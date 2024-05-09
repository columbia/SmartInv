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
254 /**
255  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
256  * @dev See https://eips.ethereum.org/EIPS/eip-721
257  */
258 contract IERC721Metadata is IERC721 {
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 }
274 
275 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
276 
277 pragma solidity ^0.5.0;
278 
279 
280 
281 
282 
283 
284 /**
285  * @title ERC721 Non-Fungible Token Standard basic implementation
286  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
287  */
288 contract ERC721 is ERC165, IERC721Metadata {
289     using SafeMath for uint256;
290     using Address for address;
291 
292     // Token name
293     string public name;
294     // Token symbol
295     string public symbol;
296 
297     string public uriPrefix = "";
298     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
299     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
300     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
301 
302     // Mapping from token ID to owner
303     mapping (uint256 => address) private _tokenOwner;
304 
305     // Mapping from token ID to approved address
306     mapping (uint256 => address) private _tokenApprovals;
307 
308     // Mapping from owner to number of owned token
309     mapping (address => uint256) private _ownedTokensCount;
310 
311     // Mapping from owner to operator approvals
312     mapping (address => mapping (address => bool)) private _operatorApprovals;
313 
314     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
315     /*
316      * 0x80ac58cd ===
317      *     bytes4(keccak256('balanceOf(address)')) ^
318      *     bytes4(keccak256('ownerOf(uint256)')) ^
319      *     bytes4(keccak256('approve(address,uint256)')) ^
320      *     bytes4(keccak256('getApproved(uint256)')) ^
321      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
322      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
323      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
324      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
325      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
326      */
327 
328     constructor () public {
329         // register the supported interfaces to conform to ERC721 via ERC165
330         _registerInterface(_INTERFACE_ID_ERC721);
331         name ="SEER: Web3 Identity";
332         symbol ="SDID";
333     }
334 
335     /**
336      * @dev Gets the balance of the specified address
337      * @param owner address to query the balance of
338      * @return uint256 representing the amount owned by the passed address
339      */
340     function balanceOf(address owner) public view returns (uint256) {
341         require(owner != address(0));
342         return _ownedTokensCount[owner];
343     }
344 
345     /**
346      * @dev Gets the owner of the specified token ID
347      * @param tokenId uint256 ID of the token to query the owner of
348      * @return owner address currently marked as the owner of the given token ID
349      */
350     function ownerOf(uint256 tokenId) public view returns (address) {
351         address owner = _tokenOwner[tokenId];
352         require(owner != address(0));
353         return owner;
354     }
355 
356     function _baseURI() internal view returns (string memory) {
357         return uriPrefix;
358     }
359 
360     /**
361      * @dev See {IERC721Metadata-tokenURI}.
362      */
363     function tokenURI(uint256 tokenId) public view  returns (string memory) {
364         require(_tokenOwner[tokenId] != address(0));
365         string memory baseURI = _baseURI();
366         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, uint2str(tokenId))) : "";
367     }
368 
369     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
370         if (_i == 0) {
371             return "0";
372         }
373         uint j = _i;
374         uint len;
375         while (j != 0) {
376             len++;
377             j /= 10;
378         }
379         bytes memory bstr = new bytes(len);
380         uint k = len;
381         while (_i != 0) {
382             k = k-1;
383             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
384             bytes1 b1 = bytes1(temp);
385             bstr[k] = b1;
386             _i /= 10;
387         }
388         return string(bstr);
389     }
390 
391     /**
392      * @dev Approves another address to transfer the given token ID
393      * The zero address indicates there is no approved address.
394      * There can only be one approved address per token at a given time.
395      * Can only be called by the token owner or an approved operator.
396      * @param to address to be approved for the given token ID
397      * @param tokenId uint256 ID of the token to be approved
398      */
399     function approve(address to, uint256 tokenId) public {
400         address owner = ownerOf(tokenId);
401         require(to != owner);
402         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
403 
404         _tokenApprovals[tokenId] = to;
405         emit Approval(owner, to, tokenId);
406     }
407 
408     /**
409      * @dev Gets the approved address for a token ID, or zero if no address set
410      * Reverts if the token ID does not exist.
411      * @param tokenId uint256 ID of the token to query the approval of
412      * @return address currently approved for the given token ID
413      */
414     function getApproved(uint256 tokenId) public view returns (address) {
415         require(_exists(tokenId));
416         return _tokenApprovals[tokenId];
417     }
418 
419     /**
420      * @dev Sets or unsets the approval of a given operator
421      * An operator is allowed to transfer all tokens of the sender on their behalf
422      * @param to operator address to set the approval
423      * @param approved representing the status of the approval to be set
424      */
425     function setApprovalForAll(address to, bool approved) public {
426         require(to != msg.sender);
427         _operatorApprovals[msg.sender][to] = approved;
428         emit ApprovalForAll(msg.sender, to, approved);
429     }
430 
431     /**
432      * @dev Tells whether an operator is approved by a given owner
433      * @param owner owner address which you want to query the approval of
434      * @param operator operator address which you want to query the approval of
435      * @return bool whether the given operator is approved by the given owner
436      */
437     function isApprovedForAll(address owner, address operator) public view returns (bool) {
438         return _operatorApprovals[owner][operator];
439     }
440 
441     /**
442      * @dev Transfers the ownership of a given token ID to another address
443      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
444      * Requires the msg sender to be the owner, approved, or operator
445      * @param from current owner of the token
446      * @param to address to receive the ownership of the given token ID
447      * @param tokenId uint256 ID of the token to be transferred
448     */
449     function transferFrom(address from, address to, uint256 tokenId) public {
450         require(_isApprovedOrOwner(msg.sender, tokenId));
451 
452         _transferFrom(from, to, tokenId);
453     }
454 
455     /**
456      * @dev Safely transfers the ownership of a given token ID to another address
457      * If the target address is a contract, it must implement `onERC721Received`,
458      * which is called upon a safe transfer, and return the magic value
459      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
460      * the transfer is reverted.
461      *
462      * Requires the msg sender to be the owner, approved, or operator
463      * @param from current owner of the token
464      * @param to address to receive the ownership of the given token ID
465      * @param tokenId uint256 ID of the token to be transferred
466     */
467     function safeTransferFrom(address from, address to, uint256 tokenId) public {
468         safeTransferFrom(from, to, tokenId, "");
469     }
470 
471     /**
472      * @dev Safely transfers the ownership of a given token ID to another address
473      * If the target address is a contract, it must implement `onERC721Received`,
474      * which is called upon a safe transfer, and return the magic value
475      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
476      * the transfer is reverted.
477      * Requires the msg sender to be the owner, approved, or operator
478      * @param from current owner of the token
479      * @param to address to receive the ownership of the given token ID
480      * @param tokenId uint256 ID of the token to be transferred
481      * @param _data bytes data to send along with a safe transfer check
482      */
483     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
484         transferFrom(from, to, tokenId);
485         require(_checkOnERC721Received(from, to, tokenId, _data));
486     }
487 
488     /**
489      * @dev Returns whether the specified token exists
490      * @param tokenId uint256 ID of the token to query the existence of
491      * @return whether the token exists
492      */
493     function _exists(uint256 tokenId) internal view returns (bool) {
494         address owner = _tokenOwner[tokenId];
495         return owner != address(0);
496     }
497 
498     /**
499      * @dev Returns whether the given spender can transfer a given token ID
500      * @param spender address of the spender to query
501      * @param tokenId uint256 ID of the token to be transferred
502      * @return bool whether the msg.sender is approved for the given token ID,
503      *    is an operator of the owner, or is the owner of the token
504      */
505     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
506         address owner = ownerOf(tokenId);
507         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
508     }
509 
510     /**
511      * @dev Internal function to mint a new token
512      * Reverts if the given token ID already exists
513      * @param to The address that will own the minted token
514      * @param tokenId uint256 ID of the token to be minted
515      */
516     function _mint(address to, uint256 tokenId) internal {
517         require(to != address(0));
518         require(!_exists(tokenId));
519 
520         _tokenOwner[tokenId] = to;
521         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
522 
523         emit Transfer(address(0), to, tokenId);
524     }
525 
526     /**
527      * @dev Internal function to burn a specific token
528      * Reverts if the token does not exist
529      * Deprecated, use _burn(uint256) instead.
530      * @param owner owner of the token to burn
531      * @param tokenId uint256 ID of the token being burned
532      */
533     function _burn(address owner, uint256 tokenId) internal {
534         require(ownerOf(tokenId) == owner);
535 
536         _clearApproval(tokenId);
537 
538         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
539         _tokenOwner[tokenId] = address(0);
540 
541         emit Transfer(owner, address(0), tokenId);
542     }
543 
544     /**
545      * @dev Internal function to burn a specific token
546      * Reverts if the token does not exist
547      * @param tokenId uint256 ID of the token being burned
548      */
549     function _burn(uint256 tokenId) internal {
550         _burn(ownerOf(tokenId), tokenId);
551     }
552 
553     /**
554      * @dev Internal function to transfer ownership of a given token ID to another address.
555      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
556      * @param from current owner of the token
557      * @param to address to receive the ownership of the given token ID
558      * @param tokenId uint256 ID of the token to be transferred
559     */
560     function _transferFrom(address from, address to, uint256 tokenId) internal {
561         require(ownerOf(tokenId) == from);
562         require(to != address(0));
563 
564         _clearApproval(tokenId);
565 
566         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
567         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
568 
569         _tokenOwner[tokenId] = to;
570 
571         emit Transfer(from, to, tokenId);
572     }
573 
574     /**
575      * @dev Internal function to invoke `onERC721Received` on a target address
576      * The call is not executed if the target address is not a contract
577      * @param from address representing the previous owner of the given token ID
578      * @param to target address that will receive the tokens
579      * @param tokenId uint256 ID of the token to be transferred
580      * @param _data bytes optional data to send along with the call
581      * @return whether the call correctly returned the expected magic value
582      */
583     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
584         internal returns (bool)
585     {
586         if (!to.isContract()) {
587             return true;
588         }
589 
590         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
591         return (retval == _ERC721_RECEIVED);
592     }
593 
594     /**
595      * @dev Private function to clear current approval of a given token ID
596      * @param tokenId uint256 ID of the token to be transferred
597      */
598     function _clearApproval(uint256 tokenId) private {
599         if (_tokenApprovals[tokenId] != address(0)) {
600             _tokenApprovals[tokenId] = address(0);
601         }
602     }
603 }
604 
605 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
606 
607 pragma solidity ^0.5.0;
608 
609 /**
610  * @title Ownable
611  * @dev The Ownable contract has an owner address, and provides basic authorization control
612  * functions, this simplifies the implementation of "user permissions".
613  */
614 contract Ownable {
615     address private _owner;
616 
617     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
618 
619     /**
620      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
621      * account.
622      */
623     constructor () internal {
624         _owner = msg.sender;
625         emit OwnershipTransferred(address(0), _owner);
626     }
627 
628     /**
629      * @return the address of the owner.
630      */
631     function owner() public view returns (address) {
632         return _owner;
633     }
634 
635     /**
636      * @dev Throws if called by any account other than the owner.
637      */
638     modifier onlyOwner() {
639         require(isOwner());
640         _;
641     }
642 
643     /**
644      * @return true if `msg.sender` is the owner of the contract.
645      */
646     function isOwner() public view returns (bool) {
647         return msg.sender == _owner;
648     }
649 
650     /**
651      * @dev Allows the current owner to relinquish control of the contract.
652      * @notice Renouncing to ownership will leave the contract without an owner.
653      * It will not be possible to call the functions with the `onlyOwner`
654      * modifier anymore.
655      */
656     function renounceOwnership() public onlyOwner {
657         emit OwnershipTransferred(_owner, address(0));
658         _owner = address(0);
659     }
660 
661     /**
662      * @dev Allows the current owner to transfer control of the contract to a newOwner.
663      * @param newOwner The address to transfer ownership to.
664      */
665     function transferOwnership(address newOwner) public onlyOwner {
666         _transferOwnership(newOwner);
667     }
668 
669     /**
670      * @dev Transfers control of the contract to a newOwner.
671      * @param newOwner The address to transfer ownership to.
672      */
673     function _transferOwnership(address newOwner) internal {
674         require(newOwner != address(0));
675         emit OwnershipTransferred(_owner, newOwner);
676         _owner = newOwner;
677     }
678 }
679 
680 // File: @ensdomains/ethregistrar/contracts/BaseRegistrar.sol
681 
682 pragma solidity >=0.4.24;
683 
684 
685 
686 
687 contract BaseRegistrar is IERC721, Ownable {
688     uint constant public GRACE_PERIOD = 90 days;
689 
690     event ControllerAdded(address indexed controller);
691     event ControllerRemoved(address indexed controller);
692     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
693     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
694     event NameRenewed(uint256 indexed id, uint expires);
695 
696     // The ENS registry
697     ENS public ens;
698 
699     // The namehash of the TLD this registrar owns (eg, .eth)
700     bytes32 public baseNode;
701 
702     // A map of addresses that are authorised to register and renew names.
703     mapping(address=>bool) public controllers;
704 
705     // Authorises a controller, who can register and renew domains.
706     function addController(address controller) external;
707 
708     // Revoke controller permission for an address.
709     function removeController(address controller) external;
710 
711     // Set the resolver for the TLD this registrar manages.
712     function setResolver(address resolver) external;
713 
714     // Returns the expiration timestamp of the specified label hash.
715     function nameExpires(uint256 id) external view returns(uint);
716 
717     // Returns true iff the specified name is available for registration.
718     function available(uint256 id) public view returns(bool);
719 
720     /**
721      * @dev Register a name.
722      */
723     function register(uint256 id, address owner, uint duration) external returns(uint);
724 
725     function renew(uint256 id, uint duration) external returns(uint);
726 
727     /**
728      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
729      */
730     function reclaim(uint256 id, address owner) external;
731 }
732 
733 
734 
735 
736 // File: @ensdomains/ethregistrar/contracts/BaseRegistrarImplementation.sol
737 
738 pragma solidity ^0.5.0;
739 
740 
741 
742 
743 contract BaseRegistrarImplementation is BaseRegistrar, ERC721 {
744     // A map of expiry times
745     mapping(uint256=>uint) expiries;
746 
747     bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));
748     bytes4 constant private ERC721_ID = bytes4(
749         keccak256("balanceOf(address)") ^
750         keccak256("ownerOf(uint256)") ^
751         keccak256("approve(address,uint256)") ^
752         keccak256("getApproved(uint256)") ^
753         keccak256("setApprovalForAll(address,bool)") ^
754         keccak256("isApprovedForAll(address,address)") ^
755         keccak256("transferFrom(address,address,uint256)") ^
756         keccak256("safeTransferFrom(address,address,uint256)") ^
757         keccak256("safeTransferFrom(address,address,uint256,bytes)")
758     );
759     bytes4 constant private RECLAIM_ID = bytes4(keccak256("reclaim(uint256,address)"));
760     bytes4 constant private METADATA_ID = bytes4(
761         keccak256("name()")^
762         keccak256("symbol()")^
763         keccak256("tokenURI(uint256)")
764     );
765 
766     constructor(ENS _ens, bytes32 _baseNode) public {
767         ens = _ens;
768         baseNode = _baseNode;
769     }
770 
771     modifier live {
772         require(ens.owner(baseNode) == address(this));
773         _;
774     }
775 
776     modifier onlyController {
777         require(controllers[msg.sender]);
778         _;
779     }
780 
781     /**
782      * @dev Gets the owner of the specified token ID. Names become unowned
783      *      when their registration expires.
784      * @param tokenId uint256 ID of the token to query the owner of
785      * @return address currently marked as the owner of the given token ID
786      */
787     function ownerOf(uint256 tokenId) public view returns (address) {
788         require(expiries[tokenId] > now);
789         return super.ownerOf(tokenId);
790     }
791 
792     // Authorises a controller, who can register and renew domains.
793     function addController(address controller) external onlyOwner {
794         controllers[controller] = true;
795         emit ControllerAdded(controller);
796     }
797 
798     // Revoke controller permission for an address.
799     function removeController(address controller) external onlyOwner {
800         controllers[controller] = false;
801         emit ControllerRemoved(controller);
802     }
803 
804     // Set the resolver for the TLD this registrar manages.
805     function setResolver(address resolver) external onlyOwner {
806         ens.setResolver(baseNode, resolver);
807     }
808 
809     // Returns the expiration timestamp of the specified id.
810     function nameExpires(uint256 id) external view returns(uint) {
811         return expiries[id];
812     }
813 
814     // Returns true iff the specified name is available for registration.
815     function available(uint256 id) public view returns(bool) {
816         // Not available if it's registered here or in its grace period.
817         return expiries[id] + GRACE_PERIOD < now;
818     }
819 
820     /**
821      * @dev Register a name.
822      * @param id The token ID (keccak256 of the label).
823      * @param owner The address that should own the registration.
824      * @param duration Duration in seconds for the registration.
825      */
826     function register(uint256 id, address owner, uint duration) external returns(uint) {
827       return _register(id, owner, duration, true);
828     }
829 
830     /**
831      * @dev Register a name, without modifying the registry.
832      * @param id The token ID (keccak256 of the label).
833      * @param owner The address that should own the registration.
834      * @param duration Duration in seconds for the registration.
835      */
836     function registerOnly(uint256 id, address owner, uint duration) external returns(uint) {
837       return _register(id, owner, duration, false);
838     }
839 
840     function _register(uint256 id, address owner, uint duration, bool updateRegistry) internal live onlyController returns(uint) {
841         require(available(id));
842         require(now + duration + GRACE_PERIOD > now + GRACE_PERIOD); // Prevent future overflow
843 
844         expiries[id] = now + duration;
845         if(_exists(id)) {
846             // Name was previously owned, and expired
847             _burn(id);
848         }
849         _mint(owner, id);
850         if(updateRegistry) {
851             ens.setSubnodeOwner(baseNode, bytes32(id), owner);
852         }
853 
854         emit NameRegistered(id, owner, now + duration);
855 
856         return now + duration;
857     }
858 
859     function renew(uint256 id, uint duration) external live onlyController returns(uint) {
860         require(expiries[id] + GRACE_PERIOD >= now); // Name must be registered here or in grace period
861         require(expiries[id] + duration + GRACE_PERIOD > duration + GRACE_PERIOD); // Prevent future overflow
862 
863         expiries[id] += duration;
864         emit NameRenewed(id, expiries[id]);
865         return expiries[id];
866     }
867 
868     /**
869      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
870      */
871     function reclaim(uint256 id, address owner) external live {
872         require(_isApprovedOrOwner(msg.sender, id));
873         ens.setSubnodeOwner(baseNode, bytes32(id), owner);
874     }
875 
876     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
877         uriPrefix = _uriPrefix;
878     }
879 
880     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
881         return interfaceID == INTERFACE_META_ID ||
882                interfaceID == ERC721_ID ||
883                interfaceID == RECLAIM_ID ||
884                interfaceID == METADATA_ID;
885     }
886 }