1 /*
2  The Delta Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
3  Delta Token Contract extends HumanStandardToken, https://github.com/consensys/tokens
4  .*/
5 
6 
7 //The code seems to be mainly from ConsenSys (which is alright),
8 //but I didn't know they had this kind of quality challenges: the comments are misleading and incomplete,-
9 
10 //1. and places where they should have been used the safeMath, they have provided a commented-out alternative lines.
11 //do we need safemath? as far as I understand safe math has a bigger impact on the blockchain execution -> more expensive contract execution
12 //so that is why it is not encapsulated
13 
14 //2. They haven't also followed the solidity style guides, especially on indentations.
15 
16 //3. Also NatSpec is only partly followed.
17 
18 //4. Also I think they use "version" wrong, but will check that. I will let them know :)
19 
20 //Do you plan to transfer tokens immediately upon received transaction?
21 
22 
23 
24 pragma solidity ^0.4.8;
25 
26 contract Token {
27     /* This is a slight change to the ERC20 base standard. */
28     /// total amount of tokens
29     uint256 public totalSupply;
30 
31     /// @param _owner The address from which the balance will be retrieved
32     /// @return The balance
33     function balanceOf(address _owner) constant returns (uint256 balance);
34 
35     /// @notice send `_value` token to `_to` from `msg.sender`
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transfer(address _to, uint256 _value) returns (bool success);
40 
41     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
42     /// @param _from The address of the sender
43     /// @param _to The address of the recipient
44     /// @param _value The amount of token to be transferred
45     /// @return Whether the transfer was successful or not
46     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
47 
48     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @param _value The amount of tokens to be approved for transfer
51     /// @return Whether the approval was successful or not
52     function approve(address _spender, uint256 _value) returns (bool success);
53 
54     /// @param _owner The address of the account owning tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @return Amount of remaining tokens allowed to spent
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 }
62 
63 
64 contract StandardToken is Token {
65 
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         //Default assumes totalSupply can't be over max (2^256 - 1).
68         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
69         //Replace the if with this one instead.
70         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[msg.sender] >= _value && _value > 0) {
72             balances[msg.sender] -= _value;
73             balances[_to] += _value;
74             Transfer(msg.sender, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         //same as above. Replace this line with the following if you want to protect against wrapping uints.
81         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
83             balances[_to] += _value;
84             balances[_from] -= _value;
85             allowed[_from][msg.sender] -= _value;
86             Transfer(_from, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function balanceOf(address _owner) constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107 }
108 
109 
110 contract HumanStandardToken is StandardToken {
111 
112     function () {
113         //if ether is sent to this address, send it back.
114         throw;
115     }
116 
117     /* Public variables of the token */
118 
119     string public name;                   //fancy name: eg Simon Bucks
120     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
121     string public symbol;                 //An identifier: eg SBX
122     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
123 
124     function HumanStandardToken(
125     uint256 _initialAmount,
126     string _tokenName,
127     uint8 _decimalUnits,
128     string _tokenSymbol
129     ) {
130         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
131         totalSupply = _initialAmount;                        // Update total supply
132         name = _tokenName;                                   // Set the name for display purposes
133         decimals = _decimalUnits;                            // Amount of decimals for display purposes
134         symbol = _tokenSymbol;                               // Set the symbol for display purposes
135     }
136 
137     /* Approves and then calls the receiving contract */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141 
142         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
143         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
144         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
145         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
146         return true;
147     }
148 }
149 
150 // Creates 160,000,000.000000000000000000 TokenAAA17 Tokens
151 contract TokenAAA17 is HumanStandardToken(160000000000000000000000000, "TokenAAA17", 18, "AAA17") {}