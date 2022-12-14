<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="acs_Focus">cerca.q</property>
  
  <div class="container">
    <button class="btn btn-lg btn-primary pull-right" data-toggle="modal" data-target="#modal_newsub"><span class="glyphicon glyphicon-plus"></span> Nuovo visitatore</button>
    <img class="img-responsive img-center center-block" style="display:inline-block;" height="100px" width="auto" src="http://images.professionefinanza.com/logos/pfexpo.png" />
    <div class="panel panel-primary">
      <div class="panel-heading"><h4>Ricerca</h4></div>
      <div class="panel-body">
	<formtemplate id="cerca">
	  <div class="form-group">
	    <input class="input-lg focusedInput form-control" type="text" name="q" id="q"></input>
        </div>
        <button class="btn btn-lg btn-primary" type="submit"><span class="glyphicon glyphicon-search"></span> Ricerca</button>
        </formtemplate>
      </div>
    </div>
    <div class="panel panel-success">
      <div class="panel-heading"><h4>Risultati</h4></div>
      @table_html;noquote@
    </div>
  </div>

  <!-- Modal collection -->
  @modal_html;noquote@
  <!-- end modal -->

  <!-- Modal new subsc. -->
  <div class="modal fade" id="modal_newsub" tabindex="-1" role="dialog" aria-labelledby="modal_label_newsub">
    <div class="modal-dialog modal-md" role="document">
      <div class="modal-content">
	<div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal" aria-label="Chiudi"><span aria-hidden="true">&times;</span></button>
	  <h4 class="modal-title" id="modal_label_newsub"><b>Nuova iscrizione</h4></div>
	<div class="modal-body">
	  <formtemplate id="iscrizione"></formtemplate>
	</div>
	<div class="modal-footer">
	  <button type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
	</div>
      </div>
    </div>
  </div>
  <!-- end modal -->
