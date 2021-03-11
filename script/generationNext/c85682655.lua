--ドリルロイド
--Wind-Up Juggler
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCountLimit(1)
	e1:SetTarget(s.targ)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk ==0 then	return (a and a==e:GetHandler() and d and d:IsFaceup()) or
		(d and d==e:GetHandler() and a and a:IsFaceup()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if (a and a:IsRelateToBattle() and d and e:GetHandler()==d) then
		Duel.Destroy(a,REASON_EFFECT)
	else (d and d:IsRelateToBattle() and a and e:GetHandler()==a)then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
