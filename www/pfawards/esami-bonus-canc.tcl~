ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    esame_id:integer
}
set page_title "Aggiunta bonus"
set context [list [list index "PFAwards"] [list esami-list "Esami"] [list [export_vars -base "esami-gest" {esame_id}] "Esame #$esame_id"] $page_title]
#Form generalità
ad_form -name bonus \
    -export "esame_id" \
    -form {
	{descrizione:text
	    {label "Descrizione"}
	}
        {punti:integer
            {label "Punti"}
	}
    } -on_submit {
	set bonus_id [db_string query "select coalesce(max(bonus_id) + trunc(random()*99), trunc(random()*99)) from awards_bonus"]
	db_dml query "insert into awards_bonus (bonus_id, descrizione, punti, esame_id) values (:bonus_id, :descrizione, :punti, :esame_id)"
	ad_returnredirect [export_vars -base "esami-gest" {esame_id}]
	ad_script_abort
    }
