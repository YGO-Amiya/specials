--アポクリフォート・キラー
---@param c Card
function c27279764.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--tribute limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIBUTE_LIMIT)
	e2:SetValue(c27279764.tlimit)
	c:RegisterEffect(e2)
	--summon with 3 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27279764,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetCondition(c27279764.ttcon)
	e3:SetOperation(c27279764.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c27279764.immcon)
	e5:SetValue(c27279764.efilter)
	c:RegisterEffect(e5)
	--atk/def down
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c27279764.adtg)
	e6:SetValue(-500)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c27279764.tgtg)
	e8:SetOperation(c27279764.tgop)
	c:RegisterEffect(e8)
end
function c27279764.tlimit(e,c)
	return not c:IsSetCard(0xaa)
end
function c27279764.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c27279764.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c27279764.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c27279764.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return aux.qlifilter(e,te) end
end
function c27279764.adtg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c27279764.tgfilter(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c27279764.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return mc>0 or g and g:IsExists(c27279764.tgfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_HAND)
end
function c27279764.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if Duel.SendtoGrave(tc,REASON_RULE,1-tp)>0 and tc:IsLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetTarget(c27279764.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_MSET)
			Duel.RegisterEffect(e3,tp)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetValue(c27279764.aclimit)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c27279764.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c27279764.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end