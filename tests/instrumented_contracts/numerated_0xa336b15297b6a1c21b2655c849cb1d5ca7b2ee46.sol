1 pragma solidity ^0.4.4;
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
40 /*
41 This implements ONLY the standard functions and NOTHING else.
42 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
43 
44 If you deploy this, you won't have anything useful.
45 
46 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
47 .*/
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
93     uint256 public totalSupply;
94 }
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
110 contract PumpAndHold is StandardToken {
111 
112     function () {
113         //if ether is sent to this address, send it back.
114         throw;
115     }
116 
117     /* Public variables of the token */
118 
119     /*
120     NOTE:
121     The following variables are OPTIONAL vanities. One does not have to include them.
122     They allow one to customise the token contract & in no way influences the core functionality.
123     Some wallets/interfaces might not even bother to look at this information.
124     */
125     string public name;    //fancy name: eg Simon Bucks
126     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
127     string public symbol;                 //An identifier: eg SBX
128     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
129 
130     function PumpAndHold() {
131         balances[msg.sender] = 100000000000000000;       // Give the creator all initial tokens
132         totalSupply = 100000000000000000;                // Update total supply
133         name = 'Pump And Hold';                          // Set the name for display purposes
134         decimals = 8;                                    // Amount of decimals for display purposes
135         symbol = 'PNHD';                                 // Set the symbol for display purposes
136     }
137 
138     /* Approves and then calls the receiving contract */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142 
143         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
144         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
145         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
146         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
147         return true;
148     }
149 }