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
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
		<script src="/_scripts/scripts.js"></script>
		<link rel="alternate" type="application/rss+xml" href="/rockgardentour.rss" title="Rock Garden Tour (Pirate Feed)" />
	</head>
	<body>
		<header>
			<h1><a href="/">Rock Garden Tour (Pirate Feed)</a></h1>
			<p>This is what happens when a dude majors in computer science in college.</p>
			<p>(And gets sick of nine-minute Rock Garden Tour podcast episodes.)</h2>
		</header>
		
		<section id="download">
			<div class="rss">Subscribe to the <a href="/rockgardentour.rss" type="application/rss+xml">rss feed</a>.</div>
		</section>
		
		<section id="items">
		<cfinvoke method="getFeedMeta" component="feed.public" returnvariable="local.feedmeta" />
		<cfinvoke method="getFeedItems" component="feed.public" feedmetakey="#googleKey(local.feedmeta[1])#" returnvariable="local.feeditems" />
		<cfloop array="#local.feeditems#" index="local.i">
			<cfoutput>
			<div class="item">
				<h4><a href="#local.i.link#">#local.i.title#</a></h4>
				<p class="description">#local.i.description#</p>
				<p class="meta">
					Added on #DateFormat(local.i.pubDate, "medium")# at #TimeFormat(local.i.pubDate, "medium")#<br />
					<a href="#local.i.link#">#local.i.link#</a> (#local.i.enclosuretype#)
				</p>
			</div>
			</cfoutput>
		</cfloop>
		</section>
	</body>
</html>