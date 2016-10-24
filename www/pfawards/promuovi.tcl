ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 14 October 2015

    Programma per promuovere un esame in seconda fase.
} {
    esame_id:naturalnum
    {return_url "esami-list"}
}
pf::user_must_admin
if {[db_0or1row query "select * from awards_esami_2 where rif_id = :esame_id"]} {
    db_dml query "delete from awards_esami_2 where esame_id = :rif_id"
} else {
    set award_id [pf::awards::id]
    db_1row query "select categoria_id, persona_id from awards_esami where esame_id = :esame_id"
    set rif_id $esame_id
    # Creazione nuovo ID Esame
    set ok 1
    while {$ok} {
	set esame_id [db_string query "select coalesce(max(esame_id)+trunc(random()*99+1)+:ok, trunc(random()*99+1)) from awards_esami_2"]
	incr ok
	if {![db_0or1row query "select * from awards_esami where esame_id = :esame_id and award_id = :award_id"]} {
	    set ok 0
	}
    }
    db_1row query "select inizio2, fine2 from awards_edizioni where award_id = :award_id"
    db_dml query "insert into awards_esami_2 (esame_id, categoria_id, persona_id, attivato, rif_id, award_id, decorrenza, scadenza) values (:esame_id, :categoria_id, :persona_id, true, :rif_id, :award_id, :inizio2, :fine2)"
}
ad_returnredirect $return_url
ad_script_abort
