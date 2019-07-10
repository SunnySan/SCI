<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@page import="java.net.InetAddress" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="org.json.simple.parser.JSONParser" %>
<%@page import="org.json.simple.parser.ParseException" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.apache.commons.io.IOUtils" %>
<%@page import="java.util.*" %>

<%@include file="00_constants.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

JSONObject	obj=new JSONObject();

/*********************開始做事吧*********************/

String uid	= request.getParameter("uid");
String upassword	= request.getParameter("upassword");

if (uid==null || uid.length()<1 || upassword==null || upassword.length()<1){
	obj.put("resultCode", gcResultCodeParametersNotEnough);
	obj.put("resultText", gcResultTextParametersNotEnough);
	out.print(obj);
	out.flush();
	return;
}

int	i = 0;

for (i=0;i<gcUsers.length;i++){
	if (uid.equals(gcUsers[i][0]) && upassword.equals(gcUsers[i][1])){
		session.setAttribute("uid", uid);	//將登入用戶資料存入 session 中
		obj.put("resultCode", gcResultCodeSuccess);
		obj.put("resultText", gcResultTextSuccess);
		out.print(obj);
		out.flush();
		return;
	}
}

obj.put("resultCode", gcResultCodeParametersValidationError);
obj.put("resultText", gcResultTextParametersValidationError);
out.print(obj);
out.flush();
%>