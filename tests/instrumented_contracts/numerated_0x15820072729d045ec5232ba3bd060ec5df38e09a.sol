1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title TavernNFTs - LORDLESS tavern NFTs Contract
5  * TavernNFTs records the relationship of Tavern ownership.
6  * 
7  * ████████╗  █████╗  ██╗   ██╗ ███████╗ ██████╗  ███╗   ██╗ ███╗   ██╗ ███████╗ ████████╗ ███████╗ ██╗
8  * ╚══██╔══╝ ██╔══██╗ ██║   ██║ ██╔════╝ ██╔══██╗ ████╗  ██║ ████╗  ██║ ██╔════╝ ╚══██╔══╝ ██╔════╝ ██║
9  *    ██║    ███████║ ██║   ██║ █████╗   ██████╔╝ ██╔██╗ ██║ ██╔██╗ ██║ █████╗      ██║    ███████╗ ██║
10  *    ██║    ██╔══██║ ╚██╗ ██╔╝ ██╔══╝   ██╔══██╗ ██║╚██╗██║ ██║╚██╗██║ ██╔══╝      ██║    ╚════██║ ╚═╝
11  *    ██║    ██║  ██║  ╚████╔╝  ███████╗ ██║  ██║ ██║ ╚████║ ██║ ╚████║ ██║         ██║    ███████║ ██╗
12  *    ╚═╝    ╚═╝  ╚═╝   ╚═══╝   ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝ ╚═╝  ╚═══╝ ╚═╝         ╚═╝    ╚══════╝ ╚═╝
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
23 // File: node_modules/zeppelin-solidity/contracts/access/rbac/Roles.sol
24 
25 /**
26  * @title Roles
27  * @author Francisco Giordano (@frangio)
28  * @dev Library for managing addresses assigned to a Role.
29  * See RBAC.sol for example usage.
30  */
31 library Roles {
32   struct Role {
33     mapping (address => bool) bearer;
34   }
35 
36   /**
37    * @dev give an address access to this role
38    */
39   function add(Role storage _role, address _addr)
40     internal
41   {
42     _role.bearer[_addr] = true;
43   }
44 
45   /**
46    * @dev remove an address' access to this role
47    */
48   function remove(Role storage _role, address _addr)
49     internal
50   {
51     _role.bearer[_addr] = false;
52   }
53 
54   /**
55    * @dev check if an address has this role
56    * // reverts
57    */
58   function check(Role storage _role, address _addr)
59     internal
60     view
61   {
62     require(has(_role, _addr));
63   }
64 
65   /**
66    * @dev check if an address has this role
67    * @return bool
68    */
69   function has(Role storage _role, address _addr)
70     internal
71     view
72     returns (bool)
73   {
74     return _role.bearer[_addr];
75   }
76 }
77 
78 // File: node_modules/zeppelin-solidity/contracts/access/rbac/RBAC.sol
79 
80 /**
81  * @title RBAC (Role-Based Access Control)
82  * @author Matt Condon (@Shrugs)
83  * @dev Stores and provides setters and getters for roles and addresses.
84  * Supports unlimited numbers of roles and addresses.
85  * See //contracts/mocks/RBACMock.sol for an example of usage.
86  * This RBAC method uses strings to key roles. It may be beneficial
87  * for you to write your own implementation of this interface using Enums or similar.
88  */
89 contract RBAC {
90   using Roles for Roles.Role;
91 
92   mapping (string => Roles.Role) private roles;
93 
94   event RoleAdded(address indexed operator, string role);
95   event RoleRemoved(address indexed operator, string role);
96 
97   /**
98    * @dev reverts if addr does not have role
99    * @param _operator address
100    * @param _role the name of the role
101    * // reverts
102    */
103   function checkRole(address _operator, string _role)
104     public
105     view
106   {
107     roles[_role].check(_operator);
108   }
109 
110   /**
111    * @dev determine if addr has role
112    * @param _operator address
113    * @param _role the name of the role
114    * @return bool
115    */
116   function hasRole(address _operator, string _role)
117     public
118     view
119     returns (bool)
120   {
121     return roles[_role].has(_operator);
122   }
123 
124   /**
125    * @dev add a role to an address
126    * @param _operator address
127    * @param _role the name of the role
128    */
129   function addRole(address _operator, string _role)
130     internal
131   {
132     roles[_role].add(_operator);
133     emit RoleAdded(_operator, _role);
134   }
135 
136   /**
137    * @dev remove a role from an address
138    * @param _operator address
139    * @param _role the name of the role
140    */
141   function removeRole(address _operator, string _role)
142     internal
143   {
144     roles[_role].remove(_operator);
145     emit RoleRemoved(_operator, _role);
146   }
147 
148   /**
149    * @dev modifier to scope access to a single role (uses msg.sender as addr)
150    * @param _role the name of the role
151    * // reverts
152    */
153   modifier onlyRole(string _role)
154   {
155     checkRole(msg.sender, _role);
156     _;
157   }
158 
159   /**
160    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
161    * @param _roles the names of the roles to scope access to
162    * // reverts
163    *
164    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
165    *  see: https://github.com/ethereum/solidity/issues/2467
166    */
167   // modifier onlyRoles(string[] _roles) {
168   //     bool hasAnyRole = false;
169   //     for (uint8 i = 0; i < _roles.length; i++) {
170   //         if (hasRole(msg.sender, _roles[i])) {
171   //             hasAnyRole = true;
172   //             break;
173   //         }
174   //     }
175 
176   //     require(hasAnyRole);
177 
178   //     _;
179   // }
180 }
181 
182 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable {
190   address public owner;
191 
192 
193   event OwnershipRenounced(address indexed previousOwner);
194   event OwnershipTransferred(
195     address indexed previousOwner,
196     address indexed newOwner
197   );
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   constructor() public {
205     owner = msg.sender;
206   }
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216   /**
217    * @dev Allows the current owner to relinquish control of the contract.
218    * @notice Renouncing to ownership will leave the contract without an owner.
219    * It will not be possible to call the functions with the `onlyOwner`
220    * modifier anymore.
221    */
222   function renounceOwnership() public onlyOwner {
223     emit OwnershipRenounced(owner);
224     owner = address(0);
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param _newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address _newOwner) public onlyOwner {
232     _transferOwnership(_newOwner);
233   }
234 
235   /**
236    * @dev Transfers control of the contract to a newOwner.
237    * @param _newOwner The address to transfer ownership to.
238    */
239   function _transferOwnership(address _newOwner) internal {
240     require(_newOwner != address(0));
241     emit OwnershipTransferred(owner, _newOwner);
242     owner = _newOwner;
243   }
244 }
245 
246 // File: node_modules/zeppelin-solidity/contracts/ownership/Superuser.sol
247 
248 /**
249  * @title Superuser
250  * @dev The Superuser contract defines a single superuser who can transfer the ownership
251  * of a contract to a new address, even if he is not the owner.
252  * A superuser can transfer his role to a new address.
253  */
254 contract Superuser is Ownable, RBAC {
255   string public constant ROLE_SUPERUSER = "superuser";
256 
257   constructor () public {
258     addRole(msg.sender, ROLE_SUPERUSER);
259   }
260 
261   /**
262    * @dev Throws if called by any account that's not a superuser.
263    */
264   modifier onlySuperuser() {
265     checkRole(msg.sender, ROLE_SUPERUSER);
266     _;
267   }
268 
269   modifier onlyOwnerOrSuperuser() {
270     require(msg.sender == owner || isSuperuser(msg.sender));
271     _;
272   }
273 
274   /**
275    * @dev getter to determine if address has superuser role
276    */
277   function isSuperuser(address _addr)
278     public
279     view
280     returns (bool)
281   {
282     return hasRole(_addr, ROLE_SUPERUSER);
283   }
284 
285   /**
286    * @dev Allows the current superuser to transfer his role to a newSuperuser.
287    * @param _newSuperuser The address to transfer ownership to.
288    */
289   function transferSuperuser(address _newSuperuser) public onlySuperuser {
290     require(_newSuperuser != address(0));
291     removeRole(msg.sender, ROLE_SUPERUSER);
292     addRole(_newSuperuser, ROLE_SUPERUSER);
293   }
294 
295   /**
296    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
300     _transferOwnership(_newOwner);
301   }
302 }
303 
304 // File: node_modules/zeppelin-solidity/contracts/introspection/ERC165.sol
305 
306 /**
307  * @title ERC165
308  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
309  */
310 interface ERC165 {
311 
312   /**
313    * @notice Query if a contract implements an interface
314    * @param _interfaceId The interface identifier, as specified in ERC-165
315    * @dev Interface identification is specified in ERC-165. This function
316    * uses less than 30,000 gas.
317    */
318   function supportsInterface(bytes4 _interfaceId)
319     external
320     view
321     returns (bool);
322 }
323 
324 // File: node_modules/zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
325 
326 /**
327  * @title SupportsInterfaceWithLookup
328  * @author Matt Condon (@shrugs)
329  * @dev Implements ERC165 using a lookup table.
330  */
331 contract SupportsInterfaceWithLookup is ERC165 {
332 
333   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
334   /**
335    * 0x01ffc9a7 ===
336    *   bytes4(keccak256('supportsInterface(bytes4)'))
337    */
338 
339   /**
340    * @dev a mapping of interface id to whether or not it's supported
341    */
342   mapping(bytes4 => bool) internal supportedInterfaces;
343 
344   /**
345    * @dev A contract implementing SupportsInterfaceWithLookup
346    * implement ERC165 itself
347    */
348   constructor()
349     public
350   {
351     _registerInterface(InterfaceId_ERC165);
352   }
353 
354   /**
355    * @dev implement supportsInterface(bytes4) using a lookup table
356    */
357   function supportsInterface(bytes4 _interfaceId)
358     external
359     view
360     returns (bool)
361   {
362     return supportedInterfaces[_interfaceId];
363   }
364 
365   /**
366    * @dev private method for registering an interface
367    */
368   function _registerInterface(bytes4 _interfaceId)
369     internal
370   {
371     require(_interfaceId != 0xffffffff);
372     supportedInterfaces[_interfaceId] = true;
373   }
374 }
375 
376 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
377 
378 /**
379  * @title ERC721 Non-Fungible Token Standard basic interface
380  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
381  */
382 contract ERC721Basic is ERC165 {
383 
384   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
385   /*
386    * 0x80ac58cd ===
387    *   bytes4(keccak256('balanceOf(address)')) ^
388    *   bytes4(keccak256('ownerOf(uint256)')) ^
389    *   bytes4(keccak256('approve(address,uint256)')) ^
390    *   bytes4(keccak256('getApproved(uint256)')) ^
391    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
392    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
393    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
394    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
395    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
396    */
397 
398   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
399   /*
400    * 0x4f558e79 ===
401    *   bytes4(keccak256('exists(uint256)'))
402    */
403 
404   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
405   /**
406    * 0x780e9d63 ===
407    *   bytes4(keccak256('totalSupply()')) ^
408    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
409    *   bytes4(keccak256('tokenByIndex(uint256)'))
410    */
411 
412   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
413   /**
414    * 0x5b5e139f ===
415    *   bytes4(keccak256('name()')) ^
416    *   bytes4(keccak256('symbol()')) ^
417    *   bytes4(keccak256('tokenURI(uint256)'))
418    */
419 
420   event Transfer(
421     address indexed _from,
422     address indexed _to,
423     uint256 indexed _tokenId
424   );
425   event Approval(
426     address indexed _owner,
427     address indexed _approved,
428     uint256 indexed _tokenId
429   );
430   event ApprovalForAll(
431     address indexed _owner,
432     address indexed _operator,
433     bool _approved
434   );
435 
436   function balanceOf(address _owner) public view returns (uint256 _balance);
437   function ownerOf(uint256 _tokenId) public view returns (address _owner);
438   function exists(uint256 _tokenId) public view returns (bool _exists);
439 
440   function approve(address _to, uint256 _tokenId) public;
441   function getApproved(uint256 _tokenId)
442     public view returns (address _operator);
443 
444   function setApprovalForAll(address _operator, bool _approved) public;
445   function isApprovedForAll(address _owner, address _operator)
446     public view returns (bool);
447 
448   function transferFrom(address _from, address _to, uint256 _tokenId) public;
449   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
450     public;
451 
452   function safeTransferFrom(
453     address _from,
454     address _to,
455     uint256 _tokenId,
456     bytes _data
457   )
458     public;
459 }
460 
461 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721.sol
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
465  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
466  */
467 contract ERC721Enumerable is ERC721Basic {
468   function totalSupply() public view returns (uint256);
469   function tokenOfOwnerByIndex(
470     address _owner,
471     uint256 _index
472   )
473     public
474     view
475     returns (uint256 _tokenId);
476 
477   function tokenByIndex(uint256 _index) public view returns (uint256);
478 }
479 
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
483  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
484  */
485 contract ERC721Metadata is ERC721Basic {
486   function name() external view returns (string _name);
487   function symbol() external view returns (string _symbol);
488   function tokenURI(uint256 _tokenId) public view returns (string);
489 }
490 
491 
492 /**
493  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
494  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
495  */
496 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
497 }
498 
499 // File: node_modules/zeppelin-solidity/contracts/AddressUtils.sol
500 
501 /**
502  * Utility library of inline functions on addresses
503  */
504 library AddressUtils {
505 
506   /**
507    * Returns whether the target address is a contract
508    * @dev This function will return false if invoked during the constructor of a contract,
509    * as the code is not actually created until after the constructor finishes.
510    * @param _addr address to check
511    * @return whether the target address is a contract
512    */
513   function isContract(address _addr) internal view returns (bool) {
514     uint256 size;
515     // XXX Currently there is no better way to check if there is a contract in an address
516     // than to check the size of the code at that address.
517     // See https://ethereum.stackexchange.com/a/14016/36603
518     // for more details about how this works.
519     // TODO Check this again before the Serenity release, because all addresses will be
520     // contracts then.
521     // solium-disable-next-line security/no-inline-assembly
522     assembly { size := extcodesize(_addr) }
523     return size > 0;
524   }
525 
526 }
527 
528 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
529 
530 /**
531  * @title SafeMath
532  * @dev Math operations with safety checks that throw on error
533  */
534 library SafeMath {
535 
536   /**
537   * @dev Multiplies two numbers, throws on overflow.
538   */
539   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
540     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
541     // benefit is lost if 'b' is also tested.
542     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
543     if (_a == 0) {
544       return 0;
545     }
546 
547     c = _a * _b;
548     assert(c / _a == _b);
549     return c;
550   }
551 
552   /**
553   * @dev Integer division of two numbers, truncating the quotient.
554   */
555   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
556     // assert(_b > 0); // Solidity automatically throws when dividing by 0
557     // uint256 c = _a / _b;
558     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
559     return _a / _b;
560   }
561 
562   /**
563   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
564   */
565   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
566     assert(_b <= _a);
567     return _a - _b;
568   }
569 
570   /**
571   * @dev Adds two numbers, throws on overflow.
572   */
573   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
574     c = _a + _b;
575     assert(c >= _a);
576     return c;
577   }
578 }
579 
580 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
581 
582 /**
583  * @title ERC721 token receiver interface
584  * @dev Interface for any contract that wants to support safeTransfers
585  * from ERC721 asset contracts.
586  */
587 contract ERC721Receiver {
588   /**
589    * @dev Magic value to be returned upon successful reception of an NFT
590    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
591    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
592    */
593   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
594 
595   /**
596    * @notice Handle the receipt of an NFT
597    * @dev The ERC721 smart contract calls this function on the recipient
598    * after a `safetransfer`. This function MAY throw to revert and reject the
599    * transfer. Return of other than the magic value MUST result in the
600    * transaction being reverted.
601    * Note: the contract address is always the message sender.
602    * @param _operator The address which called `safeTransferFrom` function
603    * @param _from The address which previously owned the token
604    * @param _tokenId The NFT identifier which is being transferred
605    * @param _data Additional data with no specified format
606    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
607    */
608   function onERC721Received(
609     address _operator,
610     address _from,
611     uint256 _tokenId,
612     bytes _data
613   )
614     public
615     returns(bytes4);
616 }
617 
618 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
619 
620 /**
621  * @title ERC721 Non-Fungible Token Standard basic implementation
622  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
623  */
624 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
625 
626   using SafeMath for uint256;
627   using AddressUtils for address;
628 
629   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
630   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
631   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
632 
633   // Mapping from token ID to owner
634   mapping (uint256 => address) internal tokenOwner;
635 
636   // Mapping from token ID to approved address
637   mapping (uint256 => address) internal tokenApprovals;
638 
639   // Mapping from owner to number of owned token
640   mapping (address => uint256) internal ownedTokensCount;
641 
642   // Mapping from owner to operator approvals
643   mapping (address => mapping (address => bool)) internal operatorApprovals;
644 
645   constructor()
646     public
647   {
648     // register the supported interfaces to conform to ERC721 via ERC165
649     _registerInterface(InterfaceId_ERC721);
650     _registerInterface(InterfaceId_ERC721Exists);
651   }
652 
653   /**
654    * @dev Gets the balance of the specified address
655    * @param _owner address to query the balance of
656    * @return uint256 representing the amount owned by the passed address
657    */
658   function balanceOf(address _owner) public view returns (uint256) {
659     require(_owner != address(0));
660     return ownedTokensCount[_owner];
661   }
662 
663   /**
664    * @dev Gets the owner of the specified token ID
665    * @param _tokenId uint256 ID of the token to query the owner of
666    * @return owner address currently marked as the owner of the given token ID
667    */
668   function ownerOf(uint256 _tokenId) public view returns (address) {
669     address owner = tokenOwner[_tokenId];
670     require(owner != address(0));
671     return owner;
672   }
673 
674   /**
675    * @dev Returns whether the specified token exists
676    * @param _tokenId uint256 ID of the token to query the existence of
677    * @return whether the token exists
678    */
679   function exists(uint256 _tokenId) public view returns (bool) {
680     address owner = tokenOwner[_tokenId];
681     return owner != address(0);
682   }
683 
684   /**
685    * @dev Approves another address to transfer the given token ID
686    * The zero address indicates there is no approved address.
687    * There can only be one approved address per token at a given time.
688    * Can only be called by the token owner or an approved operator.
689    * @param _to address to be approved for the given token ID
690    * @param _tokenId uint256 ID of the token to be approved
691    */
692   function approve(address _to, uint256 _tokenId) public {
693     address owner = ownerOf(_tokenId);
694     require(_to != owner);
695     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
696 
697     tokenApprovals[_tokenId] = _to;
698     emit Approval(owner, _to, _tokenId);
699   }
700 
701   /**
702    * @dev Gets the approved address for a token ID, or zero if no address set
703    * @param _tokenId uint256 ID of the token to query the approval of
704    * @return address currently approved for the given token ID
705    */
706   function getApproved(uint256 _tokenId) public view returns (address) {
707     return tokenApprovals[_tokenId];
708   }
709 
710   /**
711    * @dev Sets or unsets the approval of a given operator
712    * An operator is allowed to transfer all tokens of the sender on their behalf
713    * @param _to operator address to set the approval
714    * @param _approved representing the status of the approval to be set
715    */
716   function setApprovalForAll(address _to, bool _approved) public {
717     require(_to != msg.sender);
718     operatorApprovals[msg.sender][_to] = _approved;
719     emit ApprovalForAll(msg.sender, _to, _approved);
720   }
721 
722   /**
723    * @dev Tells whether an operator is approved by a given owner
724    * @param _owner owner address which you want to query the approval of
725    * @param _operator operator address which you want to query the approval of
726    * @return bool whether the given operator is approved by the given owner
727    */
728   function isApprovedForAll(
729     address _owner,
730     address _operator
731   )
732     public
733     view
734     returns (bool)
735   {
736     return operatorApprovals[_owner][_operator];
737   }
738 
739   /**
740    * @dev Transfers the ownership of a given token ID to another address
741    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
742    * Requires the msg sender to be the owner, approved, or operator
743    * @param _from current owner of the token
744    * @param _to address to receive the ownership of the given token ID
745    * @param _tokenId uint256 ID of the token to be transferred
746   */
747   function transferFrom(
748     address _from,
749     address _to,
750     uint256 _tokenId
751   )
752     public
753   {
754     require(isApprovedOrOwner(msg.sender, _tokenId));
755     require(_from != address(0));
756     require(_to != address(0));
757 
758     clearApproval(_from, _tokenId);
759     removeTokenFrom(_from, _tokenId);
760     addTokenTo(_to, _tokenId);
761 
762     emit Transfer(_from, _to, _tokenId);
763   }
764 
765   /**
766    * @dev Safely transfers the ownership of a given token ID to another address
767    * If the target address is a contract, it must implement `onERC721Received`,
768    * which is called upon a safe transfer, and return the magic value
769    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
770    * the transfer is reverted.
771    *
772    * Requires the msg sender to be the owner, approved, or operator
773    * @param _from current owner of the token
774    * @param _to address to receive the ownership of the given token ID
775    * @param _tokenId uint256 ID of the token to be transferred
776   */
777   function safeTransferFrom(
778     address _from,
779     address _to,
780     uint256 _tokenId
781   )
782     public
783   {
784     // solium-disable-next-line arg-overflow
785     safeTransferFrom(_from, _to, _tokenId, "");
786   }
787 
788   /**
789    * @dev Safely transfers the ownership of a given token ID to another address
790    * If the target address is a contract, it must implement `onERC721Received`,
791    * which is called upon a safe transfer, and return the magic value
792    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
793    * the transfer is reverted.
794    * Requires the msg sender to be the owner, approved, or operator
795    * @param _from current owner of the token
796    * @param _to address to receive the ownership of the given token ID
797    * @param _tokenId uint256 ID of the token to be transferred
798    * @param _data bytes data to send along with a safe transfer check
799    */
800   function safeTransferFrom(
801     address _from,
802     address _to,
803     uint256 _tokenId,
804     bytes _data
805   )
806     public
807   {
808     transferFrom(_from, _to, _tokenId);
809     // solium-disable-next-line arg-overflow
810     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
811   }
812 
813   /**
814    * @dev Returns whether the given spender can transfer a given token ID
815    * @param _spender address of the spender to query
816    * @param _tokenId uint256 ID of the token to be transferred
817    * @return bool whether the msg.sender is approved for the given token ID,
818    *  is an operator of the owner, or is the owner of the token
819    */
820   function isApprovedOrOwner(
821     address _spender,
822     uint256 _tokenId
823   )
824     internal
825     view
826     returns (bool)
827   {
828     address owner = ownerOf(_tokenId);
829     // Disable solium check because of
830     // https://github.com/duaraghav8/Solium/issues/175
831     // solium-disable-next-line operator-whitespace
832     return (
833       _spender == owner ||
834       getApproved(_tokenId) == _spender ||
835       isApprovedForAll(owner, _spender)
836     );
837   }
838 
839   /**
840    * @dev Internal function to mint a new token
841    * Reverts if the given token ID already exists
842    * @param _to The address that will own the minted token
843    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
844    */
845   function _mint(address _to, uint256 _tokenId) internal {
846     require(_to != address(0));
847     addTokenTo(_to, _tokenId);
848     emit Transfer(address(0), _to, _tokenId);
849   }
850 
851   /**
852    * @dev Internal function to burn a specific token
853    * Reverts if the token does not exist
854    * @param _tokenId uint256 ID of the token being burned by the msg.sender
855    */
856   function _burn(address _owner, uint256 _tokenId) internal {
857     clearApproval(_owner, _tokenId);
858     removeTokenFrom(_owner, _tokenId);
859     emit Transfer(_owner, address(0), _tokenId);
860   }
861 
862   /**
863    * @dev Internal function to clear current approval of a given token ID
864    * Reverts if the given address is not indeed the owner of the token
865    * @param _owner owner of the token
866    * @param _tokenId uint256 ID of the token to be transferred
867    */
868   function clearApproval(address _owner, uint256 _tokenId) internal {
869     require(ownerOf(_tokenId) == _owner);
870     if (tokenApprovals[_tokenId] != address(0)) {
871       tokenApprovals[_tokenId] = address(0);
872     }
873   }
874 
875   /**
876    * @dev Internal function to add a token ID to the list of a given address
877    * @param _to address representing the new owner of the given token ID
878    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
879    */
880   function addTokenTo(address _to, uint256 _tokenId) internal {
881     require(tokenOwner[_tokenId] == address(0));
882     tokenOwner[_tokenId] = _to;
883     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
884   }
885 
886   /**
887    * @dev Internal function to remove a token ID from the list of a given address
888    * @param _from address representing the previous owner of the given token ID
889    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
890    */
891   function removeTokenFrom(address _from, uint256 _tokenId) internal {
892     require(ownerOf(_tokenId) == _from);
893     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
894     tokenOwner[_tokenId] = address(0);
895   }
896 
897   /**
898    * @dev Internal function to invoke `onERC721Received` on a target address
899    * The call is not executed if the target address is not a contract
900    * @param _from address representing the previous owner of the given token ID
901    * @param _to target address that will receive the tokens
902    * @param _tokenId uint256 ID of the token to be transferred
903    * @param _data bytes optional data to send along with the call
904    * @return whether the call correctly returned the expected magic value
905    */
906   function checkAndCallSafeTransfer(
907     address _from,
908     address _to,
909     uint256 _tokenId,
910     bytes _data
911   )
912     internal
913     returns (bool)
914   {
915     if (!_to.isContract()) {
916       return true;
917     }
918     bytes4 retval = ERC721Receiver(_to).onERC721Received(
919       msg.sender, _from, _tokenId, _data);
920     return (retval == ERC721_RECEIVED);
921   }
922 }
923 
924 // File: node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
925 
926 /**
927  * @title Full ERC721 Token
928  * This implementation includes all the required and some optional functionality of the ERC721 standard
929  * Moreover, it includes approve all functionality using operator terminology
930  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
931  */
932 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
933 
934   // Token name
935   string internal name_;
936 
937   // Token symbol
938   string internal symbol_;
939 
940   // Mapping from owner to list of owned token IDs
941   mapping(address => uint256[]) internal ownedTokens;
942 
943   // Mapping from token ID to index of the owner tokens list
944   mapping(uint256 => uint256) internal ownedTokensIndex;
945 
946   // Array with all token ids, used for enumeration
947   uint256[] internal allTokens;
948 
949   // Mapping from token id to position in the allTokens array
950   mapping(uint256 => uint256) internal allTokensIndex;
951 
952   // Optional mapping for token URIs
953   mapping(uint256 => string) internal tokenURIs;
954 
955   /**
956    * @dev Constructor function
957    */
958   constructor(string _name, string _symbol) public {
959     name_ = _name;
960     symbol_ = _symbol;
961 
962     // register the supported interfaces to conform to ERC721 via ERC165
963     _registerInterface(InterfaceId_ERC721Enumerable);
964     _registerInterface(InterfaceId_ERC721Metadata);
965   }
966 
967   /**
968    * @dev Gets the token name
969    * @return string representing the token name
970    */
971   function name() external view returns (string) {
972     return name_;
973   }
974 
975   /**
976    * @dev Gets the token symbol
977    * @return string representing the token symbol
978    */
979   function symbol() external view returns (string) {
980     return symbol_;
981   }
982 
983   /**
984    * @dev Returns an URI for a given token ID
985    * Throws if the token ID does not exist. May return an empty string.
986    * @param _tokenId uint256 ID of the token to query
987    */
988   function tokenURI(uint256 _tokenId) public view returns (string) {
989     require(exists(_tokenId));
990     return tokenURIs[_tokenId];
991   }
992 
993   /**
994    * @dev Gets the token ID at a given index of the tokens list of the requested owner
995    * @param _owner address owning the tokens list to be accessed
996    * @param _index uint256 representing the index to be accessed of the requested tokens list
997    * @return uint256 token ID at the given index of the tokens list owned by the requested address
998    */
999   function tokenOfOwnerByIndex(
1000     address _owner,
1001     uint256 _index
1002   )
1003     public
1004     view
1005     returns (uint256)
1006   {
1007     require(_index < balanceOf(_owner));
1008     return ownedTokens[_owner][_index];
1009   }
1010 
1011   /**
1012    * @dev Gets the total amount of tokens stored by the contract
1013    * @return uint256 representing the total amount of tokens
1014    */
1015   function totalSupply() public view returns (uint256) {
1016     return allTokens.length;
1017   }
1018 
1019   /**
1020    * @dev Gets the token ID at a given index of all the tokens in this contract
1021    * Reverts if the index is greater or equal to the total number of tokens
1022    * @param _index uint256 representing the index to be accessed of the tokens list
1023    * @return uint256 token ID at the given index of the tokens list
1024    */
1025   function tokenByIndex(uint256 _index) public view returns (uint256) {
1026     require(_index < totalSupply());
1027     return allTokens[_index];
1028   }
1029 
1030   /**
1031    * @dev Internal function to set the token URI for a given token
1032    * Reverts if the token ID does not exist
1033    * @param _tokenId uint256 ID of the token to set its URI
1034    * @param _uri string URI to assign
1035    */
1036   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1037     require(exists(_tokenId));
1038     tokenURIs[_tokenId] = _uri;
1039   }
1040 
1041   /**
1042    * @dev Internal function to add a token ID to the list of a given address
1043    * @param _to address representing the new owner of the given token ID
1044    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1045    */
1046   function addTokenTo(address _to, uint256 _tokenId) internal {
1047     super.addTokenTo(_to, _tokenId);
1048     uint256 length = ownedTokens[_to].length;
1049     ownedTokens[_to].push(_tokenId);
1050     ownedTokensIndex[_tokenId] = length;
1051   }
1052 
1053   /**
1054    * @dev Internal function to remove a token ID from the list of a given address
1055    * @param _from address representing the previous owner of the given token ID
1056    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1057    */
1058   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1059     super.removeTokenFrom(_from, _tokenId);
1060 
1061     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1062     // then delete the last slot.
1063     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1064     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1065     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1066 
1067     ownedTokens[_from][tokenIndex] = lastToken;
1068     // This also deletes the contents at the last position of the array
1069     ownedTokens[_from].length--;
1070 
1071     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1072     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1073     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1074 
1075     ownedTokensIndex[_tokenId] = 0;
1076     ownedTokensIndex[lastToken] = tokenIndex;
1077   }
1078 
1079   /**
1080    * @dev Internal function to mint a new token
1081    * Reverts if the given token ID already exists
1082    * @param _to address the beneficiary that will own the minted token
1083    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1084    */
1085   function _mint(address _to, uint256 _tokenId) internal {
1086     super._mint(_to, _tokenId);
1087 
1088     allTokensIndex[_tokenId] = allTokens.length;
1089     allTokens.push(_tokenId);
1090   }
1091 
1092   /**
1093    * @dev Internal function to burn a specific token
1094    * Reverts if the token does not exist
1095    * @param _owner owner of the token to burn
1096    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1097    */
1098   function _burn(address _owner, uint256 _tokenId) internal {
1099     super._burn(_owner, _tokenId);
1100 
1101     // Clear metadata (if any)
1102     if (bytes(tokenURIs[_tokenId]).length != 0) {
1103       delete tokenURIs[_tokenId];
1104     }
1105 
1106     // Reorg all tokens array
1107     uint256 tokenIndex = allTokensIndex[_tokenId];
1108     uint256 lastTokenIndex = allTokens.length.sub(1);
1109     uint256 lastToken = allTokens[lastTokenIndex];
1110 
1111     allTokens[tokenIndex] = lastToken;
1112     allTokens[lastTokenIndex] = 0;
1113 
1114     allTokens.length--;
1115     allTokensIndex[_tokenId] = 0;
1116     allTokensIndex[lastToken] = tokenIndex;
1117   }
1118 
1119 }
1120 
1121 // File: contracts/nft/ITavernNFTs.sol
1122 
1123 contract ITavernNFTs is ERC721 {
1124   function setTavernContract(address tavern) external;
1125   function mint(address to, uint256 tokenId) public;
1126   function batchMint(address[] tos, uint256[] tokenIds) external;
1127   function burn(uint256 tokenId) public;
1128   function setTokenURI(uint256 tokenId, string uri) public;
1129   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256);
1130 
1131   /* Events */
1132 
1133   event SetTavernContract (
1134     address tavern
1135   );
1136 
1137 }
1138 
1139 // File: contracts/nft/TavernNFTs.sol
1140 
1141 
1142 interface TavernInterface {
1143   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256);
1144 }
1145 
1146 contract TavernNFTs is ERC721Token, Superuser, ITavernNFTs {
1147   constructor(string name, string symbol) public
1148     ERC721Token(name, symbol)
1149   { }
1150 
1151   TavernInterface public tavernContract;
1152   uint16 public constant MAX_SUPPLY = 4000;  // Tavern MAX SUPPLY
1153 
1154   /**
1155    * @dev set the Tavern contract address
1156    * @return tavern Tavern contract address
1157    */
1158   function setTavernContract(address tavern) onlySuperuser external {
1159     tavernContract = TavernInterface(tavern);
1160     emit SetTavernContract(tavern);
1161   }
1162   
1163   function mint(address to, uint256 tokenId) onlySuperuser public {
1164     require(tokenId < MAX_SUPPLY);
1165     super._mint(to, tokenId);
1166   }
1167 
1168   function batchMint(address[] tos, uint256[] tokenIds) onlySuperuser external {
1169     uint256 i = 0;
1170     while (i < tokenIds.length) {
1171       super._mint(tos[i], tokenIds[i]);
1172       i += 1;
1173     }
1174   }
1175 
1176   function burn(uint256 tokenId) onlySuperuser public {
1177     super._burn(ownerOf(tokenId), tokenId);
1178   }
1179   
1180   /**
1181    * @dev Future use on ipfs or other decentralized storage platforms
1182    */
1183   function setTokenURI(uint256 _tokenId, string _uri) onlyOwnerOrSuperuser public {
1184     super._setTokenURI(_tokenId, _uri);
1185   }
1186 
1187   /**
1188    * @dev get a Tavern's infomation 
1189    * @param tokenId tokenId
1190    * @return uint256 Tavern's construction time
1191    * @return int Tavern's longitude value 
1192    * @return int Tavern's latitude value
1193    * @return uint8 Tavern's popularity
1194    * @return uint256 Tavern's activeness
1195    */
1196   function tavern(uint256 tokenId) external view returns (uint256, int, int, uint8, uint256){
1197     return tavernContract.tavern(tokenId);
1198   }
1199 
1200 }