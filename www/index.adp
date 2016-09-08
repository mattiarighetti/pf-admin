  <master>
    <property name="page_title">@page_title;noquote@</property>	
    <property name="context">@context;noquote@</property>

    <h1>Amministrazione - ProfessioneFinanza</h1>
    <hr />
    <table width="100%">
      <tr>
	<td>
	  <h2><a href="pfexpo">PFEXPO</a></h2>
	  <ul>
	    <if @expo_iscr@ not nil>
	      <li>Iscritti al PFEXPO: <b>@expo_iscr@</b></li>
	      <li>Giorni all'evento: <b>@expo_gg@</b></li>
	      <li><a href="pfexpo/eventi-list">Eventi</a></li>
	      <li><a href="pfexpo/iscritti-list">Iscritti</a></li>
	      <li><a href="pfexpo/voucher-list">Voucher</a></li>
            </if>
	    <li><a href="pfexpo/edizioni-list">Edizioni</a></li>
          </ul>
        </td>
	<td>
	  <h2><a href="pfawards">PFAwards</a></h2>
	  <ul>
	    <if @awards_iscr@ not nil>
	      <li>Iscritti ai PFAwards: <b>@awards_iscr@</b></li>
	      <li>Fase dei PFAwards: <b>@awards_fase@</b></li>
	      <li><a href="pfawards/esami-list">Esami</a></li>
	      <li><a href="pfawards/iscritti-list">Iscritti</a></li>
            </if>
	    <li><a href="pfawards/edizioni-list">Edizioni</a></li>
	  </ul>
	</td>
      </tr>
      <tr>
	<td>
	  <h2><a href="docenti">Docenti</a></h2>
	  <ul>
	    <li>Totale docenti: <b>@docenti_tot@</b></li>
	    <li><a href="docenti/docenti-list">Elenco</a></li>
	  </ul>
	</td>
      </tr>
    </table>
