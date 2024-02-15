<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="com.nexacro.java.xapi.data.*" %>
<%@ page import="com.nexacro.java.xapi.tx.*" %>

<%@ page contentType="text/xml; charset=utf-8" %>

<%
/****** Service API initialization ******/
PlatformData pdata = new PlatformData();

String search = request.getParameter("search");
String type = request.getParameter("type");
int nErrorCode = 0;
String strErrorMsg = "START";

/******* JDBC Connection *******/
Connection conn = null;
Statement  stmt = null;
ResultSet  rs   = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","java","1234");
stmt = conn.createStatement();

try {
    /******* SQL query *************/
    String SQL = "select a.productID, a.pName, a.mName, a.sName, a.unit, a.upUnit, b.Price, a.pDescription "+
    "from PRODUCT a, (select PRODUCTID, Price from UNITPRICEHISTORY where sdate = (select max(sdate) from UNITPRICEHISTORY group by PRODUCTID)) b "+
    "where a.PRODUCTID = b.PRODUCTID(+) ";
    if(type.equals("pName")){
    	SQL += "and a.pName like '%"+ search + "%'";
    }else{
    	SQL += "and a.productID like '%"+ search + "%'";
    }
    
    
    System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1"+type);
    rs = stmt.executeQuery(SQL);

    /********* Dataset Create ************/
    DataSet ds = new DataSet("pdds");
    ds.addColumn("productID",DataTypes.STRING, 10);
    ds.addColumn("pName",DataTypes.STRING, 255);
    ds.addColumn("mName", DataTypes.STRING, 100);
    ds.addColumn("sName", DataTypes.STRING, 100);
    ds.addColumn("unit", DataTypes.STRING, 10);
    ds.addColumn("upUnit",DataTypes.INT, 256);
    ds.addColumn("pDescription", DataTypes.STRING, 255);
    int row = 0;
    while(rs.next())
    {
        row = ds.newRow();
        ds.set(row, "productID", rs.getString("productID"));    
        ds.set(row, "pName", rs.getString("pName"));
        ds.set(row, "mName", rs.getString("mName"));
        ds.set(row, "sName", rs.getString("sName"));
        ds.set(row, "unit", rs.getString("unit"));    
        ds.set(row, "upUnit", rs.getString("upUnit"));
        ds.set(row, "pDescription", rs.getString("pDescription"));
    }

    /********* Adding Dataset to PlatformData ************/
    pdata.addDataSet(ds);

    nErrorCode = 0;
    strErrorMsg = "SUCC";
}
catch(SQLException e) {
    nErrorCode = -1;
    strErrorMsg = e.getMessage();
}

/******** JDBC Close *******/
if ( stmt != null ) try { stmt.close(); } catch (Exception e) {}
if ( conn != null ) try { conn.close(); } catch (Exception e) {}

PlatformData senddata = new PlatformData();
VariableList varList = senddata.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg", strErrorMsg);

/******** XML data Create ******/
HttpPlatformResponse res = new HttpPlatformResponse(response, 
    PlatformType.CONTENT_TYPE_XML,"UTF-8");
res.setData(pdata);
res.sendData();
%>