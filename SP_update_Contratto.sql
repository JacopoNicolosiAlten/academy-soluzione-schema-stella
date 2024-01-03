create procedure SP_update_Contratto as
merge DWH_D_Contratto as T
using (select N_Contratto.CodiceContratto, TipologiaContratto, IndirizzoLocale, DataStipulaContratto, DataInizioFornitura, N_Contratto.KWMassimi as kwMassimiContratto, TempoMassimoIntervento, N_Contatore.CodiceContatore, modello, N_Contatore.KWMassimiErogabili as kwMassimiContatore, DataInstallazione, N_Citta.NomeCitta, CodiceAreaGeografica
from N_Contratto
    join N_Contatore on N_Contatore.CodiceContratto=N_Contratto.CodiceContratto
    join N_Citta on N_Contatore.NomeCitta=N_Citta.NomeCitta) as S
ON T.CodiceContratto = S.CodiceContratto
when matched
then UPDATE
set T.[codiceContratto]=S.codiceContratto,
	T.[tipologiaContratto]=S.tipologiaContratto,
	T.[indirizzoLocale]=S.IndirizzoLocale,
	T.[dataStipula]=S.DataStipulaContratto,
	T.[dataInizioFornitura]=S.DataInizioFornitura,
	T.[kwMassimiContratto]=S.kwMassimiContratto,
	T.[tempoMassimoIntervento]=S.TempoMassimoIntervento,
	T.[codiceContatore]=S.CodiceContatore,
	T.[modello]=S.modello,
	T.[kwMassimiContatore]=S.kwMassimiContatore,
	T.[dataInstallazioneContatore]=S.DataInstallazione,
	T.[nomeCitta]=S.NomeCitta,
	T.[codiceAreaGeografica]=S.CodiceAreaGeografica
when not matched by target
then insert ([codiceContratto], [tipologiaContratto], [indirizzoLocale], [dataStipula], [dataInizioFornitura], [kwMassimiContratto], [tempoMassimoIntervento], [codiceContatore], [modello], [kwMassimiContatore], [dataInstallazioneContatore], [nomeCitta], [codiceAreaGeografica])
values (S.codiceContratto, S.tipologiaContratto, S.IndirizzoLocale, S.DataStipulaContratto, S.DataInizioFornitura, S.kwMassimiContratto, S.TempoMassimoIntervento, S.CodiceContatore, S.modello, S.kwMassimiContatore, S.DataInstallazione, S.NomeCitta, S.CodiceAreaGeografica);