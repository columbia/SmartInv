1 /** Orgon Token Smart Contract.  Copyright © 2019 by Oris.Space. v25 */
2 pragma solidity ^0.4.25;
3 
4 library SafeMath {
5  
6   /**
7    * Add two uint256 values, throw in case of overflow.
8    * @param x first value to add
9    * @param y second value to add
10    * @return x + y
11    */
12   function safeAdd (uint256 x, uint256 y) internal pure returns (uint256) {
13     uint256 z = x + y;
14     require(z >= x);
15     return z;
16   }
17 
18   /**
19    * Subtract one uint256 value from another, throw in case of underflow.
20    * @param x value to subtract from
21    * @param y value to subtract
22    * @return x - y
23    */
24   function safeSub (uint256 x, uint256 y) internal pure returns (uint256) {
25     require (x >= y);
26     uint256 z = x - y;
27     return z;
28   }
29 }
30 
31 contract Token {
32   /**
33    * Get total number of tokens in circulation.
34    *
35    * @return total number of tokens in circulation
36    */
37   function totalSupply () public view returns (uint256 supply);
38 
39   /**
40    * Get number of tokens currently belonging to given owner.
41    *
42    * @param _owner address to get number of tokens currently belonging to the
43    *        owner of
44    * @return number of tokens currently belonging to the owner of given address
45    */
46   function balanceOf (address _owner) public view returns (uint256 balance);
47 
48   /**
49    * Transfer given number of tokens from message sender to given recipient.
50    *
51    * @param _to address to transfer tokens to the owner of
52    * @param _value number of tokens to transfer to the owner of given address
53    * @return true if tokens were transferred successfully, false otherwise
54    */
55   function transfer (address _to, uint256 _value)
56   public returns (bool success);
57 
58   /**
59    * Transfer given number of tokens from given owner to given recipient.
60    *
61    * @param _from address to transfer tokens from the owner of
62    * @param _to address to transfer tokens to the owner of
63    * @param _value number of tokens to transfer from given owner to given
64    *        recipient
65    * @return true if tokens were transferred successfully, false otherwise
66    */
67   function transferFrom (address _from, address _to, uint256 _value)
68   public returns (bool success);
69 
70   /**
71    * Allow given spender to transfer given number of tokens from message sender.
72    *
73    * @param _spender address to allow the owner of to transfer tokens from
74    *        message sender
75    * @param _value number of tokens to allow to transfer
76    * @return true if token transfer was successfully approved, false otherwise
77    */
78   function approve (address _spender, uint256 _value)
79   public returns (bool success);
80 
81   /**
82    * Tell how many tokens given spender is currently allowed to transfer from
83    * given owner.
84    *
85    * @param _owner address to get number of tokens allowed to be transferred
86    *        from the owner of
87    * @param _spender address to get number of tokens allowed to be transferred
88    *        by the owner of
89    * @return number of tokens given spender is currently allowed to transfer
90    *         from given owner
91    */
92   function allowance (address _owner, address _spender)
93   public view returns (uint256 remaining);
94 
95   /**
96    * Logged when tokens were transferred from one owner to another.
97    *
98    * @param _from address of the owner, tokens were transferred from
99    * @param _to address of the owner, tokens were transferred to
100    * @param _value number of tokens transferred
101    */
102   event Transfer (address indexed _from, address indexed _to, uint256 _value);
103 
104   /**
105    * Logged when owner approved his tokens to be transferred by some spender.
106    *
107    * @param _owner owner who approved his tokens to be transferred
108    * @param _spender spender who were allowed to transfer the tokens belonging
109    *        to the owner
110    * @param _value number of tokens belonging to the owner, approved to be
111    *        transferred by the spender
112    */
113   event Approval (
114     address indexed _owner, address indexed _spender, uint256 _value);
115 }
116 
117 /** Orgon Token smart contract */
118 contract OrgonToken is Token {
119     
120 using SafeMath for uint256;
121 
122 /* Maximum allowed number of tokens in circulation (2^256 - 1). */
123 uint256 constant MAX_TOKEN_COUNT =
124 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
125 
126 /* Full life start time (2021-10-18 18:10:21 UTC) */
127 uint256 private constant LIFE_START_TIME = 1634559021;
128 
129 /* Number of tokens to be send for Full life start 642118523.280000000000000000 */
130 uint256 private constant LIFE_START_TOKENS = 642118523280000000000000000;
131   
132 /** Deploy Orgon Token smart contract and make message sender to be the owner
133    of the smart contract */
134 /* *********************************************** */
135 constructor() public {
136     owner = msg.sender;
137     mint = msg.sender;
138 }
139   
140   
141 /** Get name,symbol of this token, number of decimals for this token  
142  * @return name of this token */
143 /* *********************************************** */
144 function name () public pure returns (string) {
145     
146     return "ORGON";
147 }
148 
149 /* *********************************************** */
150 function symbol () public pure returns (string) {
151     
152     return "ORGON";
153 }
154 /* *********************************************** */
155 function decimals () public pure returns (uint8) {
156     
157     return 18;
158 }
159 
160 /** Get total number of tokens in circulation
161  * @return total number of tokens in circulation */
162  
163 /* *********************************************** */ 
164 function totalSupply () public view returns (uint256 supply) {
165      
166      return tokenCount;
167  }
168 
169 /* *********************************************** */
170 function totalICO () public view returns (uint256) {
171      
172      return tokenICO;
173  }
174 
175 /* *********************************************** */
176 function theMint () public view returns (address) {
177      
178      return mint;
179  }
180  
181  /* *********************************************** */
182 function theStage () public view returns (Stage) {
183      
184      return stage;
185  }
186  
187  /* *********************************************** */
188 function theOwner () public view returns (address) {
189      
190      return owner;
191  }
192  
193  
194 /** Get balance */
195 
196 /* *********************************************** */
197 function balanceOf (address _owner) public view returns (uint256 balance) {
198 
199     return accounts [_owner];
200 }
201 
202 
203 /** Transfer given number of tokens from message sender to given recipient.
204  * @param _to address to transfer tokens to the owner of
205  * @param _value number of tokens to transfer to the owner of given address
206  * @return true if tokens were transferred successfully, false otherwise */
207  
208  /* *********************************************** */
209  function transfer (address _to, uint256 _value)
210  public validDestination(_to) returns (bool success) {
211     
212     require (accounts [msg.sender]>=_value);
213     
214     uint256 fromBalance = accounts [msg.sender];
215     if (fromBalance < _value) return false;
216     
217     if (stage != Stage.ICO){
218         accounts [msg.sender] = fromBalance.safeSub(_value);
219         accounts [_to] = accounts[_to].safeAdd(_value);
220     }
221     else if (msg.sender == owner){ // stage == Stage.ICO
222         accounts [msg.sender] = fromBalance.safeSub(_value);
223         accounts [_to] = accounts[_to].safeAdd(_value);
224         tokenICO = tokenICO.safeAdd(_value);
225     }
226     else if (_to == owner){ // stage == Stage.ICO
227         accounts [msg.sender] = fromBalance.safeSub(_value);
228         accounts [_to] = accounts[_to].safeAdd(_value);
229         tokenICO = tokenICO.safeSub(_value);
230     }
231     else if (forPartners[msg.sender] >= _value){ // (sender is Partner)
232         accounts [msg.sender] = fromBalance.safeSub(_value);
233         forPartners [msg.sender] = forPartners[msg.sender].safeSub(_value);
234         accounts [_to] = accounts[_to].safeAdd(_value);
235     }
236     else revert();
237     
238     emit Transfer (msg.sender, _to, _value);
239     return true;
240 }
241 
242 
243 /** Transfer given number of tokens from given owner to given recipient.
244  * @param _from address to transfer tokens from the owner of
245  * @param _to address to transfer tokens to the owner of
246  * @param _value number of tokens to transfer from given owner to given
247  *        recipient
248  * @return true if tokens were transferred successfully, false otherwise */
249  
250 /* *********************************************** */
251 function transferFrom (address _from, address _to, uint256 _value)
252 public validDestination(_to) returns (bool success) {
253 
254     require (stage != Stage.ICO);
255     require(_from!=_to);
256     uint256 spenderAllowance = allowances [_from][msg.sender];
257     if (spenderAllowance < _value) return false;
258     uint256 fromBalance = accounts [_from];
259     if (fromBalance < _value) return false;
260 
261     allowances [_from][msg.sender] =  spenderAllowance.safeSub(_value);
262 
263     if (_value > 0) {
264       accounts [_from] = fromBalance.safeSub(_value);
265       accounts [_to] = accounts[_to].safeAdd(_value);
266     }
267     emit Transfer (_from, _to, _value);
268     return true;
269 }
270 
271 
272 /** Allow given spender to transfer given number of tokens from message sender
273  * @param _spender address to allow the owner of to transfer tokens from
274  *        message sender
275  * @param _value number of tokens to allow to transfer
276  * @return true if token transfer was successfully approved, false otherwise */
277  
278 /* *********************************************** */
279 function approve (address _spender, uint256 _value)
280 public returns (bool success) {
281     require(_spender != address(0));
282     
283     allowances [msg.sender][_spender] = _value;
284     emit Approval (msg.sender, _spender, _value);
285     return true;
286 }
287 
288 
289 /** Allow Partner to transfer given number of tokens 
290  * @param _partner Partner address 
291  * @param _value number of tokens to allow to transfer
292  * @return true if token transfer was successfully approved, false otherwise */
293  
294 /* *********************************************** */
295 function addToPartner (address _partner, uint256 _value)
296 public returns (bool success) {
297     
298     require (msg.sender == owner);
299     forPartners [_partner] = forPartners[_partner].safeAdd(_value);
300     return true;
301 }
302 
303 /** Disallow Partner to transfer given number of tokens 
304  * @param _partner Partner address
305  * @param _value number of tokens to allow to transfer
306  * @return true if token transfer was successfully approved, false otherwise */
307 
308 /* *********************************************** */
309 function subFromPartner (address _partner, uint256 _value)
310 public returns (bool success) {
311     
312     require (msg.sender == owner);
313     if (forPartners [_partner] < _value) {
314         forPartners [_partner] = 0;
315     }
316     else {
317         forPartners [_partner] = forPartners[_partner].safeSub(_value);
318     }
319     return true;
320 }
321 
322 /** Tell how many tokens given partner is currently allowed to transfer from
323   given him.
324   @param _partner address to get number of tokens allowed to be transferred         
325   @return number of tokens given spender is currently allowed to transfer
326   from given owner */
327   
328 /* *********************************************** */
329 function partners (address _partner)
330 public view returns (uint256 remaining) {
331 
332     return forPartners [_partner];
333   }
334 
335 
336 /** Create _value new tokens and give new created tokens to msg.sender.
337  * May only be called by smart contract owner.
338  * @param _value number of tokens to create
339  * @return true if tokens were created successfully, false otherwise*/
340  
341 /* *********************************************** */
342 function createTokens (uint256 _value) public returns (bool) {
343 
344     require (msg.sender == mint);
345     
346     if (_value > 0) {
347         if (_value > MAX_TOKEN_COUNT.safeSub(tokenCount)) return false;
348         accounts [msg.sender] = accounts[msg.sender].safeAdd(_value);
349         tokenCount = tokenCount.safeAdd(_value);
350         emit Transfer (address (0), msg.sender, _value);
351     }
352     return true;
353 }
354 
355 
356 /** Burn given number of tokens belonging to owner.
357  * May only be called by smart contract owner.
358  * @param _value number of tokens to burn
359  * @return true on success, false on error */
360  
361 /* *********************************************** */
362 function burnTokens (uint256 _value) public returns (bool) {
363 
364     require (msg.sender == mint);
365     require (accounts [msg.sender]>=_value);
366     
367     if (_value > accounts [mint]) return false;
368     else if (_value > 0) {
369         accounts [mint] = accounts[mint].safeSub(_value);
370         tokenCount = tokenCount.safeSub(_value);
371         emit Transfer (mint, address (0), _value);
372         return true;
373     }
374     else return true;
375 }
376 
377 
378 /** Set new owner for the smart contract.
379  * May only be called by smart contract owner.
380  * @param _newOwner address of new owner of the smart contract */
381  
382 /* *********************************************** */
383 function setOwner (address _newOwner) public validDestination(_newOwner) {
384  
385     require (msg.sender == owner);
386     
387     owner = _newOwner;
388     uint256 fromBalance = accounts [msg.sender];
389     if (fromBalance > 0 && msg.sender != _newOwner) {
390         accounts [msg.sender] = fromBalance.safeSub(fromBalance);
391         accounts [_newOwner] = accounts[_newOwner].safeAdd(fromBalance);
392         emit Transfer (msg.sender, _newOwner, fromBalance);
393     }
394 }
395 
396 /** Set new owner for the smart contract.
397  * May only be called by smart contract owner.
398  * @param _newMint address of new owner of the smart contract */
399 
400 /* *********************************************** */
401 function setMint (address _newMint) public {
402  
403  if (stage != Stage.LIFE && (msg.sender == owner || msg.sender == mint )){
404     mint = _newMint;
405  }
406  else if (msg.sender == mint){
407     mint = _newMint;
408  }
409  else revert();
410 }
411 
412 /** Chech and Get current stage
413  * @return current stage */
414  
415 /* *********************************************** */
416 function checkStage () public returns (Stage) {
417 
418     require (stage != Stage.LIFE);
419     
420     Stage currentStage = stage;
421     if (currentStage == Stage.ICO) {
422         if (block.timestamp >= LIFE_START_TIME || tokenICO > LIFE_START_TOKENS) {
423             currentStage = Stage.LIFE;
424             stage = Stage.LIFE;
425         }
426     else return currentStage;
427     }
428     return currentStage;
429 }
430 
431 /** Change stage by Owner */
432 
433 /* *********************************************** */
434 function changeStage () public {
435     
436     require (msg.sender == owner);
437     require (stage != Stage.LIFE);
438     if (stage == Stage.ICO) {stage = Stage.LIFEBYOWNER;}
439     else stage = Stage.ICO;
440 }
441 
442 
443 
444 /** Tell how many tokens given spender is currently allowed to transfer from
445  * given owner.
446  * @param _owner address to get number of tokens allowed to be transferred
447  *        from the owner of
448  * @param _spender address to get number of tokens allowed to be transferred
449  *        by the owner of
450  * @return number of tokens given spender is currently allowed to transfer
451  *         from given owner */
452  
453 /* *********************************************** */
454 function allowance (address _owner, address _spender)
455 public view returns (uint256 remaining) {
456 
457     return allowances [_owner][_spender];
458   }
459 
460 /**
461    * @dev Increase the amount of tokens that an owner allowed to a spender.
462    * approve should be called when allowed_[_spender] == 0. To increment
463    * allowed value is better to use this function to avoid 2 calls (and wait until
464    * the first transaction is mined)
465    * From MonolithDAO Token.sol
466    * @param spender The address which will spend the funds.
467    * @param addedValue The amount of tokens to increase the allowance by.
468    */
469    
470 /* *********************************************** */
471 function increaseAllowance(address spender, uint256 addedValue) public returns (bool)
472   {
473     require(spender != address(0));
474 
475     allowances[msg.sender][spender] = allowances[msg.sender][spender].safeAdd(addedValue);
476     emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
477     return true;
478   }
479 
480   /**
481    * @dev Decrease the amount of tokens that an owner allowed to a spender.
482    * approve should be called when allowed_[_spender] == 0. To decrement
483    * allowed value is better to use this function to avoid 2 calls (and wait until
484    * the first transaction is mined)
485    * From MonolithDAO Token.sol
486    * @param spender The address which will spend the funds.
487    * @param subtractedValue The amount of tokens to decrease the allowance by.
488    */
489   function decreaseAllowance(
490     address spender,
491     uint256 subtractedValue
492   )
493     public
494     returns (bool)
495   {
496     require(spender != address(0));
497 
498     allowances[msg.sender][spender] = allowances[msg.sender][spender].safeSub(subtractedValue);
499     emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
500     return true;
501   }
502 
503 
504 
505 /** Get current time in seconds since epoch.
506  * @return current time in seconds since epoch */
507 function currentTime () public view returns (uint256) {
508     return block.timestamp;
509 }
510 
511 /** Total number of tokens in circulation */
512 uint256 private  tokenCount;
513 
514 /** Total number of tokens in ICO */
515 uint256 private  tokenICO;
516 
517 /** Owner of the smart contract */
518 address private  owner;
519 
520 /** Mint of the smart contract */
521 address private  mint;
522 
523 
524   
525 enum Stage {
526     ICO, // 
527     LIFEBYOWNER,
528     LIFE// 
529 }
530   
531 /** Last known stage of token*/
532 Stage private stage = Stage.ICO;
533   
534 /** Mapping from addresses of token holders to the numbers of tokens belonging
535  * to these token holders */
536 mapping (address => uint256) private accounts;
537 
538 /** Mapping from addresses of partners to the numbers of tokens belonging
539  * to these partners. */
540 mapping (address => uint256) private forPartners;
541 
542 /** Mapping from addresses of token holders to the mapping of addresses of
543  * spenders to the allowances set by these token holders to these spenders */
544 mapping (address => mapping (address => uint256)) private allowances;
545 
546 modifier validDestination (address to) {
547     require (to != address(0x0));
548     require (to != address(this));
549     _;
550 }
551 
552 }