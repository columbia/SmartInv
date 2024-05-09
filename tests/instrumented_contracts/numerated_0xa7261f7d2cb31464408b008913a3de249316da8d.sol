1 pragma solidity 0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 contract Pausable is Ownable {
315   event Pause();
316   event Unpause();
317 
318   bool public paused = false;
319 
320 
321   /**
322    * @dev Modifier to make a function callable only when the contract is not paused.
323    */
324   modifier whenNotPaused() {
325     require(!paused);
326     _;
327   }
328 
329   /**
330    * @dev Modifier to make a function callable only when the contract is paused.
331    */
332   modifier whenPaused() {
333     require(paused);
334     _;
335   }
336 
337   /**
338    * @dev called by the owner to pause, triggers stopped state
339    */
340   function pause() onlyOwner whenNotPaused public {
341     paused = true;
342     emit Pause();
343   }
344 
345   /**
346    * @dev called by the owner to unpause, returns to normal state
347    */
348   function unpause() onlyOwner whenPaused public {
349     paused = false;
350     emit Unpause();
351   }
352 }
353 
354 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
355 
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PausableToken is StandardToken, Pausable {
361 
362   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
363     return super.transfer(_to, _value);
364   }
365 
366   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
367     return super.transferFrom(_from, _to, _value);
368   }
369 
370   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
371     return super.approve(_spender, _value);
372   }
373 
374   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
375     return super.increaseApproval(_spender, _addedValue);
376   }
377 
378   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
379     return super.decreaseApproval(_spender, _subtractedValue);
380   }
381 }
382 
383 // File: contracts/UppsalaToken.sol
384 
385 contract UppsalaToken is MintableToken, PausableToken {
386 	string public constant name = 'SENTINEL PROTOCOL';
387 	string public constant  symbol = 'UPP';
388 	uint8 public constant decimals = 18;
389 }
390 
391 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
392 
393 /**
394  * @title Crowdsale
395  * @dev Crowdsale is a base contract for managing a token crowdsale,
396  * allowing investors to purchase tokens with ether. This contract implements
397  * such functionality in its most fundamental form and can be extended to provide additional
398  * functionality and/or custom behavior.
399  * The external interface represents the basic interface for purchasing tokens, and conform
400  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
401  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
402  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
403  * behavior.
404  */
405 contract Crowdsale {
406   using SafeMath for uint256;
407 
408   // The token being sold
409   ERC20 public token;
410 
411   // Address where funds are collected
412   address public wallet;
413 
414   // How many token units a buyer gets per wei
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
427   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
428 
429   /**
430    * @param _rate Number of token units a buyer gets per wei
431    * @param _wallet Address where collected funds will be forwarded to
432    * @param _token Address of the token being sold
433    */
434   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
435     require(_rate > 0);
436     require(_wallet != address(0));
437     require(_token != address(0));
438 
439     rate = _rate;
440     wallet = _wallet;
441     token = _token;
442   }
443 
444   // -----------------------------------------
445   // Crowdsale external interface
446   // -----------------------------------------
447 
448   /**
449    * @dev fallback function ***DO NOT OVERRIDE***
450    */
451   function () external payable {
452     buyTokens(msg.sender);
453   }
454 
455   /**
456    * @dev low level token purchase ***DO NOT OVERRIDE***
457    * @param _beneficiary Address performing the token purchase
458    */
459   function buyTokens(address _beneficiary) public payable {
460 
461     uint256 weiAmount = msg.value;
462     _preValidatePurchase(_beneficiary, weiAmount);
463 
464     // calculate token amount to be created
465     uint256 tokens = _getTokenAmount(weiAmount);
466 
467     // update state
468     weiRaised = weiRaised.add(weiAmount);
469 
470     _processPurchase(_beneficiary, tokens);
471     emit TokenPurchase(
472       msg.sender,
473       _beneficiary,
474       weiAmount,
475       tokens
476     );
477 
478     _updatePurchasingState(_beneficiary, weiAmount);
479 
480     _forwardFunds();
481     _postValidatePurchase(_beneficiary, weiAmount);
482   }
483 
484   // -----------------------------------------
485   // Internal interface (extensible)
486   // -----------------------------------------
487 
488   /**
489    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
490    * @param _beneficiary Address performing the token purchase
491    * @param _weiAmount Value in wei involved in the purchase
492    */
493   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
494     require(_beneficiary != address(0));
495     require(_weiAmount != 0);
496   }
497 
498   /**
499    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
500    * @param _beneficiary Address performing the token purchase
501    * @param _weiAmount Value in wei involved in the purchase
502    */
503   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
504     // optional override
505   }
506 
507   /**
508    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
509    * @param _beneficiary Address performing the token purchase
510    * @param _tokenAmount Number of tokens to be emitted
511    */
512   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
513     token.transfer(_beneficiary, _tokenAmount);
514   }
515 
516   /**
517    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
518    * @param _beneficiary Address receiving the tokens
519    * @param _tokenAmount Number of tokens to be purchased
520    */
521   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
522     _deliverTokens(_beneficiary, _tokenAmount);
523   }
524 
525   /**
526    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
527    * @param _beneficiary Address receiving the tokens
528    * @param _weiAmount Value in wei involved in the purchase
529    */
530   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
531     // optional override
532   }
533 
534   /**
535    * @dev Override to extend the way in which ether is converted to tokens.
536    * @param _weiAmount Value in wei to be converted into tokens
537    * @return Number of tokens that can be purchased with the specified _weiAmount
538    */
539   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
540     return _weiAmount.mul(rate);
541   }
542 
543   /**
544    * @dev Determines how ETH is stored/forwarded on purchases.
545    */
546   function _forwardFunds() internal {
547     wallet.transfer(msg.value);
548   }
549 }
550 
551 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
552 
553 /**
554  * @title CappedCrowdsale
555  * @dev Crowdsale with a limit for total contributions.
556  */
557 contract CappedCrowdsale is Crowdsale {
558   using SafeMath for uint256;
559 
560   uint256 public cap;
561 
562   /**
563    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
564    * @param _cap Max amount of wei to be contributed
565    */
566   function CappedCrowdsale(uint256 _cap) public {
567     require(_cap > 0);
568     cap = _cap;
569   }
570 
571   /**
572    * @dev Checks whether the cap has been reached. 
573    * @return Whether the cap was reached
574    */
575   function capReached() public view returns (bool) {
576     return weiRaised >= cap;
577   }
578 
579   /**
580    * @dev Extend parent behavior requiring purchase to respect the funding cap.
581    * @param _beneficiary Token purchaser
582    * @param _weiAmount Amount of wei contributed
583    */
584   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
585     super._preValidatePurchase(_beneficiary, _weiAmount);
586     require(weiRaised.add(_weiAmount) <= cap);
587   }
588 
589 }
590 
591 // File: contracts/UserMinMaxCrowdsale.sol
592 
593 contract UserMinMaxCrowdsale is Crowdsale, Ownable {
594   using SafeMath for uint256;
595 
596 	uint256 public min;
597   uint256 public max;
598 
599 	mapping(address => uint256) public contributions;
600 
601 	function UserMinMaxCrowdsale(uint256 _min, uint256 _max) public {
602 		require(_min > 0);
603 		require(_max > _min);
604 		// each person should contribute between min-max amount of wei
605 		min = _min;
606 		max = _max;
607 	}
608 
609 	function getUserContribution(address _beneficiary) public view returns (uint256) {
610     return contributions[_beneficiary];
611   }
612 
613   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
614     super._preValidatePurchase(_beneficiary, _weiAmount);
615     require(contributions[_beneficiary].add(_weiAmount) <= max);
616 		require(contributions[_beneficiary].add(_weiAmount) >= min);
617   }
618 
619 	function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
620 		super._updatePurchasingState(_beneficiary, _weiAmount);
621 		// update total contribution
622 		contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
623 	}
624 }
625 
626 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
627 
628 /**
629  * @title TimedCrowdsale
630  * @dev Crowdsale accepting contributions only within a time frame.
631  */
632 contract TimedCrowdsale is Crowdsale {
633   using SafeMath for uint256;
634 
635   uint256 public openingTime;
636   uint256 public closingTime;
637 
638   /**
639    * @dev Reverts if not in crowdsale time range.
640    */
641   modifier onlyWhileOpen {
642     // solium-disable-next-line security/no-block-members
643     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
644     _;
645   }
646 
647   /**
648    * @dev Constructor, takes crowdsale opening and closing times.
649    * @param _openingTime Crowdsale opening time
650    * @param _closingTime Crowdsale closing time
651    */
652   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
653     // solium-disable-next-line security/no-block-members
654     require(_openingTime >= block.timestamp);
655     require(_closingTime >= _openingTime);
656 
657     openingTime = _openingTime;
658     closingTime = _closingTime;
659   }
660 
661   /**
662    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
663    * @return Whether crowdsale period has elapsed
664    */
665   function hasClosed() public view returns (bool) {
666     // solium-disable-next-line security/no-block-members
667     return block.timestamp > closingTime;
668   }
669 
670   /**
671    * @dev Extend parent behavior requiring to be within contributing period
672    * @param _beneficiary Token purchaser
673    * @param _weiAmount Amount of wei contributed
674    */
675   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
676     super._preValidatePurchase(_beneficiary, _weiAmount);
677   }
678 
679 }
680 
681 // File: zeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
682 
683 /**
684  * @title WhitelistedCrowdsale
685  * @dev Crowdsale in which only whitelisted users can contribute.
686  */
687 contract WhitelistedCrowdsale is Crowdsale, Ownable {
688 
689   mapping(address => bool) public whitelist;
690 
691   /**
692    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
693    */
694   modifier isWhitelisted(address _beneficiary) {
695     require(whitelist[_beneficiary]);
696     _;
697   }
698 
699   /**
700    * @dev Adds single address to whitelist.
701    * @param _beneficiary Address to be added to the whitelist
702    */
703   function addToWhitelist(address _beneficiary) external onlyOwner {
704     whitelist[_beneficiary] = true;
705   }
706 
707   /**
708    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
709    * @param _beneficiaries Addresses to be added to the whitelist
710    */
711   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
712     for (uint256 i = 0; i < _beneficiaries.length; i++) {
713       whitelist[_beneficiaries[i]] = true;
714     }
715   }
716 
717   /**
718    * @dev Removes single address from whitelist.
719    * @param _beneficiary Address to be removed to the whitelist
720    */
721   function removeFromWhitelist(address _beneficiary) external onlyOwner {
722     whitelist[_beneficiary] = false;
723   }
724 
725   /**
726    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
727    * @param _beneficiary Token beneficiary
728    * @param _weiAmount Amount of wei contributed
729    */
730   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
731     super._preValidatePurchase(_beneficiary, _weiAmount);
732   }
733 
734 }
735 
736 // File: contracts/UppsalaCrowdsale.sol
737 
738 contract UppsalaCrowdsale is WhitelistedCrowdsale, UserMinMaxCrowdsale, CappedCrowdsale,
739 TimedCrowdsale, Pausable {
740   using SafeMath for uint256;
741 
742   uint256 public withdrawTime;
743   mapping(address => uint256) public balances;
744   
745   function UppsalaCrowdsale(uint256 rate, 
746                             uint256 openTime, 
747                             uint256 closeTime, 
748                             uint256 totalCap,
749                             uint256 userMin,
750                             uint256 userMax,
751                             uint256 _withdrawTime,
752                             address account,
753                             StandardToken token)
754            Crowdsale(rate, account, token)
755            TimedCrowdsale(openTime, closeTime)
756            CappedCrowdsale(totalCap)
757            UserMinMaxCrowdsale(userMin, userMax) public
758   {
759     require(_withdrawTime > block.timestamp);
760     withdrawTime = _withdrawTime;
761   }
762 
763   function withdrawTokens(address _beneficiary) public {
764     require(block.timestamp > withdrawTime);
765     uint256 amount = balances[_beneficiary];
766     require(amount > 0);
767     balances[_beneficiary] = 0;
768     _deliverTokens(_beneficiary, amount);
769   }
770 
771   function _processPurchase(
772     address _beneficiary,
773     uint256 _tokenAmount
774   )
775     internal
776   {
777     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
778   }
779 
780   function buyTokens(address beneficiary) public payable whenNotPaused {
781     // limiting gas price
782     require(tx.gasprice <= 50000000000 wei);
783     // limiting gas limt up to around 200000-210000
784     require(msg.gas <= 190000);
785     super.buyTokens(beneficiary);
786   }
787 }