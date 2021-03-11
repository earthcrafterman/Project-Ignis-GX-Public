--平行世界融合
--Parallel World Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x3008),aux.FALSE,s.fextra,Fusion.ShuffleMaterial)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
end
