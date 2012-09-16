<cfsetting showDebugOutput="no" requestTimeout="3600" />
<cfset log = StructNew() />
<cfset log.date = Now() />

<cftry>
	<cfschedule action="update" task="RockGardenTour_CreateFeed" interval="once" requestTimeOut="3600" operation="HTTPRequest" startdate="#dateFormat( dateAdd( 'd', 7, now() ), 'mm/dd/yyyy' )#" starttime="12:00 am" url="http://#cgi.http_host##cgi.script_name#">

	<cfinvoke method="createFeed" component="feed.public" />

	<cfset log.text = "RSS data was successfully created on " & DateFormat(Now(), "medium") & " at " & TimeFormat(Now(), "medium") />
	<cfset log.status = true />
	
	<cflog file="rockgardentour" text="#log.text#">
	<cflocation url="index.cfm?logstatus=#log.status#" addtoken="no" />

	<cfcatch>
		<cfdump var="#cfcatch#">
		<cfset log.text = cfcatch.message />
		<cfset log.status = false />
		<cflog file="rockgardentour" text="#log.text#">
	</cfcatch>
</cftry>