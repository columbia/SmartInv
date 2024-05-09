1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 
116 
117 library SafeERC20 {
118   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
119     require(token.transfer(to, value));
120   }
121 
122   function safeTransferFrom(
123     ERC20 token,
124     address from,
125     address to,
126     uint256 value
127   )
128     internal
129   {
130     require(token.transferFrom(from, to, value));
131   }
132 
133   function safeApprove(ERC20 token, address spender, uint256 value) internal {
134     require(token.approve(spender, value));
135   }
136 }
137 
138 contract ERC20 is ERC20Basic {
139   function allowance(address owner, address spender)
140     public view returns (uint256);
141 
142   function transferFrom(address from, address to, uint256 value)
143     public returns (bool);
144 
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(
147     address indexed owner,
148     address indexed spender,
149     uint256 value
150   );
151 }
152 
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   uint256 totalSupply_;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[msg.sender]);
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 contract BurnableToken is BasicToken {
194 
195   event Burn(address indexed burner, uint256 value);
196 
197   /**
198    * @dev Burns a specific amount of tokens.
199    * @param _value The amount of token to be burned.
200    */
201   function burn(uint256 _value) public {
202     _burn(msg.sender, _value);
203   }
204 
205   function _burn(address _who, uint256 _value) internal {
206     require(_value <= balances[_who]);
207     // no need to require value <= totalSupply, since that would imply the
208     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
209 
210     balances[_who] = balances[_who].sub(_value);
211     totalSupply_ = totalSupply_.sub(_value);
212     emit Burn(_who, _value);
213     emit Transfer(_who, address(0), _value);
214   }
215 }
216 
217 contract StandardToken is ERC20, BasicToken {
218 
219   mapping (address => mapping (address => uint256)) internal allowed;
220 
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amount of tokens to be transferred
227    */
228   function transferFrom(
229     address _from,
230     address _to,
231     uint256 _value
232   )
233     public
234     returns (bool)
235   {
236     require(_to != address(0));
237     require(_value <= balances[_from]);
238     require(_value <= allowed[_from][msg.sender]);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
243     emit Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address _owner,
270     address _spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(
289     address _spender,
290     uint256 _addedValue
291   )
292     public
293     returns (bool)
294   {
295     allowed[msg.sender][_spender] = (
296       allowed[msg.sender][_spender].add(_addedValue));
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To decrement
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    */
310   function decreaseApproval(
311     address _spender,
312     uint256 _subtractedValue
313   )
314     public
315     returns (bool)
316   {
317     uint256 oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue > oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327 }
328 
329 contract StrayToken is StandardToken, BurnableToken, Ownable {
330 	using SafeERC20 for ERC20;
331 	
332 	uint256 public INITIAL_SUPPLY = 1000000000;
333 	
334 	string public name = "Stray";
335 	string public symbol = "ST";
336 	uint8 public decimals = 18;
337 
338 	address public companyWallet;
339 	address public privateWallet;
340 	address public fund;
341 	
342 	/**
343 	 * @param _companyWallet The company wallet which reserves 15% of the token.
344 	 * @param _privateWallet Private wallet which reservers 25% of the token.
345 	 */
346 	constructor(address _companyWallet, address _privateWallet) public {
347 		require(_companyWallet != address(0));
348 		require(_privateWallet != address(0));
349 		
350 		totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
351 		companyWallet = _companyWallet;
352 		privateWallet = _privateWallet;
353 		
354 		// 15% of tokens for company reserved.
355 		_preSale(companyWallet, totalSupply_.mul(15).div(100));
356 		
357 		// 25% of tokens for private funding.
358 		_preSale(privateWallet, totalSupply_.mul(25).div(100));
359 		
360 		// 60% of tokens for crowdsale.
361 		uint256 sold = balances[companyWallet].add(balances[privateWallet]);
362 	    balances[msg.sender] = balances[msg.sender].add(totalSupply_.sub(sold));
363 	    emit Transfer(address(0), msg.sender, balances[msg.sender]);
364 	}
365 	
366 	/**
367 	 * @param _fund The DAICO fund contract address.
368 	 */
369 	function setFundContract(address _fund) onlyOwner public {
370 	    require(_fund != address(0));
371 	    //require(_fund != owner);
372 	    //require(_fund != msg.sender);
373 	    require(_fund != address(this));
374 	    
375 	    fund = _fund;
376 	}
377 	
378 	/**
379 	 * @dev The DAICO fund contract calls this function to burn the user's token
380 	 * to avoid over refund.
381 	 * @param _from The address which just took its refund.
382 	 */
383 	function burnAll(address _from) public {
384 	    require(fund == msg.sender);
385 	    require(0 != balances[_from]);
386 	    
387 	    _burn(_from, balances[_from]);
388 	}
389 	
390 	/**
391 	 * @param _to The address which will get the token.
392 	 * @param _value The token amount.
393 	 */
394 	function _preSale(address _to, uint256 _value) internal onlyOwner {
395 		balances[_to] = _value;
396 		emit Transfer(address(0), _to, _value);
397 	}
398 	
399 }
400 
401 contract Crowdsale {
402   using SafeMath for uint256;
403   using SafeERC20 for ERC20;
404 
405   // The token being sold
406   ERC20 public token;
407 
408   // Address where funds are collected
409   address public wallet;
410 
411   // How many token units a buyer gets per wei.
412   // The rate is the conversion between wei and the smallest and indivisible token unit.
413   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
414   // 1 wei will give you 1 unit, or 0.001 TOK.
415   uint256 public rate;
416 
417   // Amount of wei raised
418   uint256 public weiRaised;
419 
420   /**
421    * Event for token purchase logging
422    * @param purchaser who paid for the tokens
423    * @param beneficiary who got the tokens
424    * @param value weis paid for purchase
425    * @param amount amount of tokens purchased
426    */
427   event TokenPurchase(
428     address indexed purchaser,
429     address indexed beneficiary,
430     uint256 value,
431     uint256 amount
432   );
433 
434   /**
435    * @param _rate Number of token units a buyer gets per wei
436    * @param _wallet Address where collected funds will be forwarded to
437    * @param _token Address of the token being sold
438    */
439   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
440     require(_rate > 0);
441     require(_wallet != address(0));
442     require(_token != address(0));
443 
444     rate = _rate;
445     wallet = _wallet;
446     token = _token;
447   }
448 
449   // -----------------------------------------
450   // Crowdsale external interface
451   // -----------------------------------------
452 
453   /**
454    * @dev fallback function ***DO NOT OVERRIDE***
455    */
456   function () external payable {
457     buyTokens(msg.sender);
458   }
459 
460   /**
461    * @dev low level token purchase ***DO NOT OVERRIDE***
462    * @param _beneficiary Address performing the token purchase
463    */
464   function buyTokens(address _beneficiary) public payable {
465 
466     uint256 weiAmount = msg.value;
467     _preValidatePurchase(_beneficiary, weiAmount);
468 
469     // calculate token amount to be created
470     uint256 tokens = _getTokenAmount(weiAmount);
471 
472     // update state
473     weiRaised = weiRaised.add(weiAmount);
474 
475     _processPurchase(_beneficiary, tokens);
476     emit TokenPurchase(
477       msg.sender,
478       _beneficiary,
479       weiAmount,
480       tokens
481     );
482 
483     _updatePurchasingState(_beneficiary, weiAmount);
484 
485     _forwardFunds();
486     _postValidatePurchase(_beneficiary, weiAmount);
487   }
488 
489   // -----------------------------------------
490   // Internal interface (extensible)
491   // -----------------------------------------
492 
493   /**
494    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
495    * @param _beneficiary Address performing the token purchase
496    * @param _weiAmount Value in wei involved in the purchase
497    */
498   function _preValidatePurchase(
499     address _beneficiary,
500     uint256 _weiAmount
501   )
502     internal
503   {
504     require(_beneficiary != address(0));
505     require(_weiAmount != 0);
506   }
507 
508   /**
509    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
510    * @param _beneficiary Address performing the token purchase
511    * @param _weiAmount Value in wei involved in the purchase
512    */
513   function _postValidatePurchase(
514     address _beneficiary,
515     uint256 _weiAmount
516   )
517     internal
518   {
519     // optional override
520   }
521 
522   /**
523    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
524    * @param _beneficiary Address performing the token purchase
525    * @param _tokenAmount Number of tokens to be emitted
526    */
527   function _deliverTokens(
528     address _beneficiary,
529     uint256 _tokenAmount
530   )
531     internal
532   {
533     token.safeTransfer(_beneficiary, _tokenAmount);
534   }
535 
536   /**
537    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
538    * @param _beneficiary Address receiving the tokens
539    * @param _tokenAmount Number of tokens to be purchased
540    */
541   function _processPurchase(
542     address _beneficiary,
543     uint256 _tokenAmount
544   )
545     internal
546   {
547     _deliverTokens(_beneficiary, _tokenAmount);
548   }
549 
550   /**
551    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
552    * @param _beneficiary Address receiving the tokens
553    * @param _weiAmount Value in wei involved in the purchase
554    */
555   function _updatePurchasingState(
556     address _beneficiary,
557     uint256 _weiAmount
558   )
559     internal
560   {
561     // optional override
562   }
563 
564   /**
565    * @dev Override to extend the way in which ether is converted to tokens.
566    * @param _weiAmount Value in wei to be converted into tokens
567    * @return Number of tokens that can be purchased with the specified _weiAmount
568    */
569   function _getTokenAmount(uint256 _weiAmount)
570     internal view returns (uint256)
571   {
572     return _weiAmount.mul(rate);
573   }
574 
575   /**
576    * @dev Determines how ETH is stored/forwarded on purchases.
577    */
578   function _forwardFunds() internal {
579     wallet.transfer(msg.value);
580   }
581 }
582 contract RefundVault is Ownable {
583   using SafeMath for uint256;
584 
585   enum State { Active, Refunding, Closed }
586 
587   mapping (address => uint256) public deposited;
588   address public wallet;
589   State public state;
590 
591   event Closed();
592   event RefundsEnabled();
593   event Refunded(address indexed beneficiary, uint256 weiAmount);
594 
595   /**
596    * @param _wallet Vault address
597    */
598   constructor(address _wallet) public {
599     require(_wallet != address(0));
600     wallet = _wallet;
601     state = State.Active;
602   }
603 
604   /**
605    * @param investor Investor address
606    */
607   function deposit(address investor) onlyOwner public payable {
608     require(state == State.Active);
609     deposited[investor] = deposited[investor].add(msg.value);
610   }
611 
612   function close() onlyOwner public {
613     require(state == State.Active);
614     state = State.Closed;
615     emit Closed();
616     wallet.transfer(address(this).balance);
617   }
618 
619   function enableRefunds() onlyOwner public {
620     require(state == State.Active);
621     state = State.Refunding;
622     emit RefundsEnabled();
623   }
624 
625   /**
626    * @param investor Investor address
627    */
628   function refund(address investor) public {
629     require(state == State.Refunding);
630     uint256 depositedValue = deposited[investor];
631     deposited[investor] = 0;
632     investor.transfer(depositedValue);
633     emit Refunded(investor, depositedValue);
634   }
635 }
636 
637 contract TimedCrowdsale is Crowdsale {
638   using SafeMath for uint256;
639 
640   uint256 public openingTime;
641   uint256 public closingTime;
642 
643   /**
644    * @dev Reverts if not in crowdsale time range.
645    */
646   modifier onlyWhileOpen {
647     // solium-disable-next-line security/no-block-members
648     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
649     _;
650   }
651 
652   /**
653    * @dev Constructor, takes crowdsale opening and closing times.
654    * @param _openingTime Crowdsale opening time
655    * @param _closingTime Crowdsale closing time
656    */
657   constructor(uint256 _openingTime, uint256 _closingTime) public {
658     // solium-disable-next-line security/no-block-members
659     require(_openingTime >= block.timestamp);
660     require(_closingTime >= _openingTime);
661 
662     openingTime = _openingTime;
663     closingTime = _closingTime;
664   }
665 
666   /**
667    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
668    * @return Whether crowdsale period has elapsed
669    */
670   function hasClosed() public view returns (bool) {
671     // solium-disable-next-line security/no-block-members
672     return block.timestamp > closingTime;
673   }
674 
675   /**
676    * @dev Extend parent behavior requiring to be within contributing period
677    * @param _beneficiary Token purchaser
678    * @param _weiAmount Amount of wei contributed
679    */
680   function _preValidatePurchase(
681     address _beneficiary,
682     uint256 _weiAmount
683   )
684     internal
685     onlyWhileOpen
686   {
687     super._preValidatePurchase(_beneficiary, _weiAmount);
688   }
689 
690 }
691 
692 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
693   using SafeMath for uint256;
694 
695   bool public isFinalized = false;
696 
697   event Finalized();
698 
699   /**
700    * @dev Must be called after crowdsale ends, to do some extra finalization
701    * work. Calls the contract's finalization function.
702    */
703   function finalize() onlyOwner public {
704     require(!isFinalized);
705     require(hasClosed());
706 
707     finalization();
708     emit Finalized();
709 
710     isFinalized = true;
711   }
712 
713   /**
714    * @dev Can be overridden to add finalization logic. The overriding function
715    * should call super.finalization() to ensure the chain of finalization is
716    * executed entirely.
717    */
718   function finalization() internal {
719   }
720 
721 }
722 
723 contract StrayCrowdsale is FinalizableCrowdsale {
724     using SafeMath for uint256;
725     
726     // Soft cap and hard cap in distributed token.
727     uint256 public softCapInToken;
728     uint256 public hardCapInToken;
729     uint256 public soldToken = 0;
730     
731     // Bouns stage time.
732     uint256 public bonusClosingTime0;
733     uint256 public bonusClosingTime1;
734     
735     // Bouns rate.
736     uint256 public bonusRateInPercent0 = 33;
737     uint256 public bonusRateInPercent1 = 20;
738     
739     // Mininum contribute: 100 USD.
740     uint256 public mininumContributeUSD = 100;
741     
742     // The floating exchange rate from external API.
743     uint256 public decimalsETHToUSD;
744     uint256 public exchangeRateETHToUSD;
745    
746    // The mininum purchase token quantity.
747     uint256 public mininumPurchaseTokenQuantity;
748     
749     // The calculated mininum contribute Wei.
750     uint256 public mininumContributeWei;
751     
752     // The exchange rate from USD to Token.
753     // 1 USD => 100 Token (0.01 USD => 1 Token).
754     uint256 public exchangeRateUSDToToken = 100;
755     
756     // Stray token contract.
757     StrayToken public strayToken;
758     
759     // Refund vault used to hold funds while crowdsale is running
760     RefundVault public vault;
761     
762     // Event 
763     event RateUpdated(uint256 rate, uint256 mininumContributeWei);
764     
765     /**
766      * @param _softCapInUSD Minimal funds to be collected.
767      * @param _hardCapInUSD Maximal funds to be collected.
768      * @param _fund The Stray DAICO fund contract address.
769      * @param _token Stray ERC20 contract.
770      * @param _openingTime Crowdsale opening time.
771      * @param _closingTime Crowdsale closing time.
772      * @param _bonusClosingTime0 Bonus stage0 closing time.
773      * @param _bonusClosingTime1 Bonus stage1 closing time.
774      */
775     constructor(uint256 _softCapInUSD
776         , uint256 _hardCapInUSD
777         , address _fund
778         , ERC20 _token
779         , uint256 _openingTime
780         , uint256 _closingTime
781         , uint256 _bonusClosingTime0
782         , uint256 _bonusClosingTime1
783         ) 
784         Crowdsale(1, _fund, _token)
785         TimedCrowdsale(_openingTime, _closingTime)
786         public 
787     {
788         // Validate ico stage time.
789         require(_bonusClosingTime0 >= _openingTime);
790         require(_bonusClosingTime1 >= _bonusClosingTime0);
791         require(_closingTime >= _bonusClosingTime1);
792         
793         bonusClosingTime0 = _bonusClosingTime0;
794         bonusClosingTime1 = _bonusClosingTime1;
795         
796         // Create the token.
797         strayToken = StrayToken(token);
798         
799         // Set soft cap and hard cap.
800         require(_softCapInUSD > 0 && _softCapInUSD <= _hardCapInUSD);
801         
802         softCapInToken = _softCapInUSD * exchangeRateUSDToToken * (10 ** uint256(strayToken.decimals()));
803         hardCapInToken = _hardCapInUSD * exchangeRateUSDToToken * (10 ** uint256(strayToken.decimals()));
804         
805         require(strayToken.balanceOf(owner) >= hardCapInToken);
806         
807         // Create the refund vault.
808         vault = new RefundVault(_fund);
809         
810         // Calculate mininum purchase token.
811         mininumPurchaseTokenQuantity = exchangeRateUSDToToken * mininumContributeUSD 
812             * (10 ** (uint256(strayToken.decimals())));
813         
814         // Set default exchange rate ETH => USD: 400.00
815         setExchangeRateETHToUSD(40000, 2);
816     }
817     
818     /**
819      * @dev Set the exchange rate from ETH to USD.
820      * @param _rate The exchange rate.
821      * @param _decimals The decimals of input rate.
822      */
823     function setExchangeRateETHToUSD(uint256 _rate, uint256 _decimals) onlyOwner public {
824         // wei * 1e-18 * _rate * 1e(-_decimals) * 1e2          = amount * 1e(-token.decimals);
825         // -----------   ----------------------   -------------
826         // Wei => ETH      ETH => USD             USD => Token
827         //
828         // If _rate = 1, wei = 1,
829         // Then  amount = 1e(token.decimals + 2 - 18 - _decimals).
830         // We need amount >= 1 to ensure the precision.
831         
832         require(uint256(strayToken.decimals()).add(2) >= _decimals.add(18));
833         
834         exchangeRateETHToUSD = _rate;
835         decimalsETHToUSD = _decimals;
836         rate = _rate.mul(exchangeRateUSDToToken);
837         if (uint256(strayToken.decimals()) >= _decimals.add(18)) {
838             rate = rate.mul(10 ** (uint256(strayToken.decimals()).sub(18).sub(_decimals)));
839         } else {
840             rate = rate.div(10 ** (_decimals.add(18).sub(uint256(strayToken.decimals()))));
841         }
842         
843         mininumContributeWei = mininumPurchaseTokenQuantity.div(rate); 
844         
845         // Avoid rounding error.
846         if (mininumContributeWei * rate < mininumPurchaseTokenQuantity)
847             mininumContributeWei += 1;
848             
849         emit RateUpdated(rate, mininumContributeWei);
850     }
851     
852     /**
853      * @dev Investors can claim refunds here if crowdsale is unsuccessful
854      */
855     function claimRefund() public {
856         require(isFinalized);
857         require(!softCapReached());
858 
859         vault.refund(msg.sender);
860     }
861     
862     /**
863      * @dev Checks whether funding goal was reached.
864      * @return Whether funding goal was reached
865      */
866     function softCapReached() public view returns (bool) {
867         return soldToken >= softCapInToken;
868     }
869     
870     /**
871      * @dev Validate if it is in ICO stage 1.
872      */
873     function isInStage1() view public returns (bool) {
874         return now <= bonusClosingTime0 && now >= openingTime;
875     }
876     
877     /**
878      * @dev Validate if it is in ICO stage 2.
879      */
880     function isInStage2() view public returns (bool) {
881         return now <= bonusClosingTime1 && now > bonusClosingTime0;
882     }
883     
884     /**
885      * @dev Validate if crowdsale has started.
886      */
887     function hasStarted() view public returns (bool) {
888         return now >= openingTime;
889     }
890     
891     /**
892      * @dev Validate the mininum contribution requirement.
893      */
894     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
895         internal
896     {
897         super._preValidatePurchase(_beneficiary, _weiAmount);
898         require(_weiAmount >= mininumContributeWei);
899     }
900     
901     /**
902      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
903      * @param _beneficiary Address receiving the tokens
904      * @param _tokenAmount Number of tokens to be purchased
905      */
906     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
907         soldToken = soldToken.add(_tokenAmount);
908         require(soldToken <= hardCapInToken);
909         
910        _tokenAmount = _addBonus(_tokenAmount);
911         
912         super._processPurchase(_beneficiary, _tokenAmount);
913     }
914     
915     /**
916      * @dev Finalization task, called when owner calls finalize()
917      */
918     function finalization() internal {
919         if (softCapReached()) {
920             vault.close();
921         } else {
922             vault.enableRefunds();
923         }
924         
925         // Burn all the unsold token.
926         strayToken.burn(token.balanceOf(address(this)));
927         
928         super.finalization();
929     }
930 
931     /**
932      * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
933      */
934     function _forwardFunds() internal {
935         vault.deposit.value(msg.value)(msg.sender);
936     }
937     
938     /**
939      * @dev Calculate the token amount and add bonus if needed.
940      */
941     function _addBonus(uint256 _tokenAmount) internal view returns (uint256) {
942         if (bonusClosingTime0 >= now) {
943             _tokenAmount = _tokenAmount.mul(100 + bonusRateInPercent0).div(100);
944         } else if (bonusClosingTime1 >= now) {
945             _tokenAmount = _tokenAmount.mul(100 + bonusRateInPercent1).div(100);
946         }
947         
948         require(_tokenAmount <= token.balanceOf(address(this)));
949         
950         return _tokenAmount;
951     }
952 }