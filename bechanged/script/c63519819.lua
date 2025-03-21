--サウザンド・アイズ・サクリファイス
function c63519819.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,64631466,27125110,true,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c63519819.hspcon)
	e0:SetTarget(c63519819.hsptg)
	e0:SetOperation(c63519819.hspop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63519819,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c63519819.eqtg)
	e1:SetOperation(c63519819.eqop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c63519819.antarget)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetCondition(c63519819.adcon)
	e4:SetValue(c63519819.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_DEFENSE)
	e5:SetCondition(c63519819.adcon)
	e5:SetValue(c63519819.defval)
	c:RegisterEffect(e5)
end
function c63519819.hspfilter(c,tp,sc)
	return c:GetOriginalCode()==27125110
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c63519819.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c63519819.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function c63519819.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c63519819.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c63519819.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function c63519819.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c63519819.can_equip_monster(c)
end
function c63519819.eqfilter(c)
	return c:GetFlagEffect(63519819)~=0
end
function c63519819.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c63519819.eqfilter,nil)
	return g:GetCount()==0
end
function c63519819.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c63519819.eqlimit(e,c)
	return e:GetOwner()==c
end
function c63519819.equip_monster(c,tp,tc)
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		Duel.SendtoGrave(tc,REASON_RULE)
		return
	end
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(63519819,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c63519819.eqlimit)
	tc:RegisterEffect(e1)
	--substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(c63519819.repval)
	tc:RegisterEffect(e2)
end
function c63519819.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		c63519819.equip_monster(c,tp,tc)
	end
end
function c63519819.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c63519819.antarget(e,c)
	return c~=e:GetHandler()
end
function c63519819.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c63519819.eqfilter,nil)
	return g:GetCount()>0
end
function c63519819.atkval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c63519819.eqfilter,nil)
	local atk=g:GetFirst():GetTextAttack()
	if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
		return 0
	else
		return atk
	end
end
function c63519819.defval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c63519819.eqfilter,nil)
	local def=g:GetFirst():GetTextDefense()
	if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or def<0 then
		return 0
	else
		return def
	end
end
