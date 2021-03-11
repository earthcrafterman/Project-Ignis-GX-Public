--迅雷の騎士ガイアドラグーン
--Gaia Dragon, the Thunder Charger
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,7,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--poschange
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(s.poscond)
	e4:SetCost(s.poscost)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and (rk==5 or rk==6)
end
function s.poscond(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and a:GetOwner() == e:GetHandler():GetOwner() and
		d and d:IsCanChangePosition() and d:IsCanBeEffectTarget(e)
end
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(Duel.GetAttackTarget(),POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end