1 pragma solidity ^0.4.19;
2 
3 /*
4  * Creator: Cancri Property
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
107     Transfer (msg.sender, _to, _value);
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
133     Transfer(_from, _to, _value);
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
145     Approval (msg.sender, _spender, _value);
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
181  * CCP token smart contract.
182  */
183 contract CCPToken is AbstractToken {
184   /**
185    * Maximum allowed number of tokens in circulation.
186    * tokenSupply = tokensIActuallyWant * (10 ^ decimals)
187    * 55000000 for CCP Token
188    */
189    
190    
191   uint256 constant MAX_TOKEN_COUNT = 55000000 * (10**0);
192    
193   /**
194    * Address of the owner of this smart contract.
195    */
196   address private owner;
197   
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
214   /**
215    * Counter of total funds collected, in wei
216   */
217   uint public totalCollected = 0;
218 
219   /**
220    * Create new CCP token smart contract and make msg.sender the
221    * owner of this smart contract.
222    */
223   function CCPToken () {
224     owner = msg.sender;
225   }
226 
227   /**
228    * Get total number of tokens in circulation.
229    *
230    * @return total number of tokens in circulation
231    */
232   function totalSupply() constant returns (uint256 supply) {
233     return tokenCount;
234   }
235 
236   string constant public name = "Cancri Property Coin";
237   string constant public symbol = "CCP";
238   uint8 constant public decimals = 0;
239   
240   /**
241    * Transfer given number of tokens from message sender to given recipient.
242    * @param _to address to transfer tokens to the owner of
243    * @param _value number of tokens to transfer to the owner of given address
244    * @return true if tokens were transferred successfully, false otherwise
245    */
246   function transfer(address _to, uint256 _value) returns (bool success) {
247     require(!frozenAccount[msg.sender]);
248 	if (frozen) return false;
249     else return AbstractToken.transfer (_to, _value);
250   }
251 
252   /**
253    * Transfer given number of tokens from given owner to given recipient.
254    *
255    * @param _from address to transfer tokens from the owner of
256    * @param _to address to transfer tokens to the owner of
257    * @param _value number of tokens to transfer from given owner to given
258    *        recipient
259    * @return true if tokens were transferred successfully, false otherwise
260    */
261   function transferFrom(address _from, address _to, uint256 _value)
262     returns (bool success) {
263 	require(!frozenAccount[_from]);
264     if (frozen) return false;
265     else return AbstractToken.transferFrom (_from, _to, _value);
266   }
267 
268    /**
269    * Change how many tokens given spender is allowed to transfer from message
270    * spender.  In order to prevent double spending of allowance,
271    * To change the approve amount you first have to reduce the addresses`
272    * allowance to zero by calling `approve(_spender, 0)` if it is not
273    * already 0 to mitigate the race condition described here:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender address to allow the owner of to transfer tokens from
276    *        message sender
277    * @param _value number of tokens to allow to transfer
278    * @return true if token transfer was successfully approved, false otherwise
279    */
280   function approve (address _spender, uint256 _value)
281     returns (bool success) {
282 	require(allowance (msg.sender, _spender) == 0 || _value == 0);
283     return AbstractToken.approve (_spender, _value);
284   }
285 
286   /**
287    * Create _value new tokens and give new created tokens to msg.sender.
288    * May only be called by smart contract owner.
289    *
290    * @param _value number of tokens to create
291    * @param _collected total amounts of fund collected for this issuance, in wei
292    * @return true if tokens were created successfully, false otherwise
293    */
294   function createTokens(uint256 _value, uint _collected)
295     returns (bool success) {
296     require (msg.sender == owner);
297 
298     if (_value > 0) {
299       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
300 	  
301       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
302       tokenCount = safeAdd (tokenCount, _value);
303       totalCollected = safeAdd(totalCollected, _collected);
304 	  
305 	  // adding transfer event and _from address as null address
306 	  Transfer(0x0, msg.sender, _value);
307 	  
308 	  return true;
309     }
310 	
311 	  return false;
312     
313   }
314   
315   
316   /**
317    * For future use only whne we will need more tokens for our main application
318    * Create mintedAmount new tokens and give new created tokens to target.
319    * May only be called by smart contract owner.
320    * @param mintedAmount number of tokens to create
321    * @return true if tokens were created successfully, false otherwise
322    */
323   
324   function mintToken(address target, uint256 mintedAmount) 
325   returns (bool success) {
326     require (msg.sender == owner);
327       if (mintedAmount > 0) {
328 	  
329       accounts [target] = safeAdd (accounts [target], mintedAmount);
330       tokenCount = safeAdd (tokenCount, mintedAmount);
331 	  
332 	  // adding transfer event and _from address as null address
333 	  Transfer(0x0, target, mintedAmount);
334 	  
335 	   return true;
336     }
337 	  return false;
338    
339     }
340   
341 
342   /**
343    * Set new owner for the smart contract.
344    * May only be called by smart contract owner.
345    *
346    * @param _newOwner address of new owner of the smart contract
347    */
348   function setOwner(address _newOwner) {
349     require (msg.sender == owner);
350 
351     owner = _newOwner;
352   }
353 
354   /**
355    * Freeze ALL token transfers.
356    * May only be called by smart contract owner.
357    */
358   function freezeTransfers () {
359     require (msg.sender == owner);
360 
361     if (!frozen) {
362       frozen = true;
363       Freeze ();
364     }
365   }
366 
367   /**
368    * Unfreeze ALL token transfers.
369    * May only be called by smart contract owner.
370    */
371   function unfreezeTransfers () {
372     require (msg.sender == owner);
373 
374     if (frozen) {
375       frozen = false;
376       Unfreeze ();
377     }
378   }
379   
380   
381   /*A user is able to unintentionally send tokens to a contract 
382   * and if the contract is not prepared to refund them they will get stuck in the contract. 
383   * The same issue used to happen for Ether too but new Solidity versions added the payable modifier to
384   * prevent unintended Ether transfers. However, there’s no such mechanism for token transfers.
385   * so the below function is created
386   */
387   
388   function refundTokens(address _token, address _refund, uint256 _value) {
389     require (msg.sender == owner);
390     require(_token != address(this));
391     AbstractToken token = AbstractToken(_token);
392     token.transfer(_refund, _value);
393     RefundTokens(_token, _refund, _value);
394   }
395   
396   /**
397    * Freeze specific account
398    * May only be called by smart contract owner.
399    */
400   function freezeAccount(address _target, bool freeze) {
401       require (msg.sender == owner);
402 	  require (msg.sender != _target);
403       frozenAccount[_target] = freeze;
404       FrozenFunds(_target, freeze);
405  }
406 
407   /**
408    * Logged when token transfers were frozen.
409    */
410   event Freeze ();
411 
412   /**
413    * Logged when token transfers were unfrozen.
414    */
415   event Unfreeze ();
416   
417   /**
418    * Logged when a particular account is frozen.
419    */
420   
421   event FrozenFunds(address target, bool frozen);
422 
423 
424   
425   /**
426    * when accidentally send other tokens are refunded
427    */
428   
429   event RefundTokens(address _token, address _refund, uint256 _value);
430 }