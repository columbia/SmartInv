1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
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
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
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
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
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
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     hasMintPermission
342     canMint
343     public
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() onlyOwner canMint public returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 /**
365  * @title SafeERC20
366  * @dev Wrappers around ERC20 operations that throw on failure.
367  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
368  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
369  */
370 library SafeERC20 {
371   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
372     require(token.transfer(to, value));
373   }
374 
375   function safeTransferFrom(
376     ERC20 token,
377     address from,
378     address to,
379     uint256 value
380   )
381     internal
382   {
383     require(token.transferFrom(from, to, value));
384   }
385 
386   function safeApprove(ERC20 token, address spender, uint256 value) internal {
387     require(token.approve(spender, value));
388   }
389 }
390 
391 /**
392  * @title Crowdsale
393  * @dev Crowdsale is a base contract for managing a token crowdsale,
394  * allowing investors to purchase tokens with ether. This contract implements
395  * such functionality in its most fundamental form and can be extended to provide additional
396  * functionality and/or custom behavior.
397  * The external interface represents the basic interface for purchasing tokens, and conform
398  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
399  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
400  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
401  * behavior.
402  */
403 contract Crowdsale {
404   using SafeMath for uint256;
405   using SafeERC20 for ERC20;
406 
407   // The token being sold
408   ERC20 public token;
409 
410   // Address where funds are collected
411   address public wallet;
412 
413   // How many token units a buyer gets per wei.
414   // The rate is the conversion between wei and the smallest and indivisible token unit.
415   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
416   // 1 wei will give you 1 unit, or 0.001 TOK.
417   uint256 public rate;
418 
419   // Amount of wei raised
420   uint256 public weiRaised;
421 
422   /**
423    * Event for token purchase logging
424    * @param purchaser who paid for the tokens
425    * @param beneficiary who got the tokens
426    * @param value weis paid for purchase
427    * @param amount amount of tokens purchased
428    */
429   event TokenPurchase(
430     address indexed purchaser,
431     address indexed beneficiary,
432     uint256 value,
433     uint256 amount
434   );
435 
436   /**
437    * @param _rate Number of token units a buyer gets per wei
438    * @param _wallet Address where collected funds will be forwarded to
439    * @param _token Address of the token being sold
440    */
441   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
442     require(_rate > 0);
443     require(_wallet != address(0));
444     require(_token != address(0));
445 
446     rate = _rate;
447     wallet = _wallet;
448     token = _token;
449   }
450 
451   // -----------------------------------------
452   // Crowdsale external interface
453   // -----------------------------------------
454 
455   /**
456    * @dev fallback function ***DO NOT OVERRIDE***
457    */
458   function () external payable {
459     buyTokens(msg.sender);
460   }
461 
462   /**
463    * @dev low level token purchase ***DO NOT OVERRIDE***
464    * @param _beneficiary Address performing the token purchase
465    */
466   function buyTokens(address _beneficiary) public payable {
467 
468     uint256 weiAmount = msg.value;
469     _preValidatePurchase(_beneficiary, weiAmount);
470 
471     // calculate token amount to be created
472     uint256 tokens = _getTokenAmount(weiAmount);
473 
474     // update state
475     weiRaised = weiRaised.add(weiAmount);
476 
477     _processPurchase(_beneficiary, tokens);
478     emit TokenPurchase(
479       msg.sender,
480       _beneficiary,
481       weiAmount,
482       tokens
483     );
484 
485     _updatePurchasingState(_beneficiary, weiAmount);
486 
487     _forwardFunds();
488     _postValidatePurchase(_beneficiary, weiAmount);
489   }
490 
491   // -----------------------------------------
492   // Internal interface (extensible)
493   // -----------------------------------------
494 
495   /**
496    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
497    * @param _beneficiary Address performing the token purchase
498    * @param _weiAmount Value in wei involved in the purchase
499    */
500   function _preValidatePurchase(
501     address _beneficiary,
502     uint256 _weiAmount
503   )
504     internal
505   {
506     require(_beneficiary != address(0));
507     require(_weiAmount != 0);
508   }
509 
510   /**
511    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
512    * @param _beneficiary Address performing the token purchase
513    * @param _weiAmount Value in wei involved in the purchase
514    */
515   function _postValidatePurchase(
516     address _beneficiary,
517     uint256 _weiAmount
518   )
519     internal
520   {
521     // optional override
522   }
523 
524   /**
525    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
526    * @param _beneficiary Address performing the token purchase
527    * @param _tokenAmount Number of tokens to be emitted
528    */
529   function _deliverTokens(
530     address _beneficiary,
531     uint256 _tokenAmount
532   )
533     internal
534   {
535     token.safeTransfer(_beneficiary, _tokenAmount);
536   }
537 
538   /**
539    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
540    * @param _beneficiary Address receiving the tokens
541    * @param _tokenAmount Number of tokens to be purchased
542    */
543   function _processPurchase(
544     address _beneficiary,
545     uint256 _tokenAmount
546   )
547     internal
548   {
549     _deliverTokens(_beneficiary, _tokenAmount);
550   }
551 
552   /**
553    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
554    * @param _beneficiary Address receiving the tokens
555    * @param _weiAmount Value in wei involved in the purchase
556    */
557   function _updatePurchasingState(
558     address _beneficiary,
559     uint256 _weiAmount
560   )
561     internal
562   {
563     // optional override
564   }
565 
566   /**
567    * @dev Override to extend the way in which ether is converted to tokens.
568    * @param _weiAmount Value in wei to be converted into tokens
569    * @return Number of tokens that can be purchased with the specified _weiAmount
570    */
571   function _getTokenAmount(uint256 _weiAmount)
572     internal view returns (uint256)
573   {
574     return _weiAmount.mul(rate);
575   }
576 
577   /**
578    * @dev Determines how ETH is stored/forwarded on purchases.
579    */
580   function _forwardFunds() internal {
581     wallet.transfer(msg.value);
582   }
583 }
584 
585 /**
586  * @title CappedCrowdsale
587  * @dev Crowdsale with a limit for total contributions.
588  */
589 contract CappedCrowdsale is Crowdsale {
590   using SafeMath for uint256;
591 
592   uint256 public cap;
593 
594   /**
595    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
596    * @param _cap Max amount of wei to be contributed
597    */
598   constructor(uint256 _cap) public {
599     require(_cap > 0);
600     cap = _cap;
601   }
602 
603   /**
604    * @dev Checks whether the cap has been reached.
605    * @return Whether the cap was reached
606    */
607   function capReached() public view returns (bool) {
608     return weiRaised >= cap;
609   }
610 
611   /**
612    * @dev Extend parent behavior requiring purchase to respect the funding cap.
613    * @param _beneficiary Token purchaser
614    * @param _weiAmount Amount of wei contributed
615    */
616   function _preValidatePurchase(
617     address _beneficiary,
618     uint256 _weiAmount
619   )
620     internal
621   {
622     super._preValidatePurchase(_beneficiary, _weiAmount);
623     require(weiRaised.add(_weiAmount) <= cap);
624   }
625 
626 }
627 
628 /**
629  * @title AllowanceCrowdsale
630  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
631  */
632 contract AllowanceCrowdsale is Crowdsale {
633   using SafeMath for uint256;
634   using SafeERC20 for ERC20;
635 
636   address public tokenWallet;
637 
638   /**
639    * @dev Constructor, takes token wallet address.
640    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
641    */
642   constructor(address _tokenWallet) public {
643     require(_tokenWallet != address(0));
644     tokenWallet = _tokenWallet;
645   }
646 
647   /**
648    * @dev Checks the amount of tokens left in the allowance.
649    * @return Amount of tokens left in the allowance
650    */
651   function remainingTokens() public view returns (uint256) {
652     return token.allowance(tokenWallet, this);
653   }
654 
655   /**
656    * @dev Overrides parent behavior by transferring tokens from wallet.
657    * @param _beneficiary Token purchaser
658    * @param _tokenAmount Amount of tokens purchased
659    */
660   function _deliverTokens(
661     address _beneficiary,
662     uint256 _tokenAmount
663   )
664     internal
665   {
666     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
667   }
668 }
669 
670 /**
671  * @title MintedCrowdsale
672  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
673  * Token ownership should be transferred to MintedCrowdsale for minting.
674  */
675 contract MintedCrowdsale is Crowdsale {
676 
677   /**
678    * @dev Overrides delivery by minting tokens upon purchase.
679    * @param _beneficiary Token purchaser
680    * @param _tokenAmount Number of tokens to be minted
681    */
682   function _deliverTokens(
683     address _beneficiary,
684     uint256 _tokenAmount
685   )
686     internal
687   {
688     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
689   }
690 }
691 
692 /**
693  * @title Contracts that should be able to recover tokens
694  * @author SylTi
695  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
696  * This will prevent any accidental loss of tokens.
697  */
698 contract CanReclaimToken is Ownable {
699   using SafeERC20 for ERC20Basic;
700 
701   /**
702    * @dev Reclaim all ERC20Basic compatible tokens
703    * @param token ERC20Basic The address of the token contract
704    */
705   function reclaimToken(ERC20Basic token) external onlyOwner {
706     uint256 balance = token.balanceOf(this);
707     token.safeTransfer(owner, balance);
708   }
709 
710 }
711 
712 /**
713  * @title Contracts that should not own Tokens
714  * @author Remco Bloemen <remco@2π.com>
715  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
716  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
717  * owner to reclaim the tokens.
718  */
719 contract HasNoTokens is CanReclaimToken {
720 
721  /**
722   * @dev Reject all ERC223 compatible tokens
723   * @param from_ address The address that is transferring the tokens
724   * @param value_ uint256 the amount of the specified token
725   * @param data_ Bytes The data passed from the caller.
726   */
727   function tokenFallback(address from_, uint256 value_, bytes data_) external {
728     from_;
729     value_;
730     data_;
731     revert();
732   }
733 
734 }
735 
736 contract HealthToken is StandardToken {
737 
738   string public constant name = "HealthToken";
739   string public constant symbol = "HT";
740   uint8 public constant decimals = 18;
741 
742   uint256 public constant INITIAL_SUPPLY = 30000000 * (10 ** uint256(decimals));
743 
744   constructor(
745     address _wallet
746   ) 
747   public {
748     totalSupply_ = INITIAL_SUPPLY;
749     balances[_wallet] = INITIAL_SUPPLY;
750     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
751     
752   }
753 
754 }
755 
756 contract HealthTokenCrowdsale is AllowanceCrowdsale, HasNoTokens {
757 
758   constructor
759     (
760       uint256 _rate, 
761       address _wallet,
762       StandardToken _token,
763       address _tokenWallet
764     ) 
765     
766   public
767     Crowdsale(_rate, _wallet, _token)
768     AllowanceCrowdsale(_tokenWallet)
769   {
770     discount = 25;
771     rate = _rate;
772     volumeDiscounts.push(VolumeDiscount(10 ether, 5));
773     volumeDiscounts.push(VolumeDiscount(50 ether, 10));
774     volumeDiscounts.push(VolumeDiscount(100 ether, 15));
775   }
776 //10 50 100
777   struct VolumeDiscount {
778     uint256 volume;
779     uint8 discount;
780   }
781 
782   uint256 public rate;
783   uint8 public discount;
784   VolumeDiscount[] public volumeDiscounts;
785 
786   function setDiscount(uint8 _discount) external onlyOwner {
787     discount = _discount;
788   }
789 
790   function setRate(uint256 _rate) external onlyOwner {
791     rate = _rate;
792   }
793 
794   function addVolumeDiscount(uint256 _volume, uint8 _discount) external onlyOwner {
795     volumeDiscounts.push(VolumeDiscount(_volume, _discount));
796   }
797 
798   function clearVolumeDiscounts() external onlyOwner {
799     delete volumeDiscounts;
800   }
801 
802   function getVolumeDiscountsCount() public constant returns(uint) {
803     return volumeDiscounts.length;
804   }
805 
806   function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
807     uint256 tokensAmount = weiAmount.mul(rate);
808 
809     uint8 totalDiscount = discount;
810     uint8 volumeDiscount = 0;
811 
812     for(uint i = 0; i < volumeDiscounts.length; i ++) {
813       if(weiAmount >= volumeDiscounts[i].volume && volumeDiscount < volumeDiscounts[i].discount) {
814         volumeDiscount = volumeDiscounts[i].discount;
815       } 
816     }
817 
818     totalDiscount = totalDiscount + volumeDiscount;
819 
820     if(totalDiscount > 0) {
821       return tokensAmount / 100 * (100 + totalDiscount);
822     }
823 
824     return tokensAmount;
825   }
826 }