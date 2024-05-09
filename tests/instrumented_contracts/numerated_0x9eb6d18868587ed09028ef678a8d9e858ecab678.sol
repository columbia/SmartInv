1 pragma solidity ^0.4.4;
2  
3 contract Token {
4     
5     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
6     assert(b <= a);
7     return a - b;
8     }
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
36     ///burns tokens from totaly supply forever
37     function burn(uint256 _value) returns (bool success) {}
38  
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43  
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     event Burn(address indexed burner, uint256 value);
47     
48 }
49  
50  
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
89     function burn(uint256 _value) returns (bool success) {
90         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough
91 		if (_value <= 0) throw; 
92         balances[msg.sender] = Token.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
93         totalSupply = Token.safeSub(totalSupply,_value);                                // Updates totalSupply
94         Burn(msg.sender, _value);
95         return true;
96     }
97  
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101  
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     uint256 public totalSupply;
105 }
106  
107  
108 //name this contract whatever you'd like
109 contract MathisTestToken is StandardToken {
110  
111     function () {
112         //if ether is sent to this address, send it back.
113         throw;
114     }
115  
116     /* Public variables of the token */
117  
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customise the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
128  
129 //
130 // CHANGE THESE VALUES FOR YOUR TOKEN
131 //
132  
133 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
134  
135     function MathisTestToken(
136         ) {
137         balances[msg.sender] = 200000000;               // Give the creator all initial tokens (100000 for example)
138         totalSupply = 200000000;                        // Update total supply (100000 for example)
139         name = "Mathis TestCoin";                                   // Set the name for display purposes
140         decimals = 0;                            // Amount of decimals for display purposes
141         symbol = "MATHTEST";                               // Set the symbol for display purposes
142         
143         //200000000000000000000000000
144         //18 decimals
145         //total supply: 200,000,000 OODL
146     }
147  
148     /* Approves and then calls the receiving contract */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152  
153         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
154         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
155         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
156         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
157         return true;
158     }
159 }