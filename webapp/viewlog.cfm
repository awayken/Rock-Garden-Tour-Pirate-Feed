<cfset logfile = "WEB-INF/bluedragon/work/cflog/rockgardentour.log">
<cffile action="read" file="#expandPath( logfile )#" variable="local.logoutput">
<pre><cfoutput>#local.logoutput#</cfoutput></pre>