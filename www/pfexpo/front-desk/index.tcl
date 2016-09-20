ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    {q ""}
    {modal_html ""}
}
pf::user_must_admin
set page_title "Front desk"
set context [list [list /pfexpo "PFEXPO"] $page_title]
set focus "q"
set expo_id [pf::expo::id]
template::head::add_javascript -src "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
template::head::add_javascript -defer -src "http://professionefinanza.cloudapp.net/resources/pf-theme/styles/bootstrap/js/bootstrap.min.js"
template::head::add_javascript -src "DYMO.label.framework.js" -charset "UTF-8"
template::head::add_javascript -src "dymo.js" -charset "UTF-8"
ad_form -name "cerca" \
    -mode edit \
    -form {
	{q:text(text)
	    {label "Ricerca"}
	    {value $q}
	    {help_text "Campi di ricerca: nome, cognome, codice iscrizione, email, telefono."}
	}
    } -on_submit {
	ad_returnredirect "?q=$q"
    }
if {$q ne ""} {
    set table_html "<table class=\"table table-condensed\" style=\"font-size:18px;\"><tr><th>Nominativo</th><th>Email</th><th>Telefono</th><th>Iscrizione</th><th>Codice iscritto</th><th>&nbsp;</th><th>&nbsp;</th></tr>"
    db_foreach query "select iscritto_id, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, to_char(data, 'DD/MM/YYYY') as data, email, telefono, barcode, case when pagato is true then 1 else 0 end as paid from expo_iscritti where expo_id = :expo_id and (cognome ilike '%$q%' or nome ilike '%$q%' or telefono ilike '%$q%' or email ilike '%$q%' or nome||cognome ilike '%$q%' or cognome||nome ilike '%$q%' or barcode ilike '%$q%' or iscritto_id::text ilike '$q%') order by data desc" {
	if {$paid == 1} {
	    set bgcolor "#ff9999"
	} else {
	    set bgcolor ""
	}
	append table_html "<tr bgcolor=\"$bgcolor\"><td>[string toupper $nome] [string toupper $cognome]</td><td>$email</td><td>$telefono</td><td>$data</td><td>$iscritto_id</td><td><button type=\"button\" class=\"btn btn-warning btn-lg\" data-toggle=\"modal\" data-target=\"#modal_$iscritto_id\"><span class=\"glyphicon glyphicon-th-list\"></span></button></td>"
	#Estrazione corsi da passare a DYMO LABEL
	set courses ""
	db_foreach query "select e.short_title, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time, i.iscrizione_id, i.soldout from expo_eventi e, expo_iscrizioni i, expo_sale s where e.evento_id = i.evento_id and i.iscritto_id = :iscritto_id and s.sala_id = e.sala_id" {
	    append courses "- " $short_title " (" $sala ", " $start_time ")"
	    if {$paid == 1 || [db_0or1row query "select * from expo_iscrizioni where voucher_id is not null and iscrizione_id = :iscrizione_id limit 1"]} {
		append courses "-(€)"
	    }
	    if {$soldout ne ""} {
		append courses "-(*)"
	    }
	    append courses "<br />"
	}
	#Toglie ultimo br, inutile
	set courses [string trimright $courses "<br />"]
	set modal_table "<table class=\"table table-hover\" style=\"font-size:18px;\"><tr><th>Codice iscrizione</th><th>Codice evento</th><th>Denominazione</th><th>Orario</th><th>Sala</th></tr>"
	db_foreach query "select i.iscrizione_id, e.short_title as denominazione, e.evento_id, to_char(e.start_time, 'HH24:MI') as orario, s.denominazione as sala from expo_eventi e, expo_iscrizioni i, expo_sale s where i.iscritto_id = :iscritto_id and i.evento_id = e.evento_id and s.sala_id = e.sala_id" {
	    append modal_table "<tr><td>$iscrizione_id</td><td>$evento_id</td><td>$denominazione</td><td>$orario</td><td>$sala</td></tr>"
	}
	append modal_table "</table>"
	append table_html "<td><center><button id=\"print\" class=\"btn btn-success btn-lg\" onClick=\"printBadge('$barcode','[string map {' &rsquo;} $nome]','[string map {' &rsquo;} $cognome]', '[string map {' &rsquo;} $courses]')\"><span class=\"glyphicon glyphicon-print\"></span></button></td></tr>"
	append modal_html "<div class=\"modal fade\" id=\"modal_$iscritto_id\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"modal_label_$iscritto_id\"><div class=\"modal-dialog modal-lg\" role=\"document\"><div class=\"modal-content\"><div class=\"modal-header\"><button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Chiudi\"><span aria-hidden=\"true\">&times;</span></button><h4 class=\"modal-title\" id=\"modal_label_$iscritto_id\"><b>Dettaglio iscrizione per $nome $cognome</b><br /><small>Codice iscritto: $iscritto_id</small></h4></div>$modal_table<div class=\"modal-footer\"><!--<a class=\"btn btn-default\"></a>--><button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Chiudi</button></div></div></div></div>"
    }
    append table_html "</table>"
} else {
    set table_html "Nessun risultato."
    set modal_html ""
}

#Prepara form iscrizione
ad_form -name iscrizione \
    -edit_buttons [list [list "Iscrivi" new]] \
    -has_edit 1 \
    -form {
	{nome:text
	    {label "Nome"}
	    {html {maxlength 50}}
	}
	{cognome:text
            {label "Cognome"}
            {html {maxlength 50}}
        }
	{email:text
            {label "Email"}
            {html {maxlength 50}}
        }
	{societa:text,optional
            {label "Societa"}
            {html {maxlength 50}}
        }
	{telefono:text,optional
            {label "Telefono"}
            {html {maxlength 50}}
        }
	{provincia:text
            {label "Provincia"}
            {html {maxlength 50}}
        }
	{voucher:boolean(checkbox),optional
	    {label "Area VIP"}
	    {options {{"" "t"}}}
	}
    } -on_submit {
      	set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+1,1) FROM expo_iscritti"]
	set barcode "80300"
	if {[string length $iscritto_id] == 4} {
	    append barcode 000
	}
	if {[string length $iscritto_id] == 5} {
	    append barcode 00
	}
	if {[string length $iscritto_id] == 6} {
	    append barcode 0
	}
	append barcode $iscritto_id
	db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, email, societa, telefono, provincia, data, barcode, pagato, expo_id) VALUES (:iscritto_id, :nome, :cognome, :email, :societa, :telefono, :provincia, current_date, :barcode, :voucher, :expo_id)"
    } -after_submit {
	set return_url "index?q=$iscritto_id"
	ad_returnredirect -message "Iscrizione correttamente effettuata (Codice iscritto: $iscritto_id)." $return_url
	ad_script_abort
    }
