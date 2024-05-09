1 // File: contracts/ERC721/el/IBurnableEtherLegendsToken.sol
2 
3 pragma solidity 0.5.0;
4 
5 interface IBurnableEtherLegendsToken {        
6     function burn(uint256 tokenId) external;
7 }
8 
9 // File: contracts/ERC721/el/IMintableEtherLegendsToken.sol
10 
11 pragma solidity 0.5.0;
12 
13 interface IMintableEtherLegendsToken {        
14     function mintTokenOfType(address to, uint256 idOfTokenType) external;
15 }
16 
17 // File: contracts/ERC721/el/ITokenDefinitionManager.sol
18 
19 pragma solidity 0.5.0;
20 
21 interface ITokenDefinitionManager {        
22     function getNumberOfTokenDefinitions() external view returns (uint256);
23     function hasTokenDefinition(uint256 tokenTypeId) external view returns (bool);
24     function getTokenTypeNameAtIndex(uint256 index) external view returns (string memory);
25     function getTokenTypeName(uint256 tokenTypeId) external view returns (string memory);
26     function getTokenTypeId(string calldata name) external view returns (uint256);
27     function getCap(uint256 tokenTypeId) external view returns (uint256);
28     function getAbbreviation(uint256 tokenTypeId) external view returns (string memory);
29 }
30 
31 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others (`ERC165Checker`).
41  *
42  * For an implementation, see `ERC165`.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
57 
58 pragma solidity ^0.5.0;
59 
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 contract IERC721 is IERC165 {
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of NFTs in `owner`'s account.
71      */
72     function balanceOf(address owner) public view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the NFT specified by `tokenId`.
76      */
77     function ownerOf(uint256 tokenId) public view returns (address owner);
78 
79     /**
80      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
81      * another (`to`).
82      *
83      * 
84      *
85      * Requirements:
86      * - `from`, `to` cannot be zero.
87      * - `tokenId` must be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this
89      * NFT by either `approve` or `setApproveForAll`.
90      */
91     function safeTransferFrom(address from, address to, uint256 tokenId) public;
92     /**
93      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
94      * another (`to`).
95      *
96      * Requirements:
97      * - If the caller is not `from`, it must be approved to move this NFT by
98      * either `approve` or `setApproveForAll`.
99      */
100     function transferFrom(address from, address to, uint256 tokenId) public;
101     function approve(address to, uint256 tokenId) public;
102     function getApproved(uint256 tokenId) public view returns (address operator);
103 
104     function setApprovalForAll(address operator, bool _approved) public;
105     function isApprovedForAll(address owner, address operator) public view returns (bool);
106 
107 
108     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
112 
113 pragma solidity ^0.5.0;
114 
115 
116 /**
117  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
118  * @dev See https://eips.ethereum.org/EIPS/eip-721
119  */
120 contract IERC721Enumerable is IERC721 {
121     function totalSupply() public view returns (uint256);
122     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
123 
124     function tokenByIndex(uint256 index) public view returns (uint256);
125 }
126 
127 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
128 
129 pragma solidity ^0.5.0;
130 
131 
132 /**
133  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
134  * @dev See https://eips.ethereum.org/EIPS/eip-721
135  */
136 contract IERC721Metadata is IERC721 {
137     function name() external view returns (string memory);
138     function symbol() external view returns (string memory);
139     function tokenURI(uint256 tokenId) external view returns (string memory);
140 }
141 
142 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol
143 
144 pragma solidity ^0.5.0;
145 
146 
147 
148 
149 /**
150  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
151  * @dev See https://eips.ethereum.org/EIPS/eip-721
152  */
153 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
154     // solhint-disable-previous-line no-empty-blocks
155 }
156 
157 // File: contracts/ERC721/el/IEtherLegendsToken.sol
158 
159 pragma solidity 0.5.0;
160 
161 
162 
163 
164 
165 contract IEtherLegendsToken is IERC721Full, IMintableEtherLegendsToken, IBurnableEtherLegendsToken, ITokenDefinitionManager {
166     function totalSupplyOfType(uint256 tokenTypeId) external view returns (uint256);
167     function getTypeIdOfToken(uint256 tokenId) external view returns (uint256);
168 }
169 
170 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
171 
172 pragma solidity ^0.5.0;
173 
174 /**
175  * @title ERC721 token receiver interface
176  * @dev Interface for any contract that wants to support safeTransfers
177  * from ERC721 asset contracts.
178  */
179 contract IERC721Receiver {
180     /**
181      * @notice Handle the receipt of an NFT
182      * @dev The ERC721 smart contract calls this function on the recipient
183      * after a `safeTransfer`. This function MUST return the function selector,
184      * otherwise the caller will revert the transaction. The selector to be
185      * returned can be obtained as `this.onERC721Received.selector`. This
186      * function MAY throw to revert and reject the transfer.
187      * Note: the ERC721 contract address is always the message sender.
188      * @param operator The address which called `safeTransferFrom` function
189      * @param from The address which previously owned the token
190      * @param tokenId The NFT identifier which is being transferred
191      * @param data Additional data with no specified format
192      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
193      */
194     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
195     public returns (bytes4);
196 }
197 
198 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
199 
200 pragma solidity ^0.5.0;
201 
202 /**
203  * @dev Wrappers over Solidity's arithmetic operations with added overflow
204  * checks.
205  *
206  * Arithmetic operations in Solidity wrap on overflow. This can easily result
207  * in bugs, because programmers usually assume that an overflow raises an
208  * error, which is the standard behavior in high level programming languages.
209  * `SafeMath` restores this intuition by reverting the transaction when an
210  * operation overflows.
211  *
212  * Using this library instead of the unchecked operations eliminates an entire
213  * class of bugs, so it's recommended to use it always.
214  */
215 library SafeMath {
216     /**
217      * @dev Returns the addition of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `+` operator.
221      *
222      * Requirements:
223      * - Addition cannot overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         require(b <= a, "SafeMath: subtraction overflow");
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, "SafeMath: division by zero");
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         require(b != 0, "SafeMath: modulo by zero");
304         return a % b;
305     }
306 }
307 
308 // File: openzeppelin-solidity/contracts/utils/Address.sol
309 
310 pragma solidity ^0.5.0;
311 
312 /**
313  * @dev Collection of functions related to the address type,
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * This test is non-exhaustive, and there may be false-negatives: during the
320      * execution of a contract's constructor, its address will be reported as
321      * not containing a contract.
322      *
323      * > It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies in extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 }
337 
338 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
339 
340 pragma solidity ^0.5.0;
341 
342 
343 /**
344  * @title Counters
345  * @author Matt Condon (@shrugs)
346  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
347  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
348  *
349  * Include with `using Counters for Counters.Counter;`
350  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
351  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
352  * directly accessed.
353  */
354 library Counters {
355     using SafeMath for uint256;
356 
357     struct Counter {
358         // This variable should never be directly accessed by users of the library: interactions must be restricted to
359         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
360         // this feature: see https://github.com/ethereum/solidity/issues/4637
361         uint256 _value; // default: 0
362     }
363 
364     function current(Counter storage counter) internal view returns (uint256) {
365         return counter._value;
366     }
367 
368     function increment(Counter storage counter) internal {
369         counter._value += 1;
370     }
371 
372     function decrement(Counter storage counter) internal {
373         counter._value = counter._value.sub(1);
374     }
375 }
376 
377 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
378 
379 pragma solidity ^0.5.0;
380 
381 
382 /**
383  * @dev Implementation of the `IERC165` interface.
384  *
385  * Contracts may inherit from this and call `_registerInterface` to declare
386  * their support of an interface.
387  */
388 contract ERC165 is IERC165 {
389     /*
390      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
391      */
392     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
393 
394     /**
395      * @dev Mapping of interface ids to whether or not it's supported.
396      */
397     mapping(bytes4 => bool) private _supportedInterfaces;
398 
399     constructor () internal {
400         // Derived contracts need only register support for their own interfaces,
401         // we register support for ERC165 itself here
402         _registerInterface(_INTERFACE_ID_ERC165);
403     }
404 
405     /**
406      * @dev See `IERC165.supportsInterface`.
407      *
408      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
409      */
410     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
411         return _supportedInterfaces[interfaceId];
412     }
413 
414     /**
415      * @dev Registers the contract as an implementer of the interface defined by
416      * `interfaceId`. Support of the actual ERC165 interface is automatic and
417      * registering its interface id is not required.
418      *
419      * See `IERC165.supportsInterface`.
420      *
421      * Requirements:
422      *
423      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
424      */
425     function _registerInterface(bytes4 interfaceId) internal {
426         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
427         _supportedInterfaces[interfaceId] = true;
428     }
429 }
430 
431 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
432 
433 pragma solidity ^0.5.0;
434 
435 
436 
437 
438 
439 
440 
441 /**
442  * @title ERC721 Non-Fungible Token Standard basic implementation
443  * @dev see https://eips.ethereum.org/EIPS/eip-721
444  */
445 contract ERC721 is ERC165, IERC721 {
446     using SafeMath for uint256;
447     using Address for address;
448     using Counters for Counters.Counter;
449 
450     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
451     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
452     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
453 
454     // Mapping from token ID to owner
455     mapping (uint256 => address) private _tokenOwner;
456 
457     // Mapping from token ID to approved address
458     mapping (uint256 => address) private _tokenApprovals;
459 
460     // Mapping from owner to number of owned token
461     mapping (address => Counters.Counter) private _ownedTokensCount;
462 
463     // Mapping from owner to operator approvals
464     mapping (address => mapping (address => bool)) private _operatorApprovals;
465 
466     /*
467      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
468      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
469      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
470      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
471      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
472      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
473      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
474      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
475      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
476      *
477      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
478      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
479      */
480     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
481 
482     constructor () public {
483         // register the supported interfaces to conform to ERC721 via ERC165
484         _registerInterface(_INTERFACE_ID_ERC721);
485     }
486 
487     /**
488      * @dev Gets the balance of the specified address.
489      * @param owner address to query the balance of
490      * @return uint256 representing the amount owned by the passed address
491      */
492     function balanceOf(address owner) public view returns (uint256) {
493         require(owner != address(0), "ERC721: balance query for the zero address");
494 
495         return _ownedTokensCount[owner].current();
496     }
497 
498     /**
499      * @dev Gets the owner of the specified token ID.
500      * @param tokenId uint256 ID of the token to query the owner of
501      * @return address currently marked as the owner of the given token ID
502      */
503     function ownerOf(uint256 tokenId) public view returns (address) {
504         address owner = _tokenOwner[tokenId];
505         require(owner != address(0), "ERC721: owner query for nonexistent token");
506 
507         return owner;
508     }
509 
510     /**
511      * @dev Approves another address to transfer the given token ID
512      * The zero address indicates there is no approved address.
513      * There can only be one approved address per token at a given time.
514      * Can only be called by the token owner or an approved operator.
515      * @param to address to be approved for the given token ID
516      * @param tokenId uint256 ID of the token to be approved
517      */
518     function approve(address to, uint256 tokenId) public {
519         address owner = ownerOf(tokenId);
520         require(to != owner, "ERC721: approval to current owner");
521 
522         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
523             "ERC721: approve caller is not owner nor approved for all"
524         );
525 
526         _tokenApprovals[tokenId] = to;
527         emit Approval(owner, to, tokenId);
528     }
529 
530     /**
531      * @dev Gets the approved address for a token ID, or zero if no address set
532      * Reverts if the token ID does not exist.
533      * @param tokenId uint256 ID of the token to query the approval of
534      * @return address currently approved for the given token ID
535      */
536     function getApproved(uint256 tokenId) public view returns (address) {
537         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
538 
539         return _tokenApprovals[tokenId];
540     }
541 
542     /**
543      * @dev Sets or unsets the approval of a given operator
544      * An operator is allowed to transfer all tokens of the sender on their behalf.
545      * @param to operator address to set the approval
546      * @param approved representing the status of the approval to be set
547      */
548     function setApprovalForAll(address to, bool approved) public {
549         require(to != msg.sender, "ERC721: approve to caller");
550 
551         _operatorApprovals[msg.sender][to] = approved;
552         emit ApprovalForAll(msg.sender, to, approved);
553     }
554 
555     /**
556      * @dev Tells whether an operator is approved by a given owner.
557      * @param owner owner address which you want to query the approval of
558      * @param operator operator address which you want to query the approval of
559      * @return bool whether the given operator is approved by the given owner
560      */
561     function isApprovedForAll(address owner, address operator) public view returns (bool) {
562         return _operatorApprovals[owner][operator];
563     }
564 
565     /**
566      * @dev Transfers the ownership of a given token ID to another address.
567      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
568      * Requires the msg.sender to be the owner, approved, or operator.
569      * @param from current owner of the token
570      * @param to address to receive the ownership of the given token ID
571      * @param tokenId uint256 ID of the token to be transferred
572      */
573     function transferFrom(address from, address to, uint256 tokenId) public {
574         //solhint-disable-next-line max-line-length
575         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
576 
577         _transferFrom(from, to, tokenId);
578     }
579 
580     /**
581      * @dev Safely transfers the ownership of a given token ID to another address
582      * If the target address is a contract, it must implement `onERC721Received`,
583      * which is called upon a safe transfer, and return the magic value
584      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
585      * the transfer is reverted.
586      * Requires the msg.sender to be the owner, approved, or operator
587      * @param from current owner of the token
588      * @param to address to receive the ownership of the given token ID
589      * @param tokenId uint256 ID of the token to be transferred
590      */
591     function safeTransferFrom(address from, address to, uint256 tokenId) public {
592         safeTransferFrom(from, to, tokenId, "");
593     }
594 
595     /**
596      * @dev Safely transfers the ownership of a given token ID to another address
597      * If the target address is a contract, it must implement `onERC721Received`,
598      * which is called upon a safe transfer, and return the magic value
599      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
600      * the transfer is reverted.
601      * Requires the msg.sender to be the owner, approved, or operator
602      * @param from current owner of the token
603      * @param to address to receive the ownership of the given token ID
604      * @param tokenId uint256 ID of the token to be transferred
605      * @param _data bytes data to send along with a safe transfer check
606      */
607     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
608         transferFrom(from, to, tokenId);
609         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
610     }
611 
612     /**
613      * @dev Returns whether the specified token exists.
614      * @param tokenId uint256 ID of the token to query the existence of
615      * @return bool whether the token exists
616      */
617     function _exists(uint256 tokenId) internal view returns (bool) {
618         address owner = _tokenOwner[tokenId];
619         return owner != address(0);
620     }
621 
622     /**
623      * @dev Returns whether the given spender can transfer a given token ID.
624      * @param spender address of the spender to query
625      * @param tokenId uint256 ID of the token to be transferred
626      * @return bool whether the msg.sender is approved for the given token ID,
627      * is an operator of the owner, or is the owner of the token
628      */
629     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
630         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
631         address owner = ownerOf(tokenId);
632         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
633     }
634 
635     /**
636      * @dev Internal function to mint a new token.
637      * Reverts if the given token ID already exists.
638      * @param to The address that will own the minted token
639      * @param tokenId uint256 ID of the token to be minted
640      */
641     function _mint(address to, uint256 tokenId) internal {
642         require(to != address(0), "ERC721: mint to the zero address");
643         require(!_exists(tokenId), "ERC721: token already minted");
644 
645         _tokenOwner[tokenId] = to;
646         _ownedTokensCount[to].increment();
647 
648         emit Transfer(address(0), to, tokenId);
649     }
650 
651     /**
652      * @dev Internal function to burn a specific token.
653      * Reverts if the token does not exist.
654      * Deprecated, use _burn(uint256) instead.
655      * @param owner owner of the token to burn
656      * @param tokenId uint256 ID of the token being burned
657      */
658     function _burn(address owner, uint256 tokenId) internal {
659         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
660 
661         _clearApproval(tokenId);
662 
663         _ownedTokensCount[owner].decrement();
664         _tokenOwner[tokenId] = address(0);
665 
666         emit Transfer(owner, address(0), tokenId);
667     }
668 
669     /**
670      * @dev Internal function to burn a specific token.
671      * Reverts if the token does not exist.
672      * @param tokenId uint256 ID of the token being burned
673      */
674     function _burn(uint256 tokenId) internal {
675         _burn(ownerOf(tokenId), tokenId);
676     }
677 
678     /**
679      * @dev Internal function to transfer ownership of a given token ID to another address.
680      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
681      * @param from current owner of the token
682      * @param to address to receive the ownership of the given token ID
683      * @param tokenId uint256 ID of the token to be transferred
684      */
685     function _transferFrom(address from, address to, uint256 tokenId) internal {
686         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
687         require(to != address(0), "ERC721: transfer to the zero address");
688 
689         _clearApproval(tokenId);
690 
691         _ownedTokensCount[from].decrement();
692         _ownedTokensCount[to].increment();
693 
694         _tokenOwner[tokenId] = to;
695 
696         emit Transfer(from, to, tokenId);
697     }
698 
699     /**
700      * @dev Internal function to invoke `onERC721Received` on a target address.
701      * The call is not executed if the target address is not a contract.
702      *
703      * This function is deprecated.
704      * @param from address representing the previous owner of the given token ID
705      * @param to target address that will receive the tokens
706      * @param tokenId uint256 ID of the token to be transferred
707      * @param _data bytes optional data to send along with the call
708      * @return bool whether the call correctly returned the expected magic value
709      */
710     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
711         internal returns (bool)
712     {
713         if (!to.isContract()) {
714             return true;
715         }
716 
717         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
718         return (retval == _ERC721_RECEIVED);
719     }
720 
721     /**
722      * @dev Private function to clear current approval of a given token ID.
723      * @param tokenId uint256 ID of the token to be transferred
724      */
725     function _clearApproval(uint256 tokenId) private {
726         if (_tokenApprovals[tokenId] != address(0)) {
727             _tokenApprovals[tokenId] = address(0);
728         }
729     }
730 }
731 
732 // File: contracts/ERC721/ELERC721Metadata.sol
733 
734 pragma solidity 0.5.0;
735 
736 
737 
738 
739 contract ELERC721Metadata is ERC165, ERC721, IERC721Metadata {
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     /*
747      *     bytes4(keccak256('name()')) == 0x06fdde03
748      *     bytes4(keccak256('symbol()')) == 0x95d89b41
749      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
750      *
751      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
752      */
753     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
754 
755     /**
756      * @dev Constructor function
757      */
758     constructor (string memory name, string memory symbol) public {
759         _name = name;
760         _symbol = symbol;
761 
762         // register the supported interfaces to conform to ERC721 via ERC165
763         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
764     }
765 
766     /**
767      * @dev Gets the token name.
768      * @return string representing the token name
769      */
770     function name() external view returns (string memory) {
771         return _name;
772     }
773 
774     /**
775      * @dev Gets the token symbol.
776      * @return string representing the token symbol
777      */
778     function symbol() external view returns (string memory) {
779         return _symbol;
780     }
781 
782     /**
783      * @dev Returns an URI for a given token ID.
784      * Throws if the token ID does not exist. May return an empty string.
785      * @param tokenId uint256 ID of the token to query
786      */
787     function tokenURI(uint256 tokenId) external view returns (string memory) {
788         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
789         return "";
790     }
791 
792     /**
793      * @dev Internal function to burn a specific token.
794      * Reverts if the token does not exist.
795      * Deprecated, use _burn(uint256) instead.
796      * @param owner owner of the token to burn
797      * @param tokenId uint256 ID of the token being burned by the msg.sender
798      */
799     function _burn(address owner, uint256 tokenId) internal {
800         super._burn(owner, tokenId);
801     }
802 }
803 
804 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
805 
806 pragma solidity ^0.5.0;
807 
808 
809 
810 
811 /**
812  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
813  * @dev See https://eips.ethereum.org/EIPS/eip-721
814  */
815 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
816     // Mapping from owner to list of owned token IDs
817     mapping(address => uint256[]) private _ownedTokens;
818 
819     // Mapping from token ID to index of the owner tokens list
820     mapping(uint256 => uint256) private _ownedTokensIndex;
821 
822     // Array with all token ids, used for enumeration
823     uint256[] private _allTokens;
824 
825     // Mapping from token id to position in the allTokens array
826     mapping(uint256 => uint256) private _allTokensIndex;
827 
828     /*
829      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
830      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
831      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
832      *
833      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
834      */
835     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
836 
837     /**
838      * @dev Constructor function.
839      */
840     constructor () public {
841         // register the supported interface to conform to ERC721Enumerable via ERC165
842         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
843     }
844 
845     /**
846      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
847      * @param owner address owning the tokens list to be accessed
848      * @param index uint256 representing the index to be accessed of the requested tokens list
849      * @return uint256 token ID at the given index of the tokens list owned by the requested address
850      */
851     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
852         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
853         return _ownedTokens[owner][index];
854     }
855 
856     /**
857      * @dev Gets the total amount of tokens stored by the contract.
858      * @return uint256 representing the total amount of tokens
859      */
860     function totalSupply() public view returns (uint256) {
861         return _allTokens.length;
862     }
863 
864     /**
865      * @dev Gets the token ID at a given index of all the tokens in this contract
866      * Reverts if the index is greater or equal to the total number of tokens.
867      * @param index uint256 representing the index to be accessed of the tokens list
868      * @return uint256 token ID at the given index of the tokens list
869      */
870     function tokenByIndex(uint256 index) public view returns (uint256) {
871         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
872         return _allTokens[index];
873     }
874 
875     /**
876      * @dev Internal function to transfer ownership of a given token ID to another address.
877      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
878      * @param from current owner of the token
879      * @param to address to receive the ownership of the given token ID
880      * @param tokenId uint256 ID of the token to be transferred
881      */
882     function _transferFrom(address from, address to, uint256 tokenId) internal {
883         super._transferFrom(from, to, tokenId);
884 
885         _removeTokenFromOwnerEnumeration(from, tokenId);
886 
887         _addTokenToOwnerEnumeration(to, tokenId);
888     }
889 
890     /**
891      * @dev Internal function to mint a new token.
892      * Reverts if the given token ID already exists.
893      * @param to address the beneficiary that will own the minted token
894      * @param tokenId uint256 ID of the token to be minted
895      */
896     function _mint(address to, uint256 tokenId) internal {
897         super._mint(to, tokenId);
898 
899         _addTokenToOwnerEnumeration(to, tokenId);
900 
901         _addTokenToAllTokensEnumeration(tokenId);
902     }
903 
904     /**
905      * @dev Internal function to burn a specific token.
906      * Reverts if the token does not exist.
907      * Deprecated, use _burn(uint256) instead.
908      * @param owner owner of the token to burn
909      * @param tokenId uint256 ID of the token being burned
910      */
911     function _burn(address owner, uint256 tokenId) internal {
912         super._burn(owner, tokenId);
913 
914         _removeTokenFromOwnerEnumeration(owner, tokenId);
915         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
916         _ownedTokensIndex[tokenId] = 0;
917 
918         _removeTokenFromAllTokensEnumeration(tokenId);
919     }
920 
921     /**
922      * @dev Gets the list of token IDs of the requested owner.
923      * @param owner address owning the tokens
924      * @return uint256[] List of token IDs owned by the requested address
925      */
926     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
927         return _ownedTokens[owner];
928     }
929 
930     /**
931      * @dev Private function to add a token to this extension's ownership-tracking data structures.
932      * @param to address representing the new owner of the given token ID
933      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
934      */
935     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
936         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
937         _ownedTokens[to].push(tokenId);
938     }
939 
940     /**
941      * @dev Private function to add a token to this extension's token tracking data structures.
942      * @param tokenId uint256 ID of the token to be added to the tokens list
943      */
944     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
945         _allTokensIndex[tokenId] = _allTokens.length;
946         _allTokens.push(tokenId);
947     }
948 
949     /**
950      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
951      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
952      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
953      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
954      * @param from address representing the previous owner of the given token ID
955      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
956      */
957     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
958         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
959         // then delete the last slot (swap and pop).
960 
961         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
962         uint256 tokenIndex = _ownedTokensIndex[tokenId];
963 
964         // When the token to delete is the last token, the swap operation is unnecessary
965         if (tokenIndex != lastTokenIndex) {
966             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
967 
968             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
969             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
970         }
971 
972         // This also deletes the contents at the last position of the array
973         _ownedTokens[from].length--;
974 
975         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
976         // lastTokenId, or just over the end of the array if the token was the last one).
977     }
978 
979     /**
980      * @dev Private function to remove a token from this extension's token tracking data structures.
981      * This has O(1) time complexity, but alters the order of the _allTokens array.
982      * @param tokenId uint256 ID of the token to be removed from the tokens list
983      */
984     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
985         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
986         // then delete the last slot (swap and pop).
987 
988         uint256 lastTokenIndex = _allTokens.length.sub(1);
989         uint256 tokenIndex = _allTokensIndex[tokenId];
990 
991         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
992         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
993         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
994         uint256 lastTokenId = _allTokens[lastTokenIndex];
995 
996         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
997         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
998 
999         // This also deletes the contents at the last position of the array
1000         _allTokens.length--;
1001         _allTokensIndex[tokenId] = 0;
1002     }
1003 }
1004 
1005 // File: contracts/ERC721/ELERC721Full.sol
1006 
1007 pragma solidity 0.5.0;
1008 
1009 
1010 
1011 
1012 /**
1013  * @title Full ERC721 Token
1014  * This implementation includes all the required and some optional functionality of the ERC721 standard
1015  * Moreover, it includes approve all functionality using operator terminology
1016  * @dev see https://eips.ethereum.org/EIPS/eip-721
1017  */
1018 contract ELERC721Full is ERC721, ERC721Enumerable, ELERC721Metadata {
1019     constructor (string memory name, string memory symbol) public ELERC721Metadata(name, symbol) {
1020         // solhint-disable-previous-line no-empty-blocks
1021     }
1022 }
1023 
1024 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1025 
1026 pragma solidity ^0.5.0;
1027 
1028 /**
1029  * @dev Contract module which provides a basic access control mechanism, where
1030  * there is an account (an owner) that can be granted exclusive access to
1031  * specific functions.
1032  *
1033  * This module is used through inheritance. It will make available the modifier
1034  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1035  * the owner.
1036  */
1037 contract Ownable {
1038     address private _owner;
1039 
1040     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1041 
1042     /**
1043      * @dev Initializes the contract setting the deployer as the initial owner.
1044      */
1045     constructor () internal {
1046         _owner = msg.sender;
1047         emit OwnershipTransferred(address(0), _owner);
1048     }
1049 
1050     /**
1051      * @dev Returns the address of the current owner.
1052      */
1053     function owner() public view returns (address) {
1054         return _owner;
1055     }
1056 
1057     /**
1058      * @dev Throws if called by any account other than the owner.
1059      */
1060     modifier onlyOwner() {
1061         require(isOwner(), "Ownable: caller is not the owner");
1062         _;
1063     }
1064 
1065     /**
1066      * @dev Returns true if the caller is the current owner.
1067      */
1068     function isOwner() public view returns (bool) {
1069         return msg.sender == _owner;
1070     }
1071 
1072     /**
1073      * @dev Leaves the contract without owner. It will not be possible to call
1074      * `onlyOwner` functions anymore. Can only be called by the current owner.
1075      *
1076      * > Note: Renouncing ownership will leave the contract without an owner,
1077      * thereby removing any functionality that is only available to the owner.
1078      */
1079     function renounceOwnership() public onlyOwner {
1080         emit OwnershipTransferred(_owner, address(0));
1081         _owner = address(0);
1082     }
1083 
1084     /**
1085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1086      * Can only be called by the current owner.
1087      */
1088     function transferOwnership(address newOwner) public onlyOwner {
1089         _transferOwnership(newOwner);
1090     }
1091 
1092     /**
1093      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1094      */
1095     function _transferOwnership(address newOwner) internal {
1096         require(newOwner != address(0), "Ownable: new owner is the zero address");
1097         emit OwnershipTransferred(_owner, newOwner);
1098         _owner = newOwner;
1099     }
1100 }
1101 
1102 // File: openzeppelin-solidity/contracts/access/Roles.sol
1103 
1104 pragma solidity ^0.5.0;
1105 
1106 /**
1107  * @title Roles
1108  * @dev Library for managing addresses assigned to a Role.
1109  */
1110 library Roles {
1111     struct Role {
1112         mapping (address => bool) bearer;
1113     }
1114 
1115     /**
1116      * @dev Give an account access to this role.
1117      */
1118     function add(Role storage role, address account) internal {
1119         require(!has(role, account), "Roles: account already has role");
1120         role.bearer[account] = true;
1121     }
1122 
1123     /**
1124      * @dev Remove an account's access to this role.
1125      */
1126     function remove(Role storage role, address account) internal {
1127         require(has(role, account), "Roles: account does not have role");
1128         role.bearer[account] = false;
1129     }
1130 
1131     /**
1132      * @dev Check if an account has this role.
1133      * @return bool
1134      */
1135     function has(Role storage role, address account) internal view returns (bool) {
1136         require(account != address(0), "Roles: account is the zero address");
1137         return role.bearer[account];
1138     }
1139 }
1140 
1141 // File: contracts/ERC721/el/EtherLegendsToken.sol
1142 
1143 pragma solidity 0.5.0;
1144 
1145 
1146 
1147 
1148 
1149 contract EtherLegendsToken is ELERC721Full, IEtherLegendsToken, Ownable {
1150   using Roles for Roles.Role;
1151   Roles.Role private _minters;
1152 
1153   mapping (uint256 => uint256) private _tokenTypeToSupply;
1154   mapping (uint256 => uint256) private _tokenIdToType;
1155   uint256 private _amountMinted;  
1156 
1157   uint256 private nextTokenTypeIndex;
1158   string[] public tokenTypeNames;
1159   mapping (uint256 => uint256) private tokenTypeIndexMap;
1160   mapping (string => uint256) private tokenTypeNameIdMap;    
1161   mapping (uint256 => string) private tokenTypeIdNameMap;
1162   mapping (uint256 => uint256) private tokenTypeToCap;
1163   mapping (uint256 => string) private tokenTypeToAbbreviation;
1164 
1165   string public baseTokenURI;
1166 
1167   constructor() public 
1168     ELERC721Full("Ether Legends", "EL")
1169     Ownable()
1170   {
1171 
1172   }  
1173 
1174   function isMinter(address account) public view returns (bool) {
1175     return _minters.has(account);
1176   }
1177 
1178   function addMinter(address account) external {
1179     _requireOnlyOwner();
1180     _minters.add(account);
1181   }
1182 
1183   function removeMinter(address account) external {
1184     _requireOnlyOwner();
1185     _minters.remove(account);
1186   }        
1187 
1188   function _totalSupplyOfType(uint256 tokenTypeId) internal view returns (uint256) {
1189     return _tokenTypeToSupply[tokenTypeId];
1190   }
1191 
1192   function totalSupplyOfType(uint256 tokenTypeId) external view returns (uint256) {
1193     return _totalSupplyOfType(tokenTypeId);
1194   }
1195 
1196   function getTypeIdOfToken(uint256 tokenId) external view returns (uint256) {
1197     return _tokenIdToType[tokenId];
1198   }
1199 
1200   function exists(uint256 tokenId) external view returns (bool) {
1201     return _exists(tokenId);
1202   }
1203 
1204   function mintTokenOfType(address to, uint256 idOfTokenType) external {
1205     _requireOnlyMinter();
1206     require(_totalSupplyOfType(idOfTokenType) < _getCap(idOfTokenType));
1207     _mint(to, _amountMinted++, idOfTokenType);
1208   }
1209 
1210   function _mint(address to, uint256 tokenId, uint256 idOfTokenType) internal {    
1211     _mint(to, tokenId);
1212     _tokenTypeToSupply[idOfTokenType]++;
1213     _tokenIdToType[tokenId] = idOfTokenType;
1214   }
1215 
1216   function burn(uint256 tokenId) external {  
1217     require(_isApprovedOrOwner(msg.sender, tokenId), "caller is not owner nor approved");
1218     _burn(tokenId);    
1219     _tokenTypeToSupply[_tokenIdToType[tokenId]]--;
1220     delete _tokenIdToType[tokenId];
1221   }  
1222 
1223   function _requireOnlyOwner() internal view {
1224     require(isOwner(), "Ownable: caller is not the owner");
1225   }
1226 
1227   function _requireOnlyMinter() internal view {
1228     require(isMinter(msg.sender), "caller does not have the Minter role");
1229   }
1230 
1231   /* Token Definition Management */  
1232 
1233   function hasTokenDefinition(uint256 tokenTypeId) external view returns (bool) {
1234     return _hasTokenDefinition(tokenTypeId);
1235   }
1236 
1237   function getNumberOfTokenDefinitions() external view returns (uint256) {
1238     return tokenTypeNames.length;
1239   }          
1240 
1241   function getTokenTypeId(string calldata name) external view returns (uint256) {
1242     return _getTokenTypeId(name);
1243   }    
1244 
1245   function getTokenTypeNameAtIndex(uint256 index) external view returns (string memory) {
1246     require(index < tokenTypeNames.length, "Token Definition Index Out Of Range");
1247     return tokenTypeNames[index];
1248   }
1249 
1250   function getTokenTypeName(uint256 tokenTypeId) external view returns (string memory) {
1251     return _getTokenTypeName(tokenTypeId);
1252   }  
1253 
1254   function getCap(uint256 tokenTypeId) external view returns (uint256) {
1255     return _getCap(tokenTypeId);
1256   }  
1257 
1258   function getAbbreviation(uint256 tokenTypeId) external view returns (string memory) {
1259     return _getAbbreviation(tokenTypeId);
1260   }
1261 
1262   function addTokenDefinition(string calldata name, uint256 cap, string calldata abbreviation) external {
1263     _requireOnlyOwner();
1264     require(!_hasTokenDefinition(name), "token type already defined");
1265     require(bytes(abbreviation).length < 32, "abbreviation may not exceed 31 characters");
1266 
1267     nextTokenTypeIndex++;
1268     tokenTypeIndexMap[nextTokenTypeIndex] = tokenTypeNames.length;
1269     tokenTypeNameIdMap[name] = nextTokenTypeIndex;
1270     tokenTypeIdNameMap[nextTokenTypeIndex] = name;
1271     tokenTypeNames.push(name);
1272     tokenTypeToCap[nextTokenTypeIndex] = cap;
1273     tokenTypeToAbbreviation[nextTokenTypeIndex] = abbreviation;
1274   }    
1275 
1276   function removeTokenDefinition(string calldata name) external {
1277     _requireOnlyOwner();
1278     require(_hasTokenDefinition(name), "token type not defined");
1279     require(_totalSupplyOfType(_getTokenTypeId(name)) == 0, "tokens of this type exist");
1280 
1281     uint256 typeId = tokenTypeNameIdMap[name];      
1282     uint256 typeIndex = tokenTypeIndexMap[typeId];
1283 
1284     delete tokenTypeIndexMap[typeId];
1285     delete tokenTypeNameIdMap[name];
1286     delete tokenTypeIdNameMap[typeId];
1287     delete tokenTypeToCap[typeId];
1288     delete tokenTypeToAbbreviation[typeId];
1289 
1290     string memory tmp = _getTokenTypeNameAtIndex(typeIndex);      
1291     string memory priorLastTypeName = _getTokenTypeNameAtIndex(tokenTypeNames.length - 1);
1292     uint256 priorLastTypeId = tokenTypeNameIdMap[priorLastTypeName];      
1293     tokenTypeNames[typeIndex] = tokenTypeNames[tokenTypeNames.length - 1];
1294     tokenTypeNames[tokenTypeNames.length - 1] = tmp;
1295     tokenTypeIndexMap[priorLastTypeId] = typeIndex;
1296     delete tokenTypeNames[tokenTypeNames.length - 1];
1297     tokenTypeNames.length--;
1298   }
1299 
1300   function _hasTokenDefinition(string memory name) internal view returns (bool) {
1301     return tokenTypeNameIdMap[name] != 0;
1302   }
1303 
1304   function _hasTokenDefinition(uint256 tokenTypeId) internal view returns (bool) {
1305     return tokenTypeToCap[tokenTypeId] != 0;
1306   }
1307 
1308   function _getTokenTypeId(string memory name) internal view returns (uint256) {
1309     require(_hasTokenDefinition(name), "path not defined");
1310     return tokenTypeNameIdMap[name];
1311   }
1312 
1313   function _getTokenTypeName(uint256 tokenTypeId) internal view returns (string memory) {
1314     require(_hasTokenDefinition(tokenTypeId), "path not defined");
1315     return tokenTypeIdNameMap[tokenTypeId];
1316   }
1317 
1318   function _getCap(uint256 tokenTypeId) internal view returns (uint256) {
1319     require(_hasTokenDefinition(tokenTypeId), "token type not defined");
1320     return tokenTypeToCap[tokenTypeId];
1321   }  
1322 
1323   function _getAbbreviation(uint256 tokenTypeId) internal view returns (string memory) {
1324     require(_hasTokenDefinition(tokenTypeId), "token type not defined");
1325     return tokenTypeToAbbreviation[tokenTypeId];
1326   }  
1327 
1328   function _getTokenTypeNameAtIndex(uint256 typeIndex) internal view returns (string memory) {
1329     return tokenTypeNames[typeIndex];
1330   }
1331 
1332   /* Token URI */
1333 
1334   function setBaseURI(string calldata uri) external {
1335     _requireOnlyOwner();
1336     baseTokenURI = uri;    
1337   }    
1338 
1339   function tokenURI(uint256 tokenId) external view returns (string memory) {
1340     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1341     return string(abi.encodePacked(baseTokenURI, _getAbbreviation(_tokenIdToType[tokenId]), '?tokenId=', uint2str(tokenId)));
1342   }
1343 
1344   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1345     if (_i == 0) {
1346       return "0";
1347     }
1348     uint j = _i;
1349     uint len;
1350     while (j != 0) {
1351       len++;
1352       j /= 10;
1353     }
1354     bytes memory bstr = new bytes(len);
1355     uint k = len - 1;
1356     while (_i != 0) {
1357       bstr[k--] = byte(uint8(48 + _i % 10));
1358       _i /= 10;
1359     }
1360     return string(bstr);
1361   }
1362 }