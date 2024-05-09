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
21   }
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
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   uint256 public totalSupply;
58   function balanceOf(address who) public constant returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract ERC20 is ERC20Basic {
67   using SafeMath for uint256;
68   mapping(address => uint256) balances; 
69 
70  
71 }
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85  function Ownable() {
86     owner = msg.sender;
87   }
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) onlyOwner public {
100     require(newOwner != address(0));
101     emit OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 }
105 
106 /**
107  * @title Mintable token
108  * @dev Simple ERC20 Token example, with mintable token creation
109  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
110  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
111  */
112 contract MintableToken is ERC20, Ownable {
113   event Mint(address indexed to, uint256 amount);
114   event MintFinished();
115   bool public mintingFinished = false;
116   modifier canMint() {
117     require(!mintingFinished);
118     _;
119   }
120   /**
121    * @dev Function to mint tokens
122    * @param _to The address that will receive the minted tokens.
123    * @param _amount The amount of tokens to mint.
124    * @return A boolean that indicates if the operation was successful.
125    */
126   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
127     totalSupply = totalSupply.add(_amount);
128     balances[_to] = balances[_to].add(_amount);
129     emit Mint(_to, _amount);
130     emit Transfer(0x0, _to, _amount);
131     return true;
132   }
133   /**
134    * @dev Function to stop minting new tokens.
135    * @return True if the operation was successful.
136    */
137   function finishMinting() onlyOwner public returns (bool) {
138     mintingFinished = true;
139     emit MintFinished();
140     return true;
141   }
142 }
143 
144 /**
145  * @title Crowdsale
146  * @dev Crowdsale is a base contract for managing a token crowdsale,
147  * allowing investors to purchase tokens with ether. This contract implements
148  * such functionality in its most fundamental form and can be extended to provide additional
149  * functionality and/or custom behavior.
150  * The external interface represents the basic interface for purchasing tokens, and conform
151  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
152  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
153  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
154  * behavior.
155  */
156 contract Crowdsale {
157   using SafeMath for uint256;
158 
159   // The token being sold
160   ERC20 public token;
161 
162   // Address where funds are collected
163   address public wallet;
164 
165   // How many token units a buyer gets per wei
166   uint256 public rate;
167 
168   // Amount of wei raised
169   uint256 public weiRaised;
170 
171   /**
172    * Event for token purchase logging
173    * @param purchaser who paid for the tokens
174    * @param beneficiary who got the tokens
175    * @param value weis paid for purchase
176    * @param amount amount of tokens purchased
177    */
178   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
179 
180   /**
181    * @param _rate Number of token units a buyer gets per wei
182    * @param _wallet Address where collected funds will be forwarded to
183    * @param _token Address of the token being sold
184    */
185   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
186     require(_rate > 0);
187     require(_wallet != address(0));
188     require(_token != address(0));
189 
190     rate = _rate;
191     wallet = _wallet;
192     token = _token;
193   }
194 
195   // -----------------------------------------
196   // Crowdsale external interface
197   // -----------------------------------------
198 
199   /**
200    * @dev fallback function ***DO NOT OVERRIDE***
201    */
202   function () external payable {
203     buyTokens(msg.sender);
204   }
205 
206   /**
207    * @dev low level token purchase ***DO NOT OVERRIDE***
208    * @param _beneficiary Address performing the token purchase
209    */
210   function buyTokens(address _beneficiary) public payable {
211 
212     uint256 weiAmount = msg.value;
213     _preValidatePurchase(_beneficiary, weiAmount);
214 
215     // calculate token amount to be created
216     uint256 tokens = _getTokenAmount(weiAmount);
217 
218     // update state
219     weiRaised = weiRaised.add(weiAmount);
220 
221     _processPurchase(_beneficiary, tokens);
222     emit TokenPurchase(
223       msg.sender,
224       _beneficiary,
225       weiAmount,
226       tokens
227     );
228 
229     _updatePurchasingState(_beneficiary, weiAmount);
230 
231     _forwardFunds();
232     _postValidatePurchase(_beneficiary, weiAmount);
233   }
234 
235   // -----------------------------------------
236   // Internal interface (extensible)
237   // -----------------------------------------
238 
239   /**
240    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
241    * @param _beneficiary Address performing the token purchase
242    * @param _weiAmount Value in wei involved in the purchase
243    */
244   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
245     require(_beneficiary != address(0));
246     require(_weiAmount != 0);
247   }
248 
249   /**
250    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
251    * @param _beneficiary Address performing the token purchase
252    * @param _weiAmount Value in wei involved in the purchase
253    */
254   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
255     // optional override
256   }
257 
258   /**
259    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
260    * @param _beneficiary Address performing the token purchase
261    * @param _tokenAmount Number of tokens to be emitted
262    */
263   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
264     token.transfer(_beneficiary, _tokenAmount);
265   }
266 
267   /**
268    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
269    * @param _beneficiary Address receiving the tokens
270    * @param _tokenAmount Number of tokens to be purchased
271    */
272   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
273     _deliverTokens(_beneficiary, _tokenAmount);
274   }
275 
276   /**
277    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
278    * @param _beneficiary Address receiving the tokens
279    * @param _weiAmount Value in wei involved in the purchase
280    */
281   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
282     // optional override
283   }
284 
285   /**
286    * @dev Override to extend the way in which ether is converted to tokens.
287    * @param _weiAmount Value in wei to be converted into tokens
288    * @return Number of tokens that can be purchased with the specified _weiAmount
289    */
290   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
291     return _weiAmount.mul(rate);
292   }
293 
294   /**
295    * @dev Determines how ETH is stored/forwarded on purchases.
296    */
297   function _forwardFunds() internal {
298     wallet.transfer(msg.value);
299   }
300 }
301 
302 
303 
304 
305 /**
306  * @title TimedCrowdsale
307  * @dev Crowdsale accepting contributions only within a time frame.
308  */
309 contract TimedCrowdsale is Crowdsale {
310   using SafeMath for uint256;
311 
312   uint256 public openingTime;
313   uint256 public closingTime;
314 
315   /**
316    * @dev Reverts if not in crowdsale time range.
317    */
318   modifier onlyWhileOpen {
319     // solium-disable-next-line security/no-block-members
320     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
321     _;
322   }
323 
324   /**
325    * @dev Constructor, takes crowdsale opening and closing times.
326    * @param _openingTime Crowdsale opening time
327    * @param _closingTime Crowdsale closing time
328    */
329   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
330     // solium-disable-next-line security/no-block-members
331     require(_openingTime >= block.timestamp);
332     require(_closingTime >= _openingTime);
333 
334     openingTime = _openingTime;
335     closingTime = _closingTime;
336   }
337 
338   /**
339    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
340    * @return Whether crowdsale period has elapsed
341    */
342   function hasClosed() public view returns (bool) {
343     // solium-disable-next-line security/no-block-members
344     return block.timestamp > closingTime;
345   }
346 
347   /**
348    * @dev Extend parent behavior requiring to be within contributing period
349    * @param _beneficiary Token purchaser
350    * @param _weiAmount Amount of wei contributed
351    */
352   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
353     super._preValidatePurchase(_beneficiary, _weiAmount);
354   }
355 
356 }
357 
358 
359 /**
360  * @title MintedCrowdsale
361  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
362  * Token ownership should be transferred to MintedCrowdsale for minting. 
363  */
364 contract MintedCrowdsale is Crowdsale {
365 
366   /**
367    * @dev Overrides delivery by minting tokens upon purchase.
368    * @param _beneficiary Token purchaser
369    * @param _tokenAmount Number of tokens to be minted
370    */
371   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
372     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
373   }
374 }
375 
376 
377 
378 /**
379  * @title EscrowAccountCrowdsale.
380  */
381 contract EscrowAccountCrowdsale is TimedCrowdsale, Ownable {
382   using SafeMath for uint256;
383   EscrowVault public vault;
384   /**
385    * @dev Constructor, creates EscrowAccountCrowdsale.
386    */
387    function EscrowAccountCrowdsale() public {
388     vault = new EscrowVault(wallet);
389   }
390   /**
391    * @dev Investors can claim refunds here if whitelisted is unsuccessful
392    */
393   function returnInvestoramount(address _beneficiary, uint256 _percentage) internal onlyOwner {
394     vault.refund(_beneficiary,_percentage);
395   }
396 
397   function afterWhtelisted(address _beneficiary) internal onlyOwner{
398       vault.closeAfterWhitelisted(_beneficiary);
399   }
400   /**
401    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
402    */
403   function _forwardFunds() internal {
404     vault.deposit.value(msg.value)(msg.sender);
405   }
406 
407 }
408 
409 /**
410  * @title EscrowVault
411  * @dev This contract is used for storing funds while a crowdsale
412  * is in progress. Supports refunding the money if whitelist fails,
413  * and forwarding it if whitelist is successful.
414  */
415 contract EscrowVault is Ownable {
416   using SafeMath for uint256;
417   mapping (address => uint256) public deposited;
418   address public wallet;
419   event Closed();
420   event Refunded(address indexed beneficiary, uint256 weiAmount);
421   /**
422    * @param _wallet Vault address
423    */
424   function EscrowVault(address _wallet) public {
425     require(_wallet != address(0));
426     wallet = _wallet;
427    
428   }
429   /**
430    * @param investor Investor address
431    */
432   function deposit(address investor) onlyOwner  payable {
433     deposited[investor] = deposited[investor].add(msg.value);
434   }
435    function closeAfterWhitelisted(address _beneficiary) onlyOwner public {
436    
437     uint256 depositedValue = deposited[_beneficiary];
438     deposited[_beneficiary] = 0;
439     wallet.transfer(depositedValue);
440   }
441    
442 
443   /**
444    * @param investor Investor address
445    */
446   function refund(address investor, uint256 _percentage)onlyOwner  {
447     uint256 depositedValue = deposited[investor];
448     depositedValue=depositedValue.sub(_percentage);
449    
450     investor.transfer(depositedValue);
451     wallet.transfer(_percentage);
452     emit Refunded(investor, depositedValue);
453      deposited[investor] = 0;
454   }
455 }
456 
457 /**
458  * @title PostDeliveryCrowdsale
459  * @dev Crowdsale that locks tokens from withdrawal until it whitelisted and crowdsale ends.
460  */
461 contract PostDeliveryCrowdsale is TimedCrowdsale {
462   using SafeMath for uint256;
463 
464   mapping(address => uint256) public balances;
465 
466   /**
467    * @dev Withdraw tokens only after whitelisted ends and after crowdsale ends.
468    */
469    
470   
471   function withdrawTokens() public {
472    require(hasClosed());
473     uint256 amount = balances[msg.sender];
474     require(amount > 0);
475     balances[msg.sender] = 0;
476     _deliverTokens(msg.sender, amount);
477   }
478   
479   
480    function failedWhitelist(address _beneficiary) internal  {
481     require(_beneficiary != address(0));
482     uint256 amount = balances[_beneficiary];
483     balances[_beneficiary] = 0;
484   }
485   function getInvestorDepositAmount(address _investor) public constant returns(uint256 paid){
486      
487      return balances[_investor];
488  }
489 
490   /**
491    * @dev Overrides parent by storing balances instead of issuing tokens right away.
492    * @param _beneficiary Token purchaser
493    * @param _tokenAmount Amount of tokens purchased
494    */
495   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
496     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
497   }
498 
499 }
500 
501 
502 contract CryptoAssetCrowdsale is TimedCrowdsale, MintedCrowdsale,EscrowAccountCrowdsale,PostDeliveryCrowdsale {
503 
504  enum Stage {PROCESS1_FAILED, PROCESS1_SUCCESS,PROCESS2_FAILED, PROCESS2_SUCCESS,PROCESS3_FAILED, PROCESS3_SUCCESS} 	
505  	//stage Phase1 or Phase2 or Phase
506 	enum Phase {PHASE1, PHASE2,PHASE3}
507 	//stage ICO
508 	Phase public phase;
509  
510   struct whitelisted{
511        Stage  stage;
512  }
513   uint256 public adminCharge_p1=0.010 ether;
514   uint256 public adminCharge_p2=0.13 ether;
515   uint256 public adminCharge_p3=0.14 ether;
516   uint256 public cap=750 ether;// softcap is 750 ether
517   uint256 public goal=4500 ether;// hardcap is 4500 ether
518   uint256 public minContribAmount = 0.1 ether; // min invesment
519   mapping(address => whitelisted) public whitelist;
520   // How much ETH each address has invested to this crowdsale
521   mapping (address => uint256) public investedAmountOf;
522     // How many distinct addresses have invested
523   uint256 public investorCount;
524     // decimalFactor
525   uint256 public constant DECIMALFACTOR = 10**uint256(18);
526   event updateRate(uint256 tokenRate, uint256 time);
527   
528    /**
529  	* @dev CryptoAssetCrowdsale is a base contract for managing a token crowdsale.
530  	* CryptoAssetCrowdsale have a start and end timestamps, where investors can make
531  	* token purchases and the crowdsale will assign them tokens based
532  	* on a token per ETH rate. Funds collected are forwarded to a wallet
533  	* as they arrive.
534  	*/
535   
536  function CryptoAssetCrowdsale(uint256 _starttime, uint256 _endTime, uint256 _rate, address _wallet,ERC20 _token)
537   TimedCrowdsale(_starttime,_endTime)Crowdsale(_rate, _wallet,_token)
538   {
539       phase = Phase.PHASE1;
540   }
541     
542   /**
543    * @dev fallback function ***DO NOT OVERRIDE***
544    */
545   function () external payable {
546     buyTokens(msg.sender);
547   }
548   
549   function buyTokens(address _beneficiary) public payable onlyWhileOpen{
550     require(_beneficiary != address(0));
551     require(validPurchase());
552   
553     uint256 weiAmount = msg.value;
554     // calculate token amount to be created
555     uint256 tokens = weiAmount.mul(rate);
556     uint256 volumebasedBonus=0;
557     if(phase == Phase.PHASE1){
558     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase1(tokens)).div(100);
559 
560     }else if(phase == Phase.PHASE2){
561     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase2(tokens)).div(100);
562 
563     }else{
564     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase3(tokens)).div(100);
565 
566     }
567 
568     tokens=tokens.add(volumebasedBonus);
569     _preValidatePurchase( _beneficiary,  weiAmount);
570     weiRaised = weiRaised.add(weiAmount);
571     _processPurchase(_beneficiary, tokens);
572     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
573     _forwardFunds();
574     if(investedAmountOf[msg.sender] == 0) {
575            // A new investor
576            investorCount++;
577         }
578         // Update investor
579         investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(weiAmount);
580   }
581     function tokensaleToOtherCoinUser(address beneficiary, uint256 weiAmount) public onlyOwner onlyWhileOpen {
582     require(beneficiary != address(0) && weiAmount > 0);
583     uint256 tokens = weiAmount.mul(rate);
584     uint256 volumebasedBonus=0;
585     if(phase == Phase.PHASE1){
586     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase1(tokens)).div(100);
587 
588     }else if(phase == Phase.PHASE2){
589     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase2(tokens)).div(100);
590 
591     }else{
592     volumebasedBonus = tokens.mul(getTokenVolumebasedBonusRateForPhase3(tokens)).div(100);
593 
594     }
595 
596     tokens=tokens.add(volumebasedBonus);
597     weiRaised = weiRaised.add(weiAmount);
598     _processPurchase(beneficiary, tokens);
599     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
600     }
601     
602     function validPurchase() internal constant returns (bool) {
603     bool minContribution = minContribAmount <= msg.value;
604     return  minContribution;
605   }
606   
607   
608   function getTokenVolumebasedBonusRateForPhase1(uint256 value) internal constant returns (uint256) {
609         uint256 bonusRate = 0;
610         uint256 valume = value.div(DECIMALFACTOR);
611 
612         if (valume <= 50000 && valume >= 149999) {
613             bonusRate = 30;
614         } else if (valume <= 150000 && valume >= 299999) {
615             bonusRate = 35;
616         } else if (valume <= 300000 && valume >= 500000) {
617             bonusRate = 40;
618         } else{
619             bonusRate = 25;
620         }
621 
622         return bonusRate;
623     }
624   
625    function getTokenVolumebasedBonusRateForPhase2(uint256 value) internal constant returns (uint256) {
626         uint256 bonusRate = 0;
627         uint valume = value.div(DECIMALFACTOR);
628 
629         if (valume <= 50000 && valume >= 149999) {
630             bonusRate = 25;
631         } else if (valume <= 150000 && valume >= 299999) {
632             bonusRate = 30;
633         } else if (valume <= 300000 && valume >= 500000) {
634             bonusRate = 35;
635         } else{
636             bonusRate = 20;
637         }
638 
639         return bonusRate;
640     }
641     
642      function getTokenVolumebasedBonusRateForPhase3(uint256 value) internal constant returns (uint256) {
643         uint256 bonusRate = 0;
644         uint valume = value.div(DECIMALFACTOR);
645 
646         if (valume <= 50000 && valume >= 149999) {
647             bonusRate = 20;
648         } else if (valume <= 150000 && valume >= 299999) {
649             bonusRate = 25;
650         } else if (valume <= 300000 && valume >= 500000) {
651             bonusRate = 30;
652         } else{
653             bonusRate = 15;
654         }
655 
656         return bonusRate;
657     }
658   
659   /**
660  	* @dev change the Phase from phase1 to phase2 
661  	*/
662   	function startPhase2(uint256 _startTime) public onlyOwner {
663       	require(_startTime>0);
664       	phase = Phase.PHASE2;
665       	openingTime=_startTime;
666       
667    }
668    
669      /**
670  	* @dev change the Phase from phase2 to phase3 sale
671  	*/
672   	function startPhase3(uint256 _startTime) public onlyOwner {
673       	require(0> _startTime);
674       	phase = Phase.PHASE3;
675         openingTime=_startTime;
676 
677    }
678 
679  /**
680    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
681    */
682   modifier isWhitelisted(address _beneficiary) {
683     require(whitelist[_beneficiary].stage==Stage.PROCESS3_SUCCESS);
684     _;
685   }
686 
687   /**
688    * @dev Adds single address to whitelist.
689    * @param _beneficiary Address to be added to the whitelist
690    */
691   function addToWhitelist(address _beneficiary,uint256 _stage) external onlyOwner {
692       require(_beneficiary != address(0));
693       require(_stage>0);  
694  if(_stage==1){
695      whitelist[_beneficiary].stage=Stage.PROCESS1_FAILED;
696      returnInvestoramount(_beneficiary,adminCharge_p1);
697      failedWhitelist(_beneficiary);
698      investedAmountOf[_beneficiary]=0;
699  }else if(_stage==2){
700      whitelist[_beneficiary].stage=Stage.PROCESS1_SUCCESS;
701  }else if(_stage==3){
702      whitelist[_beneficiary].stage=Stage.PROCESS2_FAILED;
703      returnInvestoramount(_beneficiary,adminCharge_p2);
704      failedWhitelist(_beneficiary);
705           investedAmountOf[_beneficiary]=0;
706  }else if(_stage==4){
707      whitelist[_beneficiary].stage=Stage.PROCESS2_SUCCESS;
708  }else if(_stage==5){
709      whitelist[_beneficiary].stage=Stage.PROCESS3_FAILED;
710      returnInvestoramount(_beneficiary,adminCharge_p3);
711      failedWhitelist(_beneficiary);
712           investedAmountOf[_beneficiary]=0;
713      }else if(_stage==6){
714      whitelist[_beneficiary].stage=Stage.PROCESS3_SUCCESS;
715      afterWhtelisted( _beneficiary);
716  }
717  
718  }
719  
720   /**
721    * @dev Withdraw tokens only after Investors added into whitelist .
722    */
723   function withdrawTokens() public isWhitelisted(msg.sender)  {
724     require(hasClosed());
725     uint256 amount = balances[msg.sender];
726     require(amount > 0);
727     balances[msg.sender] = 0;
728     _deliverTokens(msg.sender, amount);
729    
730   }
731   
732  /**
733  * @dev Change crowdsale ClosingTime
734  * @param  _endTime is End time in Seconds
735  */
736   function changeEndtime(uint256 _endTime) public onlyOwner {
737     require(_endTime > 0); 
738     closingTime = _endTime;
739     }
740 
741  /**
742  * @dev Change Token rate per ETH
743  * @param  _rate is set the current rate of AND Token
744  */
745   function changeRate(uint256 _rate) public onlyOwner {
746     require(_rate > 0); 
747     rate = _rate;
748     emit updateRate(_rate,block.timestamp);
749     }
750   /**
751  * @dev Change admin chargers
752  * @param  _p1 for first Kyc Failed-$5
753  * @param  _p2 for second AML Failed-$7
754  * @param  _p3 for third AI Failed-$57
755  */
756   function changeAdminCharges(uint256 _p1,uint256 _p2,uint256 _p3) public onlyOwner {
757     require(_p1 > 0);
758     require(_p2 > 0); 
759     require(_p3 > 0); 
760     adminCharge_p1=_p1;
761     adminCharge_p2=_p2;
762     adminCharge_p3=_p3;
763     
764     }
765     
766  /**
767    * @dev Change minContribution amountAmount.
768    * @param _minInvestment for minimum contribution ETH amount
769    */
770   function changeMinInvestment(uint256 _minInvestment) public onlyOwner {
771      require(_minInvestment > 0);
772      minContribAmount=_minInvestment;
773   }
774   /**
775    * @dev Checks whether the cap has been reached.
776    * @return Whether the cap was reached
777    */
778   function capReached() public view returns (bool) {
779     return weiRaised >= cap;
780   }
781   /**
782    * @dev Checks whether the goal has been reached.
783    * @return Whether the goal was reached
784    */
785   function goalReached() public view returns (bool) {
786     return weiRaised >= goal;
787   }
788   
789   	/**
790  	* @param _to is beneficiary address
791  	* @param _value  Amount if tokens
792  	* @dev  tokens distribution
793  	*/
794 	function tokenDistribution(address _to, uint256 _value)public onlyOwner {
795         require (
796            _to != 0x0 && _value > 0);
797         _processPurchase(_to, _value);
798         whitelist[_to].stage=Stage.PROCESS3_SUCCESS;
799     }
800 }