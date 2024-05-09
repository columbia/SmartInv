1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title -
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
27 
28 
29 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    * @notice Renouncing to ownership will leave the contract without an owner.
66    * It will not be possible to call the functions with the `onlyOwner`
67    * modifier anymore.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102 
103   bool public paused = false;
104 
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() public onlyOwner whenNotPaused {
126     paused = true;
127     emit Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() public onlyOwner whenPaused {
134     paused = false;
135     emit Unpause();
136   }
137 }
138 
139 // File: node_modules/zeppelin-solidity/contracts/access/rbac/Roles.sol
140 
141 /**
142  * @title Roles
143  * @author Francisco Giordano (@frangio)
144  * @dev Library for managing addresses assigned to a Role.
145  * See RBAC.sol for example usage.
146  */
147 library Roles {
148   struct Role {
149     mapping (address => bool) bearer;
150   }
151 
152   /**
153    * @dev give an address access to this role
154    */
155   function add(Role storage _role, address _addr)
156     internal
157   {
158     _role.bearer[_addr] = true;
159   }
160 
161   /**
162    * @dev remove an address' access to this role
163    */
164   function remove(Role storage _role, address _addr)
165     internal
166   {
167     _role.bearer[_addr] = false;
168   }
169 
170   /**
171    * @dev check if an address has this role
172    * // reverts
173    */
174   function check(Role storage _role, address _addr)
175     internal
176     view
177   {
178     require(has(_role, _addr));
179   }
180 
181   /**
182    * @dev check if an address has this role
183    * @return bool
184    */
185   function has(Role storage _role, address _addr)
186     internal
187     view
188     returns (bool)
189   {
190     return _role.bearer[_addr];
191   }
192 }
193 
194 // File: node_modules/zeppelin-solidity/contracts/access/rbac/RBAC.sol
195 
196 /**
197  * @title RBAC (Role-Based Access Control)
198  * @author Matt Condon (@Shrugs)
199  * @dev Stores and provides setters and getters for roles and addresses.
200  * Supports unlimited numbers of roles and addresses.
201  * See //contracts/mocks/RBACMock.sol for an example of usage.
202  * This RBAC method uses strings to key roles. It may be beneficial
203  * for you to write your own implementation of this interface using Enums or similar.
204  */
205 contract RBAC {
206   using Roles for Roles.Role;
207 
208   mapping (string => Roles.Role) private roles;
209 
210   event RoleAdded(address indexed operator, string role);
211   event RoleRemoved(address indexed operator, string role);
212 
213   /**
214    * @dev reverts if addr does not have role
215    * @param _operator address
216    * @param _role the name of the role
217    * // reverts
218    */
219   function checkRole(address _operator, string _role)
220     public
221     view
222   {
223     roles[_role].check(_operator);
224   }
225 
226   /**
227    * @dev determine if addr has role
228    * @param _operator address
229    * @param _role the name of the role
230    * @return bool
231    */
232   function hasRole(address _operator, string _role)
233     public
234     view
235     returns (bool)
236   {
237     return roles[_role].has(_operator);
238   }
239 
240   /**
241    * @dev add a role to an address
242    * @param _operator address
243    * @param _role the name of the role
244    */
245   function addRole(address _operator, string _role)
246     internal
247   {
248     roles[_role].add(_operator);
249     emit RoleAdded(_operator, _role);
250   }
251 
252   /**
253    * @dev remove a role from an address
254    * @param _operator address
255    * @param _role the name of the role
256    */
257   function removeRole(address _operator, string _role)
258     internal
259   {
260     roles[_role].remove(_operator);
261     emit RoleRemoved(_operator, _role);
262   }
263 
264   /**
265    * @dev modifier to scope access to a single role (uses msg.sender as addr)
266    * @param _role the name of the role
267    * // reverts
268    */
269   modifier onlyRole(string _role)
270   {
271     checkRole(msg.sender, _role);
272     _;
273   }
274 
275   /**
276    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
277    * @param _roles the names of the roles to scope access to
278    * // reverts
279    *
280    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
281    *  see: https://github.com/ethereum/solidity/issues/2467
282    */
283   // modifier onlyRoles(string[] _roles) {
284   //     bool hasAnyRole = false;
285   //     for (uint8 i = 0; i < _roles.length; i++) {
286   //         if (hasRole(msg.sender, _roles[i])) {
287   //             hasAnyRole = true;
288   //             break;
289   //         }
290   //     }
291 
292   //     require(hasAnyRole);
293 
294   //     _;
295   // }
296 }
297 
298 // File: node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol
299 
300 /**
301  * @title Superuser
302  * @dev The Superuser contract defines a single superuser who can transfer the ownership
303  * of a contract to a new address, even if he is not the owner.
304  * A superuser can transfer his role to a new address.
305  */
306 contract Superuser is Ownable, RBAC {
307   string public constant ROLE_SUPERUSER = "superuser";
308 
309   constructor () public {
310     addRole(msg.sender, ROLE_SUPERUSER);
311   }
312 
313   /**
314    * @dev Throws if called by any account that's not a superuser.
315    */
316   modifier onlySuperuser() {
317     checkRole(msg.sender, ROLE_SUPERUSER);
318     _;
319   }
320 
321   modifier onlyOwnerOrSuperuser() {
322     require(msg.sender == owner || isSuperuser(msg.sender));
323     _;
324   }
325 
326   /**
327    * @dev getter to determine if address has superuser role
328    */
329   function isSuperuser(address _addr)
330     public
331     view
332     returns (bool)
333   {
334     return hasRole(_addr, ROLE_SUPERUSER);
335   }
336 
337   /**
338    * @dev Allows the current superuser to transfer his role to a newSuperuser.
339    * @param _newSuperuser The address to transfer ownership to.
340    */
341   function transferSuperuser(address _newSuperuser) public onlySuperuser {
342     require(_newSuperuser != address(0));
343     removeRole(msg.sender, ROLE_SUPERUSER);
344     addRole(_newSuperuser, ROLE_SUPERUSER);
345   }
346 
347   /**
348    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
352     _transferOwnership(_newOwner);
353   }
354 }
355 
356 // File: contracts/lib/SafeMath.sol
357 
358 /**
359  * @title SafeMath
360  */
361 library SafeMath {
362   /**
363   * @dev Integer division of two numbers, truncating the quotient.
364   */
365   function div(uint256 a, uint256 b) internal pure returns (uint256) {
366     // assert(b > 0); // Solidity automatically throws when dividing by 0
367     // uint256 c = a / b;
368     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
369     return a / b;
370   }
371 
372   /**
373   * @dev Multiplies two numbers, throws on overflow.
374   */
375   function mul(uint256 a, uint256 b) 
376       internal 
377       pure 
378       returns (uint256 c) 
379   {
380     if (a == 0) {
381       return 0;
382     }
383     c = a * b;
384     require(c / a == b, "SafeMath mul failed");
385     return c;
386   }
387 
388   /**
389   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
390   */
391   function sub(uint256 a, uint256 b)
392       internal
393       pure
394       returns (uint256) 
395   {
396     require(b <= a, "SafeMath sub failed");
397     return a - b;
398   }
399 
400   /**
401   * @dev Adds two numbers, throws on overflow.
402   */
403   function add(uint256 a, uint256 b)
404       internal
405       pure
406       returns (uint256 c) 
407   {
408     c = a + b;
409     require(c >= a, "SafeMath add failed");
410     return c;
411   }
412   
413   /**
414     * @dev gives square root of given x.
415     */
416   function sqrt(uint256 x)
417       internal
418       pure
419       returns (uint256 y) 
420   {
421     uint256 z = ((add(x,1)) / 2);
422     y = x;
423     while (z < y) 
424     {
425       y = z;
426       z = ((add((x / z),z)) / 2);
427     }
428   }
429   
430   /**
431     * @dev gives square. batchplies x by x
432     */
433   function sq(uint256 x)
434       internal
435       pure
436       returns (uint256)
437   {
438     return (mul(x,x));
439   }
440   
441   /**
442     * @dev x to the power of y 
443     */
444   function pwr(uint256 x, uint256 y)
445       internal 
446       pure 
447       returns (uint256)
448   {
449     if (x==0)
450         return (0);
451     else if (y==0)
452         return (1);
453     else 
454     {
455       uint256 z = x;
456       for (uint256 i=1; i < y; i++)
457         z = mul(z,x);
458       return (z);
459     }
460   }
461 }
462 
463 // File: contracts/luckyblock/ILuckyblock.sol
464 
465 /**
466  * @title -luckyblock Interface
467  */
468 
469 interface ILuckyblock{
470 
471   function getLuckyblockSpend(
472     bytes32 luckyblockId
473   ) external view returns (
474     address[],
475     uint256[],
476     uint256
477   ); 
478 
479   function getLuckyblockEarn(
480     bytes32 luckyblockId
481     ) external view returns (
482     address[],
483     uint256[],
484     int[],
485     uint256,
486     int
487   );
488 
489   function getLuckyblockBase(
490     bytes32 luckyblockId
491     ) external view returns (
492       bool
493   );
494 
495   function addLuckyblock(uint256 seed) external;
496 
497   function start(
498     bytes32 luckyblockId
499   ) external;
500 
501   function stop(
502     bytes32 luckyblockId
503   ) external;
504 
505   function updateLuckyblockSpend(
506     bytes32 luckyblockId,
507     address[] spendTokenAddresses, 
508     uint256[] spendTokenCount,
509     uint256 spendEtherCount
510   ) external;
511 
512   function updateLuckyblockEarn (
513     bytes32 luckyblockId,
514     address[] earnTokenAddresses,
515     uint256[] earnTokenCount,
516     int[] earnTokenProbability, // (0 - 100)
517     uint256 earnEtherCount,
518     int earnEtherProbability
519   ) external;
520   function setRandomContract(address _randomContract) external;
521   function getLuckyblockIds()external view returns(bytes32[]);
522   function play(bytes32 luckyblockId) public payable;
523   function withdrawToken(address contractAddress, address to, uint256 balance) external;
524   function withdrawEth(address to, uint256 balance) external;
525 
526   
527   
528 
529   /* Events */
530 
531   event Play (
532     bytes32 indexed luckyblockId,
533     address user,
534     uint8 random
535   );
536 
537   event WithdrawToken (
538     address indexed contractAddress,
539     address to,
540     uint256 count
541   );
542 
543   event WithdrawEth (
544     address to,
545     uint256 count
546   );
547 
548   event Pay (
549     address from,
550     uint256 value
551   );
552 }
553 
554 
555 contract ERC20Interface {
556   function transfer(address to, uint tokens) public returns (bool);
557   function transferFrom(address from, address to, uint tokens) public returns (bool);
558   function balanceOf(address tokenOwner) public view returns (uint256);
559   function allowance(address tokenOwner, address spender) public view returns (uint);
560 }
561 
562 contract Random {
563   function getRandom() external view returns (uint8);
564 }
565 
566 contract Luckyblock is Superuser, Pausable, ILuckyblock {
567 
568   using SafeMath for *;
569 
570   address public randomContract;
571 
572   struct User {
573     address user;
574     string name;
575     uint256 verifytime;
576     uint256 verifyFee;
577   }
578 
579   struct LuckyblockBase {
580     bool ended;
581   }
582 
583   struct LuckyblockSpend {
584     address[] spendTokenAddresses;
585     uint256[] spendTokenCount;
586     uint256 spendEtherCount;
587   }
588 
589   struct LuckyblockEarn {
590     address[] earnTokenAddresses;
591     uint256[] earnTokenCount;
592     int[] earnTokenProbability; // (0 - 100)
593     uint256 earnEtherCount;
594     int earnEtherProbability;
595   }
596 
597   bytes32[] public luckyblockIds; //
598 
599   mapping (address => bytes32[]) contractAddressToLuckyblockId;
600 
601   mapping (bytes32 => LuckyblockEarn) luckyblockIdToLuckyblockEarn;
602   mapping (bytes32 => LuckyblockSpend) luckyblockIdToLuckyblockSpend;
603   mapping (bytes32 => LuckyblockBase) luckyblockIdToLuckyblockBase;
604 
605 
606   mapping (bytes32 => mapping (address => bool)) luckyblockIdToUserAddress;
607   mapping (address => uint256) contractAddressToLuckyblockCount;
608 
609   function () public payable {
610     emit Pay(msg.sender, msg.value);
611   }
612 
613   function setRandomContract(address _randomContract) external onlyOwnerOrSuperuser {
614     randomContract = _randomContract;
615   }
616 
617   function getLuckyblockIds()external view returns(bytes32[]){
618     return luckyblockIds;
619   }
620 
621   function getLuckyblockSpend(
622     bytes32 luckyblockId
623     ) external view returns (
624       address[],
625       uint256[],
626       uint256
627     ) {
628     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
629     return (
630       _luckyblockSpend.spendTokenAddresses,
631       _luckyblockSpend.spendTokenCount,
632       _luckyblockSpend.spendEtherCount
633       );
634   }
635 
636   function getLuckyblockEarn(
637     bytes32 luckyblockId
638     ) external view returns (
639       address[],
640       uint256[],
641       int[],
642       uint256,
643       int
644     ) {
645     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
646     return (
647       _luckyblockEarn.earnTokenAddresses,
648       _luckyblockEarn.earnTokenCount,
649       _luckyblockEarn.earnTokenProbability,
650       _luckyblockEarn.earnEtherCount,
651       _luckyblockEarn.earnEtherProbability
652       );
653   }
654 
655   function getLuckyblockBase(
656     bytes32 luckyblockId
657     ) external view returns (
658       bool
659     ) {
660     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
661     return (
662       _luckyblockBase.ended
663       );
664   }
665   
666   function addLuckyblock(uint256 seed) external onlyOwnerOrSuperuser {
667     bytes32 luckyblockId = keccak256(
668       abi.encodePacked(block.timestamp, seed)
669     );
670     LuckyblockBase memory _luckyblockBase = LuckyblockBase(
671       false
672     );
673     luckyblockIds.push(luckyblockId);
674     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
675   }
676 
677   function start(bytes32 luckyblockId) external{
678     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
679     _luckyblockBase.ended = false;
680     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
681   }
682 
683   function stop(bytes32 luckyblockId) external{
684     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
685     _luckyblockBase.ended = true;
686     luckyblockIdToLuckyblockBase[luckyblockId] = _luckyblockBase;
687   }
688 
689   function updateLuckyblockSpend (
690     bytes32 luckyblockId,
691     address[] spendTokenAddresses, 
692     uint256[] spendTokenCount,
693     uint256 spendEtherCount
694     ) external onlyOwnerOrSuperuser {
695     LuckyblockSpend memory _luckyblockSpend = LuckyblockSpend(
696       spendTokenAddresses,
697       spendTokenCount,
698       spendEtherCount
699     );
700     luckyblockIdToLuckyblockSpend[luckyblockId] = _luckyblockSpend;
701   }
702 
703   function updateLuckyblockEarn (
704     bytes32 luckyblockId,
705     address[] earnTokenAddresses,
706     uint256[] earnTokenCount,
707     int[] earnTokenProbability, // (0 - 100)
708     uint256 earnEtherCount,
709     int earnEtherProbability
710     ) external onlyOwnerOrSuperuser {
711     LuckyblockEarn memory _luckyblockEarn = LuckyblockEarn(
712       earnTokenAddresses,
713       earnTokenCount,
714       earnTokenProbability, // (0 - 100)
715       earnEtherCount,
716       earnEtherProbability
717     );
718     luckyblockIdToLuckyblockEarn[luckyblockId] = _luckyblockEarn;
719   }
720 
721   // function isContract(address _address) private view returns (bool){
722   //   uint size;
723   //   assembly { size := extcodesize(addr) }
724   //   return size > 0;
725   // }
726 
727   function isContract(address addr) private returns (bool) {
728     uint size;
729     assembly { size := extcodesize(addr) }
730     return size > 0;
731   }
732 
733   function play(bytes32 luckyblockId) public payable whenNotPaused {
734     require(!isContract(msg.sender));
735     LuckyblockBase storage _luckyblockBase = luckyblockIdToLuckyblockBase[luckyblockId];
736     LuckyblockSpend storage _luckyblockSpend = luckyblockIdToLuckyblockSpend[luckyblockId];
737     LuckyblockEarn storage _luckyblockEarn = luckyblockIdToLuckyblockEarn[luckyblockId];
738     
739     require(!_luckyblockBase.ended, "luckyblock is ended");
740 
741     // check sender's ether balance 
742     require(msg.value >= _luckyblockSpend.spendEtherCount, "sender value not enough");
743 
744     // check spend
745     if (_luckyblockSpend.spendTokenAddresses[0] != address(0x0)) {
746       for (uint8 i = 0; i < _luckyblockSpend.spendTokenAddresses.length; i++) {
747 
748         // check sender's erc20 balance 
749         require(
750           ERC20Interface(
751             _luckyblockSpend.spendTokenAddresses[i]
752           ).balanceOf(address(msg.sender)) >= _luckyblockSpend.spendTokenCount[i]
753         );
754 
755         require(
756           ERC20Interface(
757             _luckyblockSpend.spendTokenAddresses[i]
758           ).allowance(address(msg.sender), address(this)) >= _luckyblockSpend.spendTokenCount[i]
759         );
760 
761         // transfer erc20 token
762         ERC20Interface(_luckyblockSpend.spendTokenAddresses[i])
763           .transferFrom(msg.sender, address(this), _luckyblockSpend.spendTokenCount[i]);
764         }
765     }
766     
767     // check earn erc20
768     if (_luckyblockEarn.earnTokenAddresses[0] !=
769       address(0x0)) {
770       for (uint8 j= 0; j < _luckyblockEarn.earnTokenAddresses.length; j++) {
771         // check sender's erc20 balance 
772         uint256 earnTokenCount = _luckyblockEarn.earnTokenCount[j];
773         require(
774           ERC20Interface(_luckyblockEarn.earnTokenAddresses[j])
775           .balanceOf(address(this)) >= earnTokenCount
776         );
777       }
778     }
779     
780     // check earn ether
781     require(address(this).balance >= _luckyblockEarn.earnEtherCount, "contract value not enough");
782 
783     // do a random
784     uint8 _random = random();
785 
786     // earn erc20
787     for (uint8 k = 0; k < _luckyblockEarn.earnTokenAddresses.length; k++){
788       // if win erc20
789       if (_luckyblockEarn.earnTokenAddresses[0]
790         != address(0x0)){
791         if (_random + _luckyblockEarn.earnTokenProbability[k] >= 100) {
792           ERC20Interface(_luckyblockEarn.earnTokenAddresses[k])
793             .transfer(msg.sender, _luckyblockEarn.earnTokenCount[k]);
794         }
795       }
796     }
797     uint256 value = msg.value;
798     uint256 payExcess = value.sub(_luckyblockSpend.spendEtherCount);
799     
800     // if win ether
801     if (_random + _luckyblockEarn.earnEtherProbability >= 100) {
802       uint256 balance = _luckyblockEarn.earnEtherCount.add(payExcess);
803       if (balance > 0){
804         msg.sender.transfer(balance);
805       }
806     } else if (payExcess > 0) {
807       msg.sender.transfer(payExcess);
808     }
809     
810     emit Play(luckyblockId, msg.sender, _random);
811   }
812 
813   function withdrawToken(address contractAddress, address to, uint256 balance)
814     external onlyOwnerOrSuperuser {
815     ERC20Interface erc20 = ERC20Interface(contractAddress);
816     if (balance == uint256(0x0)){
817       erc20.transfer(to, erc20.balanceOf(address(this)));
818       emit WithdrawToken(contractAddress, to, erc20.balanceOf(address(this)));
819     } else {
820       erc20.transfer(to, balance);
821       emit WithdrawToken(contractAddress, to, balance);
822     }
823   }
824 
825   function withdrawEth(address to, uint256 balance) external onlySuperuser {
826     if (balance == uint256(0x0)) {
827       to.transfer(address(this).balance);
828       emit WithdrawEth(to, address(this).balance);
829     } else {
830       to.transfer(balance);
831       emit WithdrawEth(to, balance);
832     }
833   }
834 
835   function random() private view returns (uint8) {
836     return Random(randomContract).getRandom(); // random 0-99
837   }
838 }