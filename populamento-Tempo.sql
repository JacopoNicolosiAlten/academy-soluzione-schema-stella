insert into DWH_D_Tempo([date], [year], [month], monthName)
select data, Anno, Mese, monthName
from BPP_Tempo
where Giorno = 1;