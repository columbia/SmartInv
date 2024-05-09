1 pragma solidity ^0.4.9;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 /*
42 This implements ONLY the standard functions and NOTHING else.
43 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
44 
45 If you deploy this, you won't have anything useful.
46 
47 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
48 .*/
49 
50 contract StandardToken is Token {
51 
52     address tokenOwner;
53     mapping(address => uint256) balances;
54     mapping(address => mapping(address => uint256)) allowed;
55     uint256 public totalSupply;
56 
57     modifier onlyowner {
58         require(isOwner(msg.sender));
59         _;
60     }
61 
62     function isOwner(address _addr) returns (bool) {
63         return tokenOwner == _addr;
64     }
65 
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[msg.sender] >= _value && _value > 0) {
69             balances[msg.sender] -= _value;
70             balances[_to] += _value;
71             Transfer(msg.sender, _to, _value);
72             return true;
73         } else {return false;}
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             allowed[_from][msg.sender] -= _value;
81             Transfer(_from, _to, _value);
82             return true;
83         } else {
84             return false;
85         }
86     }
87 
88     function balanceOf(address _owner) constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) onlyowner returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 
102 }
103 
104 /*
105 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
106 
107 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
108 Imagine coins, currencies, shares, voting weight, etc.
109 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
110 
111 1) Initial Finite Supply (upon creation one specifies how much is minted).
112 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
113 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
114 
115 .*/
116 
117 contract ISINToken is StandardToken {
118 
119     function() {
120         //if ether is sent to this address, send it back.
121         throw;
122     }
123 
124     /* Public variables of the token */
125     string public name;
126     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
127     string public symbol;
128     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
129 
130     function ISINToken(
131         uint256 _initialAmount,
132         string _tokenName,
133         uint8 _decimalUnits,
134         string _tokenSymbol
135     ) {
136         tokenOwner = msg.sender;
137         balances[msg.sender] = _initialAmount;
138         // Give the creator all initial tokens
139         totalSupply = _initialAmount;
140         // Update total supply
141         name = _tokenName;
142         // Set the name for display purposes
143         decimals = _decimalUnits;
144         // Amount of decimals for display purposes
145         symbol = _tokenSymbol;
146         // Set the symbol for display purposes
147     }
148 }