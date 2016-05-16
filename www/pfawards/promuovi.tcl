ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
} {
    esame_id:naturalnum
}
pf::user_must_admin
set page_title "PFAwards - ProfessioneFinanza"
set context [list $page_title]
set dash_menu [pf::admin_menu "pfawards"]
template::head::add_css -href /dashboard.css
set categoria_id [db_string query "select categoria_id from awards_esami where esame_id = :esame_id"]
if {![db_0or1row query "select * from awards_esami_2 where rif_id = :esame_id"]} {
    set persona_id [db_string query "select persona_id from awards_esami where esame_id = :esame_id"]
    set rif_id $esame_id
    # Creazione nuovo ID Esame
    set ok 1
    while {$ok} {
	set esame_id [db_string query "select coalesce(max(esame_id)+trunc(random()*99+1)+:ok, trunc(random()*99+1)) from awards_esami_2"]
	incr ok
	if {![db_0or1row query "select * from awards_esami where esame_id = :esame_id"]} {
	    set ok 0
	}
    }
    db_dml query "insert into awards_esami_2 (esame_id, categoria_id, persona_id, attivato, rif_id, award_id) values (:esame_id, :categoria_id, :persona_id, true, :rif_id, 1)"
} else {
    db_dml query "delete from awards_esami_2 where rif_id = :esame_id"
}
ad_returnredirect "promuovi-list?categoria_id=$categoria_id"
ad_script_abort
