1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-02
7 */
8 
9 // File: @openzeppelin/contracts/ownership/Ownable.sol
10 
11 pragma solidity ^0.5.0;
12 
13 /**
14  * @dev Contract module which provides a basic access control mechanism, where
15  * there is an account (an owner) that can be granted exclusive access to
16  * specific functions.
17  *
18  * This module is used through inheritance. It will make available the modifier
19  * `onlyOwner`, which can be aplied to your functions to restrict their use to
20  * the owner.
21  */
22 contract Ownable {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor () internal {
31         _owner = msg.sender;
32         emit OwnershipTransferred(address(0), _owner);
33     }
34 
35     /**
36      * @dev Returns the address of the current owner.
37      */
38     function owner() public view returns (address) {
39         return _owner;
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(isOwner(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     /**
51      * @dev Returns true if the caller is the current owner.
52      */
53     function isOwner() public view returns (bool) {
54         return msg.sender == _owner;
55     }
56 
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * > Note: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         _transferOwnership(newOwner);
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      */
80     function _transferOwnership(address newOwner) internal {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/introspection/IERC165.sol
88 
89 pragma solidity ^0.5.0;
90 
91 /**
92  * @dev Interface of the ERC165 standard, as defined in the
93  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
94  *
95  * Implementers can declare support of contract interfaces, which can then be
96  * queried by others (`ERC165Checker`).
97  *
98  * For an implementation, see `ERC165`.
99  */
100 interface IERC165 {
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 }
111 
112 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
113 
114 pragma solidity ^0.5.0;
115 
116 
117 /**
118  * @dev Required interface of an ERC721 compliant contract.
119  */
120 contract IERC721 is IERC165 {
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
123     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
124 
125     /**
126      * @dev Returns the number of NFTs in `owner`'s account.
127      */
128     function balanceOf(address owner) public view returns (uint256 balance);
129 
130     /**
131      * @dev Returns the owner of the NFT specified by `tokenId`.
132      */
133     function ownerOf(uint256 tokenId) public view returns (address owner);
134 
135     /**
136      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
137      * another (`to`).
138      *
139      * 
140      *
141      * Requirements:
142      * - `from`, `to` cannot be zero.
143      * - `tokenId` must be owned by `from`.
144      * - If the caller is not `from`, it must be have been allowed to move this
145      * NFT by either `approve` or `setApproveForAll`.
146      */
147     function safeTransferFrom(address from, address to, uint256 tokenId) public;
148     /**
149      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
150      * another (`to`).
151      *
152      * Requirements:
153      * - If the caller is not `from`, it must be approved to move this NFT by
154      * either `approve` or `setApproveForAll`.
155      */
156     function transferFrom(address from, address to, uint256 tokenId) public;
157     function approve(address to, uint256 tokenId) public;
158     function getApproved(uint256 tokenId) public view returns (address operator);
159 
160     function setApprovalForAll(address operator, bool _approved) public;
161     function isApprovedForAll(address owner, address operator) public view returns (bool);
162 
163 
164     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
165 }
166 
167 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
168 
169 pragma solidity ^0.5.0;
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  * from ERC721 asset contracts.
175  */
176 contract IERC721Receiver {
177     /**
178      * @notice Handle the receipt of an NFT
179      * @dev The ERC721 smart contract calls this function on the recipient
180      * after a `safeTransfer`. This function MUST return the function selector,
181      * otherwise the caller will revert the transaction. The selector to be
182      * returned can be obtained as `this.onERC721Received.selector`. This
183      * function MAY throw to revert and reject the transfer.
184      * Note: the ERC721 contract address is always the message sender.
185      * @param operator The address which called `safeTransferFrom` function
186      * @param from The address which previously owned the token
187      * @param tokenId The NFT identifier which is being transferred
188      * @param data Additional data with no specified format
189      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
190      */
191     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
192     public returns (bytes4);
193 }
194 
195 // File: @openzeppelin/contracts/math/SafeMath.sol
196 
197 pragma solidity ^0.5.0;
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations with added overflow
201  * checks.
202  *
203  * Arithmetic operations in Solidity wrap on overflow. This can easily result
204  * in bugs, because programmers usually assume that an overflow raises an
205  * error, which is the standard behavior in high level programming languages.
206  * `SafeMath` restores this intuition by reverting the transaction when an
207  * operation overflows.
208  *
209  * Using this library instead of the unchecked operations eliminates an entire
210  * class of bugs, so it's recommended to use it always.
211  */
212 library SafeMath {
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b <= a, "SafeMath: subtraction overflow");
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the multiplication of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `*` operator.
250      *
251      * Requirements:
252      * - Multiplication cannot overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256         // benefit is lost if 'b' is also tested.
257         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
258         if (a == 0) {
259             return 0;
260         }
261 
262         uint256 c = a * b;
263         require(c / a == b, "SafeMath: multiplication overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers. Reverts on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         // Solidity only automatically asserts when dividing by 0
281         require(b > 0, "SafeMath: division by zero");
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * Reverts when dividing by zero.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         require(b != 0, "SafeMath: modulo by zero");
301         return a % b;
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Address.sol
306 
307 pragma solidity ^0.5.0;
308 
309 /**
310  * @dev Collection of functions related to the address type,
311  */
312 library Address {
313     /**
314      * @dev Returns true if `account` is a contract.
315      *
316      * This test is non-exhaustive, and there may be false-negatives: during the
317      * execution of a contract's constructor, its address will be reported as
318      * not containing a contract.
319      *
320      * > It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies in extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/drafts/Counters.sol
336 
337 pragma solidity ^0.5.0;
338 
339 
340 /**
341  * @title Counters
342  * @author Matt Condon (@shrugs)
343  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
344  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
345  *
346  * Include with `using Counters for Counters.Counter;`
347  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
348  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
349  * directly accessed.
350  */
351 library Counters {
352     using SafeMath for uint256;
353 
354     struct Counter {
355         // This variable should never be directly accessed by users of the library: interactions must be restricted to
356         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
357         // this feature: see https://github.com/ethereum/solidity/issues/4637
358         uint256 _value; // default: 0
359     }
360 
361     function current(Counter storage counter) internal view returns (uint256) {
362         return counter._value;
363     }
364 
365     function increment(Counter storage counter) internal {
366         counter._value += 1;
367     }
368 
369     function decrement(Counter storage counter) internal {
370         counter._value = counter._value.sub(1);
371     }
372 }
373 
374 // File: @openzeppelin/contracts/introspection/ERC165.sol
375 
376 pragma solidity ^0.5.0;
377 
378 
379 /**
380  * @dev Implementation of the `IERC165` interface.
381  *
382  * Contracts may inherit from this and call `_registerInterface` to declare
383  * their support of an interface.
384  */
385 contract ERC165 is IERC165 {
386     /*
387      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
388      */
389     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
390 
391     /**
392      * @dev Mapping of interface ids to whether or not it's supported.
393      */
394     mapping(bytes4 => bool) private _supportedInterfaces;
395 
396     constructor () internal {
397         // Derived contracts need only register support for their own interfaces,
398         // we register support for ERC165 itself here
399         _registerInterface(_INTERFACE_ID_ERC165);
400     }
401 
402     /**
403      * @dev See `IERC165.supportsInterface`.
404      *
405      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
406      */
407     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
408         return _supportedInterfaces[interfaceId];
409     }
410 
411     /**
412      * @dev Registers the contract as an implementer of the interface defined by
413      * `interfaceId`. Support of the actual ERC165 interface is automatic and
414      * registering its interface id is not required.
415      *
416      * See `IERC165.supportsInterface`.
417      *
418      * Requirements:
419      *
420      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
421      */
422     function _registerInterface(bytes4 interfaceId) internal {
423         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
424         _supportedInterfaces[interfaceId] = true;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
429 
430 pragma solidity ^0.5.0;
431 
432 
433 
434 
435 
436 
437 
438 /**
439  * @title ERC721 Non-Fungible Token Standard basic implementation
440  * @dev see https://eips.ethereum.org/EIPS/eip-721
441  */
442 contract ERC721 is ERC165, IERC721 {
443     using SafeMath for uint256;
444     using Address for address;
445     using Counters for Counters.Counter;
446 
447     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
448     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
449     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
450 
451     // Mapping from token ID to owner
452     mapping (uint256 => address) private _tokenOwner;
453 
454     // Mapping from token ID to approved address
455     mapping (uint256 => address) private _tokenApprovals;
456 
457     // Mapping from owner to number of owned token
458     mapping (address => Counters.Counter) private _ownedTokensCount;
459 
460     // Mapping from owner to operator approvals
461     mapping (address => mapping (address => bool)) private _operatorApprovals;
462 
463     /*
464      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
465      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
466      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
467      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
468      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
469      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
470      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
471      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
472      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
473      *
474      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
475      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
476      */
477     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
478 
479     constructor () public {
480         // register the supported interfaces to conform to ERC721 via ERC165
481         _registerInterface(_INTERFACE_ID_ERC721);
482     }
483 
484     /**
485      * @dev Gets the balance of the specified address.
486      * @param owner address to query the balance of
487      * @return uint256 representing the amount owned by the passed address
488      */
489     function balanceOf(address owner) public view returns (uint256) {
490         require(owner != address(0), "ERC721: balance query for the zero address");
491 
492         return _ownedTokensCount[owner].current();
493     }
494 
495     /**
496      * @dev Gets the owner of the specified token ID.
497      * @param tokenId uint256 ID of the token to query the owner of
498      * @return address currently marked as the owner of the given token ID
499      */
500     function ownerOf(uint256 tokenId) public view returns (address) {
501         address owner = _tokenOwner[tokenId];
502         require(owner != address(0), "ERC721: owner query for nonexistent token");
503 
504         return owner;
505     }
506 
507     /**
508      * @dev Approves another address to transfer the given token ID
509      * The zero address indicates there is no approved address.
510      * There can only be one approved address per token at a given time.
511      * Can only be called by the token owner or an approved operator.
512      * @param to address to be approved for the given token ID
513      * @param tokenId uint256 ID of the token to be approved
514      */
515     function approve(address to, uint256 tokenId) public {
516         address owner = ownerOf(tokenId);
517         require(to != owner, "ERC721: approval to current owner");
518 
519         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
520             "ERC721: approve caller is not owner nor approved for all"
521         );
522 
523         _tokenApprovals[tokenId] = to;
524         emit Approval(owner, to, tokenId);
525     }
526 
527     /**
528      * @dev Gets the approved address for a token ID, or zero if no address set
529      * Reverts if the token ID does not exist.
530      * @param tokenId uint256 ID of the token to query the approval of
531      * @return address currently approved for the given token ID
532      */
533     function getApproved(uint256 tokenId) public view returns (address) {
534         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
535 
536         return _tokenApprovals[tokenId];
537     }
538 
539     /**
540      * @dev Sets or unsets the approval of a given operator
541      * An operator is allowed to transfer all tokens of the sender on their behalf.
542      * @param to operator address to set the approval
543      * @param approved representing the status of the approval to be set
544      */
545     function setApprovalForAll(address to, bool approved) public {
546         require(to != msg.sender, "ERC721: approve to caller");
547 
548         _operatorApprovals[msg.sender][to] = approved;
549         emit ApprovalForAll(msg.sender, to, approved);
550     }
551 
552     /**
553      * @dev Tells whether an operator is approved by a given owner.
554      * @param owner owner address which you want to query the approval of
555      * @param operator operator address which you want to query the approval of
556      * @return bool whether the given operator is approved by the given owner
557      */
558     function isApprovedForAll(address owner, address operator) public view returns (bool) {
559         return _operatorApprovals[owner][operator];
560     }
561 
562     /**
563      * @dev Transfers the ownership of a given token ID to another address.
564      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
565      * Requires the msg.sender to be the owner, approved, or operator.
566      * @param from current owner of the token
567      * @param to address to receive the ownership of the given token ID
568      * @param tokenId uint256 ID of the token to be transferred
569      */
570     function transferFrom(address from, address to, uint256 tokenId) public {
571         //solhint-disable-next-line max-line-length
572         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
573 
574         _transferFrom(from, to, tokenId);
575     }
576 
577     /**
578      * @dev Safely transfers the ownership of a given token ID to another address
579      * If the target address is a contract, it must implement `onERC721Received`,
580      * which is called upon a safe transfer, and return the magic value
581      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
582      * the transfer is reverted.
583      * Requires the msg.sender to be the owner, approved, or operator
584      * @param from current owner of the token
585      * @param to address to receive the ownership of the given token ID
586      * @param tokenId uint256 ID of the token to be transferred
587      */
588     function safeTransferFrom(address from, address to, uint256 tokenId) public {
589         safeTransferFrom(from, to, tokenId, "");
590     }
591 
592     /**
593      * @dev Safely transfers the ownership of a given token ID to another address
594      * If the target address is a contract, it must implement `onERC721Received`,
595      * which is called upon a safe transfer, and return the magic value
596      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
597      * the transfer is reverted.
598      * Requires the msg.sender to be the owner, approved, or operator
599      * @param from current owner of the token
600      * @param to address to receive the ownership of the given token ID
601      * @param tokenId uint256 ID of the token to be transferred
602      * @param _data bytes data to send along with a safe transfer check
603      */
604     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
605         transferFrom(from, to, tokenId);
606         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
607     }
608 
609     /**
610      * @dev Returns whether the specified token exists.
611      * @param tokenId uint256 ID of the token to query the existence of
612      * @return bool whether the token exists
613      */
614     function _exists(uint256 tokenId) internal view returns (bool) {
615         address owner = _tokenOwner[tokenId];
616         return owner != address(0);
617     }
618 
619     /**
620      * @dev Returns whether the given spender can transfer a given token ID.
621      * @param spender address of the spender to query
622      * @param tokenId uint256 ID of the token to be transferred
623      * @return bool whether the msg.sender is approved for the given token ID,
624      * is an operator of the owner, or is the owner of the token
625      */
626     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
627         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
628         address owner = ownerOf(tokenId);
629         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
630     }
631 
632     /**
633      * @dev Internal function to mint a new token.
634      * Reverts if the given token ID already exists.
635      * @param to The address that will own the minted token
636      * @param tokenId uint256 ID of the token to be minted
637      */
638     function _mint(address to, uint256 tokenId) internal {
639         require(to != address(0), "ERC721: mint to the zero address");
640         require(!_exists(tokenId), "ERC721: token already minted");
641 
642         _tokenOwner[tokenId] = to;
643         _ownedTokensCount[to].increment();
644 
645         emit Transfer(address(0), to, tokenId);
646     }
647 
648     /**
649      * @dev Internal function to burn a specific token.
650      * Reverts if the token does not exist.
651      * Deprecated, use _burn(uint256) instead.
652      * @param owner owner of the token to burn
653      * @param tokenId uint256 ID of the token being burned
654      */
655     function _burn(address owner, uint256 tokenId) internal {
656         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
657 
658         _clearApproval(tokenId);
659 
660         _ownedTokensCount[owner].decrement();
661         _tokenOwner[tokenId] = address(0);
662 
663         emit Transfer(owner, address(0), tokenId);
664     }
665 
666     /**
667      * @dev Internal function to burn a specific token.
668      * Reverts if the token does not exist.
669      * @param tokenId uint256 ID of the token being burned
670      */
671     function _burn(uint256 tokenId) internal {
672         _burn(ownerOf(tokenId), tokenId);
673     }
674 
675     /**
676      * @dev Internal function to transfer ownership of a given token ID to another address.
677      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
678      * @param from current owner of the token
679      * @param to address to receive the ownership of the given token ID
680      * @param tokenId uint256 ID of the token to be transferred
681      */
682     function _transferFrom(address from, address to, uint256 tokenId) internal {
683         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
684         require(to != address(0), "ERC721: transfer to the zero address");
685 
686         _clearApproval(tokenId);
687 
688         _ownedTokensCount[from].decrement();
689         _ownedTokensCount[to].increment();
690 
691         _tokenOwner[tokenId] = to;
692 
693         emit Transfer(from, to, tokenId);
694     }
695 
696     /**
697      * @dev Internal function to invoke `onERC721Received` on a target address.
698      * The call is not executed if the target address is not a contract.
699      *
700      * This function is deprecated.
701      * @param from address representing the previous owner of the given token ID
702      * @param to target address that will receive the tokens
703      * @param tokenId uint256 ID of the token to be transferred
704      * @param _data bytes optional data to send along with the call
705      * @return bool whether the call correctly returned the expected magic value
706      */
707     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
708         internal returns (bool)
709     {
710         if (!to.isContract()) {
711             return true;
712         }
713 
714         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
715         return (retval == _ERC721_RECEIVED);
716     }
717 
718     /**
719      * @dev Private function to clear current approval of a given token ID.
720      * @param tokenId uint256 ID of the token to be transferred
721      */
722     function _clearApproval(uint256 tokenId) private {
723         if (_tokenApprovals[tokenId] != address(0)) {
724             _tokenApprovals[tokenId] = address(0);
725         }
726     }
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
730 
731 pragma solidity ^0.5.0;
732 
733 
734 /**
735  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
736  * @dev See https://eips.ethereum.org/EIPS/eip-721
737  */
738 contract IERC721Enumerable is IERC721 {
739     function totalSupply() public view returns (uint256);
740     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
741 
742     function tokenByIndex(uint256 index) public view returns (uint256);
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
746 
747 pragma solidity ^0.5.0;
748 
749 
750 
751 
752 /**
753  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
757     // Mapping from owner to list of owned token IDs
758     mapping(address => uint256[]) private _ownedTokens;
759 
760     // Mapping from token ID to index of the owner tokens list
761     mapping(uint256 => uint256) private _ownedTokensIndex;
762 
763     // Array with all token ids, used for enumeration
764     uint256[] private _allTokens;
765 
766     // Mapping from token id to position in the allTokens array
767     mapping(uint256 => uint256) private _allTokensIndex;
768 
769     /*
770      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
771      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
772      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
773      *
774      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
775      */
776     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
777 
778     /**
779      * @dev Constructor function.
780      */
781     constructor () public {
782         // register the supported interface to conform to ERC721Enumerable via ERC165
783         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
784     }
785 
786     /**
787      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
788      * @param owner address owning the tokens list to be accessed
789      * @param index uint256 representing the index to be accessed of the requested tokens list
790      * @return uint256 token ID at the given index of the tokens list owned by the requested address
791      */
792     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
793         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
794         return _ownedTokens[owner][index];
795     }
796 
797     /**
798      * @dev Gets the total amount of tokens stored by the contract.
799      * @return uint256 representing the total amount of tokens
800      */
801     function totalSupply() public view returns (uint256) {
802         return _allTokens.length;
803     }
804 
805     /**
806      * @dev Gets the token ID at a given index of all the tokens in this contract
807      * Reverts if the index is greater or equal to the total number of tokens.
808      * @param index uint256 representing the index to be accessed of the tokens list
809      * @return uint256 token ID at the given index of the tokens list
810      */
811     function tokenByIndex(uint256 index) public view returns (uint256) {
812         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
813         return _allTokens[index];
814     }
815 
816     /**
817      * @dev Internal function to transfer ownership of a given token ID to another address.
818      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
819      * @param from current owner of the token
820      * @param to address to receive the ownership of the given token ID
821      * @param tokenId uint256 ID of the token to be transferred
822      */
823     function _transferFrom(address from, address to, uint256 tokenId) internal {
824         super._transferFrom(from, to, tokenId);
825 
826         _removeTokenFromOwnerEnumeration(from, tokenId);
827 
828         _addTokenToOwnerEnumeration(to, tokenId);
829     }
830 
831     /**
832      * @dev Internal function to mint a new token.
833      * Reverts if the given token ID already exists.
834      * @param to address the beneficiary that will own the minted token
835      * @param tokenId uint256 ID of the token to be minted
836      */
837     function _mint(address to, uint256 tokenId) internal {
838         super._mint(to, tokenId);
839 
840         _addTokenToOwnerEnumeration(to, tokenId);
841 
842         _addTokenToAllTokensEnumeration(tokenId);
843     }
844 
845     /**
846      * @dev Internal function to burn a specific token.
847      * Reverts if the token does not exist.
848      * Deprecated, use _burn(uint256) instead.
849      * @param owner owner of the token to burn
850      * @param tokenId uint256 ID of the token being burned
851      */
852     function _burn(address owner, uint256 tokenId) internal {
853         super._burn(owner, tokenId);
854 
855         _removeTokenFromOwnerEnumeration(owner, tokenId);
856         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
857         _ownedTokensIndex[tokenId] = 0;
858 
859         _removeTokenFromAllTokensEnumeration(tokenId);
860     }
861 
862     /**
863      * @dev Gets the list of token IDs of the requested owner.
864      * @param owner address owning the tokens
865      * @return uint256[] List of token IDs owned by the requested address
866      */
867     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
868         return _ownedTokens[owner];
869     }
870 
871     /**
872      * @dev Private function to add a token to this extension's ownership-tracking data structures.
873      * @param to address representing the new owner of the given token ID
874      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
875      */
876     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
877         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
878         _ownedTokens[to].push(tokenId);
879     }
880 
881     /**
882      * @dev Private function to add a token to this extension's token tracking data structures.
883      * @param tokenId uint256 ID of the token to be added to the tokens list
884      */
885     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
886         _allTokensIndex[tokenId] = _allTokens.length;
887         _allTokens.push(tokenId);
888     }
889 
890     /**
891      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
892      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
893      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
894      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
895      * @param from address representing the previous owner of the given token ID
896      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
897      */
898     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
899         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
900         // then delete the last slot (swap and pop).
901 
902         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
903         uint256 tokenIndex = _ownedTokensIndex[tokenId];
904 
905         // When the token to delete is the last token, the swap operation is unnecessary
906         if (tokenIndex != lastTokenIndex) {
907             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
908 
909             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
910             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
911         }
912 
913         // This also deletes the contents at the last position of the array
914         _ownedTokens[from].length--;
915 
916         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
917         // lastTokenId, or just over the end of the array if the token was the last one).
918     }
919 
920     /**
921      * @dev Private function to remove a token from this extension's token tracking data structures.
922      * This has O(1) time complexity, but alters the order of the _allTokens array.
923      * @param tokenId uint256 ID of the token to be removed from the tokens list
924      */
925     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
926         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
927         // then delete the last slot (swap and pop).
928 
929         uint256 lastTokenIndex = _allTokens.length.sub(1);
930         uint256 tokenIndex = _allTokensIndex[tokenId];
931 
932         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
933         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
934         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
935         uint256 lastTokenId = _allTokens[lastTokenIndex];
936 
937         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
938         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
939 
940         // This also deletes the contents at the last position of the array
941         _allTokens.length--;
942         _allTokensIndex[tokenId] = 0;
943     }
944 }
945 
946 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
947 
948 pragma solidity ^0.5.0;
949 
950 
951 /**
952  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
953  * @dev See https://eips.ethereum.org/EIPS/eip-721
954  */
955 contract IERC721Metadata is IERC721 {
956     function name() external view returns (string memory);
957     function symbol() external view returns (string memory);
958     function tokenURI(uint256 tokenId) external view returns (string memory);
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
962 
963 pragma solidity ^0.5.0;
964 
965 
966 
967 
968 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
969     // Token name
970     string private _name;
971 
972     // Token symbol
973     string private _symbol;
974 
975     // Optional mapping for token URIs
976     mapping(uint256 => string) private _tokenURIs;
977 
978     /*
979      *     bytes4(keccak256('name()')) == 0x06fdde03
980      *     bytes4(keccak256('symbol()')) == 0x95d89b41
981      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
982      *
983      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
984      */
985     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
986 
987     /**
988      * @dev Constructor function
989      */
990     constructor (string memory name, string memory symbol) public {
991         _name = name;
992         _symbol = symbol;
993 
994         // register the supported interfaces to conform to ERC721 via ERC165
995         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
996     }
997 
998     /**
999      * @dev Gets the token name.
1000      * @return string representing the token name
1001      */
1002     function name() external view returns (string memory) {
1003         return _name;
1004     }
1005 
1006     /**
1007      * @dev Gets the token symbol.
1008      * @return string representing the token symbol
1009      */
1010     function symbol() external view returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev Returns an URI for a given token ID.
1016      * Throws if the token ID does not exist. May return an empty string.
1017      * @param tokenId uint256 ID of the token to query
1018      */
1019     function tokenURI(uint256 tokenId) external view returns (string memory) {
1020         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1021         return _tokenURIs[tokenId];
1022     }
1023 
1024     /**
1025      * @dev Internal function to set the token URI for a given token.
1026      * Reverts if the token ID does not exist.
1027      * @param tokenId uint256 ID of the token to set its URI
1028      * @param uri string URI to assign
1029      */
1030     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1031         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1032         _tokenURIs[tokenId] = uri;
1033     }
1034 
1035     /**
1036      * @dev Internal function to burn a specific token.
1037      * Reverts if the token does not exist.
1038      * Deprecated, use _burn(uint256) instead.
1039      * @param owner owner of the token to burn
1040      * @param tokenId uint256 ID of the token being burned by the msg.sender
1041      */
1042     function _burn(address owner, uint256 tokenId) internal {
1043         super._burn(owner, tokenId);
1044 
1045         // Clear metadata (if any)
1046         if (bytes(_tokenURIs[tokenId]).length != 0) {
1047             delete _tokenURIs[tokenId];
1048         }
1049     }
1050 }
1051 
1052 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1053 
1054 pragma solidity ^0.5.0;
1055 
1056 
1057 
1058 
1059 /**
1060  * @title Full ERC721 Token
1061  * This implementation includes all the required and some optional functionality of the ERC721 standard
1062  * Moreover, it includes approve all functionality using operator terminology
1063  * @dev see https://eips.ethereum.org/EIPS/eip-721
1064  */
1065 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1066     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1067         // solhint-disable-previous-line no-empty-blocks
1068     }
1069 }
1070 
1071 // File: contracts/libs/String.sol
1072 
1073 pragma solidity ^0.5.11;
1074 
1075 library String {
1076 
1077     /**
1078      * @dev Convert bytes32 to string.
1079      * @param _x - to be converted to string.
1080      * @return string
1081      */
1082     function bytes32ToString(bytes32 _x) internal pure returns (string memory) {
1083         bytes memory bytesString = new bytes(32);
1084         uint charCount = 0;
1085         for (uint j = 0; j < 32; j++) {
1086             byte char = byte(bytes32(uint(_x) * 2 ** (8 * j)));
1087             if (char != 0) {
1088                 bytesString[charCount] = char;
1089                 charCount++;
1090             }
1091         }
1092         bytes memory bytesStringTrimmed = new bytes(charCount);
1093         for (uint j = 0; j < charCount; j++) {
1094             bytesStringTrimmed[j] = bytesString[j];
1095         }
1096         return string(bytesStringTrimmed);
1097     }
1098 
1099     /**
1100      * @dev Convert uint to string.
1101      * @param _i - uint256 to be converted to string.
1102      * @return uint in string
1103      */
1104     function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
1105         uint i = _i;
1106 
1107         if (i == 0) {
1108             return "0";
1109         }
1110         uint j = i;
1111         uint len;
1112         while (j != 0) {
1113             len++;
1114             j /= 10;
1115         }
1116         bytes memory bstr = new bytes(len);
1117         uint k = len - 1;
1118         while (i != 0) {
1119             bstr[k--] = byte(uint8(48 + i % 10));
1120             i /= 10;
1121         }
1122         return string(bstr);
1123     }
1124 }
1125 
1126 // File: contracts/ERC721BaseCollection.sol
1127 
1128 pragma solidity ^0.5.11;
1129 
1130 
1131 
1132 
1133 contract ERC721BaseCollection is Ownable, ERC721Full {
1134     using String for bytes32;
1135     using String for uint256;
1136 
1137     mapping(bytes32 => uint256) public maxIssuance;
1138     mapping(bytes32 => uint) public issued;
1139     mapping(uint256 => string) internal _tokenPaths;
1140     mapping(address => bool) public allowed;
1141 
1142     string[] public wearables;
1143 
1144     string public baseURI;
1145     bool public isComplete;
1146 
1147     event BaseURI(string _oldBaseURI, string _newBaseURI);
1148     event Allowed(address indexed _operator, bool _allowed);
1149     event AddWearable(bytes32 indexed _wearableIdKey, string _wearableId, uint256 _maxIssuance);
1150     event Issue(address indexed _beneficiary, uint256 indexed _tokenId, bytes32 indexed _wearableIdKey, string _wearableId, uint256 _issuedId);
1151     event Complete();
1152 
1153 
1154     /**
1155      * @dev Create the contract.
1156      * @param _name - name of the contract
1157      * @param _symbol - symbol of the contract
1158      * @param _operator - Address allowed to mint tokens
1159      * @param _baseURI - base URI for token URIs
1160      */
1161     constructor(string memory _name, string memory _symbol, address _operator, string memory _baseURI) public ERC721Full(_name, _symbol) {
1162         setAllowed(_operator, true);
1163         setBaseURI(_baseURI);
1164     }
1165 
1166     modifier onlyAllowed() {
1167         require(allowed[msg.sender], "Only an `allowed` address can issue tokens");
1168         _;
1169     }
1170 
1171 
1172     /**
1173      * @dev Set Base URI.
1174      * @param _baseURI - base URI for token URIs
1175      */
1176     function setBaseURI(string memory _baseURI) public onlyOwner {
1177         emit BaseURI(baseURI, _baseURI);
1178         baseURI = _baseURI;
1179     }
1180 
1181     /**
1182      * @dev Set allowed account to issue tokens.
1183      * @param _operator - Address allowed to issue tokens
1184      * @param _allowed - Whether is allowed or not
1185      */
1186     function setAllowed(address _operator, bool _allowed) public onlyOwner {
1187         require(_operator != address(0), "Invalid address");
1188         require(allowed[_operator] != _allowed, "You should set a different value");
1189 
1190         allowed[_operator] = _allowed;
1191         emit Allowed(_operator, _allowed);
1192     }
1193 
1194 
1195     /**
1196      * @dev Returns an URI for a given token ID.
1197      * Throws if the token ID does not exist. May return an empty string.
1198      * @param _tokenId - uint256 ID of the token queried
1199      * @return token URI
1200      */
1201     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1202         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1203         return string(abi.encodePacked(baseURI, _tokenPaths[_tokenId]));
1204     }
1205 
1206 
1207     /**
1208      * @dev Transfers the ownership of given tokens ID to another address.
1209      * Usage of this method is discouraged, use {safeBatchTransferFrom} whenever possible.
1210      * Requires the msg.sender to be the owner, approved, or operator.
1211      * @param _from current owner of the token
1212      * @param _to address to receive the ownership of the given token ID
1213      * @param _tokenIds uint256 ID of the token to be transferred
1214      */
1215     function batchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds) external {
1216         for (uint256 i = 0; i < _tokenIds.length; i++) {
1217             transferFrom(_from, _to, _tokenIds[i]);
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns the wearables length.
1223      * @return wearable length
1224      */
1225     function wearablesCount() external view returns (uint256) {
1226         return wearables.length;
1227     }
1228 
1229     /**
1230      * @dev Complete the collection.
1231      * @notice that it will only prevent for adding more wearables.
1232      * The issuance is still allowed.
1233      */
1234     function completeCollection() external onlyOwner {
1235         require(!isComplete, "The collection is already completed");
1236         isComplete = true;
1237         emit Complete();
1238     }
1239 
1240      /**
1241      * @dev Add a new wearable to the collection.
1242      * @notice that this method should only allow wearableIds less than or equal to 32 bytes
1243      * @param _wearableIds - wearable ids
1244      * @param _maxIssuances - total supply for the wearables
1245      */
1246     function addWearables(bytes32[] calldata _wearableIds, uint256[] calldata _maxIssuances) external onlyOwner {
1247         require(_wearableIds.length == _maxIssuances.length, "Parameters should have the same length");
1248 
1249         for (uint256 i = 0; i < _wearableIds.length; i++) {
1250             addWearable(_wearableIds[i].bytes32ToString(), _maxIssuances[i]);
1251         }
1252     }
1253 
1254     /**
1255      * @dev Add a new wearable to the collection.
1256      * @notice that this method allows wearableIds of any size. It should be used
1257      * if a wearableId is greater than 32 bytes
1258      * @param _wearableId - wearable id
1259      * @param _maxIssuance - total supply for the wearable
1260      */
1261     function addWearable(string memory _wearableId, uint256 _maxIssuance) public onlyOwner {
1262         require(!isComplete, "The collection is complete");
1263         bytes32 key = getWearableKey(_wearableId);
1264 
1265         require(maxIssuance[key] == 0, "Can not modify an existing wearable");
1266         require(_maxIssuance > 0, "Max issuance should be greater than 0");
1267 
1268         maxIssuance[key] = _maxIssuance;
1269         wearables.push(_wearableId);
1270 
1271         emit AddWearable(key, _wearableId, _maxIssuance);
1272     }
1273 
1274     /**
1275      * @dev Safely transfers the ownership of given token IDs to another address
1276      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1277      * which is called upon a safe transfer, and return the magic value
1278      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1279      * the transfer is reverted.
1280      * Requires the msg.sender to be the owner, approved, or operator
1281      * @param _from - current owner of the token
1282      * @param _to - address to receive the ownership of the given token ID
1283      * @param _tokenIds - uint256 IDs of the tokens to be transferred
1284      */
1285     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1286         safeBatchTransferFrom(_from, _to, _tokenIds, "");
1287     }
1288 
1289     /**
1290      * @dev Safely transfers the ownership of given token IDs to another address
1291      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1292      * which is called upon a safe transfer, and return the magic value
1293      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1294      * the transfer is reverted.
1295      * Requires the msg.sender to be the owner, approved, or operator
1296      * @param _from - current owner of the token
1297      * @param _to - address to receive the ownership of the given token ID
1298      * @param _tokenIds - uint256 ID of the tokens to be transferred
1299      * @param _data bytes data to send along with a safe transfer check
1300      */
1301     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory _data) public {
1302         for (uint256 i = 0; i < _tokenIds.length; i++) {
1303             safeTransferFrom(_from, _to, _tokenIds[i], _data);
1304         }
1305     }
1306 
1307     /**
1308      * @dev Get keccak256 of a wearableId.
1309      * @param _wearableId - token wearable
1310      * @return bytes32 keccak256 of the wearableId
1311      */
1312     function getWearableKey(string memory _wearableId) public pure returns (bytes32) {
1313         return keccak256(abi.encodePacked(_wearableId));
1314     }
1315 
1316     /**
1317      * @dev Mint a new NFT of the specified kind.
1318      * @notice that will throw if kind has reached its maximum or is invalid
1319      * @param _beneficiary - owner of the token
1320      * @param _tokenId - token
1321      * @param _wearableIdKey - wearable key
1322      * @param _wearableId - token wearable
1323      * @param _issuedId - issued id
1324      */
1325     function _mint(
1326         address _beneficiary,
1327         uint256 _tokenId,
1328         bytes32 _wearableIdKey,
1329         string memory _wearableId,
1330         uint256 _issuedId
1331     ) internal {
1332         // Check issuance
1333         require(
1334             _issuedId > 0 && _issuedId <= maxIssuance[_wearableIdKey],
1335             "Invalid issued id"
1336         );
1337         require(issued[_wearableIdKey] < maxIssuance[_wearableIdKey], "Option exhausted");
1338 
1339         // Mint erc721 token
1340         super._mint(_beneficiary, _tokenId);
1341 
1342         // Increase issuance
1343         issued[_wearableIdKey] = issued[_wearableIdKey] + 1;
1344 
1345         // Log
1346         emit Issue(_beneficiary, _tokenId, _wearableIdKey, _wearableId, _issuedId);
1347     }
1348 }
1349 
1350 // File: contracts/ERC721Collection.sol
1351 
1352 pragma solidity ^0.5.11;
1353 
1354 
1355 
1356 
1357 contract ERC721Collection is Ownable, ERC721Full, ERC721BaseCollection {
1358     /**
1359      * @dev Create the contract.
1360      * @param _name - name of the contract
1361      * @param _symbol - symbol of the contract
1362      * @param _operator - Address allowed to mint tokens
1363      * @param _baseURI - base URI for token URIs
1364      */
1365     constructor(
1366         string memory _name,
1367         string memory _symbol,
1368         address _operator,
1369         string memory _baseURI
1370     ) public ERC721BaseCollection(_name, _symbol, _operator, _baseURI) {}
1371 
1372     /**
1373      * @dev Issue a new NFT of the specified kind.
1374      * @notice that will throw if kind has reached its maximum or is invalid
1375      * @param _beneficiary - owner of the token
1376      * @param _wearableId - token wearable
1377      */
1378     function issueToken(address _beneficiary, string calldata _wearableId) external onlyAllowed {
1379         _issueToken(_beneficiary, _wearableId);
1380     }
1381 
1382     /**
1383      * @dev Issue NFTs.
1384      * @notice that will throw if kind has reached its maximum or is invalid
1385      * @param _beneficiaries - owner of the tokens
1386      * @param _wearableIds - token wearables
1387      */
1388     function issueTokens(address[] calldata _beneficiaries, bytes32[] calldata _wearableIds) external onlyAllowed {
1389         require(_beneficiaries.length == _wearableIds.length, "Parameters should have the same length");
1390 
1391         for(uint256 i = 0; i < _wearableIds.length; i++) {
1392             _issueToken(_beneficiaries[i], _wearableIds[i].bytes32ToString());
1393         }
1394     }
1395 
1396     /**
1397      * @dev Returns an URI for a given token ID.
1398      * Throws if the token ID does not exist. May return an empty string.
1399      * @param _tokenId - uint256 ID of the token queried
1400      * @return token URI
1401      */
1402     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1403         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1404         return string(abi.encodePacked(baseURI, _tokenPaths[_tokenId]));
1405     }
1406 
1407     /**
1408      * @dev Issue a new NFT of the specified kind.
1409      * @notice that will throw if kind has reached its maximum or is invalid
1410      * @param _beneficiary - owner of the token
1411      * @param _wearableId - token wearable
1412      */
1413     function _issueToken(address _beneficiary, string memory _wearableId) internal {
1414         bytes32 key = getWearableKey(_wearableId);
1415         uint256 issuedId = issued[key] + 1;
1416         uint256 tokenId = this.totalSupply();
1417 
1418         _mint(_beneficiary, tokenId, key, _wearableId, issuedId);
1419         _setTokenURI(
1420             tokenId,
1421             string(abi.encodePacked(_wearableId, "/", issuedId.uintToString()))
1422         );
1423     }
1424 
1425     /**
1426      * @dev Internal function to set the token URI for a given token.
1427      * Reverts if the token ID does not exist.
1428      * @param _tokenId - uint256 ID of the token to set as its URI
1429      * @param _uri - string URI to assign
1430      */
1431     function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
1432         _tokenPaths[_tokenId] = _uri;
1433     }
1434 }