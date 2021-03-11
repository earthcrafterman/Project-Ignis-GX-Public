--バブルイリュージョン
--Bubble Illusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_names={79979666}
function s.hfilter(c)
	return c:IsCode(79979666) and c:IsAbleToHand()
end
function s.filter(c)
	return c:IsFaceup() and (c:IsCode(79979666) or (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,79979666)))
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
	local ef1 = Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local ef2 = Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	
	if chk==0 then return ef1 or ef2 end
	
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	
	if ef1 and ef2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif ef1 then
		Duel.SelectOption(tp,aux.Stringid(id,0))
		op=0
	elseif ef2 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=1
	else
		return
	end
	
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(s.sactivate)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(s.activate)
	end
end
function s.sactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,1,1,nil,tp,e)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1,id)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
