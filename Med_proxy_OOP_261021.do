d hu001-hu005
tab hu034 hu001
recode hu035 -99/-1=., gen(oop)
tab oop
table hu034, contents(mean oop median oop p25 oop p75 oop freq ) by(hu001)

recode hhincome -99/-1=., gen(income)
gen prop_oop=(oop*12/income)
gen hh=substr(tilda_serial,1,4)
egen hh_oop=total(oop), by(hh)
gen prop_hh_oop=(hh_oop*12/income)
egen pickone_hh=tag(hh)
gen medcard=hu001
recode medcard 2=1 if hu034==2

table hu001 if pickone_hh==1, contents(mean prop_hh_oop median prop_hh_oop p25 prop_hh_oop p75 prop_hh_oop freq )
table hu034 if pickone==1, contents(mean prop_hh_oop median prop_hh_oop p25 prop_hh_oop p75 prop_hh_oop freq ) by(hu001)

table medcard if pickone_hh==1, contents(mean prop_hh_oop median prop_hh_oop p25 prop_hh_oop p75 prop_hh_oop freq )
table medcard if pickone_hh==1, contents(mean hh_oop median hh_oop p25 hh_oop p75 hh_oop freq )

recode hu005 -99/-1=., gen (gpvisits)
recode hu006 -99/-2=. -1=0, gen(gpspend_m)
gen gpspend=gpspend_m*gpvisits
recode hu038 -99/-2=. -1=0, gen(edspend)
recode hu039 -99/-2=. -1=0, gen(hospspend)
recode hu040 -99/-2=. -1=0, gen(inpatspend)

gen totalhcspend= gpspend+ edspend+ hospspend+ inpatspend
recode hu015_a4 -99/-2=. -1=0, gen(homehelpspend)
recode hu015_b4 -99/-2=. -1=0, gen(perscarespend)
recode hu015_c4 -99/-2=. -1=0, gen(mealsspend)
recode hu033 -99/-2=. -1=0, gen(nhspend)
recode hu036 -99/-2=. -1=0, gen(otherhcspend)
egen totalspend=rowtotal(  totalhcspend- otherhcspend)
gen prop_oop_total=oop/totalspend
gen prop_oop_ex_hc=oop/(income-totalspend)
recode prop_oop_ex_hc -10000/-0.00000001=.
table medcard, contents(mean prop_oop_ex_hc median prop_oop_ex_hc  p25 prop_oop_ex_hc  p75 prop_oop_ex_hc  freq )

histogram totalspend if totalspend>0 & totalspend<10000, bin(70)
table medcard, contents(mean prop_oop_total median prop_oop_total  p25 prop_oop_total  p75 prop_oop_total  freq )
table medcard, contents(mean prop_oop_ex_hc median prop_oop_ex_hc  p25 prop_oop_ex_hc  p75 prop_oop_ex_hc  freq )

/////checking if update gets logged
