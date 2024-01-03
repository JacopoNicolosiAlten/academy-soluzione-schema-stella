create or alter PROCEDURE SP_update_Cliente as
MERGE DWH_D_Cliente as T
USING N_Cliente as S
on S.[CodiceCliente] = T.[CodiceCliente]

when matched
then UPDATE
set T.[codiceCliente] = S.[codiceCliente],
	T.[tipoCliente] = S.[TipologiaCliente],
	T.[nome] = S.[nome],
	T.[cognome] = S.[cognome],
	T.[numeroTelefono] = S.numeroTelefono,
	T.[indirizzo] = S.[indirizzo],
	T.[ragioneSociale] = S.[ragioneSociale],
	T.[professione] = S.[professione],
	T.[nomeReferente] = S.[nomeReferente],
	T.[cognomeReferente] = S.[cognomeReferente]
when not matched by target
then insert ([codiceCliente], [tipoCliente], [nome], [cognome], [numeroTelefono], [indirizzo], [ragioneSociale], [professione], [nomeReferente], [cognomeReferente])
values (S.[codiceCliente], S.[TipologiaCliente], S.[nome], S.[cognome], S.[numeroTelefono], S.[indirizzo], S.[ragioneSociale], S.[professione], S.[nomeReferente], S.[cognomeReferente]);