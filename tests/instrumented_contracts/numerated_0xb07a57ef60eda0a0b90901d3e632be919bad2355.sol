1 pragma solidity ^0.4.6;
2 /*
3 The SWIFT Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
4 
5 SWIFT contract extends HumanStandardToken, https://github.com/consensys/tokens
6 
7 .*/
8 contract Token {
9 
10     /// @return total amount of tokens
11     function totalSupply() constant returns (uint256 supply) {}
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89     uint256 public totalSupply;
90 }
91 
92 
93 contract SWIFTStandardToken is StandardToken {
94 
95     function () {
96         //if ether is sent to this address, send it back.
97         throw;
98     }
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;                   //fancy name: eg Simon Bucks
109     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
110     string public symbol;                 //An identifier: eg SBX
111     string public version = 'HE0.2';       //human 0.1 standard. Just an arbitrary versioning scheme.
112 
113     function SWIFTStandardToken(
114         uint256 _initialAmount,
115         string _tokenName,
116         uint8 _decimalUnits,
117         string _tokenSymbol
118         ) {
119         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
120         totalSupply = _initialAmount;                        // Update total supply
121         name = _tokenName;                                   // Set the name for display purposes
122         decimals = _decimalUnits;                            // Amount of decimals for display purposes
123         symbol = _tokenSymbol;                               // Set the symbol for display purposes
124     }
125 
126     /* Approves and then calls the receiving contract */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130 
131         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
132         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
133         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
134         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
135         return true;
136     }
137 }
138 
139 // Creates 20,000,000.000000000 SWIFT (SWIFT) Tokens
140 contract SWIFT is SWIFTStandardToken(20000000000000000, "SWIFT", 9, "SWIFT") {}