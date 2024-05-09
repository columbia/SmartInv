1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6 
7     function totalSupply() constant returns (uint256 supply) {}
8     
9 
10     
11     /// @param _owner The address from which the balance will be retrieved
12 
13     /// @return The balance
14 
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17  
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20 
21     /// @param _to The address of the recipient
22 
23     /// @param _value The amount of token to be transferred
24 
25     /// @return Whether the transfer was successful or not
26 
27     function transfer(address _to, uint256 _value) returns (bool success) {}
28 
29  
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32 
33     /// @param _from The address of the sender
34 
35     /// @param _to The address of the recipient
36 
37     /// @param _value The amount of token to be transferred
38 
39     /// @return Whether the transfer was successful or not
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
42 
43  
44 
45     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46 
47     /// @param _spender The address of the account able to transfer the tokens
48 
49     /// @param _value The amount of wei to be approved for transfer
50 
51     /// @return Whether the approval was successful or not
52 
53     function approve(address _spender, uint256 _value) returns (bool success) {}
54 
55  
56 
57     /// @param _owner The address of the account owning tokens
58 
59     /// @param _spender The address of the account able to transfer the tokens
60 
61     /// @return Amount of remaining tokens allowed to spent
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
64 
65  
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68 
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71 }
72 
73  
74 
75 contract StandardToken is Token {
76 
77 
78     function transfer(address _to, uint256 _value) returns (bool success) {
79 
80         //Default assumes totalSupply can't be over max (2^256 - 1).
81 
82         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
83 
84         //Replace the if with this one instead.
85 
86         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87 
88         if (balances[msg.sender] >= _value && _value > 0) {
89 
90             balances[msg.sender] -= _value;
91 
92             balances[_to] += _value;
93 
94             Transfer(msg.sender, _to, _value);
95 
96             return true;
97 
98         } else { return false; }
99 
100     }
101 
102  
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104 
105         //same as above. Replace this line with the following if you want to protect against wrapping uints.
106 
107         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
108 
109         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
110 
111             balances[_to] += _value;
112 
113             balances[_from] -= _value;
114 
115             allowed[_from][msg.sender] -= _value;
116 
117             Transfer(_from, _to, _value);
118 
119             return true;
120 
121         } else { return false; }
122 
123     }
124 
125  
126     function balanceOf(address _owner) constant returns (uint256 balance) {
127 
128         return balances[_owner];
129 
130     }
131 
132 
133     function approve(address _spender, uint256 _value) returns (bool success) {
134 
135         allowed[msg.sender][_spender] = _value;
136 
137         Approval(msg.sender, _spender, _value);
138 
139         return true;
140 
141     }
142 
143 
144     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145 
146       return allowed[_owner][_spender];
147 
148     }
149 
150  
151 
152     mapping (address => uint256) balances;
153 
154     mapping (address => mapping (address => uint256)) allowed;
155 
156     uint256 public totalSupply;
157 
158 }
159 
160  
161 
162  
163 
164 //name this contract whatever you'd like
165 
166 contract ERC20Token is StandardToken {
167 
168 
169     function () {
170 
171         //if ether is sent to this address, send it back.
172 
173         throw;
174 
175     }
176  
177 
178     /* Public variables of the token */
179 
180 
181     /*
182 
183     NOTE:
184 
185     The following variables are OPTIONAL vanities. One does not have to include them.
186 
187     They allow one to customise the token contract & in no way influences the core functionality.
188 
189     Some wallets/interfaces might not even bother to look at this information.
190 
191     */
192 
193     string public name;                   //fancy name: eg Simon Bucks
194 
195     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
196 
197     string public symbol;                 //An identifier: eg SBX
198 
199     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
200 
201  
202 
203 //
204 
205 // CHANGE THESE VALUES FOR YOUR TOKEN
206 
207 //
208 
209  
210 
211 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
212 
213  
214 
215     function ERC20Token(         ) {
216 
217         balances[msg.sender] = 1000000000000000; // Give the creator all initial tokens (100000 for example)
218 
219         totalSupply = 1000000000000000;          // Update total supply (100000 for example)
220 
221         name = "HermanToken";                 // Set the name for display purposes
222 
223         decimals = 10;           // Amount of decimals for display purposes
224 
225         symbol = "HETK";             // Set the symbol for display purposes
226 
227     }
228 
229  
230 
231     /* Approves and then calls the receiving contract */
232 
233     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
234 
235         allowed[msg.sender][_spender] = _value;
236 
237         Approval(msg.sender, _spender, _value);
238 
239  
240 
241         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
242 
243         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
244 
245         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
246 
247         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
248 
249         return true;
250 
251     }
252 
253 }