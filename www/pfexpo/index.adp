  <master>
    <property name="page_title">@page_title;noquote@</property>	
    <property name="context">@context;noquote@</property>
    
    <h1>@page_title;noquote@</h1>
    <hr />
    <table width="100%">
      <tr>
	<td>
	  <formtemplate id="edizione">
	    <div class="form-group">
	      <div class="input-group">
		<div class="input-group-addon">PFEXPO</div>
		<formwidget id="expo_id">

	    </div>      
	      <input type="hidden" name="module" value="pfexpo" />
	      <input class="btn btn-success" type="button" value="Nuovo" onClick="location.href='edizioni-gest'" />
	      <input class="btn btn-success" type="button" value="Modifica" onClick="location.href='edizioni-gest?expo_id=@expo_id;noquote@'" />
          </div>
			     </formtemplate><br />
	  <b>Edizione corrente</b>
	  <ul>
	  <li><a href="eventi-list">Eventi</a></li>
	  <li><a href="iscritti-list">Iscritti</a></li>
	  <li><a href="edizioni-partners-list">Partners</a></li>
	  <li><a href="voucher-list">Voucher</a></li>
	  <li><a href="partecipati-list">Presenze</a></li>
	  <li><a href="front-desk">Front desk</a></li>
	    </ul>
      </td>
	<td>
	  <big>
	  <center><b>Insights</b></center>
	  <ul>
	    <li>Giorni all'evento: <span class="badge">@giorni;noquote@</span></li>
	    <li>Iscritti totali: <span class="badge">@tot_iscr;noquote@</span></li>
	    <li>Iscritti oggi: <span class="badge">@oggi_iscr;noquote@</span></li>
	      </ul>
	  </big>
	  <small>
	    <center><b>Utility</b></center>
	    <ul>
	      <li><a href="luoghi-list">Luoghi</a></li>
	      <li><a href="speakers-list">Speakers</a></li>
	      <li><a href="partners-list">Partners</a></li>
	      <li><a href="percorsi-list">Percorsi</a></li>
	  </small>
    </td>
	    </tr>
	  </table>
    <h2>Tabella oraria</h2>
    <hr />
    @events_table;noquote@
