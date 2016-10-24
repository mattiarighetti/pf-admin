  <master>
    <property name="doc(title)">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
    <h1>@page_title@</h1>
    <hr />
    <div class="container">
      <div class="well well-sm">
	<a href="esami-reset?esame_id=@esame_id@&return_url=esami-gest" class="btn btn-default"><span class="glyphicon glyphicon-hourglass"></span> Reset</a>
	<button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal1"><span class="glyphicon glyphicon-th-list"></span> Prima fase</button>
	<a class="btn btn-default" href="@pdf_doc_1@" target="_blank"><span class="glyphicon glyphicon-print"></span> Stampa PDF 1</a>
	<if @quesiti2_html@ ne "">
	  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#modal2"><span class="glyphicon glyphicon-th-list"></span> Seconda fase</button>
	  <a href="@pdf_doc_2@" target="_blank" class="btn btn-default"><span class="glyphicon glyphicon-print"></span> Stampa PDF 2</a>
      </if>
	<else>
	  <a href="" class="btn btn-default"><span class="glyphicon glyphicon-certificate"></span> Promuovi</a>
  </else>
    </div>
      <table border="0" width="100%">
	<tr>
	  <td width="50%">
	    <h3>Informazioni</h3>
	    <formtemplate id="esame"></formtemplate>
	      </td>
	  <td>
	    <h3>Svolgimento</h3>
	    @svolto_html;noquote@
	    <hr />
	    <h3>Bonus</h3>
	  <listtemplate name="bonus"></listtemplate>
		    </td>
	      </tr>
	</table>
    
      <div class="modal fade" id="modal1" role="dialog">
	<div class="modal-dialog modal-lg">
	  <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
	      <h4 class="modal-title"><b>Esame prima fase #@esame_id@</b><br><small>Codice iscritto: @persona_id@</small></h4>
				    </div>
	    <div class="modal-body">
	      @quesiti_html;noquote@
	      </div>
	    <div class="modal-footer">
	      <a class="btn btn-default" target="_blank" href="@pdf_doc_1@">Stampa PDF</a><button type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
	    </div>
	  </div>
	</div>
	</div>

      
      <div class="modal fade" id="modal2" role="dialog">
	<div class="modal-dialog modal-lg">
	  <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
	      <h4 class="modal-title"><b>Esame seconda fase #@esame2_id@</b><br><small>Codice iscritto: @persona_id@</small></h4>
				    </div>
	    <div class="modal-body">
	      @quesiti2_html;noquote@
	      </div>
	    <div class="modal-footer">
	      <a class="btn btn-default" href="@pdf_doc_2@" target="_blank">Stampa PDF</a>--><button type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
	    </div>
	  </div>
	</div>
      </div>
    </div>
