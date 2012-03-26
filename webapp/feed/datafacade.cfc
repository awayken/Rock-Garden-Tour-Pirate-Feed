<cfcomponent displayname="Data Facade" hint="Contains the data methods." output="false">

	<cfset this.source = "http://www.sdpb.org/newsite/showarchive.aspx?progname=rockgardentour" />
	<cfset this.title = "Rock Garden Tour (Pirate Feed)" />
	<cfset this.link = "http://" & cgi.http_host & Replace(cgi.script_name, "index.cfm", "") & "rockgardentour.rss" />
	<cfset this.description = "A pirate feed of the full length episodes from the Rock Garden Tour radio show." />
	<cfset this.pubdate = Now() />

	<cffunction name="getFeedItems" access="public" output="false" returntype="query"
				hint="Gets the feed items with optional meta key from the FeedItem database.">
		<cfargument name="idhash" required="no" default="">
		
		<cfset var feeditems = QueryNew("idhash, title, link, pubdate, description, enclosure, enclosuretype")>
		
		<cftry>
			<cfquery datasource="rockgardentour" name="feeditems">
				SELECT idhash, title, link, pubdate, description, enclosure, enclosuretype
				FROM FeedItem
			<cfif Len(arguments.idhash)>
				WHERE idhash = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.idhash#">
			</cfif>
				ORDER BY pubdate DESC
			</cfquery>
			
			<cfcatch type="database">
				<cfquery dataSource="rockgardentour">
					CREATE TABLE FeedItem (
						idhash varchar(256),
						title varchar(200),
						link varchar(400),
						pubdate date,
						description varchar(4000),
						enclosure varchar(400),
						enclosuretype varchar(25)
					)
				</cfquery>
			</cfcatch>
		</cftry>
		
		<cfreturn feeditems />
	</cffunction>
	
	<cffunction name="writeFeedItems" access="private" output="true" returntype="string"
				hint="Writes the feed items to the FeedItem database.">
		<cfargument name="episodes" required="yes">
		
		<cfset var local = StructNew()>

		<cfloop array="#arguments.episodes#" index="local.episode">
			<cfset local.itemlookup = getFeedItems(hash(local.episode.link)) />
			<cfif Not local.itemlookup.RecordCount>
				<cfparam name="local.episode.title" default="">
				<cfparam name="local.episode.description" default="">
				
				<cfquery dataSource="rockgardentour">
					INSERT INTO FeedItem (idhash, title, link, pubdate, description, enclosure, enclosuretype)
					VALUES (
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#hash(local.episode.link)#">, /* A hash of the MP3 link for later lookup */
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#local.episode.title#">, /* Get actual episode title */
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#Replace(local.episode.link, " ", "%20", "all")#">, /* Get episode link */
						<cfqueryparam CFSQLType="CF_SQL_DATE" value="#local.episode.pubdate#">, /* Get actual published dates */
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#local.episode.description#">, /* Get actual published description */
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#Replace(local.episode.link, " ", "%20", "all")#">, /* Also episode link */
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="audio/mp3"> /* Hard-coded for now */
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="deleteFeed" access="public" output="false"
				hint="Clears the database for feed items.">
		
		<cfquery dataSource="rockgardentour">
			TRUNCATE TABLE FeedItem;
		</cfquery>
		
	</cffunction>
	
	
	
	
<!--- Helpers --->
	<cffunction name="getUrl" access="private" output="false" returntype="string"
				hint="Helper method to digest URLs using cfhttp.">
		<cfargument name="url" required="yes">

		<cfhttp method="get" resolveURL="yes" url="#arguments.url#">
			<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0">
			<cfhttpparam type="Header" name="TE" value="deflate;q=0">
		</cfhttp>
		
		<cfreturn cfhttp.filecontent>
	</cffunction>

</cfcomponent>