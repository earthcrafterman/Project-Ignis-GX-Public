--バブル・シャッフル
--Bubble Shuffle
local s,id=GetID()
function s.initial_effect(c)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.chtg)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
s.listed_names={79979666}
function s.hfilter(c)
	return c:IsCode(79979666) and c:IsAbleToHand()
end
function s.filter1(c,ft)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() and (ft>0 or c:GetSequence()<5)
		and (c:IsCode(79979666) or (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,79979666)))
end
function s.filter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.pfilter(c,e)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsRelateToEffect(e)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ef1 = Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local ef2 = ft>-1 and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	
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
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,ft)
		e:SetLabelObject(g1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g2=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(s.posop)
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
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.pfilter,nil,e)
	if #g==2 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		local tc=e:GetLabelObject()
		if not tc:IsImmuneToEffect(e) and tc:IsReleasable() and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:GetSequence()<5) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.Release(tc,REASON_EFFECT)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
