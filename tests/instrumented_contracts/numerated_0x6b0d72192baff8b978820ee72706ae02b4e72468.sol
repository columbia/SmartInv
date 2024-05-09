1 pragma solidity ^0.4.21;
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
308 // File: contracts/JcnxxxToken.sol
309 
310 contract JcnxxxToken is MintableToken {
311 
312 	string public name = "JCN Token";
313 	string public symbol = "JCNXXX";
314 	uint8 public decimals = 18;
315 }
316 
317 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
318 
319 /**
320  * @title Crowdsale
321  * @dev Crowdsale is a base contract for managing a token crowdsale,
322  * allowing investors to purchase tokens with ether. This contract implements
323  * such functionality in its most fundamental form and can be extended to provide additional
324  * functionality and/or custom behavior.
325  * The external interface represents the basic interface for purchasing tokens, and conform
326  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
327  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
328  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
329  * behavior.
330  */
331 contract Crowdsale {
332   using SafeMath for uint256;
333 
334   // The token being sold
335   ERC20 public token;
336 
337   // Address where funds are collected
338   address public wallet;
339 
340   // How many token units a buyer gets per wei
341   uint256 public rate;
342 
343   // Amount of wei raised
344   uint256 public weiRaised;
345 
346   /**
347    * Event for token purchase logging
348    * @param purchaser who paid for the tokens
349    * @param beneficiary who got the tokens
350    * @param value weis paid for purchase
351    * @param amount amount of tokens purchased
352    */
353   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
354 
355   /**
356    * @param _rate Number of token units a buyer gets per wei
357    * @param _wallet Address where collected funds will be forwarded to
358    * @param _token Address of the token being sold
359    */
360   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
361     require(_rate > 0);
362     require(_wallet != address(0));
363     require(_token != address(0));
364 
365     rate = _rate;
366     wallet = _wallet;
367     token = _token;
368   }
369 
370   // -----------------------------------------
371   // Crowdsale external interface
372   // -----------------------------------------
373 
374   /**
375    * @dev fallback function ***DO NOT OVERRIDE***
376    */
377   function () external payable {
378     buyTokens(msg.sender);
379   }
380 
381   /**
382    * @dev low level token purchase ***DO NOT OVERRIDE***
383    * @param _beneficiary Address performing the token purchase
384    */
385   function buyTokens(address _beneficiary) public payable {
386 
387     uint256 weiAmount = msg.value;
388     _preValidatePurchase(_beneficiary, weiAmount);
389 
390     // calculate token amount to be created
391     uint256 tokens = _getTokenAmount(weiAmount);
392 
393     // update state
394     weiRaised = weiRaised.add(weiAmount);
395 
396     _processPurchase(_beneficiary, tokens);
397     emit TokenPurchase(
398       msg.sender,
399       _beneficiary,
400       weiAmount,
401       tokens
402     );
403 
404     _updatePurchasingState(_beneficiary, weiAmount);
405 
406     _forwardFunds();
407     _postValidatePurchase(_beneficiary, weiAmount);
408   }
409 
410   // -----------------------------------------
411   // Internal interface (extensible)
412   // -----------------------------------------
413 
414   /**
415    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
416    * @param _beneficiary Address performing the token purchase
417    * @param _weiAmount Value in wei involved in the purchase
418    */
419   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
420     require(_beneficiary != address(0));
421     require(_weiAmount != 0);
422   }
423 
424   /**
425    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
426    * @param _beneficiary Address performing the token purchase
427    * @param _weiAmount Value in wei involved in the purchase
428    */
429   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
430     // optional override
431   }
432 
433   /**
434    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
435    * @param _beneficiary Address performing the token purchase
436    * @param _tokenAmount Number of tokens to be emitted
437    */
438   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
439     token.transfer(_beneficiary, _tokenAmount);
440   }
441 
442   /**
443    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
444    * @param _beneficiary Address receiving the tokens
445    * @param _tokenAmount Number of tokens to be purchased
446    */
447   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
448     _deliverTokens(_beneficiary, _tokenAmount);
449   }
450 
451   /**
452    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
453    * @param _beneficiary Address receiving the tokens
454    * @param _weiAmount Value in wei involved in the purchase
455    */
456   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
457     // optional override
458   }
459 
460   /**
461    * @dev Override to extend the way in which ether is converted to tokens.
462    * @param _weiAmount Value in wei to be converted into tokens
463    * @return Number of tokens that can be purchased with the specified _weiAmount
464    */
465   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
466     return _weiAmount.mul(rate);
467   }
468 
469   /**
470    * @dev Determines how ETH is stored/forwarded on purchases.
471    */
472   function _forwardFunds() internal {
473     wallet.transfer(msg.value);
474   }
475 }
476 
477 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
478 
479 /**
480  * @title TimedCrowdsale
481  * @dev Crowdsale accepting contributions only within a time frame.
482  */
483 contract TimedCrowdsale is Crowdsale {
484   using SafeMath for uint256;
485 
486   uint256 public openingTime;
487   uint256 public closingTime;
488 
489   /**
490    * @dev Reverts if not in crowdsale time range.
491    */
492   modifier onlyWhileOpen {
493     // solium-disable-next-line security/no-block-members
494     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
495     _;
496   }
497 
498   /**
499    * @dev Constructor, takes crowdsale opening and closing times.
500    * @param _openingTime Crowdsale opening time
501    * @param _closingTime Crowdsale closing time
502    */
503   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
504     // solium-disable-next-line security/no-block-members
505     require(_openingTime >= block.timestamp);
506     require(_closingTime >= _openingTime);
507 
508     openingTime = _openingTime;
509     closingTime = _closingTime;
510   }
511 
512   /**
513    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
514    * @return Whether crowdsale period has elapsed
515    */
516   function hasClosed() public view returns (bool) {
517     // solium-disable-next-line security/no-block-members
518     return block.timestamp > closingTime;
519   }
520 
521   /**
522    * @dev Extend parent behavior requiring to be within contributing period
523    * @param _beneficiary Token purchaser
524    * @param _weiAmount Amount of wei contributed
525    */
526   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
527     super._preValidatePurchase(_beneficiary, _weiAmount);
528   }
529 
530 }
531 
532 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
533 
534 /**
535  * @title FinalizableCrowdsale
536  * @dev Extension of Crowdsale where an owner can do extra work
537  * after finishing.
538  */
539 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
540   using SafeMath for uint256;
541 
542   bool public isFinalized = false;
543 
544   event Finalized();
545 
546   /**
547    * @dev Must be called after crowdsale ends, to do some extra finalization
548    * work. Calls the contract's finalization function.
549    */
550   function finalize() onlyOwner public {
551     require(!isFinalized);
552     require(hasClosed());
553 
554     finalization();
555     emit Finalized();
556 
557     isFinalized = true;
558   }
559 
560   /**
561    * @dev Can be overridden to add finalization logic. The overriding function
562    * should call super.finalization() to ensure the chain of finalization is
563    * executed entirely.
564    */
565   function finalization() internal {
566   }
567 
568 }
569 
570 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
571 
572 /**
573  * @title MintedCrowdsale
574  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
575  * Token ownership should be transferred to MintedCrowdsale for minting. 
576  */
577 contract MintedCrowdsale is Crowdsale {
578 
579   /**
580    * @dev Overrides delivery by minting tokens upon purchase.
581    * @param _beneficiary Token purchaser
582    * @param _tokenAmount Number of tokens to be minted
583    */
584   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
585     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
586   }
587 }
588 
589 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
590 
591 /**
592  * @title CappedCrowdsale
593  * @dev Crowdsale with a limit for total contributions.
594  */
595 contract CappedCrowdsale is Crowdsale {
596   using SafeMath for uint256;
597 
598   uint256 public cap;
599 
600   /**
601    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
602    * @param _cap Max amount of wei to be contributed
603    */
604   function CappedCrowdsale(uint256 _cap) public {
605     require(_cap > 0);
606     cap = _cap;
607   }
608 
609   /**
610    * @dev Checks whether the cap has been reached. 
611    * @return Whether the cap was reached
612    */
613   function capReached() public view returns (bool) {
614     return weiRaised >= cap;
615   }
616 
617   /**
618    * @dev Extend parent behavior requiring purchase to respect the funding cap.
619    * @param _beneficiary Token purchaser
620    * @param _weiAmount Amount of wei contributed
621    */
622   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
623     super._preValidatePurchase(_beneficiary, _weiAmount);
624     require(weiRaised.add(_weiAmount) <= cap);
625   }
626 
627 }
628 
629 // File: contracts/JcnxxxCrowdsale.sol
630 
631 contract JcnxxxCrowdsale is FinalizableCrowdsale, MintedCrowdsale, CappedCrowdsale {
632 
633 	uint256 public constant FOUNDERS_SHARE = 30000000 * (10 ** uint256(18));	//30 Million
634 	uint256 public constant RESERVE_FUND = 15000000 * (10 ** uint256(18));		//15 Million
635 	uint256 public constant CONTENT_FUND = 5000000 * (10 ** uint256(18));		//5 Million
636 	uint256 public constant BOUNTY_FUND = 5000000 * (10 ** uint256(18));		//5 Million
637 	uint256 public constant HARD_CAP = 100000000 * (10 ** uint256(18));			//100 Million
638 
639 	// ICO phases structure
640 	enum IcoPhases { PrivateSale, EarlyBirdPresale, Presale, EarlyBirdCrowdsale, FullCrowdsale }
641 	struct Phase {
642 		uint256 startTime;
643 		uint256 endTime;
644 		uint256 minimum;	//in wei
645 		uint8 bonus;
646 	}
647 	mapping (uint => Phase) ico;
648 
649 	//constructor
650 	function JcnxxxCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, MintableToken _token) public
651 	CappedCrowdsale(HARD_CAP.div(_rate))
652 	FinalizableCrowdsale()
653 	MintedCrowdsale()
654 	TimedCrowdsale(_openingTime, _closingTime)
655 	Crowdsale(_rate, _wallet, _token) 
656 	{       
657 		//define the ICO phases (date/time in GMT+2)
658 
659 		//2018-07-09 11:00, 2018-09-15 10:59, 10.0 ether 50%
660 		ico[uint(IcoPhases.PrivateSale)] = Phase(1531126800, 1537001999, 10000000000000000000, 50);	
661 
662 		//2018-09-15 11:00, 2018-09-25 10:59, 0.75 ether 25%
663 		ico[uint(IcoPhases.EarlyBirdPresale)] = Phase(1537002000, 1537865999, 750000000000000000, 25);	
664 		
665 		//2018-09-25 11:00, 2018-10-05 10:59, 0.5 ether 15%
666 		ico[uint(IcoPhases.Presale)] = Phase(1537866000, 1538729999, 500000000000000000, 15);
667 		
668 		//2018-10-05 11:00, 2018-10-15 10:59, 0.25 ether 5%
669 		ico[uint(IcoPhases.EarlyBirdCrowdsale)] = Phase(1538730000, 1539593999, 250000000000000000, 5);
670 		
671 		//2018-10-15 11:00, 2018-11-15 10:59, 0.001 ether 2%
672 		ico[uint(IcoPhases.FullCrowdsale)] = Phase(1539594000, 1542275999, 1000000000000000, 2);
673 	}
674 
675 	/**
676 	 * @dev Called to mint the reserved tokens
677 	 */
678 	function mintReservedTokens() onlyOwner public {
679 
680 		//mint the reserved tokens
681 		uint256 reserved_tokens = FOUNDERS_SHARE.add(RESERVE_FUND).add(CONTENT_FUND).add(BOUNTY_FUND);
682 		require(MintableToken(token).mint(wallet, reserved_tokens));
683 	}
684 
685 	/**
686 	 * @dev Called to do an airdrop
687 	 * @param _to list of addresses to send tokens to.
688 	 * @param _value list of amount of tokens to send to the addresses.
689 	 */
690 	function airdrop(address[] _to, uint256[] _value) onlyOwner public returns (bool) {
691 
692 		//make sure we have a value for each address and that its a max of 100 addresses otherwise gas limit will be reached
693 		//and of course that the crowdsale has not been finalized yet
694 		require(!isFinalized);
695 		require(_to.length == _value.length);
696         require(_to.length <= 100);
697 
698         // loop through to addresses and send value
699         for(uint8 i = 0; i < _to.length; i++) {
700             require(MintableToken(token).mint(_to[i], (_value[i].mul((10 ** uint256(18))))) == true);
701         }
702         return true;
703 	}
704 
705 	// -----------------------------------------
706 	// Overrides
707 	// -----------------------------------------
708 
709 	/**
710  	 * @dev Extend parent behavior requiring purchase to respect the minimum of the current phase.
711 	 * @param _beneficiary Address performing the token purchase
712 	 * @param _weiAmount Value in wei involved in the purchase
713 	 */
714 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
715 		super._preValidatePurchase(_beneficiary, _weiAmount);
716 
717 		//get the minimum
718 		uint256 minimum = _currentIcoPhaseMinimum();
719 
720 		//make sure the minimum is met
721 		require(_weiAmount >= minimum);
722 	}
723 
724 	/**
725 	 * @dev Override to extend the way in which ether is converted to tokens.
726 	 * @param _weiAmount Value in wei to be converted into tokens
727 	 * @return Number of tokens that can be purchased with the specified _weiAmount
728 	 */
729 	function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
730 
731 		uint256 tokens = _weiAmount.mul(rate);
732 
733 		//determine the bonus
734 		uint bonus = _currentIcoPhaseBonus();
735 
736 		//tokens = tokens + ((tokens * bonus)/100);
737 		return tokens.add((tokens.mul(bonus)).div(100));
738 	}
739 
740 	/**
741 	 * @dev Override to make sure we mint the rest of the tokens that were not purchased.
742 	 * should call super.finalization() to ensure the chain of finalization is
743 	 * executed entirely.
744 	 */
745 	function finalization() internal {
746 
747 		uint256 _tokenAmount = HARD_CAP.sub(token.totalSupply());
748 		require(MintableToken(token).mint(wallet, _tokenAmount));
749 
750 		super.finalization();
751 	}
752 
753 	// -----------------------------------------
754 	// Internal interface
755 	// -----------------------------------------
756 
757 	//function to find out what is the current ICO phase bonus 
758 	function _currentIcoPhaseBonus() public view returns (uint8) {
759 
760 		for (uint i = 0; i < 5; i++) {
761 			if(ico[i].startTime <= now && ico[i].endTime >= now){
762 				return ico[i].bonus;
763 			}
764 		}
765 		return 0;	//not currently in any phase, ICO most likely finished or not started, 0% bonus
766 	}
767 
768 	//function to find out what is the current ICO phase minimum 
769 	function _currentIcoPhaseMinimum() public view returns (uint256) {
770 
771 		for (uint i = 0; i < 5; i++) {
772 			if(ico[i].startTime <= now && ico[i].endTime >= now){
773 				return ico[i].minimum;
774 			}
775 		}
776 		return 0;	//not currently in any phase, ICO most likely finished or not started, 0 minimum
777 	}
778 }