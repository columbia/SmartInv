1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
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
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    * @notice Renouncing to ownership will leave the contract without an owner.
95    * It will not be possible to call the functions with the `onlyOwner`
96    * modifier anymore.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that throw on error
127  */
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, throws on overflow.
132   */
133   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
134     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
135     // benefit is lost if 'b' is also tested.
136     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137     if (a == 0) {
138       return 0;
139     }
140 
141     c = a * b;
142     assert(c / a == b);
143     return c;
144   }
145 
146   /**
147   * @dev Integer division of two numbers, truncating the quotient.
148   */
149   function div(uint256 a, uint256 b) internal pure returns (uint256) {
150     // assert(b > 0); // Solidity automatically throws when dividing by 0
151     // uint256 c = a / b;
152     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153     return a / b;
154   }
155 
156   /**
157   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
158   */
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     assert(b <= a);
161     return a - b;
162   }
163 
164   /**
165   * @dev Adds two numbers, throws on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
168     c = a + b;
169     assert(c >= a);
170     return c;
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181   using SafeMath for uint256;
182 
183   mapping(address => uint256) balances;
184 
185   uint256 totalSupply_;
186 
187   /**
188   * @dev Total number of tokens in existence
189   */
190   function totalSupply() public view returns (uint256) {
191     return totalSupply_;
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[msg.sender]);
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * https://github.com/ethereum/EIPs/issues/20
227  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(
241     address _from,
242     address _to,
243     uint256 _value
244   )
245     public
246     returns (bool)
247   {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     emit Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    * Beware that changing an allowance with this method brings the risk that someone may use both the old
262    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265    * @param _spender The address which will spend the funds.
266    * @param _value The amount of tokens to be spent.
267    */
268   function approve(address _spender, uint256 _value) public returns (bool) {
269     allowed[msg.sender][_spender] = _value;
270     emit Approval(msg.sender, _spender, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Function to check the amount of tokens that an owner allowed to a spender.
276    * @param _owner address The address which owns the funds.
277    * @param _spender address The address which will spend the funds.
278    * @return A uint256 specifying the amount of tokens still available for the spender.
279    */
280   function allowance(
281     address _owner,
282     address _spender
283    )
284     public
285     view
286     returns (uint256)
287   {
288     return allowed[_owner][_spender];
289   }
290 
291   /**
292    * @dev Increase the amount of tokens that an owner allowed to a spender.
293    * approve should be called when allowed[_spender] == 0. To increment
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _addedValue The amount of tokens to increase the allowance by.
299    */
300   function increaseApproval(
301     address _spender,
302     uint256 _addedValue
303   )
304     public
305     returns (bool)
306   {
307     allowed[msg.sender][_spender] = (
308       allowed[msg.sender][_spender].add(_addedValue));
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Decrease the amount of tokens that an owner allowed to a spender.
315    * approve should be called when allowed[_spender] == 0. To decrement
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _subtractedValue The amount of tokens to decrease the allowance by.
321    */
322   function decreaseApproval(
323     address _spender,
324     uint256 _subtractedValue
325   )
326     public
327     returns (bool)
328   {
329     uint256 oldValue = allowed[msg.sender][_spender];
330     if (_subtractedValue > oldValue) {
331       allowed[msg.sender][_spender] = 0;
332     } else {
333       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334     }
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339 }
340 
341 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     hasMintPermission
376     canMint
377     public
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() onlyOwner canMint public returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: contracts/PartnerToken.sol
399 
400 contract PartnerToken is MintableToken, DetailedERC20 {
401   string public _name = "SuperPartner";
402   string public _symbol = "SPX";
403   uint8 public _decimals = 0;
404 
405   constructor() DetailedERC20(_name, _symbol, _decimals) public {
406 
407   }
408 }
409 
410 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure.
415  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
420     require(token.transfer(to, value));
421   }
422 
423   function safeTransferFrom(
424     ERC20 token,
425     address from,
426     address to,
427     uint256 value
428   )
429     internal
430   {
431     require(token.transferFrom(from, to, value));
432   }
433 
434   function safeApprove(ERC20 token, address spender, uint256 value) internal {
435     require(token.approve(spender, value));
436   }
437 }
438 
439 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
440 
441 /**
442  * @title Crowdsale
443  * @dev Crowdsale is a base contract for managing a token crowdsale,
444  * allowing investors to purchase tokens with ether. This contract implements
445  * such functionality in its most fundamental form and can be extended to provide additional
446  * functionality and/or custom behavior.
447  * The external interface represents the basic interface for purchasing tokens, and conform
448  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
449  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
450  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
451  * behavior.
452  */
453 contract Crowdsale {
454   using SafeMath for uint256;
455   using SafeERC20 for ERC20;
456 
457   // The token being sold
458   ERC20 public token;
459 
460   // Address where funds are collected
461   address public wallet;
462 
463   // How many token units a buyer gets per wei.
464   // The rate is the conversion between wei and the smallest and indivisible token unit.
465   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
466   // 1 wei will give you 1 unit, or 0.001 TOK.
467   uint256 public rate;
468 
469   // Amount of wei raised
470   uint256 public weiRaised;
471 
472   /**
473    * Event for token purchase logging
474    * @param purchaser who paid for the tokens
475    * @param beneficiary who got the tokens
476    * @param value weis paid for purchase
477    * @param amount amount of tokens purchased
478    */
479   event TokenPurchase(
480     address indexed purchaser,
481     address indexed beneficiary,
482     uint256 value,
483     uint256 amount
484   );
485 
486   /**
487    * @param _rate Number of token units a buyer gets per wei
488    * @param _wallet Address where collected funds will be forwarded to
489    * @param _token Address of the token being sold
490    */
491   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
492     require(_rate > 0);
493     require(_wallet != address(0));
494     require(_token != address(0));
495 
496     rate = _rate;
497     wallet = _wallet;
498     token = _token;
499   }
500 
501   // -----------------------------------------
502   // Crowdsale external interface
503   // -----------------------------------------
504 
505   /**
506    * @dev fallback function ***DO NOT OVERRIDE***
507    */
508   function () external payable {
509     buyTokens(msg.sender);
510   }
511 
512   /**
513    * @dev low level token purchase ***DO NOT OVERRIDE***
514    * @param _beneficiary Address performing the token purchase
515    */
516   function buyTokens(address _beneficiary) public payable {
517 
518     uint256 weiAmount = msg.value;
519     _preValidatePurchase(_beneficiary, weiAmount);
520 
521     // calculate token amount to be created
522     uint256 tokens = _getTokenAmount(weiAmount);
523 
524     // update state
525     weiRaised = weiRaised.add(weiAmount);
526 
527     _processPurchase(_beneficiary, tokens);
528     emit TokenPurchase(
529       msg.sender,
530       _beneficiary,
531       weiAmount,
532       tokens
533     );
534 
535     _updatePurchasingState(_beneficiary, weiAmount);
536 
537     _forwardFunds();
538     _postValidatePurchase(_beneficiary, weiAmount);
539   }
540 
541   // -----------------------------------------
542   // Internal interface (extensible)
543   // -----------------------------------------
544 
545   /**
546    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
547    * @param _beneficiary Address performing the token purchase
548    * @param _weiAmount Value in wei involved in the purchase
549    */
550   function _preValidatePurchase(
551     address _beneficiary,
552     uint256 _weiAmount
553   )
554     internal
555   {
556     require(_beneficiary != address(0));
557     require(_weiAmount != 0);
558   }
559 
560   /**
561    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
562    * @param _beneficiary Address performing the token purchase
563    * @param _weiAmount Value in wei involved in the purchase
564    */
565   function _postValidatePurchase(
566     address _beneficiary,
567     uint256 _weiAmount
568   )
569     internal
570   {
571     // optional override
572   }
573 
574   /**
575    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
576    * @param _beneficiary Address performing the token purchase
577    * @param _tokenAmount Number of tokens to be emitted
578    */
579   function _deliverTokens(
580     address _beneficiary,
581     uint256 _tokenAmount
582   )
583     internal
584   {
585     token.safeTransfer(_beneficiary, _tokenAmount);
586   }
587 
588   /**
589    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
590    * @param _beneficiary Address receiving the tokens
591    * @param _tokenAmount Number of tokens to be purchased
592    */
593   function _processPurchase(
594     address _beneficiary,
595     uint256 _tokenAmount
596   )
597     internal
598   {
599     _deliverTokens(_beneficiary, _tokenAmount);
600   }
601 
602   /**
603    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
604    * @param _beneficiary Address receiving the tokens
605    * @param _weiAmount Value in wei involved in the purchase
606    */
607   function _updatePurchasingState(
608     address _beneficiary,
609     uint256 _weiAmount
610   )
611     internal
612   {
613     // optional override
614   }
615 
616   /**
617    * @dev Override to extend the way in which ether is converted to tokens.
618    * @param _weiAmount Value in wei to be converted into tokens
619    * @return Number of tokens that can be purchased with the specified _weiAmount
620    */
621   function _getTokenAmount(uint256 _weiAmount)
622     internal view returns (uint256)
623   {
624     return _weiAmount.mul(rate);
625   }
626 
627   /**
628    * @dev Determines how ETH is stored/forwarded on purchases.
629    */
630   function _forwardFunds() internal {
631     wallet.transfer(msg.value);
632   }
633 }
634 
635 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
636 
637 /**
638  * @title MintedCrowdsale
639  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
640  * Token ownership should be transferred to MintedCrowdsale for minting.
641  */
642 contract MintedCrowdsale is Crowdsale {
643 
644   /**
645    * @dev Overrides delivery by minting tokens upon purchase.
646    * @param _beneficiary Token purchaser
647    * @param _tokenAmount Number of tokens to be minted
648    */
649   function _deliverTokens(
650     address _beneficiary,
651     uint256 _tokenAmount
652   )
653     internal
654   {
655     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
656   }
657 }
658 
659 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
660 
661 /**
662  * @title CappedCrowdsale
663  * @dev Crowdsale with a limit for total contributions.
664  */
665 contract CappedCrowdsale is Crowdsale {
666   using SafeMath for uint256;
667 
668   uint256 public cap;
669 
670   /**
671    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
672    * @param _cap Max amount of wei to be contributed
673    */
674   constructor(uint256 _cap) public {
675     require(_cap > 0);
676     cap = _cap;
677   }
678 
679   /**
680    * @dev Checks whether the cap has been reached.
681    * @return Whether the cap was reached
682    */
683   function capReached() public view returns (bool) {
684     return weiRaised >= cap;
685   }
686 
687   /**
688    * @dev Extend parent behavior requiring purchase to respect the funding cap.
689    * @param _beneficiary Token purchaser
690    * @param _weiAmount Amount of wei contributed
691    */
692   function _preValidatePurchase(
693     address _beneficiary,
694     uint256 _weiAmount
695   )
696     internal
697   {
698     super._preValidatePurchase(_beneficiary, _weiAmount);
699     require(weiRaised.add(_weiAmount) <= cap);
700   }
701 
702 }
703 
704 // File: contracts/SuperPartnerCrowdsale.sol
705 
706 contract SuperPartnerCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale {
707 
708   constructor(
709     uint256 _rate,
710     uint256 _cap,
711     address _wallet,
712     PartnerToken _token
713   ) public
714   Crowdsale(_rate, _wallet, _token)
715   CappedCrowdsale(_cap) {
716 
717   }
718 
719   // Accept only round ETH purchase
720   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
721     super._preValidatePurchase(_beneficiary, _weiAmount);
722     require(_weiAmount%(10**18)==0);
723   }
724 
725   // Override tokens amount as token has no decimal points and «_rate» not used
726   function _getTokenAmount(uint256 _weiAmount)
727     internal view returns (uint256) {
728     return _weiAmount/(10**18);
729   }
730 
731 }