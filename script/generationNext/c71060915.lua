--フェザー・ウィンド
--Feather Wind
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_names={21844576}
function s.sfilter(c,tp,e)
	return c:IsCode(21844576) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ffilter(c)
	return c:IsFaceup() and (c:IsCode(21844576) or 
		(c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,21844576)))
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local ef1 = Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil,tp,e)
	local ef2 = Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_ONFIELD,0,1,nil)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
	
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
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(s.sactivate)
	else
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
		
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
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
