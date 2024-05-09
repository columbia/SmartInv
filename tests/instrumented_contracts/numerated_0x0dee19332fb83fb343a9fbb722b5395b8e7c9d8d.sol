1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of wei to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93 }
94 
95 
96 /*
97 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
98 
99 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
100 Imagine coins, currencies, shares, voting weight, etc.
101 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
102 
103 1) Initial Finite Supply (upon creation one specifies how much is minted).
104 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
105 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
106 
107 .*/
108 
109 
110 pragma solidity ^0.4.15;
111 
112 contract HumanStandardToken is StandardToken {
113 
114     /* Public variables of the token */
115 
116     /*
117     NOTE:
118     The following variables are OPTIONAL vanities. One does not have to include them.
119     They allow one to customise the token contract & in no way influences the core functionality.
120     Some wallets/interfaces might not even bother to look at this information.
121     */
122     string public name;                   //fancy name: eg Simon Bucks
123     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
124     string public symbol;                 //An identifier: eg SBX
125     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
126 
127     function HumanStandardToken(
128         uint256 _initialAmount,
129         string _tokenName,
130         uint8 _decimalUnits,
131         string _tokenSymbol
132         ) {
133         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
134         totalSupply = _initialAmount;                        // Update total supply
135         name = _tokenName;                                   // Set the name for display purposes
136         decimals = _decimalUnits;                            // Amount of decimals for display purposes
137         symbol = _tokenSymbol;                               // Set the symbol for display purposes
138     }
139 
140     /* Approves and then calls the receiving contract */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144 
145         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
146         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
147         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
148         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
149         return true;
150     }
151 }