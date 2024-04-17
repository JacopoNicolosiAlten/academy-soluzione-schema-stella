create or alter PROCEDURE SP_update_fasciaOraria as
MERGE DWH_D_FasciaOraria as T
USING AC_FasciaOraria as S
on S.CodiceFasciaOraria = T.codiceFasciaOraria and S.prezzoKwh = T.prezzoKwh and T.historical=0

-- se trovo il match, sono nel caso in cui trovo nella source un'entità (fascia Oraria) già presente nella target, per la quale non sono cambiati dati da storicizzare (prezzoKwh è invariato rispetto all'ultima info disponibile nella target)
-- in questo caso è sufficiente aggiornare gli attributi non storicizzati
when matched
then UPDATE
set T.oraInizioValidita = S.[OraInizioValidità],
T.oraFineValidita = S.[OraFineValidità]

-- se non trovo il match, potrei essere in due casi:
--1 è stata trovata una nuova entità (fascia oraria)
--2 per un'entità già presente nella target, viene trovato un prezzoKwh differente
-- in entrambi i casi devo inserire una nuova riga
-- nel caso 1 perché c'è una nuova entità
-- nel caso 2 perché la riga attualmente valida per quell'entità andrà invecchiata, dovrà quindi subentrare una nuova riga con l'informazione aggiornata.
when not matched by target
then insert (CodiceFasciaOraria, oraInizioValidita, oraFineValidita, prezzoKwh, dataInizio, dataFine, historical)
values (S.CodiceFasciaOraria, S.oraInizioValidità, S.oraFineValidità, S.prezzoKWh, get_date(), NULL, 0);

-- in ultimo, dopo il merge, posso usare un update per eseguire due operazioni in contemporanea:
--1 invecchiare le righe necessarie
--2 aggiornare gli attributi non storicizzati per le righe vecchie
-- l'update deve quindi riguardare due tipologie di righe, selezionate dal where:
--1 le righe che erano già storiche prima della procedura (identificate con codiceFasciaOraria matchato e historical=1)
--2 le righe che devono essere invecchiate (identificate con codiceFasciaOraria matchato e prezzoKwh diverso)
update DWH_D_FasciaOraria
set historical = 1, -- invecchio (non ha nessun effetto sulle righe già vecchie)
    dataFine = isnull(dataFine, get_date()), -- se dataFine è nullo sto invecchiando la riga in questo momento--> imposto dataFine=data attuale (non ha nessun effetto sulle righe già vecchie)
    oraInizioValidita = S.[OraInizioValidità], --aggiorno attributi non storicizzati
    oraFineValidita = S.[OraFineValidità]
from AC_FasciaOraria S
where S.CodiceFasciaOraria = DWH_D_FasciaOraria.codiceFasciaOraria
 and (S.prezzoKwh <> DWH_D_FasciaOraria.prezzoKwh or DWH_D_FasciaOraria.historical=1)
