extends Node
class_name Constants


enum PlayerState {
	IDLE,
	RUNNING,
	READYJUMP,
	SLIDING,
	TALKING,
	INAIR,
	ONLEDGE,
	CLIMBING,
	FROZEN,
}

const PlayerStates = {
	PlayerState.IDLE : "Idle",
	PlayerState.RUNNING : "Running",
	PlayerState.READYJUMP : "ReadyJump",
	PlayerState.SLIDING : "Sliding",
	PlayerState.TALKING : "Talking",
	PlayerState.INAIR : "InAir",
	PlayerState.ONLEDGE : "OnLedge",
	PlayerState.CLIMBING : "Climbing",
	PlayerState.FROZEN : "Frozen",
}

const StringToPlayerStateLookup = {
	 "Idle" : PlayerState.IDLE,
	 "Running" : PlayerState.RUNNING,
	 "ReadyJump" : PlayerState.READYJUMP,
	 "Sliding" : PlayerState.SLIDING,
	 "Talking" : PlayerState.TALKING,
	 "InAir" : PlayerState.INAIR,
	 "OnLedge" : PlayerState.ONLEDGE,
	 "Climbing" : PlayerState.CLIMBING,
	 "Frozen" : PlayerState.FROZEN,
}

const PlayerStateToColorLookup := {
	PlayerState.IDLE : Color.WHITE,
	PlayerState.RUNNING : Color.DARK_ORANGE,
	PlayerState.READYJUMP : Color.LIGHT_SALMON,
	PlayerState.SLIDING : Color.LIGHT_YELLOW,
	PlayerState.TALKING : Color.HOT_PINK,
	PlayerState.INAIR : Color.CADET_BLUE,
	PlayerState.ONLEDGE : Color.CRIMSON,
	PlayerState.CLIMBING : Color.SPRING_GREEN,
	PlayerState.FROZEN : Color.CYAN,
}
