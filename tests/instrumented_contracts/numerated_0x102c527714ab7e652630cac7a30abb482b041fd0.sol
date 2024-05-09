1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
120 
121 /**
122  * @title Roles
123  * @author Francisco Giordano (@frangio)
124  * @dev Library for managing addresses assigned to a Role.
125  * See RBAC.sol for example usage.
126  */
127 library Roles {
128   struct Role {
129     mapping (address => bool) bearer;
130   }
131 
132   /**
133    * @dev give an address access to this role
134    */
135   function add(Role storage _role, address _addr)
136     internal
137   {
138     _role.bearer[_addr] = true;
139   }
140 
141   /**
142    * @dev remove an address' access to this role
143    */
144   function remove(Role storage _role, address _addr)
145     internal
146   {
147     _role.bearer[_addr] = false;
148   }
149 
150   /**
151    * @dev check if an address has this role
152    * // reverts
153    */
154   function check(Role storage _role, address _addr)
155     internal
156     view
157   {
158     require(has(_role, _addr));
159   }
160 
161   /**
162    * @dev check if an address has this role
163    * @return bool
164    */
165   function has(Role storage _role, address _addr)
166     internal
167     view
168     returns (bool)
169   {
170     return _role.bearer[_addr];
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
175 
176 /**
177  * @title RBAC (Role-Based Access Control)
178  * @author Matt Condon (@Shrugs)
179  * @dev Stores and provides setters and getters for roles and addresses.
180  * Supports unlimited numbers of roles and addresses.
181  * See //contracts/mocks/RBACMock.sol for an example of usage.
182  * This RBAC method uses strings to key roles. It may be beneficial
183  * for you to write your own implementation of this interface using Enums or similar.
184  */
185 contract RBAC {
186   using Roles for Roles.Role;
187 
188   mapping (string => Roles.Role) private roles;
189 
190   event RoleAdded(address indexed operator, string role);
191   event RoleRemoved(address indexed operator, string role);
192 
193   /**
194    * @dev reverts if addr does not have role
195    * @param _operator address
196    * @param _role the name of the role
197    * // reverts
198    */
199   function checkRole(address _operator, string _role)
200     public
201     view
202   {
203     roles[_role].check(_operator);
204   }
205 
206   /**
207    * @dev determine if addr has role
208    * @param _operator address
209    * @param _role the name of the role
210    * @return bool
211    */
212   function hasRole(address _operator, string _role)
213     public
214     view
215     returns (bool)
216   {
217     return roles[_role].has(_operator);
218   }
219 
220   /**
221    * @dev add a role to an address
222    * @param _operator address
223    * @param _role the name of the role
224    */
225   function addRole(address _operator, string _role)
226     internal
227   {
228     roles[_role].add(_operator);
229     emit RoleAdded(_operator, _role);
230   }
231 
232   /**
233    * @dev remove a role from an address
234    * @param _operator address
235    * @param _role the name of the role
236    */
237   function removeRole(address _operator, string _role)
238     internal
239   {
240     roles[_role].remove(_operator);
241     emit RoleRemoved(_operator, _role);
242   }
243 
244   /**
245    * @dev modifier to scope access to a single role (uses msg.sender as addr)
246    * @param _role the name of the role
247    * // reverts
248    */
249   modifier onlyRole(string _role)
250   {
251     checkRole(msg.sender, _role);
252     _;
253   }
254 
255   /**
256    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
257    * @param _roles the names of the roles to scope access to
258    * // reverts
259    *
260    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
261    *  see: https://github.com/ethereum/solidity/issues/2467
262    */
263   // modifier onlyRoles(string[] _roles) {
264   //     bool hasAnyRole = false;
265   //     for (uint8 i = 0; i < _roles.length; i++) {
266   //         if (hasRole(msg.sender, _roles[i])) {
267   //             hasAnyRole = true;
268   //             break;
269   //         }
270   //     }
271 
272   //     require(hasAnyRole);
273 
274   //     _;
275   // }
276 }
277 
278 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
279 
280 /**
281  * @title Whitelist
282  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
283  * This simplifies the implementation of "user permissions".
284  */
285 contract Whitelist is Ownable, RBAC {
286   string public constant ROLE_WHITELISTED = "whitelist";
287 
288   /**
289    * @dev Throws if operator is not whitelisted.
290    * @param _operator address
291    */
292   modifier onlyIfWhitelisted(address _operator) {
293     checkRole(_operator, ROLE_WHITELISTED);
294     _;
295   }
296 
297   /**
298    * @dev add an address to the whitelist
299    * @param _operator address
300    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
301    */
302   function addAddressToWhitelist(address _operator)
303     public
304     onlyOwner
305   {
306     addRole(_operator, ROLE_WHITELISTED);
307   }
308 
309   /**
310    * @dev getter to determine if address is in whitelist
311    */
312   function whitelist(address _operator)
313     public
314     view
315     returns (bool)
316   {
317     return hasRole(_operator, ROLE_WHITELISTED);
318   }
319 
320   /**
321    * @dev add addresses to the whitelist
322    * @param _operators addresses
323    * @return true if at least one address was added to the whitelist,
324    * false if all addresses were already in the whitelist
325    */
326   function addAddressesToWhitelist(address[] _operators)
327     public
328     onlyOwner
329   {
330     for (uint256 i = 0; i < _operators.length; i++) {
331       addAddressToWhitelist(_operators[i]);
332     }
333   }
334 
335   /**
336    * @dev remove an address from the whitelist
337    * @param _operator address
338    * @return true if the address was removed from the whitelist,
339    * false if the address wasn't in the whitelist in the first place
340    */
341   function removeAddressFromWhitelist(address _operator)
342     public
343     onlyOwner
344   {
345     removeRole(_operator, ROLE_WHITELISTED);
346   }
347 
348   /**
349    * @dev remove addresses from the whitelist
350    * @param _operators addresses
351    * @return true if at least one address was removed from the whitelist,
352    * false if all addresses weren't in the whitelist in the first place
353    */
354   function removeAddressesFromWhitelist(address[] _operators)
355     public
356     onlyOwner
357   {
358     for (uint256 i = 0; i < _operators.length; i++) {
359       removeAddressFromWhitelist(_operators[i]);
360     }
361   }
362 
363 }
364 
365 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
366 
367 /**
368  * @title ERC165
369  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
370  */
371 interface ERC165 {
372 
373   /**
374    * @notice Query if a contract implements an interface
375    * @param _interfaceId The interface identifier, as specified in ERC-165
376    * @dev Interface identification is specified in ERC-165. This function
377    * uses less than 30,000 gas.
378    */
379   function supportsInterface(bytes4 _interfaceId)
380     external
381     view
382     returns (bool);
383 }
384 
385 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
386 
387 /**
388  * @title ERC721 Non-Fungible Token Standard basic interface
389  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
390  */
391 contract ERC721Basic is ERC165 {
392 
393   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
394   /*
395    * 0x80ac58cd ===
396    *   bytes4(keccak256('balanceOf(address)')) ^
397    *   bytes4(keccak256('ownerOf(uint256)')) ^
398    *   bytes4(keccak256('approve(address,uint256)')) ^
399    *   bytes4(keccak256('getApproved(uint256)')) ^
400    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
401    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
402    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
403    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
404    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
405    */
406 
407   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
408   /*
409    * 0x4f558e79 ===
410    *   bytes4(keccak256('exists(uint256)'))
411    */
412 
413   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
414   /**
415    * 0x780e9d63 ===
416    *   bytes4(keccak256('totalSupply()')) ^
417    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
418    *   bytes4(keccak256('tokenByIndex(uint256)'))
419    */
420 
421   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
422   /**
423    * 0x5b5e139f ===
424    *   bytes4(keccak256('name()')) ^
425    *   bytes4(keccak256('symbol()')) ^
426    *   bytes4(keccak256('tokenURI(uint256)'))
427    */
428 
429   event Transfer(
430     address indexed _from,
431     address indexed _to,
432     uint256 indexed _tokenId
433   );
434   event Approval(
435     address indexed _owner,
436     address indexed _approved,
437     uint256 indexed _tokenId
438   );
439   event ApprovalForAll(
440     address indexed _owner,
441     address indexed _operator,
442     bool _approved
443   );
444 
445   function balanceOf(address _owner) public view returns (uint256 _balance);
446   function ownerOf(uint256 _tokenId) public view returns (address _owner);
447   function exists(uint256 _tokenId) public view returns (bool _exists);
448 
449   function approve(address _to, uint256 _tokenId) public;
450   function getApproved(uint256 _tokenId)
451     public view returns (address _operator);
452 
453   function setApprovalForAll(address _operator, bool _approved) public;
454   function isApprovedForAll(address _owner, address _operator)
455     public view returns (bool);
456 
457   function transferFrom(address _from, address _to, uint256 _tokenId) public;
458   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
459     public;
460 
461   function safeTransferFrom(
462     address _from,
463     address _to,
464     uint256 _tokenId,
465     bytes _data
466   )
467     public;
468 }
469 
470 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
474  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
475  */
476 contract ERC721Enumerable is ERC721Basic {
477   function totalSupply() public view returns (uint256);
478   function tokenOfOwnerByIndex(
479     address _owner,
480     uint256 _index
481   )
482     public
483     view
484     returns (uint256 _tokenId);
485 
486   function tokenByIndex(uint256 _index) public view returns (uint256);
487 }
488 
489 
490 /**
491  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
492  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
493  */
494 contract ERC721Metadata is ERC721Basic {
495   function name() external view returns (string _name);
496   function symbol() external view returns (string _symbol);
497   function tokenURI(uint256 _tokenId) public view returns (string);
498 }
499 
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
503  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
504  */
505 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
506 }
507 
508 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
509 
510 /**
511  * @title ERC721 token receiver interface
512  * @dev Interface for any contract that wants to support safeTransfers
513  * from ERC721 asset contracts.
514  */
515 contract ERC721Receiver {
516   /**
517    * @dev Magic value to be returned upon successful reception of an NFT
518    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
519    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
520    */
521   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
522 
523   /**
524    * @notice Handle the receipt of an NFT
525    * @dev The ERC721 smart contract calls this function on the recipient
526    * after a `safetransfer`. This function MAY throw to revert and reject the
527    * transfer. Return of other than the magic value MUST result in the
528    * transaction being reverted.
529    * Note: the contract address is always the message sender.
530    * @param _operator The address which called `safeTransferFrom` function
531    * @param _from The address which previously owned the token
532    * @param _tokenId The NFT identifier which is being transferred
533    * @param _data Additional data with no specified format
534    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
535    */
536   function onERC721Received(
537     address _operator,
538     address _from,
539     uint256 _tokenId,
540     bytes _data
541   )
542     public
543     returns(bytes4);
544 }
545 
546 // File: openzeppelin-solidity/contracts/AddressUtils.sol
547 
548 /**
549  * Utility library of inline functions on addresses
550  */
551 library AddressUtils {
552 
553   /**
554    * Returns whether the target address is a contract
555    * @dev This function will return false if invoked during the constructor of a contract,
556    * as the code is not actually created until after the constructor finishes.
557    * @param _addr address to check
558    * @return whether the target address is a contract
559    */
560   function isContract(address _addr) internal view returns (bool) {
561     uint256 size;
562     // XXX Currently there is no better way to check if there is a contract in an address
563     // than to check the size of the code at that address.
564     // See https://ethereum.stackexchange.com/a/14016/36603
565     // for more details about how this works.
566     // TODO Check this again before the Serenity release, because all addresses will be
567     // contracts then.
568     // solium-disable-next-line security/no-inline-assembly
569     assembly { size := extcodesize(_addr) }
570     return size > 0;
571   }
572 
573 }
574 
575 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
576 
577 /**
578  * @title SupportsInterfaceWithLookup
579  * @author Matt Condon (@shrugs)
580  * @dev Implements ERC165 using a lookup table.
581  */
582 contract SupportsInterfaceWithLookup is ERC165 {
583 
584   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
585   /**
586    * 0x01ffc9a7 ===
587    *   bytes4(keccak256('supportsInterface(bytes4)'))
588    */
589 
590   /**
591    * @dev a mapping of interface id to whether or not it's supported
592    */
593   mapping(bytes4 => bool) internal supportedInterfaces;
594 
595   /**
596    * @dev A contract implementing SupportsInterfaceWithLookup
597    * implement ERC165 itself
598    */
599   constructor()
600     public
601   {
602     _registerInterface(InterfaceId_ERC165);
603   }
604 
605   /**
606    * @dev implement supportsInterface(bytes4) using a lookup table
607    */
608   function supportsInterface(bytes4 _interfaceId)
609     external
610     view
611     returns (bool)
612   {
613     return supportedInterfaces[_interfaceId];
614   }
615 
616   /**
617    * @dev private method for registering an interface
618    */
619   function _registerInterface(bytes4 _interfaceId)
620     internal
621   {
622     require(_interfaceId != 0xffffffff);
623     supportedInterfaces[_interfaceId] = true;
624   }
625 }
626 
627 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
628 
629 /**
630  * @title ERC721 Non-Fungible Token Standard basic implementation
631  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
632  */
633 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
634 
635   using SafeMath for uint256;
636   using AddressUtils for address;
637 
638   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
639   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
640   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
641 
642   // Mapping from token ID to owner
643   mapping (uint256 => address) internal tokenOwner;
644 
645   // Mapping from token ID to approved address
646   mapping (uint256 => address) internal tokenApprovals;
647 
648   // Mapping from owner to number of owned token
649   mapping (address => uint256) internal ownedTokensCount;
650 
651   // Mapping from owner to operator approvals
652   mapping (address => mapping (address => bool)) internal operatorApprovals;
653 
654   constructor()
655     public
656   {
657     // register the supported interfaces to conform to ERC721 via ERC165
658     _registerInterface(InterfaceId_ERC721);
659     _registerInterface(InterfaceId_ERC721Exists);
660   }
661 
662   /**
663    * @dev Gets the balance of the specified address
664    * @param _owner address to query the balance of
665    * @return uint256 representing the amount owned by the passed address
666    */
667   function balanceOf(address _owner) public view returns (uint256) {
668     require(_owner != address(0));
669     return ownedTokensCount[_owner];
670   }
671 
672   /**
673    * @dev Gets the owner of the specified token ID
674    * @param _tokenId uint256 ID of the token to query the owner of
675    * @return owner address currently marked as the owner of the given token ID
676    */
677   function ownerOf(uint256 _tokenId) public view returns (address) {
678     address owner = tokenOwner[_tokenId];
679     require(owner != address(0));
680     return owner;
681   }
682 
683   /**
684    * @dev Returns whether the specified token exists
685    * @param _tokenId uint256 ID of the token to query the existence of
686    * @return whether the token exists
687    */
688   function exists(uint256 _tokenId) public view returns (bool) {
689     address owner = tokenOwner[_tokenId];
690     return owner != address(0);
691   }
692 
693   /**
694    * @dev Approves another address to transfer the given token ID
695    * The zero address indicates there is no approved address.
696    * There can only be one approved address per token at a given time.
697    * Can only be called by the token owner or an approved operator.
698    * @param _to address to be approved for the given token ID
699    * @param _tokenId uint256 ID of the token to be approved
700    */
701   function approve(address _to, uint256 _tokenId) public {
702     address owner = ownerOf(_tokenId);
703     require(_to != owner);
704     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
705 
706     tokenApprovals[_tokenId] = _to;
707     emit Approval(owner, _to, _tokenId);
708   }
709 
710   /**
711    * @dev Gets the approved address for a token ID, or zero if no address set
712    * @param _tokenId uint256 ID of the token to query the approval of
713    * @return address currently approved for the given token ID
714    */
715   function getApproved(uint256 _tokenId) public view returns (address) {
716     return tokenApprovals[_tokenId];
717   }
718 
719   /**
720    * @dev Sets or unsets the approval of a given operator
721    * An operator is allowed to transfer all tokens of the sender on their behalf
722    * @param _to operator address to set the approval
723    * @param _approved representing the status of the approval to be set
724    */
725   function setApprovalForAll(address _to, bool _approved) public {
726     require(_to != msg.sender);
727     operatorApprovals[msg.sender][_to] = _approved;
728     emit ApprovalForAll(msg.sender, _to, _approved);
729   }
730 
731   /**
732    * @dev Tells whether an operator is approved by a given owner
733    * @param _owner owner address which you want to query the approval of
734    * @param _operator operator address which you want to query the approval of
735    * @return bool whether the given operator is approved by the given owner
736    */
737   function isApprovedForAll(
738     address _owner,
739     address _operator
740   )
741     public
742     view
743     returns (bool)
744   {
745     return operatorApprovals[_owner][_operator];
746   }
747 
748   /**
749    * @dev Transfers the ownership of a given token ID to another address
750    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
751    * Requires the msg sender to be the owner, approved, or operator
752    * @param _from current owner of the token
753    * @param _to address to receive the ownership of the given token ID
754    * @param _tokenId uint256 ID of the token to be transferred
755   */
756   function transferFrom(
757     address _from,
758     address _to,
759     uint256 _tokenId
760   )
761     public
762   {
763     require(isApprovedOrOwner(msg.sender, _tokenId));
764     require(_from != address(0));
765     require(_to != address(0));
766 
767     clearApproval(_from, _tokenId);
768     removeTokenFrom(_from, _tokenId);
769     addTokenTo(_to, _tokenId);
770 
771     emit Transfer(_from, _to, _tokenId);
772   }
773 
774   /**
775    * @dev Safely transfers the ownership of a given token ID to another address
776    * If the target address is a contract, it must implement `onERC721Received`,
777    * which is called upon a safe transfer, and return the magic value
778    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
779    * the transfer is reverted.
780    *
781    * Requires the msg sender to be the owner, approved, or operator
782    * @param _from current owner of the token
783    * @param _to address to receive the ownership of the given token ID
784    * @param _tokenId uint256 ID of the token to be transferred
785   */
786   function safeTransferFrom(
787     address _from,
788     address _to,
789     uint256 _tokenId
790   )
791     public
792   {
793     // solium-disable-next-line arg-overflow
794     safeTransferFrom(_from, _to, _tokenId, "");
795   }
796 
797   /**
798    * @dev Safely transfers the ownership of a given token ID to another address
799    * If the target address is a contract, it must implement `onERC721Received`,
800    * which is called upon a safe transfer, and return the magic value
801    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
802    * the transfer is reverted.
803    * Requires the msg sender to be the owner, approved, or operator
804    * @param _from current owner of the token
805    * @param _to address to receive the ownership of the given token ID
806    * @param _tokenId uint256 ID of the token to be transferred
807    * @param _data bytes data to send along with a safe transfer check
808    */
809   function safeTransferFrom(
810     address _from,
811     address _to,
812     uint256 _tokenId,
813     bytes _data
814   )
815     public
816   {
817     transferFrom(_from, _to, _tokenId);
818     // solium-disable-next-line arg-overflow
819     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
820   }
821 
822   /**
823    * @dev Returns whether the given spender can transfer a given token ID
824    * @param _spender address of the spender to query
825    * @param _tokenId uint256 ID of the token to be transferred
826    * @return bool whether the msg.sender is approved for the given token ID,
827    *  is an operator of the owner, or is the owner of the token
828    */
829   function isApprovedOrOwner(
830     address _spender,
831     uint256 _tokenId
832   )
833     internal
834     view
835     returns (bool)
836   {
837     address owner = ownerOf(_tokenId);
838     // Disable solium check because of
839     // https://github.com/duaraghav8/Solium/issues/175
840     // solium-disable-next-line operator-whitespace
841     return (
842       _spender == owner ||
843       getApproved(_tokenId) == _spender ||
844       isApprovedForAll(owner, _spender)
845     );
846   }
847 
848   /**
849    * @dev Internal function to mint a new token
850    * Reverts if the given token ID already exists
851    * @param _to The address that will own the minted token
852    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
853    */
854   function _mint(address _to, uint256 _tokenId) internal {
855     require(_to != address(0));
856     addTokenTo(_to, _tokenId);
857     emit Transfer(address(0), _to, _tokenId);
858   }
859 
860   /**
861    * @dev Internal function to burn a specific token
862    * Reverts if the token does not exist
863    * @param _tokenId uint256 ID of the token being burned by the msg.sender
864    */
865   function _burn(address _owner, uint256 _tokenId) internal {
866     clearApproval(_owner, _tokenId);
867     removeTokenFrom(_owner, _tokenId);
868     emit Transfer(_owner, address(0), _tokenId);
869   }
870 
871   /**
872    * @dev Internal function to clear current approval of a given token ID
873    * Reverts if the given address is not indeed the owner of the token
874    * @param _owner owner of the token
875    * @param _tokenId uint256 ID of the token to be transferred
876    */
877   function clearApproval(address _owner, uint256 _tokenId) internal {
878     require(ownerOf(_tokenId) == _owner);
879     if (tokenApprovals[_tokenId] != address(0)) {
880       tokenApprovals[_tokenId] = address(0);
881     }
882   }
883 
884   /**
885    * @dev Internal function to add a token ID to the list of a given address
886    * @param _to address representing the new owner of the given token ID
887    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
888    */
889   function addTokenTo(address _to, uint256 _tokenId) internal {
890     require(tokenOwner[_tokenId] == address(0));
891     tokenOwner[_tokenId] = _to;
892     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
893   }
894 
895   /**
896    * @dev Internal function to remove a token ID from the list of a given address
897    * @param _from address representing the previous owner of the given token ID
898    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
899    */
900   function removeTokenFrom(address _from, uint256 _tokenId) internal {
901     require(ownerOf(_tokenId) == _from);
902     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
903     tokenOwner[_tokenId] = address(0);
904   }
905 
906   /**
907    * @dev Internal function to invoke `onERC721Received` on a target address
908    * The call is not executed if the target address is not a contract
909    * @param _from address representing the previous owner of the given token ID
910    * @param _to target address that will receive the tokens
911    * @param _tokenId uint256 ID of the token to be transferred
912    * @param _data bytes optional data to send along with the call
913    * @return whether the call correctly returned the expected magic value
914    */
915   function checkAndCallSafeTransfer(
916     address _from,
917     address _to,
918     uint256 _tokenId,
919     bytes _data
920   )
921     internal
922     returns (bool)
923   {
924     if (!_to.isContract()) {
925       return true;
926     }
927     bytes4 retval = ERC721Receiver(_to).onERC721Received(
928       msg.sender, _from, _tokenId, _data);
929     return (retval == ERC721_RECEIVED);
930   }
931 }
932 
933 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
934 
935 /**
936  * @title Full ERC721 Token
937  * This implementation includes all the required and some optional functionality of the ERC721 standard
938  * Moreover, it includes approve all functionality using operator terminology
939  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
940  */
941 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
942 
943   // Token name
944   string internal name_;
945 
946   // Token symbol
947   string internal symbol_;
948 
949   // Mapping from owner to list of owned token IDs
950   mapping(address => uint256[]) internal ownedTokens;
951 
952   // Mapping from token ID to index of the owner tokens list
953   mapping(uint256 => uint256) internal ownedTokensIndex;
954 
955   // Array with all token ids, used for enumeration
956   uint256[] internal allTokens;
957 
958   // Mapping from token id to position in the allTokens array
959   mapping(uint256 => uint256) internal allTokensIndex;
960 
961   // Optional mapping for token URIs
962   mapping(uint256 => string) internal tokenURIs;
963 
964   /**
965    * @dev Constructor function
966    */
967   constructor(string _name, string _symbol) public {
968     name_ = _name;
969     symbol_ = _symbol;
970 
971     // register the supported interfaces to conform to ERC721 via ERC165
972     _registerInterface(InterfaceId_ERC721Enumerable);
973     _registerInterface(InterfaceId_ERC721Metadata);
974   }
975 
976   /**
977    * @dev Gets the token name
978    * @return string representing the token name
979    */
980   function name() external view returns (string) {
981     return name_;
982   }
983 
984   /**
985    * @dev Gets the token symbol
986    * @return string representing the token symbol
987    */
988   function symbol() external view returns (string) {
989     return symbol_;
990   }
991 
992   /**
993    * @dev Returns an URI for a given token ID
994    * Throws if the token ID does not exist. May return an empty string.
995    * @param _tokenId uint256 ID of the token to query
996    */
997   function tokenURI(uint256 _tokenId) public view returns (string) {
998     require(exists(_tokenId));
999     return tokenURIs[_tokenId];
1000   }
1001 
1002   /**
1003    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1004    * @param _owner address owning the tokens list to be accessed
1005    * @param _index uint256 representing the index to be accessed of the requested tokens list
1006    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1007    */
1008   function tokenOfOwnerByIndex(
1009     address _owner,
1010     uint256 _index
1011   )
1012     public
1013     view
1014     returns (uint256)
1015   {
1016     require(_index < balanceOf(_owner));
1017     return ownedTokens[_owner][_index];
1018   }
1019 
1020   /**
1021    * @dev Gets the total amount of tokens stored by the contract
1022    * @return uint256 representing the total amount of tokens
1023    */
1024   function totalSupply() public view returns (uint256) {
1025     return allTokens.length;
1026   }
1027 
1028   /**
1029    * @dev Gets the token ID at a given index of all the tokens in this contract
1030    * Reverts if the index is greater or equal to the total number of tokens
1031    * @param _index uint256 representing the index to be accessed of the tokens list
1032    * @return uint256 token ID at the given index of the tokens list
1033    */
1034   function tokenByIndex(uint256 _index) public view returns (uint256) {
1035     require(_index < totalSupply());
1036     return allTokens[_index];
1037   }
1038 
1039   /**
1040    * @dev Internal function to set the token URI for a given token
1041    * Reverts if the token ID does not exist
1042    * @param _tokenId uint256 ID of the token to set its URI
1043    * @param _uri string URI to assign
1044    */
1045   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1046     require(exists(_tokenId));
1047     tokenURIs[_tokenId] = _uri;
1048   }
1049 
1050   /**
1051    * @dev Internal function to add a token ID to the list of a given address
1052    * @param _to address representing the new owner of the given token ID
1053    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1054    */
1055   function addTokenTo(address _to, uint256 _tokenId) internal {
1056     super.addTokenTo(_to, _tokenId);
1057     uint256 length = ownedTokens[_to].length;
1058     ownedTokens[_to].push(_tokenId);
1059     ownedTokensIndex[_tokenId] = length;
1060   }
1061 
1062   /**
1063    * @dev Internal function to remove a token ID from the list of a given address
1064    * @param _from address representing the previous owner of the given token ID
1065    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1066    */
1067   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1068     super.removeTokenFrom(_from, _tokenId);
1069 
1070     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1071     // then delete the last slot.
1072     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1073     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1074     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1075 
1076     ownedTokens[_from][tokenIndex] = lastToken;
1077     // This also deletes the contents at the last position of the array
1078     ownedTokens[_from].length--;
1079 
1080     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1081     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1082     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1083 
1084     ownedTokensIndex[_tokenId] = 0;
1085     ownedTokensIndex[lastToken] = tokenIndex;
1086   }
1087 
1088   /**
1089    * @dev Internal function to mint a new token
1090    * Reverts if the given token ID already exists
1091    * @param _to address the beneficiary that will own the minted token
1092    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1093    */
1094   function _mint(address _to, uint256 _tokenId) internal {
1095     super._mint(_to, _tokenId);
1096 
1097     allTokensIndex[_tokenId] = allTokens.length;
1098     allTokens.push(_tokenId);
1099   }
1100 
1101   /**
1102    * @dev Internal function to burn a specific token
1103    * Reverts if the token does not exist
1104    * @param _owner owner of the token to burn
1105    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1106    */
1107   function _burn(address _owner, uint256 _tokenId) internal {
1108     super._burn(_owner, _tokenId);
1109 
1110     // Clear metadata (if any)
1111     if (bytes(tokenURIs[_tokenId]).length != 0) {
1112       delete tokenURIs[_tokenId];
1113     }
1114 
1115     // Reorg all tokens array
1116     uint256 tokenIndex = allTokensIndex[_tokenId];
1117     uint256 lastTokenIndex = allTokens.length.sub(1);
1118     uint256 lastToken = allTokens[lastTokenIndex];
1119 
1120     allTokens[tokenIndex] = lastToken;
1121     allTokens[lastTokenIndex] = 0;
1122 
1123     allTokens.length--;
1124     allTokensIndex[_tokenId] = 0;
1125     allTokensIndex[lastToken] = tokenIndex;
1126   }
1127 
1128 }
1129 
1130 // File: contracts/Strings.sol
1131 
1132 library Strings {
1133   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1134   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1135     bytes memory _ba = bytes(_a);
1136     bytes memory _bb = bytes(_b);
1137     bytes memory _bc = bytes(_c);
1138     bytes memory _bd = bytes(_d);
1139     bytes memory _be = bytes(_e);
1140     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1141     bytes memory babcde = bytes(abcde);
1142     uint k = 0;
1143     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1144     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1145     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1146     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1147     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1148     return string(babcde);
1149   }
1150 
1151   function strConcat(string _a, string _b) internal pure returns (string) {
1152     return strConcat(_a, _b, "", "", "");
1153   }
1154 }
1155 
1156 // File: contracts/CryptoKaiju.sol
1157 
1158 /**
1159 * @title CryptoKaiju - http://cryptokaiju.io
1160 *
1161 * Collectable Vinyl Toys Powered By The Ethereum Blockchain.
1162 *
1163 * The contract below represents the base contract for issuing CryptoKaiju NFT tokens.
1164 *
1165 * Taking over the world one collectable Kaiju at a time.
1166 *
1167 * Dreamt up by https://coinjournal.net in partnership between http://knownorigin.io & http://blockrocket.tech
1168 */
1169 contract CryptoKaiju is ERC721Token, Whitelist {
1170   using SafeMath for uint256;
1171 
1172   string public tokenBaseURI = "https://ipfs.infura.io/ipfs/";
1173 
1174   // The NFC tag ID
1175   mapping(bytes32 => uint256) internal nfcIdToTokenId;
1176   mapping(uint256 => bytes32) internal tokenIdToNfcId;
1177 
1178   // Block when the Kaiju was born - will help with ordering by birth date which could differ from token ID
1179   mapping(uint256 => uint256) internal tokenIdToBirthDate;
1180 
1181   // A pointer to the next token to be minted, zero indexed
1182   uint256 public tokenIdPointer = 0;
1183 
1184   constructor () public ERC721Token("CryptoKaiju", "KAIJU") {
1185     addAddressToWhitelist(msg.sender);
1186   }
1187 
1188   function mint(bytes32 nfcId, string tokenURI, uint256 birthDate)
1189   public
1190   onlyIfWhitelisted(msg.sender)
1191   returns (bool) {
1192     _mint(msg.sender, nfcId, tokenURI, birthDate);
1193     return true;
1194   }
1195 
1196   function mintTo(address to, bytes32 nfcId, string tokenURI, uint256 birthDate)
1197   public
1198   onlyIfWhitelisted(msg.sender)
1199   returns (bool) {
1200     _mint(to, nfcId, tokenURI, birthDate);
1201     return true;
1202   }
1203 
1204   function _mint(address to, bytes32 nfcId, string tokenURI, uint256 birthDate) internal {
1205     require(nfcIdToTokenId[nfcId] == 0, "Unable to mint Kaiju with duplicate NFC ID");
1206 
1207     uint256 tokenId = tokenIdPointer;
1208 
1209     tokenIdToBirthDate[tokenId] = birthDate;
1210     tokenIdToNfcId[tokenId] = nfcId;
1211     nfcIdToTokenId[nfcId] = tokenId;
1212 
1213     _mint(to, tokenId);
1214     _setTokenURI(tokenId, tokenURI);
1215 
1216     tokenIdPointer = tokenIdPointer.add(1);
1217   }
1218 
1219   function burn(uint256 tokenId)
1220   public
1221   onlyIfWhitelisted(msg.sender) {
1222     // Cleanup custom data
1223     bytes32 nfcId = tokenIdToNfcId[tokenId];
1224     delete nfcIdToTokenId[nfcId];
1225     delete tokenIdToNfcId[tokenId];
1226     delete tokenIdToBirthDate[tokenId];
1227 
1228     // Super burn
1229     _burn(ownerOf(tokenId), tokenId);
1230   }
1231 
1232   function setTokenURI(uint256 tokenId, string uri)
1233   public
1234   onlyIfWhitelisted(msg.sender) {
1235     _setTokenURI(tokenId, uri);
1236   }
1237 
1238   function setTokenBaseURI(string _newBaseURI)
1239   external
1240   onlyIfWhitelisted(msg.sender) {
1241     require(bytes(_newBaseURI).length != 0, "Base URI invalid");
1242     tokenBaseURI = _newBaseURI;
1243   }
1244 
1245   function tokenURI(uint256 _tokenId) public view returns (string) {
1246     require(exists(_tokenId));
1247     return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
1248   }
1249 
1250   function birthDateOf(uint256 _tokenId) public view returns (uint256) {
1251     return tokenIdToBirthDate[_tokenId];
1252   }
1253 
1254   function tokenOf(bytes32 _nfcId) public view returns (uint256) {
1255     return nfcIdToTokenId[_nfcId];
1256   }
1257 
1258   function nfcIdOf(uint256 _tokenId) public view returns (bytes32) {
1259     return tokenIdToNfcId[_tokenId];
1260   }
1261 
1262   function tokensOf(address _owner) public view returns (uint256[] _tokenIds) {
1263     return ownedTokens[_owner];
1264   }
1265 
1266   function nfcDetails(bytes32 _nfcId) public view returns (
1267     uint256 tokenId,
1268     bytes32 nfcId,
1269     string tokenUri,
1270     uint256 dob
1271   ) {
1272     uint256 _tokenId = nfcIdToTokenId[_nfcId];
1273     return tokenDetails(_tokenId);
1274   }
1275 
1276   function tokenDetails(uint256 _tokenId) public view returns (
1277     uint256 tokenId,
1278     bytes32 nfcId,
1279     string tokenUri,
1280     uint256 dob
1281   ) {
1282     require(exists(_tokenId));
1283 
1284     return (
1285     _tokenId,
1286     tokenIdToNfcId[_tokenId],
1287     tokenURI(_tokenId),
1288     tokenIdToBirthDate[_tokenId]
1289     );
1290   }
1291 
1292 }