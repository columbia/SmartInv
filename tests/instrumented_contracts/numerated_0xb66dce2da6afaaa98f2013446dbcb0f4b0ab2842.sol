1 pragma solidity 0.5.12;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others (`ERC165Checker`).
9  *
10  * For an implementation, see `ERC165`.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25  * @dev Required interface of an ERC721 compliant contract.
26  */
27 contract IERC721 is IERC165 {
28     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
29     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
30     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
31 
32     /**
33      * @dev Returns the number of NFTs in `owner`'s account.
34      */
35     function balanceOf(address owner) public view returns (uint256 balance);
36 
37     /**
38      * @dev Returns the owner of the NFT specified by `tokenId`.
39      */
40     function ownerOf(uint256 tokenId) public view returns (address owner);
41 
42     /**
43      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
44      * another (`to`).
45      *
46      * 
47      *
48      * Requirements:
49      * - `from`, `to` cannot be zero.
50      * - `tokenId` must be owned by `from`.
51      * - If the caller is not `from`, it must be have been allowed to move this
52      * NFT by either `approve` or `setApproveForAll`.
53      */
54     function safeTransferFrom(address from, address to, uint256 tokenId) public;
55     /**
56      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
57      * another (`to`).
58      *
59      * Requirements:
60      * - If the caller is not `from`, it must be approved to move this NFT by
61      * either `approve` or `setApproveForAll`.
62      */
63     function transferFrom(address from, address to, uint256 tokenId) public;
64     function approve(address to, uint256 tokenId) public;
65     function getApproved(uint256 tokenId) public view returns (address operator);
66 
67     function setApprovalForAll(address operator, bool _approved) public;
68     function isApprovedForAll(address owner, address operator) public view returns (bool);
69 
70 
71     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
72 }
73 
74 /**
75  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
76  * @dev See https://eips.ethereum.org/EIPS/eip-721
77  */
78 contract IERC721Metadata is IERC721 {
79     function name() external view returns (string memory);
80     function symbol() external view returns (string memory);
81     function tokenURI(uint256 tokenId) external view returns (string memory);
82 }
83 
84 contract IRegistry is IERC721Metadata {
85 
86     event NewURI(uint256 indexed tokenId, string uri);
87 
88     event NewURIPrefix(string prefix);
89 
90     event Resolve(uint256 indexed tokenId, address indexed to);
91 
92     event Sync(address indexed resolver, uint256 indexed updateId, uint256 indexed tokenId);
93 
94     /**
95      * @dev Controlled function to set the token URI Prefix for all tokens.
96      * @param prefix string URI to assign
97      */
98     function controlledSetTokenURIPrefix(string calldata prefix) external;
99 
100     /**
101      * @dev Returns whether the given spender can transfer a given token ID.
102      * @param spender address of the spender to query
103      * @param tokenId uint256 ID of the token to be transferred
104      * @return bool whether the msg.sender is approved for the given token ID,
105      * is an operator of the owner, or is the owner of the token
106      */
107     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
108 
109     /**
110      * @dev Mints a new a child token.
111      * Calculates child token ID using a namehash function.
112      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
113      * Requires the token not exist.
114      * @param to address to receive the ownership of the given token ID
115      * @param tokenId uint256 ID of the parent token
116      * @param label subdomain label of the child token ID
117      */
118     function mintChild(address to, uint256 tokenId, string calldata label) external;
119 
120     /**
121      * @dev Controlled function to mint a given token ID.
122      * Requires the msg.sender to be controller.
123      * Requires the token ID to not exist.
124      * @param to address the given token ID will be minted to
125      * @param label string that is a subdomain
126      * @param tokenId uint256 ID of the parent token
127      */
128     function controlledMintChild(address to, uint256 tokenId, string calldata label) external;
129 
130     /**
131      * @dev Transfers the ownership of a child token ID to another address.
132      * Calculates child token ID using a namehash function.
133      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
134      * Requires the token already exist.
135      * @param from current owner of the token
136      * @param to address to receive the ownership of the given token ID
137      * @param tokenId uint256 ID of the token to be transferred
138      * @param label subdomain label of the child token ID
139      */
140     function transferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
141 
142     /**
143      * @dev Controlled function to transfers the ownership of a token ID to
144      * another address.
145      * Requires the msg.sender to be controller.
146      * Requires the token already exist.
147      * @param from current owner of the token
148      * @param to address to receive the ownership of the given token ID
149      * @param tokenId uint256 ID of the token to be transferred
150      */
151     function controlledTransferFrom(address from, address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Safely transfers the ownership of a child token ID to another address.
155      * Calculates child token ID using a namehash function.
156      * Implements a ERC721Reciever check unlike transferFromChild.
157      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
158      * Requires the token already exist.
159      * @param from current owner of the token
160      * @param to address to receive the ownership of the given token ID
161      * @param tokenId uint256 parent ID of the token to be transferred
162      * @param label subdomain label of the child token ID
163      * @param _data bytes data to send along with a safe transfer check
164      */
165     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label, bytes calldata _data) external;
166 
167     /// Shorthand for calling the above ^^^ safeTransferFromChild function with an empty _data parameter. Similar to ERC721.safeTransferFrom.
168     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external;
169 
170     /**
171      * @dev Controlled frunction to safely transfers the ownership of a token ID
172      * to another address.
173      * Implements a ERC721Reciever check unlike controlledSafeTransferFrom.
174      * Requires the msg.sender to be controller.
175      * Requires the token already exist.
176      * @param from current owner of the token
177      * @param to address to receive the ownership of the given token ID
178      * @param tokenId uint256 parent ID of the token to be transferred
179      * @param _data bytes data to send along with a safe transfer check
180      */
181     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data) external;
182 
183     /**
184      * @dev Burns a child token ID.
185      * Calculates child token ID using a namehash function.
186      * Requires the msg.sender to be the owner, approved, or operator of tokenId.
187      * Requires the token already exist.
188      * @param tokenId uint256 ID of the token to be transferred
189      * @param label subdomain label of the child token ID
190      */
191     function burnChild(uint256 tokenId, string calldata label) external;
192 
193     /**
194      * @dev Controlled function to burn a given token ID.
195      * Requires the msg.sender to be controller.
196      * Requires the token already exist.
197      * @param tokenId uint256 ID of the token to be burned
198      */
199     function controlledBurn(uint256 tokenId) external;
200 
201     /**
202      * @dev Sets the resolver of a given token ID to another address.
203      * Requires the msg.sender to be the owner, approved, or operator.
204      * @param to address the given token ID will resolve to
205      * @param tokenId uint256 ID of the token to be transferred
206      */
207     function resolveTo(address to, uint256 tokenId) external;
208 
209     /**
210      * @dev Gets the resolver of the specified token ID.
211      * @param tokenId uint256 ID of the token to query the resolver of
212      * @return address currently marked as the resolver of the given token ID
213      */
214     function resolverOf(uint256 tokenId) external view returns (address);
215 
216     /**
217      * @dev Controlled function to sets the resolver of a given token ID.
218      * Requires the msg.sender to be controller.
219      * @param to address the given token ID will resolve to
220      * @param tokenId uint256 ID of the token to be transferred
221      */
222     function controlledResolveTo(address to, uint256 tokenId) external;
223 
224 }
225 
226 /**
227  * @title ERC721 token receiver interface
228  * @dev Interface for any contract that wants to support safeTransfers
229  * from ERC721 asset contracts.
230  */
231 contract IERC721Receiver {
232     /**
233      * @notice Handle the receipt of an NFT
234      * @dev The ERC721 smart contract calls this function on the recipient
235      * after a `safeTransfer`. This function MUST return the function selector,
236      * otherwise the caller will revert the transaction. The selector to be
237      * returned can be obtained as `this.onERC721Received.selector`. This
238      * function MAY throw to revert and reject the transfer.
239      * Note: the ERC721 contract address is always the message sender.
240      * @param operator The address which called `safeTransferFrom` function
241      * @param from The address which previously owned the token
242      * @param tokenId The NFT identifier which is being transferred
243      * @param data Additional data with no specified format
244      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
245      */
246     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
247     public returns (bytes4);
248 }
249 
250 /**
251  * @dev Wrappers over Solidity's arithmetic operations with added overflow
252  * checks.
253  *
254  * Arithmetic operations in Solidity wrap on overflow. This can easily result
255  * in bugs, because programmers usually assume that an overflow raises an
256  * error, which is the standard behavior in high level programming languages.
257  * `SafeMath` restores this intuition by reverting the transaction when an
258  * operation overflows.
259  *
260  * Using this library instead of the unchecked operations eliminates an entire
261  * class of bugs, so it's recommended to use it always.
262  */
263 library SafeMath {
264     /**
265      * @dev Returns the addition of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `+` operator.
269      *
270      * Requirements:
271      * - Addition cannot overflow.
272      */
273     function add(uint256 a, uint256 b) internal pure returns (uint256) {
274         uint256 c = a + b;
275         require(c >= a, "SafeMath: addition overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      * - Subtraction cannot overflow.
288      */
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         require(b <= a, "SafeMath: subtraction overflow");
291         uint256 c = a - b;
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the multiplication of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      * - Multiplication cannot overflow.
304      */
305     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
307         // benefit is lost if 'b' is also tested.
308         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
309         if (a == 0) {
310             return 0;
311         }
312 
313         uint256 c = a * b;
314         require(c / a == b, "SafeMath: multiplication overflow");
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers. Reverts on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      * - The divisor cannot be zero.
329      */
330     function div(uint256 a, uint256 b) internal pure returns (uint256) {
331         // Solidity only automatically asserts when dividing by 0
332         require(b > 0, "SafeMath: division by zero");
333         uint256 c = a / b;
334         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      * - The divisor cannot be zero.
349      */
350     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
351         require(b != 0, "SafeMath: modulo by zero");
352         return a % b;
353     }
354 }
355 
356 /**
357  * @dev Collection of functions related to the address type,
358  */
359 library Address {
360     /**
361      * @dev Returns true if `account` is a contract.
362      *
363      * This test is non-exhaustive, and there may be false-negatives: during the
364      * execution of a contract's constructor, its address will be reported as
365      * not containing a contract.
366      *
367      * > It is unsafe to assume that an address for which this function returns
368      * false is an externally-owned account (EOA) and not a contract.
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies in extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { size := extcodesize(account) }
378         return size > 0;
379     }
380 }
381 
382 /**
383  * @title Counters
384  * @author Matt Condon (@shrugs)
385  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
386  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
387  *
388  * Include with `using Counters for Counters.Counter;`
389  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
390  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
391  * directly accessed.
392  */
393 library Counters {
394     using SafeMath for uint256;
395 
396     struct Counter {
397         // This variable should never be directly accessed by users of the library: interactions must be restricted to
398         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
399         // this feature: see https://github.com/ethereum/solidity/issues/4637
400         uint256 _value; // default: 0
401     }
402 
403     function current(Counter storage counter) internal view returns (uint256) {
404         return counter._value;
405     }
406 
407     function increment(Counter storage counter) internal {
408         counter._value += 1;
409     }
410 
411     function decrement(Counter storage counter) internal {
412         counter._value = counter._value.sub(1);
413     }
414 }
415 
416 /**
417  * @dev Implementation of the `IERC165` interface.
418  *
419  * Contracts may inherit from this and call `_registerInterface` to declare
420  * their support of an interface.
421  */
422 contract ERC165 is IERC165 {
423     /*
424      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
425      */
426     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
427 
428     /**
429      * @dev Mapping of interface ids to whether or not it's supported.
430      */
431     mapping(bytes4 => bool) private _supportedInterfaces;
432 
433     constructor () internal {
434         // Derived contracts need only register support for their own interfaces,
435         // we register support for ERC165 itself here
436         _registerInterface(_INTERFACE_ID_ERC165);
437     }
438 
439     /**
440      * @dev See `IERC165.supportsInterface`.
441      *
442      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
445         return _supportedInterfaces[interfaceId];
446     }
447 
448     /**
449      * @dev Registers the contract as an implementer of the interface defined by
450      * `interfaceId`. Support of the actual ERC165 interface is automatic and
451      * registering its interface id is not required.
452      *
453      * See `IERC165.supportsInterface`.
454      *
455      * Requirements:
456      *
457      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
458      */
459     function _registerInterface(bytes4 interfaceId) internal {
460         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
461         _supportedInterfaces[interfaceId] = true;
462     }
463 }
464 
465 /**
466  * @title ERC721 Non-Fungible Token Standard basic implementation
467  * @dev see https://eips.ethereum.org/EIPS/eip-721
468  */
469 contract ERC721 is ERC165, IERC721 {
470     using SafeMath for uint256;
471     using Address for address;
472     using Counters for Counters.Counter;
473 
474     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
475     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
476     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
477 
478     // Mapping from token ID to owner
479     mapping (uint256 => address) private _tokenOwner;
480 
481     // Mapping from token ID to approved address
482     mapping (uint256 => address) private _tokenApprovals;
483 
484     // Mapping from owner to number of owned token
485     mapping (address => Counters.Counter) private _ownedTokensCount;
486 
487     // Mapping from owner to operator approvals
488     mapping (address => mapping (address => bool)) private _operatorApprovals;
489 
490     /*
491      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
492      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
493      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
494      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
495      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
496      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
497      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
498      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
499      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
500      *
501      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
502      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
503      */
504     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
505 
506     constructor () public {
507         // register the supported interfaces to conform to ERC721 via ERC165
508         _registerInterface(_INTERFACE_ID_ERC721);
509     }
510 
511     /**
512      * @dev Gets the balance of the specified address.
513      * @param owner address to query the balance of
514      * @return uint256 representing the amount owned by the passed address
515      */
516     function balanceOf(address owner) public view returns (uint256) {
517         require(owner != address(0), "ERC721: balance query for the zero address");
518 
519         return _ownedTokensCount[owner].current();
520     }
521 
522     /**
523      * @dev Gets the owner of the specified token ID.
524      * @param tokenId uint256 ID of the token to query the owner of
525      * @return address currently marked as the owner of the given token ID
526      */
527     function ownerOf(uint256 tokenId) public view returns (address) {
528         address owner = _tokenOwner[tokenId];
529         require(owner != address(0), "ERC721: owner query for nonexistent token");
530 
531         return owner;
532     }
533 
534     /**
535      * @dev Approves another address to transfer the given token ID
536      * The zero address indicates there is no approved address.
537      * There can only be one approved address per token at a given time.
538      * Can only be called by the token owner or an approved operator.
539      * @param to address to be approved for the given token ID
540      * @param tokenId uint256 ID of the token to be approved
541      */
542     function approve(address to, uint256 tokenId) public {
543         address owner = ownerOf(tokenId);
544         require(to != owner, "ERC721: approval to current owner");
545 
546         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
547             "ERC721: approve caller is not owner nor approved for all"
548         );
549 
550         _tokenApprovals[tokenId] = to;
551         emit Approval(owner, to, tokenId);
552     }
553 
554     /**
555      * @dev Gets the approved address for a token ID, or zero if no address set
556      * Reverts if the token ID does not exist.
557      * @param tokenId uint256 ID of the token to query the approval of
558      * @return address currently approved for the given token ID
559      */
560     function getApproved(uint256 tokenId) public view returns (address) {
561         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
562 
563         return _tokenApprovals[tokenId];
564     }
565 
566     /**
567      * @dev Sets or unsets the approval of a given operator
568      * An operator is allowed to transfer all tokens of the sender on their behalf.
569      * @param to operator address to set the approval
570      * @param approved representing the status of the approval to be set
571      */
572     function setApprovalForAll(address to, bool approved) public {
573         require(to != msg.sender, "ERC721: approve to caller");
574 
575         _operatorApprovals[msg.sender][to] = approved;
576         emit ApprovalForAll(msg.sender, to, approved);
577     }
578 
579     /**
580      * @dev Tells whether an operator is approved by a given owner.
581      * @param owner owner address which you want to query the approval of
582      * @param operator operator address which you want to query the approval of
583      * @return bool whether the given operator is approved by the given owner
584      */
585     function isApprovedForAll(address owner, address operator) public view returns (bool) {
586         return _operatorApprovals[owner][operator];
587     }
588 
589     /**
590      * @dev Transfers the ownership of a given token ID to another address.
591      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
592      * Requires the msg.sender to be the owner, approved, or operator.
593      * @param from current owner of the token
594      * @param to address to receive the ownership of the given token ID
595      * @param tokenId uint256 ID of the token to be transferred
596      */
597     function transferFrom(address from, address to, uint256 tokenId) public {
598         //solhint-disable-next-line max-line-length
599         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
600 
601         _transferFrom(from, to, tokenId);
602     }
603 
604     /**
605      * @dev Safely transfers the ownership of a given token ID to another address
606      * If the target address is a contract, it must implement `onERC721Received`,
607      * which is called upon a safe transfer, and return the magic value
608      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
609      * the transfer is reverted.
610      * Requires the msg.sender to be the owner, approved, or operator
611      * @param from current owner of the token
612      * @param to address to receive the ownership of the given token ID
613      * @param tokenId uint256 ID of the token to be transferred
614      */
615     function safeTransferFrom(address from, address to, uint256 tokenId) public {
616         safeTransferFrom(from, to, tokenId, "");
617     }
618 
619     /**
620      * @dev Safely transfers the ownership of a given token ID to another address
621      * If the target address is a contract, it must implement `onERC721Received`,
622      * which is called upon a safe transfer, and return the magic value
623      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
624      * the transfer is reverted.
625      * Requires the msg.sender to be the owner, approved, or operator
626      * @param from current owner of the token
627      * @param to address to receive the ownership of the given token ID
628      * @param tokenId uint256 ID of the token to be transferred
629      * @param _data bytes data to send along with a safe transfer check
630      */
631     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
632         transferFrom(from, to, tokenId);
633         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
634     }
635 
636     /**
637      * @dev Returns whether the specified token exists.
638      * @param tokenId uint256 ID of the token to query the existence of
639      * @return bool whether the token exists
640      */
641     function _exists(uint256 tokenId) internal view returns (bool) {
642         address owner = _tokenOwner[tokenId];
643         return owner != address(0);
644     }
645 
646     /**
647      * @dev Returns whether the given spender can transfer a given token ID.
648      * @param spender address of the spender to query
649      * @param tokenId uint256 ID of the token to be transferred
650      * @return bool whether the msg.sender is approved for the given token ID,
651      * is an operator of the owner, or is the owner of the token
652      */
653     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
654         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
655         address owner = ownerOf(tokenId);
656         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
657     }
658 
659     /**
660      * @dev Internal function to mint a new token.
661      * Reverts if the given token ID already exists.
662      * @param to The address that will own the minted token
663      * @param tokenId uint256 ID of the token to be minted
664      */
665     function _mint(address to, uint256 tokenId) internal {
666         require(to != address(0), "ERC721: mint to the zero address");
667         require(!_exists(tokenId), "ERC721: token already minted");
668 
669         _tokenOwner[tokenId] = to;
670         _ownedTokensCount[to].increment();
671 
672         emit Transfer(address(0), to, tokenId);
673     }
674 
675     /**
676      * @dev Internal function to burn a specific token.
677      * Reverts if the token does not exist.
678      * Deprecated, use _burn(uint256) instead.
679      * @param owner owner of the token to burn
680      * @param tokenId uint256 ID of the token being burned
681      */
682     function _burn(address owner, uint256 tokenId) internal {
683         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
684 
685         _clearApproval(tokenId);
686 
687         _ownedTokensCount[owner].decrement();
688         _tokenOwner[tokenId] = address(0);
689 
690         emit Transfer(owner, address(0), tokenId);
691     }
692 
693     /**
694      * @dev Internal function to burn a specific token.
695      * Reverts if the token does not exist.
696      * @param tokenId uint256 ID of the token being burned
697      */
698     function _burn(uint256 tokenId) internal {
699         _burn(ownerOf(tokenId), tokenId);
700     }
701 
702     /**
703      * @dev Internal function to transfer ownership of a given token ID to another address.
704      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
705      * @param from current owner of the token
706      * @param to address to receive the ownership of the given token ID
707      * @param tokenId uint256 ID of the token to be transferred
708      */
709     function _transferFrom(address from, address to, uint256 tokenId) internal {
710         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
711         require(to != address(0), "ERC721: transfer to the zero address");
712 
713         _clearApproval(tokenId);
714 
715         _ownedTokensCount[from].decrement();
716         _ownedTokensCount[to].increment();
717 
718         _tokenOwner[tokenId] = to;
719 
720         emit Transfer(from, to, tokenId);
721     }
722 
723     /**
724      * @dev Internal function to invoke `onERC721Received` on a target address.
725      * The call is not executed if the target address is not a contract.
726      *
727      * This function is deprecated.
728      * @param from address representing the previous owner of the given token ID
729      * @param to target address that will receive the tokens
730      * @param tokenId uint256 ID of the token to be transferred
731      * @param _data bytes optional data to send along with the call
732      * @return bool whether the call correctly returned the expected magic value
733      */
734     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
735         internal returns (bool)
736     {
737         if (!to.isContract()) {
738             return true;
739         }
740 
741         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
742         return (retval == _ERC721_RECEIVED);
743     }
744 
745     /**
746      * @dev Private function to clear current approval of a given token ID.
747      * @param tokenId uint256 ID of the token to be transferred
748      */
749     function _clearApproval(uint256 tokenId) private {
750         if (_tokenApprovals[tokenId] != address(0)) {
751             _tokenApprovals[tokenId] = address(0);
752         }
753     }
754 }
755 
756 /**
757  * @title ERC721 Burnable Token
758  * @dev ERC721 Token that can be irreversibly burned (destroyed).
759  */
760 contract ERC721Burnable is ERC721 {
761     /**
762      * @dev Burns a specific ERC721 token.
763      * @param tokenId uint256 id of the ERC721 token to be burned.
764      */
765     function burn(uint256 tokenId) public {
766         //solhint-disable-next-line max-line-length
767         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
768         _burn(tokenId);
769     }
770 }
771 
772 /**
773  * @title Roles
774  * @dev Library for managing addresses assigned to a Role.
775  */
776 library Roles {
777     struct Role {
778         mapping (address => bool) bearer;
779     }
780 
781     /**
782      * @dev Give an account access to this role.
783      */
784     function add(Role storage role, address account) internal {
785         require(!has(role, account), "Roles: account already has role");
786         role.bearer[account] = true;
787     }
788 
789     /**
790      * @dev Remove an account's access to this role.
791      */
792     function remove(Role storage role, address account) internal {
793         require(has(role, account), "Roles: account does not have role");
794         role.bearer[account] = false;
795     }
796 
797     /**
798      * @dev Check if an account has this role.
799      * @return bool
800      */
801     function has(Role storage role, address account) internal view returns (bool) {
802         require(account != address(0), "Roles: account is the zero address");
803         return role.bearer[account];
804     }
805 }
806 
807 // solium-disable error-reason
808 
809 /**
810  * @title ControllerRole
811  * @dev An Controller role defined using the Open Zeppelin Role system.
812  */
813 contract ControllerRole {
814 
815     using Roles for Roles.Role;
816 
817     // NOTE: Commented out standard Role events to save gas.
818     // event ControllerAdded(address indexed account);
819     // event ControllerRemoved(address indexed account);
820 
821     Roles.Role private _controllers;
822 
823     constructor () public {
824         _addController(msg.sender);
825     }
826 
827     modifier onlyController() {
828         require(isController(msg.sender));
829         _;
830     }
831 
832     function isController(address account) public view returns (bool) {
833         return _controllers.has(account);
834     }
835 
836     function addController(address account) public onlyController {
837         _addController(account);
838     }
839 
840     function renounceController() public {
841         _removeController(msg.sender);
842     }
843 
844     function _addController(address account) internal {
845         _controllers.add(account);
846         // emit ControllerAdded(account);
847     }
848 
849     function _removeController(address account) internal {
850         _controllers.remove(account);
851         // emit ControllerRemoved(account);
852     }
853 
854 }
855 
856 // solium-disable no-empty-blocks,error-reason
857 
858 /**
859  * @title Registry
860  * @dev An ERC721 Token see https://eips.ethereum.org/EIPS/eip-721. With
861  * additional functions so other trusted contracts to interact with the tokens.
862  */
863 contract Registry is IRegistry, ControllerRole, ERC721Burnable {
864 
865     // Optional mapping for token URIs
866     mapping(uint256 => string) internal _tokenURIs;
867 
868     string internal _prefix;
869 
870     // Mapping from token ID to resolver address
871     mapping (uint256 => address) internal _tokenResolvers;
872 
873     // uint256(keccak256(abi.encodePacked(uint256(0x0), keccak256(abi.encodePacked("crypto")))))
874     uint256 private constant _CRYPTO_HASH =
875         0x0f4a10a4f46c288cea365fcf45cccf0e9d901b945b9829ccdb54c10dc3cb7a6f;
876 
877     modifier onlyApprovedOrOwner(uint256 tokenId) {
878         require(_isApprovedOrOwner(msg.sender, tokenId));
879         _;
880     }
881 
882     constructor () public {
883         _mint(address(0xdead), _CRYPTO_HASH);
884         // register the supported interfaces to conform to ERC721 via ERC165
885         _registerInterface(0x5b5e139f); // ERC721 Metadata Interface
886         _tokenURIs[root()] = "crypto";
887         emit NewURI(root(), "crypto");
888     }
889 
890     /// ERC721 Metadata extension
891 
892     function name() external view returns (string memory) {
893         return ".crypto";
894     }
895 
896     function symbol() external view returns (string memory) {
897         return "UD";
898     }
899 
900     function tokenURI(uint256 tokenId) external view returns (string memory) {
901         require(_exists(tokenId));
902         return string(abi.encodePacked(_prefix, _tokenURIs[tokenId]));
903     }
904 
905     function controlledSetTokenURIPrefix(string calldata prefix) external onlyController {
906         _prefix = prefix;
907         emit NewURIPrefix(prefix);
908     }
909 
910     /// Ownership
911 
912     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
913         return _isApprovedOrOwner(spender, tokenId);
914     }
915 
916     /// Registry Constants
917 
918     function root() public pure returns (uint256) {
919         return _CRYPTO_HASH;
920     }
921 
922     function childIdOf(uint256 tokenId, string calldata label) external pure returns (uint256) {
923         return _childId(tokenId, label);
924     }
925 
926     /// Minting
927 
928     function mintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
929         _mintChild(to, tokenId, label);
930     }
931 
932     function controlledMintChild(address to, uint256 tokenId, string calldata label) external onlyController {
933         _mintChild(to, tokenId, label);
934     }
935 
936     function safeMintChild(address to, uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
937         _safeMintChild(to, tokenId, label, "");
938     }
939 
940     function safeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
941         external
942         onlyApprovedOrOwner(tokenId)
943     {
944         _safeMintChild(to, tokenId, label, _data);
945     }
946 
947     function controlledSafeMintChild(address to, uint256 tokenId, string calldata label, bytes calldata _data)
948         external
949         onlyController
950     {
951         _safeMintChild(to, tokenId, label, _data);
952     }
953 
954     /// Transfering
955 
956     function setOwner(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId)  {
957         super._transferFrom(ownerOf(tokenId), to, tokenId);
958     }
959 
960     function transferFromChild(address from, address to, uint256 tokenId, string calldata label)
961         external
962         onlyApprovedOrOwner(tokenId)
963     {
964         _transferFrom(from, to, _childId(tokenId, label));
965     }
966 
967     function controlledTransferFrom(address from, address to, uint256 tokenId) external onlyController {
968         _transferFrom(from, to, tokenId);
969     }
970 
971     function safeTransferFromChild(
972         address from,
973         address to,
974         uint256 tokenId,
975         string memory label,
976         bytes memory _data
977     ) public onlyApprovedOrOwner(tokenId) {
978         uint256 childId = _childId(tokenId, label);
979         _transferFrom(from, to, childId);
980         require(_checkOnERC721Received(from, to, childId, _data));
981     }
982 
983     function safeTransferFromChild(address from, address to, uint256 tokenId, string calldata label) external {
984         safeTransferFromChild(from, to, tokenId, label, "");
985     }
986 
987     function controlledSafeTransferFrom(address from, address to, uint256 tokenId, bytes calldata _data)
988         external
989         onlyController
990     {
991         _transferFrom(from, to, tokenId);
992         require(_checkOnERC721Received(from, to, tokenId, _data));
993     }
994 
995     /// Burning
996 
997     function burnChild(uint256 tokenId, string calldata label) external onlyApprovedOrOwner(tokenId) {
998         _burn(_childId(tokenId, label));
999     }
1000 
1001     function controlledBurn(uint256 tokenId) external onlyController {
1002         _burn(tokenId);
1003     }
1004 
1005     /// Resolution
1006 
1007     function resolverOf(uint256 tokenId) external view returns (address) {
1008         address resolver = _tokenResolvers[tokenId];
1009         require(resolver != address(0));
1010         return resolver;
1011     }
1012 
1013     function resolveTo(address to, uint256 tokenId) external onlyApprovedOrOwner(tokenId) {
1014         _resolveTo(to, tokenId);
1015     }
1016 
1017     function controlledResolveTo(address to, uint256 tokenId) external onlyController {
1018         _resolveTo(to, tokenId);
1019     }
1020 
1021     function sync(uint256 tokenId, uint256 updateId) external {
1022         require(_tokenResolvers[tokenId] == msg.sender);
1023         emit Sync(msg.sender, updateId, tokenId);
1024     }
1025 
1026     /// Internal
1027 
1028     function _childId(uint256 tokenId, string memory label) internal pure returns (uint256) {
1029         require(bytes(label).length != 0);
1030         return uint256(keccak256(abi.encodePacked(tokenId, keccak256(abi.encodePacked(label)))));
1031     }
1032 
1033     function _mintChild(address to, uint256 tokenId, string memory label) internal {
1034         uint256 childId = _childId(tokenId, label);
1035         _mint(to, childId);
1036 
1037         require(bytes(label).length != 0);
1038         require(_exists(childId));
1039 
1040         bytes memory domain = abi.encodePacked(label, ".", _tokenURIs[tokenId]);
1041 
1042         _tokenURIs[childId] = string(domain);
1043         emit NewURI(childId, string(domain));
1044     }
1045 
1046     function _safeMintChild(address to, uint256 tokenId, string memory label, bytes memory _data) internal {
1047         _mintChild(to, tokenId, label);
1048         require(_checkOnERC721Received(address(0), to, _childId(tokenId, label), _data));
1049     }
1050 
1051     function _transferFrom(address from, address to, uint256 tokenId) internal {
1052         super._transferFrom(from, to, tokenId);
1053         // Clear resolver (if any)
1054         if (_tokenResolvers[tokenId] != address(0x0)) {
1055             delete _tokenResolvers[tokenId];
1056         }
1057     }
1058 
1059     function _burn(uint256 tokenId) internal {
1060         super._burn(tokenId);
1061         // Clear resolver (if any)
1062         if (_tokenResolvers[tokenId] != address(0x0)) {
1063             delete _tokenResolvers[tokenId];
1064         }
1065         // Clear metadata (if any)
1066         if (bytes(_tokenURIs[tokenId]).length != 0) {
1067             delete _tokenURIs[tokenId];
1068         }
1069     }
1070 
1071     function _resolveTo(address to, uint256 tokenId) internal {
1072         require(_exists(tokenId));
1073         emit Resolve(tokenId, to);
1074         _tokenResolvers[tokenId] = to;
1075     }
1076 
1077 }
1078 
1079 /**
1080  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1081  *
1082  * These functions can be used to verify that a message was signed by the holder
1083  * of the private keys of a given address.
1084  */
1085 library ECDSA {
1086     /**
1087      * @dev Returns the address that signed a hashed message (`hash`) with
1088      * `signature`. This address can then be used for verification purposes.
1089      *
1090      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1091      * this function rejects them by requiring the `s` value to be in the lower
1092      * half order, and the `v` value to be either 27 or 28.
1093      *
1094      * (.note) This call _does not revert_ if the signature is invalid, or
1095      * if the signer is otherwise unable to be retrieved. In those scenarios,
1096      * the zero address is returned.
1097      *
1098      * (.warning) `hash` _must_ be the result of a hash operation for the
1099      * verification to be secure: it is possible to craft signatures that
1100      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1101      * this is by receiving a hash of the original message (which may otherwise)
1102      * be too long), and then calling `toEthSignedMessageHash` on it.
1103      */
1104     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1105         // Check the signature length
1106         if (signature.length != 65) {
1107             return (address(0));
1108         }
1109 
1110         // Divide the signature in r, s and v variables
1111         bytes32 r;
1112         bytes32 s;
1113         uint8 v;
1114 
1115         // ecrecover takes the signature parameters, and the only way to get them
1116         // currently is to use assembly.
1117         // solhint-disable-next-line no-inline-assembly
1118         assembly {
1119             r := mload(add(signature, 0x20))
1120             s := mload(add(signature, 0x40))
1121             v := byte(0, mload(add(signature, 0x60)))
1122         }
1123 
1124         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1125         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1126         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1127         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1128         //
1129         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1130         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1131         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1132         // these malleable signatures as well.
1133         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1134             return address(0);
1135         }
1136 
1137         if (v != 27 && v != 28) {
1138             return address(0);
1139         }
1140 
1141         // If the signature is valid (and not malleable), return the signer address
1142         return ecrecover(hash, v, r, s);
1143     }
1144 
1145     /**
1146      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1147      * replicates the behavior of the
1148      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
1149      * JSON-RPC method.
1150      *
1151      * See `recover`.
1152      */
1153     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1154         // 32 is the length in bytes of hash,
1155         // enforced by the type signature above
1156         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1157     }
1158 }
1159 
1160 // solium-disable error-reason
1161 
1162 contract SignatureUtil {
1163     using ECDSA for bytes32;
1164 
1165     // Mapping from owner to a nonce
1166     mapping (uint256 => uint256) internal _nonces;
1167 
1168     Registry internal _registry;
1169 
1170     constructor(Registry registry) public {
1171         _registry = registry;
1172     }
1173 
1174     function registry() external view returns (address) {
1175         return address(_registry);
1176     }
1177 
1178     /**
1179      * @dev Gets the nonce of the specified address.
1180      * @param tokenId token ID for nonce query
1181      * @return nonce of the given address
1182      */
1183     function nonceOf(uint256 tokenId) external view returns (uint256) {
1184         return _nonces[tokenId];
1185     }
1186 
1187     function _validate(bytes32 hash, uint256 tokenId, bytes memory signature) internal {
1188         uint256 nonce = _nonces[tokenId];
1189 
1190         address signer = keccak256(abi.encodePacked(hash, address(this), nonce)).toEthSignedMessageHash().recover(signature);
1191         require(
1192             signer != address(0) &&
1193             _registry.isApprovedOrOwner(
1194                 signer,
1195                 tokenId
1196             ),
1197             "INVALID_SIGNATURE"
1198         );
1199 
1200         _nonces[tokenId] += 1;
1201     }
1202 
1203 }
1204 
1205 contract MinterRole {
1206     using Roles for Roles.Role;
1207 
1208     event MinterAdded(address indexed account);
1209     event MinterRemoved(address indexed account);
1210 
1211     Roles.Role private _minters;
1212 
1213     constructor () internal {
1214         _addMinter(msg.sender);
1215     }
1216 
1217     modifier onlyMinter() {
1218         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1219         _;
1220     }
1221 
1222     function isMinter(address account) public view returns (bool) {
1223         return _minters.has(account);
1224     }
1225 
1226     function addMinter(address account) public onlyMinter {
1227         _addMinter(account);
1228     }
1229 
1230     function renounceMinter() public {
1231         _removeMinter(msg.sender);
1232     }
1233 
1234     function _addMinter(address account) internal {
1235         _minters.add(account);
1236         emit MinterAdded(account);
1237     }
1238 
1239     function _removeMinter(address account) internal {
1240         _minters.remove(account);
1241         emit MinterRemoved(account);
1242     }
1243 }
1244 
1245 interface IMintingController {
1246 
1247     /**
1248      * @dev Minter function that mints a Second Level Domain (SLD).
1249      * @param to address to mint the new SLD to.
1250      * @param label SLD label to mint.
1251      */
1252     function mintSLD(address to, string calldata label) external;
1253 
1254     /**
1255      * @dev Minter function that safely mints a Second Level Domain (SLD).
1256      * Implements a ERC721Reciever check unlike mintSLD.
1257      * @param to address to mint the new SLD to.
1258      * @param label SLD label to mint.
1259      */
1260     function safeMintSLD(address to, string calldata label) external;
1261 
1262     /**
1263      * @dev Minter function that safely mints a Second Level Domain (SLD).
1264      * Implements a ERC721Reciever check unlike mintSLD.
1265      * @param to address to mint the new SLD to.
1266      * @param label SLD label to mint.
1267      * @param _data bytes data to send along with a safe transfer check
1268      */
1269     function safeMintSLD(address to, string calldata label, bytes calldata _data) external;
1270 
1271 }
1272 
1273 /**
1274  * @title MintingController
1275  * @dev Defines the functions for distribution of Second Level Domains (SLD)s.
1276  */
1277 contract MintingController is IMintingController, MinterRole {
1278 
1279     Registry internal _registry;
1280 
1281     constructor (Registry registry) public {
1282         _registry = registry;
1283     }
1284 
1285     function registry() external view returns (address) {
1286         return address(_registry);
1287     }
1288 
1289     function mintSLD(address to, string memory label) public onlyMinter {
1290         _registry.controlledMintChild(to, _registry.root(), label);
1291     }
1292 
1293     function safeMintSLD(address to, string calldata label) external {
1294         safeMintSLD(to, label, "");
1295     }
1296 
1297     function safeMintSLD(address to, string memory label, bytes memory _data) public onlyMinter {
1298         _registry.controlledSafeMintChild(to, _registry.root(), label, _data);
1299     }
1300 
1301     function mintSLDWithResolver(address to, string memory label, address resolver) public onlyMinter {
1302         _registry.controlledMintChild(to, _registry.root(), label);
1303         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1304     }
1305 
1306     function safeMintSLDWithResolver(address to, string calldata label, address resolver) external {
1307         safeMintSLD(to, label, "");
1308         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1309     }
1310 
1311     function safeMintSLDWithResolver(address to, string calldata label, address resolver, bytes calldata _data) external {
1312         safeMintSLD(to, label, _data);
1313         _registry.controlledResolveTo(resolver, _registry.childIdOf(_registry.root(), label));
1314     }
1315 
1316 }
1317 
1318 pragma experimental ABIEncoderV2;
1319 
1320 
1321 
1322 
1323 // solium-disable error-reason
1324 
1325 contract Resolver is SignatureUtil {
1326 
1327     event Set(uint256 indexed tokenId, string indexed keyIndex, string indexed valueIndex, string key, string value);
1328     event NewKey(uint256 indexed tokenId, string indexed keyIndex, string key);
1329     event ResetRecords(uint256 indexed tokenId);
1330 
1331     // Mapping from token ID to preset id to key to value
1332     mapping (uint256 => mapping (uint256 =>  mapping (string => string))) internal _records;
1333 
1334     // Mapping from token ID to current preset id
1335     mapping (uint256 => uint256) _tokenPresets;
1336 
1337     // All keys that were set
1338     mapping (uint256 => string) _hashedKeys;
1339 
1340     MintingController internal _mintingController;
1341 
1342     constructor(Registry registry, MintingController mintingController) public SignatureUtil(registry) {
1343         require(address(registry) == mintingController.registry());
1344         _mintingController = mintingController;
1345     }
1346 
1347     /**
1348      * @dev Throws if called when not the resolver.
1349      */
1350     modifier whenResolver(uint256 tokenId) {
1351         require(address(this) == _registry.resolverOf(tokenId), "RESOLVER_DETACHED_FROM_DOMAIN");
1352         _;
1353     }
1354 
1355     modifier whenApprovedOrOwner(uint256 tokenId) {
1356         require(_registry.isApprovedOrOwner(msg.sender, tokenId), "SENDER_IS_NOT_APPROVED_OR_OWNER");
1357         _;
1358     }
1359 
1360     function reset(uint256 tokenId) external whenApprovedOrOwner(tokenId) {
1361         _setPreset(now, tokenId);
1362     }
1363 
1364     function resetFor(uint256 tokenId, bytes calldata signature) external {
1365         _validate(keccak256(abi.encodeWithSelector(this.reset.selector, tokenId)), tokenId, signature);
1366         _setPreset(now, tokenId);
1367     }
1368 
1369     /**
1370      * @dev Function to get record.
1371      * @param key The key to query the value of.
1372      * @param tokenId The token id to fetch.
1373      * @return The value string.
1374      */
1375     function get(string memory key, uint256 tokenId) public view whenResolver(tokenId) returns (string memory) {
1376         return _records[tokenId][_tokenPresets[tokenId]][key];
1377     }
1378 
1379     /**
1380      * @dev Function to get key by provided hash. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1381      * @param keyHash The key to query the value of.
1382      * @return The key string.
1383      */
1384     function hashToKey(uint256 keyHash) public view returns (string memory) {
1385         return _hashedKeys[keyHash];
1386     }
1387 
1388     /**
1389      * @dev Function to get keys by provided key hashes. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1390      * @param hashes The key to query the value of.
1391      * @return Keys
1392      */
1393     function hashesToKeys(uint256[] memory hashes) public view returns (string[] memory) {
1394         uint256 keyCount = hashes.length;
1395         string[] memory values = new string[](keyCount);
1396         for (uint256 i = 0; i < keyCount; i++) {
1397             values[i] = hashToKey(hashes[i]);
1398         }
1399 
1400         return values;
1401     }
1402 
1403     /**
1404      * @dev Function get value by provied key hash. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1405      * @param keyHash The key to query the value of.
1406      * @param tokenId The token id to set.
1407      * @return Key and value.
1408      */
1409     function getByHash(uint256 keyHash, uint256 tokenId) public view whenResolver(tokenId) returns (string memory key, string memory value) {
1410         key = hashToKey(keyHash);
1411         value = get(key, tokenId);
1412     }
1413 
1414     /**
1415      * @dev Function get values by provied key hashes. Keys hashes can be found in Sync event emitted by Registry.sol contract.
1416      * @param keyHashes The key to query the value of.
1417      * @param tokenId The token id to set.
1418      * @return Keys and values.
1419      */
1420     function getManyByHash(
1421         uint256[] memory keyHashes,
1422         uint256 tokenId
1423     ) public view whenResolver(tokenId) returns (string[] memory keys, string[] memory values) {
1424         uint256 keyCount = keyHashes.length;
1425         keys = new string[](keyCount);
1426         values = new string[](keyCount);
1427         for (uint256 i = 0; i < keyCount; i++) {
1428             (keys[i], values[i]) = getByHash(keyHashes[i], tokenId);
1429         }
1430     }
1431 
1432     function preconfigure(
1433         string[] memory keys,
1434         string[] memory values,
1435         uint256 tokenId
1436     ) public {
1437         require(_mintingController.isMinter(msg.sender), "SENDER_IS_NOT_MINTER");
1438         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Function to set record.
1443      * @param key The key set the value of.
1444      * @param value The value to set key to.
1445      * @param tokenId The token id to set.
1446      */
1447     function set(string calldata key, string calldata value, uint256 tokenId) external whenApprovedOrOwner(tokenId) {
1448         _set(_tokenPresets[tokenId], key, value, tokenId);
1449     }
1450 
1451     /**
1452      * @dev Function to set record on behalf of an address.
1453      * @param key The key set the value of.
1454      * @param value The value to set key to.
1455      * @param tokenId The token id to set.
1456      * @param signature The signature to verify the transaction with.
1457      */
1458     function setFor(
1459         string calldata key,
1460         string calldata value,
1461         uint256 tokenId,
1462         bytes calldata signature
1463     ) external {
1464         _validate(keccak256(abi.encodeWithSelector(this.set.selector, key, value, tokenId)), tokenId, signature);
1465         _set(_tokenPresets[tokenId], key, value, tokenId);
1466     }
1467 
1468     /**
1469      * @dev Function to get multiple record.
1470      * @param keys The keys to query the value of.
1471      * @param tokenId The token id to fetch.
1472      * @return The values.
1473      */
1474     function getMany(string[] calldata keys, uint256 tokenId) external view whenResolver(tokenId) returns (string[] memory) {
1475         uint256 keyCount = keys.length;
1476         string[] memory values = new string[](keyCount);
1477         uint256 preset = _tokenPresets[tokenId];
1478         for (uint256 i = 0; i < keyCount; i++) {
1479             values[i] = _records[tokenId][preset][keys[i]];
1480         }
1481         return values;
1482     }
1483 
1484     function setMany(
1485         string[] memory keys,
1486         string[] memory values,
1487         uint256 tokenId
1488     ) public whenApprovedOrOwner(tokenId) {
1489         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1490     }
1491 
1492     /**
1493      * @dev Function to set record on behalf of an address.
1494      * @param keys The keys set the values of.
1495      * @param values The values to set keys to.
1496      * @param tokenId The token id to set.
1497      * @param signature The signature to verify the transaction with.
1498      */
1499     function setManyFor(
1500         string[] memory keys,
1501         string[] memory values,
1502         uint256 tokenId,
1503         bytes memory signature
1504     ) public {
1505         _validate(keccak256(abi.encodeWithSelector(this.setMany.selector, keys, values, tokenId)), tokenId, signature);
1506         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1507     }
1508 
1509      /**
1510      * @dev Function to reset all domain records and set new ones.
1511      * @param keys records keys.
1512      * @param values records values.
1513      * @param tokenId domain token id.
1514      */
1515     function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) public whenApprovedOrOwner(tokenId) {
1516         _reconfigure(keys, values, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Delegated version of reconfigure() function.
1521      * @param keys records keys.
1522      * @param values records values.
1523      * @param tokenId domain token id.
1524      * @param signature user signature.
1525      */
1526     function reconfigureFor(
1527         string[] memory keys,
1528         string[] memory values,
1529         uint256 tokenId,
1530         bytes memory signature
1531     ) public {
1532         _validate(keccak256(abi.encodeWithSelector(this.reconfigure.selector, keys, values, tokenId)), tokenId, signature);
1533         _reconfigure(keys, values, tokenId);
1534     }
1535 
1536     // reset records
1537     function _setPreset(uint256 presetId, uint256 tokenId) internal {
1538         _tokenPresets[tokenId] = presetId;
1539         _registry.sync(tokenId, 0); // notify registry that domain records were reset
1540         emit ResetRecords(tokenId);
1541     }
1542 
1543     /**
1544      * @dev Internal function to to set record. As opposed to set, this imposes no restrictions on msg.sender.
1545      * @param preset preset to set key/values on
1546      * @param key key of record to be set
1547      * @param value value of record to be set
1548      * @param tokenId uint256 ID of the token
1549      */
1550     function _set(uint256 preset, string memory key, string memory value, uint256 tokenId) internal {
1551         uint256 keyHash = uint256(keccak256(bytes(key)));
1552         bool isNewKey = bytes(_records[tokenId][preset][key]).length == 0;
1553         _registry.sync(tokenId, keyHash);
1554         _records[tokenId][preset][key] = value;
1555 
1556         if (bytes(_hashedKeys[keyHash]).length == 0) {
1557             _hashedKeys[keyHash] = key;
1558         }
1559 
1560         if (isNewKey) {
1561             emit NewKey(tokenId, key, key);
1562         }
1563         emit Set(tokenId, key, value, key, value);
1564     }
1565 
1566     /**
1567      * @dev Internal function to to set multiple records. As opposed to setMany, this imposes
1568      * no restrictions on msg.sender.
1569      * @param preset preset to set key/values on
1570      * @param keys keys of record to be set
1571      * @param values values of record to be set
1572      * @param tokenId uint256 ID of the token
1573      */
1574     function _setMany(uint256 preset, string[] memory keys, string[] memory values, uint256 tokenId) internal {
1575         uint256 keyCount = keys.length;
1576         for (uint256 i = 0; i < keyCount; i++) {
1577             _set(preset, keys[i], values[i], tokenId);
1578         }
1579     }
1580 
1581     /**
1582      * @dev Internal function to reset all domain records and set new ones.
1583      * @param keys records keys.
1584      * @param values records values.
1585      * @param tokenId domain token id.
1586      */
1587     function _reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) internal {
1588         _setPreset(now, tokenId);
1589         _setMany(_tokenPresets[tokenId], keys, values, tokenId);
1590     }
1591 
1592 }