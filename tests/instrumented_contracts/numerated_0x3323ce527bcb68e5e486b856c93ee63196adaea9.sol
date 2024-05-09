1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
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
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     require(value <= _balances[msg.sender]);
162     require(to != address(0));
163 
164     _balances[msg.sender] = _balances[msg.sender].sub(value);
165     _balances[to] = _balances[to].add(value);
166     emit Transfer(msg.sender, to, value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param spender The address which will spend the funds.
177    * @param value The amount of tokens to be spent.
178    */
179   function approve(address spender, uint256 value) public returns (bool) {
180     require(spender != address(0));
181 
182     _allowed[msg.sender][spender] = value;
183     emit Approval(msg.sender, spender, value);
184     return true;
185   }
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param from address The address which you want to send tokens from
190    * @param to address The address which you want to transfer to
191    * @param value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(
194     address from,
195     address to,
196     uint256 value
197   )
198     public
199     returns (bool)
200   {
201     require(value <= _balances[from]);
202     require(value <= _allowed[from][msg.sender]);
203     require(to != address(0));
204 
205     _balances[from] = _balances[from].sub(value);
206     _balances[to] = _balances[to].add(value);
207     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
208     emit Transfer(from, to, value);
209     return true;
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    * approve should be called when allowed_[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param spender The address which will spend the funds.
219    * @param addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseAllowance(
222     address spender,
223     uint256 addedValue
224   )
225     public
226     returns (bool)
227   {
228     require(spender != address(0));
229 
230     _allowed[msg.sender][spender] = (
231       _allowed[msg.sender][spender].add(addedValue));
232     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed_[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param spender The address which will spend the funds.
243    * @param subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseAllowance(
246     address spender,
247     uint256 subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     require(spender != address(0));
253 
254     _allowed[msg.sender][spender] = (
255       _allowed[msg.sender][spender].sub(subtractedValue));
256     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param amount The amount that will be created.
266    */
267   function _mint(address account, uint256 amount) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(amount);
270     _balances[account] = _balances[account].add(amount);
271     emit Transfer(address(0), account, amount);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param amount The amount that will be burnt.
279    */
280   function _burn(address account, uint256 amount) internal {
281     require(account != 0);
282     require(amount <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(amount);
285     _balances[account] = _balances[account].sub(amount);
286     emit Transfer(account, address(0), amount);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param amount The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 amount) internal {
297     require(amount <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       amount);
303     _burn(account, amount);
304   }
305 }
306 
307 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
308 
309 /**
310  * @title SafeERC20
311  * @dev Wrappers around ERC20 operations that throw on failure.
312  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
313  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
314  */
315 library SafeERC20 {
316   function safeTransfer(
317     IERC20 token,
318     address to,
319     uint256 value
320   )
321     internal
322   {
323     require(token.transfer(to, value));
324   }
325 
326   function safeTransferFrom(
327     IERC20 token,
328     address from,
329     address to,
330     uint256 value
331   )
332     internal
333   {
334     require(token.transferFrom(from, to, value));
335   }
336 
337   function safeApprove(
338     IERC20 token,
339     address spender,
340     uint256 value
341   )
342     internal
343   {
344     require(token.approve(spender, value));
345   }
346 }
347 
348 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
349 
350 /**
351  * @title Crowdsale
352  * @dev Crowdsale is a base contract for managing a token crowdsale,
353  * allowing investors to purchase tokens with ether. This contract implements
354  * such functionality in its most fundamental form and can be extended to provide additional
355  * functionality and/or custom behavior.
356  * The external interface represents the basic interface for purchasing tokens, and conform
357  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
358  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
359  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
360  * behavior.
361  */
362 contract Crowdsale {
363   using SafeMath for uint256;
364   using SafeERC20 for IERC20;
365 
366   // The token being sold
367   IERC20 private _token;
368 
369   // Address where funds are collected
370   address private _wallet;
371 
372   // How many token units a buyer gets per wei.
373   // The rate is the conversion between wei and the smallest and indivisible token unit.
374   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
375   // 1 wei will give you 1 unit, or 0.001 TOK.
376   uint256 private _rate;
377 
378   // Amount of wei raised
379   uint256 private _weiRaised;
380 
381   /**
382    * Event for token purchase logging
383    * @param purchaser who paid for the tokens
384    * @param beneficiary who got the tokens
385    * @param value weis paid for purchase
386    * @param amount amount of tokens purchased
387    */
388   event TokensPurchased(
389     address indexed purchaser,
390     address indexed beneficiary,
391     uint256 value,
392     uint256 amount
393   );
394 
395   /**
396    * @param rate Number of token units a buyer gets per wei
397    * @dev The rate is the conversion between wei and the smallest and indivisible
398    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
399    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
400    * @param wallet Address where collected funds will be forwarded to
401    * @param token Address of the token being sold
402    */
403   constructor(uint256 rate, address wallet, IERC20 token) public {
404     require(rate > 0);
405     require(wallet != address(0));
406     require(token != address(0));
407 
408     _rate = rate;
409     _wallet = wallet;
410     _token = token;
411   }
412 
413   // -----------------------------------------
414   // Crowdsale external interface
415   // -----------------------------------------
416 
417   /**
418    * @dev fallback function ***DO NOT OVERRIDE***
419    */
420   function () external payable {
421     buyTokens(msg.sender);
422   }
423 
424   /**
425    * @return the token being sold.
426    */
427   function token() public view returns(IERC20) {
428     return _token;
429   }
430 
431   /**
432    * @return the address where funds are collected.
433    */
434   function wallet() public view returns(address) {
435     return _wallet;
436   }
437 
438   /**
439    * @return the number of token units a buyer gets per wei.
440    */
441   function rate() public view returns(uint256) {
442     return _rate;
443   }
444 
445   /**
446    * @return the mount of wei raised.
447    */
448   function weiRaised() public view returns (uint256) {
449     return _weiRaised;
450   }
451 
452   /**
453    * @dev low level token purchase ***DO NOT OVERRIDE***
454    * @param beneficiary Address performing the token purchase
455    */
456   function buyTokens(address beneficiary) public payable {
457 
458     uint256 weiAmount = msg.value;
459     _preValidatePurchase(beneficiary, weiAmount);
460 
461     // calculate token amount to be created
462     uint256 tokens = _getTokenAmount(weiAmount);
463 
464     // update state
465     _weiRaised = _weiRaised.add(weiAmount);
466 
467     _processPurchase(beneficiary, tokens);
468     emit TokensPurchased(
469       msg.sender,
470       beneficiary,
471       weiAmount,
472       tokens
473     );
474 
475     _updatePurchasingState(beneficiary, weiAmount);
476 
477     _forwardFunds();
478     _postValidatePurchase(beneficiary, weiAmount);
479   }
480 
481   // -----------------------------------------
482   // Internal interface (extensible)
483   // -----------------------------------------
484 
485   /**
486    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
487    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
488    *   super._preValidatePurchase(beneficiary, weiAmount);
489    *   require(weiRaised().add(weiAmount) <= cap);
490    * @param beneficiary Address performing the token purchase
491    * @param weiAmount Value in wei involved in the purchase
492    */
493   function _preValidatePurchase(
494     address beneficiary,
495     uint256 weiAmount
496   )
497     internal
498   {
499     require(beneficiary != address(0));
500     require(weiAmount != 0);
501   }
502 
503   /**
504    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
505    * @param beneficiary Address performing the token purchase
506    * @param weiAmount Value in wei involved in the purchase
507    */
508   function _postValidatePurchase(
509     address beneficiary,
510     uint256 weiAmount
511   )
512     internal
513   {
514     // optional override
515   }
516 
517   /**
518    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
519    * @param beneficiary Address performing the token purchase
520    * @param tokenAmount Number of tokens to be emitted
521    */
522   function _deliverTokens(
523     address beneficiary,
524     uint256 tokenAmount
525   )
526     internal
527   {
528     _token.safeTransfer(beneficiary, tokenAmount);
529   }
530 
531   /**
532    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
533    * @param beneficiary Address receiving the tokens
534    * @param tokenAmount Number of tokens to be purchased
535    */
536   function _processPurchase(
537     address beneficiary,
538     uint256 tokenAmount
539   )
540     internal
541   {
542     _deliverTokens(beneficiary, tokenAmount);
543   }
544 
545   /**
546    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
547    * @param beneficiary Address receiving the tokens
548    * @param weiAmount Value in wei involved in the purchase
549    */
550   function _updatePurchasingState(
551     address beneficiary,
552     uint256 weiAmount
553   )
554     internal
555   {
556     // optional override
557   }
558 
559   /**
560    * @dev Override to extend the way in which ether is converted to tokens.
561    * @param weiAmount Value in wei to be converted into tokens
562    * @return Number of tokens that can be purchased with the specified _weiAmount
563    */
564   function _getTokenAmount(uint256 weiAmount)
565     internal view returns (uint256)
566   {
567     return weiAmount.mul(_rate);
568   }
569 
570   /**
571    * @dev Determines how ETH is stored/forwarded on purchases.
572    */
573   function _forwardFunds() internal {
574     _wallet.transfer(msg.value);
575   }
576 }
577 
578 // File: contracts/TieredPriceCrowdsale.sol
579 
580 /**
581  * @title CappedWhitelistedCrowdsale
582  * @dev Crowdsale with a limit for total contributions and per-beneficiary caps. 
583  * Combination of CappedCrowdsale and IndividuallyCappedCrowdsale
584  */
585 contract TieredPriceCrowdsale is Crowdsale {
586     uint256 private _baseRate;
587     uint256 private _tier2Start;
588     uint256 private _tier3Start;
589     uint256 private _tier4Start;
590 
591     constructor( 
592       uint256 baseRate,
593       uint256 openingTimeTier2,
594       uint256 openingTimeTier3, 
595       uint256 openingTimeTier4
596     ) 
597     public 
598     {
599         require(baseRate > 0);
600         require(openingTimeTier2 > block.timestamp);
601         require(openingTimeTier3 >= openingTimeTier2);
602         require(openingTimeTier4 >= openingTimeTier3);
603 
604         _baseRate = baseRate;
605         _tier4Start = openingTimeTier4;
606         _tier3Start = openingTimeTier3;
607         _tier2Start = openingTimeTier2;
608     }
609 
610     function _getbonusRate()
611       internal view returns (uint256)
612     {
613         // Calculate current rate with bonus
614         if(_tier2Start > block.timestamp){
615             return(_baseRate * 6 / 5);
616         }
617         else if(_tier3Start > block.timestamp){
618             return(_baseRate * 11 / 10);
619         }
620         else if(_tier4Start > block.timestamp){
621             return(_baseRate * 21 / 20);
622         }
623         else {
624             return(_baseRate);
625         }
626     }
627 
628     /**
629       * @return the current bonus level.
630       */
631     function bonusRate() public view returns(uint256) {
632         return _getbonusRate();
633     }
634 
635      /**
636       * @param tier Value that represents the tier
637       * @return Timestamp when the tier starts
638       */
639     function tierStartTime(
640         uint256 tier       
641     ) external view returns(uint256) 
642     {
643         if(tier == 2){
644             return _tier2Start;
645         }
646         else if(tier == 3){
647             return _tier3Start;
648         }
649         else if(tier == 4){
650             return _tier4Start;
651         }
652         return 0;
653     }
654 
655     /**
656       * @dev Override to extend the way in which ether is converted to tokens.
657       * @param weiAmount Value in wei to be converted into tokens
658       * @return Number of tokens that can be purchased with the specified _weiAmount
659       */
660     function _getTokenAmount(
661         uint256 weiAmount
662     )
663       internal view returns (uint256)
664     {
665         return weiAmount.mul(_getbonusRate());
666     }
667 }
668 
669 // File: openzeppelin-solidity/contracts/access/Roles.sol
670 
671 /**
672  * @title Roles
673  * @dev Library for managing addresses assigned to a Role.
674  */
675 library Roles {
676   struct Role {
677     mapping (address => bool) bearer;
678   }
679 
680   /**
681    * @dev give an account access to this role
682    */
683   function add(Role storage role, address account) internal {
684     require(account != address(0));
685     role.bearer[account] = true;
686   }
687 
688   /**
689    * @dev remove an account's access to this role
690    */
691   function remove(Role storage role, address account) internal {
692     require(account != address(0));
693     role.bearer[account] = false;
694   }
695 
696   /**
697    * @dev check if an account has this role
698    * @return bool
699    */
700   function has(Role storage role, address account)
701     internal
702     view
703     returns (bool)
704   {
705     require(account != address(0));
706     return role.bearer[account];
707   }
708 }
709 
710 // File: openzeppelin-solidity/contracts/access/roles/CapperRole.sol
711 
712 contract CapperRole {
713   using Roles for Roles.Role;
714 
715   event CapperAdded(address indexed account);
716   event CapperRemoved(address indexed account);
717 
718   Roles.Role private cappers;
719 
720   constructor() public {
721     cappers.add(msg.sender);
722   }
723 
724   modifier onlyCapper() {
725     require(isCapper(msg.sender));
726     _;
727   }
728 
729   function isCapper(address account) public view returns (bool) {
730     return cappers.has(account);
731   }
732 
733   function addCapper(address account) public onlyCapper {
734     cappers.add(account);
735     emit CapperAdded(account);
736   }
737 
738   function renounceCapper() public {
739     cappers.remove(msg.sender);
740   }
741 
742   function _removeCapper(address account) internal {
743     cappers.remove(account);
744     emit CapperRemoved(account);
745   }
746 }
747 
748 // File: contracts/WhitelistedCrowdsale.sol
749 
750 /**
751  * @title WhitelistedCrowdsale
752  * @dev Crowdsale with whitelist required for purchases, based on IndividuallyCappedCrowdsale.
753  */
754 contract WhitelistedCrowdsale is Crowdsale, CapperRole {
755     using SafeMath for uint256;
756 
757     uint256 private _invCap;   
758 
759     mapping(address => uint256) private _contributions;
760     mapping(address => uint256) private _whitelist;
761 
762     /**
763     * Event for when _account is added or removed from whitelist
764     * @param _account address added or removed
765     * @param _phase represents the whitelist status (0:unwhitelisted, 1:whitelisted)​
766     */
767     event WhitelistUpdated(
768         address indexed _account,
769         uint8 _phase
770     );
771 
772     constructor(uint256 invCap) public
773     {
774         require(invCap > 0);
775         _invCap = invCap;
776     }
777 
778     /**
779     * @dev Checks whether the _account is in the whitelist.
780     * @param _account Address to be checked
781     * @return Whether the _account is whitelisted
782     */
783     function isWhitelisted(address _account) public view returns (bool) {
784         return _whitelist[_account] != 0;
785     }
786 
787     /**
788     * @notice function to whitelist an address which can be called only by the capper address.
789     *
790     * @param _account account address to be whitelisted
791     * @param _phase 0: unwhitelisted, 1: whitelisted
792     *
793     * @return bool address is successfully whitelisted/unwhitelisted.
794     */
795     function updateWhitelist(address _account, uint8 _phase) external onlyCapper returns (bool) {
796         require(_account != address(0));
797         _updateWhitelist(_account, _phase);
798         return true;
799     }
800 
801     /**
802     * @notice function to whitelist an address which can be called only by the capper address.
803     *
804     * @param _accounts list of account addresses to be whitelisted
805     * @param _phase 0: unwhitelisted, 1: whitelisted
806     *
807     * @return bool addresses are successfully whitelisted/unwhitelisted.
808     */
809     function updateWhitelistAddresses(address[] _accounts, uint8 _phase) external onlyCapper {
810         for (uint256 i = 0; i < _accounts.length; i++) {
811             require(_accounts[i] != address(0));
812             _updateWhitelist(_accounts[i], _phase);
813         }
814     }
815 
816     /**
817     * @notice function to whitelist an address which can be called only by the capper address.
818     *
819     * @param _account account address to be whitelisted
820     * @param _phase 0: unwhitelisted, 1: whitelisted
821     */
822     function _updateWhitelist(
823         address _account, 
824         uint8 _phase
825     ) 
826     internal 
827     {
828         if(_phase == 1){
829             _whitelist[_account] = _invCap;
830         } else {
831             _whitelist[_account] = 0;
832         }
833         emit WhitelistUpdated(
834             _account, 
835             _phase
836         );
837     }
838 
839     /**
840     * @dev add an address to the whitelist
841     * @param _account address
842     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
843     */
844     // function addAddressToWhitelist(address _account) public onlyCapper returns (bool) {
845     //     require(_account != address(0));
846     //     _whitelist[_account] = _invCap;
847     //     return isWhitelisted(_account);
848     // }
849 
850     /**
851     * @dev add addresses to the whitelist
852     * @param _beneficiaries addresses
853     * @return true if at least one address was added to the whitelist,
854     * false if all addresses were already in the whitelist
855     */
856     // function addAddressesToWhitelist(address[] _beneficiaries) external onlyCapper {
857     //     for (uint256 i = 0; i < _beneficiaries.length; i++) {
858     //         addAddressToWhitelist(_beneficiaries[i]);
859     //     }
860     // }
861 
862     /**
863     * @dev remove an address from the whitelist
864     * @param _account address
865     * @return true if the address was removed from the whitelist, false if the address wasn't already in the whitelist
866     */
867     // function removeAddressFromWhitelist(address _account) public onlyCapper returns (bool) {
868     //     require(_account != address(0));
869     //     _whitelist[_account] = 0;
870     //     return isWhitelisted(_account);
871     // }
872 
873     /**
874     * @dev remove addresses from the whitelist
875     * @param _beneficiaries addresses
876     * @return true if at least one address was removed from the whitelist,
877     * false if all addresses weren't already in the whitelist
878     */
879     // function removeAddressesFromWhitelist(address[] _beneficiaries) external onlyCapper {
880     //     for (uint256 i = 0; i < _beneficiaries.length; i++) {
881     //         removeAddressFromWhitelist(_beneficiaries[i]);
882     //     }
883     // }
884 
885     /**
886     * @dev Returns the amount contributed so far by a specific _account.
887     * @param _account Address of contributor
888     * @return _account contribution so far
889     */
890     function getContribution(address _account)
891     public view returns (uint256)
892     {
893         return _contributions[_account];
894     }
895 
896     /**
897     * @dev Extend parent behavior requiring purchase to respect the _account's funding cap.
898     * @param _account Token purchaser
899     * @param weiAmount Amount of wei contributed
900     */
901     function _preValidatePurchase(
902         address _account,
903         uint256 weiAmount
904     )
905     internal
906     {
907         super._preValidatePurchase(_account, weiAmount);
908         require(
909             _contributions[_account].add(weiAmount) <= _whitelist[_account]);
910     }
911 
912     /**
913     * @dev Extend parent behavior to update _account contributions
914     * @param _account Token purchaser
915     * @param weiAmount Amount of wei contributed
916     */
917     function _updatePurchasingState(
918         address _account,
919         uint256 weiAmount
920     )
921     internal
922     {
923         super._updatePurchasingState(_account, weiAmount);
924         _contributions[_account] = _contributions[_account].add(weiAmount);
925     }
926 
927 }
928 
929 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
930 
931 /**
932  * @title CappedCrowdsale
933  * @dev Crowdsale with a limit for total contributions.
934  */
935 contract CappedCrowdsale is Crowdsale {
936   using SafeMath for uint256;
937 
938   uint256 private _cap;
939 
940   /**
941    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
942    * @param cap Max amount of wei to be contributed
943    */
944   constructor(uint256 cap) public {
945     require(cap > 0);
946     _cap = cap;
947   }
948 
949   /**
950    * @return the cap of the crowdsale.
951    */
952   function cap() public view returns(uint256) {
953     return _cap;
954   }
955 
956   /**
957    * @dev Checks whether the cap has been reached.
958    * @return Whether the cap was reached
959    */
960   function capReached() public view returns (bool) {
961     return weiRaised() >= _cap;
962   }
963 
964   /**
965    * @dev Extend parent behavior requiring purchase to respect the funding cap.
966    * @param beneficiary Token purchaser
967    * @param weiAmount Amount of wei contributed
968    */
969   function _preValidatePurchase(
970     address beneficiary,
971     uint256 weiAmount
972   )
973     internal
974   {
975     super._preValidatePurchase(beneficiary, weiAmount);
976     require(weiRaised().add(weiAmount) <= _cap);
977   }
978 
979 }
980 
981 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
982 
983 /**
984  * @title TimedCrowdsale
985  * @dev Crowdsale accepting contributions only within a time frame.
986  */
987 contract TimedCrowdsale is Crowdsale {
988   using SafeMath for uint256;
989 
990   uint256 private _openingTime;
991   uint256 private _closingTime;
992 
993   /**
994    * @dev Reverts if not in crowdsale time range.
995    */
996   modifier onlyWhileOpen {
997     require(isOpen());
998     _;
999   }
1000 
1001   /**
1002    * @dev Constructor, takes crowdsale opening and closing times.
1003    * @param openingTime Crowdsale opening time
1004    * @param closingTime Crowdsale closing time
1005    */
1006   constructor(uint256 openingTime, uint256 closingTime) public {
1007     // solium-disable-next-line security/no-block-members
1008     require(openingTime >= block.timestamp);
1009     require(closingTime >= openingTime);
1010 
1011     _openingTime = openingTime;
1012     _closingTime = closingTime;
1013   }
1014 
1015   /**
1016    * @return the crowdsale opening time.
1017    */
1018   function openingTime() public view returns(uint256) {
1019     return _openingTime;
1020   }
1021 
1022   /**
1023    * @return the crowdsale closing time.
1024    */
1025   function closingTime() public view returns(uint256) {
1026     return _closingTime;
1027   }
1028 
1029   /**
1030    * @return true if the crowdsale is open, false otherwise.
1031    */
1032   function isOpen() public view returns (bool) {
1033     // solium-disable-next-line security/no-block-members
1034     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
1035   }
1036 
1037   /**
1038    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1039    * @return Whether crowdsale period has elapsed
1040    */
1041   function hasClosed() public view returns (bool) {
1042     // solium-disable-next-line security/no-block-members
1043     return block.timestamp > _closingTime;
1044   }
1045 
1046   /**
1047    * @dev Extend parent behavior requiring to be within contributing period
1048    * @param beneficiary Token purchaser
1049    * @param weiAmount Amount of wei contributed
1050    */
1051   function _preValidatePurchase(
1052     address beneficiary,
1053     uint256 weiAmount
1054   )
1055     internal
1056     onlyWhileOpen
1057   {
1058     super._preValidatePurchase(beneficiary, weiAmount);
1059   }
1060 
1061 }
1062 
1063 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1064 
1065 /**
1066  * @title FinalizableCrowdsale
1067  * @dev Extension of Crowdsale with a one-off finalization action, where one
1068  * can do extra work after finishing.
1069  */
1070 contract FinalizableCrowdsale is TimedCrowdsale {
1071   using SafeMath for uint256;
1072 
1073   bool private _finalized = false;
1074 
1075   event CrowdsaleFinalized();
1076 
1077   /**
1078    * @return true if the crowdsale is finalized, false otherwise.
1079    */
1080   function finalized() public view returns (bool) {
1081     return _finalized;
1082   }
1083 
1084   /**
1085    * @dev Must be called after crowdsale ends, to do some extra finalization
1086    * work. Calls the contract's finalization function.
1087    */
1088   function finalize() public {
1089     require(!_finalized);
1090     require(hasClosed());
1091 
1092     _finalization();
1093     emit CrowdsaleFinalized();
1094 
1095     _finalized = true;
1096   }
1097 
1098   /**
1099    * @dev Can be overridden to add finalization logic. The overriding function
1100    * should call super._finalization() to ensure the chain of finalization is
1101    * executed entirely.
1102    */
1103   function _finalization() internal {
1104   }
1105 
1106 }
1107 
1108 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1109 
1110 contract MinterRole {
1111   using Roles for Roles.Role;
1112 
1113   event MinterAdded(address indexed account);
1114   event MinterRemoved(address indexed account);
1115 
1116   Roles.Role private minters;
1117 
1118   constructor() public {
1119     minters.add(msg.sender);
1120   }
1121 
1122   modifier onlyMinter() {
1123     require(isMinter(msg.sender));
1124     _;
1125   }
1126 
1127   function isMinter(address account) public view returns (bool) {
1128     return minters.has(account);
1129   }
1130 
1131   function addMinter(address account) public onlyMinter {
1132     minters.add(account);
1133     emit MinterAdded(account);
1134   }
1135 
1136   function renounceMinter() public {
1137     minters.remove(msg.sender);
1138   }
1139 
1140   function _removeMinter(address account) internal {
1141     minters.remove(account);
1142     emit MinterRemoved(account);
1143   }
1144 }
1145 
1146 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1147 
1148 /**
1149  * @title ERC20Mintable
1150  * @dev ERC20 minting logic
1151  */
1152 contract ERC20Mintable is ERC20, MinterRole {
1153   event MintingFinished();
1154 
1155   bool private _mintingFinished = false;
1156 
1157   modifier onlyBeforeMintingFinished() {
1158     require(!_mintingFinished);
1159     _;
1160   }
1161 
1162   /**
1163    * @return true if the minting is finished.
1164    */
1165   function mintingFinished() public view returns(bool) {
1166     return _mintingFinished;
1167   }
1168 
1169   /**
1170    * @dev Function to mint tokens
1171    * @param to The address that will receive the minted tokens.
1172    * @param amount The amount of tokens to mint.
1173    * @return A boolean that indicates if the operation was successful.
1174    */
1175   function mint(
1176     address to,
1177     uint256 amount
1178   )
1179     public
1180     onlyMinter
1181     onlyBeforeMintingFinished
1182     returns (bool)
1183   {
1184     _mint(to, amount);
1185     return true;
1186   }
1187 
1188   /**
1189    * @dev Function to stop minting new tokens.
1190    * @return True if the operation was successful.
1191    */
1192   function finishMinting()
1193     public
1194     onlyMinter
1195     onlyBeforeMintingFinished
1196     returns (bool)
1197   {
1198     _mintingFinished = true;
1199     emit MintingFinished();
1200     return true;
1201   }
1202 }
1203 
1204 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1205 
1206 /**
1207  * @title MintedCrowdsale
1208  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1209  * Token ownership should be transferred to MintedCrowdsale for minting.
1210  */
1211 contract MintedCrowdsale is Crowdsale {
1212 
1213   /**
1214    * @dev Overrides delivery by minting tokens upon purchase.
1215    * @param beneficiary Token purchaser
1216    * @param tokenAmount Number of tokens to be minted
1217    */
1218   function _deliverTokens(
1219     address beneficiary,
1220     uint256 tokenAmount
1221   )
1222     internal
1223   {
1224     // Potentially dangerous assumption about the type of the token.
1225     require(
1226       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1227   }
1228 }
1229 
1230 // File: contracts/PlazaCrowdsale.sol
1231 
1232 contract PlazaCrowdsale is CappedCrowdsale, FinalizableCrowdsale, MintedCrowdsale, WhitelistedCrowdsale, TieredPriceCrowdsale {
1233     constructor(
1234         uint256 openingTime,
1235         uint256 closingTime,
1236         uint256 rate,
1237         address wallet,
1238         uint256 cap,
1239         ERC20Mintable token,
1240         uint256 openingTimeTier4, 
1241         uint256 openingTimeTier3, 
1242         uint256 openingTimeTier2,
1243         uint256 invCap
1244     )
1245     public
1246     Crowdsale(rate, wallet, token)
1247     CappedCrowdsale(cap)
1248     WhitelistedCrowdsale(invCap)
1249     TimedCrowdsale(openingTime, closingTime)
1250     TieredPriceCrowdsale(rate, openingTimeTier2, openingTimeTier3, openingTimeTier4)
1251     {}
1252 
1253 }