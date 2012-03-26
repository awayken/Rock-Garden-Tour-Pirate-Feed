<cfsetting showDebugOutput="no" />
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>Rock Garden Tour (Pirate Feed)</title>
		<meta name="robots" content="noindex, nofollow" />
		<link rel="stylesheet" href="/_styles/styles.css" media="screen" />
		<!--[if lt IE 9]>
		<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
		<script src="/_scripts/scripts.js"></script>
		<link rel="alternate" type="application/rss+xml" href="/rockgardentour.rss" title="Rock Garden Tour (Pirate Feed)" />
	</head>
	<body>
		<header>
			<h1><a href="/">Rock Garden Tour (Pirate Feed)</a></h1>
			<p>This is what happens when a dude majors in computer science in college.</p>
			<p>(And gets sick of nine-minute Rock Garden Tour podcast episodes.)</h2>
		</header>
		
	<cfif isDefined("URL.logstatus")>
		<section id="messages">
		<cfif URL.logstatus eq "true">
			<div class="message success">Feed successfully updated.</div>
		<cfelse>
			<div class="message failure">There was a problem updating the feed. See the log for more details.</div>
		</cfif>
		</section>
	</cfif>
		
		<section id="download">
			<div class="rss">Subscribe to the <a href="/rockgardentour.rss" type="application/rss+xml">rss feed</a>.</div>
		</section>
		
		<section id="items">
		<cfset feed = createObject("component", "feed.public")>
		<cfset feeditems = feed.getFeedItems()>
		<cfif feeditems.RecordCount>
			<cfoutput query="feeditems">
				<div class="item">
					<h4><a href="#feeditems.link#">#feeditems.title#</a></h4>
					<p class="description">#feeditems.description#</p>
					<p class="meta">
						Added on #DateFormat(feeditems.pubDate, "medium")#<br />
						<a href="#feeditems.link#">#feeditems.link#</a> (#feeditems.enclosuretype#)
					</p>
				</div>
			</cfoutput>
		</cfif>
		</section>
	</body>
</html>