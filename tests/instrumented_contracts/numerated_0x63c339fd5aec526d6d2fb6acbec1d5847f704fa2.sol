1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title Pausable
117  * @dev Base contract which allows children to implement an emergency stop mechanism.
118  */
119 contract Pausable is Ownable {
120   event Pause();
121   event Unpause();
122 
123   bool public paused = false;
124 
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is not paused.
128    */
129   modifier whenNotPaused() {
130     require(!paused);
131     _;
132   }
133 
134   /**
135    * @dev Modifier to make a function callable only when the contract is paused.
136    */
137   modifier whenPaused() {
138     require(paused);
139     _;
140   }
141 
142   /**
143    * @dev called by the owner to pause, triggers stopped state
144    */
145   function pause() public onlyOwner whenNotPaused {
146     paused = true;
147     emit Pause();
148   }
149 
150   /**
151    * @dev called by the owner to unpause, returns to normal state
152    */
153   function unpause() public onlyOwner whenPaused {
154     paused = false;
155     emit Unpause();
156   }
157 }
158 
159 /**
160  * @title ERC20Basic
161  * @dev Simpler version of ERC20 interface
162  * See https://github.com/ethereum/EIPs/issues/179
163  */
164 contract ERC20Basic {
165   function totalSupply() public view returns (uint256);
166   function balanceOf(address _who) public view returns (uint256);
167   function transfer(address _to, uint256 _value) public returns (bool);
168   event Transfer(address indexed from, address indexed to, uint256 value);
169 }
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address _owner, address _spender)
177     public view returns (uint256);
178 
179   function transferFrom(address _from, address _to, uint256 _value)
180     public returns (bool);
181 
182   function approve(address _spender, uint256 _value) public returns (bool);
183   event Approval(
184     address indexed owner,
185     address indexed spender,
186     uint256 value
187   );
188 }
189 
190 /**
191  * @title Basic token
192  * @dev Basic version of StandardToken, with no allowances.
193  */
194 contract BasicToken is ERC20Basic {
195   using SafeMath for uint256;
196 
197   mapping(address => uint256) internal balances;
198 
199   uint256 internal totalSupply_;
200 
201   /**
202   * @dev Total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return totalSupply_;
206   }
207 
208   /**
209   * @dev Transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) public returns (bool) {
214     require(_value <= balances[msg.sender]);
215     require(_to != address(0));
216 
217     balances[msg.sender] = balances[msg.sender].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     emit Transfer(msg.sender, _to, _value);
220     return true;
221   }
222 
223   /**
224   * @dev Gets the balance of the specified address.
225   * @param _owner The address to query the the balance of.
226   * @return An uint256 representing the amount owned by the passed address.
227   */
228   function balanceOf(address _owner) public view returns (uint256) {
229     return balances[_owner];
230   }
231 
232 }
233 
234 /**
235  * @title Standard ERC20 token
236  *
237  * @dev Implementation of the basic standard token.
238  * https://github.com/ethereum/EIPs/issues/20
239  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
240  */
241 contract StandardToken is ERC20, BasicToken {
242 
243   mapping (address => mapping (address => uint256)) internal allowed;
244 
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262     require(_to != address(0));
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(
293     address _owner,
294     address _spender
295    )
296     public
297     view
298     returns (uint256)
299   {
300     return allowed[_owner][_spender];
301   }
302 
303   /**
304    * @dev Increase the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed[_spender] == 0. To increment
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _addedValue The amount of tokens to increase the allowance by.
311    */
312   function increaseApproval(
313     address _spender,
314     uint256 _addedValue
315   )
316     public
317     returns (bool)
318   {
319     allowed[msg.sender][_spender] = (
320       allowed[msg.sender][_spender].add(_addedValue));
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spender.
327    * approve should be called when allowed[_spender] == 0. To decrement
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param _spender The address which will spend the funds.
332    * @param _subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   function decreaseApproval(
335     address _spender,
336     uint256 _subtractedValue
337   )
338     public
339     returns (bool)
340   {
341     uint256 oldValue = allowed[msg.sender][_spender];
342     if (_subtractedValue >= oldValue) {
343       allowed[msg.sender][_spender] = 0;
344     } else {
345       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
346     }
347     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348     return true;
349   }
350 
351 }
352 
353 /**
354  * @title Burnable Token
355  * @dev Token that can be irreversibly burned (destroyed).
356  */
357 contract BurnableToken is BasicToken {
358 
359   event Burn(address indexed burner, uint256 value);
360 
361   /**
362    * @dev Burns a specific amount of tokens.
363    * @param _value The amount of token to be burned.
364    */
365   function burn(uint256 _value) public {
366     _burn(msg.sender, _value);
367   }
368 
369   function _burn(address _who, uint256 _value) internal {
370     require(_value <= balances[_who]);
371     // no need to require value <= totalSupply, since that would imply the
372     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
373 
374     balances[_who] = balances[_who].sub(_value);
375     totalSupply_ = totalSupply_.sub(_value);
376     emit Burn(_who, _value);
377     emit Transfer(_who, address(0), _value);
378   }
379 }
380 
381 /**
382  * @title Mintable token
383  * @dev Simple ERC20 Token example, with mintable token creation
384  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
385  */
386 contract MintableToken is StandardToken, Ownable {
387   event Mint(address indexed to, uint256 amount);
388   event MintFinished();
389 
390   bool public mintingFinished = false;
391 
392 
393   modifier canMint() {
394     require(!mintingFinished);
395     _;
396   }
397 
398   modifier hasMintPermission() {
399     require(msg.sender == owner);
400     _;
401   }
402 
403   /**
404    * @dev Function to mint tokens
405    * @param _to The address that will receive the minted tokens.
406    * @param _amount The amount of tokens to mint.
407    * @return A boolean that indicates if the operation was successful.
408    */
409   function mint(
410     address _to,
411     uint256 _amount
412   )
413     public
414     hasMintPermission
415     canMint
416     returns (bool)
417   {
418     totalSupply_ = totalSupply_.add(_amount);
419     balances[_to] = balances[_to].add(_amount);
420     emit Mint(_to, _amount);
421     emit Transfer(address(0), _to, _amount);
422     return true;
423   }
424 
425   /**
426    * @dev Function to stop minting new tokens.
427    * @return True if the operation was successful.
428    */
429   function finishMinting() public onlyOwner canMint returns (bool) {
430     mintingFinished = true;
431     emit MintFinished();
432     return true;
433   }
434 }
435 
436 /**
437 * @title Crowdsale
438 * @dev Crowdsale is a base contract for managing a token crowdsale
439 * behavior.
440 */
441 contract Crowdsale is Ownable{
442   using SafeMath for uint256;
443 
444   // Address where funds are collected
445   address public wallet;
446 
447   // Amount of wei raised
448   uint256 public weiRaised;
449 
450   bool public isFinalized = false;
451 
452   uint256 public openingTime;
453   uint256 public closingTime;
454 
455   event Finalized();
456 
457   /**
458   * Event for token purchase logging
459   * @param purchaser who paid for the tokens
460   * @param beneficiary who got the tokens
461   * @param value weis paid for purchase
462   * @param amount amount of tokens purchased
463   */
464   event TokenPurchase(
465     address indexed purchaser,
466     address indexed beneficiary,
467     uint256 value,
468     uint256 amount
469   );
470 
471   /**
472   * @dev Reverts if not in crowdsale time range.
473   */
474   modifier onlyWhileOpen {
475     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
476     _;
477   }
478   
479   /**
480   * @param _wallet Address where collected funds will be forwarded to
481   * @param _openingTime Crowdsale opening time
482   * @param _closingTime Crowdsale closing time
483   */
484   constructor(address _wallet, uint256 _openingTime, uint256 _closingTime) public {
485     require(_wallet != address(0));
486     require(_openingTime >= block.timestamp);
487     require(_closingTime >= _openingTime);
488 
489     openingTime = _openingTime;
490     closingTime = _closingTime;
491 
492     wallet = _wallet;
493   }
494 
495   // -----------------------------------------
496   // Crowdsale external interface
497   // -----------------------------------------
498 
499   /**
500   * @dev fallback function ***DO NOT OVERRIDE***
501   */
502   function () external payable {
503     buyTokens(msg.sender);
504   }
505 
506   /**
507   * @dev low level token purchase ***DO NOT OVERRIDE***
508   * @param _beneficiary Address performing the token purchase
509   */
510   function buyTokens(address _beneficiary) public payable {
511 
512     uint256 weiAmount = msg.value;
513     _preValidatePurchase(_beneficiary, weiAmount);
514 
515     // calculate token amount to be created
516     uint256 tokens = _getTokenAmount(weiAmount);
517 
518     // update state
519     weiRaised = weiRaised.add(weiAmount);
520 
521     _processPurchase(_beneficiary, tokens);
522     emit TokenPurchase(
523       msg.sender,
524       _beneficiary,
525       weiAmount,
526       tokens
527     );
528 
529     _forwardFunds();
530   }
531 
532   /**
533   * @dev Must be called after crowdsale ends, to do some extra finalization
534   * work. Calls the contract's finalization function.
535   */
536   function finalize() public onlyOwner {
537     require(!isFinalized);
538     require(hasClosed());
539 
540     emit Finalized();
541 
542     isFinalized = true;
543   }
544 
545   // -----------------------------------------
546   // Internal interface (extensible)
547   // -----------------------------------------
548 
549   /**
550   * @dev Validation of an incoming purchase.
551   * @param _beneficiary Address performing the token purchase
552   * @param _weiAmount Value in wei involved in the purchase
553   */
554   function _preValidatePurchase(
555     address _beneficiary,
556     uint256 _weiAmount
557   )
558     internal view
559     onlyWhileOpen
560   {
561     require(_beneficiary != address(0));
562     require(_weiAmount != 0);
563   }
564 
565   /**
566   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
567   * @param _beneficiary Address performing the token purchase
568   * @param _tokenAmount Number of tokens to be emitted
569   */
570    function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal;
571 
572   /**
573   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
574   * @param _beneficiary Address receiving the tokens
575   * @param _tokenAmount Number of tokens to be purchased
576   */
577   function _processPurchase(
578     address _beneficiary,
579     uint256 _tokenAmount
580   )
581     internal
582   {
583     _deliverTokens(_beneficiary, _tokenAmount);
584   }
585 
586   /**
587   * @dev Determines how ETH is stored/forwarded on purchases.
588   */
589   function _forwardFunds() internal {
590     wallet.transfer(msg.value);
591   }
592 
593   /**
594   * @dev Override to extend the way in which ether is converted to tokens.
595   * @param weiAmount Value in wei to be converted into tokens
596   * @return Number of tokens that can be purchased with the specified _weiAmount
597   */
598   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256);
599 
600   /**
601   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
602   * @return Whether crowdsale period has elapsed
603   */
604   function hasClosed() public view returns (bool) {
605     return block.timestamp > closingTime;
606   }
607 
608 }
609 
610 contract FieldCoin is MintableToken, BurnableToken{
611 
612     using SafeMath for uint256;
613     
614     //name of token
615     string public name;
616     //token symbol
617     string public symbol;
618     //decimals in token
619     uint8 public decimals;
620     //address of bounty wallet
621     address public bountyWallet;
622     //address of team wallet
623     address public teamWallet;
624     //flag to set token release true=> token is ready for transfer
625     bool public transferEnabled;
626     //token available for offering
627     uint256 public TOKEN_OFFERING_ALLOWANCE = 770e6 * 10 **18;//770 million(sale+bonus)
628     // Address of token offering
629     address public tokenOfferingAddr;
630     //address to collect tokens when land is transferred
631     address public landCollectorAddr;
632 
633     mapping(address => bool) public transferAgents;
634     //mapping for blacklisted address
635     mapping(address => bool) private blacklist;
636 
637     /**
638     * Check if transfer is allowed
639     *
640     * Permissions:
641     *                                                       Owner  OffeirngContract    Others
642     * transfer (before transferEnabled is true)               y            n              n
643     * transferFrom (before transferEnabled is true)           y            y              y
644     * transfer/transferFrom after transferEnabled is true     y            n              y
645     */    
646     modifier canTransfer(address sender) {
647         require(transferEnabled || transferAgents[sender], "transfer is not enabled or sender is not allowed");
648           _;
649     }
650 
651     /**
652     * Check if token offering address is set or not
653     */
654     modifier onlyTokenOfferingAddrNotSet() {
655         require(tokenOfferingAddr == address(0x0), "token offering address is already set");
656         _;
657     }
658 
659     /**
660     * Check if land collector address is set or not
661     */
662     modifier onlyWhenLandCollectporAddressIsSet() {
663         require(landCollectorAddr != address(0x0), "land collector address is not set");
664         _;
665     }
666 
667 
668     /**
669     * Check if address is a valid destination to transfer tokens to
670     * - must not be zero address
671     * - must not be the token address
672     * - must not be the owner's address
673     * - must not be the token offering contract address
674     */
675     modifier validDestination(address to) {
676         require(to != address(0x0), "receiver can't be zero address");
677         require(to != address(this), "receiver can't be token address");
678         require(to != owner, "receiver can't be owner");
679         require(to != address(tokenOfferingAddr), "receiver can't be token offering address");
680         _;
681     }
682 
683     /**
684     * @dev Constuctor of the contract
685     *
686     */
687     constructor () public {
688         name    =   "Fieldcoin";
689         symbol  =   "FLC";
690         decimals    =   18;  
691         totalSupply_ =   1000e6 * 10  **  uint256(decimals); //1000 million
692         owner   =   msg.sender;
693         balances[owner] = totalSupply_;
694     }
695 
696     /**
697     * @dev set bounty wallet
698     * @param _bountyWallet address of bounty wallet.
699     *
700     */
701     function setBountyWallet (address _bountyWallet) public onlyOwner returns (bool) {
702         require(_bountyWallet != address(0x0), "bounty address can't be zero");
703         if(bountyWallet == address(0x0)){  
704             bountyWallet = _bountyWallet;
705             balances[bountyWallet] = 20e6 * 10   **  uint256(decimals); //20 million
706             balances[owner] = balances[owner].sub(20e6 * 10   **  uint256(decimals));
707         }else{
708             address oldBountyWallet = bountyWallet;
709             bountyWallet = _bountyWallet;
710             balances[bountyWallet] = balances[oldBountyWallet];
711         }
712         return true;
713     }
714 
715     /**
716     * @dev set team wallet
717     * @param _teamWallet address of bounty wallet.
718     *
719     */
720     function setTeamWallet (address _teamWallet) public onlyOwner returns (bool) {
721         require(_teamWallet != address(0x0), "team address can't be zero");
722         if(teamWallet == address(0x0)){  
723             teamWallet = _teamWallet;
724             balances[teamWallet] = 90e6 * 10   **  uint256(decimals); //90 million
725             balances[owner] = balances[owner].sub(90e6 * 10   **  uint256(decimals));
726         }else{
727             address oldTeamWallet = teamWallet;
728             teamWallet = _teamWallet;
729             balances[teamWallet] = balances[oldTeamWallet];
730         }
731         return true;
732     }
733 
734     /**
735     * @dev transfer token to a specified address (written due to backward compatibility)
736     * @param to address to which token is transferred
737     * @param value amount of tokens to transfer
738     * return bool true=> transfer is succesful
739     */
740     function transfer(address to, uint256 value) canTransfer(msg.sender) validDestination(to) public returns (bool) {
741         return super.transfer(to, value);
742     }
743 
744     /**
745     * @dev Transfer tokens from one address to another
746     * @param from address from which token is transferred 
747     * @param to address to which token is transferred
748     * @param value amount of tokens to transfer
749     * @return bool true=> transfer is succesful
750     */
751     function transferFrom(address from, address to, uint256 value) canTransfer(msg.sender) validDestination(to) public returns (bool) {
752         return super.transferFrom(from, to, value);
753     }
754 
755     /**
756     * @dev add addresses to the blacklist
757     * @return true if address was added to the blacklist,
758     * false if address were already in the blacklist
759     */
760     function addBlacklistAddress(address addr) public onlyOwner {
761         require(!isBlacklisted(addr), "address is already blacklisted");
762         require(addr != address(0x0), "blacklisting address can't be zero");
763         // blacklisted so they can withdraw
764         blacklist[addr] = true;
765     }
766 
767     /**
768     * @dev Set token offering to approve allowance for offering contract to distribute tokens
769     *
770     * @param offeringAddr Address of token offerng contract i.e., fieldcoinsale contract
771     * @param amountForSale Amount of tokens for sale, set 0 to max out
772     */
773     function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
774         require (offeringAddr != address(0x0), "offering address can't be zero");
775         require(!transferEnabled, "transfer should be diabled");
776 
777         uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
778         require(amount <= TOKEN_OFFERING_ALLOWANCE);
779 
780         approve(offeringAddr, amount);
781         tokenOfferingAddr = offeringAddr;
782         //start the transfer for offeringAddr
783         setTransferAgent(tokenOfferingAddr, true);
784 
785     }
786 
787     /**
788     * @dev set land collector address
789     *
790     */
791     function setLandCollector(address collectorAddr) public onlyOwner {
792         require (collectorAddr != address(0x0), "land collecting address can't be set to zero");
793         require(!transferEnabled,  "transfer should be diabled");
794         landCollectorAddr = collectorAddr;
795     }
796 
797 
798     /**
799     * @dev release tokens for transfer
800     *
801     */
802     function enableTransfer() public onlyOwner {
803         transferEnabled = true;
804         // End the offering
805         approve(tokenOfferingAddr, 0);
806         //stop the transfer for offeringAddr
807         setTransferAgent(tokenOfferingAddr, false);
808     }
809 
810     /**
811     * @dev Set transfer agent to true for transfer tokens for private investor and exchange
812     * @param _addr who will be allowd for transfer
813     * @param _allowTransfer true=>allowed
814     *
815     */
816     function setTransferAgent(address _addr, bool _allowTransfer) public onlyOwner {
817         transferAgents[_addr] = _allowTransfer;
818     }
819 
820     /**
821     * @dev withdraw if KYC not verified
822     * @param _investor investor whose tokens are to be withdrawn
823     * @param _tokens amount of tokens to be withdrawn
824     */
825     function _withdraw(address _investor, uint256 _tokens) external{
826         require (msg.sender == tokenOfferingAddr, "sender must be offering address");
827         require (isBlacklisted(_investor), "address is not whitelisted");
828         balances[owner] = balances[owner].add(_tokens);
829         balances[_investor] = balances[_investor].sub(_tokens);
830         balances[_investor] = 0;
831     }
832 
833     /**
834     * @dev buy land during ICO
835     * @param _investor investor whose tokens are to be transferred
836     * @param _tokens amount of tokens to be transferred
837     */
838     function _buyLand(address _investor, uint256 _tokens) external onlyWhenLandCollectporAddressIsSet{
839         require (!transferEnabled, "transfer should be diabled");
840         require (msg.sender == tokenOfferingAddr, "sender must be offering address");
841         balances[landCollectorAddr] = balances[landCollectorAddr].add(_tokens);
842         balances[_investor] = balances[_investor].sub(_tokens);
843     }
844 
845    /**
846    * @dev Burns a specific amount of tokens.
847    * @param _value The amount of token to be burned.
848    */
849     function burn(uint256 _value) public {
850         require(transferEnabled || msg.sender == owner, "transfer is not enabled or sender is not owner");
851         super.burn(_value);
852     }
853 
854     /**
855     * @dev check address is blacklisted or not
856     * @param _addr who will be checked
857     * @return true=> if blacklisted, false=> if not
858     *
859     */
860     function isBlacklisted(address _addr) public view returns(bool){
861         return blacklist[_addr];
862     }
863 
864 }
865 
866 contract FieldCoinSale is Crowdsale, Pausable{
867 
868     using SafeMath for uint256;
869 
870     //To store tokens supplied during CrowdSale
871     uint256 public totalSaleSupply = 600000000 *10 **18; // 600 million tokens
872     //price of token in cents
873     uint256 public tokenCost = 5; //5 cents i.e., .5$
874     //1 eth = usd in cents, eg: 1 eth = 107.91$ so, 1 eth = =107,91 cents
875     uint256 public ETH_USD;
876     //min contribution 
877     uint256 public minContribution = 10000; //100,00 cents i.e., 100$
878     //max contribution 
879     uint256 public maxContribution = 100000000; //100 million cents i.e., 1 million dollar
880     //count for bonus
881     uint256 public milestoneCount;
882     //flag to check bonus is initialized or not
883     bool public initialized = false;
884     //total number of bonus tokens
885     uint256 public bonusTokens = 170e6 * 10 ** 18; //170 millions
886     //tokens for sale
887     uint256 public tokensSold = 0;
888     //object of FieldCoin
889     FieldCoin private objFieldCoin;
890 
891     struct Milestone {
892         uint256 bonus;
893         uint256 total;
894     }
895 
896     Milestone[6] public milestones;
897     
898     //Structure to store token sent and wei received by the buyer of tokens
899     struct Investor {
900         uint256 weiReceived;
901         uint256 tokenSent;
902         uint256 bonusSent;
903     }
904 
905     //investors indexed by their ETH address
906     mapping(address => Investor) public investors;
907 
908     //event triggered when tokens are withdrawn
909     event Withdrawn();
910 
911     /**
912     * @dev Constuctor of the contract
913     *
914     */
915     constructor (uint256 _openingTime, uint256 _closingTime, address _wallet, address _token, uint256 _ETH_USD, uint256 _minContribution, uint256 _maxContribution) public
916     Crowdsale(_wallet, _openingTime, _closingTime) {
917         require(_ETH_USD > 0, "ETH USD rate should be greater than 0");
918         minContribution = (_minContribution == 0) ? minContribution : _minContribution;
919         maxContribution = (_maxContribution == 0) ? maxContribution : _maxContribution;
920         ETH_USD = _ETH_USD;
921         objFieldCoin = FieldCoin(_token);
922     }
923 
924     /**
925     * @dev Set eth usd rate
926     * @param _ETH_USD stores ether value in cents
927     *       i.e., 1 ETH = 107.01 $ so, 1 ETH = 10701 cents
928     *
929     */
930     function setETH_USDRate(uint256 _ETH_USD) public onlyOwner{
931         require(_ETH_USD > 0, "ETH USD rate should be greater than 0");
932         ETH_USD = _ETH_USD;
933     }
934 
935     /**
936     * @dev Set new coinbase(wallet) address
937     * @param _newWallet wallet address
938     *
939     */
940     function setNewWallet(address _newWallet) onlyOwner public {
941         wallet = _newWallet;
942     }
943 
944     /**
945     * @dev Set new minimum contribution
946     * @param _minContribution minimum contribution in cents
947     *
948     */
949     function changeMinContribution(uint256 _minContribution) public onlyOwner {
950         require(_minContribution > 0, "min contribution should be greater than 0");
951         minContribution = _minContribution;
952     }
953 
954     /**
955     * @dev Set new maximum contribution
956     * @param _maxContribution maximum contribution in cents
957     *
958     */
959     function changeMaxContribution(uint256 _maxContribution) public onlyOwner {
960         require(_maxContribution > 0, "max contribution should be greater than 0");
961         maxContribution = _maxContribution;
962     }
963 
964     /**
965     * @dev Set new token cost
966     * @param _tokenCost price of 1 token in cents
967     */
968     function changeTokenCost(uint256 _tokenCost) public onlyOwner {
969         require(_tokenCost > 0, "token cost can not be zero");
970         tokenCost = _tokenCost;
971     }
972 
973     /**
974     * @dev Set new opening time
975     * @param _openingTime time in UTX
976     *
977     */
978     function changeOpeningTIme(uint256 _openingTime) public onlyOwner {
979         require(_openingTime >= block.timestamp, "opening time is less than current time");
980         openingTime = _openingTime;
981     }
982 
983     /**
984     * @dev Set new closing time
985     * @param _closingTime time in UTX
986     *
987     */
988     function changeClosingTime(uint256 _closingTime) public onlyOwner {
989         require(_closingTime >= openingTime, "closing time is less than opening time");
990         closingTime = _closingTime;
991     }
992 
993     /**
994     * @dev initialize bonuses
995     * @param _bonus tokens bonus in array depends on their slab
996     * @param _total slab of tokens bonuses in array
997     */
998     function initializeMilestones(uint256[] _bonus, uint256[] _total) public onlyOwner {
999         require(_bonus.length > 0 && _bonus.length == _total.length);
1000         for(uint256 i = 0; i < _bonus.length; i++) {
1001             milestones[i] = Milestone({ total: _total[i], bonus: _bonus[i] });
1002         }
1003         milestoneCount = _bonus.length;
1004         initialized = true;
1005     }
1006 
1007     /**
1008     * @dev function processing tokens and bonuses
1009     * will over ride the function in Crowdsale.sol
1010     * @param _beneficiary who will receive tokens
1011     * @param _tokenAmount amount of tokens to send without bonus
1012     *
1013     */
1014     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1015         require(tokensRemaining() >= _tokenAmount, "token need to be transferred is more than the available token");
1016         uint256 _bonusTokens = _processBonus(_tokenAmount);
1017         bonusTokens = bonusTokens.sub(_bonusTokens);
1018         tokensSold = tokensSold.add(_tokenAmount);
1019         // accumulate total token to be given
1020         uint256 totalNumberOfTokenTransferred = _tokenAmount.add(_bonusTokens);
1021         //initializing structure for the address of the beneficiary
1022         Investor storage _investor = investors[_beneficiary];
1023         //Update investor's balance
1024         _investor.tokenSent = _investor.tokenSent.add(totalNumberOfTokenTransferred);
1025         _investor.weiReceived = _investor.weiReceived.add(msg.value);
1026         _investor.bonusSent = _investor.bonusSent.add(_bonusTokens);
1027         super._processPurchase(_beneficiary, totalNumberOfTokenTransferred);
1028     }
1029 
1030      /**
1031     * @dev send token manually to people who invest other than ether
1032     * @param _beneficiary Address performing the token purchase
1033     * @param weiAmount amount of wei invested
1034     */
1035     function createTokenManually(address _beneficiary, uint256 weiAmount) external onlyOwner {
1036         // calculate token amount to be created
1037         uint256 tokens = _getTokenAmount(weiAmount);
1038         
1039         // update state
1040         weiRaised = weiRaised.add(weiAmount);
1041     
1042         _processPurchase(_beneficiary, tokens);
1043         emit TokenPurchase(
1044           msg.sender,
1045           _beneficiary,
1046           weiAmount,
1047           tokens
1048         );
1049     }
1050 
1051     /**
1052     * @dev Source of tokens.
1053     * @param _beneficiary Address performing the token purchase
1054     * @param _tokenAmount Number of tokens to be emitted
1055     */
1056     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1057         if(!objFieldCoin.transferFrom(objFieldCoin.owner(), _beneficiary, _tokenAmount)){
1058             revert("token delivery failed");
1059         }
1060     }
1061 
1062     /**
1063     * @dev withdraw if KYC not verified
1064     */
1065     function withdraw() external{
1066         Investor storage _investor = investors[msg.sender];
1067         //transfer investor's balance to owner
1068         objFieldCoin._withdraw(msg.sender, _investor.tokenSent);
1069         //return the ether to the investor balance
1070         msg.sender.transfer(_investor.weiReceived);
1071         //set everything to zero after transfer successful
1072         _investor.weiReceived = 0;
1073         _investor.tokenSent = 0;
1074         _investor.bonusSent = 0;
1075         emit Withdrawn();
1076     }
1077 
1078     /**
1079     * @dev buy land during ICO
1080     * @param _tokens amount of tokens to be transferred
1081     */
1082     function buyLand(uint256 _tokens) external{
1083         Investor memory _investor = investors[msg.sender];
1084         require (_tokens <= objFieldCoin.balanceOf(msg.sender).sub(_investor.bonusSent), "token to buy land is more than the available number of tokens");
1085         //transfer investor's balance to land collector
1086         objFieldCoin._buyLand(msg.sender, _tokens);
1087     }
1088 
1089     /*
1090     * @dev Function to add Ether in the contract 
1091     */
1092     function fundContractForWithdraw()external payable{
1093     }
1094 
1095     /**
1096     * @dev increase bonus allowance if exhausted
1097     * @param _value amount of token bonus to increase in 18 decimal places
1098     *
1099     */
1100     function increaseBonusAllowance(uint256 _value) public onlyOwner {
1101         bonusTokens = bonusTokens.add(_value);
1102     }
1103     
1104     // -----------------------------------------
1105     // Getter interface
1106     // -----------------------------------------
1107 
1108     /**
1109     * @dev Validation of an incoming purchase.
1110     * @param _beneficiary Address performing the token purchase
1111     * @param _weiAmount Value in wei involved in the purchase
1112     */
1113     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) whenNotPaused internal view{
1114         require (!hasClosed(), "Sale has been ended");
1115         require(initialized, "Bonus is not initialized");
1116         require(_weiAmount >= getMinContributionInWei(), "amount is less than min contribution");
1117         require(_weiAmount <= getMaxContributionInWei(), "amount is more than max contribution");
1118         super._preValidatePurchase(_beneficiary, _weiAmount);
1119     }
1120 
1121     function _processBonus(uint256 _tokenAmount) internal view returns(uint256){
1122         uint256 currentMilestoneIndex = getCurrentMilestoneIndex();
1123         uint256 _bonusTokens = 0;
1124         //get bonus tier
1125         Milestone memory _currentMilestone = milestones[currentMilestoneIndex];
1126         if(bonusTokens > 0 && _currentMilestone.bonus > 0) {
1127           _bonusTokens = _tokenAmount.mul(_currentMilestone.bonus).div(100);
1128           _bonusTokens = bonusTokens < _bonusTokens ? bonusTokens : _bonusTokens;
1129         }
1130         return _bonusTokens;
1131     }
1132 
1133     /**
1134     * @dev check whether tokens are remaining are not
1135     *
1136     */
1137     function tokensRemaining() public view returns(uint256) {
1138         return totalSaleSupply.sub(tokensSold);
1139     }
1140 
1141     /**
1142     * @dev gives the bonus milestone index for bonus colculation
1143     * @return the bonus milestones index
1144     *
1145     */
1146     function getCurrentMilestoneIndex() public view returns (uint256) {
1147         for(uint256 i = 0; i < milestoneCount; i++) {
1148             if(tokensSold < milestones[i].total) {
1149                 return i;
1150             }
1151         }
1152     }
1153 
1154     /**
1155     * @dev gives the token price w.r.t to wei sent 
1156     * @return the amount of tokens to be given based on wei received
1157     *
1158     */
1159     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1160         return _weiAmount.mul(ETH_USD).div(tokenCost);
1161     }
1162 
1163     /**
1164     * @dev check whether token is left or sale is ended
1165     * @return true=> sale ended or false=> not ended
1166     *
1167     */
1168     function hasClosed() public view returns (bool) {
1169         uint256 tokensLeft = tokensRemaining();
1170         return tokensLeft <= 1e18 || super.hasClosed();
1171     }
1172 
1173     /**
1174     * @dev gives minimum contribution in wei
1175     * @return the min contribution value in wei
1176     *
1177     */
1178     function getMinContributionInWei() public view returns(uint256){
1179         return (minContribution.mul(1e18)).div(ETH_USD);
1180     }
1181 
1182     /**
1183     * @dev gives max contribution in wei
1184     * @return the max contribution value in wei
1185     *
1186     */
1187     function getMaxContributionInWei() public view returns(uint256){
1188         return (maxContribution.mul(1e18)).div(ETH_USD);
1189     }
1190 
1191     /**
1192     * @dev gives usd raised based on wei raised
1193     * @return the usd value in cents
1194     *
1195     */
1196     function usdRaised() public view returns (uint256) {
1197         return weiRaised.mul(ETH_USD).div(1e18);
1198     }
1199     
1200 }