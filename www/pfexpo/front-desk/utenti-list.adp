  <master>
    <property name="title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    <property name="focus">@focus;noquote@</property>	
    
    <div class="container">
      <br></br>
	<center>
	  <img class="center-block" style="display:inline-block;" height="100px" width="auto" src="http://images.professionefinanza.com/logos/pfexpo.png" />
	</center>
      <br></br>
      <formtemplate id="cerca">
	<center>
	  <br></br><input class="form-control" type="text" name="q" id="q" style="width:75%;"></input><br></br>
	  <button class="btn btn-lg btn-primary" type="submit"><span class="glyphicon glyphicon-search"></span> Ricerca</button>
	  <a class="btn btn-lg btn-primary" href="nuovo"><span class="glyphicon glyphicon-plus"></span> Nuovo visitatore</a>
	</center>
      </formtemplate>
      <br></br>
      @table_html;noquote@
    </div>