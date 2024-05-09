1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title -luckyblock
5  * play a luckyblock : )
6  * Contact us for further cooperation support@lordless.io
7  *
8  * ██╗      ██╗   ██╗  ██████╗ ██╗  ██╗ ██╗   ██╗ ██████╗  ██╗       ██████╗   ██████╗ ██╗  ██╗
9  * ██║      ██║   ██║ ██╔════╝ ██║ ██╔╝ ╚██╗ ██╔╝ ██╔══██╗ ██║      ██╔═══██╗ ██╔════╝ ██║ ██╔╝
10  * ██║      ██║   ██║ ██║      █████╔╝   ╚████╔╝  ██████╔╝ ██║      ██║   ██║ ██║      █████╔╝
11  * ██║      ██║   ██║ ██║      ██╔═██╗    ╚██╔╝   ██╔══██╗ ██║      ██║   ██║ ██║      ██╔═██╗
12  * ███████╗ ╚██████╔╝ ╚██████╗ ██║  ██╗    ██║    ██████╔╝ ███████╗ ╚██████╔╝ ╚██████╗ ██║  ██╗
13  * ╚══════╝  ╚═════╝   ╚═════╝ ╚═╝  ╚═╝    ╚═╝    ╚═════╝  ╚══════╝  ╚═════╝   ╚═════╝ ╚═╝  ╚═╝
14  *
15  * ---
16  * POWERED BY
17  * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
18  * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
19  * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
20  * game at https://game.lordless.io
21  * code at https://github.com/lordlessio
22  */
23 
24 
25 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipRenounced(address indexed previousOwner);
37   event OwnershipTransferred(
38     address indexed previousOwner,
39     address indexed newOwner
40   );
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   constructor() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to relinquish control of the contract.
61    * @notice Renouncing to ownership will leave the contract without an owner.
62    * It will not be possible to call the functions with the `onlyOwner`
63    * modifier anymore.
64    */
65   function renounceOwnership() public onlyOwner {
66     emit OwnershipRenounced(owner);
67     owner = address(0);
68   }
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param _newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address _newOwner) public onlyOwner {
75     _transferOwnership(_newOwner);
76   }
77 
78   /**
79    * @dev Transfers control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82   function _transferOwnership(address _newOwner) internal {
83     require(_newOwner != address(0));
84     emit OwnershipTransferred(owner, _newOwner);
85     owner = _newOwner;
86   }
87 }
88 
89 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96   event Pause();
97   event Unpause();
98 
99   bool public paused = false;
100 
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() public onlyOwner whenNotPaused {
122     paused = true;
123     emit Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() public onlyOwner whenPaused {
130     paused = false;
131     emit Unpause();
132   }
133 }
134 
135 // File: node_modules/zeppelin-solidity/contracts/access/rbac/Roles.sol
136 
137 /**
138  * @title Roles
139  * @author Francisco Giordano (@frangio)
140  * @dev Library for managing addresses assigned to a Role.
141  * See RBAC.sol for example usage.
142  */
143 library Roles {
144   struct Role {
145     mapping (address => bool) bearer;
146   }
147 
148   /**
149    * @dev give an address access to this role
150    */
151   function add(Role storage _role, address _addr)
152     internal
153   {
154     _role.bearer[_addr] = true;
155   }
156 
157   /**
158    * @dev remove an address' access to this role
159    */
160   function remove(Role storage _role, address _addr)
161     internal
162   {
163     _role.bearer[_addr] = false;
164   }
165 
166   /**
167    * @dev check if an address has this role
168    * // reverts
169    */
170   function check(Role storage _role, address _addr)
171     internal
172     view
173   {
174     require(has(_role, _addr));
175   }
176 
177   /**
178    * @dev check if an address has this role
179    * @return bool
180    */
181   function has(Role storage _role, address _addr)
182     internal
183     view
184     returns (bool)
185   {
186     return _role.bearer[_addr];
187   }
188 }
189 
190 // File: node_modules/zeppelin-solidity/contracts/access/rbac/RBAC.sol
191 
192 /**
193  * @title RBAC (Role-Based Access Control)
194  * @author Matt Condon (@Shrugs)
195  * @dev Stores and provides setters and getters for roles and addresses.
196  * Supports unlimited numbers of roles and addresses.
197  * See //contracts/mocks/RBACMock.sol for an example of usage.
198  * This RBAC method uses strings to key roles. It may be beneficial
199  * for you to write your own implementation of this interface using Enums or similar.
200  */
201 contract RBAC {
202   using Roles for Roles.Role;
203 
204   mapping (string => Roles.Role) private roles;
205 
206   event RoleAdded(address indexed operator, string role);
207   event RoleRemoved(address indexed operator, string role);
208 
209   /**
210    * @dev reverts if addr does not have role
211    * @param _operator address
212    * @param _role the name of the role
213    * // reverts
214    */
215   function checkRole(address _operator, string _role)
216     public
217     view
218   {
219     roles[_role].check(_operator);
220   }
221 
222   /**
223    * @dev determine if addr has role
224    * @param _operator address
225    * @param _role the name of the role
226    * @return bool
227    */
228   function hasRole(address _operator, string _role)
229     public
230     view
231     returns (bool)
232   {
233     return roles[_role].has(_operator);
234   }
235 
236   /**
237    * @dev add a role to an address
238    * @param _operator address
239    * @param _role the name of the role
240    */
241   function addRole(address _operator, string _role)
242     internal
243   {
244     roles[_role].add(_operator);
245     emit RoleAdded(_operator, _role);
246   }
247 
248   /**
249    * @dev remove a role from an address
250    * @param _operator address
251    * @param _role the name of the role
252    */
253   function removeRole(address _operator, string _role)
254     internal
255   {
256     roles[_role].remove(_operator);
257     emit RoleRemoved(_operator, _role);
258   }
259 
260   /**
261    * @dev modifier to scope access to a single role (uses msg.sender as addr)
262    * @param _role the name of the role
263    * // reverts
264    */
265   modifier onlyRole(string _role)
266   {
267     checkRole(msg.sender, _role);
268     _;
269   }
270 
271   /**
272    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
273    * @param _roles the names of the roles to scope access to
274    * // reverts
275    *
276    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
277    *  see: https://github.com/ethereum/solidity/issues/2467
278    */
279   // modifier onlyRoles(string[] _roles) {
280   //     bool hasAnyRole = false;
281   //     for (uint8 i = 0; i < _roles.length; i++) {
282   //         if (hasRole(msg.sender, _roles[i])) {
283   //             hasAnyRole = true;
284   //             break;
285   //         }
286   //     }
287 
288   //     require(hasAnyRole);
289 
290   //     _;
291   // }
292 }
293 
294 // File: node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol
295 
296 /**
297  * @title Superuser
298  * @dev The Superuser contract defines a single superuser who can transfer the ownership
299  * of a contract to a new address, even if he is not the owner.
300  * A superuser can transfer his role to a new address.
301  */
302 contract Superuser is Ownable, RBAC {
303   string public constant ROLE_SUPERUSER = "superuser";
304 
305   constructor () public {
306     addRole(msg.sender, ROLE_SUPERUSER);
307   }
308 
309   /**
310    * @dev Throws if called by any account that's not a superuser.
311    */
312   modifier onlySuperuser() {
313     checkRole(msg.sender, ROLE_SUPERUSER);
314     _;
315   }
316 
317   modifier onlyOwnerOrSuperuser() {
318     require(msg.sender == owner || isSuperuser(msg.sender));
319     _;
320   }
321 
322   /**
323    * @dev getter to determine if address has superuser role
324    */
325   function isSuperuser(address _addr)
326     public
327     view
328     returns (bool)
329   {
330     return hasRole(_addr, ROLE_SUPERUSER);
331   }
332 
333   /**
334    * @dev Allows the current superuser to transfer his role to a newSuperuser.
335    * @param _newSuperuser The address to transfer ownership to.
336    */
337   function transferSuperuser(address _newSuperuser) public onlySuperuser {
338     require(_newSuperuser != address(0));
339     removeRole(msg.sender, ROLE_SUPERUSER);
340     addRole(_newSuperuser, ROLE_SUPERUSER);
341   }
342 
343   /**
344    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
345    * @param _newOwner The address to transfer ownership to.
346    */
347   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
348     _transferOwnership(_newOwner);
349   }
350 }
351 
352 // File: contracts/lib/SafeMath.sol
353 
354 /**
355  * @title SafeMath
356  */
357 library SafeMath {
358   /**
359   * @dev Integer division of two numbers, truncating the quotient.
360   */
361   function div(uint256 a, uint256 b) internal pure returns (uint256) {
362     // assert(b > 0); // Solidity automatically throws when dividing by 0
363     // uint256 c = a / b;
364     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
365     return a / b;
366   }
367 
368   /**
369   * @dev Multiplies two numbers, throws on overflow.
370   */
371   function mul(uint256 a, uint256 b) 
372       internal 
373       pure 
374       returns (uint256 c) 
375   {
376     if (a == 0) {
377       return 0;
378     }
379     c = a * b;
380     require(c / a == b, "SafeMath mul failed");
381     return c;
382   }
383 
384   /**
385   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
386   */
387   function sub(uint256 a, uint256 b)
388       internal
389       pure
390       returns (uint256) 
391   {
392     require(b <= a, "SafeMath sub failed");
393     return a - b;
394   }
395 
396   /**
397   * @dev Adds two numbers, throws on overflow.
398   */
399   function add(uint256 a, uint256 b)
400       internal
401       pure
402       returns (uint256 c) 
403   {
404     c = a + b;
405     require(c >= a, "SafeMath add failed");
406     return c;
407   }
408   
409   /**
410     * @dev gives square root of given x.
411     */
412   function sqrt(uint256 x)
413       internal
414       pure
415       returns (uint256 y) 
416   {
417     uint256 z = ((add(x,1)) / 2);
418     y = x;
419     while (z < y) 
420     {
421       y = z;
422       z = ((add((x / z),z)) / 2);
423     }
424   }
425   
426   /**
427     * @dev gives square. batchplies x by x
428     */
429   function sq(uint256 x)
430       internal
431       pure
432       returns (uint256)
433   {
434     return (mul(x,x));
435   }
436   
437   /**
438     * @dev x to the power of y 
439     */
440   function pwr(uint256 x, uint256 y)
441       internal 
442       pure 
443       returns (uint256)
444   {
445     if (x==0)
446         return (0);
447     else if (y==0)
448         return (1);
449     else 
450     {
451       uint256 z = x;
452       for (uint256 i=1; i < y; i++)
453         z = mul(z,x);
454       return (z);
455     }
456   }
457 }
458 
459 // File: contracts/luckyblock/ILuckyblock.sol
460 
461 /**
462  * @title -luckyblock Interface
463  */
464 
465 interface ILuckyblock{
466 
467   function getLuckyblockSpend(
468     bytes32 luckyblockId
469   ) external view returns (
470     address[],
471     uint256[],
472     uint256
473   ); 
474 
475   function getLuckyblockEarn(
476     bytes32 luckyblockId
477     ) external view returns (
478     address[],
479     uint256[],
480     int[],
481     uint256,
482     int
483   );
484 
485   function getLuckyblockBase(
486     bytes32 luckyblockId
487     ) external view returns (
488       bool
489   );
490 
491   function addLuckyblock(uint256 seed) external;
492 
493   function start(
494     bytes32 luckyblockId
495   ) external;
496 
497   function stop(
498     bytes32 luckyblockId
499   ) external;
500 
501   function updateLuckyblockSpend(
502     bytes32 luckyblockId,
503     address[] spendTokenAddresses, 
504     uint256[] spendTokenCount,
505     uint256 spendEtherCount
506   ) external;
507 
508   function updateLuckyblockEarn (
509     bytes32 luckyblockId,
510     address[] earnTokenAddresses,
511     uint256[] earnTokenCount,
512     int[] earnTokenProbability, // (0 - 100)
513     uint256 earnEtherCount,
514     int earnEtherProbability
515   ) external;
516 
517   function getLuckyblockIds()external view returns(bytes32[]);
518   function play(bytes32 luckyblockId) external payable;
519   function withdrawToken(address contractAddress, address to, uint256 balance) external;
520   function withdrawEth(address to, uint256 balance) external;
521 
522   
523   
524 
525   /* Events */
526 
527   event Play (
528     bytes32 indexed luckyblockId,
529     address user,
530     uint8 random
531   );
532 
533   event WithdrawToken (
534     address indexed contractAddress,
535     address to,
536     uint256 count
537   );
538 
539   event WithdrawEth (
540     address to,
541     uint256 count
542   );
543 
544   event Pay (
545     address from,
546     uint256 value
547   );
548 }
549 
550 // File: contracts/luckyblock/Luckyblock.sol
551 
552 
553 
554 
555 contract ERC20Interface {
556   function transfer(address to, uint tokens) public returns (bool);
557   function transferFrom(address from, address to, uint tokens) public returns (bool);
558   function balanceOf(address tokenOwner) public view returns (uint256);
559   function allowance(address tokenOwner, address spender) public view returns (uint);
560 }
561 contract Luckyblock is Superuser, Pausable, ILuckyblock {
562 
563   using SafeMath for *;
564 
565   struct User {
566     address user;
567     string name;
568     uint256 verifytime;
569     uint256 verifyFee;
570   }
571 
572   struct LuckyblockBase {
573     bool ended;
574   }
575 
576   struct LuckyblockSpend {
577     address[] spendTokenAddresses;
578     uint256[] spendTokenCount;
579     uint256 spendEtherCount;
580   }
581 
582   struct LuckyblockEarn {
583     address[] earnTokenAddresses;
584     uint256[] earnTokenCount;
585     int[] earnTokenProbability; // (0 - 100)
586     uint256 earnEtherCount;
587     int earnEtherProbability;
588   }
589 
590   bytes32[] public luckyblockIds; //
591 
592   mapping (address => bytes32[]) contractAddressToLuckyblockId;
593 
594   mapping (bytes32 => LuckyblockEarn) luckyblockIdToLuckyblockEarn;
595   mapping (bytes32 => LuckyblockSpend) luckyblockIdToLuckyblockSpend;
596   mapping (bytes32 => LuckyblockBase) luckyblockIdToLuckyblockBase;
597 
598 
599   mapping (bytes32 => mapping (address => bool)) luckyblockIdToUserAddress;
600   mapping (address => uint256) contractAddressToLuckyblockCount;
601 
602   function () public payable {
603     emit Pay(msg.sender, msg.value);
604   }
605 
606   function getLuckyblockIds()external view returns(bytes32[]){
607     return luckyblockIds;
608   }
609 
610   function getLuckyblockSpend(
611     bytes32 luckyblockId
612     ) external view returns (
613       address[],
614       uint256[],
615       uint256
616     ) {
617     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
618     return (
619       _luckyblockSpend.spendTokenAddresses,
620       _luckyblockSpend.spendTokenCount,
621       _luckyblockSpend.spendEtherCount
622       );
623   }
624 
625   function getLuckyblockEarn(
626     bytes32 luckyblockId
627     ) external view returns (
628       address[],
629       uint256[],
630       int[],
631       uint256,
632       int
633     ) {
634     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
635     return (
636       _luckyblockEarn.earnTokenAddresses,
637       _luckyblockEarn.earnTokenCount,
638       _luckyblockEarn.earnTokenProbability,
639       _luckyblockEarn.earnEtherCount,
640       _luckyblockEarn.earnEtherProbability
641       );
642   }
643 
644   function getLuckyblockBase(
645     bytes32 luckyblockId
646     ) external view returns (
647       bool
648     ) {
649     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
650     return (
651       _luckyblockBase.ended
652       );
653   }
654   
655   function addLuckyblock(uint256 seed) external onlyOwnerOrSuperuser {
656     bytes32 luckyblockId = keccak256(
657       abi.encodePacked(block.timestamp, seed)
658     );
659     LuckyblockBase memory _luckyblockBase = LuckyblockBase(
660       false
661     );
662     luckyblockIds.push(luckyblockId);
663     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
664   }
665 
666   function start(bytes32 luckyblockId) external{
667     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
668     _luckyblockBase.ended = false;
669     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
670   }
671 
672   function stop(bytes32 luckyblockId) external{
673     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
674     _luckyblockBase.ended = true;
675     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
676   }
677 
678   function updateLuckyblockSpend (
679     bytes32 luckyblockId,
680     address[] spendTokenAddresses, 
681     uint256[] spendTokenCount,
682     uint256 spendEtherCount
683     ) external onlyOwnerOrSuperuser {
684     LuckyblockSpend memory _luckyblockSpend = LuckyblockSpend(
685       spendTokenAddresses,
686       spendTokenCount,
687       spendEtherCount
688     );
689     luckyblockIdToLuckyblockSpend[luckyblockId] = _luckyblockSpend;
690   }
691 
692   function updateLuckyblockEarn (
693     bytes32 luckyblockId,
694     address[] earnTokenAddresses,
695     uint256[] earnTokenCount,
696     int[] earnTokenProbability, // (0 - 100)
697     uint256 earnEtherCount,
698     int earnEtherProbability
699     ) external onlyOwnerOrSuperuser {
700     LuckyblockEarn memory _luckyblockEarn = LuckyblockEarn(
701       earnTokenAddresses,
702       earnTokenCount,
703       earnTokenProbability, // (0 - 100)
704       earnEtherCount,
705       earnEtherProbability
706     );
707     luckyblockIdToLuckyblockEarn[luckyblockId] = _luckyblockEarn;
708   }
709 
710 
711   function play(bytes32 luckyblockId) external payable whenNotPaused {
712     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
713     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
714     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
715     
716     require(!_luckyblockBase.ended, "luckyblock is ended");
717 
718     // check sender's ether balance 
719     require(msg.value >= _luckyblockSpend.spendEtherCount, "sender value not enough");
720 
721     // check spend
722     if (_luckyblockSpend.spendTokenAddresses[0] != address(0x0)) {
723       for (uint8 i = 0; i < _luckyblockSpend.spendTokenAddresses.length; i++) {
724 
725         // check sender's erc20 balance 
726         require(
727           ERC20Interface(
728             _luckyblockSpend.spendTokenAddresses[i]
729           ).balanceOf(address(msg.sender)) >= _luckyblockSpend.spendTokenCount[i]
730         );
731 
732         require(
733           ERC20Interface(
734             _luckyblockSpend.spendTokenAddresses[i]
735           ).allowance(address(msg.sender), address(this)) >= _luckyblockSpend.spendTokenCount[i]
736         );
737 
738         // transfer erc20 token
739         ERC20Interface(_luckyblockSpend.spendTokenAddresses[i])
740           .transferFrom(msg.sender, address(this), _luckyblockSpend.spendTokenCount[i]);
741         }
742     }
743     
744     // check earn erc20
745     if (_luckyblockEarn.earnTokenAddresses[0] !=
746       address(0x0)) {
747       for (uint8 j= 0; j < _luckyblockEarn.earnTokenAddresses.length; j++) {
748         // check sender's erc20 balance 
749         uint256 earnTokenCount = _luckyblockEarn.earnTokenCount[j];
750         require(
751           ERC20Interface(_luckyblockEarn.earnTokenAddresses[j])
752           .balanceOf(address(this)) >= earnTokenCount
753         );
754       }
755     }
756     
757     // check earn ether
758     require(address(this).balance >= _luckyblockEarn.earnEtherCount, "contract value not enough");
759 
760     // do a random
761     uint8 _random = random();
762 
763     // earn erc20
764     for (uint8 k = 0; k < _luckyblockEarn.earnTokenAddresses.length; k++){
765       // if win erc20
766       if (_luckyblockEarn.earnTokenAddresses[0] 
767         != address(0x0)){
768         if (_random + _luckyblockEarn.earnTokenProbability[k] >= 100) {
769           ERC20Interface(_luckyblockEarn.earnTokenAddresses[k])
770             .transfer(msg.sender, _luckyblockEarn.earnTokenCount[k]);
771         }
772       }
773     }
774     uint256 value = msg.value;
775     uint256 payExcess = value.sub(_luckyblockSpend.spendEtherCount);
776     
777     // if win ether
778     if (_random + _luckyblockEarn.earnEtherProbability >= 100) {
779       uint256 balance = _luckyblockEarn.earnEtherCount.add(payExcess);
780       if (balance > 0){
781         msg.sender.transfer(balance);
782       }
783     } else if (payExcess > 0) {
784       msg.sender.transfer(payExcess);
785     }
786     
787     emit Play(luckyblockId, msg.sender, _random);
788   }
789 
790   function withdrawToken(address contractAddress, address to, uint256 balance)
791     external onlyOwnerOrSuperuser {
792     ERC20Interface erc20 = ERC20Interface(contractAddress);
793     if (balance == uint256(0x0)){
794       erc20.transfer(to, erc20.balanceOf(address(this)));
795       emit WithdrawToken(contractAddress, to, erc20.balanceOf(address(this)));
796     } else {
797       erc20.transfer(to, balance);
798       emit WithdrawToken(contractAddress, to, balance);
799     }
800   }
801 
802   function withdrawEth(address to, uint256 balance) external onlySuperuser {
803     if (balance == uint256(0x0)) {
804       to.transfer(address(this).balance);
805       emit WithdrawEth(to, address(this).balance);
806     } else {
807       to.transfer(balance);
808       emit WithdrawEth(to, balance);
809     }
810   }
811 
812   function random() private view returns (uint8) {
813     return uint8(uint256(keccak256(block.timestamp, block.difficulty))%100); // random 0-99
814   }
815 
816 }