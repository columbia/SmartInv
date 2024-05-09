1 pragma solidity ^0.4.18;
2 
3 // File: contracts/MigrationTarget.sol
4 
5 //
6 // Migration target
7 // @dev Implement this interface to make migration target
8 //
9 contract MigrationTarget {
10   function migrateFrom(address _from, uint256 _amount, uint256 _rewards, uint256 _trueBuy, bool _devStatus) public;
11 }
12 
13 // File: contracts/Ownable.sol
14 
15 contract Ownable {
16   address public owner;
17 
18   // Event
19   event OwnershipChanged(address indexed oldOwner, address indexed newOwner);
20 
21   // Modifier
22   modifier onlyOwner {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   function Ownable() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     emit OwnershipChanged(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 // File: contracts/ERC20.sol
43 
44 contract ERC20 {
45   uint256 public totalSupply;
46   function balanceOf(address _owner) view public returns (uint256 balance);
47   function transfer(address _to, uint256 _value) public returns (bool success);
48   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
49   function approve(address _spender, uint256 _value) public returns (bool success);
50   function allowance(address _owner, address _spender) view public returns (uint256 remaining);
51   event Transfer(address indexed _from, address indexed _to, uint256 _value);
52   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 // File: contracts/SafeMath.sol
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62   function mul(uint256 a, uint256 b)
63     internal
64     pure
65     returns (uint256)
66   {
67     if (a == 0) {
68       return 0;
69     }
70     uint256 c = a * b;
71     assert(c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b)
76     internal
77     pure
78     returns (uint256)
79   {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return c;
84   }
85 
86   function sub(uint256 a, uint256 b)
87     internal
88     pure
89     returns (uint256)
90   {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b)
96     internal
97     pure
98     returns (uint256)
99   {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 // File: contracts/StandardToken.sol
107 
108 /*  ERC 20 token */
109 contract StandardToken is ERC20 {
110   /**
111    * Internal transfer, only can be called by this contract
112    */
113   function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
114     // Prevent transfer to 0x0 address. Use burn() instead
115     require(_to != address(0));
116     // Check if the sender has enough
117     require(balances[_from] >= _value);
118     // Check for overflows
119     require(balances[_to] + _value > balances[_to]);
120     // Save this for an assertion in the future
121     uint256 previousBalances = balances[_from] + balances[_to];
122     // Subtract from the sender
123     balances[_from] -= _value;
124     // Add the same to the recipient
125     balances[_to] += _value;
126     emit Transfer(_from, _to, _value);
127     // Asserts are used to use static analysis to find bugs in your code. They should never fail
128     assert(balances[_from] + balances[_to] == previousBalances);
129 
130     return true;
131   }
132 
133   /**
134    * Transfer tokens
135    *
136    * Send `_value` tokens to `_to` from your account
137    *
138    * @param _to The address of the recipient
139    * @param _value the amount to send
140    */
141   function transfer(address _to, uint256 _value) public returns (bool success) {
142     return _transfer(msg.sender, _to, _value);
143   }
144 
145   /**
146    * Transfer tokens from other address
147    *
148    * Send `_value` tokens to `_to` in behalf of `_from`
149    *
150    * @param _from The address of the sender
151    * @param _to The address of the recipient
152    * @param _value the amount to send
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
155     require(_value <= allowed[_from][msg.sender]);     // Check allowance
156     allowed[_from][msg.sender] -= _value;
157     return _transfer(_from, _to, _value);
158   }
159 
160   function balanceOf(address _owner) view public returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164   /**
165    * Set allowance for other address
166    *
167    * Allows `_spender` to spend no more than `_value` tokens in your behalf
168    *
169    * @param _spender The address authorized to spend
170    * @param _value the max amount they can spend
171    */
172   function approve(address _spender, uint256 _value) public returns (bool success) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182   mapping (address => uint256) public balances;
183   mapping (address => mapping (address => uint256)) public allowed;
184 }
185 
186 // File: contracts/RoyaltyToken.sol
187 
188 /*  Royalty token */
189 contract RoyaltyToken is StandardToken {
190   using SafeMath for uint256;
191   // restricted addresses	
192   mapping(address => bool) public restrictedAddresses;
193   
194   event RestrictedStatusChanged(address indexed _address, bool status);
195 
196   struct Account {
197     uint256 balance;
198     uint256 lastRoyaltyPoint;
199   }
200 
201   mapping(address => Account) public accounts;
202   uint256 public totalRoyalty;
203   uint256 public unclaimedRoyalty;
204 
205   /**
206    * Get Royalty amount for given account
207    *
208    * @param account The address for Royalty account
209    */
210   function RoyaltysOwing(address account) public view returns (uint256) {
211     uint256 newRoyalty = totalRoyalty.sub(accounts[account].lastRoyaltyPoint);
212     return balances[account].mul(newRoyalty).div(totalSupply);
213   }
214 
215   /**
216    * @dev Update account for Royalty
217    * @param account The address of owner
218    */
219   function updateAccount(address account) internal {
220     uint256 owing = RoyaltysOwing(account);
221     accounts[account].lastRoyaltyPoint = totalRoyalty;
222     if (owing > 0) {
223       unclaimedRoyalty = unclaimedRoyalty.sub(owing);
224       accounts[account].balance = accounts[account].balance.add(owing);
225     }
226   }
227 
228   function disburse() public payable {
229     require(totalSupply > 0);
230     require(msg.value > 0);
231 
232     uint256 newRoyalty = msg.value;
233     totalRoyalty = totalRoyalty.add(newRoyalty);
234     unclaimedRoyalty = unclaimedRoyalty.add(newRoyalty);
235   }
236 
237   /**
238    * @dev Send `_value` tokens to `_to` from your account
239    *
240    * @param _to The address of the recipient
241    * @param _value the amount to send
242    */
243   function transfer(address _to, uint256 _value) public returns (bool success) {
244     // Require that the sender is not restricted
245     require(restrictedAddresses[msg.sender] == false);
246     updateAccount(_to);
247     updateAccount(msg.sender);
248     return super.transfer(_to, _value);
249   }
250 
251   /**
252    * @dev Transfer tokens from other address. Send `_value` tokens to `_to` in behalf of `_from`
253    *
254    * @param _from The address of the sender
255    * @param _to The address of the recipient
256    * @param _value the amount to send
257    */
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   ) public returns (bool success) {
263     updateAccount(_to);
264     updateAccount(_from);
265     return super.transferFrom(_from, _to, _value);
266   }
267 
268   function withdrawRoyalty() public {
269     updateAccount(msg.sender);
270 
271     // retrieve Royalty amount
272     uint256 RoyaltyAmount = accounts[msg.sender].balance;
273     require(RoyaltyAmount > 0);
274     accounts[msg.sender].balance = 0;
275 
276     // transfer Royalty amount
277     msg.sender.transfer(RoyaltyAmount);
278   }
279 }
280 
281 // File: contracts/Q2.sol
282 
283 contract Q2 is Ownable, RoyaltyToken {
284   using SafeMath for uint256;
285 
286   string public name = "Q2";
287   string public symbol = "Q2";
288   uint8 public decimals = 18;
289 
290   bool public whitelist = true;
291 
292   // whitelist addresses
293   mapping(address => bool) public whitelistedAddresses;
294 
295   // token creation cap
296   uint256 public creationCap = 15000000 * (10 ** 18); // 15M
297   uint256 public reservedFund = 10000000 * (10 ** 18); // 10M
298 
299   // stage info
300   struct Stage {
301     uint8 number;
302     uint256 exchangeRate;
303     uint256 startBlock;
304     uint256 endBlock;
305     uint256 cap;
306   }
307 
308   // events
309   event MintTokens(address indexed _to, uint256 _value);
310   event StageStarted(uint8 _stage, uint256 _totalSupply, uint256 _balance);
311   event StageEnded(uint8 _stage, uint256 _totalSupply, uint256 _balance);
312   event WhitelistStatusChanged(address indexed _address, bool status);
313   event WhitelistChanged(bool status);
314 
315   // eth wallet
316   address public ethWallet;
317   mapping (uint8 => Stage) stages;
318 
319   // current state info
320   uint8 public currentStage;
321 
322   function Q2(address _ethWallet) public {
323     ethWallet = _ethWallet;
324 
325     // reserved tokens
326     mintTokens(ethWallet, reservedFund);
327   }
328 
329   function mintTokens(address to, uint256 value) internal {
330     require(value > 0);
331     balances[to] = balances[to].add(value);
332     totalSupply = totalSupply.add(value);
333     require(totalSupply <= creationCap);
334 
335     // broadcast event
336     emit MintTokens(to, value);
337   }
338 
339   function () public payable {
340     buyTokens();
341   }
342 
343   function buyTokens() public payable {
344     require(whitelist==false || whitelistedAddresses[msg.sender] == true);
345     require(msg.value > 0);
346 
347     Stage memory stage = stages[currentStage];
348     require(block.number >= stage.startBlock && block.number <= stage.endBlock);
349 
350     uint256 tokens = msg.value * stage.exchangeRate;
351     require(totalSupply.add(tokens) <= stage.cap);
352 
353     mintTokens(msg.sender, tokens);
354   }
355 
356   function startStage(
357     uint256 _exchangeRate,
358     uint256 _cap,
359     uint256 _startBlock,
360     uint256 _endBlock
361   ) public onlyOwner {
362     require(_exchangeRate > 0 && _cap > 0);
363     require(_startBlock > block.number);
364     require(_startBlock < _endBlock);
365 
366     // stop current stage if it's running
367     Stage memory currentObj = stages[currentStage];
368     if (currentObj.endBlock > 0) {
369       // broadcast stage end event
370       emit StageEnded(currentStage, totalSupply, address(this).balance);
371     }
372 
373     // increment current stage
374     currentStage = currentStage + 1;
375 
376     // create new stage object
377     Stage memory s = Stage({
378       number: currentStage,
379       startBlock: _startBlock,
380       endBlock: _endBlock,
381       exchangeRate: _exchangeRate,
382       cap: _cap + totalSupply
383     });
384     stages[currentStage] = s;
385 
386     // broadcast stage started event
387     emit StageStarted(currentStage, totalSupply, address(this).balance);
388   }
389 
390   function withdraw() public onlyOwner {
391     ethWallet.transfer(address(this).balance);
392   }
393 
394   function getCurrentStage() view public returns (
395     uint8 number,
396     uint256 exchangeRate,
397     uint256 startBlock,
398     uint256 endBlock,
399     uint256 cap
400   ) {
401     Stage memory currentObj = stages[currentStage];
402     number = currentObj.number;
403     exchangeRate = currentObj.exchangeRate;
404     startBlock = currentObj.startBlock;
405     endBlock = currentObj.endBlock;
406     cap = currentObj.cap;
407   }
408 
409   function changeWhitelistStatus(address _address, bool status) public onlyOwner {
410     whitelistedAddresses[_address] = status;
411     emit WhitelistStatusChanged(_address, status);
412   }
413 
414   function changeRestrictedtStatus(address _address, bool status) public onlyOwner {
415     restrictedAddresses[_address] = status;
416     emit RestrictedStatusChanged(_address, status);
417   }
418   
419   function changeWhitelist(bool status) public onlyOwner {
420      whitelist = status;
421      emit WhitelistChanged(status);
422   }
423 }
424 
425 // File: contracts/Quarters.sol
426 
427 interface TokenRecipient {
428   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
429 }
430 
431 contract Quarters is Ownable, StandardToken {
432   // Public variables of the token
433   string public name = "Quarters";
434   string public symbol = "Q";
435   uint8 public decimals = 0; // no decimals, only integer quarters
436 
437   uint16 public ethRate = 4000; // Quarters/ETH
438   uint256 public tranche = 40000; // Number of Quarters in initial tranche
439 
440   // List of developers
441   // address -> status
442   mapping (address => bool) public developers;
443 
444   uint256 public outstandingQuarters;
445   address public q2;
446 
447   // number of Quarters for next tranche
448   uint8 public trancheNumerator = 2;
449   uint8 public trancheDenominator = 1;
450 
451   // initial multiples, rates (as percentages) for tiers of developers
452   uint32 public mega = 20;
453   uint32 public megaRate = 115;
454   uint32 public large = 100;
455   uint32 public largeRate = 90;
456   uint32 public medium = 2000;
457   uint32 public mediumRate = 75;
458   uint32 public small = 50000;
459   uint32 public smallRate = 50;
460   uint32 public microRate = 25;
461 
462   // rewards related storage
463   mapping (address => uint256) public rewards;    // rewards earned, but not yet collected
464   mapping (address => uint256) public trueBuy;    // tranche rewards are set based on *actual* purchases of Quarters
465 
466   uint256 public rewardAmount = 40;
467 
468   uint8 public rewardNumerator = 1;
469   uint8 public rewardDenominator = 4;
470 
471   // reserve ETH from Q2 to fund rewards
472   uint256 public reserveETH=0;
473 
474   // ETH rate changed
475   event EthRateChanged(uint16 currentRate, uint16 newRate);
476 
477   // This notifies clients about the amount burnt
478   event Burn(address indexed from, uint256 value);
479 
480   event QuartersOrdered(address indexed sender, uint256 ethValue, uint256 tokens);
481   event DeveloperStatusChanged(address indexed developer, bool status);
482   event TrancheIncreased(uint256 _tranche, uint256 _etherPool, uint256 _outstandingQuarters);
483   event MegaEarnings(address indexed developer, uint256 value, uint256 _baseRate, uint256 _tranche, uint256 _outstandingQuarters, uint256 _etherPool);
484   event Withdraw(address indexed developer, uint256 value, uint256 _baseRate, uint256 _tranche, uint256 _outstandingQuarters, uint256 _etherPool);
485   event BaseRateChanged(uint256 _baseRate, uint256 _tranche, uint256 _outstandingQuarters, uint256 _etherPool,  uint256 _totalSupply);
486   event Reward(address indexed _address, uint256 value, uint256 _outstandingQuarters, uint256 _totalSupply);
487 
488   /**
489    * developer modifier
490    */
491   modifier onlyActiveDeveloper() {
492     require(developers[msg.sender] == true);
493     _;
494   }
495 
496   /**
497    * Constructor function
498    *
499    * Initializes contract with initial supply tokens to the owner of the contract
500    */
501   function Quarters(
502     address _q2,
503     uint256 firstTranche
504   ) public {
505     q2 = _q2;
506     tranche = firstTranche; // number of Quarters to be sold before increasing price
507   }
508 
509   function setEthRate (uint16 rate) onlyOwner public {
510     // Ether price is set in Wei
511     require(rate > 0);
512     ethRate = rate;
513     emit EthRateChanged(ethRate, rate);
514   }
515 
516   /**
517    * Adjust reward amount
518    */
519   function adjustReward (uint256 reward) onlyOwner public {
520     rewardAmount = reward; // may be zero, no need to check value to 0
521   }
522 
523   function adjustWithdrawRate(uint32 mega2, uint32 megaRate2, uint32 large2, uint32 largeRate2, uint32 medium2, uint32 mediumRate2, uint32 small2, uint32 smallRate2, uint32 microRate2) onlyOwner public {
524     // the values (mega, large, medium, small) are multiples, e.g., 20x, 100x, 10000x
525     // the rates (megaRate, etc.) are percentage points, e.g., 150 is 150% of the remaining etherPool
526     if (mega2 > 0 && megaRate2 > 0) {
527       mega = mega2;
528       megaRate = megaRate2;
529     }
530 
531     if (large2 > 0 && largeRate2 > 0) {
532       large = large2;
533       largeRate = largeRate2;
534     }
535 
536     if (medium2 > 0 && mediumRate2 > 0) {
537       medium = medium2;
538       mediumRate = mediumRate2;
539     }
540 
541     if (small2 > 0 && smallRate2 > 0){
542       small = small2;
543       smallRate = smallRate2;
544     }
545 
546     if (microRate2 > 0) {
547       microRate = microRate2;
548     }
549   }
550 
551   /**
552    * adjust tranche for next cycle
553    */
554   function adjustNextTranche (uint8 numerator, uint8 denominator) onlyOwner public {
555     require(numerator > 0 && denominator > 0);
556     trancheNumerator = numerator;
557     trancheDenominator = denominator;
558   }
559 
560   function adjustTranche(uint256 tranche2) onlyOwner public {
561     require(tranche2 > 0);
562     tranche = tranche2;
563   }
564 
565   /**
566    * Adjust rewards for `_address`
567    */
568   function updatePlayerRewards(address _address) internal {
569     require(_address != address(0));
570 
571     uint256 _reward = 0;
572     if (rewards[_address] == 0) {
573       _reward = rewardAmount;
574     } else if (rewards[_address] < tranche) {
575       _reward = trueBuy[_address] * rewardNumerator / rewardDenominator;
576     }
577 
578     if (_reward > 0) {
579       // update rewards record
580       rewards[_address] = tranche;
581 
582       balances[_address] += _reward;
583       allowed[_address][msg.sender] += _reward; // set allowance
584 
585       totalSupply += _reward;
586       outstandingQuarters += _reward;
587 
588       uint256 spentETH = (_reward * (10 ** 18)) / ethRate;
589       if (reserveETH >= spentETH) {
590           reserveETH -= spentETH;
591         } else {
592           reserveETH = 0;
593         }
594 
595       // tranche size change
596       _changeTrancheIfNeeded();
597 
598       emit Approval(_address, msg.sender, _reward);
599       emit Reward(_address, _reward, outstandingQuarters, totalSupply);
600     }
601   }
602 
603   /**
604    * Developer status
605    */
606   function setDeveloperStatus (address _address, bool status) onlyOwner public {
607     developers[_address] = status;
608     emit DeveloperStatusChanged(_address, status);
609   }
610 
611   /**
612    * Set allowance for other address and notify
613    *
614    * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
615    *
616    * @param _spender The address authorized to spend
617    * @param _value the max amount they can spend
618    * @param _extraData some extra information to send to the approved contract
619    */
620   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
621   public
622   returns (bool success) {
623     TokenRecipient spender = TokenRecipient(_spender);
624     if (approve(_spender, _value)) {
625       spender.receiveApproval(msg.sender, _value, this, _extraData);
626       return true;
627     }
628 
629     return false;
630   }
631 
632   /**
633    * Destroy tokens
634    *
635    * Remove `_value` tokens from the system irreversibly
636    *
637    * @param _value the amount of money to burn
638    */
639   function burn(uint256 _value) public returns (bool success) {
640     require(balances[msg.sender] >= _value);   // Check if the sender has enough
641     balances[msg.sender] -= _value;            // Subtract from the sender
642     totalSupply -= _value;                     // Updates totalSupply
643     outstandingQuarters -= _value;              // Update outstanding quarters
644     emit Burn(msg.sender, _value);
645 
646     // log rate change
647     emit BaseRateChanged(getBaseRate(), tranche, outstandingQuarters, address(this).balance, totalSupply);
648     return true;
649   }
650 
651   /**
652    * Destroy tokens from other account
653    *
654    * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
655    *
656    * @param _from the address of the sender
657    * @param _value the amount of money to burn
658    */
659   function burnFrom(address _from, uint256 _value) public returns (bool success) {
660     require(balances[_from] >= _value);                // Check if the targeted balance is enough
661     require(_value <= allowed[_from][msg.sender]);     // Check allowance
662     balances[_from] -= _value;                         // Subtract from the targeted balance
663     allowed[_from][msg.sender] -= _value;              // Subtract from the sender's allowance
664     totalSupply -= _value;                      // Update totalSupply
665     outstandingQuarters -= _value;              // Update outstanding quarters
666     emit Burn(_from, _value);
667 
668     // log rate change
669     emit BaseRateChanged(getBaseRate(), tranche, outstandingQuarters, address(this).balance, totalSupply);
670     return true;
671   }
672 
673   /**
674    * Buy quarters by sending ethers to contract address (no data required)
675    */
676   function () payable public {
677     _buy(msg.sender);
678   }
679 
680 
681   function buy() payable public {
682     _buy(msg.sender);
683   }
684 
685   function buyFor(address buyer) payable public {
686     uint256 _value =  _buy(buyer);
687 
688     // allow donor (msg.sender) to spend buyer's tokens
689     allowed[buyer][msg.sender] += _value;
690     emit Approval(buyer, msg.sender, _value);
691   }
692 
693   function _changeTrancheIfNeeded() internal {
694     if (totalSupply >= tranche) {
695       // change tranche size for next cycle
696       tranche = (tranche * trancheNumerator) / trancheDenominator;
697 
698       // fire event for tranche change
699       emit TrancheIncreased(tranche, address(this).balance, outstandingQuarters);
700     }
701   }
702 
703   // returns number of quarters buyer got
704   function _buy(address buyer) internal returns (uint256) {
705     require(buyer != address(0));
706 
707     uint256 nq = (msg.value * ethRate) / (10 ** 18);
708     require(nq != 0);
709     if (nq > tranche) {
710       nq = tranche;
711     }
712 
713     totalSupply += nq;
714     balances[buyer] += nq;
715     trueBuy[buyer] += nq;
716     outstandingQuarters += nq;
717 
718     // change tranche size
719     _changeTrancheIfNeeded();
720 
721     // event for quarters order (invoice)
722     emit QuartersOrdered(buyer, msg.value, nq);
723 
724     // log rate change
725     emit BaseRateChanged(getBaseRate(), tranche, outstandingQuarters, address(this).balance, totalSupply);
726 
727     // transfer owner's cut
728     Q2(q2).disburse.value(msg.value * 15 / 100)();
729 
730     // return nq
731     return nq;
732   }
733 
734   /**
735    * Transfer allowance from other address's allowance
736    *
737    * Send `_value` tokens to `_to` in behalf of `_from`
738    *
739    * @param _from The address of the sender
740    * @param _to The address of the recipient
741    * @param _value the amount to send
742    */
743   function transferAllowance(address _from, address _to, uint256 _value) public returns (bool success) {
744     updatePlayerRewards(_from);
745     require(_value <= allowed[_from][msg.sender]);     // Check allowance
746     allowed[_from][msg.sender] -= _value;
747 
748     if (_transfer(_from, _to, _value)) {
749       // allow msg.sender to spend _to's tokens
750       allowed[_to][msg.sender] += _value;
751       emit Approval(_to, msg.sender, _value);
752       return true;
753     }
754 
755     return false;
756   }
757 
758   function withdraw(uint256 value) onlyActiveDeveloper public {
759     require(balances[msg.sender] >= value);
760 
761     uint256 baseRate = getBaseRate();
762     require(baseRate > 0); // check if base rate > 0
763 
764     uint256 earnings = value * baseRate;
765     uint256 rate = getRate(value); // get rate from value and tranche
766     uint256 earningsWithBonus = (rate * earnings) / 100;
767     if (earningsWithBonus > address(this).balance) {
768       earnings = address(this).balance;
769     } else {
770       earnings = earningsWithBonus;
771     }
772 
773     balances[msg.sender] -= value;
774     outstandingQuarters -= value; // update the outstanding Quarters
775 
776     uint256 etherPool = address(this).balance - earnings;
777     if (rate == megaRate) {
778       emit MegaEarnings(msg.sender, earnings, baseRate, tranche, outstandingQuarters, etherPool); // with current base rate
779     }
780 
781     // event for withdraw
782     emit Withdraw(msg.sender, earnings, baseRate, tranche, outstandingQuarters, etherPool);  // with current base rate
783 
784     // log rate change
785     emit BaseRateChanged(getBaseRate(), tranche, outstandingQuarters, address(this).balance, totalSupply);
786 
787     // earning for developers
788     msg.sender.transfer(earnings);  
789 }
790 
791   function disburse() public payable {
792     reserveETH += msg.value;
793   }
794 
795   function getBaseRate () view public returns (uint256) {
796     if (outstandingQuarters > 0) {
797       return (address(this).balance - reserveETH) / outstandingQuarters;
798     }
799 
800     return (address(this).balance - reserveETH);
801   }
802 
803   function getRate (uint256 value) view public returns (uint32) {
804     if (value * mega > tranche) {  // size & rate for mega developer
805       return megaRate;
806     } else if (value * large > tranche) {   // size & rate for large developer
807       return largeRate;
808     } else if (value * medium > tranche) {  // size and rate for medium developer
809       return mediumRate;
810     } else if (value * small > tranche){  // size and rate for small developer
811       return smallRate;
812     }
813 
814     return microRate; // rate for micro developer
815   }
816 
817 
818   //
819   // Migrations
820   //
821 
822   // Target contract
823   address public migrationTarget;
824   bool public migrating = false;
825 
826   // Migrate event
827   event Migrate(address indexed _from, uint256 _value);
828 
829   //
830   // Migrate tokens to the new token contract.
831   //
832   function migrate() public {
833     require(migrationTarget != address(0));
834     uint256 _amount = balances[msg.sender];
835     require(_amount > 0);
836     balances[msg.sender] = 0;
837 
838     totalSupply = totalSupply - _amount;
839     outstandingQuarters = outstandingQuarters - _amount;
840 
841     rewards[msg.sender] = 0;
842     trueBuy[msg.sender] = 0;
843     developers[msg.sender] = false;
844 
845     emit Migrate(msg.sender, _amount);
846     MigrationTarget(migrationTarget).migrateFrom(msg.sender, _amount, rewards[msg.sender], trueBuy[msg.sender], developers[msg.sender]);
847   }
848 
849   //
850   // Set address of migration target contract
851   // @param _target The address of the MigrationTarget contract
852   //
853   function setMigrationTarget(address _target) onlyOwner public {
854     migrationTarget = _target;
855   }
856 }