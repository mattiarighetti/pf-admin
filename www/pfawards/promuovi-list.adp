<html>
  <master>
    <property name="page_title">@page_title;noquote@</property>	
    <property name="context">@context;noquote@</property>

    <div class="container-fluid">
      <div class="row">
	<div class="col-sm-3 col-md-2 sidebar">
	  @dash_menu;noquote@
	</div>
	<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
	  <h1 class="page-header">Categoria: @categoria@</h1>
	  <a href="promuovi-cat" class="btn btn-default">Torna indietro</a><br>Promossi in questa categoria: @count@</br>
	  @table_html;noquote@
    </div>
	</div>
      </div>
