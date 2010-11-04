<cfcomponent displayname="Rock Garden Tour" output="false">

	<cfset this.rssurl = "rockgardentour.xml" />
	<cfset this.source = "http://sdpb.org/radio/showarchive.aspx?progname=rockgardentour" />
	<cfset this.today = Now() />
	
	<cffunction name="displayFeed" output="true">
		
		<cfset var local = StructNew() />
		<cfquery dbtype="google" name="local.feedmeta">
			select from FeedMeta
			order by pubdate DESC
			from 1, to 1
		</cfquery>
		
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
		<cfquery dbtype="google" name="local.feeditems">
			select from FeedItem
			where feedmetakey == #googleKey(local.feedmeta[1])#
			order by pubdate DESC
		</cfquery>
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

	<cffunction name="createFeed" output="false">
		
		<cfscript>
			writeFeedItems(scrapeSource(this.source), writeFeedMeta());
		</cfscript>
		
	</cffunction>
	
	<cffunction name="scrapeSource" output="false" returntype="array">
		<cfargument name="source" required="yes" />
	
		<cfset var local = StructNew() />
		<cfset var tools = createObject("component", "tools") />
		<cfset local.destinations = ArrayNew(1) />
		
		<cfset local.source = getUrl(arguments.source) />
		<cfset local.source_links = tools.REMatch("https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?", local.source) />
		<cfloop array="#local.source_links#" index="local.a">
			<cfif Find("shows.aspx", local.a)>
				<cfset local.a = Replace(local.a, """", "", "all") />
				
				<cfset local.destination = getUrl(local.a)>
				<cfset local.destination_link = tools.REMatch("file=http://www.sdpb.org/media/Rock Garden Tour/(.+).mp3", local.destination) />
				<cfif ArrayLen(local.destination_link) EQ 1>
					<cfset local.destination_link = local.destination_link[1] />
					<cfset local.destination_link = Trim(Right(local.destination_link, Len(local.destination_link) - 5)) />
					<cfset ArrayAppend(local.destinations, local.destination_link) />
				</cfif>
			</cfif>
		</cfloop>
	
		<cfreturn local.destinations />
	</cffunction>
	
	<cffunction name="writeFeedMeta" output="false" returntype="string">
		
		<cfset var meta = StructNew() />
		
		<cfset meta.title = "Rock Garden Tour (Pirate Feed)" />
		<cfset meta.link = "http://" & cgi.http_host & Replace(cgi.script_name, "index.cfm", "") & this.rssurl />
		<cfset meta.description = "A pirate feed of the full length episodes from the Rock Garden Tour radio show." />
		<cfset meta.pubdate = this.today />
		
		<cfreturn googleWrite(meta, "FeedMeta")>
	</cffunction>
	
	<cffunction name="writeFeedItems" output="false" returntype="string">
		<cfargument name="episodes" required="yes" />
		<cfargument name="metakey" required="no" default="" />
		
		<cfset var local = StructNew() />
		<cfset var item = StructNew() />
		
		<cfset local.i = 1>
		<cfloop array="#arguments.episodes#" index="local.episode">
			<cfscript>
				item = StructNew();
				item.title = ListLast(local.episode, "/"); //Get actual episode title
				item.link = Replace(local.episode, " ", "%20", "all");
				item.pubdate = DateAdd("ww", -(local.i), this.today); //Get actual published dates
				item.description = "Listen the full episode at " & local.episode; //Get actual published description
	  			item.enclosure = Replace(local.episode, " ", "%20", "all");
	  			item.enclosuretype = "audio/mp3";
				item.feedmetakey = arguments.metakey;
	  			
				googleWrite(item, "FeedItem");
				
				local.i = local.i + 1;
			</cfscript>
		</cfloop>
	</cffunction>
	
	<cffunction name="getUrl" output="false" returntype="string">
		<cfargument name="url" required="yes" />

		<cfhttp method="get" resolveURL="yes" url="#arguments.url#">
			<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0">
			<cfhttpparam type="Header" name="TE" value="deflate;q=0">
		</cfhttp>
		
		<cfreturn cfhttp.filecontent />
	</cffunction>

</cfcomponent>