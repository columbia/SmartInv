1 pragma solidity ^0.4.4;
2 
3  
4 
5 contract Token {
6 
7  
8 
9     /// @return total amount of tokens
10 
11     function totalSupply() constant returns (uint256 supply) {}
12 
13  
14 
15     /// @param _owner The address from which the balance will be retrieved
16 
17     /// @return The balance
18 
19     function balanceOf(address _owner) constant returns (uint256 balance) {}
20 
21  
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24 
25     /// @param _to The address of the recipient
26 
27     /// @param _value The amount of token to be transferred
28 
29     /// @return Whether the transfer was successful or not
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {}
32 
33  
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36 
37     /// @param _from The address of the sender
38 
39     /// @param _to The address of the recipient
40 
41     /// @param _value The amount of token to be transferred
42 
43     /// @return Whether the transfer was successful or not
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47  
48 
49     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50 
51     /// @param _spender The address of the account able to transfer the tokens
52 
53     /// @param _value The amount of wei to be approved for transfer
54 
55     /// @return Whether the approval was successful or not
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {}
58 
59  
60 
61     /// @param _owner The address of the account owning tokens
62 
63     /// @param _spender The address of the account able to transfer the tokens
64 
65     /// @return Amount of remaining tokens allowed to spent
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
68 
69  
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72 
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75    
76 
77 }
78 
79  
80 
81  
82 
83  
84 
85 contract StandardToken is Token {
86 
87  
88 
89     function transfer(address _to, uint256 _value) returns (bool success) {
90 
91         //Default assumes totalSupply can't be over max (2^256 - 1).
92 
93         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
94 
95         //Replace the if with this one instead.
96 
97         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
98 
99         if (balances[msg.sender] >= _value && _value > 0) {
100 
101             balances[msg.sender] -= _value;
102 
103             balances[_to] += _value;
104 
105             Transfer(msg.sender, _to, _value);
106 
107             return true;
108 
109         } else { return false; }
110 
111     }
112 
113  
114 
115     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
116 
117         //same as above. Replace this line with the following if you want to protect against wrapping uints.
118 
119         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
120 
121         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
122 
123             balances[_to] += _value;
124 
125             balances[_from] -= _value;
126 
127             allowed[_from][msg.sender] -= _value;
128 
129             Transfer(_from, _to, _value);
130 
131             return true;
132 
133         } else { return false; }
134 
135     }
136 
137  
138 
139     function balanceOf(address _owner) constant returns (uint256 balance) {
140 
141         return balances[_owner];
142 
143     }
144 
145  
146 
147     function approve(address _spender, uint256 _value) returns (bool success) {
148 
149         allowed[msg.sender][_spender] = _value;
150 
151         Approval(msg.sender, _spender, _value);
152 
153         return true;
154 
155     }
156 
157  
158 
159     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
160 
161       return allowed[_owner][_spender];
162 
163     }
164 
165  
166 
167     mapping (address => uint256) balances;
168 
169     mapping (address => mapping (address => uint256)) allowed;
170 
171     uint256 public totalSupply;
172 
173 }
174 
175  
176 
177  
178 
179 //name this contract whatever you'd like
180 
181 contract RYNOTE is StandardToken {
182 
183  
184 
185     function () {
186 
187         //if ether is sent to this address, send it back.
188 
189         throw;
190 
191     }
192 
193  
194 
195     /* Public variables of the token */
196 
197  
198 
199     /*
200 
201     NOTE:
202 
203     The following variables are OPTIONAL vanities. One does not have to include them.
204 
205     They allow one to customise the token contract & in no way influences the core functionality.
206 
207     Some wallets/interfaces might not even bother to look at this information.
208 
209     */
210 
211     string public name;                   //fancy name: eg Simon Bucks
212 
213     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
214 
215     string public symbol;                 //An identifier: eg SBX
216 
217     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
218 
219  
220 
221 //
222 
223 // CHANGE THESE VALUES FOR YOUR TOKEN
224 
225 //
226 
227  
228 
229 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
230 
231  
232 
233     function RYNOTE(
234 
235         ) {
236 
237         balances[msg.sender] = 50000000000000000;               // Give the creator all initial tokens (100000 for example)
238 
239         totalSupply = 50000000000000000;                        // Update total supply (100000 for example)
240 
241         name = "RYNOTE";                                   // Set the name for display purposes
242 
243         decimals = 6;                            // Amount of decimals for display purposes
244 
245         symbol = "RYN";                               // Set the symbol for display purposes
246 
247     }
248 
249  
250 
251     /* Approves and then calls the receiving contract */
252 
253     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
254 
255         allowed[msg.sender][_spender] = _value;
256 
257         Approval(msg.sender, _spender, _value);
258 
259  
260 
261         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
262 
263         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
264 
265         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
266 
267         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
268 
269         return true;
270 
271     }
272 
273 }