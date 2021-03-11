--強奪
--Snatch Steal
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,1,Card.IsControlerCanBeChanged,s.eqlimit,s.cost,s.target)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_CONTROL)
	e4:SetValue(s.ctval)
	c:RegisterEffect(e4)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,aux.TRUE,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,aux.TRUE,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function s.target(e,tp,eg,ep,ev,re,r,rp,tc)
	e:SetCategory(CATEGORY_CONTROL+CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c and Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)==0 then
		Duel.Destroy(c,REASON_COST)
	end
end
function s.ctval(e,c)
	return e:GetHandlerPlayer()
end
