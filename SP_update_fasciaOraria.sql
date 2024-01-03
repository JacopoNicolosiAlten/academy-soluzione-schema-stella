create or alter PROCEDURE SP_update_fasciaOraria as
MERGE DWH_D_FasciaOraria as T
USING N_FasciaOraria as S
on S.CodiceFasciaOraria = T.codiceFasciaOraria

when matched
then UPDATE
set T.oraInizioValidita = S.[OraInizioValidità],
T.oraFineValidita = S.[OraFineValidità],
T.prezzoKwh = S.[PrezzoKWh]
when not matched by target
then insert (CodiceFasciaOraria, oraInizioValidita, oraFineValidita, prezzoKwh)
values (S.CodiceFasciaOraria, S.oraInizioValidità, S.oraFineValidità, S.prezzoKWh);