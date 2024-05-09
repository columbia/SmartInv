1 pragma solidity 0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Roles
55  * @author Francisco Giordano (@frangio)
56  * @dev Library for managing addresses assigned to a Role.
57  * See RBAC.sol for example usage.
58  */
59 library Roles {
60   struct Role {
61     mapping (address => bool) bearer;
62   }
63 
64   /**
65    * @dev give an address access to this role
66    */
67   function add(Role storage role, address addr)
68     internal
69   {
70     role.bearer[addr] = true;
71   }
72 
73   /**
74    * @dev remove an address' access to this role
75    */
76   function remove(Role storage role, address addr)
77     internal
78   {
79     role.bearer[addr] = false;
80   }
81 
82   /**
83    * @dev check if an address has this role
84    * // reverts
85    */
86   function check(Role storage role, address addr)
87     view
88     internal
89   {
90     require(has(role, addr));
91   }
92 
93   /**
94    * @dev check if an address has this role
95    * @return bool
96    */
97   function has(Role storage role, address addr)
98     view
99     internal
100     returns (bool)
101   {
102     return role.bearer[addr];
103   }
104 }
105 
106 /**
107  * @title RBAC (Role-Based Access Control)
108  * @author Matt Condon (@Shrugs)
109  * @dev Stores and provides setters and getters for roles and addresses.
110  * Supports unlimited numbers of roles and addresses.
111  * See //contracts/mocks/RBACMock.sol for an example of usage.
112  * This RBAC method uses strings to key roles. It may be beneficial
113  * for you to write your own implementation of this interface using Enums or similar.
114  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
115  * to avoid typos.
116  */
117 contract RBAC {
118   using Roles for Roles.Role;
119 
120   mapping (string => Roles.Role) private roles;
121 
122   event RoleAdded(address indexed operator, string role);
123   event RoleRemoved(address indexed operator, string role);
124 
125   /**
126    * @dev reverts if addr does not have role
127    * @param _operator address
128    * @param _role the name of the role
129    * // reverts
130    */
131   function checkRole(address _operator, string _role)
132     view
133     public
134   {
135     roles[_role].check(_operator);
136   }
137 
138   /**
139    * @dev determine if addr has role
140    * @param _operator address
141    * @param _role the name of the role
142    * @return bool
143    */
144   function hasRole(address _operator, string _role)
145     view
146     public
147     returns (bool)
148   {
149     return roles[_role].has(_operator);
150   }
151 
152   /**
153    * @dev add a role to an address
154    * @param _operator address
155    * @param _role the name of the role
156    */
157   function addRole(address _operator, string _role)
158     internal
159   {
160     roles[_role].add(_operator);
161     emit RoleAdded(_operator, _role);
162   }
163 
164   /**
165    * @dev remove a role from an address
166    * @param _operator address
167    * @param _role the name of the role
168    */
169   function removeRole(address _operator, string _role)
170     internal
171   {
172     roles[_role].remove(_operator);
173     emit RoleRemoved(_operator, _role);
174   }
175 
176   /**
177    * @dev modifier to scope access to a single role (uses msg.sender as addr)
178    * @param _role the name of the role
179    * // reverts
180    */
181   modifier onlyRole(string _role)
182   {
183     checkRole(msg.sender, _role);
184     _;
185   }
186 
187   /**
188    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
189    * @param _roles the names of the roles to scope access to
190    * // reverts
191    *
192    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
193    *  see: https://github.com/ethereum/solidity/issues/2467
194    */
195   // modifier onlyRoles(string[] _roles) {
196   //     bool hasAnyRole = false;
197   //     for (uint8 i = 0; i < _roles.length; i++) {
198   //         if (hasRole(msg.sender, _roles[i])) {
199   //             hasAnyRole = true;
200   //             break;
201   //         }
202   //     }
203 
204   //     require(hasAnyRole);
205 
206   //     _;
207   // }
208 }
209 
210 /**
211  * @title Ownable
212  * @dev The Ownable contract has an owner address, and provides basic authorization control
213  * functions, this simplifies the implementation of "user permissions".
214  */
215 contract Ownable {
216   address public owner;
217 
218 
219   event OwnershipRenounced(address indexed previousOwner);
220   event OwnershipTransferred(
221     address indexed previousOwner,
222     address indexed newOwner
223   );
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   constructor() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to relinquish control of the contract.
244    * @notice Renouncing to ownership will leave the contract without an owner.
245    * It will not be possible to call the functions with the `onlyOwner`
246    * modifier anymore.
247    */
248   function renounceOwnership() public onlyOwner {
249     emit OwnershipRenounced(owner);
250     owner = address(0);
251   }
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param _newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address _newOwner) public onlyOwner {
258     _transferOwnership(_newOwner);
259   }
260 
261   /**
262    * @dev Transfers control of the contract to a newOwner.
263    * @param _newOwner The address to transfer ownership to.
264    */
265   function _transferOwnership(address _newOwner) internal {
266     require(_newOwner != address(0));
267     emit OwnershipTransferred(owner, _newOwner);
268     owner = _newOwner;
269   }
270 }
271 
272 /**
273  * @title Contracts that should not own Ether
274  * @author Remco Bloemen <remco@2π.com>
275  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
276  * in the contract, it will allow the owner to reclaim this ether.
277  * @notice Ether can still be sent to this contract by:
278  * calling functions labeled `payable`
279  * `selfdestruct(contract_address)`
280  * mining directly to the contract address
281  */
282 contract HasNoEther is Ownable {
283 
284   /**
285   * @dev Constructor that rejects incoming Ether
286   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
287   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
288   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
289   * we could use assembly to access msg.value.
290   */
291   constructor() public payable {
292     require(msg.value == 0);
293   }
294 
295   /**
296    * @dev Disallows direct send by settings a default function without the `payable` flag.
297    */
298   function() external {
299   }
300 
301   /**
302    * @dev Transfer all Ether held by the contract to the owner.
303    */
304   function reclaimEther() external onlyOwner {
305     owner.transfer(address(this).balance);
306   }
307 }
308 
309 /**
310  * @title Whitelist
311  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
312  * This simplifies the implementation of "user permissions".
313  */
314 contract Whitelist is Ownable, RBAC {
315   string public constant ROLE_WHITELISTED = "whitelist";
316 
317   /**
318    * @dev Throws if operator is not whitelisted.
319    * @param _operator address
320    */
321   modifier onlyIfWhitelisted(address _operator) {
322     checkRole(_operator, ROLE_WHITELISTED);
323     _;
324   }
325 
326   /**
327    * @dev add an address to the whitelist
328    * @param _operator address
329    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
330    */
331   function addAddressToWhitelist(address _operator)
332     onlyOwner
333     public
334   {
335     addRole(_operator, ROLE_WHITELISTED);
336   }
337 
338   /**
339    * @dev getter to determine if address is in whitelist
340    */
341   function whitelist(address _operator)
342     public
343     view
344     returns (bool)
345   {
346     return hasRole(_operator, ROLE_WHITELISTED);
347   }
348 
349   /**
350    * @dev add addresses to the whitelist
351    * @param _operators addresses
352    * @return true if at least one address was added to the whitelist,
353    * false if all addresses were already in the whitelist
354    */
355   function addAddressesToWhitelist(address[] _operators)
356     onlyOwner
357     public
358   {
359     for (uint256 i = 0; i < _operators.length; i++) {
360       addAddressToWhitelist(_operators[i]);
361     }
362   }
363 
364   /**
365    * @dev remove an address from the whitelist
366    * @param _operator address
367    * @return true if the address was removed from the whitelist,
368    * false if the address wasn't in the whitelist in the first place
369    */
370   function removeAddressFromWhitelist(address _operator)
371     onlyOwner
372     public
373   {
374     removeRole(_operator, ROLE_WHITELISTED);
375   }
376 
377   /**
378    * @dev remove addresses from the whitelist
379    * @param _operators addresses
380    * @return true if at least one address was removed from the whitelist,
381    * false if all addresses weren't in the whitelist in the first place
382    */
383   function removeAddressesFromWhitelist(address[] _operators)
384     onlyOwner
385     public
386   {
387     for (uint256 i = 0; i < _operators.length; i++) {
388       removeAddressFromWhitelist(_operators[i]);
389     }
390   }
391 
392 }
393 
394 
395 
396 /**
397  * Utility library of inline functions on addresses
398  */
399 library AddressUtils {
400 
401   /**
402    * Returns whether the target address is a contract
403    * @dev This function will return false if invoked during the constructor of a contract,
404    * as the code is not actually created until after the constructor finishes.
405    * @param addr address to check
406    * @return whether the target address is a contract
407    */
408   function isContract(address addr) internal view returns (bool) {
409     uint256 size;
410     // XXX Currently there is no better way to check if there is a contract in an address
411     // than to check the size of the code at that address.
412     // See https://ethereum.stackexchange.com/a/14016/36603
413     // for more details about how this works.
414     // TODO Check this again before the Serenity release, because all addresses will be
415     // contracts then.
416     // solium-disable-next-line security/no-inline-assembly
417     assembly { size := extcodesize(addr) }
418     return size > 0;
419   }
420 
421 }
422 
423 
424 /**
425  * @title ERC165
426  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
427  */
428 interface ERC165 {
429 
430   /**
431    * @notice Query if a contract implements an interface
432    * @param _interfaceId The interface identifier, as specified in ERC-165
433    * @dev Interface identification is specified in ERC-165. This function
434    * uses less than 30,000 gas.
435    */
436   function supportsInterface(bytes4 _interfaceId)
437     external
438     view
439     returns (bool);
440 }
441 
442 /**
443  * @title SupportsInterfaceWithLookup
444  * @author Matt Condon (@shrugs)
445  * @dev Implements ERC165 using a lookup table.
446  */
447 contract SupportsInterfaceWithLookup is ERC165 {
448   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
449   /**
450    * 0x01ffc9a7 ===
451    *   bytes4(keccak256('supportsInterface(bytes4)'))
452    */
453 
454   /**
455    * @dev a mapping of interface id to whether or not it's supported
456    */
457   mapping(bytes4 => bool) internal supportedInterfaces;
458 
459   /**
460    * @dev A contract implementing SupportsInterfaceWithLookup
461    * implement ERC165 itself
462    */
463   constructor()
464     public
465   {
466     _registerInterface(InterfaceId_ERC165);
467   }
468 
469   /**
470    * @dev implement supportsInterface(bytes4) using a lookup table
471    */
472   function supportsInterface(bytes4 _interfaceId)
473     external
474     view
475     returns (bool)
476   {
477     return supportedInterfaces[_interfaceId];
478   }
479 
480   /**
481    * @dev private method for registering an interface
482    */
483   function _registerInterface(bytes4 _interfaceId)
484     internal
485   {
486     require(_interfaceId != 0xffffffff);
487     supportedInterfaces[_interfaceId] = true;
488   }
489 }
490 
491 /**
492  * @title ERC721 Non-Fungible Token Standard basic interface
493  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
494  */
495 contract ERC721Basic is ERC165 {
496   event Transfer(
497     address indexed _from,
498     address indexed _to,
499     uint256 indexed _tokenId
500   );
501   event Approval(
502     address indexed _owner,
503     address indexed _approved,
504     uint256 indexed _tokenId
505   );
506   event ApprovalForAll(
507     address indexed _owner,
508     address indexed _operator,
509     bool _approved
510   );
511 
512   function balanceOf(address _owner) public view returns (uint256 _balance);
513   function ownerOf(uint256 _tokenId) public view returns (address _owner);
514   function exists(uint256 _tokenId) public view returns (bool _exists);
515 
516   function approve(address _to, uint256 _tokenId) public;
517   function getApproved(uint256 _tokenId)
518     public view returns (address _operator);
519 
520   function setApprovalForAll(address _operator, bool _approved) public;
521   function isApprovedForAll(address _owner, address _operator)
522     public view returns (bool);
523 
524   function transferFrom(address _from, address _to, uint256 _tokenId) public;
525   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
526     public;
527 
528   function safeTransferFrom(
529     address _from,
530     address _to,
531     uint256 _tokenId,
532     bytes _data
533   )
534     public;
535 }
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 contract ERC721Receiver {
543   /**
544    * @dev Magic value to be returned upon successful reception of an NFT
545    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
546    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
547    */
548   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
549 
550   /**
551    * @notice Handle the receipt of an NFT
552    * @dev The ERC721 smart contract calls this function on the recipient
553    * after a `safetransfer`. This function MAY throw to revert and reject the
554    * transfer. Return of other than the magic value MUST result in the 
555    * transaction being reverted.
556    * Note: the contract address is always the message sender.
557    * @param _operator The address which called `safeTransferFrom` function
558    * @param _from The address which previously owned the token
559    * @param _tokenId The NFT identifier which is being transfered
560    * @param _data Additional data with no specified format
561    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
562    */
563   function onERC721Received(
564     address _operator,
565     address _from,
566     uint256 _tokenId,
567     bytes _data
568   )
569     public
570     returns(bytes4);
571 }
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
576  */
577 contract ERC721Enumerable is ERC721Basic {
578   function totalSupply() public view returns (uint256);
579   function tokenOfOwnerByIndex(
580     address _owner,
581     uint256 _index
582   )
583     public
584     view
585     returns (uint256 _tokenId);
586 
587   function tokenByIndex(uint256 _index) public view returns (uint256);
588 }
589 
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
593  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
594  */
595 contract ERC721Metadata is ERC721Basic {
596   function name() external view returns (string _name);
597   function symbol() external view returns (string _symbol);
598   function tokenURI(uint256 _tokenId) public view returns (string);
599 }
600 
601 
602 /**
603  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
604  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
605  */
606 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
607 }
608 
609 
610 /**
611  * @title ERC721 Non-Fungible Token Standard basic implementation
612  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
613  */
614 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
615 
616   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
617   /*
618    * 0x80ac58cd ===
619    *   bytes4(keccak256('balanceOf(address)')) ^
620    *   bytes4(keccak256('ownerOf(uint256)')) ^
621    *   bytes4(keccak256('approve(address,uint256)')) ^
622    *   bytes4(keccak256('getApproved(uint256)')) ^
623    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
624    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
625    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
626    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
627    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
628    */
629 
630   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
631   /*
632    * 0x4f558e79 ===
633    *   bytes4(keccak256('exists(uint256)'))
634    */
635 
636   using SafeMath for uint256;
637   using AddressUtils for address;
638 
639   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
640   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
641   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
642 
643   // Mapping from token ID to owner
644   mapping (uint256 => address) internal tokenOwner;
645 
646   // Mapping from token ID to approved address
647   mapping (uint256 => address) internal tokenApprovals;
648 
649   // Mapping from owner to number of owned token
650   mapping (address => uint256) internal ownedTokensCount;
651 
652   // Mapping from owner to operator approvals
653   mapping (address => mapping (address => bool)) internal operatorApprovals;
654 
655   /**
656    * @dev Guarantees msg.sender is owner of the given token
657    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
658    */
659   modifier onlyOwnerOf(uint256 _tokenId) {
660     require(ownerOf(_tokenId) == msg.sender);
661     _;
662   }
663 
664   /**
665    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
666    * @param _tokenId uint256 ID of the token to validate
667    */
668   modifier canTransfer(uint256 _tokenId) {
669     require(isApprovedOrOwner(msg.sender, _tokenId));
670     _;
671   }
672 
673   constructor()
674     public
675   {
676     // register the supported interfaces to conform to ERC721 via ERC165
677     _registerInterface(InterfaceId_ERC721);
678     _registerInterface(InterfaceId_ERC721Exists);
679   }
680 
681   /**
682    * @dev Gets the balance of the specified address
683    * @param _owner address to query the balance of
684    * @return uint256 representing the amount owned by the passed address
685    */
686   function balanceOf(address _owner) public view returns (uint256) {
687     require(_owner != address(0));
688     return ownedTokensCount[_owner];
689   }
690 
691   /**
692    * @dev Gets the owner of the specified token ID
693    * @param _tokenId uint256 ID of the token to query the owner of
694    * @return owner address currently marked as the owner of the given token ID
695    */
696   function ownerOf(uint256 _tokenId) public view returns (address) {
697     address owner = tokenOwner[_tokenId];
698     require(owner != address(0));
699     return owner;
700   }
701 
702   /**
703    * @dev Returns whether the specified token exists
704    * @param _tokenId uint256 ID of the token to query the existence of
705    * @return whether the token exists
706    */
707   function exists(uint256 _tokenId) public view returns (bool) {
708     address owner = tokenOwner[_tokenId];
709     return owner != address(0);
710   }
711 
712   /**
713    * @dev Approves another address to transfer the given token ID
714    * The zero address indicates there is no approved address.
715    * There can only be one approved address per token at a given time.
716    * Can only be called by the token owner or an approved operator.
717    * @param _to address to be approved for the given token ID
718    * @param _tokenId uint256 ID of the token to be approved
719    */
720   function approve(address _to, uint256 _tokenId) public {
721     address owner = ownerOf(_tokenId);
722     require(_to != owner);
723     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
724 
725     tokenApprovals[_tokenId] = _to;
726     emit Approval(owner, _to, _tokenId);
727   }
728 
729   /**
730    * @dev Gets the approved address for a token ID, or zero if no address set
731    * @param _tokenId uint256 ID of the token to query the approval of
732    * @return address currently approved for the given token ID
733    */
734   function getApproved(uint256 _tokenId) public view returns (address) {
735     return tokenApprovals[_tokenId];
736   }
737 
738   /**
739    * @dev Sets or unsets the approval of a given operator
740    * An operator is allowed to transfer all tokens of the sender on their behalf
741    * @param _to operator address to set the approval
742    * @param _approved representing the status of the approval to be set
743    */
744   function setApprovalForAll(address _to, bool _approved) public {
745     require(_to != msg.sender);
746     operatorApprovals[msg.sender][_to] = _approved;
747     emit ApprovalForAll(msg.sender, _to, _approved);
748   }
749 
750   /**
751    * @dev Tells whether an operator is approved by a given owner
752    * @param _owner owner address which you want to query the approval of
753    * @param _operator operator address which you want to query the approval of
754    * @return bool whether the given operator is approved by the given owner
755    */
756   function isApprovedForAll(
757     address _owner,
758     address _operator
759   )
760     public
761     view
762     returns (bool)
763   {
764     return operatorApprovals[_owner][_operator];
765   }
766 
767   /**
768    * @dev Transfers the ownership of a given token ID to another address
769    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
770    * Requires the msg sender to be the owner, approved, or operator
771    * @param _from current owner of the token
772    * @param _to address to receive the ownership of the given token ID
773    * @param _tokenId uint256 ID of the token to be transferred
774   */
775   function transferFrom(
776     address _from,
777     address _to,
778     uint256 _tokenId
779   )
780     public
781     canTransfer(_tokenId)
782   {
783     require(_from != address(0));
784     require(_to != address(0));
785 
786     clearApproval(_from, _tokenId);
787     removeTokenFrom(_from, _tokenId);
788     addTokenTo(_to, _tokenId);
789 
790     emit Transfer(_from, _to, _tokenId);
791   }
792 
793   /**
794    * @dev Safely transfers the ownership of a given token ID to another address
795    * If the target address is a contract, it must implement `onERC721Received`,
796    * which is called upon a safe transfer, and return the magic value
797    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
798    * the transfer is reverted.
799    *
800    * Requires the msg sender to be the owner, approved, or operator
801    * @param _from current owner of the token
802    * @param _to address to receive the ownership of the given token ID
803    * @param _tokenId uint256 ID of the token to be transferred
804   */
805   function safeTransferFrom(
806     address _from,
807     address _to,
808     uint256 _tokenId
809   )
810     public
811     canTransfer(_tokenId)
812   {
813     // solium-disable-next-line arg-overflow
814     safeTransferFrom(_from, _to, _tokenId, "");
815   }
816 
817   /**
818    * @dev Safely transfers the ownership of a given token ID to another address
819    * If the target address is a contract, it must implement `onERC721Received`,
820    * which is called upon a safe transfer, and return the magic value
821    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
822    * the transfer is reverted.
823    * Requires the msg sender to be the owner, approved, or operator
824    * @param _from current owner of the token
825    * @param _to address to receive the ownership of the given token ID
826    * @param _tokenId uint256 ID of the token to be transferred
827    * @param _data bytes data to send along with a safe transfer check
828    */
829   function safeTransferFrom(
830     address _from,
831     address _to,
832     uint256 _tokenId,
833     bytes _data
834   )
835     public
836     canTransfer(_tokenId)
837   {
838     transferFrom(_from, _to, _tokenId);
839     // solium-disable-next-line arg-overflow
840     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
841   }
842 
843   /**
844    * @dev Returns whether the given spender can transfer a given token ID
845    * @param _spender address of the spender to query
846    * @param _tokenId uint256 ID of the token to be transferred
847    * @return bool whether the msg.sender is approved for the given token ID,
848    *  is an operator of the owner, or is the owner of the token
849    */
850   function isApprovedOrOwner(
851     address _spender,
852     uint256 _tokenId
853   )
854     internal
855     view
856     returns (bool)
857   {
858     address owner = ownerOf(_tokenId);
859     // Disable solium check because of
860     // https://github.com/duaraghav8/Solium/issues/175
861     // solium-disable-next-line operator-whitespace
862     return (
863       _spender == owner ||
864       getApproved(_tokenId) == _spender ||
865       isApprovedForAll(owner, _spender)
866     );
867   }
868 
869   /**
870    * @dev Internal function to mint a new token
871    * Reverts if the given token ID already exists
872    * @param _to The address that will own the minted token
873    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
874    */
875   function _mint(address _to, uint256 _tokenId) internal {
876     require(_to != address(0));
877     addTokenTo(_to, _tokenId);
878     emit Transfer(address(0), _to, _tokenId);
879   }
880 
881   /**
882    * @dev Internal function to burn a specific token
883    * Reverts if the token does not exist
884    * @param _tokenId uint256 ID of the token being burned by the msg.sender
885    */
886   function _burn(address _owner, uint256 _tokenId) internal {
887     clearApproval(_owner, _tokenId);
888     removeTokenFrom(_owner, _tokenId);
889     emit Transfer(_owner, address(0), _tokenId);
890   }
891 
892   /**
893    * @dev Internal function to clear current approval of a given token ID
894    * Reverts if the given address is not indeed the owner of the token
895    * @param _owner owner of the token
896    * @param _tokenId uint256 ID of the token to be transferred
897    */
898   function clearApproval(address _owner, uint256 _tokenId) internal {
899     require(ownerOf(_tokenId) == _owner);
900     if (tokenApprovals[_tokenId] != address(0)) {
901       tokenApprovals[_tokenId] = address(0);
902     }
903   }
904 
905   /**
906    * @dev Internal function to add a token ID to the list of a given address
907    * @param _to address representing the new owner of the given token ID
908    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
909    */
910   function addTokenTo(address _to, uint256 _tokenId) internal {
911     require(tokenOwner[_tokenId] == address(0));
912     tokenOwner[_tokenId] = _to;
913     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
914   }
915 
916   /**
917    * @dev Internal function to remove a token ID from the list of a given address
918    * @param _from address representing the previous owner of the given token ID
919    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
920    */
921   function removeTokenFrom(address _from, uint256 _tokenId) internal {
922     require(ownerOf(_tokenId) == _from);
923     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
924     tokenOwner[_tokenId] = address(0);
925   }
926 
927   /**
928    * @dev Internal function to invoke `onERC721Received` on a target address
929    * The call is not executed if the target address is not a contract
930    * @param _from address representing the previous owner of the given token ID
931    * @param _to target address that will receive the tokens
932    * @param _tokenId uint256 ID of the token to be transferred
933    * @param _data bytes optional data to send along with the call
934    * @return whether the call correctly returned the expected magic value
935    */
936   function checkAndCallSafeTransfer(
937     address _from,
938     address _to,
939     uint256 _tokenId,
940     bytes _data
941   )
942     internal
943     returns (bool)
944   {
945     if (!_to.isContract()) {
946       return true;
947     }
948     bytes4 retval = ERC721Receiver(_to).onERC721Received(
949       msg.sender, _from, _tokenId, _data);
950     return (retval == ERC721_RECEIVED);
951   }
952 }
953 
954 
955 /**
956  * @title Full ERC721 Token
957  * This implementation includes all the required and some optional functionality of the ERC721 standard
958  * Moreover, it includes approve all functionality using operator terminology
959  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
960  */
961 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
962 
963   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
964   /**
965    * 0x780e9d63 ===
966    *   bytes4(keccak256('totalSupply()')) ^
967    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
968    *   bytes4(keccak256('tokenByIndex(uint256)'))
969    */
970 
971   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
972   /**
973    * 0x5b5e139f ===
974    *   bytes4(keccak256('name()')) ^
975    *   bytes4(keccak256('symbol()')) ^
976    *   bytes4(keccak256('tokenURI(uint256)'))
977    */
978 
979   // Token name
980   string internal name_;
981 
982   // Token symbol
983   string internal symbol_;
984 
985   // Mapping from owner to list of owned token IDs
986   mapping(address => uint256[]) internal ownedTokens;
987 
988   // Mapping from token ID to index of the owner tokens list
989   mapping(uint256 => uint256) internal ownedTokensIndex;
990 
991   // Array with all token ids, used for enumeration
992   uint256[] internal allTokens;
993 
994   // Mapping from token id to position in the allTokens array
995   mapping(uint256 => uint256) internal allTokensIndex;
996 
997   // Optional mapping for token URIs
998   mapping(uint256 => string) internal tokenURIs;
999 
1000   /**
1001    * @dev Constructor function
1002    */
1003   constructor(string _name, string _symbol) public {
1004     name_ = _name;
1005     symbol_ = _symbol;
1006 
1007     // register the supported interfaces to conform to ERC721 via ERC165
1008     _registerInterface(InterfaceId_ERC721Enumerable);
1009     _registerInterface(InterfaceId_ERC721Metadata);
1010   }
1011 
1012   /**
1013    * @dev Gets the token name
1014    * @return string representing the token name
1015    */
1016   function name() external view returns (string) {
1017     return name_;
1018   }
1019 
1020   /**
1021    * @dev Gets the token symbol
1022    * @return string representing the token symbol
1023    */
1024   function symbol() external view returns (string) {
1025     return symbol_;
1026   }
1027 
1028   /**
1029    * @dev Returns an URI for a given token ID
1030    * Throws if the token ID does not exist. May return an empty string.
1031    * @param _tokenId uint256 ID of the token to query
1032    */
1033   function tokenURI(uint256 _tokenId) public view returns (string) {
1034     require(exists(_tokenId));
1035     return tokenURIs[_tokenId];
1036   }
1037 
1038   /**
1039    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1040    * @param _owner address owning the tokens list to be accessed
1041    * @param _index uint256 representing the index to be accessed of the requested tokens list
1042    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1043    */
1044   function tokenOfOwnerByIndex(
1045     address _owner,
1046     uint256 _index
1047   )
1048     public
1049     view
1050     returns (uint256)
1051   {
1052     require(_index < balanceOf(_owner));
1053     return ownedTokens[_owner][_index];
1054   }
1055 
1056   /**
1057    * @dev Gets the total amount of tokens stored by the contract
1058    * @return uint256 representing the total amount of tokens
1059    */
1060   function totalSupply() public view returns (uint256) {
1061     return allTokens.length;
1062   }
1063 
1064   /**
1065    * @dev Gets the token ID at a given index of all the tokens in this contract
1066    * Reverts if the index is greater or equal to the total number of tokens
1067    * @param _index uint256 representing the index to be accessed of the tokens list
1068    * @return uint256 token ID at the given index of the tokens list
1069    */
1070   function tokenByIndex(uint256 _index) public view returns (uint256) {
1071     require(_index < totalSupply());
1072     return allTokens[_index];
1073   }
1074 
1075   /**
1076    * @dev Internal function to set the token URI for a given token
1077    * Reverts if the token ID does not exist
1078    * @param _tokenId uint256 ID of the token to set its URI
1079    * @param _uri string URI to assign
1080    */
1081   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1082     require(exists(_tokenId));
1083     tokenURIs[_tokenId] = _uri;
1084   }
1085 
1086   /**
1087    * @dev Internal function to add a token ID to the list of a given address
1088    * @param _to address representing the new owner of the given token ID
1089    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1090    */
1091   function addTokenTo(address _to, uint256 _tokenId) internal {
1092     super.addTokenTo(_to, _tokenId);
1093     uint256 length = ownedTokens[_to].length;
1094     ownedTokens[_to].push(_tokenId);
1095     ownedTokensIndex[_tokenId] = length;
1096   }
1097 
1098   /**
1099    * @dev Internal function to remove a token ID from the list of a given address
1100    * @param _from address representing the previous owner of the given token ID
1101    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1102    */
1103   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1104     super.removeTokenFrom(_from, _tokenId);
1105 
1106     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1107     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1108     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1109 
1110     ownedTokens[_from][tokenIndex] = lastToken;
1111     ownedTokens[_from][lastTokenIndex] = 0;
1112     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1113     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1114     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1115 
1116     ownedTokens[_from].length--;
1117     ownedTokensIndex[_tokenId] = 0;
1118     ownedTokensIndex[lastToken] = tokenIndex;
1119   }
1120 
1121   /**
1122    * @dev Internal function to mint a new token
1123    * Reverts if the given token ID already exists
1124    * @param _to address the beneficiary that will own the minted token
1125    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1126    */
1127   function _mint(address _to, uint256 _tokenId) internal {
1128     super._mint(_to, _tokenId);
1129 
1130     allTokensIndex[_tokenId] = allTokens.length;
1131     allTokens.push(_tokenId);
1132   }
1133 
1134   /**
1135    * @dev Internal function to burn a specific token
1136    * Reverts if the token does not exist
1137    * @param _owner owner of the token to burn
1138    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1139    */
1140   function _burn(address _owner, uint256 _tokenId) internal {
1141     super._burn(_owner, _tokenId);
1142 
1143     // Clear metadata (if any)
1144     if (bytes(tokenURIs[_tokenId]).length != 0) {
1145       delete tokenURIs[_tokenId];
1146     }
1147 
1148     // Reorg all tokens array
1149     uint256 tokenIndex = allTokensIndex[_tokenId];
1150     uint256 lastTokenIndex = allTokens.length.sub(1);
1151     uint256 lastToken = allTokens[lastTokenIndex];
1152 
1153     allTokens[tokenIndex] = lastToken;
1154     allTokens[lastTokenIndex] = 0;
1155 
1156     allTokens.length--;
1157     allTokensIndex[_tokenId] = 0;
1158     allTokensIndex[lastToken] = tokenIndex;
1159   }
1160 
1161 }
1162 
1163 contract CryptantCrabStoreInterface {
1164   function createAddress(bytes32 key, address value) external returns (bool);
1165   function createAddresses(bytes32[] keys, address[] values) external returns (bool);
1166   function updateAddress(bytes32 key, address value) external returns (bool);
1167   function updateAddresses(bytes32[] keys, address[] values) external returns (bool);
1168   function removeAddress(bytes32 key) external returns (bool);
1169   function removeAddresses(bytes32[] keys) external returns (bool);
1170   function readAddress(bytes32 key) external view returns (address);
1171   function readAddresses(bytes32[] keys) external view returns (address[]);
1172   // Bool related functions
1173   function createBool(bytes32 key, bool value) external returns (bool);
1174   function createBools(bytes32[] keys, bool[] values) external returns (bool);
1175   function updateBool(bytes32 key, bool value) external returns (bool);
1176   function updateBools(bytes32[] keys, bool[] values) external returns (bool);
1177   function removeBool(bytes32 key) external returns (bool);
1178   function removeBools(bytes32[] keys) external returns (bool);
1179   function readBool(bytes32 key) external view returns (bool);
1180   function readBools(bytes32[] keys) external view returns (bool[]);
1181   // Bytes32 related functions
1182   function createBytes32(bytes32 key, bytes32 value) external returns (bool);
1183   function createBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
1184   function updateBytes32(bytes32 key, bytes32 value) external returns (bool);
1185   function updateBytes32s(bytes32[] keys, bytes32[] values) external returns (bool);
1186   function removeBytes32(bytes32 key) external returns (bool);
1187   function removeBytes32s(bytes32[] keys) external returns (bool);
1188   function readBytes32(bytes32 key) external view returns (bytes32);
1189   function readBytes32s(bytes32[] keys) external view returns (bytes32[]);
1190   // uint256 related functions
1191   function createUint256(bytes32 key, uint256 value) external returns (bool);
1192   function createUint256s(bytes32[] keys, uint256[] values) external returns (bool);
1193   function updateUint256(bytes32 key, uint256 value) external returns (bool);
1194   function updateUint256s(bytes32[] keys, uint256[] values) external returns (bool);
1195   function removeUint256(bytes32 key) external returns (bool);
1196   function removeUint256s(bytes32[] keys) external returns (bool);
1197   function readUint256(bytes32 key) external view returns (uint256);
1198   function readUint256s(bytes32[] keys) external view returns (uint256[]);
1199   // int256 related functions
1200   function createInt256(bytes32 key, int256 value) external returns (bool);
1201   function createInt256s(bytes32[] keys, int256[] values) external returns (bool);
1202   function updateInt256(bytes32 key, int256 value) external returns (bool);
1203   function updateInt256s(bytes32[] keys, int256[] values) external returns (bool);
1204   function removeInt256(bytes32 key) external returns (bool);
1205   function removeInt256s(bytes32[] keys) external returns (bool);
1206   function readInt256(bytes32 key) external view returns (int256);
1207   function readInt256s(bytes32[] keys) external view returns (int256[]);
1208   // internal functions
1209   function parseKey(bytes32 key) internal pure returns (bytes32);
1210   function parseKeys(bytes32[] _keys) internal pure returns (bytes32[]);
1211 }
1212 
1213 interface GenesisCrabInterface {
1214   function generateCrabGene(bool isPresale, bool hasLegendaryPart) external returns (uint256 _gene, uint256 _skin, uint256 _heartValue, uint256 _growthValue);
1215   function mutateCrabPart(uint256 _part, uint256 _existingPartGene, uint256 _legendaryPercentage) external view returns (uint256);
1216   function generateCrabHeart() external view returns (uint256, uint256);
1217 }
1218 
1219 contract CrabData {
1220   modifier crabDataLength(uint256[] memory _crabData) {
1221     require(_crabData.length == 8);
1222     _;
1223   }
1224 
1225   struct CrabPartData {
1226     uint256 hp;
1227     uint256 dps;
1228     uint256 blockRate;
1229     uint256 resistanceBonus;
1230     uint256 hpBonus;
1231     uint256 dpsBonus;
1232     uint256 blockBonus;
1233     uint256 mutiplierBonus;
1234   }
1235 
1236   function arrayToCrabPartData(
1237     uint256[] _partData
1238   ) 
1239     internal 
1240     pure 
1241     crabDataLength(_partData) 
1242     returns (CrabPartData memory _parsedData) 
1243   {
1244     _parsedData = CrabPartData(
1245       _partData[0],   // hp
1246       _partData[1],   // dps
1247       _partData[2],   // block rate
1248       _partData[3],   // resistance bonus
1249       _partData[4],   // hp bonus
1250       _partData[5],   // dps bonus
1251       _partData[6],   // block bonus
1252       _partData[7]);  // multiplier bonus
1253   }
1254 
1255   function crabPartDataToArray(CrabPartData _crabPartData) internal pure returns (uint256[] memory _resultData) {
1256     _resultData = new uint256[](8);
1257     _resultData[0] = _crabPartData.hp;
1258     _resultData[1] = _crabPartData.dps;
1259     _resultData[2] = _crabPartData.blockRate;
1260     _resultData[3] = _crabPartData.resistanceBonus;
1261     _resultData[4] = _crabPartData.hpBonus;
1262     _resultData[5] = _crabPartData.dpsBonus;
1263     _resultData[6] = _crabPartData.blockBonus;
1264     _resultData[7] = _crabPartData.mutiplierBonus;
1265   }
1266 }
1267 
1268 
1269 contract GeneSurgeon {
1270   //0 - filler, 1 - body, 2 - leg, 3 - left claw, 4 - right claw
1271   uint256[] internal crabPartMultiplier = [0, 10**9, 10**6, 10**3, 1];
1272 
1273   function extractElementsFromGene(uint256 _gene) internal view returns (uint256[] memory _elements) {
1274     _elements = new uint256[](4);
1275     _elements[0] = _gene / crabPartMultiplier[1] / 100 % 10;
1276     _elements[1] = _gene / crabPartMultiplier[2] / 100 % 10;
1277     _elements[2] = _gene / crabPartMultiplier[3] / 100 % 10;
1278     _elements[3] = _gene / crabPartMultiplier[4] / 100 % 10;
1279   }
1280 
1281   function extractPartsFromGene(uint256 _gene) internal view returns (uint256[] memory _parts) {
1282     _parts = new uint256[](4);
1283     _parts[0] = _gene / crabPartMultiplier[1] % 100;
1284     _parts[1] = _gene / crabPartMultiplier[2] % 100;
1285     _parts[2] = _gene / crabPartMultiplier[3] % 100;
1286     _parts[3] = _gene / crabPartMultiplier[4] % 100;
1287   }
1288 }
1289 
1290 contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
1291   event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);
1292   event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1293   event DefaultMetadataURIChanged(string newUri);
1294 
1295   /**
1296    * @dev Pre-generated keys to save gas
1297    * keys are generated with:
1298    * CRAB_BODY       = bytes4(keccak256("crab_body"))       = 0xc398430e
1299    * CRAB_LEG        = bytes4(keccak256("crab_leg"))        = 0x889063b1
1300    * CRAB_LEFT_CLAW  = bytes4(keccak256("crab_left_claw"))  = 0xdb6290a2
1301    * CRAB_RIGHT_CLAW = bytes4(keccak256("crab_right_claw")) = 0x13453f89
1302    */
1303   bytes4 internal constant CRAB_BODY = 0xc398430e;
1304   bytes4 internal constant CRAB_LEG = 0x889063b1;
1305   bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
1306   bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
1307 
1308   /**
1309    * @dev Stores all the crab data
1310    */
1311   mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
1312 
1313   /**
1314    * @dev Mapping from tokenId to its corresponding special skin
1315    * tokenId with default skin will not be stored. 
1316    */
1317   mapping(uint256 => uint256) internal crabSpecialSkins;
1318 
1319   /**
1320    * @dev default MetadataURI
1321    */
1322   string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";
1323 
1324   constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {
1325     // constructor
1326     initiateCrabPartData();
1327   }
1328 
1329   /**
1330    * @dev Returns an URI for a given token ID
1331    * Throws if the token ID does not exist.
1332    * Will return the token's metadata URL if it has one, 
1333    * otherwise will just return base on the default metadata URI
1334    * @param _tokenId uint256 ID of the token to query
1335    */
1336   function tokenURI(uint256 _tokenId) public view returns (string) {
1337     require(exists(_tokenId));
1338 
1339     string memory _uri = tokenURIs[_tokenId];
1340 
1341     if(bytes(_uri).length == 0) {
1342       _uri = getMetadataURL(bytes(defaultMetadataURI), _tokenId);
1343     }
1344 
1345     return _uri;
1346   }
1347 
1348   /**
1349    * @dev Returns the data of a specific parts
1350    * @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1351    * @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1352    * @param _setIndex the set index of for the specified part. This will starts from 1.
1353    */
1354   function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
1355     bytes4 _key;
1356     if(_partIndex == 1) {
1357       _key = CRAB_BODY;
1358     } else if(_partIndex == 2) {
1359       _key = CRAB_LEG;
1360     } else if(_partIndex == 3) {
1361       _key = CRAB_LEFT_CLAW;
1362     } else if(_partIndex == 4) {
1363       _key = CRAB_RIGHT_CLAW;
1364     } else {
1365       revert();
1366     }
1367 
1368     CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
1369 
1370     _resultData = crabPartDataToArray(_crabPartData);
1371   }
1372 
1373   /**
1374    * @dev Gift(Transfer) a token to another address. Caller must be token owner
1375    * @param _from current owner of the token
1376    * @param _to address to receive the ownership of the given token ID
1377    * @param _tokenId uint256 ID of the token to be transferred
1378    */
1379   function giftToken(address _from, address _to, uint256 _tokenId) external {
1380     safeTransferFrom(_from, _to, _tokenId);
1381 
1382     emit GiftTransfered(_from, _to, _tokenId);
1383   }
1384 
1385   /**
1386    * @dev External function to mint a new token, for whitelisted address only.
1387    * Reverts if the given token ID already exists
1388    * @param _tokenOwner address the beneficiary that will own the minted token
1389    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1390    * @param _skinId the skin ID to be applied for all the token minted
1391    */
1392   function mintToken(address _tokenOwner, uint256 _tokenId, uint256 _skinId) external onlyIfWhitelisted(msg.sender) {
1393     super._mint(_tokenOwner, _tokenId);
1394 
1395     if(_skinId > 0) {
1396       crabSpecialSkins[_tokenId] = _skinId;
1397     }
1398   }
1399 
1400   /**
1401    * @dev Returns crab data base on the gene provided
1402    * @param _gene the gene info where crab data will be retrieved base on it
1403    * @return 4 uint arrays:
1404    * 1st Array = Body's Data
1405    * 2nd Array = Leg's Data
1406    * 3rd Array = Left Claw's Data
1407    * 4th Array = Right Claw's Data
1408    */
1409   function crabPartDataFromGene(uint256 _gene) external view returns (
1410     uint256[] _bodyData,
1411     uint256[] _legData,
1412     uint256[] _leftClawData,
1413     uint256[] _rightClawData
1414   ) {
1415     uint256[] memory _parts = extractPartsFromGene(_gene);
1416     uint256[] memory _elements = extractElementsFromGene(_gene);
1417 
1418     _bodyData = dataOfPart(1, _elements[0], _parts[0]);
1419     _legData = dataOfPart(2, _elements[1], _parts[1]);
1420     _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
1421     _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
1422   }
1423 
1424   /**
1425    * @dev For developer to add new parts, notice that this is the only method to add crab data
1426    * so that developer can add extra content. there's no other method for developer to modify
1427    * the data. This is to assure token owner actually owns their data.
1428    * @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
1429    * @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
1430    * @param _partDataArray data of the parts.
1431    */
1432   function setPartData(uint256 _partIndex, uint256 _element, uint256[] _partDataArray) external onlyOwner {
1433     CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
1434 
1435     bytes4 _key;
1436     if(_partIndex == 1) {
1437       _key = CRAB_BODY;
1438     } else if(_partIndex == 2) {
1439       _key = CRAB_LEG;
1440     } else if(_partIndex == 3) {
1441       _key = CRAB_LEFT_CLAW;
1442     } else if(_partIndex == 4) {
1443       _key = CRAB_RIGHT_CLAW;
1444     }
1445 
1446     // if index 1 is empty will fill at index 1
1447     if(crabPartData[_key][_element][1].hp == 0 && crabPartData[_key][_element][1].dps == 0) {
1448       crabPartData[_key][_element][1] = _partData;
1449     } else {
1450       crabPartData[_key][_element].push(_partData);
1451     }
1452 
1453     emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
1454   }
1455 
1456   /**
1457    * @dev Updates the default metadata URI
1458    * @param _defaultUri the new metadata URI
1459    */
1460   function setDefaultMetadataURI(string _defaultUri) external onlyOwner {
1461     defaultMetadataURI = _defaultUri;
1462 
1463     emit DefaultMetadataURIChanged(_defaultUri);
1464   }
1465 
1466   /**
1467    * @dev Updates the metadata URI for existing token
1468    * @param _tokenId the tokenID that metadata URI to be changed
1469    * @param _uri the new metadata URI for the specified token
1470    */
1471   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
1472     _setTokenURI(_tokenId, _uri);
1473   }
1474 
1475   /**
1476    * @dev Returns the special skin of the provided tokenId
1477    * @param _tokenId cryptant crab's tokenId
1478    * @return Special skin belongs to the _tokenId provided. 
1479    * 0 will be returned if no special skin found.
1480    */
1481   function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
1482     return crabSpecialSkins[_tokenId];
1483   }
1484 
1485   /**
1486    * @dev This functions will adjust the length of crabPartData
1487    * so that when adding data the index can start with 1.
1488    * Reason of doing this is because gene cannot have parts with index 0.
1489    */
1490   function initiateCrabPartData() internal {
1491     require(crabPartData[CRAB_BODY][1].length == 0);
1492 
1493     for(uint256 i = 1 ; i <= 5 ; i++) {
1494       crabPartData[CRAB_BODY][i].length = 2;
1495       crabPartData[CRAB_LEG][i].length = 2;
1496       crabPartData[CRAB_LEFT_CLAW][i].length = 2;
1497       crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
1498     }
1499   }
1500 
1501   /**
1502    * @dev Returns whether the given spender can transfer a given token ID
1503    * @param _spender address of the spender to query
1504    * @param _tokenId uint256 ID of the token to be transferred
1505    * @return bool whether the msg.sender is approved for the given token ID,
1506    *  is an operator of the owner, or is the owner of the token, 
1507    *  or has been whitelisted by contract owner
1508    */
1509   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1510     address owner = ownerOf(_tokenId);
1511     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || whitelist(_spender);
1512   }
1513 
1514   /**
1515    * @dev Will merge the uri and tokenId together. 
1516    * @param _uri URI to be merge. This will be the first part of the result URL.
1517    * @param _tokenId tokenID to be merge. This will be the last part of the result URL.
1518    * @return the merged urL
1519    */
1520   function getMetadataURL(bytes _uri, uint256 _tokenId) internal pure returns (string) {
1521     uint256 _tmpTokenId = _tokenId;
1522     uint256 _tokenLength;
1523 
1524     // Getting the length(number of digits) of token ID
1525     do {
1526       _tokenLength++;
1527       _tmpTokenId /= 10;
1528     } while (_tmpTokenId > 0);
1529 
1530     // creating a byte array with the length of URL + token digits
1531     bytes memory _result = new bytes(_uri.length + _tokenLength);
1532 
1533     // cloning the uri bytes into the result bytes
1534     for(uint256 i = 0 ; i < _uri.length ; i ++) {
1535       _result[i] = _uri[i];
1536     }
1537 
1538     // appending the tokenId to the end of the result bytes
1539     uint256 lastIndex = _result.length - 1;
1540     for(_tmpTokenId = _tokenId ; _tmpTokenId > 0 ; _tmpTokenId /= 10) {
1541       _result[lastIndex--] = byte(48 + _tmpTokenId % 10);
1542     }
1543 
1544     return string(_result);
1545   }
1546 }
1547 
1548 
1549 contract CryptantCrabBase is Ownable {
1550   GenesisCrabInterface public genesisCrab;
1551   CryptantCrabNFT public cryptantCrabToken;
1552   CryptantCrabStoreInterface public cryptantCrabStorage;
1553 
1554   constructor(address _genesisCrabAddress, address _cryptantCrabTokenAddress, address _cryptantCrabStorageAddress) public {
1555     // constructor
1556     
1557     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
1558   }
1559 
1560   function setAddresses(
1561     address _genesisCrabAddress, 
1562     address _cryptantCrabTokenAddress, 
1563     address _cryptantCrabStorageAddress
1564   ) 
1565   external onlyOwner {
1566     _setAddresses(_genesisCrabAddress, _cryptantCrabTokenAddress, _cryptantCrabStorageAddress);
1567   }
1568 
1569   function _setAddresses(
1570     address _genesisCrabAddress,
1571     address _cryptantCrabTokenAddress,
1572     address _cryptantCrabStorageAddress
1573   )
1574   internal 
1575   {
1576     if(_genesisCrabAddress != address(0)) {
1577       GenesisCrabInterface genesisCrabContract = GenesisCrabInterface(_genesisCrabAddress);
1578       genesisCrab = genesisCrabContract;
1579     }
1580     
1581     if(_cryptantCrabTokenAddress != address(0)) {
1582       CryptantCrabNFT cryptantCrabTokenContract = CryptantCrabNFT(_cryptantCrabTokenAddress);
1583       cryptantCrabToken = cryptantCrabTokenContract;
1584     }
1585     
1586     if(_cryptantCrabStorageAddress != address(0)) {
1587       CryptantCrabStoreInterface cryptantCrabStorageContract = CryptantCrabStoreInterface(_cryptantCrabStorageAddress);
1588       cryptantCrabStorage = cryptantCrabStorageContract;
1589     }
1590   }
1591 }
1592 
1593 
1594 contract CryptantCrabInformant is CryptantCrabBase{
1595   constructor
1596   (
1597     address _genesisCrabAddress, 
1598     address _cryptantCrabTokenAddress, 
1599     address _cryptantCrabStorageAddress
1600   ) 
1601   public 
1602   CryptantCrabBase
1603   (
1604     _genesisCrabAddress, 
1605     _cryptantCrabTokenAddress, 
1606     _cryptantCrabStorageAddress
1607   ) {
1608     // constructor
1609 
1610   }
1611 
1612   function _getCrabData(uint256 _tokenId) internal view returns 
1613   (
1614     uint256 _gene, 
1615     uint256 _level, 
1616     uint256 _exp, 
1617     uint256 _mutationCount,
1618     uint256 _trophyCount,
1619     uint256 _heartValue,
1620     uint256 _growthValue
1621   ) {
1622     require(cryptantCrabStorage != address(0));
1623 
1624     bytes32[] memory keys = new bytes32[](7);
1625     uint256[] memory values;
1626 
1627     keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
1628     keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
1629     keys[2] = keccak256(abi.encodePacked(_tokenId, "exp"));
1630     keys[3] = keccak256(abi.encodePacked(_tokenId, "mutationCount"));
1631     keys[4] = keccak256(abi.encodePacked(_tokenId, "trophyCount"));
1632     keys[5] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
1633     keys[6] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
1634 
1635     values = cryptantCrabStorage.readUint256s(keys);
1636 
1637     // process heart value
1638     uint256 _processedHeartValue;
1639     for(uint256 i = 1 ; i <= 1000 ; i *= 10) {
1640       if(uint256(values[5]) / i % 10 > 0) {
1641         _processedHeartValue += i;
1642       }
1643     }
1644 
1645     _gene = values[0];
1646     _level = values[1];
1647     _exp = values[2];
1648     _mutationCount = values[3];
1649     _trophyCount = values[4];
1650     _heartValue = _processedHeartValue;
1651     _growthValue = values[6];
1652   }
1653 
1654   function _geneOfCrab(uint256 _tokenId) internal view returns (uint256 _gene) {
1655     require(cryptantCrabStorage != address(0));
1656 
1657     _gene = cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_tokenId, "gene")));
1658   }
1659 }
1660 
1661 contract CryptantCrabPurchasable is CryptantCrabInformant {
1662   using SafeMath for uint256;
1663 
1664   event CrabHatched(address indexed owner, uint256 tokenId, uint256 gene, uint256 specialSkin, uint256 crabPrice, uint256 growthValue);
1665   event CryptantFragmentsAdded(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
1666   event CryptantFragmentsRemoved(address indexed cryptantOwner, uint256 amount, uint256 newBalance);
1667   event Refund(address indexed refundReceiver, uint256 reqAmt, uint256 paid, uint256 refundAmt);
1668 
1669   constructor
1670   (
1671     address _genesisCrabAddress, 
1672     address _cryptantCrabTokenAddress, 
1673     address _cryptantCrabStorageAddress
1674   ) 
1675   public 
1676   CryptantCrabInformant
1677   (
1678     _genesisCrabAddress, 
1679     _cryptantCrabTokenAddress, 
1680     _cryptantCrabStorageAddress
1681   ) {
1682     // constructor
1683 
1684   }
1685 
1686   function getCryptantFragments(address _sender) public view returns (uint256) {
1687     return cryptantCrabStorage.readUint256(keccak256(abi.encodePacked(_sender, "cryptant")));
1688   }
1689 
1690   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) external onlyOwner {
1691     return _createCrab(false, _customTokenId, _crabPrice, _customGene, _customSkin, _customHeart, _hasLegendary);
1692   }
1693 
1694   function _addCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1695     _newBalance = getCryptantFragments(_cryptantOwner).add(_amount);
1696     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1697     emit CryptantFragmentsAdded(_cryptantOwner, _amount, _newBalance);
1698   }
1699 
1700   function _removeCryptantFragments(address _cryptantOwner, uint256 _amount) internal returns (uint256 _newBalance) {
1701     _newBalance = getCryptantFragments(_cryptantOwner).sub(_amount);
1702     cryptantCrabStorage.updateUint256(keccak256(abi.encodePacked(_cryptantOwner, "cryptant")), _newBalance);
1703     emit CryptantFragmentsRemoved(_cryptantOwner, _amount, _newBalance);
1704   }
1705 
1706   function _createCrab(bool _isPresale, uint256 _tokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) internal {
1707     uint256[] memory _values = new uint256[](4);
1708     bytes32[] memory _keys = new bytes32[](4);
1709 
1710     uint256 _gene;
1711     uint256 _specialSkin;
1712     uint256 _heartValue;
1713     uint256 _growthValue;
1714     if(_customGene == 0) {
1715       (_gene, _specialSkin, _heartValue, _growthValue) = genesisCrab.generateCrabGene(_isPresale, _hasLegendary);
1716     } else {
1717       _gene = _customGene;
1718     }
1719 
1720     if(_customSkin != 0) {
1721       _specialSkin = _customSkin;
1722     }
1723 
1724     if(_customHeart != 0) {
1725       _heartValue = _customHeart;
1726     } else if (_heartValue == 0) {
1727       (_heartValue, _growthValue) = genesisCrab.generateCrabHeart();
1728     }
1729     
1730     cryptantCrabToken.mintToken(msg.sender, _tokenId, _specialSkin);
1731 
1732     // Gene pair
1733     _keys[0] = keccak256(abi.encodePacked(_tokenId, "gene"));
1734     _values[0] = _gene;
1735 
1736     // Level pair
1737     _keys[1] = keccak256(abi.encodePacked(_tokenId, "level"));
1738     _values[1] = 1;
1739 
1740     // Heart Value pair
1741     _keys[2] = keccak256(abi.encodePacked(_tokenId, "heartValue"));
1742     _values[2] = _heartValue;
1743 
1744     // Growth Value pair
1745     _keys[3] = keccak256(abi.encodePacked(_tokenId, "growthValue"));
1746     _values[3] = _growthValue;
1747 
1748     require(cryptantCrabStorage.createUint256s(_keys, _values));
1749 
1750     emit CrabHatched(msg.sender, _tokenId, _gene, _specialSkin, _crabPrice, _growthValue);
1751   }
1752 
1753   function _refundExceededValue(uint256 _senderValue, uint256 _requiredValue) internal {
1754     uint256 _exceededValue = _senderValue.sub(_requiredValue);
1755 
1756     if(_exceededValue > 0) {
1757       msg.sender.transfer(_exceededValue);
1758 
1759       emit Refund(msg.sender, _requiredValue, _senderValue, _exceededValue);
1760     } 
1761   }
1762 }
1763 
1764 contract Withdrawable is Ownable {
1765   address public withdrawer;
1766 
1767   /**
1768    * @dev Throws if called by any account other than the withdrawer.
1769    */
1770   modifier onlyWithdrawer() {
1771     require(msg.sender == withdrawer);
1772     _;
1773   }
1774 
1775   function setWithdrawer(address _newWithdrawer) external onlyOwner {
1776     withdrawer = _newWithdrawer;
1777   }
1778 
1779   /**
1780    * @dev withdraw the specified amount of ether from contract.
1781    * @param _amount the amount of ether to withdraw. Units in wei.
1782    */
1783   function withdraw(uint256 _amount) external onlyWithdrawer returns(bool) {
1784     require(_amount <= address(this).balance);
1785     withdrawer.transfer(_amount);
1786     return true;
1787   }
1788 }
1789 
1790 contract Randomable {
1791   // Generates a random number base on last block hash
1792   function _generateRandom(bytes32 seed) view internal returns (bytes32) {
1793     return keccak256(abi.encodePacked(blockhash(block.number-1), seed));
1794   }
1795 
1796   function _generateRandomNumber(bytes32 seed, uint256 max) view internal returns (uint256) {
1797     return uint256(_generateRandom(seed)) % max;
1798   }
1799 }
1800 
1801 contract CryptantCrabPresale is CryptantCrabPurchasable, HasNoEther, Withdrawable, Randomable {
1802   event PresalePurchased(address indexed owner, uint256 amount, uint256 cryptant, uint256 refund);
1803 
1804   uint256 constant public PRESALE_LIMIT = 5000;
1805 
1806   /**
1807    * @dev Currently is set to 17/11/2018 00:00:00
1808    */
1809   uint256 public presaleEndTime = 1542412800;
1810 
1811   /**
1812    * @dev Initial presale price is 0.25 ether
1813    */
1814   uint256 public currentPresalePrice = 250 finney;
1815 
1816   /** 
1817    * @dev tracks the current token id, starts from 721
1818    */
1819   uint256 public currentTokenId = 721;
1820 
1821   /** 
1822    * @dev tracks the current giveaway token id, starts from 5102
1823    */
1824   uint256 public giveawayTokenId = 5102;
1825 
1826   constructor
1827   (
1828     address _genesisCrabAddress, 
1829     address _cryptantCrabTokenAddress, 
1830     address _cryptantCrabStorageAddress
1831   ) 
1832   public 
1833   CryptantCrabPurchasable
1834   (
1835     _genesisCrabAddress, 
1836     _cryptantCrabTokenAddress, 
1837     _cryptantCrabStorageAddress
1838   ) {
1839     // constructor
1840 
1841   }
1842 
1843   function setCurrentTokenId(uint256 _newTokenId) external onlyOwner {
1844     currentTokenId = _newTokenId;
1845   }
1846 
1847   function setPresaleEndtime(uint256 _newEndTime) external onlyOwner {
1848     presaleEndTime = _newEndTime;
1849   }
1850 
1851   function getPresalePrice() public view returns (uint256) {
1852     return currentPresalePrice;
1853   }
1854 
1855   function purchase(uint256 _amount) external payable {
1856     require(genesisCrab != address(0));
1857     require(cryptantCrabToken != address(0));
1858     require(cryptantCrabStorage != address(0));
1859     require(_amount > 0 && _amount <= 10);
1860     require(isPresale());
1861     require(PRESALE_LIMIT >= currentTokenId + _amount);
1862 
1863     uint256 _value = msg.value;
1864     uint256 _currentPresalePrice = getPresalePrice();
1865     uint256 _totalRequiredAmount = _currentPresalePrice * _amount;
1866 
1867     require(_value >= _totalRequiredAmount);
1868 
1869     // Purchase 10 crabs will have 1 crab with legendary part
1870     // Default value for _crabWithLegendaryPart is just a unreacable number
1871     uint256 _crabWithLegendaryPart = 100;
1872     if(_amount == 10) {
1873       // decide which crab will have the legendary part
1874       _crabWithLegendaryPart = _generateRandomNumber(bytes32(currentTokenId), 10);
1875     }
1876 
1877     for(uint256 i = 0 ; i < _amount ; i++) {
1878       currentTokenId++;
1879       _createCrab(true, currentTokenId, _currentPresalePrice, 0, 0, 0, _crabWithLegendaryPart == i);
1880     }
1881 
1882     // Presale crab will get free cryptant fragments
1883     _addCryptantFragments(msg.sender, (i * 3000));
1884 
1885     // Refund exceeded value
1886     _refundExceededValue(_value, _totalRequiredAmount);
1887 
1888     emit PresalePurchased(msg.sender, _amount, i * 3000, _value - _totalRequiredAmount);
1889   }
1890 
1891   function createCrab(uint256 _customTokenId, uint256 _crabPrice, uint256 _customGene, uint256 _customSkin, uint256 _customHeart, bool _hasLegendary) external onlyOwner {
1892     return _createCrab(true, _customTokenId, _crabPrice, _customGene, _customSkin, _customHeart, _hasLegendary);
1893   }
1894 
1895   function generateGiveawayCrabs(uint256 _amount) external onlyOwner {
1896     for(uint256 i = 0 ; i < _amount ; i++) {
1897       _createCrab(false, giveawayTokenId++, 120 finney, 0, 0, 0, false);
1898     }
1899   }
1900 
1901   function isPresale() internal view returns (bool) {
1902     return now < presaleEndTime;
1903   }
1904 }