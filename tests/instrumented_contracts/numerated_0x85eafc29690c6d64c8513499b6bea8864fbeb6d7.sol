1 pragma solidity ^0.4.23;
2 
3 // File: contracts/OpenZeppelin/ERC20Basic.sol
4 
5 /**
6  * @title ERC20
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20 {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/OpenZeppelin/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22 */
23 
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   /**
49   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 /**
67  * @title Crowdsale
68  * @dev Crowdsale is a base contract for managing a token crowdsale,
69  * allowing investors to purchase tokens with ether.
70  */
71 
72 contract Crowdsale {
73   using SafeMath for uint256;
74 
75   // The token being sold
76   ERC20 public token;
77 
78   // Address where funds are collected
79   address public wallet;
80 
81   // Address of the contract owner
82   address public owner;
83 
84   // The rate of tokens per ether. Only applied for the first tier, the first
85   // 150 million tokens sold
86   uint256 public rate;
87 
88   // Amount of wei raised
89   uint256 public weiRaised;
90 
91   // Amount of sold tokens
92   uint256 public soldTokens;
93 
94   // Amount of tokens processed
95   uint256 public processedTokens;
96 
97   // Amount of unsold tokens to burn
98   uint256 public unSoldTokens;
99 
100   // Amount of locked tokens
101   uint256 public lockedTokens;
102 
103   // Amount of alocated tokens
104   uint256 public allocatedTokens;
105 
106   // Amount of distributed tokens
107   uint256 public distributedTokens;
108 
109   // ICO state paused or not
110   bool public paused = false;
111 
112   // Minimal amount to exchange in ETH
113   uint256 public minPurchase = 53 finney;
114 
115   // Keeping track of current round
116   uint256 public currentRound;
117 
118   // We can only sell maximum total amount- 1,000,000,000 tokens during the ICO
119   uint256 public constant maxTokensRaised = 1000000000E4;
120 
121   // Timestamp when the crowdsale starts 01/01/2018 @ 00:00am (UTC);
122   uint256 public startTime = 1527703200;
123 
124   // Timestamp when the initial round ends (UTC);
125   uint256 public currentRoundStart = startTime;
126 
127   // Timestamp when the crowdsale ends 07/07/2018 @ 00:00am (UTC);
128   uint256 public endTime = 1532386740;
129 
130   // Timestamp when locked tokens become unlocked 21/09/2018 @ 00:00am (UTC);
131   uint256 public lockedTill = 1542931200;
132 
133   // Timestamp when approved tokens become available 21/09/2018 @ 00:00am (UTC);
134   uint256 public approvedTill = 1535328000;
135 
136   // How much each user paid for the crowdsale
137   mapping(address => uint256) public crowdsaleBalances;
138 
139   // How many tokens each user got for the crowdsale
140   mapping(address => uint256) public tokensBought;
141 
142   // How many tokens each user got for the crowdsale as bonus
143   mapping(address => uint256) public bonusBalances;
144 
145   // How many tokens each user got locked
146   mapping(address => uint256) public lockedBalances;
147 
148   // How many tokens each user got pre-delivered
149   mapping(address => uint256) public allocatedBalances;
150 
151   // If user is approved to withdraw tokens
152   mapping(address => bool) public approved;
153 
154   // How many tokens each user got distributed
155   mapping(address => uint256) public distributedBalances;
156 
157   // Bonus levels per each round
158   mapping (uint256 => uint256) public bonusLevels;
159 
160   // Rate levels per each round
161   mapping (uint256 => uint256) public rateLevels;
162 
163   // Cap levels per each round
164   mapping (uint256 => uint256) public capLevels;
165 
166   // To track list of contributors
167   address[] public allocatedAddresses;              
168 
169 
170   /**
171    * Event for token purchase logging
172    * @param purchaser who paid for the tokens
173    * @param beneficiary who got the tokens
174    * @param value weis paid for purchase
175    * @param amount amount of tokens purchased
176    */
177 
178   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
179 
180   event Pause();
181   event Unpause();
182 
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   modifier whenNotPaused() {
189     require(!paused);
190     _;
191   }
192 
193   modifier whenPaused() {
194     require(paused);
195     _;
196   }
197 
198   function pause() onlyOwner whenNotPaused public {
199     paused = true;
200     emit Pause();
201   }
202 
203   function unpause() onlyOwner whenPaused public {
204     paused = false;
205     emit Unpause();
206   }
207 
208   function setNewBonusLevel (uint256 _bonusIndex, uint256 _bonusValue) onlyOwner external {
209     bonusLevels[_bonusIndex] = _bonusValue;
210   }
211 
212   function setNewRateLevel (uint256 _rateIndex, uint256 _rateValue) onlyOwner external {
213     rateLevels[_rateIndex] = _rateValue;
214   }
215 
216   function setMinPurchase (uint256 _minPurchase) onlyOwner external {
217     minPurchase = _minPurchase;
218   }
219 
220    // @notice Set's the rate of tokens per ether for each round
221   function setNewRatesCustom (uint256 _r1, uint256 _r2, uint256 _r3, uint256 _r4, uint256 _r5, uint256 _r6) onlyOwner external {
222     require(_r1 > 0 && _r2 > 0 && _r3 > 0 && _r4 > 0 && _r5 > 0 && _r6 > 0);
223     rateLevels[1] = _r1;
224     rateLevels[2] = _r2;
225     rateLevels[3] = _r3;
226     rateLevels[4] = _r4;
227     rateLevels[5] = _r5;
228     rateLevels[6] = _r6;
229   }
230 
231    // @notice Set's the rate of tokens per ether for each round
232   function setNewRatesBase (uint256 _r1) onlyOwner external {
233     require(_r1 > 0);
234     rateLevels[1] = _r1;
235     rateLevels[2] = _r1.div(2);
236     rateLevels[3] = _r1.div(3);
237     rateLevels[4] = _r1.div(4);
238     rateLevels[5] = _r1.div(5);
239     rateLevels[6] = _r1.div(5);
240   }
241 
242   /**
243    * @param _rate Number of token units a buyer gets per ETH
244    * @param _wallet Address where collected funds will be forwarded to
245    * @param _token Address of the token being sold
246    */
247 
248   constructor(uint256 _rate, address _wallet, address _owner, ERC20 _token) public {
249     require(_rate > 0);
250     require(_wallet != address(0));
251     require(_token != address(0));
252 
253     wallet = _wallet;
254     token = _token;
255     owner = _owner;
256 
257     soldTokens = 0;
258     unSoldTokens = 0;
259     processedTokens = 0;
260 
261     lockedTokens = 0;
262     distributedTokens = 0;
263 
264     currentRound = 1;
265 
266     //bonus values per each round;
267     bonusLevels[1] =  5;
268     bonusLevels[2] = 10;
269     bonusLevels[3] = 15;
270     bonusLevels[4] = 20;
271     bonusLevels[5] = 50;
272     bonusLevels[6] = 0;
273 
274     //rate values per each round;
275     rateLevels[1] = _rate;
276     rateLevels[2] = _rate.div(2);
277     rateLevels[3] = _rate.div(3);
278     rateLevels[4] = _rate.div(4);
279     rateLevels[5] = _rate.div(5);
280     rateLevels[6] = _rate.div(5);
281 
282     //cap values per each round
283     capLevels[1] = 150000000E4;
284     capLevels[2] = 210000000E4;
285     capLevels[3] = 255000000E4;
286     capLevels[4] = 285000000E4;
287     capLevels[5] = 300000000E4;
288     capLevels[6] = maxTokensRaised;
289 
290   }
291 
292   // -----------------------------------------
293   // Crowdsale interface
294   // -----------------------------------------
295 
296   function () external payable whenNotPaused {
297     buyTokens(msg.sender);
298   }
299 
300   /**
301    * @dev low level token purchase
302    * @param _beneficiary Address performing the token purchase
303    */
304   function buyTokens(address _beneficiary) public payable whenNotPaused {
305 
306     uint256 amountPaid = msg.value;
307     _preValidatePurchase(_beneficiary, amountPaid);
308 
309     uint256 tokens = 0;
310     uint256 bonusTokens = 0;
311     uint256 fullTokens = 0;
312 
313     // Round 1
314     if(processedTokens < capLevels[1]) {
315 
316         tokens = _getTokensAmount(amountPaid, 1);
317         bonusTokens = _getBonusAmount(tokens, 1);
318         fullTokens = tokens.add(bonusTokens);
319 
320         // If the amount of tokens that you want to buy gets out of round 1
321         if(processedTokens.add(fullTokens) > capLevels[1]) {
322             tokens = _calculateExcessTokens(amountPaid, 1);
323             bonusTokens = _calculateExcessBonus(tokens, 1);
324             setCurrentRound(2);
325         }
326 
327     // Round 2
328     } else if(processedTokens >= capLevels[1] && processedTokens < capLevels[2]) {
329         tokens = _getTokensAmount(amountPaid, 2);
330         bonusTokens = _getBonusAmount(tokens, 2);
331         fullTokens = tokens.add(bonusTokens);
332 
333         // If the amount of tokens that you want to buy gets out of round 2
334         if(processedTokens.add(fullTokens) > capLevels[2]) {
335             tokens = _calculateExcessTokens(amountPaid, 2);
336             bonusTokens = _calculateExcessBonus(tokens, 2);
337             setCurrentRound(3);
338         }
339 
340     // Round 3
341     } else if(processedTokens >= capLevels[2] && processedTokens < capLevels[3]) {
342          tokens = _getTokensAmount(amountPaid, 3);
343          bonusTokens = _getBonusAmount(tokens, 3);
344          fullTokens = tokens.add(bonusTokens);
345 
346          // If the amount of tokens that you want to buy gets out of round 3
347          if(processedTokens.add(fullTokens) > capLevels[3]) {
348             tokens = _calculateExcessTokens(amountPaid, 3);
349             bonusTokens = _calculateExcessBonus(tokens, 3);
350             setCurrentRound(4);
351          }
352 
353     // Round 4
354     } else if(processedTokens >= capLevels[3] && processedTokens < capLevels[4]) {
355          tokens = _getTokensAmount(amountPaid, 4);
356          bonusTokens = _getBonusAmount(tokens, 4);
357          fullTokens = tokens.add(bonusTokens);
358 
359          // If the amount of tokens that you want to buy gets out of round 4
360          if(processedTokens.add(fullTokens) > capLevels[4]) {
361             tokens = _calculateExcessTokens(amountPaid, 4);
362             bonusTokens = _calculateExcessBonus(tokens, 4);
363             setCurrentRound(5);
364          }
365 
366     // Round 5
367     } else if(processedTokens >= capLevels[4] && processedTokens < capLevels[5]) {
368          tokens = _getTokensAmount(amountPaid, 5);
369          bonusTokens = _getBonusAmount(tokens, 5);
370          fullTokens = tokens.add(bonusTokens);
371 
372          // If the amount of tokens that you want to buy gets out of round 5
373          if(processedTokens.add(fullTokens) > capLevels[5]) {
374             tokens = _calculateExcessTokens(amountPaid, 5);
375             bonusTokens = 0;
376             setCurrentRound(6);
377          }
378 
379     // Round 6
380     } else if(processedTokens >= capLevels[5]) {
381         tokens = _getTokensAmount(amountPaid, 6);
382     }
383 
384     // update state
385     weiRaised = weiRaised.add(amountPaid);
386     fullTokens = tokens.add(bonusTokens);
387     soldTokens = soldTokens.add(fullTokens);
388     processedTokens = processedTokens.add(fullTokens);
389 
390     // Keep a record of how many tokens everybody gets in case we need to do refunds
391     tokensBought[msg.sender] = tokensBought[msg.sender].add(tokens);
392 
393     // Kepp a record of how many wei everybody contributed in case we need to do refunds
394     crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(amountPaid);
395 
396     // Kepp a record of how many token everybody got as bonus to display in
397     bonusBalances[msg.sender] = bonusBalances[msg.sender].add(bonusTokens);
398 
399    // Combine bought tokens with bonus tokens before sending to investor
400     uint256 totalTokens = tokens.add(bonusTokens);
401 
402     // Distribute the token
403     _processPurchase(_beneficiary, totalTokens);
404     emit TokenPurchase(
405       msg.sender,
406       _beneficiary,
407       amountPaid,
408       totalTokens
409     );
410   }
411 
412   // -----------------------------------------
413   // Internal interface (extensible)
414   // -----------------------------------------
415 
416   /**
417    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
418    * @param _beneficiary Address performing the token purchase
419    * @param _weiAmount Value in wei involved in the purchase
420    */
421   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal {
422 
423     require(_beneficiary != address(0));
424     require(_weiAmount != 0);
425 
426     bool withinPeriod = hasStarted() && hasNotEnded();
427     bool nonZeroPurchase = msg.value > 0;
428     bool withinTokenLimit = processedTokens < maxTokensRaised;
429     bool minimumPurchase = msg.value >= minPurchase;
430 
431     require(withinPeriod);
432     require(nonZeroPurchase);
433     require(withinTokenLimit);
434     require(minimumPurchase);
435   }
436 
437 
438   /**
439    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
440    * @param _beneficiary Address receiving the tokens
441    * @param _tokenAmount Number of tokens to be purchased
442    */
443   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
444     uint256 _tokensToPreAllocate = _tokenAmount.div(2);
445     uint256 _tokensToLock = _tokenAmount.sub(_tokensToPreAllocate);
446     
447     //record address for future distribution
448     allocatedAddresses.push(_beneficiary);    
449 
450     //pre allocate 50% of purchase for delivery in 30 days
451     _preAllocateTokens(_beneficiary, _tokensToPreAllocate);
452     
453     //lock 50% of purchase for delivery after 4 months
454     _lockTokens(_beneficiary, _tokensToLock);
455     
456     //approve by default (dissaprove manually)
457     approved[_beneficiary] = true;
458   }
459 
460   function _lockTokens(address _beneficiary, uint256 _tokenAmount) internal {
461     lockedBalances[_beneficiary] = lockedBalances[_beneficiary].add(_tokenAmount);
462     lockedTokens = lockedTokens.add(_tokenAmount);
463   }
464 
465   function _preAllocateTokens(address _beneficiary, uint256 _tokenAmount) internal {
466     allocatedBalances[_beneficiary] = allocatedBalances[_beneficiary].add(_tokenAmount);
467     allocatedTokens = allocatedTokens.add(_tokenAmount);
468   }
469 
470   /**
471    * @dev Override to extend the way in which ether is converted to bonus tokens.
472    * @param _tokenAmount Value in wei to be converted into tokens
473    * @return Number of bonus tokens that can be distributed with the specified bonus percent
474    */
475   function _getBonusAmount(uint256 _tokenAmount, uint256 _bonusIndex) internal view returns (uint256) {
476     uint256 bonusValue = _tokenAmount.mul(bonusLevels[_bonusIndex]);
477     return bonusValue.div(100);
478   }
479 
480     function _calculateExcessBonus(uint256 _tokens, uint256 _level) internal view returns (uint256) {
481         uint256 thisLevelTokens = processedTokens.add(_tokens);
482         uint256 nextLevelTokens = thisLevelTokens.sub(capLevels[_level]);
483         uint256 totalBonus = _getBonusAmount(nextLevelTokens, _level.add(1));
484         return totalBonus;
485     }
486 
487    function _calculateExcessTokens(
488       uint256 amount,
489       uint256 roundSelected
490    ) internal returns(uint256) {
491       require(amount > 0);
492       require(roundSelected >= 1 && roundSelected <= 6);
493 
494       uint256 _rate = rateLevels[roundSelected];
495       uint256 _leftTokens = capLevels[roundSelected].sub(processedTokens);
496       uint256 weiThisRound = _leftTokens.div(_rate).mul(1E14);
497       uint256 weiNextRound = amount.sub(weiThisRound);
498       uint256 tokensNextRound = 0;
499 
500       // If there's excessive wei for the last tier, refund those
501       uint256 nextRound = roundSelected.add(1);
502       if(roundSelected != 6) {
503         tokensNextRound = _getTokensAmount(weiNextRound, nextRound);
504       }
505       else {
506          msg.sender.transfer(weiNextRound);
507       }
508 
509       uint256 totalTokens = _leftTokens.add(tokensNextRound);
510       return totalTokens;
511    }
512 
513 
514    function _getTokensAmount(uint256 weiPaid, uint256 roundSelected)
515         internal constant returns(uint256 calculatedTokens)
516    {
517       require(weiPaid > 0);
518       require(roundSelected >= 1 && roundSelected <= 6);
519       uint256 typeTokenWei = weiPaid.div(1E14);
520       calculatedTokens = typeTokenWei.mul(rateLevels[roundSelected]);
521 
522    }
523 
524   // -----------------------------------------
525   // External interface (withdraw)
526   // -----------------------------------------
527 
528   /**
529    * @dev Determines how ETH is being transfered to owners wallet.
530    */
531   function _withdrawAllFunds() onlyOwner external {
532     wallet.transfer(address(this).balance);
533   }
534 
535   function _withdrawWei(uint256 _amount) onlyOwner external {
536     wallet.transfer(_amount);
537   }
538 
539    function _changeLockDate(uint256 _newDate) onlyOwner external {
540     require(_newDate <= endTime.add(36 weeks));
541     lockedTill = _newDate;
542   }
543 
544    function _changeApproveDate(uint256 _newDate) onlyOwner external {
545     require(_newDate <= endTime.add(12 weeks));
546     approvedTill = _newDate;
547   }
548 
549   function changeWallet(address _newWallet) onlyOwner external {
550     wallet = _newWallet;
551   }
552 
553    /// @notice Public function to check if the crowdsale has ended or not
554    function hasNotEnded() public constant returns(bool) {
555       return now < endTime && processedTokens < maxTokensRaised;
556    }
557 
558    /// @notice Public function to check if the crowdsale has started or not
559    function hasStarted() public constant returns(bool) {
560       return now > startTime;
561    }
562 
563     function setCurrentRound(uint256 _roundIndex) internal {
564         currentRound = _roundIndex;
565         currentRoundStart = now;
566     }
567 
568     //move to next round by overwriting soldTokens value, unsold tokens will be burned;
569    function goNextRound() onlyOwner external {
570        require(currentRound < 6);
571        uint256 notSold = getUnsold();
572        unSoldTokens = unSoldTokens.add(notSold);
573        processedTokens = capLevels[currentRound];
574        currentRound = currentRound.add(1);
575        currentRoundStart = now;
576    }
577 
578     function getUnsold() internal view returns (uint256) {
579         uint256 unSold = capLevels[currentRound].sub(processedTokens);
580         return unSold;
581     }
582 
583     function checkUnsold() onlyOwner external view returns (uint256) {
584         uint256 unSold = capLevels[currentRound].sub(processedTokens);
585         return unSold;
586     }
587 
588     function round() public view returns(uint256) {
589         return currentRound;
590     }
591 
592     function currentBonusLevel() public view returns(uint256) {
593         return bonusLevels[currentRound];
594     }
595 
596     function currentRateLevel() public view returns(uint256) {
597         return rateLevels[currentRound];
598     }
599 
600     function currentCapLevel() public view returns(uint256) {
601         return capLevels[currentRound];
602     }
603 
604     function changeApproval(address _beneficiary, bool _newStatus) onlyOwner public {
605         approved[_beneficiary] = _newStatus;
606     }
607 
608     function massApproval(bool _newStatus, uint256 _start, uint256 _end) onlyOwner public {
609         require(_start >= 0);
610         require(_end > 0);
611         require(_end > _start);
612         for (uint256 i = _start; i < _end; i++) {
613             approved[allocatedAddresses[i]] = _newStatus;
614         }
615     }
616 
617     function autoTransferApproved(uint256 _start, uint256 _end) onlyOwner public {
618         require(_start >= 0);
619         require(_end > 0);
620         require(_end > _start);
621         for (uint256 i = _start; i < _end; i++) {
622             transferApprovedBalance(allocatedAddresses[i]);
623         }
624     }
625 
626     function autoTransferLocked(uint256 _start, uint256 _end) onlyOwner public {
627         require(_start >= 0);
628         require(_end > 0);
629         require(_end > _start);
630         for (uint256 i = _start; i < _end; i++) {
631             transferLockedBalance(allocatedAddresses[i]);
632         }
633     }
634 
635     function transferApprovedBalance(address _beneficiary) public {
636         require(_beneficiary != address(0));
637         require(now >= approvedTill);
638         require(allocatedTokens > 0);
639         require(approved[_beneficiary]);
640         require(allocatedBalances[_beneficiary] > 0);
641         
642         uint256 _approvedTokensToTransfer = allocatedBalances[_beneficiary];
643         token.transfer(_beneficiary, _approvedTokensToTransfer);
644         distributedBalances[_beneficiary] = distributedBalances[_beneficiary].add(_approvedTokensToTransfer);
645         allocatedTokens = allocatedTokens.sub(_approvedTokensToTransfer);
646         allocatedBalances[_beneficiary] = 0;
647         distributedTokens = distributedTokens.add(_approvedTokensToTransfer);
648     }
649 
650     function transferLockedBalance(address _beneficiary) public {
651         require(_beneficiary != address(0));
652         require(now >= lockedTill);
653         require(lockedTokens > 0);
654         require(approved[_beneficiary]);
655         require(lockedBalances[_beneficiary] > 0);
656 
657         uint256 _lockedTokensToTransfer = lockedBalances[_beneficiary];
658         token.transfer(_beneficiary, _lockedTokensToTransfer);
659         distributedBalances[_beneficiary] = distributedBalances[_beneficiary].add(_lockedTokensToTransfer);
660         lockedTokens = lockedTokens.sub(_lockedTokensToTransfer);
661         lockedBalances[_beneficiary] = 0;
662         distributedTokens = distributedTokens.add(_lockedTokensToTransfer);
663     }
664 
665     function transferToken(uint256 _tokens) external onlyOwner returns (bool success) {
666         //bool withinPeriod = hasStarted() && hasNotEnded();
667         //require(!withinPeriod);
668         return token.transfer(owner, _tokens);
669     }
670 
671     function tokenBalance() public view returns (uint256) {
672         return token.balanceOf(address(this));
673     }
674 
675     //destory contract with unsold tokens
676     function burnUnsold() public onlyOwner {
677         require(now > lockedTill);
678         require(address(this).balance == 0);
679         require(lockedTokens == 0);
680         require(allocatedTokens == 0);
681         require(unSoldTokens > 0);
682         selfdestruct(owner);
683     }
684 
685 }