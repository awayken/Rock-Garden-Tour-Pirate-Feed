<cfcomponent displayname="Feed" output="false" extends="datafacade">
	
	<cfset this.source = "http://sdpb.org/radio/showarchive.aspx?progname=rockgardentour" />
	<cfset this.today = Now() />
	
	<cffunction name="displayFeed" access="public" output="true"
				hint="Gets the data currently in the datastore in FeedMeta and FeedItem, and it displays them as an RSS feed.">
		
		<cfset var local = StructNew() />
		<cfset local.feedmeta = getFeedMeta() />
		<cfset local.feeditems = getFeedItems(googleKey(local.feedmeta[1])) />
		
<cfoutput><?xml version="1.0"?>
<rss version="2.0">
	<channel>
		<title>#local.feedmeta[1].title#</title>
		<link>#local.feedmeta[1].link#</link>
		<description>#local.feedmeta[1].description#</description>
		<language>en-us</language>
		<lastBuildDate>#DateFormat(local.feedmeta[1].pubDate, "long")# #TimeFormat(local.feedmeta[1].pubDate, "long")#</lastBuildDate>
		<generator>Open Bluedragon on Google AppEngine</generator>
		<ttl>1440</ttl>
	<cfloop array="#local.feeditems#" index="local.i">
		<item>
			<title>#local.i.title#</title>
			<description>#local.i.description#</description>
			<pubDate>#DateFormat(local.i.pubDate, "long")# #TimeFormat(local.i.pubDate, "long")#</pubDate>
			<guid>#local.i.link#</guid>
			<link>#local.i.link#</link>
			<enclosure url="#local.i.enclosure#" type="#local.i.enclosuretype#" />
		</item>
	</cfloop>
	</channel>
</rss></cfoutput>
	</cffunction>




	<cffunction name="createFeed" access="public" output="false"
				hint="Writes the metadata and items for the feed to the datastores.">
		
		<cfscript>
			writeFeedItems(scrapeSource(this.source), writeFeedMeta());
		</cfscript>
		
	</cffunction>
	
	<cffunction name="scrapeSource" access="private" output="yes" returntype="array"
				hint="Scrapes our source page for RSS content. Very source-specific.">
		<cfargument name="source" required="yes" />
	
		<cfset var local = StructNew() />
		<cfset var tools = createObject("component", "tools") />
		<cfset local.output = ArrayNew(1) />
		
		<cfset local.source = getUrl(arguments.source) />
		<cfset local.source_links = tools.REMatch("https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?", local.source) />
		<cfloop array="#local.source_links#" index="local.a">
			<cfif Find("shows.aspx", local.a)>
				<cfset local.a = Replace(local.a, """", "", "all") />
				<cfset local.destination = getUrl(local.a) />
				<cfset local.episode = StructNew() />
				
				<cfset local.episode.link = tools.REMatch("file=http://www.sdpb.org/media/Rock Garden Tour/(.+).mp3", local.destination) />
				<cfif ArrayLen(local.episode.link) EQ 1>
					<!--- Get episode link --->
					<cfset local.episode.link = local.episode.link[1] />
					<cfset local.episode.link = Trim(Right(local.episode.link, Len(local.episode.link) - 5)) />
					
					<!--- Get episode details --->
					<cfset local.destination_details = tools.REMatch('<h2>Rock Garden Tour </h2>(.+)<strong>Pics:</strong>', local.destination) />
					<cfif ArrayLen(local.destination_details) EQ 1>
						<!---
							Unlike Adobe ColdFusion, specifying a multi-character list delimiter works
							not as a multi-character delimiter but as a list of delimiter characters.
							We're actually using this to our advantage (though it was confusing at first).
						--->
						<cfset local.destination_detail = ListToArray(local.destination_details[1], "<>") />
						
						<!--- Get episode title --->
						<cfset local.episode.title = local.destination_detail[4] />
						
						<!--- Get episode pubdate --->
						<cfset local.episode.pubdate = CreateODBCDate(local.destination_detail[10]) />
						
						<!--- Get episode description --->
						<cfset local.episode.description = local.destination_detail[14] />
					</cfif>
					
					<!--- Add our new struct to our array --->
					<cfset ArrayAppend(local.output, local.episode) />
				</cfif>
			</cfif>
		</cfloop>
	
		<cfreturn local.output />
	</cffunction>
	
	<cffunction name="writeFeedMeta" access="private" output="false" returntype="string"
				hint="Writes the feed metadata to the FeedMeta datastore.">
		
		<cfset var meta = StructNew() />
		
		<cfset meta.title = "Rock Garden Tour (Pirate Feed)" />
		<cfset meta.link = "http://" & cgi.http_host & Replace(cgi.script_name, "index.cfm", "") & "rockgardentour.rss" />
		<cfset meta.description = "A pirate feed of the full length episodes from the Rock Garden Tour radio show." />
		<cfset meta.pubdate = this.today />
		
		<cfreturn googleWrite(meta, "FeedMeta")>
	</cffunction>
	
	<cffunction name="writeFeedItems" access="private" output="true" returntype="string"
				hint="Writes the feed items to the FeedItem datastore.">
		<cfargument name="episodes" required="yes" />
		<cfargument name="metakey" required="no" default="" />
		
		<cfset var local = StructNew() />
		<cfset var item = StructNew() />

		<cfset local.i = 1>
		<cfloop array="#arguments.episodes#" index="local.episode">
			<cfscript>
				item = StructNew();
				item.title = local.episode.title; //Get actual episode title
				item.link = Replace(local.episode.link, " ", "%20", "all"); //Get episode link
				item.pubdate = local.episode.pubdate; //Get actual published dates
				item.description = local.episode.description; //Get actual published description
	  			item.enclosure = Replace(local.episode.link, " ", "%20", "all"); //Also episode link
	  			item.enclosuretype = "audio/mp3";
				item.feedmetakey = arguments.metakey;
	  			
				googleWrite(item, "FeedItem");
				
				local.i = local.i + 1;
			</cfscript>
		</cfloop>
	</cffunction>

</cfcomponent>