--ハーピィ・レディ－朱雀の陣－
--Harpie Lady Sparrow Formation
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end
s.listed_names={CARD_HARPIE_LADY}
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_HARPIE_LADY)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		and tp~=Duel.GetTurnPlayer()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a = Duel.GetAttacker()
	if a and Duel.Destroy(a,REASON_EFFECT) then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
