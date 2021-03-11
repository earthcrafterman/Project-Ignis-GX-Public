--メタル・デビルゾア
--Metalzoa
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,24311372,s.matfilter)
	Fusion.AddProcMix(c,true,true,s.confilter1,s.confilter2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	c:EnableReviveLimit()
end
s.listed_names={24311372,68540058,CARD_METAMORPHOSIS}
function s.matfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_NORMAL)
end
function s.confilter1(c)
	return c:IsCode(24311372) and c:IsLocation(LOCATION_ONFIELD)
end
function s.confilter2(c)
	return c:IsCode(68540058) and c:IsLocation(LOCATION_SZONE)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end