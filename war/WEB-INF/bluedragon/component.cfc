<cfcomponent>
	<cffunction name="googleWrite" access="public" returntype="string" output="false">

		<cfargument name="kind"    type="string" required="false">
		<cfargument name="keyName" type="string" required="false">

		<cfif isDefined( "arguments.kind" )>
		  <cfif not isDefined("arguments.keyName")>
			<cfreturn googleWrite( this, arguments.kind )>
		  <cfelse>
		    <cfreturn googleWrite(this, arguments.kind, arguments.keyName)>
		  </cfif>
		<cfelse>
			<cfreturn googleWrite( this )>
		</cfif>
	</cffunction>

	<cffunction name="googleDelete" access="public" returntype="void" output="false">
		<cfset googleDelete( this )>
	</cffunction>

	<cffunction name="googleKey" access="public" returntype="string" output="false">
		<cfreturn googleKey( this )>
	</cffunction>
</cfcomponent>
