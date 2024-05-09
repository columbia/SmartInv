1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract SealTokenSale is Pausable {
121   using SafeMath for uint256;
122 
123   /**
124   * @dev Supporter struct to allow tracking supporters KYC status and referrer address
125   */
126   struct Supporter {
127     bool hasKYC;
128     address referrerAddress;
129   }
130 
131   /**
132   * @dev External Supporter struct to allow tracking reserved amounts by supporter
133   */
134   struct ExternalSupporter {
135     uint256 reservedAmount;
136   }
137 
138   /**
139    * @dev Token Sale States
140    */
141   enum TokenSaleState {Private, Pre, Main, Finished}
142 
143   // Variables
144   mapping(address => Supporter) public supportersMap; // Mapping with all the Token Sale participants (Private excluded)
145   mapping(address => ExternalSupporter) public externalSupportersMap; // Mapping with external supporters
146   SealToken public token; // ERC20 Token contract address
147   address public vaultWallet; // Wallet address to which ETH and Company Reserve Tokens get forwarded
148   address public airdropWallet; // Wallet address to which Unsold Tokens get forwarded
149   address public kycWallet; // Wallet address for the KYC server
150   uint256 public tokensSold; // How many tokens have been sold
151   uint256 public tokensReserved; // How many tokens have been reserved
152   uint256 public maxTxGasPrice; // Maximum transaction gas price allowed for fair-chance transactions
153   TokenSaleState public currentState; // current Sale state
154 
155   uint256 public constant ONE_MILLION = 10 ** 6; // One million for token cap calculation reference
156   uint256 public constant PRE_SALE_TOKEN_CAP = 384 * ONE_MILLION * 10 ** 18; // Maximum amount that can be sold during the Pre Sale period
157   uint256 public constant TOKEN_SALE_CAP = 492 * ONE_MILLION * 10 ** 18; // Maximum amount of tokens that can be sold by this contract
158   uint256 public constant TOTAL_TOKENS_SUPPLY = 1200 * ONE_MILLION * 10 ** 18; // Total supply that will be minted
159   uint256 public constant MIN_ETHER = 0.1 ether; // Minimum ETH Contribution allowed during the crowd sale
160 
161   /* Minimum PreSale Contributions in Ether */
162   uint256 public constant PRE_SALE_MIN_ETHER = 1 ether; // Minimum to get 10% Bonus Tokens
163   uint256 public constant PRE_SALE_15_BONUS_MIN = 60 ether; // Minimum to get 15% Bonus Tokens
164   uint256 public constant PRE_SALE_20_BONUS_MIN = 300 ether; // Minimum to get 20% Bonus Tokens
165   uint256 public constant PRE_SALE_30_BONUS_MIN = 1200 ether; // Minimum to get 30% Bonus Tokens
166 
167   /* Rate */
168   uint256 public tokenBaseRate; // Base rate
169 
170   uint256 public referrerBonusRate; // Referrer Bonus Rate with 2 decimals (250 for 2.5% bonus for example)
171   uint256 public referredBonusRate; // Referred Bonus Rate with 2 decimals (250 for 2.5% bonus for example)
172 
173   /**
174     * @dev Modifier to only allow Owner or KYC Wallet to execute a function
175     */
176   modifier onlyOwnerOrKYCWallet() {
177     require(msg.sender == owner || msg.sender == kycWallet);
178     _;
179   }
180 
181   /**
182   * Event for token purchase logging
183   * @param purchaser The wallet address that bought the tokens
184   * @param value How many Weis were paid for the purchase
185   * @param amount The amount of tokens purchased
186   */
187   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
188 
189   /**
190   * Event for token reservation 
191   * @param wallet The beneficiary wallet address
192   * @param amount The amount of tokens
193   */
194   event TokenReservation(address indexed wallet, uint256 amount);
195 
196   /**
197   * Event for token reservation confirmation
198   * @param wallet The beneficiary wallet address
199   * @param amount The amount of tokens
200   */
201   event TokenReservationConfirmation(address indexed wallet, uint256 amount);
202 
203   /**
204   * Event for token reservation cancellation
205   * @param wallet The beneficiary wallet address
206   * @param amount The amount of tokens
207   */
208   event TokenReservationCancellation(address indexed wallet, uint256 amount);
209 
210   /**
211    * Event for kyc status change logging
212    * @param user User address
213    * @param isApproved KYC approval state
214    */
215   event KYC(address indexed user, bool isApproved);
216 
217   /**
218    * Event for referrer set
219    * @param user User address
220    * @param referrerAddress Referrer address
221    */
222   event ReferrerSet(address indexed user, address indexed referrerAddress);
223 
224   /**
225    * Event for referral bonus incomplete
226    * @param userAddress User address
227    * @param missingAmount Missing Amount
228    */
229   event ReferralBonusIncomplete(address indexed userAddress, uint256 missingAmount);
230 
231   /**
232    * Event for referral bonus minted
233    * @param userAddress User address
234    * @param amount Amount minted
235    */
236   event ReferralBonusMinted(address indexed userAddress, uint256 amount);
237 
238   /**
239    * Constructor
240    * @param _vaultWallet Vault address
241    * @param _airdropWallet Airdrop wallet address
242    * @param _kycWallet KYC address
243    * @param _tokenBaseRate Token Base rate (Tokens/ETH)
244    * @param _referrerBonusRate Referrer Bonus rate (2 decimals, ex 250 for 2.5%)
245    * @param _referredBonusRate Referred Bonus rate (2 decimals, ex 250 for 2.5%)
246    * @param _maxTxGasPrice Maximum gas price allowed when buying tokens
247    */
248   function SealTokenSale(
249     address _vaultWallet,
250     address _airdropWallet,
251     address _kycWallet,
252     uint256 _tokenBaseRate,
253     uint256 _referrerBonusRate,
254     uint256 _referredBonusRate,
255     uint256 _maxTxGasPrice
256   )
257   public
258   {
259     require(_vaultWallet != address(0));
260     require(_airdropWallet != address(0));
261     require(_kycWallet != address(0));
262     require(_tokenBaseRate > 0);
263     require(_referrerBonusRate > 0);
264     require(_referredBonusRate > 0);
265     require(_maxTxGasPrice > 0);
266 
267     vaultWallet = _vaultWallet;
268     airdropWallet = _airdropWallet;
269     kycWallet = _kycWallet;
270     tokenBaseRate = _tokenBaseRate;
271     referrerBonusRate = _referrerBonusRate;
272     referredBonusRate = _referredBonusRate;
273     maxTxGasPrice = _maxTxGasPrice;
274 
275     tokensSold = 0;
276     tokensReserved = 0;
277 
278     token = new SealToken();
279 
280     // init sale state;
281     currentState = TokenSaleState.Private;
282   }
283 
284   /* fallback function can be used to buy tokens */
285   function() public payable {
286     buyTokens();
287   }
288 
289   /* low level token purchase function */
290   function buyTokens() public payable whenNotPaused {
291     // Do not allow if gasprice is bigger than the maximum
292     // This is for fair-chance for all contributors, so no one can
293     // set a too-high transaction price and be able to buy earlier
294     require(tx.gasprice <= maxTxGasPrice);
295 
296     // make sure we're in pre or main sale period
297     require(isPublicTokenSaleRunning());
298 
299     // check if KYC ok
300     require(userHasKYC(msg.sender));
301 
302     // check user is sending enough Wei for the stage's rules
303     require(aboveMinimumPurchase());
304 
305     address sender = msg.sender;
306     uint256 weiAmountSent = msg.value;
307 
308     // calculate token amount
309     uint256 bonusMultiplier = getBonusMultiplier(weiAmountSent);
310     uint256 newTokens = weiAmountSent.mul(tokenBaseRate).mul(bonusMultiplier).div(100);
311 
312     // check totals and mint the tokens
313     checkTotalsAndMintTokens(sender, newTokens, false);
314 
315     // Log Event
316     TokenPurchase(sender, weiAmountSent, newTokens);
317 
318     // forward the funds to the vault wallet
319     vaultWallet.transfer(msg.value);
320   }
321 
322   /**
323   * @dev Reserve Tokens
324   * @param _wallet Destination Address
325   * @param _amount Amount of tokens
326   */
327   function reserveTokens(address _wallet, uint256 _amount) public onlyOwner {
328     // check amount positive
329     require(_amount > 0);
330     // check destination address not null
331     require(_wallet != address(0));
332 
333     // make sure that we're in private sale or presale
334     require(isPrivateSaleRunning() || isPreSaleRunning());
335 
336     // check cap
337     uint256 totalTokensReserved = tokensReserved.add(_amount);
338     require(tokensSold + totalTokensReserved <= PRE_SALE_TOKEN_CAP);
339 
340     // update total reserved
341     tokensReserved = totalTokensReserved;
342 
343     // save user reservation
344     externalSupportersMap[_wallet].reservedAmount = externalSupportersMap[_wallet].reservedAmount.add(_amount);
345 
346     // Log Event
347     TokenReservation(_wallet, _amount);
348   }
349 
350   /**
351   * @dev Confirm Reserved Tokens
352   * @param _wallet Destination Address
353   * @param _amount Amount of tokens
354   */
355   function confirmReservedTokens(address _wallet, uint256 _amount) public onlyOwner {
356     // check amount positive
357     require(_amount > 0);
358     // check destination address not null
359     require(_wallet != address(0));
360 
361     // make sure the sale hasn't ended yet
362     require(!hasEnded());
363 
364     // check amount not more than reserved
365     require(_amount <= externalSupportersMap[_wallet].reservedAmount);
366 
367     // check totals and mint the tokens
368     checkTotalsAndMintTokens(_wallet, _amount, true);
369 
370     // Log Event
371     TokenReservationConfirmation(_wallet, _amount);
372   }
373 
374   /**
375    * @dev Cancel Reserved Tokens
376    * @param _wallet Destination Address
377    * @param _amount Amount of tokens
378    */
379   function cancelReservedTokens(address _wallet, uint256 _amount) public onlyOwner {
380     // check amount positive
381     require(_amount > 0);
382     // check destination address not null
383     require(_wallet != address(0));
384 
385     // make sure the sale hasn't ended yet
386     require(!hasEnded());
387 
388     // check amount not more than reserved
389     require(_amount <= externalSupportersMap[_wallet].reservedAmount);
390 
391     // update total reserved
392     tokensReserved = tokensReserved.sub(_amount);
393 
394     // update user reservation
395     externalSupportersMap[_wallet].reservedAmount = externalSupportersMap[_wallet].reservedAmount.sub(_amount);
396 
397     // Log Event
398     TokenReservationCancellation(_wallet, _amount);
399   }
400 
401   /**
402   * @dev Check totals and Mint tokens
403   * @param _wallet Destination Address
404   * @param _amount Amount of tokens
405   */
406   function checkTotalsAndMintTokens(address _wallet, uint256 _amount, bool _fromReservation) private {
407     // check that we have not yet reached the cap
408     uint256 totalTokensSold = tokensSold.add(_amount);
409 
410     uint256 totalTokensReserved = tokensReserved;
411     if (_fromReservation) {
412       totalTokensReserved = totalTokensReserved.sub(_amount);
413     }
414 
415     if (isMainSaleRunning()) {
416       require(totalTokensSold + totalTokensReserved <= TOKEN_SALE_CAP);
417     } else {
418       require(totalTokensSold + totalTokensReserved <= PRE_SALE_TOKEN_CAP);
419     }
420 
421     // update contract state
422     tokensSold = totalTokensSold;
423 
424     if (_fromReservation) {
425       externalSupportersMap[_wallet].reservedAmount = externalSupportersMap[_wallet].reservedAmount.sub(_amount);
426       tokensReserved = totalTokensReserved;
427     }
428 
429     // mint the tokens
430     token.mint(_wallet, _amount);
431 
432     address userReferrer = getUserReferrer(_wallet);
433 
434     if (userReferrer != address(0)) {
435       // Mint Referrer bonus
436       mintReferralShare(_amount, userReferrer, referrerBonusRate);
437 
438       // Mint Referred bonus
439       mintReferralShare(_amount, _wallet, referredBonusRate);
440     }
441   }
442 
443   /**
444    * @dev Mint Referral Share
445    * @param _amount Amount of tokens
446    * @param _userAddress User Address
447    * @param _bonusRate Bonus rate (2 decimals)
448    */
449   function mintReferralShare(uint256 _amount, address _userAddress, uint256 _bonusRate) private {
450     // calculate max tokens available
451     uint256 currentCap;
452 
453     if (isMainSaleRunning()) {
454       currentCap = TOKEN_SALE_CAP;
455     } else {
456       currentCap = PRE_SALE_TOKEN_CAP;
457     }
458 
459     uint256 maxTokensAvailable = currentCap - tokensSold - tokensReserved;
460 
461     // check if we have enough tokens
462     uint256 fullShare = _amount.mul(_bonusRate).div(10000);
463     if (fullShare <= maxTokensAvailable) {
464       // mint the tokens
465       token.mint(_userAddress, fullShare);
466 
467       // update state
468       tokensSold = tokensSold.add(fullShare);
469 
470       // log event
471       ReferralBonusMinted(_userAddress, fullShare);
472     }
473     else {
474       // mint the available tokens
475       token.mint(_userAddress, maxTokensAvailable);
476 
477       // update state
478       tokensSold = tokensSold.add(maxTokensAvailable);
479 
480       // log events
481 
482       ReferralBonusMinted(_userAddress, maxTokensAvailable);
483       ReferralBonusIncomplete(_userAddress, fullShare - maxTokensAvailable);
484     }
485   }
486 
487   /**
488   * @dev Start Presale
489   */
490   function startPreSale() public onlyOwner {
491     // make sure we're in the private sale state
492     require(currentState == TokenSaleState.Private);
493 
494     // move to presale
495     currentState = TokenSaleState.Pre;
496   }
497 
498   /**
499   * @dev Go back to private sale
500   */
501   function goBackToPrivateSale() public onlyOwner {
502     // make sure we're in the pre sale
503     require(currentState == TokenSaleState.Pre);
504 
505     // go back to private
506     currentState = TokenSaleState.Private;
507   }
508 
509   /**
510   * @dev Start Main sale
511   */
512   function startMainSale() public onlyOwner {
513     // make sure we're in the presale state
514     require(currentState == TokenSaleState.Pre);
515 
516     // move to main sale
517     currentState = TokenSaleState.Main;
518   }
519 
520   /**
521   * @dev Go back to Presale
522   */
523   function goBackToPreSale() public onlyOwner {
524     // make sure we're in the main sale
525     require(currentState == TokenSaleState.Main);
526 
527     // go back to presale
528     currentState = TokenSaleState.Pre;
529   }
530 
531   /**
532   * @dev Ends the operation of the contract
533   */
534   function finishContract() public onlyOwner {
535     // make sure we're in the main sale
536     require(currentState == TokenSaleState.Main);
537 
538     // make sure there are no pending reservations
539     require(tokensReserved == 0);
540 
541     // mark sale as finished
542     currentState = TokenSaleState.Finished;
543 
544     // send the unsold tokens to the airdrop wallet
545     uint256 unsoldTokens = TOKEN_SALE_CAP.sub(tokensSold);
546     token.mint(airdropWallet, unsoldTokens);
547 
548     // send the company reserve tokens to the vault wallet
549     uint256 notForSaleTokens = TOTAL_TOKENS_SUPPLY.sub(TOKEN_SALE_CAP);
550     token.mint(vaultWallet, notForSaleTokens);
551 
552     // finish the minting of the token, so that transfers are allowed
553     token.finishMinting();
554 
555     // transfer ownership of the token contract to the owner,
556     // so it isn't locked to be a child of the crowd sale contract
557     token.transferOwnership(owner);
558   }
559 
560   /**
561   * @dev Updates the maximum allowed gas price that can be used when calling buyTokens()
562   * @param _newMaxTxGasPrice The new maximum gas price
563   */
564   function updateMaxTxGasPrice(uint256 _newMaxTxGasPrice) public onlyOwner {
565     require(_newMaxTxGasPrice > 0);
566     maxTxGasPrice = _newMaxTxGasPrice;
567   }
568 
569   /**
570    * @dev Updates the token baserate
571    * @param _tokenBaseRate The new token baserate in tokens/eth
572    */
573   function updateTokenBaseRate(uint256 _tokenBaseRate) public onlyOwner {
574     require(_tokenBaseRate > 0);
575     tokenBaseRate = _tokenBaseRate;
576   }
577 
578   /**
579    * @dev Updates the Vault Wallet address
580    * @param _vaultWallet The new vault wallet
581    */
582   function updateVaultWallet(address _vaultWallet) public onlyOwner {
583     require(_vaultWallet != address(0));
584     vaultWallet = _vaultWallet;
585   }
586 
587   /**
588    * @dev Updates the KYC Wallet address
589    * @param _kycWallet The new kyc wallet
590    */
591   function updateKYCWallet(address _kycWallet) public onlyOwner {
592     require(_kycWallet != address(0));
593     kycWallet = _kycWallet;
594   }
595 
596   /**
597   * @dev Approve user's KYC
598   * @param _user User Address
599   */
600   function approveUserKYC(address _user) onlyOwnerOrKYCWallet public {
601     require(_user != address(0));
602 
603     Supporter storage sup = supportersMap[_user];
604     sup.hasKYC = true;
605     KYC(_user, true);
606   }
607 
608   /**
609    * @dev Disapprove user's KYC
610    * @param _user User Address
611    */
612   function disapproveUserKYC(address _user) onlyOwnerOrKYCWallet public {
613     require(_user != address(0));
614 
615     Supporter storage sup = supportersMap[_user];
616     sup.hasKYC = false;
617     KYC(_user, false);
618   }
619 
620   /**
621    * @dev Approve user's KYC and sets referrer
622    * @param _user User Address
623    * @param _referrerAddress Referrer Address
624    */
625   function approveUserKYCAndSetReferrer(address _user, address _referrerAddress) onlyOwnerOrKYCWallet public {
626     require(_user != address(0));
627 
628     Supporter storage sup = supportersMap[_user];
629     sup.hasKYC = true;
630     sup.referrerAddress = _referrerAddress;
631 
632     // log events
633     KYC(_user, true);
634     ReferrerSet(_user, _referrerAddress);
635   }
636 
637   /**
638   * @dev check if private sale is running
639   */
640   function isPrivateSaleRunning() public view returns (bool) {
641     return (currentState == TokenSaleState.Private);
642   }
643 
644   /**
645   * @dev check if pre sale or main sale are running
646   */
647   function isPublicTokenSaleRunning() public view returns (bool) {
648     return (isPreSaleRunning() || isMainSaleRunning());
649   }
650 
651   /**
652   * @dev check if pre sale is running
653   */
654   function isPreSaleRunning() public view returns (bool) {
655     return (currentState == TokenSaleState.Pre);
656   }
657 
658   /**
659   * @dev check if main sale is running
660   */
661   function isMainSaleRunning() public view returns (bool) {
662     return (currentState == TokenSaleState.Main);
663   }
664 
665   /**
666   * @dev check if sale has ended
667   */
668   function hasEnded() public view returns (bool) {
669     return (currentState == TokenSaleState.Finished);
670   }
671 
672   /**
673   * @dev Check if user has passed KYC
674   * @param _user User Address
675   */
676   function userHasKYC(address _user) public view returns (bool) {
677     return supportersMap[_user].hasKYC;
678   }
679 
680   /**
681   * @dev Get User's referrer address
682   * @param _user User Address
683   */
684   function getUserReferrer(address _user) public view returns (address) {
685     return supportersMap[_user].referrerAddress;
686   }
687 
688   /**
689   * @dev Get User's reserved amount
690   * @param _user User Address
691   */
692   function getReservedAmount(address _user) public view returns (uint256) {
693     return externalSupportersMap[_user].reservedAmount;
694   }
695 
696   /**
697    * @dev Returns the bonus multiplier to calculate the purchase rate
698    * @param _weiAmount Purchase amount
699    */
700   function getBonusMultiplier(uint256 _weiAmount) internal view returns (uint256) {
701     if (isMainSaleRunning()) {
702       return 100;
703     }
704     else if (isPreSaleRunning()) {
705       if (_weiAmount >= PRE_SALE_30_BONUS_MIN) {
706         // 30% bonus
707         return 130;
708       }
709       else if (_weiAmount >= PRE_SALE_20_BONUS_MIN) {
710         // 20% bonus
711         return 120;
712       }
713       else if (_weiAmount >= PRE_SALE_15_BONUS_MIN) {
714         // 15% bonus
715         return 115;
716       }
717       else if (_weiAmount >= PRE_SALE_MIN_ETHER) {
718         // 10% bonus
719         return 110;
720       }
721       else {
722         // Safeguard but this should never happen as aboveMinimumPurchase checks the minimum
723         revert();
724       }
725     }
726   }
727 
728   /**
729    * @dev Check if the user is buying above the required minimum
730    */
731   function aboveMinimumPurchase() internal view returns (bool) {
732     if (isMainSaleRunning()) {
733       return msg.value >= MIN_ETHER;
734     }
735     else if (isPreSaleRunning()) {
736       return msg.value >= PRE_SALE_MIN_ETHER;
737     } else {
738       return false;
739     }
740   }
741 }
742 
743 contract ERC20Basic {
744   function totalSupply() public view returns (uint256);
745   function balanceOf(address who) public view returns (uint256);
746   function transfer(address to, uint256 value) public returns (bool);
747   event Transfer(address indexed from, address indexed to, uint256 value);
748 }
749 
750 contract BasicToken is ERC20Basic {
751   using SafeMath for uint256;
752 
753   mapping(address => uint256) balances;
754 
755   uint256 totalSupply_;
756 
757   /**
758   * @dev total number of tokens in existence
759   */
760   function totalSupply() public view returns (uint256) {
761     return totalSupply_;
762   }
763 
764   /**
765   * @dev transfer token for a specified address
766   * @param _to The address to transfer to.
767   * @param _value The amount to be transferred.
768   */
769   function transfer(address _to, uint256 _value) public returns (bool) {
770     require(_to != address(0));
771     require(_value <= balances[msg.sender]);
772 
773     // SafeMath.sub will throw if there is not enough balance.
774     balances[msg.sender] = balances[msg.sender].sub(_value);
775     balances[_to] = balances[_to].add(_value);
776     Transfer(msg.sender, _to, _value);
777     return true;
778   }
779 
780   /**
781   * @dev Gets the balance of the specified address.
782   * @param _owner The address to query the the balance of.
783   * @return An uint256 representing the amount owned by the passed address.
784   */
785   function balanceOf(address _owner) public view returns (uint256 balance) {
786     return balances[_owner];
787   }
788 
789 }
790 
791 contract ERC20 is ERC20Basic {
792   function allowance(address owner, address spender) public view returns (uint256);
793   function transferFrom(address from, address to, uint256 value) public returns (bool);
794   function approve(address spender, uint256 value) public returns (bool);
795   event Approval(address indexed owner, address indexed spender, uint256 value);
796 }
797 
798 contract StandardToken is ERC20, BasicToken {
799 
800   mapping (address => mapping (address => uint256)) internal allowed;
801 
802 
803   /**
804    * @dev Transfer tokens from one address to another
805    * @param _from address The address which you want to send tokens from
806    * @param _to address The address which you want to transfer to
807    * @param _value uint256 the amount of tokens to be transferred
808    */
809   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
810     require(_to != address(0));
811     require(_value <= balances[_from]);
812     require(_value <= allowed[_from][msg.sender]);
813 
814     balances[_from] = balances[_from].sub(_value);
815     balances[_to] = balances[_to].add(_value);
816     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
817     Transfer(_from, _to, _value);
818     return true;
819   }
820 
821   /**
822    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
823    *
824    * Beware that changing an allowance with this method brings the risk that someone may use both the old
825    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
826    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
827    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
828    * @param _spender The address which will spend the funds.
829    * @param _value The amount of tokens to be spent.
830    */
831   function approve(address _spender, uint256 _value) public returns (bool) {
832     allowed[msg.sender][_spender] = _value;
833     Approval(msg.sender, _spender, _value);
834     return true;
835   }
836 
837   /**
838    * @dev Function to check the amount of tokens that an owner allowed to a spender.
839    * @param _owner address The address which owns the funds.
840    * @param _spender address The address which will spend the funds.
841    * @return A uint256 specifying the amount of tokens still available for the spender.
842    */
843   function allowance(address _owner, address _spender) public view returns (uint256) {
844     return allowed[_owner][_spender];
845   }
846 
847   /**
848    * @dev Increase the amount of tokens that an owner allowed to a spender.
849    *
850    * approve should be called when allowed[_spender] == 0. To increment
851    * allowed value is better to use this function to avoid 2 calls (and wait until
852    * the first transaction is mined)
853    * From MonolithDAO Token.sol
854    * @param _spender The address which will spend the funds.
855    * @param _addedValue The amount of tokens to increase the allowance by.
856    */
857   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
858     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
859     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
860     return true;
861   }
862 
863   /**
864    * @dev Decrease the amount of tokens that an owner allowed to a spender.
865    *
866    * approve should be called when allowed[_spender] == 0. To decrement
867    * allowed value is better to use this function to avoid 2 calls (and wait until
868    * the first transaction is mined)
869    * From MonolithDAO Token.sol
870    * @param _spender The address which will spend the funds.
871    * @param _subtractedValue The amount of tokens to decrease the allowance by.
872    */
873   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
874     uint oldValue = allowed[msg.sender][_spender];
875     if (_subtractedValue > oldValue) {
876       allowed[msg.sender][_spender] = 0;
877     } else {
878       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
879     }
880     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
881     return true;
882   }
883 
884 }
885 
886 contract MintableToken is StandardToken, Ownable {
887   event Mint(address indexed to, uint256 amount);
888   event MintFinished();
889 
890   bool public mintingFinished = false;
891 
892 
893   modifier canMint() {
894     require(!mintingFinished);
895     _;
896   }
897 
898   /**
899    * @dev Function to mint tokens
900    * @param _to The address that will receive the minted tokens.
901    * @param _amount The amount of tokens to mint.
902    * @return A boolean that indicates if the operation was successful.
903    */
904   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
905     totalSupply_ = totalSupply_.add(_amount);
906     balances[_to] = balances[_to].add(_amount);
907     Mint(_to, _amount);
908     Transfer(address(0), _to, _amount);
909     return true;
910   }
911 
912   /**
913    * @dev Function to stop minting new tokens.
914    * @return True if the operation was successful.
915    */
916   function finishMinting() onlyOwner canMint public returns (bool) {
917     mintingFinished = true;
918     MintFinished();
919     return true;
920   }
921 }
922 
923 contract SealToken is MintableToken {
924     // Constants
925     string public constant name = "SealToken";
926     string public constant symbol = "SEAL";
927     uint8 public constant decimals = 18;
928 
929     /**
930     * @dev Modifier to only allow transfers after the minting has been done
931     */
932     modifier onlyWhenTransferEnabled() {
933         require(mintingFinished);
934         _;
935     }
936 
937     modifier validDestination(address _to) {
938         require(_to != address(0x0));
939         require(_to != address(this));
940         _;
941     }
942 
943     function SealToken() public {
944     }
945 
946     function transferFrom(address _from, address _to, uint256 _value) public        
947         onlyWhenTransferEnabled
948         validDestination(_to)         
949         returns (bool) {
950         return super.transferFrom(_from, _to, _value);
951     }
952 
953     function approve(address _spender, uint256 _value) public
954         onlyWhenTransferEnabled         
955         returns (bool) {
956         return super.approve(_spender, _value);
957     }
958 
959     function increaseApproval (address _spender, uint _addedValue) public
960         onlyWhenTransferEnabled         
961         returns (bool) {
962         return super.increaseApproval(_spender, _addedValue);
963     }
964 
965     function decreaseApproval (address _spender, uint _subtractedValue) public
966         onlyWhenTransferEnabled         
967         returns (bool) {
968         return super.decreaseApproval(_spender, _subtractedValue);
969     }
970 
971     function transfer(address _to, uint256 _value) public
972         onlyWhenTransferEnabled
973         validDestination(_to)         
974         returns (bool) {
975         return super.transfer(_to, _value);
976     }
977 }