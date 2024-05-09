1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipRenounced(address indexed previousOwner);
62   event OwnershipTransferred(
63     address indexed previousOwner,
64     address indexed newOwner
65   );
66 
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   function totalSupply() public view returns (uint256);
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender)
129     public view returns (uint256);
130 
131   function transferFrom(address from, address to, uint256 value)
132     public returns (bool);
133 
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(
205     address _from,
206     address _to,
207     uint256 _value
208   )
209     public
210     returns (bool)
211   {
212     require(_to != address(0));
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     emit Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    *
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(
246     address _owner,
247     address _spender
248    )
249     public
250     view
251     returns (uint256)
252   {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(
267     address _spender,
268     uint _addedValue
269   )
270     public
271     returns (bool)
272   {
273     allowed[msg.sender][_spender] = (
274       allowed[msg.sender][_spender].add(_addedValue));
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    *
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval(
290     address _spender,
291     uint _subtractedValue
292   )
293     public
294     returns (bool)
295   {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 /**
309  * @title Crowdsale
310  * @dev Crowdsale is a base contract for managing a token crowdsale,
311  * allowing investors to purchase tokens with ether. This contract implements
312  * such functionality in its most fundamental form and can be extended to provide additional
313  * functionality and/or custom behavior.
314  * The external interface represents the basic interface for purchasing tokens, and conform
315  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
316  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
317  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
318  * behavior.
319  */
320 contract Crowdsale {
321   using SafeMath for uint256;
322 
323   // The token being sold
324   ERC20 public token;
325 
326   // Address where funds are collected
327   address public wallet;
328 
329   // How many token units a buyer gets per wei.
330   // The rate is the conversion between wei and the smallest and indivisible token unit.
331   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
332   // 1 wei will give you 1 unit, or 0.001 TOK.
333   uint256 public rate;
334 
335   // Amount of wei raised
336   uint256 public weiRaised;
337 
338   /**
339    * Event for token purchase logging
340    * @param purchaser who paid for the tokens
341    * @param beneficiary who got the tokens
342    * @param value weis paid for purchase
343    * @param amount amount of tokens purchased
344    */
345   event TokenPurchase(
346     address indexed purchaser,
347     address indexed beneficiary,
348     uint256 value,
349     uint256 amount
350   );
351 
352   /**
353    * @param _rate Number of token units a buyer gets per wei
354    * @param _wallet Address where collected funds will be forwarded to
355    * @param _token Address of the token being sold
356    */
357   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
358     require(_rate > 0);
359     require(_wallet != address(0));
360     require(_token != address(0));
361 
362     rate = _rate;
363     wallet = _wallet;
364     token = _token;
365   }
366 
367   // -----------------------------------------
368   // Crowdsale external interface
369   // -----------------------------------------
370 
371   /**
372    * @dev fallback function ***DO NOT OVERRIDE***
373    */
374   function () external payable {
375     buyTokens(msg.sender);
376   }
377 
378   /**
379    * @dev low level token purchase ***DO NOT OVERRIDE***
380    * @param _beneficiary Address performing the token purchase
381    */
382   function buyTokens(address _beneficiary) public payable {
383 
384     uint256 weiAmount = msg.value;
385     _preValidatePurchase(_beneficiary, weiAmount);
386 
387     // calculate token amount to be created
388     uint256 tokens = _getTokenAmount(weiAmount);
389 
390     // update state
391     weiRaised = weiRaised.add(weiAmount);
392 
393     _processPurchase(_beneficiary, tokens);
394     emit TokenPurchase(
395       msg.sender,
396       _beneficiary,
397       weiAmount,
398       tokens
399     );
400 
401     _updatePurchasingState(_beneficiary, weiAmount);
402 
403     _forwardFunds();
404     _postValidatePurchase(_beneficiary, weiAmount);
405   }
406 
407   // -----------------------------------------
408   // Internal interface (extensible)
409   // -----------------------------------------
410 
411   /**
412    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
413    * @param _beneficiary Address performing the token purchase
414    * @param _weiAmount Value in wei involved in the purchase
415    */
416   function _preValidatePurchase(
417     address _beneficiary,
418     uint256 _weiAmount
419   )
420     internal
421   {
422     require(_beneficiary != address(0));
423     require(_weiAmount != 0);
424   }
425 
426   /**
427    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
428    * @param _beneficiary Address performing the token purchase
429    * @param _weiAmount Value in wei involved in the purchase
430    */
431   function _postValidatePurchase(
432     address _beneficiary,
433     uint256 _weiAmount
434   )
435     internal
436   {
437     // optional override
438   }
439 
440   /**
441    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
442    * @param _beneficiary Address performing the token purchase
443    * @param _tokenAmount Number of tokens to be emitted
444    */
445   function _deliverTokens(
446     address _beneficiary,
447     uint256 _tokenAmount
448   )
449     internal
450   {
451     token.transfer(_beneficiary, _tokenAmount);
452   }
453 
454   /**
455    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
456    * @param _beneficiary Address receiving the tokens
457    * @param _tokenAmount Number of tokens to be purchased
458    */
459   function _processPurchase(
460     address _beneficiary,
461     uint256 _tokenAmount
462   )
463     internal
464   {
465     _deliverTokens(_beneficiary, _tokenAmount);
466   }
467 
468   /**
469    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
470    * @param _beneficiary Address receiving the tokens
471    * @param _weiAmount Value in wei involved in the purchase
472    */
473   function _updatePurchasingState(
474     address _beneficiary,
475     uint256 _weiAmount
476   )
477     internal
478   {
479     // optional override
480   }
481 
482   /**
483    * @dev Override to extend the way in which ether is converted to tokens.
484    * @param _weiAmount Value in wei to be converted into tokens
485    * @return Number of tokens that can be purchased with the specified _weiAmount
486    */
487   function _getTokenAmount(uint256 _weiAmount)
488     internal view returns (uint256)
489   {
490     return _weiAmount.mul(rate);
491   }
492 
493   /**
494    * @dev Determines how ETH is stored/forwarded on purchases.
495    */
496   function _forwardFunds() internal {
497     wallet.transfer(msg.value);
498   }
499 }
500 
501 /**
502  * @title CappedCrowdsale
503  * @dev Crowdsale with a limit for total contributions.
504  */
505 contract CappedCrowdsale is Crowdsale {
506   using SafeMath for uint256;
507 
508   uint256 public cap;
509 
510   /**
511    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
512    * @param _cap Max amount of wei to be contributed
513    */
514   constructor(uint256 _cap) public {
515     require(_cap > 0);
516     cap = _cap;
517   }
518 
519   /**
520    * @dev Checks whether the cap has been reached.
521    * @return Whether the cap was reached
522    */
523   function capReached() public view returns (bool) {
524     return weiRaised >= cap;
525   }
526 
527   /**
528    * @dev Extend parent behavior requiring purchase to respect the funding cap.
529    * @param _beneficiary Token purchaser
530    * @param _weiAmount Amount of wei contributed
531    */
532   function _preValidatePurchase(
533     address _beneficiary,
534     uint256 _weiAmount
535   )
536     internal
537   {
538     super._preValidatePurchase(_beneficiary, _weiAmount);
539     require(weiRaised.add(_weiAmount) <= cap);
540   }
541 
542 }
543 
544 
545 
546 
547 
548 
549 /**
550  * @title Mintable token
551  * @dev Simple ERC20 Token example, with mintable token creation
552  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
553  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
554  */
555 contract MintableToken is StandardToken, Ownable {
556   event Mint(address indexed to, uint256 amount);
557   event MintFinished();
558 
559   bool public mintingFinished = false;
560 
561 
562   modifier canMint() {
563     require(!mintingFinished);
564     _;
565   }
566 
567   modifier hasMintPermission() {
568     require(msg.sender == owner);
569     _;
570   }
571 
572   /**
573    * @dev Function to mint tokens
574    * @param _to The address that will receive the minted tokens.
575    * @param _amount The amount of tokens to mint.
576    * @return A boolean that indicates if the operation was successful.
577    */
578   function mint(
579     address _to,
580     uint256 _amount
581   )
582     hasMintPermission
583     canMint
584     public
585     returns (bool)
586   {
587     totalSupply_ = totalSupply_.add(_amount);
588     balances[_to] = balances[_to].add(_amount);
589     emit Mint(_to, _amount);
590     emit Transfer(address(0), _to, _amount);
591     return true;
592   }
593 
594   /**
595    * @dev Function to stop minting new tokens.
596    * @return True if the operation was successful.
597    */
598   function finishMinting() onlyOwner canMint public returns (bool) {
599     mintingFinished = true;
600     emit MintFinished();
601     return true;
602   }
603 }
604 /**
605  * @title Capped token
606  * @dev Mintable token with a token cap.
607  */
608 contract CappedToken is MintableToken {
609 
610   uint256 public cap;
611 
612   constructor(uint256 _cap) public {
613     require(_cap > 0);
614     cap = _cap;
615   }
616 
617   /**
618    * @dev Function to mint tokens
619    * @param _to The address that will receive the minted tokens.
620    * @param _amount The amount of tokens to mint.
621    * @return A boolean that indicates if the operation was successful.
622    */
623   function mint(
624     address _to,
625     uint256 _amount
626   )
627     onlyOwner
628     canMint
629     public
630     returns (bool)
631   {
632     require(totalSupply_.add(_amount) <= cap);
633 
634     return super.mint(_to, _amount);
635   }
636 
637 }
638 
639 /**
640  * @title MintedCrowdsale
641  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
642  * Token ownership should be transferred to MintedCrowdsale for minting.
643  */
644 contract MintedCrowdsale is Crowdsale {
645 
646   /**
647    * @dev Overrides delivery by minting tokens upon purchase.
648    * @param _beneficiary Token purchaser
649    * @param _tokenAmount Number of tokens to be minted
650    */
651   function _deliverTokens(
652     address _beneficiary,
653     uint256 _tokenAmount
654   )
655     internal
656   {
657     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
658   }
659 }
660 
661 
662 
663 
664 
665 contract FrameworkInvest is MintedCrowdsale,CappedCrowdsale,  Ownable {
666   
667   mapping(address => bool) public owners;
668 
669   uint8 decimals = 18;  //this should be the token value
670   // ============
671   enum CrowdsaleStage { PS_R1, PS_R2, PS_R3, PS_R4, PS_R5, PS_R6, PS_R7, ICO }
672   CrowdsaleStage public stage = CrowdsaleStage.PS_R1; // By default it's Pre Sale Round 1
673   // =============
674 
675   // Token Distribution
676   // =============================
677   uint256 public maxTokens = 100000000 * (10 ** uint256(decimals)); // There will be total 20 million FRWK Tokens available for sale
678   uint256 public tokensForReserve = 40000000 * (10 ** uint256(decimals)); // 40 million for the eco system reserve
679   uint256 public tokensForBounty = 1000000 * (10 ** uint256(decimals)); // 1 million for token bounty reserve
680   uint256 public totalTokensForSale = 50000000 * (10 ** uint256(decimals)); // 50 million FRWK Tokens will be sold in Crowdsale
681   uint256 public totalTokensForSaleDuringPreICO = 20000000 * (10 ** uint256(decimals)); // 20 million out of 6 million FRWKs will be sold during PreICO
682   // ==============================
683   
684   // Token Funding Rates
685   // ==============================
686   uint256 public DEFAULT_RATE = 500;
687   uint256 public ROUND_1_PRESALE_BONUS = 175; //35%
688   uint256 public ROUND_2_PRESALE_BONUS = 150; //30%
689   uint256 public ROUND_3_PRESALE_BONUS = 125; //25%
690   uint256 public ROUND_4_PRESALE_BONUS = 100; //20%
691   uint256 public ROUND_5_PRESALE_BONUS = 75; //15%
692   uint256 public ROUND_6_PRESALE_BONUS = 50; //10%
693   uint256 public ROUND_7_PRESALE_BONUS = 25; //5%
694   uint256 public ICO_BONUS = 0;
695 
696   // Amount raised in PreICO
697   // ==================
698   uint256 public totalWeiRaisedDuringPreICO;
699   // ===================
700 
701   bool public crowdsaleStarted = true;
702   bool public crowdsalePaused = false;
703   // Events
704   event EthTransferred(string text);
705   event EthRefunded(string text);
706   
707 modifier onlyOwner() {
708     require(isAnOwner(msg.sender));
709     _;
710   }
711 
712   function addNewOwner(address _owner) public onlyOwner{
713     require(_owner != address(0));
714     owners[_owner]= true;
715   }
716 
717   function removeOwner(address _owner) public onlyOwner{
718     require(_owner != address(0));
719     require(_owner != msg.sender);
720     owners[_owner]= false;
721   }
722 
723   function isAnOwner(address _owner) public constant returns(bool) {
724      if (_owner == owner){
725        return true;
726      }
727 
728      return owners[_owner];
729   }
730   
731   modifier hasMintPermission() {
732     require(isAnOwner(msg.sender));
733     _;
734   }
735 
736 
737   function FrameworkInvest(uint256 _rate, address _wallet, uint256 _cap, CappedToken _token) CappedCrowdsale(_cap) Crowdsale(_rate, _wallet, _token) public {
738   }
739   
740   
741   // Crowdsale Stage Management
742     // =========================================================
743     function setCrowdsaleStage(uint value) public onlyOwner {
744 
745         CrowdsaleStage _stage;
746 
747         if (uint(CrowdsaleStage.PS_R1) == value) {
748           _stage = CrowdsaleStage.PS_R1;
749           calculateAndSetRate(ROUND_1_PRESALE_BONUS);
750         } else if (uint(CrowdsaleStage.PS_R2) == value) {
751           _stage = CrowdsaleStage.PS_R2;
752           calculateAndSetRate(ROUND_2_PRESALE_BONUS);
753         } else if (uint(CrowdsaleStage.PS_R3) == value) {
754           _stage = CrowdsaleStage.PS_R3;
755           calculateAndSetRate(ROUND_3_PRESALE_BONUS);
756         } else if (uint(CrowdsaleStage.PS_R4) == value) {
757           _stage = CrowdsaleStage.PS_R4;
758           calculateAndSetRate(ROUND_4_PRESALE_BONUS);
759         } else if (uint(CrowdsaleStage.PS_R5) == value) {
760           _stage = CrowdsaleStage.PS_R5;
761           calculateAndSetRate(ROUND_5_PRESALE_BONUS);
762         } else if (uint(CrowdsaleStage.PS_R6) == value) {
763           _stage = CrowdsaleStage.PS_R6;
764           calculateAndSetRate(ROUND_6_PRESALE_BONUS);
765         } else if (uint(CrowdsaleStage.PS_R7) == value) {
766           _stage = CrowdsaleStage.PS_R7;
767           calculateAndSetRate(ROUND_7_PRESALE_BONUS);
768         } else if (uint(CrowdsaleStage.ICO) == value) {
769           _stage = CrowdsaleStage.ICO;
770           calculateAndSetRate(ICO_BONUS);
771         }
772 
773         stage = _stage;
774     }
775 
776     // Change the current rate
777     function setCurrentRate(uint256 _rate) private {
778         rate = _rate;
779     }
780 
781     // Change the current rate
782     function calculateAndSetRate(uint256 _bonus) private {
783         uint256 calcRate = DEFAULT_RATE + _bonus;
784         setCurrentRate(calcRate);
785     }
786     
787     function setRate(uint256 _rate) public onlyOwner {
788         setCurrentRate(_rate);
789     }
790     
791     function setCrowdSale(bool _started) public onlyOwner {
792         crowdsaleStarted = _started;
793     }
794   // ================ Stage Management Over =====================
795   
796     // Token Purchase
797     // =========================
798     function () external payable {
799        require(!crowdsalePaused);
800         uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
801         if ((stage != CrowdsaleStage.ICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
802           msg.sender.transfer(msg.value); // Refund them
803           EthRefunded("Presale Limit Hit.");
804           return;
805         }
806 
807         buyTokens(msg.sender);
808         EthTransferred("Transferred funds to wallet.");
809         
810         if (stage != CrowdsaleStage.ICO) {
811             totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
812         }
813     }
814   function pauseCrowdsale() public onlyOwner{
815     crowdsalePaused = true;
816   }
817   function unPauseCrowdsale() public onlyOwner{
818     crowdsalePaused = false;
819   }
820     // ===========================
821     // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
822     // ====================================================================
823 
824     function finish(address _reserveFund, address _bountyFund) public onlyOwner {
825         if (crowdsaleStarted){
826             uint256 alreadyMinted = token.totalSupply();
827             require(alreadyMinted < maxTokens);
828 
829             uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
830             if (unsoldTokens > 0) {
831                 tokensForReserve = tokensForReserve + unsoldTokens;
832             }
833             MintableToken(token).mint(_reserveFund,tokensForReserve);
834             MintableToken(token).mint(_bountyFund,tokensForBounty);
835             crowdsaleStarted = false;
836         }
837     }
838   // ===============================
839 }