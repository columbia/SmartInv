1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title -Airdrop
5  * every erc20 token can doAirdrop here 
6  * Contact us for further cooperation support@lordless.io
7  *
8  *  █████╗  ██╗ ██████╗  ██████╗  ██████╗   ██████╗  ██████╗
9  * ██╔══██╗ ██║ ██╔══██╗ ██╔══██╗ ██╔══██╗ ██╔═══██╗ ██╔══██╗
10  * ███████║ ██║ ██████╔╝ ██║  ██║ ██████╔╝ ██║   ██║ ██████╔╝
11  * ██╔══██║ ██║ ██╔══██╗ ██║  ██║ ██╔══██╗ ██║   ██║ ██╔═══╝
12  * ██║  ██║ ██║ ██║  ██║ ██████╔╝ ██║  ██║ ╚██████╔╝ ██║
13  * ╚═╝  ╚═╝ ╚═╝ ╚═╝  ╚═╝ ╚═════╝  ╚═╝  ╚═╝  ╚═════╝  ╚═╝
14  *
15  * ---
16  * POWERED BY
17  * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
18  * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
19  * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
20  * game at http://lordless.games
21  * code at https://github.com/lordlessio
22  */
23 
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   /**
58    * @dev Allows the current owner to relinquish control of the contract.
59    * @notice Renouncing to ownership will leave the contract without an owner.
60    * It will not be possible to call the functions with the `onlyOwner`
61    * modifier anymore.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(owner);
65     owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is Ownable {
93   event Pause();
94   event Unpause();
95 
96   bool public paused = false;
97 
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() public onlyOwner whenNotPaused {
119     paused = true;
120     emit Pause();
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() public onlyOwner whenPaused {
127     paused = false;
128     emit Unpause();
129   }
130 }
131 
132 
133 /**
134  * @title Roles
135  * @author Francisco Giordano (@frangio)
136  * @dev Library for managing addresses assigned to a Role.
137  * See RBAC.sol for example usage.
138  */
139 library Roles {
140   struct Role {
141     mapping (address => bool) bearer;
142   }
143 
144   /**
145    * @dev give an address access to this role
146    */
147   function add(Role storage _role, address _addr)
148     internal
149   {
150     _role.bearer[_addr] = true;
151   }
152 
153   /**
154    * @dev remove an address' access to this role
155    */
156   function remove(Role storage _role, address _addr)
157     internal
158   {
159     _role.bearer[_addr] = false;
160   }
161 
162   /**
163    * @dev check if an address has this role
164    * // reverts
165    */
166   function check(Role storage _role, address _addr)
167     internal
168     view
169   {
170     require(has(_role, _addr));
171   }
172 
173   /**
174    * @dev check if an address has this role
175    * @return bool
176    */
177   function has(Role storage _role, address _addr)
178     internal
179     view
180     returns (bool)
181   {
182     return _role.bearer[_addr];
183   }
184 }
185 
186 
187 /**
188  * @title RBAC (Role-Based Access Control)
189  * @author Matt Condon (@Shrugs)
190  * @dev Stores and provides setters and getters for roles and addresses.
191  * Supports unlimited numbers of roles and addresses.
192  * See //contracts/mocks/RBACMock.sol for an example of usage.
193  * This RBAC method uses strings to key roles. It may be beneficial
194  * for you to write your own implementation of this interface using Enums or similar.
195  */
196 contract RBAC {
197   using Roles for Roles.Role;
198 
199   mapping (string => Roles.Role) private roles;
200 
201   event RoleAdded(address indexed operator, string role);
202   event RoleRemoved(address indexed operator, string role);
203 
204   /**
205    * @dev reverts if addr does not have role
206    * @param _operator address
207    * @param _role the name of the role
208    * // reverts
209    */
210   function checkRole(address _operator, string _role)
211     public
212     view
213   {
214     roles[_role].check(_operator);
215   }
216 
217   /**
218    * @dev determine if addr has role
219    * @param _operator address
220    * @param _role the name of the role
221    * @return bool
222    */
223   function hasRole(address _operator, string _role)
224     public
225     view
226     returns (bool)
227   {
228     return roles[_role].has(_operator);
229   }
230 
231   /**
232    * @dev add a role to an address
233    * @param _operator address
234    * @param _role the name of the role
235    */
236   function addRole(address _operator, string _role)
237     internal
238   {
239     roles[_role].add(_operator);
240     emit RoleAdded(_operator, _role);
241   }
242 
243   /**
244    * @dev remove a role from an address
245    * @param _operator address
246    * @param _role the name of the role
247    */
248   function removeRole(address _operator, string _role)
249     internal
250   {
251     roles[_role].remove(_operator);
252     emit RoleRemoved(_operator, _role);
253   }
254 
255   /**
256    * @dev modifier to scope access to a single role (uses msg.sender as addr)
257    * @param _role the name of the role
258    * // reverts
259    */
260   modifier onlyRole(string _role)
261   {
262     checkRole(msg.sender, _role);
263     _;
264   }
265 
266   /**
267    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
268    * @param _roles the names of the roles to scope access to
269    * // reverts
270    *
271    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
272    *  see: https://github.com/ethereum/solidity/issues/2467
273    */
274   // modifier onlyRoles(string[] _roles) {
275   //     bool hasAnyRole = false;
276   //     for (uint8 i = 0; i < _roles.length; i++) {
277   //         if (hasRole(msg.sender, _roles[i])) {
278   //             hasAnyRole = true;
279   //             break;
280   //         }
281   //     }
282 
283   //     require(hasAnyRole);
284 
285   //     _;
286   // }
287 }
288 
289 
290 /**
291  * @title Superuser
292  * @dev The Superuser contract defines a single superuser who can transfer the ownership
293  * of a contract to a new address, even if he is not the owner.
294  * A superuser can transfer his role to a new address.
295  */
296 contract Superuser is Ownable, RBAC {
297   string public constant ROLE_SUPERUSER = "superuser";
298 
299   constructor () public {
300     addRole(msg.sender, ROLE_SUPERUSER);
301   }
302 
303   /**
304    * @dev Throws if called by any account that's not a superuser.
305    */
306   modifier onlySuperuser() {
307     checkRole(msg.sender, ROLE_SUPERUSER);
308     _;
309   }
310 
311   modifier onlyOwnerOrSuperuser() {
312     require(msg.sender == owner || isSuperuser(msg.sender));
313     _;
314   }
315 
316   /**
317    * @dev getter to determine if address has superuser role
318    */
319   function isSuperuser(address _addr)
320     public
321     view
322     returns (bool)
323   {
324     return hasRole(_addr, ROLE_SUPERUSER);
325   }
326 
327   /**
328    * @dev Allows the current superuser to transfer his role to a newSuperuser.
329    * @param _newSuperuser The address to transfer ownership to.
330    */
331   function transferSuperuser(address _newSuperuser) public onlySuperuser {
332     require(_newSuperuser != address(0));
333     removeRole(msg.sender, ROLE_SUPERUSER);
334     addRole(_newSuperuser, ROLE_SUPERUSER);
335   }
336 
337   /**
338    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
339    * @param _newOwner The address to transfer ownership to.
340    */
341   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
342     _transferOwnership(_newOwner);
343   }
344 }
345 
346 
347 /**
348  * @title SafeMath
349  */
350 library SafeMath {
351   /**
352   * @dev Integer division of two numbers, truncating the quotient.
353   */
354   function div(uint256 a, uint256 b) internal pure returns (uint256) {
355     // assert(b > 0); // Solidity automatically throws when dividing by 0
356     // uint256 c = a / b;
357     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
358     return a / b;
359   }
360 
361   /**
362   * @dev Multiplies two numbers, throws on overflow.
363   */
364   function mul(uint256 a, uint256 b) 
365       internal 
366       pure 
367       returns (uint256 c) 
368   {
369     if (a == 0) {
370       return 0;
371     }
372     c = a * b;
373     require(c / a == b, "SafeMath mul failed");
374     return c;
375   }
376 
377   /**
378   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
379   */
380   function sub(uint256 a, uint256 b)
381       internal
382       pure
383       returns (uint256) 
384   {
385     require(b <= a, "SafeMath sub failed");
386     return a - b;
387   }
388 
389   /**
390   * @dev Adds two numbers, throws on overflow.
391   */
392   function add(uint256 a, uint256 b)
393       internal
394       pure
395       returns (uint256 c) 
396   {
397     c = a + b;
398     require(c >= a, "SafeMath add failed");
399     return c;
400   }
401   
402   /**
403     * @dev gives square root of given x.
404     */
405   function sqrt(uint256 x)
406       internal
407       pure
408       returns (uint256 y) 
409   {
410     uint256 z = ((add(x,1)) / 2);
411     y = x;
412     while (z < y) 
413     {
414       y = z;
415       z = ((add((x / z),z)) / 2);
416     }
417   }
418   
419   /**
420     * @dev gives square. batchplies x by x
421     */
422   function sq(uint256 x)
423       internal
424       pure
425       returns (uint256)
426   {
427     return (mul(x,x));
428   }
429   
430   /**
431     * @dev x to the power of y 
432     */
433   function pwr(uint256 x, uint256 y)
434       internal 
435       pure 
436       returns (uint256)
437   {
438     if (x==0)
439         return (0);
440     else if (y==0)
441         return (1);
442     else 
443     {
444       uint256 z = x;
445       for (uint256 i=1; i < y; i++)
446         z = mul(z,x);
447       return (z);
448     }
449   }
450 }
451 
452 
453 /**
454  * @title -airdrop Interface
455  */
456 
457 interface IAirdrop {
458 
459   function isVerifiedUser(address user) external view returns (bool);
460   function isCollected(address user, bytes32 airdropId) external view returns (bool);
461   function getAirdropIds()external view returns(bytes32[]);
462   function getAirdropIdsByContractAddress(address contractAddress)external view returns(bytes32[]);
463   function getUser(address userAddress) external view returns (
464     address,
465     string,
466     uint256,
467     uint256
468   );
469   function getAirdrop(
470     bytes32 airdropId
471     ) external view returns (address, uint256, bool);
472   function updateVeifyFee(uint256 fee) external;
473   function verifyUser(string name) external payable;
474   function addAirdrop (address contractAddress, uint256 countPerUser, bool needVerifiedUser) external;
475   function claim(bytes32 airdropId) external;
476   function withdrawToken(address contractAddress, address to) external;
477   function withdrawEth(address to) external;
478 
479   
480   
481 
482   /* Events */
483 
484   event UpdateVeifyFee (
485     uint256 indexed fee
486   );
487 
488   event VerifyUser (
489     address indexed user
490   );
491 
492   event AddAirdrop (
493     address indexed contractAddress,
494     uint256 countPerUser,
495     bool needVerifiedUser
496   );
497 
498   event Claim (
499     bytes32 airdropId,
500     address user
501   );
502 
503   event WithdrawToken (
504     address indexed contractAddress,
505     address to,
506     uint256 count
507   );
508 
509   event WithdrawEth (
510     address to,
511     uint256 count
512   );
513 }
514 
515 
516 
517 
518 
519 
520 
521 contract ERC20Interface {
522   function transfer(address to, uint tokens) public returns (bool success);
523   function transferFrom(address from, address to, uint tokens) public returns (bool success);
524   function balanceOf(address tokenOwner) public view returns (uint balance);
525 }
526 contract Airdrop is Superuser, Pausable, IAirdrop {
527 
528   using SafeMath for *;
529 
530   struct User {
531     address user;
532     string name;
533     uint256 verifytime;
534     uint256 verifyFee;
535   }
536 
537   struct Airdrop {
538     address contractAddress;
539     uint256 countPerUser; // wei
540     bool needVerifiedUser;
541   }
542 
543   uint256 public verifyFee = 2e16; // 0.02 eth
544   bytes32[] public airdropIds; //
545 
546   mapping (address => User) public userAddressToUser;
547   mapping (address => bytes32[]) contractAddressToAirdropId;
548   mapping (bytes32 => Airdrop) airdropIdToAirdrop;
549   mapping (bytes32 => mapping (address => bool)) airdropIdToUserAddress;
550   mapping (address => uint256) contractAddressToAirdropCount;
551 
552 
553   function isVerifiedUser(address user) external view returns (bool){
554     return userAddressToUser[user].user == user;
555   }
556 
557   function isCollected(address user, bytes32 airdropId) external view returns (bool) {
558     return airdropIdToUserAddress[airdropId][user];
559   }
560 
561   function getAirdropIdsByContractAddress(address contractAddress)external view returns(bytes32[]){
562     return contractAddressToAirdropId[contractAddress];
563   }
564   function getAirdropIds()external view returns(bytes32[]){
565     return airdropIds;
566   }
567 
568   function tokenTotalClaim(address contractAddress)external view returns(uint256){
569     return contractAddressToAirdropCount[contractAddress];
570   }
571 
572   function getUser(
573     address userAddress
574     ) external view returns (address, string, uint256 ,uint256){
575     User storage user = userAddressToUser[userAddress];
576     return (user.user, user.name, user.verifytime, user.verifyFee);
577   }
578 
579   function getAirdrop(
580     bytes32 airdropId
581     ) external view returns (address, uint256, bool){
582     Airdrop storage airdrop = airdropIdToAirdrop[airdropId];
583     return (airdrop.contractAddress, airdrop.countPerUser, airdrop.needVerifiedUser);
584   }
585   
586   function updateVeifyFee(uint256 fee) external onlyOwnerOrSuperuser{
587     verifyFee = fee;
588     emit UpdateVeifyFee(fee);
589   }
590 
591   function verifyUser(string name) external payable whenNotPaused {
592     address sender = msg.sender;
593     require(!this.isVerifiedUser(sender), "Is Verified User");
594     uint256 _ethAmount = msg.value;
595     require(_ethAmount >= verifyFee, "LESS FEE");
596     uint256 payExcess = _ethAmount.sub(verifyFee);
597     if(payExcess > 0) {
598       sender.transfer(payExcess);
599     }
600     
601     User memory _user = User(
602       sender,
603       name,
604       block.timestamp,
605       verifyFee
606     );
607 
608     userAddressToUser[sender] = _user;
609     emit VerifyUser(msg.sender);
610   }
611 
612   function addAirdrop(address contractAddress, uint256 countPerUser, bool needVerifiedUser) external onlyOwnerOrSuperuser{
613     bytes32 airdropId = keccak256(
614       abi.encodePacked(block.timestamp, contractAddress, countPerUser, needVerifiedUser)
615     );
616 
617     Airdrop memory _airdrop = Airdrop(
618       contractAddress,
619       countPerUser,
620       needVerifiedUser
621     );
622     airdropIdToAirdrop[airdropId] = _airdrop;
623     airdropIds.push(airdropId);
624     contractAddressToAirdropId[contractAddress].push(airdropId);
625     emit AddAirdrop(contractAddress, countPerUser, needVerifiedUser);
626   }
627 
628   function claim(bytes32 airdropId) external whenNotPaused {
629 
630     Airdrop storage _airdrop = airdropIdToAirdrop[airdropId];
631     if (_airdrop.needVerifiedUser) {
632       require(this.isVerifiedUser(msg.sender));
633     }
634     
635     require(!this.isCollected(msg.sender, airdropId), "The same Airdrop can only be collected once per address.");
636     ERC20Interface erc20 = ERC20Interface(_airdrop.contractAddress);
637     erc20.transfer(msg.sender, _airdrop.countPerUser);
638     airdropIdToUserAddress[airdropId][msg.sender] = true;
639     // update to
640     contractAddressToAirdropCount[_airdrop.contractAddress] = 
641       contractAddressToAirdropCount[_airdrop.contractAddress].add(_airdrop.countPerUser);
642     emit Claim(airdropId, msg.sender);
643   }
644 
645   function withdrawToken(address contractAddress, address to) external onlyOwnerOrSuperuser {
646     ERC20Interface erc20 = ERC20Interface(contractAddress);
647     uint256 balance = erc20.balanceOf(address(this));
648     erc20.transfer(to, balance);
649     emit WithdrawToken(contractAddress, to, balance);
650   }
651 
652   function withdrawEth(address to) external onlySuperuser {
653     uint256 balance = address(this).balance;
654     to.transfer(balance);
655     emit WithdrawEth(to, balance);
656   }
657 
658 }