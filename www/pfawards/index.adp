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
	      <div class="input-group-addon">PFAWARDS</div>
	      <formwidget id="award_id">
		
	      </div>      
	    <input type="hidden" name="module" value="award" />
	      <input class="btn btn-success" type="button" value="Nuovo" onClick="location.href='edizioni-gest'" />
	      <input class="btn btn-success" type="button" value="Modifica" onClick="location.href='edizioni-gest?award_id=@award_id;noquote@'" />
          </div>
	</formtemplate><br />
	<b>Edizione corrente</b>
	  <ul>
	  <li><a href="domande-list?award_id=@award_id@">Domande</a></li>
	  <li><a href="iscritti-list">Iscritti</a></li>
	  <li><a href="esami-list">Esami</a></li>
	  </ul>
      </td>
	<td>
	  <big>
	  <center><b>Insights</b></center>
	  <ul>
	    <li>Totale iscritti: <span class="badge">@tot_iscritti;noquote@</span></li>
	      </ul>
	  </big>
	  <small>
	    <center><b>Utility</b></center>
	    <ul>
	      <li><a href="demo">Demo PFAwards</a></li>
	      <li><a href="domande-list">Tutti i quesiti</a></li>
	      <li><a href="categorie-list">Categorie</a></li>
	      <li>Comitato</li>
	  </small>
    </td>
	    </tr>
	  </table>
