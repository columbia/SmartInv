type Ref;

type ContractName;

const unique null: Ref;

const unique IERC20: ContractName;

const unique VeriSol: ContractName;

const unique SafeMath: ContractName;

const unique simplifiedVisor: ContractName;

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



procedure {:public} balanceOf_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, account_s91: Ref) returns (__ret_0_: int);



procedure {:public} transfer_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, recipient_s100: Ref, amount_s100: int) returns (__ret_0_: bool);



procedure {:public} allowance_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, owner_s109: Ref, spender_s109: Ref) returns (__ret_0_: int);



procedure {:public} approve_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, spender_s118: Ref, amount_s118: int) returns (__ret_0_: bool);



procedure {:public} transferFrom_IERC20(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, sender_s129: Ref, recipient_s129: Ref, amount_s129: int) returns (__ret_0_: bool);



procedure SafeMath_SafeMath_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure SafeMath_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);



procedure add_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s345: int, b_s345: int) returns (__ret_0_: int);



procedure sub_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s370: int, b_s370: int) returns (__ret_0_: int);



procedure mul_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s404: int, b_s404: int) returns (__ret_0_: int);



procedure div_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s429: int, b_s429: int) returns (__ret_0_: int);



procedure mod_SafeMath(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, a_s450: int, b_s450: int) returns (__ret_0_: int);



procedure simplifiedVisor_simplifiedVisor_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, to_simplifiedVisor, ceil_simplifiedVisor, price_simplifiedVisor;



implementation {:ForceInline} simplifiedVisor_simplifiedVisor_NoBaseCtor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    assume msgsender_MSG != null;
    Balance[this] := 0;
    to_simplifiedVisor[this] := null;
    ceil_simplifiedVisor[this] := 0;
    price_simplifiedVisor[this] := 0;
    return;
}



procedure simplifiedVisor_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int);
  modifies Balance, to_simplifiedVisor, ceil_simplifiedVisor, price_simplifiedVisor;



implementation {:ForceInline} simplifiedVisor_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int)
{

  anon0:
    call {:si_unique_call 6} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 7} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 8} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 9} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 10} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_3;

  corral_source_split_3:
    call {:si_unique_call 11} IERC20_IERC20(this, msgsender_MSG, msgvalue_MSG);
    call {:si_unique_call 12} simplifiedVisor_simplifiedVisor_NoBaseCtor(this, msgsender_MSG, msgvalue_MSG);
    return;
}



var myToken_simplifiedVisor: [Ref]Ref;

var token0_simplifiedVisor: [Ref]Ref;

var token1_simplifiedVisor: [Ref]Ref;

var to_simplifiedVisor: [Ref]Ref;

var ceil_simplifiedVisor: [Ref]int;

var price_simplifiedVisor: [Ref]int;

procedure {:public} liquidate_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, ceil_s52: int);



implementation {:ForceInline} liquidate_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int, ceil_s52: int)
{
  var tokenPrice_s51: int;
  var __var_1: bool;
  var __var_2: int;

  anon0:
    call {:si_unique_call 13} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 14} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 15} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 16} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 17} {:cexpr "ceil"} boogie_si_record_sol2Bpl_int(ceil_s52);
    call {:si_unique_call 18} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_5;

  corral_source_split_5:
    goto corral_source_split_6;

  corral_source_split_6:
    assume tokenPrice_s51 >= 0;
    call {:si_unique_call 19} tokenPrice_s51 := getPrice_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
    tokenPrice_s51 := tokenPrice_s51;
    call {:si_unique_call 20} {:cexpr "tokenPrice"} boogie_si_record_sol2Bpl_int(tokenPrice_s51);
    goto corral_source_split_7;

  corral_source_split_7:
    assume tokenPrice_s51 >= 0;
    assume price_simplifiedVisor[this] >= 0;
    assume old(price_simplifiedVisor[this]) >= 0;
    assume 2 * old(price_simplifiedVisor[this]) >= 0;
    assert tokenPrice_s51 <= 2 * old(price_simplifiedVisor[this]);
    goto corral_source_split_8;

  corral_source_split_8:
    assume tokenPrice_s51 >= 0;
    assume ceil_s52 >= 0;
    goto anon5_Then, anon5_Else;

  anon5_Then:
    assume {:partition} tokenPrice_s51 >= ceil_s52;
    goto corral_source_split_10;

  corral_source_split_10:
    goto corral_source_split_11;

  corral_source_split_11:
    goto anon6_Then, anon6_Else;

  anon6_Then:
    assume {:partition} DType[myToken_simplifiedVisor[this]] == simplifiedVisor;
    call {:si_unique_call 21} __var_1 := transfer_IERC20(myToken_simplifiedVisor[this], this, __var_2, to_simplifiedVisor[this], 30);
    return;

  anon6_Else:
    assume {:partition} DType[myToken_simplifiedVisor[this]] != simplifiedVisor;
    goto anon7_Then, anon7_Else;

  anon7_Then:
    assume {:partition} DType[myToken_simplifiedVisor[this]] == IERC20;
    call {:si_unique_call 22} __var_1 := transfer_IERC20(myToken_simplifiedVisor[this], this, __var_2, to_simplifiedVisor[this], 30);
    return;

  anon7_Else:
    assume {:partition} DType[myToken_simplifiedVisor[this]] != IERC20;
    assume false;
    return;

  anon5_Else:
    assume {:partition} ceil_s52 > tokenPrice_s51;
    return;
}



procedure {:public} getPrice_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int);



implementation {:ForceInline} getPrice_simplifiedVisor(this: Ref, msgsender_MSG: Ref, msgvalue_MSG: int) returns (__ret_0_: int)
{
  var price_s75: int;
  var __var_3: int;
  var __var_4: int;
  var __var_5: Ref;
  var __var_6: int;
  var __var_7: int;
  var __var_8: Ref;

  anon0:
    call {:si_unique_call 23} {:cexpr "_verisolFirstArg"} boogie_si_record_sol2Bpl_bool(false);
    call {:si_unique_call 24} {:cexpr "this"} boogie_si_record_sol2Bpl_ref(this);
    call {:si_unique_call 25} {:cexpr "msg.sender"} boogie_si_record_sol2Bpl_ref(msgsender_MSG);
    call {:si_unique_call 26} {:cexpr "msg.value"} boogie_si_record_sol2Bpl_int(msgvalue_MSG);
    call {:si_unique_call 27} {:cexpr "_verisolLastArg"} boogie_si_record_sol2Bpl_bool(true);
    goto corral_source_split_13;

  corral_source_split_13:
    goto corral_source_split_14;

  corral_source_split_14:
    assume price_s75 >= 0;
    assume __var_3 >= 0;
    __var_5 := this;
    goto anon9_Then, anon9_Else;

  anon9_Then:
    assume {:partition} DType[token0_simplifiedVisor[this]] == simplifiedVisor;
    call {:si_unique_call 28} __var_3 := balanceOf_IERC20(token0_simplifiedVisor[this], this, __var_4, this);
    goto anon4;

  anon9_Else:
    assume {:partition} DType[token0_simplifiedVisor[this]] != simplifiedVisor;
    goto anon10_Then, anon10_Else;

  anon10_Then:
    assume {:partition} DType[token0_simplifiedVisor[this]] == IERC20;
    call {:si_unique_call 29} __var_3 := balanceOf_IERC20(token0_simplifiedVisor[this], this, __var_4, this);
    goto anon4;

  anon10_Else:
    assume {:partition} DType[token0_simplifiedVisor[this]] != IERC20;
    assume false;
    goto anon4;

  anon4:
    assume __var_3 >= 0;
    assume __var_6 >= 0;
    __var_8 := this;
    goto anon11_Then, anon11_Else;

  anon11_Then:
    assume {:partition} DType[token1_simplifiedVisor[this]] == simplifiedVisor;
    call {:si_unique_call 30} __var_6 := balanceOf_IERC20(token1_simplifiedVisor[this], this, __var_7, this);
    goto anon8;

  anon11_Else:
    assume {:partition} DType[token1_simplifiedVisor[this]] != simplifiedVisor;
    goto anon12_Then, anon12_Else;

  anon12_Then:
    assume {:partition} DType[token1_simplifiedVisor[this]] == IERC20;
    call {:si_unique_call 31} __var_6 := balanceOf_IERC20(token1_simplifiedVisor[this], this, __var_7, this);
    goto anon8;

  anon12_Else:
    assume {:partition} DType[token1_simplifiedVisor[this]] != IERC20;
    assume false;
    goto anon8;

  anon8:
    assume __var_6 >= 0;
    assume __var_3 div __var_6 >= 0;
    price_s75 := __var_3 div __var_6;
    call {:si_unique_call 32} {:cexpr "price"} boogie_si_record_sol2Bpl_int(price_s75);
    goto corral_source_split_16;

  corral_source_split_16:
    assume price_s75 >= 0;
    __ret_0_ := price_s75;
    return;
}



procedure FallbackDispatch(from: Ref, to: Ref, amount: int);



procedure Fallback_UnknownType(from: Ref, to: Ref, amount: int);



procedure send(from: Ref, to: Ref, amount: int) returns (success: bool);



procedure BoogieEntry_IERC20();



procedure BoogieEntry_SafeMath();



const {:existential true} HoudiniB1_simplifiedVisor: bool;

const {:existential true} HoudiniB2_simplifiedVisor: bool;

procedure BoogieEntry_simplifiedVisor();



procedure CorralChoice_IERC20(this: Ref);



procedure CorralEntry_IERC20();



procedure CorralChoice_SafeMath(this: Ref);



procedure CorralEntry_SafeMath();



procedure CorralChoice_simplifiedVisor(this: Ref);
  modifies now, Alloc;



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

  anon0:
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
    assume now > tmpNow;
    assume msgsender_MSG != null;
    assume DType[msgsender_MSG] != IERC20;
    assume DType[msgsender_MSG] != VeriSol;
    assume DType[msgsender_MSG] != SafeMath;
    assume DType[msgsender_MSG] != simplifiedVisor;
    Alloc[msgsender_MSG] := true;
    goto anon9_Then, anon9_Else;

  anon9_Then:
    assume {:partition} choice == 8;
    call {:si_unique_call 33} __ret_0_totalSupply := totalSupply_IERC20(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon9_Else:
    assume {:partition} choice != 8;
    goto anon10_Then, anon10_Else;

  anon10_Then:
    assume {:partition} choice == 7;
    call {:si_unique_call 34} __ret_0_balanceOf := balanceOf_IERC20(this, msgsender_MSG, msgvalue_MSG, account_s91);
    return;

  anon10_Else:
    assume {:partition} choice != 7;
    goto anon11_Then, anon11_Else;

  anon11_Then:
    assume {:partition} choice == 6;
    call {:si_unique_call 35} __ret_0_transfer := transfer_IERC20(this, msgsender_MSG, msgvalue_MSG, recipient_s100, amount_s100);
    return;

  anon11_Else:
    assume {:partition} choice != 6;
    goto anon12_Then, anon12_Else;

  anon12_Then:
    assume {:partition} choice == 5;
    call {:si_unique_call 36} __ret_0_allowance := allowance_IERC20(this, msgsender_MSG, msgvalue_MSG, owner_s109, spender_s109);
    return;

  anon12_Else:
    assume {:partition} choice != 5;
    goto anon13_Then, anon13_Else;

  anon13_Then:
    assume {:partition} choice == 4;
    call {:si_unique_call 37} __ret_0_approve := approve_IERC20(this, msgsender_MSG, msgvalue_MSG, spender_s118, amount_s118);
    return;

  anon13_Else:
    assume {:partition} choice != 4;
    goto anon14_Then, anon14_Else;

  anon14_Then:
    assume {:partition} choice == 3;
    call {:si_unique_call 38} __ret_0_transferFrom := transferFrom_IERC20(this, msgsender_MSG, msgvalue_MSG, sender_s129, recipient_s129, amount_s129);
    return;

  anon14_Else:
    assume {:partition} choice != 3;
    goto anon15_Then, anon15_Else;

  anon15_Then:
    assume {:partition} choice == 2;
    call {:si_unique_call 39} liquidate_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG, ceil_s52);
    return;

  anon15_Else:
    assume {:partition} choice != 2;
    goto anon16_Then, anon16_Else;

  anon16_Then:
    assume {:partition} choice == 1;
    call {:si_unique_call 40} __ret_0_getPrice := getPrice_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
    return;

  anon16_Else:
    assume {:partition} choice != 1;
    return;
}



procedure CorralEntry_simplifiedVisor();
  modifies Alloc, Balance, to_simplifiedVisor, ceil_simplifiedVisor, price_simplifiedVisor, now;



implementation CorralEntry_simplifiedVisor()
{
  var this: Ref;
  var msgsender_MSG: Ref;
  var msgvalue_MSG: int;

  anon0:
    call {:si_unique_call 41} this := FreshRefGenerator();
    assume now >= 0;
    assume DType[this] == simplifiedVisor;
    call {:si_unique_call 42} simplifiedVisor_simplifiedVisor(this, msgsender_MSG, msgvalue_MSG);
    goto anon2_LoopHead;

  anon2_LoopHead:
    goto anon2_LoopDone, anon2_LoopBody;

  anon2_LoopBody:
    assume {:partition} true;
    call {:si_unique_call 43} CorralChoice_simplifiedVisor(this);
    goto anon2_LoopHead;

  anon2_LoopDone:
    assume {:partition} !true;
    return;
}


