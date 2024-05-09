1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-02
3 */
4 
5 // File: @openzeppelin/contracts/ownership/Ownable.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Contract module which provides a basic access control mechanism, where
11  * there is an account (an owner) that can be granted exclusive access to
12  * specific functions.
13  *
14  * This module is used through inheritance. It will make available the modifier
15  * `onlyOwner`, which can be aplied to your functions to restrict their use to
16  * the owner.
17  */
18 contract Ownable {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor () internal {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(isOwner(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Returns true if the caller is the current owner.
48      */
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     /**
54      * @dev Leaves the contract without owner. It will not be possible to call
55      * `onlyOwner` functions anymore. Can only be called by the current owner.
56      *
57      * > Note: Renouncing ownership will leave the contract without an owner,
58      * thereby removing any functionality that is only available to the owner.
59      */
60     function renounceOwnership() public onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Can only be called by the current owner.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      */
76     function _transferOwnership(address newOwner) internal {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/introspection/IERC165.sol
84 
85 pragma solidity ^0.5.0;
86 
87 /**
88  * @dev Interface of the ERC165 standard, as defined in the
89  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
90  *
91  * Implementers can declare support of contract interfaces, which can then be
92  * queried by others (`ERC165Checker`).
93  *
94  * For an implementation, see `ERC165`.
95  */
96 interface IERC165 {
97     /**
98      * @dev Returns true if this contract implements the interface defined by
99      * `interfaceId`. See the corresponding
100      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
101      * to learn more about how these ids are created.
102      *
103      * This function call must use less than 30 000 gas.
104      */
105     function supportsInterface(bytes4 interfaceId) external view returns (bool);
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
109 
110 pragma solidity ^0.5.0;
111 
112 
113 /**
114  * @dev Required interface of an ERC721 compliant contract.
115  */
116 contract IERC721 is IERC165 {
117     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
118     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
120 
121     /**
122      * @dev Returns the number of NFTs in `owner`'s account.
123      */
124     function balanceOf(address owner) public view returns (uint256 balance);
125 
126     /**
127      * @dev Returns the owner of the NFT specified by `tokenId`.
128      */
129     function ownerOf(uint256 tokenId) public view returns (address owner);
130 
131     /**
132      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
133      * another (`to`).
134      *
135      * 
136      *
137      * Requirements:
138      * - `from`, `to` cannot be zero.
139      * - `tokenId` must be owned by `from`.
140      * - If the caller is not `from`, it must be have been allowed to move this
141      * NFT by either `approve` or `setApproveForAll`.
142      */
143     function safeTransferFrom(address from, address to, uint256 tokenId) public;
144     /**
145      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
146      * another (`to`).
147      *
148      * Requirements:
149      * - If the caller is not `from`, it must be approved to move this NFT by
150      * either `approve` or `setApproveForAll`.
151      */
152     function transferFrom(address from, address to, uint256 tokenId) public;
153     function approve(address to, uint256 tokenId) public;
154     function getApproved(uint256 tokenId) public view returns (address operator);
155 
156     function setApprovalForAll(address operator, bool _approved) public;
157     function isApprovedForAll(address owner, address operator) public view returns (bool);
158 
159 
160     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
164 
165 pragma solidity ^0.5.0;
166 
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 contract IERC721Receiver {
173     /**
174      * @notice Handle the receipt of an NFT
175      * @dev The ERC721 smart contract calls this function on the recipient
176      * after a `safeTransfer`. This function MUST return the function selector,
177      * otherwise the caller will revert the transaction. The selector to be
178      * returned can be obtained as `this.onERC721Received.selector`. This
179      * function MAY throw to revert and reject the transfer.
180      * Note: the ERC721 contract address is always the message sender.
181      * @param operator The address which called `safeTransferFrom` function
182      * @param from The address which previously owned the token
183      * @param tokenId The NFT identifier which is being transferred
184      * @param data Additional data with no specified format
185      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
186      */
187     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
188     public returns (bytes4);
189 }
190 
191 // File: @openzeppelin/contracts/math/SafeMath.sol
192 
193 pragma solidity ^0.5.0;
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations with added overflow
197  * checks.
198  *
199  * Arithmetic operations in Solidity wrap on overflow. This can easily result
200  * in bugs, because programmers usually assume that an overflow raises an
201  * error, which is the standard behavior in high level programming languages.
202  * `SafeMath` restores this intuition by reverting the transaction when an
203  * operation overflows.
204  *
205  * Using this library instead of the unchecked operations eliminates an entire
206  * class of bugs, so it's recommended to use it always.
207  */
208 library SafeMath {
209     /**
210      * @dev Returns the addition of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `+` operator.
214      *
215      * Requirements:
216      * - Addition cannot overflow.
217      */
218     function add(uint256 a, uint256 b) internal pure returns (uint256) {
219         uint256 c = a + b;
220         require(c >= a, "SafeMath: addition overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b <= a, "SafeMath: subtraction overflow");
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `*` operator.
246      *
247      * Requirements:
248      * - Multiplication cannot overflow.
249      */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252         // benefit is lost if 'b' is also tested.
253         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254         if (a == 0) {
255             return 0;
256         }
257 
258         uint256 c = a * b;
259         require(c / a == b, "SafeMath: multiplication overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers. Reverts on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Solidity only automatically asserts when dividing by 0
277         require(b > 0, "SafeMath: division by zero");
278         uint256 c = a / b;
279         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         require(b != 0, "SafeMath: modulo by zero");
297         return a % b;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Address.sol
302 
303 pragma solidity ^0.5.0;
304 
305 /**
306  * @dev Collection of functions related to the address type,
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * This test is non-exhaustive, and there may be false-negatives: during the
313      * execution of a contract's constructor, its address will be reported as
314      * not containing a contract.
315      *
316      * > It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies in extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         // solhint-disable-next-line no-inline-assembly
326         assembly { size := extcodesize(account) }
327         return size > 0;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/drafts/Counters.sol
332 
333 pragma solidity ^0.5.0;
334 
335 
336 /**
337  * @title Counters
338  * @author Matt Condon (@shrugs)
339  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
340  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
341  *
342  * Include with `using Counters for Counters.Counter;`
343  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
344  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
345  * directly accessed.
346  */
347 library Counters {
348     using SafeMath for uint256;
349 
350     struct Counter {
351         // This variable should never be directly accessed by users of the library: interactions must be restricted to
352         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
353         // this feature: see https://github.com/ethereum/solidity/issues/4637
354         uint256 _value; // default: 0
355     }
356 
357     function current(Counter storage counter) internal view returns (uint256) {
358         return counter._value;
359     }
360 
361     function increment(Counter storage counter) internal {
362         counter._value += 1;
363     }
364 
365     function decrement(Counter storage counter) internal {
366         counter._value = counter._value.sub(1);
367     }
368 }
369 
370 // File: @openzeppelin/contracts/introspection/ERC165.sol
371 
372 pragma solidity ^0.5.0;
373 
374 
375 /**
376  * @dev Implementation of the `IERC165` interface.
377  *
378  * Contracts may inherit from this and call `_registerInterface` to declare
379  * their support of an interface.
380  */
381 contract ERC165 is IERC165 {
382     /*
383      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
384      */
385     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
386 
387     /**
388      * @dev Mapping of interface ids to whether or not it's supported.
389      */
390     mapping(bytes4 => bool) private _supportedInterfaces;
391 
392     constructor () internal {
393         // Derived contracts need only register support for their own interfaces,
394         // we register support for ERC165 itself here
395         _registerInterface(_INTERFACE_ID_ERC165);
396     }
397 
398     /**
399      * @dev See `IERC165.supportsInterface`.
400      *
401      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
402      */
403     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
404         return _supportedInterfaces[interfaceId];
405     }
406 
407     /**
408      * @dev Registers the contract as an implementer of the interface defined by
409      * `interfaceId`. Support of the actual ERC165 interface is automatic and
410      * registering its interface id is not required.
411      *
412      * See `IERC165.supportsInterface`.
413      *
414      * Requirements:
415      *
416      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
417      */
418     function _registerInterface(bytes4 interfaceId) internal {
419         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
420         _supportedInterfaces[interfaceId] = true;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 
430 
431 
432 
433 
434 /**
435  * @title ERC721 Non-Fungible Token Standard basic implementation
436  * @dev see https://eips.ethereum.org/EIPS/eip-721
437  */
438 contract ERC721 is ERC165, IERC721 {
439     using SafeMath for uint256;
440     using Address for address;
441     using Counters for Counters.Counter;
442 
443     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
444     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
445     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
446 
447     // Mapping from token ID to owner
448     mapping (uint256 => address) private _tokenOwner;
449 
450     // Mapping from token ID to approved address
451     mapping (uint256 => address) private _tokenApprovals;
452 
453     // Mapping from owner to number of owned token
454     mapping (address => Counters.Counter) private _ownedTokensCount;
455 
456     // Mapping from owner to operator approvals
457     mapping (address => mapping (address => bool)) private _operatorApprovals;
458 
459     /*
460      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
461      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
462      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
463      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
464      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
465      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
466      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
467      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
468      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
469      *
470      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
471      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
472      */
473     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
474 
475     constructor () public {
476         // register the supported interfaces to conform to ERC721 via ERC165
477         _registerInterface(_INTERFACE_ID_ERC721);
478     }
479 
480     /**
481      * @dev Gets the balance of the specified address.
482      * @param owner address to query the balance of
483      * @return uint256 representing the amount owned by the passed address
484      */
485     function balanceOf(address owner) public view returns (uint256) {
486         require(owner != address(0), "ERC721: balance query for the zero address");
487 
488         return _ownedTokensCount[owner].current();
489     }
490 
491     /**
492      * @dev Gets the owner of the specified token ID.
493      * @param tokenId uint256 ID of the token to query the owner of
494      * @return address currently marked as the owner of the given token ID
495      */
496     function ownerOf(uint256 tokenId) public view returns (address) {
497         address owner = _tokenOwner[tokenId];
498         require(owner != address(0), "ERC721: owner query for nonexistent token");
499 
500         return owner;
501     }
502 
503     /**
504      * @dev Approves another address to transfer the given token ID
505      * The zero address indicates there is no approved address.
506      * There can only be one approved address per token at a given time.
507      * Can only be called by the token owner or an approved operator.
508      * @param to address to be approved for the given token ID
509      * @param tokenId uint256 ID of the token to be approved
510      */
511     function approve(address to, uint256 tokenId) public {
512         address owner = ownerOf(tokenId);
513         require(to != owner, "ERC721: approval to current owner");
514 
515         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
516             "ERC721: approve caller is not owner nor approved for all"
517         );
518 
519         _tokenApprovals[tokenId] = to;
520         emit Approval(owner, to, tokenId);
521     }
522 
523     /**
524      * @dev Gets the approved address for a token ID, or zero if no address set
525      * Reverts if the token ID does not exist.
526      * @param tokenId uint256 ID of the token to query the approval of
527      * @return address currently approved for the given token ID
528      */
529     function getApproved(uint256 tokenId) public view returns (address) {
530         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
531 
532         return _tokenApprovals[tokenId];
533     }
534 
535     /**
536      * @dev Sets or unsets the approval of a given operator
537      * An operator is allowed to transfer all tokens of the sender on their behalf.
538      * @param to operator address to set the approval
539      * @param approved representing the status of the approval to be set
540      */
541     function setApprovalForAll(address to, bool approved) public {
542         require(to != msg.sender, "ERC721: approve to caller");
543 
544         _operatorApprovals[msg.sender][to] = approved;
545         emit ApprovalForAll(msg.sender, to, approved);
546     }
547 
548     /**
549      * @dev Tells whether an operator is approved by a given owner.
550      * @param owner owner address which you want to query the approval of
551      * @param operator operator address which you want to query the approval of
552      * @return bool whether the given operator is approved by the given owner
553      */
554     function isApprovedForAll(address owner, address operator) public view returns (bool) {
555         return _operatorApprovals[owner][operator];
556     }
557 
558     /**
559      * @dev Transfers the ownership of a given token ID to another address.
560      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
561      * Requires the msg.sender to be the owner, approved, or operator.
562      * @param from current owner of the token
563      * @param to address to receive the ownership of the given token ID
564      * @param tokenId uint256 ID of the token to be transferred
565      */
566     function transferFrom(address from, address to, uint256 tokenId) public {
567         //solhint-disable-next-line max-line-length
568         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
569 
570         _transferFrom(from, to, tokenId);
571     }
572 
573     /**
574      * @dev Safely transfers the ownership of a given token ID to another address
575      * If the target address is a contract, it must implement `onERC721Received`,
576      * which is called upon a safe transfer, and return the magic value
577      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
578      * the transfer is reverted.
579      * Requires the msg.sender to be the owner, approved, or operator
580      * @param from current owner of the token
581      * @param to address to receive the ownership of the given token ID
582      * @param tokenId uint256 ID of the token to be transferred
583      */
584     function safeTransferFrom(address from, address to, uint256 tokenId) public {
585         safeTransferFrom(from, to, tokenId, "");
586     }
587 
588     /**
589      * @dev Safely transfers the ownership of a given token ID to another address
590      * If the target address is a contract, it must implement `onERC721Received`,
591      * which is called upon a safe transfer, and return the magic value
592      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
593      * the transfer is reverted.
594      * Requires the msg.sender to be the owner, approved, or operator
595      * @param from current owner of the token
596      * @param to address to receive the ownership of the given token ID
597      * @param tokenId uint256 ID of the token to be transferred
598      * @param _data bytes data to send along with a safe transfer check
599      */
600     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
601         transferFrom(from, to, tokenId);
602         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
603     }
604 
605     /**
606      * @dev Returns whether the specified token exists.
607      * @param tokenId uint256 ID of the token to query the existence of
608      * @return bool whether the token exists
609      */
610     function _exists(uint256 tokenId) internal view returns (bool) {
611         address owner = _tokenOwner[tokenId];
612         return owner != address(0);
613     }
614 
615     /**
616      * @dev Returns whether the given spender can transfer a given token ID.
617      * @param spender address of the spender to query
618      * @param tokenId uint256 ID of the token to be transferred
619      * @return bool whether the msg.sender is approved for the given token ID,
620      * is an operator of the owner, or is the owner of the token
621      */
622     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
623         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
624         address owner = ownerOf(tokenId);
625         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
626     }
627 
628     /**
629      * @dev Internal function to mint a new token.
630      * Reverts if the given token ID already exists.
631      * @param to The address that will own the minted token
632      * @param tokenId uint256 ID of the token to be minted
633      */
634     function _mint(address to, uint256 tokenId) internal {
635         require(to != address(0), "ERC721: mint to the zero address");
636         require(!_exists(tokenId), "ERC721: token already minted");
637 
638         _tokenOwner[tokenId] = to;
639         _ownedTokensCount[to].increment();
640 
641         emit Transfer(address(0), to, tokenId);
642     }
643 
644     /**
645      * @dev Internal function to burn a specific token.
646      * Reverts if the token does not exist.
647      * Deprecated, use _burn(uint256) instead.
648      * @param owner owner of the token to burn
649      * @param tokenId uint256 ID of the token being burned
650      */
651     function _burn(address owner, uint256 tokenId) internal {
652         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
653 
654         _clearApproval(tokenId);
655 
656         _ownedTokensCount[owner].decrement();
657         _tokenOwner[tokenId] = address(0);
658 
659         emit Transfer(owner, address(0), tokenId);
660     }
661 
662     /**
663      * @dev Internal function to burn a specific token.
664      * Reverts if the token does not exist.
665      * @param tokenId uint256 ID of the token being burned
666      */
667     function _burn(uint256 tokenId) internal {
668         _burn(ownerOf(tokenId), tokenId);
669     }
670 
671     /**
672      * @dev Internal function to transfer ownership of a given token ID to another address.
673      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
674      * @param from current owner of the token
675      * @param to address to receive the ownership of the given token ID
676      * @param tokenId uint256 ID of the token to be transferred
677      */
678     function _transferFrom(address from, address to, uint256 tokenId) internal {
679         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
680         require(to != address(0), "ERC721: transfer to the zero address");
681 
682         _clearApproval(tokenId);
683 
684         _ownedTokensCount[from].decrement();
685         _ownedTokensCount[to].increment();
686 
687         _tokenOwner[tokenId] = to;
688 
689         emit Transfer(from, to, tokenId);
690     }
691 
692     /**
693      * @dev Internal function to invoke `onERC721Received` on a target address.
694      * The call is not executed if the target address is not a contract.
695      *
696      * This function is deprecated.
697      * @param from address representing the previous owner of the given token ID
698      * @param to target address that will receive the tokens
699      * @param tokenId uint256 ID of the token to be transferred
700      * @param _data bytes optional data to send along with the call
701      * @return bool whether the call correctly returned the expected magic value
702      */
703     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
704         internal returns (bool)
705     {
706         if (!to.isContract()) {
707             return true;
708         }
709 
710         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
711         return (retval == _ERC721_RECEIVED);
712     }
713 
714     /**
715      * @dev Private function to clear current approval of a given token ID.
716      * @param tokenId uint256 ID of the token to be transferred
717      */
718     function _clearApproval(uint256 tokenId) private {
719         if (_tokenApprovals[tokenId] != address(0)) {
720             _tokenApprovals[tokenId] = address(0);
721         }
722     }
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
726 
727 pragma solidity ^0.5.0;
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 contract IERC721Enumerable is IERC721 {
735     function totalSupply() public view returns (uint256);
736     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
737 
738     function tokenByIndex(uint256 index) public view returns (uint256);
739 }
740 
741 // File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol
742 
743 pragma solidity ^0.5.0;
744 
745 
746 
747 
748 /**
749  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
750  * @dev See https://eips.ethereum.org/EIPS/eip-721
751  */
752 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
753     // Mapping from owner to list of owned token IDs
754     mapping(address => uint256[]) private _ownedTokens;
755 
756     // Mapping from token ID to index of the owner tokens list
757     mapping(uint256 => uint256) private _ownedTokensIndex;
758 
759     // Array with all token ids, used for enumeration
760     uint256[] private _allTokens;
761 
762     // Mapping from token id to position in the allTokens array
763     mapping(uint256 => uint256) private _allTokensIndex;
764 
765     /*
766      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
767      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
768      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
769      *
770      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
771      */
772     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
773 
774     /**
775      * @dev Constructor function.
776      */
777     constructor () public {
778         // register the supported interface to conform to ERC721Enumerable via ERC165
779         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
780     }
781 
782     /**
783      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
784      * @param owner address owning the tokens list to be accessed
785      * @param index uint256 representing the index to be accessed of the requested tokens list
786      * @return uint256 token ID at the given index of the tokens list owned by the requested address
787      */
788     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
789         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
790         return _ownedTokens[owner][index];
791     }
792 
793     /**
794      * @dev Gets the total amount of tokens stored by the contract.
795      * @return uint256 representing the total amount of tokens
796      */
797     function totalSupply() public view returns (uint256) {
798         return _allTokens.length;
799     }
800 
801     /**
802      * @dev Gets the token ID at a given index of all the tokens in this contract
803      * Reverts if the index is greater or equal to the total number of tokens.
804      * @param index uint256 representing the index to be accessed of the tokens list
805      * @return uint256 token ID at the given index of the tokens list
806      */
807     function tokenByIndex(uint256 index) public view returns (uint256) {
808         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
809         return _allTokens[index];
810     }
811 
812     /**
813      * @dev Internal function to transfer ownership of a given token ID to another address.
814      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
815      * @param from current owner of the token
816      * @param to address to receive the ownership of the given token ID
817      * @param tokenId uint256 ID of the token to be transferred
818      */
819     function _transferFrom(address from, address to, uint256 tokenId) internal {
820         super._transferFrom(from, to, tokenId);
821 
822         _removeTokenFromOwnerEnumeration(from, tokenId);
823 
824         _addTokenToOwnerEnumeration(to, tokenId);
825     }
826 
827     /**
828      * @dev Internal function to mint a new token.
829      * Reverts if the given token ID already exists.
830      * @param to address the beneficiary that will own the minted token
831      * @param tokenId uint256 ID of the token to be minted
832      */
833     function _mint(address to, uint256 tokenId) internal {
834         super._mint(to, tokenId);
835 
836         _addTokenToOwnerEnumeration(to, tokenId);
837 
838         _addTokenToAllTokensEnumeration(tokenId);
839     }
840 
841     /**
842      * @dev Internal function to burn a specific token.
843      * Reverts if the token does not exist.
844      * Deprecated, use _burn(uint256) instead.
845      * @param owner owner of the token to burn
846      * @param tokenId uint256 ID of the token being burned
847      */
848     function _burn(address owner, uint256 tokenId) internal {
849         super._burn(owner, tokenId);
850 
851         _removeTokenFromOwnerEnumeration(owner, tokenId);
852         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
853         _ownedTokensIndex[tokenId] = 0;
854 
855         _removeTokenFromAllTokensEnumeration(tokenId);
856     }
857 
858     /**
859      * @dev Gets the list of token IDs of the requested owner.
860      * @param owner address owning the tokens
861      * @return uint256[] List of token IDs owned by the requested address
862      */
863     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
864         return _ownedTokens[owner];
865     }
866 
867     /**
868      * @dev Private function to add a token to this extension's ownership-tracking data structures.
869      * @param to address representing the new owner of the given token ID
870      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
871      */
872     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
873         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
874         _ownedTokens[to].push(tokenId);
875     }
876 
877     /**
878      * @dev Private function to add a token to this extension's token tracking data structures.
879      * @param tokenId uint256 ID of the token to be added to the tokens list
880      */
881     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
882         _allTokensIndex[tokenId] = _allTokens.length;
883         _allTokens.push(tokenId);
884     }
885 
886     /**
887      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
888      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
889      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
890      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
891      * @param from address representing the previous owner of the given token ID
892      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
893      */
894     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
895         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
896         // then delete the last slot (swap and pop).
897 
898         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
899         uint256 tokenIndex = _ownedTokensIndex[tokenId];
900 
901         // When the token to delete is the last token, the swap operation is unnecessary
902         if (tokenIndex != lastTokenIndex) {
903             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
904 
905             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
906             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
907         }
908 
909         // This also deletes the contents at the last position of the array
910         _ownedTokens[from].length--;
911 
912         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
913         // lastTokenId, or just over the end of the array if the token was the last one).
914     }
915 
916     /**
917      * @dev Private function to remove a token from this extension's token tracking data structures.
918      * This has O(1) time complexity, but alters the order of the _allTokens array.
919      * @param tokenId uint256 ID of the token to be removed from the tokens list
920      */
921     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
922         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
923         // then delete the last slot (swap and pop).
924 
925         uint256 lastTokenIndex = _allTokens.length.sub(1);
926         uint256 tokenIndex = _allTokensIndex[tokenId];
927 
928         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
929         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
930         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
931         uint256 lastTokenId = _allTokens[lastTokenIndex];
932 
933         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
934         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
935 
936         // This also deletes the contents at the last position of the array
937         _allTokens.length--;
938         _allTokensIndex[tokenId] = 0;
939     }
940 }
941 
942 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
943 
944 pragma solidity ^0.5.0;
945 
946 
947 /**
948  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
949  * @dev See https://eips.ethereum.org/EIPS/eip-721
950  */
951 contract IERC721Metadata is IERC721 {
952     function name() external view returns (string memory);
953     function symbol() external view returns (string memory);
954     function tokenURI(uint256 tokenId) external view returns (string memory);
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol
958 
959 pragma solidity ^0.5.0;
960 
961 
962 
963 
964 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
965     // Token name
966     string private _name;
967 
968     // Token symbol
969     string private _symbol;
970 
971     // Optional mapping for token URIs
972     mapping(uint256 => string) private _tokenURIs;
973 
974     /*
975      *     bytes4(keccak256('name()')) == 0x06fdde03
976      *     bytes4(keccak256('symbol()')) == 0x95d89b41
977      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
978      *
979      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
980      */
981     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
982 
983     /**
984      * @dev Constructor function
985      */
986     constructor (string memory name, string memory symbol) public {
987         _name = name;
988         _symbol = symbol;
989 
990         // register the supported interfaces to conform to ERC721 via ERC165
991         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
992     }
993 
994     /**
995      * @dev Gets the token name.
996      * @return string representing the token name
997      */
998     function name() external view returns (string memory) {
999         return _name;
1000     }
1001 
1002     /**
1003      * @dev Gets the token symbol.
1004      * @return string representing the token symbol
1005      */
1006     function symbol() external view returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev Returns an URI for a given token ID.
1012      * Throws if the token ID does not exist. May return an empty string.
1013      * @param tokenId uint256 ID of the token to query
1014      */
1015     function tokenURI(uint256 tokenId) external view returns (string memory) {
1016         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1017         return _tokenURIs[tokenId];
1018     }
1019 
1020     /**
1021      * @dev Internal function to set the token URI for a given token.
1022      * Reverts if the token ID does not exist.
1023      * @param tokenId uint256 ID of the token to set its URI
1024      * @param uri string URI to assign
1025      */
1026     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1027         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1028         _tokenURIs[tokenId] = uri;
1029     }
1030 
1031     /**
1032      * @dev Internal function to burn a specific token.
1033      * Reverts if the token does not exist.
1034      * Deprecated, use _burn(uint256) instead.
1035      * @param owner owner of the token to burn
1036      * @param tokenId uint256 ID of the token being burned by the msg.sender
1037      */
1038     function _burn(address owner, uint256 tokenId) internal {
1039         super._burn(owner, tokenId);
1040 
1041         // Clear metadata (if any)
1042         if (bytes(_tokenURIs[tokenId]).length != 0) {
1043             delete _tokenURIs[tokenId];
1044         }
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol
1049 
1050 pragma solidity ^0.5.0;
1051 
1052 
1053 
1054 
1055 /**
1056  * @title Full ERC721 Token
1057  * This implementation includes all the required and some optional functionality of the ERC721 standard
1058  * Moreover, it includes approve all functionality using operator terminology
1059  * @dev see https://eips.ethereum.org/EIPS/eip-721
1060  */
1061 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1062     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1063         // solhint-disable-previous-line no-empty-blocks
1064     }
1065 }
1066 
1067 // File: contracts/libs/String.sol
1068 
1069 pragma solidity ^0.5.11;
1070 
1071 library String {
1072 
1073     /**
1074      * @dev Convert bytes32 to string.
1075      * @param _x - to be converted to string.
1076      * @return string
1077      */
1078     function bytes32ToString(bytes32 _x) internal pure returns (string memory) {
1079         bytes memory bytesString = new bytes(32);
1080         uint charCount = 0;
1081         for (uint j = 0; j < 32; j++) {
1082             byte char = byte(bytes32(uint(_x) * 2 ** (8 * j)));
1083             if (char != 0) {
1084                 bytesString[charCount] = char;
1085                 charCount++;
1086             }
1087         }
1088         bytes memory bytesStringTrimmed = new bytes(charCount);
1089         for (uint j = 0; j < charCount; j++) {
1090             bytesStringTrimmed[j] = bytesString[j];
1091         }
1092         return string(bytesStringTrimmed);
1093     }
1094 
1095     /**
1096      * @dev Convert uint to string.
1097      * @param _i - uint256 to be converted to string.
1098      * @return uint in string
1099      */
1100     function uintToString(uint _i) internal pure returns (string memory _uintAsString) {
1101         uint i = _i;
1102 
1103         if (i == 0) {
1104             return "0";
1105         }
1106         uint j = i;
1107         uint len;
1108         while (j != 0) {
1109             len++;
1110             j /= 10;
1111         }
1112         bytes memory bstr = new bytes(len);
1113         uint k = len - 1;
1114         while (i != 0) {
1115             bstr[k--] = byte(uint8(48 + i % 10));
1116             i /= 10;
1117         }
1118         return string(bstr);
1119     }
1120 }
1121 
1122 // File: contracts/ERC721BaseCollection.sol
1123 
1124 pragma solidity ^0.5.11;
1125 
1126 
1127 
1128 
1129 contract ERC721BaseCollection is Ownable, ERC721Full {
1130     using String for bytes32;
1131     using String for uint256;
1132 
1133     mapping(bytes32 => uint256) public maxIssuance;
1134     mapping(bytes32 => uint) public issued;
1135     mapping(uint256 => string) internal _tokenPaths;
1136     mapping(address => bool) public allowed;
1137 
1138     string[] public wearables;
1139 
1140     string public baseURI;
1141     bool public isComplete;
1142 
1143     event BaseURI(string _oldBaseURI, string _newBaseURI);
1144     event Allowed(address indexed _operator, bool _allowed);
1145     event AddWearable(bytes32 indexed _wearableIdKey, string _wearableId, uint256 _maxIssuance);
1146     event Issue(address indexed _beneficiary, uint256 indexed _tokenId, bytes32 indexed _wearableIdKey, string _wearableId, uint256 _issuedId);
1147     event Complete();
1148 
1149 
1150     /**
1151      * @dev Create the contract.
1152      * @param _name - name of the contract
1153      * @param _symbol - symbol of the contract
1154      * @param _operator - Address allowed to mint tokens
1155      * @param _baseURI - base URI for token URIs
1156      */
1157     constructor(string memory _name, string memory _symbol, address _operator, string memory _baseURI) public ERC721Full(_name, _symbol) {
1158         setAllowed(_operator, true);
1159         setBaseURI(_baseURI);
1160     }
1161 
1162     modifier onlyAllowed() {
1163         require(allowed[msg.sender], "Only an `allowed` address can issue tokens");
1164         _;
1165     }
1166 
1167 
1168     /**
1169      * @dev Set Base URI.
1170      * @param _baseURI - base URI for token URIs
1171      */
1172     function setBaseURI(string memory _baseURI) public onlyOwner {
1173         emit BaseURI(baseURI, _baseURI);
1174         baseURI = _baseURI;
1175     }
1176 
1177     /**
1178      * @dev Set allowed account to issue tokens.
1179      * @param _operator - Address allowed to issue tokens
1180      * @param _allowed - Whether is allowed or not
1181      */
1182     function setAllowed(address _operator, bool _allowed) public onlyOwner {
1183         require(_operator != address(0), "Invalid address");
1184         require(allowed[_operator] != _allowed, "You should set a different value");
1185 
1186         allowed[_operator] = _allowed;
1187         emit Allowed(_operator, _allowed);
1188     }
1189 
1190 
1191     /**
1192      * @dev Returns an URI for a given token ID.
1193      * Throws if the token ID does not exist. May return an empty string.
1194      * @param _tokenId - uint256 ID of the token queried
1195      * @return token URI
1196      */
1197     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1198         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1199         return string(abi.encodePacked(baseURI, _tokenPaths[_tokenId]));
1200     }
1201 
1202 
1203     /**
1204      * @dev Transfers the ownership of given tokens ID to another address.
1205      * Usage of this method is discouraged, use {safeBatchTransferFrom} whenever possible.
1206      * Requires the msg.sender to be the owner, approved, or operator.
1207      * @param _from current owner of the token
1208      * @param _to address to receive the ownership of the given token ID
1209      * @param _tokenIds uint256 ID of the token to be transferred
1210      */
1211     function batchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds) external {
1212         for (uint256 i = 0; i < _tokenIds.length; i++) {
1213             transferFrom(_from, _to, _tokenIds[i]);
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns the wearables length.
1219      * @return wearable length
1220      */
1221     function wearablesCount() external view returns (uint256) {
1222         return wearables.length;
1223     }
1224 
1225     /**
1226      * @dev Complete the collection.
1227      * @notice that it will only prevent for adding more wearables.
1228      * The issuance is still allowed.
1229      */
1230     function completeCollection() external onlyOwner {
1231         require(!isComplete, "The collection is already completed");
1232         isComplete = true;
1233         emit Complete();
1234     }
1235 
1236      /**
1237      * @dev Add a new wearable to the collection.
1238      * @notice that this method should only allow wearableIds less than or equal to 32 bytes
1239      * @param _wearableIds - wearable ids
1240      * @param _maxIssuances - total supply for the wearables
1241      */
1242     function addWearables(bytes32[] calldata _wearableIds, uint256[] calldata _maxIssuances) external onlyOwner {
1243         require(_wearableIds.length == _maxIssuances.length, "Parameters should have the same length");
1244 
1245         for (uint256 i = 0; i < _wearableIds.length; i++) {
1246             addWearable(_wearableIds[i].bytes32ToString(), _maxIssuances[i]);
1247         }
1248     }
1249 
1250     /**
1251      * @dev Add a new wearable to the collection.
1252      * @notice that this method allows wearableIds of any size. It should be used
1253      * if a wearableId is greater than 32 bytes
1254      * @param _wearableId - wearable id
1255      * @param _maxIssuance - total supply for the wearable
1256      */
1257     function addWearable(string memory _wearableId, uint256 _maxIssuance) public onlyOwner {
1258         require(!isComplete, "The collection is complete");
1259         bytes32 key = getWearableKey(_wearableId);
1260 
1261         require(maxIssuance[key] == 0, "Can not modify an existing wearable");
1262         require(_maxIssuance > 0, "Max issuance should be greater than 0");
1263 
1264         maxIssuance[key] = _maxIssuance;
1265         wearables.push(_wearableId);
1266 
1267         emit AddWearable(key, _wearableId, _maxIssuance);
1268     }
1269 
1270     /**
1271      * @dev Safely transfers the ownership of given token IDs to another address
1272      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1273      * which is called upon a safe transfer, and return the magic value
1274      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1275      * the transfer is reverted.
1276      * Requires the msg.sender to be the owner, approved, or operator
1277      * @param _from - current owner of the token
1278      * @param _to - address to receive the ownership of the given token ID
1279      * @param _tokenIds - uint256 IDs of the tokens to be transferred
1280      */
1281     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
1282         safeBatchTransferFrom(_from, _to, _tokenIds, "");
1283     }
1284 
1285     /**
1286      * @dev Safely transfers the ownership of given token IDs to another address
1287      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1288      * which is called upon a safe transfer, and return the magic value
1289      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1290      * the transfer is reverted.
1291      * Requires the msg.sender to be the owner, approved, or operator
1292      * @param _from - current owner of the token
1293      * @param _to - address to receive the ownership of the given token ID
1294      * @param _tokenIds - uint256 ID of the tokens to be transferred
1295      * @param _data bytes data to send along with a safe transfer check
1296      */
1297     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory _data) public {
1298         for (uint256 i = 0; i < _tokenIds.length; i++) {
1299             safeTransferFrom(_from, _to, _tokenIds[i], _data);
1300         }
1301     }
1302 
1303     /**
1304      * @dev Get keccak256 of a wearableId.
1305      * @param _wearableId - token wearable
1306      * @return bytes32 keccak256 of the wearableId
1307      */
1308     function getWearableKey(string memory _wearableId) public pure returns (bytes32) {
1309         return keccak256(abi.encodePacked(_wearableId));
1310     }
1311 
1312     /**
1313      * @dev Mint a new NFT of the specified kind.
1314      * @notice that will throw if kind has reached its maximum or is invalid
1315      * @param _beneficiary - owner of the token
1316      * @param _tokenId - token
1317      * @param _wearableIdKey - wearable key
1318      * @param _wearableId - token wearable
1319      * @param _issuedId - issued id
1320      */
1321     function _mint(
1322         address _beneficiary,
1323         uint256 _tokenId,
1324         bytes32 _wearableIdKey,
1325         string memory _wearableId,
1326         uint256 _issuedId
1327     ) internal {
1328         // Check issuance
1329         require(
1330             _issuedId > 0 && _issuedId <= maxIssuance[_wearableIdKey],
1331             "Invalid issued id"
1332         );
1333         require(issued[_wearableIdKey] < maxIssuance[_wearableIdKey], "Option exhausted");
1334 
1335         // Mint erc721 token
1336         super._mint(_beneficiary, _tokenId);
1337 
1338         // Increase issuance
1339         issued[_wearableIdKey] = issued[_wearableIdKey] + 1;
1340 
1341         // Log
1342         emit Issue(_beneficiary, _tokenId, _wearableIdKey, _wearableId, _issuedId);
1343     }
1344 }
1345 
1346 // File: contracts/ERC721Collection.sol
1347 
1348 pragma solidity ^0.5.11;
1349 
1350 
1351 
1352 
1353 contract ERC721Collection is Ownable, ERC721Full, ERC721BaseCollection {
1354     /**
1355      * @dev Create the contract.
1356      * @param _name - name of the contract
1357      * @param _symbol - symbol of the contract
1358      * @param _operator - Address allowed to mint tokens
1359      * @param _baseURI - base URI for token URIs
1360      */
1361     constructor(
1362         string memory _name,
1363         string memory _symbol,
1364         address _operator,
1365         string memory _baseURI
1366     ) public ERC721BaseCollection(_name, _symbol, _operator, _baseURI) {}
1367 
1368     /**
1369      * @dev Issue a new NFT of the specified kind.
1370      * @notice that will throw if kind has reached its maximum or is invalid
1371      * @param _beneficiary - owner of the token
1372      * @param _wearableId - token wearable
1373      */
1374     function issueToken(address _beneficiary, string calldata _wearableId) external onlyAllowed {
1375         _issueToken(_beneficiary, _wearableId);
1376     }
1377 
1378     /**
1379      * @dev Issue NFTs.
1380      * @notice that will throw if kind has reached its maximum or is invalid
1381      * @param _beneficiaries - owner of the tokens
1382      * @param _wearableIds - token wearables
1383      */
1384     function issueTokens(address[] calldata _beneficiaries, bytes32[] calldata _wearableIds) external onlyAllowed {
1385         require(_beneficiaries.length == _wearableIds.length, "Parameters should have the same length");
1386 
1387         for(uint256 i = 0; i < _wearableIds.length; i++) {
1388             _issueToken(_beneficiaries[i], _wearableIds[i].bytes32ToString());
1389         }
1390     }
1391 
1392     /**
1393      * @dev Returns an URI for a given token ID.
1394      * Throws if the token ID does not exist. May return an empty string.
1395      * @param _tokenId - uint256 ID of the token queried
1396      * @return token URI
1397      */
1398     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1399         require(_exists(_tokenId), "ERC721Metadata: received a URI query for a nonexistent token");
1400         return string(abi.encodePacked(baseURI, _tokenPaths[_tokenId]));
1401     }
1402 
1403     /**
1404      * @dev Issue a new NFT of the specified kind.
1405      * @notice that will throw if kind has reached its maximum or is invalid
1406      * @param _beneficiary - owner of the token
1407      * @param _wearableId - token wearable
1408      */
1409     function _issueToken(address _beneficiary, string memory _wearableId) internal {
1410         bytes32 key = getWearableKey(_wearableId);
1411         uint256 issuedId = issued[key] + 1;
1412         uint256 tokenId = this.totalSupply();
1413 
1414         _mint(_beneficiary, tokenId, key, _wearableId, issuedId);
1415         _setTokenURI(
1416             tokenId,
1417             string(abi.encodePacked(_wearableId, "/", issuedId.uintToString()))
1418         );
1419     }
1420 
1421     /**
1422      * @dev Internal function to set the token URI for a given token.
1423      * Reverts if the token ID does not exist.
1424      * @param _tokenId - uint256 ID of the token to set as its URI
1425      * @param _uri - string URI to assign
1426      */
1427     function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
1428         _tokenPaths[_tokenId] = _uri;
1429     }
1430 }