1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21     }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 interface IERC20 {
56   function totalSupply() external view returns (uint256);
57 
58   function balanceOf(address who) external view returns (uint256);
59 
60   function allowance(address owner, address spender)
61     external view returns (uint256);
62 
63   function transfer(address to, uint256 value) external returns (bool);
64 
65   function approve(address spender, uint256 value)
66     external returns (bool);
67 
68   function transferFrom(address from, address to, uint256 value)
69     external returns (bool);
70 
71   event Transfer(
72     address indexed from,
73     address indexed to,
74     uint256 value
75   );
76 
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 
85 /**
86  * @title SafeERC20
87  * @dev Wrappers around ERC20 operations that throw on failure.
88  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
89  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
90  */
91 library SafeERC20 {
92   function safeTransfer(
93     IERC20 token,
94     address to,
95     uint256 value
96   )
97     internal
98   {
99     require(token.transfer(to, value));
100   }
101 
102   function safeTransferFrom(
103     IERC20 token,
104     address from,
105     address to,
106     uint256 value
107   )
108     internal
109   {
110     require(token.transferFrom(from, to, value));
111   }
112 
113 }
114 
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122   address public owner;
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124   /**
125    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126    * account.
127    */
128  function Ownable() {
129     owner = msg.sender;
130   }
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138   /**
139    * @dev Allows the current owner to transfer control of the contract to a newOwner.
140    * @param newOwner The address to transfer ownership to.
141    */
142   function transferOwnership(address newOwner) onlyOwner public {
143     require(newOwner != address(0));
144     emit OwnershipTransferred(owner, newOwner);
145     owner = newOwner;
146   }
147 }
148 
149 /**
150  * @title Crowdsale
151  * @dev Crowdsale is a base contract for managing a token crowdsale,
152  * allowing investors to purchase tokens with ether. This contract implements
153  * such functionality in its most fundamental form and can be extended to provide additional
154  * functionality and/or custom behavior.
155  * The external interface represents the basic interface for purchasing tokens, and conform
156  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
157  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
158  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
159  * behavior.
160  */
161 contract Crowdsale is Ownable {
162   using SafeMath for uint256;
163   using SafeERC20 for IERC20;
164 
165   // The token being sold
166   IERC20 public _token;
167 
168   // Address where funds are collected
169   address public _wallet;
170 
171   // How many token units a buyer gets per wei.
172   // The rate is the conversion between wei and the smallest and indivisible token unit.
173   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
174   // 1 wei will give you 1 unit, or 0.001 TOK.
175   uint256 public _rate;
176 
177   // Amount of wei raised
178   uint256 public _weiRaised;
179 
180   /**
181    * Event for token purchase logging
182    * @param purchaser who paid for the tokens
183    * @param beneficiary who got the tokens
184    * @param value weis paid for purchase
185    * @param amount amount of tokens purchased
186    */
187   event TokensPurchased(
188     address indexed purchaser,
189     address indexed beneficiary,
190     uint256 value,
191     uint256 amount
192   );
193 
194   /**
195    * @param rate Number of token units a buyer gets per wei
196    * @dev The rate is the conversion between wei and the smallest and indivisible
197    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
198    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
199    * @param wallet Address where collected funds will be forwarded to
200    * @param token Address of the token being sold
201    */
202   constructor(uint256 rate, address wallet, IERC20 token) public {
203     require(rate > 0);
204     require(wallet != address(0));
205     require(token != address(0));
206 
207     _rate = rate;
208     _wallet = wallet;
209     _token = token;
210   }
211 
212   // -----------------------------------------
213   // Crowdsale external interface
214   // -----------------------------------------
215 
216   /**
217    * @dev fallback function ***DO NOT OVERRIDE***
218    */
219   function () external payable {
220     buyTokens(msg.sender);
221   }
222 
223   /**
224    * @dev low level token purchase ***DO NOT OVERRIDE***
225    * @param beneficiary Address performing the token purchase
226    */
227   function buyTokens(address beneficiary) public payable {
228 
229     uint256 weiAmount = msg.value;
230     _preValidatePurchase(beneficiary, weiAmount);
231 
232     // calculate token amount to be created
233     uint256 tokens = _getTokenAmount(weiAmount);
234 
235     // update state
236     _weiRaised = _weiRaised.add(weiAmount);
237 
238     _processPurchase(beneficiary, tokens);
239     emit TokensPurchased(
240       msg.sender,
241       beneficiary,
242       weiAmount,
243       tokens
244     );
245 
246     _updatePurchasingState(beneficiary, weiAmount);
247 
248     _forwardFunds();
249     _postValidatePurchase(beneficiary, weiAmount);
250   }
251 
252   // -----------------------------------------
253   // Internal interface (extensible)
254   // -----------------------------------------
255 
256   /**
257    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
258    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
259    *   super._preValidatePurchase(beneficiary, weiAmount);
260    *   require(weiRaised().add(weiAmount) <= cap);
261    * @param beneficiary Address performing the token purchase
262    * @param weiAmount Value in wei involved in the purchase
263    */
264   function _preValidatePurchase(
265     address beneficiary,
266     uint256 weiAmount
267   )
268     internal
269   {
270     require(beneficiary != address(0));
271     require(weiAmount != 0);
272   }
273 
274   /**
275    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
276    * @param beneficiary Address performing the token purchase
277    * @param weiAmount Value in wei involved in the purchase
278    */
279   function _postValidatePurchase(
280     address beneficiary,
281     uint256 weiAmount
282   )
283     internal
284   {
285     // optional override
286   }
287 
288   /**
289    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
290    * @param beneficiary Address performing the token purchase
291    * @param tokenAmount Number of tokens to be emitted
292    */
293   function _deliverTokens(
294     address beneficiary,
295     uint256 tokenAmount
296   )
297     internal
298   {
299     _token.transferFrom(owner,beneficiary, tokenAmount);
300   }
301 
302   /**
303    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
304    * @param beneficiary Address receiving the tokens
305    * @param tokenAmount Number of tokens to be purchased
306    */
307   function _processPurchase(
308     address beneficiary,
309     uint256 tokenAmount
310   )
311     internal
312   {
313     _deliverTokens(beneficiary, tokenAmount);
314   }
315 
316   /**
317    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
318    * @param beneficiary Address receiving the tokens
319    * @param weiAmount Value in wei involved in the purchase
320    */
321   function _updatePurchasingState(
322     address beneficiary,
323     uint256 weiAmount
324   )
325     internal
326   {
327     // optional override
328   }
329 
330   /**
331    * @dev Override to extend the way in which ether is converted to tokens.
332    * @param weiAmount Value in wei to be converted into tokens
333    * @return Number of tokens that can be purchased with the specified _weiAmount
334    */
335   function _getTokenAmount(uint256 weiAmount)
336     internal view returns (uint256)
337   {
338     return weiAmount.mul(_rate);
339   }
340 
341   /**
342    * @dev Determines how ETH is stored/forwarded on purchases.
343    */
344   function _forwardFunds() internal {
345     _wallet.transfer(msg.value);
346   }
347 }
348 
349 
350 /**
351  * @title TimedCrowdsale
352  * @dev Crowdsale accepting contributions only within a time frame.
353  */
354 contract TimedCrowdsale is Crowdsale {
355   using SafeMath for uint256;
356 
357   uint256 public _openingTime;
358   uint256 public _closingTime;
359 
360   /**
361    * @dev Reverts if not in crowdsale time range.
362    */
363   modifier onlyWhileOpen {
364     require(isOpen());
365     _;
366   }
367 
368   /**
369    * @dev Constructor, takes crowdsale opening and closing times.
370    * @param openingTime Crowdsale opening time
371    * @param closingTime Crowdsale closing time
372    */
373   constructor(uint256 openingTime, uint256 closingTime) public {
374     // solium-disable-next-line security/no-block-members
375     require(openingTime >= block.timestamp);
376     require(closingTime >= openingTime);
377 
378     _openingTime = openingTime;
379     _closingTime = closingTime;
380   }
381 
382 
383   /**
384    * @return true if the crowdsale is open, false otherwise.
385    */
386   function isOpen() public view returns (bool) {
387     // solium-disable-next-line security/no-block-members
388     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
389   }
390 
391   /**
392    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
393    * @return Whether crowdsale period has elapsed
394    */
395   function hasClosed() public view returns (bool) {
396     // solium-disable-next-line security/no-block-members
397     return block.timestamp > _closingTime;
398   }
399 
400   /**
401    * @dev Extend parent behavior requiring to be within contributing period
402    * @param beneficiary Token purchaser
403    * @param weiAmount Amount of wei contributed
404    */
405   function _preValidatePurchase(
406     address beneficiary,
407     uint256 weiAmount
408   )
409     internal
410     onlyWhileOpen
411   {
412     super._preValidatePurchase(beneficiary, weiAmount);
413   }
414 
415 }
416 
417 /**
418  * @title EscrowAccountCrowdsale.
419  */
420 contract EscrowAccountCrowdsale is TimedCrowdsale {
421   using SafeMath for uint256;
422   EscrowVault public vault;
423   /**
424    * @dev Constructor, creates EscrowAccountCrowdsale.
425    */
426   function EscrowAccountCrowdsale() public {
427     vault = new EscrowVault(_wallet);
428   }
429   /**
430    * @dev Investors can claim refunds here if whitelisted is unsuccessful
431    */
432   function returnInvestoramount(address _beneficiary, uint256 _percentage) internal onlyOwner {
433     vault.refund(_beneficiary);
434   }
435 
436  /**
437    * @dev Investors can claim refunds here if whitelisted is unsuccessful
438    */
439   function adminChargeForDebit(address _beneficiary, uint256 _adminCharge) internal onlyOwner {
440     vault.debitForFailed(_beneficiary,_adminCharge);
441   }
442 
443   function afterWhtelisted(address _beneficiary) internal onlyOwner{
444       vault.closeAfterWhitelisted(_beneficiary);
445   }
446   
447   function afterWhtelistedBuy(address _beneficiary) internal {
448       vault.closeAfterWhitelisted(_beneficiary);
449   }
450   /**
451    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
452    */
453   function _forwardFunds() internal {
454     vault.deposit.value(msg.value)(msg.sender);
455   }
456 
457 }
458 
459 /**
460  * @title EscrowVault
461  * @dev This contract is used for storing funds while a crowdsale
462  * is in progress. Supports refunding the money if whitelist fails,
463  * and forwarding it if whitelist is successful.
464  */
465 contract EscrowVault is Ownable {
466   using SafeMath for uint256;
467   mapping (address => uint256) public deposited;
468   address public wallet;
469   event Closed();
470   event Refunded(address indexed beneficiary, uint256 weiAmount);
471   /**
472    * @param _wallet Vault address
473    */
474   function EscrowVault(address _wallet) public {
475     require(_wallet != address(0));
476     wallet = _wallet;   
477   }
478   /**
479    * @param investor Investor address
480    */
481   function deposit(address investor) onlyOwner  payable {
482     deposited[investor] = deposited[investor].add(msg.value);
483   }
484   
485   /**
486    * @dev Transfers deposited amount to wallet address after verification is completed.
487    * @param _beneficiary depositor address.
488    */
489   function closeAfterWhitelisted(address _beneficiary) onlyOwner public { 
490     uint256 depositedValue = deposited[_beneficiary];
491     deposited[_beneficiary] = 0;
492     wallet.transfer(depositedValue);
493   }
494   
495   /**
496    * @param investor Investor address
497    */
498   function debitForFailed(address investor, uint256 _debit)public onlyOwner  {
499      uint256 depositedValue = deposited[investor];
500      depositedValue=depositedValue.sub(_debit);
501      wallet.transfer(_debit);
502      deposited[investor] = depositedValue;
503   }
504    
505   /**
506    * @dev 
507    * @param investor Investor address
508    */
509   function refund(address investor)public onlyOwner  {
510     uint256 depositedValue = deposited[investor];
511     investor.transfer(depositedValue);
512      emit Refunded(investor, depositedValue);
513      deposited[investor] = 0;
514   }
515 }
516 
517 /**
518  * @title PostDeliveryCrowdsale
519  * @dev Crowdsale that locks tokens from withdrawal until it whitelisted and crowdsale ends.
520  */
521 contract PostDeliveryCrowdsale is TimedCrowdsale {
522   using SafeMath for uint256;
523 
524   mapping(address => uint256) public _balances;
525 
526   /**
527    * @dev Withdraw tokens only after whitelisted ends and after crowdsale ends.
528    */
529   function withdrawTokens() public {
530    require(hasClosed());
531     uint256 amount = _balances[msg.sender];
532     require(amount > 0);
533     _balances[msg.sender] = 0;
534     _deliverTokens(msg.sender, amount);
535   }
536   
537    /**
538     * @dev Debits token for the failed verification
539     * @param _beneficiary address from which tokens debited
540     * @param _token amount of tokens to be debited
541     */
542     
543    function failedWhitelistForDebit(address _beneficiary,uint256 _token) internal  {
544     require(_beneficiary != address(0));
545     uint256 amount = _balances[_beneficiary];
546     _balances[_beneficiary] = amount.sub(_token);
547   }
548   
549    /**
550     * @dev debits entire tokens after refund, if verification completely failed
551     * @param _beneficiary address from which tokens debited
552     */
553    function failedWhitelist(address _beneficiary) internal  {
554     require(_beneficiary != address(0));
555     uint256 amount = _balances[_beneficiary];
556     _balances[_beneficiary] = 0;
557   }
558   
559   function getInvestorDepositAmount(address _investor) public constant returns(uint256 paid){
560      return _balances[_investor];
561   }
562 
563   /**
564    * @dev Overrides parent by storing balances instead of issuing tokens right away.
565    * @param _beneficiary Token purchaser
566    * @param _tokenAmount Amount of tokens purchased
567    */
568   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
569     _balances[_beneficiary] = _balances[_beneficiary].add(_tokenAmount);
570   }
571 
572 }
573 
574 
575 contract BitcoinageCrowdsale is TimedCrowdsale,EscrowAccountCrowdsale,PostDeliveryCrowdsale {
576 
577  enum Stage {KYC_FAILED, KYC_SUCCESS,AML_FAILED, AML_SUCCESS} 	
578   //stage PreSale or PublicSale
579   enum Phase {PRESALE, PUBLICSALE}
580   //stage ICO
581   Phase public phase;
582  
583   uint256 private constant DECIMALFACTOR = 10**uint256(18);
584   uint256 public _totalSupply=200000000 * DECIMALFACTOR;
585   uint256 public presale=5000000* DECIMALFACTOR;
586   uint256 public publicsale=110000000* DECIMALFACTOR;
587   uint256 public teamAndAdvisorsAndBountyAllocation = 12000000 * DECIMALFACTOR;
588   uint256 public operatingBudgetAllocation = 5000000 * DECIMALFACTOR;
589   uint256 public tokensVested = 28000000 * DECIMALFACTOR;
590  
591   struct whitelisted{
592        Stage  stage;
593  }
594   uint256 public adminCharge=0.025 ether;
595   uint256 public minContribAmount = 0.2 ether; // min invesment
596   mapping(address => whitelisted) public whitelist;
597   // How much ETH each address has invested to this crowdsale
598   mapping (address => uint256) public investedAmountOf;
599     // How many distinct addresses have invested
600   uint256 public investorCount;
601     // decimalFactor
602  
603   event updateRate(uint256 tokenRate, uint256 time);
604   
605    /**
606  	* @dev BitcoinageCrowdsale is a base contract for managing a token crowdsale.
607  	* BitcoinageCrowdsale have a start and end timestamps, where investors can make
608  	* token purchases and the crowdsale will assign them tokens based
609  	* on a token per ETH rate. Funds collected are forwarded to a wallet
610  	* as they arrive.
611  	*/
612   
613  function BitcoinageCrowdsale(uint256 _starttime, uint256 _endTime, uint256 _rate, address _wallet,IERC20 _token)
614   TimedCrowdsale(_starttime,_endTime)Crowdsale(_rate, _wallet,_token)
615   {
616       phase = Phase.PRESALE;
617   }
618     
619   /**
620    * @dev fallback function ***DO NOT OVERRIDE***
621    */
622   function () external payable {
623     buyTokens(msg.sender);
624   }
625   
626   /**
627    * @dev token purchased on sending ether
628    * @param _beneficiary Address performing the token purchase
629    */
630   function buyTokens(address _beneficiary) public payable onlyWhileOpen{
631     require(_beneficiary != address(0));
632     require(validPurchase());
633   
634     uint256 weiAmount = msg.value;
635     // calculate token amount to be created
636     uint256 tokens = weiAmount.mul(_rate);
637      if(phase==Phase.PRESALE){
638         assert(presale>=tokens);
639         presale=presale.sub(tokens);
640     }else{
641         assert(publicsale>=tokens);
642         publicsale=publicsale.sub(tokens);
643     }
644     
645      _forwardFunds();
646          _processPurchase(_beneficiary, tokens);
647     if(investedAmountOf[msg.sender] == 0) {
648            // A new investor
649            investorCount++;
650         }
651         // Update investor
652       investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(weiAmount);
653         
654       if(whitelist[_beneficiary].stage==Stage.AML_SUCCESS){
655                 afterWhtelistedBuy(_beneficiary);
656       }
657       
658   }
659    
660     function validPurchase() internal constant returns (bool) {
661     bool minContribution = minContribAmount <= msg.value;
662     return  minContribution;
663   }
664   
665 
666 
667  /**
668    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
669    */
670   modifier isWhitelisted(address _beneficiary) {
671     require(whitelist[_beneficiary].stage==Stage.AML_SUCCESS);
672     _;
673   }
674 
675   /**
676    * @dev Adds single address to whitelist.
677    * @param _beneficiary Address to be added to the whitelist
678    */
679   function addToWhitelist(address _beneficiary,uint256 _stage) external onlyOwner {
680      require(_beneficiary != address(0));
681      if(_stage==1){
682          
683          failedWhitelistForDebit(_beneficiary,_rate.mul(adminCharge));
684          adminChargeForDebit(_beneficiary,adminCharge);
685          whitelist[_beneficiary].stage=Stage.KYC_FAILED;
686          uint256 value=investedAmountOf[_beneficiary];
687          value=value.sub(adminCharge);
688          investedAmountOf[_beneficiary]=value;
689          
690      }else if(_stage==2){
691          
692          whitelist[_beneficiary].stage=Stage.KYC_SUCCESS;
693          
694      }else if(_stage==3){
695          
696          whitelist[_beneficiary].stage=Stage.AML_FAILED;
697          returnInvestoramount(_beneficiary,adminCharge);
698          failedWhitelist(_beneficiary);
699          investedAmountOf[_beneficiary]=0;
700          
701      }else if(_stage==4){
702          
703          whitelist[_beneficiary].stage=Stage.AML_SUCCESS;
704          afterWhtelisted( _beneficiary); 
705     
706      }
707   }
708  
709   /**
710    * @dev Withdraw tokens only after Investors added into whitelist .
711    */
712   function withdrawTokens() public isWhitelisted(msg.sender)  {
713     uint256 amount = _balances[msg.sender];
714     require(amount > 0);
715     _deliverTokens(msg.sender, amount);
716     _balances[msg.sender] = 0;
717   }
718   
719  /**
720  * @dev Change crowdsale ClosingTime
721  * @param  _endTime is End time in Seconds
722  */
723   function changeEndtime(uint256 _endTime) public onlyOwner {
724     require(_endTime > 0); 
725     _closingTime = _endTime;
726   }
727     
728     /**
729  * @dev Change crowdsale OpeningTime
730  * @param  _startTime is End time in Seconds
731  */
732   function changeStarttime(uint256 _startTime) public onlyOwner {
733     require(_startTime > 0); 
734     _openingTime = _startTime;
735   }
736     
737  /**
738    * @dev Change Stage.
739    * @param _rate for ETH Per Token
740    */
741   function changeStage(uint256 _rate) public onlyOwner {
742      require(_rate>0);
743      _rate=_rate;
744      phase=Phase.PUBLICSALE;
745   }
746 
747  /**
748  * @dev Change Token rate per ETH
749  * @param  _rate is set the current rate of AND Token
750  */
751   function changeRate(uint256 _rate) public onlyOwner {
752     require(_rate > 0); 
753     _rate = _rate;
754     emit updateRate(_rate,block.timestamp);
755   }
756   
757  /**
758    * @dev Change adminCharge Amount.
759    * @param _adminCharge for debit ETH amount
760    */
761   function changeAdminCharge(uint256 _adminCharge) public onlyOwner {
762      require(_adminCharge > 0);
763      adminCharge=_adminCharge;
764   }
765   
766     
767  /**
768    * @dev transfer tokens to advisor and bounty team.
769    * @param to for recipiant address
770    * @param tokens is amount of tokens
771    */
772   
773     function transferTeamAndAdvisorsAndBountyAllocation  (address to, uint256 tokens) public onlyOwner {
774          require (
775             to != 0x0 && tokens > 0 && teamAndAdvisorsAndBountyAllocation >= tokens
776          );
777         _deliverTokens(to, tokens);
778          teamAndAdvisorsAndBountyAllocation = teamAndAdvisorsAndBountyAllocation.sub(tokens);
779     }
780      
781      /**
782    * @dev transfer vested tokens.
783    * @param to for recipiant address
784    * @param tokens is amount of tokens
785    */
786      
787      function transferTokensVested(address to, uint256 tokens) public onlyOwner {
788          require (
789             to != 0x0 && tokens > 0 && tokensVested >= tokens
790          );
791         _deliverTokens(to, tokens);
792          tokensVested = tokensVested.sub(tokens);
793      }
794      
795       /**
796    * @dev transfer tokens to operating team.
797    * @param to for recipiant address
798    * @param tokens is amount of tokens
799    */
800      
801      function transferOperatingBudgetAllocation(address to, uint256 tokens) public onlyOwner {
802          require (
803             to != 0x0 && tokens > 0 && operatingBudgetAllocation >= tokens
804          );
805         _deliverTokens(to, tokens);
806          operatingBudgetAllocation = operatingBudgetAllocation.sub(tokens);
807      }
808 }