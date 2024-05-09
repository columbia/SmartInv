1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125 
126   bool public paused = false;
127 
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is not paused.
131    */
132   modifier whenNotPaused() {
133     require(!paused);
134     _;
135   }
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is paused.
139    */
140   modifier whenPaused() {
141     require(paused);
142     _;
143   }
144 
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152 
153   /**
154    * @dev called by the owner to unpause, returns to normal state
155    */
156   function unpause() onlyOwner whenPaused public {
157     paused = false;
158     emit Unpause();
159   }
160 }
161 
162 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
163 
164 /**
165  * @title ERC20Basic
166  * @dev Simpler version of ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/179
168  */
169 contract ERC20Basic {
170   function totalSupply() public view returns (uint256);
171   function balanceOf(address who) public view returns (uint256);
172   function transfer(address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
198 
199 /**
200  * @title Crowdsale
201  * @dev Crowdsale is a base contract for managing a token crowdsale,
202  * allowing investors to purchase tokens with ether. This contract implements
203  * such functionality in its most fundamental form and can be extended to provide additional
204  * functionality and/or custom behavior.
205  * The external interface represents the basic interface for purchasing tokens, and conform
206  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
207  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
208  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
209  * behavior.
210  */
211 contract Crowdsale {
212   using SafeMath for uint256;
213 
214   // The token being sold
215   ERC20 public token;
216 
217   // Address where funds are collected
218   address public wallet;
219 
220   // How many token units a buyer gets per wei.
221   // The rate is the conversion between wei and the smallest and indivisible token unit.
222   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
223   // 1 wei will give you 1 unit, or 0.001 TOK.
224   uint256 public rate;
225 
226   // Amount of wei raised
227   uint256 public weiRaised;
228 
229   /**
230    * Event for token purchase logging
231    * @param purchaser who paid for the tokens
232    * @param beneficiary who got the tokens
233    * @param value weis paid for purchase
234    * @param amount amount of tokens purchased
235    */
236   event TokenPurchase(
237     address indexed purchaser,
238     address indexed beneficiary,
239     uint256 value,
240     uint256 amount
241   );
242 
243   /**
244    * @param _rate Number of token units a buyer gets per wei
245    * @param _wallet Address where collected funds will be forwarded to
246    * @param _token Address of the token being sold
247    */
248   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
249     require(_rate > 0);
250     require(_wallet != address(0));
251     require(_token != address(0));
252 
253     rate = _rate;
254     wallet = _wallet;
255     token = _token;
256   }
257 
258   // -----------------------------------------
259   // Crowdsale external interface
260   // -----------------------------------------
261 
262   /**
263    * @dev fallback function ***DO NOT OVERRIDE***
264    */
265   function () external payable {
266     buyTokens(msg.sender);
267   }
268 
269   /**
270    * @dev low level token purchase ***DO NOT OVERRIDE***
271    * @param _beneficiary Address performing the token purchase
272    */
273   function buyTokens(address _beneficiary) public payable {
274 
275     uint256 weiAmount = msg.value;
276     _preValidatePurchase(_beneficiary, weiAmount);
277 
278     // calculate token amount to be created
279     uint256 tokens = _getTokenAmount(weiAmount);
280 
281     // update state
282     weiRaised = weiRaised.add(weiAmount);
283 
284     _processPurchase(_beneficiary, tokens);
285     emit TokenPurchase(
286       msg.sender,
287       _beneficiary,
288       weiAmount,
289       tokens
290     );
291 
292     _updatePurchasingState(_beneficiary, weiAmount);
293 
294     _forwardFunds();
295     _postValidatePurchase(_beneficiary, weiAmount);
296   }
297 
298   // -----------------------------------------
299   // Internal interface (extensible)
300   // -----------------------------------------
301 
302   /**
303    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
304    * @param _beneficiary Address performing the token purchase
305    * @param _weiAmount Value in wei involved in the purchase
306    */
307   function _preValidatePurchase(
308     address _beneficiary,
309     uint256 _weiAmount
310   )
311     internal
312   {
313     require(_beneficiary != address(0));
314     require(_weiAmount != 0);
315   }
316 
317   /**
318    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
319    * @param _beneficiary Address performing the token purchase
320    * @param _weiAmount Value in wei involved in the purchase
321    */
322   function _postValidatePurchase(
323     address _beneficiary,
324     uint256 _weiAmount
325   )
326     internal
327   {
328     // optional override
329   }
330 
331   /**
332    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
333    * @param _beneficiary Address performing the token purchase
334    * @param _tokenAmount Number of tokens to be emitted
335    */
336   function _deliverTokens(
337     address _beneficiary,
338     uint256 _tokenAmount
339   )
340     internal
341   {
342     token.transfer(_beneficiary, _tokenAmount);
343   }
344 
345   /**
346    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
347    * @param _beneficiary Address receiving the tokens
348    * @param _tokenAmount Number of tokens to be purchased
349    */
350   function _processPurchase(
351     address _beneficiary,
352     uint256 _tokenAmount
353   )
354     internal
355   {
356     _deliverTokens(_beneficiary, _tokenAmount);
357   }
358 
359   /**
360    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
361    * @param _beneficiary Address receiving the tokens
362    * @param _weiAmount Value in wei involved in the purchase
363    */
364   function _updatePurchasingState(
365     address _beneficiary,
366     uint256 _weiAmount
367   )
368     internal
369   {
370     // optional override
371   }
372 
373   /**
374    * @dev Override to extend the way in which ether is converted to tokens.
375    * @param _weiAmount Value in wei to be converted into tokens
376    * @return Number of tokens that can be purchased with the specified _weiAmount
377    */
378   function _getTokenAmount(uint256 _weiAmount)
379     internal view returns (uint256)
380   {
381     return _weiAmount.mul(rate);
382   }
383 
384   /**
385    * @dev Determines how ETH is stored/forwarded on purchases.
386    */
387   function _forwardFunds() internal {
388     wallet.transfer(msg.value);
389   }
390 }
391 
392 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
393 
394 /**
395  * @title Basic token
396  * @dev Basic version of StandardToken, with no allowances.
397  */
398 contract BasicToken is ERC20Basic {
399   using SafeMath for uint256;
400 
401   mapping(address => uint256) balances;
402 
403   uint256 totalSupply_;
404 
405   /**
406   * @dev total number of tokens in existence
407   */
408   function totalSupply() public view returns (uint256) {
409     return totalSupply_;
410   }
411 
412   /**
413   * @dev transfer token for a specified address
414   * @param _to The address to transfer to.
415   * @param _value The amount to be transferred.
416   */
417   function transfer(address _to, uint256 _value) public returns (bool) {
418     require(_to != address(0));
419     require(_value <= balances[msg.sender]);
420 
421     balances[msg.sender] = balances[msg.sender].sub(_value);
422     balances[_to] = balances[_to].add(_value);
423     emit Transfer(msg.sender, _to, _value);
424     return true;
425   }
426 
427   /**
428   * @dev Gets the balance of the specified address.
429   * @param _owner The address to query the the balance of.
430   * @return An uint256 representing the amount owned by the passed address.
431   */
432   function balanceOf(address _owner) public view returns (uint256) {
433     return balances[_owner];
434   }
435 
436 }
437 
438 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
439 
440 /**
441  * @title Standard ERC20 token
442  *
443  * @dev Implementation of the basic standard token.
444  * @dev https://github.com/ethereum/EIPs/issues/20
445  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
446  */
447 contract StandardToken is ERC20, BasicToken {
448 
449   mapping (address => mapping (address => uint256)) internal allowed;
450 
451 
452   /**
453    * @dev Transfer tokens from one address to another
454    * @param _from address The address which you want to send tokens from
455    * @param _to address The address which you want to transfer to
456    * @param _value uint256 the amount of tokens to be transferred
457    */
458   function transferFrom(
459     address _from,
460     address _to,
461     uint256 _value
462   )
463     public
464     returns (bool)
465   {
466     require(_to != address(0));
467     require(_value <= balances[_from]);
468     require(_value <= allowed[_from][msg.sender]);
469 
470     balances[_from] = balances[_from].sub(_value);
471     balances[_to] = balances[_to].add(_value);
472     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
473     emit Transfer(_from, _to, _value);
474     return true;
475   }
476 
477   /**
478    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
479    *
480    * Beware that changing an allowance with this method brings the risk that someone may use both the old
481    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
482    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
483    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
484    * @param _spender The address which will spend the funds.
485    * @param _value The amount of tokens to be spent.
486    */
487   function approve(address _spender, uint256 _value) public returns (bool) {
488     allowed[msg.sender][_spender] = _value;
489     emit Approval(msg.sender, _spender, _value);
490     return true;
491   }
492 
493   /**
494    * @dev Function to check the amount of tokens that an owner allowed to a spender.
495    * @param _owner address The address which owns the funds.
496    * @param _spender address The address which will spend the funds.
497    * @return A uint256 specifying the amount of tokens still available for the spender.
498    */
499   function allowance(
500     address _owner,
501     address _spender
502    )
503     public
504     view
505     returns (uint256)
506   {
507     return allowed[_owner][_spender];
508   }
509 
510   /**
511    * @dev Increase the amount of tokens that an owner allowed to a spender.
512    *
513    * approve should be called when allowed[_spender] == 0. To increment
514    * allowed value is better to use this function to avoid 2 calls (and wait until
515    * the first transaction is mined)
516    * From MonolithDAO Token.sol
517    * @param _spender The address which will spend the funds.
518    * @param _addedValue The amount of tokens to increase the allowance by.
519    */
520   function increaseApproval(
521     address _spender,
522     uint _addedValue
523   )
524     public
525     returns (bool)
526   {
527     allowed[msg.sender][_spender] = (
528       allowed[msg.sender][_spender].add(_addedValue));
529     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
530     return true;
531   }
532 
533   /**
534    * @dev Decrease the amount of tokens that an owner allowed to a spender.
535    *
536    * approve should be called when allowed[_spender] == 0. To decrement
537    * allowed value is better to use this function to avoid 2 calls (and wait until
538    * the first transaction is mined)
539    * From MonolithDAO Token.sol
540    * @param _spender The address which will spend the funds.
541    * @param _subtractedValue The amount of tokens to decrease the allowance by.
542    */
543   function decreaseApproval(
544     address _spender,
545     uint _subtractedValue
546   )
547     public
548     returns (bool)
549   {
550     uint oldValue = allowed[msg.sender][_spender];
551     if (_subtractedValue > oldValue) {
552       allowed[msg.sender][_spender] = 0;
553     } else {
554       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
555     }
556     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
557     return true;
558   }
559 
560 }
561 
562 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
563 
564 /**
565  * @title Mintable token
566  * @dev Simple ERC20 Token example, with mintable token creation
567  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
568  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
569  */
570 contract MintableToken is StandardToken, Ownable {
571   event Mint(address indexed to, uint256 amount);
572   event MintFinished();
573 
574   bool public mintingFinished = false;
575 
576 
577   modifier canMint() {
578     require(!mintingFinished);
579     _;
580   }
581 
582   modifier hasMintPermission() {
583     require(msg.sender == owner);
584     _;
585   }
586 
587   /**
588    * @dev Function to mint tokens
589    * @param _to The address that will receive the minted tokens.
590    * @param _amount The amount of tokens to mint.
591    * @return A boolean that indicates if the operation was successful.
592    */
593   function mint(
594     address _to,
595     uint256 _amount
596   )
597     hasMintPermission
598     canMint
599     public
600     returns (bool)
601   {
602     totalSupply_ = totalSupply_.add(_amount);
603     balances[_to] = balances[_to].add(_amount);
604     emit Mint(_to, _amount);
605     emit Transfer(address(0), _to, _amount);
606     return true;
607   }
608 
609   /**
610    * @dev Function to stop minting new tokens.
611    * @return True if the operation was successful.
612    */
613   function finishMinting() onlyOwner canMint public returns (bool) {
614     mintingFinished = true;
615     emit MintFinished();
616     return true;
617   }
618 }
619 
620 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
621 
622 /**
623  * @title MintedCrowdsale
624  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
625  * Token ownership should be transferred to MintedCrowdsale for minting.
626  */
627 contract MintedCrowdsale is Crowdsale {
628 
629   /**
630    * @dev Overrides delivery by minting tokens upon purchase.
631    * @param _beneficiary Token purchaser
632    * @param _tokenAmount Number of tokens to be minted
633    */
634   function _deliverTokens(
635     address _beneficiary,
636     uint256 _tokenAmount
637   )
638     internal
639   {
640     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
641   }
642 }
643 
644 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
645 
646 /**
647  * @title CappedCrowdsale
648  * @dev Crowdsale with a limit for total contributions.
649  */
650 contract CappedCrowdsale is Crowdsale {
651   using SafeMath for uint256;
652 
653   uint256 public cap;
654 
655   /**
656    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
657    * @param _cap Max amount of wei to be contributed
658    */
659   constructor(uint256 _cap) public {
660     require(_cap > 0);
661     cap = _cap;
662   }
663 
664   /**
665    * @dev Checks whether the cap has been reached.
666    * @return Whether the cap was reached
667    */
668   function capReached() public view returns (bool) {
669     return weiRaised >= cap;
670   }
671 
672   /**
673    * @dev Extend parent behavior requiring purchase to respect the funding cap.
674    * @param _beneficiary Token purchaser
675    * @param _weiAmount Amount of wei contributed
676    */
677   function _preValidatePurchase(
678     address _beneficiary,
679     uint256 _weiAmount
680   )
681     internal
682   {
683     super._preValidatePurchase(_beneficiary, _weiAmount);
684     require(weiRaised.add(_weiAmount) <= cap);
685   }
686 
687 }
688 
689 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
690 
691 /**
692  * @title WhitelistedCrowdsale
693  * @dev Crowdsale in which only whitelisted users can contribute.
694  */
695 contract WhitelistedCrowdsale is Crowdsale, Ownable {
696 
697   mapping(address => bool) public whitelist;
698 
699   /**
700    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
701    */
702   modifier isWhitelisted(address _beneficiary) {
703     require(whitelist[_beneficiary]);
704     _;
705   }
706 
707   /**
708    * @dev Adds single address to whitelist.
709    * @param _beneficiary Address to be added to the whitelist
710    */
711   function addToWhitelist(address _beneficiary) external onlyOwner {
712     whitelist[_beneficiary] = true;
713   }
714 
715   /**
716    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
717    * @param _beneficiaries Addresses to be added to the whitelist
718    */
719   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
720     for (uint256 i = 0; i < _beneficiaries.length; i++) {
721       whitelist[_beneficiaries[i]] = true;
722     }
723   }
724 
725   /**
726    * @dev Removes single address from whitelist.
727    * @param _beneficiary Address to be removed to the whitelist
728    */
729   function removeFromWhitelist(address _beneficiary) external onlyOwner {
730     whitelist[_beneficiary] = false;
731   }
732 
733   /**
734    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
735    * @param _beneficiary Token beneficiary
736    * @param _weiAmount Amount of wei contributed
737    */
738   function _preValidatePurchase(
739     address _beneficiary,
740     uint256 _weiAmount
741   )
742     internal
743     isWhitelisted(_beneficiary)
744   {
745     super._preValidatePurchase(_beneficiary, _weiAmount);
746   }
747 
748 }
749 
750 // File: contracts/ZeexCrowdsale.sol
751 
752 contract ZeexCrowdsale is CappedCrowdsale, WhitelistedCrowdsale, MintedCrowdsale, Pausable {
753   using SafeMath for uint256;
754 
755   address[] public bonusUsers;
756   mapping(address => uint256) public bonusTokens;
757 
758   event Lock(address user, uint amount);
759   event ReleaseLockedTokens(address user, uint amount, address to);
760 
761   constructor(
762     uint _hardCapWei,
763     address _wallet,
764     address _token
765   ) public
766     Crowdsale(5000, _wallet, MintableToken(_token))
767     CappedCrowdsale(_hardCapWei)
768   {
769     paused = true;
770   }
771 
772   function _preValidatePurchase(
773     address _beneficiary,
774     uint256 _weiAmount
775   )
776     internal
777     whenNotPaused
778   {
779     super._preValidatePurchase(_beneficiary, _weiAmount);
780   }
781 
782   function grantTokensForMultipleBeneficiaries(
783     address[] _beneficiaries,
784     uint256[] _tokenAmounts
785   )
786     public
787     onlyOwner
788   {
789     require(_beneficiaries.length == _tokenAmounts.length, "Beneficiaries list length must be aligned with token amounts list length");
790     for (uint i = 0; i < _beneficiaries.length; i++) {
791       _deliverTokens(_beneficiaries[i], _tokenAmounts[i]);
792     }
793   }
794 
795   function grantTokens(
796     address _beneficiary,
797     uint256 _tokenAmount
798   )
799     public
800     onlyOwner
801   {
802     require(_tokenAmount > 0, "token amount must be greater than 0");
803     _deliverTokens(_beneficiary, _tokenAmount);
804   }
805 
806   function grantBonusTokens(
807     address _beneficiary,
808     uint256 _tokenAmount
809   )
810     public
811     onlyOwner
812   {
813     lockAndDeliverTokens(_beneficiary, _tokenAmount);
814   }
815 
816   function lockAndDeliverTokens(
817     address _beneficiary,
818     uint256 _tokenAmount
819   )
820     internal
821   {
822     lockBonusTokens(_beneficiary, _tokenAmount);
823     _deliverTokens(address(this), _tokenAmount);
824   }
825 
826   function lockBonusTokens(
827     address _beneficiary,
828     uint256 _amount
829   )
830     internal
831   {
832     if (bonusTokens[_beneficiary] == 0) {
833       bonusUsers.push(_beneficiary);
834     }
835 
836     bonusTokens[_beneficiary] = bonusTokens[_beneficiary].add(_amount);
837     emit Lock(_beneficiary, _amount);
838   }
839 
840   function getBonusBalance(
841     uint _from,
842     uint _to
843   )
844     public
845     view
846     returns (
847       uint total
848     )
849   {
850     require(_from >= 0 && _to >= _from && _to <= bonusUsers.length, "from / to index out of bound");
851 
852     for (uint i = _from; i < _to; i++) {
853       total = total.add(getUserBonusBalance(bonusUsers[i]));
854     }
855   }
856 
857   function getUserBonusBalance(
858     address _user
859   )
860     public
861     view
862     returns (
863       uint total
864     )
865   {
866     return bonusTokens[_user];
867   }
868 
869   function getBonusUsersCount() public view returns(uint count) {
870     return bonusUsers.length;
871   }
872 
873   function releaseUserBonusTokens(
874     address _user,
875     uint _amount,
876     address _to
877   )
878     public
879     onlyOwner
880   {
881     releaseSingleUserBonusTokens(_user, _amount, _to);
882   }
883 
884   function releaseBonusTokens(
885     address[] _users,
886     uint[] _amounts
887   )
888     public
889     onlyOwner
890   {
891     for (uint i = 0; i < _users.length; i++) {
892       address user = _users[i];
893       uint amount = _amounts[i];
894       releaseSingleUserBonusTokens(user, amount, user);
895     }
896   }
897 
898   function releaseSingleUserBonusTokens(
899     address _user,
900     uint _amount,
901     address _to
902   )
903     internal
904     onlyOwner
905   {
906     uint tokenBalance = bonusTokens[_user];
907     require(tokenBalance >= _amount, "Invalid bonus amount");
908 
909     bonusTokens[_user] = bonusTokens[_user].sub(_amount);
910     token.transfer(_to, _amount);
911     emit ReleaseLockedTokens(_user, _amount, _to);
912   }
913 
914   function transferTokenOwnership(
915     address _to
916   )
917     public
918     onlyOwner
919   {
920     Ownable(token).transferOwnership(_to);
921   }
922 }