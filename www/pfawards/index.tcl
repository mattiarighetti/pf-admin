ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
}
pf::user_must_admin
set page_title "PFAwards - ProfessioneFinanza"
set context [list $page_title]
set dash_menu [pf::admin_menu "pfawards"]
template::head::add_css -href /dashboard.css
ad_return_template
