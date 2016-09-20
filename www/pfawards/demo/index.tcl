ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
}
pf::user_must_admin
set page_title "Demo"
set context [list [list ../index "PFAwards"] $page_title]
set award_id [pf::awards::id]
if {[db_0or1row query "select * from awards_edizioni where demo is true and award_id = :award_id"]} {
    set attiva_button "Stato: attivo. <a class=\"btn btn-warning btn-xs\" href=\"attiva\">Disattiva</a>."
} else {
    set attiva_button "Stato: disattivo. <a class=\"btn btn-success btn-xs\" href=\"attiva\">Attiva</a>."
}
ad_return_template
