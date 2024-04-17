create procedure SP_update_Contratto as
merge DWH_D_Contratto as T
using (select AC_Contratto.CodiceContratto, AC_Contratto.kwh_max, AC_Cliente.codice as codiceCliente, TipologiaCliente, nome, cognome, numeroTelefono, indirizzo, ragioneSociale, professione, nomeReferente, cognomeReferente
from AC_Contratto
	join AC_Cliente on AC_Cliente.Codice = AC_Contratto.CodiceCliente) as S
ON T.CodiceContratto = S.CodiceContratto
when matched
then UPDATE
set T.[codiceCliente]=S.codiceCliente,
	T.kwhMax = S.kwh_max
	--....
when not matched by target
then insert ([codiceContratto], codiceCliente, kwhMax) --...
values (S.codiceContratto, S.codiceCliente, S.kwhMax);--...
