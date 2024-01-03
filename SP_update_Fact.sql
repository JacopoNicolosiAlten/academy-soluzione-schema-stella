create procedure SP_update_Fact as
with N_S as (select codiceContratto, COUNT(CodiceCliente) over(PARTITION BY codiceContratto) as numClienti, CodiceCliente
    from N_Stipula)

merge DWH_Fact as T
using (select D_FO.skFasciaOraria, D_cl.skCliente, D_contr.skContratto, D_t.skTempo, N_Bolletta.NumeroBolletta, N_Bolletta.DataEmissione, N_Bolletta.dataScadenzaPagamento, N_RFO.Consumo/N_S.numClienti as consumo, round(N_RFO.consumo * D_FO.prezzoKwh / N_S.numClienti, 2) as sommaDaPagare
from N_Bolletta
    join DWH_D_Contratto as D_contr on D_contr.codiceContratto = N_Bolletta.CodiceContratto 
    join N_Contratto on N_Bolletta.CodiceContratto = N_Contratto.CodiceContratto
    join DWH_D_Tempo as D_t on N_Bolletta.periodoRiferimento = concat(D_t.monthName, ' ', D_t.[year])
    join N_RiferimentoFasciaOraria as N_RFO on N_RFO.NumeroBolletta=N_Bolletta.NumeroBolletta
    join DWH_D_FasciaOraria as D_FO on D_FO.codiceFasciaOraria=N_RFO.CodiceFasciaOraria
    join N_S on N_S.CodiceContratto = N_Contratto.CodiceContratto
    join DWH_D_Cliente as D_cl on D_cl.codiceCliente=N_S.CodiceCliente) as S
on S.skTempo=T.skTempo and S.skContratto=T.skContratto and S.skCliente=T.skCliente and S.skFasciaOraria=T.skFasciaOraria
when matched
then UPDATE
set T.DataEmissioneBolletta = S.DataEmissione,
T.dataScadenzaPagamento = S.dataScadenzaPagamento,
T.consumo = S.consumo,
T.sommaDovuta = S.sommaDaPagare,
T.NumeroBolletta = S.NumeroBolletta

when not matched by TARGET
then insert (skTempo, skContratto, skCliente, skFasciaOraria, DataEmissioneBolletta, dataScadenzaPagamento, consumo, numeroBolletta, sommaDovuta)
values (S.skTempo, S.skContratto, S.skCliente, S.skFasciaOraria, S.DataEmissione, S.dataScadenzaPagamento, S.consumo, S.numeroBolletta, S.sommaDaPagare);