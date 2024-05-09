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
760     mapping(address => uint256) private _caps;
761 
762     constructor(uint256 invCap) public
763     {
764         require(invCap > 0);
765         _invCap = invCap;
766     }
767 
768     /**
769     * @dev Checks whether the beneficiary is in the whitelist.
770     * @param beneficiary Address to be checked
771     * @return Whether the beneficiary is whitelisted
772     */
773     function isWhitelisted(address beneficiary) public view returns (bool) {
774         return _caps[beneficiary] != 0;
775     }
776 
777     /**
778     * @dev add an address to the whitelist
779     * @param beneficiary address
780     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
781     */
782     function addAddressToWhitelist(address beneficiary) public onlyCapper returns (bool) {
783         require(beneficiary != address(0));
784         _caps[beneficiary] = _invCap;
785         return isWhitelisted(beneficiary);
786     }
787 
788     /**
789     * @dev add addresses to the whitelist
790     * @param _beneficiaries addresses
791     * @return true if at least one address was added to the whitelist,
792     * false if all addresses were already in the whitelist
793     */
794     function addAddressesToWhitelist(address[] _beneficiaries) external onlyCapper {
795         for (uint256 i = 0; i < _beneficiaries.length; i++) {
796             addAddressToWhitelist(_beneficiaries[i]);
797         }
798     }
799 
800     /**
801     * @dev remove an address from the whitelist
802     * @param beneficiary address
803     * @return true if the address was removed from the whitelist, false if the address wasn't already in the whitelist
804     */
805     function removeAddressFromWhitelist(address beneficiary) public onlyCapper returns (bool) {
806         require(beneficiary != address(0));
807         _caps[beneficiary] = 0;
808         return isWhitelisted(beneficiary);
809     }
810 
811     /**
812     * @dev remove addresses from the whitelist
813     * @param _beneficiaries addresses
814     * @return true if at least one address was removed from the whitelist,
815     * false if all addresses weren't already in the whitelist
816     */
817     function removeAddressesFromWhitelist(address[] _beneficiaries) external onlyCapper {
818         for (uint256 i = 0; i < _beneficiaries.length; i++) {
819             removeAddressFromWhitelist(_beneficiaries[i]);
820         }
821     }
822 
823     /**
824     * @dev Returns the amount contributed so far by a specific beneficiary.
825     * @param beneficiary Address of contributor
826     * @return Beneficiary contribution so far
827     */
828     function getContribution(address beneficiary)
829     public view returns (uint256)
830     {
831         return _contributions[beneficiary];
832     }
833 
834     /**
835     * @dev Extend parent behavior requiring purchase to respect the beneficiary's funding cap.
836     * @param beneficiary Token purchaser
837     * @param weiAmount Amount of wei contributed
838     */
839     function _preValidatePurchase(
840         address beneficiary,
841         uint256 weiAmount
842     )
843     internal
844     {
845         super._preValidatePurchase(beneficiary, weiAmount);
846         require(
847             _contributions[beneficiary].add(weiAmount) <= _caps[beneficiary]);
848     }
849 
850     /**
851     * @dev Extend parent behavior to update beneficiary contributions
852     * @param beneficiary Token purchaser
853     * @param weiAmount Amount of wei contributed
854     */
855     function _updatePurchasingState(
856         address beneficiary,
857         uint256 weiAmount
858     )
859     internal
860     {
861         super._updatePurchasingState(beneficiary, weiAmount);
862         _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
863     }
864 
865 }
866 
867 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
868 
869 /**
870  * @title CappedCrowdsale
871  * @dev Crowdsale with a limit for total contributions.
872  */
873 contract CappedCrowdsale is Crowdsale {
874   using SafeMath for uint256;
875 
876   uint256 private _cap;
877 
878   /**
879    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
880    * @param cap Max amount of wei to be contributed
881    */
882   constructor(uint256 cap) public {
883     require(cap > 0);
884     _cap = cap;
885   }
886 
887   /**
888    * @return the cap of the crowdsale.
889    */
890   function cap() public view returns(uint256) {
891     return _cap;
892   }
893 
894   /**
895    * @dev Checks whether the cap has been reached.
896    * @return Whether the cap was reached
897    */
898   function capReached() public view returns (bool) {
899     return weiRaised() >= _cap;
900   }
901 
902   /**
903    * @dev Extend parent behavior requiring purchase to respect the funding cap.
904    * @param beneficiary Token purchaser
905    * @param weiAmount Amount of wei contributed
906    */
907   function _preValidatePurchase(
908     address beneficiary,
909     uint256 weiAmount
910   )
911     internal
912   {
913     super._preValidatePurchase(beneficiary, weiAmount);
914     require(weiRaised().add(weiAmount) <= _cap);
915   }
916 
917 }
918 
919 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
920 
921 /**
922  * @title TimedCrowdsale
923  * @dev Crowdsale accepting contributions only within a time frame.
924  */
925 contract TimedCrowdsale is Crowdsale {
926   using SafeMath for uint256;
927 
928   uint256 private _openingTime;
929   uint256 private _closingTime;
930 
931   /**
932    * @dev Reverts if not in crowdsale time range.
933    */
934   modifier onlyWhileOpen {
935     require(isOpen());
936     _;
937   }
938 
939   /**
940    * @dev Constructor, takes crowdsale opening and closing times.
941    * @param openingTime Crowdsale opening time
942    * @param closingTime Crowdsale closing time
943    */
944   constructor(uint256 openingTime, uint256 closingTime) public {
945     // solium-disable-next-line security/no-block-members
946     require(openingTime >= block.timestamp);
947     require(closingTime >= openingTime);
948 
949     _openingTime = openingTime;
950     _closingTime = closingTime;
951   }
952 
953   /**
954    * @return the crowdsale opening time.
955    */
956   function openingTime() public view returns(uint256) {
957     return _openingTime;
958   }
959 
960   /**
961    * @return the crowdsale closing time.
962    */
963   function closingTime() public view returns(uint256) {
964     return _closingTime;
965   }
966 
967   /**
968    * @return true if the crowdsale is open, false otherwise.
969    */
970   function isOpen() public view returns (bool) {
971     // solium-disable-next-line security/no-block-members
972     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
973   }
974 
975   /**
976    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
977    * @return Whether crowdsale period has elapsed
978    */
979   function hasClosed() public view returns (bool) {
980     // solium-disable-next-line security/no-block-members
981     return block.timestamp > _closingTime;
982   }
983 
984   /**
985    * @dev Extend parent behavior requiring to be within contributing period
986    * @param beneficiary Token purchaser
987    * @param weiAmount Amount of wei contributed
988    */
989   function _preValidatePurchase(
990     address beneficiary,
991     uint256 weiAmount
992   )
993     internal
994     onlyWhileOpen
995   {
996     super._preValidatePurchase(beneficiary, weiAmount);
997   }
998 
999 }
1000 
1001 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
1002 
1003 /**
1004  * @title FinalizableCrowdsale
1005  * @dev Extension of Crowdsale with a one-off finalization action, where one
1006  * can do extra work after finishing.
1007  */
1008 contract FinalizableCrowdsale is TimedCrowdsale {
1009   using SafeMath for uint256;
1010 
1011   bool private _finalized = false;
1012 
1013   event CrowdsaleFinalized();
1014 
1015   /**
1016    * @return true if the crowdsale is finalized, false otherwise.
1017    */
1018   function finalized() public view returns (bool) {
1019     return _finalized;
1020   }
1021 
1022   /**
1023    * @dev Must be called after crowdsale ends, to do some extra finalization
1024    * work. Calls the contract's finalization function.
1025    */
1026   function finalize() public {
1027     require(!_finalized);
1028     require(hasClosed());
1029 
1030     _finalization();
1031     emit CrowdsaleFinalized();
1032 
1033     _finalized = true;
1034   }
1035 
1036   /**
1037    * @dev Can be overridden to add finalization logic. The overriding function
1038    * should call super._finalization() to ensure the chain of finalization is
1039    * executed entirely.
1040    */
1041   function _finalization() internal {
1042   }
1043 
1044 }
1045 
1046 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1047 
1048 contract MinterRole {
1049   using Roles for Roles.Role;
1050 
1051   event MinterAdded(address indexed account);
1052   event MinterRemoved(address indexed account);
1053 
1054   Roles.Role private minters;
1055 
1056   constructor() public {
1057     minters.add(msg.sender);
1058   }
1059 
1060   modifier onlyMinter() {
1061     require(isMinter(msg.sender));
1062     _;
1063   }
1064 
1065   function isMinter(address account) public view returns (bool) {
1066     return minters.has(account);
1067   }
1068 
1069   function addMinter(address account) public onlyMinter {
1070     minters.add(account);
1071     emit MinterAdded(account);
1072   }
1073 
1074   function renounceMinter() public {
1075     minters.remove(msg.sender);
1076   }
1077 
1078   function _removeMinter(address account) internal {
1079     minters.remove(account);
1080     emit MinterRemoved(account);
1081   }
1082 }
1083 
1084 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1085 
1086 /**
1087  * @title ERC20Mintable
1088  * @dev ERC20 minting logic
1089  */
1090 contract ERC20Mintable is ERC20, MinterRole {
1091   event MintingFinished();
1092 
1093   bool private _mintingFinished = false;
1094 
1095   modifier onlyBeforeMintingFinished() {
1096     require(!_mintingFinished);
1097     _;
1098   }
1099 
1100   /**
1101    * @return true if the minting is finished.
1102    */
1103   function mintingFinished() public view returns(bool) {
1104     return _mintingFinished;
1105   }
1106 
1107   /**
1108    * @dev Function to mint tokens
1109    * @param to The address that will receive the minted tokens.
1110    * @param amount The amount of tokens to mint.
1111    * @return A boolean that indicates if the operation was successful.
1112    */
1113   function mint(
1114     address to,
1115     uint256 amount
1116   )
1117     public
1118     onlyMinter
1119     onlyBeforeMintingFinished
1120     returns (bool)
1121   {
1122     _mint(to, amount);
1123     return true;
1124   }
1125 
1126   /**
1127    * @dev Function to stop minting new tokens.
1128    * @return True if the operation was successful.
1129    */
1130   function finishMinting()
1131     public
1132     onlyMinter
1133     onlyBeforeMintingFinished
1134     returns (bool)
1135   {
1136     _mintingFinished = true;
1137     emit MintingFinished();
1138     return true;
1139   }
1140 }
1141 
1142 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
1143 
1144 /**
1145  * @title MintedCrowdsale
1146  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1147  * Token ownership should be transferred to MintedCrowdsale for minting.
1148  */
1149 contract MintedCrowdsale is Crowdsale {
1150 
1151   /**
1152    * @dev Overrides delivery by minting tokens upon purchase.
1153    * @param beneficiary Token purchaser
1154    * @param tokenAmount Number of tokens to be minted
1155    */
1156   function _deliverTokens(
1157     address beneficiary,
1158     uint256 tokenAmount
1159   )
1160     internal
1161   {
1162     // Potentially dangerous assumption about the type of the token.
1163     require(
1164       ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
1165   }
1166 }
1167 
1168 // File: contracts/PlazaCrowdsale.sol
1169 
1170 contract PlazaCrowdsale is CappedCrowdsale, FinalizableCrowdsale, MintedCrowdsale, WhitelistedCrowdsale, TieredPriceCrowdsale {
1171     constructor(
1172         uint256 openingTime,
1173         uint256 closingTime,
1174         uint256 rate,
1175         address wallet,
1176         uint256 cap,
1177         ERC20Mintable token,
1178         uint256 openingTimeTier4, 
1179         uint256 openingTimeTier3, 
1180         uint256 openingTimeTier2,
1181         uint256 invCap
1182     )
1183     public
1184     Crowdsale(rate, wallet, token)
1185     CappedCrowdsale(cap)
1186     WhitelistedCrowdsale(invCap)
1187     TimedCrowdsale(openingTime, closingTime)
1188     TieredPriceCrowdsale(rate, openingTimeTier2, openingTimeTier3, openingTimeTier4)
1189     {}
1190 
1191 }