ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
}
pf::user_must_admin
set page_title "PFAwards - ProfessioneFinanza"
set context [list $page_title]
set dash_menu [pf::admin_menu "pfawards"]
template::head::add_css -href /dashboard.css
set table_html "<table class=\"table table-hover\">"
db_foreach query "select titolo, categoria_id from awards_categorie order by categoria_id" {
    append table_html "<tr><td>$titolo</td><td><a href=\"promuovi-list?categoria_id=$categoria_id\" class=\"btn btn-primary\">Consulta categoria</a></td></tr>"
}
append table_html "</table>"
ad_return_template
