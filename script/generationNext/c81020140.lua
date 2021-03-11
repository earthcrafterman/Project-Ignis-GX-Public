--ヴォルカニック・リボルバー
--Volcanic Blaster
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition2)
	e1:SetOperation(s.operation2)
	c:RegisterEffect(e1)
	--Top Deck
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_series={0x32}
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_EFFECT) and 
		not e:GetHandler():IsReason(REASON_RETURN)
end
function s.filter(c)
	return c:IsSetCard(0x32) and c:IsType(TYPE_MONSTER)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.ShuffleDeck(tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(g:GetFirst(),0)
		Duel.ConfirmDecktop(tp,1)
	end
end
