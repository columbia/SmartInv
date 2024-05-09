1 // File: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others (`ERC165Checker`).
11  *
12  * For an implementation, see `ERC165`.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 
28 pragma solidity ^0.5.0;
29 
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 contract IERC721 is IERC165 {
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
37     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
38 
39     /**
40      * @dev Returns the number of NFTs in `owner`'s account.
41      */
42     function balanceOf(address owner) public view returns (uint256 balance);
43 
44     /**
45      * @dev Returns the owner of the NFT specified by `tokenId`.
46      */
47     function ownerOf(uint256 tokenId) public view returns (address owner);
48 
49     /**
50      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
51      * another (`to`).
52      *
53      * 
54      *
55      * Requirements:
56      * - `from`, `to` cannot be zero.
57      * - `tokenId` must be owned by `from`.
58      * - If the caller is not `from`, it must be have been allowed to move this
59      * NFT by either `approve` or `setApproveForAll`.
60      */
61     function safeTransferFrom(address from, address to, uint256 tokenId) public;
62     /**
63      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
64      * another (`to`).
65      *
66      * Requirements:
67      * - If the caller is not `from`, it must be approved to move this NFT by
68      * either `approve` or `setApproveForAll`.
69      */
70     function transferFrom(address from, address to, uint256 tokenId) public;
71     function approve(address to, uint256 tokenId) public;
72     function getApproved(uint256 tokenId) public view returns (address operator);
73 
74     function setApprovalForAll(address operator, bool _approved) public;
75     function isApprovedForAll(address owner, address operator) public view returns (bool);
76 
77 
78     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
82 
83 pragma solidity ^0.5.0;
84 
85 
86 /**
87  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
88  * @dev See https://eips.ethereum.org/EIPS/eip-721
89  */
90 contract IERC721Metadata is IERC721 {
91     function name() external view returns (string memory);
92     function symbol() external view returns (string memory);
93     function tokenURI(uint256 tokenId) external view returns (string memory);
94 }
95 
96 // File: contracts/IRegistry.sol
97 
98 pragma solidity 0.5.12;
99 
100 
101 contract IRegistry is IERC721Metadata {
102 
103     event NewURI(uint256 indexed tokenId, string uri);
104 
105     event NewURIPrefix(string prefix);
106 
107     event Resolve(uint256 indexed tokenId, address indexed to);
108 
109     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
110 
111     /**
112      * @dev Controlled function to set the token URI Prefix for all tokens.
113      * @param prefix string URI to assign
114      */
115     function controlledSetTokenURIPrefix(string calldata prefix) external;
116 
117     /**
118      * @dev Returns whether the given spender can transfer a given token ID.
119      * @param spender address of the spender to query
120      * @param tokenId uint256 ID of the token to be transferred
121      * @return bool whether the msg.sender is approved for the given token ID,
122      * is an operator of the owner, or is the owner of the token
123      */
124     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
125 
126     /**
127      * @dev Mints a new a child token.
128      * Calculates child token ID using a namehash function.
129      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
130      * Requires the token not exist.
131      * @param to address to receive the ownership of the given token ID
132      * @param tokenId uint256 ID of the parent token
133      * @param label subdomain label of the child token ID
134      */
135     function mintChild(address to, uint256 tokenId, string calldata label) external;
136 
137     /**
138      * @dev Controlled function to mint a given token ID.
139      * Requires the msg.sender to be controller.
140      * Requires the token ID to not exist.
141      * @param to address the given token ID will be minted to
142      * @param label string that is a subdomain
143      * @param tokenId uint256 ID of the parent token
144      */
145     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
146 
147     /**
148      * @dev Transfers the ownership of a child token ID to another address.
149      * Calculates child token ID using a namehash function.
150      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
151      * Requires the token already exist.
152      * @param from current owner of the token
153      * @param to address to receive the ownership of the given token ID
154      * @param tokenId uint256 ID of the token to be transferred
155      * @param label subdomain label of the child token ID
156      */
157     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
158 
159     /**
160      * @dev Controlled function to transfers the ownership of a token ID to
161      * another address.
162      * Requires the msg.sender to be controller.
163      * Requires the token already exist.
164      * @param from current owner of the token
165      * @param to address to receive the ownership of the given token ID
166      * @param tokenId uint256 ID of the token to be transferred
167      */
168     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
169 
170     /**
171      * @dev Safely transfers the ownership of a child token ID to another address.
172      * Calculates child token ID using a namehash function.
173      * Implements a ERC721Reciever check unlike transferFromChild.
174      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
175      * Requires the token already exist.
176      * @param from current owner of the token
177      * @param to address to receive the ownership of the given token ID
178      * @param tokenId uint256 parent ID of the token to be transferred
179      * @param label subdomain label of the child token ID
180      * @param _data bytes data to send along with a safe transfer check
181      */
182     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
183 
184     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
185     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
186 
187     /**
188      * @dev Controlled frunction to safely transfers the ownership of a token ID
189      * to another address.
190      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
191      * Requires the msg.sender to be controller.
192      * Requires the token already exist.
193      * @param from current owner of the token
194      * @param to address to receive the ownership of the given token ID
195      * @param tokenId uint256 parent ID of the token to be transferred
196      * @param _data bytes data to send along with a safe transfer check
197      */
198     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
199 
200     /**
201      * @dev Burns a child token ID.
202      * Calculates child token ID using a namehash function.
203      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
204      * Requires the token already exist.
205      * @param tokenId uint256 ID of the token to be transferred
206      * @param label subdomain label of the child token ID
207      */
208     function burnChild(uint256 tokenId, string calldata label) external;
209 
210     /**
211      * @dev Controlled function to burn a given token ID.
212      * Requires the msg.sender to be controller.
213      * Requires the token already exist.
214      * @param tokenId uint256 ID of the token to be burned
215      */
216     function controlledBurn(uint256 tokenId) external;
217 
218     /**
219      * @dev Sets the resolver of a given token ID to another address.
220      * Requires the msg.sender to be the owner, approved, or operator.
221      * @param to address the given token ID will resolve to
222      * @param tokenId uint256 ID of the token to be transferred
223      */
224     function resolveTo(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Gets the resolver of the specified token ID.
228      * @param tokenId uint256 ID of the token to query the resolver of
229      * @return address currently marked as the resolver of the given token ID
230      */
231     function resolverOf(uint256 tokenId) external view returns (address);
232 
233     /**
234      * @dev Controlled function to sets the resolver of a given token ID.
235      * Requires the msg.sender to be controller.
236      * @param to address the given token ID will resolve to
237      * @param tokenId uint256 ID of the token to be transferred
238      */
239     function controlledResolveTo(address to, uint256 tokenId) external;
240 
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
244 
245 pragma solidity ^0.5.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 contract IERC721Receiver {
253     /**
254      * @notice Handle the receipt of an NFT
255      * @dev The ERC721 smart contract calls this function on the recipient
256      * after a `safeTransfer`. This function MUST return the function selector,
257      * otherwise the caller will revert the transaction. The selector to be
258      * returned can be obtained as `this.onERC721Received.selector`. This
259      * function MAY throw to revert and reject the transfer.
260      * Note: the ERC721 contract address is always the message sender.
261      * @param operator The address which called `safeTransferFrom` function
262      * @param from The address which previously owned the token
263      * @param tokenId The NFT identifier which is being transferred
264      * @param data Additional data with no specified format
265      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
266      */
267     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
268     public returns (bytes4);
269 }
270 
271 // File: @openzeppelin/contracts/math/SafeMath.sol
272 
273 pragma solidity ^0.5.0;
274 
275 /**
276  * @dev Wrappers over Solidity's arithmetic operations with added overflow
277  * checks.
278  *
279  * Arithmetic operations in Solidity wrap on overflow. This can easily result
280  * in bugs, because programmers usually assume that an overflow raises an
281  * error, which is the standard behavior in high level programming languages.
282  * `SafeMath` restores this intuition by reverting the transaction when an
283  * operation overflows.
284  *
285  * Using this library instead of the unchecked operations eliminates an entire
286  * class of bugs, so it's recommended to use it always.
287  */
288 library SafeMath {
289     /**
290      * @dev Returns the addition of two unsigned integers, reverting on
291      * overflow.
292      *
293      * Counterpart to Solidity's `+` operator.
294      *
295      * Requirements:
296      * - Addition cannot overflow.
297      */
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         uint256 c = a + b;
300         require(c >= a, "SafeMath: addition overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the subtraction of two unsigned integers, reverting on
307      * overflow (when the result is negative).
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      * - Subtraction cannot overflow.
313      */
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         require(b <= a, "SafeMath: subtraction overflow");
316         uint256 c = a - b;
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the multiplication of two unsigned integers, reverting on
323      * overflow.
324      *
325      * Counterpart to Solidity's `*` operator.
326      *
327      * Requirements:
328      * - Multiplication cannot overflow.
329      */
330     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
331         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
332         // benefit is lost if 'b' is also tested.
333         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
334         if (a == 0) {
335             return 0;
336         }
337 
338         uint256 c = a * b;
339         require(c / a == b, "SafeMath: multiplication overflow");
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the integer division of two unsigned integers. Reverts on
346      * division by zero. The result is rounded towards zero.
347      *
348      * Counterpart to Solidity's `/` operator. Note: this function uses a
349      * `revert` opcode (which leaves remaining gas untouched) while Solidity
350      * uses an invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      * - The divisor cannot be zero.
354      */
355     function div(uint256 a, uint256 b) internal pure returns (uint256) {
356         // Solidity only automatically asserts when dividing by 0
357         require(b > 0, "SafeMath: division by zero");
358         uint256 c = a / b;
359         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * Reverts when dividing by zero.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
376         require(b != 0, "SafeMath: modulo by zero");
377         return a % b;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/utils/Address.sol
382 
383 pragma solidity ^0.5.0;
384 
385 /**
386  * @dev Collection of functions related to the address type,
387  */
388 library Address {
389     /**
390      * @dev Returns true if `account` is a contract.
391      *
392      * This test is non-exhaustive, and there may be false-negatives: during the
393      * execution of a contract's constructor, its address will be reported as
394      * not containing a contract.
395      *
396      * > It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      */
399     function isContract(address account) internal view returns (bool) {
400         // This method relies in extcodesize, which returns 0 for contracts in
401         // construction, since the code is only stored at the end of the
402         // constructor execution.
403 
404         uint256 size;
405         // solhint-disable-next-line no-inline-assembly
406         assembly { size := extcodesize(account) }
407         return size > 0;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/drafts/Counters.sol
412 
413 pragma solidity ^0.5.0;
414 
415 
416 /**
417  * @title Counters
418  * @author Matt Condon (@shrugs)
419  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
420  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
421  *
422  * Include with `using Counters for Counters.Counter;`
423  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
424  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
425  * directly accessed.
426  */
427 library Counters {
428     using SafeMath for uint256;
429 
430     struct Counter {
431         // This variable should never be directly accessed by users of the library: interactions must be restricted to
432         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
433         // this feature: see https://github.com/ethereum/solidity/issues/4637
434         uint256 _value; // default: 0
435     }
436 
437     function current(Counter storage counter) internal view returns (uint256) {
438         return counter._value;
439     }
440 
441     function increment(Counter storage counter) internal {
442         counter._value += 1;
443     }
444 
445     function decrement(Counter storage counter) internal {
446         counter._value = counter._value.sub(1);
447     }
448 }
449 
450 // File: @openzeppelin/contracts/introspection/ERC165.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 /**
456  * @dev Implementation of the `IERC165` interface.
457  *
458  * Contracts may inherit from this and call `_registerInterface` to declare
459  * their support of an interface.
460  */
461 contract ERC165 is IERC165 {
462     /*
463      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
464      */
465     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
466 
467     /**
468      * @dev Mapping of interface ids to whether or not it's supported.
469      */
470     mapping(bytes4 => bool) private _supportedInterfaces;
471 
472     constructor () internal {
473         // Derived contracts need only register support for their own interfaces,
474         // we register support for ERC165 itself here
475         _registerInterface(_INTERFACE_ID_ERC165);
476     }
477 
478     /**
479      * @dev See `IERC165.supportsInterface`.
480      *
481      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
482      */
483     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
484         return _supportedInterfaces[interfaceId];
485     }
486 
487     /**
488      * @dev Registers the contract as an implementer of the interface defined by
489      * `interfaceId`. Support of the actual ERC165 interface is automatic and
490      * registering its interface id is not required.
491      *
492      * See `IERC165.supportsInterface`.
493      *
494      * Requirements:
495      *
496      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
497      */
498     function _registerInterface(bytes4 interfaceId) internal {
499         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
500         _supportedInterfaces[interfaceId] = true;
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 
511 
512 
513 
514 /**
515  * @title ERC721 Non-Fungible Token Standard basic implementation
516  * @dev see https://eips.ethereum.org/EIPS/eip-721
517  */
518 contract ERC721 is ERC165, IERC721 {
519     using SafeMath for uint256;
520     using Address for address;
521     using Counters for Counters.Counter;
522 
523     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
524     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
525     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
526 
527     // Mapping from token ID to owner
528     mapping (uint256 => address) private _tokenOwner;
529 
530     // Mapping from token ID to approved address
531     mapping (uint256 => address) private _tokenApprovals;
532 
533     // Mapping from owner to number of owned token
534     mapping (address => Counters.Counter) private _ownedTokensCount;
535 
536     // Mapping from owner to operator approvals
537     mapping (address => mapping (address => bool)) private _operatorApprovals;
538 
539     /*
540      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
541      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
542      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
543      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
544      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
545      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
546      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
547      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
548      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
549      *
550      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
551      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
552      */
553     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
554 
555     constructor () public {
556         // register the supported interfaces to conform to ERC721 via ERC165
557         _registerInterface(_INTERFACE_ID_ERC721);
558     }
559 
560     /**
561      * @dev Gets the balance of the specified address.
562      * @param owner address to query the balance of
563      * @return uint256 representing the amount owned by the passed address
564      */
565     function balanceOf(address owner) public view returns (uint256) {
566         require(owner != address(0), "ERC721: balance query for the zero address");
567 
568         return _ownedTokensCount[owner].current();
569     }
570 
571     /**
572      * @dev Gets the owner of the specified token ID.
573      * @param tokenId uint256 ID of the token to query the owner of
574      * @return address currently marked as the owner of the given token ID
575      */
576     function ownerOf(uint256 tokenId) public view returns (address) {
577         address owner = _tokenOwner[tokenId];
578         require(owner != address(0), "ERC721: owner query for nonexistent token");
579 
580         return owner;
581     }
582 
583     /**
584      * @dev Approves another address to transfer the given token ID
585      * The zero address indicates there is no approved address.
586      * There can only be one approved address per token at a given time.
587      * Can only be called by the token owner or an approved operator.
588      * @param to address to be approved for the given token ID
589      * @param tokenId uint256 ID of the token to be approved
590      */
591     function approve(address to, uint256 tokenId) public {
592         address owner = ownerOf(tokenId);
593         require(to != owner, "ERC721: approval to current owner");
594 
595         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
596             "ERC721: approve caller is not owner nor approved for all"
597         );
598 
599         _tokenApprovals[tokenId] = to;
600         emit Approval(owner, to, tokenId);
601     }
602 
603     /**
604      * @dev Gets the approved address for a token ID, or zero if no address set
605      * Reverts if the token ID does not exist.
606      * @param tokenId uint256 ID of the token to query the approval of
607      * @return address currently approved for the given token ID
608      */
609     function getApproved(uint256 tokenId) public view returns (address) {
610         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
611 
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev Sets or unsets the approval of a given operator
617      * An operator is allowed to transfer all tokens of the sender on their behalf.
618      * @param to operator address to set the approval
619      * @param approved representing the status of the approval to be set
620      */
621     function setApprovalForAll(address to, bool approved) public {
622         require(to != msg.sender, "ERC721: approve to caller");
623 
624         _operatorApprovals[msg.sender][to] = approved;
625         emit ApprovalForAll(msg.sender, to, approved);
626     }
627 
628     /**
629      * @dev Tells whether an operator is approved by a given owner.
630      * @param owner owner address which you want to query the approval of
631      * @param operator operator address which you want to query the approval of
632      * @return bool whether the given operator is approved by the given owner
633      */
634     function isApprovedForAll(address owner, address operator) public view returns (bool) {
635         return _operatorApprovals[owner][operator];
636     }
637 
638     /**
639      * @dev Transfers the ownership of a given token ID to another address.
640      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
641      * Requires the msg.sender to be the owner, approved, or operator.
642      * @param from current owner of the token
643      * @param to address to receive the ownership of the given token ID
644      * @param tokenId uint256 ID of the token to be transferred
645      */
646     function transferFrom(address from, address to, uint256 tokenId) public {
647         //solhint-disable-next-line max-line-length
648         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
649 
650         _transferFrom(from, to, tokenId);
651     }
652 
653     /**
654      * @dev Safely transfers the ownership of a given token ID to another address
655      * If the target address is a contract, it must implement `onERC721Received`,
656      * which is called upon a safe transfer, and return the magic value
657      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
658      * the transfer is reverted.
659      * Requires the msg.sender to be the owner, approved, or operator
660      * @param from current owner of the token
661      * @param to address to receive the ownership of the given token ID
662      * @param tokenId uint256 ID of the token to be transferred
663      */
664     function safeTransferFrom(address from, address to, uint256 tokenId) public {
665         safeTransferFrom(from, to, tokenId, "");
666     }
667 
668     /**
669      * @dev Safely transfers the ownership of a given token ID to another address
670      * If the target address is a contract, it must implement `onERC721Received`,
671      * which is called upon a safe transfer, and return the magic value
672      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
673      * the transfer is reverted.
674      * Requires the msg.sender to be the owner, approved, or operator
675      * @param from current owner of the token
676      * @param to address to receive the ownership of the given token ID
677      * @param tokenId uint256 ID of the token to be transferred
678      * @param _data bytes data to send along with a safe transfer check
679      */
680     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
681         transferFrom(from, to, tokenId);
682         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
683     }
684 
685     /**
686      * @dev Returns whether the specified token exists.
687      * @param tokenId uint256 ID of the token to query the existence of
688      * @return bool whether the token exists
689      */
690     function _exists(uint256 tokenId) internal view returns (bool) {
691         address owner = _tokenOwner[tokenId];
692         return owner != address(0);
693     }
694 
695     /**
696      * @dev Returns whether the given spender can transfer a given token ID.
697      * @param spender address of the spender to query
698      * @param tokenId uint256 ID of the token to be transferred
699      * @return bool whether the msg.sender is approved for the given token ID,
700      * is an operator of the owner, or is the owner of the token
701      */
702     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
703         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
704         address owner = ownerOf(tokenId);
705         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
706     }
707 
708     /**
709      * @dev Internal function to mint a new token.
710      * Reverts if the given token ID already exists.
711      * @param to The address that will own the minted token
712      * @param tokenId uint256 ID of the token to be minted
713      */
714     function _mint(address to, uint256 tokenId) internal {
715         require(to != address(0), "ERC721: mint to the zero address");
716         require(!_exists(tokenId), "ERC721: token already minted");
717 
718         _tokenOwner[tokenId] = to;
719         _ownedTokensCount[to].increment();
720 
721         emit Transfer(address(0), to, tokenId);
722     }
723 
724     /**
725      * @dev Internal function to burn a specific token.
726      * Reverts if the token does not exist.
727      * Deprecated, use _burn(uint256) instead.
728      * @param owner owner of the token to burn
729      * @param tokenId uint256 ID of the token being burned
730      */
731     function _burn(address owner, uint256 tokenId) internal {
732         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
733 
734         _clearApproval(tokenId);
735 
736         _ownedTokensCount[owner].decrement();
737         _tokenOwner[tokenId] = address(0);
738 
739         emit Transfer(owner, address(0), tokenId);
740     }
741 
742     /**
743      * @dev Internal function to burn a specific token.
744      * Reverts if the token does not exist.
745      * @param tokenId uint256 ID of the token being burned
746      */
747     function _burn(uint256 tokenId) internal {
748         _burn(ownerOf(tokenId), tokenId);
749     }
750 
751     /**
752      * @dev Internal function to transfer ownership of a given token ID to another address.
753      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
754      * @param from current owner of the token
755      * @param to address to receive the ownership of the given token ID
756      * @param tokenId uint256 ID of the token to be transferred
757      */
758     function _transferFrom(address from, address to, uint256 tokenId) internal {
759         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
760         require(to != address(0), "ERC721: transfer to the zero address");
761 
762         _clearApproval(tokenId);
763 
764         _ownedTokensCount[from].decrement();
765         _ownedTokensCount[to].increment();
766 
767         _tokenOwner[tokenId] = to;
768 
769         emit Transfer(from, to, tokenId);
770     }
771 
772     /**
773      * @dev Internal function to invoke `onERC721Received` on a target address.
774      * The call is not executed if the target address is not a contract.
775      *
776      * This function is deprecated.
777      * @param from address representing the previous owner of the given token ID
778      * @param to target address that will receive the tokens
779      * @param tokenId uint256 ID of the token to be transferred
780      * @param _data bytes optional data to send along with the call
781      * @return bool whether the call correctly returned the expected magic value
782      */
783     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
784         internal returns (bool)
785     {
786         if (!to.isContract()) {
787             return true;
788         }
789 
790         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
791         return (retval == _ERC721_RECEIVED);
792     }
793 
794     /**
795      * @dev Private function to clear current approval of a given token ID.
796      * @param tokenId uint256 ID of the token to be transferred
797      */
798     function _clearApproval(uint256 tokenId) private {
799         if (_tokenApprovals[tokenId] != address(0)) {
800             _tokenApprovals[tokenId] = address(0);
801         }
802     }
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
806 
807 pragma solidity ^0.5.0;
808 
809 
810 /**
811  * @title ERC721 Burnable Token
812  * @dev ERC721 Token that can be irreversibly burned (destroyed).
813  */
814 contract ERC721Burnable is ERC721 {
815     /**
816      * @dev Burns a specific ERC721 token.
817      * @param tokenId uint256 id of the ERC721 token to be burned.
818      */
819     function burn(uint256 tokenId) public {
820         //solhint-disable-next-line max-line-length
821         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
822         _burn(tokenId);
823     }
824 }
825 
826 // File: @openzeppelin/contracts/access/Roles.sol
827 
828 pragma solidity ^0.5.0;
829 
830 /**
831  * @title Roles
832  * @dev Library for managing addresses assigned to a Role.
833  */
834 library Roles {
835     struct Role {
836         mapping (address => bool) bearer;
837     }
838 
839     /**
840      * @dev Give an account access to this role.
841      */
842     function add(Role storage role, address account) internal {
843         require(!has(role, account), "Roles: account already has role");
844         role.bearer[account] = true;
845     }
846 
847     /**
848      * @dev Remove an account's access to this role.
849      */
850     function remove(Role storage role, address account) internal {
851         require(has(role, account), "Roles: account does not have role");
852         role.bearer[account] = false;
853     }
854 
855     /**
856      * @dev Check if an account has this role.
857      * @return bool
858      */
859     function has(Role storage role, address account) internal view returns (bool) {
860         require(account != address(0), "Roles: account is the zero address");
861         return role.bearer[account];
862     }
863 }
864 
865 // File: contracts/util/ControllerRole.sol
866 
867 pragma solidity 0.5.12;
868 
869 
870 // solium-disable error-reason
871 
872 /**
873  * @title ControllerRole
874  * @dev An Controller role defined using the Open Zeppelin Role system.
875  */
876 contract ControllerRole {
877 
878     using Roles for Roles.Role;
879 
880     // NOTE: Commented out standard Role events to save gas.
881     // event ControllerAdded(address indexed account);
882     // event ControllerRemoved(address indexed account);
883 
884     Roles.Role private _controllers;
885 
886     constructor () public {
887         _addController(msg.sender);
888     }
889 
890     modifier onlyController() {
891         require(isController(msg.sender));
892         _;
893     }
894 
895     function isController(address account) public view returns (bool) {
896         return _controllers.has(account);
897     }
898 
899     function addController(address account) public onlyController {
900         _addController(account);
901     }
902 
903     function renounceController() public {
904         _removeController(msg.sender);
905     }
906 
907     function _addController(address account) internal {
908         _controllers.add(account);
909         // emit ControllerAdded(account);
910     }
911 
912     function _removeController(address account) internal {
913         _controllers.remove(account);
914         // emit ControllerRemoved(account);
915     }
916 
917 }
918 
919 // File: contracts/Registry.sol
920 
921 pragma solidity 0.5.12;
922 
923 
924 
925 
926 // solium-disable no-empty-blocks,error-reason
927 
928 /**
929  * @title Registry
930  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
931  * additional functions so other trusted contracts to interact with the tokens.
932  */
933 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
934 
935     // Optional mapping for token URIs
936     mapping(uint256 => string) internal _tokenURIs;
937 
938     string internal _prefix;
939 
940     // Mapping from token ID to resolver address
941     mapping (uint256 => address) internal _tokenResolvers;
942 
943     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
944     uint256 private constant _CRYPTO_HASH =
945         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
946 
947     modifier onlyApprovedOrOwner(uint256 tokenId) {
948         require(_isApprovedOrOwner(msg.sender, tokenId));
949         _;
950     }
951 
952     constructor () public {
953         _mint(address(0xdead), _CRYPTO_HASH);
954         // register the supported interfaces to conform to ERC721 via ERC165
955         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
956         _tokenURIs[root()] = "crypto";
957         emit NewURI(root(), "crypto");
958     }
959 
960     /// ERC721 Metadata extension
961 
962     function name() external view returns (string memory) {
963         return ".crypto";
964     }
965 
966     function symbol() external view returns (string memory) {
967         return "UD";
968     }
969 
970     function tokenURI(uint256 tokenId) external view returns (string memory) {
971         require(_exists(tokenId));
972         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
973     }
974 
975     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
976         _prefix = prefix;
977         emit NewURIPrefix(prefix);
978     }
979 
980     /// Ownership
981 
982     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
983         return _isApprovedOrOwner(spender, tokenId);
984     }
985 
986     /// Registry Constants
987 
988     function root() public pure returns (uint256) {
989         return _CRYPTO_HASH;
990     }
991 
992     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
993         return _childId(tokenId, label);
994     }
995 
996     /// Minting
997 
998     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
999         _mintChild(to, tokenId, label);
1000     }
1001 
1002     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
1003         _mintChild(to, tokenId, label);
1004     }
1005 
1006     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1007         _safeMintChild(to, tokenId, label, "");
1008     }
1009 
1010     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1011         external
1012         onlyApprovedOrOwner(tokenId)
1013     {
1014         _safeMintChild(to, tokenId, label, _data);
1015     }
1016 
1017     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
1018         external
1019         onlyController
1020     {
1021         _safeMintChild(to, tokenId, label, _data);
1022     }
1023 
1024     /// Transfering
1025 
1026     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
1027         super._transferFrom(ownerOf(tokenId), to, tokenId);
1028     }
1029 
1030     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
1031         external
1032         onlyApprovedOrOwner(tokenId)
1033     {
1034         _transferFrom(from, to, _childId(tokenId, label));
1035     }
1036 
1037     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
1038         _transferFrom(from, to, tokenId);
1039     }
1040 
1041     function safeTransferFromChild(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         string memory label,
1046         bytes memory _data
1047     ) public onlyApprovedOrOwner(tokenId) {
1048         uint256 childId = _childId(tokenId, label);
1049         _transferFrom(from, to, childId);
1050         require(_checkOnERC721Received(from, to, childId, _data));
1051     }
1052 
1053     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
1054         safeTransferFromChild(from, to, tokenId, label, "");
1055     }
1056 
1057     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
1058         external
1059         onlyController
1060     {
1061         _transferFrom(from, to, tokenId);
1062         require(_checkOnERC721Received(from, to, tokenId, _data));
1063     }
1064 
1065     /// Burning
1066 
1067     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
1068         _burn(_childId(tokenId, label));
1069     }
1070 
1071     function controlledBurn(uint256 tokenId) external onlyController {
1072         _burn(tokenId);
1073     }
1074 
1075     /// Resolution
1076 
1077     function resolverOf(uint256 tokenId) external view returns (address) {
1078         address resolver = _tokenResolvers[tokenId];
1079         require(resolver != address(0));
1080         return resolver;
1081     }
1082 
1083     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1084         _resolveTo(to, tokenId);
1085     }
1086 
1087     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1088         _resolveTo(to, tokenId);
1089     }
1090 
1091     function sync(uint256 tokenId, uint256 updateId) external {
1092         require(_tokenResolvers[tokenId] == msg.sender);
1093         emit Sync(msg.sender, updateId, tokenId);
1094     }
1095 
1096     /// Internal
1097 
1098     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1099         require(bytes(label).length != 0);
1100         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1101     }
1102 
1103     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1104         uint256 childId = _childId(tokenId, label);
1105         _mint(to, childId);
1106 
1107         require(bytes(label).length != 0);
1108         require(_exists(childId));
1109 
1110         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1111 
1112         _tokenURIs[childId] = string(domain);
1113         emit NewURI(childId, string(domain));
1114     }
1115 
1116     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1117         _mintChild(to, tokenId, label);
1118         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1119     }
1120 
1121     function _transferFrom(address from, address to, uint256 tokenId) internal {
1122         super._transferFrom(from, to, tokenId);
1123         // Clear resolver (if any)
1124         if (_tokenResolvers[tokenId] != address(0x0)) {
1125             delete _tokenResolvers[tokenId];
1126         }
1127     }
1128 
1129     function _burn(uint256 tokenId) internal {
1130         super._burn(tokenId);
1131         // Clear resolver (if any)
1132         if (_tokenResolvers[tokenId] != address(0x0)) {
1133             delete _tokenResolvers[tokenId];
1134         }
1135         // Clear metadata (if any)
1136         if (bytes(_tokenURIs[tokenId]).length != 0) {
1137             delete _tokenURIs[tokenId];
1138         }
1139     }
1140 
1141     function _resolveTo(address to, uint256 tokenId) internal {
1142         require(_exists(tokenId));
1143         emit Resolve(tokenId, to);
1144         _tokenResolvers[tokenId] = to;
1145     }
1146 
1147 }