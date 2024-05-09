1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender)
119     public view returns (uint256);
120 
121   function transferFrom(address from, address to, uint256 value)
122     public returns (bool);
123 
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(
152     address _from,
153     address _to,
154     uint256 _value
155   )
156     public
157     returns (bool)
158   {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     emit Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(
193     address _owner,
194     address _spender
195    )
196     public
197     view
198     returns (uint256)
199   {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(
214     address _spender,
215     uint _addedValue
216   )
217     public
218     returns (bool)
219   {
220     allowed[msg.sender][_spender] = (
221       allowed[msg.sender][_spender].add(_addedValue));
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(
237     address _spender,
238     uint _subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     uint oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue > oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 
256 /**
257  * @title Ownable
258  * @dev The Ownable contract has an owner address, and provides basic authorization control
259  * functions, this simplifies the implementation of "user permissions".
260  */
261 contract Ownable {
262   address public owner;
263 
264 
265   event OwnershipRenounced(address indexed previousOwner);
266   event OwnershipTransferred(
267     address indexed previousOwner,
268     address indexed newOwner
269   );
270 
271 
272   /**
273    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274    * account.
275    */
276   constructor() public {
277     owner = msg.sender;
278   }
279 
280   /**
281    * @dev Throws if called by any account other than the owner.
282    */
283   modifier onlyOwner() {
284     require(msg.sender == owner);
285     _;
286   }
287 
288   /**
289    * @dev Allows the current owner to relinquish control of the contract.
290    */
291   function renounceOwnership() public onlyOwner {
292     emit OwnershipRenounced(owner);
293     owner = address(0);
294   }
295 
296   /**
297    * @dev Allows the current owner to transfer control of the contract to a newOwner.
298    * @param _newOwner The address to transfer ownership to.
299    */
300   function transferOwnership(address _newOwner) public onlyOwner {
301     _transferOwnership(_newOwner);
302   }
303 
304   /**
305    * @dev Transfers control of the contract to a newOwner.
306    * @param _newOwner The address to transfer ownership to.
307    */
308   function _transferOwnership(address _newOwner) internal {
309     require(_newOwner != address(0));
310     emit OwnershipTransferred(owner, _newOwner);
311     owner = _newOwner;
312   }
313 }
314 
315 
316 /**
317  * @title Mintable token
318  * @dev Simple ERC20 Token example, with mintable token creation
319  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
320  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
321  */
322 contract MintableToken is StandardToken, Ownable {
323   event Mint(address indexed to, uint256 amount);
324   event MintFinished();
325 
326   bool public mintingFinished = false;
327 
328 
329   modifier canMint() {
330     require(!mintingFinished);
331     _;
332   }
333 
334   modifier hasMintPermission() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will receive the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(
346     address _to,
347     uint256 _amount
348   )
349     hasMintPermission
350     canMint
351     public
352     returns (bool)
353   {
354     totalSupply_ = totalSupply_.add(_amount);
355     balances[_to] = balances[_to].add(_amount);
356     emit Mint(_to, _amount);
357     emit Transfer(address(0), _to, _amount);
358     return true;
359   }
360 
361   /**
362    * @dev Function to stop minting new tokens.
363    * @return True if the operation was successful.
364    */
365   function finishMinting() onlyOwner canMint public returns (bool) {
366     mintingFinished = true;
367     emit MintFinished();
368     return true;
369   }
370 }
371 
372 
373 /**
374  * @title Crowdsale
375  * @dev Crowdsale is a base contract for managing a token crowdsale,
376  * allowing investors to purchase tokens with ether. This contract implements
377  * such functionality in its most fundamental form and can be extended to provide additional
378  * functionality and/or custom behavior.
379  * The external interface represents the basic interface for purchasing tokens, and conform
380  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
381  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
382  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
383  * behavior.
384  */
385 contract Crowdsale {
386   using SafeMath for uint256;
387 
388   // The token being sold
389   ERC20 public token;
390 
391   // Address where funds are collected
392   address public wallet;
393 
394   // How many token units a buyer gets per wei.
395   // The rate is the conversion between wei and the smallest and indivisible token unit.
396   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
397   // 1 wei will give you 1 unit, or 0.001 TOK.
398   uint256 public rate;
399 
400   // Amount of wei raised
401   uint256 public weiRaised;
402 
403   /**
404    * Event for token purchase logging
405    * @param purchaser who paid for the tokens
406    * @param beneficiary who got the tokens
407    * @param value weis paid for purchase
408    * @param amount amount of tokens purchased
409    */
410   event TokenPurchase(
411     address indexed purchaser,
412     address indexed beneficiary,
413     uint256 value,
414     uint256 amount
415   );
416 
417   /**
418    * @param _rate Number of token units a buyer gets per wei
419    * @param _wallet Address where collected funds will be forwarded to
420    * @param _token Address of the token being sold
421    */
422   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
423     require(_rate > 0);
424     require(_wallet != address(0));
425     require(_token != address(0));
426 
427     rate = _rate;
428     wallet = _wallet;
429     token = _token;
430   }
431 
432   // -----------------------------------------
433   // Crowdsale external interface
434   // -----------------------------------------
435 
436   /**
437    * @dev fallback function ***DO NOT OVERRIDE***
438    */
439   function () external payable {
440     buyTokens(msg.sender);
441   }
442 
443   /**
444    * @dev low level token purchase ***DO NOT OVERRIDE***
445    * @param _beneficiary Address performing the token purchase
446    */
447   function buyTokens(address _beneficiary) public payable {
448 
449     uint256 weiAmount = msg.value;
450     _preValidatePurchase(_beneficiary, weiAmount);
451 
452     // calculate token amount to be created
453     uint256 tokens = _getTokenAmount(weiAmount);
454 
455     // update state
456     weiRaised = weiRaised.add(weiAmount);
457 
458     _processPurchase(_beneficiary, tokens);
459     emit TokenPurchase(
460       msg.sender,
461       _beneficiary,
462       weiAmount,
463       tokens
464     );
465 
466     _updatePurchasingState(_beneficiary, weiAmount);
467 
468     _forwardFunds();
469     _postValidatePurchase(_beneficiary, weiAmount);
470   }
471 
472   // -----------------------------------------
473   // Internal interface (extensible)
474   // -----------------------------------------
475 
476   /**
477    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
478    * @param _beneficiary Address performing the token purchase
479    * @param _weiAmount Value in wei involved in the purchase
480    */
481   function _preValidatePurchase(
482     address _beneficiary,
483     uint256 _weiAmount
484   )
485     internal
486   {
487     require(_beneficiary != address(0));
488     require(_weiAmount != 0);
489   }
490 
491   /**
492    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
493    * @param _beneficiary Address performing the token purchase
494    * @param _weiAmount Value in wei involved in the purchase
495    */
496   function _postValidatePurchase(
497     address _beneficiary,
498     uint256 _weiAmount
499   )
500     internal
501   {
502     // optional override
503   }
504 
505   /**
506    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
507    * @param _beneficiary Address performing the token purchase
508    * @param _tokenAmount Number of tokens to be emitted
509    */
510   function _deliverTokens(
511     address _beneficiary,
512     uint256 _tokenAmount
513   )
514     internal
515   {
516     token.transfer(_beneficiary, _tokenAmount);
517   }
518 
519   /**
520    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
521    * @param _beneficiary Address receiving the tokens
522    * @param _tokenAmount Number of tokens to be purchased
523    */
524   function _processPurchase(
525     address _beneficiary,
526     uint256 _tokenAmount
527   )
528     internal
529   {
530     _deliverTokens(_beneficiary, _tokenAmount);
531   }
532 
533   /**
534    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
535    * @param _beneficiary Address receiving the tokens
536    * @param _weiAmount Value in wei involved in the purchase
537    */
538   function _updatePurchasingState(
539     address _beneficiary,
540     uint256 _weiAmount
541   )
542     internal
543   {
544     // optional override
545   }
546 
547   /**
548    * @dev Override to extend the way in which ether is converted to tokens.
549    * @param _weiAmount Value in wei to be converted into tokens
550    * @return Number of tokens that can be purchased with the specified _weiAmount
551    */
552   function _getTokenAmount(uint256 _weiAmount)
553     internal view returns (uint256)
554   {
555     return _weiAmount.mul(rate);
556   }
557 
558   /**
559    * @dev Determines how ETH is stored/forwarded on purchases.
560    */
561   function _forwardFunds() internal {
562     wallet.transfer(msg.value);
563   }
564 }
565 
566 
567 /**
568  * @title AllowanceCrowdsale
569  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
570  */
571 contract AllowanceCrowdsale is Crowdsale {
572   using SafeMath for uint256;
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
604     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
605   }
606 }
607 
608 
609 /**
610  * @title WhitelistedCrowdsale
611  * @dev Crowdsale in which only whitelisted users can contribute.
612  */
613 contract WhitelistedCrowdsale is Crowdsale, Ownable {
614 
615   mapping(address => bool) public whitelist;
616 
617   /**
618    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
619    */
620   modifier isWhitelisted(address _beneficiary) {
621     require(whitelist[_beneficiary]);
622     _;
623   }
624 
625   /**
626    * @dev Adds single address to whitelist.
627    * @param _beneficiary Address to be added to the whitelist
628    */
629   function addToWhitelist(address _beneficiary) external onlyOwner {
630     whitelist[_beneficiary] = true;
631   }
632 
633   /**
634    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
635    * @param _beneficiaries Addresses to be added to the whitelist
636    */
637   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
638     for (uint256 i = 0; i < _beneficiaries.length; i++) {
639       whitelist[_beneficiaries[i]] = true;
640     }
641   }
642 
643   /**
644    * @dev Removes single address from whitelist.
645    * @param _beneficiary Address to be removed to the whitelist
646    */
647   function removeFromWhitelist(address _beneficiary) external onlyOwner {
648     whitelist[_beneficiary] = false;
649   }
650 
651   /**
652    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
653    * @param _beneficiary Token beneficiary
654    * @param _weiAmount Amount of wei contributed
655    */
656   function _preValidatePurchase(
657     address _beneficiary,
658     uint256 _weiAmount
659   )
660     internal
661     isWhitelisted(_beneficiary)
662   {
663     super._preValidatePurchase(_beneficiary, _weiAmount);
664   }
665 
666 }
667 
668 
669 contract ContracoinSale is Crowdsale, AllowanceCrowdsale, WhitelistedCrowdsale {
670   bool public isFinalized = false;
671 
672   constructor(
673     uint _rate,
674     address _wallet,
675     MintableToken _token,
676     address _tokenWallet
677   )
678     Crowdsale(_rate, _wallet, _token)
679     AllowanceCrowdsale(_tokenWallet)
680     public
681   {
682   }
683 
684   /**
685   * @dev Allows admin to update the crowdsale rate
686   * @param _rate Crowdsale rate
687   */
688   function setRate(uint _rate) public onlyOwner {
689     rate = _rate;
690   }
691 
692   /**
693    * @dev Extend parent behavior requiring to be within contributing period
694    * @param _beneficiary Token purchaser
695    * @param _weiAmount Amount of wei contributed
696    */
697   function _preValidatePurchase(
698     address _beneficiary,
699     uint256 _weiAmount
700   )
701     internal
702     onlyWhileOpen
703   {
704     super._preValidatePurchase(_beneficiary, _weiAmount);
705   }
706 
707   /**
708    * @dev Reverts if not in crowdsale time range.
709    */
710   modifier onlyWhileOpen {
711     require(!isFinalized);
712     _;
713   }
714 
715   /**
716   * @dev Allows admin to finalize the crowdsale
717   */
718   function finalize() public onlyOwner {
719     require(!isFinalized);
720     isFinalized = true;
721   }
722 
723 }