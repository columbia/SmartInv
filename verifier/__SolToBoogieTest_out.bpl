type Ref;
type ContractName;
const unique null: Ref;
const unique IERC20: ContractName;
const unique VeriSol: ContractName;
const unique SafeMath: ContractName;
const unique TimelockController: ContractName;
const unique TimelockController.Proposal: ContractName;
function ConstantToRef(x: int) returns (ret: Ref);
function BoogieRefToInt(x: Ref) returns (ret: int);
function {:bvbuiltin "mod"} modBpl(x: int, y: int) returns (ret: int);
function keccak256(x: int) returns (ret: int);
function abiEncodePacked1(x: int) returns (ret: int);
function _SumMapping_VeriSol(x: [Ref]int) returns (ret: int);
function abiEncodePacked2(x: int, y: int) returns (ret: int);
function abiEncodePacked1R(x: Ref) returns (ret: int);
function abiEncodePacked2R(x: Ref, y: int) returns (ret: int);
var Balance: [Ref]int;
var DType: [Ref]ContractName;
var Alloc: [Ref]bool;
var balance_ADDR: [Ref]int;
var M_Ref_int: [Ref][Ref]int;
var M_int_Ref: [Ref][int]Ref;
var Length: [Ref]int;
var now: int;
procedure {:inline 1} FreshRefGenerator() returns (newRef: Ref);
implementation FreshRefGenerator() returns (newRef: Ref)
{
havoc newRef;
assume ((Alloc[newRef]) == (false));
Alloc[newRef] := true;
assume ((newRef) != (null));
}

procedure {:inline 1} HavocAllocMany();
implementation HavocAllocMany()
{
var oldAlloc: [Ref]bool;
oldAlloc := Alloc;
havoc Alloc;
assume (forall  __i__0_0:Ref ::  ((oldAlloc[__i__0_0]) ==> (Alloc[__i__0_0])));
}

procedure boogie_si_record_sol2Bpl_int(x: int);
procedure boogie_si_record_sol2Bpl_ref(x: Ref);
procedure boogie_si_record_sol2Bpl_bool(x: bool);
procedure {:inline 1} TimelockController.Proposal_ctor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sTime: int, newOwner: Ref);
implementation TimelockController.Proposal_ctor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sTime: int, newOwner: Ref)
{
sTime_TimelockController.Proposal[this] := sTime;
newOwner_TimelockController.Proposal[this] := newOwner;
}


axiom(forall  __i__0_0:int, __i__0_1:int :: {ConstantToRef(__i__0_0), ConstantToRef(__i__0_1)} (((__i__0_0) == (__i__0_1)) || ((ConstantToRef(__i__0_0)) != (ConstantToRef(__i__0_1)))));

axiom(forall  __i__0_0:int, __i__0_1:int :: {keccak256(__i__0_0), keccak256(__i__0_1)} (((__i__0_0) == (__i__0_1)) || ((keccak256(__i__0_0)) != (keccak256(__i__0_1)))));

axiom(forall  __i__0_0:int, __i__0_1:int :: {abiEncodePacked1(__i__0_0), abiEncodePacked1(__i__0_1)} (((__i__0_0) == (__i__0_1)) || ((abiEncodePacked1(__i__0_0)) != (abiEncodePacked1(__i__0_1)))));

axiom(forall  __i__0_0:[Ref]int ::  ((exists __i__0_1:Ref ::  ((__i__0_0[__i__0_1]) != (0))) || ((_SumMapping_VeriSol(__i__0_0)) == (0))));

axiom(forall  __i__0_0:[Ref]int, __i__0_1:Ref, __i__0_2:int ::  ((_SumMapping_VeriSol(__i__0_0[__i__0_1 := __i__0_2])) == (((_SumMapping_VeriSol(__i__0_0)) - (__i__0_0[__i__0_1])) + (__i__0_2))));

axiom(forall  __i__0_0:int, __i__0_1:int, __i__1_0:int, __i__1_1:int :: {abiEncodePacked2(__i__0_0, __i__1_0), abiEncodePacked2(__i__0_1, __i__1_1)} ((((__i__0_0) == (__i__0_1)) && ((__i__1_0) == (__i__1_1))) || ((abiEncodePacked2(__i__0_0, __i__1_0)) != (abiEncodePacked2(__i__0_1, __i__1_1)))));

axiom(forall  __i__0_0:Ref, __i__0_1:Ref :: {abiEncodePacked1R(__i__0_0), abiEncodePacked1R(__i__0_1)} (((__i__0_0) == (__i__0_1)) || ((abiEncodePacked1R(__i__0_0)) != (abiEncodePacked1R(__i__0_1)))));

axiom(forall  __i__0_0:Ref, __i__0_1:Ref, __i__1_0:int, __i__1_1:int :: {abiEncodePacked2R(__i__0_0, __i__1_0), abiEncodePacked2R(__i__0_1, __i__1_1)} ((((__i__0_0) == (__i__0_1)) && ((__i__1_0) == (__i__1_1))) || ((abiEncodePacked2R(__i__0_0, __i__1_0)) != (abiEncodePacked2R(__i__0_1, __i__1_1)))));
procedure {:inline 1} IERC20_IERC20_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation IERC20_IERC20_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
// start of initialization
assume ((msgsender_MSG) != (null));
Balance[this] := 0;
// end of initialization
}

procedure {:inline 1} IERC20_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation IERC20_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./Libraries/IERC20.sol"} {:sourceLine 7} (true);
call IERC20_IERC20_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

procedure {:public} {:inline 1} totalSupply_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);
procedure {:public} {:inline 1} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s161: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s170: Ref, amount_s170: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s179: Ref, spender_s179: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s188: Ref, amount_s188: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s199: Ref, recipient_s199: Ref, amount_s199: int) returns (__ret_0_: bool);
procedure {:inline 1} SafeMath_SafeMath_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation SafeMath_SafeMath_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
// start of initialization
assume ((msgsender_MSG) != (null));
Balance[this] := 0;
// end of initialization
}

procedure {:inline 1} SafeMath_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation SafeMath_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 16} (true);
call SafeMath_SafeMath_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

procedure {:inline 1} add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s415: int, b_s415: int) returns (__ret_0_: int);
implementation add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s415: int, b_s415: int) returns (__ret_0_: int)
{
var c_s414: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s415);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s415);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 26} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 27} (true);
assume ((c_s414) >= (0));
assume ((a_s415) >= (0));
assume ((b_s415) >= (0));
assume (((a_s415) + (b_s415)) >= (0));
c_s414 := (a_s415) + (b_s415);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s414);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 28} (true);
assume ((c_s414) >= (0));
assume ((a_s415) >= (0));
assume ((c_s414) >= (a_s415));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 30} (true);
assume ((c_s414) >= (0));
__ret_0_ := c_s414;
return;
}

procedure {:inline 1} sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s440: int, b_s440: int) returns (__ret_0_: int);
implementation sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s440: int, b_s440: int) returns (__ret_0_: int)
{
var c_s439: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s440);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s440);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 42} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 43} (true);
assume ((b_s440) >= (0));
assume ((a_s440) >= (0));
assume ((b_s440) <= (a_s440));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 44} (true);
assume ((c_s439) >= (0));
assume ((a_s440) >= (0));
assume ((b_s440) >= (0));
assume (((a_s440) - (b_s440)) >= (0));
c_s439 := (a_s440) - (b_s440);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s439);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 46} (true);
assume ((c_s439) >= (0));
__ret_0_ := c_s439;
return;
}

procedure {:inline 1} mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s474: int, b_s474: int) returns (__ret_0_: int);
implementation mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s474: int, b_s474: int) returns (__ret_0_: int)
{
var c_s473: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s474);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s474);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 58} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 62} (true);
assume ((a_s474) >= (0));
if ((a_s474) == (0)) {
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 62} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 63} (true);
__ret_0_ := 0;
return;
}
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 66} (true);
assume ((c_s473) >= (0));
assume ((a_s474) >= (0));
assume ((b_s474) >= (0));
assume (((a_s474) * (b_s474)) >= (0));
c_s473 := (a_s474) * (b_s474);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s473);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 67} (true);
assume ((c_s473) >= (0));
assume ((a_s474) >= (0));
assume (((c_s473) div (a_s474)) >= (0));
assume ((b_s474) >= (0));
assume (((c_s473) div (a_s474)) == (b_s474));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 69} (true);
assume ((c_s473) >= (0));
__ret_0_ := c_s473;
return;
}

procedure {:inline 1} div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s499: int, b_s499: int) returns (__ret_0_: int);
implementation div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s499: int, b_s499: int) returns (__ret_0_: int)
{
var c_s498: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s499);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s499);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 83} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 85} (true);
assume ((b_s499) >= (0));
assume ((b_s499) > (0));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 86} (true);
assume ((c_s498) >= (0));
assume ((a_s499) >= (0));
assume ((b_s499) >= (0));
assume (((a_s499) div (b_s499)) >= (0));
c_s498 := (a_s499) div (b_s499);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s498);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 89} (true);
assume ((c_s498) >= (0));
__ret_0_ := c_s498;
return;
}

procedure {:inline 1} mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s520: int, b_s520: int) returns (__ret_0_: int);
implementation mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s520: int, b_s520: int) returns (__ret_0_: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s520);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s520);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 103} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 104} (true);
assume ((b_s520) >= (0));
assume ((b_s520) != (0));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./SafeMath.sol"} {:sourceLine 105} (true);
assume ((a_s520) >= (0));
assume ((b_s520) >= (0));
assume (((a_s520) mod (b_s520)) >= (0));
__ret_0_ := (a_s520) mod (b_s520);
return;
}

procedure {:inline 1} TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
var __var_1: Ref;
// start of initialization
assume ((msgsender_MSG) != (null));
Balance[this] := 0;
owner_TimelockController[this] := null;
lockedFunds_TimelockController[this] := 0;
// Make struct variables distinct for proposal
call __var_1 := FreshRefGenerator();
proposal_TimelockController[this] := __var_1;
// end of initialization
}

procedure {:inline 1} TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 8} (true);
call IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
call TimelockController_TimelockController_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

var sTime_TimelockController.Proposal: [Ref]int;
var newOwner_TimelockController.Proposal: [Ref]Ref;
var owner_TimelockController: [Ref]Ref;
var votingToken_TimelockController: [Ref]Ref;
var lockedFunds_TimelockController: [Ref]int;
var proposal_TimelockController: [Ref]Ref;
procedure {:public} {:inline 1} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
var __var_2: Ref;
var __var_3: Ref;
var __var_4: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 19} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 20} (true);
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) >= (0));
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) == (0));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 21} (true);
call __var_3 := FreshRefGenerator();
assume ((now) >= (0));
assume ((DType[__var_3]) == (TimelockController.Proposal));
call TimelockController.Proposal_ctor(__var_3, this, 0, now, msgsender_MSG);
__var_2 := __var_3;
proposal_TimelockController[this] := __var_2;
}

procedure {:public} {:inline 1} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s72: int);
implementation execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s72: int)
{
var __var_5: bool;
var __var_6: int;
var __var_7: Ref;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "amount"} boogie_si_record_sol2Bpl_int(amount_s72);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 24} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 25} (true);
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) >= (0));
assume (((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) + (24)) >= (0));
assume ((now) >= (0));
assume (((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) + (24)) > (now));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 26} (true);
__var_7 := this;
assume ((amount_s72) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_5 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_6, msgsender_MSG, this, amount_s72);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_5 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_6, msgsender_MSG, this, amount_s72);
} else {
assume (false);
}
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 27} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
assume ((amount_s72) >= (0));
lockedFunds_TimelockController[this] := (lockedFunds_TimelockController[this]) + (amount_s72);
call  {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
}

procedure {:public} {:inline 1} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
var __var_8: int;
var __var_9: int;
var __var_10: Ref;
var __var_11: int;
var __var_12: int;
var __var_13: int;
var __var_14: int;
var __var_15: Ref;
var __var_16: int;
var __var_17: int;
var __var_18: Ref;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 29} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 30} (true);
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) >= (0));
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) != (0));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 31} (true);
assume ((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) >= (0));
assume (((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) + (24)) >= (0));
assume ((now) >= (0));
assume (((sTime_TimelockController.Proposal[proposal_TimelockController[this]]) + (24)) < (now));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 32} (true);
assume ((__var_8) >= (0));
__var_10 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_8 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_9, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_8 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_9, this);
} else {
assume (false);
}
assume ((__var_8) >= (0));
assume (((__var_8) * (2)) >= (0));
assume ((__var_11) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_11 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_12);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_11 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_12);
} else {
assume (false);
}
assume ((__var_11) >= (0));
assume (((__var_8) * (2)) > (__var_11));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 34} (true);
assume ((__var_13) >= (0));
__var_15 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_13 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_14, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_13 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_14, this);
} else {
assume (false);
}
assume ((__var_13) >= (0));
assume ((old(__var_13)) >= (0));
assume ((__var_16) >= (0));
__var_18 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_16 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_17, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_16 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_17, this);
} else {
assume (false);
}
assume ((__var_16) >= (0));
assert ((old(__var_13)) == (__var_16));
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 35} (true);
owner_TimelockController[this] := newOwner_TimelockController.Proposal[proposal_TimelockController[this]];
call  {:cexpr "owner"} boogie_si_record_sol2Bpl_ref(owner_TimelockController[this]);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 36} (true);
}

procedure {:public} {:inline 1} rewardFunds_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);
implementation rewardFunds_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 38} (true);
assert {:first} {:sourceFile "/home/jw4074/SmartInv/verifier/./timecontroller.sol"} {:sourceLine 39} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
__ret_0_ := lockedFunds_TimelockController[this];
return;
}

procedure {:inline 1} FallbackDispatch(from: Ref, to: Ref, amount: int);
implementation FallbackDispatch(from: Ref, to: Ref, amount: int)
{
if ((DType[to]) == (TimelockController)) {
assume ((amount) == (0));
} else if ((DType[to]) == (IERC20)) {
assume ((amount) == (0));
} else {
call Fallback_UnknownType(from, to, amount);
}
}

procedure {:inline 1} Fallback_UnknownType(from: Ref, to: Ref, amount: int);
implementation Fallback_UnknownType(from: Ref, to: Ref, amount: int)
{
// ---- Logic for payable function START 
assume ((Balance[from]) >= (amount));
Balance[from] := (Balance[from]) - (amount);
Balance[to] := (Balance[to]) + (amount);
// ---- Logic for payable function END 
}

procedure {:inline 1} send(from: Ref, to: Ref, amount: int) returns (success: bool);
implementation send(from: Ref, to: Ref, amount: int) returns (success: bool)
{
if ((Balance[from]) >= (amount)) {
call FallbackDispatch(from, to, amount);
success := true;
} else {
success := false;
}
}

procedure BoogieEntry_IERC20();
implementation BoogieEntry_IERC20()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var tmpNow: int;
assume ((now) >= (0));
assume (((DType[this]) == (IERC20)) || ((DType[this]) == (TimelockController)));
call IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
}
}

procedure BoogieEntry_SafeMath();
implementation BoogieEntry_SafeMath()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var tmpNow: int;
assume ((now) >= (0));
assume ((DType[this]) == (SafeMath));
call SafeMath_SafeMath(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
}
}

const {:existential true} HoudiniB1_TimelockController: bool;
const {:existential true} HoudiniB2_TimelockController: bool;
procedure BoogieEntry_TimelockController();
implementation BoogieEntry_TimelockController()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var __ret_0_totalSupply: int;
var account_s161: Ref;
var __ret_0_balanceOf: int;
var recipient_s170: Ref;
var amount_s170: int;
var __ret_0_transfer: bool;
var owner_s179: Ref;
var spender_s179: Ref;
var __ret_0_allowance: int;
var spender_s188: Ref;
var amount_s188: int;
var __ret_0_approve: bool;
var sender_s199: Ref;
var recipient_s199: Ref;
var amount_s199: int;
var __ret_0_transferFrom: bool;
var amount_s72: int;
var __ret_0_rewardFunds: int;
var tmpNow: int;
assume ((now) >= (0));
assume ((DType[this]) == (TimelockController));
call TimelockController_TimelockController(this, msgsender_MSG, msgvalue_MSG);
while (true)
  invariant (HoudiniB1_TimelockController) ==> ((owner_TimelockController[this]) == (null));
  invariant (HoudiniB2_TimelockController) ==> ((owner_TimelockController[this]) != (null));
{
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc __ret_0_totalSupply;
havoc account_s161;
havoc __ret_0_balanceOf;
havoc recipient_s170;
havoc amount_s170;
havoc __ret_0_transfer;
havoc owner_s179;
havoc spender_s179;
havoc __ret_0_allowance;
havoc spender_s188;
havoc amount_s188;
havoc __ret_0_approve;
havoc sender_s199;
havoc recipient_s199;
havoc amount_s199;
havoc __ret_0_transferFrom;
havoc amount_s72;
havoc __ret_0_rewardFunds;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
if ((choice) == (10)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (9)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s161);
} else if ((choice) == (8)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s170, amount_s170);
} else if ((choice) == (7)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s179, spender_s179);
} else if ((choice) == (6)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s188, amount_s188);
} else if ((choice) == (5)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s199, recipient_s199, amount_s199);
} else if ((choice) == (4)) {
call startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (3)) {
call execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s72);
} else if ((choice) == (2)) {
call endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (1)) {
call __ret_0_rewardFunds := rewardFunds_TimelockController(this, msgsender_MSG, msgvalue_MSG);
}
}
}

procedure CorralChoice_IERC20(this: Ref);
implementation CorralChoice_IERC20(this: Ref)
{
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var tmpNow: int;
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
}

procedure CorralEntry_IERC20();
implementation CorralEntry_IERC20()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
call this := FreshRefGenerator();
assume ((now) >= (0));
assume (((DType[this]) == (IERC20)) || ((DType[this]) == (TimelockController)));
call IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
call CorralChoice_IERC20(this);
}
}

procedure CorralChoice_SafeMath(this: Ref);
implementation CorralChoice_SafeMath(this: Ref)
{
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var tmpNow: int;
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
}

procedure CorralEntry_SafeMath();
implementation CorralEntry_SafeMath()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
call this := FreshRefGenerator();
assume ((now) >= (0));
assume ((DType[this]) == (SafeMath));
call SafeMath_SafeMath(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
call CorralChoice_SafeMath(this);
}
}

procedure CorralChoice_TimelockController(this: Ref);
implementation CorralChoice_TimelockController(this: Ref)
{
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var __ret_0_totalSupply: int;
var account_s161: Ref;
var __ret_0_balanceOf: int;
var recipient_s170: Ref;
var amount_s170: int;
var __ret_0_transfer: bool;
var owner_s179: Ref;
var spender_s179: Ref;
var __ret_0_allowance: int;
var spender_s188: Ref;
var amount_s188: int;
var __ret_0_approve: bool;
var sender_s199: Ref;
var recipient_s199: Ref;
var amount_s199: int;
var __ret_0_transferFrom: bool;
var amount_s72: int;
var __ret_0_rewardFunds: int;
var tmpNow: int;
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc __ret_0_totalSupply;
havoc account_s161;
havoc __ret_0_balanceOf;
havoc recipient_s170;
havoc amount_s170;
havoc __ret_0_transfer;
havoc owner_s179;
havoc spender_s179;
havoc __ret_0_allowance;
havoc spender_s188;
havoc amount_s188;
havoc __ret_0_approve;
havoc sender_s199;
havoc recipient_s199;
havoc amount_s199;
havoc __ret_0_transferFrom;
havoc amount_s72;
havoc __ret_0_rewardFunds;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (TimelockController));
Alloc[msgsender_MSG] := true;
if ((choice) == (10)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (9)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s161);
} else if ((choice) == (8)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s170, amount_s170);
} else if ((choice) == (7)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s179, spender_s179);
} else if ((choice) == (6)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s188, amount_s188);
} else if ((choice) == (5)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s199, recipient_s199, amount_s199);
} else if ((choice) == (4)) {
call startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (3)) {
call execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s72);
} else if ((choice) == (2)) {
call endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (1)) {
call __ret_0_rewardFunds := rewardFunds_TimelockController(this, msgsender_MSG, msgvalue_MSG);
}
}

procedure CorralEntry_TimelockController();
implementation CorralEntry_TimelockController()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
call this := FreshRefGenerator();
assume ((now) >= (0));
assume ((DType[this]) == (TimelockController));
call TimelockController_TimelockController(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
call CorralChoice_TimelockController(this);
}
}


