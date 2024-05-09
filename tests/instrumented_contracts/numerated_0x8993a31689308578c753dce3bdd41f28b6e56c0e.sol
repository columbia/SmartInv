1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 /**
251  * @title Ownable
252  * @dev The Ownable contract has an owner address, and provides basic authorization control
253  * functions, this simplifies the implementation of "user permissions".
254  */
255 contract Ownable {
256   address public owner;
257 
258 
259   event OwnershipRenounced(address indexed previousOwner);
260   event OwnershipTransferred(
261     address indexed previousOwner,
262     address indexed newOwner
263   );
264 
265 
266   /**
267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
268    * account.
269    */
270   constructor() public {
271     owner = msg.sender;
272   }
273 
274   /**
275    * @dev Throws if called by any account other than the owner.
276    */
277   modifier onlyOwner() {
278     require(msg.sender == owner);
279     _;
280   }
281 
282   /**
283    * @dev Allows the current owner to relinquish control of the contract.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasMintPermission() {
328     require(msg.sender == owner);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(
339     address _to,
340     uint256 _amount
341   )
342     hasMintPermission
343     canMint
344     public
345     returns (bool)
346   {
347     totalSupply_ = totalSupply_.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     emit Mint(_to, _amount);
350     emit Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     emit MintFinished();
361     return true;
362   }
363 }
364 
365 /**
366  * @title Crowdsale
367  * @dev Crowdsale is a base contract for managing a token crowdsale,
368  * allowing investors to purchase tokens with ether. This contract implements
369  * such functionality in its most fundamental form and can be extended to provide additional
370  * functionality and/or custom behavior.
371  * The external interface represents the basic interface for purchasing tokens, and conform
372  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
373  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
374  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
375  * behavior.
376  */
377 contract Crowdsale {
378   using SafeMath for uint256;
379 
380   // The token being sold
381   ERC20 public token;
382 
383   // Address where funds are collected
384   address public wallet;
385 
386   // How many token units a buyer gets per wei.
387   // The rate is the conversion between wei and the smallest and indivisible token unit.
388   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
389   // 1 wei will give you 1 unit, or 0.001 TOK.
390   uint256 public rate;
391 
392   // Amount of wei raised
393   uint256 public weiRaised;
394 
395   /**
396    * Event for token purchase logging
397    * @param purchaser who paid for the tokens
398    * @param beneficiary who got the tokens
399    * @param value weis paid for purchase
400    * @param amount amount of tokens purchased
401    */
402   event TokenPurchase(
403     address indexed purchaser,
404     address indexed beneficiary,
405     uint256 value,
406     uint256 amount
407   );
408 
409   /**
410    * @param _rate Number of token units a buyer gets per wei
411    * @param _wallet Address where collected funds will be forwarded to
412    * @param _token Address of the token being sold
413    */
414   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
415     require(_rate > 0);
416     require(_wallet != address(0));
417     require(_token != address(0));
418 
419     rate = _rate;
420     wallet = _wallet;
421     token = _token;
422   }
423 
424   // -----------------------------------------
425   // Crowdsale external interface
426   // -----------------------------------------
427 
428   /**
429    * @dev fallback function ***DO NOT OVERRIDE***
430    */
431   function () external payable {
432     buyTokens(msg.sender);
433   }
434 
435   /**
436    * @dev low level token purchase ***DO NOT OVERRIDE***
437    * @param _beneficiary Address performing the token purchase
438    */
439   function buyTokens(address _beneficiary) public payable {
440 
441     uint256 weiAmount = msg.value;
442     _preValidatePurchase(_beneficiary, weiAmount);
443 
444     // calculate token amount to be created
445     uint256 tokens = _getTokenAmount(weiAmount);
446 
447     // update state
448     weiRaised = weiRaised.add(weiAmount);
449 
450     _processPurchase(_beneficiary, tokens);
451     emit TokenPurchase(
452       msg.sender,
453       _beneficiary,
454       weiAmount,
455       tokens
456     );
457 
458     _updatePurchasingState(_beneficiary, weiAmount);
459 
460     _forwardFunds();
461     _postValidatePurchase(_beneficiary, weiAmount);
462   }
463 
464   // -----------------------------------------
465   // Internal interface (extensible)
466   // -----------------------------------------
467 
468   /**
469    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
470    * @param _beneficiary Address performing the token purchase
471    * @param _weiAmount Value in wei involved in the purchase
472    */
473   function _preValidatePurchase(
474     address _beneficiary,
475     uint256 _weiAmount
476   )
477     internal
478   {
479     require(_beneficiary != address(0));
480     require(_weiAmount != 0);
481   }
482 
483   /**
484    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
485    * @param _beneficiary Address performing the token purchase
486    * @param _weiAmount Value in wei involved in the purchase
487    */
488   function _postValidatePurchase(
489     address _beneficiary,
490     uint256 _weiAmount
491   )
492     internal
493   {
494     // optional override
495   }
496 
497   /**
498    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
499    * @param _beneficiary Address performing the token purchase
500    * @param _tokenAmount Number of tokens to be emitted
501    */
502   function _deliverTokens(
503     address _beneficiary,
504     uint256 _tokenAmount
505   )
506     internal
507   {
508     token.transfer(_beneficiary, _tokenAmount);
509   }
510 
511   /**
512    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
513    * @param _beneficiary Address receiving the tokens
514    * @param _tokenAmount Number of tokens to be purchased
515    */
516   function _processPurchase(
517     address _beneficiary,
518     uint256 _tokenAmount
519   )
520     internal
521   {
522     _deliverTokens(_beneficiary, _tokenAmount);
523   }
524 
525   /**
526    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
527    * @param _beneficiary Address receiving the tokens
528    * @param _weiAmount Value in wei involved in the purchase
529    */
530   function _updatePurchasingState(
531     address _beneficiary,
532     uint256 _weiAmount
533   )
534     internal
535   {
536     // optional override
537   }
538 
539   /**
540    * @dev Override to extend the way in which ether is converted to tokens.
541    * @param _weiAmount Value in wei to be converted into tokens
542    * @return Number of tokens that can be purchased with the specified _weiAmount
543    */
544   function _getTokenAmount(uint256 _weiAmount)
545     internal view returns (uint256)
546   {
547     return _weiAmount.mul(rate);
548   }
549 
550   /**
551    * @dev Determines how ETH is stored/forwarded on purchases.
552    */
553   function _forwardFunds() internal {
554     wallet.transfer(msg.value);
555   }
556 }
557 
558 /**
559  * @title MintedCrowdsale
560  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
561  * Token ownership should be transferred to MintedCrowdsale for minting.
562  */
563 contract MintedCrowdsale is Crowdsale {
564 
565   /**
566    * @dev Overrides delivery by minting tokens upon purchase.
567    * @param _beneficiary Token purchaser
568    * @param _tokenAmount Number of tokens to be minted
569    */
570   function _deliverTokens(
571     address _beneficiary,
572     uint256 _tokenAmount
573   )
574     internal
575   {
576     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
577   }
578 }
579 
580 /**
581  * @title WhitelistedCrowdsale
582  * @dev Crowdsale in which only whitelisted users can contribute.
583  */
584 contract WhitelistedCrowdsale is Crowdsale, Ownable {
585 
586   mapping(address => bool) public whitelist;
587 
588   /**
589    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
590    */
591   modifier isWhitelisted(address _beneficiary) {
592     require(whitelist[_beneficiary]);
593     _;
594   }
595 
596   /**
597    * @dev Adds single address to whitelist.
598    * @param _beneficiary Address to be added to the whitelist
599    */
600   function addToWhitelist(address _beneficiary) external onlyOwner {
601     whitelist[_beneficiary] = true;
602   }
603 
604   /**
605    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
606    * @param _beneficiaries Addresses to be added to the whitelist
607    */
608   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
609     for (uint256 i = 0; i < _beneficiaries.length; i++) {
610       whitelist[_beneficiaries[i]] = true;
611     }
612   }
613 
614   /**
615    * @dev Removes single address from whitelist.
616    * @param _beneficiary Address to be removed to the whitelist
617    */
618   function removeFromWhitelist(address _beneficiary) external onlyOwner {
619     whitelist[_beneficiary] = false;
620   }
621 
622   /**
623    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
624    * @param _beneficiary Token beneficiary
625    * @param _weiAmount Amount of wei contributed
626    */
627   function _preValidatePurchase(
628     address _beneficiary,
629     uint256 _weiAmount
630   )
631     internal
632     isWhitelisted(_beneficiary)
633   {
634     super._preValidatePurchase(_beneficiary, _weiAmount);
635   }
636 
637 }
638 
639 contract AssetGalorePresale is Crowdsale, MintedCrowdsale, WhitelistedCrowdsale {
640   bool public isFinalized = false;
641 
642   constructor(
643     uint _rate,
644     address _wallet,
645     MintableToken _token
646   )
647     Crowdsale(_rate, _wallet, _token)
648     public
649   {
650   }
651 
652   /**
653   * @dev Allows admin to mint tokens
654   * @param _beneficiary token benneficiary
655   * @param _tokenAmount Number of tokens
656   */
657   function mintTokens(
658     address _beneficiary,
659     uint256 _tokenAmount
660   )
661     public
662     onlyOwner
663   {
664     _deliverTokens(_beneficiary, _tokenAmount);
665   }
666 
667   /**
668   * @dev Allows admin to update the crowdsale rate
669   * @param _rate Crowdsale rate
670   */
671   function setRate(uint _rate) public onlyOwner {
672     rate = _rate;
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
690   /**
691    * @dev Reverts if not in crowdsale time range.
692    */
693   modifier onlyWhileOpen {
694     require(!isFinalized);
695     _;
696   }
697 
698   /**
699   * @dev Allows admin to finalize the crowdsale
700   */
701   function finalize() public onlyOwner {
702     require(!isFinalized);
703     MintableToken(token).transferOwnership(wallet);
704     isFinalized = true;
705   }
706 
707 }