ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 18 May 2015
}
pf::user_must_admin
set page_title "Amministrazione - ProfessioneFinanza"
set context ""
if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true limit 1"]
    set expo_iscr [db_string query "select count(distinct(email)) from expo_iscritti where expo_id = :expo_id"]
    set expo_gg [db_string query "select data - current_date from expo_edizioni where expo_id = :expo_id"]
} else {
    set expo_iscr ""
}
if {[db_0or1row query "select * from awards_edizioni where attivo is true limit 1"]} {
    set award_id [db_string query "select award_id from awards_edizioni where attivo is true limit 1"]
    set awards_iscr [db_string query "select count(distinct(persona_id)) from awards_esami where award_id = :award_id"]
    set awards_fase [db_string query "select case when current_date < inizio1 then 'Iscrizioni' when current_date between inizio1 and fine1 then 'Prima fase' when current_date between inizio2 and fine2 then 'Seconda fase' when current_date > fine2 then 'Fine' end from awards_edizioni where award_id = :award_id"]
} else {
    set awards_iscr ""
}
set docenti_tot [db_string query "select count(*) from docenti"]
set utenti_tot [db_string query "select count(*) from users"]
ad_return_template
