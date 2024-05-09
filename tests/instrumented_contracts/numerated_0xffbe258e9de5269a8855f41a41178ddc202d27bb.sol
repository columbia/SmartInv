1 pragma solidity ^0.4.24;
2 
3 
4 /**
5 * @title - Tavern's Power Algorithm
6 * Power contract implements the algorithm of Tavern equity attribute
7 *
8 * ██████╗   ██████╗  ██╗    ██╗ ███████╗ ██████╗  ██╗
9 * ██╔══██╗ ██╔═══██╗ ██║    ██║ ██╔════╝ ██╔══██╗ ██║
10 * ██████╔╝ ██║   ██║ ██║ █╗ ██║ █████╗   ██████╔╝ ██║
11 * ██╔═══╝  ██║   ██║ ██║███╗██║ ██╔══╝   ██╔══██╗ ╚═╝
12 * ██║      ╚██████╔╝ ╚███╔███╔╝ ███████╗ ██║  ██║ ██╗
13 * ╚═╝       ╚═════╝   ╚══╝╚══╝  ╚══════╝ ╚═╝  ╚═╝ ╚═╝
14 *
15 * ---
16 * POWERED BY
17 * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
18 * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
19 * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
20 * game at https://lordless.io
21 * code at https://github.com/lordlessio
22 */
23 
24 // File: node_modules/zeppelin-solidity/contracts/access/rbac/Roles.sol
25 
26 /**
27  * @title Roles
28  * @author Francisco Giordano (@frangio)
29  * @dev Library for managing addresses assigned to a Role.
30  * See RBAC.sol for example usage.
31  */
32 library Roles {
33   struct Role {
34     mapping (address => bool) bearer;
35   }
36 
37   /**
38    * @dev give an address access to this role
39    */
40   function add(Role storage _role, address _addr)
41     internal
42   {
43     _role.bearer[_addr] = true;
44   }
45 
46   /**
47    * @dev remove an address' access to this role
48    */
49   function remove(Role storage _role, address _addr)
50     internal
51   {
52     _role.bearer[_addr] = false;
53   }
54 
55   /**
56    * @dev check if an address has this role
57    * // reverts
58    */
59   function check(Role storage _role, address _addr)
60     internal
61     view
62   {
63     require(has(_role, _addr));
64   }
65 
66   /**
67    * @dev check if an address has this role
68    * @return bool
69    */
70   function has(Role storage _role, address _addr)
71     internal
72     view
73     returns (bool)
74   {
75     return _role.bearer[_addr];
76   }
77 }
78 
79 // File: node_modules/zeppelin-solidity/contracts/access/rbac/RBAC.sol
80 
81 /**
82  * @title RBAC (Role-Based Access Control)
83  * @author Matt Condon (@Shrugs)
84  * @dev Stores and provides setters and getters for roles and addresses.
85  * Supports unlimited numbers of roles and addresses.
86  * See //contracts/mocks/RBACMock.sol for an example of usage.
87  * This RBAC method uses strings to key roles. It may be beneficial
88  * for you to write your own implementation of this interface using Enums or similar.
89  */
90 contract RBAC {
91   using Roles for Roles.Role;
92 
93   mapping (string => Roles.Role) private roles;
94 
95   event RoleAdded(address indexed operator, string role);
96   event RoleRemoved(address indexed operator, string role);
97 
98   /**
99    * @dev reverts if addr does not have role
100    * @param _operator address
101    * @param _role the name of the role
102    * // reverts
103    */
104   function checkRole(address _operator, string _role)
105     public
106     view
107   {
108     roles[_role].check(_operator);
109   }
110 
111   /**
112    * @dev determine if addr has role
113    * @param _operator address
114    * @param _role the name of the role
115    * @return bool
116    */
117   function hasRole(address _operator, string _role)
118     public
119     view
120     returns (bool)
121   {
122     return roles[_role].has(_operator);
123   }
124 
125   /**
126    * @dev add a role to an address
127    * @param _operator address
128    * @param _role the name of the role
129    */
130   function addRole(address _operator, string _role)
131     internal
132   {
133     roles[_role].add(_operator);
134     emit RoleAdded(_operator, _role);
135   }
136 
137   /**
138    * @dev remove a role from an address
139    * @param _operator address
140    * @param _role the name of the role
141    */
142   function removeRole(address _operator, string _role)
143     internal
144   {
145     roles[_role].remove(_operator);
146     emit RoleRemoved(_operator, _role);
147   }
148 
149   /**
150    * @dev modifier to scope access to a single role (uses msg.sender as addr)
151    * @param _role the name of the role
152    * // reverts
153    */
154   modifier onlyRole(string _role)
155   {
156     checkRole(msg.sender, _role);
157     _;
158   }
159 
160   /**
161    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
162    * @param _roles the names of the roles to scope access to
163    * // reverts
164    *
165    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
166    *  see: https://github.com/ethereum/solidity/issues/2467
167    */
168   // modifier onlyRoles(string[] _roles) {
169   //     bool hasAnyRole = false;
170   //     for (uint8 i = 0; i < _roles.length; i++) {
171   //         if (hasRole(msg.sender, _roles[i])) {
172   //             hasAnyRole = true;
173   //             break;
174   //         }
175   //     }
176 
177   //     require(hasAnyRole);
178 
179   //     _;
180   // }
181 }
182 
183 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191   address public owner;
192 
193 
194   event OwnershipRenounced(address indexed previousOwner);
195   event OwnershipTransferred(
196     address indexed previousOwner,
197     address indexed newOwner
198   );
199 
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   constructor() public {
206     owner = msg.sender;
207   }
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to relinquish control of the contract.
219    * @notice Renouncing to ownership will leave the contract without an owner.
220    * It will not be possible to call the functions with the `onlyOwner`
221    * modifier anymore.
222    */
223   function renounceOwnership() public onlyOwner {
224     emit OwnershipRenounced(owner);
225     owner = address(0);
226   }
227 
228   /**
229    * @dev Allows the current owner to transfer control of the contract to a newOwner.
230    * @param _newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(address _newOwner) public onlyOwner {
233     _transferOwnership(_newOwner);
234   }
235 
236   /**
237    * @dev Transfers control of the contract to a newOwner.
238    * @param _newOwner The address to transfer ownership to.
239    */
240   function _transferOwnership(address _newOwner) internal {
241     require(_newOwner != address(0));
242     emit OwnershipTransferred(owner, _newOwner);
243     owner = _newOwner;
244   }
245 }
246 
247 // File: node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol
248 
249 /**
250  * @title Superuser
251  * @dev The Superuser contract defines a single superuser who can transfer the ownership
252  * of a contract to a new address, even if he is not the owner.
253  * A superuser can transfer his role to a new address.
254  */
255 contract Superuser is Ownable, RBAC {
256   string public constant ROLE_SUPERUSER = "superuser";
257 
258   constructor () public {
259     addRole(msg.sender, ROLE_SUPERUSER);
260   }
261 
262   /**
263    * @dev Throws if called by any account that's not a superuser.
264    */
265   modifier onlySuperuser() {
266     checkRole(msg.sender, ROLE_SUPERUSER);
267     _;
268   }
269 
270   modifier onlyOwnerOrSuperuser() {
271     require(msg.sender == owner || isSuperuser(msg.sender));
272     _;
273   }
274 
275   /**
276    * @dev getter to determine if address has superuser role
277    */
278   function isSuperuser(address _addr)
279     public
280     view
281     returns (bool)
282   {
283     return hasRole(_addr, ROLE_SUPERUSER);
284   }
285 
286   /**
287    * @dev Allows the current superuser to transfer his role to a newSuperuser.
288    * @param _newSuperuser The address to transfer ownership to.
289    */
290   function transferSuperuser(address _newSuperuser) public onlySuperuser {
291     require(_newSuperuser != address(0));
292     removeRole(msg.sender, ROLE_SUPERUSER);
293     addRole(_newSuperuser, ROLE_SUPERUSER);
294   }
295 
296   /**
297    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
298    * @param _newOwner The address to transfer ownership to.
299    */
300   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
301     _transferOwnership(_newOwner);
302   }
303 }
304 
305 // File: contracts/lib/SafeMath.sol
306 
307 /**
308  * @title SafeMath
309  */
310 library SafeMath {
311   /**
312   * @dev Integer division of two numbers, truncating the quotient.
313   */
314   function div(uint256 a, uint256 b) internal pure returns (uint256) {
315     // assert(b > 0); // Solidity automatically throws when dividing by 0
316     // uint256 c = a / b;
317     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
318     return a / b;
319   }
320 
321   /**
322   * @dev Multiplies two numbers, throws on overflow.
323   */
324   function mul(uint256 a, uint256 b) 
325       internal 
326       pure 
327       returns (uint256 c) 
328   {
329     if (a == 0) {
330       return 0;
331     }
332     c = a * b;
333     require(c / a == b, "SafeMath mul failed");
334     return c;
335   }
336 
337   /**
338   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
339   */
340   function sub(uint256 a, uint256 b)
341       internal
342       pure
343       returns (uint256) 
344   {
345     require(b <= a, "SafeMath sub failed");
346     return a - b;
347   }
348 
349   /**
350   * @dev Adds two numbers, throws on overflow.
351   */
352   function add(uint256 a, uint256 b)
353       internal
354       pure
355       returns (uint256 c) 
356   {
357     c = a + b;
358     require(c >= a, "SafeMath add failed");
359     return c;
360   }
361   
362   /**
363     * @dev gives square root of given x.
364     */
365   function sqrt(uint256 x)
366       internal
367       pure
368       returns (uint256 y) 
369   {
370     uint256 z = ((add(x,1)) / 2);
371     y = x;
372     while (z < y) 
373     {
374       y = z;
375       z = ((add((x / z),z)) / 2);
376     }
377   }
378   
379   /**
380     * @dev gives square. batchplies x by x
381     */
382   function sq(uint256 x)
383       internal
384       pure
385       returns (uint256)
386   {
387     return (mul(x,x));
388   }
389   
390   /**
391     * @dev x to the power of y 
392     */
393   function pwr(uint256 x, uint256 y)
394       internal 
395       pure 
396       returns (uint256)
397   {
398     if (x==0)
399         return (0);
400     else if (y==0)
401         return (1);
402     else 
403     {
404       uint256 z = x;
405       for (uint256 i=1; i < y; i++)
406         z = mul(z,x);
407       return (z);
408     }
409   }
410 }
411 
412 // File: contracts/tavern/IPower.sol
413 
414 interface IPower {
415   function setTavernContract(address tavern) external;
416   function influenceByToken(uint256 tokenId) external view returns(uint256);
417   function levelByToken(uint256 tokenId) external view returns(uint256);
418   function weightsApportion(uint256 userLevel, uint256 lordLevel) external view returns(uint256);
419 
420    /* Events */
421 
422   event SetTavernContract (
423     address tavern
424   );
425 }
426 
427 // File: contracts/tavern/ITavern.sol
428 
429 /**
430  * @title Tavern Interface
431  */
432 
433 interface ITavern {
434 
435   function setPowerContract(address _powerContract) external;
436   function influenceByToken(uint256 tokenId) external view returns(uint256);
437   function levelByToken(uint256 tokenId) external view returns(uint256);
438   function weightsApportion(uint256 ulevel1, uint256 ulevel2) external view returns(uint256);
439 
440   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256);
441   function isBuilt(uint256 tokenId) external view returns (bool);
442 
443   function build(
444     uint256 tokenId,
445     int longitude,
446     int latitude,
447     uint8 popularity
448     ) external;
449 
450   function batchBuild(
451     uint256[] tokenIds,
452     int[] longitudes,
453     int[] latitudes,
454     uint8[] popularitys
455     ) external;
456 
457   function activenessUpgrade(uint256 tokenId, uint256 deltaActiveness) external;
458   function batchActivenessUpgrade(uint256[] tokenIds, uint256[] deltaActiveness) external;
459 
460   function popularitySetting(uint256 tokenId, uint8 popularity) external;
461   function batchPopularitySetting(uint256[] tokenIds, uint8[] popularitys) external;
462   
463   /* Events */
464 
465   event Build (
466     uint256 time,
467     uint256 indexed tokenId,
468     int longitude,
469     int latitude,
470     uint8 popularity
471   );
472 
473   event ActivenessUpgrade (
474     uint256 indexed tokenId,
475     uint256 oActiveness,
476     uint256 newActiveness
477   );
478 
479   event PopularitySetting (
480     uint256 indexed tokenId,
481     uint256 oPopularity,
482     uint256 newPopularity
483   );
484 }
485 
486 // File: contracts/tavern/Power.sol
487 
488 contract Power is Superuser, IPower{
489   using SafeMath for *;
490   ITavern public tavernContract;
491   
492   /**
493    * @dev set the Tavern contract address
494    * @return tavern Tavern contract address
495    */
496   function setTavernContract(address tavern) onlySuperuser external {
497     tavernContract = ITavern(tavern);
498     emit SetTavernContract(tavern);
499   }
500 
501   /**
502    * @dev get influence by token
503    * @param tokenId tokenId
504    * @return tavern Tavern contract address
505    * influence is
506    */
507   function influenceByToken(uint256 tokenId) external view returns(uint256){
508 
509 
510     uint8 popularity;
511     uint256 activeness;
512     ( , , , popularity, activeness) = tavernContract.tavern(tokenId);
513     return _influenceAlgorithm(popularity, activeness);
514   }
515 
516   /**
517    * @dev get Tavern's level by tokenId
518    * @param tokenId tokenId
519    * @return uint256 Tavern's level
520    */
521   function levelByToken(uint256 tokenId) external view returns(uint256){
522 
523     uint256 activeness;
524     ( , , , , activeness) = tavernContract.tavern(tokenId);
525     return _activeness2level(activeness);
526   }
527 
528   function _influenceAlgorithm(uint8 _popularity, uint256 _activeness) internal pure returns (uint256) {
529     uint256 popularity = uint256(_popularity);
530     return popularity.mul(_activeness).add(popularity);
531   }
532   
533   function _activeness2level(uint256 _activeness) internal pure returns (uint256) {
534     return (_activeness.mul(uint(108).sq())/10).sqrt()/108 + 1;
535   }
536 
537   uint public constant weightsApportionDecimals = 4;
538   /**
539   * @dev get Tavern's weightsApportion 
540   * @param userLevel userLevel
541   * @param lordLevel lordLevel
542   * @return uint256 Tavern's weightsApportion
543   * The candy that the user rewards when completing the candy mission will be assigned to the user and the lord. 
544   * The distribution ratio is determined by weightsApportion
545   */
546   function weightsApportion(uint256 userLevel, uint256 lordLevel) external view returns(uint256) {
547     return 2000 + 6000 * userLevel / (userLevel + lordLevel);
548   }
549 
550 }