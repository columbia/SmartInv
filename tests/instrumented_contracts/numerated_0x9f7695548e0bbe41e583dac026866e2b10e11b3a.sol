1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     assert(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     assert(c >= _a);
54 
55     return c;
56   }
57 }
58 
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 {
65   function totalSupply() public view returns (uint256);
66 
67   function balanceOf(address _who) public view returns (uint256);
68 
69   function allowance(address _owner, address _spender)
70     public view returns (uint256);
71 
72   function transfer(address _to, uint256 _value) public returns (bool);
73 
74   function approve(address _spender, uint256 _value)
75     public returns (bool);
76 
77   function transferFrom(address _from, address _to, uint256 _value)
78     public returns (bool);
79 
80   event Transfer(
81     address indexed from,
82     address indexed to,
83     uint256 value
84   );
85 
86   event Approval(
87     address indexed owner,
88     address indexed spender,
89     uint256 value
90   );
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://github.com/ethereum/EIPs/issues/20
99  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20 {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108   uint256 totalSupply_;
109 
110   /**
111   * @dev Total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param _owner address The address which owns the funds.
129    * @param _spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132   function allowance(
133     address _owner,
134     address _spender
135    )
136     public
137     view
138     returns (uint256)
139   {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144   * @dev Transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_value <= balances[msg.sender]);
150     require(_to != address(0));
151 
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     emit Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189     require(_to != address(0));
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(
208     address _spender,
209     uint256 _addedValue
210   )
211     public
212     returns (bool)
213   {
214     allowed[msg.sender][_spender] = (
215       allowed[msg.sender][_spender].add(_addedValue));
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(
230     address _spender,
231     uint256 _subtractedValue
232   )
233     public
234     returns (bool)
235   {
236     uint256 oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue >= oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 
249 /**
250  * @title SafeERC20
251  * @dev Wrappers around ERC20 operations that throw on failure.
252  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
253  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
254  */
255 library SafeERC20 {
256   function safeTransfer(
257     ERC20 _token,
258     address _to,
259     uint256 _value
260   )
261     internal
262   {
263     require(_token.transfer(_to, _value));
264   }
265 
266   function safeTransferFrom(
267     ERC20 _token,
268     address _from,
269     address _to,
270     uint256 _value
271   )
272     internal
273   {
274     require(_token.transferFrom(_from, _to, _value));
275   }
276 
277   function safeApprove(
278     ERC20 _token,
279     address _spender,
280     uint256 _value
281   )
282     internal
283   {
284     require(_token.approve(_spender, _value));
285   }
286 }
287 
288 
289 contract NmxToken is StandardToken {
290 
291   string public constant name = "Numex";
292   string public constant symbol = "NMX";
293   uint8 public constant decimals = 18;
294 
295   uint256 public constant INITIAL_SUPPLY = 1500000 * (10 ** uint256(decimals));
296 
297   /**
298    * @dev Constructor that gives msg.sender all of existing tokens.
299    */
300   constructor() public {
301     totalSupply_ = INITIAL_SUPPLY;
302     balances[msg.sender] = INITIAL_SUPPLY;
303     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
304   }
305 }
306 
307 
308 /**
309  * @title Crowdsale
310  * @dev Crowdsale is a base contract for managing a token crowdsale,
311  * allowing investors to purchase tokens with ether. This contract implements
312  * such functionality in its most fundamental form and can be extended to provide additional
313  * functionality and/or custom behavior.
314  * The external interface represents the basic interface for purchasing tokens, and conform
315  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
316  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
317  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
318  * behavior.
319  */
320 contract Crowdsale {
321   using SafeMath for uint256;
322   using SafeERC20 for ERC20;
323 
324   // The token being sold
325   ERC20 public token;
326 
327   // Address where funds are collected
328   address public wallet;
329 
330   // How many token units a buyer gets per wei.
331   // The rate is the conversion between wei and the smallest and indivisible token unit.
332   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
333   // 1 wei will give you 1 unit, or 0.001 TOK.
334   uint256 public rate;
335 
336   // Amount of wei raised
337   uint256 public weiRaised;
338 
339   /**
340    * Event for token purchase logging
341    * @param purchaser who paid for the tokens
342    * @param beneficiary who got the tokens
343    * @param value weis paid for purchase
344    * @param amount amount of tokens purchased
345    */
346   event TokenPurchase(
347     address indexed purchaser,
348     address indexed beneficiary,
349     uint256 value,
350     uint256 amount
351   );
352 
353   /**
354    * @param _rate Number of token units a buyer gets per wei
355    * @param _wallet Address where collected funds will be forwarded to
356    * @param _token Address of the token being sold
357    */
358   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
359     require(_rate > 0);
360     require(_wallet != address(0));
361     require(_token != address(0));
362 
363     rate = _rate;
364     wallet = _wallet;
365     token = _token;
366   }
367 
368   // -----------------------------------------
369   // Crowdsale external interface
370   // -----------------------------------------
371 
372   /**
373    * @dev fallback function ***DO NOT OVERRIDE***
374    */
375   function () external payable {
376     buyTokens(msg.sender);
377   }
378 
379   /**
380    * @dev low level token purchase ***DO NOT OVERRIDE***
381    * @param _beneficiary Address performing the token purchase
382    */
383   function buyTokens(address _beneficiary) public payable {
384 
385     uint256 weiAmount = msg.value;
386     _preValidatePurchase(_beneficiary, weiAmount);
387 
388     // calculate token amount to be created
389     uint256 tokens = _getTokenAmount(weiAmount);
390 
391     // update state
392     weiRaised = weiRaised.add(weiAmount);
393 
394     _processPurchase(_beneficiary, tokens);
395     emit TokenPurchase(
396       msg.sender,
397       _beneficiary,
398       weiAmount,
399       tokens
400     );
401 
402     _updatePurchasingState(_beneficiary, weiAmount);
403 
404     _forwardFunds();
405     _postValidatePurchase(_beneficiary, weiAmount);
406   }
407 
408   // -----------------------------------------
409   // Internal interface (extensible)
410   // -----------------------------------------
411 
412   /**
413    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
414    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
415    *   super._preValidatePurchase(_beneficiary, _weiAmount);
416    *   require(weiRaised.add(_weiAmount) <= cap);
417    * @param _beneficiary Address performing the token purchase
418    * @param _weiAmount Value in wei involved in the purchase
419    */
420   function _preValidatePurchase(
421     address _beneficiary,
422     uint256 _weiAmount
423   )
424     internal
425   {
426     require(_beneficiary != address(0));
427     require(_weiAmount != 0);
428   }
429 
430   /**
431    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
432    * @param _beneficiary Address performing the token purchase
433    * @param _weiAmount Value in wei involved in the purchase
434    */
435   function _postValidatePurchase(
436     address _beneficiary,
437     uint256 _weiAmount
438   )
439     internal
440   {
441     // optional override
442   }
443 
444   /**
445    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
446    * @param _beneficiary Address performing the token purchase
447    * @param _tokenAmount Number of tokens to be emitted
448    */
449   function _deliverTokens(
450     address _beneficiary,
451     uint256 _tokenAmount
452   )
453     internal
454   {
455     token.safeTransfer(_beneficiary, _tokenAmount);
456   }
457 
458   /**
459    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
460    * @param _beneficiary Address receiving the tokens
461    * @param _tokenAmount Number of tokens to be purchased
462    */
463   function _processPurchase(
464     address _beneficiary,
465     uint256 _tokenAmount
466   )
467     internal
468   {
469     _deliverTokens(_beneficiary, _tokenAmount);
470   }
471 
472   /**
473    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
474    * @param _beneficiary Address receiving the tokens
475    * @param _weiAmount Value in wei involved in the purchase
476    */
477   function _updatePurchasingState(
478     address _beneficiary,
479     uint256 _weiAmount
480   )
481     internal
482   {
483     // optional override
484   }
485 
486   /**
487    * @dev Override to extend the way in which ether is converted to tokens.
488    * @param _weiAmount Value in wei to be converted into tokens
489    * @return Number of tokens that can be purchased with the specified _weiAmount
490    */
491   function _getTokenAmount(uint256 _weiAmount)
492     internal view returns (uint256)
493   {
494     return _weiAmount.mul(rate);
495   }
496 
497   /**
498    * @dev Determines how ETH is stored/forwarded on purchases.
499    */
500   function _forwardFunds() internal {
501     wallet.transfer(msg.value);
502   }
503 }
504 
505 
506 /**
507  * @title TimedCrowdsale
508  * @dev Crowdsale accepting contributions only within a time frame.
509  */
510 contract TimedCrowdsale is Crowdsale {
511   using SafeMath for uint256;
512 
513   uint256 public openingTime;
514   uint256 public closingTime;
515 
516   /**
517    * @dev Reverts if not in crowdsale time range.
518    */
519   modifier onlyWhileOpen {
520     // solium-disable-next-line security/no-block-members
521     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
522     _;
523   }
524 
525   /**
526    * @dev Constructor, takes crowdsale opening and closing times.
527    * @param _openingTime Crowdsale opening time
528    * @param _closingTime Crowdsale closing time
529    */
530   constructor(uint256 _openingTime, uint256 _closingTime) public {
531     // solium-disable-next-line security/no-block-members
532     require(_openingTime >= block.timestamp);
533     require(_closingTime >= _openingTime);
534 
535     openingTime = _openingTime;
536     closingTime = _closingTime;
537   }
538 
539   /**
540    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
541    * @return Whether crowdsale period has elapsed
542    */
543   function hasClosed() public view returns (bool) {
544     // solium-disable-next-line security/no-block-members
545     return block.timestamp > closingTime;
546   }
547 
548   /**
549    * @dev Extend parent behavior requiring to be within contributing period
550    * @param _beneficiary Token purchaser
551    * @param _weiAmount Amount of wei contributed
552    */
553   function _preValidatePurchase(
554     address _beneficiary,
555     uint256 _weiAmount
556   )
557     internal
558     onlyWhileOpen
559   {
560     super._preValidatePurchase(_beneficiary, _weiAmount);
561   }
562 
563 }
564 
565 
566 /**
567  * @title AllowanceCrowdsale
568  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
569  */
570 contract AllowanceCrowdsale is Crowdsale {
571   using SafeMath for uint256;
572   using SafeERC20 for ERC20;
573 
574   address public tokenWallet;
575 
576   /**
577    * @dev Constructor, takes token wallet address.
578    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
579    */
580   constructor(address _tokenWallet) public {
581     require(_tokenWallet != address(0));
582     tokenWallet = _tokenWallet;
583   }
584 
585   /**
586    * @dev Checks the amount of tokens left in the allowance.
587    * @return Amount of tokens left in the allowance
588    */
589   function remainingTokens() public view returns (uint256) {
590     return token.allowance(tokenWallet, this);
591   }
592 
593   /**
594    * @dev Overrides parent behavior by transferring tokens from wallet.
595    * @param _beneficiary Token purchaser
596    * @param _tokenAmount Amount of tokens purchased
597    */
598   function _deliverTokens(
599     address _beneficiary,
600     uint256 _tokenAmount
601   )
602     internal
603   {
604     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
605   }
606 }
607 
608 
609 /**
610  * @title IncreasingPriceCrowdsale
611  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
612  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
613  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
614  */
615 contract IncreasingPriceCrowdsale is TimedCrowdsale {
616   using SafeMath for uint256;
617 
618   uint256 public initialRate;
619   uint256 public finalRate;
620 
621   /**
622    * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
623    * @param _initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
624    * @param _finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
625    */
626   constructor(uint256 _initialRate, uint256 _finalRate) public {
627     require(_initialRate >= _finalRate);
628     require(_finalRate > 0);
629     initialRate = _initialRate;
630     finalRate = _finalRate;
631   }
632 
633   /**
634    * @dev Returns the rate of tokens per wei at the present time.
635    * Note that, as price _increases_ with time, the rate _decreases_.
636    * @return The number of tokens a buyer gets per wei at a given time
637    */
638   function getCurrentRate() public view returns (uint256) {
639     // solium-disable-next-line security/no-block-members
640     uint256 elapsedTime = block.timestamp.sub(openingTime);
641     uint256 timeRange = closingTime.sub(openingTime);
642     uint256 rateRange = initialRate.sub(finalRate);
643     return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
644   }
645 
646   /**
647    * @dev Overrides parent method taking into account variable rate.
648    * @param _weiAmount The value in wei to be converted into tokens
649    * @return The number of tokens _weiAmount wei will buy at present time
650    */
651   function _getTokenAmount(uint256 _weiAmount)
652     internal view returns (uint256)
653   {
654     uint256 currentRate = getCurrentRate();
655     return currentRate.mul(_weiAmount);
656   }
657 
658 }
659 
660 
661 /**
662  * @title NmxCrowdsale
663  * TimedCrowdsale - sets a time boundary for raising funds
664  * AllowanceCrowdsale - allows to purchase tokens from external wallet
665  */
666 contract NmxCrowdsale is AllowanceCrowdsale, IncreasingPriceCrowdsale {
667 
668   // solium-disable-next-line max-len
669   event CrowdsaleCreated(address owner, uint256 openingTime, uint256 closingTime, uint256 rate);
670 
671   /**
672    * @param _openingTime  time in Unix epoch - opening the crowdsale
673    * @param _closingTime  time in Unix epoch - closing the crowdsale
674    * @param _rate         how many tokens per 1 Ether in first stage
675    * @param _ratePublic   how many tokens per 1 Ether in last stage
676    * @param _wallet       wallet to collect Ether
677    * @param _token        ERC20 token to put on sale
678    * @param _tokenHolder  address of the token holder - to approve crowdsale
679    */
680   constructor(
681     uint256 _openingTime,
682     uint256 _closingTime,
683     uint256 _rate,
684     uint256 _ratePublic,
685     address _wallet,
686     StandardToken _token,
687     address _tokenHolder
688   )
689     public
690     Crowdsale(_rate, _wallet, _token)
691     AllowanceCrowdsale(_tokenHolder)
692     TimedCrowdsale(_openingTime, _closingTime)
693     IncreasingPriceCrowdsale(_rate, _ratePublic)
694   {
695     emit CrowdsaleCreated(
696       msg.sender, 
697       _openingTime, 
698       _closingTime, 
699       _rate);
700   }
701 
702   /**
703   * There are only 2 rates: private and public - equally long
704   */
705   function getCurrentRate() public view returns (uint256) {
706     // solium-disable-next-line security/no-block-members
707     uint256 elapsedTime = block.timestamp.sub(openingTime);
708     uint256 timeRange = closingTime.sub(openingTime);
709     if (elapsedTime < timeRange.div(2)) {
710       return initialRate;
711     } else {
712       return finalRate;
713     }
714   }
715 }