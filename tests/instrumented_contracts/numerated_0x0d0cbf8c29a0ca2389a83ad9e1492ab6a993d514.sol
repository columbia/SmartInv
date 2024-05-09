1 /**
2  * Source Code first verified at https://etherscan.io on Monday, February 6, 2017
3  (UTC) */
4 
5 contract Token {
6 
7     /// @return total amount of tokens
8     function totalSupply() constant returns (uint256 supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) constant returns (uint256 balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 /*
44 This implements ONLY the standard functions and NOTHING else.
45 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
46 
47 If you deploy this, you won't have anything useful.
48 
49 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
50 .*/
51 
52 contract StandardToken is Token {
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             Transfer(_from, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95     uint256 public totalSupply;
96 }
97 
98 /*
99 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
100 
101 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
102 Imagine coins, currencies, shares, voting weight, etc.
103 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
104 
105 1) Initial Finite Supply (upon creation one specifies how much is minted).
106 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
107 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
108 
109 .*/
110 
111 contract HumanStandardToken is StandardToken {
112 
113     function () {
114         //if ether is sent to this address, send it back.
115         throw;
116     }
117 
118     /* Public variables of the token */
119 
120     /*
121     NOTE:
122     The following variables are OPTIONAL vanities. One does not have to include them.
123     They allow one to customise the token contract & in no way influences the core functionality.
124     Some wallets/interfaces might not even bother to look at this information.
125     */
126     string public name;                   //fancy name: eg Simon Bucks
127     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
128     string public symbol;                 //An identifier: eg SBX
129     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
130 
131     function HumanStandardToken(
132         uint256 _initialAmount,
133         string _tokenName,
134         uint8 _decimalUnits,
135         string _tokenSymbol
136         ) {
137         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
138         totalSupply = _initialAmount;                        // Update total supply
139         name = _tokenName;                                   // Set the name for display purposes
140         decimals = _decimalUnits;                            // Amount of decimals for display purposes
141         symbol = _tokenSymbol;                               // Set the symbol for display purposes
142     }
143 
144     /* Approves and then calls the receiving contract */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
153         return true;
154     }
155 }