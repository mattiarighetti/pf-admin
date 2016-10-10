ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015
}
pf::user_must_admin
set page_title "PFAwards"
set context [list $page_title]
if {![info exists award_id]} {
    if {[ad_get_cookie award_id] != ""} {
	set award_id [ad_get_cookie award_id]
    } else {
	if {[db_0or1row query "select * from awards_edizioni where attivo is true limit 1"]} {
	    set award_id [db_string query "select award_id from awards_edizioni where attivo is true limit 1"]
	} else {
	    set award_id [db_string query "select award_id from awards_edizioni order by anno desc limit 1"]
	}
	ad_set_cookie award_id $award_id
    }
}
ad_form -name edizione \
    -mode edit \
    -html {class "form-inline"} \
    -form {
	{award_id:integer(select)
	    {options {[db_list_of_lists query "select anno, award_id from awards_edizioni order by award_id desc"]}}
	    {html {class "form-control" onChange "this.form.submit()"}}
	    {value $award_id}
	}
    } -on_submit {
	ad_set_cookie award_id $award_id
    }
set tot_iscritti [db_string query "select count(distinct(persona_id)) from awards_esami where award_id = :award_id"]
set awards_fase [db_string query "select case when current_date < inizio1 then 'Iscrizioni' when current_date between inizio1 and fine1 then 'Prima fase' when current_date between inizio2 and fine2 then 'Seconda fase' when current_date > fine2 then 'Fine' end from awards_edizioni where award_id = :award_id"]


ad_return_template
