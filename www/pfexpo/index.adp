  <master>
    <property name="page_title">@page_title;noquote@</property>	
    <property name="context">@context;noquote@</property>
    
    <div class="container-fluid">
      <div class="row">
	<div class="col-sm-3 col-md-2 sidebar">
	  @admin_menu;noquote@
	</div>
	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
	  <h1 class="page-header">@page_title;noquote@</h1>
	  <formtemplate id="edizione">
	    <div class="form-group">
	      <div class="input-group">
		<div class="input-group-addon">PFEXPO</div>
		<formwidget id="expo_id">
	      </div>      
	      <input type="hidden" name="module" value="pfexpo" />
	      <input class="btn btn-success" type="button" value="Nuovo" onClick="location.href='expo-gest'" />
	      <input class="btn btn-success" type="button" value="Modifica" onClick="location.href='expo-gest?expo_id=@expo_id;noquote@'" />
	    </div>
	  </formtemplate></br>
	  <ul class="list-group">
	      <li class="list-group-item">Giorni all'evento: <span class="badge">@giorni;noquote@</span></li>
	      <li class="list-group-item">Iscritti totali: <span class="badge">@tot_iscr;noquote@</span></li>
	      <li class="list-group-item">Iscritti oggi: <span class="badge">@oggi_iscr;noquote@</span></li>
	      	      </ul>
	  
	  
	  <div class="table-responsive">
	    <table align="center" border="0" width="100%">
	      <tr>
		<td width="50%" valign="top">
		  <center>
		    <ul class="list-group">
		      <li class="list-group-item disabled">MENU</li>
		      <li class="list-group-item"><a href="eventi-list">Eventi</a></li>
		      <li class="list-group-item"><a href="iscritti-list?expo_id=@expo_id@">Iscritti</a></li>
		      <li class="list-group-item"><a href="voucher-list">Voucher</a></li>
		      <li class="list-group-item"><a href="partecipati-list">Partecipati</a></li>
			    </ul>
		  </center>
		</td>
		<td width="50%" valign="top">
		  <center>
		    <ul class="list-group">
		      <li class="list-group-item disabled">UTILITY</li>
		      <li class="list-group-item"><a href="eventi-list">Eventi</a> | <a href="categoriaevento-list">Percorsi evento</a></li>
		      <li class="list-group-item"><a href="edizioni-partners-list?expo_id=@expo_id@">Partners espositori</a></li>
		      <li class="list-group-item"><a href="speakers-list">Speakers</a></li>
		      <li class="list-group-item"><a href="sale-list">Sale</a> | <a href="luoghi-list">Luoghi</a></li>
		    </ul>
		  </center>
		</td>
	      </tr>
	    </table>
	    </div>
	  @events_table;noquote@
	</div>
      </div>
    </div>
