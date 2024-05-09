1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title -luckyblock
6  * play a luckyblock : )
7  * Contact us for further cooperation support@lordless.io
8  *
9  * ██╗      ██╗   ██╗  ██████╗ ██╗  ██╗ ██╗   ██╗ ██████╗  ██╗       ██████╗   ██████╗ ██╗  ██╗
10  * ██║      ██║   ██║ ██╔════╝ ██║ ██╔╝ ╚██╗ ██╔╝ ██╔══██╗ ██║      ██╔═══██╗ ██╔════╝ ██║ ██╔╝
11  * ██║      ██║   ██║ ██║      █████╔╝   ╚████╔╝  ██████╔╝ ██║      ██║   ██║ ██║      █████╔╝
12  * ██║      ██║   ██║ ██║      ██╔═██╗    ╚██╔╝   ██╔══██╗ ██║      ██║   ██║ ██║      ██╔═██╗
13  * ███████╗ ╚██████╔╝ ╚██████╗ ██║  ██╗    ██║    ██████╔╝ ███████╗ ╚██████╔╝ ╚██████╗ ██║  ██╗
14  * ╚══════╝  ╚═════╝   ╚═════╝ ╚═╝  ╚═╝    ╚═╝    ╚═════╝  ╚══════╝  ╚═════╝   ╚═════╝ ╚═╝  ╚═╝
15  *
16  * ---
17  * POWERED BY
18  * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
19  * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
20  * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
21  * game at https://game.lordless.io
22  * code at https://github.com/lordlessio
23  */
24 
25 
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
516   function setRandomContract(address _randomContract) external;
517   function getLuckyblockIds()external view returns(bytes32[]);
518   function play(bytes32 luckyblockId) public payable;
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
550 contract ERC20Interface {
551   function transfer(address to, uint tokens) public returns (bool);
552   function transferFrom(address from, address to, uint tokens) public returns (bool);
553   function balanceOf(address tokenOwner) public view returns (uint256);
554   function allowance(address tokenOwner, address spender) public view returns (uint);
555 }
556 
557 contract Random {
558   function getRandom() external view returns (uint8);
559 }
560 
561 contract Luckyblock is Superuser, Pausable, ILuckyblock {
562 
563   using SafeMath for *;
564 
565   address randomContract;
566 
567   struct User {
568     address user;
569     string name;
570     uint256 verifytime;
571     uint256 verifyFee;
572   }
573 
574   struct LuckyblockBase {
575     bool ended;
576   }
577 
578   struct LuckyblockSpend {
579     address[] spendTokenAddresses;
580     uint256[] spendTokenCount;
581     uint256 spendEtherCount;
582   }
583 
584   struct LuckyblockEarn {
585     address[] earnTokenAddresses;
586     uint256[] earnTokenCount;
587     int[] earnTokenProbability; // (0 - 100)
588     uint256 earnEtherCount;
589     int earnEtherProbability;
590   }
591 
592   bytes32[] public luckyblockIds; //
593 
594   mapping (address => bytes32[]) contractAddressToLuckyblockId;
595 
596   mapping (bytes32 => LuckyblockEarn) luckyblockIdToLuckyblockEarn;
597   mapping (bytes32 => LuckyblockSpend) luckyblockIdToLuckyblockSpend;
598   mapping (bytes32 => LuckyblockBase) luckyblockIdToLuckyblockBase;
599 
600 
601   mapping (bytes32 => mapping (address => bool)) luckyblockIdToUserAddress;
602   mapping (address => uint256) contractAddressToLuckyblockCount;
603 
604   function () public payable {
605     emit Pay(msg.sender, msg.value);
606   }
607 
608   function setRandomContract(address _randomContract) external onlyOwnerOrSuperuser {
609     randomContract = _randomContract;
610   }
611 
612   function getLuckyblockIds()external view returns(bytes32[]){
613     return luckyblockIds;
614   }
615 
616   function getLuckyblockSpend(
617     bytes32 luckyblockId
618     ) external view returns (
619       address[],
620       uint256[],
621       uint256
622     ) {
623     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
624     return (
625       _luckyblockSpend.spendTokenAddresses,
626       _luckyblockSpend.spendTokenCount,
627       _luckyblockSpend.spendEtherCount
628       );
629   }
630 
631   function getLuckyblockEarn(
632     bytes32 luckyblockId
633     ) external view returns (
634       address[],
635       uint256[],
636       int[],
637       uint256,
638       int
639     ) {
640     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
641     return (
642       _luckyblockEarn.earnTokenAddresses,
643       _luckyblockEarn.earnTokenCount,
644       _luckyblockEarn.earnTokenProbability,
645       _luckyblockEarn.earnEtherCount,
646       _luckyblockEarn.earnEtherProbability
647       );
648   }
649 
650   function getLuckyblockBase(
651     bytes32 luckyblockId
652     ) external view returns (
653       bool
654     ) {
655     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
656     return (
657       _luckyblockBase.ended
658       );
659   }
660   
661   function addLuckyblock(uint256 seed) external onlyOwnerOrSuperuser {
662     bytes32 luckyblockId = keccak256(
663       abi.encodePacked(block.timestamp, seed)
664     );
665     LuckyblockBase memory _luckyblockBase = LuckyblockBase(
666       false
667     );
668     luckyblockIds.push(luckyblockId);
669     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
670   }
671 
672   function start(bytes32 luckyblockId) external{
673     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
674     _luckyblockBase.ended = false;
675     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
676   }
677 
678   function stop(bytes32 luckyblockId) external{
679     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
680     _luckyblockBase.ended = true;
681     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
682   }
683 
684   function updateLuckyblockSpend (
685     bytes32 luckyblockId,
686     address[] spendTokenAddresses, 
687     uint256[] spendTokenCount,
688     uint256 spendEtherCount
689     ) external onlyOwnerOrSuperuser {
690     LuckyblockSpend memory _luckyblockSpend = LuckyblockSpend(
691       spendTokenAddresses,
692       spendTokenCount,
693       spendEtherCount
694     );
695     luckyblockIdToLuckyblockSpend[luckyblockId] = _luckyblockSpend;
696   }
697 
698   function updateLuckyblockEarn (
699     bytes32 luckyblockId,
700     address[] earnTokenAddresses,
701     uint256[] earnTokenCount,
702     int[] earnTokenProbability, // (0 - 100)
703     uint256 earnEtherCount,
704     int earnEtherProbability
705     ) external onlyOwnerOrSuperuser {
706     LuckyblockEarn memory _luckyblockEarn = LuckyblockEarn(
707       earnTokenAddresses,
708       earnTokenCount,
709       earnTokenProbability, // (0 - 100)
710       earnEtherCount,
711       earnEtherProbability
712     );
713     luckyblockIdToLuckyblockEarn[luckyblockId] = _luckyblockEarn;
714   }
715 
716 
717   function play(bytes32 luckyblockId) public payable whenNotPaused {
718     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
719     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
720     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
721     
722     require(!_luckyblockBase.ended, "luckyblock is ended");
723 
724     // check sender's ether balance 
725     require(msg.value >= _luckyblockSpend.spendEtherCount, "sender value not enough");
726 
727     // check spend
728     if (_luckyblockSpend.spendTokenAddresses[0] != address(0x0)) {
729       for (uint8 i = 0; i < _luckyblockSpend.spendTokenAddresses.length; i++) {
730 
731         // check sender's erc20 balance 
732         require(
733           ERC20Interface(
734             _luckyblockSpend.spendTokenAddresses[i]
735           ).balanceOf(address(msg.sender)) >= _luckyblockSpend.spendTokenCount[i]
736         );
737 
738         require(
739           ERC20Interface(
740             _luckyblockSpend.spendTokenAddresses[i]
741           ).allowance(address(msg.sender), address(this)) >= _luckyblockSpend.spendTokenCount[i]
742         );
743 
744         // transfer erc20 token
745         ERC20Interface(_luckyblockSpend.spendTokenAddresses[i])
746           .transferFrom(msg.sender, address(this), _luckyblockSpend.spendTokenCount[i]);
747         }
748     }
749     
750     // check earn erc20
751     if (_luckyblockEarn.earnTokenAddresses[0] !=
752       address(0x0)) {
753       for (uint8 j= 0; j < _luckyblockEarn.earnTokenAddresses.length; j++) {
754         // check sender's erc20 balance 
755         uint256 earnTokenCount = _luckyblockEarn.earnTokenCount[j];
756         require(
757           ERC20Interface(_luckyblockEarn.earnTokenAddresses[j])
758           .balanceOf(address(this)) >= earnTokenCount
759         );
760       }
761     }
762     
763     // check earn ether
764     require(address(this).balance >= _luckyblockEarn.earnEtherCount, "contract value not enough");
765 
766     // do a random
767     uint8 _random = random();
768 
769     // earn erc20
770     for (uint8 k = 0; k < _luckyblockEarn.earnTokenAddresses.length; k++){
771       // if win erc20
772       if (_luckyblockEarn.earnTokenAddresses[0]
773         != address(0x0)){
774         if (_random + _luckyblockEarn.earnTokenProbability[k] >= 100) {
775           ERC20Interface(_luckyblockEarn.earnTokenAddresses[k])
776             .transfer(msg.sender, _luckyblockEarn.earnTokenCount[k]);
777         }
778       }
779     }
780     uint256 value = msg.value;
781     uint256 payExcess = value.sub(_luckyblockSpend.spendEtherCount);
782     
783     // if win ether
784     if (_random + _luckyblockEarn.earnEtherProbability >= 100) {
785       uint256 balance = _luckyblockEarn.earnEtherCount.add(payExcess);
786       if (balance > 0){
787         msg.sender.transfer(balance);
788       }
789     } else if (payExcess > 0) {
790       msg.sender.transfer(payExcess);
791     }
792     
793     emit Play(luckyblockId, msg.sender, _random);
794   }
795 
796   function withdrawToken(address contractAddress, address to, uint256 balance)
797     external onlyOwnerOrSuperuser {
798     ERC20Interface erc20 = ERC20Interface(contractAddress);
799     if (balance == uint256(0x0)){
800       erc20.transfer(to, erc20.balanceOf(address(this)));
801       emit WithdrawToken(contractAddress, to, erc20.balanceOf(address(this)));
802     } else {
803       erc20.transfer(to, balance);
804       emit WithdrawToken(contractAddress, to, balance);
805     }
806   }
807 
808   function withdrawEth(address to, uint256 balance) external onlySuperuser {
809     if (balance == uint256(0x0)) {
810       to.transfer(address(this).balance);
811       emit WithdrawEth(to, address(this).balance);
812     } else {
813       to.transfer(balance);
814       emit WithdrawEth(to, balance);
815     }
816   }
817 
818   function random() private view returns (uint8) {
819     return Random(randomContract).getRandom(); // random 0-99
820   }
821 }