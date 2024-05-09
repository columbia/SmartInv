1 /**
2  *Submitted for verification at Etherscan.io on 2017-02-06
3 */
4 pragma solidity ^0.4.21;
5 
6 contract Token {
7 
8     /// @return total amount of tokens
9     function totalSupply() constant returns (uint256 supply) {}
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) returns (bool success) {}
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
27 
28     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of wei to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) returns (bool success) {}
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
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
112 contract HumanStandardToken is StandardToken {
113 
114     function () {
115         //if ether is sent to this address, send it back.
116         throw;
117     }
118 
119     /* Public variables of the token */
120 
121     /*
122     NOTE:
123     The following variables are OPTIONAL vanities. One does not have to include them.
124     They allow one to customise the token contract & in no way influences the core functionality.
125     Some wallets/interfaces might not even bother to look at this information.
126     */
127     string public name;                   //fancy name: eg Simon Bucks
128     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
129     string public symbol;                 //An identifier: eg SBX
130     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
131 
132     function HumanStandardToken(
133         uint256 _initialAmount,
134         string _tokenName,
135         uint8 _decimalUnits,
136         string _tokenSymbol
137         ) {
138         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
139         totalSupply = _initialAmount;                        // Update total supply
140         name = _tokenName;                                   // Set the name for display purposes
141         decimals = _decimalUnits;                            // Amount of decimals for display purposes
142         symbol = _tokenSymbol;                               // Set the symbol for display purposes
143     }
144 
145     /* Approves and then calls the receiving contract */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149 
150         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
151         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
152         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
153         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
154         return true;
155     }
156 }