1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title -LORDLESS tavern - Tavern
5  * Tavern contract records the core attributes of Tavern
6  * 
7  * ████████╗  █████╗  ██╗   ██╗ ███████╗ ██████╗  ███╗   ██╗ ██╗
8  * ╚══██╔══╝ ██╔══██╗ ██║   ██║ ██╔════╝ ██╔══██╗ ████╗  ██║ ██║
9  *    ██║    ███████║ ██║   ██║ █████╗   ██████╔╝ ██╔██╗ ██║ ██║
10  *    ██║    ██╔══██║ ╚██╗ ██╔╝ ██╔══╝   ██╔══██╗ ██║╚██╗██║ ╚═╝
11  *    ██║    ██║  ██║  ╚████╔╝  ███████╗ ██║  ██║ ██║ ╚████║ ██╗
12  *    ╚═╝    ╚═╝  ╚═╝   ╚═══╝   ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝ ╚═╝
13  * 
14  * ---
15  * POWERED BY
16  * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
17  * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
18  * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
19  * game at https://lordless.io
20  * code at https://github.com/lordlessio
21  */
22 
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
305 // File: contracts/tavern/IPower.sol
306 
307 interface IPower {
308   function setTavernContract(address tavern) external;
309   function influenceByToken(uint256 tokenId) external view returns(uint256);
310   function levelByToken(uint256 tokenId) external view returns(uint256);
311   function weightsApportion(uint256 userLevel, uint256 lordLevel) external view returns(uint256);
312 
313    /* Events */
314 
315   event SetTavernContract (
316     address tavern
317   );
318 }
319 
320 // File: contracts/tavern/ITavern.sol
321 
322 /**
323  * @title Tavern Interface
324  */
325 
326 interface ITavern {
327 
328   function setPowerContract(address _powerContract) external;
329   function influenceByToken(uint256 tokenId) external view returns(uint256);
330   function levelByToken(uint256 tokenId) external view returns(uint256);
331   function weightsApportion(uint256 ulevel1, uint256 ulevel2) external view returns(uint256);
332 
333   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256);
334   function isBuilt(uint256 tokenId) external view returns (bool);
335 
336   function build(
337     uint256 tokenId,
338     int longitude,
339     int latitude,
340     uint8 popularity
341     ) external;
342 
343   function batchBuild(
344     uint256[] tokenIds,
345     int[] longitudes,
346     int[] latitudes,
347     uint8[] popularitys
348     ) external;
349 
350   function activenessUpgrade(uint256 tokenId, uint256 deltaActiveness) external;
351   function batchActivenessUpgrade(uint256[] tokenIds, uint256[] deltaActiveness) external;
352 
353   function popularitySetting(uint256 tokenId, uint8 popularity) external;
354   function batchPopularitySetting(uint256[] tokenIds, uint8[] popularitys) external;
355   
356   /* Events */
357 
358   event Build (
359     uint256 time,
360     uint256 indexed tokenId,
361     int longitude,
362     int latitude,
363     uint8 popularity
364   );
365 
366   event ActivenessUpgrade (
367     uint256 indexed tokenId,
368     uint256 oActiveness,
369     uint256 newActiveness
370   );
371 
372   event PopularitySetting (
373     uint256 indexed tokenId,
374     uint256 oPopularity,
375     uint256 newPopularity
376   );
377 }
378 
379 // File: contracts/lib/SafeMath.sol
380 
381 /**
382  * @title SafeMath
383  */
384 library SafeMath {
385   /**
386   * @dev Integer division of two numbers, truncating the quotient.
387   */
388   function div(uint256 a, uint256 b) internal pure returns (uint256) {
389     // assert(b > 0); // Solidity automatically throws when dividing by 0
390     // uint256 c = a / b;
391     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
392     return a / b;
393   }
394 
395   /**
396   * @dev Multiplies two numbers, throws on overflow.
397   */
398   function mul(uint256 a, uint256 b) 
399       internal 
400       pure 
401       returns (uint256 c) 
402   {
403     if (a == 0) {
404       return 0;
405     }
406     c = a * b;
407     require(c / a == b, "SafeMath mul failed");
408     return c;
409   }
410 
411   /**
412   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
413   */
414   function sub(uint256 a, uint256 b)
415       internal
416       pure
417       returns (uint256) 
418   {
419     require(b <= a, "SafeMath sub failed");
420     return a - b;
421   }
422 
423   /**
424   * @dev Adds two numbers, throws on overflow.
425   */
426   function add(uint256 a, uint256 b)
427       internal
428       pure
429       returns (uint256 c) 
430   {
431     c = a + b;
432     require(c >= a, "SafeMath add failed");
433     return c;
434   }
435   
436   /**
437     * @dev gives square root of given x.
438     */
439   function sqrt(uint256 x)
440       internal
441       pure
442       returns (uint256 y) 
443   {
444     uint256 z = ((add(x,1)) / 2);
445     y = x;
446     while (z < y) 
447     {
448       y = z;
449       z = ((add((x / z),z)) / 2);
450     }
451   }
452   
453   /**
454     * @dev gives square. batchplies x by x
455     */
456   function sq(uint256 x)
457       internal
458       pure
459       returns (uint256)
460   {
461     return (mul(x,x));
462   }
463   
464   /**
465     * @dev x to the power of y 
466     */
467   function pwr(uint256 x, uint256 y)
468       internal 
469       pure 
470       returns (uint256)
471   {
472     if (x==0)
473         return (0);
474     else if (y==0)
475         return (1);
476     else 
477     {
478       uint256 z = x;
479       for (uint256 i=1; i < y; i++)
480         z = mul(z,x);
481       return (z);
482     }
483   }
484 }
485 
486 // File: contracts/tavern/TavernBase.sol
487 
488 contract TavernBase is ITavern {
489   using SafeMath for *;
490 
491   struct Tavern {
492     uint256 initAt; // The time of tavern init
493     int longitude; // The longitude of tavern
494     int latitude; // The latitude of tavern
495     uint8 popularity; // The popularity of tavern
496     uint256 activeness; // The activeness of tavern
497   }
498   
499   uint8 public constant decimals = 16; // longitude latitude decimals
500 
501   mapping(uint256 => Tavern) internal tokenTaverns;
502   
503   function _tavern(uint256 _tokenId) internal view returns (uint256, int, int, uint8, uint256) {
504     Tavern storage tavern = tokenTaverns[_tokenId];
505     return (
506       tavern.initAt, 
507       tavern.longitude, 
508       tavern.latitude, 
509       tavern.popularity, 
510       tavern.activeness
511     );
512   }
513   
514   function _isBuilt(uint256 _tokenId) internal view returns (bool){
515     Tavern storage tavern = tokenTaverns[_tokenId];
516     return (tavern.initAt > 0);
517   }
518 
519   function _build(
520     uint256 _tokenId,
521     int _longitude,
522     int _latitude,
523     uint8 _popularity
524     ) internal {
525 
526     // Check whether tokenid has been initialized
527     require(!_isBuilt(_tokenId));
528     require(_isLongitude(_longitude));
529     require(_isLatitude(_latitude));
530     require(_popularity != 0);
531     uint256 time = block.timestamp;
532     Tavern memory tavern = Tavern(
533       time, _longitude, _latitude, _popularity, uint256(0)
534     );
535     tokenTaverns[_tokenId] = tavern;
536     emit Build(time, _tokenId, _longitude, _latitude, _popularity);
537   }
538   
539   function _batchBuild(
540     uint256[] _tokenIds,
541     int[] _longitudes,
542     int[] _latitudes,
543     uint8[] _popularitys
544     ) internal {
545     uint256 i = 0;
546     while (i < _tokenIds.length) {
547       _build(
548         _tokenIds[i],
549         _longitudes[i],
550         _latitudes[i],
551         _popularitys[i]
552       );
553       i += 1;
554     }
555 
556     
557   }
558 
559   function _activenessUpgrade(uint256 _tokenId, uint256 _deltaActiveness) internal {
560     require(_isBuilt(_tokenId));
561     Tavern storage tavern = tokenTaverns[_tokenId];
562     uint256 oActiveness = tavern.activeness;
563     uint256 newActiveness = tavern.activeness.add(_deltaActiveness);
564     tavern.activeness = newActiveness;
565     tokenTaverns[_tokenId] = tavern;
566     emit ActivenessUpgrade(_tokenId, oActiveness, newActiveness);
567   }
568   function _batchActivenessUpgrade(uint256[] _tokenIds, uint256[] __deltaActiveness) internal {
569     uint256 i = 0;
570     while (i < _tokenIds.length) {
571       _activenessUpgrade(_tokenIds[i], __deltaActiveness[i]);
572       i += 1;
573     }
574   }
575 
576   function _popularitySetting(uint256 _tokenId, uint8 _popularity) internal {
577     require(_isBuilt(_tokenId));
578     uint8 oPopularity = tokenTaverns[_tokenId].popularity;
579     tokenTaverns[_tokenId].popularity = _popularity;
580     emit PopularitySetting(_tokenId, oPopularity, _popularity);
581   }
582 
583   function _batchPopularitySetting(uint256[] _tokenIds, uint8[] _popularitys) internal {
584     uint256 i = 0;
585     while (i < _tokenIds.length) {
586       _popularitySetting(_tokenIds[i], _popularitys[i]);
587       i += 1;
588     }
589   }
590 
591   function _isLongitude (
592     int _param
593   ) internal pure returns (bool){
594     
595     return( 
596       _param <= 180 * int(10 ** uint256(decimals))&&
597       _param >= -180 * int(10 ** uint256(decimals))
598       );
599   } 
600 
601   function _isLatitude (
602     int _param
603   ) internal pure returns (bool){
604     return( 
605       _param <= 90 * int(10 ** uint256(decimals))&&
606       _param >= -90 * int(10 ** uint256(decimals))
607       );
608   } 
609 }
610 
611 // File: contracts/tavern/Tavern.sol
612 
613 
614 contract Tavern is ITavern, TavernBase, Superuser {
615   
616   IPower public powerContract;
617 
618   /**
619    * @dev set power contract address
620    * @param _powerContract contract address
621    */
622   function setPowerContract(address _powerContract) onlySuperuser external{
623     powerContract = IPower(_powerContract);
624   }
625 
626   
627   /**
628    * @dev get Tavern's influence by tokenId
629    * @param tokenId tokenId
630    * @return uint256 Tavern's influence 
631    *
632    * The influence of Tavern determines its ability to distribute candy daily.
633    */
634   function influenceByToken(uint256 tokenId) external view returns(uint256) {
635     return powerContract.influenceByToken(tokenId);
636   }
637 
638 
639   /**
640    * @dev get Tavern's weightsApportion 
641    * @param userLevel userLevel
642    * @param lordLevel lordLevel
643    * @return uint256 Tavern's weightsApportion
644    * The candy that the user rewards when completing the candy mission will be assigned to the user and the lord. 
645    * The distribution ratio is determined by weightsApportion
646    */
647   function weightsApportion(uint256 userLevel, uint256 lordLevel) external view returns(uint256){
648     return powerContract.weightsApportion(userLevel, lordLevel);
649   }
650 
651   /**
652    * @dev get Tavern's level by tokenId
653    * @param tokenId tokenId
654    * @return uint256 Tavern's level
655    */
656   function levelByToken(uint256 tokenId) external view returns(uint256) {
657     return powerContract.levelByToken(tokenId);
658   }
659 
660   /**
661    * @dev get a Tavern's infomation 
662    * @param tokenId tokenId
663    * @return uint256 Tavern's construction time
664    * @return int Tavern's longitude value 
665    * @return int Tavern's latitude value
666    * @return uint8 Tavern's popularity
667    * @return uint256 Tavern's activeness
668    */
669   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256){
670     return super._tavern(tokenId);
671   }
672 
673   /**
674    * @dev check the tokenId is built 
675    * @param tokenId tokenId
676    * @return bool tokenId is built 
677    */
678   function isBuilt(uint256 tokenId) external view returns (bool){
679     return super._isBuilt(tokenId);
680   }
681 
682   /**
683    * @dev build a tavern
684    * @param tokenId tokenId
685    * @param longitude longitude value 
686    * @param latitude latitude value
687    * @param popularity popularity
688    */
689   function build(
690     uint256 tokenId,
691     int longitude,
692     int latitude,
693     uint8 popularity
694   ) external onlySuperuser {
695     super._build(tokenId, longitude, latitude, popularity);
696   }
697 
698   /**
699    * @dev build batch tavern in one transaction
700    * @param tokenIds Array of tokenId
701    * @param longitudes Array of longitude value 
702    * @param latitudes Array of latitude value
703    * @param popularitys Array of popularity
704    */
705   function batchBuild(
706     uint256[] tokenIds,
707     int[] longitudes,
708     int[] latitudes,
709     uint8[] popularitys
710     ) external onlySuperuser{
711 
712     super._batchBuild(
713       tokenIds,
714       longitudes,
715       latitudes,
716       popularitys
717     );
718   }
719 
720   /**
721    * @dev upgrade Tavern's activeness 
722    * @param tokenId tokenId
723    * @param deltaActiveness delta activeness
724    */
725   function activenessUpgrade(uint256 tokenId, uint256 deltaActiveness) onlyOwnerOrSuperuser external {
726     super._activenessUpgrade(tokenId, deltaActiveness);
727   }
728 
729   /**
730    * @dev upgrade batch Taverns's activeness 
731    * @param tokenIds Array of tokenId
732    * @param deltaActiveness  array of delta activeness
733    */
734   function batchActivenessUpgrade(uint256[] tokenIds, uint256[] deltaActiveness) onlyOwnerOrSuperuser external {
735     super._batchActivenessUpgrade(tokenIds, deltaActiveness);
736   }
737 
738   /**
739    * @dev set Taverns's popularity 
740    * @param tokenId Tavern's tokenId
741    * @param popularity Tavern's popularity
742    */
743   function popularitySetting(uint256 tokenId, uint8 popularity) onlySuperuser external {
744     super._popularitySetting(tokenId, popularity);
745   }
746 
747   /**
748    * @dev set batch Taverns's popularity 
749    * @param tokenIds Array of tokenId
750    * @param popularitys Array of popularity
751    */
752   function batchPopularitySetting(uint256[] tokenIds, uint8[] popularitys) onlySuperuser external {
753     super._batchPopularitySetting(tokenIds, popularitys);
754   }
755 }