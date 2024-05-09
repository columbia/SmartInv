1 pragma solidity ^0.4.4;
2 contract Arzdigital {
3 /// @return total amount of tokens
4  function totalSupply() constant returns (uint256 supply) {}
5 /// @param _owner The address from which the balance will be retrieved
6  /// @return The balance
7  function balanceOf(address _owner) constant returns (uint256 balance) {}
8 /// @notice send `_value` token to `_to` from `msg.sender`
9  /// @param _to The address of the recipient
10  /// @param _value The amount of token to be transferred
11  /// @return Whether the transfer was successful or not
12  function transfer(address _to, uint256 _value) returns (bool success) {}
13 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
14  /// @param _from The address of the sender
15  /// @param _to The address of the recipient
16  /// @param _value The amount of token to be transferred
17  /// @return Whether the transfer was successful or not
18  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19 /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
20  /// @param _spender The address of the account able to transfer the tokens
21  /// @param _value The amount of wei to be approved for transfer
22  /// @return Whether the approval was successful or not
23  function approve(address _spender, uint256 _value) returns (bool success) {}
24 /// @param _owner The address of the account owning tokens
25  /// @param _spender The address of the account able to transfer the tokens
26  /// @return Amount of remaining tokens allowed to spent
27  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
28 event Transfer(address indexed _from, address indexed _to, uint256 _value);
29  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30  
31 }
32 contract StandardToken is Arzdigital {
33 function transfer(address _to, uint256 _value) returns (bool success) {
34  //Default assumes totalSupply can’t be over max (2²⁵⁶ — 1).
35  //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn’t wrap.
36  //Replace the if with this one instead.
37  //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
38  if (balances[msg.sender] >= _value && _value > 0) {
39  balances[msg.sender] -= _value;
40  balances[_to] += _value;
41  Transfer(msg.sender, _to, _value);
42  return true;
43  } else { return false; }
44  }
45 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46  //same as above. Replace this line with the following if you want to protect against wrapping uints.
47  //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48  if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
49  balances[_to] += _value;
50  balances[_from] -= _value;
51  allowed[_from][msg.sender] -= _value;
52  Transfer(_from, _to, _value);
53  return true;
54  } else { return false; }
55  }
56 function balanceOf(address _owner) constant returns (uint256 balance) {
57  return balances[_owner];
58  }
59 function approve(address _spender, uint256 _value) returns (bool success) {
60  allowed[msg.sender][_spender] = _value;
61  Approval(msg.sender, _spender, _value);
62  return true;
63  }
64 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65  return allowed[_owner][_spender];
66  }
67 mapping (address => uint256) balances;
68  mapping (address => mapping (address => uint256)) allowed;
69  uint256 public totalSupply;
70 }
71 //name this contract whatever you’d like
72 contract Token is StandardToken {
73 function () {
74  //if ether is sent to this address, send it back.
75  throw;
76  }
77 /* Public variables of the token */
78 /*
79  NOTE:
80  The following variables are OPTIONAL vanities. One does not have to include them.
81  They allow one to customise the token contract & in no way influences the core functionality.
82  Some wallets/interfaces might not even bother to look at this information.
83  */
84  string public name; //fancy name: eg Simon Bucks
85  uint8 public decimals; //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It’s like comparing 1 wei to 1 ether.
86  string public symbol; //An identifier: eg SBX
87  string public version = 'H1.0'; //human 0.1 standard. Just an arbitrary versioning scheme.
88 //
89 // برای توکن خود مقدارهای زیر را تغییر دهید
90 //
91 //make sure this function name matches the contract name above. So if you’re token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
92 function Token(
93  ) {
94  balances[msg.sender] = 10000000000000000; // تمام توکنهای ساخته شده سازنده برسد -عددی وارد کنید مثلا 100000
95  totalSupply = 10000000000000000; // تمام عرضه
96  name = 'SwapDEX'; // نام توکن
97  decimals = 7; // اعشار
98  symbol = 'SDX'; // نماد توکن
99  }
100 /* Approves and then calls the receiving contract */
101  function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102  allowed[msg.sender][_spender] = _value;
103  Approval(msg.sender, _spender, _value);
104 //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn’t have to include a contract in here just for this.
105  //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
106  //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
107  if(!_spender.call(bytes4(bytes32(sha3('receiveApproval(address,uint256,address,bytes)'))), msg.sender, _value, this, _extraData)) { throw; }
108  return true;
109  }
110 }