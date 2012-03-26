w<cfsetting showDebugOutput="no" requestTimeout="3600" />
<cfset log = StructNew() />
<cfset log.date = Now() />

<cftry>
	<cfinvoke method="deleteFeed" component="feed.public" />
	<cfset log.text = "RSS data was successfully deleted on " & DateFormat(Now(), "medium") & " at " & TimeFormat(Now(), "medium") />
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