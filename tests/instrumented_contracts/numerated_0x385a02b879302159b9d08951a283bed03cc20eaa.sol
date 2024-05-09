1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Roles
52  * @author Francisco Giordano (@frangio)
53  * @dev Library for managing addresses assigned to a Role.
54  *      See RBAC.sol for example usage.
55  */
56 library Roles {
57     struct Role {
58         mapping (address => bool) bearer;
59     }
60 
61     /**
62      * @dev give an address access to this role
63      */
64     function add(Role storage role, address addr)
65     internal
66     {
67         role.bearer[addr] = true;
68     }
69 
70     /**
71      * @dev remove an address' access to this role
72      */
73     function remove(Role storage role, address addr)
74     internal
75     {
76         role.bearer[addr] = false;
77     }
78 
79     /**
80      * @dev check if an address has this role
81      * // reverts
82      */
83     function check(Role storage role, address addr)
84     view
85     internal
86     {
87         require(has(role, addr));
88     }
89 
90     /**
91      * @dev check if an address has this role
92      * @return bool
93      */
94     function has(Role storage role, address addr)
95     view
96     internal
97     returns (bool)
98     {
99         return role.bearer[addr];
100     }
101 }
102 
103 
104 
105 /**
106  * @title RBAC (Role-Based Access Control)
107  * @author Matt Condon (@Shrugs)
108  * @dev Stores and provides setters and getters for roles and addresses.
109  * @dev Supports unlimited numbers of roles and addresses.
110  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
111  * This RBAC method uses strings to key roles. It may be beneficial
112  *  for you to write your own implementation of this interface using Enums or similar.
113  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
114  *  to avoid typos.
115  */
116 contract RBAC {
117     using Roles for Roles.Role;
118 
119     mapping (string => Roles.Role) private roles;
120 
121     event RoleAdded(address addr, string roleName);
122     event RoleRemoved(address addr, string roleName);
123 
124     /**
125      * @dev reverts if addr does not have role
126      * @param addr address
127      * @param roleName the name of the role
128      * // reverts
129      */
130     function checkRole(address addr, string roleName)
131     view
132     public
133     {
134         roles[roleName].check(addr);
135     }
136 
137     /**
138      * @dev determine if addr has role
139      * @param addr address
140      * @param roleName the name of the role
141      * @return bool
142      */
143     function hasRole(address addr, string roleName)
144     view
145     public
146     returns (bool)
147     {
148         return roles[roleName].has(addr);
149     }
150 
151     /**
152      * @dev add a role to an address
153      * @param addr address
154      * @param roleName the name of the role
155      */
156     function addRole(address addr, string roleName)
157     internal
158     {
159         roles[roleName].add(addr);
160         emit RoleAdded(addr, roleName);
161     }
162 
163     /**
164      * @dev remove a role from an address
165      * @param addr address
166      * @param roleName the name of the role
167      */
168     function removeRole(address addr, string roleName)
169     internal
170     {
171         roles[roleName].remove(addr);
172         emit RoleRemoved(addr, roleName);
173     }
174 
175     /**
176      * @dev modifier to scope access to a single role (uses msg.sender as addr)
177      * @param roleName the name of the role
178      * // reverts
179      */
180     modifier onlyRole(string roleName)
181     {
182         checkRole(msg.sender, roleName);
183         _;
184     }
185 
186     /**
187      * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
188      * @param roleNames the names of the roles to scope access to
189      * // reverts
190      *
191      * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
192      *  see: https://github.com/ethereum/solidity/issues/2467
193      */
194     // modifier onlyRoles(string[] roleNames) {
195     //     bool hasAnyRole = false;
196     //     for (uint8 i = 0; i < roleNames.length; i++) {
197     //         if (hasRole(msg.sender, roleNames[i])) {
198     //             hasAnyRole = true;
199     //             break;
200     //         }
201     //     }
202 
203     //     require(hasAnyRole);
204 
205     //     _;
206     // }
207 }
208 
209 
210 /**
211  * @title RBACWithAdmin
212  * @author Matt Condon (@Shrugs)
213  * @dev It's recommended that you define constants in the contract,
214  * @dev like ROLE_ADMIN below, to avoid typos.
215  */
216 contract RBACWithAdmin is RBAC {
217     /**
218      * A constant role name for indicating admins.
219      */
220     string public constant ROLE_ADMIN = "admin";
221 
222     /**
223      * @dev modifier to scope access to admins
224      * // reverts
225      */
226     modifier onlyAdmin()
227     {
228         checkRole(msg.sender, ROLE_ADMIN);
229         _;
230     }
231 
232     /**
233      * @dev constructor. Sets msg.sender as admin by default
234      */
235     function RBACWithAdmin()
236     public
237     {
238         addRole(msg.sender, ROLE_ADMIN);
239     }
240 
241     /**
242      * @dev add a role to an address
243      * @param addr address
244      * @param roleName the name of the role
245      */
246     function adminAddRole(address addr, string roleName)
247     onlyAdmin
248     public
249     {
250         addRole(addr, roleName);
251     }
252 
253     /**
254      * @dev remove a role from an address
255      * @param addr address
256      * @param roleName the name of the role
257      */
258     function adminRemoveRole(address addr, string roleName)
259     onlyAdmin
260     public
261     {
262         removeRole(addr, roleName);
263     }
264 }
265 
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273     address public owner;
274 
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278 
279     /**
280      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281      * account.
282      */
283     function Ownable() public {
284         owner = msg.sender;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(msg.sender == owner);
292         _;
293     }
294 
295     /**
296      * @dev Allows the current owner to transfer control of the contract to a newOwner.
297      * @param newOwner The address to transfer ownership to.
298      */
299     function transferOwnership(address newOwner) public onlyOwner {
300         require(newOwner != address(0));
301         emit OwnershipTransferred(owner, newOwner);
302         owner = newOwner;
303     }
304 
305 }
306 
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Ownable {
313     event Pause();
314     event Unpause();
315 
316     bool public paused = false;
317 
318 
319     /**
320      * @dev Modifier to make a function callable only when the contract is not paused.
321      */
322     modifier whenNotPaused() {
323         require(!paused);
324         _;
325     }
326 
327     /**
328      * @dev Modifier to make a function callable only when the contract is paused.
329      */
330     modifier whenPaused() {
331         require(paused);
332         _;
333     }
334 
335     /**
336      * @dev called by the owner to pause, triggers stopped state
337      */
338     function pause() onlyOwner whenNotPaused public {
339         paused = true;
340         emit Pause();
341     }
342 
343     /**
344      * @dev called by the owner to unpause, returns to normal state
345      */
346     function unpause() onlyOwner whenPaused public {
347         paused = false;
348         emit Unpause();
349     }
350 }
351 
352 
353 /**
354  * @title ERC20Basic
355  * @dev Simpler version of ERC20 interface
356  * @dev see https://github.com/ethereum/EIPs/issues/179
357  */
358 contract ERC20Basic {
359     function totalSupply() public view returns (uint256);
360     function balanceOf(address who) public view returns (uint256);
361     function transfer(address to, uint256 value) public returns (bool);
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 }
364 
365 /**
366  * @title ERC20 interface
367  * @dev see https://github.com/ethereum/EIPs/issues/20
368  */
369 contract ERC20 is ERC20Basic {
370     function allowance(address owner, address spender) public view returns (uint256);
371     function transferFrom(address from, address to, uint256 value) public returns (bool);
372     function approve(address spender, uint256 value) public returns (bool);
373     event Approval(address indexed owner, address indexed spender, uint256 value);
374 }
375 
376 /**
377  * @title Crowdsale
378  * @dev Crowdsale is a base contract for managing a token crowdsale,
379  * allowing investors to purchase tokens with ether. This contract implements
380  * such functionality in its most fundamental form and can be extended to provide additional
381  * functionality and/or custom behavior.
382  * The external interface represents the basic interface for purchasing tokens, and conform
383  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
384  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
385  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
386  * behavior.
387  */
388 contract Crowdsale {
389     using SafeMath for uint256;
390 
391     // The token being sold
392     ERC20 public token;
393 
394     // Address where funds are collected
395     address public wallet;
396 
397     // How many token units a buyer gets per wei
398     uint256 public rate;
399 
400     // Amount of wei raised
401     uint256 public weiRaised;
402 
403     /**
404      * Event for token purchase logging
405      * @param purchaser who paid for the tokens
406      * @param beneficiary who got the tokens
407      * @param value weis paid for purchase
408      * @param amount amount of tokens purchased
409      */
410     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
411 
412     /**
413      * @param _rate Number of token units a buyer gets per wei
414      * @param _wallet Address where collected funds will be forwarded to
415      * @param _token Address of the token being sold
416      */
417     function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
418         require(_rate > 0);
419         require(_wallet != address(0));
420         require(_token != address(0));
421 
422         rate = _rate;
423         wallet = _wallet;
424         token = _token;
425     }
426 
427     // -----------------------------------------
428     // Crowdsale external interface
429     // -----------------------------------------
430 
431     /**
432      * @dev fallback function ***DO NOT OVERRIDE***
433      */
434     function () external payable {
435         buyTokens(msg.sender);
436     }
437 
438     /**
439      * @dev low level token purchase ***DO NOT OVERRIDE***
440      * @param _beneficiary Address performing the token purchase
441      */
442     function buyTokens(address _beneficiary) public payable {
443 
444         uint256 weiAmount = msg.value;
445         _preValidatePurchase(_beneficiary, weiAmount);
446 
447         // calculate token amount to be created
448         uint256 tokens = _getTokenAmount(weiAmount);
449 
450         // update state
451         weiRaised = weiRaised.add(weiAmount);
452 
453         _processPurchase(_beneficiary, tokens);
454         emit TokenPurchase(
455         msg.sender,
456         _beneficiary,
457         weiAmount,
458         tokens
459         );
460 
461         _updatePurchasingState(_beneficiary, weiAmount);
462 
463         _forwardFunds();
464         _postValidatePurchase(_beneficiary, weiAmount);
465     }
466 
467     // -----------------------------------------
468     // Internal interface (extensible)
469     // -----------------------------------------
470 
471     /**
472      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
473      * @param _beneficiary Address performing the token purchase
474      * @param _weiAmount Value in wei involved in the purchase
475      */
476     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
477         require(_beneficiary != address(0));
478         require(_weiAmount != 0);
479     }
480 
481     /**
482      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
483      * @param _beneficiary Address performing the token purchase
484      * @param _weiAmount Value in wei involved in the purchase
485      */
486     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
487         // optional override
488     }
489 
490     /**
491      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
492      * @param _beneficiary Address performing the token purchase
493      * @param _tokenAmount Number of tokens to be emitted
494      */
495     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
496         token.transfer(_beneficiary, _tokenAmount);
497     }
498 
499     /**
500      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
501      * @param _beneficiary Address receiving the tokens
502      * @param _tokenAmount Number of tokens to be purchased
503      */
504     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
505         _deliverTokens(_beneficiary, _tokenAmount);
506     }
507 
508     /**
509      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
510      * @param _beneficiary Address receiving the tokens
511      * @param _weiAmount Value in wei involved in the purchase
512      */
513     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
514         // optional override
515     }
516 
517     /**
518      * @dev Override to extend the way in which ether is converted to tokens.
519      * @param _weiAmount Value in wei to be converted into tokens
520      * @return Number of tokens that can be purchased with the specified _weiAmount
521      */
522     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
523         return _weiAmount.mul(rate);
524     }
525 
526     /**
527      * @dev Determines how ETH is stored/forwarded on purchases.
528      */
529     function _forwardFunds() internal {
530         wallet.transfer(msg.value);
531     }
532 }
533 
534 
535 
536 // NbtToken crowdsale-valuable interface
537 contract NbtToken  {
538     uint256 public saleableTokens;
539     uint256 public MAX_SALE_VOLUME;
540     function balanceOf(address who) public view returns (uint256);
541     function transfer(address to, uint256 value) public returns (bool);
542     function moveTokensFromSaleToCirculating(address _to, uint256 _amount) public returns (bool);
543 }
544 
545 /// @title Nbt Token Crowdsale Contract
546 // Main crowdsale contract
547 contract NbtCrowdsale is Crowdsale, Pausable, RBACWithAdmin {
548 
549     /*** EVENTS ***/
550 
551     event NewStart(uint256 start);
552     event NewDeadline(uint256 deadline);
553     event NewRate(uint256 rate);
554     event NewWallet(address new_address);
555     event Sale(address indexed buyer, uint256 tokens_with_bonuses);
556 
557     /*** CONSTANTS ***/
558 
559     uint256 public DECIMALS = 8;
560     uint256 public BONUS1 = 100; // %
561     uint256 public BONUS1_LIMIT = 150000000 * 10**DECIMALS;
562     uint256 public BONUS2 = 60; // %
563     uint256 public BONUS2_LIMIT = 250000000 * 10**DECIMALS;
564     uint256 public MIN_TOKENS = 1000 * 10**DECIMALS;
565 
566     NbtToken public token;
567 
568     /*** STORAGE ***/
569 
570     uint256 public start;
571     uint256 public deadline;
572     bool crowdsaleClosed = false;
573 
574     /*** MODIFIERS ***/
575 
576     modifier afterDeadline() { if (now > deadline) _; }
577     modifier beforeDeadline() { if (now <= deadline) _; }
578     modifier afterStart() { if (now >= start) _; }
579     modifier beforeStart() { if (now < start) _; }
580 
581     /*** CONSTRUCTOR ***/
582 
583     /**
584       * @param _rate Number of token units a buyer gets per wei
585       * @param _wallet Address where collected funds will be forwarded to
586       * @param _token Address of the token being sold
587       * @param _start Start date of the crowdsale
588       * @param _deadline Deadline of the crowdsale
589       */
590     function NbtCrowdsale(uint256 _rate, address _wallet, NbtToken _token, uint256 _start, uint256 _deadline) Crowdsale(_rate, _wallet, ERC20(_token)) public {
591         require(_rate > 0);
592         require(_wallet != address(0));
593         require(_token != address(0));
594         require(_start < _deadline);
595 
596         start = _start;
597         deadline = _deadline;
598 
599         rate = _rate;
600         wallet = _wallet;
601         token = _token;
602     }
603 
604     /*** PUBLIC AND EXTERNAL FUNCTIONS ***/
605 
606     /**
607      * @dev set new start date for crowdsale.
608      * @param _start The new start timestamp
609      */
610     function setStart(uint256 _start) onlyAdmin whenPaused public returns (bool) {
611         require(_start < deadline);
612         start = _start;
613         emit NewStart(start);
614         return true;
615     }
616 
617     /**
618      * @dev set new start date for crowdsale.
619      * @param _deadline The new deadline timestamp
620      */
621     function setDeadline(uint256 _deadline) onlyAdmin whenPaused public returns (bool) {
622         require(start < _deadline);
623         deadline = _deadline;
624         emit NewDeadline(_deadline);
625         return true;
626     }
627 
628     /**
629      * @dev set new wallet address
630      * @param _addr The new wallet address
631      */
632     function setWallet(address _addr) onlyAdmin public returns (bool) {
633         require(_addr != address(0) && _addr != address(this));
634         wallet = _addr;
635         emit NewWallet(wallet);
636         return true;
637     }
638 
639     /**
640      * @dev set new rate for crowdsale.
641      * @param _rate Number of token units a buyer gets per wei
642      */
643     function setRate(uint256 _rate) onlyAdmin public returns (bool) {
644         require(_rate > 0);
645         rate = _rate;
646         emit NewRate(rate);
647         return true;
648     }
649 
650     /**
651       * @dev called by the admin to pause, triggers stopped state
652       */
653     function pause() onlyAdmin whenNotPaused public {
654         paused = true;
655         emit Pause();
656     }
657 
658     /**
659      * @dev called by the admin to unpause, returns to normal state
660      */
661     function unpause() onlyAdmin whenPaused public {
662         paused = false;
663         emit Unpause();
664     }
665 
666     function getCurrentBonus() public view returns (uint256) {
667         if (token.MAX_SALE_VOLUME().sub(token.saleableTokens()) < BONUS1_LIMIT) {
668             return BONUS1;
669         } else if (token.MAX_SALE_VOLUME().sub(token.saleableTokens()) < BONUS2_LIMIT) {
670             return BONUS2;
671         } else {
672             return 0;
673         }
674     }
675 
676     function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
677         return _getTokenAmount(_weiAmount);
678     }
679 
680     /**
681      * Close the crowdsale
682      */
683     function closeCrowdsale() onlyAdmin afterDeadline public {
684         crowdsaleClosed = true;
685     }
686 
687     /*** INTERNAL FUNCTIONS ***/
688 
689     /**
690        * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
691        * @param _beneficiary Address performing the token purchase
692        * @param _weiAmount Value in wei involved in the purchase
693        */
694     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) whenNotPaused afterStart beforeDeadline internal {
695         require(!crowdsaleClosed);
696         require(_weiAmount >= 1000000000000);
697         require(_getTokenAmount(_weiAmount) <= token.balanceOf(this));
698         require(_getTokenAmount(_weiAmount) >= MIN_TOKENS);
699         super._preValidatePurchase(_beneficiary, _weiAmount);
700     }
701 
702     /**
703    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
704    * @param _beneficiary Address performing the token purchase
705    * @param _weiAmount Value in wei involved in the purchase
706    */
707     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
708         // optional override
709     }
710 
711     /**
712       * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
713       * @param _beneficiary Address performing the token purchase
714       * @param _tokenAmount Number of tokens to be emitted
715       */
716     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
717         token.moveTokensFromSaleToCirculating(_beneficiary, _tokenAmount);
718         token.transfer(_beneficiary, _tokenAmount);
719         emit Sale(_beneficiary, _tokenAmount);
720     }
721 
722     /**
723    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
724    * @param _beneficiary Address receiving the tokens
725    * @param _tokenAmount Number of tokens to be purchased
726    */
727     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
728         _deliverTokens(_beneficiary, _tokenAmount);
729     }
730 
731     /**
732    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
733    * @param _beneficiary Address receiving the tokens
734    * @param _weiAmount Value in wei involved in the purchase
735    */
736     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
737         // optional override
738     }
739 
740     /**
741      * @dev Override to extend the way in which ether is converted to tokens.
742      * @param _weiAmount Value in wei to be converted into tokens
743      * @return Number of tokens that can be purchased with the specified _weiAmount
744      */
745     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
746         uint256 _current_bonus =  getCurrentBonus();
747         if (_current_bonus == 0) {
748             return _weiAmount.mul(rate).div(1000000000000); // token amount for 1 szabo
749         } else {
750             return _weiAmount.mul(rate).mul(_current_bonus.add(100)).div(100).div(1000000000000); // token amount for 1 szabo
751         }
752     }
753 
754     /**
755      * @dev Determines how ETH is stored/forwarded on purchases.
756      */
757     function _forwardFunds() internal {
758         wallet.transfer(msg.value);
759     }
760 }