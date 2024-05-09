type Ref;

type ContractName;

const unique null: Ref;

const unique IERC20: ContractName;

const unique VeriSol: ContractName;

const unique SafeMath: ContractName;

const unique TimelockController: ContractName;

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

var M_Ref_bool: [Ref][Ref]bool;

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



procedure {:public} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s311: Ref) returns (__ret_0_: int);



procedure {:public} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s320: Ref, amount_s320: int) returns (__ret_0_: bool);



procedure {:public} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s329: Ref, spender_s329: Ref) returns (__ret_0_: int);



procedure {:public} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s338: Ref, amount_s338: int) returns (__ret_0_: bool);



procedure {:public} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s349: Ref, recipient_s349: Ref, amount_s349: int) returns (__ret_0_: bool);



procedure SafeMath_SafeMath_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure SafeMath_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s565: int, b_s565: int) returns (__ret_0_: int);



procedure sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s590: int, b_s590: int) returns (__ret_0_: int);



procedure mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s624: int, b_s624: int) returns (__ret_0_: int);



procedure div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s649: int, b_s649: int) returns (__ret_0_: int);



procedure mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s670: int, b_s670: int) returns (__ret_0_: int);



procedure TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, owner_TimelockController, startTime_TimelockController, Alloc, startingBalanceList_TimelockController, voteAddrList_TimelockController, existingAddr_TimelockController, lockedFunds_TimelockController;



implementation {:ForceInline} TimelockController_TimelockController_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{
  var __var_1: Ref;
  var __var_2: Ref;
  var __var_3: Ref;

  anon0:
    assume msgsender_MSG != null;
    Balance[this] := 0;
    owner_TimelockController[this] := null;
    startTime_TimelockController[this] := 0;
    call {:si_unique_call 6} __var_1 := FreshRefGenerator();
    startingBalanceList_TimelockController[this] := __var_1;
    assume (forall __i__0_0: Ref :: M_Ref_int[startingBalanceList_TimelockController[this]][__i__0_0] == 0);
    call {:si_unique_call 7} __var_2 := FreshRefGenerator();
    voteAddrList_TimelockController[this] := __var_2;
    assume Length[voteAddrList_TimelockController[this]] == 0;
    call {:si_unique_call 8} __var_3 := FreshRefGenerator();
    existingAddr_TimelockController[this] := __var_3;
    assume (forall __i__0_0: Ref :: !M_Ref_bool[existingAddr_TimelockController[this]][__i__0_0]);
    lockedFunds_TimelockController[this] := 0;
    return;
}



procedure TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, owner_TimelockController, startTime_TimelockController, Alloc, startingBalanceList_TimelockController, voteAddrList_TimelockController, existingAddr_TimelockController, lockedFunds_TimelockController;



implementation {:ForceInline} TimelockController_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    call {:si_unique_call 9} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 10} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 11} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 12} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 13} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_3;

  corral_source_split_3:
    call {:si_unique_call 14} IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
    call {:si_unique_call 15} TimelockController_TimelockController_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
    return;
}



var owner_TimelockController: [Ref]Ref;

var startTime_TimelockController: [Ref]int;

var startingBalanceList_TimelockController: [Ref]Ref;

var voteAddrList_TimelockController: [Ref]Ref;

var existingAddr_TimelockController: [Ref]Ref;

var lockedFunds_TimelockController: [Ref]int;

var votingToken_TimelockController: [Ref]Ref;

procedure getStartingBalance_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, voter_s38: Ref) returns (__ret_0_: int);



implementation {:ForceInline} getStartingBalance_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, voter_s38: Ref) returns (__ret_0_: int)
{
  var __var_4: int;
  var __var_5: int;

  anon0:
    call {:si_unique_call 16} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 17} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 18} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 19} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 20} {:cexpr "voter"} boogie_si_record_sol2Bpl_ref(voter_s38);
    call {:si_unique_call 21} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_5;

  corral_source_split_5:
    goto corral_source_split_6;

  corral_source_split_6:
    assume __var_4 >= 0;
    goto anon5_Then, anon5_Else;

  anon5_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 22} __var_4 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_5, voter_s38);
    goto anon4;

  anon5_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon6_Then, anon6_Else;

  anon6_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 23} __var_4 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_5, voter_s38);
    goto anon4;

  anon6_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    assume __var_4 >= 0;
    __ret_0_ := __var_4;
    return;
}



procedure findHighest_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: Ref);



implementation {:ForceInline} findHighest_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: Ref)
{
  var highestProposal_s117: Ref;
  var highestAmount_s117: int;
  var balanceGap_s117: int;
  var i_s105: int;
  var __var_6: int;
  var __var_7: int;
  var __var_8: Ref;

  anon0:
    call {:si_unique_call 24} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 25} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 26} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 27} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 28} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_8;

  corral_source_split_8:
    goto corral_source_split_9;

  corral_source_split_9:
    havoc highestProposal_s117;
    goto corral_source_split_10;

  corral_source_split_10:
    havoc highestAmount_s117;
    goto corral_source_split_11;

  corral_source_split_11:
    havoc balanceGap_s117;
    goto corral_source_split_12;

  corral_source_split_12:
    assume highestAmount_s117 >= 0;
    highestAmount_s117 := 0;
    call {:si_unique_call 29} {:cexpr "highestAmount"} boogie_si_record_sol2Bpl_int(highestAmount_s117);
    goto corral_source_split_13;

  corral_source_split_13:
    assume i_s105 >= 0;
    assume Length[voteAddrList_TimelockController[this]] >= 0;
    goto corral_source_split_14;

  corral_source_split_14:
    assume i_s105 >= 0;
    i_s105 := 0;
    call {:si_unique_call 30} {:cexpr "i"} boogie_si_record_sol2Bpl_int(i_s105);
    goto anon9_LoopHead;

  anon9_LoopHead:
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} i_s105 < Length[voteAddrList_TimelockController[this]];
    goto corral_source_split_16;

  corral_source_split_16:
    goto corral_source_split_17;

  corral_source_split_17:
    assume balanceGap_s117 >= 0;
    assume i_s105 >= 0;
    assume M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]] >= 0;
    assume __var_6 >= 0;
    assume i_s105 >= 0;
    goto anon10_Then, anon10_Else;

  anon10_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 31} __var_6 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_7, M_int_Ref[voteAddrList_TimelockController[this]][i_s105]);
    goto anon5;

  anon10_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon11_Then, anon11_Else;

  anon11_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 32} __var_6 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_7, M_int_Ref[voteAddrList_TimelockController[this]][i_s105]);
    goto anon5;

  anon11_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon5;

  anon5:
    assume __var_6 >= 0;
    assume M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]] - __var_6 >= 0;
    balanceGap_s117 := M_Ref_int[startingBalanceList_TimelockController[this]][M_int_Ref[voteAddrList_TimelockController[this]][i_s105]] - __var_6;
    call {:si_unique_call 33} {:cexpr "balanceGap"} boogie_si_record_sol2Bpl_int(balanceGap_s117);
    goto corral_source_split_19;

  corral_source_split_19:
    assume balanceGap_s117 >= 0;
    assume balanceGap_s117 >= 0;
    goto corral_source_split_20;

  corral_source_split_20:
    assume balanceGap_s117 >= 0;
    assume highestAmount_s117 >= 0;
    goto anon12_Then, anon12_Else;

  anon12_Then:
    assume {:partition} balanceGap_s117 > highestAmount_s117;
    goto corral_source_split_22;

  corral_source_split_22:
    goto corral_source_split_23;

  corral_source_split_23:
    assume highestAmount_s117 >= 0;
    assume balanceGap_s117 >= 0;
    highestAmount_s117 := balanceGap_s117;
    call {:si_unique_call 34} {:cexpr "highestAmount"} boogie_si_record_sol2Bpl_int(highestAmount_s117);
    goto corral_source_split_24;

  corral_source_split_24:
    assume i_s105 >= 0;
    highestProposal_s117 := M_int_Ref[voteAddrList_TimelockController[this]][i_s105];
    call {:si_unique_call 35} {:cexpr "highestProposal"} boogie_si_record_sol2Bpl_ref(highestProposal_s117);
    goto anon7;

  anon12_Else:
    assume {:partition} highestAmount_s117 >= balanceGap_s117;
    goto anon7;

  anon7:
    assume i_s105 >= 0;
    i_s105 := i_s105 + 1;
    call {:si_unique_call 36} {:cexpr "i"} boogie_si_record_sol2Bpl_int(i_s105);
    assume i_s105 >= 0;
    goto anon9_LoopHead;

  anon9_LoopDone:
    assume {:partition} Length[voteAddrList_TimelockController[this]] <= i_s105;
    goto anon8;

  anon8:
    __var_8 := null;
    assume highestProposal_s117 != null;
    goto corral_source_split_26;

  corral_source_split_26:
    __ret_0_ := highestProposal_s117;
    return;
}



procedure {:public} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, startTime_TimelockController;



implementation {:ForceInline} startExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    call {:si_unique_call 37} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 38} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 39} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 40} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 41} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    assume Balance[msgsender_MSG] >= msgvalue_MSG;
    Balance[msgsender_MSG] := Balance[msgsender_MSG] - msgvalue_MSG;
    Balance[this] := Balance[this] + msgvalue_MSG;
    goto corral_source_split_28;

  corral_source_split_28:
    goto corral_source_split_29;

  corral_source_split_29:
    assume startTime_TimelockController[this] >= 0;
    assume startTime_TimelockController[this] == 0;
    goto corral_source_split_30;

  corral_source_split_30:
    assume startTime_TimelockController[this] >= 0;
    assume now >= 0;
    startTime_TimelockController[this] := now;
    call {:si_unique_call 42} {:cexpr "startTime"} boogie_si_record_sol2Bpl_int(startTime_TimelockController[this]);
    return;
}



procedure {:public} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s199: int);
  modifies Balance, M_Ref_int, M_int_Ref, Length, M_Ref_bool;



implementation {:ForceInline} execute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, amount_s199: int)
{
  var __var_9: int;
  var __var_10: bool;
  var __var_11: int;
  var __var_12: Ref;
  var __var_13: int;

  anon0:
    call {:si_unique_call 43} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 44} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 45} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 46} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 47} {:cexpr "amount"} boogie_si_record_sol2Bpl_int(amount_s199);
    call {:si_unique_call 48} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    assume Balance[msgsender_MSG] >= msgvalue_MSG;
    Balance[msgsender_MSG] := Balance[msgsender_MSG] - msgvalue_MSG;
    Balance[this] := Balance[this] + msgvalue_MSG;
    goto corral_source_split_32;

  corral_source_split_32:
    goto corral_source_split_33;

  corral_source_split_33:
    assume M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG] <==> !true;
    goto corral_source_split_34;

  corral_source_split_34:
    assume startTime_TimelockController[this] >= 0;
    assume startTime_TimelockController[this] + 24 * 60 * 60 >= 0;
    assume now >= 0;
    assume startTime_TimelockController[this] + 24 * 60 * 60 > now;
    goto corral_source_split_35;

  corral_source_split_35:
    assume M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG] >= 0;
    call {:si_unique_call 49} __var_9 := getStartingBalance_TimelockController(this, msgsender_MSG, msgvalue_MSG, msgsender_MSG);
    M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG] := __var_9;
    assume __var_9 >= 0;
    call {:si_unique_call 50} {:cexpr "startingBalanceList[msg.sender]"} boogie_si_record_sol2Bpl_int(M_Ref_int[startingBalanceList_TimelockController[this]][msgsender_MSG]);
    goto corral_source_split_36;

  corral_source_split_36:
    __var_12 := this;
    assume amount_s199 >= 0;
    goto anon5_Then, anon5_Else;

  anon5_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 51} __var_10 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_11, msgsender_MSG, this, amount_s199);
    goto anon4;

  anon5_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon6_Then, anon6_Else;

  anon6_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 52} __var_10 := transferFrom_IERC20(votingToken_TimelockController[this], this, __var_11, msgsender_MSG, this, amount_s199);
    goto anon4;

  anon6_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    __var_13 := Length[voteAddrList_TimelockController[this]];
    M_int_Ref[voteAddrList_TimelockController[this]][__var_13] := msgsender_MSG;
    Length[voteAddrList_TimelockController[this]] := __var_13 + 1;
    goto corral_source_split_38;

  corral_source_split_38:
    M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG] := true;
    call {:si_unique_call 53} {:cexpr "existingAddr[msg.sender]"} boogie_si_record_sol2Bpl_bool(M_Ref_bool[existingAddr_TimelockController[this]][msgsender_MSG]);
    return;
}



procedure {:public} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, lockedFunds_TimelockController, owner_TimelockController, Length;



implementation {:ForceInline} endExecute_TimelockController(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
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

  anon0:
    call {:si_unique_call 54} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 55} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 56} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 57} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 58} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    assume Balance[msgsender_MSG] >= msgvalue_MSG;
    Balance[msgsender_MSG] := Balance[msgsender_MSG] - msgvalue_MSG;
    Balance[this] := Balance[this] + msgvalue_MSG;
    goto corral_source_split_40;

  corral_source_split_40:
    goto corral_source_split_41;

  corral_source_split_41:
    assume startTime_TimelockController[this] >= 0;
    assume startTime_TimelockController[this] != 0;
    goto corral_source_split_42;

  corral_source_split_42:
    assume startTime_TimelockController[this] >= 0;
    assume startTime_TimelockController[this] + 24 * 60 * 60 >= 0;
    assume now >= 0;
    assume startTime_TimelockController[this] + 24 * 60 * 60 < now;
    goto corral_source_split_43;

  corral_source_split_43:
    assume __var_14 >= 0;
    __var_16 := this;
    goto anon30_Then, anon30_Else;

  anon30_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 59} __var_14 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_15, this);
    goto anon4;

  anon30_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon31_Then, anon31_Else;

  anon31_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 60} __var_14 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_15, this);
    goto anon4;

  anon31_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    assume __var_14 >= 0;
    assume __var_14 * 2 >= 0;
    assume __var_17 >= 0;
    goto anon32_Then, anon32_Else;

  anon32_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 61} __var_17 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_18);
    goto anon8;

  anon32_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon33_Then, anon33_Else;

  anon33_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 62} __var_17 := totalSupply_IERC20(votingToken_TimelockController[this], this, __var_18);
    goto anon8;

  anon33_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon8;

  anon8:
    assume __var_17 >= 0;
    assume __var_14 * 2 > __var_17;
    goto corral_source_split_45;

  corral_source_split_45:
    assume __var_19 >= 0;
    __var_21 := this;
    goto anon34_Then, anon34_Else;

  anon34_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 63} __var_19 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_20, this);
    goto anon12;

  anon34_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon35_Then, anon35_Else;

  anon35_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 64} __var_19 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_20, this);
    goto anon12;

  anon35_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon12;

  anon12:
    assume __var_19 >= 0;
    assume old(__var_19) >= 0;
    assume __var_22 >= 0;
    __var_24 := this;
    goto anon36_Then, anon36_Else;

  anon36_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 65} __var_22 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_23, this);
    goto anon16;

  anon36_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon37_Then, anon37_Else;

  anon37_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 66} __var_22 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_23, this);
    goto anon16;

  anon37_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon16;

  anon16:
    assume __var_22 >= 0;
    assert old(__var_19) == __var_22;
    goto corral_source_split_47;

  corral_source_split_47:
    assume lockedFunds_TimelockController[this] >= 0;
    __var_27 := this;
    goto anon38_Then, anon38_Else;

  anon38_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 67} __var_25 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_26, this);
    goto anon20;

  anon38_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon39_Then, anon39_Else;

  anon39_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 68} __var_25 := balanceOf_IERC20(votingToken_TimelockController[this], this, __var_26, this);
    goto anon20;

  anon39_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon20;

  anon20:
    lockedFunds_TimelockController[this] := __var_25;
    assume __var_25 >= 0;
    call {:si_unique_call 69} {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
    goto corral_source_split_49;

  corral_source_split_49:
    call {:si_unique_call 70} __var_28 := findHighest_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    owner_TimelockController[this] := __var_28;
    call {:si_unique_call 71} {:cexpr "owner"} boogie_si_record_sol2Bpl_ref(owner_TimelockController[this]);
    goto corral_source_split_50;

  corral_source_split_50:
    assume lockedFunds_TimelockController[this] >= 0;
    goto anon40_Then, anon40_Else;

  anon40_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 72} __var_29 := approve_IERC20(votingToken_TimelockController[this], this, __var_30, owner_TimelockController[this], lockedFunds_TimelockController[this]);
    goto anon24;

  anon40_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon41_Then, anon41_Else;

  anon41_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 73} __var_29 := approve_IERC20(votingToken_TimelockController[this], this, __var_30, owner_TimelockController[this], lockedFunds_TimelockController[this]);
    goto anon24;

  anon41_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon24;

  anon24:
    goto anon42_Then, anon42_Else;

  anon42_Then:
    assume {:partition} __var_29 <==> true;
    goto corral_source_split_52;

  corral_source_split_52:
    goto corral_source_split_53;

  corral_source_split_53:
    assume lockedFunds_TimelockController[this] >= 0;
    goto anon43_Then, anon43_Else;

  anon43_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == TimelockController;
    call {:si_unique_call 74} __var_31 := transfer_IERC20(votingToken_TimelockController[this], this, __var_32, owner_TimelockController[this], lockedFunds_TimelockController[this]);
    goto anon29;

  anon43_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != TimelockController;
    goto anon44_Then, anon44_Else;

  anon44_Then:
    assume {:partition} DType[votingToken_TimelockController[this]] == IERC20;
    call {:si_unique_call 75} __var_31 := transfer_IERC20(votingToken_TimelockController[this], this, __var_32, owner_TimelockController[this], lockedFunds_TimelockController[this]);
    goto anon29;

  anon44_Else:
    assume {:partition} DType[votingToken_TimelockController[this]] != IERC20;
    assume false;
    goto anon29;

  anon42_Else:
    assume {:partition} __var_29 <==> !true;
    goto anon29;

  anon29:
    assume lockedFunds_TimelockController[this] >= 0;
    lockedFunds_TimelockController[this] := 0;
    call {:si_unique_call 76} {:cexpr "lockedFunds"} boogie_si_record_sol2Bpl_int(lockedFunds_TimelockController[this]);
    goto corral_source_split_55;

  corral_source_split_55:
    Length[voteAddrList_TimelockController[this]] := 0;
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
  modifies now, Alloc, Balance, startTime_TimelockController, M_Ref_int, M_int_Ref, Length, M_Ref_bool, lockedFunds_TimelockController, owner_TimelockController;



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

  anon0:
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
    assume now > tmpNow;
    assume msgsender_MSG != null;
    assume DType[msgsender_MSG] != IERC20;
    assume DType[msgsender_MSG] != VeriSol;
    assume DType[msgsender_MSG] != SafeMath;
    assume DType[msgsender_MSG] != TimelockController;
    Alloc[msgsender_MSG] := true;
    goto anon10_Then, anon10_Else;

  anon10_Then:
    assume {:partition} choice == 9;
    call {:si_unique_call 77} __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon10_Else:
    assume {:partition} choice != 9;
    goto anon11_Then, anon11_Else;

  anon11_Then:
    assume {:partition} choice == 8;
    call {:si_unique_call 78} __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s311);
    return;

  anon11_Else:
    assume {:partition} choice != 8;
    goto anon12_Then, anon12_Else;

  anon12_Then:
    assume {:partition} choice == 7;
    call {:si_unique_call 79} __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s320, amount_s320);
    return;

  anon12_Else:
    assume {:partition} choice != 7;
    goto anon13_Then, anon13_Else;

  anon13_Then:
    assume {:partition} choice == 6;
    call {:si_unique_call 80} __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s329, spender_s329);
    return;

  anon13_Else:
    assume {:partition} choice != 6;
    goto anon14_Then, anon14_Else;

  anon14_Then:
    assume {:partition} choice == 5;
    call {:si_unique_call 81} __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s338, amount_s338);
    return;

  anon14_Else:
    assume {:partition} choice != 5;
    goto anon15_Then, anon15_Else;

  anon15_Then:
    assume {:partition} choice == 4;
    call {:si_unique_call 82} __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s349, recipient_s349, amount_s349);
    return;

  anon15_Else:
    assume {:partition} choice != 4;
    goto anon16_Then, anon16_Else;

  anon16_Then:
    assume {:partition} choice == 3;
    call {:si_unique_call 83} startExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon16_Else:
    assume {:partition} choice != 3;
    goto anon17_Then, anon17_Else;

  anon17_Then:
    assume {:partition} choice == 2;
    call {:si_unique_call 84} execute_TimelockController(this, msgsender_MSG, msgvalue_MSG, amount_s199);
    return;

  anon17_Else:
    assume {:partition} choice != 2;
    goto anon18_Then, anon18_Else;

  anon18_Then:
    assume {:partition} choice == 1;
    call {:si_unique_call 85} endExecute_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon18_Else:
    assume {:partition} choice != 1;
    return;
}



procedure CorralEntry_TimelockController();
  modifies Alloc, Balance, owner_TimelockController, startTime_TimelockController, startingBalanceList_TimelockController, voteAddrList_TimelockController, existingAddr_TimelockController, lockedFunds_TimelockController, now, M_Ref_int, M_int_Ref, Length, M_Ref_bool;



implementation CorralEntry_TimelockController()
{
  var this: Ref;
  var msgsender_MSG: Ref;
  var msgvalue_MSG: int;

  anon0:
    call {:si_unique_call 86} this := FreshRefGenerator();
    assume now >= 0;
    assume DType[this] == TimelockController;
    call {:si_unique_call 87} TimelockController_TimelockController(this, msgsender_MSG, msgvalue_MSG);
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} true;
    call {:si_unique_call 88} CorralChoice_TimelockController(this);
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} !true;
    return;
}


