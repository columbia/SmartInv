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
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
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
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
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
79   function () public payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
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
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract CappedCrowdsale is Crowdsale {
124   using SafeMath for uint256;
125 
126   uint256 public cap;
127 
128   function CappedCrowdsale(uint256 _cap) public {
129     require(_cap > 0);
130     cap = _cap;
131   }
132 
133   // overriding Crowdsale#validPurchase to add extra cap logic
134   // @return true if investors can buy at the moment
135   function validPurchase() internal constant returns (bool) {
136     bool withinCap = weiRaised.add(msg.value) <= cap;
137     return super.validPurchase() && withinCap;
138   }
139 
140   // overriding Crowdsale#hasEnded to add cap logic
141   // @return true if crowdsale event has ended
142   function hasEnded() public constant returns (bool) {
143     bool capReached = weiRaised >= cap;
144     return super.hasEnded() || capReached;
145   }
146 
147 }
148 
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner public {
179     require(newOwner != address(0));
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 
186 contract WhiteListCrowdsale is
187   CappedCrowdsale,
188   Ownable
189 {
190 
191   /**
192    * @dev Rate of bonus tokens received by investors during the whitelist period of the crowdsale.
193    */
194   uint8 public constant WHITELIST_BONUS_RATE = 10;
195 
196   /**
197    * @dev Rate of bonus tokens received by a referring investor,
198    * expressed as % of total bonus tokens issued for the purchase.
199    */
200   uint8 public constant REFERRAL_SHARE_RATE = 50;
201 
202   /**
203    * @dev Timestamp until which it is possible to add an investor to the whitelist.
204    */
205   uint256 public whiteListRegistrationEndTime;
206 
207   /**
208    * @dev Timestamp after which anyone can participate in the crowdsale.
209    */
210   uint256 public whiteListEndTime;
211 
212   /**
213    * @dev Whitelisted addresses.
214    */
215   mapping(address => bool) public isWhiteListed;
216 
217   /**
218    * @dev Referral codes associated to their referring addresses.
219    */
220   mapping(bytes32 => address) internal referralCodes;
221 
222   /**
223    * @dev Maps referred investors to their referrers (referred => referring).
224    */
225   mapping(address => address) internal referrals;
226 
227   /**
228    * @dev Event fired when an address is added to the whitelist.
229    * @param investor whitelisted investor
230    * @param referralCode referral code of the whitelisted investor
231    */
232   event WhiteListedInvestorAdded(
233     address indexed investor,
234     string referralCode
235   );
236 
237   /**
238    * event for bonus token emmited
239    * @param referralCode referral code of the whitelisted investor
240    * @param referredInvestor address of the referred investor
241    */
242   event ReferredInvestorAdded(
243     string referralCode,
244     address referredInvestor
245   );
246 
247   /**
248    * @dev Event fired when bonus tokens are emitted for referred purchases.
249    * @param beneficiary who got the tokens
250    * @param amount bonus tokens issued
251    */
252   event ReferredBonusTokensEmitted(
253     address indexed beneficiary,
254     uint256 amount
255   );
256 
257   /**
258    * @dev Event fired when bonus tokens are emitted for whitelist or referred purchases.
259    * @param beneficiary who got the tokens
260    * @param amount bonus tokens issued
261    */
262   event WhiteListBonusTokensEmitted(
263     address indexed beneficiary,
264     uint256 amount
265   );
266 
267   /**
268    * @dev WhiteListCrowdsale construction.
269    * @param _whiteListRegistrationEndTime time until which white list registration is still possible
270    * @param _whiteListEndTime time until which only white list purchases are accepted
271    */
272   function WhiteListCrowdsale(uint256 _whiteListRegistrationEndTime, uint256 _whiteListEndTime) public {
273     require(_whiteListEndTime > startTime);
274 
275     whiteListEndTime = _whiteListEndTime;
276     whiteListRegistrationEndTime = _whiteListRegistrationEndTime;
277   }
278 
279   /**
280    * @dev Overriding Crowdsale#buyTokens to add extra whitelist and referral logic.
281    * @param _beneficiary address that is buying tokens.
282    */
283   function buyTokens(address _beneficiary) public payable
284   {
285     require(validWhiteListedPurchase(_beneficiary));
286 
287     // Buys tokens and transfers them to _beneficiary.
288     super.buyTokens(_beneficiary);
289     
290     uint256 bonusTokens = computeBonusTokens(_beneficiary, msg.value);
291     if (isReferred(_beneficiary))
292     {
293       uint256 bonusTokensForReferral = bonusTokens.mul(REFERRAL_SHARE_RATE).div(100);
294       uint256 bonusTokensForReferred = bonusTokens.sub(bonusTokensForReferral);
295       token.mint(_beneficiary, bonusTokensForReferred);
296       token.mint(referrals[_beneficiary], bonusTokensForReferral);
297       ReferredBonusTokensEmitted(_beneficiary, bonusTokensForReferred);
298       WhiteListBonusTokensEmitted(referrals[_beneficiary], bonusTokensForReferral);
299     }
300     else if (isWhiteListed[_beneficiary])
301     {
302       token.mint(_beneficiary, bonusTokens);
303       WhiteListBonusTokensEmitted(_beneficiary, bonusTokens);
304     }
305   }
306 
307   /**
308    * @dev Adds an investor to the whitelist if registration is open. Fails otherwise.
309    * @param _investor whitelisted investor
310    * @param _referralCode investor's referral code
311    */
312   function addWhiteListedInvestor(address _investor, string _referralCode) public
313   {
314     require(block.timestamp <= whiteListRegistrationEndTime);
315     require(_investor != 0);
316     require(!isWhiteListed[_investor]);
317     bytes32 referralCodeHash = keccak256(_referralCode);
318     require(referralCodes[referralCodeHash] == 0x0);
319     
320     isWhiteListed[_investor] = true;
321     referralCodes[referralCodeHash] = _investor;
322     WhiteListedInvestorAdded(_investor, _referralCode);
323   }
324 
325   /**
326    * @dev Adds up to 30 whitelisted investors. To be called one or more times
327    * for initial whitelist loading.
328    * @param _investors whitelisted investors.
329    * @param _referralCodes keccak-256 hashes of corresponding investor referral codes.
330    */
331   function loadWhiteList(address[] _investors, bytes32[] _referralCodes) public onlyOwner
332   {
333     require(_investors.length <= 30);
334     require(_investors.length == _referralCodes.length);
335 
336     for (uint i = 0; i < _investors.length; i++)
337     {
338       isWhiteListed[_investors[i]] = true;
339       referralCodes[_referralCodes[i]] = _investors[i];
340     }
341   }
342 
343   /**
344    * @dev Adds a referred investor to the second-level whitelist.
345    * @param _referredInvestor whitelisted investor.
346    * @param _referralCode investor's referral code.
347    */
348   function addReferredInvestor(string _referralCode, address _referredInvestor) public
349   {
350     require(!hasEnded());
351     require(!isWhiteListed[_referredInvestor]);
352     require(_referredInvestor != 0);
353     require(referrals[_referredInvestor] == 0x0);
354     bytes32 referralCodeHash = keccak256(_referralCode);
355     require(referralCodes[referralCodeHash] != 0);
356 
357     referrals[_referredInvestor] = referralCodes[referralCodeHash];
358     ReferredInvestorAdded(_referralCode, _referredInvestor);
359   }
360 
361   /**
362    * @dev Adds up to 30 referred investors. To be called one or more times
363    * for initial referred list loading.
364    * @param _referralCodes keccak-256 hashes of referral codes.
365    * @param _investors corresponding referred investors.
366    */
367   function loadReferredInvestors(bytes32[] _referralCodes, address[] _investors) public onlyOwner
368   {
369     require(_investors.length <= 30);
370     require(_investors.length == _referralCodes.length);
371 
372     for (uint i = 0; i < _investors.length; i++)
373     {
374       referrals[_investors[i]] = referralCodes[_referralCodes[i]];
375     }
376   }
377 
378   /**
379    * @dev Returns true if _investor is a referred investor.
380    * @param _investor address to check against the list of referred investors.
381    */
382   function isReferred(address _investor) public constant returns (bool)
383   {
384     return referrals[_investor] != 0x0;
385   }
386 
387   /**
388    * @dev Returns true if _investor is a whitelisted or referred investor,
389    * or the whitelist period has ended (and the crowdsale hasn't) and everyone can buy.
390    * @param _investor investor who is making the purchase.
391    */
392   function validWhiteListedPurchase(address _investor) internal constant returns (bool)
393   {
394     return isWhiteListed[_investor] || isReferred(_investor) || block.timestamp > whiteListEndTime;
395   }
396 
397   /**
398    * @dev Returns the number of bonus tokens for a whitelisted or referred purchase.
399    * Returns zero if the purchase is not from a whitelisted or referred investor.
400    * @param _weiAmount purchase amount.
401    */
402   function computeBonusTokens(address _beneficiary, uint256 _weiAmount) internal constant returns (uint256)
403   {
404     if (isReferred(_beneficiary) || isWhiteListed[_beneficiary]) {
405       uint256 bonusTokens = _weiAmount.mul(rate).mul(WHITELIST_BONUS_RATE).div(100);
406       if (block.timestamp > whiteListEndTime) {
407         bonusTokens = bonusTokens.div(2);
408       }
409       return bonusTokens;
410     }
411     else
412     {
413       return 0;
414     }
415   }
416 
417 }
418 
419 contract FinalizableCrowdsale is Crowdsale, Ownable {
420   using SafeMath for uint256;
421 
422   bool public isFinalized = false;
423 
424   event Finalized();
425 
426   /**
427    * @dev Must be called after crowdsale ends, to do some extra finalization
428    * work. Calls the contract's finalization function.
429    */
430   function finalize() onlyOwner public {
431     require(!isFinalized);
432     require(hasEnded());
433 
434     finalization();
435     Finalized();
436 
437     isFinalized = true;
438   }
439 
440   /**
441    * @dev Can be overridden to add finalization logic. The overriding function
442    * should call super.finalization() to ensure the chain of finalization is
443    * executed entirely.
444    */
445   function finalization() internal {
446   }
447 }
448 
449 contract RefundVault is Ownable {
450   using SafeMath for uint256;
451 
452   enum State { Active, Refunding, Closed }
453 
454   mapping (address => uint256) public deposited;
455   address public wallet;
456   State public state;
457 
458   event Closed();
459   event RefundsEnabled();
460   event Refunded(address indexed beneficiary, uint256 weiAmount);
461 
462   function RefundVault(address _wallet) public {
463     require(_wallet != 0x0);
464     wallet = _wallet;
465     state = State.Active;
466   }
467 
468   function deposit(address investor) onlyOwner public payable {
469     require(state == State.Active);
470     deposited[investor] = deposited[investor].add(msg.value);
471   }
472 
473   function close() onlyOwner public {
474     require(state == State.Active);
475     state = State.Closed;
476     Closed();
477     wallet.transfer(this.balance);
478   }
479 
480   function enableRefunds() onlyOwner public {
481     require(state == State.Active);
482     state = State.Refunding;
483     RefundsEnabled();
484   }
485 
486   function refund(address investor) public {
487     require(state == State.Refunding);
488     uint256 depositedValue = deposited[investor];
489     deposited[investor] = 0;
490     investor.transfer(depositedValue);
491     Refunded(investor, depositedValue);
492   }
493 }
494 
495 contract RefundableCrowdsale is FinalizableCrowdsale {
496   using SafeMath for uint256;
497 
498   // minimum amount of funds to be raised in weis
499   uint256 public goal;
500 
501   // refund vault used to hold funds while crowdsale is running
502   RefundVault public vault;
503 
504   function RefundableCrowdsale(uint256 _goal) public {
505     require(_goal > 0);
506     vault = new RefundVault(wallet);
507     goal = _goal;
508   }
509 
510   // We're overriding the fund forwarding from Crowdsale.
511   // In addition to sending the funds, we want to call
512   // the RefundVault deposit function
513   function forwardFunds() internal {
514     vault.deposit.value(msg.value)(msg.sender);
515   }
516 
517   // if crowdsale is unsuccessful, investors can claim refunds here
518   function claimRefund() public {
519     require(isFinalized);
520     require(!goalReached());
521 
522     vault.refund(msg.sender);
523   }
524 
525   // vault finalization task, called when owner calls finalize()
526   function finalization() internal {
527     if (goalReached()) {
528       vault.close();
529     } else {
530       vault.enableRefunds();
531     }
532 
533     super.finalization();
534   }
535 
536   function goalReached() public constant returns (bool) {
537     return weiRaised >= goal;
538   }
539 
540 }
541 
542 contract Destructible is Ownable {
543 
544   function Destructible() public payable { }
545 
546   /**
547    * @dev Transfers the current balance to the owner and terminates the contract.
548    */
549   function destroy() onlyOwner public {
550     selfdestruct(owner);
551   }
552 
553   function destroyAndSend(address _recipient) onlyOwner public {
554     selfdestruct(_recipient);
555   }
556 }
557 
558 contract Pausable is Ownable {
559   event Pause();
560   event Unpause();
561 
562   bool public paused = false;
563 
564 
565   /**
566    * @dev Modifier to make a function callable only when the contract is not paused.
567    */
568   modifier whenNotPaused() {
569     require(!paused);
570     _;
571   }
572 
573   /**
574    * @dev Modifier to make a function callable only when the contract is paused.
575    */
576   modifier whenPaused() {
577     require(paused);
578     _;
579   }
580 
581   /**
582    * @dev called by the owner to pause, triggers stopped state
583    */
584   function pause() onlyOwner whenNotPaused public {
585     paused = true;
586     Pause();
587   }
588 
589   /**
590    * @dev called by the owner to unpause, returns to normal state
591    */
592   function unpause() onlyOwner whenPaused public {
593     paused = false;
594     Unpause();
595   }
596 }
597 
598 contract DemeterCrowdsale is
599   RefundableCrowdsale,
600   WhiteListCrowdsale,
601   Pausable,
602   Destructible
603 {
604 
605   /**
606    * @dev Each time an investor purchases, he gets this % of the minted tokens
607    * (plus bonus if applicable), while the company gets 70% (minus bonus).
608    */
609   uint8 constant public PERC_TOKENS_TO_INVESTOR = 30;
610 
611   /**
612    * @dev Portion of total tokens reserved for future token releases.
613    * Documentation-only. Unused in code, as the release part is calculated by subtraction.
614    */
615   uint8 constant public PERC_TOKENS_TO_RELEASE = 25;
616 
617   /**
618    * @dev Address to which the release tokens are credited.
619    */
620   address constant public RELEASE_WALLET = 0x867D85437d27cA97e1EB574250efbba487aca637;
621 
622   /**
623    * Portion of total tokens reserved for dev. team.
624    */
625   uint8 constant public PERC_TOKENS_TO_DEV = 20;
626 
627   /**
628    * @dev Address to which the dev. tokens are credited.
629    */
630   address constant public DEV_WALLET = 0x70323222694584c68BD5a29194bb72c248e715F7;
631 
632   /**
633    * Portion of total tokens reserved for business dev.
634    */
635   uint8 constant public PERC_TOKENS_TO_BIZDEV = 25;
636 
637   /**
638    * @dev Address to which the business dev. tokens are credited.
639    */
640   address constant public BIZDEV_WALLET = 0xE43053e265F04f690021735E02BBA559Cea681D6;
641 
642   /**
643    * @dev Event fired whenever company tokens are issued for a purchase.
644    * @param investor who made the purchase
645    * @param value weis paid for purchase
646    * @param amount amount of tokens minted for the company
647    */
648   event CompanyTokensIssued(
649     address indexed investor,
650     uint256 value,
651     uint256 amount
652   );
653 
654   /**
655    * @dev DemeterCrowdsale construction.
656    * @param _startTime beginning of crowdsale.
657    * @param _endTime end of crowdsale.
658    * @param _whiteListRegistrationEndTime time until which whitelist registration is still possible.
659    * @param _whiteListEndTime time until which only whitelist purchases are accepted.
660    * @param _rate how many tokens per ether in case of no whitelist or referral bonuses.
661    * @param _cap crowdsale hard cap in wei.
662    * @param _goal minimum crowdsale goal in wei; if not reached, causes refunds to be available.
663    * @param _wallet where the raised ethers are transferred in case of successful crowdsale.
664    */
665   function DemeterCrowdsale(
666     uint256 _startTime,
667     uint256 _endTime,
668     uint256 _whiteListRegistrationEndTime,
669     uint256 _whiteListEndTime,
670     uint256 _rate,
671     uint256 _cap,
672     uint256 _goal,
673     address _wallet
674   ) public
675     Crowdsale(_startTime, _endTime, _rate, _wallet)
676     CappedCrowdsale(_cap)
677     RefundableCrowdsale(_goal)
678     WhiteListCrowdsale(_whiteListRegistrationEndTime, _whiteListEndTime)
679   {
680     DemeterToken(token).setUnlockTime(_endTime);
681   }
682 
683   /**
684    * @dev Called when a purchase is made. Override to issue company tokens
685    * in addition to bought and bonus tokens.
686    * @param _beneficiary the investor that buys the tokens.
687    */
688   function buyTokens(address _beneficiary) public payable whenNotPaused {
689     require(msg.value >= 0.1 ether);
690     // buys tokens (including referral or whitelist tokens) and
691     // transfers them to _beneficiary.
692     super.buyTokens(_beneficiary);
693     
694     // mints additional tokens for the company and distributes them to the company wallets.
695     issueCompanyTokens(_beneficiary, msg.value);
696   }
697 
698   /**
699    * @dev Closes the vault, terminates the contract and the token contract as well.
700    * Only allowed while the vault is open (not when refunds are enabled or the vault
701    * is already closed). Balance would be transferred to the owner, but it is
702    * always zero anyway.
703    */
704   function destroy() public onlyOwner {
705     vault.close();
706     super.destroy();
707     DemeterToken(token).destroyAndSend(this);
708   }
709 
710   /**
711    * @dev Closes the vault, terminates the contract and the token contract as well.
712    * Only allowed while the vault is open (not when refunds are enabled or the vault
713    * is already closed). Balance would be transferred to _recipient, but it is
714    * always zero anyway.
715    */
716   function destroyAndSend(address _recipient) public onlyOwner {
717     vault.close();
718     super.destroyAndSend(_recipient);
719     DemeterToken(token).destroyAndSend(_recipient);
720   }
721 
722   /**
723    * @dev Allows the owner to change the minimum goal during the sale.
724    * @param _goal new goal in wei.
725    */
726   function updateGoal(uint256 _goal) public onlyOwner {
727     require(_goal >= 0 && _goal <= cap);
728     require(!hasEnded());
729 
730     goal = _goal;
731   }
732 
733   /**
734    * @dev Mints additional tokens for the company and distributes them to the company wallets.
735    * @param _investor the investor that bought tokens.
736    * @param _weiAmount the amount paid in weis.
737    */
738   function issueCompanyTokens(address _investor, uint256 _weiAmount) internal {
739     uint256 investorTokens = _weiAmount.mul(rate);
740     uint256 bonusTokens = computeBonusTokens(_investor, _weiAmount);
741     uint256 companyTokens = investorTokens.mul(100 - PERC_TOKENS_TO_INVESTOR).div(PERC_TOKENS_TO_INVESTOR);
742     uint256 totalTokens = investorTokens.add(companyTokens);
743     // distribute total tokens among the three wallets.
744     uint256 devTokens = totalTokens.mul(PERC_TOKENS_TO_DEV).div(100);
745     token.mint(DEV_WALLET, devTokens);
746     // We take out bonus tokens from bizDev amount.
747     uint256 bizDevTokens = (totalTokens.mul(PERC_TOKENS_TO_BIZDEV).div(100)).sub(bonusTokens);
748     token.mint(BIZDEV_WALLET, bizDevTokens);
749     uint256 actualCompanyTokens = companyTokens.sub(bonusTokens);
750     uint256 releaseTokens = actualCompanyTokens.sub(bizDevTokens).sub(devTokens);
751     token.mint(RELEASE_WALLET, releaseTokens);
752 
753     CompanyTokensIssued(_investor, _weiAmount, actualCompanyTokens);
754   }
755 
756   /**
757    * @dev Override to create our specific token contract.
758    */
759   function createTokenContract() internal returns (MintableToken) {
760     return new DemeterToken();
761   }
762 
763   /**
764    * Immediately unlocks tokens. To be used in case of early close of the sale.
765    */
766   function unlockTokens() internal {
767     if (DemeterToken(token).unlockTime() > block.timestamp) {
768       DemeterToken(token).setUnlockTime(block.timestamp);
769     }
770   }
771 
772   /**
773    * @dev Unlock the tokens immediately if the sale closes prematurely.
774    */
775   function finalization() internal {
776     super.finalization();
777     unlockTokens();
778   }
779 
780 }
781 
782 contract ERC20Basic {
783   uint256 public totalSupply;
784   function balanceOf(address who) public constant returns (uint256);
785   function transfer(address to, uint256 value) public returns (bool);
786   event Transfer(address indexed from, address indexed to, uint256 value);
787 }
788 
789 contract BasicToken is ERC20Basic {
790   using SafeMath for uint256;
791 
792   mapping(address => uint256) balances;
793 
794   /**
795   * @dev transfer token for a specified address
796   * @param _to The address to transfer to.
797   * @param _value The amount to be transferred.
798   */
799   function transfer(address _to, uint256 _value) public returns (bool) {
800     require(_to != address(0));
801 
802     // SafeMath.sub will throw if there is not enough balance.
803     balances[msg.sender] = balances[msg.sender].sub(_value);
804     balances[_to] = balances[_to].add(_value);
805     Transfer(msg.sender, _to, _value);
806     return true;
807   }
808 
809   /**
810   * @dev Gets the balance of the specified address.
811   * @param _owner The address to query the the balance of.
812   * @return An uint256 representing the amount owned by the passed address.
813   */
814   function balanceOf(address _owner) public constant returns (uint256 balance) {
815     return balances[_owner];
816   }
817 
818 }
819 
820 contract ERC20 is ERC20Basic {
821   function allowance(address owner, address spender) public constant returns (uint256);
822   function transferFrom(address from, address to, uint256 value) public returns (bool);
823   function approve(address spender, uint256 value) public returns (bool);
824   event Approval(address indexed owner, address indexed spender, uint256 value);
825 }
826 
827 contract StandardToken is ERC20, BasicToken {
828 
829   mapping (address => mapping (address => uint256)) allowed;
830 
831 
832   /**
833    * @dev Transfer tokens from one address to another
834    * @param _from address The address which you want to send tokens from
835    * @param _to address The address which you want to transfer to
836    * @param _value uint256 the amount of tokens to be transferred
837    */
838   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
839     require(_to != address(0));
840 
841     uint256 _allowance = allowed[_from][msg.sender];
842 
843     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
844     // require (_value <= _allowance);
845 
846     balances[_from] = balances[_from].sub(_value);
847     balances[_to] = balances[_to].add(_value);
848     allowed[_from][msg.sender] = _allowance.sub(_value);
849     Transfer(_from, _to, _value);
850     return true;
851   }
852 
853   /**
854    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
855    *
856    * Beware that changing an allowance with this method brings the risk that someone may use both the old
857    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
858    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
859    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
860    * @param _spender The address which will spend the funds.
861    * @param _value The amount of tokens to be spent.
862    */
863   function approve(address _spender, uint256 _value) public returns (bool) {
864     allowed[msg.sender][_spender] = _value;
865     Approval(msg.sender, _spender, _value);
866     return true;
867   }
868 
869   /**
870    * @dev Function to check the amount of tokens that an owner allowed to a spender.
871    * @param _owner address The address which owns the funds.
872    * @param _spender address The address which will spend the funds.
873    * @return A uint256 specifying the amount of tokens still available for the spender.
874    */
875   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
876     return allowed[_owner][_spender];
877   }
878 
879   /**
880    * approve should be called when allowed[_spender] == 0. To increment
881    * allowed value is better to use this function to avoid 2 calls (and wait until
882    * the first transaction is mined)
883    * From MonolithDAO Token.sol
884    */
885   function increaseApproval (address _spender, uint _addedValue) public
886     returns (bool success) {
887     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
888     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
889     return true;
890   }
891 
892   function decreaseApproval (address _spender, uint _subtractedValue) public
893     returns (bool success) {
894     uint oldValue = allowed[msg.sender][_spender];
895     if (_subtractedValue > oldValue) {
896       allowed[msg.sender][_spender] = 0;
897     } else {
898       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
899     }
900     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
901     return true;
902   }
903 
904 }
905 
906 contract MintableToken is StandardToken, Ownable {
907   event Mint(address indexed to, uint256 amount);
908   event MintFinished();
909 
910   bool public mintingFinished = false;
911 
912 
913   modifier canMint() {
914     require(!mintingFinished);
915     _;
916   }
917 
918   /**
919    * @dev Function to mint tokens
920    * @param _to The address that will receive the minted tokens.
921    * @param _amount The amount of tokens to mint.
922    * @return A boolean that indicates if the operation was successful.
923    */
924   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
925     totalSupply = totalSupply.add(_amount);
926     balances[_to] = balances[_to].add(_amount);
927     Mint(_to, _amount);
928     Transfer(0x0, _to, _amount);
929     return true;
930   }
931 
932   /**
933    * @dev Function to stop minting new tokens.
934    * @return True if the operation was successful.
935    */
936   function finishMinting() onlyOwner public returns (bool) {
937     mintingFinished = true;
938     MintFinished();
939     return true;
940   }
941 }
942 
943 contract TimeLockedToken is MintableToken
944 {
945 
946   /**
947    * @dev Timestamp after which tokens can be transferred.
948    */
949   uint256 public unlockTime = 0;
950 
951   /**
952    * @dev Checks whether it can transfer or otherwise throws.
953    */
954   modifier canTransfer() {
955     require(unlockTime == 0 || block.timestamp > unlockTime);
956     _;
957   }
958 
959   /**
960    * @dev Sets the date and time since which tokens can be transfered.
961    * It can only be moved back, and not in the past.
962    * @param _unlockTime New unlock timestamp.
963    */
964   function setUnlockTime(uint256 _unlockTime) public onlyOwner {
965     require(unlockTime == 0 || _unlockTime < unlockTime);
966     require(_unlockTime >= block.timestamp);
967 
968     unlockTime = _unlockTime;
969   }
970 
971   /**
972    * @dev Checks modifier and allows transfer if tokens are not locked.
973    * @param _to The address that will recieve the tokens.
974    * @param _value The amount of tokens to be transferred.
975    */
976   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
977     return super.transfer(_to, _value);
978   }
979 
980   /**
981   * @dev Checks modifier and allows transfer if tokens are not locked.
982   * @param _from The address that will send the tokens.
983   * @param _to The address that will recieve the tokens.
984   * @param _value The amount of tokens to be transferred.
985   */
986   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
987     return super.transferFrom(_from, _to, _value);
988   }
989 
990 }
991 
992 contract DemeterToken is TimeLockedToken, Destructible
993 {
994   string public name = "Demeter";
995   string public symbol = "DMT";
996   uint256 public decimals = 18;
997 }