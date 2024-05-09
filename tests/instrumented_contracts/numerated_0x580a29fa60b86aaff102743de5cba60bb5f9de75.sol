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
1130 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Holder.sol
1131 
1132 contract ERC721Holder is ERC721Receiver {
1133   function onERC721Received(
1134     address,
1135     address,
1136     uint256,
1137     bytes
1138   )
1139     public
1140     returns(bytes4)
1141   {
1142     return ERC721_RECEIVED;
1143   }
1144 }
1145 
1146 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
1147 
1148 /**
1149  * @title ERC20Basic
1150  * @dev Simpler version of ERC20 interface
1151  * See https://github.com/ethereum/EIPs/issues/179
1152  */
1153 contract ERC20Basic {
1154   function totalSupply() public view returns (uint256);
1155   function balanceOf(address _who) public view returns (uint256);
1156   function transfer(address _to, uint256 _value) public returns (bool);
1157   event Transfer(address indexed from, address indexed to, uint256 value);
1158 }
1159 
1160 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
1161 
1162 /**
1163  * @title Basic token
1164  * @dev Basic version of StandardToken, with no allowances.
1165  */
1166 contract BasicToken is ERC20Basic {
1167   using SafeMath for uint256;
1168 
1169   mapping(address => uint256) internal balances;
1170 
1171   uint256 internal totalSupply_;
1172 
1173   /**
1174   * @dev Total number of tokens in existence
1175   */
1176   function totalSupply() public view returns (uint256) {
1177     return totalSupply_;
1178   }
1179 
1180   /**
1181   * @dev Transfer token for a specified address
1182   * @param _to The address to transfer to.
1183   * @param _value The amount to be transferred.
1184   */
1185   function transfer(address _to, uint256 _value) public returns (bool) {
1186     require(_value <= balances[msg.sender]);
1187     require(_to != address(0));
1188 
1189     balances[msg.sender] = balances[msg.sender].sub(_value);
1190     balances[_to] = balances[_to].add(_value);
1191     emit Transfer(msg.sender, _to, _value);
1192     return true;
1193   }
1194 
1195   /**
1196   * @dev Gets the balance of the specified address.
1197   * @param _owner The address to query the the balance of.
1198   * @return An uint256 representing the amount owned by the passed address.
1199   */
1200   function balanceOf(address _owner) public view returns (uint256) {
1201     return balances[_owner];
1202   }
1203 
1204 }
1205 
1206 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1207 
1208 /**
1209  * @title ERC20 interface
1210  * @dev see https://github.com/ethereum/EIPs/issues/20
1211  */
1212 contract ERC20 is ERC20Basic {
1213   function allowance(address _owner, address _spender)
1214     public view returns (uint256);
1215 
1216   function transferFrom(address _from, address _to, uint256 _value)
1217     public returns (bool);
1218 
1219   function approve(address _spender, uint256 _value) public returns (bool);
1220   event Approval(
1221     address indexed owner,
1222     address indexed spender,
1223     uint256 value
1224   );
1225 }
1226 
1227 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
1228 
1229 /**
1230  * @title Standard ERC20 token
1231  *
1232  * @dev Implementation of the basic standard token.
1233  * https://github.com/ethereum/EIPs/issues/20
1234  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1235  */
1236 contract StandardToken is ERC20, BasicToken {
1237 
1238   mapping (address => mapping (address => uint256)) internal allowed;
1239 
1240 
1241   /**
1242    * @dev Transfer tokens from one address to another
1243    * @param _from address The address which you want to send tokens from
1244    * @param _to address The address which you want to transfer to
1245    * @param _value uint256 the amount of tokens to be transferred
1246    */
1247   function transferFrom(
1248     address _from,
1249     address _to,
1250     uint256 _value
1251   )
1252     public
1253     returns (bool)
1254   {
1255     require(_value <= balances[_from]);
1256     require(_value <= allowed[_from][msg.sender]);
1257     require(_to != address(0));
1258 
1259     balances[_from] = balances[_from].sub(_value);
1260     balances[_to] = balances[_to].add(_value);
1261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1262     emit Transfer(_from, _to, _value);
1263     return true;
1264   }
1265 
1266   /**
1267    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1268    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1269    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1270    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1271    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1272    * @param _spender The address which will spend the funds.
1273    * @param _value The amount of tokens to be spent.
1274    */
1275   function approve(address _spender, uint256 _value) public returns (bool) {
1276     allowed[msg.sender][_spender] = _value;
1277     emit Approval(msg.sender, _spender, _value);
1278     return true;
1279   }
1280 
1281   /**
1282    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1283    * @param _owner address The address which owns the funds.
1284    * @param _spender address The address which will spend the funds.
1285    * @return A uint256 specifying the amount of tokens still available for the spender.
1286    */
1287   function allowance(
1288     address _owner,
1289     address _spender
1290    )
1291     public
1292     view
1293     returns (uint256)
1294   {
1295     return allowed[_owner][_spender];
1296   }
1297 
1298   /**
1299    * @dev Increase the amount of tokens that an owner allowed to a spender.
1300    * approve should be called when allowed[_spender] == 0. To increment
1301    * allowed value is better to use this function to avoid 2 calls (and wait until
1302    * the first transaction is mined)
1303    * From MonolithDAO Token.sol
1304    * @param _spender The address which will spend the funds.
1305    * @param _addedValue The amount of tokens to increase the allowance by.
1306    */
1307   function increaseApproval(
1308     address _spender,
1309     uint256 _addedValue
1310   )
1311     public
1312     returns (bool)
1313   {
1314     allowed[msg.sender][_spender] = (
1315       allowed[msg.sender][_spender].add(_addedValue));
1316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1317     return true;
1318   }
1319 
1320   /**
1321    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1322    * approve should be called when allowed[_spender] == 0. To decrement
1323    * allowed value is better to use this function to avoid 2 calls (and wait until
1324    * the first transaction is mined)
1325    * From MonolithDAO Token.sol
1326    * @param _spender The address which will spend the funds.
1327    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1328    */
1329   function decreaseApproval(
1330     address _spender,
1331     uint256 _subtractedValue
1332   )
1333     public
1334     returns (bool)
1335   {
1336     uint256 oldValue = allowed[msg.sender][_spender];
1337     if (_subtractedValue >= oldValue) {
1338       allowed[msg.sender][_spender] = 0;
1339     } else {
1340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1341     }
1342     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1343     return true;
1344   }
1345 
1346 }
1347 
1348 // File: contracts/Strings.sol
1349 
1350 library Strings {
1351   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1352   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1353     bytes memory _ba = bytes(_a);
1354     bytes memory _bb = bytes(_b);
1355     bytes memory _bc = bytes(_c);
1356     bytes memory _bd = bytes(_d);
1357     bytes memory _be = bytes(_e);
1358     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1359     bytes memory babcde = bytes(abcde);
1360     uint k = 0;
1361     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1362     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1363     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1364     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1365     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1366     return string(babcde);
1367   }
1368 
1369   function strConcat(string _a, string _b) internal pure returns (string) {
1370     return strConcat(_a, _b, "", "", "");
1371   }
1372 }
1373 
1374 // File: contracts/Medianizer.sol
1375 
1376 // This is the original medianizer implementation used by MakerDAO. we use this
1377 // contract to fetch the latest ether price by calling the read() function.
1378 // public deployed instances of  this contract can be found here:
1379 //1) kovan: https://kovan.etherscan.io/address/0x9FfFE440258B79c5d6604001674A4722FfC0f7Bc#code
1380 //2) mainnet: https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B#readContract
1381 
1382 /// return median value of feeds
1383 
1384 // Copyright (C) 2017  DappHub, LLC
1385 
1386 // Licensed under the Apache License, Version 2.0 (the "License").
1387 // You may not use this file except in compliance with the License.
1388 
1389 // Unless required by applicable law or agreed to in writing, software
1390 // distributed under the License is distributed on an "AS IS" BASIS,
1391 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
1392 
1393 pragma solidity ^0.4.8;
1394 
1395 contract DSAuthority {
1396     function canCall(
1397         address src, address dst, bytes4 sig
1398     ) constant returns (bool);
1399 }
1400 
1401 contract DSAuthEvents {
1402     event LogSetAuthority (address indexed authority);
1403     event LogSetOwner     (address indexed owner);
1404 }
1405 
1406 contract DSAuth is DSAuthEvents {
1407     DSAuthority  public  authority;
1408     address      public  owner;
1409 
1410     function DSAuth() {
1411         owner = msg.sender;
1412         LogSetOwner(msg.sender);
1413     }
1414 
1415     function setOwner(address owner_)
1416         auth
1417     {
1418         owner = owner_;
1419         LogSetOwner(owner);
1420     }
1421 
1422     function setAuthority(DSAuthority authority_)
1423         auth
1424     {
1425         authority = authority_;
1426         LogSetAuthority(authority);
1427     }
1428 
1429     modifier auth {
1430         assert(isAuthorized(msg.sender, msg.sig));
1431         _;
1432     }
1433 
1434     modifier authorized(bytes4 sig) {
1435         assert(isAuthorized(msg.sender, sig));
1436         _;
1437     }
1438 
1439     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
1440         if (src == address(this)) {
1441             return true;
1442         } else if (src == owner) {
1443             return true;
1444         } else if (authority == DSAuthority(0)) {
1445             return false;
1446         } else {
1447             return authority.canCall(src, this, sig);
1448         }
1449     }
1450 
1451     function assert(bool x) internal {
1452         if (!x) throw;
1453     }
1454 }
1455 
1456 contract DSNote {
1457     event LogNote(
1458         bytes4   indexed  sig,
1459         address  indexed  guy,
1460         bytes32  indexed  foo,
1461         bytes32  indexed  bar,
1462 	uint	 	  wad,
1463         bytes             fax
1464     ) anonymous;
1465 
1466     modifier note {
1467         bytes32 foo;
1468         bytes32 bar;
1469 
1470         assembly {
1471             foo := calldataload(4)
1472             bar := calldataload(36)
1473         }
1474 
1475         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
1476 
1477         _;
1478     }
1479 }
1480 
1481 contract DSMath {
1482 
1483     /*
1484     standard uint256 functions
1485      */
1486 
1487     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
1488         assert((z = x + y) >= x);
1489     }
1490 
1491     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
1492         assert((z = x - y) <= x);
1493     }
1494 
1495     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
1496         assert((z = x * y) >= x);
1497     }
1498 
1499     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
1500         z = x / y;
1501     }
1502 
1503     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
1504         return x <= y ? x : y;
1505     }
1506     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
1507         return x >= y ? x : y;
1508     }
1509 
1510     /*
1511     uint128 functions (h is for half)
1512      */
1513 
1514 
1515     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
1516         assert((z = x + y) >= x);
1517     }
1518 
1519     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
1520         assert((z = x - y) <= x);
1521     }
1522 
1523     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1524         assert((z = x * y) >= x);
1525     }
1526 
1527     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1528         z = x / y;
1529     }
1530 
1531     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
1532         return x <= y ? x : y;
1533     }
1534     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
1535         return x >= y ? x : y;
1536     }
1537 
1538 
1539     /*
1540     int256 functions
1541      */
1542 
1543     function imin(int256 x, int256 y) constant internal returns (int256 z) {
1544         return x <= y ? x : y;
1545     }
1546     function imax(int256 x, int256 y) constant internal returns (int256 z) {
1547         return x >= y ? x : y;
1548     }
1549 
1550     /*
1551     WAD math
1552      */
1553 
1554     uint128 constant WAD = 10 ** 18;
1555 
1556     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
1557         return hadd(x, y);
1558     }
1559 
1560     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
1561         return hsub(x, y);
1562     }
1563 
1564     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1565         z = cast((uint256(x) * y + WAD / 2) / WAD);
1566     }
1567 
1568     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1569         z = cast((uint256(x) * WAD + y / 2) / y);
1570     }
1571 
1572     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
1573         return hmin(x, y);
1574     }
1575     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
1576         return hmax(x, y);
1577     }
1578 
1579     /*
1580     RAY math
1581      */
1582 
1583     uint128 constant RAY = 10 ** 27;
1584 
1585     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
1586         return hadd(x, y);
1587     }
1588 
1589     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
1590         return hsub(x, y);
1591     }
1592 
1593     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
1594         z = cast((uint256(x) * y + RAY / 2) / RAY);
1595     }
1596 
1597     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
1598         z = cast((uint256(x) * RAY + y / 2) / y);
1599     }
1600 
1601     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
1602         // This famous algorithm is called "exponentiation by squaring"
1603         // and calculates x^n with x as fixed-point and n as regular unsigned.
1604         //
1605         // It's O(log n), instead of O(n) for naive repeated multiplication.
1606         //
1607         // These facts are why it works:
1608         //
1609         //  If n is even, then x^n = (x^2)^(n/2).
1610         //  If n is odd,  then x^n = x * x^(n-1),
1611         //   and applying the equation for even x gives
1612         //    x^n = x * (x^2)^((n-1) / 2).
1613         //
1614         //  Also, EVM division is flooring and
1615         //    floor[(n-1) / 2] = floor[n / 2].
1616 
1617         z = n % 2 != 0 ? x : RAY;
1618 
1619         for (n /= 2; n != 0; n /= 2) {
1620             x = rmul(x, x);
1621 
1622             if (n % 2 != 0) {
1623                 z = rmul(z, x);
1624             }
1625         }
1626     }
1627 
1628     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
1629         return hmin(x, y);
1630     }
1631     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
1632         return hmax(x, y);
1633     }
1634 
1635     function cast(uint256 x) constant internal returns (uint128 z) {
1636         assert((z = uint128(x)) == x);
1637     }
1638 
1639 }
1640 
1641 contract DSThing is DSAuth, DSNote, DSMath {
1642 }
1643 
1644 contract DSValue is DSThing {
1645     bool    has;
1646     bytes32 val;
1647     function peek() constant returns (bytes32, bool) {
1648         return (val,has);
1649     }
1650     function read() constant returns (bytes32) {
1651         var (wut, has) = peek();
1652         assert(has);
1653         return wut;
1654     }
1655     function poke(bytes32 wut) note auth {
1656         val = wut;
1657         has = true;
1658     }
1659     function void() note auth { // unset the value
1660         has = false;
1661     }
1662 }
1663 
1664 contract Medianizer is DSValue {
1665     mapping (bytes12 => address) public values;
1666     mapping (address => bytes12) public indexes;
1667     bytes12 public next = 0x1;
1668 
1669     uint96 public min = 0x1;
1670 
1671     function set(address wat) auth {
1672         bytes12 nextId = bytes12(uint96(next) + 1);
1673         assert(nextId != 0x0);
1674         set(next, wat);
1675         next = nextId;
1676     }
1677 
1678     function set(bytes12 pos, address wat) note auth {
1679         if (pos == 0x0) throw;
1680 
1681         if (wat != 0 && indexes[wat] != 0) throw;
1682 
1683         indexes[values[pos]] = 0; // Making sure to remove a possible existing address in that position
1684 
1685         if (wat != 0) {
1686             indexes[wat] = pos;
1687         }
1688 
1689         values[pos] = wat;
1690     }
1691 
1692     function setMin(uint96 min_) note auth {
1693         if (min_ == 0x0) throw;
1694         min = min_;
1695     }
1696 
1697     function setNext(bytes12 next_) note auth {
1698         if (next_ == 0x0) throw;
1699         next = next_;
1700     }
1701 
1702     function unset(bytes12 pos) {
1703         set(pos, 0);
1704     }
1705 
1706     function unset(address wat) {
1707         set(indexes[wat], 0);
1708     }
1709 
1710     function poke() {
1711         poke(0);
1712     }
1713 
1714     function poke(bytes32) note {
1715         (val, has) = compute();
1716     }
1717 
1718     function compute() constant returns (bytes32, bool) {
1719         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
1720         uint96 ctr = 0;
1721         for (uint96 i = 1; i < uint96(next); i++) {
1722             if (values[bytes12(i)] != 0) {
1723                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
1724                 if (wuz) {
1725                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
1726                         wuts[ctr] = wut;
1727                     } else {
1728                         uint96 j = 0;
1729                         while (wut >= wuts[j]) {
1730                             j++;
1731                         }
1732                         for (uint96 k = ctr; k > j; k--) {
1733                             wuts[k] = wuts[k - 1];
1734                         }
1735                         wuts[j] = wut;
1736                     }
1737                     ctr++;
1738                 }
1739             }
1740         }
1741 
1742         if (ctr < min) return (val, false);
1743 
1744         bytes32 value;
1745         if (ctr % 2 == 0) {
1746             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
1747             uint128 val2 = uint128(wuts[ctr / 2]);
1748             value = bytes32(wdiv(hadd(val1, val2), 2 ether));
1749         } else {
1750             value = wuts[(ctr - 1) / 2];
1751         }
1752 
1753         return (value, true);
1754     }
1755 
1756 }
1757 
1758 // File: contracts/RadiCards.sol
1759 
1760 /**
1761 * @title Radi.Cards
1762 * This is the main Radi Cards NFT (ERC721) contract. It allows for the minting of
1763 * cards(NFTs) that can be sent to either a known EOA or to a claimable link.
1764 * ETH or DAI can be sent along with the card and the sender can choose a ratio
1765 * between a participating benefactor and the recipient, with no restriction.
1766 * Predefined cards can be added, with the artwork stored on IPFS.
1767 * The card message is stored within the smart contract. Cards can have a defined max
1768 * quantity that can be minted and a minimum purchase price. The claimable link sender
1769 * generates a public/private key pair that is used to take the NFT out of escrow (held within
1770 * this contract). The private key can then be sent to the recipient by email,
1771 * telergram, wechat ect. and is embedded within a URL to a claim page. When the user
1772 * opens the claim URL the private key is used to redeem the NFT and any associated gift (ETH/DAI).
1773 
1774 * @author blockrocket.tech (smart contracts)
1775 * @author cryptodecks.co
1776 * @author knownorigin.io
1777 * @author pheme.app
1778 * @author d1labs.com
1779 * @author mbdoesthings.com
1780 * @author chrismaree.io (smart contracts v2 update)
1781 */
1782 contract RadiCards is ERC721Token, ERC721Holder, Whitelist {
1783     using SafeMath for uint256;
1784 
1785     // dai support
1786     StandardToken daiContract;
1787     Medianizer medianizerContract;
1788 
1789     string public tokenBaseURI = "https://ipfs.infura.io/ipfs/";
1790     uint256 public tokenIdPointer = 0;
1791 
1792     struct Benefactor {
1793         address ethAddress;
1794         string name;
1795         string website;
1796         string logo;
1797     }
1798 
1799     struct CardDesign {
1800         string tokenURI;
1801         bool active;
1802         uint minted;
1803         uint maxQnty; //set to zero for unlimited
1804         //minimum price per card set in Atto (SI prefix for 1x10-18 dai)
1805         uint256 minPrice; //set to zero to default to the minimumContribution
1806     }
1807 
1808     // claimable link support
1809     enum Statuses { Empty, Deposited, Claimed, Cancelled }
1810     uint256 public EPHEMERAL_ADDRESS_FEE = 0.01 ether;
1811     mapping(address => uint256) public ephemeralWalletCards; // ephemeral wallet => tokenId
1812 
1813     struct RadiCard {
1814         address gifter;
1815         string message;
1816         bool daiDonation;
1817         uint256 giftAmount;
1818         uint256 donationAmount;
1819         Statuses status;
1820         uint256 cardIndex;
1821         uint256 benefactorIndex;
1822     }
1823 
1824     mapping(uint256 => Benefactor) public benefactors;
1825     uint256[] internal benefactorsIndex;
1826 
1827     mapping(uint256 => CardDesign) public cards;
1828     uint256[] internal cardsIndex;
1829 
1830     mapping(uint256 => RadiCard) public tokenIdToRadiCardIndex;
1831 
1832     //total gifted/donated in ETH
1833     uint256 public totalGiftedInWei;
1834     uint256 public totalDonatedInWei;
1835 
1836     //total gifted/donated in DAI
1837     uint256 public totalGiftedInAtto; //SI prefix for 1x10-18 dai is Atto.
1838     uint256 public totalDonatedInAtto;
1839 
1840     event CardGifted(
1841         address indexed _to,
1842         uint256 indexed _benefactorIndex,
1843         uint256 indexed _cardIndex,
1844         address _from,
1845         uint256 _tokenId,
1846         bool daiDonation,
1847         uint256 giftAmount,
1848         uint256 donationAmount,
1849         Statuses status
1850     );
1851 
1852     event LogClaimGift(
1853             address indexed ephemeralAddress,
1854             address indexed sender,
1855             uint tokenId,
1856             address receiver,
1857             uint giftAmount,
1858         bool daiDonation
1859     );
1860 
1861     event LogCancelGift(
1862         address indexed ephemeralAddress,
1863         address indexed sender,
1864         uint tokenId
1865     );
1866 
1867 
1868     event BenefactorAdded(
1869         uint256 indexed _benefactorIndex
1870     );
1871 
1872     event CardAdded(
1873         uint256 indexed _cardIndex
1874     );
1875 
1876     constructor () public ERC721Token("RadiCards", "RADI") {
1877         addAddressToWhitelist(msg.sender);
1878     }
1879 
1880     function gift(address _to, uint256 _benefactorIndex, uint256 _cardIndex, string _message, uint256 _donationAmount, uint256 _giftAmount, bool _claimableLink) payable public returns (bool) {
1881         require(_to != address(0), "Must be a valid address");
1882         if(_donationAmount > 0){
1883             require(benefactors[_benefactorIndex].ethAddress != address(0), "Must specify existing benefactor");
1884         }
1885 
1886         require(bytes(cards[_cardIndex].tokenURI).length != 0, "Must specify existing card");
1887         require(cards[_cardIndex].active, "Must be an active card");
1888 
1889         Statuses _giftStatus;
1890         address _sentToAddress;
1891 
1892         if(_claimableLink){
1893             require(_donationAmount + _giftAmount + EPHEMERAL_ADDRESS_FEE == msg.value, "Can only request to donate and gift the amount of ether sent + Ephemeral fee");
1894             _giftStatus = Statuses.Deposited;
1895             _sentToAddress = this;
1896             ephemeralWalletCards[_to] = tokenIdPointer;
1897             _to.transfer(EPHEMERAL_ADDRESS_FEE);
1898         }
1899 
1900         else {
1901             require(_donationAmount + _giftAmount == msg.value,"Can only request to donate and gift the amount of ether sent");
1902             _giftStatus = Statuses.Claimed;
1903             _sentToAddress = _to;
1904         }
1905 
1906         if (cards[_cardIndex].maxQnty > 0){ //the max quantity is set to zero to indicate no limit. Only need to check that can mint if limited
1907             require(cards[_cardIndex].minted < cards[_cardIndex].maxQnty, "Can't exceed maximum quantity of card type");
1908         }
1909 
1910         if(cards[_cardIndex].minPrice > 0){ //if the card has a minimum price check that enough has been sent
1911         // Convert the current value of the eth send to a USD value of atto (1 usd = 10^18 atto).
1912         // require(getEthUsdValue(msg.value) >= (cards[_cardIndex].minPrice), "Must send at least the minimum amount");
1913             require (getMinCardPriceInWei(_cardIndex) <= msg.value,"Must send at least the minimum amount to buy card");
1914         }
1915 
1916         tokenIdToRadiCardIndex[tokenIdPointer] = RadiCard({
1917             gifter: msg.sender,
1918             message: _message,
1919             daiDonation: false,
1920             giftAmount: _giftAmount,
1921             donationAmount: _donationAmount,
1922             status: _giftStatus,
1923             cardIndex: _cardIndex,
1924             benefactorIndex: _benefactorIndex
1925         });
1926 
1927         // Card is minted to the _sentToAddress. This is either this radicards contract(if claimableLink==true)
1928         // and the creator chose to use the escrow for a claimable link or to the recipient EOA directly
1929         uint256 _tokenId = _mint(_sentToAddress, cards[_cardIndex].tokenURI);
1930         cards[_cardIndex].minted++;
1931 
1932         // transfer the ETH to the benefactor
1933         if(_donationAmount > 0){
1934             benefactors[_benefactorIndex].ethAddress.transfer(_donationAmount);
1935             totalDonatedInWei = totalDonatedInWei.add(_donationAmount);
1936         }
1937         // transfer gift to recipient.
1938 
1939         if(_giftAmount > 0){
1940             totalGiftedInWei = totalGiftedInWei.add(_giftAmount);
1941         // note that we only do the transfer if the link is not claimable as if it is the eth sits in escrow within this contract
1942             if(!_claimableLink){
1943                 _sentToAddress.transfer(_giftAmount);
1944             }
1945         }
1946         emit CardGifted(_sentToAddress, _benefactorIndex, _cardIndex, msg.sender, _tokenId, false, _giftAmount, _donationAmount, _giftStatus);
1947         return true;
1948     }
1949 
1950     function giftInDai(address _to, uint256 _benefactorIndex, uint256 _cardIndex, string _message, uint256 _donationAmount, uint256 _giftAmount, bool _claimableLink) public payable returns (bool) {
1951         require(_to != address(0), "Must be a valid address");
1952         if (_donationAmount > 0){
1953             require(benefactors[_benefactorIndex].ethAddress != address(0), "Must specify existing benefactor");
1954         }
1955 
1956         require(bytes(cards[_cardIndex].tokenURI).length != 0, "Must specify existing card");
1957         require(cards[_cardIndex].active, "Must be an active card");
1958 
1959         require((_donationAmount + _giftAmount) <= daiContract.allowance(msg.sender, this), "Must have provided high enough alowance to Radicard contract");
1960         require((_donationAmount + _giftAmount) <= daiContract.balanceOf(msg.sender), "Must have enough token balance of dai to pay for donation and gift amount");
1961 
1962         if (cards[_cardIndex].maxQnty > 0){ //the max quantity is set to zero to indicate no limit. Only need to check that can mint if limited
1963             require(cards[_cardIndex].minted < cards[_cardIndex].maxQnty, "Can't exceed maximum quantity of card type");
1964         }
1965 
1966         if(cards[_cardIndex].minPrice > 0){ //if the card has a minimum price check that enough has been sent
1967             require((_donationAmount + _giftAmount) >= cards[_cardIndex].minPrice, "The total dai sent with the transaction is less than the min price of the token");
1968         }
1969 
1970         //parameters that change based on the if the card is setup as with a claimable link
1971         Statuses _giftStatus;
1972         address _sentToAddress;
1973 
1974         if(_claimableLink){
1975             require(msg.value == EPHEMERAL_ADDRESS_FEE, "A claimable link was generated but not enough ephemeral ether was sent!");
1976             _giftStatus = Statuses.Deposited;
1977             _sentToAddress = this;
1978             // need to store the address of the ephemeral account and the card that it owns for claimable link functionality
1979             ephemeralWalletCards[_to] = tokenIdPointer;
1980             _to.transfer(EPHEMERAL_ADDRESS_FEE);
1981         }
1982 
1983         else {
1984             _giftStatus = Statuses.Claimed;
1985             _sentToAddress = _to;
1986         }
1987 
1988         tokenIdToRadiCardIndex[tokenIdPointer] = RadiCard({
1989             gifter: msg.sender,
1990             message: _message,
1991             daiDonation: true,
1992             giftAmount: _giftAmount,
1993             donationAmount: _donationAmount,
1994             status: _giftStatus,
1995             cardIndex: _cardIndex,
1996             benefactorIndex: _benefactorIndex
1997         });
1998 
1999         // Card is minted to the _sentToAddress. This is either this radicards contract(if claimableLink==true)
2000         // and the creator chose to use the escrow for a claimable link or to the recipient EOA directly
2001         uint256 _tokenId = _mint(_sentToAddress, cards[_cardIndex].tokenURI);
2002 
2003         cards[_cardIndex].minted++;
2004 
2005         // transfer the DAI to the benefactor
2006         if(_donationAmount > 0){
2007             address _benefactorAddress = benefactors[_benefactorIndex].ethAddress;
2008             require(daiContract.transferFrom(msg.sender, _benefactorAddress, _donationAmount),"Sending to benefactor failed");
2009             totalDonatedInAtto = totalDonatedInAtto.add(_donationAmount);
2010         }
2011 
2012         // transfer gift to recipient. note that this pattern is slightly different from the eth case as irrespective of
2013         // if it is a claimable link or not we preform the transaction. if it is indeed a claimable link the dai is sent
2014         // to the contract and held in escrow
2015         if(_giftAmount > 0){
2016             require(daiContract.transferFrom(msg.sender, _sentToAddress, _giftAmount),"Sending to recipient failed");
2017             totalGiftedInAtto = totalGiftedInAtto.add(_giftAmount);
2018         }
2019 
2020         emit CardGifted(_sentToAddress, _benefactorIndex, _cardIndex, msg.sender, _tokenId, true, _giftAmount, _donationAmount, _giftStatus);
2021         return true;
2022     }
2023 
2024     function _mint(address to, string tokenURI) internal returns (uint256 _tokenId) {
2025         uint256 tokenId = tokenIdPointer;
2026 
2027         super._mint(to, tokenId);
2028         _setTokenURI(tokenId, tokenURI);
2029 
2030         tokenIdPointer = tokenIdPointer.add(1);
2031 
2032         return tokenId;
2033     }
2034 
2035     function cancelGift(address _ephemeralAddress) public returns (bool) {
2036         uint256 tokenId = ephemeralWalletCards[_ephemeralAddress];
2037         require(tokenId != 0, "Can only call this function on an address that was used as an ephemeral");
2038         RadiCard storage card = tokenIdToRadiCardIndex[tokenId];
2039 
2040         // is deposited and wasn't claimed or cancelled before
2041         require(card.status == Statuses.Deposited, "can only cancel gifts that are unclaimed (deposited)");
2042 
2043         // only gifter can cancel transfer;
2044         require(msg.sender == card.gifter, "only the gifter of the card can cancel a gift");
2045 
2046         // update status to cancelled
2047         card.status = Statuses.Cancelled;
2048 
2049         // transfer optional ether or dai back to creators address
2050         if (card.giftAmount > 0) {
2051             if(card.daiDonation){
2052                 require(daiContract.transfer(msg.sender, card.giftAmount),"Sending to recipient after cancel gift failed");
2053             }
2054             else{
2055                 msg.sender.transfer(card.giftAmount);
2056             }
2057         }
2058 
2059         // send nft to buyer. for this we use a custom transfer function to take the nft out of escrow and
2060         // send it back to the buyer.
2061         transferFromEscrow(msg.sender, tokenId);
2062 
2063         // log cancel event
2064         emit LogCancelGift(_ephemeralAddress, msg.sender, tokenId);
2065         return true;
2066     }
2067 
2068     function claimGift(address _receiver) public returns (bool success) {
2069         // only holder of ephemeral private key can claim gift
2070         address _ephemeralAddress = msg.sender;
2071 
2072         uint256 tokenId = ephemeralWalletCards[_ephemeralAddress];
2073 
2074         require(tokenId != 0, "The calling address does not have an ephemeral card associated with it");
2075 
2076         RadiCard storage card = tokenIdToRadiCardIndex[tokenId];
2077 
2078         // is deposited and wasn't claimed or cancelled before
2079         require(card.status == Statuses.Deposited, "Can only claim a gift that is unclaimed");
2080 
2081         // update gift status to claimed
2082         card.status = Statuses.Claimed;
2083 
2084         // send nft to receiver
2085         transferFromEscrow(_receiver, tokenId);
2086 
2087         // transfer optional ether & dai to receiver's address
2088         if (card.giftAmount > 0) {
2089             if(card.daiDonation){
2090                 require(daiContract.transfer(_receiver, card.giftAmount),"Sending to recipient after cancel gift failed");
2091         }
2092             else{
2093                 _receiver.transfer(card.giftAmount);
2094             }
2095         }
2096 
2097         // log claim event
2098         emit LogClaimGift(
2099             _ephemeralAddress,
2100             card.gifter,
2101             tokenId,
2102             _receiver,
2103             card.giftAmount,
2104             card.daiDonation
2105         );
2106         return true;
2107     }
2108 
2109     function burn(uint256 _tokenId) public pure  {
2110         revert("Radi.Cards are censorship resistant!");
2111     }
2112 
2113     function tokenURI(uint256 _tokenId) public view returns (string) {
2114         require(exists(_tokenId), "token does not exist");
2115 
2116         return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
2117     }
2118 
2119     function tokenDetails(uint256 _tokenId)
2120     public view
2121     returns (
2122         address _gifter,
2123         string _message,
2124         bool _daiDonation,
2125         uint256 _giftAmount,
2126         uint256 _donationAmount,
2127         Statuses status,
2128         uint256 _cardIndex,
2129         uint256 _benefactorIndex
2130     ) {
2131         require(exists(_tokenId), "token does not exist");
2132         RadiCard memory _radiCard = tokenIdToRadiCardIndex[_tokenId];
2133         return (
2134         _radiCard.gifter,
2135         _radiCard.message,
2136         _radiCard.daiDonation,
2137         _radiCard.giftAmount,
2138         _radiCard.donationAmount,
2139         _radiCard.status,
2140         _radiCard.cardIndex,
2141         _radiCard.benefactorIndex
2142         );
2143     }
2144 
2145     function tokenBenefactor(uint256 _tokenId)
2146     public view
2147     returns (
2148         address _ethAddress,
2149         string _name,
2150         string _website,
2151         string _logo
2152     ) {
2153         require(exists(_tokenId),"Card must exist");
2154         RadiCard memory _radiCard = tokenIdToRadiCardIndex[_tokenId];
2155         Benefactor memory _benefactor = benefactors[_radiCard.benefactorIndex];
2156         return (
2157         _benefactor.ethAddress,
2158         _benefactor.name,
2159         _benefactor.website,
2160         _benefactor.logo
2161         );
2162     }
2163 
2164     function tokensOf(address _owner) public view returns (uint256[] _tokenIds) {
2165         return ownedTokens[_owner];
2166     }
2167 
2168     function benefactorsKeys() public view returns (uint256[] _keys) {
2169         return benefactorsIndex;
2170     }
2171 
2172     function cardsKeys() public view returns (uint256[] _keys) {
2173         return cardsIndex;
2174     }
2175 
2176     function addBenefactor(uint256 _benefactorIndex, address _ethAddress, string _name, string _website, string _logo)
2177     public onlyIfWhitelisted(msg.sender)
2178     returns (bool) {
2179         require(address(_ethAddress) != address(0), "Invalid address");
2180         require(bytes(_name).length != 0, "Invalid name");
2181         require(bytes(_website).length != 0, "Invalid name");
2182         require(bytes(_logo).length != 0, "Invalid name");
2183 
2184         benefactors[_benefactorIndex] = Benefactor(
2185             _ethAddress,
2186             _name,
2187             _website,
2188             _logo
2189         );
2190         benefactorsIndex.push(_benefactorIndex);
2191 
2192         emit BenefactorAdded(_benefactorIndex);
2193         return true;
2194     }
2195 
2196     function addCard(uint256 _cardIndex, string _tokenURI, bool _active, uint256 _maxQnty, uint256 _minPrice)
2197     public onlyIfWhitelisted(msg.sender)
2198     returns (bool) {
2199         require(bytes(_tokenURI).length != 0, "Invalid token URI");
2200 
2201         cards[_cardIndex] = CardDesign(
2202             _tokenURI,
2203             _active,
2204             0,
2205             _maxQnty,
2206             _minPrice
2207         );
2208         cardsIndex.push(_cardIndex);
2209 
2210         emit CardAdded(_cardIndex);
2211         return true;
2212     }
2213 
2214     function setTokenBaseURI(string _newBaseURI) external onlyIfWhitelisted(msg.sender) {
2215         require(bytes(_newBaseURI).length != 0, "Base URI invalid");
2216 
2217         tokenBaseURI = _newBaseURI;
2218     }
2219 
2220     function setActive(uint256 _cardIndex, bool _active) external onlyIfWhitelisted(msg.sender) {
2221         require(bytes(cards[_cardIndex].tokenURI).length != 0, "Must specify existing card");
2222         cards[_cardIndex].active = _active;
2223     }
2224 
2225     function setMaxQuantity(uint256 _cardIndex, uint256 _maxQnty) external onlyIfWhitelisted(msg.sender) {
2226         require(bytes(cards[_cardIndex].tokenURI).length != 0, "Must specify existing card");
2227         require(cards[_cardIndex].minted <= _maxQnty, "Can't set the max quantity less than the current total minted");
2228         cards[_cardIndex].maxQnty = _maxQnty;
2229     }
2230 
2231     function setMinPrice(uint256 _cardIndex, uint256 _minPrice) external onlyIfWhitelisted(msg.sender) {
2232         require(bytes(cards[_cardIndex].tokenURI).length != 0, "Must specify existing card");
2233         cards[_cardIndex].minPrice = _minPrice;
2234     }
2235 
2236     function setDaiContractAddress(address _daiERC20ContractAddress) external onlyIfWhitelisted(msg.sender){
2237         require(_daiERC20ContractAddress != address(0), "Must be a valid address");
2238         daiContract = StandardToken(_daiERC20ContractAddress);
2239     }
2240 
2241     // sets the medianizer contract for the makerdao implementation used as a price oracle
2242     function setMedianizerContractAddress(address _MedianizerContractAddress) external onlyIfWhitelisted(msg.sender){
2243         require(_MedianizerContractAddress != address(0), "Must be a valid address");
2244         medianizerContract = Medianizer(_MedianizerContractAddress);
2245     }
2246 
2247     // returns the current ether price in usd. 18 decimal point precision used
2248     function getEtherPrice() public view returns(uint256){
2249         return uint256(medianizerContract.read());
2250     }
2251 
2252     // returns the value of ether in atto  (1 usd of ether = 10^18 atto)
2253     function getEthUsdValue(uint256 _ether) public view returns(uint256){
2254         return ((_ether*getEtherPrice())/(1 ether));
2255     }
2256 
2257     // returns the minimum required in wei for a particular card given the card min price in dai
2258     function getMinCardPriceInWei(uint256 _cardIndex) public view returns(uint256){
2259         return ((cards[_cardIndex].minPrice * 1 ether)/getEtherPrice());
2260     }
2261     // transfer tokens held by this contract in escrow to the recipient. Used when either claiming or cancelling gifts
2262     function transferFromEscrow(address _recipient,uint256 _tokenId) internal{
2263         require(super.ownerOf(_tokenId) == address(this),"The card must be owned by the contract for it to be in escrow");
2264         super.clearApproval(this, _tokenId);
2265         super.removeTokenFrom(this, _tokenId);
2266         super.addTokenTo(_recipient, _tokenId);
2267         emit Transfer(this, _recipient, _tokenId);
2268     }
2269 }