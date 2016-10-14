  <master>
    <property name="doc(title)">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
    <h1>@page_title@</h1>
    <hr />
    <table border="0" width="100%">
      <tr>
	<td width="50%">
	  <h3>Informazioni</h3>
	  <formtemplate id="esame"></formtemplate>
	  <a href="esami-reset?esame_id=@esame_id@&return_url=esami-gest" class="btn btn-default">Reset</a>
	    </td>
	<td>
	  <h3>Svolgimento</h3>
	  @svolto_html;noquote@
	  <hr />
	  <h3>Bonus</h3>
	  <listtemplate name="bonus"></listtemplate>
		  </td>
	    </tr>
      <tr>
	<td colspan="2">
	  <br />
	  <h3>Quesiti</h3>
	  @quesiti_html;noquote@
  </td>
	    </tr>
      </table>
