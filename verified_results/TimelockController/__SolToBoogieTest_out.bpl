type Ref;
type ContractName;
const unique null: Ref;
const unique IERC20: ContractName;
const unique VeriSol: ContractName;
const unique SafeMath: ContractName;
const unique TimelockController: ContractName;
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
var M_Ref_bool: [Ref][Ref]bool;
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
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/Libraries/IERC20.sol"} {:sourceLine 7} (true);
call IERC20_IERC20_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

procedure {:public} {:inline 1} totalSupply_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);
procedure {:public} {:inline 1} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s311: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s320: Ref, amount_s320: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s329: Ref, spender_s329: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s338: Ref, amount_s338: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s349: Ref, recipient_s349: Ref, amount_s349: int) returns (__ret_0_: bool);
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
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 16} (true);
call SafeMath_SafeMath_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

procedure {:inline 1} add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s565: int, b_s565: int) returns (__ret_0_: int);
implementation add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s565: int, b_s565: int) returns (__ret_0_: int)
{
var c_s564: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s565);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s565);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 26} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 27} (true);
assume ((c_s564) >= (0));
assume ((a_s565) >= (0));
assume ((b_s565) >= (0));
assume (((a_s565) + (b_s565)) >= (0));
c_s564 := (a_s565) + (b_s565);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s564);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 28} (true);
assume ((c_s564) >= (0));
assume ((a_s565) >= (0));
assume ((c_s564) >= (a_s565));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 30} (true);
assume ((c_s564) >= (0));
__ret_0_ := c_s564;
return;
}

procedure {:inline 1} sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s590: int, b_s590: int) returns (__ret_0_: int);
implementation sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s590: int, b_s590: int) returns (__ret_0_: int)
{
var c_s589: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s590);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s590);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 42} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 43} (true);
assume ((b_s590) >= (0));
assume ((a_s590) >= (0));
assume ((b_s590) <= (a_s590));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 44} (true);
assume ((c_s589) >= (0));
assume ((a_s590) >= (0));
assume ((b_s590) >= (0));
assume (((a_s590) - (b_s590)) >= (0));
c_s589 := (a_s590) - (b_s590);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s589);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 46} (true);
assume ((c_s589) >= (0));
__ret_0_ := c_s589;
return;
}

procedure {:inline 1} mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s624: int, b_s624: int) returns (__ret_0_: int);
implementation mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s624: int, b_s624: int) returns (__ret_0_: int)
{
var c_s623: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s624);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s624);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 58} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 62} (true);
assume ((a_s624) >= (0));
if ((a_s624) == (0)) {
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 62} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 63} (true);
__ret_0_ := 0;
return;
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 66} (true);
assume ((c_s623) >= (0));
assume ((a_s624) >= (0));
assume ((b_s624) >= (0));
assume (((a_s624) * (b_s624)) >= (0));
c_s623 := (a_s624) * (b_s624);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s623);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 67} (true);
assume ((c_s623) >= (0));
assume ((a_s624) >= (0));
assume (((c_s623) div (a_s624)) >= (0));
assume ((b_s624) >= (0));
assume (((c_s623) div (a_s624)) == (b_s624));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 69} (true);
assume ((c_s623) >= (0));
__ret_0_ := c_s623;
return;
}

procedure {:inline 1} div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s649: int, b_s649: int) returns (__ret_0_: int);
implementation div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s649: int, b_s649: int) returns (__ret_0_: int)
{
var c_s648: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s649);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s649);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 83} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 85} (true);
assume ((b_s649) >= (0));
assume ((b_s649) > (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 86} (true);
assume ((c_s648) >= (0));
assume ((a_s649) >= (0));
assume ((b_s649) >= (0));
assume (((a_s649) div (b_s649)) >= (0));
c_s648 := (a_s649) div (b_s649);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s648);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 89} (true);
assume ((c_s648) >= (0));
__ret_0_ := c_s648;
return;
}

procedure {:inline 1} mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s670: int, b_s670: int) returns (__ret_0_: int);
implementation mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s670: int, b_s670: int) returns (__ret_0_: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s670);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s670);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 103} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 104} (true);
assume ((b_s670) >= (0));
assume ((b_s670) != (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 105} (true);
assume ((a_s670) >= (0));
assume ((b_s670) >= (0));
assume (((a_s670) mod (b_s670)) >= (0));
__ret_0_ := (a_s670) mod (b_s670);
return;
}

procedure {:inline 1} TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
var __var_1: Ref;
var __var_2: Ref;
var __var_3: Ref;
// start of initialization
assume ((msgsender_MSG) != (null));
Balance[this] := 0;
owner_TimelockController[this] := null;
startTime_TimelockController[this] := 0;
// Make array/mapping vars distinct for startingBalanceList
call __var_1 := FreshRefGenerator();
startingBalanceList_TimelockController[this] := __var_1;
// Initialize Integer mapping startingBalanceList
assume (forall  __i__0_0:Ref ::  ((M_Ref_int[startingBalanceList_TimelockController[this]][__i__0_0]) == (0)));
// Make array/mapping vars distinct for voteAddrList
call __var_2 := FreshRefGenerator();
voteAddrList_TimelockController[this] := __var_2;
assume ((Length[voteAddrList_TimelockController[this]]) == (0));
// Make array/mapping vars distinct for existingAddr
call __var_3 := FreshRefGenerator();
existingAddr_TimelockController[this] := __var_3;
// Initialize Boolean mapping existingAddr
assume (forall  __i__0_0:Ref ::  (!(M_Ref_bool[existingAddr_TimelockController[this]][__i__0_0])));
lockedFunds_TimelockController[this] := 0;
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
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 9} (true);
call IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
call TimelockController_TimelockController_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

var owner_TimelockController: [Ref]Ref;
var startTime_TimelockController: [Ref]int;
var startingBalanceList_TimelockController: [Ref]Ref;
var voteAddrList_TimelockController: [Ref]Ref;
var existingAddr_TimelockController: [Ref]Ref;
var lockedFunds_TimelockController: [Ref]int;
var votingToken_TimelockController: [Ref]Ref;
procedure {:inline 1} getStartingBalance_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, voter_s38: Ref) returns (__ret_0_: int);
implementation getStartingBalance_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, voter_s38: Ref) returns (__ret_0_: int)
{
var __var_4: int;
var __var_5: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "voter"} boogie_si_record_sol2Bpl_ref(voter_s38);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 19} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 20} (true);
assume ((__var_4) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_4 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_5, voter_s38);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_4 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_5, voter_s38);
} else {
assume (false);
}
assume ((__var_4) >= (0));
__ret_0_ := __var_4;
return;
}

procedure {:inline 1} findHighest_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: Ref);
implementation findHighest_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: Ref)
{
var highestProposal_s117: Ref;
var highestAmount_s117: int;
var balanceGap_s117: int;
var i_s105: int;
var __var_6: int;
var __var_7: int;
var __var_8: Ref;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 23} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 24} (true);
havoc highestProposal_s117;
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 25} (true);
havoc highestAmount_s117;
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 26} (true);
havoc balanceGap_s117;
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 28} (true);
assume ((highestAmount_s117) >= (0));
highestAmount_s117 := 0;
call  {:cexpr "highestAmount"} boogie_si_record_sol2Bpl_int(highestAmount_s117);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 29} (true);
assume ((i_s105) >= (0));
assume ((Length[voteAddrList_TimelockController[this]]) >= (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 29} (true);
assume ((i_s105) >= (0));
i_s105 := 0;
call  {:cexpr "i"} boogie_si_record_sol2Bpl_int(i_s105);
while ((i_s105) < (Length[voteAddrList_TimelockController[this]]))
{
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 29} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 30} (true);
assume ((balanceGap_s117) >= (0));
assume ((i_s105) >= (0));
assume ((M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]]) >= (0));
assume ((__var_6) >= (0));
assume ((i_s105) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_6 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_7, M_int_Ref[voteAddrList_TimelockController[this]][i_s105]);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_6 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_7, M_int_Ref[voteAddrList_TimelockController[this]][i_s105]);
} else {
assume (false);
}
assume ((__var_6) >= (0));
assume (((M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]]) - (__var_6)) >= (0));
balanceGap_s117 := (M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]]) - (__var_6);
call  {:cexpr "balanceGap"} boogie_si_record_sol2Bpl_int(balanceGap_s117);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 31} (true);
assume ((balanceGap_s117) >= (0));
assume ((balanceGap_s117) >= (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 32} (true);
assume ((balanceGap_s117) >= (0));
assume ((highestAmount_s117) >= (0));
if ((balanceGap_s117) > (highestAmount_s117)) {
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 32} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 33} (true);
assume ((highestAmount_s117) >= (0));
assume ((balanceGap_s117) >= (0));
highestAmount_s117 := balanceGap_s117;
call  {:cexpr "highestAmount"} boogie_si_record_sol2Bpl_int(highestAmount_s117);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 34} (true);
assume ((i_s105) >= (0));
highestProposal_s117 := M_int_Ref[voteAddrList_TimelockController[this]][i_s105];
call  {:cexpr "highestProposal"} boogie_si_record_sol2Bpl_ref(highestProposal_s117);
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 29} (true);
assume ((i_s105) >= (0));
i_s105 := (i_s105) + (1);
call  {:cexpr "i"} boogie_si_record_sol2Bpl_int(i_s105);
assume ((i_s105) >= (0));
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 37} (true);
__var_8 := null;
assume ((highestProposal_s117) != (null));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 38} (true);
__ret_0_ := highestProposal_s117;
return;
}

procedure {:public} {:inline 1} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
// ---- Logic for payable function START 
assume ((Balance[msgsender_MSG]) >= (msgvalue_MSG));
Balance[msgsender_MSG] := (Balance[msgsender_MSG]) - (msgvalue_MSG);
Balance[this] := (Balance[this]) + (msgvalue_MSG);
// ---- Logic for payable function END 
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 41} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 42} (true);
assume ((startTime_TimelockController[this]) >= (0));
assume ((startTime_TimelockController[this]) == (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 43} (true);
assume ((startTime_TimelockController[this]) >= (0));
assume ((now) >= (0));
startTime_TimelockController[this] := now;
call  {:cexpr "startTime"} boogie_si_record_sol2Bpl_int(startTime_TimelockController[this]);
}

procedure {:public} {:inline 1} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s199: int);
implementation execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s199: int)
{
var __var_9: int;
var __var_10: bool;
var __var_11: int;
var __var_12: Ref;
var __var_13: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "amount"} boogie_si_record_sol2Bpl_int(amount_s199);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
// ---- Logic for payable function START 
assume ((Balance[msgsender_MSG]) >= (msgvalue_MSG));
Balance[msgsender_MSG] := (Balance[msgsender_MSG]) - (msgvalue_MSG);
Balance[this] := (Balance[this]) + (msgvalue_MSG);
// ---- Logic for payable function END 
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 47} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 48} (true);
assume ((M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG]) != (true));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 49} (true);
assume ((startTime_TimelockController[this]) >= (0));
assume (((startTime_TimelockController[this]) + (((24) * (60)) * (60))) >= (0));
assume ((now) >= (0));
assume (((startTime_TimelockController[this]) + (((24) * (60)) * (60))) > (now));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 50} (true);
assume ((M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG]) >= (0));
call __var_9 := getStartingBalance_TimelockController(this, msgsender_MSG, msgvalue_MSG, msgsender_MSG);
M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG] := __var_9;
assume ((__var_9) >= (0));
call  {:cexpr "startingBalanceList[msg.sender]"} boogie_si_record_sol2Bpl_int(M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG]);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 51} (true);
__var_12 := this;
assume ((amount_s199) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_10 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_11, msgsender_MSG, this, amount_s199);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_10 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_11, msgsender_MSG, this, amount_s199);
} else {
assume (false);
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 52} (true);
__var_13 := Length[voteAddrList_TimelockController[this]];
M_int_Ref[voteAddrList_TimelockController[this]][__var_13] := msgsender_MSG;
Length[voteAddrList_TimelockController[this]] := (__var_13) + (1);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 53} (true);
M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG] := true;
call  {:cexpr "existingAddr[msg.sender]"} boogie_si_record_sol2Bpl_bool(M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG]);
}

procedure {:public} {:inline 1} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
var __var_14: int;
var __var_15: int;
var __var_16: Ref;
var __var_17: int;
var __var_18: int;
var __var_19: int;
var __var_20: int;
var __var_21: Ref;
var __var_22: int;
var __var_23: int;
var __var_24: Ref;
var __var_25: int;
var __var_26: int;
var __var_27: Ref;
var __var_28: Ref;
var __var_29: bool;
var __var_30: int;
var __var_31: bool;
var __var_32: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
// ---- Logic for payable function START 
assume ((Balance[msgsender_MSG]) >= (msgvalue_MSG));
Balance[msgsender_MSG] := (Balance[msgsender_MSG]) - (msgvalue_MSG);
Balance[this] := (Balance[this]) + (msgvalue_MSG);
// ---- Logic for payable function END 
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 56} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 57} (true);
assume ((startTime_TimelockController[this]) >= (0));
assume ((startTime_TimelockController[this]) != (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 58} (true);
assume ((startTime_TimelockController[this]) >= (0));
assume (((startTime_TimelockController[this]) + (((24) * (60)) * (60))) >= (0));
assume ((now) >= (0));
assume (((startTime_TimelockController[this]) + (((24) * (60)) * (60))) < (now));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 59} (true);
assume ((__var_14) >= (0));
__var_16 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_14 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_15, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_14 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_15, this);
} else {
assume (false);
}
assume ((__var_14) >= (0));
assume (((__var_14) * (2)) >= (0));
assume ((__var_17) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_17 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_18);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_17 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_18);
} else {
assume (false);
}
assume ((__var_17) >= (0));
assume (((__var_14) * (2)) > (__var_17));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 61} (true);
assume ((__var_19) >= (0));
__var_21 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_19 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_20, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_19 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_20, this);
} else {
assume (false);
}
assume ((__var_19) >= (0));
assume ((old(__var_19)) >= (0));
assume ((__var_22) >= (0));
__var_24 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_22 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_23, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_22 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_23, this);
} else {
assume (false);
}
assume ((__var_22) >= (0));
assert ((old(__var_19)) == (__var_22));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 62} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
__var_27 := this;
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_25 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_26, this);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_25 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_26, this);
} else {
assume (false);
}
lockedFunds_TimelockController[this] := __var_25;
assume ((__var_25) >= (0));
call  {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 63} (true);
call __var_28 := findHighest_TimelockController(this, msgsender_MSG, msgvalue_MSG);
owner_TimelockController[this] := __var_28;
call  {:cexpr "owner"} boogie_si_record_sol2Bpl_ref(owner_TimelockController[this]);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 64} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_29 := approve_IERC20(votingToken_TimelockController[this], this, __var_30, owner_TimelockController[this], lockedFunds_TimelockController[this]);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_29 := approve_IERC20(votingToken_TimelockController[this], this, __var_30, owner_TimelockController[this], lockedFunds_TimelockController[this]);
} else {
assume (false);
}
if ((__var_29) == (true)) {
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 64} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 65} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
if ((DType[votingToken_TimelockController[this]]) == (TimelockController)) {
call __var_31 := transfer_IERC20(votingToken_TimelockController[this], this, __var_32, owner_TimelockController[this], lockedFunds_TimelockController[this]);
} else if ((DType[votingToken_TimelockController[this]]) == (IERC20)) {
call __var_31 := transfer_IERC20(votingToken_TimelockController[this], this, __var_32, owner_TimelockController[this], lockedFunds_TimelockController[this]);
} else {
assume (false);
}
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 67} (true);
assume ((lockedFunds_TimelockController[this]) >= (0));
lockedFunds_TimelockController[this] := 0;
call  {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/timecontroller_fix_inv.sol"} {:sourceLine 68} (true);
Length[voteAddrList_TimelockController[this]] := 0;
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
var account_s311: Ref;
var __ret_0_balanceOf: int;
var recipient_s320: Ref;
var amount_s320: int;
var __ret_0_transfer: bool;
var owner_s329: Ref;
var spender_s329: Ref;
var __ret_0_allowance: int;
var spender_s338: Ref;
var amount_s338: int;
var __ret_0_approve: bool;
var sender_s349: Ref;
var recipient_s349: Ref;
var amount_s349: int;
var __ret_0_transferFrom: bool;
var amount_s199: int;
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
havoc account_s311;
havoc __ret_0_balanceOf;
havoc recipient_s320;
havoc amount_s320;
havoc __ret_0_transfer;
havoc owner_s329;
havoc spender_s329;
havoc __ret_0_allowance;
havoc spender_s338;
havoc amount_s338;
havoc __ret_0_approve;
havoc sender_s349;
havoc recipient_s349;
havoc amount_s349;
havoc __ret_0_transferFrom;
havoc amount_s199;
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
if ((choice) == (9)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (8)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s311);
} else if ((choice) == (7)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s320, amount_s320);
} else if ((choice) == (6)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s329, spender_s329);
} else if ((choice) == (5)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s338, amount_s338);
} else if ((choice) == (4)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s349, recipient_s349, amount_s349);
} else if ((choice) == (3)) {
call startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (2)) {
call execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s199);
} else if ((choice) == (1)) {
call endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
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
var account_s311: Ref;
var __ret_0_balanceOf: int;
var recipient_s320: Ref;
var amount_s320: int;
var __ret_0_transfer: bool;
var owner_s329: Ref;
var spender_s329: Ref;
var __ret_0_allowance: int;
var spender_s338: Ref;
var amount_s338: int;
var __ret_0_approve: bool;
var sender_s349: Ref;
var recipient_s349: Ref;
var amount_s349: int;
var __ret_0_transferFrom: bool;
var amount_s199: int;
var tmpNow: int;
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc __ret_0_totalSupply;
havoc account_s311;
havoc __ret_0_balanceOf;
havoc recipient_s320;
havoc amount_s320;
havoc __ret_0_transfer;
havoc owner_s329;
havoc spender_s329;
havoc __ret_0_allowance;
havoc spender_s338;
havoc amount_s338;
havoc __ret_0_approve;
havoc sender_s349;
havoc recipient_s349;
havoc amount_s349;
havoc __ret_0_transferFrom;
havoc amount_s199;
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
if ((choice) == (9)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (8)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s311);
} else if ((choice) == (7)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s320, amount_s320);
} else if ((choice) == (6)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s329, spender_s329);
} else if ((choice) == (5)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s338, amount_s338);
} else if ((choice) == (4)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s349, recipient_s349, amount_s349);
} else if ((choice) == (3)) {
call startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (2)) {
call execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s199);
} else if ((choice) == (1)) {
call endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
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


