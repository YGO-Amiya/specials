--死神の巡遊
function c62784717.initial_effect(c)
	aux.AddCodeList(c,73206827)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62784717,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c62784717.coincon)
	e2:SetTarget(c62784717.cointg)
	e2:SetOperation(c62784717.coinop)
	c:RegisterEffect(e2)
end
c62784717.toss_coin=true
function c62784717.coincon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c62784717.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c62784717.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res
	if Duel.IsEnvironment(73206827,tp,LOCATION_FZONE) then
		local off=1
		local ops={}
		local opval={}
		if true then
			ops[off]=aux.Stringid(62784717,1)
			opval[off-1]=0
			off=off+1
		end
		if true then
			ops[off]=aux.Stringid(62784717,2)
			opval[off-1]=1
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		res=opval[op]
	else
		res=1-Duel.TossCoin(tp,1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	if res==1 then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c62784717.limcon)
	else
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(0,1)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c62784717.limcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
