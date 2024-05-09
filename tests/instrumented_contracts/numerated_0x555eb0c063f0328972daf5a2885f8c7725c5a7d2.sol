1 contract Token {
2 
3 
4     /// @return total amount of tokens
5 
6     function totalSupply() constant returns (uint256 supply) {}
7 
8 
9     /// @param _owner The address from which the balance will be retrieved
10 
11     /// @return The balance
12 
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17 
18     /// @param _to The address of the recipient
19 
20     /// @param _value The amount of token to be transferred
21 
22     /// @return Whether the transfer was successful or not
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28 
29     /// @param _from The address of the sender
30 
31     /// @param _to The address of the recipient
32 
33     /// @param _value The amount of token to be transferred
34 
35     /// @return Whether the transfer was successful or not
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
38 
39 
40     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41 
42     /// @param _spender The address of the account able to transfer the tokens
43 
44     /// @param _value The amount of wei to be approved for transfer
45 
46     /// @return Whether the approval was successful or not
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {}
49 
50 
51     /// @param _owner The address of the account owning tokens
52 
53     /// @param _spender The address of the account able to transfer the tokens
54 
55     /// @return Amount of remaining tokens allowed to spent
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
58 
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64 
65 }
66 
67 
68 contract StandardToken is Token {
69 
70 
71     function transfer(address _to, uint256 _value) returns (bool success) {
72 
73         //Default assumes totalSupply can't be over max (2^256 - 1).
74 
75         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
76 
77         //Replace the if with this one instead.
78 
79         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
80 
81         if (balances[msg.sender] >= _value && _value > 0) {
82 
83             balances[msg.sender] -= _value;
84 
85             balances[_to] += _value;
86 
87             Transfer(msg.sender, _to, _value);
88 
89             return true;
90 
91         } else { return false; }
92 
93     }
94 
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
97 
98         //same as above. Replace this line with the following if you want to protect against wrapping uints.
99 
100         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101 
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103 
104             balances[_to] += _value;
105 
106             balances[_from] -= _value;
107 
108             allowed[_from][msg.sender] -= _value;
109 
110             Transfer(_from, _to, _value);
111 
112             return true;
113 
114         } else { return false; }
115 
116     }
117 
118 
119     function balanceOf(address _owner) constant returns (uint256 balance) {
120 
121         return balances[_owner];
122 
123     }
124 
125 
126     function approve(address _spender, uint256 _value) returns (bool success) {
127 
128         allowed[msg.sender][_spender] = _value;
129 
130         Approval(msg.sender, _spender, _value);
131 
132         return true;
133 
134     }
135 
136 
137     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138 
139       return allowed[_owner][_spender];
140 
141     }
142 
143 
144     mapping (address => uint256) balances;
145 
146     mapping (address => mapping (address => uint256)) allowed;
147 
148     uint256 public totalSupply;
149 
150 }
151 
152 
153 //name this contract whatever you'd like
154 
155 contract ERC20Token is StandardToken {
156 
157 
158     function () {
159 
160         //if ether is sent to this address, send it back.
161 
162         throw;
163 
164     }
165 
166 
167     /* Public variables of the token */
168 
169 
170     /*
171 
172     NOTE:
173 
174     The following variables are OPTIONAL vanities. One does not have to include them.
175 
176     They allow one to customise the token contract & in no way influences the core functionality.
177 
178     Some wallets/interfaces might not even bother to look at this information.
179 
180     */
181 
182     string public name;                   //fancy name: eg Simon Bucks
183 
184     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
185 
186     string public symbol;                 //An identifier: eg SBX
187 
188     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
189 
190 
191 //
192 
193 // CHANGE THESE VALUES FOR YOUR TOKEN
194 
195 //
196 
197 
198 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
199 
200 
201     function ERC20Token(
202 
203         ) {
204 
205         balances[msg.sender] = 50000000000;               // Give the creator all initial tokens (100000 for example)
206 
207         totalSupply = 50000000000;                        // Update total supply (100000 for example)
208 
209         name = "CryptoToken";                                   // Set the name for display purposes
210 
211         decimals = 2;                            // Amount of decimals for display purposes
212 
213         symbol = "CLC";                               // Set the symbol for display purposes
214 
215     }
216 
217 
218     /* Approves and then calls the receiving contract */
219 
220     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
221 
222         allowed[msg.sender][_spender] = _value;
223 
224         Approval(msg.sender, _spender, _value);
225 
226 
227         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
228 
229         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
230 
231         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
232 
233         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
234 
235         return true;
236 
237     }
238 
239 }