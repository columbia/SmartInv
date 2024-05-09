1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
286 
287 /**
288  * @title TimedCrowdsale
289  * @dev Crowdsale accepting contributions only within a time frame.
290  */
291 contract TimedCrowdsale is Crowdsale {
292   using SafeMath for uint256;
293 
294   uint256 public openingTime;
295   uint256 public closingTime;
296 
297   /**
298    * @dev Reverts if not in crowdsale time range.
299    */
300   modifier onlyWhileOpen {
301     // solium-disable-next-line security/no-block-members
302     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
303     _;
304   }
305 
306   /**
307    * @dev Constructor, takes crowdsale opening and closing times.
308    * @param _openingTime Crowdsale opening time
309    * @param _closingTime Crowdsale closing time
310    */
311   constructor(uint256 _openingTime, uint256 _closingTime) public {
312     // solium-disable-next-line security/no-block-members
313     require(_openingTime >= block.timestamp);
314     require(_closingTime >= _openingTime);
315 
316     openingTime = _openingTime;
317     closingTime = _closingTime;
318   }
319 
320   /**
321    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
322    * @return Whether crowdsale period has elapsed
323    */
324   function hasClosed() public view returns (bool) {
325     // solium-disable-next-line security/no-block-members
326     return block.timestamp > closingTime;
327   }
328 
329   /**
330    * @dev Extend parent behavior requiring to be within contributing period
331    * @param _beneficiary Token purchaser
332    * @param _weiAmount Amount of wei contributed
333    */
334   function _preValidatePurchase(
335     address _beneficiary,
336     uint256 _weiAmount
337   )
338     internal
339     onlyWhileOpen
340   {
341     super._preValidatePurchase(_beneficiary, _weiAmount);
342   }
343 
344 }
345 
346 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
347 
348 /**
349  * @title CappedCrowdsale
350  * @dev Crowdsale with a limit for total contributions.
351  */
352 contract CappedCrowdsale is Crowdsale {
353   using SafeMath for uint256;
354 
355   uint256 public cap;
356 
357   /**
358    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
359    * @param _cap Max amount of wei to be contributed
360    */
361   constructor(uint256 _cap) public {
362     require(_cap > 0);
363     cap = _cap;
364   }
365 
366   /**
367    * @dev Checks whether the cap has been reached.
368    * @return Whether the cap was reached
369    */
370   function capReached() public view returns (bool) {
371     return weiRaised >= cap;
372   }
373 
374   /**
375    * @dev Extend parent behavior requiring purchase to respect the funding cap.
376    * @param _beneficiary Token purchaser
377    * @param _weiAmount Amount of wei contributed
378    */
379   function _preValidatePurchase(
380     address _beneficiary,
381     uint256 _weiAmount
382   )
383     internal
384   {
385     super._preValidatePurchase(_beneficiary, _weiAmount);
386     require(weiRaised.add(_weiAmount) <= cap);
387   }
388 
389 }
390 
391 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
392 
393 /**
394  * @title Basic token
395  * @dev Basic version of StandardToken, with no allowances.
396  */
397 contract BasicToken is ERC20Basic {
398   using SafeMath for uint256;
399 
400   mapping(address => uint256) balances;
401 
402   uint256 totalSupply_;
403 
404   /**
405   * @dev total number of tokens in existence
406   */
407   function totalSupply() public view returns (uint256) {
408     return totalSupply_;
409   }
410 
411   /**
412   * @dev transfer token for a specified address
413   * @param _to The address to transfer to.
414   * @param _value The amount to be transferred.
415   */
416   function transfer(address _to, uint256 _value) public returns (bool) {
417     require(_to != address(0));
418     require(_value <= balances[msg.sender]);
419 
420     balances[msg.sender] = balances[msg.sender].sub(_value);
421     balances[_to] = balances[_to].add(_value);
422     emit Transfer(msg.sender, _to, _value);
423     return true;
424   }
425 
426   /**
427   * @dev Gets the balance of the specified address.
428   * @param _owner The address to query the the balance of.
429   * @return An uint256 representing the amount owned by the passed address.
430   */
431   function balanceOf(address _owner) public view returns (uint256) {
432     return balances[_owner];
433   }
434 
435 }
436 
437 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
438 
439 /**
440  * @title Standard ERC20 token
441  *
442  * @dev Implementation of the basic standard token.
443  * @dev https://github.com/ethereum/EIPs/issues/20
444  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
445  */
446 contract StandardToken is ERC20, BasicToken {
447 
448   mapping (address => mapping (address => uint256)) internal allowed;
449 
450 
451   /**
452    * @dev Transfer tokens from one address to another
453    * @param _from address The address which you want to send tokens from
454    * @param _to address The address which you want to transfer to
455    * @param _value uint256 the amount of tokens to be transferred
456    */
457   function transferFrom(
458     address _from,
459     address _to,
460     uint256 _value
461   )
462     public
463     returns (bool)
464   {
465     require(_to != address(0));
466     require(_value <= balances[_from]);
467     require(_value <= allowed[_from][msg.sender]);
468 
469     balances[_from] = balances[_from].sub(_value);
470     balances[_to] = balances[_to].add(_value);
471     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
472     emit Transfer(_from, _to, _value);
473     return true;
474   }
475 
476   /**
477    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
478    *
479    * Beware that changing an allowance with this method brings the risk that someone may use both the old
480    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
481    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
482    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
483    * @param _spender The address which will spend the funds.
484    * @param _value The amount of tokens to be spent.
485    */
486   function approve(address _spender, uint256 _value) public returns (bool) {
487     allowed[msg.sender][_spender] = _value;
488     emit Approval(msg.sender, _spender, _value);
489     return true;
490   }
491 
492   /**
493    * @dev Function to check the amount of tokens that an owner allowed to a spender.
494    * @param _owner address The address which owns the funds.
495    * @param _spender address The address which will spend the funds.
496    * @return A uint256 specifying the amount of tokens still available for the spender.
497    */
498   function allowance(
499     address _owner,
500     address _spender
501    )
502     public
503     view
504     returns (uint256)
505   {
506     return allowed[_owner][_spender];
507   }
508 
509   /**
510    * @dev Increase the amount of tokens that an owner allowed to a spender.
511    *
512    * approve should be called when allowed[_spender] == 0. To increment
513    * allowed value is better to use this function to avoid 2 calls (and wait until
514    * the first transaction is mined)
515    * From MonolithDAO Token.sol
516    * @param _spender The address which will spend the funds.
517    * @param _addedValue The amount of tokens to increase the allowance by.
518    */
519   function increaseApproval(
520     address _spender,
521     uint _addedValue
522   )
523     public
524     returns (bool)
525   {
526     allowed[msg.sender][_spender] = (
527       allowed[msg.sender][_spender].add(_addedValue));
528     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
529     return true;
530   }
531 
532   /**
533    * @dev Decrease the amount of tokens that an owner allowed to a spender.
534    *
535    * approve should be called when allowed[_spender] == 0. To decrement
536    * allowed value is better to use this function to avoid 2 calls (and wait until
537    * the first transaction is mined)
538    * From MonolithDAO Token.sol
539    * @param _spender The address which will spend the funds.
540    * @param _subtractedValue The amount of tokens to decrease the allowance by.
541    */
542   function decreaseApproval(
543     address _spender,
544     uint _subtractedValue
545   )
546     public
547     returns (bool)
548   {
549     uint oldValue = allowed[msg.sender][_spender];
550     if (_subtractedValue > oldValue) {
551       allowed[msg.sender][_spender] = 0;
552     } else {
553       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
554     }
555     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
556     return true;
557   }
558 
559 }
560 
561 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
562 
563 /**
564  * @title Ownable
565  * @dev The Ownable contract has an owner address, and provides basic authorization control
566  * functions, this simplifies the implementation of "user permissions".
567  */
568 contract Ownable {
569   address public owner;
570 
571 
572   event OwnershipRenounced(address indexed previousOwner);
573   event OwnershipTransferred(
574     address indexed previousOwner,
575     address indexed newOwner
576   );
577 
578 
579   /**
580    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
581    * account.
582    */
583   constructor() public {
584     owner = msg.sender;
585   }
586 
587   /**
588    * @dev Throws if called by any account other than the owner.
589    */
590   modifier onlyOwner() {
591     require(msg.sender == owner);
592     _;
593   }
594 
595   /**
596    * @dev Allows the current owner to relinquish control of the contract.
597    */
598   function renounceOwnership() public onlyOwner {
599     emit OwnershipRenounced(owner);
600     owner = address(0);
601   }
602 
603   /**
604    * @dev Allows the current owner to transfer control of the contract to a newOwner.
605    * @param _newOwner The address to transfer ownership to.
606    */
607   function transferOwnership(address _newOwner) public onlyOwner {
608     _transferOwnership(_newOwner);
609   }
610 
611   /**
612    * @dev Transfers control of the contract to a newOwner.
613    * @param _newOwner The address to transfer ownership to.
614    */
615   function _transferOwnership(address _newOwner) internal {
616     require(_newOwner != address(0));
617     emit OwnershipTransferred(owner, _newOwner);
618     owner = _newOwner;
619   }
620 }
621 
622 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
623 
624 /**
625  * @title Mintable token
626  * @dev Simple ERC20 Token example, with mintable token creation
627  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
628  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
629  */
630 contract MintableToken is StandardToken, Ownable {
631   event Mint(address indexed to, uint256 amount);
632   event MintFinished();
633 
634   bool public mintingFinished = false;
635 
636 
637   modifier canMint() {
638     require(!mintingFinished);
639     _;
640   }
641 
642   modifier hasMintPermission() {
643     require(msg.sender == owner);
644     _;
645   }
646 
647   /**
648    * @dev Function to mint tokens
649    * @param _to The address that will receive the minted tokens.
650    * @param _amount The amount of tokens to mint.
651    * @return A boolean that indicates if the operation was successful.
652    */
653   function mint(
654     address _to,
655     uint256 _amount
656   )
657     hasMintPermission
658     canMint
659     public
660     returns (bool)
661   {
662     totalSupply_ = totalSupply_.add(_amount);
663     balances[_to] = balances[_to].add(_amount);
664     emit Mint(_to, _amount);
665     emit Transfer(address(0), _to, _amount);
666     return true;
667   }
668 
669   /**
670    * @dev Function to stop minting new tokens.
671    * @return True if the operation was successful.
672    */
673   function finishMinting() onlyOwner canMint public returns (bool) {
674     mintingFinished = true;
675     emit MintFinished();
676     return true;
677   }
678 }
679 
680 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
681 
682 /**
683  * @title MintedCrowdsale
684  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
685  * Token ownership should be transferred to MintedCrowdsale for minting.
686  */
687 contract MintedCrowdsale is Crowdsale {
688 
689   /**
690    * @dev Overrides delivery by minting tokens upon purchase.
691    * @param _beneficiary Token purchaser
692    * @param _tokenAmount Number of tokens to be minted
693    */
694   function _deliverTokens(
695     address _beneficiary,
696     uint256 _tokenAmount
697   )
698     internal
699   {
700     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
701   }
702 }
703 
704 // File: contracts/TestCrowdsale.sol
705 
706 interface MintableERC20 {
707     function finishMinting() public returns (bool);
708 }
709 
710 contract TestCrowdsale is Crowdsale, TimedCrowdsale, CappedCrowdsale, MintedCrowdsale {
711     bool public isFinalized = false;
712 
713     event Finalized();
714     constructor
715     (
716         uint256 _rate,
717         address _wallet,
718         ERC20 _token,
719         uint256 _openingTime,
720         uint256 _closingTime,
721         uint256 _cap
722     ) 
723         Crowdsale(_rate, _wallet, _token)
724         TimedCrowdsale(_openingTime, _closingTime)
725         CappedCrowdsale(_cap)
726         public
727     {
728 
729     }
730 
731     function finalize() public {
732         require(!isFinalized);
733         require(hasClosed() || capReached());
734 
735         finalization();
736         emit Finalized();
737 
738         isFinalized = true;
739     }
740 
741 
742     function finalization() internal {
743         MintableERC20 mintableToken = MintableERC20(token);
744         mintableToken.finishMinting();  
745     }
746 
747 }