1 contract Token {
2 /// @return total amount of tokens
3 function totalSupply() constant returns (uint256 supply) {}
4 /// @param _owner The address from which the balance will be retrieved
5 /// @return The balance
6 function balanceOf(address _owner) constant returns (uint256 balance) {}
7 /// @notice send `_value` token to `_to` from `msg.sender`
8 /// @param _to The address of the recipient
9 /// @param _value The amount of token to be transferred
10 /// @return Whether the transfer was successful or not
11 function transfer(address _to, uint256 _value) returns (bool success) {}
12 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
13 /// @param _from The address of the sender
14 /// @param _to The address of the recipient
15 /// @param _value The amount of token to be transferred
16 /// @return Whether the transfer was successful or not
17 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
18 /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
19 /// @param _spender The address of the account able to transfer the tokens
20 /// @param _value The amount of wei to be approved for transfer
21 /// @return Whether the approval was successful or not
22 function approve(address _spender, uint256 _value) returns (bool success) {}
23 /// @param _owner The address of the account owning tokens
24 /// @param _spender The address of the account able to transfer the tokens
25 /// @return Amount of remaining tokens allowed to spent
26 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
27 event Transfer(address indexed _from, address indexed _to, uint256 _value);
28 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 
32 contract StandardToken is Token {
33 function transfer(address _to, uint256 _value) returns (bool success) {
34 if (balances[msg.sender] >= _value && _value > 0) {
35 balances[msg.sender] -= _value;
36 balances[_to] += _value;
37 Transfer(msg.sender, _to, _value);
38 return true;
39 } else { return false; }
40 }
41 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43 balances[_to] += _value;
44 balances[_from] -= _value;
45 allowed[_from][msg.sender] -= _value;
46 Transfer(_from, _to, _value);
47 return true;
48 } else { return false; }
49 }
50 function balanceOf(address _owner) constant returns (uint256 balance) {
51 return balances[_owner];
52 }
53 function approve(address _spender, uint256 _value) returns (bool success) {
54 allowed[msg.sender][_spender] = _value;
55 Approval(msg.sender, _spender, _value);
56 return true;
57 }
58 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59 return allowed[_owner][_spender];
60 }
61 mapping (address => uint256) balances;
62 mapping (address => mapping (address => uint256)) allowed;
63 uint256 public totalSupply;
64 }
65 
66 
67 contract LeverageToken is StandardToken {
68 function () {
69 //if ether is sent to this address, send it back.
70 throw;
71 }
72 
73 /* Public variables of the token */
74 string public name = 'Leverage Platform Token'; 
75 uint8 public decimals;//Decimals
76 string public symbol = 'LVP';//TICKER
77 string public version = '1.0.2';
78 
79 function LeverageToken(
80 ) {
81 balances[msg.sender] = 50000000;
82 totalSupply = 50000000;
83 name = "LEVERAGE PLATFORM";
84 decimals = 0;// Amount of decimals for display purposes
85 symbol = "LVP";//TICKER
86 }
87 
88 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89 allowed[msg.sender][_spender] = _value;
90 Approval(msg.sender, _spender, _value);
91 if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
92 return true;
93 }
94 }