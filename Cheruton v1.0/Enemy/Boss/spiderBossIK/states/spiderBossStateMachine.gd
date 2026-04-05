extends baseFSM

func onChangeState(state_name):
	print("spiderboss changing to ", state_name)
	super.onChangeState(state_name)
