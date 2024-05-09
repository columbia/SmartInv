1 pragma solidity ^0.4.25;
2 
3 
4 
5 
6 contract Token {
7 
8 
9 
10 
11 /// @return total amount of tokens
12 function totalSupply() constant returns (uint256 supply) {}
13 
14 
15 
16 
17 /// @param _owner The address from which the balance will be retrieved
18 /// @return The balance
19 function balanceOf(address _owner) constant returns (uint256 balance) {}
20 
21 
22 
23 
24 /// @notice send `_value` token to `_to` from `msg.sender`
25 /// @param _to The address of the recipient
26 /// @param _value The amount of token to be transferred
27 /// @return Whether the transfer was successful or not
28 function transfer(address _to, uint256 _value) returns (bool success) {}
29 
30 
31 
32 
33 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34 /// @param _from The address of the sender
35 /// @param _to The address of the recipient
36 /// @param _value The amount of token to be transferred
37 /// @return Whether the transfer was successful or not
38 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
39 
40 
41 
42 
43 /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44 /// @param _spender The address of the account able to transfer the tokens
45 /// @param _value The amount of wei to be approved for transfer
46 /// @return Whether the approval was successful or not
47 function approve(address _spender, uint256 _value) returns (bool success) {}
48 
49 
50 
51 
52 /// @param _owner The address of the account owning tokens
53 /// @param _spender The address of the account able to transfer the tokens
54 /// @return Amount of remaining tokens allowed to spent
55 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
56 
57 
58 
59 
60 event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 
63 
64 
65 
66 }
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 contract StandardToken is Token {
80 
81 
82 
83 
84 function transfer(address _to, uint256 _value) returns (bool success) {
85 //Default assumes totalSupply can't be over max (2^256 - 1).
86 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
87 //Replace the if with this one instead.
88 //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
89 if (balances[msg.sender] >= _value && _value > 0) {
90 balances[msg.sender] -= _value;
91 balances[_to] += _value;
92 Transfer(msg.sender, _to, _value);
93 return true;
94 } else { return false; }
95 }
96 
97 
98 
99 
100 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101 //same as above. Replace this line with the following if you want to protect against wrapping uints.
102 //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104 balances[_to] += _value;
105 balances[_from] -= _value;
106 allowed[_from][msg.sender] -= _value;
107 Transfer(_from, _to, _value);
108 return true;
109 } else { return false; }
110 }
111 
112 
113 
114 
115 function balanceOf(address _owner) constant returns (uint256 balance) {
116 return balances[_owner];
117 }
118 
119 
120 
121 
122 function approve(address _spender, uint256 _value) returns (bool success) {
123 allowed[msg.sender][_spender] = _value;
124 Approval(msg.sender, _spender, _value);
125 return true;
126 }
127 
128 
129 
130 
131 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132 return allowed[_owner][_spender];
133 }
134 
135 
136 
137 
138 mapping (address => uint256) balances;
139 mapping (address => mapping (address => uint256)) allowed;
140 uint256 public totalSupply;
141 }
142 
143 
144 
145 
146 
147 
148 
149 
150 //name this contract whatever you'd like
151 contract DexQCoin is StandardToken {
152 
153 
154 
155 
156 function () {
157 //if ether is sent to this address, send it back.
158 throw;
159 }
160 
161 
162 
163 
164 /* Public variables of the token */
165 
166 
167 
168 
169 /*
170 NOTE:
171 The following variables are OPTIONAL vanities. One does not have to include them.
172 They allow one to customise the token contract & in no way influences the core functionality.
173 Some wallets/interfaces might not even bother to look at this information.
174 */
175 string public name; //fancy name: eg Simon Bucks
176 uint8 public decimals;//How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
177 string public symbol; //An identifier: eg SBX
178 string public version = 'H1.0'; //human 0.1 standard. Just an arbitrary versioning scheme.
179 
180 
181 
182 
183 //
184 // CHANGE THESE VALUES FOR YOUR TOKEN
185 //
186 
187 
188 
189 
190 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
191 
192 
193 
194 
195 function DexQCoin(
196 ) {
197 balances[msg.sender] = 20000000000000000; // Give the creator all initial tokens (100000 for example)
198 totalSupply = 20000000000000000;// Update total supply (100000 for example)
199 name = "Dexq Coin"; // Set the name for display purposes
200 decimals = 6;// Amount of decimals for display purposes
201 symbol = "DXQ"; // Set the symbol for display purposes
202 }
203 
204 
205 
206 
207 /* Approves and then calls the receiving contract */
208 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
209 allowed[msg.sender][_spender] = _value;
210 Approval(msg.sender, _spender, _value);
211 
212 
213 
214 
215 //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
216 //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
217 //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
218 if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
219 return true;
220 }
221 }