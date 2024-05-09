1 // File: @ensdomains/ens/contracts/ENS.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface ENS {
6 
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19     // Logged when an operator is added or removed.
20     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
21 
22     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
23     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
24     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
25     function setResolver(bytes32 node, address resolver) external;
26     function setOwner(bytes32 node, address owner) external;
27     function setTTL(bytes32 node, uint64 ttl) external;
28     function setApprovalForAll(address operator, bool approved) external;
29     function owner(bytes32 node) external view returns (address);
30     function resolver(bytes32 node) external view returns (address);
31     function ttl(bytes32 node) external view returns (uint64);
32     function recordExists(bytes32 node) external view returns (bool);
33     function isApprovedForAll(address owner, address operator) external view returns (bool);
34 }
35 
36 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @title IERC165
42  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
43  */
44 interface IERC165 {
45     /**
46      * @notice Query if a contract implements an interface
47      * @param interfaceId The interface identifier, as specified in ERC-165
48      * @dev Interface identification is specified in ERC-165. This function
49      * uses less than 30,000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.5.0;
57 
58 
59 /**
60  * @title ERC721 Non-Fungible Token Standard basic interface
61  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
62  */
63 contract IERC721 is IERC165 {
64     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
65     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     function balanceOf(address owner) public view returns (uint256 balance);
69     function ownerOf(uint256 tokenId) public view returns (address owner);
70 
71     function approve(address to, uint256 tokenId) public;
72     function getApproved(uint256 tokenId) public view returns (address operator);
73 
74     function setApprovalForAll(address operator, bool _approved) public;
75     function isApprovedForAll(address owner, address operator) public view returns (bool);
76 
77     function transferFrom(address from, address to, uint256 tokenId) public;
78     function safeTransferFrom(address from, address to, uint256 tokenId) public;
79 
80     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
81 }
82 
83 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
84 
85 pragma solidity ^0.5.0;
86 
87 /**
88  * @title ERC721 token receiver interface
89  * @dev Interface for any contract that wants to support safeTransfers
90  * from ERC721 asset contracts.
91  */
92 contract IERC721Receiver {
93     /**
94      * @notice Handle the receipt of an NFT
95      * @dev The ERC721 smart contract calls this function on the recipient
96      * after a `safeTransfer`. This function MUST return the function selector,
97      * otherwise the caller will revert the transaction. The selector to be
98      * returned can be obtained as `this.onERC721Received.selector`. This
99      * function MAY throw to revert and reject the transfer.
100      * Note: the ERC721 contract address is always the message sender.
101      * @param operator The address which called `safeTransferFrom` function
102      * @param from The address which previously owned the token
103      * @param tokenId The NFT identifier which is being transferred
104      * @param data Additional data with no specified format
105      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
106      */
107     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
108     public returns (bytes4);
109 }
110 
111 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @title SafeMath
117  * @dev Unsigned math operations with safety checks that revert on error
118  */
119 library SafeMath {
120     /**
121     * @dev Multiplies two unsigned integers, reverts on overflow.
122     */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127         if (a == 0) {
128             return 0;
129         }
130 
131         uint256 c = a * b;
132         require(c / a == b);
133 
134         return c;
135     }
136 
137     /**
138     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
139     */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Solidity only automatically asserts when dividing by 0
142         require(b > 0);
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     /**
150     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
151     */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160     * @dev Adds two unsigned integers, reverts on overflow.
161     */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a);
165 
166         return c;
167     }
168 
169     /**
170     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
171     * reverts when dividing by zero.
172     */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b != 0);
175         return a % b;
176     }
177 }
178 
179 // File: openzeppelin-solidity/contracts/utils/Address.sol
180 
181 pragma solidity ^0.5.0;
182 
183 /**
184  * Utility library of inline functions on addresses
185  */
186 library Address {
187     /**
188      * Returns whether the target address is a contract
189      * @dev This function will return false if invoked during the constructor of a contract,
190      * as the code is not actually created until after the constructor finishes.
191      * @param account address of the account to check
192      * @return whether the target address is a contract
193      */
194     function isContract(address account) internal view returns (bool) {
195         uint256 size;
196         // XXX Currently there is no better way to check if there is a contract in an address
197         // than to check the size of the code at that address.
198         // See https://ethereum.stackexchange.com/a/14016/36603
199         // for more details about how this works.
200         // TODO Check this again before the Serenity release, because all addresses will be
201         // contracts then.
202         // solhint-disable-next-line no-inline-assembly
203         assembly { size := extcodesize(account) }
204         return size > 0;
205     }
206 }
207 
208 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
209 
210 pragma solidity ^0.5.0;
211 
212 
213 /**
214  * @title ERC165
215  * @author Matt Condon (@shrugs)
216  * @dev Implements ERC165 using a lookup table.
217  */
218 contract ERC165 is IERC165 {
219     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
220     /**
221      * 0x01ffc9a7 ===
222      *     bytes4(keccak256('supportsInterface(bytes4)'))
223      */
224 
225     /**
226      * @dev a mapping of interface id to whether or not it's supported
227      */
228     mapping(bytes4 => bool) private _supportedInterfaces;
229 
230     /**
231      * @dev A contract implementing SupportsInterfaceWithLookup
232      * implement ERC165 itself
233      */
234     constructor () internal {
235         _registerInterface(_INTERFACE_ID_ERC165);
236     }
237 
238     /**
239      * @dev implement supportsInterface(bytes4) using a lookup table
240      */
241     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
242         return _supportedInterfaces[interfaceId];
243     }
244 
245     /**
246      * @dev internal method for registering an interface
247      */
248     function _registerInterface(bytes4 interfaceId) internal {
249         require(interfaceId != 0xffffffff);
250         _supportedInterfaces[interfaceId] = true;
251     }
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
255 
256 pragma solidity ^0.5.0;
257 
258 
259 
260 
261 
262 
263 /**
264  * @title ERC721 Non-Fungible Token Standard basic implementation
265  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
266  */
267 contract ERC721 is ERC165, IERC721 {
268     using SafeMath for uint256;
269     using Address for address;
270 
271     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
272     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
273     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
274 
275     // Mapping from token ID to owner
276     mapping (uint256 => address) private _tokenOwner;
277 
278     // Mapping from token ID to approved address
279     mapping (uint256 => address) private _tokenApprovals;
280 
281     // Mapping from owner to number of owned token
282     mapping (address => uint256) private _ownedTokensCount;
283 
284     // Mapping from owner to operator approvals
285     mapping (address => mapping (address => bool)) private _operatorApprovals;
286 
287     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
288     /*
289      * 0x80ac58cd ===
290      *     bytes4(keccak256('balanceOf(address)')) ^
291      *     bytes4(keccak256('ownerOf(uint256)')) ^
292      *     bytes4(keccak256('approve(address,uint256)')) ^
293      *     bytes4(keccak256('getApproved(uint256)')) ^
294      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
295      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
296      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
297      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
298      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
299      */
300 
301     constructor () public {
302         // register the supported interfaces to conform to ERC721 via ERC165
303         _registerInterface(_INTERFACE_ID_ERC721);
304     }
305 
306     /**
307      * @dev Gets the balance of the specified address
308      * @param owner address to query the balance of
309      * @return uint256 representing the amount owned by the passed address
310      */
311     function balanceOf(address owner) public view returns (uint256) {
312         require(owner != address(0));
313         return _ownedTokensCount[owner];
314     }
315 
316     /**
317      * @dev Gets the owner of the specified token ID
318      * @param tokenId uint256 ID of the token to query the owner of
319      * @return owner address currently marked as the owner of the given token ID
320      */
321     function ownerOf(uint256 tokenId) public view returns (address) {
322         address owner = _tokenOwner[tokenId];
323         require(owner != address(0));
324         return owner;
325     }
326 
327     /**
328      * @dev Approves another address to transfer the given token ID
329      * The zero address indicates there is no approved address.
330      * There can only be one approved address per token at a given time.
331      * Can only be called by the token owner or an approved operator.
332      * @param to address to be approved for the given token ID
333      * @param tokenId uint256 ID of the token to be approved
334      */
335     function approve(address to, uint256 tokenId) public {
336         address owner = ownerOf(tokenId);
337         require(to != owner);
338         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
339 
340         _tokenApprovals[tokenId] = to;
341         emit Approval(owner, to, tokenId);
342     }
343 
344     /**
345      * @dev Gets the approved address for a token ID, or zero if no address set
346      * Reverts if the token ID does not exist.
347      * @param tokenId uint256 ID of the token to query the approval of
348      * @return address currently approved for the given token ID
349      */
350     function getApproved(uint256 tokenId) public view returns (address) {
351         require(_exists(tokenId));
352         return _tokenApprovals[tokenId];
353     }
354 
355     /**
356      * @dev Sets or unsets the approval of a given operator
357      * An operator is allowed to transfer all tokens of the sender on their behalf
358      * @param to operator address to set the approval
359      * @param approved representing the status of the approval to be set
360      */
361     function setApprovalForAll(address to, bool approved) public {
362         require(to != msg.sender);
363         _operatorApprovals[msg.sender][to] = approved;
364         emit ApprovalForAll(msg.sender, to, approved);
365     }
366 
367     /**
368      * @dev Tells whether an operator is approved by a given owner
369      * @param owner owner address which you want to query the approval of
370      * @param operator operator address which you want to query the approval of
371      * @return bool whether the given operator is approved by the given owner
372      */
373     function isApprovedForAll(address owner, address operator) public view returns (bool) {
374         return _operatorApprovals[owner][operator];
375     }
376 
377     /**
378      * @dev Transfers the ownership of a given token ID to another address
379      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
380      * Requires the msg sender to be the owner, approved, or operator
381      * @param from current owner of the token
382      * @param to address to receive the ownership of the given token ID
383      * @param tokenId uint256 ID of the token to be transferred
384     */
385     function transferFrom(address from, address to, uint256 tokenId) public {
386         require(_isApprovedOrOwner(msg.sender, tokenId));
387 
388         _transferFrom(from, to, tokenId);
389     }
390 
391     /**
392      * @dev Safely transfers the ownership of a given token ID to another address
393      * If the target address is a contract, it must implement `onERC721Received`,
394      * which is called upon a safe transfer, and return the magic value
395      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
396      * the transfer is reverted.
397      *
398      * Requires the msg sender to be the owner, approved, or operator
399      * @param from current owner of the token
400      * @param to address to receive the ownership of the given token ID
401      * @param tokenId uint256 ID of the token to be transferred
402     */
403     function safeTransferFrom(address from, address to, uint256 tokenId) public {
404         safeTransferFrom(from, to, tokenId, "");
405     }
406 
407     /**
408      * @dev Safely transfers the ownership of a given token ID to another address
409      * If the target address is a contract, it must implement `onERC721Received`,
410      * which is called upon a safe transfer, and return the magic value
411      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
412      * the transfer is reverted.
413      * Requires the msg sender to be the owner, approved, or operator
414      * @param from current owner of the token
415      * @param to address to receive the ownership of the given token ID
416      * @param tokenId uint256 ID of the token to be transferred
417      * @param _data bytes data to send along with a safe transfer check
418      */
419     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
420         transferFrom(from, to, tokenId);
421         require(_checkOnERC721Received(from, to, tokenId, _data));
422     }
423 
424     /**
425      * @dev Returns whether the specified token exists
426      * @param tokenId uint256 ID of the token to query the existence of
427      * @return whether the token exists
428      */
429     function _exists(uint256 tokenId) internal view returns (bool) {
430         address owner = _tokenOwner[tokenId];
431         return owner != address(0);
432     }
433 
434     /**
435      * @dev Returns whether the given spender can transfer a given token ID
436      * @param spender address of the spender to query
437      * @param tokenId uint256 ID of the token to be transferred
438      * @return bool whether the msg.sender is approved for the given token ID,
439      *    is an operator of the owner, or is the owner of the token
440      */
441     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
442         address owner = ownerOf(tokenId);
443         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
444     }
445 
446     /**
447      * @dev Internal function to mint a new token
448      * Reverts if the given token ID already exists
449      * @param to The address that will own the minted token
450      * @param tokenId uint256 ID of the token to be minted
451      */
452     function _mint(address to, uint256 tokenId) internal {
453         require(to != address(0));
454         require(!_exists(tokenId));
455 
456         _tokenOwner[tokenId] = to;
457         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
458 
459         emit Transfer(address(0), to, tokenId);
460     }
461 
462     /**
463      * @dev Internal function to burn a specific token
464      * Reverts if the token does not exist
465      * Deprecated, use _burn(uint256) instead.
466      * @param owner owner of the token to burn
467      * @param tokenId uint256 ID of the token being burned
468      */
469     function _burn(address owner, uint256 tokenId) internal {
470         require(ownerOf(tokenId) == owner);
471 
472         _clearApproval(tokenId);
473 
474         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
475         _tokenOwner[tokenId] = address(0);
476 
477         emit Transfer(owner, address(0), tokenId);
478     }
479 
480     /**
481      * @dev Internal function to burn a specific token
482      * Reverts if the token does not exist
483      * @param tokenId uint256 ID of the token being burned
484      */
485     function _burn(uint256 tokenId) internal {
486         _burn(ownerOf(tokenId), tokenId);
487     }
488 
489     /**
490      * @dev Internal function to transfer ownership of a given token ID to another address.
491      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
492      * @param from current owner of the token
493      * @param to address to receive the ownership of the given token ID
494      * @param tokenId uint256 ID of the token to be transferred
495     */
496     function _transferFrom(address from, address to, uint256 tokenId) internal {
497         require(ownerOf(tokenId) == from);
498         require(to != address(0));
499 
500         _clearApproval(tokenId);
501 
502         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
503         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
504 
505         _tokenOwner[tokenId] = to;
506 
507         emit Transfer(from, to, tokenId);
508     }
509 
510     /**
511      * @dev Internal function to invoke `onERC721Received` on a target address
512      * The call is not executed if the target address is not a contract
513      * @param from address representing the previous owner of the given token ID
514      * @param to target address that will receive the tokens
515      * @param tokenId uint256 ID of the token to be transferred
516      * @param _data bytes optional data to send along with the call
517      * @return whether the call correctly returned the expected magic value
518      */
519     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
520         internal returns (bool)
521     {
522         if (!to.isContract()) {
523             return true;
524         }
525 
526         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
527         return (retval == _ERC721_RECEIVED);
528     }
529 
530     /**
531      * @dev Private function to clear current approval of a given token ID
532      * @param tokenId uint256 ID of the token to be transferred
533      */
534     function _clearApproval(uint256 tokenId) private {
535         if (_tokenApprovals[tokenId] != address(0)) {
536             _tokenApprovals[tokenId] = address(0);
537         }
538     }
539 }
540 
541 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
542 
543 pragma solidity ^0.5.0;
544 
545 /**
546  * @title Ownable
547  * @dev The Ownable contract has an owner address, and provides basic authorization control
548  * functions, this simplifies the implementation of "user permissions".
549  */
550 contract Ownable {
551     address private _owner;
552 
553     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
554 
555     /**
556      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
557      * account.
558      */
559     constructor () internal {
560         _owner = msg.sender;
561         emit OwnershipTransferred(address(0), _owner);
562     }
563 
564     /**
565      * @return the address of the owner.
566      */
567     function owner() public view returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if called by any account other than the owner.
573      */
574     modifier onlyOwner() {
575         require(isOwner());
576         _;
577     }
578 
579     /**
580      * @return true if `msg.sender` is the owner of the contract.
581      */
582     function isOwner() public view returns (bool) {
583         return msg.sender == _owner;
584     }
585 
586     /**
587      * @dev Allows the current owner to relinquish control of the contract.
588      * @notice Renouncing to ownership will leave the contract without an owner.
589      * It will not be possible to call the functions with the `onlyOwner`
590      * modifier anymore.
591      */
592     function renounceOwnership() public onlyOwner {
593         emit OwnershipTransferred(_owner, address(0));
594         _owner = address(0);
595     }
596 
597     /**
598      * @dev Allows the current owner to transfer control of the contract to a newOwner.
599      * @param newOwner The address to transfer ownership to.
600      */
601     function transferOwnership(address newOwner) public onlyOwner {
602         _transferOwnership(newOwner);
603     }
604 
605     /**
606      * @dev Transfers control of the contract to a newOwner.
607      * @param newOwner The address to transfer ownership to.
608      */
609     function _transferOwnership(address newOwner) internal {
610         require(newOwner != address(0));
611         emit OwnershipTransferred(_owner, newOwner);
612         _owner = newOwner;
613     }
614 }
615 
616 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
617 
618 pragma solidity >=0.4.24;
619 
620 
621 
622 
623 contract BaseRegistrar is IERC721, Ownable {
624     uint constant public GRACE_PERIOD = 90 days;
625 
626     event ControllerAdded(address indexed controller);
627     event ControllerRemoved(address indexed controller);
628     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
629     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
630     event NameRenewed(uint256 indexed id, uint expires);
631 
632     // The ENS registry
633     ENS public ens;
634 
635     // The namehash of the TLD this registrar owns (eg, .eth)
636     bytes32 public baseNode;
637 
638     // A map of addresses that are authorised to register and renew names.
639     mapping(address=>bool) public controllers;
640 
641     // Authorises a controller, who can register and renew domains.
642     function addController(address controller) external;
643 
644     // Revoke controller permission for an address.
645     function removeController(address controller) external;
646 
647     // Set the resolver for the TLD this registrar manages.
648     function setResolver(address resolver) external;
649 
650     // Returns the expiration timestamp of the specified label hash.
651     function nameExpires(uint256 id) external view returns(uint);
652 
653     // Returns true iff the specified name is available for registration.
654     function available(uint256 id) public view returns(bool);
655 
656     /**
657      * @dev Register a name.
658      */
659     function register(uint256 id, address owner, uint duration) external returns(uint);
660 
661     function renew(uint256 id, uint duration) external returns(uint);
662 
663     /**
664      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
665      */
666     function reclaim(uint256 id, address owner) external;
667 }
668 
669 // File: @ensdomains/ethregistrar/contracts/BaseRegistrarImplementation.sol
670 
671 pragma solidity ^0.5.0;
672 
673 
674 
675 
676 contract BaseRegistrarImplementation is BaseRegistrar, ERC721 {
677     // A map of expiry times
678     mapping(uint256=>uint) expiries;
679 
680     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
681     bytes4 constant private ERC721_ID = bytes4(
682         keccak256("balanceOf(address)") ^
683         keccak256("ownerOf(uint256)") ^
684         keccak256("approve(address,uint256)") ^
685         keccak256("getApproved(uint256)") ^
686         keccak256("setApprovalForAll(address,bool)") ^
687         keccak256("isApprovedForAll(address,address)") ^
688         keccak256("transferFrom(address,address,uint256)") ^
689         keccak256("safeTransferFrom(address,address,uint256)") ^
690         keccak256("safeTransferFrom(address,address,uint256,bytes)")
691     );
692     bytes4 constant private RECLAIM_ID = bytes4(keccak256("reclaim(uint256,address)"));
693 
694     constructor(ENS _ens, bytes32 _baseNode) public {
695         ens = _ens;
696         baseNode = _baseNode;
697     }
698 
699     modifier live {
700         require(ens.owner(baseNode) == address(this));
701         _;
702     }
703 
704     modifier onlyController {
705         require(controllers[msg.sender]);
706         _;
707     }
708 
709     /**
710      * @dev Gets the owner of the specified token ID. Names become unowned
711      *      when their registration expires.
712      * @param tokenId uint256 ID of the token to query the owner of
713      * @return address currently marked as the owner of the given token ID
714      */
715     function ownerOf(uint256 tokenId) public view returns (address) {
716         require(expiries[tokenId] > now);
717         return super.ownerOf(tokenId);
718     }
719 
720     // Authorises a controller, who can register and renew domains.
721     function addController(address controller) external onlyOwner {
722         controllers[controller] = true;
723         emit ControllerAdded(controller);
724     }
725 
726     // Revoke controller permission for an address.
727     function removeController(address controller) external onlyOwner {
728         controllers[controller] = false;
729         emit ControllerRemoved(controller);
730     }
731 
732     // Set the resolver for the TLD this registrar manages.
733     function setResolver(address resolver) external onlyOwner {
734         ens.setResolver(baseNode, resolver);
735     }
736 
737     // Returns the expiration timestamp of the specified id.
738     function nameExpires(uint256 id) external view returns(uint) {
739         return expiries[id];
740     }
741 
742     // Returns true iff the specified name is available for registration.
743     function available(uint256 id) public view returns(bool) {
744         // Not available if it's registered here or in its grace period.
745         return expiries[id] + GRACE_PERIOD < now;
746     }
747 
748     /**
749      * @dev Register a name.
750      * @param id The token ID (keccak256 of the label).
751      * @param owner The address that should own the registration.
752      * @param duration Duration in seconds for the registration.
753      */
754     function register(uint256 id, address owner, uint duration) external returns(uint) {
755       return _register(id, owner, duration, true);
756     }
757 
758     /**
759      * @dev Register a name, without modifying the registry.
760      * @param id The token ID (keccak256 of the label).
761      * @param owner The address that should own the registration.
762      * @param duration Duration in seconds for the registration.
763      */
764     function registerOnly(uint256 id, address owner, uint duration) external returns(uint) {
765       return _register(id, owner, duration, false);
766     }
767 
768     function _register(uint256 id, address owner, uint duration, bool updateRegistry) internal live onlyController returns(uint) {
769         require(available(id));
770         require(now + duration + GRACE_PERIOD > now + GRACE_PERIOD); // Prevent future overflow
771 
772         expiries[id] = now + duration;
773         if(_exists(id)) {
774             // Name was previously owned, and expired
775             _burn(id);
776         }
777         _mint(owner, id);
778         if(updateRegistry) {
779             ens.setSubnodeOwner(baseNode, bytes32(id), owner);
780         }
781 
782         emit NameRegistered(id, owner, now + duration);
783 
784         return now + duration;
785     }
786 
787     function renew(uint256 id, uint duration) external live onlyController returns(uint) {
788         require(expiries[id] + GRACE_PERIOD >= now); // Name must be registered here or in grace period
789         require(expiries[id] + duration + GRACE_PERIOD > duration + GRACE_PERIOD); // Prevent future overflow
790 
791         expiries[id] += duration;
792         emit NameRenewed(id, expiries[id]);
793         return expiries[id];
794     }
795 
796     /**
797      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
798      */
799     function reclaim(uint256 id, address owner) external live {
800         require(_isApprovedOrOwner(msg.sender, id));
801         ens.setSubnodeOwner(baseNode, bytes32(id), owner);
802     }
803 
804     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
805         return interfaceID == INTERFACE_META_ID ||
806                interfaceID == ERC721_ID ||
807                interfaceID == RECLAIM_ID;
808     }
809 }