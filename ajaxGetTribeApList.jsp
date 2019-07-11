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

<%
/***************輸入範例********************************************************
所有資料
http://127.0.0.1:8080/CHT/ajaxGetPaymentOrderList.jsp

單一資料
http://127.0.0.1:8080/CHT/ajaxGetPaymentOrderList.jsp?Payment_Order_ID=TX15011901DA55595D5898AD
*******************************************************************************/

/***************輸出範例********************************************************
*******************************************************************************/
%>

<%
request.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");
response.setHeader("Pragma","no-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 

out.clear();	//注意，一定要有out.clear();，要不然client端無法解析XML，會認為XML格式有問題

JSONObject	obj=new JSONObject();

/*********************開始做事吧*********************/

Hashtable	ht					= new Hashtable();
String		sResultCode			= gcResultCodeSuccess;
String		sResultText			= gcResultTextSuccess;
String		s[][]				= null;
String		sSQL				= "";
List<String> sSQLList			= new ArrayList<String>();
String		sDate				= getDateTimeNow(gcDateFormatSlashYMDTime);
String		sUser				= "System";
String		ss					= "";

String		sResponse			= "";
String		sCity			= "";

List  lPoints = new LinkedList();
Map m1 = null;
Map m2 = null;
List  lCities = new LinkedList();

sSQL = "SELECT tribe, ap, mac";
sSQL += " FROM sci_tribe";
sSQL += " ORDER BY tribe";

ht = getDBData(sSQL, gcDataSourceNameCMSIOT);

sResultCode = ht.get("ResultCode").toString();
sResultText = ht.get("ResultText").toString();

if (sResultCode.equals(gcResultCodeSuccess)){	//有資料
	s = (String[][])ht.get("Data");
	String	sHead[]		= null;
	sHead = new String[]{"tribe", "ap", "mac"};

	lPoints = new LinkedList();
	lCities = new LinkedList();
	m1 = null;
	m2 = new HashMap();
	
	for (int i=0;i<s.length;i++){	//每個i代表一個 row
		if (!sCity.equals(s[i][0]) && i>0){	//不同縣市, i==0是第一筆資料，不需處理
			m2.put("tribe", sCity);
			m2.put("aps", lPoints);
			lCities.add(m2);
			sCity=s[i][0];
			lPoints = new LinkedList();
			m2 = new HashMap();
		}
		sCity=s[i][0];
		m1 = new HashMap();
		for (int j=0;j<sHead.length;j++){	//取出每個row中的橫向儲存格(j是column、i是row)
			m1.put(sHead[j], nullToString(s[i][j], ""));
		}
		lPoints.add(m1);
	}
	m2.put("tribe", sCity);
	m2.put("aps", lPoints);
	lCities.add(m2);
	obj.put("tribes", lCities);

}else{
	out.print(sResultText);
	out.flush();
	return;
}


out.print(obj);
out.flush();
%>
