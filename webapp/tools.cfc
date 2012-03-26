<cfcomponent displayname="Tools" hint="Contains some tools to augment some missing functionality in OpenBD" output="false">
	
<!--- UDFs by Miles Rausch --->





<!--- UDFs by Steven Levithan --->
<!--- http://blog.stevenlevithan.com/archives/rematch-coldfusion --->
<cffunction name="reMatch_" output="false" returntype="array">
	<cfargument name="regex" type="string" required="yes" />
	<cfargument name="string" type="string" required="yes" />
	<cfargument name="start" type="numeric" required="no" default="1" />
	<cfargument name="scope" type="string" required="no" default="ALL" />
	<cfargument name="returnLenPos" type="boolean" required="no" default="FALSE" />
	<cfargument name="caseSensitive" type="boolean" required="no" default="TRUE" />
	
	<cfset var thisMatch = "" />
	<cfset var matchInfo = structNew() />
	<cfset var matches = arrayNew(1) />
	<!--- Set the time before entering the loop --->
	<cfset var timeout = now() />
	
	<!--- Build the matches array. Continue looping until additional instances of regex are not found.
	If scope is "ONE", the loop will end after the first iteration --->
	<cfloop condition="TRUE">
		<!--- By using returnSubExpressions (the fourth reFind argument), the position and length of the
		first match is captured in arrays named len and pos --->
		<cfif caseSensitive>
			<cfset thisMatch = reFind(regex, string, start, TRUE) />
		<cfelse>
			<cfset thisMatch = reFindNoCase(regex, string, start, TRUE) />
		</cfif>
		
		<!--- If a match was not found, end the loop --->
		<cfif thisMatch.pos[1] EQ 0>
			<cfbreak />
		<!--- If a match was found, and extended info was requested, append a struct containing the value,
		length, and position of the match to the matches array --->
		<cfelseif returnLenPos>
			<cfset matchInfo.value = mid(string, thisMatch.pos[1], thisMatch.len[1]) />
			<cfset matchInfo.len = thisMatch.len[1] />
			<cfset matchInfo.pos = thisMatch.pos[1] />
			<cfset arrayAppend(matches, duplicate(matchInfo)) />
		<!--- Otherwise, just append the match value to the matches array --->
		<cfelse>
			<cfset arrayAppend(matches, mid(string, thisMatch.pos[1], thisMatch.len[1])) />
		</cfif>
		
		<!--- If only the first match was requested, end the loop --->
		<cfif scope EQ "ONE">
			<cfbreak />
		<!--- If the match length was greater than zero --->
		<cfelseif thisMatch.pos[1] + thisMatch.len[1] GT start>
			<!--- Set the start position for the next iteration of the loop to the end position of the match --->
			<cfset start = thisMatch.pos[1] + thisMatch.len[1] />
		<!--- If the match was zero length --->
		<cfelse>
			<!--- Advance the start position for the next iteration of the loop by one, to avoid infinite iteration --->
			<cfset start = start + 1 />
		</cfif>
		
		<!--- If the loop has run for 20 seconds, throw an error, to mitigate against overlong processing.
		However, note that even one pass using a poorly-written regex which triggers catastrophic backtracking
		could take longer than 20 seconds --->
		<cfif dateDiff("s", timeout, now()) GTE 20>
			<cfthrow message="Processing too long. Optimize regular expression for better performance" />
		</cfif>
	</cfloop>
	
	<cfreturn matches />
</cffunction>

<!--- Case-insensitive version of reMatch() --->
<cffunction name="reMatchNoCase" output="false">
	<cfargument name="regex" type="string" required="yes" />
	<cfargument name="string" type="string" required="yes" />
	<cfargument name="start" type="numeric" required="no" default="1" />
	<cfargument name="scope" type="string" required="no" default="ONE" />
	<cfargument name="returnLenPos" type="boolean" required="no" default="FALSE" />
	<cfreturn reMatch(regex, string, start, scope, returnLenPos, FALSE) />
</cffunction>

<!--- Non-regex version of reMatch() --->
<cffunction name="match" output="false">
	<cfargument name="substring" type="string" required="yes" />
	<cfargument name="string" type="string" required="yes" />
	<cfargument name="start" type="numeric" required="no" default="1" />
	<cfargument name="scope" type="string" required="no" default="ONE" />
	<cfargument name="returnLenPos" type="boolean" required="no" default="FALSE" />
	<cfreturn reMatch(reEscape(substring), string, start, scope, returnLenPos, TRUE) />
</cffunction>

<!--- Case-insensitive version of match() --->
<cffunction name="matchNoCase" output="false">
	<cfargument name="substring" type="string" required="yes" />
	<cfargument name="string" type="string" required="yes" />
	<cfargument name="start" type="numeric" required="no" default="1" />
	<cfargument name="scope" type="string" required="no" default="ONE" />
	<cfargument name="returnLenPos" type="boolean" required="no" default="FALSE" />
	<cfreturn reMatch(reEscape(substring), string, start, scope, returnLenPos, FALSE) />
</cffunction>

<!--- Escape special regular expression characters (.,*,+,?,^,$,{,},(,),|,[,],\) within a string by preceding
them with a forward slash (\). This allows safely using literal strings within regular expressions --->
<cffunction name="reEscape" returntype="string" output="false">
	<cfargument name="string" type="string" required="yes" />
	<cfreturn reReplace(string, "[.*+?^${}()|[\]\\]", "\\\0", "ALL") />
</cffunction>

</cfcomponent>