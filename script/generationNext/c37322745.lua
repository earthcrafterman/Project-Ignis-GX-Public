--ナチュルの森
--Naturia Forest
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsRace(RACE_BEAST+RACE_INSECT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.gfilter(c)
	return c:IsSetCard(RACE_BEAST+RACE_INSECT) and c:IsReason(REASON_COST) and c:IsType(TYPE_MONSTER) and
		c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return eg:IsExists(s.gfilter,1,nil) and re and rc:IsType(TYPE_MONSTER) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=eg:Filter(s.gfilter,nil):IsExists(Card.IsControler,1,nil,tp)
		local e2=eg:Filter(s.gfilter,nil):IsExists(Card.IsControler,1,nil,1-tp)
		return (e1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)) or
			(e2 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_DECK,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=eg:Filter(s.gfilter,nil):IsExists(Card.IsControler,1,nil,tp)
	local e2=eg:Filter(s.gfilter,nil):IsExists(Card.IsControler,1,nil,1-tp)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if e1 then
		local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g1>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
	if e2 then
		local g2=Duel.SelectMatchingCard(tp,s.filter,1-tp,0,LOCATION_DECK,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g2)
		end
	end
end
