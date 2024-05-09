1 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
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
26 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
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
81 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
82 
83 pragma solidity ^0.5.0;
84 
85 /**
86  * @title ERC721 token receiver interface
87  * @dev Interface for any contract that wants to support safeTransfers
88  * from ERC721 asset contracts.
89  */
90 contract IERC721Receiver {
91     /**
92      * @notice Handle the receipt of an NFT
93      * @dev The ERC721 smart contract calls this function on the recipient
94      * after a `safeTransfer`. This function MUST return the function selector,
95      * otherwise the caller will revert the transaction. The selector to be
96      * returned can be obtained as `this.onERC721Received.selector`. This
97      * function MAY throw to revert and reject the transfer.
98      * Note: the ERC721 contract address is always the message sender.
99      * @param operator The address which called `safeTransferFrom` function
100      * @param from The address which previously owned the token
101      * @param tokenId The NFT identifier which is being transferred
102      * @param data Additional data with no specified format
103      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
104      */
105     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
106     public returns (bytes4);
107 }
108 
109 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
110 
111 pragma solidity ^0.5.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a, "SafeMath: subtraction overflow");
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Solidity only automatically asserts when dividing by 0
195         require(b > 0, "SafeMath: division by zero");
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b != 0, "SafeMath: modulo by zero");
215         return a % b;
216     }
217 }
218 
219 // File: openzeppelin-solidity/contracts/utils/Address.sol
220 
221 pragma solidity ^0.5.0;
222 
223 /**
224  * @dev Collection of functions related to the address type,
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * This test is non-exhaustive, and there may be false-negatives: during the
231      * execution of a contract's constructor, its address will be reported as
232      * not containing a contract.
233      *
234      * > It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      */
237     function isContract(address account) internal view returns (bool) {
238         // This method relies in extcodesize, which returns 0 for contracts in
239         // construction, since the code is only stored at the end of the
240         // constructor execution.
241 
242         uint256 size;
243         // solhint-disable-next-line no-inline-assembly
244         assembly { size := extcodesize(account) }
245         return size > 0;
246     }
247 }
248 
249 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
250 
251 pragma solidity ^0.5.0;
252 
253 
254 /**
255  * @title Counters
256  * @author Matt Condon (@shrugs)
257  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
258  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
259  *
260  * Include with `using Counters for Counters.Counter;`
261  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
262  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
263  * directly accessed.
264  */
265 library Counters {
266     using SafeMath for uint256;
267 
268     struct Counter {
269         // This variable should never be directly accessed by users of the library: interactions must be restricted to
270         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
271         // this feature: see https://github.com/ethereum/solidity/issues/4637
272         uint256 _value; // default: 0
273     }
274 
275     function current(Counter storage counter) internal view returns (uint256) {
276         return counter._value;
277     }
278 
279     function increment(Counter storage counter) internal {
280         counter._value += 1;
281     }
282 
283     function decrement(Counter storage counter) internal {
284         counter._value = counter._value.sub(1);
285     }
286 }
287 
288 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
289 
290 pragma solidity ^0.5.0;
291 
292 
293 /**
294  * @dev Implementation of the `IERC165` interface.
295  *
296  * Contracts may inherit from this and call `_registerInterface` to declare
297  * their support of an interface.
298  */
299 contract ERC165 is IERC165 {
300     /*
301      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
302      */
303     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
304 
305     /**
306      * @dev Mapping of interface ids to whether or not it's supported.
307      */
308     mapping(bytes4 => bool) private _supportedInterfaces;
309 
310     constructor () internal {
311         // Derived contracts need only register support for their own interfaces,
312         // we register support for ERC165 itself here
313         _registerInterface(_INTERFACE_ID_ERC165);
314     }
315 
316     /**
317      * @dev See `IERC165.supportsInterface`.
318      *
319      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
322         return _supportedInterfaces[interfaceId];
323     }
324 
325     /**
326      * @dev Registers the contract as an implementer of the interface defined by
327      * `interfaceId`. Support of the actual ERC165 interface is automatic and
328      * registering its interface id is not required.
329      *
330      * See `IERC165.supportsInterface`.
331      *
332      * Requirements:
333      *
334      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
335      */
336     function _registerInterface(bytes4 interfaceId) internal {
337         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
338         _supportedInterfaces[interfaceId] = true;
339     }
340 }
341 
342 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
343 
344 pragma solidity ^0.5.0;
345 
346 
347 
348 
349 
350 
351 
352 /**
353  * @title ERC721 Non-Fungible Token Standard basic implementation
354  * @dev see https://eips.ethereum.org/EIPS/eip-721
355  */
356 contract ERC721 is ERC165, IERC721 {
357     using SafeMath for uint256;
358     using Address for address;
359     using Counters for Counters.Counter;
360 
361     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
362     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
363     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
364 
365     // Mapping from token ID to owner
366     mapping (uint256 => address) private _tokenOwner;
367 
368     // Mapping from token ID to approved address
369     mapping (uint256 => address) private _tokenApprovals;
370 
371     // Mapping from owner to number of owned token
372     mapping (address => Counters.Counter) private _ownedTokensCount;
373 
374     // Mapping from owner to operator approvals
375     mapping (address => mapping (address => bool)) private _operatorApprovals;
376 
377     /*
378      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
379      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
380      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
381      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
382      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
383      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
384      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
385      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
386      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
387      *
388      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
389      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
390      */
391     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
392 
393     constructor () public {
394         // register the supported interfaces to conform to ERC721 via ERC165
395         _registerInterface(_INTERFACE_ID_ERC721);
396     }
397 
398     /**
399      * @dev Gets the balance of the specified address.
400      * @param owner address to query the balance of
401      * @return uint256 representing the amount owned by the passed address
402      */
403     function balanceOf(address owner) public view returns (uint256) {
404         require(owner != address(0), "ERC721: balance query for the zero address");
405 
406         return _ownedTokensCount[owner].current();
407     }
408 
409     /**
410      * @dev Gets the owner of the specified token ID.
411      * @param tokenId uint256 ID of the token to query the owner of
412      * @return address currently marked as the owner of the given token ID
413      */
414     function ownerOf(uint256 tokenId) public view returns (address) {
415         address owner = _tokenOwner[tokenId];
416         require(owner != address(0), "ERC721: owner query for nonexistent token");
417 
418         return owner;
419     }
420 
421     /**
422      * @dev Approves another address to transfer the given token ID
423      * The zero address indicates there is no approved address.
424      * There can only be one approved address per token at a given time.
425      * Can only be called by the token owner or an approved operator.
426      * @param to address to be approved for the given token ID
427      * @param tokenId uint256 ID of the token to be approved
428      */
429     function approve(address to, uint256 tokenId) public {
430         address owner = ownerOf(tokenId);
431         require(to != owner, "ERC721: approval to current owner");
432 
433         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
434             "ERC721: approve caller is not owner nor approved for all"
435         );
436 
437         _tokenApprovals[tokenId] = to;
438         emit Approval(owner, to, tokenId);
439     }
440 
441     /**
442      * @dev Gets the approved address for a token ID, or zero if no address set
443      * Reverts if the token ID does not exist.
444      * @param tokenId uint256 ID of the token to query the approval of
445      * @return address currently approved for the given token ID
446      */
447     function getApproved(uint256 tokenId) public view returns (address) {
448         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
449 
450         return _tokenApprovals[tokenId];
451     }
452 
453     /**
454      * @dev Sets or unsets the approval of a given operator
455      * An operator is allowed to transfer all tokens of the sender on their behalf.
456      * @param to operator address to set the approval
457      * @param approved representing the status of the approval to be set
458      */
459     function setApprovalForAll(address to, bool approved) public {
460         require(to != msg.sender, "ERC721: approve to caller");
461 
462         _operatorApprovals[msg.sender][to] = approved;
463         emit ApprovalForAll(msg.sender, to, approved);
464     }
465 
466     /**
467      * @dev Tells whether an operator is approved by a given owner.
468      * @param owner owner address which you want to query the approval of
469      * @param operator operator address which you want to query the approval of
470      * @return bool whether the given operator is approved by the given owner
471      */
472     function isApprovedForAll(address owner, address operator) public view returns (bool) {
473         return _operatorApprovals[owner][operator];
474     }
475 
476     /**
477      * @dev Transfers the ownership of a given token ID to another address.
478      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
479      * Requires the msg.sender to be the owner, approved, or operator.
480      * @param from current owner of the token
481      * @param to address to receive the ownership of the given token ID
482      * @param tokenId uint256 ID of the token to be transferred
483      */
484     function transferFrom(address from, address to, uint256 tokenId) public {
485         //solhint-disable-next-line max-line-length
486         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
487 
488         _transferFrom(from, to, tokenId);
489     }
490 
491     /**
492      * @dev Safely transfers the ownership of a given token ID to another address
493      * If the target address is a contract, it must implement `onERC721Received`,
494      * which is called upon a safe transfer, and return the magic value
495      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
496      * the transfer is reverted.
497      * Requires the msg.sender to be the owner, approved, or operator
498      * @param from current owner of the token
499      * @param to address to receive the ownership of the given token ID
500      * @param tokenId uint256 ID of the token to be transferred
501      */
502     function safeTransferFrom(address from, address to, uint256 tokenId) public {
503         safeTransferFrom(from, to, tokenId, "");
504     }
505 
506     /**
507      * @dev Safely transfers the ownership of a given token ID to another address
508      * If the target address is a contract, it must implement `onERC721Received`,
509      * which is called upon a safe transfer, and return the magic value
510      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
511      * the transfer is reverted.
512      * Requires the msg.sender to be the owner, approved, or operator
513      * @param from current owner of the token
514      * @param to address to receive the ownership of the given token ID
515      * @param tokenId uint256 ID of the token to be transferred
516      * @param _data bytes data to send along with a safe transfer check
517      */
518     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
519         transferFrom(from, to, tokenId);
520         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
521     }
522 
523     /**
524      * @dev Returns whether the specified token exists.
525      * @param tokenId uint256 ID of the token to query the existence of
526      * @return bool whether the token exists
527      */
528     function _exists(uint256 tokenId) internal view returns (bool) {
529         address owner = _tokenOwner[tokenId];
530         return owner != address(0);
531     }
532 
533     /**
534      * @dev Returns whether the given spender can transfer a given token ID.
535      * @param spender address of the spender to query
536      * @param tokenId uint256 ID of the token to be transferred
537      * @return bool whether the msg.sender is approved for the given token ID,
538      * is an operator of the owner, or is the owner of the token
539      */
540     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
541         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
542         address owner = ownerOf(tokenId);
543         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
544     }
545 
546     /**
547      * @dev Internal function to mint a new token.
548      * Reverts if the given token ID already exists.
549      * @param to The address that will own the minted token
550      * @param tokenId uint256 ID of the token to be minted
551      */
552     function _mint(address to, uint256 tokenId) internal {
553         require(to != address(0), "ERC721: mint to the zero address");
554         require(!_exists(tokenId), "ERC721: token already minted");
555 
556         _tokenOwner[tokenId] = to;
557         _ownedTokensCount[to].increment();
558 
559         emit Transfer(address(0), to, tokenId);
560     }
561 
562     /**
563      * @dev Internal function to burn a specific token.
564      * Reverts if the token does not exist.
565      * Deprecated, use _burn(uint256) instead.
566      * @param owner owner of the token to burn
567      * @param tokenId uint256 ID of the token being burned
568      */
569     function _burn(address owner, uint256 tokenId) internal {
570         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
571 
572         _clearApproval(tokenId);
573 
574         _ownedTokensCount[owner].decrement();
575         _tokenOwner[tokenId] = address(0);
576 
577         emit Transfer(owner, address(0), tokenId);
578     }
579 
580     /**
581      * @dev Internal function to burn a specific token.
582      * Reverts if the token does not exist.
583      * @param tokenId uint256 ID of the token being burned
584      */
585     function _burn(uint256 tokenId) internal {
586         _burn(ownerOf(tokenId), tokenId);
587     }
588 
589     /**
590      * @dev Internal function to transfer ownership of a given token ID to another address.
591      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
592      * @param from current owner of the token
593      * @param to address to receive the ownership of the given token ID
594      * @param tokenId uint256 ID of the token to be transferred
595      */
596     function _transferFrom(address from, address to, uint256 tokenId) internal {
597         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
598         require(to != address(0), "ERC721: transfer to the zero address");
599 
600         _clearApproval(tokenId);
601 
602         _ownedTokensCount[from].decrement();
603         _ownedTokensCount[to].increment();
604 
605         _tokenOwner[tokenId] = to;
606 
607         emit Transfer(from, to, tokenId);
608     }
609 
610     /**
611      * @dev Internal function to invoke `onERC721Received` on a target address.
612      * The call is not executed if the target address is not a contract.
613      *
614      * This function is deprecated.
615      * @param from address representing the previous owner of the given token ID
616      * @param to target address that will receive the tokens
617      * @param tokenId uint256 ID of the token to be transferred
618      * @param _data bytes optional data to send along with the call
619      * @return bool whether the call correctly returned the expected magic value
620      */
621     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
622         internal returns (bool)
623     {
624         if (!to.isContract()) {
625             return true;
626         }
627 
628         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
629         return (retval == _ERC721_RECEIVED);
630     }
631 
632     /**
633      * @dev Private function to clear current approval of a given token ID.
634      * @param tokenId uint256 ID of the token to be transferred
635      */
636     function _clearApproval(uint256 tokenId) private {
637         if (_tokenApprovals[tokenId] != address(0)) {
638             _tokenApprovals[tokenId] = address(0);
639         }
640     }
641 }
642 
643 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
644 
645 pragma solidity ^0.5.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 contract IERC721Metadata is IERC721 {
653     function name() external view returns (string memory);
654     function symbol() external view returns (string memory);
655     function tokenURI(uint256 tokenId) external view returns (string memory);
656 }
657 
658 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
659 
660 pragma solidity ^0.5.0;
661 
662 
663 
664 
665 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Optional mapping for token URIs
673     mapping(uint256 => string) private _tokenURIs;
674 
675     /*
676      *     bytes4(keccak256('name()')) == 0x06fdde03
677      *     bytes4(keccak256('symbol()')) == 0x95d89b41
678      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
679      *
680      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
681      */
682     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
683 
684     /**
685      * @dev Constructor function
686      */
687     constructor (string memory name, string memory symbol) public {
688         _name = name;
689         _symbol = symbol;
690 
691         // register the supported interfaces to conform to ERC721 via ERC165
692         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
693     }
694 
695     /**
696      * @dev Gets the token name.
697      * @return string representing the token name
698      */
699     function name() external view returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev Gets the token symbol.
705      * @return string representing the token symbol
706      */
707     function symbol() external view returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev Returns an URI for a given token ID.
713      * Throws if the token ID does not exist. May return an empty string.
714      * @param tokenId uint256 ID of the token to query
715      */
716     function tokenURI(uint256 tokenId) external view returns (string memory) {
717         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
718         return _tokenURIs[tokenId];
719     }
720 
721     /**
722      * @dev Internal function to set the token URI for a given token.
723      * Reverts if the token ID does not exist.
724      * @param tokenId uint256 ID of the token to set its URI
725      * @param uri string URI to assign
726      */
727     function _setTokenURI(uint256 tokenId, string memory uri) internal {
728         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
729         _tokenURIs[tokenId] = uri;
730     }
731 
732     /**
733      * @dev Internal function to burn a specific token.
734      * Reverts if the token does not exist.
735      * Deprecated, use _burn(uint256) instead.
736      * @param owner owner of the token to burn
737      * @param tokenId uint256 ID of the token being burned by the msg.sender
738      */
739     function _burn(address owner, uint256 tokenId) internal {
740         super._burn(owner, tokenId);
741 
742         // Clear metadata (if any)
743         if (bytes(_tokenURIs[tokenId]).length != 0) {
744             delete _tokenURIs[tokenId];
745         }
746     }
747 }
748 
749 // File: openzeppelin-solidity/contracts/access/Roles.sol
750 
751 pragma solidity ^0.5.0;
752 
753 /**
754  * @title Roles
755  * @dev Library for managing addresses assigned to a Role.
756  */
757 library Roles {
758     struct Role {
759         mapping (address => bool) bearer;
760     }
761 
762     /**
763      * @dev Give an account access to this role.
764      */
765     function add(Role storage role, address account) internal {
766         require(!has(role, account), "Roles: account already has role");
767         role.bearer[account] = true;
768     }
769 
770     /**
771      * @dev Remove an account's access to this role.
772      */
773     function remove(Role storage role, address account) internal {
774         require(has(role, account), "Roles: account does not have role");
775         role.bearer[account] = false;
776     }
777 
778     /**
779      * @dev Check if an account has this role.
780      * @return bool
781      */
782     function has(Role storage role, address account) internal view returns (bool) {
783         require(account != address(0), "Roles: account is the zero address");
784         return role.bearer[account];
785     }
786 }
787 
788 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
789 
790 pragma solidity ^0.5.0;
791 
792 
793 contract PauserRole {
794     using Roles for Roles.Role;
795 
796     event PauserAdded(address indexed account);
797     event PauserRemoved(address indexed account);
798 
799     Roles.Role private _pausers;
800 
801     constructor () internal {
802         _addPauser(msg.sender);
803     }
804 
805     modifier onlyPauser() {
806         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
807         _;
808     }
809 
810     function isPauser(address account) public view returns (bool) {
811         return _pausers.has(account);
812     }
813 
814     function addPauser(address account) public onlyPauser {
815         _addPauser(account);
816     }
817 
818     function renouncePauser() public {
819         _removePauser(msg.sender);
820     }
821 
822     function _addPauser(address account) internal {
823         _pausers.add(account);
824         emit PauserAdded(account);
825     }
826 
827     function _removePauser(address account) internal {
828         _pausers.remove(account);
829         emit PauserRemoved(account);
830     }
831 }
832 
833 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
834 
835 pragma solidity ^0.5.0;
836 
837 
838 /**
839  * @dev Contract module which allows children to implement an emergency stop
840  * mechanism that can be triggered by an authorized account.
841  *
842  * This module is used through inheritance. It will make available the
843  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
844  * the functions of your contract. Note that they will not be pausable by
845  * simply including this module, only once the modifiers are put in place.
846  */
847 contract Pausable is PauserRole {
848     /**
849      * @dev Emitted when the pause is triggered by a pauser (`account`).
850      */
851     event Paused(address account);
852 
853     /**
854      * @dev Emitted when the pause is lifted by a pauser (`account`).
855      */
856     event Unpaused(address account);
857 
858     bool private _paused;
859 
860     /**
861      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
862      * to the deployer.
863      */
864     constructor () internal {
865         _paused = false;
866     }
867 
868     /**
869      * @dev Returns true if the contract is paused, and false otherwise.
870      */
871     function paused() public view returns (bool) {
872         return _paused;
873     }
874 
875     /**
876      * @dev Modifier to make a function callable only when the contract is not paused.
877      */
878     modifier whenNotPaused() {
879         require(!_paused, "Pausable: paused");
880         _;
881     }
882 
883     /**
884      * @dev Modifier to make a function callable only when the contract is paused.
885      */
886     modifier whenPaused() {
887         require(_paused, "Pausable: not paused");
888         _;
889     }
890 
891     /**
892      * @dev Called by a pauser to pause, triggers stopped state.
893      */
894     function pause() public onlyPauser whenNotPaused {
895         _paused = true;
896         emit Paused(msg.sender);
897     }
898 
899     /**
900      * @dev Called by a pauser to unpause, returns to normal state.
901      */
902     function unpause() public onlyPauser whenPaused {
903         _paused = false;
904         emit Unpaused(msg.sender);
905     }
906 }
907 
908 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
909 
910 pragma solidity ^0.5.0;
911 
912 /**
913  * @dev Contract module which provides a basic access control mechanism, where
914  * there is an account (an owner) that can be granted exclusive access to
915  * specific functions.
916  *
917  * This module is used through inheritance. It will make available the modifier
918  * `onlyOwner`, which can be aplied to your functions to restrict their use to
919  * the owner.
920  */
921 contract Ownable {
922     address private _owner;
923 
924     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
925 
926     /**
927      * @dev Initializes the contract setting the deployer as the initial owner.
928      */
929     constructor () internal {
930         _owner = msg.sender;
931         emit OwnershipTransferred(address(0), _owner);
932     }
933 
934     /**
935      * @dev Returns the address of the current owner.
936      */
937     function owner() public view returns (address) {
938         return _owner;
939     }
940 
941     /**
942      * @dev Throws if called by any account other than the owner.
943      */
944     modifier onlyOwner() {
945         require(isOwner(), "Ownable: caller is not the owner");
946         _;
947     }
948 
949     /**
950      * @dev Returns true if the caller is the current owner.
951      */
952     function isOwner() public view returns (bool) {
953         return msg.sender == _owner;
954     }
955 
956     /**
957      * @dev Leaves the contract without owner. It will not be possible to call
958      * `onlyOwner` functions anymore. Can only be called by the current owner.
959      *
960      * > Note: Renouncing ownership will leave the contract without an owner,
961      * thereby removing any functionality that is only available to the owner.
962      */
963     function renounceOwnership() public onlyOwner {
964         emit OwnershipTransferred(_owner, address(0));
965         _owner = address(0);
966     }
967 
968     /**
969      * @dev Transfers ownership of the contract to a new account (`newOwner`).
970      * Can only be called by the current owner.
971      */
972     function transferOwnership(address newOwner) public onlyOwner {
973         _transferOwnership(newOwner);
974     }
975 
976     /**
977      * @dev Transfers ownership of the contract to a new account (`newOwner`).
978      */
979     function _transferOwnership(address newOwner) internal {
980         require(newOwner != address(0), "Ownable: new owner is the zero address");
981         emit OwnershipTransferred(_owner, newOwner);
982         _owner = newOwner;
983     }
984 }
985 
986 // File: contracts/eth_superplayer_randomequip.sol
987 
988 pragma solidity ^0.5.0;
989 
990 
991 
992 
993 
994 
995 contract SuperplayerRandomEquipment  is Ownable{
996 
997   using SafeMath for uint256;
998 
999   //enum EquipmentPart {Weapon ,Head,Coat,Pants ,Shoes }
1000   //enum EquipmentRareness {White,Green,Blue,Purple, Orange,Red }
1001 
1002   // Equipment in pool
1003   struct Equipment {
1004     string key;
1005     uint weight;
1006   //  EquipmentPart part;
1007   //  EquipmentRareness rareness;
1008     uint[] randomKeyIds; 
1009   }
1010 
1011 
1012   Equipment[] private equips;
1013   uint256 TotalEquipNum; // for ERC721
1014   uint256 TotalWeight; // for ERC721
1015 
1016   //keyid -> value->weight
1017 
1018 
1019   struct ValueByWeight {
1020     uint value;
1021     uint weight;
1022   }
1023 
1024   mapping(uint => ValueByWeight[] ) randomvalueTable  ;
1025   mapping(uint => uint ) randomvalueTableWeights  ;
1026 
1027 
1028 
1029 
1030   constructor() public{
1031     //initRtables();
1032     //initEquipmentPools();
1033   }
1034 
1035 
1036 
1037 
1038   function getRandomEquipment(uint256 seed) public view returns(uint blockNo,string memory ekey,uint[] memory randomProps)  {
1039     uint random = getRandom(seed);
1040     uint equipIndex = getRandomEquipIndexByWeight(  random % TotalWeight  + 1) ;
1041     //ensure equipment index
1042     Equipment memory  equip =  equips[equipIndex];
1043 
1044     //ensure random values
1045     randomProps = new uint[](equip.randomKeyIds.length);
1046     for(uint i=0;i< randomProps.length ; i++) {
1047       uint keyid = equip.randomKeyIds[i] ;
1048       uint rv = _randomValue(keyid,  (random >>i )% randomvalueTableWeights[keyid] +1 );
1049       randomProps[i] = rv;
1050     }
1051     blockNo = block.number;
1052     ekey = equip.key;
1053   }
1054 
1055 
1056 
1057   // config
1058   function initRtables1() public  onlyOwner{
1059     _initRtables1();
1060   }
1061   function initRtables2() public  onlyOwner{
1062     _initRtables2();
1063   }
1064 
1065   function initEquipmentPools() public  onlyOwner{
1066     _initEquipmentPools();
1067   }
1068   function addEquipToPool(string memory key,uint[] memory randomKeyIds,uint weight) public  onlyOwner{
1069     _addEquipToPool(key,randomKeyIds,weight);
1070   }
1071 
1072 
1073 
1074 
1075   function addRandomValuesforRTable(uint keyid, uint[] memory values,uint[] memory weights) public onlyOwner {
1076     _addRandomValuesforRTable(keyid,values,weights);
1077   }
1078   //config end
1079 
1080 
1081   function getEquipmentConf(uint equipIndex) public view returns( string memory key,uint weight,uint[] memory randomKeyIds){
1082     Equipment memory  equip =  equips[equipIndex];
1083     key = equip.key;
1084     weight = equip.weight;
1085     randomKeyIds = equip.randomKeyIds;
1086   }
1087 
1088   function getRandomValueConf(uint keyid) public view returns( uint[]memory values,uint[] memory weights){
1089     ValueByWeight[] memory vs  =randomvalueTable[keyid];
1090     values = new uint[](vs.length);
1091     weights = new uint[](vs.length);
1092     for(uint i = 0 ;i < vs.length;++i) {
1093       values[i]=vs[i].value;
1094       weights[i]=vs[i].weight;
1095     }
1096   }
1097 
1098 
1099   function getRandomEquipIndexByWeight( uint weight ) internal view returns (uint) {
1100     require( weight <= TotalWeight );
1101     uint sum ;
1102     for (uint i = 0;i < TotalEquipNum ; i++){
1103       sum += equips[i].weight;
1104       if( weight  <=  sum ){
1105         return i;
1106       }
1107     }
1108     return TotalEquipNum -1 ;
1109   }
1110 
1111 
1112   function _addEquipToPool(string memory key,uint[] memory randomKeyIds,uint weight) internal {
1113     Equipment memory newEquip = Equipment({
1114       key : key,
1115       randomKeyIds : randomKeyIds,
1116       weight : weight
1117     });
1118     equips.push(newEquip);
1119     TotalEquipNum = TotalEquipNum.add(1);
1120     TotalWeight += weight;
1121   }
1122 
1123   function _addRandomValuesforRTable(uint keyid, uint[] memory values,uint[] memory weights) internal {
1124     require(randomvalueTableWeights[keyid]  == 0 );
1125     for( uint i = 0; i < values.length;++i) {
1126       ValueByWeight memory vw  = ValueByWeight({
1127         value : values[i],
1128         weight: weights[i]
1129       });
1130       randomvalueTable[keyid].push(vw);
1131       randomvalueTableWeights[keyid] += weights[i];
1132     }
1133   }
1134   //concat user seed  later
1135   function getRandom(uint256 seed) internal view returns (uint256){
1136     return uint256(keccak256(abi.encodePacked(block.timestamp, seed,block.difficulty)));
1137   }
1138 
1139   function _randomValue (uint keyid,uint weight ) internal view returns(uint randomValue){
1140     ValueByWeight[] memory vs  =randomvalueTable[keyid];
1141     uint sum ;
1142     for (uint i = 0;i < vs.length ; i++){
1143       ValueByWeight memory vw  = vs[i];
1144       sum += vw.weight;
1145       if( weight  <=  sum ){
1146         return vw.value;
1147       }
1148     }
1149     return vs[vs.length -1].value ;
1150   }
1151 
1152 
1153 
1154   function _initEquipmentPools () internal {
1155 
1156 
1157 uint[] memory pblue_weapongun_gun_sniper_laser = new uint[](4);
1158 pblue_weapongun_gun_sniper_laser[0] = 134;
1159 pblue_weapongun_gun_sniper_laser[1] = 134;
1160 pblue_weapongun_gun_sniper_laser[2] = 134;
1161 pblue_weapongun_gun_sniper_laser[3] = 134;
1162 _addEquipToPool("blue_weapongun_gun_sniper_laser",pblue_weapongun_gun_sniper_laser,1);
1163 
1164 
1165 uint[] memory pblue_weapongun_gun_black_hand = new uint[](4);
1166 pblue_weapongun_gun_black_hand[0] = 135;
1167 pblue_weapongun_gun_black_hand[1] = 135;
1168 pblue_weapongun_gun_black_hand[2] = 135;
1169 pblue_weapongun_gun_black_hand[3] = 135;
1170 _addEquipToPool("blue_weapongun_gun_black_hand",pblue_weapongun_gun_black_hand,1);
1171 
1172 
1173 uint[] memory pblue_weapon_gun_gray_auto = new uint[](4);
1174 pblue_weapon_gun_gray_auto[0] = 132;
1175 pblue_weapon_gun_gray_auto[1] = 132;
1176 pblue_weapon_gun_gray_auto[2] = 132;
1177 pblue_weapon_gun_gray_auto[3] = 132;
1178 _addEquipToPool("blue_weapon_gun_gray_auto",pblue_weapon_gun_gray_auto,1);
1179 
1180 
1181 uint[] memory pblue_weapon_gun_gray_sniper = new uint[](4);
1182 pblue_weapon_gun_gray_sniper[0] = 133;
1183 pblue_weapon_gun_gray_sniper[1] = 133;
1184 pblue_weapon_gun_gray_sniper[2] = 133;
1185 pblue_weapon_gun_gray_sniper[3] = 133;
1186 _addEquipToPool("blue_weapon_gun_gray_sniper",pblue_weapon_gun_gray_sniper,1);
1187 
1188 
1189 uint[] memory pblue_weapon_gun_gray_shotgun = new uint[](4);
1190 pblue_weapon_gun_gray_shotgun[0] = 131;
1191 pblue_weapon_gun_gray_shotgun[1] = 131;
1192 pblue_weapon_gun_gray_shotgun[2] = 131;
1193 pblue_weapon_gun_gray_shotgun[3] = 131;
1194 _addEquipToPool("blue_weapon_gun_gray_shotgun",pblue_weapon_gun_gray_shotgun,1);
1195 
1196 
1197 uint[] memory pblue_helmet_damage = new uint[](5);
1198 pblue_helmet_damage[0] = 232;
1199 pblue_helmet_damage[1] = 232;
1200 pblue_helmet_damage[2] = 232;
1201 pblue_helmet_damage[3] = 232;
1202 pblue_helmet_damage[4] = 232;
1203 _addEquipToPool("blue_helmet_damage",pblue_helmet_damage,2);
1204 
1205 
1206 uint[] memory pblue_body_damage = new uint[](5);
1207 pblue_body_damage[0] = 232;
1208 pblue_body_damage[1] = 232;
1209 pblue_body_damage[2] = 232;
1210 pblue_body_damage[3] = 232;
1211 pblue_body_damage[4] = 232;
1212 _addEquipToPool("blue_body_damage",pblue_body_damage,2);
1213 
1214 
1215 uint[] memory pblue_leg_damage = new uint[](5);
1216 pblue_leg_damage[0] = 232;
1217 pblue_leg_damage[1] = 232;
1218 pblue_leg_damage[2] = 232;
1219 pblue_leg_damage[3] = 232;
1220 pblue_leg_damage[4] = 232;
1221 _addEquipToPool("blue_leg_damage",pblue_leg_damage,2);
1222 
1223 
1224 uint[] memory pblue_shoes_damage = new uint[](5);
1225 pblue_shoes_damage[0] = 232;
1226 pblue_shoes_damage[1] = 232;
1227 pblue_shoes_damage[2] = 232;
1228 pblue_shoes_damage[3] = 232;
1229 pblue_shoes_damage[4] = 232;
1230 _addEquipToPool("blue_shoes_damage",pblue_shoes_damage,2);
1231 
1232 
1233 uint[] memory pblue_helmet_hp = new uint[](5);
1234 pblue_helmet_hp[0] = 231;
1235 pblue_helmet_hp[1] = 231;
1236 pblue_helmet_hp[2] = 231;
1237 pblue_helmet_hp[3] = 231;
1238 pblue_helmet_hp[4] = 231;
1239 _addEquipToPool("blue_helmet_hp",pblue_helmet_hp,2);
1240 
1241 
1242 uint[] memory pblue_body_hp = new uint[](5);
1243 pblue_body_hp[0] = 231;
1244 pblue_body_hp[1] = 231;
1245 pblue_body_hp[2] = 231;
1246 pblue_body_hp[3] = 231;
1247 pblue_body_hp[4] = 231;
1248 _addEquipToPool("blue_body_hp",pblue_body_hp,2);
1249 
1250 
1251 uint[] memory pblue_leg_hp = new uint[](5);
1252 pblue_leg_hp[0] = 231;
1253 pblue_leg_hp[1] = 231;
1254 pblue_leg_hp[2] = 231;
1255 pblue_leg_hp[3] = 231;
1256 pblue_leg_hp[4] = 231;
1257 _addEquipToPool("blue_leg_hp",pblue_leg_hp,2);
1258 
1259 
1260 uint[] memory pblue_shoes_hp = new uint[](5);
1261 pblue_shoes_hp[0] = 231;
1262 pblue_shoes_hp[1] = 231;
1263 pblue_shoes_hp[2] = 231;
1264 pblue_shoes_hp[3] = 231;
1265 pblue_shoes_hp[4] = 231;
1266 _addEquipToPool("blue_shoes_hp",pblue_shoes_hp,0);
1267 
1268      
1269      
1270 
1271   }
1272   function _initRtables1 () internal {
1273 
1274 
1275 uint[] memory v121 = new uint[](6);
1276 uint[] memory w121  = new uint[](6);
1277 v121[0]= 1001; w121[0]=14;
1278 v121[1]= 1002; w121[1]=40;
1279 v121[2]= 1003; w121[2]=10;
1280 v121[3]= 1008; w121[3]=12;
1281 v121[4]= 1009; w121[4]=12;
1282 v121[5]= 1010; w121[5]=12;
1283 _addRandomValuesforRTable(121,v121,w121);
1284 
1285 uint[] memory v123 = new uint[](7);
1286 uint[] memory w123  = new uint[](7);
1287 v123[0]= 1001; w123[0]=30;
1288 v123[1]= 1005; w123[1]=10;
1289 v123[2]= 1006; w123[2]=10;
1290 v123[3]= 1008; w123[3]=13;
1291 v123[4]= 1009; w123[4]=12;
1292 v123[5]= 1010; w123[5]=13;
1293 v123[6]= 1007; w123[6]=12;
1294 _addRandomValuesforRTable(123,v123,w123);
1295 
1296 uint[] memory v125 = new uint[](7);
1297 uint[] memory w125  = new uint[](7);
1298 v125[0]= 1001; w125[0]=30;
1299 v125[1]= 1005; w125[1]=10;
1300 v125[2]= 1006; w125[2]=10;
1301 v125[3]= 1008; w125[3]=20;
1302 v125[4]= 1009; w125[4]=10;
1303 v125[5]= 1010; w125[5]=10;
1304 v125[6]= 1007; w125[6]=10;
1305 _addRandomValuesforRTable(125,v125,w125);
1306 
1307 uint[] memory v135 = new uint[](7);
1308 uint[] memory w135  = new uint[](7);
1309 v135[0]= 1001; w135[0]=20;
1310 v135[1]= 1005; w135[1]=8;
1311 v135[2]= 1006; w135[2]=8;
1312 v135[3]= 1008; w135[3]=8;
1313 v135[4]= 1009; w135[4]=40;
1314 v135[5]= 1010; w135[5]=8;
1315 v135[6]= 1007; w135[6]=8;
1316 _addRandomValuesforRTable(135,v135,w135);
1317 
1318 uint[] memory v232 = new uint[](8);
1319 uint[] memory w232  = new uint[](8);
1320 v232[0]= 2002; w232[0]=15;
1321 v232[1]= 2003; w232[1]=8;
1322 v232[2]= 2004; w232[2]=7;
1323 v232[3]= 2001; w232[3]=34;
1324 v232[4]= 2008; w232[4]=9;
1325 v232[5]= 2007; w232[5]=9;
1326 v232[6]= 2009; w232[6]=9;
1327 v232[7]= 2005; w232[7]=9;
1328 _addRandomValuesforRTable(232,v232,w232);
1329 
1330 uint[] memory v112 = new uint[](7);
1331 uint[] memory w112  = new uint[](7);
1332 v112[0]= 1001; w112[0]=40;
1333 v112[1]= 1005; w112[1]=10;
1334 v112[2]= 1006; w112[2]=10;
1335 v112[3]= 1008; w112[3]=10;
1336 v112[4]= 1009; w112[4]=10;
1337 v112[5]= 1010; w112[5]=10;
1338 v112[6]= 1007; w112[6]=10;
1339 _addRandomValuesforRTable(112,v112,w112);
1340 
1341 uint[] memory v124 = new uint[](7);
1342 uint[] memory w124  = new uint[](7);
1343 v124[0]= 1001; w124[0]=30;
1344 v124[1]= 1005; w124[1]=10;
1345 v124[2]= 1006; w124[2]=10;
1346 v124[3]= 1008; w124[3]=10;
1347 v124[4]= 1009; w124[4]=10;
1348 v124[5]= 1010; w124[5]=20;
1349 v124[6]= 1007; w124[6]=10;
1350 _addRandomValuesforRTable(124,v124,w124);
1351 
1352 uint[] memory v134 = new uint[](7);
1353 uint[] memory w134  = new uint[](7);
1354 v134[0]= 1001; w134[0]=20;
1355 v134[1]= 1005; w134[1]=8;
1356 v134[2]= 1006; w134[2]=8;
1357 v134[3]= 1008; w134[3]=8;
1358 v134[4]= 1009; w134[4]=8;
1359 v134[5]= 1010; w134[5]=40;
1360 v134[6]= 1007; w134[6]=8;
1361 _addRandomValuesforRTable(134,v134,w134);
1362 
1363 uint[] memory v211 = new uint[](6);
1364 uint[] memory w211  = new uint[](6);
1365 v211[0]= 2002; w211[0]=30;
1366 v211[1]= 2003; w211[1]=10;
1367 v211[2]= 2004; w211[2]=10;
1368 v211[3]= 2001; w211[3]=30;
1369 v211[4]= 2008; w211[4]=10;
1370 v211[5]= 2007; w211[5]=10;
1371 _addRandomValuesforRTable(211,v211,w211);
1372 
1373 uint[] memory v221 = new uint[](6);
1374 uint[] memory w221  = new uint[](6);
1375 v221[0]= 2002; w221[0]=35;
1376 v221[1]= 2003; w221[1]=12;
1377 v221[2]= 2004; w221[2]=13;
1378 v221[3]= 2001; w221[3]=20;
1379 v221[4]= 2008; w221[4]=10;
1380 v221[5]= 2007; w221[5]=10;
1381 _addRandomValuesforRTable(221,v221,w221);
1382 
1383 uint[] memory v212 = new uint[](8);
1384 uint[] memory w212  = new uint[](8);
1385 v212[0]= 2002; w212[0]=30;
1386 v212[1]= 2003; w212[1]=10;
1387 v212[2]= 2004; w212[2]=10;
1388 v212[3]= 2001; w212[3]=30;
1389 v212[4]= 2008; w212[4]=5;
1390 v212[5]= 2007; w212[5]=5;
1391 v212[6]= 2009; w212[6]=5;
1392 v212[7]= 2005; w212[7]=5;
1393 _addRandomValuesforRTable(212,v212,w212);
1394 
1395 
1396   }
1397 
1398   function _initRtables2 () internal {
1399 uint[] memory v111 = new uint[](6);
1400 uint[] memory w111  = new uint[](6);
1401 v111[0]= 1001; w111[0]=14;
1402 v111[1]= 1002; w111[1]=40;
1403 v111[2]= 1003; w111[2]=10;
1404 v111[3]= 1008; w111[3]=12;
1405 v111[4]= 1009; w111[4]=12;
1406 v111[5]= 1010; w111[5]=12;
1407 _addRandomValuesforRTable(111,v111,w111);
1408 
1409 uint[] memory v113 = new uint[](7);
1410 uint[] memory w113  = new uint[](7);
1411 v113[0]= 1001; w113[0]=30;
1412 v113[1]= 1005; w113[1]=10;
1413 v113[2]= 1006; w113[2]=10;
1414 v113[3]= 1008; w113[3]=13;
1415 v113[4]= 1009; w113[4]=12;
1416 v113[5]= 1010; w113[5]=13;
1417 v113[6]= 1007; w113[6]=12;
1418 _addRandomValuesforRTable(113,v113,w113);
1419 
1420 uint[] memory v114 = new uint[](7);
1421 uint[] memory w114  = new uint[](7);
1422 v114[0]= 1001; w114[0]=30;
1423 v114[1]= 1005; w114[1]=10;
1424 v114[2]= 1006; w114[2]=10;
1425 v114[3]= 1008; w114[3]=10;
1426 v114[4]= 1009; w114[4]=10;
1427 v114[5]= 1010; w114[5]=20;
1428 v114[6]= 1007; w114[6]=10;
1429 _addRandomValuesforRTable(114,v114,w114);
1430 
1431 uint[] memory v133 = new uint[](7);
1432 uint[] memory w133  = new uint[](7);
1433 v133[0]= 1001; w133[0]=8;
1434 v133[1]= 1005; w133[1]=40;
1435 v133[2]= 1006; w133[2]=20;
1436 v133[3]= 1008; w133[3]=8;
1437 v133[4]= 1009; w133[4]=8;
1438 v133[5]= 1010; w133[5]=8;
1439 v133[6]= 1007; w133[6]=8;
1440 _addRandomValuesforRTable(133,v133,w133);
1441 
1442 uint[] memory v115 = new uint[](7);
1443 uint[] memory w115  = new uint[](7);
1444 v115[0]= 1001; w115[0]=30;
1445 v115[1]= 1005; w115[1]=10;
1446 v115[2]= 1006; w115[2]=10;
1447 v115[3]= 1008; w115[3]=20;
1448 v115[4]= 1009; w115[4]=10;
1449 v115[5]= 1010; w115[5]=10;
1450 v115[6]= 1007; w115[6]=10;
1451 _addRandomValuesforRTable(115,v115,w115);
1452 
1453 uint[] memory v122 = new uint[](7);
1454 uint[] memory w122  = new uint[](7);
1455 v122[0]= 1001; w122[0]=40;
1456 v122[1]= 1005; w122[1]=10;
1457 v122[2]= 1006; w122[2]=10;
1458 v122[3]= 1008; w122[3]=10;
1459 v122[4]= 1009; w122[4]=10;
1460 v122[5]= 1010; w122[5]=10;
1461 v122[6]= 1007; w122[6]=1;
1462 _addRandomValuesforRTable(122,v122,w122);
1463 
1464 uint[] memory v131 = new uint[](6);
1465 uint[] memory w131  = new uint[](6);
1466 v131[0]= 1001; w131[0]=10;
1467 v131[1]= 1002; w131[1]=40;
1468 v131[2]= 1002; w131[2]=20;
1469 v131[3]= 1008; w131[3]=10;
1470 v131[4]= 1009; w131[4]=10;
1471 v131[5]= 1010; w131[5]=10;
1472 _addRandomValuesforRTable(131,v131,w131);
1473 
1474 uint[] memory v132 = new uint[](7);
1475 uint[] memory w132  = new uint[](7);
1476 v132[0]= 1001; w132[0]=50;
1477 v132[1]= 1005; w132[1]=9;
1478 v132[2]= 1006; w132[2]=9;
1479 v132[3]= 1008; w132[3]=8;
1480 v132[4]= 1009; w132[4]=8;
1481 v132[5]= 1010; w132[5]=8;
1482 v132[6]= 1007; w132[6]=8;
1483 _addRandomValuesforRTable(132,v132,w132);
1484 
1485 uint[] memory v231 = new uint[](6);
1486 uint[] memory w231  = new uint[](6);
1487 v231[0]= 2002; w231[0]=40;
1488 v231[1]= 2003; w231[1]=15;
1489 v231[2]= 2004; w231[2]=15;
1490 v231[3]= 2001; w231[3]=15;
1491 v231[4]= 2008; w231[4]=7;
1492 v231[5]= 2007; w231[5]=8;
1493 _addRandomValuesforRTable(231,v231,w231);
1494 
1495 uint[] memory v222 = new uint[](8);
1496 uint[] memory w222  = new uint[](8);
1497 v222[0]= 2002; w222[0]=20;
1498 v222[1]= 2003; w222[1]=10;
1499 v222[2]= 2004; w222[2]=10;
1500 v222[3]= 2001; w222[3]=32;
1501 v222[4]= 2008; w222[4]=7;
1502 v222[5]= 2007; w222[5]=7;
1503 v222[6]= 2009; w222[6]=7;
1504 v222[7]= 2005; w222[7]=7;
1505 _addRandomValuesforRTable(222,v222,w222);
1506   }
1507 
1508 
1509 }