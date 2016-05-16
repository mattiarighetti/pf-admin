  <master>
    <property name="doc(title)">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
      <table> 
	<tr> 	 
	  <td class="list-filter-pane" width="240px" valign="top">
	    <form action="@base_url@">	 
	      <table>
		<tr class="ricerca">
		  <td colspan="2" class="list-filter-header">Ricerca</td>
		</tr>
		<tr>
		  <td>
		    <input class="input" type="text" value="@q;noquote@" name="q" id="ricerca" style="width:235px" />
		  </td>
		</tr>
		<tr>
		  <td>
		    <center>
		      <input class="bot" type="submit" value="Cerca" />
			<input class="bot" type="button" value="Reset" onClick="location.href='partecipati-list';" />
		    </center>
		  </td>	
		</tr>	
		<tr>	
		  <listfilters name="iscritti"></listfilters>
		  <td class="list-list-pane" valign="top">
		    <h3>Edizione:</h3>@edizione@
		    <listtemplate name="iscritti"></listtemplate>
		  </td>
		</tr>
	      </table>
	    </form>
	  </td>
	</tr>
      </table>
    </body>
