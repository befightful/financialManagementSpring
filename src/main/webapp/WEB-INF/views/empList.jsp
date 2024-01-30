<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="com.nexacro.java.xapi.data.*" %>
<%@ page import="com.nexacro.java.xapi.tx.*" %>

<%@ page contentType="text/xml; charset=utf-8" %>

<%
/****** Service API initialization ******/
PlatformData pdata = new PlatformData();

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
    String SQL = "select a.empCd, a.empNm, a.empZipCd, b.value empZipNm "+
    "from empBasics_T a, (select code, value from comCd_t where div='zip') b "+
    "where a.empZipCd = b.code";
    rs = stmt.executeQuery(SQL);

    /********* Dataset Create ************/
    DataSet ds = new DataSet("dsEmpList");
    ds.addColumn("empCd",DataTypes.STRING, 4);
    ds.addColumn("empNm",DataTypes.STRING, 20);
    ds.addColumn("empZipCd", DataTypes.STRING, 5);
    ds.addColumn("empZIpNm", DataTypes.STRING, 50);
    int row = 0;
    while(rs.next())
    {
        row = ds.newRow();
        ds.set(row, "empCd", rs.getString("empCd"));    
        ds.set(row, "empNm", rs.getString("empNm"));
        ds.set(row, "empZipCd", rs.getString("empZipCd"));
        ds.set(row, "empZIpNm", rs.getString("empZIpNm"));
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