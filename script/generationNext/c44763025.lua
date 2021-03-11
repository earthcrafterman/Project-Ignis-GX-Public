--いたずら好きな双子悪魔
--Delinquent Duo
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFieldGroupCount(1-tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(1-tp,0,LOCATION_HAND)
	
	if #g1>0 and #g2>0 then
		local sg1=g1:RandomSelect(tp,1)
		local sg2=g2:RandomSelect(1-tp,1)
		
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		Duel.SendtoGrave(sg2,REASON_EFFECT+REASON_DISCARD)
		
		g1:RemoveCard(sg1:GetFirst())
		g2:RemoveCard(sg2:GetFirst())
		
		if #g1>0 and #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
			
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
			sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg2,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
