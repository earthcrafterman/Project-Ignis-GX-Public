--エレキツネザル
--Wattlemur
local s,id=GetID()
function s.initial_effect(c)
	--Extra attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EXTRA_ATTACK)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--bp limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--attack limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(s.poscon)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
end
s.listed_series={0xe}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():IsPreviousControler(tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.con)
	e1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.con(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	if a and a:GetOwner()==tp and a:IsSetCard(0xe) then
		e:SetLabelObject(d)
		return d and d:IsRelateToBattle()
	end
	if d and d:GetOwner()==tp and d:IsSetCard(0xe) then
		e:SetLabelObject(a)
		return a and a:IsRelateToBattle()
	end
	return false
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return true end
	d:CreateEffectRelation(e)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		tc:RegisterEffect(e1,true)
	end
end

