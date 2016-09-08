<master>
  <property name="doc(title)">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  
  <h1>Iscritti</h1>
  <hr />
  <table width="100%"> 
    <tr>
      <td class="list-filter-pane" width="240px" valign="top">
	<form action="@base_url@">	 
	<p class="list-filter-header">Ricerca</p>
	<input class="input" type="text" value="@q;noquote@" name="q" id="ricerca" style="width:235px" />
		<center>
		  <input class="bot" type="submit" value="Cerca" />
		  <input class="bot" type="button" value="Reset" onClick="location.href='iscritti-list';" />
		</center>
	      <listfilters name="iscritti"></listfilters>
	</form>
      </td>
      <td class="list-list-pane" valign="top">
	<listtemplate name="iscritti"></listtemplate>
      </td>
    </tr>
  </table>
     
