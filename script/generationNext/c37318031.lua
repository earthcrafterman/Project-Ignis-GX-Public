--R－ライトジャスティス
--R - Righteous Heart
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3008)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,true,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
