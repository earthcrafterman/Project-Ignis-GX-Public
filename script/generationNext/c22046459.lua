--巨大化
--Megamorph
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(s.condition)
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.condition2)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function s.condition(e)
	return Duel.GetLP(p)<Duel.GetLP(1-p)
end
function s.condition(e)
	return Duel.GetLP(p)>=Duel.GetLP(1-p)
end
