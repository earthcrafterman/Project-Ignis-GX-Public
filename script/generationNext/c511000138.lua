--Dark Element
local s,id=GetID()
function s.initial_effect(c)
	--ritsp
	Ritual.AddProcGreaterCode(c,12,nil,511000137)
	--ritsp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(s.ritcon)
	e2:SetOperation(s.ritop)
	c:RegisterEffect(e2)
	--hsp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:IsCode(25833572) and c:IsAbleToRemove()
end
function s.rfilter(c,e,tp)
	return c:IsCode(511000137) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsType(TYPE_RITUAL)
end
s.listed_names={511000137,25833572,25955164,62340868,98434877}
function s.ritcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_GRAVE,0,1,nil) and
		Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
end
function s.ritop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	
	if rg and mg and #rg>0 and #mg>0 then
		rg:GetFirst():SetMaterial(mg)
		Duel.Remove(mg,POS_FACEUP,REASON_COST+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(rg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		rg:GetFirst():CompleteProcedure()
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.filter(c,e,tp)
	return (c:IsCode(25955164) or c:IsCode(62340868) or c:IsCode(98434877)) and 
		c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end