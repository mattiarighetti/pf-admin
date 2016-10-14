ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    esame_id:integer
}
set page_title "Esame #"
append page_title $esame_id
set context [list [list index "PFAwards"] [list esami-list "Esami"] $page_title]
#Form generalità
ad_form -name esame \
    -mode display \
    -has_edit 0 \
    -has_submit 0 \
    -cancel_url [export_vars -base "esame-canc" {esame_id}] \
    -cancel_label "Cancella l'esame" \
    -show_required_p 0 \
    -form {
        esame_id:key
	{nominativo:text,optional
	    {label "Nominativo"}
	    {html {disabled disabled}}
	}
        {categoria_id:integer(select),optional
            {label "Categoria"}
	    {options {[db_list_of_lists query "select titolo, categoria_id from awards_categorie order by categoria_id"]}}
        }
        {data_iscr:date,to_sql(sql_date),to_html(sql_date),optional
            {label "Iscrizione"}
	    {format "DD MONTH YYYY HH24 MI SS"}
	    {help_text "Formato: GG Mese AAAA H24 MI"}
	    {html {disabled disabled}}
	}
	{stato:text(select),optional
	    {label "Stato"}
	    {options {{"Svolto" svolto} {"Rifiutato" rifiutato} {"Da svolgere" ""}}}
	    {html {disabled disabled}}
	    }
	{attivato:text(checkbox),optional
	    {label "Attivato"}
	    {options {{"" t}}}
	}
	{decorrenza:date,to_sql(sql_date),to_html(sql_date),optional
            {label "Decorrenza"}
	    {format "DD MONTH YYYY HH24 MI SS"}
	    {help_text "Formato: GG Mese AAAA H24 MI"}
	}
	{scadenza:date,to_sql(sql_date),to_html(sql_date),optional
            {label "Scadenza"}
	    {format "DD MONTH YYYY HH24 MI SS"}
	    {help_text "Formato: GG Mese AAAA H24 MI"}
	}
	{award_id:integer(select),optional
	    {label "Edizione PFAwards"}
	    {options {[db_list_of_lists query "select anno, award_id from awards_edizioni order by award_id"]}}
	    {html {disabled disabled}}
	}
    } -select_query {
	"SELECT UPPER(p.last_name)||' '||INITCAP(LOWER(p.first_names)) AS nominativo, e.award_id, e.categoria_id, e.data_iscr, e.decorrenza, e.scadenza, e.stato, e.attivato, e.pdf_doc from awards_esami e, persons p, crm_persone r where e.persona_id = r.persona_id and r.user_id = p.person_id and e.esame_id = :esame_id"
    } -edit_data {
	db_dml query "UPDATE awards_esami SET decorrenza = $decorrenza, scadenza = $scadenza, attivato = :attivato where esame_id = :esame_id"
    }
#Estrazione dati aggiuntivi in caso di svolgimento
if {[db_0or1row query "select * from awards_esami where start_time is not null and end_time is not null and esame_id = :esame_id"]} {
    db_1row query "select start_time, end_time, punti, pdf_doc from awards_esami where esame_id = :esame_id"
    set svolto_html "<table class=\"table\"><tr><td><b>Inizio sessione</b></td><td>$start_time</td></tr><tr><td><b>Fine sessione</b></td><td>$end_time</td></tr><tr><td><b>Punti totalizzati</b></td><td>$punti</td></tr><tr><td><b>Documento PDF</b></td><td><a href=\"$pdf_doc\" target=\"_blank\">$pdf_doc</a></td></tr></table>"
} else {
    set svolto_html ""
}
#Bonus
template::list::create -name "bonus" \
    -actions [list "Aggiungi" [export_vars -base esami-bonus-gest {esame_id}] "Aggiungi bonus all'esame"] \
    -key bonus_id \
    -bulk_actions {"Cancella" "esami-bonus-canc" "Cancella i bonus selezionati"} \
    -bulk_action_method post \
    -bulk_action_export_vars {bonus_id} \
    -row_pretty_plural "bonus" \
    -no_data "Nessun bonus." \
    -elements {
	bonus_id {
	    label "ID Bonus"
	}
	descrizione {
	    label "Descrizione"
	}
	punti {
	    label "Punti"
	}
    }
db_multirow bonus query "select bonus_id, descrizione, punti from awards_bonus where esame_id = :esame_id"
#Estrazione quesiti
if {[db_0or1row query "select * from awards_rispusr where esame_id = :esame_id limit 1"]} {
    set queristi_html "<ul class=\"list-group\">"
    set counter 1
    db_foreach query "select d.domanda_id, d.testo, r.risposta_id as risp_sel, ri.punti as punti_tot from awards_domande d, awards_rispusr r, awards_risposte ri where r.domanda_id = d.domanda_id and r.esame_id = :esame_id and ri.risposta_id = r.risposta_id" {
	append quesiti_html "<li class=\"list-group-item\"><strong><span class=\"label label-info\">$counter.</span> $testo (#$domanda_id) <span class=\"badge\">Punti: $punti_tot</span></strong><br />"
	db_foreach query "select risposta_id, testo, punti from awards_risposte where domanda_id = :domanda_id order by risposta_id" {
	    if {$risposta_id eq $risp_sel} {
		append quesiti_html "   (#$risposta_id)   <span class=\"label label-warning\">X</span> $testo ($punti)<br />"
	    } else {
		append quesiti_html "   (#$risposta_id)   - $testo ($punti)<br />"
	    }
	}
	append quesiti_html "</li>"
    }
    append quesiti_html "</ul>"
} else {
    set quesiti_html ""
}
