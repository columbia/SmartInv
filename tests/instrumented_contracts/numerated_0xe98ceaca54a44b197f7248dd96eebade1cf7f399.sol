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
994 /*
995 
996 
997 
998 
999 
1000 */
1001 
1002 
1003 
1004 
1005 contract IRandomBuffValue {
1006     function randomValue(uint keyid,uint random) public view returns(uint);
1007 }
1008 
1009 
1010 
1011 
1012 contract SuperplayerRandomValueBase is Ownable {
1013   using SafeMath for uint256;
1014   struct ValueByWeight {
1015     uint value;
1016     uint weight;
1017   }
1018 
1019   mapping(uint => ValueByWeight[] ) randomvalueTable  ;
1020   mapping(uint => uint ) randomvalueTableWeights  ;
1021 
1022   function randomValue (uint keyid,uint random ) public view returns(uint rv){
1023       rv = _randomValue(keyid,  random% randomvalueTableWeights[keyid] +1 );
1024   }
1025 
1026 
1027   function getRandomValueConf(uint keyid) public view returns( uint[]memory values,uint[] memory weights){
1028     ValueByWeight[] memory vs  =randomvalueTable[keyid];
1029     values = new uint[](vs.length);
1030     weights = new uint[](vs.length);
1031     for(uint i = 0 ;i < vs.length;++i) {
1032       values[i]=vs[i].value;
1033       weights[i]=vs[i].weight;
1034     }
1035   }
1036 
1037   function addRandomValuesforRTable(uint keyid, uint[] memory values,uint[] memory weights) public onlyOwner {
1038     _addRandomValuesforRTable(keyid,values,weights);
1039   }
1040 
1041 
1042   function _randomValue (uint keyid,uint weight ) internal view returns(uint randomValue){
1043     ValueByWeight[] memory vs  =randomvalueTable[keyid];
1044     uint sum ;
1045     for (uint i = 0;i < vs.length ; i++){
1046       ValueByWeight memory vw  = vs[i];
1047       sum += vw.weight;
1048       if( weight  <=  sum ){
1049         return vw.value;
1050       }
1051     }
1052     return vs[vs.length -1].value ;
1053   }
1054 
1055  function _addRandomValuesforRTable(uint keyid, uint[] memory values,uint[] memory weights) internal {
1056     require(randomvalueTableWeights[keyid]  == 0 );
1057     for( uint i = 0; i < values.length;++i) {
1058       ValueByWeight memory vw  = ValueByWeight({
1059         value : values[i],
1060         weight: weights[i]
1061       });
1062       randomvalueTable[keyid].push(vw);
1063       randomvalueTableWeights[keyid] += weights[i];
1064     }
1065   }
1066 }
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 contract SuperplayerRandomEquipmentBase  is Ownable{
1075 
1076   using SafeMath for uint256;
1077 
1078   //enum EquipmentPart {Weapon ,Head,Coat,Pants ,Shoes }
1079   //enum EquipmentRareness {White,Green,Blue,Purple, Orange,Red }
1080 
1081   // Equipment in pool
1082   struct Equipment {
1083     string key;
1084     uint weight;
1085     uint[] randomKeyIds; 
1086     uint maxCnt;
1087   }
1088 
1089 
1090 
1091 
1092   mapping(uint256 => uint256 ) equipsCurrCnt;
1093 
1094   Equipment[] private equips;
1095   uint256 TotalEquipNum; // for ERC721
1096 
1097   IRandomBuffValue  insRandomBuff;
1098   //keyid -> value->weight
1099 
1100   constructor(address insRandomBuffAddr) public{
1101     insRandomBuff = IRandomBuffValue(insRandomBuffAddr);
1102   }
1103 
1104   function getRandomEquipment(uint256 seed) public view returns(uint blockNo,string memory ekey,uint[] memory randomProps)  {
1105     uint TotalWeight = _getTotalWeight();
1106     require(TotalWeight>0);
1107     uint random = getRandom(seed);
1108     uint equipIndex = getRandomEquipIndexByWeight(  random % TotalWeight  + 1) ;
1109     //ensure equipment index
1110     Equipment memory  equip =  equips[equipIndex];
1111 
1112     //ensure random values
1113     randomProps = new uint[](equip.randomKeyIds.length);
1114     for(uint i=0;i< randomProps.length ; i++) {
1115       uint keyid = equip.randomKeyIds[i] ;
1116       uint rv = insRandomBuff.randomValue(keyid,  (random >>i ) );
1117       randomProps[i] = rv;
1118     }
1119     blockNo = block.number;
1120     ekey = equip.key;
1121   }
1122 
1123 
1124   function getRandom(uint256 seed) internal view returns (uint256){
1125     return uint256(keccak256(abi.encodePacked(block.timestamp, seed,block.difficulty)));
1126   }
1127 
1128 
1129 
1130   function addEquipToPool(string memory key,uint[] memory randomKeyIds,uint weight,uint maxCnt) public  onlyOwner{
1131     _addEquipToPool(key,randomKeyIds,weight,maxCnt);
1132   }
1133 
1134 
1135   //config end
1136   function getCurrentQty() public view returns( uint[] memory ukeys,uint[] memory maxCnt,uint[] memory currentCnt ){
1137     ukeys = new uint[](TotalEquipNum);
1138     maxCnt = new uint[](TotalEquipNum);
1139     currentCnt = new uint[](TotalEquipNum);
1140 
1141     for (uint i = 0;i < TotalEquipNum ; i++){
1142       uint ukey = uint256(keccak256(abi.encodePacked(bytes(equips[i].key))));
1143       ukeys[i] =  ukey;
1144       maxCnt[i] = equips[i].maxCnt;
1145       currentCnt[i] = equipsCurrCnt[ukey];
1146     }
1147   }
1148 
1149   //config end
1150   function getEquipmentConf(uint equipIndex) public view returns( string memory key,uint weight,uint[] memory randomKeyIds){
1151     Equipment memory  equip =  equips[equipIndex];
1152     key = equip.key;
1153     weight = equip.weight;
1154     randomKeyIds = equip.randomKeyIds;
1155   }
1156 
1157 
1158   function getRandomEquipIndexByWeight( uint weight ) internal view returns (uint) {
1159     uint TotalWeight = _getTotalWeight();
1160     require( weight <= TotalWeight );
1161     uint sum ;
1162     for (uint i = 0;i < TotalEquipNum ; i++){
1163      uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(equips[i].key))));
1164      if (equips[i].maxCnt > equipsCurrCnt[ uintkey ]) {
1165         sum += equips[i].weight;
1166         if( weight  <=  sum ){
1167           return i;
1168         }
1169      }
1170     }
1171     return TotalEquipNum -1 ;
1172   }
1173 
1174 
1175   function _addEquipToPool(string memory key,uint[] memory randomKeyIds,uint weight,uint maxCnt) internal {
1176     Equipment memory newEquip = Equipment({
1177       key : key,
1178       randomKeyIds : randomKeyIds,
1179       weight : weight,
1180       maxCnt : maxCnt
1181     });
1182     equips.push(newEquip);
1183     TotalEquipNum = TotalEquipNum.add(1);
1184   }
1185 
1186 
1187   function _incrCurrentEquipCnt(string memory key) internal {
1188      uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(key))));
1189      equipsCurrCnt[uintkey] = equipsCurrCnt[uintkey]  + 1;
1190   }
1191 
1192   function _getTotalWeight( ) internal view returns(uint) {
1193     uint res = 0;
1194     for (uint i = 0;i < TotalEquipNum ; i++){
1195      uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(equips[i].key))));
1196      if (equips[i].maxCnt > equipsCurrCnt[ uintkey ]) {
1197        res += equips[i].weight;
1198      }
1199     }
1200     return res;
1201   }
1202 
1203 }
1204 
1205 contract SuperPlayerGachaWithRecommendReward  is Ownable  {
1206 
1207   mapping(uint=> address) recommendRecord;
1208 
1209 
1210   function addRecommend(string memory key,address payable to ) public  onlyOwner{
1211      uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(key))));
1212      recommendRecord[uintkey] = to;
1213   }
1214 
1215 
1216   function getRecommendAddress( string memory key ) public view returns(address) {
1217     return _getRecommendAddress(key);
1218   }
1219 
1220   function _getRecommendAddress( string memory key ) internal view returns(address) {
1221      uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(key))));
1222      return recommendRecord[uintkey];
1223   }
1224 
1225 
1226 
1227 }
1228 
1229 contract SuperPlayerGachaTest  is SuperplayerRandomEquipmentBase ,SuperPlayerGachaWithRecommendReward{
1230 
1231   using SafeMath for uint256;
1232 
1233   uint256 recommendRatio = 3000; //base 10000
1234   event Draw(string key);
1235 
1236   constructor(address insRandomBuffAddr) SuperplayerRandomEquipmentBase(insRandomBuffAddr) public{
1237 
1238     feeForOne = 66 finney ;
1239     feeForTen = 594 finney;
1240   }
1241 
1242   uint256  public feeForOne;
1243   uint256 public feeForTen;
1244 
1245 
1246 
1247 
1248   function gacha (uint seed,string memory from) public payable  {
1249      require( msg.value >= feeForOne );
1250      uint blockNo;
1251      string memory key;
1252      uint[] memory equips;
1253      (blockNo,  key,  equips)  = this.getRandomEquipment(seed );
1254    //  spIns.createEquip(msg.sender,key,equips,extraProps);
1255    emit Draw(key);
1256      //return back
1257     _incrCurrentEquipCnt(key);
1258 
1259 
1260      //return back
1261      msg.sender.transfer(msg.value.sub(feeForOne));
1262 
1263      //give recommend reward
1264      address payable recommendAddress = address(uint160(_getRecommendAddress(from)));
1265      if(recommendAddress != address(0)) {
1266        recommendAddress.transfer( feeForOne.mul(recommendRatio).div(10000));
1267      }
1268 
1269   }
1270 
1271   function gacha10 (uint seed,string memory from) public payable  {
1272      require( msg.value >= feeForTen );
1273      uint blockNo;
1274      string memory key;
1275      uint[] memory equips;
1276      for (uint i=0 ;i<10;++i) {
1277       (blockNo,  key,  equips)  = this.getRandomEquipment(seed+i );
1278      // spIns.createEquip(msg.sender,key,equips,extraProps);
1279       _incrCurrentEquipCnt(key);
1280       emit Draw(key);
1281 
1282      }
1283      //return back
1284     // msg.sender.transfer(msg.value.sub(feeForTen));
1285 
1286      //give recommend reward
1287      address payable recommendAddress = address(uint160(_getRecommendAddress(from)));
1288      if(recommendAddress != address(0)) {
1289        recommendAddress.transfer( feeForTen.mul(recommendRatio).div(10000));
1290      }
1291   }
1292 
1293   function withdraw( address payable to )  public onlyOwner{
1294     require(to == msg.sender); //to == msg.sender == _owner
1295     to.transfer((address(this).balance ));
1296   }
1297 }
1298 
1299 // File: contracts/eth_superplayer_nft.sol
1300 
1301 pragma solidity ^0.5.0;
1302 
1303 
1304 
1305 
1306 
1307 
1308 /*
1309 
1310 
1311 
1312 
1313 
1314 */
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 /**
1323  * @title Whitelist
1324  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1325  * @dev This simplifies the implementation of "user permissions".
1326  */
1327 contract EquipGeneratorWhitelist is Ownable {
1328   mapping(address => string) public whitelist;
1329   mapping(string => address)  cat2address;
1330 
1331   event WhitelistedAddressAdded(address addr,string category);
1332   event WhitelistedAddressRemoved(address addr);
1333 
1334   /**
1335    * @dev Throws if called by any account that's not whitelisted.
1336    */
1337   modifier canGenerate() {
1338     //require(keccak256(whitelist[msg.sender]) == keccak256(category));
1339     require(bytes(whitelist[msg.sender]).length >0 );
1340     _;
1341   }
1342 
1343   /**
1344    * @dev add an address to the whitelist
1345    * @param addr address
1346    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1347    */
1348   function addAddressToWhitelist(address addr,string memory category) onlyOwner internal returns(bool success) {
1349     require( bytes(category).length > 0 );
1350     if (bytes(whitelist[addr]).length == 0) {
1351       require( cat2address[category] == address(0));
1352       whitelist[addr] = category;
1353       emit WhitelistedAddressAdded(addr,category);
1354       success = true;
1355     }
1356   }
1357 
1358 
1359   /**
1360    * @dev remove an address from the whitelist
1361    * @param addr address
1362    * @return true if the address was removed from the whitelist,
1363    * false if the address wasn't in the whitelist in the first place
1364    */
1365   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
1366     string storage category = whitelist[addr];
1367     if (bytes(category).length != 0) {
1368       delete cat2address[category] ;
1369       delete whitelist[addr]  ;
1370       emit WhitelistedAddressRemoved(addr);
1371       success = true;
1372     }
1373   }
1374 
1375 
1376 
1377 }
1378 
1379 
1380 
1381 contract SuperplayerEquipmentInterface {
1382   function createEquip(address to, string memory key, uint[] memory randomProps )  public returns(uint256);
1383 }
1384 
1385 contract SuperplayerRandomEquipmentInterface {
1386   function getRandomEquipment(uint256 seed) public view returns(uint blockNo,string memory ekey,uint[] memory randomProps) ;
1387 }
1388 
1389    
1390 contract SuperplayerEquipmentV001 is EquipGeneratorWhitelist,ERC721 ,ERC721Metadata("SuperPlayerEquipment","SPE") {
1391 
1392   using SafeMath for uint256;
1393 
1394   enum EquipmentPart {Weapon ,Head,Coat,Pants ,Shoes ,Bag}
1395   enum EquipmentRareness {Blue,Purple, Orange,Red }
1396 
1397   struct Equipment {
1398     string key; //using key to contains part and rareness format : rareness_part_name
1399 //    EquipmentPart part;
1400  //   EquipmentRareness rareness;
1401     uint[] randomProperties;
1402     uint[] advancedProperties; //for equipment enhance
1403   }
1404 
1405 
1406 
1407   event Birth(address where,uint256 tokenId , string key,  uint[] randomProps);
1408   event GetAdvancedProperties(address where,uint256 tokenId,uint[] advancedProps);
1409 
1410 
1411   mapping (uint256 => uint256) private typeLimitsMap;
1412   mapping (uint256 => uint256) private typeCurrCntMap;
1413 
1414   uint256 TotalEquipNum; // for ERC721
1415 
1416 
1417   Equipment[] private equips;
1418 
1419   constructor() public{
1420 
1421   }
1422 
1423   function totalSupply() public view returns (uint) {
1424     return TotalEquipNum;
1425   }
1426 
1427   function addEquipmentGenerator(address addr, string memory category) onlyOwner public returns(bool success){
1428     return addAddressToWhitelist(addr,category);
1429   }
1430 
1431   function removeEquipmentGenerator(address addr) onlyOwner public returns(bool success){
1432     return removeAddressFromWhitelist(addr);
1433   }
1434 
1435   function setLimit(string memory key, uint256 limit) onlyOwner public {
1436     uint256 uintkey =  uint256(keccak256(abi.encodePacked(bytes(key))));
1437     //only can set once
1438     require( typeLimitsMap[uintkey] == uint256(0) ) ;
1439     typeLimitsMap[ uintkey ] = limit;
1440   }
1441 
1442   function setLimits(uint256[] memory uintkeys, uint256[] memory limits) onlyOwner public {
1443     require(uintkeys.length == limits.length);
1444     uint len = uintkeys.length;
1445     for (uint i = 0;i < len ; i++){
1446     //only can set once
1447       uint256 uintkey = uintkeys[i];
1448       if( typeLimitsMap[ uintkey]  == 0 ) {
1449         typeLimitsMap[ uintkey ] = limits[i];
1450       }
1451     }
1452   }
1453 
1454 
1455 
1456   function getLimit(string memory key)  public view returns(uint256 current, uint256 limit){
1457     uint256 uintkey = uint256(keccak256(abi.encodePacked(bytes(key))));
1458     current = typeCurrCntMap[uintkey];
1459     limit = typeLimitsMap[uintkey];
1460   }
1461 
1462   /*
1463    * This privilege should transfer to the community nodes ,but as the beginning,our team control it for game's quickly  iteration
1464    */
1465   function createEquip(address to, string memory key, uint[] memory randomProps) canGenerate public returns(uint256){
1466     uint256 uintkey =  uint256(keccak256(abi.encodePacked(bytes(key))));
1467     uint256 currentTypCnt = typeCurrCntMap[uintkey]; 
1468 
1469     // limit checkt
1470     require(currentTypCnt < typeLimitsMap[uintkey]) ;
1471 
1472     uint[] memory emptyProps = new uint[](0); 
1473     Equipment memory newEquip = Equipment({
1474       key : key,
1475       randomProperties : randomProps,
1476       advancedProperties : emptyProps
1477     });
1478     TotalEquipNum = TotalEquipNum.add(1);
1479     uint256 newEquipId = equips.push(newEquip).sub(1);
1480     emit Birth(msg.sender,newEquipId,key,randomProps);
1481     _mint(to,newEquipId);
1482 
1483     typeCurrCntMap[uintkey] =  currentTypCnt + 1;
1484 
1485     return newEquipId;
1486   }
1487 
1488 
1489   function accquireAdvancedProps(uint256 tokenId,uint[] memory advancedProps) canGenerate public  {
1490     require(tokenId < TotalEquipNum );
1491     require( _isApprovedOrOwner( msg.sender,tokenId));
1492     Equipment storage equip = equips[tokenId];
1493     equip.advancedProperties = advancedProps;
1494   }
1495 
1496   function getEquip(uint256 idx) public view returns(
1497     string memory key,
1498     uint[] memory randomProps,
1499     uint[] memory advancedProperties
1500   ){
1501       require(idx < TotalEquipNum);
1502       Equipment storage equip = equips[idx];
1503       key = equip.key;
1504       randomProps = equip.randomProperties;
1505       advancedProperties = equip.advancedProperties;
1506   }
1507 }
1508 
1509 
1510 
1511 
1512 /*
1513  * 
1514  */
1515 
1516 // File: contracts/eth_superplayer_v001.sol
1517 
1518 pragma solidity ^0.5.0;
1519 
1520 
1521 
1522 
1523 
1524 
1525 
1526 contract SuperplayerRandomValueV001 is SuperplayerRandomValueBase {
1527 
1528   // config
1529   function initRtables1() public  onlyOwner{
1530     _initRtables1();
1531   }
1532   function initRtables2() public  onlyOwner{
1533     _initRtables2();
1534   }
1535   function initRtables3() public  onlyOwner{
1536     _initRtables3();
1537   }
1538 
1539 
1540 
1541   function _initRtables1 () internal {
1542 
1543 uint[] memory v112 = new uint[](7);
1544 uint[] memory w112  = new uint[](7);
1545 v112[0]= 1001; w112[0]=40;
1546 v112[1]= 1005; w112[1]=10;
1547 v112[2]= 1006; w112[2]=10;
1548 v112[3]= 1008; w112[3]=10;
1549 v112[4]= 1009; w112[4]=10;
1550 v112[5]= 1010; w112[5]=10;
1551 v112[6]= 1007; w112[6]=10;
1552 _addRandomValuesforRTable(112,v112,w112);
1553 
1554 uint[] memory v144 = new uint[](7);
1555 uint[] memory w144  = new uint[](7);
1556 v144[0]= 1001; w144[0]=15;
1557 v144[1]= 1005; w144[1]=5;
1558 v144[2]= 1006; w144[2]=5;
1559 v144[3]= 1008; w144[3]=5;
1560 v144[4]= 1009; w144[4]=5;
1561 v144[5]= 1010; w144[5]=60;
1562 v144[6]= 1007; w144[6]=5;
1563 _addRandomValuesforRTable(144,v144,w144);
1564 
1565 uint[] memory v243 = new uint[](8);
1566 uint[] memory w243  = new uint[](8);
1567 v243[0]= 2002; w243[0]=12;
1568 v243[1]= 2003; w243[1]=8;
1569 v243[2]= 2004; w243[2]=5;
1570 v243[3]= 2001; w243[3]=13;
1571 v243[4]= 2008; w243[4]=6;
1572 v243[5]= 2007; w243[5]=6;
1573 v243[6]= 2005; w243[6]=30;
1574 v243[7]= 2006; w243[7]=20;
1575 _addRandomValuesforRTable(243,v243,w243);
1576 
1577 uint[] memory v114 = new uint[](7);
1578 uint[] memory w114  = new uint[](7);
1579 v114[0]= 1001; w114[0]=30;
1580 v114[1]= 1005; w114[1]=10;
1581 v114[2]= 1006; w114[2]=10;
1582 v114[3]= 1008; w114[3]=10;
1583 v114[4]= 1009; w114[4]=10;
1584 v114[5]= 1010; w114[5]=20;
1585 v114[6]= 1007; w114[6]=10;
1586 _addRandomValuesforRTable(114,v114,w114);
1587 
1588 uint[] memory v121 = new uint[](6);
1589 uint[] memory w121  = new uint[](6);
1590 v121[0]= 1001; w121[0]=14;
1591 v121[1]= 1002; w121[1]=40;
1592 v121[2]= 1003; w121[2]=10;
1593 v121[3]= 1008; w121[3]=12;
1594 v121[4]= 1009; w121[4]=12;
1595 v121[5]= 1010; w121[5]=12;
1596 _addRandomValuesforRTable(121,v121,w121);
1597 
1598 uint[] memory v123 = new uint[](7);
1599 uint[] memory w123  = new uint[](7);
1600 v123[0]= 1001; w123[0]=30;
1601 v123[1]= 1005; w123[1]=10;
1602 v123[2]= 1006; w123[2]=10;
1603 v123[3]= 1008; w123[3]=13;
1604 v123[4]= 1009; w123[4]=12;
1605 v123[5]= 1010; w123[5]=13;
1606 v123[6]= 1007; w123[6]=12;
1607 _addRandomValuesforRTable(123,v123,w123);
1608 
1609 uint[] memory v132 = new uint[](7);
1610 uint[] memory w132  = new uint[](7);
1611 v132[0]= 1001; w132[0]=50;
1612 v132[1]= 1005; w132[1]=9;
1613 v132[2]= 1006; w132[2]=9;
1614 v132[3]= 1008; w132[3]=8;
1615 v132[4]= 1009; w132[4]=8;
1616 v132[5]= 1010; w132[5]=8;
1617 v132[6]= 1007; w132[6]=8;
1618 _addRandomValuesforRTable(132,v132,w132);
1619 
1620 uint[] memory v244 = new uint[](7);
1621 uint[] memory w244  = new uint[](7);
1622 v244[0]= 2002; w244[0]=12;
1623 v244[1]= 2003; w244[1]=8;
1624 v244[2]= 2004; w244[2]=5;
1625 v244[3]= 2001; w244[3]=15;
1626 v244[4]= 2008; w244[4]=10;
1627 v244[5]= 2007; w244[5]=10;
1628 v244[6]= 2010; w244[6]=40;
1629 _addRandomValuesforRTable(244,v244,w244);
1630 
1631 uint[] memory v212 = new uint[](8);
1632 uint[] memory w212  = new uint[](8);
1633 v212[0]= 2002; w212[0]=30;
1634 v212[1]= 2003; w212[1]=10;
1635 v212[2]= 2004; w212[2]=10;
1636 v212[3]= 2001; w212[3]=30;
1637 v212[4]= 2008; w212[4]=5;
1638 v212[5]= 2007; w212[5]=5;
1639 v212[6]= 2009; w212[6]=5;
1640 v212[7]= 2005; w212[7]=5;
1641 _addRandomValuesforRTable(212,v212,w212);
1642 
1643 uint[] memory v145 = new uint[](7);
1644 uint[] memory w145  = new uint[](7);
1645 v145[0]= 1001; w145[0]=15;
1646 v145[1]= 1005; w145[1]=5;
1647 v145[2]= 1006; w145[2]=5;
1648 v145[3]= 1008; w145[3]=5;
1649 v145[4]= 1009; w145[4]=60;
1650 v145[5]= 1010; w145[5]=5;
1651 v145[6]= 1007; w145[6]=5;
1652 _addRandomValuesforRTable(145,v145,w145);
1653 
1654   }
1655 
1656   function _initRtables2 () internal {
1657 
1658 
1659 uint[] memory v221 = new uint[](6);
1660 uint[] memory w221  = new uint[](6);
1661 v221[0]= 2002; w221[0]=35;
1662 v221[1]= 2003; w221[1]=12;
1663 v221[2]= 2004; w221[2]=13;
1664 v221[3]= 2001; w221[3]=20;
1665 v221[4]= 2008; w221[4]=10;
1666 v221[5]= 2007; w221[5]=10;
1667 _addRandomValuesforRTable(221,v221,w221);
1668 
1669 uint[] memory v232 = new uint[](8);
1670 uint[] memory w232  = new uint[](8);
1671 v232[0]= 2002; w232[0]=15;
1672 v232[1]= 2003; w232[1]=8;
1673 v232[2]= 2004; w232[2]=7;
1674 v232[3]= 2001; w232[3]=34;
1675 v232[4]= 2008; w232[4]=9;
1676 v232[5]= 2007; w232[5]=9;
1677 v232[6]= 2009; w232[6]=9;
1678 v232[7]= 2005; w232[7]=9;
1679 _addRandomValuesforRTable(232,v232,w232);
1680 
1681 uint[] memory v242 = new uint[](8);
1682 uint[] memory w242  = new uint[](8);
1683 v242[0]= 2002; w242[0]=12;
1684 v242[1]= 2003; w242[1]=8;
1685 v242[2]= 2004; w242[2]=5;
1686 v242[3]= 2001; w242[3]=35;
1687 v242[4]= 2008; w242[4]=10;
1688 v242[5]= 2007; w242[5]=10;
1689 v242[6]= 2009; w242[6]=10;
1690 v242[7]= 2005; w242[7]=10;
1691 _addRandomValuesforRTable(242,v242,w242);
1692 
1693 uint[] memory v124 = new uint[](7);
1694 uint[] memory w124  = new uint[](7);
1695 v124[0]= 1001; w124[0]=30;
1696 v124[1]= 1005; w124[1]=10;
1697 v124[2]= 1006; w124[2]=10;
1698 v124[3]= 1008; w124[3]=10;
1699 v124[4]= 1009; w124[4]=10;
1700 v124[5]= 1010; w124[5]=20;
1701 v124[6]= 1007; w124[6]=10;
1702 _addRandomValuesforRTable(124,v124,w124);
1703 
1704 uint[] memory v131 = new uint[](6);
1705 uint[] memory w131  = new uint[](6);
1706 v131[0]= 1001; w131[0]=10;
1707 v131[1]= 1002; w131[1]=40;
1708 v131[2]= 1002; w131[2]=20;
1709 v131[3]= 1008; w131[3]=10;
1710 v131[4]= 1009; w131[4]=10;
1711 v131[5]= 1010; w131[5]=10;
1712 _addRandomValuesforRTable(131,v131,w131);
1713 
1714 uint[] memory v135 = new uint[](7);
1715 uint[] memory w135  = new uint[](7);
1716 v135[0]= 1001; w135[0]=20;
1717 v135[1]= 1005; w135[1]=8;
1718 v135[2]= 1006; w135[2]=8;
1719 v135[3]= 1008; w135[3]=8;
1720 v135[4]= 1009; w135[4]=40;
1721 v135[5]= 1010; w135[5]=8;
1722 v135[6]= 1007; w135[6]=8;
1723 _addRandomValuesforRTable(135,v135,w135);
1724 
1725 uint[] memory v231 = new uint[](6);
1726 uint[] memory w231  = new uint[](6);
1727 v231[0]= 2002; w231[0]=40;
1728 v231[1]= 2003; w231[1]=15;
1729 v231[2]= 2004; w231[2]=15;
1730 v231[3]= 2001; w231[3]=15;
1731 v231[4]= 2008; w231[4]=7;
1732 v231[5]= 2007; w231[5]=8;
1733 _addRandomValuesforRTable(231,v231,w231);
1734 
1735 uint[] memory v141 = new uint[](6);
1736 uint[] memory w141  = new uint[](6);
1737 v141[0]= 1001; w141[0]=10;
1738 v141[1]= 1002; w141[1]=45;
1739 v141[2]= 1002; w141[2]=25;
1740 v141[3]= 1008; w141[3]=7;
1741 v141[4]= 1009; w141[4]=7;
1742 v141[5]= 1010; w141[5]=6;
1743 _addRandomValuesforRTable(141,v141,w141);
1744 
1745 uint[] memory v142 = new uint[](7);
1746 uint[] memory w142  = new uint[](7);
1747 v142[0]= 1001; w142[0]=60;
1748 v142[1]= 1005; w142[1]=7;
1749 v142[2]= 1006; w142[2]=7;
1750 v142[3]= 1008; w142[3]=7;
1751 v142[4]= 1009; w142[4]=7;
1752 v142[5]= 1010; w142[5]=6;
1753 v142[6]= 1007; w142[6]=6;
1754 _addRandomValuesforRTable(142,v142,w142);
1755 
1756 uint[] memory v111 = new uint[](6);
1757 uint[] memory w111  = new uint[](6);
1758 v111[0]= 1001; w111[0]=14;
1759 v111[1]= 1002; w111[1]=40;
1760 v111[2]= 1003; w111[2]=10;
1761 v111[3]= 1008; w111[3]=12;
1762 v111[4]= 1009; w111[4]=12;
1763 v111[5]= 1010; w111[5]=12;
1764 _addRandomValuesforRTable(111,v111,w111);
1765 
1766   }
1767 
1768   function _initRtables3 () internal {
1769 
1770 
1771 uint[] memory v113 = new uint[](7);
1772 uint[] memory w113  = new uint[](7);
1773 v113[0]= 1001; w113[0]=30;
1774 v113[1]= 1005; w113[1]=10;
1775 v113[2]= 1006; w113[2]=10;
1776 v113[3]= 1008; w113[3]=13;
1777 v113[4]= 1009; w113[4]=12;
1778 v113[5]= 1010; w113[5]=13;
1779 v113[6]= 1007; w113[6]=12;
1780 _addRandomValuesforRTable(113,v113,w113);
1781 
1782 uint[] memory v115 = new uint[](7);
1783 uint[] memory w115  = new uint[](7);
1784 v115[0]= 1001; w115[0]=30;
1785 v115[1]= 1005; w115[1]=10;
1786 v115[2]= 1006; w115[2]=10;
1787 v115[3]= 1008; w115[3]=20;
1788 v115[4]= 1009; w115[4]=10;
1789 v115[5]= 1010; w115[5]=10;
1790 v115[6]= 1007; w115[6]=10;
1791 _addRandomValuesforRTable(115,v115,w115);
1792 
1793 uint[] memory v222 = new uint[](8);
1794 uint[] memory w222  = new uint[](8);
1795 v222[0]= 2002; w222[0]=20;
1796 v222[1]= 2003; w222[1]=10;
1797 v222[2]= 2004; w222[2]=10;
1798 v222[3]= 2001; w222[3]=32;
1799 v222[4]= 2008; w222[4]=7;
1800 v222[5]= 2007; w222[5]=7;
1801 v222[6]= 2009; w222[6]=7;
1802 v222[7]= 2005; w222[7]=7;
1803 _addRandomValuesforRTable(222,v222,w222);
1804 
1805 uint[] memory v245 = new uint[](7);
1806 uint[] memory w245  = new uint[](7);
1807 v245[0]= 2002; w245[0]=12;
1808 v245[1]= 2003; w245[1]=8;
1809 v245[2]= 2004; w245[2]=5;
1810 v245[3]= 2001; w245[3]=15;
1811 v245[4]= 2008; w245[4]=10;
1812 v245[5]= 2007; w245[5]=10;
1813 v245[6]= 2009; w245[6]=40;
1814 _addRandomValuesforRTable(245,v245,w245);
1815 
1816 uint[] memory v133 = new uint[](7);
1817 uint[] memory w133  = new uint[](7);
1818 v133[0]= 1001; w133[0]=8;
1819 v133[1]= 1005; w133[1]=40;
1820 v133[2]= 1006; w133[2]=20;
1821 v133[3]= 1008; w133[3]=8;
1822 v133[4]= 1009; w133[4]=8;
1823 v133[5]= 1010; w133[5]=8;
1824 v133[6]= 1007; w133[6]=8;
1825 _addRandomValuesforRTable(133,v133,w133);
1826 
1827 uint[] memory v134 = new uint[](7);
1828 uint[] memory w134  = new uint[](7);
1829 v134[0]= 1001; w134[0]=20;
1830 v134[1]= 1005; w134[1]=8;
1831 v134[2]= 1006; w134[2]=8;
1832 v134[3]= 1008; w134[3]=8;
1833 v134[4]= 1009; w134[4]=8;
1834 v134[5]= 1010; w134[5]=40;
1835 v134[6]= 1007; w134[6]=8;
1836 _addRandomValuesforRTable(134,v134,w134);
1837 
1838 uint[] memory v241 = new uint[](6);
1839 uint[] memory w241  = new uint[](6);
1840 v241[0]= 2002; w241[0]=50;
1841 v241[1]= 2003; w241[1]=15;
1842 v241[2]= 2004; w241[2]=15;
1843 v241[3]= 2001; w241[3]=10;
1844 v241[4]= 2008; w241[4]=5;
1845 v241[5]= 2007; w241[5]=5;
1846 _addRandomValuesforRTable(241,v241,w241);
1847 
1848 uint[] memory v122 = new uint[](7);
1849 uint[] memory w122  = new uint[](7);
1850 v122[0]= 1001; w122[0]=40;
1851 v122[1]= 1005; w122[1]=10;
1852 v122[2]= 1006; w122[2]=10;
1853 v122[3]= 1008; w122[3]=10;
1854 v122[4]= 1009; w122[4]=10;
1855 v122[5]= 1010; w122[5]=10;
1856 v122[6]= 1007; w122[6]=1;
1857 _addRandomValuesforRTable(122,v122,w122);
1858 
1859 uint[] memory v125 = new uint[](7);
1860 uint[] memory w125  = new uint[](7);
1861 v125[0]= 1001; w125[0]=30;
1862 v125[1]= 1005; w125[1]=10;
1863 v125[2]= 1006; w125[2]=10;
1864 v125[3]= 1008; w125[3]=20;
1865 v125[4]= 1009; w125[4]=10;
1866 v125[5]= 1010; w125[5]=10;
1867 v125[6]= 1007; w125[6]=10;
1868 _addRandomValuesforRTable(125,v125,w125);
1869 
1870 uint[] memory v211 = new uint[](6);
1871 uint[] memory w211  = new uint[](6);
1872 v211[0]= 2002; w211[0]=30;
1873 v211[1]= 2003; w211[1]=10;
1874 v211[2]= 2004; w211[2]=10;
1875 v211[3]= 2001; w211[3]=30;
1876 v211[4]= 2008; w211[4]=10;
1877 v211[5]= 2007; w211[5]=10;
1878 _addRandomValuesforRTable(211,v211,w211);
1879 
1880 uint[] memory v143 = new uint[](7);
1881 uint[] memory w143  = new uint[](7);
1882 v143[0]= 1001; w143[0]=8;
1883 v143[1]= 1005; w143[1]=45;
1884 v143[2]= 1006; w143[2]=25;
1885 v143[3]= 1008; w143[3]=6;
1886 v143[4]= 1009; w143[4]=6;
1887 v143[5]= 1010; w143[5]=5;
1888 v143[6]= 1007; w143[6]=5;
1889 _addRandomValuesforRTable(143,v143,w143);
1890   }
1891 
1892 
1893 
1894 
1895 
1896 
1897 
1898 
1899 }
1900 
1901 
1902 
1903 contract SuperplayerRandomEquipmentV001  is SuperplayerRandomEquipmentBase{
1904 
1905 
1906   constructor(address insRandomBuffAddr) SuperplayerRandomEquipmentBase(insRandomBuffAddr) public{
1907 
1908   }
1909 
1910 
1911 
1912   function initEquipmentPools() public  onlyOwner{
1913     _initEquipmentPools();
1914   }
1915 
1916   function _initEquipmentPools () internal {
1917 
1918 
1919 uint[] memory ppurple_shoes_range_nft = new uint[](6);
1920 ppurple_shoes_range_nft[0] = 244;
1921 ppurple_shoes_range_nft[1] = 244;
1922 ppurple_shoes_range_nft[2] = 244;
1923 ppurple_shoes_range_nft[3] = 244;
1924 ppurple_shoes_range_nft[4] = 244;
1925 ppurple_shoes_range_nft[5] = 244;
1926 _addEquipToPool("purple_shoes_range_nft",ppurple_shoes_range_nft,2300,40);
1927 
1928 
1929 uint[] memory pblue_weapon_gun_gray_shotgun = new uint[](4);
1930 pblue_weapon_gun_gray_shotgun[0] = 131;
1931 pblue_weapon_gun_gray_shotgun[1] = 131;
1932 pblue_weapon_gun_gray_shotgun[2] = 131;
1933 pblue_weapon_gun_gray_shotgun[3] = 131;
1934 _addEquipToPool("blue_weapon_gun_gray_shotgun",pblue_weapon_gun_gray_shotgun,5000,100);
1935 
1936 
1937 uint[] memory pblue_leg_hp = new uint[](5);
1938 pblue_leg_hp[0] = 231;
1939 pblue_leg_hp[1] = 231;
1940 pblue_leg_hp[2] = 231;
1941 pblue_leg_hp[3] = 231;
1942 pblue_leg_hp[4] = 231;
1943 _addEquipToPool("blue_leg_hp",pblue_leg_hp,10000,200);
1944 
1945 
1946 uint[] memory ppurple_weapon_gun_catapult_auto_eth = new uint[](5);
1947 ppurple_weapon_gun_catapult_auto_eth[0] = 142;
1948 ppurple_weapon_gun_catapult_auto_eth[1] = 142;
1949 ppurple_weapon_gun_catapult_auto_eth[2] = 142;
1950 ppurple_weapon_gun_catapult_auto_eth[3] = 142;
1951 ppurple_weapon_gun_catapult_auto_eth[4] = 142;
1952 _addEquipToPool("purple_weapon_gun_catapult_auto_eth",ppurple_weapon_gun_catapult_auto_eth,1000,20);
1953 
1954 
1955 uint[] memory pblue_weapongun_gun_sniper_laser = new uint[](4);
1956 pblue_weapongun_gun_sniper_laser[0] = 134;
1957 pblue_weapongun_gun_sniper_laser[1] = 134;
1958 pblue_weapongun_gun_sniper_laser[2] = 134;
1959 pblue_weapongun_gun_sniper_laser[3] = 134;
1960 _addEquipToPool("blue_weapongun_gun_sniper_laser",pblue_weapongun_gun_sniper_laser,5000,100);
1961 
1962 
1963 uint[] memory pblue_weapongun_gun_black_hand = new uint[](4);
1964 pblue_weapongun_gun_black_hand[0] = 135;
1965 pblue_weapongun_gun_black_hand[1] = 135;
1966 pblue_weapongun_gun_black_hand[2] = 135;
1967 pblue_weapongun_gun_black_hand[3] = 135;
1968 _addEquipToPool("blue_weapongun_gun_black_hand",pblue_weapongun_gun_black_hand,5000,100);
1969 
1970 
1971 uint[] memory pblue_leg_damage = new uint[](5);
1972 pblue_leg_damage[0] = 232;
1973 pblue_leg_damage[1] = 232;
1974 pblue_leg_damage[2] = 232;
1975 pblue_leg_damage[3] = 232;
1976 pblue_leg_damage[4] = 232;
1977 _addEquipToPool("blue_leg_damage",pblue_leg_damage,10000,200);
1978 
1979 
1980 uint[] memory pblue_helmet_hp = new uint[](5);
1981 pblue_helmet_hp[0] = 231;
1982 pblue_helmet_hp[1] = 231;
1983 pblue_helmet_hp[2] = 231;
1984 pblue_helmet_hp[3] = 231;
1985 pblue_helmet_hp[4] = 231;
1986 _addEquipToPool("blue_helmet_hp",pblue_helmet_hp,10000,200);
1987 
1988 
1989 uint[] memory pblue_helmet_damage = new uint[](5);
1990 pblue_helmet_damage[0] = 232;
1991 pblue_helmet_damage[1] = 232;
1992 pblue_helmet_damage[2] = 232;
1993 pblue_helmet_damage[3] = 232;
1994 pblue_helmet_damage[4] = 232;
1995 _addEquipToPool("blue_helmet_damage",pblue_helmet_damage,10000,200);
1996 
1997 
1998 uint[] memory ppurple_body_crit_nft = new uint[](6);
1999 ppurple_body_crit_nft[0] = 243;
2000 ppurple_body_crit_nft[1] = 243;
2001 ppurple_body_crit_nft[2] = 243;
2002 ppurple_body_crit_nft[3] = 243;
2003 ppurple_body_crit_nft[4] = 243;
2004 ppurple_body_crit_nft[5] = 243;
2005 _addEquipToPool("purple_body_crit_nft",ppurple_body_crit_nft,2300,40);
2006 
2007 
2008 uint[] memory ppurple_shoes_crit_nft = new uint[](6);
2009 ppurple_shoes_crit_nft[0] = 243;
2010 ppurple_shoes_crit_nft[1] = 243;
2011 ppurple_shoes_crit_nft[2] = 243;
2012 ppurple_shoes_crit_nft[3] = 243;
2013 ppurple_shoes_crit_nft[4] = 243;
2014 ppurple_shoes_crit_nft[5] = 243;
2015 _addEquipToPool("purple_shoes_crit_nft",ppurple_shoes_crit_nft,2300,40);
2016 
2017 
2018 uint[] memory ppurple_leg_range_nft = new uint[](6);
2019 ppurple_leg_range_nft[0] = 244;
2020 ppurple_leg_range_nft[1] = 244;
2021 ppurple_leg_range_nft[2] = 244;
2022 ppurple_leg_range_nft[3] = 244;
2023 ppurple_leg_range_nft[4] = 244;
2024 ppurple_leg_range_nft[5] = 244;
2025 _addEquipToPool("purple_leg_range_nft",ppurple_leg_range_nft,2300,40);
2026 
2027 
2028 uint[] memory ppurple_body_hp_nft = new uint[](6);
2029 ppurple_body_hp_nft[0] = 241;
2030 ppurple_body_hp_nft[1] = 241;
2031 ppurple_body_hp_nft[2] = 241;
2032 ppurple_body_hp_nft[3] = 241;
2033 ppurple_body_hp_nft[4] = 241;
2034 ppurple_body_hp_nft[5] = 241;
2035 _addEquipToPool("purple_body_hp_nft",ppurple_body_hp_nft,2300,40);
2036 
2037 
2038 uint[] memory pblue_weapon_gun_gray_sniper = new uint[](4);
2039 pblue_weapon_gun_gray_sniper[0] = 133;
2040 pblue_weapon_gun_gray_sniper[1] = 133;
2041 pblue_weapon_gun_gray_sniper[2] = 133;
2042 pblue_weapon_gun_gray_sniper[3] = 133;
2043 _addEquipToPool("blue_weapon_gun_gray_sniper",pblue_weapon_gun_gray_sniper,5000,100);
2044 
2045 
2046 uint[] memory pblue_shoes_damage = new uint[](5);
2047 pblue_shoes_damage[0] = 232;
2048 pblue_shoes_damage[1] = 232;
2049 pblue_shoes_damage[2] = 232;
2050 pblue_shoes_damage[3] = 232;
2051 pblue_shoes_damage[4] = 232;
2052 _addEquipToPool("blue_shoes_damage",pblue_shoes_damage,10000,200);
2053 
2054 
2055 uint[] memory pblue_body_hp = new uint[](5);
2056 pblue_body_hp[0] = 231;
2057 pblue_body_hp[1] = 231;
2058 pblue_body_hp[2] = 231;
2059 pblue_body_hp[3] = 231;
2060 pblue_body_hp[4] = 231;
2061 _addEquipToPool("blue_body_hp",pblue_body_hp,10000,200);
2062 
2063 
2064 uint[] memory pblue_shoes_hp = new uint[](5);
2065 pblue_shoes_hp[0] = 231;
2066 pblue_shoes_hp[1] = 231;
2067 pblue_shoes_hp[2] = 231;
2068 pblue_shoes_hp[3] = 231;
2069 pblue_shoes_hp[4] = 231;
2070 _addEquipToPool("blue_shoes_hp",pblue_shoes_hp,10000,200);
2071 
2072 
2073 uint[] memory ppurple_leg_hp_nft = new uint[](6);
2074 ppurple_leg_hp_nft[0] = 241;
2075 ppurple_leg_hp_nft[1] = 241;
2076 ppurple_leg_hp_nft[2] = 241;
2077 ppurple_leg_hp_nft[3] = 241;
2078 ppurple_leg_hp_nft[4] = 241;
2079 ppurple_leg_hp_nft[5] = 241;
2080 _addEquipToPool("purple_leg_hp_nft",ppurple_leg_hp_nft,2300,40);
2081 
2082 
2083 uint[] memory ppurple_shoes_hp_nft = new uint[](6);
2084 ppurple_shoes_hp_nft[0] = 241;
2085 ppurple_shoes_hp_nft[1] = 241;
2086 ppurple_shoes_hp_nft[2] = 241;
2087 ppurple_shoes_hp_nft[3] = 241;
2088 ppurple_shoes_hp_nft[4] = 241;
2089 ppurple_shoes_hp_nft[5] = 241;
2090 _addEquipToPool("purple_shoes_hp_nft",ppurple_shoes_hp_nft,2300,40);
2091 
2092 
2093 uint[] memory ppurple_leg_crit_nft = new uint[](6);
2094 ppurple_leg_crit_nft[0] = 243;
2095 ppurple_leg_crit_nft[1] = 243;
2096 ppurple_leg_crit_nft[2] = 243;
2097 ppurple_leg_crit_nft[3] = 243;
2098 ppurple_leg_crit_nft[4] = 243;
2099 ppurple_leg_crit_nft[5] = 243;
2100 _addEquipToPool("purple_leg_crit_nft",ppurple_leg_crit_nft,2300,40);
2101 
2102 
2103 uint[] memory ppurple_helmet_crit_nft = new uint[](6);
2104 ppurple_helmet_crit_nft[0] = 243;
2105 ppurple_helmet_crit_nft[1] = 243;
2106 ppurple_helmet_crit_nft[2] = 243;
2107 ppurple_helmet_crit_nft[3] = 243;
2108 ppurple_helmet_crit_nft[4] = 243;
2109 ppurple_helmet_crit_nft[5] = 243;
2110 _addEquipToPool("purple_helmet_crit_nft",ppurple_helmet_crit_nft,2300,40);
2111 
2112 
2113 uint[] memory ppurple_body_range_nft = new uint[](6);
2114 ppurple_body_range_nft[0] = 244;
2115 ppurple_body_range_nft[1] = 244;
2116 ppurple_body_range_nft[2] = 244;
2117 ppurple_body_range_nft[3] = 244;
2118 ppurple_body_range_nft[4] = 244;
2119 ppurple_body_range_nft[5] = 244;
2120 _addEquipToPool("purple_body_range_nft",ppurple_body_range_nft,2300,40);
2121 
2122 
2123 uint[] memory pblue_body_damage = new uint[](5);
2124 pblue_body_damage[0] = 232;
2125 pblue_body_damage[1] = 232;
2126 pblue_body_damage[2] = 232;
2127 pblue_body_damage[3] = 232;
2128 pblue_body_damage[4] = 232;
2129 _addEquipToPool("blue_body_damage",pblue_body_damage,10000,200);
2130 
2131 
2132 uint[] memory ppurple_weapon_gun_fire_eth = new uint[](5);
2133 ppurple_weapon_gun_fire_eth[0] = 141;
2134 ppurple_weapon_gun_fire_eth[1] = 141;
2135 ppurple_weapon_gun_fire_eth[2] = 141;
2136 ppurple_weapon_gun_fire_eth[3] = 141;
2137 ppurple_weapon_gun_fire_eth[4] = 141;
2138 _addEquipToPool("purple_weapon_gun_fire_eth",ppurple_weapon_gun_fire_eth,1000,20);
2139 
2140 
2141 uint[] memory ppurple_helmet_hp_nft = new uint[](6);
2142 ppurple_helmet_hp_nft[0] = 241;
2143 ppurple_helmet_hp_nft[1] = 241;
2144 ppurple_helmet_hp_nft[2] = 241;
2145 ppurple_helmet_hp_nft[3] = 241;
2146 ppurple_helmet_hp_nft[4] = 241;
2147 ppurple_helmet_hp_nft[5] = 241;
2148 _addEquipToPool("purple_helmet_hp_nft",ppurple_helmet_hp_nft,2300,40);
2149 
2150 
2151 uint[] memory ppurple_helmet_range_nft = new uint[](6);
2152 ppurple_helmet_range_nft[0] = 244;
2153 ppurple_helmet_range_nft[1] = 244;
2154 ppurple_helmet_range_nft[2] = 244;
2155 ppurple_helmet_range_nft[3] = 244;
2156 ppurple_helmet_range_nft[4] = 244;
2157 ppurple_helmet_range_nft[5] = 244;
2158 _addEquipToPool("purple_helmet_range_nft",ppurple_helmet_range_nft,2300,40);
2159 
2160 
2161 uint[] memory ppurple_weapon_gun_rocket_eth = new uint[](5);
2162 ppurple_weapon_gun_rocket_eth[0] = 144;
2163 ppurple_weapon_gun_rocket_eth[1] = 144;
2164 ppurple_weapon_gun_rocket_eth[2] = 144;
2165 ppurple_weapon_gun_rocket_eth[3] = 144;
2166 ppurple_weapon_gun_rocket_eth[4] = 144;
2167 _addEquipToPool("purple_weapon_gun_rocket_eth",ppurple_weapon_gun_rocket_eth,1000,20);
2168 
2169 
2170 uint[] memory pblue_weapon_gun_gray_auto = new uint[](4);
2171 pblue_weapon_gun_gray_auto[0] = 132;
2172 pblue_weapon_gun_gray_auto[1] = 132;
2173 pblue_weapon_gun_gray_auto[2] = 132;
2174 pblue_weapon_gun_gray_auto[3] = 132;
2175 _addEquipToPool("blue_weapon_gun_gray_auto",pblue_weapon_gun_gray_auto,5000,100);
2176 
2177 
2178   }
2179 
2180 
2181 }
2182 
2183 
2184 contract SuperPlayerGachaPresell  is SuperplayerRandomEquipmentV001 ,SuperPlayerGachaWithRecommendReward {
2185 
2186   using SafeMath for uint256;
2187   SuperplayerEquipmentInterface spIns;
2188 
2189   uint256 recommendRatio = 3000; //base 10000
2190 
2191   constructor(address equipAddr, address randomAddr) SuperplayerRandomEquipmentV001(randomAddr) public{
2192     spIns = SuperplayerEquipmentInterface(equipAddr);
2193 
2194     feeForOne = 66 finney ;
2195     feeForTen = 594 finney;
2196   }
2197 
2198   uint256  public feeForOne;
2199   uint256 public feeForTen;
2200 
2201 
2202 
2203 
2204   function gacha (uint seed,string memory from) public payable  {
2205      require( msg.value >= feeForOne );
2206      uint blockNo;
2207      string memory key;
2208      uint[] memory equips;
2209      (blockNo,  key,  equips)  = this.getRandomEquipment(seed );
2210      _incrCurrentEquipCnt(key);
2211      spIns.createEquip(msg.sender,key,equips);
2212      //return back
2213      msg.sender.transfer(msg.value.sub(feeForOne));
2214      //give recommend reward
2215      address payable recommendAddress = address(uint160(_getRecommendAddress(from)));
2216      if(recommendAddress != address(0)) {
2217        recommendAddress.transfer( feeForOne.mul(recommendRatio).div(10000));
2218      }
2219 
2220   }
2221 
2222   function gacha10 (uint seed,string memory from) public payable  {
2223      require( msg.value >= feeForTen );
2224      uint blockNo;
2225      string memory key;
2226      uint[] memory equips;
2227      for (uint i=0 ;i<10;++i) {
2228       (blockNo,  key,  equips)  = this.getRandomEquipment(seed+i );
2229       _incrCurrentEquipCnt(key);
2230       spIns.createEquip(msg.sender,key,equips);
2231      }
2232      msg.sender.transfer(msg.value.sub(feeForTen));
2233      //give recommend reward
2234      address payable recommendAddress = address(uint160(_getRecommendAddress(from)));
2235      if(recommendAddress != address(0)) {
2236        recommendAddress.transfer( feeForTen.mul(recommendRatio).div(10000));
2237      }
2238   }
2239 
2240 
2241   function withdraw( address payable to )  public onlyOwner{
2242     require(to == msg.sender); //to == msg.sender == _owner
2243     to.transfer((address(this).balance ));
2244   }
2245 
2246 }