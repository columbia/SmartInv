type Ref;
type ContractName;
const unique null: Ref;
const unique IERC20: ContractName;
const unique VeriSol: ContractName;
const unique SafeMath: ContractName;
const unique simplifiedVisor: ContractName;
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
procedure {:public} {:inline 1} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s91: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s100: Ref, amount_s100: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s109: Ref, spender_s109: Ref) returns (__ret_0_: int);
procedure {:public} {:inline 1} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s118: Ref, amount_s118: int) returns (__ret_0_: bool);
procedure {:public} {:inline 1} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s129: Ref, recipient_s129: Ref, amount_s129: int) returns (__ret_0_: bool);
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

procedure {:inline 1} add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s345: int, b_s345: int) returns (__ret_0_: int);
implementation add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s345: int, b_s345: int) returns (__ret_0_: int)
{
var c_s344: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s345);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s345);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 26} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 27} (true);
assume ((c_s344) >= (0));
assume ((a_s345) >= (0));
assume ((b_s345) >= (0));
assume (((a_s345) + (b_s345)) >= (0));
c_s344 := (a_s345) + (b_s345);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s344);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 28} (true);
assume ((c_s344) >= (0));
assume ((a_s345) >= (0));
assume ((c_s344) >= (a_s345));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 30} (true);
assume ((c_s344) >= (0));
__ret_0_ := c_s344;
return;
}

procedure {:inline 1} sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s370: int, b_s370: int) returns (__ret_0_: int);
implementation sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s370: int, b_s370: int) returns (__ret_0_: int)
{
var c_s369: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s370);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s370);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 42} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 43} (true);
assume ((b_s370) >= (0));
assume ((a_s370) >= (0));
assume ((b_s370) <= (a_s370));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 44} (true);
assume ((c_s369) >= (0));
assume ((a_s370) >= (0));
assume ((b_s370) >= (0));
assume (((a_s370) - (b_s370)) >= (0));
c_s369 := (a_s370) - (b_s370);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s369);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 46} (true);
assume ((c_s369) >= (0));
__ret_0_ := c_s369;
return;
}

procedure {:inline 1} mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s404: int, b_s404: int) returns (__ret_0_: int);
implementation mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s404: int, b_s404: int) returns (__ret_0_: int)
{
var c_s403: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s404);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s404);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 58} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 62} (true);
assume ((a_s404) >= (0));
if ((a_s404) == (0)) {
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 62} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 63} (true);
__ret_0_ := 0;
return;
}
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 66} (true);
assume ((c_s403) >= (0));
assume ((a_s404) >= (0));
assume ((b_s404) >= (0));
assume (((a_s404) * (b_s404)) >= (0));
c_s403 := (a_s404) * (b_s404);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s403);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 67} (true);
assume ((c_s403) >= (0));
assume ((a_s404) >= (0));
assume (((c_s403) div (a_s404)) >= (0));
assume ((b_s404) >= (0));
assume (((c_s403) div (a_s404)) == (b_s404));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 69} (true);
assume ((c_s403) >= (0));
__ret_0_ := c_s403;
return;
}

procedure {:inline 1} div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s429: int, b_s429: int) returns (__ret_0_: int);
implementation div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s429: int, b_s429: int) returns (__ret_0_: int)
{
var c_s428: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s429);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s429);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 83} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 85} (true);
assume ((b_s429) >= (0));
assume ((b_s429) > (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 86} (true);
assume ((c_s428) >= (0));
assume ((a_s429) >= (0));
assume ((b_s429) >= (0));
assume (((a_s429) div (b_s429)) >= (0));
c_s428 := (a_s429) div (b_s429);
call  {:cexpr "c"} boogie_si_record_sol2Bpl_int(c_s428);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 89} (true);
assume ((c_s428) >= (0));
__ret_0_ := c_s428;
return;
}

procedure {:inline 1} mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s450: int, b_s450: int) returns (__ret_0_: int);
implementation mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s450: int, b_s450: int) returns (__ret_0_: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "a"} boogie_si_record_sol2Bpl_int(a_s450);
call  {:cexpr "b"} boogie_si_record_sol2Bpl_int(b_s450);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 103} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 104} (true);
assume ((b_s450) >= (0));
assume ((b_s450) != (0));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/SafeMath.sol"} {:sourceLine 105} (true);
assume ((a_s450) >= (0));
assume ((b_s450) >= (0));
assume (((a_s450) mod (b_s450)) >= (0));
__ret_0_ := (a_s450) mod (b_s450);
return;
}

procedure {:inline 1} simplifiedVisor_simplifiedVisor_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation simplifiedVisor_simplifiedVisor_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
// start of initialization
assume ((msgsender_MSG) != (null));
Balance[this] := 0;
to_simplifiedVisor[this] := null;
ceil_simplifiedVisor[this] := 0;
price_simplifiedVisor[this] := 0;
// end of initialization
}

procedure {:inline 1} simplifiedVisor_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
implementation simplifiedVisor_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 9} (true);
call IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
call simplifiedVisor_simplifiedVisor_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
}

var myToken_simplifiedVisor: [Ref]Ref;
var token0_simplifiedVisor: [Ref]Ref;
var token1_simplifiedVisor: [Ref]Ref;
var to_simplifiedVisor: [Ref]Ref;
var ceil_simplifiedVisor: [Ref]int;
var price_simplifiedVisor: [Ref]int;
procedure {:public} {:inline 1} liquidate_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, ceil_s52: int);
implementation liquidate_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, ceil_s52: int)
{
var tokenPrice_s51: int;
var __var_1: bool;
var __var_2: int;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "ceil"} boogie_si_record_sol2Bpl_int(ceil_s52);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 18} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 19} (true);
assume ((tokenPrice_s51) >= (0));
call tokenPrice_s51 := getPrice_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
tokenPrice_s51 := tokenPrice_s51;
call  {:cexpr "tokenPrice"} boogie_si_record_sol2Bpl_int(tokenPrice_s51);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 20} (true);
assume ((tokenPrice_s51) >= (0));
assume ((price_simplifiedVisor[this]) >= (0));
assume ((old(price_simplifiedVisor[this])) >= (0));
assume (((2) * (old(price_simplifiedVisor[this]))) >= (0));
assert ((tokenPrice_s51) <= ((2) * (old(price_simplifiedVisor[this]))));
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 21} (true);
assume ((tokenPrice_s51) >= (0));
assume ((ceil_s52) >= (0));
if ((tokenPrice_s51) >= (ceil_s52)) {
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 21} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 22} (true);
if ((DType[myToken_simplifiedVisor[this]]) == (simplifiedVisor)) {
call __var_1 := transfer_IERC20(myToken_simplifiedVisor[this], this, __var_2, to_simplifiedVisor[this], 30);
} else if ((DType[myToken_simplifiedVisor[this]]) == (IERC20)) {
call __var_1 := transfer_IERC20(myToken_simplifiedVisor[this], this, __var_2, to_simplifiedVisor[this], 30);
} else {
assume (false);
}
}
}

procedure {:public} {:inline 1} getPrice_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);
implementation getPrice_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int)
{
var price_s75: int;
var __var_3: int;
var __var_4: int;
var __var_5: Ref;
var __var_6: int;
var __var_7: int;
var __var_8: Ref;
call  {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
call  {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
call  {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
call  {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
call  {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 26} (true);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 27} (true);
assume ((price_s75) >= (0));
assume ((__var_3) >= (0));
__var_5 := this;
if ((DType[token0_simplifiedVisor[this]]) == (simplifiedVisor)) {
call __var_3 := balanceOf_IERC20(token0_simplifiedVisor[this], this, __var_4, this);
} else if ((DType[token0_simplifiedVisor[this]]) == (IERC20)) {
call __var_3 := balanceOf_IERC20(token0_simplifiedVisor[this], this, __var_4, this);
} else {
assume (false);
}
assume ((__var_3) >= (0));
assume ((__var_6) >= (0));
__var_8 := this;
if ((DType[token1_simplifiedVisor[this]]) == (simplifiedVisor)) {
call __var_6 := balanceOf_IERC20(token1_simplifiedVisor[this], this, __var_7, this);
} else if ((DType[token1_simplifiedVisor[this]]) == (IERC20)) {
call __var_6 := balanceOf_IERC20(token1_simplifiedVisor[this], this, __var_7, this);
} else {
assume (false);
}
assume ((__var_6) >= (0));
assume (((__var_3) div (__var_6)) >= (0));
price_s75 := (__var_3) div (__var_6);
call  {:cexpr "price"} boogie_si_record_sol2Bpl_int(price_s75);
assert {:first} {:sourceFile "/home/sallyjunsongwang/SmartInv/verifier/visor.sol"} {:sourceLine 28} (true);
assume ((price_s75) >= (0));
__ret_0_ := price_s75;
return;
}

procedure {:inline 1} FallbackDispatch(from: Ref, to: Ref, amount: int);
implementation FallbackDispatch(from: Ref, to: Ref, amount: int)
{
if ((DType[to]) == (simplifiedVisor)) {
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
assume (((DType[this]) == (IERC20)) || ((DType[this]) == (simplifiedVisor)));
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
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
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
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
Alloc[msgsender_MSG] := true;
}
}

const {:existential true} HoudiniB1_simplifiedVisor: bool;
const {:existential true} HoudiniB2_simplifiedVisor: bool;
procedure BoogieEntry_simplifiedVisor();
implementation BoogieEntry_simplifiedVisor()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var __ret_0_totalSupply: int;
var account_s91: Ref;
var __ret_0_balanceOf: int;
var recipient_s100: Ref;
var amount_s100: int;
var __ret_0_transfer: bool;
var owner_s109: Ref;
var spender_s109: Ref;
var __ret_0_allowance: int;
var spender_s118: Ref;
var amount_s118: int;
var __ret_0_approve: bool;
var sender_s129: Ref;
var recipient_s129: Ref;
var amount_s129: int;
var __ret_0_transferFrom: bool;
var ceil_s52: int;
var __ret_0_getPrice: int;
var tmpNow: int;
assume ((now) >= (0));
assume ((DType[this]) == (simplifiedVisor));
call simplifiedVisor_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
while (true)
  invariant (HoudiniB1_simplifiedVisor) ==> ((to_simplifiedVisor[this]) == (null));
  invariant (HoudiniB2_simplifiedVisor) ==> ((to_simplifiedVisor[this]) != (null));
{
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc __ret_0_totalSupply;
havoc account_s91;
havoc __ret_0_balanceOf;
havoc recipient_s100;
havoc amount_s100;
havoc __ret_0_transfer;
havoc owner_s109;
havoc spender_s109;
havoc __ret_0_allowance;
havoc spender_s118;
havoc amount_s118;
havoc __ret_0_approve;
havoc sender_s129;
havoc recipient_s129;
havoc amount_s129;
havoc __ret_0_transferFrom;
havoc ceil_s52;
havoc __ret_0_getPrice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
Alloc[msgsender_MSG] := true;
if ((choice) == (8)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (7)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s91);
} else if ((choice) == (6)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s100, amount_s100);
} else if ((choice) == (5)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s109, spender_s109);
} else if ((choice) == (4)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s118, amount_s118);
} else if ((choice) == (3)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s129, recipient_s129, amount_s129);
} else if ((choice) == (2)) {
call liquidate_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG, ceil_s52);
} else if ((choice) == (1)) {
call __ret_0_getPrice := getPrice_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
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
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
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
assume (((DType[this]) == (IERC20)) || ((DType[this]) == (simplifiedVisor)));
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
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
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

procedure CorralChoice_simplifiedVisor(this: Ref);
implementation CorralChoice_simplifiedVisor(this: Ref)
{
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
var choice: int;
var __ret_0_totalSupply: int;
var account_s91: Ref;
var __ret_0_balanceOf: int;
var recipient_s100: Ref;
var amount_s100: int;
var __ret_0_transfer: bool;
var owner_s109: Ref;
var spender_s109: Ref;
var __ret_0_allowance: int;
var spender_s118: Ref;
var amount_s118: int;
var __ret_0_approve: bool;
var sender_s129: Ref;
var recipient_s129: Ref;
var amount_s129: int;
var __ret_0_transferFrom: bool;
var ceil_s52: int;
var __ret_0_getPrice: int;
var tmpNow: int;
havoc msgsender_MSG;
havoc msgvalue_MSG;
havoc choice;
havoc __ret_0_totalSupply;
havoc account_s91;
havoc __ret_0_balanceOf;
havoc recipient_s100;
havoc amount_s100;
havoc __ret_0_transfer;
havoc owner_s109;
havoc spender_s109;
havoc __ret_0_allowance;
havoc spender_s118;
havoc amount_s118;
havoc __ret_0_approve;
havoc sender_s129;
havoc recipient_s129;
havoc amount_s129;
havoc __ret_0_transferFrom;
havoc ceil_s52;
havoc __ret_0_getPrice;
havoc tmpNow;
tmpNow := now;
havoc now;
assume ((now) > (tmpNow));
assume ((msgsender_MSG) != (null));
assume ((DType[msgsender_MSG]) != (IERC20));
assume ((DType[msgsender_MSG]) != (VeriSol));
assume ((DType[msgsender_MSG]) != (SafeMath));
assume ((DType[msgsender_MSG]) != (simplifiedVisor));
Alloc[msgsender_MSG] := true;
if ((choice) == (8)) {
call __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
} else if ((choice) == (7)) {
call __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s91);
} else if ((choice) == (6)) {
call __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s100, amount_s100);
} else if ((choice) == (5)) {
call __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s109, spender_s109);
} else if ((choice) == (4)) {
call __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s118, amount_s118);
} else if ((choice) == (3)) {
call __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s129, recipient_s129, amount_s129);
} else if ((choice) == (2)) {
call liquidate_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG, ceil_s52);
} else if ((choice) == (1)) {
call __ret_0_getPrice := getPrice_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
}
}

procedure CorralEntry_simplifiedVisor();
implementation CorralEntry_simplifiedVisor()
{
var this: Ref;
var msgsender_MSG: Ref;
var msgvalue_MSG: int;
call this := FreshRefGenerator();
assume ((now) >= (0));
assume ((DType[this]) == (simplifiedVisor));
call simplifiedVisor_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
while (true)
{
call CorralChoice_simplifiedVisor(this);
}
}


