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
String startDate	= nullToString(request.getParameter("startDate"), "");
String endDate		= nullToString(request.getParameter("endDate"), "");

String uid		= (String) session.getAttribute("uid");
String token	= (String) session.getAttribute("token");

if (beEmpty(uid) || beEmpty(token)){
	obj.put("resultCode", gcResultCodeNoLoginInfoFound);
	obj.put("resultText", gcResultTextNoLoginInfoFound);
	out.print(obj);
	out.flush();
	return;
}

if (beEmpty(startDate)) startDate = getYesterday(gcDateFormatdashYMD);
if (beEmpty(endDate)) endDate = getDateTimeNow(gcDateFormatdashYMD);
startDate = java.net.URLEncoder.encode(startDate + "T00:00:00+08:00");
endDate = java.net.URLEncoder.encode(endDate + "T23:59:59+08:00");

int	i = 0;
java.lang.Boolean	bOK = false;
String				sResultCode	= gcResultCodeSuccess;
String				sResultText	= gcResultTextSuccess;

String				sciApiUrl	= "";
String				sData		= "";
String				sResponse	= "";
String				ss	= "";

sciApiUrl = gcSCIServerURL + "api/reports/3/sections/10/data?access_token=";
sciApiUrl += token;
sData = "start=" + startDate;
sData += "&end=" + endDate;
writeLog("error", "sciApiUrl= " + sciApiUrl);
writeLog("error", "sData= " + sData);
	try
	{
		HttpsURLConnection.setDefaultHostnameVerifier(this.new NullHostNameVerifier());
		SSLContext sc = SSLContext.getInstance("TLS");
		sc.init(null, trustAllCerts, new SecureRandom());
		HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
		URL u;
		u = new URL(sciApiUrl);
		HttpURLConnection uc = (HttpURLConnection)u.openConnection();
		//uc.setRequestProperty ("Content-Type", "application/json");
		uc.setRequestProperty("contentType", "utf-8");
		uc.setRequestMethod("POST");
		uc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); 
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
		writeLog("info", "sResponse= " + sResponse);
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