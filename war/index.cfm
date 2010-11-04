<cfsetting showDebugOutput="no" requestTimeout="3600" />

<cfset public = createObject("component", "public") />
<cfset tools = createObject("component", "tools") />

<cfif IsDefined("URL.createFeed")>
	<cfset local.logtext = "" />
	
	<cftry>
		<cfinvoke method="createFeed" component="public" />
		<cfset local.logtext = "New RSS data was successfully created on " & DateFormat(Now(), "medium") & " at " & TimeFormat(Now(), "medium") />
		
		<cfcatch>
			<cfset local.logtext = cfcatch.message />
		</cfcatch>
	</cftry>
	
	<cflog file="RockGardenTour" text="#local.logtext#" />
	
	<cflocation url="/rockgardentour.xml" addtoken="no" />
<cfelse>
	<p>Welcome to the Rock Garden Tour (Pirate Feed).</p>
</cfif>