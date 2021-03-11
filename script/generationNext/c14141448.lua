--ラーバモス
--Great Moth
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,87756343,40240595)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.fuscon)
	e2:SetOperation(s.fusop)
	c:RegisterEffect(e2)
end
s.listed_names={48579379,40240595,CARD_METAMORPHOSIS}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.mfilter(c)
	return c:IsCode(40240595) and c:IsAbleToRemove()
end
function s.ffilter(c,e,tp)
	return c:IsCode(48579379) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_FUSION)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and
		Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.fusop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	mg:AddCard(e:GetHandler())
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fg=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	
	if fg and mg and #fg>0 and #mg>0 then
		fg:GetFirst():SetMaterial(mg)
		Duel.Remove(mg,POS_FACEUP,REASON_COST+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(fg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		fg:GetFirst():CompleteProcedure()
	end
end