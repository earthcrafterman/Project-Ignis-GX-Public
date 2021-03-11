--Burst Impact
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_names={58932615}
function s.hfilter(c)
	return c:IsCode(58932615) and c:IsAbleToHand()
end
function s.ffilter(c)
	return c:IsFaceup() and c:IsReleasable() and (c:IsCode(58932615) or (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,58932615)))
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	
	local ef1 = Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local ef2 = Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_MZONE,0,1,nil)
	
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
		
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(s.activate)
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
function s.dfilter(c)
	return c ~= Duel.GetFirstTarget()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local rg=Duel.SelectReleaseGroupCost(tp,s.ffilter,1,1,false,nil,nil)
	if #rg>0 and Duel.Release(rg,REASON_COST) then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
