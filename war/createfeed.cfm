<cfsetting showDebugOutput="no" requestTimeout="3600" />
<cfset local.public = createObject("component", "public") />
<cfset local.logtext = "" />

<cftry>
	<cfinvoke method="createFeed" component="local.public" />
	<cfset local.logtext = "New RSS data was successfully created on " & DateFormat(Now(), "medium") & " at " & TimeFormat(Now(), "medium") />
	
	<cfcatch>
		<cfset local.logtext = cfcatch.message />
	</cfcatch>
</cftry>

<cflog file="RockGardenTour" text="#local.logtext#" />