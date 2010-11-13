<cfsetting showDebugOutput="no" requestTimeout="3600" />
<cfset local.feed = createObject("component", "feed.public") />
<cfset local.logtext = "" />

<cftry>
	<cfinvoke method="createFeed" component="#local.feed#" />
	<cfset local.logtext = "New RSS data was successfully created on " & DateFormat(Now(), "medium") & " at " & TimeFormat(Now(), "medium") />

	<cfcatch>
		<cfset local.logtext = cfcatch.message />
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>

<cflog file="RockGardenTour" text="#local.logtext#" />