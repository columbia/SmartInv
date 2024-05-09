1 pragma solidity ^0.5.0;
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
75  * @title ERC721 token receiver interface
76  * @dev Interface for any contract that wants to support safeTransfers
77  * from ERC721 asset contracts.
78  */
79 contract IERC721Receiver {
80     /**
81      * @notice Handle the receipt of an NFT
82      * @dev The ERC721 smart contract calls this function on the recipient
83      * after a `safeTransfer`. This function MUST return the function selector,
84      * otherwise the caller will revert the transaction. The selector to be
85      * returned can be obtained as `this.onERC721Received.selector`. This
86      * function MAY throw to revert and reject the transfer.
87      * Note: the ERC721 contract address is always the message sender.
88      * @param operator The address which called `safeTransferFrom` function
89      * @param from The address which previously owned the token
90      * @param tokenId The NFT identifier which is being transferred
91      * @param data Additional data with no specified format
92      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
93      */
94     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
95     public returns (bytes4);
96 }
97 
98 /**
99  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
100  * @dev See https://eips.ethereum.org/EIPS/eip-721
101  */
102 contract IERC721Metadata is IERC721 {
103     function name() external view returns (string memory);
104     function symbol() external view returns (string memory);
105     function tokenURI(uint256 tokenId) external view returns (string memory);
106 }
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         require(b <= a, "SafeMath: subtraction overflow");
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, "SafeMath: division by zero");
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b != 0, "SafeMath: modulo by zero");
210         return a % b;
211     }
212 }
213 
214 /**
215  * @dev Collection of functions related to the address type,
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * This test is non-exhaustive, and there may be false-negatives: during the
222      * execution of a contract's constructor, its address will be reported as
223      * not containing a contract.
224      *
225      * > It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies in extcodesize, which returns 0 for contracts in
230         // construction, since the code is only stored at the end of the
231         // constructor execution.
232 
233         uint256 size;
234         // solhint-disable-next-line no-inline-assembly
235         assembly { size := extcodesize(account) }
236         return size > 0;
237     }
238 }
239 
240 /**
241  * @title Counters
242  * @author Matt Condon (@shrugs)
243  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
244  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
245  *
246  * Include with `using Counters for Counters.Counter;`
247  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
248  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
249  * directly accessed.
250  */
251 library Counters {
252     using SafeMath for uint256;
253 
254     struct Counter {
255         // This variable should never be directly accessed by users of the library: interactions must be restricted to
256         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
257         // this feature: see https://github.com/ethereum/solidity/issues/4637
258         uint256 _value; // default: 0
259     }
260 
261     function current(Counter storage counter) internal view returns (uint256) {
262         return counter._value;
263     }
264 
265     function increment(Counter storage counter) internal {
266         counter._value += 1;
267     }
268 
269     function decrement(Counter storage counter) internal {
270         counter._value = counter._value.sub(1);
271     }
272 }
273 
274 /**
275  * @dev Implementation of the `IERC165` interface.
276  *
277  * Contracts may inherit from this and call `_registerInterface` to declare
278  * their support of an interface.
279  */
280 contract ERC165 is IERC165 {
281     /*
282      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
283      */
284     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
285 
286     /**
287      * @dev Mapping of interface ids to whether or not it's supported.
288      */
289     mapping(bytes4 => bool) private _supportedInterfaces;
290 
291     constructor () internal {
292         // Derived contracts need only register support for their own interfaces,
293         // we register support for ERC165 itself here
294         _registerInterface(_INTERFACE_ID_ERC165);
295     }
296 
297     /**
298      * @dev See `IERC165.supportsInterface`.
299      *
300      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
301      */
302     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
303         return _supportedInterfaces[interfaceId];
304     }
305 
306     /**
307      * @dev Registers the contract as an implementer of the interface defined by
308      * `interfaceId`. Support of the actual ERC165 interface is automatic and
309      * registering its interface id is not required.
310      *
311      * See `IERC165.supportsInterface`.
312      *
313      * Requirements:
314      *
315      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
316      */
317     function _registerInterface(bytes4 interfaceId) internal {
318         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
319         _supportedInterfaces[interfaceId] = true;
320     }
321 }
322 
323 /**
324  * @title ERC721 Non-Fungible Token Standard basic implementation
325  * @dev see https://eips.ethereum.org/EIPS/eip-721
326  */
327 contract ERC721 is ERC165, IERC721 {
328     using SafeMath for uint256;
329     using Address for address;
330     using Counters for Counters.Counter;
331 
332     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
333     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
334     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
335 
336     // Mapping from token ID to owner
337     mapping (uint256 => address) private _tokenOwner;
338 
339     // Mapping from token ID to approved address
340     mapping (uint256 => address) private _tokenApprovals;
341 
342     // Mapping from owner to number of owned token
343     mapping (address => Counters.Counter) private _ownedTokensCount;
344 
345     // Mapping from owner to operator approvals
346     mapping (address => mapping (address => bool)) private _operatorApprovals;
347 
348     /*
349      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
350      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
351      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
352      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
353      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
354      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
355      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
356      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
357      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
358      *
359      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
360      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
361      */
362     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
363 
364     constructor () public {
365         // register the supported interfaces to conform to ERC721 via ERC165
366         _registerInterface(_INTERFACE_ID_ERC721);
367     }
368 
369     /**
370      * @dev Gets the balance of the specified address.
371      * @param owner address to query the balance of
372      * @return uint256 representing the amount owned by the passed address
373      */
374     function balanceOf(address owner) public view returns (uint256) {
375         require(owner != address(0), "ERC721: balance query for the zero address");
376 
377         return _ownedTokensCount[owner].current();
378     }
379 
380     /**
381      * @dev Gets the owner of the specified token ID.
382      * @param tokenId uint256 ID of the token to query the owner of
383      * @return address currently marked as the owner of the given token ID
384      */
385     function ownerOf(uint256 tokenId) public view returns (address) {
386         address owner = _tokenOwner[tokenId];
387         require(owner != address(0), "ERC721: owner query for nonexistent token");
388 
389         return owner;
390     }
391 
392     /**
393      * @dev Approves another address to transfer the given token ID
394      * The zero address indicates there is no approved address.
395      * There can only be one approved address per token at a given time.
396      * Can only be called by the token owner or an approved operator.
397      * @param to address to be approved for the given token ID
398      * @param tokenId uint256 ID of the token to be approved
399      */
400     function approve(address to, uint256 tokenId) public {
401         address owner = ownerOf(tokenId);
402         require(to != owner, "ERC721: approval to current owner");
403 
404         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
405             "ERC721: approve caller is not owner nor approved for all"
406         );
407 
408         _tokenApprovals[tokenId] = to;
409         emit Approval(owner, to, tokenId);
410     }
411 
412     /**
413      * @dev Gets the approved address for a token ID, or zero if no address set
414      * Reverts if the token ID does not exist.
415      * @param tokenId uint256 ID of the token to query the approval of
416      * @return address currently approved for the given token ID
417      */
418     function getApproved(uint256 tokenId) public view returns (address) {
419         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
420 
421         return _tokenApprovals[tokenId];
422     }
423 
424     /**
425      * @dev Sets or unsets the approval of a given operator
426      * An operator is allowed to transfer all tokens of the sender on their behalf.
427      * @param to operator address to set the approval
428      * @param approved representing the status of the approval to be set
429      */
430     function setApprovalForAll(address to, bool approved) public {
431         require(to != msg.sender, "ERC721: approve to caller");
432 
433         _operatorApprovals[msg.sender][to] = approved;
434         emit ApprovalForAll(msg.sender, to, approved);
435     }
436 
437     /**
438      * @dev Tells whether an operator is approved by a given owner.
439      * @param owner owner address which you want to query the approval of
440      * @param operator operator address which you want to query the approval of
441      * @return bool whether the given operator is approved by the given owner
442      */
443     function isApprovedForAll(address owner, address operator) public view returns (bool) {
444         return _operatorApprovals[owner][operator];
445     }
446 
447     /**
448      * @dev Transfers the ownership of a given token ID to another address.
449      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
450      * Requires the msg.sender to be the owner, approved, or operator.
451      * @param from current owner of the token
452      * @param to address to receive the ownership of the given token ID
453      * @param tokenId uint256 ID of the token to be transferred
454      */
455     function transferFrom(address from, address to, uint256 tokenId) public {
456         //solhint-disable-next-line max-line-length
457         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
458 
459         _transferFrom(from, to, tokenId);
460     }
461 
462     /**
463      * @dev Safely transfers the ownership of a given token ID to another address
464      * If the target address is a contract, it must implement `onERC721Received`,
465      * which is called upon a safe transfer, and return the magic value
466      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
467      * the transfer is reverted.
468      * Requires the msg.sender to be the owner, approved, or operator
469      * @param from current owner of the token
470      * @param to address to receive the ownership of the given token ID
471      * @param tokenId uint256 ID of the token to be transferred
472      */
473     function safeTransferFrom(address from, address to, uint256 tokenId) public {
474         safeTransferFrom(from, to, tokenId, "");
475     }
476 
477     /**
478      * @dev Safely transfers the ownership of a given token ID to another address
479      * If the target address is a contract, it must implement `onERC721Received`,
480      * which is called upon a safe transfer, and return the magic value
481      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
482      * the transfer is reverted.
483      * Requires the msg.sender to be the owner, approved, or operator
484      * @param from current owner of the token
485      * @param to address to receive the ownership of the given token ID
486      * @param tokenId uint256 ID of the token to be transferred
487      * @param _data bytes data to send along with a safe transfer check
488      */
489     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
490         transferFrom(from, to, tokenId);
491         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
492     }
493 
494     /**
495      * @dev Returns whether the specified token exists.
496      * @param tokenId uint256 ID of the token to query the existence of
497      * @return bool whether the token exists
498      */
499     function _exists(uint256 tokenId) internal view returns (bool) {
500         address owner = _tokenOwner[tokenId];
501         return owner != address(0);
502     }
503 
504     /**
505      * @dev Returns whether the given spender can transfer a given token ID.
506      * @param spender address of the spender to query
507      * @param tokenId uint256 ID of the token to be transferred
508      * @return bool whether the msg.sender is approved for the given token ID,
509      * is an operator of the owner, or is the owner of the token
510      */
511     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
512         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
513         address owner = ownerOf(tokenId);
514         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
515     }
516 
517     /**
518      * @dev Internal function to mint a new token.
519      * Reverts if the given token ID already exists.
520      * @param to The address that will own the minted token
521      * @param tokenId uint256 ID of the token to be minted
522      */
523     function _mint(address to, uint256 tokenId) internal {
524         require(to != address(0), "ERC721: mint to the zero address");
525         require(!_exists(tokenId), "ERC721: token already minted");
526 
527         _tokenOwner[tokenId] = to;
528         _ownedTokensCount[to].increment();
529 
530         emit Transfer(address(0), to, tokenId);
531     }
532 
533     /**
534      * @dev Internal function to burn a specific token.
535      * Reverts if the token does not exist.
536      * Deprecated, use _burn(uint256) instead.
537      * @param owner owner of the token to burn
538      * @param tokenId uint256 ID of the token being burned
539      */
540     function _burn(address owner, uint256 tokenId) internal {
541         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
542 
543         _clearApproval(tokenId);
544 
545         _ownedTokensCount[owner].decrement();
546         _tokenOwner[tokenId] = address(0);
547 
548         emit Transfer(owner, address(0), tokenId);
549     }
550 
551     /**
552      * @dev Internal function to burn a specific token.
553      * Reverts if the token does not exist.
554      * @param tokenId uint256 ID of the token being burned
555      */
556     function _burn(uint256 tokenId) internal {
557         _burn(ownerOf(tokenId), tokenId);
558     }
559 
560     /**
561      * @dev Internal function to transfer ownership of a given token ID to another address.
562      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
563      * @param from current owner of the token
564      * @param to address to receive the ownership of the given token ID
565      * @param tokenId uint256 ID of the token to be transferred
566      */
567     function _transferFrom(address from, address to, uint256 tokenId) internal {
568         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
569         require(to != address(0), "ERC721: transfer to the zero address");
570 
571         _clearApproval(tokenId);
572 
573         _ownedTokensCount[from].decrement();
574         _ownedTokensCount[to].increment();
575 
576         _tokenOwner[tokenId] = to;
577 
578         emit Transfer(from, to, tokenId);
579     }
580 
581     /**
582      * @dev Internal function to invoke `onERC721Received` on a target address.
583      * The call is not executed if the target address is not a contract.
584      *
585      * This function is deprecated.
586      * @param from address representing the previous owner of the given token ID
587      * @param to target address that will receive the tokens
588      * @param tokenId uint256 ID of the token to be transferred
589      * @param _data bytes optional data to send along with the call
590      * @return bool whether the call correctly returned the expected magic value
591      */
592     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
593         internal returns (bool)
594     {
595         if (!to.isContract()) {
596             return true;
597         }
598 
599         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
600         return (retval == _ERC721_RECEIVED);
601     }
602 
603     /**
604      * @dev Private function to clear current approval of a given token ID.
605      * @param tokenId uint256 ID of the token to be transferred
606      */
607     function _clearApproval(uint256 tokenId) private {
608         if (_tokenApprovals[tokenId] != address(0)) {
609             _tokenApprovals[tokenId] = address(0);
610         }
611     }
612 }
613 
614 /**
615  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
616  * @dev See https://eips.ethereum.org/EIPS/eip-721
617  */
618 contract IERC721Enumerable is IERC721 {
619     function totalSupply() public view returns (uint256);
620     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
621 
622     function tokenByIndex(uint256 index) public view returns (uint256);
623 }
624 
625 /**
626  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
630     // Mapping from owner to list of owned token IDs
631     mapping(address => uint256[]) private _ownedTokens;
632 
633     // Mapping from token ID to index of the owner tokens list
634     mapping(uint256 => uint256) private _ownedTokensIndex;
635 
636     // Array with all token ids, used for enumeration
637     uint256[] private _allTokens;
638 
639     // Mapping from token id to position in the allTokens array
640     mapping(uint256 => uint256) private _allTokensIndex;
641 
642     /*
643      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
644      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
645      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
646      *
647      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
648      */
649     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
650 
651     /**
652      * @dev Constructor function.
653      */
654     constructor () public {
655         // register the supported interface to conform to ERC721Enumerable via ERC165
656         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
657     }
658 
659     /**
660      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
661      * @param owner address owning the tokens list to be accessed
662      * @param index uint256 representing the index to be accessed of the requested tokens list
663      * @return uint256 token ID at the given index of the tokens list owned by the requested address
664      */
665     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
666         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
667         return _ownedTokens[owner][index];
668     }
669 
670     /**
671      * @dev Gets the total amount of tokens stored by the contract.
672      * @return uint256 representing the total amount of tokens
673      */
674     function totalSupply() public view returns (uint256) {
675         return _allTokens.length;
676     }
677 
678     /**
679      * @dev Gets the token ID at a given index of all the tokens in this contract
680      * Reverts if the index is greater or equal to the total number of tokens.
681      * @param index uint256 representing the index to be accessed of the tokens list
682      * @return uint256 token ID at the given index of the tokens list
683      */
684     function tokenByIndex(uint256 index) public view returns (uint256) {
685         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
686         return _allTokens[index];
687     }
688 
689     /**
690      * @dev Internal function to transfer ownership of a given token ID to another address.
691      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
692      * @param from current owner of the token
693      * @param to address to receive the ownership of the given token ID
694      * @param tokenId uint256 ID of the token to be transferred
695      */
696     function _transferFrom(address from, address to, uint256 tokenId) internal {
697         super._transferFrom(from, to, tokenId);
698 
699         _removeTokenFromOwnerEnumeration(from, tokenId);
700 
701         _addTokenToOwnerEnumeration(to, tokenId);
702     }
703 
704     /**
705      * @dev Internal function to mint a new token.
706      * Reverts if the given token ID already exists.
707      * @param to address the beneficiary that will own the minted token
708      * @param tokenId uint256 ID of the token to be minted
709      */
710     function _mint(address to, uint256 tokenId) internal {
711         super._mint(to, tokenId);
712 
713         _addTokenToOwnerEnumeration(to, tokenId);
714 
715         _addTokenToAllTokensEnumeration(tokenId);
716     }
717 
718     /**
719      * @dev Internal function to burn a specific token.
720      * Reverts if the token does not exist.
721      * Deprecated, use _burn(uint256) instead.
722      * @param owner owner of the token to burn
723      * @param tokenId uint256 ID of the token being burned
724      */
725     function _burn(address owner, uint256 tokenId) internal {
726         super._burn(owner, tokenId);
727 
728         _removeTokenFromOwnerEnumeration(owner, tokenId);
729         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
730         _ownedTokensIndex[tokenId] = 0;
731 
732         _removeTokenFromAllTokensEnumeration(tokenId);
733     }
734 
735     /**
736      * @dev Gets the list of token IDs of the requested owner.
737      * @param owner address owning the tokens
738      * @return uint256[] List of token IDs owned by the requested address
739      */
740     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
741         return _ownedTokens[owner];
742     }
743 
744     /**
745      * @dev Private function to add a token to this extension's ownership-tracking data structures.
746      * @param to address representing the new owner of the given token ID
747      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
748      */
749     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
750         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
751         _ownedTokens[to].push(tokenId);
752     }
753 
754     /**
755      * @dev Private function to add a token to this extension's token tracking data structures.
756      * @param tokenId uint256 ID of the token to be added to the tokens list
757      */
758     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
759         _allTokensIndex[tokenId] = _allTokens.length;
760         _allTokens.push(tokenId);
761     }
762 
763     /**
764      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
765      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
766      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
767      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
768      * @param from address representing the previous owner of the given token ID
769      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
770      */
771     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
772         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
773         // then delete the last slot (swap and pop).
774 
775         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
776         uint256 tokenIndex = _ownedTokensIndex[tokenId];
777 
778         // When the token to delete is the last token, the swap operation is unnecessary
779         if (tokenIndex != lastTokenIndex) {
780             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
781 
782             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
783             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
784         }
785 
786         // This also deletes the contents at the last position of the array
787         _ownedTokens[from].length--;
788 
789         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
790         // lastTokenId, or just over the end of the array if the token was the last one).
791     }
792 
793     /**
794      * @dev Private function to remove a token from this extension's token tracking data structures.
795      * This has O(1) time complexity, but alters the order of the _allTokens array.
796      * @param tokenId uint256 ID of the token to be removed from the tokens list
797      */
798     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
799         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
800         // then delete the last slot (swap and pop).
801 
802         uint256 lastTokenIndex = _allTokens.length.sub(1);
803         uint256 tokenIndex = _allTokensIndex[tokenId];
804 
805         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
806         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
807         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
808         uint256 lastTokenId = _allTokens[lastTokenIndex];
809 
810         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
811         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
812 
813         // This also deletes the contents at the last position of the array
814         _allTokens.length--;
815         _allTokensIndex[tokenId] = 0;
816     }
817 }
818 
819 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
820     // Token name
821     string private _name;
822 
823     // Token symbol
824     string private _symbol;
825 
826     // Optional mapping for token URIs
827     mapping(uint256 => string) private _tokenURIs;
828 
829     /*
830      *     bytes4(keccak256('name()')) == 0x06fdde03
831      *     bytes4(keccak256('symbol()')) == 0x95d89b41
832      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
833      *
834      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
835      */
836     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
837 
838     /**
839      * @dev Constructor function
840      */
841     constructor (string memory name, string memory symbol) public {
842         _name = name;
843         _symbol = symbol;
844 
845         // register the supported interfaces to conform to ERC721 via ERC165
846         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
847     }
848 
849     /**
850      * @dev Gets the token name.
851      * @return string representing the token name
852      */
853     function name() external view returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev Gets the token symbol.
859      * @return string representing the token symbol
860      */
861     function symbol() external view returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev Returns an URI for a given token ID.
867      * Throws if the token ID does not exist. May return an empty string.
868      * @param tokenId uint256 ID of the token to query
869      */
870     function tokenURI(uint256 tokenId) external view returns (string memory) {
871         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
872         return _tokenURIs[tokenId];
873     }
874 
875     /**
876      * @dev Internal function to set the token URI for a given token.
877      * Reverts if the token ID does not exist.
878      * @param tokenId uint256 ID of the token to set its URI
879      * @param uri string URI to assign
880      */
881     function _setTokenURI(uint256 tokenId, string memory uri) internal {
882         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
883         _tokenURIs[tokenId] = uri;
884     }
885 
886     /**
887      * @dev Internal function to burn a specific token.
888      * Reverts if the token does not exist.
889      * Deprecated, use _burn(uint256) instead.
890      * @param owner owner of the token to burn
891      * @param tokenId uint256 ID of the token being burned by the msg.sender
892      */
893     function _burn(address owner, uint256 tokenId) internal {
894         super._burn(owner, tokenId);
895 
896         // Clear metadata (if any)
897         if (bytes(_tokenURIs[tokenId]).length != 0) {
898             delete _tokenURIs[tokenId];
899         }
900     }
901 }
902 
903 /**
904  * @title Full ERC721 Token
905  * This implementation includes all the required and some optional functionality of the ERC721 standard
906  * Moreover, it includes approve all functionality using operator terminology
907  * @dev see https://eips.ethereum.org/EIPS/eip-721
908  */
909 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
910     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
911         // solhint-disable-previous-line no-empty-blocks
912     }
913 }
914 
915 /**
916  * @dev Contract module which provides a basic access control mechanism, where
917  * there is an account (an owner) that can be granted exclusive access to
918  * specific functions.
919  *
920  * This module is used through inheritance. It will make available the modifier
921  * `onlyOwner`, which can be aplied to your functions to restrict their use to
922  * the owner.
923  */
924 contract Ownable {
925     address private _owner;
926 
927     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
928 
929     /**
930      * @dev Initializes the contract setting the deployer as the initial owner.
931      */
932     constructor () internal {
933         _owner = msg.sender;
934         emit OwnershipTransferred(address(0), _owner);
935     }
936 
937     /**
938      * @dev Returns the address of the current owner.
939      */
940     function owner() public view returns (address) {
941         return _owner;
942     }
943 
944     /**
945      * @dev Throws if called by any account other than the owner.
946      */
947     modifier onlyOwner() {
948         require(isOwner(), "Ownable: caller is not the owner");
949         _;
950     }
951 
952     /**
953      * @dev Returns true if the caller is the current owner.
954      */
955     function isOwner() public view returns (bool) {
956         return msg.sender == _owner;
957     }
958 
959     /**
960      * @dev Leaves the contract without owner. It will not be possible to call
961      * `onlyOwner` functions anymore. Can only be called by the current owner.
962      *
963      * > Note: Renouncing ownership will leave the contract without an owner,
964      * thereby removing any functionality that is only available to the owner.
965      */
966     function renounceOwnership() public onlyOwner {
967         emit OwnershipTransferred(_owner, address(0));
968         _owner = address(0);
969     }
970 
971     /**
972      * @dev Transfers ownership of the contract to a new account (`newOwner`).
973      * Can only be called by the current owner.
974      */
975     function transferOwnership(address newOwner) public onlyOwner {
976         _transferOwnership(newOwner);
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (`newOwner`).
981      */
982     function _transferOwnership(address newOwner) internal {
983         require(newOwner != address(0), "Ownable: new owner is the zero address");
984         emit OwnershipTransferred(_owner, newOwner);
985         _owner = newOwner;
986     }
987 }
988 
989 /**
990  * @title MintableToken
991  * @dev anyone can mint token.
992  */
993 contract MintableToken is IERC721, IERC721Metadata, ERC721Full, Ownable {
994 
995     constructor (string memory name, string memory symbol) public ERC721Full(name, symbol) {
996 
997     }
998 
999     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, string memory tokenURI) public {
1000         require(owner() == ecrecover(keccak256(abi.encodePacked(tokenId)), v, r, s), "owner should sign tokenId");
1001         _mint(msg.sender, tokenId);
1002         _setTokenURI(tokenId, tokenURI);
1003     }
1004 }
1005 
1006 contract TokenSale is IERC721Receiver {
1007 
1008     mapping(bytes32 => uint256) public nonces;
1009 
1010     event Cancel(address indexed token, uint256 indexed tokenId, address owner, uint256 nonce);
1011     event Buy(address indexed token, uint256 indexed tokenId, address seller, address buyer, uint256 price, uint256 nonce);
1012 
1013     function cancel(IERC721 token, uint256 tokenId) public {
1014         address owner = token.ownerOf(tokenId);
1015         require(owner == msg.sender, "not an owner");
1016         bytes32 key = getPositionKey(token, tokenId);
1017         uint256 nonce = nonces[key] + 1;
1018         nonces[key] = nonce;
1019         emit Cancel(address(token), tokenId, owner, nonce);
1020     }
1021 
1022     function buy(IERC721 token, uint256 tokenId, uint8 v, bytes32 r, bytes32 s) public payable {
1023         bytes32 key = getPositionKey(token, tokenId);
1024         bytes memory message = prepare(address(token), tokenId, msg.value, nonces[key]);
1025         address payable owner = address(uint160(token.ownerOf(tokenId)));
1026         require(owner == testRecovery(message, v, r, s), "owner should sign correct message");
1027         uint256 nonce = nonces[key] + 1;
1028         nonces[key] = nonce;
1029         token.transferFrom(owner, msg.sender, tokenId);
1030         owner.transfer(msg.value);
1031         emit Buy(address(token), tokenId, owner, msg.sender, msg.value, nonce);
1032     }
1033 
1034     function testRecovery(bytes memory message, uint8 v, bytes32 r, bytes32 s) private pure returns (address) {
1035         bytes memory fullMessage = strConcat(
1036             bytes("\x19Ethereum Signed Message:\n"),
1037             toAsciiBytes(message.length),
1038             message,
1039             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1040         );
1041         return ecrecover(keccak256(fullMessage), v, r, s);
1042     }
1043 
1044     function prepare(address token, uint256 tokenId, uint256 price, uint256 nonce) private pure returns (bytes memory) {
1045         return strConcat(
1046             toAsciiBytes(token),
1047             bytes(". tokenId: "),
1048             toAsciiBytes(tokenId),
1049             bytes(". price: "),
1050             toAsciiBytes(price),
1051             bytes(". nonce: "),
1052             toAsciiBytes(nonce)
1053         );
1054     }
1055 
1056     function strConcat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1057         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1058         uint k = 0;
1059         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1060         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1061         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1062         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1063         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1064         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1065         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1066         return resultBytes;
1067     }
1068 
1069     function toAsciiBytes(uint _i) internal pure returns (bytes memory) {
1070         if (_i == 0) {
1071             return "0";
1072         }
1073         uint j = _i;
1074         uint len;
1075         while (j != 0) {
1076             len++;
1077             j /= 10;
1078         }
1079         bytes memory bstr = new bytes(len);
1080         uint k = len - 1;
1081         while (_i != 0) {
1082             bstr[k--] = byte(uint8(48 + _i % 10));
1083             _i /= 10;
1084         }
1085         return bstr;
1086     }
1087 
1088     function toAsciiBytes(address _addr) internal pure returns(bytes memory) {
1089         bytes32 value = bytes32(uint256(_addr));
1090         bytes memory alphabet = "0123456789abcdef";
1091         bytes memory str = new bytes(42);
1092         str[0] = '0';
1093         str[1] = 'x';
1094         for (uint256 i = 0; i < 20; i++) {
1095             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1096             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1097         }
1098         return str;
1099     }
1100 
1101     function getNonce(IERC721 token, uint256 tokenId) view public returns (uint256) {
1102         return nonces[getPositionKey(token, tokenId)];
1103     }
1104 
1105     function getPositionKey(IERC721 token, uint256 tokenId) pure public returns (bytes32) {
1106         return keccak256(abi.encodePacked(token, tokenId));
1107     }
1108 
1109     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
1110         return this.onERC721Received.selector;
1111     }
1112 }