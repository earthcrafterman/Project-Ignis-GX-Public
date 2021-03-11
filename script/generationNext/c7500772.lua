--イーグル・シャーク
--Eagle Shark
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetCondition(s.spcon)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
s.listed_names={70101178}
function s.filter(c)
	return c:IsFaceup() and c:IsCode(70101178)
end
function s.spcon(e,c)
	local tp=e:GetHandler():GetOwner()
	if c==nil then return true end
	return ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0) or
	(Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)))
end
