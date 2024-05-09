1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
57 
58 /**
59  * @title Contracts that should not own Ether
60  * @author Remco Bloemen <remco@2π.com>
61  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
62  * in the contract, it will allow the owner to reclaim this ether.
63  * @notice Ether can still be sent to this contract by:
64  * calling functions labeled `payable`
65  * `selfdestruct(contract_address)`
66  * mining directly to the contract address
67  */
68 contract HasNoEther is Ownable {
69 
70   /**
71   * @dev Constructor that rejects incoming Ether
72   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
73   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
74   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
75   * we could use assembly to access msg.value.
76   */
77   constructor() public payable {
78     require(msg.value == 0);
79   }
80 
81   /**
82    * @dev Disallows direct send by settings a default function without the `payable` flag.
83    */
84   function() external {
85   }
86 
87   /**
88    * @dev Transfer all Ether held by the contract to the owner.
89    */
90   function reclaimEther() external onlyOwner {
91     owner.transfer(this.balance);
92   }
93 }
94 
95 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     if (a == 0) {
108       return 0;
109     }
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/179
149  */
150 contract ERC20Basic {
151   function totalSupply() public view returns (uint256);
152   function balanceOf(address who) public view returns (uint256);
153   function transfer(address to, uint256 value) public returns (bool);
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) balances;
167 
168   uint256 totalSupply_;
169 
170   /**
171   * @dev total number of tokens in existence
172   */
173   function totalSupply() public view returns (uint256) {
174     return totalSupply_;
175   }
176 
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[msg.sender]);
185 
186     balances[msg.sender] = balances[msg.sender].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     emit Transfer(msg.sender, _to, _value);
189     return true;
190   }
191 
192   /**
193   * @dev Gets the balance of the specified address.
194   * @param _owner The address to query the the balance of.
195   * @return An uint256 representing the amount owned by the passed address.
196   */
197   function balanceOf(address _owner) public view returns (uint256) {
198     return balances[_owner];
199   }
200 
201 }
202 
203 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
204 
205 /**
206  * @title Burnable Token
207  * @dev Token that can be irreversibly burned (destroyed).
208  */
209 contract BurnableToken is BasicToken {
210 
211   event Burn(address indexed burner, uint256 value);
212 
213   /**
214    * @dev Burns a specific amount of tokens.
215    * @param _value The amount of token to be burned.
216    */
217   function burn(uint256 _value) public {
218     _burn(msg.sender, _value);
219   }
220 
221   function _burn(address _who, uint256 _value) internal {
222     require(_value <= balances[_who]);
223     // no need to require value <= totalSupply, since that would imply the
224     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
225 
226     balances[_who] = balances[_who].sub(_value);
227     totalSupply_ = totalSupply_.sub(_value);
228     emit Burn(_who, _value);
229     emit Transfer(_who, address(0), _value);
230   }
231 }
232 
233 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
234 
235 /**
236  * @title ERC20 interface
237  * @dev see https://github.com/ethereum/EIPs/issues/20
238  */
239 contract ERC20 is ERC20Basic {
240   function allowance(address owner, address spender)
241     public view returns (uint256);
242 
243   function transferFrom(address from, address to, uint256 value)
244     public returns (bool);
245 
246   function approve(address spender, uint256 value) public returns (bool);
247   event Approval(
248     address indexed owner,
249     address indexed spender,
250     uint256 value
251   );
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
255 
256 /**
257  * @title Standard ERC20 token
258  *
259  * @dev Implementation of the basic standard token.
260  * @dev https://github.com/ethereum/EIPs/issues/20
261  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
262  */
263 contract StandardToken is ERC20, BasicToken {
264 
265   mapping (address => mapping (address => uint256)) internal allowed;
266 
267 
268   /**
269    * @dev Transfer tokens from one address to another
270    * @param _from address The address which you want to send tokens from
271    * @param _to address The address which you want to transfer to
272    * @param _value uint256 the amount of tokens to be transferred
273    */
274   function transferFrom(
275     address _from,
276     address _to,
277     uint256 _value
278   )
279     public
280     returns (bool)
281   {
282     require(_to != address(0));
283     require(_value <= balances[_from]);
284     require(_value <= allowed[_from][msg.sender]);
285 
286     balances[_from] = balances[_from].sub(_value);
287     balances[_to] = balances[_to].add(_value);
288     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289     emit Transfer(_from, _to, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    *
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(
316     address _owner,
317     address _spender
318    )
319     public
320     view
321     returns (uint256)
322   {
323     return allowed[_owner][_spender];
324   }
325 
326   /**
327    * @dev Increase the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To increment
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _addedValue The amount of tokens to increase the allowance by.
335    */
336   function increaseApproval(
337     address _spender,
338     uint _addedValue
339   )
340     public
341     returns (bool)
342   {
343     allowed[msg.sender][_spender] = (
344       allowed[msg.sender][_spender].add(_addedValue));
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349   /**
350    * @dev Decrease the amount of tokens that an owner allowed to a spender.
351    *
352    * approve should be called when allowed[_spender] == 0. To decrement
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _subtractedValue The amount of tokens to decrease the allowance by.
358    */
359   function decreaseApproval(
360     address _spender,
361     uint _subtractedValue
362   )
363     public
364     returns (bool)
365   {
366     uint oldValue = allowed[msg.sender][_spender];
367     if (_subtractedValue > oldValue) {
368       allowed[msg.sender][_spender] = 0;
369     } else {
370       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
371     }
372     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376 }
377 
378 // File: contracts/ChartToken.sol
379 
380 contract ChartToken is StandardToken, BurnableToken, Ownable, HasNoEther {
381     string public constant name = "BetOnChart token";
382     string public constant symbol = "CHART";
383     uint8 public constant decimals = 18; // 1 ether
384     bool public saleFinished;
385     address public saleAgent;
386     address private wallet;
387 
388    /**
389     * @dev Event should be emited when sale agent changed
390     */
391     event SaleAgent(address);
392 
393    /**
394     * @dev ChartToken constructor
395     * All tokens supply will be assign to contract owner.
396     * @param _wallet Wallet to handle initial token emission.
397     */
398     constructor(address _wallet) public {
399         require(_wallet != address(0));
400 
401         totalSupply_ = 50*1e6*(1 ether);
402         saleFinished = false;
403         balances[_wallet] = totalSupply_;
404         wallet = _wallet;
405         saleAgent = address(0);
406     }
407 
408    /**
409     * @dev Modifier to make a function callable only by owner or sale agent.
410     */
411     modifier onlyOwnerOrSaleAgent() {
412         require(msg.sender == owner || msg.sender == saleAgent);
413         _;
414     }
415 
416    /**
417     * @dev Modifier to make a function callable only when a sale is finished.
418     */
419     modifier whenSaleFinished() {
420         require(saleFinished || msg.sender == saleAgent || msg.sender == wallet );
421         _;
422     }
423 
424    /**
425     * @dev Modifier to make a function callable only when a sale is not finished.
426     */
427     modifier whenSaleNotFinished() {
428         require(!saleFinished);
429         _;
430     }
431 
432    /**
433     * @dev Set sale agent
434     * @param _agent The agent address which you want to set.
435     */
436     function setSaleAgent(address _agent) public whenSaleNotFinished onlyOwner {
437         saleAgent = _agent;
438         emit SaleAgent(_agent);
439     }
440 
441    /**
442     * @dev Handle ICO end
443     */
444     function finishSale() public onlyOwnerOrSaleAgent {
445         saleAgent = address(0);
446         emit SaleAgent(saleAgent);
447         saleFinished = true;
448     }
449 
450    /**
451     * @dev Overrides default ERC20
452     */
453     function transfer(address _to, uint256 _value) public whenSaleFinished returns (bool) {
454         return super.transfer(_to, _value);
455     }
456 
457    /**
458     * @dev Overrides default ERC20
459     */
460     function transferFrom(address _from, address _to, uint256 _value) public whenSaleFinished returns (bool) {
461         return super.transferFrom(_from, _to, _value);
462     }
463 }
464 
465 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
466 
467 /**
468  * @title Crowdsale
469  * @dev Crowdsale is a base contract for managing a token crowdsale,
470  * allowing investors to purchase tokens with ether. This contract implements
471  * such functionality in its most fundamental form and can be extended to provide additional
472  * functionality and/or custom behavior.
473  * The external interface represents the basic interface for purchasing tokens, and conform
474  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
475  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
476  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
477  * behavior.
478  */
479 contract Crowdsale {
480   using SafeMath for uint256;
481 
482   // The token being sold
483   ERC20 public token;
484 
485   // Address where funds are collected
486   address public wallet;
487 
488   // How many token units a buyer gets per wei
489   uint256 public rate;
490 
491   // Amount of wei raised
492   uint256 public weiRaised;
493 
494   /**
495    * Event for token purchase logging
496    * @param purchaser who paid for the tokens
497    * @param beneficiary who got the tokens
498    * @param value weis paid for purchase
499    * @param amount amount of tokens purchased
500    */
501   event TokenPurchase(
502     address indexed purchaser,
503     address indexed beneficiary,
504     uint256 value,
505     uint256 amount
506   );
507 
508   /**
509    * @param _rate Number of token units a buyer gets per wei
510    * @param _wallet Address where collected funds will be forwarded to
511    * @param _token Address of the token being sold
512    */
513   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
514     require(_rate > 0);
515     require(_wallet != address(0));
516     require(_token != address(0));
517 
518     rate = _rate;
519     wallet = _wallet;
520     token = _token;
521   }
522 
523   // -----------------------------------------
524   // Crowdsale external interface
525   // -----------------------------------------
526 
527   /**
528    * @dev fallback function ***DO NOT OVERRIDE***
529    */
530   function () external payable {
531     buyTokens(msg.sender);
532   }
533 
534   /**
535    * @dev low level token purchase ***DO NOT OVERRIDE***
536    * @param _beneficiary Address performing the token purchase
537    */
538   function buyTokens(address _beneficiary) public payable {
539 
540     uint256 weiAmount = msg.value;
541     _preValidatePurchase(_beneficiary, weiAmount);
542 
543     // calculate token amount to be created
544     uint256 tokens = _getTokenAmount(weiAmount);
545 
546     // update state
547     weiRaised = weiRaised.add(weiAmount);
548 
549     _processPurchase(_beneficiary, tokens);
550     emit TokenPurchase(
551       msg.sender,
552       _beneficiary,
553       weiAmount,
554       tokens
555     );
556 
557     _updatePurchasingState(_beneficiary, weiAmount);
558 
559     _forwardFunds();
560     _postValidatePurchase(_beneficiary, weiAmount);
561   }
562 
563   // -----------------------------------------
564   // Internal interface (extensible)
565   // -----------------------------------------
566 
567   /**
568    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
569    * @param _beneficiary Address performing the token purchase
570    * @param _weiAmount Value in wei involved in the purchase
571    */
572   function _preValidatePurchase(
573     address _beneficiary,
574     uint256 _weiAmount
575   )
576     internal
577   {
578     require(_beneficiary != address(0));
579     require(_weiAmount != 0);
580   }
581 
582   /**
583    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
584    * @param _beneficiary Address performing the token purchase
585    * @param _weiAmount Value in wei involved in the purchase
586    */
587   function _postValidatePurchase(
588     address _beneficiary,
589     uint256 _weiAmount
590   )
591     internal
592   {
593     // optional override
594   }
595 
596   /**
597    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
598    * @param _beneficiary Address performing the token purchase
599    * @param _tokenAmount Number of tokens to be emitted
600    */
601   function _deliverTokens(
602     address _beneficiary,
603     uint256 _tokenAmount
604   )
605     internal
606   {
607     token.transfer(_beneficiary, _tokenAmount);
608   }
609 
610   /**
611    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
612    * @param _beneficiary Address receiving the tokens
613    * @param _tokenAmount Number of tokens to be purchased
614    */
615   function _processPurchase(
616     address _beneficiary,
617     uint256 _tokenAmount
618   )
619     internal
620   {
621     _deliverTokens(_beneficiary, _tokenAmount);
622   }
623 
624   /**
625    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
626    * @param _beneficiary Address receiving the tokens
627    * @param _weiAmount Value in wei involved in the purchase
628    */
629   function _updatePurchasingState(
630     address _beneficiary,
631     uint256 _weiAmount
632   )
633     internal
634   {
635     // optional override
636   }
637 
638   /**
639    * @dev Override to extend the way in which ether is converted to tokens.
640    * @param _weiAmount Value in wei to be converted into tokens
641    * @return Number of tokens that can be purchased with the specified _weiAmount
642    */
643   function _getTokenAmount(uint256 _weiAmount)
644     internal view returns (uint256)
645   {
646     return _weiAmount.mul(rate);
647   }
648 
649   /**
650    * @dev Determines how ETH is stored/forwarded on purchases.
651    */
652   function _forwardFunds() internal {
653     wallet.transfer(msg.value);
654   }
655 }
656 
657 // File: contracts/lib/TimedCrowdsale.sol
658 
659 /**
660  * @title TimedCrowdsale
661  * @dev Crowdsale accepting contributions only within a time frame.
662  */
663 contract TimedCrowdsale is Crowdsale {
664     using SafeMath for uint256;
665 
666     uint256 public openingTime;
667     uint256 public closingTime;
668 
669     /**
670      * @dev Reverts if not in crowdsale time range.
671      */
672     modifier onlyWhileOpen {
673         // solium-disable-next-line security/no-block-members
674         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
675         _;
676     }
677 
678     /**
679      * @dev Constructor, takes crowdsale opening and closing times.
680      * @param _openingTime Crowdsale opening time
681      * @param _closingTime Crowdsale closing time
682      */
683     constructor(uint256 _openingTime, uint256 _closingTime) public {
684         require(_closingTime >= _openingTime);
685 
686         openingTime = _openingTime;
687         closingTime = _closingTime;
688     }
689 
690     /**
691      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
692      * @return Whether crowdsale period has elapsed
693      */
694     function hasClosed() public view returns (bool) {
695         // solium-disable-next-line security/no-block-members
696         return block.timestamp > closingTime;
697     }
698 
699     /**
700      * @dev Extend parent behavior requiring to be within contributing period
701      * @param _beneficiary Token purchaser
702      * @param _weiAmount Amount of wei contributed
703      */
704     function _preValidatePurchase(
705         address _beneficiary,
706         uint256 _weiAmount
707     )
708     internal
709     onlyWhileOpen
710     {
711         super._preValidatePurchase(_beneficiary, _weiAmount);
712     }
713 
714 }
715 
716 // File: contracts/lib/WhitelistedCrowdsale.sol
717 
718 /**
719  * @title WhitelistedCrowdsale
720  * @dev Crowdsale in which only whitelisted users can contribute.
721  */
722 contract WhitelistedCrowdsale is Crowdsale, Ownable {
723     using SafeMath for uint256;
724 
725    /**
726     * @dev Minimal contract to whitelisted addresses
727     */
728     struct Contract
729     {
730         uint256 rate;   // Token rate
731         uint256 minInvestment; // Minimal investment
732     }
733 
734     mapping(address => bool) public whitelist;
735     mapping(address => Contract) public contracts;
736 
737     /**
738      * @dev Reverts if beneficiary is not whitelisted.
739      */
740     modifier isWhitelisted(address _beneficiary) {
741         require(whitelist[_beneficiary]);
742         _;
743     }
744 
745     /**
746      * @dev Reverts if beneficiary is not invests minimal ether amount.
747      */
748     modifier isMinimalInvestment(address _beneficiary, uint256 _weiAmount) {
749         require(_weiAmount >= contracts[_beneficiary].minInvestment);
750         _;
751     }
752 
753     /**
754      * @dev Adds single address to whitelist.
755      * @param _beneficiary Address to be added to the whitelist
756      * @param _bonus Token bonus from 0% to 300%
757      * @param _minInvestment Minimal investment
758      */
759     function addToWhitelist(address _beneficiary, uint16 _bonus, uint256 _minInvestment) external onlyOwner {
760         require(_bonus <= 300);
761 
762         whitelist[_beneficiary] = true;
763         Contract storage beneficiaryContract = contracts[_beneficiary];
764         beneficiaryContract.rate = rate.add(rate.mul(_bonus).div(100));
765         beneficiaryContract.minInvestment = _minInvestment.mul(1 ether);
766     }
767 
768     /**
769      * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
770      * @param _beneficiaries Addresses to be added to the whitelist
771      * @param _bonus Token bonus from 0% to 300%
772      * @param _minInvestment Minimal investment
773      */
774     function addManyToWhitelist(address[] _beneficiaries, uint16 _bonus, uint256 _minInvestment) external onlyOwner {
775         require(_bonus <= 300);
776 
777         for (uint256 i = 0; i < _beneficiaries.length; i++) {
778             whitelist[_beneficiaries[i]] = true;
779             Contract storage beneficiaryContract = contracts[_beneficiaries[i]];
780             beneficiaryContract.rate = rate.add(rate.mul(_bonus).div(100));
781             beneficiaryContract.minInvestment = _minInvestment.mul(1 ether);
782         }
783     }
784 
785     /**
786      * @dev Removes single address from whitelist.
787      * @param _beneficiary Address to be removed to the whitelist
788      */
789     function removeFromWhitelist(address _beneficiary) external onlyOwner {
790         whitelist[_beneficiary] = false;
791     }
792 
793     /**
794      * @dev Extend parent behavior requiring beneficiary to be in whitelist.
795      * @param _beneficiary Token beneficiary
796      * @param _weiAmount Amount of wei contributed
797      */
798     function _preValidatePurchase(
799         address _beneficiary,
800         uint256 _weiAmount
801     )
802     internal
803     isWhitelisted(_beneficiary)
804     isMinimalInvestment(_beneficiary, _weiAmount)
805     {
806         super._preValidatePurchase(_beneficiary, _weiAmount);
807     }
808 
809     /**
810     * @dev The way in which ether is converted to tokens. Overrides default function.
811     * @param _weiAmount Value in wei to be converted into tokens
812     * @return Number of tokens that can be purchased with the specified _weiAmount
813     */
814     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256)
815     {
816         return _weiAmount.mul(contracts[msg.sender].rate);
817     }
818 }
819 
820 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
821 
822 /**
823  * @title AllowanceCrowdsale
824  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
825  */
826 contract AllowanceCrowdsale is Crowdsale {
827   using SafeMath for uint256;
828 
829   address public tokenWallet;
830 
831   /**
832    * @dev Constructor, takes token wallet address.
833    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
834    */
835   constructor(address _tokenWallet) public {
836     require(_tokenWallet != address(0));
837     tokenWallet = _tokenWallet;
838   }
839 
840   /**
841    * @dev Checks the amount of tokens left in the allowance.
842    * @return Amount of tokens left in the allowance
843    */
844   function remainingTokens() public view returns (uint256) {
845     return token.allowance(tokenWallet, this);
846   }
847 
848   /**
849    * @dev Overrides parent behavior by transferring tokens from wallet.
850    * @param _beneficiary Token purchaser
851    * @param _tokenAmount Amount of tokens purchased
852    */
853   function _deliverTokens(
854     address _beneficiary,
855     uint256 _tokenAmount
856   )
857     internal
858   {
859     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
860   }
861 }
862 
863 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
864 
865 /**
866  * @title CappedCrowdsale
867  * @dev Crowdsale with a limit for total contributions.
868  */
869 contract CappedCrowdsale is Crowdsale {
870   using SafeMath for uint256;
871 
872   uint256 public cap;
873 
874   /**
875    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
876    * @param _cap Max amount of wei to be contributed
877    */
878   constructor(uint256 _cap) public {
879     require(_cap > 0);
880     cap = _cap;
881   }
882 
883   /**
884    * @dev Checks whether the cap has been reached.
885    * @return Whether the cap was reached
886    */
887   function capReached() public view returns (bool) {
888     return weiRaised >= cap;
889   }
890 
891   /**
892    * @dev Extend parent behavior requiring purchase to respect the funding cap.
893    * @param _beneficiary Token purchaser
894    * @param _weiAmount Amount of wei contributed
895    */
896   function _preValidatePurchase(
897     address _beneficiary,
898     uint256 _weiAmount
899   )
900     internal
901   {
902     super._preValidatePurchase(_beneficiary, _weiAmount);
903     require(weiRaised.add(_weiAmount) <= cap);
904   }
905 
906 }
907 
908 // File: contracts/ChartPresale.sol
909 
910 contract ChartPresale is WhitelistedCrowdsale, AllowanceCrowdsale, TimedCrowdsale, CappedCrowdsale {
911     using SafeMath for uint256;
912 
913     string public constant name = "BetOnChart token presale";
914 
915     constructor(uint256 _rate, address _tokenWallet, address _ethWallet, ChartToken _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime) public
916     Crowdsale(_rate, _ethWallet, _token)
917     AllowanceCrowdsale(_tokenWallet)
918     TimedCrowdsale(_openingTime, _closingTime)
919     CappedCrowdsale(_cap) {}
920 }