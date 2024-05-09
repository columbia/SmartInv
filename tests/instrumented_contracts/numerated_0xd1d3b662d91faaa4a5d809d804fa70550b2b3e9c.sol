1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b)
11     internal
12     pure
13     returns (uint256 c)
14   {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b)
31     internal
32     pure
33     returns (uint256)
34   {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return a / b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b)
45     internal
46     pure
47     returns (uint256)
48   {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b)
57     internal
58     pure
59     returns (uint256 c)
60   {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 
66 }
67 contract ERC20 {
68 
69   function totalSupply() public view returns (uint256);
70 
71   function balanceOf(address who) public view returns (uint256);
72 
73   function transfer(address to, uint256 value) public returns (bool);
74 
75   function allowance(address owner, address spender) public view returns (uint256);
76 
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78 
79   function approve(address spender, uint256 value) public returns (bool);
80 
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 
85 }
86 contract Owned {
87 
88   event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90   address public owner;
91   address public newOwner;
92 
93   modifier onlyOwner {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   constructor()
99     public
100   {
101     owner = msg.sender;
102   }
103 
104   function transferOwnership(address _newOwner)
105     public
106     onlyOwner
107   {
108     newOwner = _newOwner;
109   }
110 
111   function acceptOwnership()
112     public
113   {
114     require(msg.sender == newOwner);
115     owner = newOwner;
116     newOwner = address(0);
117     emit OwnershipTransferred(owner, newOwner);
118   }
119 
120 }
121 contract StandardToken is ERC20 {
122 
123   using SafeMath for uint256;
124 
125   uint256 totalSupply_;
126 
127   mapping(address => uint256) balances;
128 
129   mapping(address => mapping(address => uint256)) internal allowed;
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply()
135     public
136     view
137     returns (uint256)
138   {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev Transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value)
148     public
149     returns (bool)
150   {
151     require(_value <= balances[msg.sender]);
152     require(_to != address(0));
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner)
166     public
167     view
168     returns (uint256)
169   {
170     return balances[_owner];
171   }
172 
173 
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value)
183     public
184     returns (bool)
185   {
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188     require(_to != address(0));
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value)
207     public
208     returns (bool)
209   {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender)
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(address _spender, uint256 _addedValue)
239     public
240     returns (bool)
241   {
242     allowed[msg.sender][_spender] = (
243     allowed[msg.sender][_spender].add(_addedValue));
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(address _spender, uint256 _subtractedValue)
258     public
259     returns (bool)
260   {
261     uint256 oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue >= oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 library SafeERC20 {
273   function safeTransfer(ERC20 token, address to, uint256 value) internal {
274     require(token.transfer(to, value));
275   }
276 
277   function safeTransferFrom(
278     ERC20 token,
279     address from,
280     address to,
281     uint256 value
282   )
283   internal
284   {
285     require(token.transferFrom(from, to, value));
286   }
287 
288   function safeApprove(ERC20 token, address spender, uint256 value) internal {
289     require(token.approve(spender, value));
290   }
291 }
292 
293 contract PetCoin is StandardToken, Owned {
294 
295   using SafeMath for uint256;
296 
297   // Token metadata
298   string public constant name = "Petcoin";
299   string public constant symbol = "PETC";
300   uint256 public constant decimals = 18;
301 
302   // Token supply breakdown
303   uint256 public constant initialSupply = 2340 * (10**6) * 10**decimals; // 2.34 billion
304   uint256 public constant stageOneSupply = (10**5) * 10**decimals; // 100,000 tokens for ICO stage 1
305   uint256 public constant stageTwoSupply = (10**6) * 10**decimals; // 1,000,000 tokens for ICO stage 2
306   uint256 public constant stageThreeSupply = (10**7) * 10**decimals; // 10,000,000 tokens for ICO stage 3
307 
308   // Initial Token holder addresses.
309   // one billion token holders
310   address public constant appWallet = 0x9F6899364610B96D7718Fe3c03A6BD1Deb8623CE;
311   address public constant genWallet = 0x530E6B9A17e9AbB77CF4E125b99Bf5D5CAD69942;
312   // one hundred million token holders
313   address public constant ceoWallet = 0x388Ed3f7Aa1C4461460197FcCE5cfEf84D562c6A;
314   address public constant cooWallet = 0xa2c59e6a91B4E502CF8C95A61F50D3aB1AB30cBA;
315   address public constant devWallet = 0x7D2ea29E2d4A95f4725f52B941c518C15eAE3c64;
316   // the rest token holder
317   address public constant poolWallet = 0x7e75fe6b73993D9Be9cb975364ec70Ee2C22c13A;
318 
319   // mint configuration
320   uint256 public constant yearlyMintCap = (10*7) * 10*decimals; //10,000,000 tokens each year
321   uint16 public mintStartYear = 2019;
322   uint16 public mintEndYear = 2118;
323 
324   mapping (uint16 => bool) minted;
325 
326 
327   constructor()
328     public
329   {
330     totalSupply_ = initialSupply.add(stageOneSupply).add(stageTwoSupply).add(stageThreeSupply);
331     uint256 oneBillion = (10**9) * 10**decimals;
332     uint256 oneHundredMillion = 100 * (10**6) * 10**decimals;
333     balances[appWallet] = oneBillion;
334     emit Transfer(address(0), appWallet, oneBillion);
335     balances[genWallet] = oneBillion;
336     emit Transfer(address(0), genWallet, oneBillion);
337     balances[ceoWallet] = oneHundredMillion;
338     emit Transfer(address(0), ceoWallet, oneHundredMillion);
339     balances[cooWallet] = oneHundredMillion;
340     emit Transfer(address(0), cooWallet, oneHundredMillion);
341     balances[devWallet] = oneHundredMillion;
342     emit Transfer(address(0), devWallet, oneHundredMillion);
343     balances[poolWallet] = initialSupply.sub(balances[appWallet])
344     .sub(balances[genWallet])
345     .sub(balances[ceoWallet])
346     .sub(balances[cooWallet])
347     .sub(balances[devWallet]);
348     emit Transfer(address(0), poolWallet, balances[poolWallet]);
349     balances[msg.sender] = stageOneSupply.add(stageTwoSupply).add(stageThreeSupply);
350     emit Transfer(address(0), msg.sender, balances[msg.sender]);
351   }
352 
353   event Mint(address indexed to, uint256 amount);
354 
355   /**
356    * @dev Function to mint tokens
357    * @param _to The address that will receive the minted tokens.
358    * @return A boolean that indicates if the operation was successful.
359    */
360   function mint(
361     address _to
362   )
363     onlyOwner
364     external
365     returns (bool)
366   {
367     uint16 year = _getYear(now);
368     require (year >= mintStartYear && year <= mintEndYear && !minted[year]);
369     require (_to != address(0));
370 
371     totalSupply_ = totalSupply_.add(yearlyMintCap);
372     balances[_to] = balances[_to].add(yearlyMintCap);
373     minted[year] = true;
374 
375     emit Mint(_to, yearlyMintCap);
376     emit Transfer(address(0), _to, yearlyMintCap);
377     return true;
378   }
379 
380   function _getYear(uint256 timestamp)
381     internal
382     pure
383     returns (uint16)
384   {
385     uint16 ORIGIN_YEAR = 1970;
386     uint256 YEAR_IN_SECONDS = 31536000;
387     uint256 LEAP_YEAR_IN_SECONDS = 31622400;
388 
389     uint secondsAccountedFor = 0;
390     uint16 year;
391     uint numLeapYears;
392 
393     // Year
394     year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
395     numLeapYears = _leapYearsBefore(year) - _leapYearsBefore(ORIGIN_YEAR);
396 
397     secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
398     secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
399 
400     while (secondsAccountedFor > timestamp) {
401       if (_isLeapYear(uint16(year - 1))) {
402         secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
403       }
404       else {
405         secondsAccountedFor -= YEAR_IN_SECONDS;
406       }
407       year -= 1;
408     }
409     return year;
410   }
411 
412   function _isLeapYear(uint16 year)
413     internal
414     pure
415     returns (bool)
416   {
417     if (year % 4 != 0) {
418       return false;
419     }
420     if (year % 100 != 0) {
421       return true;
422     }
423     if (year % 400 != 0) {
424       return false;
425     }
426     return true;
427   }
428 
429   function _leapYearsBefore(uint year)
430     internal
431     pure
432     returns (uint)
433   {
434     year -= 1;
435     return year / 4 - year / 100 + year / 400;
436   }
437 
438 }
439 contract PetCoinCrowdSale is Owned {
440   using SafeMath for uint256;
441   using SafeERC20 for PetCoin;
442 
443   // Conversion rates
444   uint256 public stageOneRate = 4500; // 1 ETH = 4500 PETC
445   uint256 public stageTwoRate = 3000; // 1 ETH = 3000 PETC
446   uint256 public stageThreeRate = 2557; // 1 ETH = 2557 PETC
447 
448   // The token being sold
449   PetCoin public token;
450 
451   // Address where funds are collected
452   address public wallet;
453 
454   // Amount of wei raised
455   uint256 public weiRaised;
456 
457 
458   // Token Sale State Definitions
459   enum TokenSaleState { NOT_STARTED, STAGE_ONE, STAGE_TWO, STAGE_THREE, COMPLETED }
460 
461   TokenSaleState public state;
462 
463   struct Stage {
464     uint256 rate;
465     uint256 remaining;
466   }
467 
468   // Enum as mapping key not supported by Solidity yet
469   mapping(uint256 => Stage) public stages;
470 
471   /**
472    * Event for token purchase logging
473    * @param purchaser who paid for the tokens
474    * @param value weis paid for purchase
475    * @param amount amount of tokens purchased
476    */
477   event TokenPurchase(
478     address indexed purchaser,
479     uint256 value,
480     uint256 amount
481   );
482 
483 
484   /**
485    * Event for refund in case remaining tokens are not sufficient
486    * @param purchaser who paid for the tokens
487    * @param value weis refunded
488    */
489   event Refund(
490     address indexed purchaser,
491     uint256 value
492   );
493 
494   /**
495    * Event for move stage
496    * @param oldState old state
497    * @param newState new state
498    */
499   event MoveStage(
500     TokenSaleState oldState,
501     TokenSaleState newState
502   );
503 
504   /**
505  * Event for rates update
506  * @param who updated the rates
507  * @param stageOneRate new stageOneRate
508  * @param stageTwoRate new stageTwoRate
509  * @param stageThreeRate new stageThreeRate
510  */
511   event RatesUpdate(
512     address indexed who,
513     uint256 stageOneRate,
514     uint256 stageTwoRate,
515     uint256 stageThreeRate
516   );
517 
518   /**
519    * @param _token Address of the token being sold
520    * @param _wallet Address where collected funds will be forwarded to
521    */
522   constructor(PetCoin _token, address _wallet)
523     public
524   {
525     require(_token != address(0));
526     require(_wallet != address(0));
527 
528     token = _token;
529     wallet = _wallet;
530 
531     state = TokenSaleState.NOT_STARTED;
532     stages[uint256(TokenSaleState.STAGE_ONE)] = Stage(stageOneRate, token.stageOneSupply());
533     stages[uint256(TokenSaleState.STAGE_TWO)] = Stage(stageTwoRate, token.stageTwoSupply());
534     stages[uint256(TokenSaleState.STAGE_THREE)] = Stage(stageThreeRate, token.stageThreeSupply());
535   }
536 
537 
538   // Modifiers
539   modifier notStarted() {
540     require (state == TokenSaleState.NOT_STARTED);
541     _;
542   }
543 
544   modifier stageOne() {
545     require (state == TokenSaleState.STAGE_ONE);
546     _;
547   }
548 
549   modifier stageTwo() {
550     require (state == TokenSaleState.STAGE_TWO);
551     _;
552   }
553 
554   modifier stageThree() {
555     require (state == TokenSaleState.STAGE_THREE);
556     _;
557   }
558 
559   modifier completed() {
560     require (state == TokenSaleState.COMPLETED);
561     _;
562   }
563 
564   modifier saleInProgress() {
565     require (state == TokenSaleState.STAGE_ONE || state == TokenSaleState.STAGE_TWO || state == TokenSaleState.STAGE_THREE);
566     _;
567   }
568 
569   // -----------------------------------------
570   // Crowdsale external interface
571   // -----------------------------------------
572 
573   function kickoff()
574     external
575     onlyOwner
576     notStarted
577   {
578     _moveStage();
579   }
580 
581 
582   function updateRates(uint256 _stageOneRate, uint256 _stageTwoRate, uint256 _stageThreeRate)
583     external
584     onlyOwner
585   {
586     stageOneRate = _stageOneRate;
587     stageTwoRate = _stageTwoRate;
588     stageThreeRate = _stageThreeRate;
589     stages[uint256(TokenSaleState.STAGE_ONE)].rate = stageOneRate;
590     stages[uint256(TokenSaleState.STAGE_TWO)].rate = stageTwoRate;
591     stages[uint256(TokenSaleState.STAGE_THREE)].rate = stageThreeRate;
592     emit RatesUpdate(msg.sender, stageOneRate, stageTwoRate, stageThreeRate);
593   }
594 
595   /**
596    * @dev fallback function ***DO NOT OVERRIDE***
597    */
598   function ()
599     external
600     payable
601     saleInProgress
602   {
603     require(stages[uint256(state)].rate > 0);
604     require(stages[uint256(state)].remaining > 0);
605     require(msg.value > 0);
606 
607     uint256 weiAmount = msg.value;
608     uint256 refund = 0;
609 
610     // calculate token amount to be created
611     uint256 tokens = weiAmount.mul(stages[uint256(state)].rate);
612 
613     if (tokens > stages[uint256(state)].remaining) {
614       // calculate wei needed to purchase the remaining tokens
615       tokens = stages[uint256(state)].remaining;
616       weiAmount = tokens.div(stages[uint256(state)].rate);
617       refund = msg.value - weiAmount;
618     }
619 
620     // update state
621     weiRaised = weiRaised.add(weiAmount);
622 
623     emit TokenPurchase(
624       msg.sender,
625       weiAmount,
626       tokens
627     );
628 
629     // update remaining of the stage
630     stages[uint256(state)].remaining -= tokens;
631     assert(stages[uint256(state)].remaining >= 0);
632 
633     if (stages[uint256(state)].remaining == 0) {
634       _moveStage();
635     }
636 
637     // transfer tokens to buyer
638     token.safeTransfer(msg.sender, tokens);
639 
640     // forward ETH to the wallet
641     _forwardFunds(weiAmount);
642 
643     if (refund > 0) { // refund the purchaser if required
644       msg.sender.transfer(refund);
645       emit Refund(
646         msg.sender,
647         refund
648       );
649     }
650   }
651 
652   // -----------------------------------------
653   // Internal interface (extensible)
654   // -----------------------------------------
655 
656   function _moveStage()
657     internal
658   {
659     TokenSaleState oldState = state;
660     if (state == TokenSaleState.NOT_STARTED) {
661       state = TokenSaleState.STAGE_ONE;
662     } else if (state == TokenSaleState.STAGE_ONE) {
663       state = TokenSaleState.STAGE_TWO;
664     } else if (state == TokenSaleState.STAGE_TWO) {
665       state = TokenSaleState.STAGE_THREE;
666     } else if (state == TokenSaleState.STAGE_THREE) {
667       state = TokenSaleState.COMPLETED;
668     }
669     emit MoveStage(oldState, state);
670   }
671 
672   /**
673    * @dev Determines how ETH is stored/forwarded on purchases.
674    */
675   function _forwardFunds(uint256 weiAmount) internal {
676     wallet.transfer(weiAmount);
677   }
678 }