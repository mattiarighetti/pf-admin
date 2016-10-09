ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    persona_id:integer
}
pf::user_must_admin
set page_title "Aggiungi esame"
set context [list [list index "PFAwards"] [list iscritti-list "Iscritti"] [list [export_vars -base "iscritti-gest" {persona_id}] "Dettaglio"] $page_title]
set award_id [pf::awards::id]
ad_form -name esami \
    -export {persone_id award_id} \
    -form {
	{categoria_id:integer(checkbox)
	    {label "Categorie"}
	    {options {[db_list_of_lists query "select titolo, categoria_id from awards_categorie"]}}
	}
    } -edit_data {
	foreach esame categoria_id {
	    if {[db_0or1row query "select * from awards_esami where categoria_id = :categoria_id and award_id = :award_id and persona_id = :persona_id limit 1"]} {
		set esame_id [db_string query "select coalesce(max(esame_id) + trunc(random()*99), trunc(random()*99)) from awards_esami"]
		db_dml query "insert into awards_esami "
	    }
	}
    }
