1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract EIP820ImplementerInterface {
51     /// @notice Contracts that implement an interferce in behalf of another contract must return true
52     /// @param addr Address that the contract woll implement the interface in behalf of
53     /// @param interfaceHash keccak256 of the name of the interface
54     /// @return true if the contract can implement the interface represented by
55     ///  `ìnterfaceHash` in behalf of `addr`
56     function canImplementInterfaceForAddress(address addr, bytes32 interfaceHash) view public returns(bool);
57 }
58 
59 contract EIP820Registry {
60 
61     mapping (address => mapping(bytes32 => address)) interfaces;
62     mapping (address => address) managers;
63 
64     modifier canManage(address addr) {
65         require(getManager(addr) == msg.sender);
66         _;
67     }
68 
69     /// @notice Query the hash of an interface given a name
70     /// @param interfaceName Name of the interfce
71     function interfaceHash(string interfaceName) public pure returns(bytes32) {
72         return keccak256(interfaceName);
73     }
74 
75     /// @notice GetManager
76     function getManager(address addr) public view returns(address) {
77         // By default the manager of an address is the same address
78         if (managers[addr] == 0) {
79             return addr;
80         } else {
81             return managers[addr];
82         }
83     }
84 
85     /// @notice Sets an external `manager` that will be able to call `setInterfaceImplementer()`
86     ///  on behalf of the address.
87     /// @param addr Address that you are defining the manager for.
88     /// @param newManager The address of the manager for the `addr` that will replace
89     ///  the old one.  Set to 0x0 if you want to remove the manager.
90     function setManager(address addr, address newManager) public canManage(addr) {
91         managers[addr] = newManager == addr ? 0 : newManager;
92         ManagerChanged(addr, newManager);
93     }
94 
95     /// @notice Query if an address implements an interface and thru which contract
96     /// @param addr Address that is being queried for the implementation of an interface
97     /// @param iHash SHA3 of the name of the interface as a string
98     ///  Example `web3.utils.sha3('Ierc777`')`
99     /// @return The address of the contract that implements a speficic interface
100     ///  or 0x0 if `addr` does not implement this interface
101     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address) {
102         return interfaces[addr][iHash];
103     }
104 
105     /// @notice Sets the contract that will handle a specific interface; only
106     ///  the address itself or a `manager` defined for that address can set it
107     /// @param addr Address that you want to define the interface for
108     /// @param iHash SHA3 of the name of the interface as a string
109     ///  For example `web3.utils.sha3('Ierc777')` for the Ierc777
110     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public canManage(addr)  {
111         if ((implementer != 0) && (implementer!=msg.sender)) {
112             require(EIP820ImplementerInterface(implementer).canImplementInterfaceForAddress(addr, iHash));
113         }
114         interfaces[addr][iHash] = implementer;
115         InterfaceImplementerSet(addr, iHash, implementer);
116     }
117 
118     event InterfaceImplementerSet(address indexed addr, bytes32 indexed interfaceHash, address indexed implementer);
119     event ManagerChanged(address indexed addr, address indexed newManager);
120 }
121 
122 contract EIP820Implementer {
123     EIP820Registry eip820Registry = EIP820Registry(0x9aA513f1294c8f1B254bA1188991B4cc2EFE1D3B);
124 
125     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
126         bytes32 ifaceHash = keccak256(ifaceLabel);
127         eip820Registry.setInterfaceImplementer(this, ifaceHash, impl);
128     }
129 
130     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
131         bytes32 ifaceHash = keccak256(ifaceLabel);
132         return eip820Registry.getInterfaceImplementer(addr, ifaceHash);
133     }
134 
135     function delegateManagement(address newManager) internal {
136         eip820Registry.setManager(this, newManager);
137     }
138 
139 }
140 
141 
142 
143 contract AssetRegistryStorage {
144 
145   string internal _name;
146   string internal _symbol;
147   string internal _description;
148 
149   /**
150    * Stores the total count of assets managed by this registry
151    */
152   uint256 internal _count;
153 
154   /**
155    * Stores an array of assets owned by a given account
156    */
157   mapping(address => uint256[]) internal _assetsOf;
158 
159   /**
160    * Stores the current holder of an asset
161    */
162   mapping(uint256 => address) internal _holderOf;
163 
164   /**
165    * Stores the index of an asset in the `_assetsOf` array of its holder
166    */
167   mapping(uint256 => uint256) internal _indexOfAsset;
168 
169   /**
170    * Stores the data associated with an asset
171    */
172   mapping(uint256 => string) internal _assetData;
173 
174   /**
175    * For a given account, for a given operator, store whether that operator is
176    * allowed to transfer and modify assets on behalf of them.
177    */
178   mapping(address => mapping(address => bool)) internal _operators;
179 
180   /**
181    * Simple reentrancy lock
182    */
183   bool internal _reentrancy;
184 
185   /**
186    * Complex reentrancy lock
187    */
188   uint256 internal _reentrancyCount;
189 
190   /**
191    * Approval array
192    */
193   mapping(uint256 => address) internal _approval;
194 }
195 
196 
197 interface IAssetHolder {
198   function onAssetReceived(
199     /* address _assetRegistry == msg.sender */
200     uint256 _assetId,
201     address _previousHolder,
202     address _currentHolder,
203     bytes   _userData,
204     address _operator,
205     bytes   _operatorData
206   ) public;
207 }
208 
209 
210 interface IAssetRegistry {
211 
212   /**
213    * Global Registry getter functions
214    */
215   function name() public view returns (string);
216   function symbol() public view returns (string);
217   function description() public view returns (string);
218   function totalSupply() public view returns (uint256);
219   function decimals() public view returns (uint256);
220 
221   function isERC821() public view returns (bool);
222 
223   /**
224    * Asset-centric getter functions
225    */
226   function exists(uint256 assetId) public view returns (bool);
227 
228   function holderOf(uint256 assetId) public view returns (address);
229   function ownerOf(uint256 assetId) public view returns (address);
230 
231   function safeHolderOf(uint256 assetId) public view returns (address);
232   function safeOwnerOf(uint256 assetId) public view returns (address);
233 
234   function assetData(uint256 assetId) public view returns (string);
235   function safeAssetData(uint256 assetId) public view returns (string);
236 
237   /**
238    * Holder-centric getter functions
239    */
240   function assetCount(address holder) public view returns (uint256);
241   function balanceOf(address holder) public view returns (uint256);
242 
243   function assetByIndex(address holder, uint256 index) public view returns (uint256);
244   function assetsOf(address holder) external view returns (uint256[]);
245 
246   /**
247    * Transfer Operations
248    */
249   function transfer(address to, uint256 assetId) public;
250   function transfer(address to, uint256 assetId, bytes userData) public;
251   function transfer(address to, uint256 assetId, bytes userData, bytes operatorData) public;
252 
253   /**
254    * Authorization operations
255    */
256   function authorizeOperator(address operator, bool authorized) public;
257   function approve(address operator, uint256 assetId) public;
258 
259   /**
260    * Authorization getters
261    */
262   function isOperatorAuthorizedBy(address operator, address assetHolder)
263     public view returns (bool);
264 
265   function approvedFor(uint256 assetId)
266     public view returns (address);
267 
268   function isApprovedFor(address operator, uint256 assetId)
269     public view returns (bool);
270 
271   /**
272    * Events
273    */
274   event Transfer(
275     address indexed from,
276     address indexed to,
277     uint256 indexed assetId,
278     address operator,
279     bytes userData,
280     bytes operatorData
281   );
282   event Update(
283     uint256 indexed assetId,
284     address indexed holder,
285     address indexed operator,
286     string data
287   );
288   event AuthorizeOperator(
289     address indexed operator,
290     address indexed holder,
291     bool authorized
292   );
293   event Approve(
294     address indexed owner,
295     address indexed operator,
296     uint256 indexed assetId
297   );
298 }
299 
300 
301 contract StandardAssetRegistry is AssetRegistryStorage, IAssetRegistry, EIP820Implementer {
302   using SafeMath for uint256;
303 
304   //
305   // Global Getters
306   //
307 
308   function name() public view returns (string) {
309     return _name;
310   }
311 
312   function symbol() public view returns (string) {
313     return _symbol;
314   }
315 
316   function description() public view returns (string) {
317     return _description;
318   }
319 
320   function totalSupply() public view returns (uint256) {
321     return _count;
322   }
323 
324   function decimals() public view returns (uint256) {
325     return 0;
326   }
327 
328   function isERC821() public view returns (bool) {
329     return true;
330   }
331 
332   //
333   // Asset-centric getter functions
334   //
335 
336   function exists(uint256 assetId) public view returns (bool) {
337     return _holderOf[assetId] != 0;
338   }
339 
340   function holderOf(uint256 assetId) public view returns (address) {
341     return _holderOf[assetId];
342   }
343 
344   function ownerOf(uint256 assetId) public view returns (address) {
345     // It's OK to be inefficient here, as this method is for compatibility.
346     // Users should call `holderOf`
347     return holderOf(assetId);
348   }
349 
350   function safeHolderOf(uint256 assetId) public view returns (address) {
351     address holder = _holderOf[assetId];
352     require(holder != 0);
353     return holder;
354   }
355 
356   function safeOwnerOf(uint256 assetId) public view returns (address) {
357     return safeHolderOf(assetId);
358   }
359 
360   function assetData(uint256 assetId) public view returns (string) {
361     return _assetData[assetId];
362   }
363 
364   function safeAssetData(uint256 assetId) public view returns (string) {
365     require(_holderOf[assetId] != 0);
366     return _assetData[assetId];
367   }
368 
369   //
370   // Holder-centric getter functions
371   //
372 
373   function assetCount(address holder) public view returns (uint256) {
374     return _assetsOf[holder].length;
375   }
376 
377   function balanceOf(address holder) public view returns (uint256) {
378     return assetCount(holder);
379   }
380 
381   function assetByIndex(address holder, uint256 index) public view returns (uint256) {
382     require(index < _assetsOf[holder].length);
383     require(index < (1<<127));
384     return _assetsOf[holder][index];
385   }
386 
387   function assetsOf(address holder) external view returns (uint256[]) {
388     return _assetsOf[holder];
389   }
390 
391   //
392   // Authorization getters
393   //
394 
395   function isOperatorAuthorizedBy(address operator, address assetHolder)
396     public view returns (bool)
397   {
398     return _operators[assetHolder][operator];
399   }
400 
401   function approvedFor(uint256 assetId) public view returns (address) {
402     return _approval[assetId];
403   }
404 
405   function isApprovedFor(address operator, uint256 assetId)
406     public view returns (bool)
407   {
408     require(operator != 0);
409     if (operator == holderOf(assetId)) {
410       return true;
411     }
412     return _approval[assetId] == operator;
413   }
414 
415   //
416   // Authorization
417   //
418 
419   function authorizeOperator(address operator, bool authorized) public {
420     if (authorized) {
421       require(!isOperatorAuthorizedBy(operator, msg.sender));
422       _addAuthorization(operator, msg.sender);
423     } else {
424       require(isOperatorAuthorizedBy(operator, msg.sender));
425       _clearAuthorization(operator, msg.sender);
426     }
427     AuthorizeOperator(operator, msg.sender, authorized);
428   }
429 
430   function approve(address operator, uint256 assetId) public {
431     address holder = holderOf(assetId);
432     require(operator != holder);
433     if (approvedFor(assetId) != operator) {
434       _approval[assetId] = operator;
435       Approve(holder, operator, assetId);
436     }
437   }
438 
439   function _addAuthorization(address operator, address holder) private {
440     _operators[holder][operator] = true;
441   }
442 
443   function _clearAuthorization(address operator, address holder) private {
444     _operators[holder][operator] = false;
445   }
446 
447   //
448   // Internal Operations
449   //
450 
451   function _addAssetTo(address to, uint256 assetId) internal {
452     _holderOf[assetId] = to;
453 
454     uint256 length = assetCount(to);
455 
456     _assetsOf[to].push(assetId);
457 
458     _indexOfAsset[assetId] = length;
459 
460     _count = _count.add(1);
461   }
462 
463   function _addAssetTo(address to, uint256 assetId, string data) internal {
464     _addAssetTo(to, assetId);
465 
466     _assetData[assetId] = data;
467   }
468 
469   function _removeAssetFrom(address from, uint256 assetId) internal {
470     uint256 assetIndex = _indexOfAsset[assetId];
471     uint256 lastAssetIndex = assetCount(from).sub(1);
472     uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
473 
474     _holderOf[assetId] = 0;
475 
476     // Insert the last asset into the position previously occupied by the asset to be removed
477     _assetsOf[from][assetIndex] = lastAssetId;
478 
479     // Resize the array
480     _assetsOf[from][lastAssetIndex] = 0;
481     _assetsOf[from].length--;
482 
483     // Remove the array if no more assets are owned to prevent pollution
484     if (_assetsOf[from].length == 0) {
485       delete _assetsOf[from];
486     }
487 
488     // Update the index of positions for the asset
489     _indexOfAsset[assetId] = 0;
490     _indexOfAsset[lastAssetId] = assetIndex;
491 
492     _count = _count.sub(1);
493   }
494 
495   function _clearApproval(address holder, uint256 assetId) internal {
496     if (holderOf(assetId) == holder && _approval[assetId] != 0) {
497       _approval[assetId] = 0;
498       Approve(holder, 0, assetId);
499     }
500   }
501 
502   function _removeAssetData(uint256 assetId) internal {
503     _assetData[assetId] = '';
504   }
505 
506   //
507   // Supply-altering functions
508   //
509 
510   function _generate(uint256 assetId, address beneficiary, string data) internal {
511     require(_holderOf[assetId] == 0);
512 
513     _addAssetTo(beneficiary, assetId, data);
514 
515     Transfer(0, beneficiary, assetId, msg.sender, bytes(data), '');
516   }
517 
518   function _destroy(uint256 assetId) internal {
519     address holder = _holderOf[assetId];
520     require(holder != 0);
521 
522     _removeAssetFrom(holder, assetId);
523     _removeAssetData(assetId);
524 
525     Transfer(holder, 0, assetId, msg.sender, '', '');
526   }
527 
528   //
529   // Transaction related operations
530   //
531 
532   modifier onlyHolder(uint256 assetId) {
533     require(_holderOf[assetId] == msg.sender);
534     _;
535   }
536 
537   modifier onlyOperatorOrHolder(uint256 assetId) {
538     require(
539       _holderOf[assetId] == msg.sender
540       || isOperatorAuthorizedBy(msg.sender, _holderOf[assetId])
541       || isApprovedFor(msg.sender, assetId)
542     );
543     _;
544   }
545 
546   modifier isDestinataryDefined(address destinatary) {
547     require(destinatary != 0);
548     _;
549   }
550 
551   modifier destinataryIsNotHolder(uint256 assetId, address to) {
552     require(_holderOf[assetId] != to);
553     _;
554   }
555 
556   function transfer(address to, uint256 assetId) public {
557     return _doTransfer(to, assetId, '', 0, '');
558   }
559 
560   function transfer(address to, uint256 assetId, bytes userData) public {
561     return _doTransfer(to, assetId, userData, 0, '');
562   }
563 
564   function transfer(address to, uint256 assetId, bytes userData, bytes operatorData) public {
565     return _doTransfer(to, assetId, userData, msg.sender, operatorData);
566   }
567 
568   function _doTransfer(
569     address to, uint256 assetId, bytes userData, address operator, bytes operatorData
570   )
571     isDestinataryDefined(to)
572     destinataryIsNotHolder(assetId, to)
573     onlyOperatorOrHolder(assetId)
574     internal
575   {
576     return _doSend(to, assetId, userData, operator, operatorData);
577   }
578 
579 
580   function _doSend(
581     address to, uint256 assetId, bytes userData, address operator, bytes operatorData
582   )
583     internal
584   {
585     address holder = _holderOf[assetId];
586     _removeAssetFrom(holder, assetId);
587     _clearApproval(holder, assetId);
588     _addAssetTo(to, assetId);
589 
590     if (_isContract(to)) {
591       require(!_reentrancy);
592       _reentrancy = true;
593 
594       address recipient = interfaceAddr(to, 'IAssetHolder');
595       require(recipient != 0);
596 
597       IAssetHolder(recipient).onAssetReceived(assetId, holder, to, userData, operator, operatorData);
598 
599       _reentrancy = false;
600     }
601 
602     Transfer(holder, to, assetId, operator, userData, operatorData);
603   }
604 
605   //
606   // Update related functions
607   //
608 
609   function _update(uint256 assetId, string data) internal {
610     require(exists(assetId));
611     _assetData[assetId] = data;
612     Update(assetId, _holderOf[assetId], msg.sender, data);
613   }
614 
615   //
616   // Utilities
617   //
618 
619   function _isContract(address addr) internal view returns (bool) {
620     uint size;
621     assembly { size := extcodesize(addr) }
622     return size > 0;
623   }
624 }
625 
626 
627 /**
628  * @title Roles
629  * @author Francisco Giordano (@frangio)
630  * @dev Library for managing addresses assigned to a Role.
631  *      See RBAC.sol for example usage.
632  */
633 library Roles {
634   struct Role {
635     mapping (address => bool) bearer;
636   }
637 
638   /**
639    * @dev give an address access to this role
640    */
641   function add(Role storage role, address addr)
642     internal
643   {
644     role.bearer[addr] = true;
645   }
646 
647   /**
648    * @dev remove an address' access to this role
649    */
650   function remove(Role storage role, address addr)
651     internal
652   {
653     role.bearer[addr] = false;
654   }
655 
656   /**
657    * @dev check if an address has this role
658    * // reverts
659    */
660   function check(Role storage role, address addr)
661     view
662     internal
663   {
664     require(has(role, addr));
665   }
666 
667   /**
668    * @dev check if an address has this role
669    * @return bool
670    */
671   function has(Role storage role, address addr)
672     view
673     internal
674     returns (bool)
675   {
676     return role.bearer[addr];
677   }
678 }
679 
680 
681 
682 /**
683  * @title RBAC (Role-Based Access Control)
684  * @author Matt Condon (@Shrugs)
685  * @dev Stores and provides setters and getters for roles and addresses.
686  *      Supports unlimited numbers of roles and addresses.
687  *      See //contracts/mocks/RBACMock.sol for an example of usage.
688  * This RBAC method uses strings to key roles. It may be beneficial
689  *  for you to write your own implementation of this interface using Enums or similar.
690  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
691  *  to avoid typos.
692  */
693 contract RBAC {
694   using Roles for Roles.Role;
695 
696   mapping (string => Roles.Role) private roles;
697 
698   event RoleAdded(address addr, string roleName);
699   event RoleRemoved(address addr, string roleName);
700 
701   /**
702    * A constant role name for indicating admins.
703    */
704   string public constant ROLE_ADMIN = "admin";
705 
706   /**
707    * @dev constructor. Sets msg.sender as admin by default
708    */
709   function RBAC()
710     public
711   {
712     addRole(msg.sender, ROLE_ADMIN);
713   }
714 
715   /**
716    * @dev reverts if addr does not have role
717    * @param addr address
718    * @param roleName the name of the role
719    * // reverts
720    */
721   function checkRole(address addr, string roleName)
722     view
723     public
724   {
725     roles[roleName].check(addr);
726   }
727 
728   /**
729    * @dev determine if addr has role
730    * @param addr address
731    * @param roleName the name of the role
732    * @return bool
733    */
734   function hasRole(address addr, string roleName)
735     view
736     public
737     returns (bool)
738   {
739     return roles[roleName].has(addr);
740   }
741 
742   /**
743    * @dev add a role to an address
744    * @param addr address
745    * @param roleName the name of the role
746    */
747   function adminAddRole(address addr, string roleName)
748     onlyAdmin
749     public
750   {
751     addRole(addr, roleName);
752   }
753 
754   /**
755    * @dev remove a role from an address
756    * @param addr address
757    * @param roleName the name of the role
758    */
759   function adminRemoveRole(address addr, string roleName)
760     onlyAdmin
761     public
762   {
763     removeRole(addr, roleName);
764   }
765 
766   /**
767    * @dev add a role to an address
768    * @param addr address
769    * @param roleName the name of the role
770    */
771   function addRole(address addr, string roleName)
772     internal
773   {
774     roles[roleName].add(addr);
775     RoleAdded(addr, roleName);
776   }
777 
778   /**
779    * @dev remove a role from an address
780    * @param addr address
781    * @param roleName the name of the role
782    */
783   function removeRole(address addr, string roleName)
784     internal
785   {
786     roles[roleName].remove(addr);
787     RoleRemoved(addr, roleName);
788   }
789 
790   /**
791    * @dev modifier to scope access to a single role (uses msg.sender as addr)
792    * @param roleName the name of the role
793    * // reverts
794    */
795   modifier onlyRole(string roleName)
796   {
797     checkRole(msg.sender, roleName);
798     _;
799   }
800 
801   /**
802    * @dev modifier to scope access to admins
803    * // reverts
804    */
805   modifier onlyAdmin()
806   {
807     checkRole(msg.sender, ROLE_ADMIN);
808     _;
809   }
810 
811   /**
812    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
813    * @param roleNames the names of the roles to scope access to
814    * // reverts
815    *
816    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
817    *  see: https://github.com/ethereum/solidity/issues/2467
818    */
819   // modifier onlyRoles(string[] roleNames) {
820   //     bool hasAnyRole = false;
821   //     for (uint8 i = 0; i < roleNames.length; i++) {
822   //         if (hasRole(msg.sender, roleNames[i])) {
823   //             hasAnyRole = true;
824   //             break;
825   //         }
826   //     }
827 
828   //     require(hasAnyRole);
829 
830   //     _;
831   // }
832 }
833 
834 
835 contract Mintable821 is StandardAssetRegistry, RBAC {
836   event Mint(uint256 assetId, address indexed beneficiary, string data);
837   event MintFinished();
838 
839   uint256 public nextAssetId = 0;
840 
841   string constant ROLE_MINTER = "minter";
842   bool public minting;
843 
844   modifier onlyMinter() {
845     require(
846       hasRole(msg.sender, ROLE_MINTER)
847     );
848     _;
849   }
850 
851   modifier canMint() {
852     require(minting);
853     _;
854   }
855 
856   function Mintable821(address minter) public {
857     _name = "Mintable821";
858     _symbol = "MINT";
859     _description = "ERC 821 minting contract";
860 
861     removeRole(msg.sender, ROLE_ADMIN);
862     addRole(minter, ROLE_MINTER);
863 
864     minting = true;
865   }
866 
867   function isContractProxy(address addr) public view returns (bool) {
868     return _isContract(addr);
869   }
870 
871   function generate(address beneficiary, string data)
872     onlyMinter
873     canMint
874     public
875   {
876     uint256 assetId = nextAssetId;
877     _generate(assetId, beneficiary, data);
878     Mint(assetId, beneficiary, data);
879     nextAssetId = nextAssetId + 1;
880   }
881 
882   // function update(uint256 assetId, string data)
883   //   onlyMinter
884   //   public
885   // {
886   //   _update(assetId, data);
887   // }
888 
889   function transferTo(
890     address to, uint256 assetId, bytes userData, bytes operatorData
891   )
892     public
893   {
894     return transfer(to, assetId, userData, operatorData);
895   }
896 
897   function endMinting()
898     onlyMinter
899     canMint
900     public
901   {
902     minting = false;
903     MintFinished();
904   }
905 }
906 
907 
908 contract XLNTPeople is Mintable821 {
909   function XLNTPeople()
910     Mintable821(msg.sender)
911     public
912   {
913     _name = "XLNTPeople";
914     _symbol = "XLNTPPL";
915     _description = "I found this XLNT Person!";
916   }
917 }