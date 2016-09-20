ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
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
	    {options {[db_list_of_lists query "select titolo, categoria_id from awards_categorie"]}}
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
	ad_returnredirect "iscritti-list"
	ad_script_abort
    }