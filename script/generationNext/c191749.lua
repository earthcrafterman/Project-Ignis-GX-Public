--ヒーローフラッシュ！！
--Hero Flash!!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
s.listed_names={74825788,213326,37318031,63703130}
function s.hfilter(c)
	return c:IsCode(74825788) or c:IsCode(213326) or c:IsCode(37318031) or c:IsCode(63703130) and c:IsAbleToHand()
end
function s.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  end
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	
	local ef1 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local ef2 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,74825788)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,213326)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,37318031)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,63703130)
	
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
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(s.activate)
	end
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsSetCard(0x3008)
end
function s.hactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	
	local g=Duel.SelectMatchingCard(tp,s.hfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,nil,74825788)
	local tc2=Duel.GetFirstMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,nil,213326)
	local tc3=Duel.GetFirstMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,nil,37318031)
	local tc4=Duel.GetFirstMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,nil,63703130)
	
	local g=Group.FromCards(tc1,tc2,tc3,tc4)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	
	local dg=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MZONE,0,nil)
	local tc=dg:GetFirst()
	
	for tc in aux.Next(dg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
