<!-- 1. Designating a Java library -->
<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.nexacro.java.xapi.data.*" %>
<%@ page import="com.nexacro.java.xapi.tx.*" %>


<!-- 2. Defining a MIME type -->
<%@ page contentType="text/xml; charset=UTF-8" %>

<%
/** 3. Creating a basic object of Nexacro Platform **/
PlatformData pdata = new PlatformData();

/**  5.1 Processing ErrorCode and ErrorMsg **/ 
int nErrorCode = 0;
String strErrorMsg = "START";
   
/************************* JDBC Connection ***********************/
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String SQL = null;
   
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","java","1234");
stmt = conn.createStatement();	

/** 4. Receiving a request from the client **/
//create HttpPlatformRequest for receive data from client
HttpPlatformRequest req = new HttpPlatformRequest(request);
req.receiveData();
pdata = req.getData();   



DataSet ds = pdata.getDataSet("pdDs"); 


String productID = ds.getString(0, "productID");
   try {
	   /******* SQL query *************/
	  SQL = "delete from product where productID ='" + productID + "'";

	  System.out.println(SQL);	
		
      stmt.executeUpdate(SQL);
      
      /**  5.2 Setting ErrorCode and ErrorMsg for success **/
      nErrorCode = 0;
      strErrorMsg = "SUCC : row count("+ds.getRowCount()+")";
   } catch (SQLException e) {
      /**  5.3 Setting ErrorCode and ErrorMsg for failure **/
      nErrorCode = -1;
      strErrorMsg = e.getMessage();
      System.out.println("ERROR : " + strErrorMsg);      
   }
   
/******** JDBC Close *******/
if ( stmt != null ) try { stmt.close(); } catch (Exception e) {}
if ( conn != null ) try { conn.close(); } catch (Exception e) {}

   
/**  5.4 Saving ErrorCode and ErrorMsg to send them to the client **/
PlatformData senddata = new PlatformData();
VariableList varList = senddata.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg", strErrorMsg);

/**  6. Sending result data to the client **/
HttpPlatformResponse res = new HttpPlatformResponse(response,
PlatformType.CONTENT_TYPE_XML,"UTF-8");
res.setData(senddata);
res.sendData();

%>