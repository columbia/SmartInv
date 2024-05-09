1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 
71 
72 
73 /**
74  * @title SafeERC20
75  * @dev Wrappers around ERC20 operations that throw on failure.
76  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
77  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
78  */
79 library SafeERC20 {
80   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
81     require(token.transfer(to, value));
82   }
83 
84   function safeTransferFrom(
85     ERC20 token,
86     address from,
87     address to,
88     uint256 value
89   )
90     internal
91   {
92     require(token.transferFrom(from, to, value));
93   }
94 
95   function safeApprove(ERC20 token, address spender, uint256 value) internal {
96     require(token.approve(spender, value));
97   }
98 }
99 
100 
101 
102 /**
103  * @title Roles
104  * @author Francisco Giordano (@frangio)
105  * @dev Library for managing addresses assigned to a Role.
106  * See RBAC.sol for example usage.
107  */
108 library Roles {
109   struct Role {
110     mapping (address => bool) bearer;
111   }
112 
113   /**
114    * @dev give an address access to this role
115    */
116   function add(Role storage role, address addr)
117     internal
118   {
119     role.bearer[addr] = true;
120   }
121 
122   /**
123    * @dev remove an address' access to this role
124    */
125   function remove(Role storage role, address addr)
126     internal
127   {
128     role.bearer[addr] = false;
129   }
130 
131   /**
132    * @dev check if an address has this role
133    * // reverts
134    */
135   function check(Role storage role, address addr)
136     view
137     internal
138   {
139     require(has(role, addr));
140   }
141 
142   /**
143    * @dev check if an address has this role
144    * @return bool
145    */
146   function has(Role storage role, address addr)
147     view
148     internal
149     returns (bool)
150   {
151     return role.bearer[addr];
152   }
153 }
154 
155 
156 
157 contract Time {
158     /**
159     * @dev Current time getter
160     * @return Current time in seconds
161     */
162     function _currentTime() internal view returns (uint256) {
163         return block.timestamp;
164     }
165 }
166 
167 
168 
169 
170 /**
171  * @title RBAC (Role-Based Access Control)
172  * @author Matt Condon (@Shrugs)
173  * @dev Stores and provides setters and getters for roles and addresses.
174  * Supports unlimited numbers of roles and addresses.
175  * See //contracts/mocks/RBACMock.sol for an example of usage.
176  * This RBAC method uses strings to key roles. It may be beneficial
177  * for you to write your own implementation of this interface using Enums or similar.
178  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
179  * to avoid typos.
180  */
181 contract RBAC {
182   using Roles for Roles.Role;
183 
184   mapping (string => Roles.Role) private roles;
185 
186   event RoleAdded(address indexed operator, string role);
187   event RoleRemoved(address indexed operator, string role);
188 
189   /**
190    * @dev reverts if addr does not have role
191    * @param _operator address
192    * @param _role the name of the role
193    * // reverts
194    */
195   function checkRole(address _operator, string _role)
196     view
197     public
198   {
199     roles[_role].check(_operator);
200   }
201 
202   /**
203    * @dev determine if addr has role
204    * @param _operator address
205    * @param _role the name of the role
206    * @return bool
207    */
208   function hasRole(address _operator, string _role)
209     view
210     public
211     returns (bool)
212   {
213     return roles[_role].has(_operator);
214   }
215 
216   /**
217    * @dev add a role to an address
218    * @param _operator address
219    * @param _role the name of the role
220    */
221   function addRole(address _operator, string _role)
222     internal
223   {
224     roles[_role].add(_operator);
225     emit RoleAdded(_operator, _role);
226   }
227 
228   /**
229    * @dev remove a role from an address
230    * @param _operator address
231    * @param _role the name of the role
232    */
233   function removeRole(address _operator, string _role)
234     internal
235   {
236     roles[_role].remove(_operator);
237     emit RoleRemoved(_operator, _role);
238   }
239 
240   /**
241    * @dev modifier to scope access to a single role (uses msg.sender as addr)
242    * @param _role the name of the role
243    * // reverts
244    */
245   modifier onlyRole(string _role)
246   {
247     checkRole(msg.sender, _role);
248     _;
249   }
250 
251   /**
252    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
253    * @param _roles the names of the roles to scope access to
254    * // reverts
255    *
256    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
257    *  see: https://github.com/ethereum/solidity/issues/2467
258    */
259   // modifier onlyRoles(string[] _roles) {
260   //     bool hasAnyRole = false;
261   //     for (uint8 i = 0; i < _roles.length; i++) {
262   //         if (hasRole(msg.sender, _roles[i])) {
263   //             hasAnyRole = true;
264   //             break;
265   //         }
266   //     }
267 
268   //     require(hasAnyRole);
269 
270   //     _;
271   // }
272 }
273 
274 
275 
276 /**
277  * @title Ownable
278  * @dev The Ownable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract Ownable {
282   address public owner;
283 
284 
285   event OwnershipRenounced(address indexed previousOwner);
286   event OwnershipTransferred(
287     address indexed previousOwner,
288     address indexed newOwner
289   );
290 
291 
292   /**
293    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
294    * account.
295    */
296   constructor() public {
297     owner = msg.sender;
298   }
299 
300   /**
301    * @dev Throws if called by any account other than the owner.
302    */
303   modifier onlyOwner() {
304     require(msg.sender == owner);
305     _;
306   }
307 
308   /**
309    * @dev Allows the current owner to relinquish control of the contract.
310    * @notice Renouncing to ownership will leave the contract without an owner.
311    * It will not be possible to call the functions with the `onlyOwner`
312    * modifier anymore.
313    */
314   function renounceOwnership() public onlyOwner {
315     emit OwnershipRenounced(owner);
316     owner = address(0);
317   }
318 
319   /**
320    * @dev Allows the current owner to transfer control of the contract to a newOwner.
321    * @param _newOwner The address to transfer ownership to.
322    */
323   function transferOwnership(address _newOwner) public onlyOwner {
324     _transferOwnership(_newOwner);
325   }
326 
327   /**
328    * @dev Transfers control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function _transferOwnership(address _newOwner) internal {
332     require(_newOwner != address(0));
333     emit OwnershipTransferred(owner, _newOwner);
334     owner = _newOwner;
335   }
336 }
337 
338 
339 
340 contract Lockable {
341     // locked values specified by address
342     mapping(address => uint256) public lockedValues;
343 
344     /**
345     * @dev Method to lock specified value by specified address
346     * @param _for Address for which the value will be locked
347     * @param _value Value that be locked
348     */
349     function _lock(address _for, uint256 _value) internal {
350         require(_for != address(0) && _value > 0, "Invalid lock operation configuration.");
351 
352         if (_value != lockedValues[_for]) {
353             lockedValues[_for] = _value;
354         }
355     }
356 
357     /**
358     * @dev Method to unlock (reset) locked value
359     * @param _for Address for which the value will be unlocked
360     */
361     function _unlock(address _for) internal {
362         require(_for != address(0), "Invalid unlock operation configuration.");
363         
364         if (lockedValues[_for] != 0) {
365             lockedValues[_for] = 0;
366         }
367     }
368 }
369 
370 
371 
372 
373 
374 
375 
376 
377 
378 
379 
380 contract Operable is Ownable, RBAC {
381     // role key
382     string public constant ROLE_OPERATOR = "operator";
383 
384     /**
385      * @dev Reverts in case account is not Owner or Operator role
386      */
387     modifier hasOwnerOrOperatePermission() {
388         require(msg.sender == owner || hasRole(msg.sender, ROLE_OPERATOR), "Access denied.");
389         _;
390     }
391 
392     /**
393      * @dev Getter to determine if address is in whitelist
394      */
395     function operator(address _operator) public view returns (bool) {
396         return hasRole(_operator, ROLE_OPERATOR);
397     }
398 
399     /**
400      * @dev Method to add accounts with Operator role
401      * @param _operator Address that will receive Operator role access
402      */
403     function addOperator(address _operator) public onlyOwner {
404         addRole(_operator, ROLE_OPERATOR);
405     }
406 
407     /**
408      * @dev Method to remove accounts with Operator role
409      * @param _operator Address that will loose Operator role access
410      */
411     function removeOperator(address _operator) public onlyOwner {
412         removeRole(_operator, ROLE_OPERATOR);
413     }
414 }
415 
416 
417 
418 
419 
420 
421 contract Withdrawal is Ownable {
422     // Address to which funds will be withdrawn
423     address public withdrawWallet;
424 
425     /**
426     * Event for withdraw logging
427     * @param value Value that was withdrawn
428     */
429     event WithdrawLog(uint256 value);
430 
431     /**
432     * @param _withdrawWallet Address to which funds will be withdrawn
433     */
434     constructor(address _withdrawWallet) public {
435         require(_withdrawWallet != address(0), "Invalid funds holder wallet.");
436 
437         withdrawWallet = _withdrawWallet;
438     }
439 
440     /**
441     * @dev Transfers funds from the contract to the specified withdraw wallet address
442     */
443     function withdrawAll() external onlyOwner {
444         uint256 weiAmount = address(this).balance;
445       
446         withdrawWallet.transfer(weiAmount);
447         emit WithdrawLog(weiAmount);
448     }
449 
450     /**
451     * @dev Transfers a part of the funds from the contract to the specified withdraw wallet address
452     * @param _weiAmount Part of the funds to be withdrawn
453     */
454     function withdraw(uint256 _weiAmount) external onlyOwner {
455         require(_weiAmount <= address(this).balance, "Not enough funds.");
456 
457         withdrawWallet.transfer(_weiAmount);
458         emit WithdrawLog(_weiAmount);
459     }
460 }
461 
462 
463 
464 
465 
466 
467 
468 
469 contract PriceStrategy is Time, Operable {
470     using SafeMath for uint256;
471 
472     /**
473     * Describes stage parameters
474     * @param start Stage start date
475     * @param end Stage end date
476     * @param volume Number of tokens available for the stage
477     * @param priceInCHF Token price in CHF for the stage
478     * @param minBonusVolume The minimum number of tokens after which the bonus tokens is added
479     * @param bonus Percentage of bonus tokens
480     */
481     struct Stage {
482         uint256 start;
483         uint256 end;
484         uint256 volume;
485         uint256 priceInCHF;
486         uint256 minBonusVolume;
487         uint256 bonus;
488         bool lock;
489     }
490 
491     /**
492     * Describes lockup period parameters
493     * @param periodInSec Lockup period in seconds
494     * @param bonus Lockup bonus tokens percentage
495     */
496     struct LockupPeriod {
497         uint256 expires;
498         uint256 bonus;
499     }
500 
501     // describes stages available for ICO lifetime
502     Stage[] public stages;
503 
504     // lockup periods specified by the period in month
505     mapping(uint256 => LockupPeriod) public lockupPeriods;
506 
507     // number of decimals supported by CHF rates
508     uint256 public constant decimalsCHF = 18;
509 
510     // minimum allowed investment in CHF (decimals 1e+18)
511     uint256 public minInvestmentInCHF;
512 
513     // ETH rate in CHF
514     uint256 public rateETHtoCHF;
515 
516     /**
517     * Event for ETH to CHF rate changes logging
518     * @param newRate New rate value
519     */
520     event RateChangedLog(uint256 newRate);
521 
522     /**
523     * @param _rateETHtoCHF Cost of ETH in CHF
524     * @param _minInvestmentInCHF Minimal allowed investment in CHF
525     */
526     constructor(uint256 _rateETHtoCHF, uint256 _minInvestmentInCHF) public {
527         require(_minInvestmentInCHF > 0, "Minimum investment can not be set to 0.");        
528         minInvestmentInCHF = _minInvestmentInCHF;
529 
530         setETHtoCHFrate(_rateETHtoCHF);
531 
532         // PRE-ICO
533         stages.push(Stage({
534             start: 1536969600, // 15th Sep, 2018 00:00:00
535             end: 1542239999, // 14th Nov, 2018 23:59:59
536             volume: uint256(25000000000).mul(10 ** 18), // (twenty five billion)
537             priceInCHF: uint256(2).mul(10 ** 14), // CHF 0.00020
538             minBonusVolume: 0,
539             bonus: 0,
540             lock: false
541         }));
542 
543         // ICO
544         stages.push(Stage({
545             start: 1542240000, // 15th Nov, 2018 00:00:00
546             end: 1550188799, // 14th Feb, 2019 23:59:59
547             volume: uint256(65000000000).mul(10 ** 18), // (forty billion)
548             priceInCHF: uint256(4).mul(10 ** 14), // CHF 0.00040
549             minBonusVolume: uint256(400000000).mul(10 ** 18), // (four hundred million)
550             bonus: 2000, // 20% bonus tokens
551             lock: true
552         }));
553 
554         _setLockupPeriod(1550188799, 18, 3000); // 18 months after the end of the ICO / 30%
555         _setLockupPeriod(1550188799, 12, 2000); // 12 months after the end of the ICO / 20%
556         _setLockupPeriod(1550188799, 6, 1000); // 6 months after the end of the ICO / 10%
557     }
558 
559     /**
560     * @dev Updates ETH to CHF rate
561     * @param _rateETHtoCHF Cost of ETH in CHF
562     */
563     function setETHtoCHFrate(uint256 _rateETHtoCHF) public hasOwnerOrOperatePermission {
564         require(_rateETHtoCHF > 0, "Rate can not be set to 0.");        
565         rateETHtoCHF = _rateETHtoCHF;
566         emit RateChangedLog(rateETHtoCHF);
567     }
568 
569     /**
570     * @dev Tokens amount based on investment value in wei
571     * @param _wei Investment value in wei
572     * @param _lockup Lockup period in months
573     * @param _sold Number of tokens sold by the moment
574     * @return Amount of tokens and bonuses
575     */
576     function getTokensAmount(uint256 _wei, uint256 _lockup, uint256 _sold) public view returns (uint256 tokens, uint256 bonus) { 
577         uint256 chfAmount = _wei.mul(rateETHtoCHF).div(10 ** decimalsCHF);
578         require(chfAmount >= minInvestmentInCHF, "Investment value is below allowed minimum.");
579 
580         Stage memory currentStage = _getCurrentStage();
581         require(currentStage.priceInCHF > 0, "Invalid price value.");        
582 
583         tokens = chfAmount.mul(10 ** decimalsCHF).div(currentStage.priceInCHF);
584 
585         uint256 bonusSize;
586         if (tokens >= currentStage.minBonusVolume) {
587             bonusSize = currentStage.bonus.add(lockupPeriods[_lockup].bonus);
588         } else {
589             bonusSize = lockupPeriods[_lockup].bonus;
590         }
591 
592         bonus = tokens.mul(bonusSize).div(10 ** 4);
593 
594         uint256 total = tokens.add(bonus);
595         require(currentStage.volume > _sold.add(total), "Not enough tokens available.");
596     }    
597 
598     /**
599     * @dev Finds current stage parameters according to the rules and current date and time
600     * @return Current stage parameters (available volume of tokens and price in CHF)
601     */
602     function _getCurrentStage() internal view returns (Stage) {
603         uint256 index = 0;
604         uint256 time = _currentTime();
605 
606         Stage memory result;
607 
608         while (index < stages.length) {
609             Stage memory stage = stages[index];
610 
611             if ((time >= stage.start && time <= stage.end)) {
612                 result = stage;
613                 break;
614             }
615 
616             index++;
617         }
618 
619         return result;
620     } 
621 
622     /**
623     * @dev Sets bonus for specified lockup period. Allowed only for contract owner
624     * @param _startPoint Lock start point (is seconds)
625     * @param _period Lockup period (in months)
626     * @param _bonus Percentage of bonus tokens
627     */
628     function _setLockupPeriod(uint256 _startPoint, uint256 _period, uint256 _bonus) private {
629         uint256 expires = _startPoint.add(_period.mul(2628000));
630         lockupPeriods[_period] = LockupPeriod({
631             expires: expires,
632             bonus: _bonus
633         });
634     }
635 }
636 
637 
638 
639 
640 
641 
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 contract BaseCrowdsale {
652     using SafeMath for uint256;
653     using SafeERC20 for CosquareToken;
654 
655     // The token being sold
656     CosquareToken public token;
657     // Total amount of tokens sold
658     uint256 public tokensSold;
659 
660     /**
661     * @dev Event for tokens purchase logging
662     * @param purchaseType Who paid for the tokens
663     * @param beneficiary Who got the tokens
664     * @param value Value paid for purchase
665     * @param tokens Amount of tokens purchased
666     * @param bonuses Amount of bonuses received
667     */
668     event TokensPurchaseLog(string purchaseType, address indexed beneficiary, uint256 value, uint256 tokens, uint256 bonuses);
669 
670     /**
671     * @param _token Address of the token being sold
672     */
673     constructor(CosquareToken _token) public {
674         require(_token != address(0), "Invalid token address.");
675         token = _token;
676     }
677 
678     /**
679     * @dev fallback function ***DO NOT OVERRIDE***
680     */
681     function () external payable {
682         require(msg.data.length == 0, "Should not accept data.");
683         _buyTokens(msg.sender, msg.value, "ETH");
684     }
685 
686     /**
687     * @dev low level token purchase ***DO NOT OVERRIDE***
688     * @param _beneficiary Address performing the token purchase
689     */
690     function buyTokens(address _beneficiary) external payable {
691         _buyTokens(_beneficiary, msg.value, "ETH");
692     }
693 
694     /**
695     * @dev Tokens purchase for wei investments
696     * @param _beneficiary Address performing the token purchase
697     * @param _amount Amount of tokens purchased
698     * @param _investmentType Investment channel string
699     */
700     function _buyTokens(address _beneficiary, uint256 _amount, string _investmentType) internal {
701         _preValidatePurchase(_beneficiary, _amount);
702 
703         (uint256 tokensAmount, uint256 tokenBonus) = _getTokensAmount(_beneficiary, _amount);
704 
705         uint256 totalAmount = tokensAmount.add(tokenBonus);
706 
707         _processPurchase(_beneficiary, totalAmount);
708         emit TokensPurchaseLog(_investmentType, _beneficiary, _amount, tokensAmount, tokenBonus);        
709         
710         _postPurchaseUpdate(_beneficiary, totalAmount);
711     }  
712 
713     /**
714     * @dev Validation of an executed purchase
715     * @param _beneficiary Address performing the token purchase
716     * @param _weiAmount Value in wei involved in the purchase
717     */
718     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
719         require(_beneficiary != address(0), "Invalid beneficiary address.");
720         require(_weiAmount > 0, "Invalid investment value.");
721     }
722 
723     /**
724     * @dev Abstract function to count the number of tokens depending on the funds deposited
725     * @param _beneficiary Address for which to get the tokens amount
726     * @param _weiAmount Value in wei involved in the purchase
727     * @return Number of tokens
728     */
729     function _getTokensAmount(address _beneficiary, uint256 _weiAmount) internal view returns (uint256 tokens, uint256 bonus);
730 
731     /**
732     * @dev Executed when a purchase is ready to be executed
733     * @param _beneficiary Address receiving the tokens
734     * @param _tokensAmount Number of tokens to be purchased
735     */
736     function _processPurchase(address _beneficiary, uint256 _tokensAmount) internal {
737         _deliverTokens(_beneficiary, _tokensAmount);
738     }
739 
740     /**
741     * @dev Deliver tokens to investor
742     * @param _beneficiary Address receiving the tokens
743     * @param _tokensAmount Number of tokens to be purchased
744     */
745     function _deliverTokens(address _beneficiary, uint256 _tokensAmount) internal {
746         token.safeTransfer(_beneficiary, _tokensAmount);
747     }
748 
749     /**
750     * @dev Changes the contract state after purchase
751     * @param _beneficiary Address received the tokens
752     * @param _tokensAmount The number of tokens that were purchased
753     */
754     function _postPurchaseUpdate(address _beneficiary, uint256 _tokensAmount) internal {
755         tokensSold = tokensSold.add(_tokensAmount);
756     }
757 }
758 
759 
760 
761 contract LockableCrowdsale is Time, Lockable, Operable, PriceStrategy, BaseCrowdsale {
762     using SafeMath for uint256;
763 
764     /**
765     * @dev Locks the next purchase for the provision of bonus tokens
766     * @param _beneficiary Address for which the next purchase will be locked
767     * @param _lockupPeriod The period to which tokens will be locked from the next purchase
768     */
769     function lockNextPurchase(address _beneficiary, uint256 _lockupPeriod) external hasOwnerOrOperatePermission {
770         require(_lockupPeriod == 6 || _lockupPeriod == 12 || _lockupPeriod == 18, "Invalid lock interval");
771         Stage memory currentStage = _getCurrentStage();
772         require(currentStage.lock, "Lock operation is not allowed.");
773         _lock(_beneficiary, _lockupPeriod);      
774     }
775 
776     /**
777     * @dev Executed when a purchase is ready to be executed
778     * @param _beneficiary Address receiving the tokens
779     * @param _tokensAmount Number of tokens to be purchased
780     */
781     function _processPurchase(address _beneficiary, uint256 _tokensAmount) internal {
782         super._processPurchase(_beneficiary, _tokensAmount);
783         uint256 lockedValue = lockedValues[_beneficiary];
784 
785         if (lockedValue > 0) {
786             uint256 expires = lockupPeriods[lockedValue].expires;
787             token.lock(_beneficiary, _tokensAmount, expires);
788         }
789     }
790 
791     /**
792     * @dev Counts the number of tokens depending on the funds deposited
793     * @param _beneficiary Address for which to get the tokens amount
794     * @param _weiAmount Value in wei involved in the purchase
795     * @return Number of tokens
796     */
797     function _getTokensAmount(address _beneficiary, uint256 _weiAmount) internal view returns (uint256 tokens, uint256 bonus) { 
798         (tokens, bonus) = getTokensAmount(_weiAmount, lockedValues[_beneficiary], tokensSold);
799     }
800 
801     /**
802     * @dev Changes the contract state after purchase
803     * @param _beneficiary Address received the tokens
804     * @param _tokensAmount The number of tokens that were purchased
805     */
806     function _postPurchaseUpdate(address _beneficiary, uint256 _tokensAmount) internal {
807         super._postPurchaseUpdate(_beneficiary, _tokensAmount);
808 
809         _unlock(_beneficiary);
810     }
811 }
812 
813 
814 
815 
816 
817 
818 
819 
820 
821 
822 contract Whitelist is RBAC, Operable {
823     // role key
824     string public constant ROLE_WHITELISTED = "whitelist";
825 
826     /**
827     * @dev Throws if operator is not whitelisted.
828     * @param _operator Operator address
829     */
830     modifier onlyIfWhitelisted(address _operator) {
831         checkRole(_operator, ROLE_WHITELISTED);
832         _;
833     }
834 
835     /**
836     * @dev Add an address to the whitelist
837     * @param _operator Operator address
838     */
839     function addAddressToWhitelist(address _operator) public hasOwnerOrOperatePermission {
840         addRole(_operator, ROLE_WHITELISTED);
841     }
842 
843     /**
844     * @dev Getter to determine if address is in whitelist
845     * @param _operator The address to be added to the whitelist
846     * @return True if the address is in the whitelist
847     */
848     function whitelist(address _operator) public view returns (bool) {
849         return hasRole(_operator, ROLE_WHITELISTED);
850     }
851 
852     /**
853     * @dev Add addresses to the whitelist
854     * @param _operators Operators addresses
855     */
856     function addAddressesToWhitelist(address[] _operators) public hasOwnerOrOperatePermission {
857         for (uint256 i = 0; i < _operators.length; i++) {
858             addAddressToWhitelist(_operators[i]);
859         }
860     }
861 
862     /**
863     * @dev Remove an address from the whitelist
864     * @param _operator Operator address
865     */
866     function removeAddressFromWhitelist(address _operator) public hasOwnerOrOperatePermission {
867         removeRole(_operator, ROLE_WHITELISTED);
868     }
869 
870     /**
871     * @dev Remove addresses from the whitelist
872     * @param _operators Operators addresses
873     */
874     function removeAddressesFromWhitelist(address[] _operators) public hasOwnerOrOperatePermission {
875         for (uint256 i = 0; i < _operators.length; i++) {
876             removeAddressFromWhitelist(_operators[i]);
877         }
878     }
879 }
880 
881 
882 
883 contract WhitelistedCrowdsale is Whitelist, BaseCrowdsale {
884     /**
885     * @dev Extend parent behavior requiring beneficiary to be in whitelist.
886     * @param _beneficiary Token beneficiary
887     * @param _weiAmount Amount of wei contributed
888     */
889     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyIfWhitelisted(_beneficiary) {
890         super._preValidatePurchase(_beneficiary, _weiAmount);
891     }
892 }
893 
894 
895 
896 
897 
898 
899 
900 
901 
902 /**
903  * @title Pausable
904  * @dev Base contract which allows children to implement an emergency stop mechanism.
905  */
906 contract Pausable is Ownable {
907   event Pause();
908   event Unpause();
909 
910   bool public paused = false;
911 
912 
913   /**
914    * @dev Modifier to make a function callable only when the contract is not paused.
915    */
916   modifier whenNotPaused() {
917     require(!paused);
918     _;
919   }
920 
921   /**
922    * @dev Modifier to make a function callable only when the contract is paused.
923    */
924   modifier whenPaused() {
925     require(paused);
926     _;
927   }
928 
929   /**
930    * @dev called by the owner to pause, triggers stopped state
931    */
932   function pause() onlyOwner whenNotPaused public {
933     paused = true;
934     emit Pause();
935   }
936 
937   /**
938    * @dev called by the owner to unpause, returns to normal state
939    */
940   function unpause() onlyOwner whenPaused public {
941     paused = false;
942     emit Unpause();
943   }
944 }
945 
946 
947 
948 
949 contract PausableCrowdsale is Pausable, BaseCrowdsale {
950     /**
951     * @dev Extend parent behavior requiring contract not to be paused
952     * @param _beneficiary Token beneficiary
953     * @param _weiAmount Amount of wei contributed
954     */
955     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
956         super._preValidatePurchase(_beneficiary, _weiAmount);
957     }
958 }
959 
960 
961 
962 
963 
964 
965 
966 
967 
968 
969 /**
970  * @title ERC20 interface
971  * @dev see https://github.com/ethereum/EIPs/issues/20
972  */
973 contract ERC20 is ERC20Basic {
974   function allowance(address owner, address spender)
975     public view returns (uint256);
976 
977   function transferFrom(address from, address to, uint256 value)
978     public returns (bool);
979 
980   function approve(address spender, uint256 value) public returns (bool);
981   event Approval(
982     address indexed owner,
983     address indexed spender,
984     uint256 value
985   );
986 }
987 
988 
989 
990 /**
991  * @title DetailedERC20 token
992  * @dev The decimals are only for visualization purposes.
993  * All the operations are done using the smallest and indivisible token unit,
994  * just as on Ethereum all the operations are done in wei.
995  */
996 contract DetailedERC20 is ERC20 {
997   string public name;
998   string public symbol;
999   uint8 public decimals;
1000 
1001   constructor(string _name, string _symbol, uint8 _decimals) public {
1002     name = _name;
1003     symbol = _symbol;
1004     decimals = _decimals;
1005   }
1006 }
1007 
1008 
1009 
1010 
1011 
1012 
1013 
1014 
1015 
1016 
1017 /**
1018  * @title Basic token
1019  * @dev Basic version of StandardToken, with no allowances.
1020  */
1021 contract BasicToken is ERC20Basic {
1022   using SafeMath for uint256;
1023 
1024   mapping(address => uint256) balances;
1025 
1026   uint256 totalSupply_;
1027 
1028   /**
1029   * @dev Total number of tokens in existence
1030   */
1031   function totalSupply() public view returns (uint256) {
1032     return totalSupply_;
1033   }
1034 
1035   /**
1036   * @dev Transfer token for a specified address
1037   * @param _to The address to transfer to.
1038   * @param _value The amount to be transferred.
1039   */
1040   function transfer(address _to, uint256 _value) public returns (bool) {
1041     require(_to != address(0));
1042     require(_value <= balances[msg.sender]);
1043 
1044     balances[msg.sender] = balances[msg.sender].sub(_value);
1045     balances[_to] = balances[_to].add(_value);
1046     emit Transfer(msg.sender, _to, _value);
1047     return true;
1048   }
1049 
1050   /**
1051   * @dev Gets the balance of the specified address.
1052   * @param _owner The address to query the the balance of.
1053   * @return An uint256 representing the amount owned by the passed address.
1054   */
1055   function balanceOf(address _owner) public view returns (uint256) {
1056     return balances[_owner];
1057   }
1058 
1059 }
1060 
1061 
1062 
1063 
1064 /**
1065  * @title Standard ERC20 token
1066  *
1067  * @dev Implementation of the basic standard token.
1068  * https://github.com/ethereum/EIPs/issues/20
1069  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1070  */
1071 contract StandardToken is ERC20, BasicToken {
1072 
1073   mapping (address => mapping (address => uint256)) internal allowed;
1074 
1075 
1076   /**
1077    * @dev Transfer tokens from one address to another
1078    * @param _from address The address which you want to send tokens from
1079    * @param _to address The address which you want to transfer to
1080    * @param _value uint256 the amount of tokens to be transferred
1081    */
1082   function transferFrom(
1083     address _from,
1084     address _to,
1085     uint256 _value
1086   )
1087     public
1088     returns (bool)
1089   {
1090     require(_to != address(0));
1091     require(_value <= balances[_from]);
1092     require(_value <= allowed[_from][msg.sender]);
1093 
1094     balances[_from] = balances[_from].sub(_value);
1095     balances[_to] = balances[_to].add(_value);
1096     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1097     emit Transfer(_from, _to, _value);
1098     return true;
1099   }
1100 
1101   /**
1102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1107    * @param _spender The address which will spend the funds.
1108    * @param _value The amount of tokens to be spent.
1109    */
1110   function approve(address _spender, uint256 _value) public returns (bool) {
1111     allowed[msg.sender][_spender] = _value;
1112     emit Approval(msg.sender, _spender, _value);
1113     return true;
1114   }
1115 
1116   /**
1117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1118    * @param _owner address The address which owns the funds.
1119    * @param _spender address The address which will spend the funds.
1120    * @return A uint256 specifying the amount of tokens still available for the spender.
1121    */
1122   function allowance(
1123     address _owner,
1124     address _spender
1125    )
1126     public
1127     view
1128     returns (uint256)
1129   {
1130     return allowed[_owner][_spender];
1131   }
1132 
1133   /**
1134    * @dev Increase the amount of tokens that an owner allowed to a spender.
1135    * approve should be called when allowed[_spender] == 0. To increment
1136    * allowed value is better to use this function to avoid 2 calls (and wait until
1137    * the first transaction is mined)
1138    * From MonolithDAO Token.sol
1139    * @param _spender The address which will spend the funds.
1140    * @param _addedValue The amount of tokens to increase the allowance by.
1141    */
1142   function increaseApproval(
1143     address _spender,
1144     uint256 _addedValue
1145   )
1146     public
1147     returns (bool)
1148   {
1149     allowed[msg.sender][_spender] = (
1150       allowed[msg.sender][_spender].add(_addedValue));
1151     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1152     return true;
1153   }
1154 
1155   /**
1156    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1157    * approve should be called when allowed[_spender] == 0. To decrement
1158    * allowed value is better to use this function to avoid 2 calls (and wait until
1159    * the first transaction is mined)
1160    * From MonolithDAO Token.sol
1161    * @param _spender The address which will spend the funds.
1162    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1163    */
1164   function decreaseApproval(
1165     address _spender,
1166     uint256 _subtractedValue
1167   )
1168     public
1169     returns (bool)
1170   {
1171     uint256 oldValue = allowed[msg.sender][_spender];
1172     if (_subtractedValue > oldValue) {
1173       allowed[msg.sender][_spender] = 0;
1174     } else {
1175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1176     }
1177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1178     return true;
1179   }
1180 
1181 }
1182 
1183 
1184 
1185 
1186 
1187 
1188 contract CosquareToken is Time, StandardToken, DetailedERC20, Ownable {
1189     using SafeMath for uint256;
1190 
1191     /**
1192     * Describes locked balance
1193     * @param expires Time when tokens will be unlocked
1194     * @param value Amount of the tokens is locked
1195     */
1196     struct LockedBalance {
1197         uint256 expires;
1198         uint256 value;
1199     }
1200 
1201     // locked balances specified be the address
1202     mapping(address => LockedBalance[]) public lockedBalances;
1203 
1204     // sale wallet (65%)
1205     address public saleWallet;
1206     // reserve wallet (15%)
1207     address public reserveWallet;
1208     // team wallet (15%)
1209     address public teamWallet;
1210     // strategic wallet (5%)
1211     address public strategicWallet;
1212 
1213     // end point, after which all tokens will be unlocked
1214     uint256 public lockEndpoint;
1215 
1216     /**
1217     * Event for lock logging
1218     * @param who The address on which part of the tokens is locked
1219     * @param value Amount of the tokens is locked
1220     * @param expires Time when tokens will be unlocked
1221     */
1222     event LockLog(address indexed who, uint256 value, uint256 expires);
1223 
1224     /**
1225     * @param _saleWallet Sale wallet
1226     * @param _reserveWallet Reserve wallet
1227     * @param _teamWallet Team wallet
1228     * @param _strategicWallet Strategic wallet
1229     * @param _lockEndpoint End point, after which all tokens will be unlocked
1230     */
1231     constructor(address _saleWallet, address _reserveWallet, address _teamWallet, address _strategicWallet, uint256 _lockEndpoint) 
1232       DetailedERC20("cosquare", "CSQ", 18) public {
1233         require(_lockEndpoint > 0, "Invalid global lock end date.");
1234         lockEndpoint = _lockEndpoint;
1235 
1236         _configureWallet(_saleWallet, 65000000000000000000000000000); // 6.5e+28
1237         saleWallet = _saleWallet;
1238         _configureWallet(_reserveWallet, 15000000000000000000000000000); // 1.5e+28
1239         reserveWallet = _reserveWallet;
1240         _configureWallet(_teamWallet, 15000000000000000000000000000); // 1.5e+28
1241         teamWallet = _teamWallet;
1242         _configureWallet(_strategicWallet, 5000000000000000000000000000); // 0.5e+28
1243         strategicWallet = _strategicWallet;
1244     }
1245 
1246     /**
1247     * @dev Setting the initial value of the tokens to the wallet
1248     * @param _wallet Address to be set up
1249     * @param _amount The number of tokens to be assigned to this address
1250     */
1251     function _configureWallet(address _wallet, uint256 _amount) private {
1252         require(_wallet != address(0), "Invalid wallet address.");
1253 
1254         totalSupply_ = totalSupply_.add(_amount);
1255         balances[_wallet] = _amount;
1256         emit Transfer(address(0), _wallet, _amount);
1257     }
1258 
1259     /**
1260     * @dev Throws if the address does not have enough not locked balance
1261     * @param _who The address to transfer from
1262     * @param _value The amount to be transferred
1263     */
1264     modifier notLocked(address _who, uint256 _value) {
1265         uint256 time = _currentTime();
1266 
1267         if (lockEndpoint > time) {
1268             uint256 index = 0;
1269             uint256 locked = 0;
1270             while (index < lockedBalances[_who].length) {
1271                 if (lockedBalances[_who][index].expires > time) {
1272                     locked = locked.add(lockedBalances[_who][index].value);
1273                 }
1274 
1275                 index++;
1276             }
1277 
1278             require(_value <= balances[_who].sub(locked), "Not enough unlocked tokens");
1279         }        
1280         _;
1281     }
1282 
1283     /**
1284     * @dev Overridden to check whether enough not locked balance
1285     * @param _from The address which you want to send tokens from
1286     * @param _to The address which you want to transfer to
1287     * @param _value The amount of tokens to be transferred
1288     */
1289     function transferFrom(address _from, address _to, uint256 _value) public notLocked(_from, _value) returns (bool) {
1290         return super.transferFrom(_from, _to, _value);
1291     }
1292 
1293     /**
1294     * @dev Overridden to check whether enough not locked balance
1295     * @param _to The address to transfer to
1296     * @param _value The amount to be transferred
1297     */
1298     function transfer(address _to, uint256 _value) public notLocked(msg.sender, _value) returns (bool) {
1299         return super.transfer(_to, _value);
1300     }
1301 
1302     /**
1303     * @dev Gets the locked balance of the specified address
1304     * @param _owner The address to query the locked balance of
1305     * @param _expires Time of expiration of the lock (If equals to 0 - returns all locked tokens at this moment)
1306     * @return An uint256 representing the amount of locked balance by the passed address
1307     */
1308     function lockedBalanceOf(address _owner, uint256 _expires) external view returns (uint256) {
1309         uint256 time = _currentTime();
1310         uint256 index = 0;
1311         uint256 locked = 0;
1312 
1313         if (lockEndpoint > time) {       
1314             while (index < lockedBalances[_owner].length) {
1315                 if (_expires > 0) {
1316                     if (lockedBalances[_owner][index].expires == _expires) {
1317                         locked = locked.add(lockedBalances[_owner][index].value);
1318                     }
1319                 } else {
1320                     if (lockedBalances[_owner][index].expires >= time) {
1321                         locked = locked.add(lockedBalances[_owner][index].value);
1322                     }
1323                 }
1324 
1325                 index++;
1326             }
1327         }
1328 
1329         return locked;
1330     }
1331 
1332     /**
1333     * @dev Locks part of the balance for the specified address and for a certain period (3 periods expected)
1334     * @param _who The address of which will be locked part of the balance
1335     * @param _value The amount of tokens to be locked
1336     * @param _expires Time of expiration of the lock
1337     */
1338     function lock(address _who, uint256 _value, uint256 _expires) public onlyOwner {
1339         uint256 time = _currentTime();
1340         require(_who != address(0) && _value <= balances[_who] && _expires > time, "Invalid lock configuration.");
1341 
1342         uint256 index = 0;
1343         bool exist = false;
1344         while (index < lockedBalances[_who].length) {
1345             if (lockedBalances[_who][index].expires == _expires) {
1346                 exist = true;
1347                 break;
1348             }
1349 
1350             index++;
1351         }
1352 
1353         if (exist) {
1354             lockedBalances[_who][index].value = lockedBalances[_who][index].value.add(_value);
1355         } else {
1356             lockedBalances[_who].push(LockedBalance({
1357                 expires: _expires,
1358                 value: _value
1359             }));
1360         }
1361 
1362         emit LockLog(_who, _value, _expires);
1363     }
1364 }
1365 
1366 
1367 contract Crowdsale is Lockable, Operable, Withdrawal, PriceStrategy, LockableCrowdsale, WhitelistedCrowdsale, PausableCrowdsale {
1368     using SafeMath for uint256;
1369 
1370     /**
1371     * @param _rateETHtoCHF Cost of ETH in CHF
1372     * @param _minInvestmentInCHF Minimal allowed investment in CHF
1373     * @param _withdrawWallet Address to which funds will be withdrawn
1374     * @param _token Address of the token being sold
1375     */
1376     constructor(uint256 _rateETHtoCHF, uint256 _minInvestmentInCHF, address _withdrawWallet, CosquareToken _token)
1377         PriceStrategy(_rateETHtoCHF, _minInvestmentInCHF)
1378         Withdrawal(_withdrawWallet)
1379         BaseCrowdsale(_token) public {
1380     }  
1381 
1382     /**
1383     * @dev Distributes tokens for wei investments
1384     * @param _beneficiary Address performing the token purchase
1385     * @param _ethAmount Investment value in ETH
1386     * @param _type Type of investment channel
1387     */
1388     function distributeTokensForInvestment(address _beneficiary, uint256 _ethAmount, string _type) public hasOwnerOrOperatePermission {
1389         _buyTokens(_beneficiary, _ethAmount, _type);
1390     }
1391 
1392     /**
1393     * @dev Distributes tokens manually
1394     * @param _beneficiary Address performing the tokens distribution
1395     * @param _tokensAmount Amount of tokens distribution
1396     */
1397     function distributeTokensManual(address _beneficiary, uint256 _tokensAmount) external hasOwnerOrOperatePermission {
1398         _preValidatePurchase(_beneficiary, _tokensAmount);
1399 
1400         _deliverTokens(_beneficiary, _tokensAmount);
1401         emit TokensPurchaseLog("MANUAL", _beneficiary, 0, _tokensAmount, 0);
1402 
1403         _postPurchaseUpdate(_beneficiary, _tokensAmount);
1404     }
1405 }