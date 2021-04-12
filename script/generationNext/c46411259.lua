--突然変異
--Metamorphosis
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,c)
end
function s.filter2(c,lv,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:GetLevel()==lv and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and
		c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,id)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local lv=mg:GetFirst():GetLevel()
	if #mg > 0 then
		local fg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,mg:GetFirst())
		if #fg>0 then
			fg:GetFirst():SetMaterial(mg)
			Duel.SendtoGrave(mg,REASON_COST+REASON_MATERIAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(fg,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
			fg:GetFirst():CompleteProcedure()
		end
	end
end
