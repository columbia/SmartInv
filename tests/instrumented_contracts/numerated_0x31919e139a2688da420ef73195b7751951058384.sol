1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end block where investments are allowed (both inclusive)
36   uint256 public startBlock;
37   uint256 public endBlock;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */ 
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
59     require(_startBlock >= block.number);
60     require(_endBlock >= _startBlock);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startBlock = _startBlock;
66     endBlock = _endBlock;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold. 
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     uint256 current = block.number;
111     bool withinPeriod = current >= startBlock && current <= endBlock;
112     bool nonZeroPurchase = msg.value != 0;
113     return withinPeriod && nonZeroPurchase;
114   }
115 
116   // @return true if crowdsale event has ended
117   function hasEnded() public constant returns (bool) {
118     return block.number > endBlock;
119   }
120 
121 
122 }
123 
124 contract WhiteListCrowdsale is Crowdsale {
125   using SafeMath for uint256;
126 
127   uint256 public whiteListEndBlock;
128   mapping(address => bool) isWhiteListed;
129 
130   event InvestorWhiteListAddition(address investor);
131 
132   function WhiteListCrowdsale(uint256 _whiteListEndBlock) {
133     require(_whiteListEndBlock > startBlock);
134     whiteListEndBlock = _whiteListEndBlock;
135   }
136 
137   function addToWhiteList(address investor) public {
138     require(startBlock > block.number);
139     require(!isWhiteListed[investor]);
140     require(investor != 0);
141 
142     isWhiteListed[investor] = true;
143     InvestorWhiteListAddition(investor);
144   }
145 
146   // overriding Crowdsale#buyTokens to add extra whitelist logic
147   // we did not use validPurchase because we cannot get the beneficiary address
148   function buyTokens(address beneficiary) payable {
149     require(validWhiteListedPurchase(beneficiary));
150     return super.buyTokens(beneficiary);
151   }
152 
153   function validWhiteListedPurchase(address beneficiary) internal constant returns (bool) {
154     return isWhiteListed[beneficiary] || whiteListEndBlock <= block.number;
155   }
156 
157 }
158 
159 contract BonusWhiteListCrowdsale is WhiteListCrowdsale {
160   using SafeMath for uint256;
161 
162   uint256 bonusWhiteListRate;
163 
164   event BonusWhiteList(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
165 
166   function BonusWhiteListCrowdsale(uint256 _bonusWhiteListRate) {
167     require(_bonusWhiteListRate > 0);
168     bonusWhiteListRate = _bonusWhiteListRate;
169   }
170 
171   function buyTokens(address beneficiary) payable {
172     super.buyTokens(beneficiary);
173 
174     if(whiteListEndBlock > block.number && isWhiteListed[beneficiary]){
175       uint256 weiAmount = msg.value;
176       uint256 bonusTokens = weiAmount.mul(rate).mul(bonusWhiteListRate).div(100);
177       token.mint(beneficiary, bonusTokens);
178       BonusWhiteList(msg.sender, beneficiary, weiAmount, bonusTokens);
179     }
180   }
181 
182 }
183 
184 contract ReferedCrowdsale is WhiteListCrowdsale {
185   using SafeMath for uint256;
186 
187   mapping(address => address) referrals;
188 
189   event ReferredInvestorAddition(address whiteListedInvestor, address referredInvestor);
190 
191   function ReferedCrowdsale() {}
192 
193   function addToReferrals(address whiteListedInvestor, address referredInvestor) public {
194     require(isWhiteListed[whiteListedInvestor]);
195     require(!isWhiteListed[referredInvestor]);
196     require(whiteListedInvestor != 0);
197     require(referredInvestor != 0);
198     require(referrals[referredInvestor] == 0x0);
199 
200     referrals[referredInvestor] = whiteListedInvestor;
201     ReferredInvestorAddition(whiteListedInvestor, referredInvestor);
202   }
203 
204   function validWhiteListedPurchase(address beneficiary) internal constant returns (bool) {
205     return super.validWhiteListedPurchase(beneficiary) || referrals[beneficiary] != 0x0;
206   }
207 
208 }
209 
210 contract BonusReferrerCrowdsale is ReferedCrowdsale, BonusWhiteListCrowdsale {
211   using SafeMath for uint256;
212 
213   uint256 bonusReferredRate;
214 
215   event BonusReferred(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
216 
217   function BonusReferrerCrowdsale(uint256 _bonusReferredRate) {
218     require(_bonusReferredRate > 0 && _bonusReferredRate < bonusWhiteListRate);
219     bonusReferredRate = _bonusReferredRate;
220   }
221 
222   function buyTokens(address beneficiary) payable {
223     super.buyTokens(beneficiary);
224 
225     if(whiteListEndBlock > block.number && referrals[beneficiary] != 0x0){
226       uint256 weiAmount = msg.value;
227       uint256 bonusReferrerTokens = weiAmount.mul(rate).mul(bonusWhiteListRate - bonusReferredRate).div(100);
228       uint256 bonusReferredTokens = weiAmount.mul(rate).mul(bonusReferredRate).div(100);
229       token.mint(beneficiary, bonusReferredTokens);
230       token.mint(referrals[beneficiary], bonusReferrerTokens);
231       BonusWhiteList(msg.sender, referrals[beneficiary], weiAmount, bonusReferrerTokens);
232       BonusReferred(msg.sender, beneficiary, weiAmount, bonusReferredTokens);
233     }
234   }
235 
236 }
237 
238 contract PartialOwnershipCrowdsale is BonusReferrerCrowdsale {
239   using SafeMath for uint256;
240 
241   uint256 percentToInvestor;
242 
243   event CompanyTokenIssued(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
244 
245   function PartialOwnershipCrowdsale(uint256 _percentToInvestor) {
246     require(_percentToInvestor != 0);
247     percentToInvestor = _percentToInvestor;
248   }
249 
250   function buyTokens(address beneficiary) payable {
251     super.buyTokens(beneficiary);
252     uint256 weiAmount = msg.value;
253     uint256 investorTokens = weiAmount.mul(rate);
254     uint256 companyTokens = investorTokens.mul(100 - percentToInvestor).div(percentToInvestor);
255     if(whiteListEndBlock > block.number && (referrals[beneficiary] != 0x0 || isWhiteListed[beneficiary])){
256       companyTokens = companyTokens.sub(investorTokens.mul(bonusWhiteListRate).div(100));
257     }
258 
259     token.mint(wallet, companyTokens);
260     CompanyTokenIssued(msg.sender, beneficiary, weiAmount, companyTokens);
261   }
262 
263 }
264 
265 contract CappedCrowdsale is Crowdsale {
266   using SafeMath for uint256;
267 
268   uint256 public cap;
269 
270   function CappedCrowdsale(uint256 _cap) {
271     require(_cap > 0);
272     cap = _cap;
273   }
274 
275   // overriding Crowdsale#validPurchase to add extra cap logic
276   // @return true if investors can buy at the moment
277   function validPurchase() internal constant returns (bool) {
278     bool withinCap = weiRaised.add(msg.value) <= cap;
279     return super.validPurchase() && withinCap;
280   }
281 
282   // overriding Crowdsale#hasEnded to add cap logic
283   // @return true if crowdsale event has ended
284   function hasEnded() public constant returns (bool) {
285     bool capReached = weiRaised >= cap;
286     return super.hasEnded() || capReached;
287   }
288 
289 }
290 
291 contract Ownable {
292   address public owner;
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   function Ownable() {
300     owner = msg.sender;
301   }
302 
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(msg.sender == owner);
309     _;
310   }
311 
312 
313   /**
314    * @dev Allows the current owner to transfer control of the contract to a newOwner.
315    * @param newOwner The address to transfer ownership to.
316    */
317   function transferOwnership(address newOwner) onlyOwner {
318     if (newOwner != address(0)) {
319       owner = newOwner;
320     }
321   }
322 
323 }
324 
325 contract FinalizableCrowdsale is Crowdsale, Ownable {
326   using SafeMath for uint256;
327 
328   bool public isFinalized = false;
329 
330   event Finalized();
331 
332   // should be called after crowdsale ends, to do
333   // some extra finalization work
334   function finalize() onlyOwner {
335     require(!isFinalized);
336     require(hasEnded());
337 
338     finalization();
339     Finalized();
340     
341     isFinalized = true;
342   }
343 
344   // end token minting on finalization
345   // override this with custom logic if needed
346   function finalization() internal {
347     token.finishMinting();
348   }
349 
350 
351 
352 }
353 
354 contract RefundVault is Ownable {
355   using SafeMath for uint256;
356 
357   enum State { Active, Refunding, Closed }
358 
359   mapping (address => uint256) public deposited;
360   address public wallet;
361   State public state;
362 
363   event Closed();
364   event RefundsEnabled();
365   event Refunded(address indexed beneficiary, uint256 weiAmount);
366 
367   function RefundVault(address _wallet) {
368     require(_wallet != 0x0);
369     wallet = _wallet;
370     state = State.Active;
371   }
372 
373   function deposit(address investor) onlyOwner payable {
374     require(state == State.Active);
375     deposited[investor] = deposited[investor].add(msg.value);
376   }
377 
378   function close() onlyOwner {
379     require(state == State.Active);
380     state = State.Closed;
381     Closed();
382     wallet.transfer(this.balance);
383   }
384 
385   function enableRefunds() onlyOwner {
386     require(state == State.Active);
387     state = State.Refunding;
388     RefundsEnabled();
389   }
390 
391   function refund(address investor) {
392     require(state == State.Refunding);
393     uint256 depositedValue = deposited[investor];
394     deposited[investor] = 0;
395     investor.transfer(depositedValue);
396     Refunded(investor, depositedValue);
397   }
398 }
399 
400 contract RefundableCrowdsale is FinalizableCrowdsale {
401   using SafeMath for uint256;
402 
403   // minimum amount of funds to be raised in weis
404   uint256 public goal;
405 
406   // refund vault used to hold funds while crowdsale is running
407   RefundVault public vault;
408 
409   function RefundableCrowdsale(uint256 _goal) {
410     require(_goal > 0);
411     vault = new RefundVault(wallet);
412     goal = _goal;
413   }
414 
415   // We're overriding the fund forwarding from Crowdsale.
416   // In addition to sending the funds, we want to call
417   // the RefundVault deposit function
418   function forwardFunds() internal {
419     vault.deposit.value(msg.value)(msg.sender);
420   }
421 
422   // if crowdsale is unsuccessful, investors can claim refunds here
423   function claimRefund() {
424     require(isFinalized);
425     require(!goalReached());
426 
427     vault.refund(msg.sender);
428   }
429 
430   // vault finalization task, called when owner calls finalize()
431   function finalization() internal {
432     if (goalReached()) {
433       vault.close();
434     } else {
435       vault.enableRefunds();
436     }
437 
438     super.finalization();
439   }
440 
441   function goalReached() public constant returns (bool) {
442     return weiRaised >= goal;
443   }
444 
445 }
446 
447 contract DemeterCrowdsale is
448   Crowdsale,
449   CappedCrowdsale,
450   RefundableCrowdsale,
451   WhiteListCrowdsale,
452   ReferedCrowdsale,
453   BonusWhiteListCrowdsale,
454   BonusReferrerCrowdsale,
455   PartialOwnershipCrowdsale {
456 
457     uint256 endBlock;
458 
459   function DemeterCrowdsale(
460     uint256 _startBlock,
461     uint256 _endBlock,
462     uint256 _rate,
463     address _wallet,
464     uint256 _cap,
465     uint256 _goal,
466     uint256 _whiteListEndBlock,
467     uint256 _bonusWhiteListRate,
468     uint256 _bonusReferredRate,
469     uint256 _percentToInvestor
470   )
471     Crowdsale(_startBlock, _endBlock, _rate, _wallet)
472     CappedCrowdsale(_cap)
473     RefundableCrowdsale(_goal)
474     WhiteListCrowdsale(_whiteListEndBlock)
475     ReferedCrowdsale()
476     BonusWhiteListCrowdsale(_bonusWhiteListRate)
477     BonusReferrerCrowdsale(_bonusReferredRate)
478     PartialOwnershipCrowdsale(_percentToInvestor)
479   {
480     DemeterToken(token).setEndBlock(_endBlock);
481   }
482 
483   // creates the token to be sold.
484   // override this method to have crowdsale of a specific MintableToken token.
485   function createTokenContract() internal returns (MintableToken) {
486     return new DemeterToken();
487   }
488 
489 }
490 
491 contract DemeterCrowdsaleInstance is DemeterCrowdsale {
492 
493   function DemeterCrowdsaleInstance() DemeterCrowdsale(
494     4164989,
495     4176989,
496     1000000000000,
497     0x14f01e00092a5b0dBD43414793541df316363D82,
498     20000000000000000,
499     10000000000000000,
500     4168989,
501     7,
502     3,
503     30
504   ){}
505 
506 }
507 
508 contract ERC20Basic {
509   uint256 public totalSupply;
510   function balanceOf(address who) constant returns (uint256);
511   function transfer(address to, uint256 value) returns (bool);
512   event Transfer(address indexed from, address indexed to, uint256 value);
513 }
514 
515 contract BasicToken is ERC20Basic {
516   using SafeMath for uint256;
517 
518   mapping(address => uint256) balances;
519 
520   /**
521   * @dev transfer token for a specified address
522   * @param _to The address to transfer to.
523   * @param _value The amount to be transferred.
524   */
525   function transfer(address _to, uint256 _value) returns (bool) {
526     balances[msg.sender] = balances[msg.sender].sub(_value);
527     balances[_to] = balances[_to].add(_value);
528     Transfer(msg.sender, _to, _value);
529     return true;
530   }
531 
532   /**
533   * @dev Gets the balance of the specified address.
534   * @param _owner The address to query the the balance of. 
535   * @return An uint256 representing the amount owned by the passed address.
536   */
537   function balanceOf(address _owner) constant returns (uint256 balance) {
538     return balances[_owner];
539   }
540 
541 }
542 
543 contract ERC20 is ERC20Basic {
544   function allowance(address owner, address spender) constant returns (uint256);
545   function transferFrom(address from, address to, uint256 value) returns (bool);
546   function approve(address spender, uint256 value) returns (bool);
547   event Approval(address indexed owner, address indexed spender, uint256 value);
548 }
549 
550 contract TimeBlockedToken is ERC20, Ownable {
551 
552   uint256 endBlock;
553 
554   /**
555    * @dev Checks whether it can transfer or otherwise throws.
556    */
557   modifier canTransfer() {
558     require(block.number > endBlock);
559     _;
560   }
561 
562   function setEndBlock(uint256 _endBlock) onlyOwner {
563     endBlock = _endBlock;
564   }
565 
566   /**
567    * @dev Checks modifier and allows transfer if tokens are not locked.
568    * @param _to The address that will recieve the tokens.
569    * @param _value The amount of tokens to be transferred.
570    */
571   function transfer(address _to, uint256 _value) canTransfer returns (bool) {
572     return super.transfer(_to, _value);
573   }
574 
575   /**
576   * @dev Checks modifier and allows transfer if tokens are not locked.
577   * @param _from The address that will send the tokens.
578   * @param _to The address that will recieve the tokens.
579   * @param _value The amount of tokens to be transferred.
580   */
581   function transferFrom(address _from, address _to, uint256 _value) canTransfer returns (bool) {
582     return super.transferFrom(_from, _to, _value);
583   }
584 }
585 
586 contract StandardToken is ERC20, BasicToken {
587 
588   mapping (address => mapping (address => uint256)) allowed;
589 
590 
591   /**
592    * @dev Transfer tokens from one address to another
593    * @param _from address The address which you want to send tokens from
594    * @param _to address The address which you want to transfer to
595    * @param _value uint256 the amout of tokens to be transfered
596    */
597   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
598     var _allowance = allowed[_from][msg.sender];
599 
600     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
601     // require (_value <= _allowance);
602 
603     balances[_to] = balances[_to].add(_value);
604     balances[_from] = balances[_from].sub(_value);
605     allowed[_from][msg.sender] = _allowance.sub(_value);
606     Transfer(_from, _to, _value);
607     return true;
608   }
609 
610   /**
611    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
612    * @param _spender The address which will spend the funds.
613    * @param _value The amount of tokens to be spent.
614    */
615   function approve(address _spender, uint256 _value) returns (bool) {
616 
617     // To change the approve amount you first have to reduce the addresses`
618     //  allowance to zero by calling `approve(_spender, 0)` if it is not
619     //  already 0 to mitigate the race condition described here:
620     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
621     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
622 
623     allowed[msg.sender][_spender] = _value;
624     Approval(msg.sender, _spender, _value);
625     return true;
626   }
627 
628   /**
629    * @dev Function to check the amount of tokens that an owner allowed to a spender.
630    * @param _owner address The address which owns the funds.
631    * @param _spender address The address which will spend the funds.
632    * @return A uint256 specifing the amount of tokens still avaible for the spender.
633    */
634   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
635     return allowed[_owner][_spender];
636   }
637 
638 }
639 
640 contract MintableToken is StandardToken, Ownable {
641   event Mint(address indexed to, uint256 amount);
642   event MintFinished();
643 
644   bool public mintingFinished = false;
645 
646 
647   modifier canMint() {
648     require(!mintingFinished);
649     _;
650   }
651 
652   /**
653    * @dev Function to mint tokens
654    * @param _to The address that will recieve the minted tokens.
655    * @param _amount The amount of tokens to mint.
656    * @return A boolean that indicates if the operation was successful.
657    */
658   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
659     totalSupply = totalSupply.add(_amount);
660     balances[_to] = balances[_to].add(_amount);
661     Mint(_to, _amount);
662     return true;
663   }
664 
665   /**
666    * @dev Function to stop minting new tokens.
667    * @return True if the operation was successful.
668    */
669   function finishMinting() onlyOwner returns (bool) {
670     mintingFinished = true;
671     MintFinished();
672     return true;
673   }
674 }
675 
676 contract DemeterToken is MintableToken, TimeBlockedToken {
677   string public name = "Demeter";
678   string public symbol = "DMT";
679   uint256 public decimals = 18;
680 }