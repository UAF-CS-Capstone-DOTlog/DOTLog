<cfset pageTitle = "DOTLog Reporting"> <!--- Variable that is used in the html included header --->
<cfinclude template="../includes/header.cfm">
<cfinclude template="../includes/banner.cfm">
<cfinclude template="../includes/breadcrumb.cfm">
<cfinclude template="../includes/nav.cfm">
    <div id="content">
	<cfscript>
		writeDump(FORM);
	</cfscript>
		
    	<cfinclude template="./generatePDF.cfm">

<cfmail from="tests@dotlog.gov" to="bucky@uafcsc.com" subject="Its late">
	<cfmailparam disposition="attachment" file="test.pdf" type="application/pdf" content="#pdfData#" >

    NO BODY
</cfmail>