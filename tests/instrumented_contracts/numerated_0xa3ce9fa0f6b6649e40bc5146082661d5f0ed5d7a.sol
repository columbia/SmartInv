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
39 /**
40  * @title Token contract represents any asset in digital economy
41  */
42 contract Token is Mortal {
43     event Transfer(address indexed _from,  address indexed _to,      uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     /* Short description of token */
47     string public name;
48     string public symbol;
49 
50     /* Total count of tokens exist */
51     uint public totalSupply;
52 
53     /* Fixed point position */
54     uint8 public decimals;
55     
56     /* Token approvement system */
57     mapping(address => uint) public balanceOf;
58     mapping(address => mapping(address => uint)) public allowance;
59  
60     /**
61      * @return available balance of `sender` account (self balance)
62      */
63     function getBalance() constant returns (uint)
64     { return balanceOf[msg.sender]; }
65  
66     /**
67      * @dev This method returns non zero result when sender is approved by
68      *      argument address and target address have non zero self balance
69      * @param _address target address 
70      * @return available for `sender` balance of given address
71      */
72     function getBalance(address _address) constant returns (uint) {
73         return allowance[_address][msg.sender]
74              > balanceOf[_address] ? balanceOf[_address]
75                                    : allowance[_address][msg.sender];
76     }
77  
78     /* Token constructor */
79     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
80         name     = _name;
81         symbol   = _symbol;
82         decimals = _decimals;
83         totalSupply           = _count;
84         balanceOf[msg.sender] = _count;
85     }
86  
87     /**
88      * @dev Transfer self tokens to given address
89      * @param _to destination address
90      * @param _value amount of token values to send
91      * @notice `_value` tokens will be sended to `_to`
92      * @return `true` when transfer done
93      */
94     function transfer(address _to, uint _value) returns (bool) {
95         if (balanceOf[msg.sender] >= _value) {
96             balanceOf[msg.sender] -= _value;
97             balanceOf[_to]        += _value;
98             Transfer(msg.sender, _to, _value);
99             return true;
100         }
101         return false;
102     }
103 
104     /**
105      * @dev Transfer with approvement mechainsm
106      * @param _from source address, `_value` tokens shold be approved for `sender`
107      * @param _to destination address
108      * @param _value amount of token values to send 
109      * @notice from `_from` will be sended `_value` tokens to `_to`
110      * @return `true` when transfer is done
111      */
112     function transferFrom(address _from, address _to, uint _value) returns (bool) {
113         var avail = allowance[_from][msg.sender]
114                   > balanceOf[_from] ? balanceOf[_from]
115                                      : allowance[_from][msg.sender];
116         if (avail >= _value) {
117             allowance[_from][msg.sender] -= _value;
118             balanceOf[_from] -= _value;
119             balanceOf[_to]   += _value;
120             Transfer(_from, _to, _value);
121             return true;
122         }
123         return false;
124     }
125 
126     /**
127      * @dev Give to target address ability for self token manipulation without sending
128      * @param _address target address
129      * @param _value amount of token values for approving
130      */
131     function approve(address _address, uint _value) {
132         allowance[msg.sender][_address] += _value;
133         Approval(msg.sender, _address, _value);
134     }
135 
136     /**
137      * @dev Reset count of tokens approved for given address
138      * @param _address target address
139      */
140     function unapprove(address _address)
141     { allowance[msg.sender][_address] = 0; }
142 }
143 /**
144  * @title Ethereum crypto currency extention for Token contract
145  */
146 contract TokenEther is Token {
147     function TokenEther(string _name, string _symbol)
148              Token(_name, _symbol, 18, 0)
149     {}
150 
151     /**
152      * @dev This is the way to withdraw money from token
153      * @param _value how many tokens withdraw from balance
154      */
155     function withdraw(uint _value) {
156         if (balanceOf[msg.sender] >= _value) {
157             balanceOf[msg.sender] -= _value;
158             totalSupply           -= _value;
159             if(!msg.sender.send(_value)) throw;
160         }
161     }
162 
163     /**
164      * @dev This is the way to refill your token balance by ethers
165      */
166     function refill() payable returns (bool) {
167         balanceOf[msg.sender] += msg.value;
168         totalSupply           += msg.value;
169         return true;
170     }
171 
172     /**
173      * @dev This method is called when money sended to contract address,
174      *      a synonym for refill()
175      */
176     function () payable {
177         balanceOf[msg.sender] += msg.value;
178         totalSupply           += msg.value;
179     }
180     
181     /**
182      * @dev By security issues token that holds ethers can not be killed
183      */
184     function kill() onlyOwner { throw; }
185 }
186 
187 
188 //sol Registrar
189 // Simple global registrar.
190 // @authors:
191 //   Gav Wood <g@ethdev.com>
192 
193 contract Registrar {
194 	event Changed(string indexed name);
195 
196 	function owner(string _name) constant returns (address o_owner);
197 	function addr(string _name) constant returns (address o_address);
198 	function subRegistrar(string _name) constant returns (address o_subRegistrar);
199 	function content(string _name) constant returns (bytes32 o_content);
200 }
201 
202 //sol OwnedRegistrar
203 // Global registrar with single authoritative owner.
204 // @authors:
205 //   Gav Wood <g@ethdev.com>
206 
207 contract AiraRegistrarService is Registrar, Mortal {
208 	struct Record {
209 		address addr;
210 		address subRegistrar;
211 		bytes32 content;
212 	}
213 	
214     function owner(string _name) constant returns (address o_owner)
215     { return 0; }
216 
217 	function disown(string _name) onlyOwner {
218 		delete m_toRecord[_name];
219 		Changed(_name);
220 	}
221 
222 	function setAddr(string _name, address _a) onlyOwner {
223 		m_toRecord[_name].addr = _a;
224 		Changed(_name);
225 	}
226 	function setSubRegistrar(string _name, address _registrar) onlyOwner {
227 		m_toRecord[_name].subRegistrar = _registrar;
228 		Changed(_name);
229 	}
230 	function setContent(string _name, bytes32 _content) onlyOwner {
231 		m_toRecord[_name].content = _content;
232 		Changed(_name);
233 	}
234 	function record(string _name) constant returns (address o_addr, address o_subRegistrar, bytes32 o_content) {
235 		o_addr = m_toRecord[_name].addr;
236 		o_subRegistrar = m_toRecord[_name].subRegistrar;
237 		o_content = m_toRecord[_name].content;
238 	}
239 	function addr(string _name) constant returns (address) { return m_toRecord[_name].addr; }
240 	function subRegistrar(string _name) constant returns (address) { return m_toRecord[_name].subRegistrar; }
241 	function content(string _name) constant returns (bytes32) { return m_toRecord[_name].content; }
242 
243 	mapping (string => Record) m_toRecord;
244 }
245 
246 contract AiraEtherFunds is TokenEther {
247     function AiraEtherFunds(address _bot_reg, string _name, string _symbol)
248             TokenEther(_name, _symbol) {
249         reg = AiraRegistrarService(_bot_reg);
250     }
251 
252     /**
253      * @dev Event spawned when activation request received
254      */
255     event ActivationRequest(address indexed sender, bytes32 indexed code);
256 
257     // Balance limit
258     uint public limit;
259     
260     function setLimit(uint _limit) onlyOwner
261     { limit = _limit; }
262 
263     // Account activation fee
264     uint public fee;
265     
266     function setFee(uint _fee) onlyOwner
267     { fee = _fee; }
268 
269     /**
270      * @dev Refill balance and activate it by code
271      * @param _code is activation code
272      */
273     function activate(string _code) payable {
274         var value = msg.value;
275  
276         // Get a fee
277         if (fee > 0) {
278             if (value < fee) throw;
279             balanceOf[owner] += fee;
280             value            -= fee;
281         }
282 
283         // Refund over limit
284         if (limit > 0 && value > limit) {
285             var refund = value - limit;
286             if (!msg.sender.send(refund)) throw;
287             value = limit;
288         }
289 
290         // Refill account balance
291         balanceOf[msg.sender] += value;
292         totalSupply           += value;
293 
294         // Activation event
295         ActivationRequest(msg.sender, stringToBytes32(_code));
296     }
297 
298     /**
299      * @dev String to bytes32 conversion helper
300      */
301     function stringToBytes32(string memory source) constant returns (bytes32 result)
302     { assembly { result := mload(add(source, 32)) } }
303 
304     /**
305      * @dev This is the way to refill your token balance by ethers
306      */
307     function refill() payable returns (bool) {
308         // Throw when over limit
309         if (balanceOf[msg.sender] + msg.value > limit) throw;
310 
311         // Refill
312         balanceOf[msg.sender] += msg.value;
313         totalSupply           += msg.value;
314         return true;
315     }
316 
317     /**
318      * @dev This is the way to refill token balance by ethers
319      * @param _dest is destination address
320      */
321     function refill(address _dest) payable returns (bool) {
322         // Throw when over limit
323         if (balanceOf[_dest] + msg.value > limit) throw;
324 
325         // Refill
326         balanceOf[_dest] += msg.value;
327         totalSupply      += msg.value;
328         return true;
329     }
330 
331     /**
332      * @dev This method is called when money sended to contract address,
333      *      a synonym for refill()
334      */
335     function () payable {
336         // Throw when over limit
337         if (balanceOf[msg.sender] + msg.value > limit) throw;
338 
339         // Refill
340         balanceOf[msg.sender] += msg.value;
341         totalSupply           += msg.value;
342     }
343 
344     /**
345      * @dev Outgoing transfer (send) with allowance
346      * @param _from source address
347      * @param _to destination address
348      * @param _value amount of token values to send 
349      */
350     function sendFrom(address _from, address _to, uint _value) {
351         var avail = allowance[_from][msg.sender]
352                   > balanceOf[_from] ? balanceOf[_from]
353                                      : allowance[_from][msg.sender];
354         if (avail >= _value) {
355             allowance[_from][msg.sender] -= _value;
356             balanceOf[_from]             -= _value;
357             totalSupply                  -= _value;
358             if (!_to.send(_value)) throw;
359         }
360     }
361 
362     AiraRegistrarService public reg;
363     modifier onlySecure { if (msg.sender != reg.addr("AiraSecure")) throw; _; }
364 
365     /**
366      * @dev Increase approved token values for AiraEthBot
367      * @param _client is a client address
368      * @param _value is amount of tokens
369      */
370     function secureApprove(address _client, uint _value) onlySecure {
371         var ethBot = reg.addr("AiraEth");
372         if (ethBot != 0)
373             allowance[_client][ethBot] += _value;
374     }
375 
376     /**
377      * @dev Close allowance for AiraEthBot
378      */
379     function secureUnapprove(address _client) onlySecure {
380         var ethBot = reg.addr("AiraEth");
381         if (ethBot != 0)
382             allowance[_client][ethBot] = 0;
383     }
384 }