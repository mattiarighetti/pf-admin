<master>
  <property name="page_title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>  
  
  <h1>@page_title;noquote@</h1>  
  <hr />
  <table width="100%"> 
    <tr>
      <td class="list-filter-pane" width="240px" valign="top">
	<form action="@base_url@">	 
	<p class="list-filter-header">Ricerca</p>
	<input class="input" type="text" value="@q;noquote@" name="q" id="ricerca" style="width:235px" />
		<center>
		  <input class="bot" type="submit" value="Cerca" />
		  <input class="bot" type="button" value="Reset" onClick="location.href='docenti-list';" />
		</center>
	      <listfilters name="docenti"></listfilters>
	</form>
      </td>
      <td class="list-list-pane" valign="top">
	<listtemplate name="docenti"></listtemplate>
      </td>
    </tr>
  </table>
  
