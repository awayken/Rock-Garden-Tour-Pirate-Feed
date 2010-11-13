<cfcomponent displayname="Data Facade" hint="Contains the data methods." output="false">

	<cffunction name="getFeedMeta" access="public" output="false" returntype="array"
				hint="Gets the most recent feed metadata from the FeedMeta datastore.">
		<cfargument name="last" required="no" default="1" />
		
		<cfset var local = StructNew() />
		<cfquery dbtype="google" name="local.feedmeta">
			select from FeedMeta
			order by pubdate DESC
			from 1, to #arguments.last#
		</cfquery>
		
		<cfreturn local.feedmeta />
	</cffunction>

	<cffunction name="getFeedItems" access="public" output="false" returntype="array"
				hint="Gets the feed items with optional meta key from the FeedItem datastore.">
		<cfargument name="feedmetakey" required="no" default="" />
		
		<cfset var local = StructNew() />
		<cfquery dbtype="google" name="local.feeditems">
			select from FeedItem
		<cfif Len(arguments.feedmetakey)>
			where feedmetakey == #arguments.feedmetakey#
		</cfif>
			order by pubdate DESC
		</cfquery>
		
		<cfreturn local.feeditems />
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