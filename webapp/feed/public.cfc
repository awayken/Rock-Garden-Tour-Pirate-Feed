<cfcomponent displayname="Feed" output="false" extends="datafacade">
	
	<cffunction name="displayFeed" access="public" output="true"
				hint="Gets the data currently in the database in FeedMeta and FeedItem, and it displays them as an RSS feed.">
		
		<cfset var local = StructNew()>
		<cfset var feeditems = getFeedItems()>
		
<cfoutput><?xml version="1.0"?>
<rss version="2.0">
	<channel>
		<title>#Trim(this.title)#</title>
		<link>#this.link#</link>
		<description><![CDATA[#this.description#]]></description>
		<language>en-us</language>
		<lastBuildDate>#DateFormat(this.pubDate, "long")# #TimeFormat(this.pubDate, "long")#</lastBuildDate>
		<generator>Open Bluedragon on Google AppEngine</generator>
		<ttl>1440</ttl>
	<cfloop query="feeditems">
		<item>
			<title>#Trim(feeditems.title)#</title>
			<description><![CDATA[#feeditems.description#]]></description>
			<pubDate>#DateFormat(feeditems.pubDate, "long")# #TimeFormat(feeditems.pubDate, "long")#</pubDate>
			<guid>#feeditems.link#</guid>
			<link>#feeditems.link#</link>
			<enclosure url="#feeditems.enclosure#" type="#feeditems.enclosuretype#" />
		</item>
	</cfloop>
	</channel>
</rss></cfoutput>
	</cffunction>




	<cffunction name="createFeed" access="public" output="false"
				hint="Writes the items for the feed to the database.">
		
		<cfscript>
			writeFeedItems(scrapeSource(this.source));
		</cfscript>
		
	</cffunction>
	
	<cffunction name="scrapeSource" access="private" output="yes" returntype="array"
				hint="Scrapes our source page for RSS content. Very source-specific.">
		<cfargument name="source" required="yes" />
	
		<cfset var local = StructNew() />
<!--- 		<cfset var tools = createObject("component", "tools") /> --->
		<cfset local.output = ArrayNew(1) />
		
		<cfset local.source = getUrl(arguments.source) />
		<cfset local.source_links = REMatch("https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?", local.source) />
		<cfloop array="#local.source_links#" index="local.a">
			<cfif Find("shows.aspx", local.a)>
				<cfset local.a = Replace(local.a, """", "", "all") />
				<cfset local.destination = getUrl(local.a) />
				<cfset local.episode = StructNew() />
				
				<cfset local.episode.link = REMatch("file=http://www.sdpb.org/media/Rock Garden Tour/(.+).mp3", local.destination) />
				<cfif ArrayLen(local.episode.link) EQ 1>
					<!--- Get episode link --->
					<cfset local.episode.link = local.episode.link[1] />
					<cfset local.episode.link = Trim(Right(local.episode.link, Len(local.episode.link) - 5)) />
					
					<!--- Get episode details --->
					<cfset local.destination_details = REMatch('<div id="archivetext-wrapper">(.+)<strong>Pics:</strong>', local.destination) />
					<cfif ArrayLen(local.destination_details) EQ 1>
						<!---
							Unlike Adobe ColdFusion, specifying a multi-character list delimiter works
							not as a multi-character delimiter but as a list of delimiter characters.
							We're actually using this to our advantage (though it was confusing at first).
						--->
						<cfset local.destination_detail = ListToArray(local.destination_details[1], "<>") />
						
						<!--- Get episode title --->
						<cfset local.episode.title = local.destination_detail[6] />
						
						<!--- Get episode pubdate --->
						<cfset local.episode.pubdate = "#ListLast(local.destination_detail[10], "- ")#" />
						
						<!--- Get episode description --->
						<cfset local.episode.description = local.destination_detail[15] />
					</cfif>
					
					<!--- Add our new struct to our array --->
					<cfset ArrayAppend(local.output, local.episode) />
				</cfif>				
			</cfif>
		</cfloop>
	
		<cfreturn local.output />
	</cffunction>

</cfcomponent>