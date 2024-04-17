-- caso caricamenti incrementali sul tempo

insert into DWH_Fact(skFasciaOraria, skTempo, skContratto, counsumo, sommaDovuta, DataEmissione)
select skFasciaOraria, skTempo, skContratto, D.qta_consumata as counsumo, round(D.qta_consumata * DFO.prezzoKwh, 2) as sommaDovuta, B.DataEmissione
    from AC_Bolletta B
        join AC_DIPENDE D on B.numero_progressivo=D.numero_progressivo_bolletta
        join DWH_D_FasciaOraria DFO on DFO.codiceFasciaOraria = D.codiceFasciaOraria
        join DWH_D_Tempo T on B.periodoRiferimento = concat(T.monthName, ' ', convert(char(4), T.year))
        join DWH_D_Contratto C on C.codiceContratto=B.codiceContratto
        --join AC_Contratto Contr on contr.codiceContratto=C.codiceContratto
        --join DWH_D_Cliente Cl on cl.codiceCliente = contr.codiceCliente
where skTempo not in (select skTempo from DWH_Fact)
-- alternativa
--where T.date > (select max(date) from DWH_Fact
--    join DWH_D_Tempo on DWH_D_Tempo.skTempo=DWH_Fact.skTempo)


-- caso caricamenti completi con merge
merge DWH_Fact as T
using (select skFasciaOraria, skTempo, skContratto, D.qta_consumata as counsumo, round(D.qta_consumata * DFO.prezzoKwh, 2) as sommaDovuta, B.DataEmissione
    from AC_Bolletta B
        join AC_DIPENDE D on B.numero_progressivo=D.numero_progressivo_bolletta
        join DWH_D_FasciaOraria DFO on DFO.codiceFasciaOraria = D.codiceFasciaOraria
        join DWH_D_Tempo T on B.periodoRiferimento = concat(T.monthName, ' ', convert(char(4), T.year))
        join DWH_D_Contratto C on C.codiceContratto=B.codiceContratto
        --join AC_Contratto Contr on contr.codiceContratto=C.codiceContratto
        --join DWH_D_Cliente Cl on cl.codiceCliente = contr.codiceCliente
    ) as S
on S.skFasciaOraria=T.skFasciaOraria and  S.skTempo = T.skTempo and S.skContratto = T.skContratto

when MATCHed then update
...

when not matched by target then insert
...

-- caso caricamenti completi con truncate, insert

truncate table DWH_Fact

insert into DWH_Fact (....)
select skFasciaOraria, skTempo, skContratto, D.qta_consumata as counsumo, round(D.qta_consumata * DFO.prezzoKwh, 2) as sommaDovuta, B.DataEmissione
    from AC_Bolletta B
        join AC_DIPENDE D on B.numero_progressivo=D.numero_progressivo_bolletta
        join DWH_D_FasciaOraria DFO on DFO.codiceFasciaOraria = D.codiceFasciaOraria
        join DWH_D_Tempo T on B.periodoRiferimento = concat(T.monthName, ' ', convert(char(4), T.year))
        join DWH_D_Contratto C on C.codiceContratto=B.codiceContratto
        --join AC_Contratto Contr on contr.codiceContratto=C.codiceContratto
        --join DWH_D_Cliente Cl on cl.codiceCliente = contr.codiceCliente
    