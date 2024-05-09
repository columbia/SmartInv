1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title Contract for object that have an owner
5  */
6 contract Owned {
7     /**
8      * Contract owner address
9      */
10     address public owner;
11 
12     /**
13      * @dev Delegate contract to another person
14      * @param _owner New owner address 
15      */
16     function setOwner(address _owner) onlyOwner
17     { owner = _owner; }
18 
19     /**
20      * @dev Owner check modifier
21      */
22     modifier onlyOwner { if (msg.sender != owner) throw; _; }
23 }
24 
25 /**
26  * @title Common pattern for destroyable contracts 
27  */
28 contract Destroyable {
29     address public hammer;
30 
31     /**
32      * @dev Hammer setter
33      * @param _hammer New hammer address
34      */
35     function setHammer(address _hammer) onlyHammer
36     { hammer = _hammer; }
37 
38     /**
39      * @dev Destroy contract and scrub a data
40      * @notice Only hammer can call it 
41      */
42     function destroy() onlyHammer
43     { suicide(msg.sender); }
44 
45     /**
46      * @dev Hammer check modifier
47      */
48     modifier onlyHammer { if (msg.sender != hammer) throw; _; }
49 }
50 
51 /**
52  * @title Generic owned destroyable contract
53  */
54 contract Object is Owned, Destroyable {
55     function Object() {
56         owner  = msg.sender;
57         hammer = msg.sender;
58     }
59 }
60 
61 // Standard token interface (ERC 20)
62 // https://github.com/ethereum/EIPs/issues/20
63 contract ERC20 
64 {
65 // Functions:
66     /// @return total amount of tokens
67     uint256 public totalSupply;
68 
69     /// @param _owner The address from which the balance will be retrieved
70     /// @return The balance
71     function balanceOf(address _owner) constant returns (uint256);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) returns (bool);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85 
86     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of wei to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) returns (bool);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     function allowance(address _owner, address _spender) constant returns (uint256);
96 
97 // Events:
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 /**
103  * @title Token contract represents any asset in digital economy
104  */
105 contract Token is Object, ERC20 {
106     /* Short description of token */
107     string public name;
108     string public symbol;
109 
110     /* Total count of tokens exist */
111     uint public totalSupply;
112 
113     /* Fixed point position */
114     uint8 public decimals;
115     
116     /* Token approvement system */
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowances;
119  
120     /**
121      * @dev Get balance of plain address
122      * @param _owner is a target address
123      * @return amount of tokens on balance
124      */
125     function balanceOf(address _owner) constant returns (uint256)
126     { return balances[_owner]; }
127  
128     /**
129      * @dev Take allowed tokens
130      * @param _owner The address of the account owning tokens
131      * @param _spender The address of the account able to transfer the tokens
132      * @return Amount of remaining tokens allowed to spent
133      */
134     function allowance(address _owner, address _spender) constant returns (uint256)
135     { return allowances[_owner][_spender]; }
136 
137     /* Token constructor */
138     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
139         name        = _name;
140         symbol      = _symbol;
141         decimals    = _decimals;
142         totalSupply = _count;
143         balances[msg.sender] = _count;
144     }
145  
146     /**
147      * @dev Transfer self tokens to given address
148      * @param _to destination address
149      * @param _value amount of token values to send
150      * @notice `_value` tokens will be sended to `_to`
151      * @return `true` when transfer done
152      */
153     function transfer(address _to, uint _value) returns (bool) {
154         if (balances[msg.sender] >= _value) {
155             balances[msg.sender] -= _value;
156             balances[_to]        += _value;
157             Transfer(msg.sender, _to, _value);
158             return true;
159         }
160         return false;
161     }
162 
163     /**
164      * @dev Transfer with approvement mechainsm
165      * @param _from source address, `_value` tokens shold be approved for `sender`
166      * @param _to destination address
167      * @param _value amount of token values to send 
168      * @notice from `_from` will be sended `_value` tokens to `_to`
169      * @return `true` when transfer is done
170      */
171     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
172         var avail = allowances[_from][msg.sender]
173                   > balances[_from] ? balances[_from]
174                                     : allowances[_from][msg.sender];
175         if (avail >= _value) {
176             allowances[_from][msg.sender] -= _value;
177             balances[_from] -= _value;
178             balances[_to]   += _value;
179             Transfer(_from, _to, _value);
180             return true;
181         }
182         return false;
183     }
184 
185     /**
186      * @dev Give to target address ability for self token manipulation without sending
187      * @param _spender target address (future requester)
188      * @param _value amount of token values for approving
189      */
190     function approve(address _spender, uint256 _value) returns (bool) {
191         allowances[msg.sender][_spender] += _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Reset count of tokens approved for given address
198      * @param _spender target address (future requester)
199      */
200     function unapprove(address _spender)
201     { allowances[msg.sender][_spender] = 0; }
202 }
203 
204 /**
205  * @title Ethereum crypto currency extention for Token contract
206  */
207 contract TokenEther is Token {
208     function TokenEther(string _name, string _symbol)
209              Token(_name, _symbol, 18, 0)
210     {}
211 
212     /**
213      * @dev This is the way to withdraw money from token
214      * @param _value how many tokens withdraw from balance
215      */
216     function withdraw(uint _value) {
217         if (balances[msg.sender] >= _value) {
218             balances[msg.sender] -= _value;
219             totalSupply          -= _value;
220             if(!msg.sender.send(_value)) throw;
221         }
222     }
223 
224     /**
225      * @dev This is the way to refill your token balance by ethers
226      */
227     function refill() payable returns (bool) {
228         balances[msg.sender] += msg.value;
229         totalSupply          += msg.value;
230         return true;
231     }
232 
233     /**
234      * @dev This method is called when money sended to contract address,
235      *      a synonym for refill()
236      */
237     function () payable {
238         balances[msg.sender] += msg.value;
239         totalSupply          += msg.value;
240     }
241 }
242 
243 library CreatorTokenEther {
244     function create(string _name, string _symbol) returns (TokenEther)
245     { return new TokenEther(_name, _symbol); }
246 
247     function version() constant returns (string)
248     { return "v0.6.0 (1b4435b8)"; }
249 
250     function abi() constant returns (string)
251     { return '[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"setOwner","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"hammer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"refill","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hammer","type":"address"}],"name":"setHammer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"}],"name":"unapprove","outputs":[],"payable":false,"type":"function"},{"inputs":[{"name":"_name","type":"string"},{"name":"_symbol","type":"string"}],"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]'; }
252 }
253 
254 /**
255  * @title Builder based contract
256  */
257 contract Builder is Object {
258     /**
259      * @dev this event emitted for every builded contract
260      */
261     event Builded(address indexed client, address indexed instance);
262  
263     /* Addresses builded contracts at sender */
264     mapping(address => address[]) public getContractsOf;
265  
266     /**
267      * @dev Get last address
268      * @return last address contract
269      */
270     function getLastContract() constant returns (address) {
271         var sender_contracts = getContractsOf[msg.sender];
272         return sender_contracts[sender_contracts.length - 1];
273     }
274 
275     /* Building beneficiary */
276     address public beneficiary;
277 
278     /**
279      * @dev Set beneficiary
280      * @param _beneficiary is address of beneficiary
281      */
282     function setBeneficiary(address _beneficiary) onlyOwner
283     { beneficiary = _beneficiary; }
284 
285     /* Building cost  */
286     uint public buildingCostWei;
287 
288     /**
289      * @dev Set building cost
290      * @param _buildingCostWei is cost
291      */
292     function setCost(uint _buildingCostWei) onlyOwner
293     { buildingCostWei = _buildingCostWei; }
294 
295     /* Security check report */
296     string public securityCheckURI;
297 
298     /**
299      * @dev Set security check report URI
300      * @param _uri is an URI to report
301      */
302     function setSecurityCheck(string _uri) onlyOwner
303     { securityCheckURI = _uri; }
304 }
305 
306 //
307 // AIRA Builder for TokenEther contract
308 //
309 contract BuilderTokenEther is Builder {
310     /**
311      * @dev Run script creation contract
312      * @param _name is name token
313      * @param _symbol is symbol token
314      * @param _client is a contract destination address (zero for sender)
315      * @return address new contract
316      */
317     function create(string _name, string _symbol, address _client) payable returns (address) {
318         if (buildingCostWei > 0 && beneficiary != 0) {
319             // Too low value
320             if (msg.value < buildingCostWei) throw;
321             // Beneficiary send
322             if (!beneficiary.send(buildingCostWei)) throw;
323             // Refund
324             if (msg.value > buildingCostWei) {
325                 if (!msg.sender.send(msg.value - buildingCostWei)) throw;
326             }
327         } else {
328             // Refund all
329             if (msg.value > 0) {
330                 if (!msg.sender.send(msg.value)) throw;
331             }
332         }
333  
334         if (_client == 0)
335             _client = msg.sender;
336  
337         var inst = CreatorTokenEther.create(_name, _symbol);
338         getContractsOf[_client].push(inst);
339         Builded(_client, inst);
340         inst.setOwner(_client);
341         inst.setHammer(_client);
342         return inst;
343     }
344 }