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
	  <h3>Evento: <b>@evento_html@</b></h3>
	  <listtemplate name="speaker"></listtemplate>
	</div>
      </div>
    </div>