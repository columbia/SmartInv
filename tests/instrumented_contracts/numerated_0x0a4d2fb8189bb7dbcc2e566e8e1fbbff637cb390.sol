1 pragma solidity ^0.4.9;
2 
3 contract Token {
4   
5   /// @param _owner The address from which the balance will be retrieved
6   /// @return The balance
7   function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9   /// @notice send `_value` token to `_to` from `msg.sender`
10   /// @param _to The address of the recipient
11   /// @param _value The amount of token to be transferred
12   /// @return Whether the transfer was successful or not
13   function transfer(address _to, uint256 _value) returns (bool success) {}
14 
15   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16   /// @param _from The address of the sender
17   /// @param _to The address of the recipient
18   /// @param _value The amount of token to be transferred
19   /// @return Whether the transfer was successful or not
20   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23   /// @param _spender The address of the account able to transfer the tokens
24   /// @param _value The amount of wei to be approved for transfer
25   /// @return Whether the approval was successful or not
26   function approve(address _spender, uint256 _value) returns (bool success) {}
27 
28   /// @param _owner The address of the account owning tokens
29   /// @param _spender The address of the account able to transfer the tokens
30   /// @return Amount of remaining tokens allowed to spent
31   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
32 
33   event Transfer(address indexed _from, address indexed _to, uint256 _value);
34   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36   uint public decimals;
37   string public name;
38   string public symbol;
39 
40 }
41 
42 contract BMT is Token {
43     mapping(address => uint256) balances;
44 
45     mapping (address => mapping (address => uint256)) allowed;
46 
47     uint256 public totalSupply;
48   
49     mapping(address => uint256) freezeAccount;
50 
51     address public minter;
52  function BMT(uint256 initialSupply, string tokenName, uint8 decimalUnits,uint256 _totalSupply,string tokenSymbol) {
53     minter = msg.sender;
54 	balances[msg.sender] = initialSupply; // Give the creator all initial tokens
55 	name = tokenName; // Set the name for display purposes
56 	decimals = decimalUnits; // Amount of decimals for display purposes
57 	totalSupply= _totalSupply; // All Token
58 	symbol = tokenSymbol; // Set the symbol for display purposes
59 
60   }
61   function transfer(address _to, uint256 _value) returns (bool success) {
62     //Default assumes totalSupply can't be over max (2^256 - 1).
63     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64     //Replace the if with this one instead.
65     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to] && freezeAccount[msg.sender]==0) {
66       balances[msg.sender] -= _value;
67       balances[_to] += _value;
68       Transfer(msg.sender, _to, _value);
69       return true;
70     } else { return false; }
71   }
72 
73   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74     //same as above. Replace this line with the following if you want to protect against wrapping uints.
75     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && freezeAccount[_from]==0) {
76       balances[_to] += _value;
77       balances[_from] -= _value;
78       allowed[_from][msg.sender] -= _value;
79       Transfer(_from, _to, _value);
80       return true;
81     } else { return false; }
82   }
83 
84   function balanceOf(address _owner) constant returns (uint256 balance) {
85     return balances[_owner];
86   }
87   //account key
88   function freezeAccountOf(address _owner) constant returns (uint256 freeze) {
89     return freezeAccount[_owner];
90   }
91   //freeze account.if account !=0.freeze
92   function freeze(address account,uint key) {
93     if (msg.sender != minter) throw;
94     freezeAccount[account] = key;
95   }
96   function approve(address _spender, uint256 _value) returns (bool success) {
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106 
107 
108 }