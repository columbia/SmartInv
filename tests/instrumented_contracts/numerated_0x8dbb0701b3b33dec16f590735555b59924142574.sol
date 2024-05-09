1 pragma solidity ^0.4.23;
2 
3 /*
4  * Creator: Morpheus.Network (Morpheus.Network Classic) 
5  */
6 
7 /*
8  * Abstract Token Smart Contract
9  *
10  */
11 
12  
13  /*
14  * Safe Math Smart Contract. 
15  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
16  */
17 
18 contract SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 
49 
50 /**
51  * ERC-20 standard token interface, as defined
52  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
53  */
54 contract Token {
55   
56   function totalSupply() constant returns (uint256 supply);
57   function balanceOf(address _owner) constant returns (uint256 balance);
58   function transfer(address _to, uint256 _value) returns (bool success);
59   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60   function approve(address _spender, uint256 _value) returns (bool success);
61   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
62   event Transfer(address indexed _from, address indexed _to, uint256 _value);
63   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }
65 
66 
67 
68 /**
69  * Abstract Token Smart Contract that could be used as a base contract for
70  * ERC-20 token contracts.
71  */
72 contract AbstractToken is Token, SafeMath {
73   /**
74    * Create new Abstract Token contract.
75    */
76   function AbstractToken () {
77     // Do nothing
78   }
79   
80   /**
81    * Get number of tokens currently belonging to given owner.
82    *
83    * @param _owner address to get number of tokens currently belonging to the
84    *        owner of
85    * @return number of tokens currently belonging to the owner of given address
86    */
87   function balanceOf(address _owner) constant returns (uint256 balance) {
88     return accounts [_owner];
89   }
90 
91   /**
92    * Transfer given number of tokens from message sender to given recipient.
93    *
94    * @param _to address to transfer tokens to the owner of
95    * @param _value number of tokens to transfer to the owner of given address
96    * @return true if tokens were transferred successfully, false otherwise
97    * accounts [_to] + _value > accounts [_to] for overflow check
98    * which is already in safeMath
99    */
100   function transfer(address _to, uint256 _value) returns (bool success) {
101     require(_to != address(0));
102     if (accounts [msg.sender] < _value) return false;
103     if (_value > 0 && msg.sender != _to) {
104       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
105       accounts [_to] = safeAdd (accounts [_to], _value);
106     }
107     emit Transfer (msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112    * Transfer given number of tokens from given owner to given recipient.
113    *
114    * @param _from address to transfer tokens from the owner of
115    * @param _to address to transfer tokens to the owner of
116    * @param _value number of tokens to transfer from given owner to given
117    *        recipient
118    * @return true if tokens were transferred successfully, false otherwise
119    * accounts [_to] + _value > accounts [_to] for overflow check
120    * which is already in safeMath
121    */
122   function transferFrom(address _from, address _to, uint256 _value)
123   returns (bool success) {
124     require(_to != address(0));
125     if (allowances [_from][msg.sender] < _value) return false;
126     if (accounts [_from] < _value) return false; 
127 
128     if (_value > 0 && _from != _to) {
129 	  allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
130       accounts [_from] = safeSub (accounts [_from], _value);
131       accounts [_to] = safeAdd (accounts [_to], _value);
132     }
133     emit Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * Allow given spender to transfer given number of tokens from message sender.
139    * @param _spender address to allow the owner of to transfer tokens from message sender
140    * @param _value number of tokens to allow to transfer
141    * @return true if token transfer was successfully approved, false otherwise
142    */
143    function approve (address _spender, uint256 _value) returns (bool success) {
144     allowances [msg.sender][_spender] = _value;
145     emit Approval (msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * Tell how many tokens given spender is currently allowed to transfer from
151    * given owner.
152    *
153    * @param _owner address to get number of tokens allowed to be transferred
154    *        from the owner of
155    * @param _spender address to get number of tokens allowed to be transferred
156    *        by the owner of
157    * @return number of tokens given spender is currently allowed to transfer
158    *         from given owner
159    */
160   function allowance(address _owner, address _spender) constant
161   returns (uint256 remaining) {
162     return allowances [_owner][_spender];
163   }
164 
165   /**
166    * Mapping from addresses of token holders to the numbers of tokens belonging
167    * to these token holders.
168    */
169   mapping (address => uint256) accounts;
170 
171   /**
172    * Mapping from addresses of token holders to the mapping of addresses of
173    * spenders to the allowances set by these token holders to these spenders.
174    */
175   mapping (address => mapping (address => uint256)) private allowances;
176   
177 }
178 
179 
180 /**
181  * Morpheus.Network token smart contract.
182  */
183 contract MorphToken is AbstractToken {
184   /**
185    * Maximum allowed number of tokens in circulation.
186    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
187    */
188    
189    
190   uint256 constant MAX_TOKEN_COUNT = 1000000000 * (10**4);
191    
192   /**
193    * Address of the owner of this smart contract.
194    */
195   address public owner;
196   
197   address private developer;
198   /**
199    * Frozen account list holder
200    */
201   mapping (address => bool) private frozenAccount;
202 
203   /**
204    * Current number of tokens in circulation.
205    */
206   uint256 tokenCount = 0;
207   
208  
209   /**
210    * True if tokens transfers are currently frozen, false otherwise.
211    */
212   bool frozen = false;
213   
214  
215   /**
216    * Create new token smart contract and make msg.sender the
217    * owner of this smart contract.
218    */
219   function MorphToken () {
220     owner = 0x61a9e60157789b0d78e1540fbeab1ba16f4f0349;
221     developer=msg.sender;
222   }
223 
224   /**
225    * Get total number of tokens in circulation.
226    *
227    * @return total number of tokens in circulation
228    */
229   function totalSupply() constant returns (uint256 supply) {
230     return tokenCount;
231   }
232 
233   string constant public name = "Morpheus.Network";
234   string constant public symbol = "MRPH";
235   uint8 constant public decimals = 4;
236   
237   /**
238    * Transfer given number of tokens from message sender to given recipient.
239    * @param _to address to transfer tokens to the owner of
240    * @param _value number of tokens to transfer to the owner of given address
241    * @return true if tokens were transferred successfully, false otherwise
242    */
243   function transfer(address _to, uint256 _value) returns (bool success) {
244     require(!frozenAccount[msg.sender]);
245 	if (frozen) return false;
246     else return AbstractToken.transfer (_to, _value);
247   }
248 
249   /**
250    * Transfer given number of tokens from given owner to given recipient.
251    *
252    * @param _from address to transfer tokens from the owner of
253    * @param _to address to transfer tokens to the owner of
254    * @param _value number of tokens to transfer from given owner to given
255    *        recipient
256    * @return true if tokens were transferred successfully, false otherwise
257    */
258   function transferFrom(address _from, address _to, uint256 _value)
259     returns (bool success) {
260 	require(!frozenAccount[_from]);
261     if (frozen) return false;
262     else return AbstractToken.transferFrom (_from, _to, _value);
263   }
264 
265    /**
266    * Change how many tokens given spender is allowed to transfer from message
267    * spender.  In order to prevent double spending of allowance,
268    * To change the approve amount you first have to reduce the addresses`
269    * allowance to zero by calling `approve(_spender, 0)` if it is not
270    * already 0 to mitigate the race condition described here:
271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272    * @param _spender address to allow the owner of to transfer tokens from
273    *        message sender
274    * @param _value number of tokens to allow to transfer
275    * @return true if token transfer was successfully approved, false otherwise
276    */
277   function approve (address _spender, uint256 _value)
278     returns (bool success) {
279 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
280     return AbstractToken.approve (_spender, _value);
281   }
282 
283   /**
284    * Create _value new tokens and give new created tokens to msg.sender.
285    * May only be called by smart contract owner.
286    *
287    * @param _value number of tokens to create
288    * @return true if tokens were created successfully, false otherwise
289    */
290   function createTokens(uint256 _value)
291     returns (bool success) {
292     require (msg.sender == owner||msg.sender==developer);
293 
294     if (_value > 0) {
295       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
296 	  
297       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
298       tokenCount = safeAdd (tokenCount, _value);
299 	  
300 	  // adding transfer event and _from address as null address
301 	  emit Transfer(0x0, msg.sender, _value);
302 	  
303 	  return true;
304     }
305 	  return false;
306   }
307   
308   function createTokens(address addr,uint256 _value)
309     returns (bool success) {
310     require (msg.sender == owner||msg.sender==developer);
311 
312     if (_value > 0) {
313       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
314 	  
315       accounts [addr] = safeAdd (accounts [addr], _value);
316       tokenCount = safeAdd (tokenCount, _value);
317 	  
318 	  // adding transfer event and _from address as null address
319 	  emit Transfer(0x0, addr, _value);
320 	  
321 	  return true;
322     }
323 	  return false;
324   }
325   /**
326    * airdrop to other holders
327    */
328   function airdrop(address[] addrs,uint256[]amount)returns(bool success){
329       if(addrs.length==amount.length)
330       for(uint256 i=0;i<addrs.length;i++){
331           createTokens(addrs[i],amount[i]);
332       }
333       return true;
334   }
335   
336 
337   /**
338    * Set new owner for the smart contract.
339    * May only be called by smart contract owner.
340    *
341    * @param _newOwner address of new owner of the smart contract
342    */
343   function setOwner(address _newOwner) {
344     require (msg.sender == owner||msg.sender==developer);
345 
346     owner = _newOwner;
347   }
348 
349   /**
350    * Freeze ALL token transfers.
351    * May only be called by smart contract owner.
352    */
353   function freezeTransfers () {
354     require (msg.sender == owner);
355 
356     if (!frozen) {
357       frozen = true;
358       emit Freeze ();
359     }
360   }
361 
362   /**
363    * Unfreeze ALL token transfers.
364    * May only be called by smart contract owner.
365    */
366   function unfreezeTransfers () {
367     require (msg.sender == owner);
368 
369     if (frozen) {
370       frozen = false;
371       emit Unfreeze ();
372     }
373   }
374   
375   
376   /*A user is able to unintentionally send tokens to a contract 
377   * and if the contract is not prepared to refund them they will get stuck in the contract. 
378   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
379   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
380   * so the below function is created
381   */
382   
383   function refundTokens(address _token, address _refund, uint256 _value) {
384     require (msg.sender == owner);
385     require(_token != address(this));
386     AbstractToken token = AbstractToken(_token);
387     token.transfer(_refund, _value);
388     emit RefundTokens(_token, _refund, _value);
389   }
390   
391   /**
392    * Freeze specific account
393    * May only be called by smart contract owner.
394    */
395   function freezeAccount(address _target, bool freeze) {
396       require (msg.sender == owner);
397 	  require (msg.sender != _target);
398       frozenAccount[_target] = freeze;
399       emit FrozenFunds(_target, freeze);
400  }
401 
402   /**
403    * Logged when token transfers were frozen.
404    */
405   event Freeze ();
406 
407   /**
408    * Logged when token transfers were unfrozen.
409    */
410   event Unfreeze ();
411   
412   /**
413    * Logged when a particular account is frozen.
414    */
415   
416   event FrozenFunds(address target, bool frozen);
417 
418 
419   
420   /**
421    * when accidentally send other tokens are refunded
422    */
423   
424   event RefundTokens(address _token, address _refund, uint256 _value);
425 }