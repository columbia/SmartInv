1 // File: @openzeppelin/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/introspection/IERC165.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @dev Interface of the ERC165 standard, as defined in the
85  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
86  *
87  * Implementers can declare support of contract interfaces, which can then be
88  * queried by others (`ERC165Checker`).
89  *
90  * For an implementation, see `ERC165`.
91  */
92 interface IERC165 {
93     /**
94      * @dev Returns true if this contract implements the interface defined by
95      * `interfaceId`. See the corresponding
96      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
97      * to learn more about how these ids are created.
98      *
99      * This function call must use less than 30 000 gas.
100      */
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
105 
106 pragma solidity ^0.5.0;
107 
108 
109 /**
110  * @dev Required interface of an ERC721 compliant contract.
111  */
112 contract IERC721 is IERC165 {
113     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
114     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
115     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
116 
117     /**
118      * @dev Returns the number of NFTs in `owner`'s account.
119      */
120     function balanceOf(address owner) public view returns (uint256 balance);
121 
122     /**
123      * @dev Returns the owner of the NFT specified by `tokenId`.
124      */
125     function ownerOf(uint256 tokenId) public view returns (address owner);
126 
127     /**
128      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
129      * another (`to`).
130      *
131      * 
132      *
133      * Requirements:
134      * - `from`, `to` cannot be zero.
135      * - `tokenId` must be owned by `from`.
136      * - If the caller is not `from`, it must be have been allowed to move this
137      * NFT by either `approve` or `setApproveForAll`.
138      */
139     function safeTransferFrom(address from, address to, uint256 tokenId) public;
140     /**
141      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
142      * another (`to`).
143      *
144      * Requirements:
145      * - If the caller is not `from`, it must be approved to move this NFT by
146      * either `approve` or `setApproveForAll`.
147      */
148     function transferFrom(address from, address to, uint256 tokenId) public;
149     function approve(address to, uint256 tokenId) public;
150     function getApproved(uint256 tokenId) public view returns (address operator);
151 
152     function setApprovalForAll(address operator, bool _approved) public;
153     function isApprovedForAll(address owner, address operator) public view returns (bool);
154 
155 
156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
157 }
158 
159 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
160 
161 pragma solidity ^0.5.0;
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 contract IERC721Receiver {
169     /**
170      * @notice Handle the receipt of an NFT
171      * @dev The ERC721 smart contract calls this function on the recipient
172      * after a `safeTransfer`. This function MUST return the function selector,
173      * otherwise the caller will revert the transaction. The selector to be
174      * returned can be obtained as `this.onERC721Received.selector`. This
175      * function MAY throw to revert and reject the transfer.
176      * Note: the ERC721 contract address is always the message sender.
177      * @param operator The address which called `safeTransferFrom` function
178      * @param from The address which previously owned the token
179      * @param tokenId The NFT identifier which is being transferred
180      * @param data Additional data with no specified format
181      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
182      */
183     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
184     public returns (bytes4);
185 }
186 
187 // File: @openzeppelin/contracts/math/SafeMath.sol
188 
189 pragma solidity ^0.5.0;
190 
191 /**
192  * @dev Wrappers over Solidity's arithmetic operations with added overflow
193  * checks.
194  *
195  * Arithmetic operations in Solidity wrap on overflow. This can easily result
196  * in bugs, because programmers usually assume that an overflow raises an
197  * error, which is the standard behavior in high level programming languages.
198  * `SafeMath` restores this intuition by reverting the transaction when an
199  * operation overflows.
200  *
201  * Using this library instead of the unchecked operations eliminates an entire
202  * class of bugs, so it's recommended to use it always.
203  */
204 library SafeMath {
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b <= a, "SafeMath: subtraction overflow");
232         uint256 c = a - b;
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
248         // benefit is lost if 'b' is also tested.
249         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
250         if (a == 0) {
251             return 0;
252         }
253 
254         uint256 c = a * b;
255         require(c / a == b, "SafeMath: multiplication overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers. Reverts on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Solidity only automatically asserts when dividing by 0
273         require(b > 0, "SafeMath: division by zero");
274         uint256 c = a / b;
275         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * Reverts when dividing by zero.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         require(b != 0, "SafeMath: modulo by zero");
293         return a % b;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 pragma solidity ^0.5.0;
300 
301 /**
302  * @dev Collection of functions related to the address type,
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * This test is non-exhaustive, and there may be false-negatives: during the
309      * execution of a contract's constructor, its address will be reported as
310      * not containing a contract.
311      *
312      * > It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies in extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         // solhint-disable-next-line no-inline-assembly
322         assembly { size := extcodesize(account) }
323         return size > 0;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/drafts/Counters.sol
328 
329 pragma solidity ^0.5.0;
330 
331 
332 /**
333  * @title Counters
334  * @author Matt Condon (@shrugs)
335  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
336  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
337  *
338  * Include with `using Counters for Counters.Counter;`
339  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
340  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
341  * directly accessed.
342  */
343 library Counters {
344     using SafeMath for uint256;
345 
346     struct Counter {
347         // This variable should never be directly accessed by users of the library: interactions must be restricted to
348         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
349         // this feature: see https://github.com/ethereum/solidity/issues/4637
350         uint256 _value; // default: 0
351     }
352 
353     function current(Counter storage counter) internal view returns (uint256) {
354         return counter._value;
355     }
356 
357     function increment(Counter storage counter) internal {
358         counter._value += 1;
359     }
360 
361     function decrement(Counter storage counter) internal {
362         counter._value = counter._value.sub(1);
363     }
364 }
365 
366 // File: @openzeppelin/contracts/introspection/ERC165.sol
367 
368 pragma solidity ^0.5.0;
369 
370 
371 /**
372  * @dev Implementation of the `IERC165` interface.
373  *
374  * Contracts may inherit from this and call `_registerInterface` to declare
375  * their support of an interface.
376  */
377 contract ERC165 is IERC165 {
378     /*
379      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
380      */
381     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
382 
383     /**
384      * @dev Mapping of interface ids to whether or not it's supported.
385      */
386     mapping(bytes4 => bool) private _supportedInterfaces;
387 
388     constructor () internal {
389         // Derived contracts need only register support for their own interfaces,
390         // we register support for ERC165 itself here
391         _registerInterface(_INTERFACE_ID_ERC165);
392     }
393 
394     /**
395      * @dev See `IERC165.supportsInterface`.
396      *
397      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
398      */
399     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
400         return _supportedInterfaces[interfaceId];
401     }
402 
403     /**
404      * @dev Registers the contract as an implementer of the interface defined by
405      * `interfaceId`. Support of the actual ERC165 interface is automatic and
406      * registering its interface id is not required.
407      *
408      * See `IERC165.supportsInterface`.
409      *
410      * Requirements:
411      *
412      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
413      */
414     function _registerInterface(bytes4 interfaceId) internal {
415         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
416         _supportedInterfaces[interfaceId] = true;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
421 
422 pragma solidity ^0.5.0;
423 
424 
425 
426 
427 
428 
429 
430 /**
431  * @title ERC721 Non-Fungible Token Standard basic implementation
432  * @dev see https://eips.ethereum.org/EIPS/eip-721
433  */
434 contract ERC721 is ERC165, IERC721 {
435     using SafeMath for uint256;
436     using Address for address;
437     using Counters for Counters.Counter;
438 
439     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
440     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
441     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
442 
443     // Mapping from token ID to owner
444     mapping (uint256 => address) private _tokenOwner;
445 
446     // Mapping from token ID to approved address
447     mapping (uint256 => address) private _tokenApprovals;
448 
449     // Mapping from owner to number of owned token
450     mapping (address => Counters.Counter) private _ownedTokensCount;
451 
452     // Mapping from owner to operator approvals
453     mapping (address => mapping (address => bool)) private _operatorApprovals;
454 
455     /*
456      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
457      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
458      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
459      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
460      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
461      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
462      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
463      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
464      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
465      *
466      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
467      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
468      */
469     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
470 
471     constructor () public {
472         // register the supported interfaces to conform to ERC721 via ERC165
473         _registerInterface(_INTERFACE_ID_ERC721);
474     }
475 
476     /**
477      * @dev Gets the balance of the specified address.
478      * @param owner address to query the balance of
479      * @return uint256 representing the amount owned by the passed address
480      */
481     function balanceOf(address owner) public view returns (uint256) {
482         require(owner != address(0), "ERC721: balance query for the zero address");
483 
484         return _ownedTokensCount[owner].current();
485     }
486 
487     /**
488      * @dev Gets the owner of the specified token ID.
489      * @param tokenId uint256 ID of the token to query the owner of
490      * @return address currently marked as the owner of the given token ID
491      */
492     function ownerOf(uint256 tokenId) public view returns (address) {
493         address owner = _tokenOwner[tokenId];
494         require(owner != address(0), "ERC721: owner query for nonexistent token");
495 
496         return owner;
497     }
498 
499     /**
500      * @dev Approves another address to transfer the given token ID
501      * The zero address indicates there is no approved address.
502      * There can only be one approved address per token at a given time.
503      * Can only be called by the token owner or an approved operator.
504      * @param to address to be approved for the given token ID
505      * @param tokenId uint256 ID of the token to be approved
506      */
507     function approve(address to, uint256 tokenId) public {
508         address owner = ownerOf(tokenId);
509         require(to != owner, "ERC721: approval to current owner");
510 
511         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
512             "ERC721: approve caller is not owner nor approved for all"
513         );
514 
515         _tokenApprovals[tokenId] = to;
516         emit Approval(owner, to, tokenId);
517     }
518 
519     /**
520      * @dev Gets the approved address for a token ID, or zero if no address set
521      * Reverts if the token ID does not exist.
522      * @param tokenId uint256 ID of the token to query the approval of
523      * @return address currently approved for the given token ID
524      */
525     function getApproved(uint256 tokenId) public view returns (address) {
526         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
527 
528         return _tokenApprovals[tokenId];
529     }
530 
531     /**
532      * @dev Sets or unsets the approval of a given operator
533      * An operator is allowed to transfer all tokens of the sender on their behalf.
534      * @param to operator address to set the approval
535      * @param approved representing the status of the approval to be set
536      */
537     function setApprovalForAll(address to, bool approved) public {
538         require(to != msg.sender, "ERC721: approve to caller");
539 
540         _operatorApprovals[msg.sender][to] = approved;
541         emit ApprovalForAll(msg.sender, to, approved);
542     }
543 
544     /**
545      * @dev Tells whether an operator is approved by a given owner.
546      * @param owner owner address which you want to query the approval of
547      * @param operator operator address which you want to query the approval of
548      * @return bool whether the given operator is approved by the given owner
549      */
550     function isApprovedForAll(address owner, address operator) public view returns (bool) {
551         return _operatorApprovals[owner][operator];
552     }
553 
554     /**
555      * @dev Transfers the ownership of a given token ID to another address.
556      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
557      * Requires the msg.sender to be the owner, approved, or operator.
558      * @param from current owner of the token
559      * @param to address to receive the ownership of the given token ID
560      * @param tokenId uint256 ID of the token to be transferred
561      */
562     function transferFrom(address from, address to, uint256 tokenId) public {
563         //solhint-disable-next-line max-line-length
564         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
565 
566         _transferFrom(from, to, tokenId);
567     }
568 
569     /**
570      * @dev Safely transfers the ownership of a given token ID to another address
571      * If the target address is a contract, it must implement `onERC721Received`,
572      * which is called upon a safe transfer, and return the magic value
573      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
574      * the transfer is reverted.
575      * Requires the msg.sender to be the owner, approved, or operator
576      * @param from current owner of the token
577      * @param to address to receive the ownership of the given token ID
578      * @param tokenId uint256 ID of the token to be transferred
579      */
580     function safeTransferFrom(address from, address to, uint256 tokenId) public {
581         safeTransferFrom(from, to, tokenId, "");
582     }
583 
584     /**
585      * @dev Safely transfers the ownership of a given token ID to another address
586      * If the target address is a contract, it must implement `onERC721Received`,
587      * which is called upon a safe transfer, and return the magic value
588      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
589      * the transfer is reverted.
590      * Requires the msg.sender to be the owner, approved, or operator
591      * @param from current owner of the token
592      * @param to address to receive the ownership of the given token ID
593      * @param tokenId uint256 ID of the token to be transferred
594      * @param _data bytes data to send along with a safe transfer check
595      */
596     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
597         transferFrom(from, to, tokenId);
598         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
599     }
600 
601     /**
602      * @dev Returns whether the specified token exists.
603      * @param tokenId uint256 ID of the token to query the existence of
604      * @return bool whether the token exists
605      */
606     function _exists(uint256 tokenId) internal view returns (bool) {
607         address owner = _tokenOwner[tokenId];
608         return owner != address(0);
609     }
610 
611     /**
612      * @dev Returns whether the given spender can transfer a given token ID.
613      * @param spender address of the spender to query
614      * @param tokenId uint256 ID of the token to be transferred
615      * @return bool whether the msg.sender is approved for the given token ID,
616      * is an operator of the owner, or is the owner of the token
617      */
618     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
619         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
620         address owner = ownerOf(tokenId);
621         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
622     }
623 
624     /**
625      * @dev Internal function to mint a new token.
626      * Reverts if the given token ID already exists.
627      * @param to The address that will own the minted token
628      * @param tokenId uint256 ID of the token to be minted
629      */
630     function _mint(address to, uint256 tokenId) internal {
631         require(to != address(0), "ERC721: mint to the zero address");
632         require(!_exists(tokenId), "ERC721: token already minted");
633 
634         _tokenOwner[tokenId] = to;
635         _ownedTokensCount[to].increment();
636 
637         emit Transfer(address(0), to, tokenId);
638     }
639 
640     /**
641      * @dev Internal function to burn a specific token.
642      * Reverts if the token does not exist.
643      * Deprecated, use _burn(uint256) instead.
644      * @param owner owner of the token to burn
645      * @param tokenId uint256 ID of the token being burned
646      */
647     function _burn(address owner, uint256 tokenId) internal {
648         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
649 
650         _clearApproval(tokenId);
651 
652         _ownedTokensCount[owner].decrement();
653         _tokenOwner[tokenId] = address(0);
654 
655         emit Transfer(owner, address(0), tokenId);
656     }
657 
658     /**
659      * @dev Internal function to burn a specific token.
660      * Reverts if the token does not exist.
661      * @param tokenId uint256 ID of the token being burned
662      */
663     function _burn(uint256 tokenId) internal {
664         _burn(ownerOf(tokenId), tokenId);
665     }
666 
667     /**
668      * @dev Internal function to transfer ownership of a given token ID to another address.
669      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
670      * @param from current owner of the token
671      * @param to address to receive the ownership of the given token ID
672      * @param tokenId uint256 ID of the token to be transferred
673      */
674     function _transferFrom(address from, address to, uint256 tokenId) internal {
675         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
676         require(to != address(0), "ERC721: transfer to the zero address");
677 
678         _clearApproval(tokenId);
679 
680         _ownedTokensCount[from].decrement();
681         _ownedTokensCount[to].increment();
682 
683         _tokenOwner[tokenId] = to;
684 
685         emit Transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev Internal function to invoke `onERC721Received` on a target address.
690      * The call is not executed if the target address is not a contract.
691      *
692      * This function is deprecated.
693      * @param from address representing the previous owner of the given token ID
694      * @param to target address that will receive the tokens
695      * @param tokenId uint256 ID of the token to be transferred
696      * @param _data bytes optional data to send along with the call
697      * @return bool whether the call correctly returned the expected magic value
698      */
699     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
700         internal returns (bool)
701     {
702         if (!to.isContract()) {
703             return true;
704         }
705 
706         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
707         return (retval == _ERC721_RECEIVED);
708     }
709 
710     /**
711      * @dev Private function to clear current approval of a given token ID.
712      * @param tokenId uint256 ID of the token to be transferred
713      */
714     function _clearApproval(uint256 tokenId) private {
715         if (_tokenApprovals[tokenId] != address(0)) {
716             _tokenApprovals[tokenId] = address(0);
717         }
718     }
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
722 
723 pragma solidity ^0.5.0;
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 contract IERC721Enumerable is IERC721 {
731     function totalSupply() public view returns (uint256);
732     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
733 
734     function tokenByIndex(uint256 index) public view returns (uint256);
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
738 
739 pragma solidity ^0.5.0;
740 
741 
742 
743 
744 /**
745  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
746  * @dev See https://eips.ethereum.org/EIPS/eip-721
747  */
748 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
749     // Mapping from owner to list of owned token IDs
750     mapping(address => uint256[]) private _ownedTokens;
751 
752     // Mapping from token ID to index of the owner tokens list
753     mapping(uint256 => uint256) private _ownedTokensIndex;
754 
755     // Array with all token ids, used for enumeration
756     uint256[] private _allTokens;
757 
758     // Mapping from token id to position in the allTokens array
759     mapping(uint256 => uint256) private _allTokensIndex;
760 
761     /*
762      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
763      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
764      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
765      *
766      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
767      */
768     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
769 
770     /**
771      * @dev Constructor function.
772      */
773     constructor () public {
774         // register the supported interface to conform to ERC721Enumerable via ERC165
775         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
776     }
777 
778     /**
779      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
780      * @param owner address owning the tokens list to be accessed
781      * @param index uint256 representing the index to be accessed of the requested tokens list
782      * @return uint256 token ID at the given index of the tokens list owned by the requested address
783      */
784     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
785         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
786         return _ownedTokens[owner][index];
787     }
788 
789     /**
790      * @dev Gets the total amount of tokens stored by the contract.
791      * @return uint256 representing the total amount of tokens
792      */
793     function totalSupply() public view returns (uint256) {
794         return _allTokens.length;
795     }
796 
797     /**
798      * @dev Gets the token ID at a given index of all the tokens in this contract
799      * Reverts if the index is greater or equal to the total number of tokens.
800      * @param index uint256 representing the index to be accessed of the tokens list
801      * @return uint256 token ID at the given index of the tokens list
802      */
803     function tokenByIndex(uint256 index) public view returns (uint256) {
804         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
805         return _allTokens[index];
806     }
807 
808     /**
809      * @dev Internal function to transfer ownership of a given token ID to another address.
810      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
811      * @param from current owner of the token
812      * @param to address to receive the ownership of the given token ID
813      * @param tokenId uint256 ID of the token to be transferred
814      */
815     function _transferFrom(address from, address to, uint256 tokenId) internal {
816         super._transferFrom(from, to, tokenId);
817 
818         _removeTokenFromOwnerEnumeration(from, tokenId);
819 
820         _addTokenToOwnerEnumeration(to, tokenId);
821     }
822 
823     /**
824      * @dev Internal function to mint a new token.
825      * Reverts if the given token ID already exists.
826      * @param to address the beneficiary that will own the minted token
827      * @param tokenId uint256 ID of the token to be minted
828      */
829     function _mint(address to, uint256 tokenId) internal {
830         super._mint(to, tokenId);
831 
832         _addTokenToOwnerEnumeration(to, tokenId);
833 
834         _addTokenToAllTokensEnumeration(tokenId);
835     }
836 
837     /**
838      * @dev Internal function to burn a specific token.
839      * Reverts if the token does not exist.
840      * Deprecated, use _burn(uint256) instead.
841      * @param owner owner of the token to burn
842      * @param tokenId uint256 ID of the token being burned
843      */
844     function _burn(address owner, uint256 tokenId) internal {
845         super._burn(owner, tokenId);
846 
847         _removeTokenFromOwnerEnumeration(owner, tokenId);
848         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
849         _ownedTokensIndex[tokenId] = 0;
850 
851         _removeTokenFromAllTokensEnumeration(tokenId);
852     }
853 
854     /**
855      * @dev Gets the list of token IDs of the requested owner.
856      * @param owner address owning the tokens
857      * @return uint256[] List of token IDs owned by the requested address
858      */
859     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
860         return _ownedTokens[owner];
861     }
862 
863     /**
864      * @dev Private function to add a token to this extension's ownership-tracking data structures.
865      * @param to address representing the new owner of the given token ID
866      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
867      */
868     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
869         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
870         _ownedTokens[to].push(tokenId);
871     }
872 
873     /**
874      * @dev Private function to add a token to this extension's token tracking data structures.
875      * @param tokenId uint256 ID of the token to be added to the tokens list
876      */
877     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
878         _allTokensIndex[tokenId] = _allTokens.length;
879         _allTokens.push(tokenId);
880     }
881 
882     /**
883      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
884      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
885      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
886      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
887      * @param from address representing the previous owner of the given token ID
888      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
889      */
890     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
891         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
892         // then delete the last slot (swap and pop).
893 
894         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
895         uint256 tokenIndex = _ownedTokensIndex[tokenId];
896 
897         // When the token to delete is the last token, the swap operation is unnecessary
898         if (tokenIndex != lastTokenIndex) {
899             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
900 
901             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
902             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
903         }
904 
905         // This also deletes the contents at the last position of the array
906         _ownedTokens[from].length--;
907 
908         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
909         // lastTokenId, or just over the end of the array if the token was the last one).
910     }
911 
912     /**
913      * @dev Private function to remove a token from this extension's token tracking data structures.
914      * This has O(1) time complexity, but alters the order of the _allTokens array.
915      * @param tokenId uint256 ID of the token to be removed from the tokens list
916      */
917     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
918         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
919         // then delete the last slot (swap and pop).
920 
921         uint256 lastTokenIndex = _allTokens.length.sub(1);
922         uint256 tokenIndex = _allTokensIndex[tokenId];
923 
924         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
925         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
926         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
927         uint256 lastTokenId = _allTokens[lastTokenIndex];
928 
929         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
930         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
931 
932         // This also deletes the contents at the last position of the array
933         _allTokens.length--;
934         _allTokensIndex[tokenId] = 0;
935     }
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
939 
940 pragma solidity ^0.5.0;
941 
942 
943 /**
944  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
945  * @dev See https://eips.ethereum.org/EIPS/eip-721
946  */
947 contract IERC721Metadata is IERC721 {
948     function name() external view returns (string memory);
949     function symbol() external view returns (string memory);
950     function tokenURI(uint256 tokenId) external view returns (string memory);
951 }
952 
953 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
954 
955 pragma solidity ^0.5.0;
956 
957 
958 
959 
960 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
961     // Token name
962     string private _name;
963 
964     // Token symbol
965     string private _symbol;
966 
967     // Optional mapping for token URIs
968     mapping(uint256 => string) private _tokenURIs;
969 
970     /*
971      *     bytes4(keccak256('name()')) == 0x06fdde03
972      *     bytes4(keccak256('symbol()')) == 0x95d89b41
973      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
974      *
975      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
976      */
977     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
978 
979     /**
980      * @dev Constructor function
981      */
982     constructor (string memory name, string memory symbol) public {
983         _name = name;
984         _symbol = symbol;
985 
986         // register the supported interfaces to conform to ERC721 via ERC165
987         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
988     }
989 
990     /**
991      * @dev Gets the token name.
992      * @return string representing the token name
993      */
994     function name() external view returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev Gets the token symbol.
1000      * @return string representing the token symbol
1001      */
1002     function symbol() external view returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev Returns an URI for a given token ID.
1008      * Throws if the token ID does not exist. May return an empty string.
1009      * @param tokenId uint256 ID of the token to query
1010      */
1011     function tokenURI(uint256 tokenId) external view returns (string memory) {
1012         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1013         return _tokenURIs[tokenId];
1014     }
1015 
1016     /**
1017      * @dev Internal function to set the token URI for a given token.
1018      * Reverts if the token ID does not exist.
1019      * @param tokenId uint256 ID of the token to set its URI
1020      * @param uri string URI to assign
1021      */
1022     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1023         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1024         _tokenURIs[tokenId] = uri;
1025     }
1026 
1027     /**
1028      * @dev Internal function to burn a specific token.
1029      * Reverts if the token does not exist.
1030      * Deprecated, use _burn(uint256) instead.
1031      * @param owner owner of the token to burn
1032      * @param tokenId uint256 ID of the token being burned by the msg.sender
1033      */
1034     function _burn(address owner, uint256 tokenId) internal {
1035         super._burn(owner, tokenId);
1036 
1037         // Clear metadata (if any)
1038         if (bytes(_tokenURIs[tokenId]).length != 0) {
1039             delete _tokenURIs[tokenId];
1040         }
1041     }
1042 }
1043 
1044 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1045 
1046 pragma solidity ^0.5.0;
1047 
1048 
1049 
1050 
1051 /**
1052  * @title Full ERC721 Token
1053  * This implementation includes all the required and some optional functionality of the ERC721 standard
1054  * Moreover, it includes approve all functionality using operator terminology
1055  * @dev see https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1058     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1059         // solhint-disable-previous-line no-empty-blocks
1060     }
1061 }
1062 
1063 // File: contracts/ERC721Collection.sol
1064 
1065 pragma solidity ^0.5.11;
1066 
1067 
1068 
1069 
1070 contract ERC721Collection is Ownable, ERC721Full {
1071     mapping(bytes32 => uint256) public maxIssuance;
1072     mapping(bytes32 => uint) public issued;
1073     mapping(uint256 => string) internal _tokenPaths;
1074     mapping(address => bool) public allowed;
1075 
1076     string[] public wearables;
1077 
1078     string public baseURI;
1079     bool public isComplete;
1080 
1081     event BaseURI(string _oldBaseURI, string _newBaseURI);
1082     event Allowed(address indexed _operator, bool _allowed);
1083     event AddWearable(bytes32 indexed _wearableIdKey, string _wearableId, uint256 _maxIssuance);
1084     event Issue(address indexed _beneficiary, uint256 indexed _tokenId, bytes32 indexed _wearableIdKey, string _wearableId, uint256 _issuedId);
1085     event Complete();
1086 
1087 
1088     /**
1089      * @dev Create the contract.
1090      * @param _name - name of the contract
1091      * @param _symbol - symbol of the contract
1092      * @param _operator - Address allowed to mint tokens
1093      * @param _baseURI - base URI for token URIs
1094      */
1095     constructor(string memory _name, string memory _symbol, address _operator, string memory _baseURI) public ERC721Full(_name, _symbol) {
1096         setAllowed(_operator, true);
1097         setBaseURI(_baseURI);
1098     }
1099 
1100     modifier onlyAllowed() {
1101         require(allowed[msg.sender], "Only an `allowed` address can issue tokens");
1102         _;
1103     }
1104 
1105 
1106     /**
1107      * @dev Issue a new NFT of the specified kind.
1108      * @notice that will throw if kind has reached its maximum or is invalid
1109      * @param _beneficiary - owner of the token
1110      * @param _wearableId - token wearable
1111      */
1112     function issueToken(address _beneficiary, string calldata _wearableId) external onlyAllowed {
1113         _issueToken(_beneficiary, _wearableId);
1114     }
1115 
1116     /**
1117      * @dev Issue NFTs.
1118      * @notice that will throw if kind has reached its maximum or is invalid
1119      * @param _beneficiaries - owner of the tokens
1120      * @param _wearableIds - token wearables
1121      */
1122     function issueTokens(address[] calldata _beneficiaries, bytes32[] calldata _wearableIds) external onlyAllowed {
1123         require(_beneficiaries.length == _wearableIds.length, "Parameters should have the same length");
1124 
1125         for(uint256 i = 0; i < _wearableIds.length; i++) {
1126             _issueToken(_beneficiaries[i], _bytes32ToString(_wearableIds[i]));
1127         }
1128     }
1129 
1130 
1131     /**
1132      * @dev Set Base URI.
1133      * @param _baseURI - base URI for token URIs
1134      */
1135     function setBaseURI(string memory _baseURI) public onlyOwner {
1136         emit BaseURI(baseURI, _baseURI);
1137         baseURI = _baseURI;
1138     }
1139 
1140     /**
1141      * @dev Set allowed account to issue tokens.
1142      * @param _operator - Address allowed to issue tokens
1143      * @param _allowed - Whether is allowed or not
1144      */
1145     function setAllowed(address _operator, bool _allowed) public onlyOwner {
1146         require(_operator != address(0), "Invalid address");
1147         require(allowed[_operator] != _allowed, "You should set a different value");
1148 
1149         allowed[_operator] = _allowed;
1150         emit Allowed(_operator, _allowed);
1151     }
1152 
1153 
1154     /**
1155      * @dev Returns an URI for a given token ID.
1156      * Throws if the token ID does not exist. May return an empty string.
1157      * @param _tokenId - uint256 ID of the token queried
1158      * @return token URI
1159      */
1160     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1161         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1162         return string(abi.encodePacked(baseURI, _tokenPaths[_tokenId]));
1163     }
1164 
1165 
1166     /**
1167      * @dev Transfers the ownership of given tokens ID to another address.
1168      * Usage of this method is discouraged, use {safeBatchTransferFrom} whenever possible.
1169      * Requires the msg.sender to be the owner, approved, or operator.
1170      * @param _from current owner of the token
1171      * @param _to address to receive the ownership of the given token ID
1172      * @param _tokenIds uint256 ID of the token to be transferred
1173      */
1174     function batchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds) external {
1175         for (uint256 i = 0; i < _tokenIds.length; i++) {
1176             transferFrom(_from, _to, _tokenIds[i]);
1177         }
1178     }
1179 
1180     /**
1181      * @dev Returns the wearables length.
1182      * @return wearable length
1183      */
1184     function wearablesCount() external view returns (uint256) {
1185         return wearables.length;
1186     }
1187 
1188     /**
1189      * @dev Complete the collection.
1190      * @notice that it will only prevent for adding more wearables.
1191      * The issuance is still allowed.
1192      */
1193     function completeCollection() external onlyOwner {
1194         require(!isComplete, "The collection is already completed");
1195         isComplete = true;
1196         emit Complete();
1197     }
1198 
1199      /**
1200      * @dev Add a new wearable to the collection.
1201      * @notice that this method should only allow wearableIds less than or equal to 32 bytes
1202      * @param _wearableIds - wearable ids
1203      * @param _maxIssuances - total supply for the wearables
1204      */
1205     function addWearables(bytes32[] calldata _wearableIds, uint256[] calldata _maxIssuances) external onlyOwner {
1206         require(_wearableIds.length == _maxIssuances.length, "Parameters should have the same length");
1207 
1208         for (uint256 i = 0; i < _wearableIds.length; i++) {
1209             addWearable(_bytes32ToString(_wearableIds[i]), _maxIssuances[i]);
1210         }
1211     }
1212 
1213     /**
1214      * @dev Add a new wearable to the collection.
1215      * @notice that this method allows wearableIds of any size. It should be used
1216      * if a wearableId is greater than 32 bytes
1217      * @param _wearableId - wearable id
1218      * @param _maxIssuance - total supply for the wearable
1219      */
1220     function addWearable(string memory _wearableId, uint256 _maxIssuance) public onlyOwner {
1221         require(!isComplete, "The collection is complete");
1222         bytes32 key = getWearableKey(_wearableId);
1223 
1224         require(maxIssuance[key] == 0, "Can not modify an existing wearable");
1225         require(_maxIssuance > 0, "Max issuance should be greater than 0");
1226 
1227         maxIssuance[key] = _maxIssuance;
1228         wearables.push(_wearableId);
1229 
1230         emit AddWearable(key, _wearableId, _maxIssuance);
1231     }
1232 
1233     /**
1234      * @dev Safely transfers the ownership of given token IDs to another address
1235      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1236      * which is called upon a safe transfer, and return the magic value
1237      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1238      * the transfer is reverted.
1239      * Requires the msg.sender to be the owner, approved, or operator
1240      * @param _from - current owner of the token
1241      * @param _to - address to receive the ownership of the given token ID
1242      * @param _tokenIds - uint256 IDs of the tokens to be transferred
1243      */
1244     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1245         safeBatchTransferFrom(_from, _to, _tokenIds, "");
1246     }
1247 
1248     /**
1249      * @dev Safely transfers the ownership of given token IDs to another address
1250      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1251      * which is called upon a safe transfer, and return the magic value
1252      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1253      * the transfer is reverted.
1254      * Requires the msg.sender to be the owner, approved, or operator
1255      * @param _from - current owner of the token
1256      * @param _to - address to receive the ownership of the given token ID
1257      * @param _tokenIds - uint256 ID of the tokens to be transferred
1258      * @param _data bytes data to send along with a safe transfer check
1259      */
1260     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory _data) public {
1261         for (uint256 i = 0; i < _tokenIds.length; i++) {
1262             safeTransferFrom(_from, _to, _tokenIds[i], _data);
1263         }
1264     }
1265 
1266     /**
1267      * @dev Get keccak256 of a wearableId.
1268      * @param _wearableId - token wearable
1269      * @return bytes32 keccak256 of the wearableId
1270      */
1271     function getWearableKey(string memory _wearableId) public pure returns (bytes32) {
1272         return keccak256(abi.encodePacked(_wearableId));
1273     }
1274 
1275     /**
1276      * @dev Issue a new NFT of the specified kind.
1277      * @notice that will throw if kind has reached its maximum or is invalid
1278      * @param _beneficiary - owner of the token
1279      * @param _wearableId - token wearable
1280      */
1281     function _issueToken(address _beneficiary, string memory _wearableId) internal {
1282         bytes32 key = getWearableKey(_wearableId);
1283         if (maxIssuance[key] > 0 && issued[key] < maxIssuance[key]) {
1284             issued[key] = issued[key] + 1;
1285             uint tokenId = this.totalSupply();
1286 
1287             _mint(_beneficiary, tokenId);
1288             _setTokenURI(
1289                 tokenId,
1290                 string(abi.encodePacked(_wearableId, "/", _uintToString(issued[key])))
1291             );
1292 
1293             emit Issue(_beneficiary, tokenId, key, _wearableId, issued[key]);
1294         } else {
1295             revert("invalid: trying to issue an exhausted wearable of nft");
1296         }
1297     }
1298 
1299     /**
1300      * @dev Internal function to set the token URI for a given token.
1301      * Reverts if the token ID does not exist.
1302      * @param _tokenId - uint256 ID of the token to set as its URI
1303      * @param _uri - string URI to assign
1304      */
1305     function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
1306         require(_exists(_tokenId), "ERC721Metadata: calling set URI for a nonexistent token");
1307         _tokenPaths[_tokenId] = _uri;
1308     }
1309 
1310     /**
1311      * @dev Convert bytes32 to string.
1312      * @param _x - to be converted to string.
1313      * @return string
1314      */
1315     function _bytes32ToString(bytes32 _x) internal pure returns (string memory) {
1316         bytes memory bytesString = new bytes(32);
1317         uint charCount = 0;
1318         for (uint j = 0; j < 32; j++) {
1319             byte char = byte(bytes32(uint(_x) * 2 ** (8 * j)));
1320             if (char != 0) {
1321                 bytesString[charCount] = char;
1322                 charCount++;
1323             }
1324         }
1325         bytes memory bytesStringTrimmed = new bytes(charCount);
1326         for (uint j = 0; j < charCount; j++) {
1327             bytesStringTrimmed[j] = bytesString[j];
1328         }
1329         return string(bytesStringTrimmed);
1330     }
1331 
1332 
1333      /**
1334      * @dev Convert uint to string.
1335      * @param _i - uint256 to be converted to string.
1336      * @return uint in string
1337      */
1338     function _uintToString(uint _i) internal pure returns (string memory _uintAsString) {
1339         if (_i == 0) {
1340             return "0";
1341         }
1342         uint j = _i;
1343         uint len;
1344         while (j != 0) {
1345             len++;
1346             j /= 10;
1347         }
1348         bytes memory bstr = new bytes(len);
1349         uint k = len - 1;
1350         while (_i != 0) {
1351             bstr[k--] = byte(uint8(48 + _i % 10));
1352             _i /= 10;
1353         }
1354         return string(bstr);
1355     }
1356 }