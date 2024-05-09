1 pragma solidity ^0.4.2;
2 /**
3  * @title Contract for object that have an owner
4  */
5 contract Owned {
6     /**
7      * Contract owner address
8      */
9     address public owner;
10 
11     /**
12      * @dev Store owner on creation
13      */
14     function Owned() { owner = msg.sender; }
15 
16     /**
17      * @dev Delegate contract to another person
18      * @param _owner is another person address
19      */
20     function delegate(address _owner) onlyOwner
21     { owner = _owner; }
22 
23     /**
24      * @dev Owner check modifier
25      */
26     modifier onlyOwner { if (msg.sender != owner) throw; _; }
27 }
28 /**
29  * @title Contract for objects that can be morder
30  */
31 contract Mortal is Owned {
32     /**
33      * @dev Destroy contract and scrub a data
34      * @notice Only owner can kill me
35      */
36     function kill() onlyOwner
37     { suicide(owner); }
38 }
39 
40 // Standard token interface (ERC 20)
41 // https://github.com/ethereum/EIPs/issues/20
42 contract ERC20 
43 {
44 // Functions:
45     /// @return total amount of tokens
46     uint256 public totalSupply;
47 
48     /// @param _owner The address from which the balance will be retrieved
49     /// @return The balance
50     function balanceOf(address _owner) constant returns (uint256);
51 
52     /// @notice send `_value` token to `_to` from `msg.sender`
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transfer(address _to, uint256 _value) returns (bool);
57 
58     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
64 
65     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @param _value The amount of wei to be approved for transfer
68     /// @return Whether the approval was successful or not
69     function approve(address _spender, uint256 _value) returns (bool);
70 
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) constant returns (uint256);
75 
76 // Events:
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 /**
82  * @title Token compatible contract represents any asset in digital economy
83  * @dev Accounting based on sha3 hashed identifiers
84  */
85 contract TokenHash is Mortal, ERC20 {
86     /* Short description of token */
87     string public name;
88     string public symbol;
89 
90     /* Fixed point position */
91     uint8 public decimals;
92 
93     /* Token approvement system */
94     mapping(bytes32 => uint256) balances;
95     mapping(bytes32 => mapping(bytes32 => uint256)) allowances;
96  
97     /**
98      * @dev Get balance of plain address
99      * @param _owner is a target address
100      * @return amount of tokens on balance
101      */
102     function balanceOf(address _owner) constant returns (uint256)
103     { return balances[sha3(_owner)]; }
104 
105     /**
106      * @dev Get balance of ident
107      * @param _owner is a target ident
108      * @return amount of tokens on balance
109      */
110     function balanceOf(bytes32 _owner) constant returns (uint256)
111     { return balances[_owner]; }
112 
113     /**
114      * @dev Take allowed tokens
115      * @param _owner The address of the account owning tokens
116      * @param _spender The address of the account able to transfer the tokens
117      * @return Amount of remaining tokens allowed to spent
118      */
119     function allowance(address _owner, address _spender) constant returns (uint256)
120     { return allowances[sha3(_owner)][sha3(_spender)]; }
121 
122     /**
123      * @dev Take allowed tokens
124      * @param _owner The ident of the account owning tokens
125      * @param _spender The ident of the account able to transfer the tokens
126      * @return Amount of remaining tokens allowed to spent
127      */
128     function allowance(bytes32 _owner, bytes32 _spender) constant returns (uint256)
129     { return allowances[_owner][_spender]; }
130 
131     /* Token constructor */
132     function TokenHash(string _name, string _symbol, uint8 _decimals, uint256 _count) {
133         name        = _name;
134         symbol      = _symbol;
135         decimals    = _decimals;
136         totalSupply = _count;
137         balances[sha3(msg.sender)] = _count;
138     }
139  
140     /**
141      * @dev Transfer self tokens to given address
142      * @param _to destination address
143      * @param _value amount of token values to send
144      * @notice `_value` tokens will be sended to `_to`
145      * @return `true` when transfer done
146      */
147     function transfer(address _to, uint256 _value) returns (bool) {
148         var sender = sha3(msg.sender);
149 
150         if (balances[sender] >= _value) {
151             balances[sender]    -= _value;
152             balances[sha3(_to)] += _value;
153             Transfer(msg.sender, _to, _value);
154             return true;
155         }
156         return false;
157     }
158 
159     /**
160      * @dev Transfer self tokens to given address
161      * @param _to destination ident
162      * @param _value amount of token values to send
163      * @notice `_value` tokens will be sended to `_to`
164      * @return `true` when transfer done
165      */
166     function transfer(bytes32 _to, uint256 _value) returns (bool) {
167         var sender = sha3(msg.sender);
168 
169         if (balances[sender] >= _value) {
170             balances[sender] -= _value;
171             balances[_to]    += _value;
172             TransferHash(sender, _to, _value);
173             return true;
174         }
175         return false;
176     }
177 
178 
179     /**
180      * @dev Transfer with approvement mechainsm
181      * @param _from source address, `_value` tokens shold be approved for `sender`
182      * @param _to destination address
183      * @param _value amount of token values to send 
184      * @notice from `_from` will be sended `_value` tokens to `_to`
185      * @return `true` when transfer is done
186      */
187     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
188         var to    = sha3(_to);
189         var from  = sha3(_from);
190         var sender= sha3(msg.sender);
191         var avail = allowances[from][sender]
192                   > balances[from] ? balances[from]
193                                    : allowances[from][sender];
194         if (avail >= _value) {
195             allowances[from][sender] -= _value;
196             balances[from] -= _value;
197             balances[to]   += _value;
198             Transfer(_from, _to, _value);
199             return true;
200         }
201         return false;
202     }
203 
204     /**
205      * @dev Transfer with approvement mechainsm
206      * @param _from source ident, `_value` tokens shold be approved for `sender`
207      * @param _to destination ident
208      * @param _value amount of token values to send 
209      * @notice from `_from` will be sended `_value` tokens to `_to`
210      * @return `true` when transfer is done
211      */
212     function transferFrom(bytes32 _from, bytes32 _to, uint256 _value) returns (bool) {
213         var sender= sha3(msg.sender);
214         var avail = allowances[_from][sender]
215                   > balances[_from] ? balances[_from]
216                                     : allowances[_from][sender];
217         if (avail >= _value) {
218             allowances[_from][sender] -= _value;
219             balances[_from] -= _value;
220             balances[_to]   += _value;
221             TransferHash(_from, _to, _value);
222             return true;
223         }
224         return false;
225     }
226 
227     /**
228      * @dev Give to target address ability for self token manipulation without sending
229      * @param _spender target address (future requester)
230      * @param _value amount of token values for approving
231      */
232     function approve(address _spender, uint256 _value) returns (bool) {
233         allowances[sha3(msg.sender)][sha3(_spender)] += _value;
234         Approval(msg.sender, _spender, _value);
235         return true;
236     }
237  
238     /**
239      * @dev Give to target ident ability for self token manipulation without sending
240      * @param _spender target ident (future requester)
241      * @param _value amount of token values for approving
242      */
243     function approve(bytes32 _spender, uint256 _value) returns (bool) {
244         allowances[sha3(msg.sender)][_spender] += _value;
245         ApprovalHash(sha3(msg.sender), _spender, _value);
246         return true;
247     }
248 
249     /**
250      * @dev Reset count of tokens approved for given address
251      * @param _spender target address
252      */
253     function unapprove(address _spender)
254     { allowances[sha3(msg.sender)][sha3(_spender)] = 0; }
255  
256     /**
257      * @dev Reset count of tokens approved for given ident
258      * @param _spender target ident
259      */
260     function unapprove(bytes32 _spender)
261     { allowances[sha3(msg.sender)][_spender] = 0; }
262  
263     /* Hash driven events */
264     event TransferHash(bytes32 indexed _from,  bytes32 indexed _to,      uint256 _value);
265     event ApprovalHash(bytes32 indexed _owner, bytes32 indexed _spender, uint256 _value);
266 }
267 
268 
269 //sol Registrar
270 // Simple global registrar.
271 // @authors:
272 //   Gav Wood <g@ethdev.com>
273 
274 contract Registrar {
275 	event Changed(string indexed name);
276 
277 	function owner(string _name) constant returns (address o_owner);
278 	function addr(string _name) constant returns (address o_address);
279 	function subRegistrar(string _name) constant returns (address o_subRegistrar);
280 	function content(string _name) constant returns (bytes32 o_content);
281 }
282 
283 //sol OwnedRegistrar
284 // Global registrar with single authoritative owner.
285 // @authors:
286 //   Gav Wood <g@ethdev.com>
287 
288 contract AiraRegistrarService is Registrar, Mortal {
289 	struct Record {
290 		address addr;
291 		address subRegistrar;
292 		bytes32 content;
293 	}
294 	
295     function owner(string _name) constant returns (address o_owner)
296     { return 0; }
297 
298 	function disown(string _name) onlyOwner {
299 		delete m_toRecord[_name];
300 		Changed(_name);
301 	}
302 
303 	function setAddr(string _name, address _a) onlyOwner {
304 		m_toRecord[_name].addr = _a;
305 		Changed(_name);
306 	}
307 	function setSubRegistrar(string _name, address _registrar) onlyOwner {
308 		m_toRecord[_name].subRegistrar = _registrar;
309 		Changed(_name);
310 	}
311 	function setContent(string _name, bytes32 _content) onlyOwner {
312 		m_toRecord[_name].content = _content;
313 		Changed(_name);
314 	}
315 	function record(string _name) constant returns (address o_addr, address o_subRegistrar, bytes32 o_content) {
316 		o_addr = m_toRecord[_name].addr;
317 		o_subRegistrar = m_toRecord[_name].subRegistrar;
318 		o_content = m_toRecord[_name].content;
319 	}
320 	function addr(string _name) constant returns (address) { return m_toRecord[_name].addr; }
321 	function subRegistrar(string _name) constant returns (address) { return m_toRecord[_name].subRegistrar; }
322 	function content(string _name) constant returns (bytes32) { return m_toRecord[_name].content; }
323 
324 	mapping (string => Record) m_toRecord;
325 }
326 
327 contract AiraEtherFunds is TokenHash {
328     function AiraEtherFunds(address _bot_reg, string _name, string _symbol)
329             TokenHash(_name, _symbol, 18, 0) {
330         reg = AiraRegistrarService(_bot_reg);
331     }
332 
333     /**
334      * @dev Event spawned when activation request received
335      */
336     event ActivationRequest(address indexed ident, bytes32 indexed code);
337 
338     // Balance limit
339     uint256 public limit;
340     
341     function setLimit(uint256 _limit) onlyOwner
342     { limit = _limit; }
343 
344     // Account activation fee
345     uint256 public fee;
346     
347     function setFee(uint256 _fee) onlyOwner
348     { fee = _fee; }
349 
350     /**
351      * @dev Refill balance and activate it by code
352      * @param _code is activation code
353      */
354     function activate(string _code) payable {
355         var value = msg.value;
356  
357         // Get a fee
358         if (fee > 0) {
359             if (value < fee) throw;
360             balances[sha3(owner)] += fee;
361             value                 -= fee;
362         }
363 
364         // Refund over limit
365         if (limit > 0 && value > limit) {
366             var refund = value - limit;
367             if (!msg.sender.send(refund)) throw;
368             value = limit;
369         }
370 
371         // Refill account balance
372         balances[sha3(msg.sender)] += value;
373         totalSupply                += value;
374 
375         // Activation event
376         ActivationRequest(msg.sender, stringToBytes32(_code));
377     }
378 
379     /**
380      * @dev String to bytes32 conversion helper
381      */
382     function stringToBytes32(string memory source) constant returns (bytes32 result)
383     { assembly { result := mload(add(source, 32)) } }
384 
385     /**
386      * @dev This is the way to refill token balance by ethers
387      * @param _dest is destination address
388      */
389     function refill(address _dest) payable returns (bool)
390     { return refill(sha3(_dest)); }
391 
392     /**
393      * @dev This method is called when money sended to contract address,
394      *      a synonym for refill()
395      */
396     function () payable
397     { refill(msg.sender); }
398 
399     /**
400      * @dev This is the way to refill token balance by ethers
401      * @param _dest is destination identifier
402      */
403     function refill(bytes32 _dest) payable returns (bool) {
404         // Throw when over limit
405         if (balances[_dest] + msg.value > limit) throw;
406 
407         // Refill
408         balances[_dest] += msg.value;
409         totalSupply     += msg.value;
410         return true;
411     }
412 
413     /**
414      * @dev Outgoing transfer (send) with allowance
415      * @param _from source identifier
416      * @param _to external destination address
417      * @param _value amount of token values to send 
418      */
419     function sendFrom(bytes32 _from, address _to, uint256 _value) {
420         var sender = sha3(msg.sender);
421         var avail = allowances[_from][sender]
422                   > balances[_from] ? balances[_from]
423                                     : allowances[_from][sender];
424         if (avail >= _value) {
425             allowances[_from][sender] -= _value;
426             balances[_from]           -= _value;
427             totalSupply               -= _value;
428             if (!_to.send(_value)) throw;
429         }
430     }
431 
432     AiraRegistrarService public reg;
433     modifier onlySecure { if (msg.sender != reg.addr("AiraSecure")) throw; _; }
434 
435     /**
436      * @dev Increase approved token values for AiraEthBot
437      * @param _client is a client ident
438      * @param _value is amount of tokens
439      */
440     function secureApprove(bytes32 _client, uint256 _value) onlySecure {
441         var ethBot = reg.addr("AiraEth");
442         if (ethBot != 0) {
443             allowances[_client][sha3(ethBot)] += _value;
444             ApprovalHash(_client, sha3(ethBot), _value);
445         }
446     }
447 
448     /**
449      * @dev Close allowance for AiraEthBot
450      * @param _client is a client ident
451      */
452     function secureUnapprove(bytes32 _client) onlySecure {
453         var ethBot = reg.addr("AiraEth");
454         if (ethBot != 0)
455             allowances[_client][sha3(ethBot)] = 0;
456     }
457 
458     // By security issues deny to kill this by owner
459     function kill() onlyOwner { throw; }
460 }