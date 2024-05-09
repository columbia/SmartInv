1 pragma solidity ^0.4.4;
2  
3 contract Token {
4     
5     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
6     assert(b <= a);
7     return a - b;
8     
9     }
10  
11     /// @return total amount of tokens
12     function totalSupply() constant returns (uint256 supply) {}
13  
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17  
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success) {}
23  
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
30  
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success) {}
36     
37     ///burns tokens from totaly supply forever
38     function burn(uint256 _value) returns (bool success) {}
39  
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
44  
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47     event Burn(address indexed burner, uint256 value);
48     
49 }
50  
51  
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
90     function burn(uint256 _value) returns (bool success) {
91         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough
92 		if (_value <= 0) throw; 
93         balances[msg.sender] = Token.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
94         totalSupply = Token.safeSub(totalSupply,_value);                                // Updates totalSupply
95         Burn(msg.sender, _value);
96         return true;
97     }
98  
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101     }
102  
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105     uint256 public totalSupply;
106 }
107  
108  
109 //name this contract whatever you'd like
110 contract OodlebitToken is StandardToken {
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
125     string public name;                   //fancy name: eg Simon Bucks
126     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
127     string public symbol;                 //An identifier: eg SBX
128     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
129  
130 //
131 // CHANGE THESE VALUES FOR YOUR TOKEN
132 //
133  
134 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
135  
136     function OodlebitToken(
137         ) {
138         balances[msg.sender] = 200000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
139         totalSupply = 200000000000000000000000000;                        // Update total supply (100000 for example)
140         name = "OODL";                                   // Set the name for display purposes
141         decimals = 18;                            // Amount of decimals for display purposes
142         symbol = "OODL";                               // Set the symbol for display purposes
143         
144         //200000000000000000000000000
145         //18 decimals
146         //total supply: 200,000,000 OODL
147     }
148  
149     /* Approves and then calls the receiving contract */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153  
154         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
155         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
156         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
157         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
158         return true;
159     }
160 }