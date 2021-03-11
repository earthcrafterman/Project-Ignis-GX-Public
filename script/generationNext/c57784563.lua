--闇魔界の戦士長 ダークソード
--Dark Blade, Captain of Dark World
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(11321183)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.drcost)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_names={11321183}
function s.gfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.dfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_UNION)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(IsDiscardable,tp,LOCATION_HAND,0,1,nil)>0 and
		Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.gfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local dis=Duel.DiscardHand(tp,IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	local add=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if dis>0 and #add>0 then
		Duel.SendtoHand(add,tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,add:GetFirst())
		Duel.ShuffleHand(tp)
	end
end