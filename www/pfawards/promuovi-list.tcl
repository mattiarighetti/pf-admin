ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
} {
    categoria_id:naturalnum
}
pf::user_must_admin
set page_title "PFAwards - ProfessioneFinanza"
set context [list $page_title]
set dash_menu [pf::admin_menu "pfawards"]
template::head::add_css -href /dashboard.css
set categoria [db_string query "select titolo from awards_categorie where categoria_id = :categoria_id"]
set count [db_string query "select count(*) from awards_esami_2 where categoria_id = :categoria_id"]
set table_html "<table class=\"table table-hover\"><tr><th>Persona</th><th>Società</th><th>Email</th><th>Punti</th><th>Esame</th><th>Azione</th></tr>"
db_foreach query "select e.esame_id, initcap(lower(p.societa_man)) as societa, initcap(lower(p.nome))||' '||initcap(lower(p.cognome)) as nominativo, p.user_id, a.email, e.punti, e.pdf_doc from awards_esami e, crm_persone p, parties a where a.party_id = p.user_id and p.persona_id = e.persona_id and e.categoria_id = :categoria_id and e.stato = 'svolto' and e.punti is not null order by e.punti desc" {
    append table_html "<tr><td>$nominativo</td><td>$societa</td><td>$email</td><td>$punti</td><td><a href=\"$pdf_doc\" target=\"_blank\" class=\"btn btn-default\">Vedi esame</a></td><td><a href=\"promuovi?esame_id=$esame_id\" "
    if {[db_0or1row query "select * from awards_esami_2 where rif_id = :esame_id limit 1"]} {
	append table_html "class=\"btn btn-success\">Boccia</a></td></tr>"
    } else {
	append table_html "class=\"btn btn-warning\">Promuovi</a></td></tr>"
    }
}
append table_html "</table>"
ad_return_template
