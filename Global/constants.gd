extends Node
class_name Constants


enum PlayerState {
	IDLE,
	RUNNING,
	TALKING,
	INAIR,
	ONLEDGE,
	THROWING,
	CLIMBING,
	FROZEN,
}

const PlayerStates = {
	PlayerState.IDLE : "Idle",
	PlayerState.RUNNING : "Running",
	PlayerState.TALKING : "Talking",
	PlayerState.INAIR : "InAir",
	PlayerState.ONLEDGE : "OnLedge",
	PlayerState.THROWING : "Throwing",
	PlayerState.CLIMBING : "Climbing",
	PlayerState.FROZEN : "Frozen",
}

const StringToPlayerStateLookup = {
	 "Idle" : PlayerState.IDLE,
	 "Running" : PlayerState.RUNNING,
	 "Talking" : PlayerState.TALKING,
	 "InAir" : PlayerState.INAIR,
	 "OnLedge" : PlayerState.ONLEDGE,
	 "Throwing" : PlayerState.THROWING,
	 "Climbing" : PlayerState.CLIMBING,
	 "Frozen" : PlayerState.FROZEN,
}

const PlayerStateToColorLookup := {
	PlayerState.IDLE : Color.WHITE,
	PlayerState.RUNNING : Color.DARK_ORANGE,
	PlayerState.TALKING : Color.HOT_PINK,
	PlayerState.INAIR : Color.CADET_BLUE,
	PlayerState.ONLEDGE : Color.CRIMSON,
	PlayerState.FROZEN : Color.CYAN,
}
