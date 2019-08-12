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
<%@include file="00_utility.jsp"%>
<%@include file="00_trustAllCerts.jsp"%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

JSONObject	obj=new JSONObject();

/*********************開始做事吧*********************/
String reportId		= nullToString(request.getParameter("reportId"), "");
String section		= nullToString(request.getParameter("section"), "");
String startDate	= nullToString(request.getParameter("startDate"), "");
String endDate		= nullToString(request.getParameter("endDate"), "");
String filter		= nullToString(request.getParameter("filter"), "");
String metric		= nullToString(request.getParameter("metric"), "");
String granularity	= nullToString(request.getParameter("granularity"), "");
String limit		= nullToString(request.getParameter("limit"), "");
String type			= nullToString(request.getParameter("type"), "");

String uid		= (String) session.getAttribute("uid");
String token	= (String) session.getAttribute("token");

if (beEmpty(reportId) || beEmpty(section)){
	obj.put("resultCode", gcResultCodeParametersNotEnough);
	obj.put("resultText", gcResultTextParametersNotEnough);
	out.print(obj);
	out.flush();
	return;
}
if (beEmpty(uid) || beEmpty(token)){
	obj.put("resultCode", gcResultCodeNoLoginInfoFound);
	obj.put("resultText", gcResultTextNoLoginInfoFound);
	out.print(obj);
	out.flush();
	return;
}

if (beEmpty(startDate)) startDate = getYesterday(gcDateFormatdashYMD);
if (beEmpty(endDate)) endDate = getDateTimeNow(gcDateFormatdashYMD);
if (reportId.equals("apmac")){
	//startDate = startDate + "T00:00:00+08:00";
	//endDate = endDate + "T23:59:59+08:00";
}else{
	startDate = java.net.URLEncoder.encode(startDate + "T00:00:00+08:00");
	endDate = java.net.URLEncoder.encode(endDate + "T23:59:59+08:00");
}

int	i = 0;
java.lang.Boolean	bOK = false;
String				sResultCode	= gcResultCodeSuccess;
String				sResultText	= gcResultTextSuccess;

String				sciApiUrl	= "";
String				sData		= "";
String				sResponse	= "";
String				ss	= "";
if (beEmpty(type)){	//一般報表
	sciApiUrl = gcSCIServerURL + "api/reports/" + reportId + "/sections/" + section + "/data?access_token=" + token;
}else{	//搜尋系統有哪些APs(部落)，或者某一個或多個部落中有哪些AP可以讓用戶選
	sciApiUrl = gcSCIServerURL + "api/facets/" + section + "?access_token=" + token;;
}
sData = "start=" + startDate;
sData += "&end=" + endDate;
if (notEmpty(filter)){
	if (reportId.equals("system")){
		sData += "&filter=" + java.net.URLEncoder.encode(filter);
	}else if (reportId.equals("apmac")){
		sData = filter;
		sData = sData.replace("T00:00:00 08:00", "T00:00:00+08:00");
		sData = sData.replace("T23:59:59 08:00", "T23:59:59+08:00");
	}else{
		sData += "&filter=" + filter;
	}

}
if (notEmpty(metric)) sData += "&metric=" + metric;
if (notEmpty(granularity)) sData += "&granularity=" + granularity;
if (notEmpty(limit)) sData += "&limit=" + limit;

writeLog("debug", "sciApiUrl= " + sciApiUrl);
writeLog("debug", "sData= " + sData);
try{
	HttpsURLConnection.setDefaultHostnameVerifier(this.new NullHostNameVerifier());
	SSLContext sc = SSLContext.getInstance("TLS");
	sc.init(null, trustAllCerts, new SecureRandom());
	HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
	URL u;
	u = new URL(sciApiUrl);
	HttpURLConnection uc = (HttpURLConnection)u.openConnection();
	if (reportId.equals("apmac")){
		uc.setRequestProperty ("Content-Type", "application/json;charset=UTF-8");
	}else{
		//uc.setRequestProperty("contentType", "utf-8");
		uc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); 
	}
	uc.setRequestMethod("POST");
	uc.setDoOutput(true);
	uc.setDoInput(true);

	byte[] postData = sData.getBytes("UTF-8");	//避免中文亂碼問題
	OutputStream os = uc.getOutputStream();
	os.write(postData);
	os.close();

	InputStream in = uc.getInputStream();
	BufferedReader r = new BufferedReader(new InputStreamReader(in));
	StringBuffer buf = new StringBuffer();
	String line;
	while ((line = r.readLine())!=null) {
		buf.append(line);
	}
	in.close();
	sResponse = buf.toString();	//取得Line回應值
	bOK = true;
}catch (IOException e){ 
	sResponse = e.toString();
	writeLog("error", "Exception when send message to SCI: " + e.toString());
}

if (bOK){
	//if (reportId.equals("system") || reportId.equals("apmac")) writeLog("info", "sResponse= " + sResponse);
	sResultCode	= gcResultCodeSuccess;
	sResultText	= gcResultTextSuccess;
	obj.put("records", sResponse);
}else{
	writeLog("error", "Failed to get data from SCI: " + sResponse);
	sResultCode	= gcResultCodeUnknownError;
	sResultText	= (beEmpty(sResponse)?gcResultTextUnknownError:sResponse);
}


obj.put("resultCode", sResultCode);
obj.put("resultText", sResultText);
out.print(obj);
out.flush();
%>