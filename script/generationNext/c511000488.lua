--Feather Storm
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_names={21844576}
function s.hfilter(c)
	return c:IsCode(21844576) and c:IsAbleToHand()
end
function s.ffilter(c)
	return c:IsFaceup() and (c:IsCode(21844576) or 
		(c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,21844576)))
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	
	local ef1 = Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local ef2 = Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_MZONE,0,1,nil) and
		Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	
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
		e:SetOperation(s.hactivate)
	else
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		
		e:SetOperation(s.operation)
	end
end
function s.hactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.hfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local atk=tc:GetBaseAttack()
		local def=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(def)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end
