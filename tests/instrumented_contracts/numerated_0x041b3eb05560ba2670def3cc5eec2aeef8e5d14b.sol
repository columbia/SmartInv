1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.11;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55             balances[msg.sender] -= _value;
56             balances[_to] += _value;
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 }
89 
90 contract CNYToken is StandardToken {
91 
92     function () {
93         //if ether is sent to this address, send it back.
94         throw;
95     }
96 
97     address public founder;               // The address of the founder
98     string public name;                   // fancy name: eg Simon Bucks
99     uint8 public decimals;                // How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
100     string public symbol;                 // An identifier: eg SBX
101     string public version = 'CNY1.0';     // CNY 0.1 standard. Just an arbitrary versioning scheme.
102     
103 
104     // The nonce for avoid transfer replay attacks
105     mapping(address => uint256) nonces;
106 
107     // The last comment for address
108     mapping(address => string) lastComment;
109 
110     // The comments for transfers per address
111     mapping (address => mapping (uint256 => string)) comments;
112 
113     function CNYToken(
114         uint256 _initialAmount,
115         string _tokenName,
116         uint8 _decimalUnits,
117         string _tokenSymbol) {
118         founder = msg.sender;                                // Save the creator address
119         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
120         totalSupply = _initialAmount;                        // Update total supply
121         name = _tokenName;                                   // Set the name for display purposes
122         decimals = _decimalUnits;                            // Amount of decimals for display purposes
123         symbol = _tokenSymbol;                               // Set the symbol for display purposes  
124     }
125 
126    function transferWithComment(address _to, uint256 _value, string _comment) returns (bool success) {
127         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
128             balances[msg.sender] -= _value;
129             balances[_to] += _value;
130             lastComment[msg.sender] = _comment;
131             Transfer(msg.sender, _to, _value);
132             return true;
133         } else { return false; }
134     }
135 
136     function transferFromWithComment(address _from, address _to, uint256 _value, string _comment) returns (bool success) {
137         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
138             balances[_to] += _value;
139             balances[_from] -= _value;
140             allowed[_from][msg.sender] -= _value;
141             lastComment[_from] = _comment;
142             Transfer(_from, _to, _value);
143             return true;
144         } else { return false; }
145     }
146 
147     function balanceOf(address _owner) constant returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151     function approve(address _spender, uint256 _value) returns (bool success) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /*
158      * Proxy transfer CNY token. When some users of the ethereum account has no ether,
159      * he or she can authorize the agent for broadcast transactions, and agents may charge agency fees
160      * @param _from
161      * @param _to
162      * @param _value
163      * @param fee
164      * @param _v
165      * @param _r
166      * @param _s
167      * @param _comment
168      */
169     function transferProxy(address _from, address _to, uint256 _value, uint256 _fee,
170         uint8 _v,bytes32 _r, bytes32 _s, string _comment) returns (bool){
171 
172         if(balances[_from] < _fee + _value) throw;
173 
174         uint256 nonce = nonces[_from];
175                 
176         bytes32 hash = sha3(_from,_to,_value,_fee,nonce);
177         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
178         bytes32 prefixedHash = sha3(prefix, hash);
179         if(_from != ecrecover(prefixedHash,_v,_r,_s)) throw;
180 
181         if(balances[_to] + _value < balances[_to]
182             || balances[msg.sender] + _fee < balances[msg.sender]) throw;
183         balances[_to] += _value;
184         Transfer(_from, _to, _value);
185 
186         balances[msg.sender] += _fee;
187         Transfer(_from, msg.sender, _fee);
188 
189         balances[_from] -= _value + _fee;
190         lastComment[_from] = _comment;
191         comments[_from][nonce] = _comment;
192         nonces[_from] = nonce + 1;
193         
194         return true;
195     }
196 
197     /*
198      * Proxy approve that some one can authorize the agent for broadcast transaction
199      * which call approve method, and agents may charge agency fees
200      * @param _from The  address which should tranfer CNY to others
201      * @param _spender The spender who allowed by _from
202      * @param _value The value that should be tranfered.
203      * @param _v
204      * @param _r
205      * @param _s
206      * @param _comment
207      */
208     function approveProxy(address _from, address _spender, uint256 _value,
209         uint8 _v,bytes32 _r, bytes32 _s, string _comment) returns (bool success) {
210 
211         if(balances[_from] < _value) throw;
212         
213         uint256 nonce = nonces[_from];
214         
215         bytes32 hash = sha3(_from,_spender,_value,nonce);
216         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
217         bytes32 prefixedHash = sha3(prefix, hash);
218         if(_from != ecrecover(prefixedHash,_v,_r,_s)) throw;
219 
220         allowed[_from][_spender] = _value;
221         Approval(_from, _spender, _value);
222         lastComment[_from] = _comment;
223         comments[_from][nonce] = _comment;
224         nonces[_from] = nonce + 1;
225         return true;
226     }
227 
228 
229     /*
230      * Get the nonce
231      * @param _addr
232      */
233     function getNonce(address _addr) constant returns (uint256){
234         return nonces[_addr];
235     }
236 
237     /*
238      * Get last comment
239      * @param _addr
240      */
241     function getLastComment(address _addr) constant returns (string){
242         return lastComment[_addr];
243     }
244 
245     /*
246      * Get specified comment
247      * @param _addr
248      */
249     function getSpecifiedComment(address _addr, uint256 _nonce) constant returns (string){
250         if (nonces[_addr] < _nonce) throw;
251         return comments[_addr][_nonce];
252     }
253 
254     /* Approves and then calls the receiving contract */
255     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
256         allowed[msg.sender][_spender] = _value;
257         Approval(msg.sender, _spender, _value);
258 
259         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
260         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
261         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
262         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
263         return true;
264     }
265 
266     /* Approves and then calls the contract code*/
267     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270 
271         //Call the contract code
272         if(!_spender.call(_extraData)) { throw; }
273         return true;
274     }
275 
276     /* This notifies clients about the amount burnt */
277     event Burn(address indexed from, uint256 value);
278 
279     function burn(uint256 _value) returns (bool success) {
280         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough
281         balances[msg.sender] -= _value;                      // Subtract from the sender
282         totalSupply -= _value;                                // Updates totalSupply
283         Burn(msg.sender, _value);
284         return true;
285     }
286 
287     function burnFrom(address _from, uint256 _value) returns (bool success) {
288         if (balances[_from] < _value) throw;                // Check if the sender has enough
289         if (_value > allowed[_from][msg.sender]) throw;    // Check allowance
290         balances[_from] -= _value;                          // Subtract from the sender
291         totalSupply -= _value;                               // Updates totalSupply
292         Burn(_from, _value);
293         return true;
294     }
295 
296     /* This notifies clients about the amount increament */
297     event Increase(address _to, uint256 _value);
298 
299     // Allocate tokens to the users
300     // @param _to The owner of the token
301     // @param _value The value of the token
302     function allocateTokens(address _to, uint256 _value) {
303         if(msg.sender != founder) throw;            // only the founder have the authority
304         if(totalSupply + _value <= totalSupply || balances[_to] + _value <= balances[_to]) throw;
305         totalSupply += _value;
306         balances[_to] += _value;
307         Increase(_to,_value);
308     }
309 }