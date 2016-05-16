  <property name="doc(title)">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="focus">q</property>
  
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
	    <tr class="ricerca">
	      <td colspan="2" class="list-filter-header">Comune</td>
	    </tr>
	    <tr>
	      <td align="left" class="list-filter-header">
		<select name="cerca_comune_id" id="cerca_comune_id">@comune_id_options;noquote@</select>
	      </td>
	    </tr>
	    <tr>
	      <td>
		<center>
		  <input class="bot" type="submit" value="Cerca" />
		    <input class="bot" type="button" value="Reset" onClick="location.href='persone-list';" />
		</center>
	      </td>	
	    </tr>	
	    <tr>	
	      <listfilters name="persone"></listfilters>
	      <td class="list-list-pane" valign="top">
		<listtemplate name="persone"></listtemplate>
	      </td>
	    </tr>
	  </table>
	  </form>
	</td>
      </tr>
    </table>