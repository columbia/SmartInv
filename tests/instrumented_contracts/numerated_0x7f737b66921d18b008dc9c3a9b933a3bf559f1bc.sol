1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Strings.sol
4 
5 library Strings {
6   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
7   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
8     bytes memory _ba = bytes(_a);
9     bytes memory _bb = bytes(_b);
10     bytes memory _bc = bytes(_c);
11     bytes memory _bd = bytes(_d);
12     bytes memory _be = bytes(_e);
13     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
14     bytes memory babcde = bytes(abcde);
15     uint k = 0;
16     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
17     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
18     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
19     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
20     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
21     return string(babcde);
22   }
23 
24   function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
25     return strConcat(_a, _b, _c, _d, "");
26   }
27 
28   function strConcat(string _a, string _b, string _c) internal pure returns (string) {
29     return strConcat(_a, _b, _c, "", "");
30   }
31 
32   function strConcat(string _a, string _b) internal pure returns (string) {
33     return strConcat(_a, _b, "", "", "");
34   }
35 }
36 
37 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipRenounced(address indexed previousOwner);
49   event OwnershipTransferred(
50     address indexed previousOwner,
51     address indexed newOwner
52   );
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   constructor() public {
60     owner = msg.sender;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71   /**
72    * @dev Allows the current owner to relinquish control of the contract.
73    * @notice Renouncing to ownership will leave the contract without an owner.
74    * It will not be possible to call the functions with the `onlyOwner`
75    * modifier anymore.
76    */
77   function renounceOwnership() public onlyOwner {
78     emit OwnershipRenounced(owner);
79     owner = address(0);
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 
101 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
102 
103 /**
104  * @title Roles
105  * @author Francisco Giordano (@frangio)
106  * @dev Library for managing addresses assigned to a Role.
107  * See RBAC.sol for example usage.
108  */
109 library Roles {
110   struct Role {
111     mapping (address => bool) bearer;
112   }
113 
114   /**
115    * @dev give an address access to this role
116    */
117   function add(Role storage role, address addr)
118     internal
119   {
120     role.bearer[addr] = true;
121   }
122 
123   /**
124    * @dev remove an address' access to this role
125    */
126   function remove(Role storage role, address addr)
127     internal
128   {
129     role.bearer[addr] = false;
130   }
131 
132   /**
133    * @dev check if an address has this role
134    * // reverts
135    */
136   function check(Role storage role, address addr)
137     view
138     internal
139   {
140     require(has(role, addr));
141   }
142 
143   /**
144    * @dev check if an address has this role
145    * @return bool
146    */
147   function has(Role storage role, address addr)
148     view
149     internal
150     returns (bool)
151   {
152     return role.bearer[addr];
153   }
154 }
155 
156 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
157 
158 /**
159  * @title RBAC (Role-Based Access Control)
160  * @author Matt Condon (@Shrugs)
161  * @dev Stores and provides setters and getters for roles and addresses.
162  * Supports unlimited numbers of roles and addresses.
163  * See //contracts/mocks/RBACMock.sol for an example of usage.
164  * This RBAC method uses strings to key roles. It may be beneficial
165  * for you to write your own implementation of this interface using Enums or similar.
166  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
167  * to avoid typos.
168  */
169 contract RBAC {
170   using Roles for Roles.Role;
171 
172   mapping (string => Roles.Role) private roles;
173 
174   event RoleAdded(address indexed operator, string role);
175   event RoleRemoved(address indexed operator, string role);
176 
177   /**
178    * @dev reverts if addr does not have role
179    * @param _operator address
180    * @param _role the name of the role
181    * // reverts
182    */
183   function checkRole(address _operator, string _role)
184     view
185     public
186   {
187     roles[_role].check(_operator);
188   }
189 
190   /**
191    * @dev determine if addr has role
192    * @param _operator address
193    * @param _role the name of the role
194    * @return bool
195    */
196   function hasRole(address _operator, string _role)
197     view
198     public
199     returns (bool)
200   {
201     return roles[_role].has(_operator);
202   }
203 
204   /**
205    * @dev add a role to an address
206    * @param _operator address
207    * @param _role the name of the role
208    */
209   function addRole(address _operator, string _role)
210     internal
211   {
212     roles[_role].add(_operator);
213     emit RoleAdded(_operator, _role);
214   }
215 
216   /**
217    * @dev remove a role from an address
218    * @param _operator address
219    * @param _role the name of the role
220    */
221   function removeRole(address _operator, string _role)
222     internal
223   {
224     roles[_role].remove(_operator);
225     emit RoleRemoved(_operator, _role);
226   }
227 
228   /**
229    * @dev modifier to scope access to a single role (uses msg.sender as addr)
230    * @param _role the name of the role
231    * // reverts
232    */
233   modifier onlyRole(string _role)
234   {
235     checkRole(msg.sender, _role);
236     _;
237   }
238 
239   /**
240    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
241    * @param _roles the names of the roles to scope access to
242    * // reverts
243    *
244    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
245    *  see: https://github.com/ethereum/solidity/issues/2467
246    */
247   // modifier onlyRoles(string[] _roles) {
248   //     bool hasAnyRole = false;
249   //     for (uint8 i = 0; i < _roles.length; i++) {
250   //         if (hasRole(msg.sender, _roles[i])) {
251   //             hasAnyRole = true;
252   //             break;
253   //         }
254   //     }
255 
256   //     require(hasAnyRole);
257 
258   //     _;
259   // }
260 }
261 
262 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
263 
264 /**
265  * @title Whitelist
266  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
267  * This simplifies the implementation of "user permissions".
268  */
269 contract Whitelist is Ownable, RBAC {
270   string public constant ROLE_WHITELISTED = "whitelist";
271 
272   /**
273    * @dev Throws if operator is not whitelisted.
274    * @param _operator address
275    */
276   modifier onlyIfWhitelisted(address _operator) {
277     checkRole(_operator, ROLE_WHITELISTED);
278     _;
279   }
280 
281   /**
282    * @dev add an address to the whitelist
283    * @param _operator address
284    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
285    */
286   function addAddressToWhitelist(address _operator)
287     onlyOwner
288     public
289   {
290     addRole(_operator, ROLE_WHITELISTED);
291   }
292 
293   /**
294    * @dev getter to determine if address is in whitelist
295    */
296   function whitelist(address _operator)
297     public
298     view
299     returns (bool)
300   {
301     return hasRole(_operator, ROLE_WHITELISTED);
302   }
303 
304   /**
305    * @dev add addresses to the whitelist
306    * @param _operators addresses
307    * @return true if at least one address was added to the whitelist,
308    * false if all addresses were already in the whitelist
309    */
310   function addAddressesToWhitelist(address[] _operators)
311     onlyOwner
312     public
313   {
314     for (uint256 i = 0; i < _operators.length; i++) {
315       addAddressToWhitelist(_operators[i]);
316     }
317   }
318 
319   /**
320    * @dev remove an address from the whitelist
321    * @param _operator address
322    * @return true if the address was removed from the whitelist,
323    * false if the address wasn't in the whitelist in the first place
324    */
325   function removeAddressFromWhitelist(address _operator)
326     onlyOwner
327     public
328   {
329     removeRole(_operator, ROLE_WHITELISTED);
330   }
331 
332   /**
333    * @dev remove addresses from the whitelist
334    * @param _operators addresses
335    * @return true if at least one address was removed from the whitelist,
336    * false if all addresses weren't in the whitelist in the first place
337    */
338   function removeAddressesFromWhitelist(address[] _operators)
339     onlyOwner
340     public
341   {
342     for (uint256 i = 0; i < _operators.length; i++) {
343       removeAddressFromWhitelist(_operators[i]);
344     }
345   }
346 
347 }
348 
349 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
350 
351 /**
352  * @title SafeMath
353  * @dev Math operations with safety checks that throw on error
354  */
355 library SafeMath {
356 
357   /**
358   * @dev Multiplies two numbers, throws on overflow.
359   */
360   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
361     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
362     // benefit is lost if 'b' is also tested.
363     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
364     if (a == 0) {
365       return 0;
366     }
367 
368     c = a * b;
369     assert(c / a == b);
370     return c;
371   }
372 
373   /**
374   * @dev Integer division of two numbers, truncating the quotient.
375   */
376   function div(uint256 a, uint256 b) internal pure returns (uint256) {
377     // assert(b > 0); // Solidity automatically throws when dividing by 0
378     // uint256 c = a / b;
379     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
380     return a / b;
381   }
382 
383   /**
384   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
385   */
386   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387     assert(b <= a);
388     return a - b;
389   }
390 
391   /**
392   * @dev Adds two numbers, throws on overflow.
393   */
394   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
395     c = a + b;
396     assert(c >= a);
397     return c;
398   }
399 }
400 
401 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
402 
403 /**
404  * @title ERC165
405  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
406  */
407 interface ERC165 {
408 
409   /**
410    * @notice Query if a contract implements an interface
411    * @param _interfaceId The interface identifier, as specified in ERC-165
412    * @dev Interface identification is specified in ERC-165. This function
413    * uses less than 30,000 gas.
414    */
415   function supportsInterface(bytes4 _interfaceId)
416     external
417     view
418     returns (bool);
419 }
420 
421 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
422 
423 /**
424  * @title SupportsInterfaceWithLookup
425  * @author Matt Condon (@shrugs)
426  * @dev Implements ERC165 using a lookup table.
427  */
428 contract SupportsInterfaceWithLookup is ERC165 {
429   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
430   /**
431    * 0x01ffc9a7 ===
432    *   bytes4(keccak256('supportsInterface(bytes4)'))
433    */
434 
435   /**
436    * @dev a mapping of interface id to whether or not it's supported
437    */
438   mapping(bytes4 => bool) internal supportedInterfaces;
439 
440   /**
441    * @dev A contract implementing SupportsInterfaceWithLookup
442    * implement ERC165 itself
443    */
444   constructor()
445     public
446   {
447     _registerInterface(InterfaceId_ERC165);
448   }
449 
450   /**
451    * @dev implement supportsInterface(bytes4) using a lookup table
452    */
453   function supportsInterface(bytes4 _interfaceId)
454     external
455     view
456     returns (bool)
457   {
458     return supportedInterfaces[_interfaceId];
459   }
460 
461   /**
462    * @dev private method for registering an interface
463    */
464   function _registerInterface(bytes4 _interfaceId)
465     internal
466   {
467     require(_interfaceId != 0xffffffff);
468     supportedInterfaces[_interfaceId] = true;
469   }
470 }
471 
472 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
473 
474 /**
475  * @title ERC721 Non-Fungible Token Standard basic interface
476  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
477  */
478 contract ERC721Basic is ERC165 {
479   event Transfer(
480     address indexed _from,
481     address indexed _to,
482     uint256 indexed _tokenId
483   );
484   event Approval(
485     address indexed _owner,
486     address indexed _approved,
487     uint256 indexed _tokenId
488   );
489   event ApprovalForAll(
490     address indexed _owner,
491     address indexed _operator,
492     bool _approved
493   );
494 
495   function balanceOf(address _owner) public view returns (uint256 _balance);
496   function ownerOf(uint256 _tokenId) public view returns (address _owner);
497   function exists(uint256 _tokenId) public view returns (bool _exists);
498 
499   function approve(address _to, uint256 _tokenId) public;
500   function getApproved(uint256 _tokenId)
501     public view returns (address _operator);
502 
503   function setApprovalForAll(address _operator, bool _approved) public;
504   function isApprovedForAll(address _owner, address _operator)
505     public view returns (bool);
506 
507   function transferFrom(address _from, address _to, uint256 _tokenId) public;
508   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
509     public;
510 
511   function safeTransferFrom(
512     address _from,
513     address _to,
514     uint256 _tokenId,
515     bytes _data
516   )
517     public;
518 }
519 
520 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
521 
522 /**
523  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
524  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
525  */
526 contract ERC721Enumerable is ERC721Basic {
527   function totalSupply() public view returns (uint256);
528   function tokenOfOwnerByIndex(
529     address _owner,
530     uint256 _index
531   )
532     public
533     view
534     returns (uint256 _tokenId);
535 
536   function tokenByIndex(uint256 _index) public view returns (uint256);
537 }
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
543  */
544 contract ERC721Metadata is ERC721Basic {
545   function name() external view returns (string _name);
546   function symbol() external view returns (string _symbol);
547   function tokenURI(uint256 _tokenId) public view returns (string);
548 }
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
553  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
554  */
555 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
556 }
557 
558 // File: openzeppelin-solidity/contracts/AddressUtils.sol
559 
560 /**
561  * Utility library of inline functions on addresses
562  */
563 library AddressUtils {
564 
565   /**
566    * Returns whether the target address is a contract
567    * @dev This function will return false if invoked during the constructor of a contract,
568    * as the code is not actually created until after the constructor finishes.
569    * @param addr address to check
570    * @return whether the target address is a contract
571    */
572   function isContract(address addr) internal view returns (bool) {
573     uint256 size;
574     // XXX Currently there is no better way to check if there is a contract in an address
575     // than to check the size of the code at that address.
576     // See https://ethereum.stackexchange.com/a/14016/36603
577     // for more details about how this works.
578     // TODO Check this again before the Serenity release, because all addresses will be
579     // contracts then.
580     // solium-disable-next-line security/no-inline-assembly
581     assembly { size := extcodesize(addr) }
582     return size > 0;
583   }
584 
585 }
586 
587 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
588 
589 /**
590  * @title ERC721 token receiver interface
591  * @dev Interface for any contract that wants to support safeTransfers
592  * from ERC721 asset contracts.
593  */
594 contract ERC721Receiver {
595   /**
596    * @dev Magic value to be returned upon successful reception of an NFT
597    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
598    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
599    */
600   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
601 
602   /**
603    * @notice Handle the receipt of an NFT
604    * @dev The ERC721 smart contract calls this function on the recipient
605    * after a `safetransfer`. This function MAY throw to revert and reject the
606    * transfer. Return of other than the magic value MUST result in the 
607    * transaction being reverted.
608    * Note: the contract address is always the message sender.
609    * @param _operator The address which called `safeTransferFrom` function
610    * @param _from The address which previously owned the token
611    * @param _tokenId The NFT identifier which is being transfered
612    * @param _data Additional data with no specified format
613    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
614    */
615   function onERC721Received(
616     address _operator,
617     address _from,
618     uint256 _tokenId,
619     bytes _data
620   )
621     public
622     returns(bytes4);
623 }
624 
625 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
626 
627 /**
628  * @title ERC721 Non-Fungible Token Standard basic implementation
629  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
630  */
631 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
632 
633   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
634   /*
635    * 0x80ac58cd ===
636    *   bytes4(keccak256('balanceOf(address)')) ^
637    *   bytes4(keccak256('ownerOf(uint256)')) ^
638    *   bytes4(keccak256('approve(address,uint256)')) ^
639    *   bytes4(keccak256('getApproved(uint256)')) ^
640    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
641    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
642    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
643    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
644    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
645    */
646 
647   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
648   /*
649    * 0x4f558e79 ===
650    *   bytes4(keccak256('exists(uint256)'))
651    */
652 
653   using SafeMath for uint256;
654   using AddressUtils for address;
655 
656   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
657   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
658   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
659 
660   // Mapping from token ID to owner
661   mapping (uint256 => address) internal tokenOwner;
662 
663   // Mapping from token ID to approved address
664   mapping (uint256 => address) internal tokenApprovals;
665 
666   // Mapping from owner to number of owned token
667   mapping (address => uint256) internal ownedTokensCount;
668 
669   // Mapping from owner to operator approvals
670   mapping (address => mapping (address => bool)) internal operatorApprovals;
671 
672   /**
673    * @dev Guarantees msg.sender is owner of the given token
674    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
675    */
676   modifier onlyOwnerOf(uint256 _tokenId) {
677     require(ownerOf(_tokenId) == msg.sender);
678     _;
679   }
680 
681   /**
682    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
683    * @param _tokenId uint256 ID of the token to validate
684    */
685   modifier canTransfer(uint256 _tokenId) {
686     require(isApprovedOrOwner(msg.sender, _tokenId));
687     _;
688   }
689 
690   constructor()
691     public
692   {
693     // register the supported interfaces to conform to ERC721 via ERC165
694     _registerInterface(InterfaceId_ERC721);
695     _registerInterface(InterfaceId_ERC721Exists);
696   }
697 
698   /**
699    * @dev Gets the balance of the specified address
700    * @param _owner address to query the balance of
701    * @return uint256 representing the amount owned by the passed address
702    */
703   function balanceOf(address _owner) public view returns (uint256) {
704     require(_owner != address(0));
705     return ownedTokensCount[_owner];
706   }
707 
708   /**
709    * @dev Gets the owner of the specified token ID
710    * @param _tokenId uint256 ID of the token to query the owner of
711    * @return owner address currently marked as the owner of the given token ID
712    */
713   function ownerOf(uint256 _tokenId) public view returns (address) {
714     address owner = tokenOwner[_tokenId];
715     require(owner != address(0));
716     return owner;
717   }
718 
719   /**
720    * @dev Returns whether the specified token exists
721    * @param _tokenId uint256 ID of the token to query the existence of
722    * @return whether the token exists
723    */
724   function exists(uint256 _tokenId) public view returns (bool) {
725     address owner = tokenOwner[_tokenId];
726     return owner != address(0);
727   }
728 
729   /**
730    * @dev Approves another address to transfer the given token ID
731    * The zero address indicates there is no approved address.
732    * There can only be one approved address per token at a given time.
733    * Can only be called by the token owner or an approved operator.
734    * @param _to address to be approved for the given token ID
735    * @param _tokenId uint256 ID of the token to be approved
736    */
737   function approve(address _to, uint256 _tokenId) public {
738     address owner = ownerOf(_tokenId);
739     require(_to != owner);
740     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
741 
742     tokenApprovals[_tokenId] = _to;
743     emit Approval(owner, _to, _tokenId);
744   }
745 
746   /**
747    * @dev Gets the approved address for a token ID, or zero if no address set
748    * @param _tokenId uint256 ID of the token to query the approval of
749    * @return address currently approved for the given token ID
750    */
751   function getApproved(uint256 _tokenId) public view returns (address) {
752     return tokenApprovals[_tokenId];
753   }
754 
755   /**
756    * @dev Sets or unsets the approval of a given operator
757    * An operator is allowed to transfer all tokens of the sender on their behalf
758    * @param _to operator address to set the approval
759    * @param _approved representing the status of the approval to be set
760    */
761   function setApprovalForAll(address _to, bool _approved) public {
762     require(_to != msg.sender);
763     operatorApprovals[msg.sender][_to] = _approved;
764     emit ApprovalForAll(msg.sender, _to, _approved);
765   }
766 
767   /**
768    * @dev Tells whether an operator is approved by a given owner
769    * @param _owner owner address which you want to query the approval of
770    * @param _operator operator address which you want to query the approval of
771    * @return bool whether the given operator is approved by the given owner
772    */
773   function isApprovedForAll(
774     address _owner,
775     address _operator
776   )
777     public
778     view
779     returns (bool)
780   {
781     return operatorApprovals[_owner][_operator];
782   }
783 
784   /**
785    * @dev Transfers the ownership of a given token ID to another address
786    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
787    * Requires the msg sender to be the owner, approved, or operator
788    * @param _from current owner of the token
789    * @param _to address to receive the ownership of the given token ID
790    * @param _tokenId uint256 ID of the token to be transferred
791   */
792   function transferFrom(
793     address _from,
794     address _to,
795     uint256 _tokenId
796   )
797     public
798     canTransfer(_tokenId)
799   {
800     require(_from != address(0));
801     require(_to != address(0));
802 
803     clearApproval(_from, _tokenId);
804     removeTokenFrom(_from, _tokenId);
805     addTokenTo(_to, _tokenId);
806 
807     emit Transfer(_from, _to, _tokenId);
808   }
809 
810   /**
811    * @dev Safely transfers the ownership of a given token ID to another address
812    * If the target address is a contract, it must implement `onERC721Received`,
813    * which is called upon a safe transfer, and return the magic value
814    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
815    * the transfer is reverted.
816    *
817    * Requires the msg sender to be the owner, approved, or operator
818    * @param _from current owner of the token
819    * @param _to address to receive the ownership of the given token ID
820    * @param _tokenId uint256 ID of the token to be transferred
821   */
822   function safeTransferFrom(
823     address _from,
824     address _to,
825     uint256 _tokenId
826   )
827     public
828     canTransfer(_tokenId)
829   {
830     // solium-disable-next-line arg-overflow
831     safeTransferFrom(_from, _to, _tokenId, "");
832   }
833 
834   /**
835    * @dev Safely transfers the ownership of a given token ID to another address
836    * If the target address is a contract, it must implement `onERC721Received`,
837    * which is called upon a safe transfer, and return the magic value
838    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
839    * the transfer is reverted.
840    * Requires the msg sender to be the owner, approved, or operator
841    * @param _from current owner of the token
842    * @param _to address to receive the ownership of the given token ID
843    * @param _tokenId uint256 ID of the token to be transferred
844    * @param _data bytes data to send along with a safe transfer check
845    */
846   function safeTransferFrom(
847     address _from,
848     address _to,
849     uint256 _tokenId,
850     bytes _data
851   )
852     public
853     canTransfer(_tokenId)
854   {
855     transferFrom(_from, _to, _tokenId);
856     // solium-disable-next-line arg-overflow
857     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
858   }
859 
860   /**
861    * @dev Returns whether the given spender can transfer a given token ID
862    * @param _spender address of the spender to query
863    * @param _tokenId uint256 ID of the token to be transferred
864    * @return bool whether the msg.sender is approved for the given token ID,
865    *  is an operator of the owner, or is the owner of the token
866    */
867   function isApprovedOrOwner(
868     address _spender,
869     uint256 _tokenId
870   )
871     internal
872     view
873     returns (bool)
874   {
875     address owner = ownerOf(_tokenId);
876     // Disable solium check because of
877     // https://github.com/duaraghav8/Solium/issues/175
878     // solium-disable-next-line operator-whitespace
879     return (
880       _spender == owner ||
881       getApproved(_tokenId) == _spender ||
882       isApprovedForAll(owner, _spender)
883     );
884   }
885 
886   /**
887    * @dev Internal function to mint a new token
888    * Reverts if the given token ID already exists
889    * @param _to The address that will own the minted token
890    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
891    */
892   function _mint(address _to, uint256 _tokenId) internal {
893     require(_to != address(0));
894     addTokenTo(_to, _tokenId);
895     emit Transfer(address(0), _to, _tokenId);
896   }
897 
898   /**
899    * @dev Internal function to burn a specific token
900    * Reverts if the token does not exist
901    * @param _tokenId uint256 ID of the token being burned by the msg.sender
902    */
903   function _burn(address _owner, uint256 _tokenId) internal {
904     clearApproval(_owner, _tokenId);
905     removeTokenFrom(_owner, _tokenId);
906     emit Transfer(_owner, address(0), _tokenId);
907   }
908 
909   /**
910    * @dev Internal function to clear current approval of a given token ID
911    * Reverts if the given address is not indeed the owner of the token
912    * @param _owner owner of the token
913    * @param _tokenId uint256 ID of the token to be transferred
914    */
915   function clearApproval(address _owner, uint256 _tokenId) internal {
916     require(ownerOf(_tokenId) == _owner);
917     if (tokenApprovals[_tokenId] != address(0)) {
918       tokenApprovals[_tokenId] = address(0);
919     }
920   }
921 
922   /**
923    * @dev Internal function to add a token ID to the list of a given address
924    * @param _to address representing the new owner of the given token ID
925    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
926    */
927   function addTokenTo(address _to, uint256 _tokenId) internal {
928     require(tokenOwner[_tokenId] == address(0));
929     tokenOwner[_tokenId] = _to;
930     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
931   }
932 
933   /**
934    * @dev Internal function to remove a token ID from the list of a given address
935    * @param _from address representing the previous owner of the given token ID
936    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
937    */
938   function removeTokenFrom(address _from, uint256 _tokenId) internal {
939     require(ownerOf(_tokenId) == _from);
940     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
941     tokenOwner[_tokenId] = address(0);
942   }
943 
944   /**
945    * @dev Internal function to invoke `onERC721Received` on a target address
946    * The call is not executed if the target address is not a contract
947    * @param _from address representing the previous owner of the given token ID
948    * @param _to target address that will receive the tokens
949    * @param _tokenId uint256 ID of the token to be transferred
950    * @param _data bytes optional data to send along with the call
951    * @return whether the call correctly returned the expected magic value
952    */
953   function checkAndCallSafeTransfer(
954     address _from,
955     address _to,
956     uint256 _tokenId,
957     bytes _data
958   )
959     internal
960     returns (bool)
961   {
962     if (!_to.isContract()) {
963       return true;
964     }
965     bytes4 retval = ERC721Receiver(_to).onERC721Received(
966       msg.sender, _from, _tokenId, _data);
967     return (retval == ERC721_RECEIVED);
968   }
969 }
970 
971 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
972 
973 /**
974  * @title Full ERC721 Token
975  * This implementation includes all the required and some optional functionality of the ERC721 standard
976  * Moreover, it includes approve all functionality using operator terminology
977  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
978  */
979 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
980 
981   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
982   /**
983    * 0x780e9d63 ===
984    *   bytes4(keccak256('totalSupply()')) ^
985    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
986    *   bytes4(keccak256('tokenByIndex(uint256)'))
987    */
988 
989   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
990   /**
991    * 0x5b5e139f ===
992    *   bytes4(keccak256('name()')) ^
993    *   bytes4(keccak256('symbol()')) ^
994    *   bytes4(keccak256('tokenURI(uint256)'))
995    */
996 
997   // Token name
998   string internal name_;
999 
1000   // Token symbol
1001   string internal symbol_;
1002 
1003   // Mapping from owner to list of owned token IDs
1004   mapping(address => uint256[]) internal ownedTokens;
1005 
1006   // Mapping from token ID to index of the owner tokens list
1007   mapping(uint256 => uint256) internal ownedTokensIndex;
1008 
1009   // Array with all token ids, used for enumeration
1010   uint256[] internal allTokens;
1011 
1012   // Mapping from token id to position in the allTokens array
1013   mapping(uint256 => uint256) internal allTokensIndex;
1014 
1015   // Optional mapping for token URIs
1016   mapping(uint256 => string) internal tokenURIs;
1017 
1018   /**
1019    * @dev Constructor function
1020    */
1021   constructor(string _name, string _symbol) public {
1022     name_ = _name;
1023     symbol_ = _symbol;
1024 
1025     // register the supported interfaces to conform to ERC721 via ERC165
1026     _registerInterface(InterfaceId_ERC721Enumerable);
1027     _registerInterface(InterfaceId_ERC721Metadata);
1028   }
1029 
1030   /**
1031    * @dev Gets the token name
1032    * @return string representing the token name
1033    */
1034   function name() external view returns (string) {
1035     return name_;
1036   }
1037 
1038   /**
1039    * @dev Gets the token symbol
1040    * @return string representing the token symbol
1041    */
1042   function symbol() external view returns (string) {
1043     return symbol_;
1044   }
1045 
1046   /**
1047    * @dev Returns an URI for a given token ID
1048    * Throws if the token ID does not exist. May return an empty string.
1049    * @param _tokenId uint256 ID of the token to query
1050    */
1051   function tokenURI(uint256 _tokenId) public view returns (string) {
1052     require(exists(_tokenId));
1053     return tokenURIs[_tokenId];
1054   }
1055 
1056   /**
1057    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1058    * @param _owner address owning the tokens list to be accessed
1059    * @param _index uint256 representing the index to be accessed of the requested tokens list
1060    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1061    */
1062   function tokenOfOwnerByIndex(
1063     address _owner,
1064     uint256 _index
1065   )
1066     public
1067     view
1068     returns (uint256)
1069   {
1070     require(_index < balanceOf(_owner));
1071     return ownedTokens[_owner][_index];
1072   }
1073 
1074   /**
1075    * @dev Gets the total amount of tokens stored by the contract
1076    * @return uint256 representing the total amount of tokens
1077    */
1078   function totalSupply() public view returns (uint256) {
1079     return allTokens.length;
1080   }
1081 
1082   /**
1083    * @dev Gets the token ID at a given index of all the tokens in this contract
1084    * Reverts if the index is greater or equal to the total number of tokens
1085    * @param _index uint256 representing the index to be accessed of the tokens list
1086    * @return uint256 token ID at the given index of the tokens list
1087    */
1088   function tokenByIndex(uint256 _index) public view returns (uint256) {
1089     require(_index < totalSupply());
1090     return allTokens[_index];
1091   }
1092 
1093   /**
1094    * @dev Internal function to set the token URI for a given token
1095    * Reverts if the token ID does not exist
1096    * @param _tokenId uint256 ID of the token to set its URI
1097    * @param _uri string URI to assign
1098    */
1099   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1100     require(exists(_tokenId));
1101     tokenURIs[_tokenId] = _uri;
1102   }
1103 
1104   /**
1105    * @dev Internal function to add a token ID to the list of a given address
1106    * @param _to address representing the new owner of the given token ID
1107    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1108    */
1109   function addTokenTo(address _to, uint256 _tokenId) internal {
1110     super.addTokenTo(_to, _tokenId);
1111     uint256 length = ownedTokens[_to].length;
1112     ownedTokens[_to].push(_tokenId);
1113     ownedTokensIndex[_tokenId] = length;
1114   }
1115 
1116   /**
1117    * @dev Internal function to remove a token ID from the list of a given address
1118    * @param _from address representing the previous owner of the given token ID
1119    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1120    */
1121   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1122     super.removeTokenFrom(_from, _tokenId);
1123 
1124     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1125     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1126     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1127 
1128     ownedTokens[_from][tokenIndex] = lastToken;
1129     ownedTokens[_from][lastTokenIndex] = 0;
1130     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1131     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1132     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1133 
1134     ownedTokens[_from].length--;
1135     ownedTokensIndex[_tokenId] = 0;
1136     ownedTokensIndex[lastToken] = tokenIndex;
1137   }
1138 
1139   /**
1140    * @dev Internal function to mint a new token
1141    * Reverts if the given token ID already exists
1142    * @param _to address the beneficiary that will own the minted token
1143    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1144    */
1145   function _mint(address _to, uint256 _tokenId) internal {
1146     super._mint(_to, _tokenId);
1147 
1148     allTokensIndex[_tokenId] = allTokens.length;
1149     allTokens.push(_tokenId);
1150   }
1151 
1152   /**
1153    * @dev Internal function to burn a specific token
1154    * Reverts if the token does not exist
1155    * @param _owner owner of the token to burn
1156    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1157    */
1158   function _burn(address _owner, uint256 _tokenId) internal {
1159     super._burn(_owner, _tokenId);
1160 
1161     // Clear metadata (if any)
1162     if (bytes(tokenURIs[_tokenId]).length != 0) {
1163       delete tokenURIs[_tokenId];
1164     }
1165 
1166     // Reorg all tokens array
1167     uint256 tokenIndex = allTokensIndex[_tokenId];
1168     uint256 lastTokenIndex = allTokens.length.sub(1);
1169     uint256 lastToken = allTokens[lastTokenIndex];
1170 
1171     allTokens[tokenIndex] = lastToken;
1172     allTokens[lastTokenIndex] = 0;
1173 
1174     allTokens.length--;
1175     allTokensIndex[_tokenId] = 0;
1176     allTokensIndex[lastToken] = tokenIndex;
1177   }
1178 
1179 }
1180 
1181 // File: contracts/InterfaceToken.sol
1182 
1183 /**
1184   * @title InterfaceToken
1185   * https://www.interfacetoken.com/
1186   */
1187 contract InterfaceToken is ERC721Token, Whitelist {
1188   using SafeMath for uint256;
1189 
1190   event Minted(address indexed _owner, uint256 indexed _tokenId, bytes32 _blockhash, bytes32 _nickname);
1191 
1192   string internal tokenBaseURI = "https://ipfs.infura.io/ipfs/";
1193   string internal defaultTokenURI = "Qma4QoWXq7YzFUkREXW9wKVYPZmKzS5pkckaSjwY8Gc489";
1194 
1195   uint256 public purchaseTokenPointer = 1000000000;
1196   uint256 public costOfToken = 0.01 ether;
1197 
1198   mapping(uint256 => bytes32) internal tokenIdToNickname;
1199 
1200   mapping(uint256 => bytes32) internal tokenIdToBlockhash;
1201   mapping(bytes32 => uint256) internal blockhashToTokenId;
1202 
1203   constructor() public ERC721Token("Interface Token", "TOKN") {
1204     super.addAddressToWhitelist(msg.sender);
1205   }
1206 
1207   function() public payable {
1208     buyTokens("");
1209   }
1210 
1211   /**
1212    * @dev Mint a new InterfaceToken token
1213    * @dev Reverts if not called by curator
1214    * @param _blockhash an Ethereum block hash
1215    * @param _tokenId unique token ID
1216    * @param _nickname char stamp of token owner
1217    */
1218   function mint(bytes32 _blockhash, uint256 _tokenId, bytes32 _nickname) external onlyIfWhitelisted(msg.sender) {
1219     require(_tokenId < purchaseTokenPointer); // ensure under number where buying tokens takes place
1220     _mint(_blockhash, _tokenId, _nickname, msg.sender);
1221   }
1222 
1223   /**
1224    * @dev Mint a new InterfaceToken token (with recipient)
1225    * @dev Reverts if not called by curator
1226    * @param _blockhash an Ethereum block hash
1227    * @param _tokenId unique token ID
1228    * @param _nickname char stamp of token owner
1229    * @param _recipient owner of the newly minted token
1230    */
1231   function mintTransfer(bytes32 _blockhash, uint256 _tokenId, bytes32 _nickname, address _recipient) external onlyIfWhitelisted(msg.sender) {
1232     require(_tokenId < purchaseTokenPointer); // ensure under number where buying tokens takes place
1233     _mint(_blockhash, _tokenId, _nickname, _recipient);
1234   }
1235 
1236   /**
1237    * @dev Purchases a new InterfaceToken token
1238    * @dev Reverts if not called by curator
1239    * @param _nickname char stamp of token owner
1240    */
1241   function buyToken(bytes32 _nickname) public payable {
1242     require(msg.value >= costOfToken);
1243 
1244     _mint(keccak256(abi.encodePacked(purchaseTokenPointer, _nickname)), purchaseTokenPointer, _nickname, msg.sender);
1245     purchaseTokenPointer = purchaseTokenPointer.add(1);
1246 
1247     // reconcile payments
1248     owner.transfer(costOfToken);
1249     msg.sender.transfer(msg.value - costOfToken);
1250   }
1251 
1252   /**
1253    * @dev Purchases multiple new InterfaceToken tokens
1254    * @dev Reverts if not called by curator
1255    * @param _nickname char stamp of token owner
1256    */
1257   function buyTokens(bytes32 _nickname) public payable {
1258     require(msg.value >= costOfToken);
1259 
1260     uint i = 0;
1261     for (i; i < (msg.value / costOfToken); i++) {
1262       _mint(keccak256(abi.encodePacked(purchaseTokenPointer, _nickname)), purchaseTokenPointer, _nickname, msg.sender);
1263       purchaseTokenPointer = purchaseTokenPointer.add(1);
1264     }
1265 
1266     // reconcile payments
1267     owner.transfer(costOfToken * i);
1268     msg.sender.transfer(msg.value - (costOfToken * i));
1269   }
1270 
1271   function _mint(bytes32 _blockhash, uint256 _tokenId, bytes32 _nickname, address _recipient) internal {
1272     require(_recipient !=  address(0));
1273     require(blockhashToTokenId[_blockhash] == 0);
1274     require(tokenIdToBlockhash[_tokenId] == 0);
1275 
1276     // mint the token with sender as owner
1277     super._mint(_recipient, _tokenId);
1278 
1279     // set data
1280     tokenIdToBlockhash[_tokenId] = _blockhash;
1281     blockhashToTokenId[_blockhash] = _tokenId;
1282     tokenIdToNickname[_tokenId] = _nickname;
1283 
1284     emit Minted(_recipient, _tokenId, _blockhash, _nickname);
1285   }
1286 
1287   /**
1288    * @dev Utility function changing the cost of the token
1289    * @dev Reverts if not called by owner
1290    * @param _costOfToken cost in wei
1291    */
1292   function setCostOfToken(uint256 _costOfToken) external onlyIfWhitelisted(msg.sender) {
1293     costOfToken = _costOfToken;
1294   }
1295 
1296   /**
1297    * @dev Utility function for updating a nickname if you own the token
1298    * @dev Reverts if not called by owner
1299    * @param _tokenId the  token ID
1300    * @param _nickname char stamp of token owner
1301    */
1302   function setNickname(uint256 _tokenId, bytes32 _nickname) external onlyOwnerOf(_tokenId) {
1303     tokenIdToNickname[_tokenId] = _nickname;
1304   }
1305 
1306   /**
1307    * @dev Return owned tokens
1308    * @param _owner address to query
1309    */
1310   function tokensOf(address _owner) public view returns (uint256[] _tokenIds) {
1311     return ownedTokens[_owner];
1312   }
1313 
1314   /**
1315    * @dev checks for owned tokens
1316    * @param _owner address to query
1317    */
1318   function hasTokens(address _owner) public view returns (bool) {
1319     return ownedTokens[_owner].length > 0;
1320   }
1321 
1322   /**
1323    * @dev checks for owned tokens
1324    * @param _owner address to query
1325    */
1326   function firstToken(address _owner) public view returns (uint256 _tokenId) {
1327     require(hasTokens(_owner));
1328     return ownedTokens[_owner][0];
1329   }
1330 
1331   /**
1332    * @dev Return handle of token
1333    * @param _tokenId token ID for handle lookup
1334    */
1335   function nicknameOf(uint256 _tokenId) public view returns (bytes32 _nickname) {
1336     return tokenIdToNickname[_tokenId];
1337   }
1338 
1339   /**
1340    * @dev Get token URI fro the given token, useful for testing purposes
1341    * @param _tokenId the token ID
1342    * @return the token ID or only the base URI if not found
1343    */
1344   function tokenURI(uint256 _tokenId) public view returns (string) {
1345     if (bytes(tokenURIs[_tokenId]).length == 0) {
1346       return Strings.strConcat(tokenBaseURI, defaultTokenURI);
1347     }
1348 
1349     return Strings.strConcat(tokenBaseURI, tokenURIs[_tokenId]);
1350   }
1351 
1352   /**
1353    * @dev Allows management to update the base tokenURI path
1354    * @dev Reverts if not called by owner
1355    * @param _newBaseURI the new base URI to set
1356    */
1357   function setTokenBaseURI(string _newBaseURI) external onlyOwner {
1358     tokenBaseURI = _newBaseURI;
1359   }
1360 
1361   /**
1362    * @dev Allows management to update the default token URI
1363    * @dev Reverts if not called by owner
1364    * @param _defaultTokenURI the new default URI to set
1365    */
1366   function setDefaultTokenURI(string _defaultTokenURI) external onlyOwner {
1367     defaultTokenURI = _defaultTokenURI;
1368   }
1369 
1370   /**
1371    * @dev Utility function for updating an assets token URI
1372    * @dev Reverts if not called by management
1373    * @param _tokenId the token ID
1374    * @param _uri the token URI, will be concatenated with baseUri
1375    */
1376   function setTokenURI(uint256 _tokenId, string _uri) external onlyIfWhitelisted(msg.sender) {
1377     require(exists(_tokenId));
1378     _setTokenURI(_tokenId, _uri);
1379   }
1380 
1381   /**
1382    * @dev Return blockhash of the  token
1383    * @param _tokenId the token ID
1384    */
1385   function blockhashOf(uint256 _tokenId) public view returns (bytes32 hash) {
1386     return tokenIdToBlockhash[_tokenId];
1387   }
1388 
1389   /**
1390  * @dev Return token ID of a Blockhash
1391  * @param _blockhash blockhash reference
1392  */
1393   function tokenIdOf(bytes32 _blockhash) public view returns (uint256 hash) {
1394     return blockhashToTokenId[_blockhash];
1395   }
1396 
1397   /**
1398    * @dev Return blockhash of the  token
1399    * @param _tokenId the token ID
1400    */
1401   function burn(uint256 _tokenId) public {
1402     super._burn(msg.sender, _tokenId);
1403 
1404     bytes32 tokenBlockhash = tokenIdToBlockhash[_tokenId];
1405 
1406     if (tokenIdToBlockhash[_tokenId].length != 0) {
1407       delete tokenIdToBlockhash[_tokenId];
1408     }
1409 
1410     if (tokenIdToNickname[_tokenId].length != 0) {
1411       delete tokenIdToNickname[_tokenId];
1412     }
1413 
1414     if (blockhashToTokenId[tokenBlockhash] != 0) {
1415       delete blockhashToTokenId[tokenBlockhash];
1416     }
1417   }
1418 }