1 pragma solidity ^0.4.24;
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
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
261 
262 /**
263  * @title Ownable
264  * @dev The Ownable contract has an owner address, and provides basic authorization control
265  * functions, this simplifies the implementation of "user permissions".
266  */
267 contract Ownable {
268   address public owner;
269 
270 
271   event OwnershipRenounced(address indexed previousOwner);
272   event OwnershipTransferred(
273     address indexed previousOwner,
274     address indexed newOwner
275   );
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   constructor() public {
283     owner = msg.sender;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(msg.sender == owner);
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to relinquish control of the contract.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
380 
381 /**
382  * @title Crowdsale
383  * @dev Crowdsale is a base contract for managing a token crowdsale,
384  * allowing investors to purchase tokens with ether. This contract implements
385  * such functionality in its most fundamental form and can be extended to provide additional
386  * functionality and/or custom behavior.
387  * The external interface represents the basic interface for purchasing tokens, and conform
388  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
389  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
390  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
391  * behavior.
392  */
393 contract Crowdsale {
394   using SafeMath for uint256;
395 
396   // The token being sold
397   ERC20 public token;
398 
399   // Address where funds are collected
400   address public wallet;
401 
402   // How many token units a buyer gets per wei.
403   // The rate is the conversion between wei and the smallest and indivisible token unit.
404   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
405   // 1 wei will give you 1 unit, or 0.001 TOK.
406   uint256 public rate;
407 
408   // Amount of wei raised
409   uint256 public weiRaised;
410 
411   /**
412    * Event for token purchase logging
413    * @param purchaser who paid for the tokens
414    * @param beneficiary who got the tokens
415    * @param value weis paid for purchase
416    * @param amount amount of tokens purchased
417    */
418   event TokenPurchase(
419     address indexed purchaser,
420     address indexed beneficiary,
421     uint256 value,
422     uint256 amount
423   );
424 
425   /**
426    * @param _rate Number of token units a buyer gets per wei
427    * @param _wallet Address where collected funds will be forwarded to
428    * @param _token Address of the token being sold
429    */
430   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
431     require(_rate > 0);
432     require(_wallet != address(0));
433     require(_token != address(0));
434 
435     rate = _rate;
436     wallet = _wallet;
437     token = _token;
438   }
439 
440   // -----------------------------------------
441   // Crowdsale external interface
442   // -----------------------------------------
443 
444   /**
445    * @dev fallback function ***DO NOT OVERRIDE***
446    */
447   function () external payable {
448     buyTokens(msg.sender);
449   }
450 
451   /**
452    * @dev low level token purchase ***DO NOT OVERRIDE***
453    * @param _beneficiary Address performing the token purchase
454    */
455   function buyTokens(address _beneficiary) public payable {
456 
457     uint256 weiAmount = msg.value;
458     _preValidatePurchase(_beneficiary, weiAmount);
459 
460     // calculate token amount to be created
461     uint256 tokens = _getTokenAmount(weiAmount);
462 
463     // update state
464     weiRaised = weiRaised.add(weiAmount);
465 
466     _processPurchase(_beneficiary, tokens);
467     emit TokenPurchase(
468       msg.sender,
469       _beneficiary,
470       weiAmount,
471       tokens
472     );
473 
474     _updatePurchasingState(_beneficiary, weiAmount);
475 
476     _forwardFunds();
477     _postValidatePurchase(_beneficiary, weiAmount);
478   }
479 
480   // -----------------------------------------
481   // Internal interface (extensible)
482   // -----------------------------------------
483 
484   /**
485    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
486    * @param _beneficiary Address performing the token purchase
487    * @param _weiAmount Value in wei involved in the purchase
488    */
489   function _preValidatePurchase(
490     address _beneficiary,
491     uint256 _weiAmount
492   )
493     internal
494   {
495     require(_beneficiary != address(0));
496     require(_weiAmount != 0);
497   }
498 
499   /**
500    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
501    * @param _beneficiary Address performing the token purchase
502    * @param _weiAmount Value in wei involved in the purchase
503    */
504   function _postValidatePurchase(
505     address _beneficiary,
506     uint256 _weiAmount
507   )
508     internal
509   {
510     // optional override
511   }
512 
513   /**
514    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
515    * @param _beneficiary Address performing the token purchase
516    * @param _tokenAmount Number of tokens to be emitted
517    */
518   function _deliverTokens(
519     address _beneficiary,
520     uint256 _tokenAmount
521   )
522     internal
523   {
524     token.transfer(_beneficiary, _tokenAmount);
525   }
526 
527   /**
528    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
529    * @param _beneficiary Address receiving the tokens
530    * @param _tokenAmount Number of tokens to be purchased
531    */
532   function _processPurchase(
533     address _beneficiary,
534     uint256 _tokenAmount
535   )
536     internal
537   {
538     _deliverTokens(_beneficiary, _tokenAmount);
539   }
540 
541   /**
542    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
543    * @param _beneficiary Address receiving the tokens
544    * @param _weiAmount Value in wei involved in the purchase
545    */
546   function _updatePurchasingState(
547     address _beneficiary,
548     uint256 _weiAmount
549   )
550     internal
551   {
552     // optional override
553   }
554 
555   /**
556    * @dev Override to extend the way in which ether is converted to tokens.
557    * @param _weiAmount Value in wei to be converted into tokens
558    * @return Number of tokens that can be purchased with the specified _weiAmount
559    */
560   function _getTokenAmount(uint256 _weiAmount)
561     internal view returns (uint256)
562   {
563     return _weiAmount.mul(rate);
564   }
565 
566   /**
567    * @dev Determines how ETH is stored/forwarded on purchases.
568    */
569   function _forwardFunds() internal {
570     wallet.transfer(msg.value);
571   }
572 }
573 
574 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
575 
576 /**
577  * @title MintedCrowdsale
578  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
579  * Token ownership should be transferred to MintedCrowdsale for minting.
580  */
581 contract MintedCrowdsale is Crowdsale {
582 
583   /**
584    * @dev Overrides delivery by minting tokens upon purchase.
585    * @param _beneficiary Token purchaser
586    * @param _tokenAmount Number of tokens to be minted
587    */
588   function _deliverTokens(
589     address _beneficiary,
590     uint256 _tokenAmount
591   )
592     internal
593   {
594     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
595   }
596 }
597 
598 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
599 
600 /**
601  * @title WhitelistedCrowdsale
602  * @dev Crowdsale in which only whitelisted users can contribute.
603  */
604 contract WhitelistedCrowdsale is Crowdsale, Ownable {
605 
606   mapping(address => bool) public whitelist;
607 
608   /**
609    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
610    */
611   modifier isWhitelisted(address _beneficiary) {
612     require(whitelist[_beneficiary]);
613     _;
614   }
615 
616   /**
617    * @dev Adds single address to whitelist.
618    * @param _beneficiary Address to be added to the whitelist
619    */
620   function addToWhitelist(address _beneficiary) external onlyOwner {
621     whitelist[_beneficiary] = true;
622   }
623 
624   /**
625    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
626    * @param _beneficiaries Addresses to be added to the whitelist
627    */
628   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
629     for (uint256 i = 0; i < _beneficiaries.length; i++) {
630       whitelist[_beneficiaries[i]] = true;
631     }
632   }
633 
634   /**
635    * @dev Removes single address from whitelist.
636    * @param _beneficiary Address to be removed to the whitelist
637    */
638   function removeFromWhitelist(address _beneficiary) external onlyOwner {
639     whitelist[_beneficiary] = false;
640   }
641 
642   /**
643    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
644    * @param _beneficiary Token beneficiary
645    * @param _weiAmount Amount of wei contributed
646    */
647   function _preValidatePurchase(
648     address _beneficiary,
649     uint256 _weiAmount
650   )
651     internal
652     isWhitelisted(_beneficiary)
653   {
654     super._preValidatePurchase(_beneficiary, _weiAmount);
655   }
656 
657 }
658 
659 // File: contracts/ContracoinPresale.sol
660 
661 contract ContracoinPresale is Crowdsale, MintedCrowdsale, WhitelistedCrowdsale {
662   bool public isFinalized = false;
663 
664   constructor(
665     uint _rate,
666     address _wallet,
667     MintableToken _token
668   )
669     Crowdsale(_rate, _wallet, _token)
670     public
671   {
672   }
673 
674   /**
675   * @dev Allows admin to mint tokens
676   * @param _beneficiary token benneficiary
677   * @param _tokenAmount Number of tokens
678   */
679   function mintTokens(
680     address _beneficiary,
681     uint256 _tokenAmount
682   )
683     public
684     onlyOwner
685   {
686     _deliverTokens(_beneficiary, _tokenAmount);
687   }
688 
689   /**
690   * @dev Allows admin to update the crowdsale rate
691   * @param _rate Crowdsale rate
692   */
693   function setRate(uint _rate) public onlyOwner {
694     rate = _rate;
695   }
696 
697   /**
698    * @dev Extend parent behavior requiring to be within contributing period
699    * @param _beneficiary Token purchaser
700    * @param _weiAmount Amount of wei contributed
701    */
702   function _preValidatePurchase(
703     address _beneficiary,
704     uint256 _weiAmount
705   )
706     internal
707     onlyWhileOpen
708   {
709     super._preValidatePurchase(_beneficiary, _weiAmount);
710   }
711 
712   /**
713    * @dev Reverts if not in crowdsale time range.
714    */
715   modifier onlyWhileOpen {
716     require(!isFinalized);
717     _;
718   }
719 
720   /**
721   * @dev Allows admin to finalize the crowdsale
722   */
723   function finalize() public onlyOwner {
724     require(!isFinalized);
725     MintableToken(token).transferOwnership(wallet);
726     isFinalized = true;
727   }
728 
729 }