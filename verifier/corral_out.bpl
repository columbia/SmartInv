type Ref;

type ContractName;

const unique null: Ref;

const unique IERC20: ContractName;

const unique VeriSol: ContractName;

const unique SafeMath: ContractName;

const unique TimelockController: ContractName;

const unique TimelockController.Proposal: ContractName;

function ConstantToRef(x: int) : Ref;

function BoogieRefToInt(x: Ref) : int;

function {:bvbuiltin "mod"} modBpl(x: int, y: int) : int;

function keccak256(x: int) : int;

function abiEncodePacked1(x: int) : int;

function _SumMapping_VeriSol(x: [Ref]int) : int;

function abiEncodePacked2(x: int, y: int) : int;

function abiEncodePacked1R(x: Ref) : int;

function abiEncodePacked2R(x: Ref, y: int) : int;

var Balance: [Ref]int;

var DType: [Ref]ContractName;

var Alloc: [Ref]bool;

var balance_ADDR: [Ref]int;

var M_Ref_int: [Ref][Ref]int;

var M_int_Ref: [Ref][int]Ref;

var Length: [Ref]int;

var now: int;

procedure FreshRefGenerator() returns (newRef: Ref);
  modifies Alloc;



implementation {:ForceInline} FreshRefGenerator() returns (newRef: Ref)
{

  anon0:
    havoc newRef;
    assume Alloc[newRef] <==> false;
    Alloc[newRef] := true;
    assume newRef != null;
    return;
}



procedure HavocAllocMany();



procedure boogie_si_record_sol2Bpl_int(x: int);



procedure boogie_si_record_sol2Bpl_ref(x: Ref);



procedure boogie_si_record_sol2Bpl_bool(x: bool);



procedure TimelockController.Proposal_ctor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sTime: int, newOwner: Ref);
  modifies sTime_TimelockController.Proposal, newOwner_TimelockController.Proposal;



implementation {:ForceInline} TimelockController.Proposal_ctor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sTime: int, newOwner: Ref)
{

  anon0:
    sTime_TimelockController.Proposal[this] := sTime;
    newOwner_TimelockController.Proposal[this] := newOwner;
    return;
}



axiom (forall __i__0_0: int, __i__0_1: int :: { ConstantToRef(__i__0_0), ConstantToRef(__i__0_1) } __i__0_0 == __i__0_1 || ConstantToRef(__i__0_0) != ConstantToRef(__i__0_1));

axiom (forall __i__0_0: int, __i__0_1: int :: { keccak256(__i__0_0), keccak256(__i__0_1) } __i__0_0 == __i__0_1 || keccak256(__i__0_0) != keccak256(__i__0_1));

axiom (forall __i__0_0: int, __i__0_1: int :: { abiEncodePacked1(__i__0_0), abiEncodePacked1(__i__0_1) } __i__0_0 == __i__0_1 || abiEncodePacked1(__i__0_0) != abiEncodePacked1(__i__0_1));

axiom (forall __i__0_0: [Ref]int :: (exists __i__0_1: Ref :: __i__0_0[__i__0_1] != 0) || _SumMapping_VeriSol(__i__0_0) == 0);

axiom (forall __i__0_0: [Ref]int, __i__0_1: Ref, __i__0_2: int :: _SumMapping_VeriSol(__i__0_0[__i__0_1 := __i__0_2]) == _SumMapping_VeriSol(__i__0_0) - __i__0_0[__i__0_1] + __i__0_2);

axiom (forall __i__0_0: int, __i__0_1: int, __i__1_0: int, __i__1_1: int :: { abiEncodePacked2(__i__0_0, __i__1_0), abiEncodePacked2(__i__0_1, __i__1_1) } (__i__0_0 == __i__0_1 && __i__1_0 == __i__1_1) || abiEncodePacked2(__i__0_0, __i__1_0) != abiEncodePacked2(__i__0_1, __i__1_1));

axiom (forall __i__0_0: Ref, __i__0_1: Ref :: { abiEncodePacked1R(__i__0_0), abiEncodePacked1R(__i__0_1) } __i__0_0 == __i__0_1 || abiEncodePacked1R(__i__0_0) != abiEncodePacked1R(__i__0_1));

axiom (forall __i__0_0: Ref, __i__0_1: Ref, __i__1_0: int, __i__1_1: int :: { abiEncodePacked2R(__i__0_0, __i__1_0), abiEncodePacked2R(__i__0_1, __i__1_1) } (__i__0_0 == __i__0_1 && __i__1_0 == __i__1_1) || abiEncodePacked2R(__i__0_0, __i__1_0) != abiEncodePacked2R(__i__0_1, __i__1_1));

procedure IERC20_IERC20_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance;



implementation {:ForceInline} IERC20_IERC20_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    assume msgsender_MSG != null;
    Balance[this] := 0;
    return;
}



procedure IERC20_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance;



implementation {:ForceInline} IERC20_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    call {:si_unique_call 0} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 1} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 2} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 3} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 4} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_1;

  corral_source_split_1:
    call {:si_unique_call 5} IERC20_IERC20_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
    return;
}



procedure {:public} totalSupply_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);



procedure {:public} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s161: Ref) returns (__ret_0_: int);



procedure {:public} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s170: Ref, amount_s170: int) returns (__ret_0_: bool);



procedure {:public} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s179: Ref, spender_s179: Ref) returns (__ret_0_: int);



procedure {:public} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s188: Ref, amount_s188: int) returns (__ret_0_: bool);



procedure {:public} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s199: Ref, recipient_s199: Ref, amount_s199: int) returns (__ret_0_: bool);



procedure SafeMath_SafeMath_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure SafeMath_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s415: int, b_s415: int) returns (__ret_0_: int);



procedure sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s440: int, b_s440: int) returns (__ret_0_: int);



procedure mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s474: int, b_s474: int) returns (__ret_0_: int);



procedure div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s499: int, b_s499: int) returns (__ret_0_: int);



procedure mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s520: int, b_s520: int) returns (__ret_0_: int);



procedure TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, owner_TimelockController, lockedFunds_TimelockController, Alloc, proposal_TimelockController;



implementation {:ForceInline} TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
  var __var_1: Ref;

  anon0:
    assume msgsender_MSG != null;
    Balance[this] := 0;
    owner_TimelockController[this] := null;
    lockedFunds_TimelockController[this] := 0;
    call {:si_unique_call 6} __var_1 := FreshRefGenerator();
    proposal_TimelockController[this] := __var_1;
    return;
}



procedure TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, owner_TimelockController, lockedFunds_TimelockController, Alloc, proposal_TimelockController;



implementation {:ForceInline} TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    call {:si_unique_call 7} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 8} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 9} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 10} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 11} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_3;

  corral_source_split_3:
    call {:si_unique_call 12} IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
    call {:si_unique_call 13} TimelockController_TimelockController_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
    return;
}



var sTime_TimelockController.Proposal: [Ref]int;

var newOwner_TimelockController.Proposal: [Ref]Ref;

var owner_TimelockController: [Ref]Ref;

var votingToken_TimelockController: [Ref]Ref;

var lockedFunds_TimelockController: [Ref]int;

var proposal_TimelockController: [Ref]Ref;

procedure {:public} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Alloc, sTime_TimelockController.Proposal, newOwner_TimelockController.Proposal, proposal_TimelockController;



implementation {:ForceInline} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
  var __var_2: Ref;
  var __var_3: Ref;
  var __var_4: int;

  anon0:
    call {:si_unique_call 14} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 15} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 16} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 17} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 18} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_5;

  corral_source_split_5:
    goto corral_source_split_6;

  corral_source_split_6:
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] == 0;
    goto corral_source_split_7;

  corral_source_split_7:
    call {:si_unique_call 19} __var_3 := FreshRefGenerator();
    assume now >= 0;
    assume DType[__var_3] == TimelockController.Proposal;
    call {:si_unique_call 20} TimelockController.Proposal_ctor(__var_3, this, 0, now, msgsender_MSG);
    __var_2 := __var_3;
    proposal_TimelockController[this] := __var_2;
    return;
}



procedure {:public} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s72: int);
  modifies lockedFunds_TimelockController;



implementation {:ForceInline} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s72: int)
{
  var __var_5: bool;
  var __var_6: int;
  var __var_7: Ref;

  anon0:
    call {:si_unique_call 21} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 22} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 23} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 24} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 25} {:cexpr "amount"} boogie_si_record_sol2Bpl_int(amount_s72);
    call {:si_unique_call 26} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_9;

  corral_source_split_9:
    goto corral_source_split_10;

  corral_source_split_10:
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] + 24 >= 0;
    assume now >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] + 24 > now;
    goto corral_source_split_11;

  corral_source_split_11:
    __var_7 := this;
    assume amount_s72 >= 0;
    goto anon5_Then, anon5_Else;

  anon5_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 27} __var_5 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_6, msgsender_MSG, this, amount_s72);
    goto anon4;

  anon5_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon6_Then, anon6_Else;

  anon6_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 28} __var_5 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_6, msgsender_MSG, this, amount_s72);
    goto anon4;

  anon6_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    assume lockedFunds_TimelockController[this] >= 0;
    assume amount_s72 >= 0;
    lockedFunds_TimelockController[this] := lockedFunds_TimelockController[this] + amount_s72;
    call {:si_unique_call 29} {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
    return;
}



procedure {:public} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies owner_TimelockController;



implementation {:ForceInline} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
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

  anon0:
    call {:si_unique_call 30} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 31} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 32} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 33} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 34} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_13;

  corral_source_split_13:
    goto corral_source_split_14;

  corral_source_split_14:
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] != 0;
    goto corral_source_split_15;

  corral_source_split_15:
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] + 24 >= 0;
    assume now >= 0;
    assume sTime_TimelockController.Proposal[proposal_TimelockController[this]] + 24 < now;
    goto corral_source_split_16;

  corral_source_split_16:
    assume __var_8 >= 0;
    __var_10 := this;
    goto anon17_Then, anon17_Else;

  anon17_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 35} __var_8 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_9, this);
    goto anon4;

  anon17_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon18_Then, anon18_Else;

  anon18_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 36} __var_8 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_9, this);
    goto anon4;

  anon18_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    assume __var_8 >= 0;
    assume __var_8 * 2 >= 0;
    assume __var_11 >= 0;
    goto anon19_Then, anon19_Else;

  anon19_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 37} __var_11 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_12);
    goto anon8;

  anon19_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon20_Then, anon20_Else;

  anon20_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 38} __var_11 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_12);
    goto anon8;

  anon20_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon8;

  anon8:
    assume __var_11 >= 0;
    assume __var_8 * 2 > __var_11;
    goto corral_source_split_18;

  corral_source_split_18:
    assume __var_13 >= 0;
    __var_15 := this;
    goto anon21_Then, anon21_Else;

  anon21_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 39} __var_13 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_14, this);
    goto anon12;

  anon21_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon22_Then, anon22_Else;

  anon22_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 40} __var_13 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_14, this);
    goto anon12;

  anon22_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon12;

  anon12:
    assume __var_13 >= 0;
    assume old(__var_13) >= 0;
    assume __var_16 >= 0;
    __var_18 := this;
    goto anon23_Then, anon23_Else;

  anon23_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 41} __var_16 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_17, this);
    goto anon16;

  anon23_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon24_Then, anon24_Else;

  anon24_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 42} __var_16 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_17, this);
    goto anon16;

  anon24_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon16;

  anon16:
    assume __var_16 >= 0;
    assert old(__var_13) == __var_16;
    goto corral_source_split_20;

  corral_source_split_20:
    owner_TimelockController[this] := newOwner_TimelockController.Proposal[proposal_TimelockController[this]];
    call {:si_unique_call 43} {:cexpr "owner"} boogie_si_record_sol2Bpl_ref(owner_TimelockController[this]);
    goto corral_source_split_21;

  corral_source_split_21:
    return;
}



procedure {:public} rewardFunds_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);



implementation {:ForceInline} rewardFunds_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int)
{

  anon0:
    call {:si_unique_call 44} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 45} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 46} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 47} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 48} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_23;

  corral_source_split_23:
    goto corral_source_split_24;

  corral_source_split_24:
    assume lockedFunds_TimelockController[this] >= 0;
    __ret_0_ := lockedFunds_TimelockController[this];
    return;
}



procedure FallbackDispatch(from: Ref, to: Ref, amount: int);



procedure Fallback_UnknownType(from: Ref, to: Ref, amount: int);



procedure send(from: Ref, to: Ref, amount: int) returns (success: bool);



procedure BoogieEntry_IERC20();



procedure BoogieEntry_SafeMath();



const {:existential true} HoudiniB1_TimelockController: bool;

const {:existential true} HoudiniB2_TimelockController: bool;

procedure BoogieEntry_TimelockController();



procedure CorralChoice_IERC20(this: Ref);



procedure CorralEntry_IERC20();



procedure CorralChoice_SafeMath(this: Ref);



procedure CorralEntry_SafeMath();



procedure CorralChoice_TimelockController(this: Ref);
  modifies now, Alloc, sTime_TimelockController.Proposal, newOwner_TimelockController.Proposal, proposal_TimelockController, lockedFunds_TimelockController, owner_TimelockController;



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

  anon0:
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
    assume now > tmpNow;
    assume msgsender_MSG != null;
    assume DType[msgsender_MSG] != IERC20;
    assume DType[msgsender_MSG] != VeriSol;
    assume DType[msgsender_MSG] != SafeMath;
    assume DType[msgsender_MSG] != TimelockController;
    Alloc[msgsender_MSG] := true;
    goto anon11_Then, anon11_Else;

  anon11_Then:
    assume {:partition} choice == 10;
    call {:si_unique_call 49} __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon11_Else:
    assume {:partition} choice != 10;
    goto anon12_Then, anon12_Else;

  anon12_Then:
    assume {:partition} choice == 9;
    call {:si_unique_call 50} __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s161);
    return;

  anon12_Else:
    assume {:partition} choice != 9;
    goto anon13_Then, anon13_Else;

  anon13_Then:
    assume {:partition} choice == 8;
    call {:si_unique_call 51} __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s170, amount_s170);
    return;

  anon13_Else:
    assume {:partition} choice != 8;
    goto anon14_Then, anon14_Else;

  anon14_Then:
    assume {:partition} choice == 7;
    call {:si_unique_call 52} __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s179, spender_s179);
    return;

  anon14_Else:
    assume {:partition} choice != 7;
    goto anon15_Then, anon15_Else;

  anon15_Then:
    assume {:partition} choice == 6;
    call {:si_unique_call 53} __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s188, amount_s188);
    return;

  anon15_Else:
    assume {:partition} choice != 6;
    goto anon16_Then, anon16_Else;

  anon16_Then:
    assume {:partition} choice == 5;
    call {:si_unique_call 54} __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s199, recipient_s199, amount_s199);
    return;

  anon16_Else:
    assume {:partition} choice != 5;
    goto anon17_Then, anon17_Else;

  anon17_Then:
    assume {:partition} choice == 4;
    call {:si_unique_call 55} startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon17_Else:
    assume {:partition} choice != 4;
    goto anon18_Then, anon18_Else;

  anon18_Then:
    assume {:partition} choice == 3;
    call {:si_unique_call 56} execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s72);
    return;

  anon18_Else:
    assume {:partition} choice != 3;
    goto anon19_Then, anon19_Else;

  anon19_Then:
    assume {:partition} choice == 2;
    call {:si_unique_call 57} endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon19_Else:
    assume {:partition} choice != 2;
    goto anon20_Then, anon20_Else;

  anon20_Then:
    assume {:partition} choice == 1;
    call {:si_unique_call 58} __ret_0_rewardFunds := rewardFunds_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon20_Else:
    assume {:partition} choice != 1;
    return;
}



procedure CorralEntry_TimelockController();
  modifies Alloc, Balance, owner_TimelockController, lockedFunds_TimelockController, proposal_TimelockController, now, sTime_TimelockController.Proposal, newOwner_TimelockController.Proposal;



implementation CorralEntry_TimelockController()
{
  var this: Ref;
  var msgsender_MSG: Ref;
  var msgvalue_MSG: int;

  anon0:
    call {:si_unique_call 59} this := FreshRefGenerator();
    assume now >= 0;
    assume DType[this] == TimelockController;
    call {:si_unique_call 60} TimelockController_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} true;
    call {:si_unique_call 61} CorralChoice_TimelockController(this);
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} !true;
    return;
}


