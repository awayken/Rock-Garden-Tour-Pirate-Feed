<cfcomponent displayname="Data Facade" hint="Contains the data methods." output="false">

	<cffunction name="getFeedItems" access="public" output="false" returntype="array"
				hint="Gets the feed items with optional meta key from the FeedItem datastore.">
		<cfargument name="idhash" required="no" default="" />
		
		<cfset var feeditems = StructNew() />
		<cfquery dbtype="google" name="feeditems">
			SELECT FROM FeedItem
		<cfif Len(arguments.idhash)>
			WHERE idhash == '#arguments.idhash#'
		</cfif>
			ORDER BY pubdate DESC
		</cfquery>
		
		<cfreturn feeditems />
	</cffunction>
	
	
	
	
<!--- Helpers --->
	<cffunction name="getUrl" access="private" output="false" returntype="string"
				hint="Helper method to digest URLs using cfhttp.">
		<cfargument name="url" required="yes" />

		<cfhttp method="get" resolveURL="yes" url="#arguments.url#">
			<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0">
			<cfhttpparam type="Header" name="TE" value="deflate;q=0">
		</cfhttp>
		
		<cfreturn cfhttp.filecontent />
	</cffunction>

</cfcomponent>