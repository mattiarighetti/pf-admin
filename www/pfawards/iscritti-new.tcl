ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 3 October 2016
} 
set page_title "Nuova iscrizione"
set context [list [list index "PFAwards"] [list iscritti-list "Iscritti"] $page_title]
ad_form -name iscritto \
    -mode edit \
    -form {
	{user_id:search
	    {label "Utente"}
	    {result_datatype integer}
	    {search_query "select p.first_names||' '||p.last_name||' ('||pa.email||') - '||p.person_id, p.person_id from persons p, parties pa where pa.party_id = p.person_id and first_names||' '||last_name ilike '%'||:value||'%'"}
	    {after_html "<a href=\"iscritti-new\">Cancella</a>"}
	}
	{esami:text(checkbox),multiple
	    {label "Esami"}
	    {options {[db_list_of_lists query "select titolo, categoria_id from awards_categorie order by categoria_id"]}}
	}
	{send_email:text(checkbox),optional
	    {label "Invia email di riepilogo"}
	    {options {{"Sì" 1}}}
	    {value 1}
	}
    } -on_submit {
	foreach categoria_id $esami {
	    set persona_id [db_string query "select persona_id from crm_persone where user_id = :user_id limit 1"]
	    set award_id [db_string query "select award_id from awards_edizioni where attivo is true limit 1"]
	    set decorrenza [db_string query "select inizio1 from awards_edizioni where award_id = :award_id"]
	    set scadenza [db_string query "select fine1 from awards_edizioni where award_id = :award_id"]
	    if {![db_0or1row query "select * from awards_esami where categoria_id = :categoria_id and persona_id = :persona_id and award_id = :award_id limit 1"]} {
		set esame_id [db_string query "select coalesce(max(esame_id)+trunc(random()*99+1), trunc(random()*99+1)) from awards_esami"]
		db_dml query "insert into awards_esami (esame_id, persona_id, categoria_id, attivato, decorrenza, scadenza, award_id, data_iscr) values (:esame_id, :persona_id, :categoria_id, false, :decorrenza, :scadenza, :award_id, current_timestamp)"
	    } else {
		ad_return_complaint 1 "Tra le categorie selezionate, per una o più è già stato attivato l'esame. <a href=\"iscritti-new\">Torna indietro per correggere e rifare</a>"
	    }
	}
    } -after_submit {
	set user_id [db_string query "select user_id from crm_persone where persona_id = :persona_id"]
	set to_mail [db_string query "select email from parties where party_id = :user_id"]
	set from_mail "info@pfawards.it"
	set subject "Iscrizione ai PFAwards"
	set nominativo [db_string query "select nome||' '||cognome from crm_persone where persona_id = :persona_id"]
	set body { <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	    <html xmlns="http://www.w3.org/1999/xhtml">
	    <head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title>[SUBJECT]</title>
	    <style type="text/css">
	    body {
		padding-top: 0 !important;
		padding-bottom: 0 !important;
		padding-top: 0 !important;
		padding-bottom: 0 !important;
		margin: 0 !important;
		width: 100% !important;
		-webkit-text-size-adjust: 100% !important;
		-ms-text-size-adjust: 100% !important;
		-webkit-font-smoothing: antialiased !important;
	    }
	    .tableContent img {
		border: 0 !important;
		display: block !important;
		outline: none !important;
	    }
	    a {
		color: #382F2E;
}
	    p, h1, ul, ol, li, div {
		margin: 0;
		padding: 0;
	    }
	    td, table {
		vertical-align: top;
	    }
	    td.middle {
		vertical-align: middle;
	    }
	    h2 {
		margin: 0;
		color: #000000;
		font-weight: normal;
		font-size: 22px;
}
	    p {
		color: #555555;
		font-size: 14px;
		line-height: 22px;
	    }
	    a {
		color: #4D82FF;
	    }
	    a.link2 {
		text-decoration: none;
  color: #ffffff;
		font-size: 15px;
		background: #364B81;
		padding: 8px 12px;
		border-radius: 3px;
		-moz-border-radius: 3px;
		-webkit-border-radius: 3px;
	    }
	    a.link3 {
  background: #57bb5a;
		color: #ffffff;
		font-size: 15px;
		padding: 8px 12px;
		border-radius: 3px;
		-moz-border-radius: 3px;
		-webkit-border-radius: 3px;
  text-decoration: none;
	    }
	    .bgBody {
		background: #EAEAEA;
	    }
	    .bgItem {
		background: #ffffff;
	    }
	    </style>
<script type="colorScheme" class="swatch active">
	    {
		"name":"Default",
    "bgBody":"EAEAEA",
		"link":"4D82FF",
		"color":"555555",
    "bgItem":"ffffff",
		"title":"000000"
  }
	    </script>
	    </head>
	    <body paddingwidth="0" paddingheight="0" class='bgBody' style="padding-top: 0; padding-bottom: 0; padding-top: 0; padding-bottom: 0; background-repeat: repeat; width: 100% !important; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased;" offset="0" toppadding="0" leftpadding="0">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableContent bgBody" align="center"  style='font-family:helvetica, sans-serif;'>
	    <!-- ================ header=============== -->
	    <tr>
	    <td height='20' ></td>
	    </tr>
	    <tr>
	    <td align='center'><table width="600" border="0" cellspacing="0" cellpadding="0" class='bgItem'>
        <tr>
	    <td height='25'></td>
	    </tr>
	    <!-- ================ END header =============== -->
	    <tr>
	    <td><table width="600" border="0" cellspacing="0" cellpadding="0">
	    <tr>
	    <td class='movableContentContainer' align='center'><!--  =========================== The body ===========================  -->
	    
	    <div class='movableContent'>
	    <table width="540" border="0" cellspacing="0" cellpadding="0">
	    <tr>
	    <td><table width="600" border="0" cellspacing="0" cellpadding="0">
	    <tr>
                              <td width='20'></td>
	    <td align='left'><div class="contentEditableContainer contentImageEditable">
	    <div class="contentEditable" > <a href="http://www.pfawards.it/"><img src="http://images.professionefinanza.com/logos/pfawards.png" alt='[CLIENTS.COMPANY_NAME]' width="178" height="auto"></a> </div>
                                </div></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table>
                  </div>
                  
                  <!--image-->
                  
                  <div class='movableContent'>
	    <table width="540" border="0" cellspacing="0" cellpadding="0">
	    <tr>
	    <td><div style='border:2px solid #364B81'></div></td>
	    </tr>
	    <tr>
	    <td height='30'></td>
	    </tr>
	    <tr>
	    <td><div class="contentEditableContainer contentTextEditable">
	    <div class="contentEditable" >
	    <p style='font-size:17px;text-align:left; line-height:20px; ;'> Gentile }
	append body $nominativo
                                append body {,</p>
				    <p style='font-size:17px;text-align:left; line-height:20px; ;'>ti ringraziamo  per esserti iscritto ai <strong>PFAwards</strong>. </p>
				    <p style='font-size:17px;text-align:left; line-height:20px; ;'>Ti confermiamo la scelta delle seguenti categorie: </p>}
	db_foreach query "select c.titolo as titolo from awards_categorie c, awards_esami i where i.persona_id = :persona_id and i.categoria_id = c.categoria_id and award_id = :award_id" {
	    append body "<p style='font-size:17px;text-align:left; line-height:20px; ;'>- $titolo</p>"
	}
	append body {<p style='font-size:17px;text-align:left; line-height:20px; ;'>&nbsp;</p>	                            </div>
                          </div></td>
                      </tr>
                      <tr>
                        <td height='30'></td>
                      </tr>
                      <tr>
                        <td><div style='border:1px solid #EBE3E3'></div></td>
                      </tr>
                    </table>
                  </div>
                  <div class='movableContent'>
                    <table width="540" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                      <tr>
                        <td><div class="contentEditableContainer contentTextEditable">
                            <div class="contentEditable" >
                              <p style='font-size:30px;color:#999999;text-align:center;'>&nbsp;</p>
                            </div>
                          </div></td>
                      </tr>
                      <tr>
                        <td height='5'></td>
                      </tr>
                      <tr>
                        <td><div class="contentEditableContainer contentTextEditable">
                            <div class="contentEditable" >
                              <h2 style='font-size:30px;text-align:center; color:#364B81; font-weight:bold'>Buona preparazione!</h2>
                            </div>
                          </div></td>
                      </tr>
                      <tr>
                        <td height='27'></td>
                      </tr>
                    </table>
                    <div class="contentEditableContainer contentTextEditable">
                      <div class="contentEditable" >
                        <p style='text-align:center'><a target='_blank' href="http://awards.professionefinanza.com/" class='link2' style='color:#ffffff;'>www.PFAwards.it</a></p>
                      </div>
                    </div>
                  </div>
                  <div class='movableContent'>
                    <table width="540" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height='30'></td>
                      </tr>
                      <tr>
                        <td><div style='border:1px solid #364B81'></div></td>
                      </tr>
                      <tr>
                        <td height='25'><p style='font-size:15px;color:#999999;text-align:center;'>Per informazioni: <a href="mailto:info@PFAwards.it">info@PFAwards.it</a></p></td>
                      </tr>
                      <tr>
                        <td><div style='border:1px solid #364B81'></div></td>
                      </tr>
                      <tr>
                        <td><div class="contentEditableContainer contentTextEditable">
                            <div class="contentEditable" >
                              <p style='font-size:15px;color:#999999;text-align:center;'>&nbsp;</p>
                            </div>
                          </div></td>
                      </tr>
                    </table>
                  </div>
                  <div class="contentEditableContainer contentImageEditable">
                    <div class="contentEditable"> <img src="https://gallery.mailchimp.com/3b436c6ce3392b2a4d195a80d/images/1f5b083d-e73b-4b87-9272-0e67ee2222c1.png">
                      
                        <tr>
                          <td height='22'></td>
                        </tr>
                    </div>
                  </div></td>
              </tr>
            </table></td>
        </tr>
      </table>
      </div></td>
  </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>

<!-- end footer-->

</table>
</body>
</html>

	}
	if {$send_email eq "1"} {
	    acs_mail_lite::send -to_addr $to_mail -from_addr $from_mail -mime_type "text/html" -subject $subject -body $body
	}
ad_returnredirect "iscritti-list"
ad_script_abort
}
