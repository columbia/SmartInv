1 /* Darth Jahus Token (DJX) */
2 /* For personal use only.  */
3 /* Forked from TokenFactory (https://github.com/ConsenSys/Token-Factory) */
4 
5 pragma solidity ^0.4.4;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 /*
45 This implements ONLY the standard functions and NOTHING else.
46 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
47 
48 If you deploy this, you won't have anything useful.
49 
50 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
51 .*/
52 
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
98 
99 /*
100 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
101 
102 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
103 Imagine coins, currencies, shares, voting weight, etc.
104 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
105 
106 1) Initial Finite Supply (upon creation one specifies how much is minted).
107 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
108 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
109 
110 .*/
111 
112 contract DarthJahusToken is StandardToken {
113 
114     function () {
115         //if ether is sent to this address, send it back.
116         revert();
117     }
118 
119     /* Public variables of the token */
120 	uint256 _initialAmount = 1000000;
121     string _tokenName = "Darth Jahus Token";
122     uint8 _decimalUnits = 0;
123     string _tokenSymbol = "DJX";
124     /*
125     NOTE:
126     The following variables are OPTIONAL vanities. One does not have to include them.
127     They allow one to customise the token contract & in no way influences the core functionality.
128     Some wallets/interfaces might not even bother to look at this information.
129     */
130     string public name;                   //fancy name: eg Simon Bucks
131     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
132     string public symbol;                 //An identifier: eg SBX
133     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
134 
135     function DarthJahusToken() {
136         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
137         totalSupply = _initialAmount;                        // Update total supply
138         name = _tokenName;                                   // Set the name for display purposes
139         decimals = _decimalUnits;                            // Amount of decimals for display purposes
140         symbol = _tokenSymbol;                               // Set the symbol for display purposes
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
152         return true;
153     }
154 }