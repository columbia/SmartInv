1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/ownership/rbac/Roles.sol
92 
93 /**
94  * @title Roles
95  * @author Francisco Giordano (@frangio)
96  * @dev Library for managing addresses assigned to a Role.
97  *      See RBAC.sol for example usage.
98  */
99 library Roles {
100   struct Role {
101     mapping (address => bool) bearer;
102   }
103 
104   /**
105    * @dev give an address access to this role
106    */
107   function add(Role storage role, address addr)
108     internal
109   {
110     role.bearer[addr] = true;
111   }
112 
113   /**
114    * @dev remove an address' access to this role
115    */
116   function remove(Role storage role, address addr)
117     internal
118   {
119     role.bearer[addr] = false;
120   }
121 
122   /**
123    * @dev check if an address has this role
124    * // reverts
125    */
126   function check(Role storage role, address addr)
127     view
128     internal
129   {
130     require(has(role, addr));
131   }
132 
133   /**
134    * @dev check if an address has this role
135    * @return bool
136    */
137   function has(Role storage role, address addr)
138     view
139     internal
140     returns (bool)
141   {
142     return role.bearer[addr];
143   }
144 }
145 
146 // File: zeppelin-solidity/contracts/ownership/rbac/RBAC.sol
147 
148 /**
149  * @title RBAC (Role-Based Access Control)
150  * @author Matt Condon (@Shrugs)
151  * @dev Stores and provides setters and getters for roles and addresses.
152  *      Supports unlimited numbers of roles and addresses.
153  *      See //contracts/mocks/RBACMock.sol for an example of usage.
154  * This RBAC method uses strings to key roles. It may be beneficial
155  *  for you to write your own implementation of this interface using Enums or similar.
156  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
157  *  to avoid typos.
158  */
159 contract RBAC {
160   using Roles for Roles.Role;
161 
162   mapping (string => Roles.Role) private roles;
163 
164   event RoleAdded(address addr, string roleName);
165   event RoleRemoved(address addr, string roleName);
166 
167   /**
168    * A constant role name for indicating admins.
169    */
170   string public constant ROLE_ADMIN = "admin";
171 
172   /**
173    * @dev constructor. Sets msg.sender as admin by default
174    */
175   function RBAC()
176     public
177   {
178     addRole(msg.sender, ROLE_ADMIN);
179   }
180 
181   /**
182    * @dev reverts if addr does not have role
183    * @param addr address
184    * @param roleName the name of the role
185    * // reverts
186    */
187   function checkRole(address addr, string roleName)
188     view
189     public
190   {
191     roles[roleName].check(addr);
192   }
193 
194   /**
195    * @dev determine if addr has role
196    * @param addr address
197    * @param roleName the name of the role
198    * @return bool
199    */
200   function hasRole(address addr, string roleName)
201     view
202     public
203     returns (bool)
204   {
205     return roles[roleName].has(addr);
206   }
207 
208   /**
209    * @dev add a role to an address
210    * @param addr address
211    * @param roleName the name of the role
212    */
213   function adminAddRole(address addr, string roleName)
214     onlyAdmin
215     public
216   {
217     addRole(addr, roleName);
218   }
219 
220   /**
221    * @dev remove a role from an address
222    * @param addr address
223    * @param roleName the name of the role
224    */
225   function adminRemoveRole(address addr, string roleName)
226     onlyAdmin
227     public
228   {
229     removeRole(addr, roleName);
230   }
231 
232   /**
233    * @dev add a role to an address
234    * @param addr address
235    * @param roleName the name of the role
236    */
237   function addRole(address addr, string roleName)
238     internal
239   {
240     roles[roleName].add(addr);
241     RoleAdded(addr, roleName);
242   }
243 
244   /**
245    * @dev remove a role from an address
246    * @param addr address
247    * @param roleName the name of the role
248    */
249   function removeRole(address addr, string roleName)
250     internal
251   {
252     roles[roleName].remove(addr);
253     RoleRemoved(addr, roleName);
254   }
255 
256   /**
257    * @dev modifier to scope access to a single role (uses msg.sender as addr)
258    * @param roleName the name of the role
259    * // reverts
260    */
261   modifier onlyRole(string roleName)
262   {
263     checkRole(msg.sender, roleName);
264     _;
265   }
266 
267   /**
268    * @dev modifier to scope access to admins
269    * // reverts
270    */
271   modifier onlyAdmin()
272   {
273     checkRole(msg.sender, ROLE_ADMIN);
274     _;
275   }
276 
277   /**
278    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
279    * @param roleNames the names of the roles to scope access to
280    * // reverts
281    *
282    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
283    *  see: https://github.com/ethereum/solidity/issues/2467
284    */
285   // modifier onlyRoles(string[] roleNames) {
286   //     bool hasAnyRole = false;
287   //     for (uint8 i = 0; i < roleNames.length; i++) {
288   //         if (hasRole(msg.sender, roleNames[i])) {
289   //             hasAnyRole = true;
290   //             break;
291   //         }
292   //     }
293 
294   //     require(hasAnyRole);
295 
296   //     _;
297   // }
298 }
299 
300 // File: zeppelin-solidity/contracts/math/SafeMath.sol
301 
302 /**
303  * @title SafeMath
304  * @dev Math operations with safety checks that throw on error
305  */
306 library SafeMath {
307 
308   /**
309   * @dev Multiplies two numbers, throws on overflow.
310   */
311   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312     if (a == 0) {
313       return 0;
314     }
315     uint256 c = a * b;
316     assert(c / a == b);
317     return c;
318   }
319 
320   /**
321   * @dev Integer division of two numbers, truncating the quotient.
322   */
323   function div(uint256 a, uint256 b) internal pure returns (uint256) {
324     // assert(b > 0); // Solidity automatically throws when dividing by 0
325     uint256 c = a / b;
326     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
327     return c;
328   }
329 
330   /**
331   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
332   */
333   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
334     assert(b <= a);
335     return a - b;
336   }
337 
338   /**
339   * @dev Adds two numbers, throws on overflow.
340   */
341   function add(uint256 a, uint256 b) internal pure returns (uint256) {
342     uint256 c = a + b;
343     assert(c >= a);
344     return c;
345   }
346 }
347 
348 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
349 
350 /**
351  * @title ERC20Basic
352  * @dev Simpler version of ERC20 interface
353  * @dev see https://github.com/ethereum/EIPs/issues/179
354  */
355 contract ERC20Basic {
356   function totalSupply() public view returns (uint256);
357   function balanceOf(address who) public view returns (uint256);
358   function transfer(address to, uint256 value) public returns (bool);
359   event Transfer(address indexed from, address indexed to, uint256 value);
360 }
361 
362 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
363 
364 /**
365  * @title Basic token
366  * @dev Basic version of StandardToken, with no allowances.
367  */
368 contract BasicToken is ERC20Basic {
369   using SafeMath for uint256;
370 
371   mapping(address => uint256) balances;
372 
373   uint256 totalSupply_;
374 
375   /**
376   * @dev total number of tokens in existence
377   */
378   function totalSupply() public view returns (uint256) {
379     return totalSupply_;
380   }
381 
382   /**
383   * @dev transfer token for a specified address
384   * @param _to The address to transfer to.
385   * @param _value The amount to be transferred.
386   */
387   function transfer(address _to, uint256 _value) public returns (bool) {
388     require(_to != address(0));
389     require(_value <= balances[msg.sender]);
390 
391     // SafeMath.sub will throw if there is not enough balance.
392     balances[msg.sender] = balances[msg.sender].sub(_value);
393     balances[_to] = balances[_to].add(_value);
394     Transfer(msg.sender, _to, _value);
395     return true;
396   }
397 
398   /**
399   * @dev Gets the balance of the specified address.
400   * @param _owner The address to query the the balance of.
401   * @return An uint256 representing the amount owned by the passed address.
402   */
403   function balanceOf(address _owner) public view returns (uint256 balance) {
404     return balances[_owner];
405   }
406 
407 }
408 
409 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
410 
411 /**
412  * @title ERC20 interface
413  * @dev see https://github.com/ethereum/EIPs/issues/20
414  */
415 contract ERC20 is ERC20Basic {
416   function allowance(address owner, address spender) public view returns (uint256);
417   function transferFrom(address from, address to, uint256 value) public returns (bool);
418   function approve(address spender, uint256 value) public returns (bool);
419   event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
423 
424 /**
425  * @title Standard ERC20 token
426  *
427  * @dev Implementation of the basic standard token.
428  * @dev https://github.com/ethereum/EIPs/issues/20
429  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
430  */
431 contract StandardToken is ERC20, BasicToken {
432 
433   mapping (address => mapping (address => uint256)) internal allowed;
434 
435 
436   /**
437    * @dev Transfer tokens from one address to another
438    * @param _from address The address which you want to send tokens from
439    * @param _to address The address which you want to transfer to
440    * @param _value uint256 the amount of tokens to be transferred
441    */
442   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
443     require(_to != address(0));
444     require(_value <= balances[_from]);
445     require(_value <= allowed[_from][msg.sender]);
446 
447     balances[_from] = balances[_from].sub(_value);
448     balances[_to] = balances[_to].add(_value);
449     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
450     Transfer(_from, _to, _value);
451     return true;
452   }
453 
454   /**
455    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
456    *
457    * Beware that changing an allowance with this method brings the risk that someone may use both the old
458    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
459    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
460    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
461    * @param _spender The address which will spend the funds.
462    * @param _value The amount of tokens to be spent.
463    */
464   function approve(address _spender, uint256 _value) public returns (bool) {
465     allowed[msg.sender][_spender] = _value;
466     Approval(msg.sender, _spender, _value);
467     return true;
468   }
469 
470   /**
471    * @dev Function to check the amount of tokens that an owner allowed to a spender.
472    * @param _owner address The address which owns the funds.
473    * @param _spender address The address which will spend the funds.
474    * @return A uint256 specifying the amount of tokens still available for the spender.
475    */
476   function allowance(address _owner, address _spender) public view returns (uint256) {
477     return allowed[_owner][_spender];
478   }
479 
480   /**
481    * @dev Increase the amount of tokens that an owner allowed to a spender.
482    *
483    * approve should be called when allowed[_spender] == 0. To increment
484    * allowed value is better to use this function to avoid 2 calls (and wait until
485    * the first transaction is mined)
486    * From MonolithDAO Token.sol
487    * @param _spender The address which will spend the funds.
488    * @param _addedValue The amount of tokens to increase the allowance by.
489    */
490   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
491     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
492     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
493     return true;
494   }
495 
496   /**
497    * @dev Decrease the amount of tokens that an owner allowed to a spender.
498    *
499    * approve should be called when allowed[_spender] == 0. To decrement
500    * allowed value is better to use this function to avoid 2 calls (and wait until
501    * the first transaction is mined)
502    * From MonolithDAO Token.sol
503    * @param _spender The address which will spend the funds.
504    * @param _subtractedValue The amount of tokens to decrease the allowance by.
505    */
506   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
507     uint oldValue = allowed[msg.sender][_spender];
508     if (_subtractedValue > oldValue) {
509       allowed[msg.sender][_spender] = 0;
510     } else {
511       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
512     }
513     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
514     return true;
515   }
516 
517 }
518 
519 // File: contracts/PausableToken.sol
520 
521 contract PausableToken is StandardToken, Pausable, RBAC {
522 
523     string public constant ROLE_ADMINISTRATOR = "administrator";
524 
525     modifier whenNotPausedOrAuthorized() {
526         require(!paused || hasRole(msg.sender, ROLE_ADMINISTRATOR));
527         _;
528     }
529     /**
530      * @dev Add an address that can administer the token even when paused.
531      * @param _administrator Address of the given administrator.
532      * @return True if the administrator has been added, false if the address was already an administrator.
533      */
534     function addAdministrator(address _administrator) onlyOwner public returns (bool) {
535         if (isAdministrator(_administrator)) {
536             return false;
537         } else {
538             addRole(_administrator, ROLE_ADMINISTRATOR);
539             return true;
540         }
541     }
542 
543     /**
544      * @dev Remove an administrator.
545      * @param _administrator Address of the administrator to be removed.
546      * @return True if the administrator has been removed,
547      *  false if the address wasn't an administrator in the first place.
548      */
549     function removeAdministrator(address _administrator) onlyOwner public returns (bool) {
550         if (isAdministrator(_administrator)) {
551             removeRole(_administrator, ROLE_ADMINISTRATOR);
552             return true;
553         } else {
554             return false;
555         }
556     }
557 
558     /**
559      * @dev Determine if address is an administrator.
560      * @param _administrator Address of the administrator to be checked.
561      */
562     function isAdministrator(address _administrator) public view returns (bool) {
563         return hasRole(_administrator, ROLE_ADMINISTRATOR);
564     }
565 
566     /**
567     * @dev Transfer token for a specified address with pause feature for administrator.
568     * @dev Only applies when the transfer is allowed by the owner.
569     * @param _to The address to transfer to.
570     * @param _value The amount to be transferred.
571     */
572     function transfer(address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
573         return super.transfer(_to, _value);
574     }
575 
576     /**
577     * @dev Transfer tokens from one address to another with pause feature for administrator.
578     * @dev Only applies when the transfer is allowed by the owner.
579     * @param _from address The address which you want to send tokens from
580     * @param _to address The address which you want to transfer to
581     * @param _value uint256 the amount of tokens to be transferred
582     */
583     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrAuthorized returns (bool) {
584         return super.transferFrom(_from, _to, _value);
585     }
586 }
587 
588 // File: contracts/CurrentToken.sol
589 
590 contract CurrentToken is PausableToken {
591     string constant public name = "CurrentCoin";
592     string constant public symbol = "CUR";
593     uint8 constant public decimals = 18;
594 
595     uint256 constant public INITIAL_TOTAL_SUPPLY = 1e11 * (uint256(10) ** decimals);
596 
597     /**
598     * @dev Create CurrentToken contract and set pause
599     */
600     function CurrentToken() public {
601         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
602         balances[msg.sender] = totalSupply_;
603         Transfer(address(0), msg.sender, totalSupply_);
604 
605         pause();
606     }
607 }
608 
609 // File: contracts/VariableTimeBonusRate.sol
610 
611 /**
612  * @title VariableTimeRate
613  * @dev Contract with time dependent token distribution rate variable.
614  */
615 contract VariableTimeBonusRate {
616     using SafeMath for uint256;
617 
618     // Struct specifying the stages of rate modification.
619     struct RateModifier {
620         // Percentage by which the rate should be modified.
621         uint256 ratePermilles;
622 
623         // start time for a given rate
624         uint256 start;
625     }
626 
627     RateModifier[] private modifiers;
628 
629     /**
630      * @dev Finds currently applicable rate modifier.
631      * @return Current rate modifier percentage.
632      */
633     function currentModifier() public view returns (uint256 rateModifier) {
634         // solium-disable-next-line security/no-block-members
635         uint256 comparisonVariable = now;
636         for (uint i = 0; i < modifiers.length; i++) {
637             if (comparisonVariable >= modifiers[i].start) {
638                 rateModifier = modifiers[i].ratePermilles;
639             }
640         }
641     }
642 
643     function getRateModifierInPermilles() public view returns (uint256) {
644         return currentModifier();
645     }
646 
647     /**
648      * @dev Adds rate modifier checking not to add one with a start smaller than the previous.
649      * @param _rateModifier RateModifier struct.
650      */
651     function pushModifier(RateModifier _rateModifier) internal {
652         require(modifiers.length == 0 || _rateModifier.start > modifiers[modifiers.length - 1].start);
653         modifiers.push(_rateModifier);
654     }
655 }
656 
657 // File: contracts/TokenRate.sol
658 
659 contract TokenRate is VariableTimeBonusRate {
660 
661     uint256 constant public REFERRED_BONUS_PERMILLE  = 5;
662     uint256 constant public REFERRAL_BONUS_PERMILLE = 50;
663 
664     uint256 public rate;
665 
666     function TokenRate(uint256 _rate) public {
667         rate = _rate;
668     }
669 
670     function getCurrentBuyerRateInPermilles(bool isReferred) view public returns (uint256) {
671         uint256 permillesRate = VariableTimeBonusRate.getRateModifierInPermilles();
672         if (isReferred) {
673             permillesRate = permillesRate.add(REFERRED_BONUS_PERMILLE);
674         }
675         return permillesRate.add(1000);
676     }
677 
678     /**
679      * @dev amount for given wei calculation based on rate modifier percentage.
680      * @param _weiAmount Value in wei to be converted into tokens
681      * @return Number of tokens that can be purchased with the specified _weiAmount
682      */
683     function _getTokenAmountForBuyer(uint256 _weiAmount, bool isReferred) internal view returns (uint256) {
684         return _weiAmount.mul(rate).mul(getCurrentBuyerRateInPermilles(isReferred)).div(1000);
685     }
686 
687     function _getTokenAmountForReferral(uint256 _weiAmount, bool isReferred) internal view returns (uint256) {
688         if (isReferred) {
689             return _weiAmount.mul(rate).mul(REFERRAL_BONUS_PERMILLE).div(1000);
690         }
691         return 0;
692     }
693 
694     /**
695      * @dev amount of wei to pay for tokens - calculation based on rate modifier percentage.
696      * @param _tokensLeft Value in tokens to be converted into wei
697      * @return Number of wei that you must pay (bonus rate is taken into account)
698      */
699     function _getWeiValueOfTokens(uint256 _tokensLeft, bool isReferred) internal view returns (uint256) {
700         uint256 permillesRate = getCurrentBuyerRateInPermilles(isReferred);
701         if (isReferred) {
702             permillesRate = permillesRate.add(REFERRAL_BONUS_PERMILLE);
703         }
704         uint256 tokensToBuy = _tokensLeft.mul(1000).div(permillesRate);
705         return tokensToBuy.div(rate);
706     }
707 
708 }
709 
710 // File: contracts/Whitelist.sol
711 
712 /**
713  * @title Whitelist contract
714  * @dev Whitelist for wallets.
715 */
716 contract Whitelist is Ownable {
717     mapping(address => bool) whitelist;
718 
719     uint256 public whitelistLength = 0;
720 
721     /**
722     * @dev Add wallet to whitelist.
723     * @dev Accept request from the owner only.
724     * @param _wallet The address of wallet to add.
725     */  
726     function addWallet(address _wallet) onlyOwner public {
727         require(_wallet != address(0));
728         require(!isWhitelisted(_wallet));
729         whitelist[_wallet] = true;
730         whitelistLength++;
731     }
732 
733     /**
734     * @dev Remove wallet from whitelist.
735     * @dev Accept request from the owner only.
736     * @param _wallet The address of whitelisted wallet to remove.
737     */  
738     function removeWallet(address _wallet) onlyOwner public {
739         require(_wallet != address(0));
740         require(isWhitelisted(_wallet));
741         whitelist[_wallet] = false;
742         whitelistLength--;
743     }
744 
745     /**
746     * @dev Check the specified wallet whether it is in the whitelist.
747     * @param _wallet The address of wallet to check.
748     */ 
749     function isWhitelisted(address _wallet) constant public returns (bool) {
750         return whitelist[_wallet];
751     }
752 
753 }
754 
755 // File: contracts/CurrentCrowdsale.sol
756 
757 contract CurrentCrowdsale is Pausable, TokenRate {
758     using SafeMath for uint256;
759 
760     uint256 constant private DECIMALS = 18;
761     uint256 constant public HARDCAP_TOKENS_PRE_ICO = 100e6 * (10 ** DECIMALS);
762     uint256 constant public HARDCAP_TOKENS_ICO = 499e8 * (10 ** DECIMALS);
763 
764     uint256 public startPhase1 = 0;
765     uint256 public startPhase2 = 0;
766     uint256 public startPhase3 = 0;
767     uint256 public endOfPhase3 = 0;
768 
769     uint256 public maxcap = 0;
770 
771     uint256 public tokensSoldIco = 0;
772     uint256 public tokensRemainingIco = HARDCAP_TOKENS_ICO;
773     uint256 public tokensSoldTotal = 0;
774 
775     uint256 public weiRaisedIco = 0;
776     uint256 public weiRaisedTotal = 0;
777 
778     address private withdrawalWallet;
779 
780     CurrentToken public token;
781     Whitelist public whitelist;
782 
783     modifier beforeReachingHardCap() {
784         require(tokensRemainingIco > 0 && weiRaisedIco < maxcap);
785         _;
786     }
787 
788     modifier whenWhitelisted(address _wallet) {
789         require(whitelist.isWhitelisted(_wallet));
790         _;
791     }
792 
793     /**
794     * @dev Constructor for CurrentCrowdsale contract.
795     * @dev Set the owner who can manage whitelist and token.
796     * @param _maxcap The maxcap value.
797     * @param _startPhase1 The phase1 ICO start time.
798     * @param _startPhase2 The phase2 ICO start time.
799     * @param _startPhase3 The phase3 ICO start time.
800     * @param _endOfPhase3 The end time of ICO.
801     * @param _withdrawalWallet The address to which raised funds will be withdrawn.
802     * @param _rate exchange rate for ico.
803     * @param _token address of token used for ico.
804     * @param _whitelist address of whitelist contract used for ico.
805     */
806     function CurrentCrowdsale(
807         uint256 _maxcap,
808         uint256 _startPhase1,
809         uint256 _startPhase2,
810         uint256 _startPhase3,
811         uint256 _endOfPhase3,
812         address _withdrawalWallet,
813         uint256 _rate,
814         CurrentToken _token,
815         Whitelist _whitelist
816     )  TokenRate(_rate) public
817     {
818         require(_withdrawalWallet != address(0));
819         require(_token != address(0) && _whitelist != address(0));
820         require(_startPhase1 >= now);
821         require(_endOfPhase3 > _startPhase3);
822         require(_maxcap > 0);
823 
824         token = _token;
825         whitelist = _whitelist;
826 
827         startPhase1 = _startPhase1;
828         startPhase2 = _startPhase2;
829         startPhase3 = _startPhase3;
830         endOfPhase3 = _endOfPhase3;
831 
832         withdrawalWallet = _withdrawalWallet;
833 
834         maxcap = _maxcap;
835         tokensSoldTotal = HARDCAP_TOKENS_PRE_ICO;
836         weiRaisedTotal = tokensSoldTotal.div(_rate.mul(2));
837 
838         pushModifier(RateModifier(200, startPhase1));
839         pushModifier(RateModifier(150, startPhase2));
840         pushModifier(RateModifier(100, startPhase3));
841     }
842 
843     /**
844     * @dev Fallback function can be used to buy tokens.
845     */
846     function() public payable {
847         if (isIco()) {
848             sellTokensIco();
849         } else {
850             revert();
851         }
852     }
853 
854     /**
855     * @dev Check whether the ICO is active at the moment.
856     */
857     function isIco() public constant returns (bool) {
858         return now >= startPhase1 && now <= endOfPhase3;
859     }
860 
861     function sellTokensIco() beforeReachingHardCap whenWhitelisted(msg.sender) whenNotPaused public payable {
862         sellTokens(address(0));
863     }
864 
865     function sellTokensIcoWithReferal(address referral) beforeReachingHardCap whenWhitelisted(msg.sender) whenNotPaused public payable {
866         if (referral != msg.sender && whitelist.isWhitelisted(referral)) {
867             sellTokens(referral);
868         } else {
869             revert();
870         }
871     }
872 
873     /**
874     * @dev Manual send tokens to the specified address.
875     * @param _beneficiary The address of a investor.
876     * @param _tokensAmount Amount of tokens.
877     */
878     function manualSendTokens(address _beneficiary, uint256 _tokensAmount) public  onlyOwner {
879         require(_beneficiary != address(0));
880         require(_tokensAmount > 0);
881 
882         token.transfer(_beneficiary, _tokensAmount);
883         tokensSoldIco = tokensSoldIco.add(_tokensAmount);
884         tokensSoldTotal = tokensSoldTotal.add(_tokensAmount);
885         tokensRemainingIco = tokensRemainingIco.sub(_tokensAmount);
886     }
887 
888     /**
889     * @dev Sell tokens during ICO with referral.
890     */
891     function sellTokens(address referral) beforeReachingHardCap whenWhitelisted(msg.sender) whenNotPaused internal {
892         require(isIco());
893         require(msg.value > 0);
894 
895         uint256 weiAmount = msg.value;
896         uint256 excessiveFunds = 0;
897 
898         uint256 plannedWeiTotal = weiRaisedIco.add(weiAmount);
899 
900         if (plannedWeiTotal > maxcap) {
901             excessiveFunds = plannedWeiTotal.sub(maxcap);
902             weiAmount = maxcap.sub(weiRaisedIco);
903         }
904         bool isReferred = referral != address(0);
905         uint256 tokensForUser = _getTokenAmountForBuyer(weiAmount, isReferred);
906         uint256 tokensForReferral = _getTokenAmountForReferral(weiAmount, isReferred);
907         uint256 tokensAmount = tokensForUser.add(tokensForReferral);
908 
909         if (tokensAmount > tokensRemainingIco) {
910             uint256 weiToAccept = _getWeiValueOfTokens(tokensRemainingIco, isReferred);
911             tokensForReferral = _getTokenAmountForReferral(weiToAccept, isReferred);
912             tokensForUser = tokensRemainingIco.sub(tokensForReferral);
913             excessiveFunds = excessiveFunds.add(weiAmount.sub(weiToAccept));
914 
915             tokensAmount = tokensRemainingIco;
916             weiAmount = weiToAccept;
917         }
918 
919         tokensSoldIco = tokensSoldIco.add(tokensAmount);
920         tokensSoldTotal = tokensSoldTotal.add(tokensAmount);
921         tokensRemainingIco = tokensRemainingIco.sub(tokensAmount);
922 
923         weiRaisedIco = weiRaisedIco.add(weiAmount);
924         weiRaisedTotal = weiRaisedTotal.add(weiAmount);
925 
926         token.transfer(msg.sender, tokensForUser);
927         if (isReferred) {
928             token.transfer(referral, tokensForReferral);
929         }
930 
931         if (excessiveFunds > 0) {
932             msg.sender.transfer(excessiveFunds);
933         }
934 
935         withdrawalWallet.transfer(this.balance);
936     }
937 }