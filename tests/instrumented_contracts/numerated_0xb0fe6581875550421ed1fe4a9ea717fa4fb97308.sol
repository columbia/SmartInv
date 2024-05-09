1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   MintableToken public token;
8 
9   // start and end timestamps where investments are allowed (both inclusive)
10   uint256 public startTime;
11   uint256 public endTime;
12 
13   // address where funds are collected
14   address public wallet;
15 
16   // how many token units a buyer gets per wei
17   uint256 public rate;
18 
19   // amount of raised money in wei
20   uint256 public weiRaised;
21 
22   /**
23    * event for token purchase logging
24    * @param purchaser who paid for the tokens
25    * @param beneficiary who got the tokens
26    * @param value weis paid for purchase
27    * @param amount amount of tokens purchased
28    */
29   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
30 
31 
32   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
33     require(_startTime >= now);
34     require(_endTime >= _startTime);
35     require(_rate > 0);
36     require(_wallet != address(0));
37 
38     token = createTokenContract();
39     startTime = _startTime;
40     endTime = _endTime;
41     rate = _rate;
42     wallet = _wallet;
43   }
44 
45   // fallback function can be used to buy tokens
46   function () external payable {
47     buyTokens(msg.sender);
48   }
49 
50   // low level token purchase function
51   function buyTokens(address beneficiary) public payable {
52     require(beneficiary != address(0));
53     require(validPurchase());
54 
55     uint256 weiAmount = msg.value;
56 
57     // calculate token amount to be created
58     uint256 tokens = getTokenAmount(weiAmount);
59 
60     // update state
61     weiRaised = weiRaised.add(weiAmount);
62 
63     token.mint(beneficiary, tokens);
64     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
65 
66     forwardFunds();
67   }
68 
69   // @return true if crowdsale event has ended
70   function hasEnded() public view returns (bool) {
71     return now > endTime;
72   }
73 
74   // creates the token to be sold.
75   // override this method to have crowdsale of a specific mintable token.
76   function createTokenContract() internal returns (MintableToken) {
77     return new MintableToken();
78   }
79 
80   // Override this method to have a way to add business logic to your crowdsale when buying
81   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
82     return weiAmount.mul(rate);
83   }
84 
85   // send ether to the fund collection wallet
86   // override to create custom fund forwarding mechanisms
87   function forwardFunds() internal {
88     wallet.transfer(msg.value);
89   }
90 
91   // @return true if the transaction can buy tokens
92   function validPurchase() internal view returns (bool) {
93     bool withinPeriod = now >= startTime && now <= endTime;
94     bool nonZeroPurchase = msg.value != 0;
95     return withinPeriod && nonZeroPurchase;
96   }
97 
98 }
99 
100 contract CappedCrowdsale is Crowdsale {
101   using SafeMath for uint256;
102 
103   uint256 public cap;
104 
105   function CappedCrowdsale(uint256 _cap) public {
106     require(_cap > 0);
107     cap = _cap;
108   }
109 
110   // overriding Crowdsale#hasEnded to add cap logic
111   // @return true if crowdsale event has ended
112   function hasEnded() public view returns (bool) {
113     bool capReached = weiRaised >= cap;
114     return capReached || super.hasEnded();
115   }
116 
117   // overriding Crowdsale#validPurchase to add extra cap logic
118   // @return true if investors can buy at the moment
119   function validPurchase() internal view returns (bool) {
120     bool withinCap = weiRaised.add(msg.value) <= cap;
121     return withinCap && super.validPurchase();
122   }
123 
124 }
125 
126 library SafeMath {
127 
128   /**
129   * @dev Multiplies two numbers, throws on overflow.
130   */
131   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132     if (a == 0) {
133       return 0;
134     }
135     uint256 c = a * b;
136     assert(c / a == b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return c;
148   }
149 
150   /**
151   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256) {
162     uint256 c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 contract Ownable {
169   address public owner;
170 
171 
172   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174 
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   function Ownable() public {
180     owner = msg.sender;
181   }
182 
183   /**
184    * @dev Throws if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     require(msg.sender == owner);
188     _;
189   }
190 
191   /**
192    * @dev Allows the current owner to transfer control of the contract to a newOwner.
193    * @param newOwner The address to transfer ownership to.
194    */
195   function transferOwnership(address newOwner) public onlyOwner {
196     require(newOwner != address(0));
197     OwnershipTransferred(owner, newOwner);
198     owner = newOwner;
199   }
200 
201 }
202 
203 contract FinalizableCappedCrowdsale is CappedCrowdsale, Ownable {
204 
205     bool public isFinalized = false;
206     bool public reconciliationDateSet = false;
207     uint public reconciliationDate = 0;
208 
209     event Finalized();
210 
211     /**
212     * @dev Must be called after crowdsale ends, to do some extra finalization
213     * work. Calls the contract's finalization function.
214     */
215     function finalize() onlyOwnerOrAfterReconciliation public {
216         require(!isFinalized);
217         require(hasEnded());
218 
219         finalization();
220         Finalized();
221         isFinalized = true;
222     }
223 
224     function setReconciliationDate(uint _reconciliationDate) onlyOwner {
225         reconciliationDate = _reconciliationDate;
226         reconciliationDateSet = true;
227     }
228 
229     /**
230     * @dev Can be overridden to add finalization logic. The overriding function
231     * should call super.finalization() to ensure the chain of finalization is
232     * executed entirely.
233     */
234     function finalization() internal {
235     }
236 
237     modifier onlyOwnerOrAfterReconciliation(){
238         require(msg.sender == owner || (reconciliationDate <= now && reconciliationDateSet));
239         _;
240     }
241 
242 }
243 
244 contract PoolSegregationCrowdsale is Ownable {
245     /**
246     * we include the crowdsale eventhough this is not treated in this contract (zeppelin's CappedCrowdsale )
247     */
248     enum POOLS {POOL_STRATEGIC_INVESTORS, POOL_COMPANY_RESERVE, POOL_USER_ADOPTION, POOL_TEAM, POOL_ADVISORS, POOL_PROMO}
249 
250     using SafeMath for uint;
251 
252     mapping (uint => PoolInfo) poolMap;
253 
254     struct PoolInfo {
255         uint contribution;
256         uint poolCap;
257     }
258 
259     function PoolSegregationCrowdsale(uint _cap) {
260         poolMap[uint(POOLS.POOL_STRATEGIC_INVESTORS)] = PoolInfo(0, _cap.mul(285).div(1000));
261         poolMap[uint(POOLS.POOL_COMPANY_RESERVE)] = PoolInfo(0, _cap.mul(10).div(100));
262         poolMap[uint(POOLS.POOL_USER_ADOPTION)] = PoolInfo(0, _cap.mul(20).div(100));
263         poolMap[uint(POOLS.POOL_TEAM)] = PoolInfo(0, _cap.mul(3).div(100));
264         poolMap[uint(POOLS.POOL_ADVISORS)] = PoolInfo(0, _cap.mul(3).div(100));
265         poolMap[uint(POOLS.POOL_PROMO)] = PoolInfo(0, _cap.mul(3).div(100));
266     }
267 
268     modifier onlyIfInPool(uint amount, uint poolId) {
269         PoolInfo poolInfo = poolMap[poolId];
270         require(poolInfo.contribution.add(amount) <= poolInfo.poolCap); 
271         _;
272         poolInfo.contribution = poolInfo.contribution.add(amount);
273     }
274 
275     function transferRemainingTokensToUserAdoptionPool(uint difference) internal {
276         poolMap[uint(POOLS.POOL_USER_ADOPTION)].poolCap = poolMap[uint(POOLS.POOL_USER_ADOPTION)].poolCap.add(difference);
277     }
278 
279     function getPoolCapSize(uint poolId) public view returns(uint) {
280         return poolMap[poolId].poolCap;
281     }
282 
283 }
284 
285 contract LuckCashCrowdsale is FinalizableCappedCrowdsale, PoolSegregationCrowdsale {
286 
287     // whitelist registry contract
288     WhiteListRegistry public whitelistRegistry;
289     using SafeMath for uint;
290     uint constant public CAP = 600000000*1e18;
291     mapping (address => uint) contributions;
292 
293     /**
294    * event for token vest fund launch
295    * @param beneficiary who will get the tokens once they are vested
296    * @param fund vest fund that will received the tokens
297    * @param tokenAmount amount of tokens purchased
298    */
299     event VestedTokensFor(address indexed beneficiary, address fund, uint256 tokenAmount);
300     /**
301     * event for finalize function call at the end of the crowdsale
302     */
303     event Finalized();    
304 
305     /**
306    * event for token minting for private investors
307    * @param beneficiary who will get the tokens once they are vested
308    * @param tokenAmount amount of tokens purchased
309    */
310     event MintedTokensFor(address indexed beneficiary, uint256 tokenAmount);
311 
312     /**
313      * @dev Contract constructor function
314      * @param _startTime The timestamp of the beginning of the crowdsale
315      * @param _endTime Timestamp when the crowdsale will finish
316      * @param _rate The token rate per ETH
317      * Percent value is saved in crowdsalePercent.
318      * @param _wallet Multisig wallet that will hold the crowdsale funds.
319      * @param _whiteListRegistry Address of the whitelist registry contract
320      */
321     function LuckCashCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _whiteListRegistry) public
322     CappedCrowdsale(CAP.mul(325).div(1000))
323     PoolSegregationCrowdsale(CAP)
324     FinalizableCappedCrowdsale()
325     Crowdsale(_startTime, _endTime, _rate, _wallet)
326     {
327         require(_whiteListRegistry != address(0));
328         whitelistRegistry = WhiteListRegistry(_whiteListRegistry);
329         LuckCashToken(token).pause();
330     }
331 
332     /**
333      * @dev Creates LuckCashToken contract. This is called on the Crowdsale contract constructor 
334      */
335     function createTokenContract() internal returns(MintableToken) {
336         return new LuckCashToken(CAP); // 600 million cap
337     }
338 
339     /**
340      * @dev Mintes fresh token for a private investor.
341      * @param beneficiary The beneficiary of the minting
342      * @param amount The total token amount to be minted
343      */
344     function mintTokensFor(address beneficiary, uint256 amount, uint poolId) external onlyOwner onlyIfInPool(amount, poolId) {
345         require(beneficiary != address(0) && amount != 0);
346         // require(now <= endTime);
347 
348         token.mint(beneficiary, amount);
349 
350         MintedTokensFor(beneficiary, amount);
351     }
352 
353     /**
354      * @dev Creates a new contract for a vesting fund that will release funds for the beneficiary every quarter
355      * @param beneficiary The beneficiary of the funds
356      * @param amount The total token amount to be vested
357      * @param quarters The number of quarters over which the funds will vest. Every quarter a sum equal to amount.quarters will be release
358      */
359     function createVestFundFor(address beneficiary, uint256 amount, uint256 quarters, uint poolId) external onlyOwner onlyIfInPool(amount, poolId) {
360         require(beneficiary != address(0) && amount != 0);
361         require(quarters > 0);
362         // require(now <= endTime);
363 
364         VestingFund fund = new VestingFund(beneficiary, endTime, quarters, token); // the vesting period starts when the crowdsale has ended
365         token.mint(fund, amount);
366 
367         VestedTokensFor(beneficiary, fund, amount);
368     }
369 
370     /**
371      * @dev overrides Crowdsale#validPurchase to add whitelist logic
372      * @return true if buyers is able to buy at the moment
373      */
374     function validPurchase() internal view returns(bool) {
375         return super.validPurchase() && canContributeAmount(msg.sender, msg.value);
376     }
377 
378     function transferFromCrowdsaleToUserAdoptionPool() public onlyOwner {
379         require(now > endTime);
380         
381         super.transferRemainingTokensToUserAdoptionPool(super.getTokenAmount(cap) - super.getTokenAmount(weiRaised));
382     }
383     
384     /**
385      * @dev finalizes crowdsale
386      */ 
387     function finalization() internal {
388         token.finishMinting();
389         LuckCashToken(token).unpause();
390 
391         wallet.transfer(this.balance);
392 
393         super.finalization();
394     }
395 
396     /**
397      * @dev overrides Crowdsale#forwardFunds to report of funds transfer and not transfer into the wallet untill the end
398      */
399     function forwardFunds() internal {
400         reportContribution(msg.sender, msg.value);
401     }
402 
403     function canContributeAmount(address _contributor, uint _amount) internal view returns (bool) {
404         uint totalAmount = contributions[_contributor].add(_amount);
405         return whitelistRegistry.isAmountAllowed(_contributor, totalAmount);  
406     }
407 
408     function reportContribution(address _contributor, uint _amount) internal returns (bool) {
409        contributions[_contributor] = contributions[_contributor].add(_amount);
410     }
411 
412 }
413 
414 contract VestingFund is Ownable {
415   using SafeMath for uint256;
416   using SafeERC20 for ERC20Basic;
417 
418   event Released(uint256 amount);
419 
420   // beneficiary of tokens after they are released
421   address public beneficiary;
422   ERC20Basic public token;
423 
424   uint256 public quarters;
425   uint256 public start;
426 
427 
428   uint256 public released;
429 
430   /**
431    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
432    * _beneficiary, tokens are release in an incremental fashion after a quater has passed until _start + _quarters * 3 * months. 
433    * By then all of the balance will have vested.
434    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
435    * @param _quarters number of quarters the vesting will last
436    * @param _token ERC20 token which is being vested
437    */
438   function VestingFund(address _beneficiary, uint256 _start, uint256 _quarters, address _token) public {
439     
440     require(_beneficiary != address(0) && _token != address(0));
441     require(_quarters > 0);
442 
443     beneficiary = _beneficiary;
444     quarters = _quarters;
445     start = _start;
446     token = ERC20Basic(_token);
447   }
448 
449   /**
450    * @notice Transfers vested tokens to beneficiary.
451    */
452   function release() public {
453     uint256 unreleased = releasableAmount();
454     require(unreleased > 0);
455 
456     released = released.add(unreleased);
457     token.safeTransfer(beneficiary, unreleased);
458 
459     Released(unreleased);
460   }
461 
462   /**
463    * @dev Calculates the amount that has already vested but hasn't been released yet.
464    */
465   function releasableAmount() public view returns(uint256) {
466     return vestedAmount().sub(released);
467   }
468 
469   /**
470    * @dev Calculates the amount that has already vested.
471    */
472   function vestedAmount() public view returns(uint256) {
473     uint256 currentBalance = token.balanceOf(this);
474     uint256 totalBalance = currentBalance.add(released);
475 
476     if (now < start) {
477       return 0;
478     }
479 
480     uint256 dT = now.sub(start); // time passed since start
481     uint256 dQuarters = dT.div(90 days); // quarters passed
482 
483     if (dQuarters >= quarters) {
484       return totalBalance; // return everything if vesting period ended
485     } else {
486       return totalBalance.mul(dQuarters).div(quarters); // ammount = total * (quarters passed / total quarters)
487     }
488   }
489 }
490 
491 contract WhiteListRegistry is Ownable {
492 
493     mapping (address => WhiteListInfo) public whitelist;
494     using SafeMath for uint;
495 
496     struct WhiteListInfo {
497         bool whiteListed;
498         uint minCap;
499         uint maxCap;
500     }
501 
502     event AddedToWhiteList(
503         address contributor,
504         uint minCap,
505         uint maxCap
506     );
507 
508     event RemovedFromWhiteList(
509         address _contributor
510     );
511 
512     function addToWhiteList(address _contributor, uint _minCap, uint _maxCap) public onlyOwner {
513         require(_contributor != address(0));
514         whitelist[_contributor] = WhiteListInfo(true, _minCap, _maxCap);
515         AddedToWhiteList(_contributor, _minCap, _maxCap);
516     }
517 
518     function removeFromWhiteList(address _contributor) public onlyOwner {
519         require(_contributor != address(0));
520         delete whitelist[_contributor];
521         RemovedFromWhiteList(_contributor);
522     }
523 
524     function isWhiteListed(address _contributor) public view returns(bool) {
525         return whitelist[_contributor].whiteListed;
526     }
527 
528     function isAmountAllowed(address _contributor, uint _amount) public view returns(bool) {
529        return whitelist[_contributor].maxCap >= _amount && whitelist[_contributor].minCap <= _amount && isWhiteListed(_contributor);
530     }
531 
532 }
533 
534 contract FinalizableCrowdsale is Crowdsale, Ownable {
535   using SafeMath for uint256;
536 
537   bool public isFinalized = false;
538 
539   event Finalized();
540 
541   /**
542    * @dev Must be called after crowdsale ends, to do some extra finalization
543    * work. Calls the contract's finalization function.
544    */
545   function finalize() onlyOwner public {
546     require(!isFinalized);
547     require(hasEnded());
548 
549     finalization();
550     Finalized();
551 
552     isFinalized = true;
553   }
554 
555   /**
556    * @dev Can be overridden to add finalization logic. The overriding function
557    * should call super.finalization() to ensure the chain of finalization is
558    * executed entirely.
559    */
560   function finalization() internal {
561   }
562 }
563 
564 contract Pausable is Ownable {
565   event Pause();
566   event Unpause();
567 
568   bool public paused = false;
569 
570 
571   /**
572    * @dev Modifier to make a function callable only when the contract is not paused.
573    */
574   modifier whenNotPaused() {
575     require(!paused);
576     _;
577   }
578 
579   /**
580    * @dev Modifier to make a function callable only when the contract is paused.
581    */
582   modifier whenPaused() {
583     require(paused);
584     _;
585   }
586 
587   /**
588    * @dev called by the owner to pause, triggers stopped state
589    */
590   function pause() onlyOwner whenNotPaused public {
591     paused = true;
592     Pause();
593   }
594 
595   /**
596    * @dev called by the owner to unpause, returns to normal state
597    */
598   function unpause() onlyOwner whenPaused public {
599     paused = false;
600     Unpause();
601   }
602 }
603 
604 contract ERC20Basic {
605   function totalSupply() public view returns (uint256);
606   function balanceOf(address who) public view returns (uint256);
607   function transfer(address to, uint256 value) public returns (bool);
608   event Transfer(address indexed from, address indexed to, uint256 value);
609 }
610 
611 contract BasicToken is ERC20Basic {
612   using SafeMath for uint256;
613 
614   mapping(address => uint256) balances;
615 
616   uint256 totalSupply_;
617 
618   /**
619   * @dev total number of tokens in existence
620   */
621   function totalSupply() public view returns (uint256) {
622     return totalSupply_;
623   }
624 
625   /**
626   * @dev transfer token for a specified address
627   * @param _to The address to transfer to.
628   * @param _value The amount to be transferred.
629   */
630   function transfer(address _to, uint256 _value) public returns (bool) {
631     require(_to != address(0));
632     require(_value <= balances[msg.sender]);
633 
634     // SafeMath.sub will throw if there is not enough balance.
635     balances[msg.sender] = balances[msg.sender].sub(_value);
636     balances[_to] = balances[_to].add(_value);
637     Transfer(msg.sender, _to, _value);
638     return true;
639   }
640 
641   /**
642   * @dev Gets the balance of the specified address.
643   * @param _owner The address to query the the balance of.
644   * @return An uint256 representing the amount owned by the passed address.
645   */
646   function balanceOf(address _owner) public view returns (uint256 balance) {
647     return balances[_owner];
648   }
649 
650 }
651 
652 contract ERC20 is ERC20Basic {
653   function allowance(address owner, address spender) public view returns (uint256);
654   function transferFrom(address from, address to, uint256 value) public returns (bool);
655   function approve(address spender, uint256 value) public returns (bool);
656   event Approval(address indexed owner, address indexed spender, uint256 value);
657 }
658 
659 library SafeERC20 {
660   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
661     assert(token.transfer(to, value));
662   }
663 
664   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
665     assert(token.transferFrom(from, to, value));
666   }
667 
668   function safeApprove(ERC20 token, address spender, uint256 value) internal {
669     assert(token.approve(spender, value));
670   }
671 }
672 
673 contract StandardToken is ERC20, BasicToken {
674 
675   mapping (address => mapping (address => uint256)) internal allowed;
676 
677 
678   /**
679    * @dev Transfer tokens from one address to another
680    * @param _from address The address which you want to send tokens from
681    * @param _to address The address which you want to transfer to
682    * @param _value uint256 the amount of tokens to be transferred
683    */
684   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
685     require(_to != address(0));
686     require(_value <= balances[_from]);
687     require(_value <= allowed[_from][msg.sender]);
688 
689     balances[_from] = balances[_from].sub(_value);
690     balances[_to] = balances[_to].add(_value);
691     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
692     Transfer(_from, _to, _value);
693     return true;
694   }
695 
696   /**
697    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
698    *
699    * Beware that changing an allowance with this method brings the risk that someone may use both the old
700    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
701    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
702    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
703    * @param _spender The address which will spend the funds.
704    * @param _value The amount of tokens to be spent.
705    */
706   function approve(address _spender, uint256 _value) public returns (bool) {
707     allowed[msg.sender][_spender] = _value;
708     Approval(msg.sender, _spender, _value);
709     return true;
710   }
711 
712   /**
713    * @dev Function to check the amount of tokens that an owner allowed to a spender.
714    * @param _owner address The address which owns the funds.
715    * @param _spender address The address which will spend the funds.
716    * @return A uint256 specifying the amount of tokens still available for the spender.
717    */
718   function allowance(address _owner, address _spender) public view returns (uint256) {
719     return allowed[_owner][_spender];
720   }
721 
722   /**
723    * @dev Increase the amount of tokens that an owner allowed to a spender.
724    *
725    * approve should be called when allowed[_spender] == 0. To increment
726    * allowed value is better to use this function to avoid 2 calls (and wait until
727    * the first transaction is mined)
728    * From MonolithDAO Token.sol
729    * @param _spender The address which will spend the funds.
730    * @param _addedValue The amount of tokens to increase the allowance by.
731    */
732   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
733     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
734     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
735     return true;
736   }
737 
738   /**
739    * @dev Decrease the amount of tokens that an owner allowed to a spender.
740    *
741    * approve should be called when allowed[_spender] == 0. To decrement
742    * allowed value is better to use this function to avoid 2 calls (and wait until
743    * the first transaction is mined)
744    * From MonolithDAO Token.sol
745    * @param _spender The address which will spend the funds.
746    * @param _subtractedValue The amount of tokens to decrease the allowance by.
747    */
748   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
749     uint oldValue = allowed[msg.sender][_spender];
750     if (_subtractedValue > oldValue) {
751       allowed[msg.sender][_spender] = 0;
752     } else {
753       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
754     }
755     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
756     return true;
757   }
758 
759 }
760 
761 contract MintableToken is StandardToken, Ownable {
762   event Mint(address indexed to, uint256 amount);
763   event MintFinished();
764 
765   bool public mintingFinished = false;
766 
767 
768   modifier canMint() {
769     require(!mintingFinished);
770     _;
771   }
772 
773   /**
774    * @dev Function to mint tokens
775    * @param _to The address that will receive the minted tokens.
776    * @param _amount The amount of tokens to mint.
777    * @return A boolean that indicates if the operation was successful.
778    */
779   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
780     totalSupply_ = totalSupply_.add(_amount);
781     balances[_to] = balances[_to].add(_amount);
782     Mint(_to, _amount);
783     Transfer(address(0), _to, _amount);
784     return true;
785   }
786 
787   /**
788    * @dev Function to stop minting new tokens.
789    * @return True if the operation was successful.
790    */
791   function finishMinting() onlyOwner canMint public returns (bool) {
792     mintingFinished = true;
793     MintFinished();
794     return true;
795   }
796 }
797 
798 contract CappedToken is MintableToken {
799 
800   uint256 public cap;
801 
802   function CappedToken(uint256 _cap) public {
803     require(_cap > 0);
804     cap = _cap;
805   }
806 
807   /**
808    * @dev Function to mint tokens
809    * @param _to The address that will receive the minted tokens.
810    * @param _amount The amount of tokens to mint.
811    * @return A boolean that indicates if the operation was successful.
812    */
813   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
814     require(totalSupply_.add(_amount) <= cap);
815 
816     return super.mint(_to, _amount);
817   }
818 
819 }
820 
821 contract PausableToken is StandardToken, Pausable {
822 
823   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
824     return super.transfer(_to, _value);
825   }
826 
827   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
828     return super.transferFrom(_from, _to, _value);
829   }
830 
831   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
832     return super.approve(_spender, _value);
833   }
834 
835   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
836     return super.increaseApproval(_spender, _addedValue);
837   }
838 
839   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
840     return super.decreaseApproval(_spender, _subtractedValue);
841   }
842 }
843 
844 contract LuckCashToken is PausableToken, CappedToken {
845     string public constant name = "LuckCash";
846     string public constant symbol = "LCK";
847     uint8 public constant decimals = 18;
848 
849     function LuckCashToken(uint _cap) public CappedToken(_cap) PausableToken() {
850 
851     }
852 }