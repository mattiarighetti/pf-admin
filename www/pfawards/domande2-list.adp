  <master>
    <property name="doc(title)">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
    <h1>@page_title@</h1>
    <hr />
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
		    <input class="input" type="text" value="@q;noquote@" name="q" id="ricerca" placeholder="Testo domanda, codice domanda..." style="width:235px" />
		  </td>
		</tr>
		<tr>
		  <td>
		    <center>
		      <input class="bot" type="submit" value="Cerca" />
			<input class="bot" type="button" value="Reset" onClick="location.href='domande2-list';" />
		    </center>
		  </td>	
		</tr>	
		<tr>	
		  <listfilters name="domande"></listfilters>
		  <td class="list-list-pane" valign="top">
		    <listtemplate name="domande"></listtemplate>
		  </td>
		</tr>
	      </table>
	    </form>
	  </td>
	</tr>
      </table>
    </body>
