#Description: Makes registry A become active. B becomes inactive.
function regBankA(state)
	state.regbank = 0
end

#Description: Makes registry B become active. A becomes inactive.
function regBankB(state)
	state.regbank = 1
end
