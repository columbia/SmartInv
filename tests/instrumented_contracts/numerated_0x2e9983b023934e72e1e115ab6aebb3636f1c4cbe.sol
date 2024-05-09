1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-27
3 */
4 
5 pragma solidity ^0.5.0;
6 pragma experimental ABIEncoderV2;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor () internal { }
22     // solhint-disable-previous-line no-empty-blocks
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor () internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 /**
131  * @dev Required interface of an ERC721 compliant contract.
132  */
133 contract IERC721 is IERC165 {
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of NFTs in `owner`'s account.
140      */
141     function balanceOf(address owner) public view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the NFT specified by `tokenId`.
145      */
146     function ownerOf(uint256 tokenId) public view returns (address owner);
147 
148     /**
149      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
150      * another (`to`).
151      *
152      *
153      *
154      * Requirements:
155      * - `from`, `to` cannot be zero.
156      * - `tokenId` must be owned by `from`.
157      * - If the caller is not `from`, it must be have been allowed to move this
158      * NFT by either {approve} or {setApprovalForAll}.
159      */
160     function safeTransferFrom(address from, address to, uint256 tokenId) public;
161     /**
162      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
163      * another (`to`).
164      *
165      * Requirements:
166      * - If the caller is not `from`, it must be approved to move this NFT by
167      * either {approve} or {setApprovalForAll}.
168      */
169     function transferFrom(address from, address to, uint256 tokenId) public;
170     function approve(address to, uint256 tokenId) public;
171     function getApproved(uint256 tokenId) public view returns (address operator);
172 
173     function setApprovalForAll(address operator, bool _approved) public;
174     function isApprovedForAll(address owner, address operator) public view returns (bool);
175 
176 
177     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
178 }
179 
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
182  * @dev See https://eips.ethereum.org/EIPS/eip-721
183  */
184 contract IERC721Metadata is IERC721 {
185     function name() external view returns (string memory);
186     function symbol() external view returns (string memory);
187     function tokenURI(uint256 tokenId) external view returns (string memory);
188 }
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 contract IERC721Receiver {
196     /**
197      * @notice Handle the receipt of an NFT
198      * @dev The ERC721 smart contract calls this function on the recipient
199      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
200      * otherwise the caller will revert the transaction. The selector to be
201      * returned can be obtained as `this.onERC721Received.selector`. This
202      * function MAY throw to revert and reject the transfer.
203      * Note: the ERC721 contract address is always the message sender.
204      * @param operator The address which called `safeTransferFrom` function
205      * @param from The address which previously owned the token
206      * @param tokenId The NFT identifier which is being transferred
207      * @param data Additional data with no specified format
208      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
209      */
210     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
211     public returns (bytes4);
212 }
213 
214 /**
215  * @dev Wrappers over Solidity's arithmetic operations with added overflow
216  * checks.
217  *
218  * Arithmetic operations in Solidity wrap on overflow. This can easily result
219  * in bugs, because programmers usually assume that an overflow raises an
220  * error, which is the standard behavior in high level programming languages.
221  * `SafeMath` restores this intuition by reverting the transaction when an
222  * operation overflows.
223  *
224  * Using this library instead of the unchecked operations eliminates an entire
225  * class of bugs, so it's recommended to use it always.
226  */
227 library SafeMath {
228     /**
229      * @dev Returns the addition of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `+` operator.
233      *
234      * Requirements:
235      * - Addition cannot overflow.
236      */
237     function add(uint256 a, uint256 b) internal pure returns (uint256) {
238         uint256 c = a + b;
239         require(c >= a, "SafeMath: addition overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting on
246      * overflow (when the result is negative).
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254         return sub(a, b, "SafeMath: subtraction overflow");
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
259      * overflow (when the result is negative).
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      * - Subtraction cannot overflow.
265      *
266      * _Available since v2.4.0._
267      */
268     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         uint256 c = a - b;
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the multiplication of two unsigned integers, reverting on
277      * overflow.
278      *
279      * Counterpart to Solidity's `*` operator.
280      *
281      * Requirements:
282      * - Multiplication cannot overflow.
283      */
284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
285         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
286         // benefit is lost if 'b' is also tested.
287         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
288         if (a == 0) {
289             return 0;
290         }
291 
292         uint256 c = a * b;
293         require(c / a == b, "SafeMath: multiplication overflow");
294 
295         return c;
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      * - The divisor cannot be zero.
308      */
309     function div(uint256 a, uint256 b) internal pure returns (uint256) {
310         return div(a, b, "SafeMath: division by zero");
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      *
324      * _Available since v2.4.0._
325      */
326     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         // Solidity only automatically asserts when dividing by 0
328         require(b > 0, errorMessage);
329         uint256 c = a / b;
330         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      * - The divisor cannot be zero.
345      */
346     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
347         return mod(a, b, "SafeMath: modulo by zero");
348     }
349 
350     /**
351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
352      * Reverts with custom message when dividing by zero.
353      *
354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
355      * opcode (which leaves remaining gas untouched) while Solidity uses an
356      * invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      * - The divisor cannot be zero.
360      *
361      * _Available since v2.4.0._
362      */
363     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         require(b != 0, errorMessage);
365         return a % b;
366     }
367 }
368 
369 /**
370  * @dev Collection of functions related to the address type
371  */
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following 
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
392         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
393         // for accounts without code, i.e. `keccak256('')`
394         bytes32 codehash;
395         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
396         // solhint-disable-next-line no-inline-assembly
397         assembly { codehash := extcodehash(account) }
398         return (codehash != accountHash && codehash != 0x0);
399     }
400 
401     /**
402      * @dev Converts an `address` into `address payable`. Note that this is
403      * simply a type cast: the actual underlying value is not changed.
404      *
405      * _Available since v2.4.0._
406      */
407     function toPayable(address account) internal pure returns (address payable) {
408         return address(uint160(account));
409     }
410 
411     /**
412      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
413      * `recipient`, forwarding all available gas and reverting on errors.
414      *
415      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
416      * of certain opcodes, possibly making contracts go over the 2300 gas limit
417      * imposed by `transfer`, making them unable to receive funds via
418      * `transfer`. {sendValue} removes this limitation.
419      *
420      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
421      *
422      * IMPORTANT: because control is transferred to `recipient`, care must be
423      * taken to not create reentrancy vulnerabilities. Consider using
424      * {ReentrancyGuard} or the
425      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
426      *
427      * _Available since v2.4.0._
428      */
429     function sendValue(address payable recipient, uint256 amount) internal {
430         require(address(this).balance >= amount, "Address: insufficient balance");
431 
432         // solhint-disable-next-line avoid-call-value
433         (bool success, ) = recipient.call.value(amount)("");
434         require(success, "Address: unable to send value, recipient may have reverted");
435     }
436 }
437 
438 /**
439  * @title Counters
440  * @author Matt Condon (@shrugs)
441  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
442  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
443  *
444  * Include with `using Counters for Counters.Counter;`
445  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
446  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
447  * directly accessed.
448  */
449 library Counters {
450     using SafeMath for uint256;
451 
452     struct Counter {
453         // This variable should never be directly accessed by users of the library: interactions must be restricted to
454         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
455         // this feature: see https://github.com/ethereum/solidity/issues/4637
456         uint256 _value; // default: 0
457     }
458 
459     function current(Counter storage counter) internal view returns (uint256) {
460         return counter._value;
461     }
462 
463     function increment(Counter storage counter) internal {
464         // The {SafeMath} overflow check can be skipped here, see the comment at the top
465         counter._value += 1;
466     }
467 
468     function decrement(Counter storage counter) internal {
469         counter._value = counter._value.sub(1);
470     }
471 }
472 
473 /**
474  * @dev Implementation of the {IERC165} interface.
475  *
476  * Contracts may inherit from this and call {_registerInterface} to declare
477  * their support of an interface.
478  */
479 contract ERC165 is IERC165 {
480     /*
481      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
482      */
483     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
484 
485     /**
486      * @dev Mapping of interface ids to whether or not it's supported.
487      */
488     mapping(bytes4 => bool) private _supportedInterfaces;
489 
490     constructor () internal {
491         // Derived contracts need only register support for their own interfaces,
492         // we register support for ERC165 itself here
493         _registerInterface(_INTERFACE_ID_ERC165);
494     }
495 
496     /**
497      * @dev See {IERC165-supportsInterface}.
498      *
499      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
502         return _supportedInterfaces[interfaceId];
503     }
504 
505     /**
506      * @dev Registers the contract as an implementer of the interface defined by
507      * `interfaceId`. Support of the actual ERC165 interface is automatic and
508      * registering its interface id is not required.
509      *
510      * See {IERC165-supportsInterface}.
511      *
512      * Requirements:
513      *
514      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
515      */
516     function _registerInterface(bytes4 interfaceId) internal {
517         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
518         _supportedInterfaces[interfaceId] = true;
519     }
520 }
521 
522 /**
523  * @title ERC721 Non-Fungible Token Standard basic implementation
524  * @dev see https://eips.ethereum.org/EIPS/eip-721
525  */
526 contract ERC721 is Context, ERC165, IERC721 {
527     using SafeMath for uint256;
528     using Address for address;
529     using Counters for Counters.Counter;
530 
531     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
532     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
533     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
534 
535     // Mapping from token ID to owner
536     mapping (uint256 => address) private _tokenOwner;
537 
538     // Mapping from token ID to approved address
539     mapping (uint256 => address) private _tokenApprovals;
540 
541     // Mapping from owner to number of owned token
542     mapping (address => Counters.Counter) private _ownedTokensCount;
543 
544     // Mapping from owner to operator approvals
545     mapping (address => mapping (address => bool)) private _operatorApprovals;
546 
547     /*
548      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
549      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
550      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
551      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
552      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
553      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
554      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
555      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
556      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
557      *
558      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
559      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
560      */
561     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
562 
563     constructor () public {
564         // register the supported interfaces to conform to ERC721 via ERC165
565         _registerInterface(_INTERFACE_ID_ERC721);
566     }
567 
568     /**
569      * @dev Gets the balance of the specified address.
570      * @param owner address to query the balance of
571      * @return uint256 representing the amount owned by the passed address
572      */
573     function balanceOf(address owner) public view returns (uint256) {
574         require(owner != address(0), "ERC721: balance query for the zero address");
575 
576         return _ownedTokensCount[owner].current();
577     }
578 
579     /**
580      * @dev Gets the owner of the specified token ID.
581      * @param tokenId uint256 ID of the token to query the owner of
582      * @return address currently marked as the owner of the given token ID
583      */
584     function ownerOf(uint256 tokenId) public view returns (address) {
585         address owner = _tokenOwner[tokenId];
586         require(owner != address(0), "ERC721: owner query for nonexistent token");
587 
588         return owner;
589     }
590 
591     /**
592      * @dev Approves another address to transfer the given token ID
593      * The zero address indicates there is no approved address.
594      * There can only be one approved address per token at a given time.
595      * Can only be called by the token owner or an approved operator.
596      * @param to address to be approved for the given token ID
597      * @param tokenId uint256 ID of the token to be approved
598      */
599     function approve(address to, uint256 tokenId) public {
600         address owner = ownerOf(tokenId);
601         require(to != owner, "ERC721: approval to current owner");
602 
603         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
604             "ERC721: approve caller is not owner nor approved for all"
605         );
606 
607         _tokenApprovals[tokenId] = to;
608         emit Approval(owner, to, tokenId);
609     }
610 
611     /**
612      * @dev Gets the approved address for a token ID, or zero if no address set
613      * Reverts if the token ID does not exist.
614      * @param tokenId uint256 ID of the token to query the approval of
615      * @return address currently approved for the given token ID
616      */
617     function getApproved(uint256 tokenId) public view returns (address) {
618         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
619 
620         return _tokenApprovals[tokenId];
621     }
622 
623     /**
624      * @dev Sets or unsets the approval of a given operator
625      * An operator is allowed to transfer all tokens of the sender on their behalf.
626      * @param to operator address to set the approval
627      * @param approved representing the status of the approval to be set
628      */
629     function setApprovalForAll(address to, bool approved) public {
630         require(to != _msgSender(), "ERC721: approve to caller");
631 
632         _operatorApprovals[_msgSender()][to] = approved;
633         emit ApprovalForAll(_msgSender(), to, approved);
634     }
635 
636     /**
637      * @dev Tells whether an operator is approved by a given owner.
638      * @param owner owner address which you want to query the approval of
639      * @param operator operator address which you want to query the approval of
640      * @return bool whether the given operator is approved by the given owner
641      */
642     function isApprovedForAll(address owner, address operator) public view returns (bool) {
643         return _operatorApprovals[owner][operator];
644     }
645 
646     /**
647      * @dev Transfers the ownership of a given token ID to another address.
648      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
649      * Requires the msg.sender to be the owner, approved, or operator.
650      * @param from current owner of the token
651      * @param to address to receive the ownership of the given token ID
652      * @param tokenId uint256 ID of the token to be transferred
653      */
654     function transferFrom(address from, address to, uint256 tokenId) public {
655         //solhint-disable-next-line max-line-length
656         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
657 
658         _transferFrom(from, to, tokenId);
659     }
660 
661     /**
662      * @dev Safely transfers the ownership of a given token ID to another address
663      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
664      * which is called upon a safe transfer, and return the magic value
665      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
666      * the transfer is reverted.
667      * Requires the msg.sender to be the owner, approved, or operator
668      * @param from current owner of the token
669      * @param to address to receive the ownership of the given token ID
670      * @param tokenId uint256 ID of the token to be transferred
671      */
672     function safeTransferFrom(address from, address to, uint256 tokenId) public {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev Safely transfers the ownership of a given token ID to another address
678      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
679      * which is called upon a safe transfer, and return the magic value
680      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
681      * the transfer is reverted.
682      * Requires the _msgSender() to be the owner, approved, or operator
683      * @param from current owner of the token
684      * @param to address to receive the ownership of the given token ID
685      * @param tokenId uint256 ID of the token to be transferred
686      * @param _data bytes data to send along with a safe transfer check
687      */
688     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
689         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
690         _safeTransferFrom(from, to, tokenId, _data);
691     }
692 
693     /**
694      * @dev Safely transfers the ownership of a given token ID to another address
695      * If the target address is a contract, it must implement `onERC721Received`,
696      * which is called upon a safe transfer, and return the magic value
697      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
698      * the transfer is reverted.
699      * Requires the msg.sender to be the owner, approved, or operator
700      * @param from current owner of the token
701      * @param to address to receive the ownership of the given token ID
702      * @param tokenId uint256 ID of the token to be transferred
703      * @param _data bytes data to send along with a safe transfer check
704      */
705     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
706         _transferFrom(from, to, tokenId);
707         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
708     }
709 
710     /**
711      * @dev Returns whether the specified token exists.
712      * @param tokenId uint256 ID of the token to query the existence of
713      * @return bool whether the token exists
714      */
715     function _exists(uint256 tokenId) internal view returns (bool) {
716         address owner = _tokenOwner[tokenId];
717         return owner != address(0);
718     }
719 
720     /**
721      * @dev Returns whether the given spender can transfer a given token ID.
722      * @param spender address of the spender to query
723      * @param tokenId uint256 ID of the token to be transferred
724      * @return bool whether the msg.sender is approved for the given token ID,
725      * is an operator of the owner, or is the owner of the token
726      */
727     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
728         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
729         address owner = ownerOf(tokenId);
730         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
731     }
732 
733     /**
734      * @dev Internal function to safely mint a new token.
735      * Reverts if the given token ID already exists.
736      * If the target address is a contract, it must implement `onERC721Received`,
737      * which is called upon a safe transfer, and return the magic value
738      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
739      * the transfer is reverted.
740      * @param to The address that will own the minted token
741      * @param tokenId uint256 ID of the token to be minted
742      */
743     function _safeMint(address to, uint256 tokenId) internal {
744         _safeMint(to, tokenId, "");
745     }
746 
747     /**
748      * @dev Internal function to safely mint a new token.
749      * Reverts if the given token ID already exists.
750      * If the target address is a contract, it must implement `onERC721Received`,
751      * which is called upon a safe transfer, and return the magic value
752      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
753      * the transfer is reverted.
754      * @param to The address that will own the minted token
755      * @param tokenId uint256 ID of the token to be minted
756      * @param _data bytes data to send along with a safe transfer check
757      */
758     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
759         _mint(to, tokenId);
760         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
761     }
762 
763     /**
764      * @dev Internal function to mint a new token.
765      * Reverts if the given token ID already exists.
766      * @param to The address that will own the minted token
767      * @param tokenId uint256 ID of the token to be minted
768      */
769     function _mint(address to, uint256 tokenId) internal {
770         require(to != address(0), "ERC721: mint to the zero address");
771         require(!_exists(tokenId), "ERC721: token already minted");
772 
773         _tokenOwner[tokenId] = to;
774         _ownedTokensCount[to].increment();
775 
776         emit Transfer(address(0), to, tokenId);
777     }
778 
779     /**
780      * @dev Internal function to burn a specific token.
781      * Reverts if the token does not exist.
782      * Deprecated, use {_burn} instead.
783      * @param owner owner of the token to burn
784      * @param tokenId uint256 ID of the token being burned
785      */
786     function _burn(address owner, uint256 tokenId) internal {
787         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
788 
789         _clearApproval(tokenId);
790 
791         _ownedTokensCount[owner].decrement();
792         _tokenOwner[tokenId] = address(0);
793 
794         emit Transfer(owner, address(0), tokenId);
795     }
796 
797     /**
798      * @dev Internal function to burn a specific token.
799      * Reverts if the token does not exist.
800      * @param tokenId uint256 ID of the token being burned
801      */
802     function _burn(uint256 tokenId) internal {
803         _burn(ownerOf(tokenId), tokenId);
804     }
805 
806     /**
807      * @dev Internal function to transfer ownership of a given token ID to another address.
808      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
809      * @param from current owner of the token
810      * @param to address to receive the ownership of the given token ID
811      * @param tokenId uint256 ID of the token to be transferred
812      */
813     function _transferFrom(address from, address to, uint256 tokenId) internal {
814         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
815         require(to != address(0), "ERC721: transfer to the zero address");
816 
817         _clearApproval(tokenId);
818 
819         _ownedTokensCount[from].decrement();
820         _ownedTokensCount[to].increment();
821 
822         _tokenOwner[tokenId] = to;
823 
824         emit Transfer(from, to, tokenId);
825     }
826 
827     /**
828      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
829      * The call is not executed if the target address is not a contract.
830      *
831      * This is an internal detail of the `ERC721` contract and its use is deprecated.
832      * @param from address representing the previous owner of the given token ID
833      * @param to target address that will receive the tokens
834      * @param tokenId uint256 ID of the token to be transferred
835      * @param _data bytes optional data to send along with the call
836      * @return bool whether the call correctly returned the expected magic value
837      */
838     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
839         internal returns (bool)
840     {
841         if (!to.isContract()) {
842             return true;
843         }
844         // solhint-disable-next-line avoid-low-level-calls
845         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
846             IERC721Receiver(to).onERC721Received.selector,
847             _msgSender(),
848             from,
849             tokenId,
850             _data
851         ));
852         if (!success) {
853             if (returndata.length > 0) {
854                 // solhint-disable-next-line no-inline-assembly
855                 assembly {
856                     let returndata_size := mload(returndata)
857                     revert(add(32, returndata), returndata_size)
858                 }
859             } else {
860                 revert("ERC721: transfer to non ERC721Receiver implementer");
861             }
862         } else {
863             bytes4 retval = abi.decode(returndata, (bytes4));
864             return (retval == _ERC721_RECEIVED);
865         }
866     }
867 
868     /**
869      * @dev Private function to clear current approval of a given token ID.
870      * @param tokenId uint256 ID of the token to be transferred
871      */
872     function _clearApproval(uint256 tokenId) private {
873         if (_tokenApprovals[tokenId] != address(0)) {
874             _tokenApprovals[tokenId] = address(0);
875         }
876     }
877 }
878 
879 /**
880  * @title ERC721 Burnable Token
881  * @dev ERC721 Token that can be irreversibly burned (destroyed).
882  */
883 contract ERC721Burnable is Context, ERC721 {
884     /**
885      * @dev Burns a specific ERC721 token.
886      * @param tokenId uint256 id of the ERC721 token to be burned.
887      */
888     function burn(uint256 tokenId) public {
889         //solhint-disable-next-line max-line-length
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
891         _burn(tokenId);
892     }
893 }
894 
895 /**
896  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
897  * @dev See https://eips.ethereum.org/EIPS/eip-721
898  */
899 contract IERC721Enumerable is IERC721 {
900     function totalSupply() public view returns (uint256);
901     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
902 
903     function tokenByIndex(uint256 index) public view returns (uint256);
904 }
905 
906 /**
907  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
908  * @dev See https://eips.ethereum.org/EIPS/eip-721
909  */
910 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
911     // Mapping from owner to list of owned token IDs
912     mapping(address => uint256[]) private _ownedTokens;
913 
914     // Mapping from token ID to index of the owner tokens list
915     mapping(uint256 => uint256) private _ownedTokensIndex;
916 
917     // Array with all token ids, used for enumeration
918     uint256[] private _allTokens;
919 
920     // Mapping from token id to position in the allTokens array
921     mapping(uint256 => uint256) private _allTokensIndex;
922 
923     /*
924      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
925      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
926      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
927      *
928      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
929      */
930     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
931 
932     /**
933      * @dev Constructor function.
934      */
935     constructor () public {
936         // register the supported interface to conform to ERC721Enumerable via ERC165
937         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
938     }
939 
940     /**
941      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
942      * @param owner address owning the tokens list to be accessed
943      * @param index uint256 representing the index to be accessed of the requested tokens list
944      * @return uint256 token ID at the given index of the tokens list owned by the requested address
945      */
946     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
947         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
948         return _ownedTokens[owner][index];
949     }
950 
951     /**
952      * @dev Gets the total amount of tokens stored by the contract.
953      * @return uint256 representing the total amount of tokens
954      */
955     function totalSupply() public view returns (uint256) {
956         return _allTokens.length;
957     }
958 
959     /**
960      * @dev Gets the token ID at a given index of all the tokens in this contract
961      * Reverts if the index is greater or equal to the total number of tokens.
962      * @param index uint256 representing the index to be accessed of the tokens list
963      * @return uint256 token ID at the given index of the tokens list
964      */
965     function tokenByIndex(uint256 index) public view returns (uint256) {
966         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
967         return _allTokens[index];
968     }
969 
970     /**
971      * @dev Internal function to transfer ownership of a given token ID to another address.
972      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
973      * @param from current owner of the token
974      * @param to address to receive the ownership of the given token ID
975      * @param tokenId uint256 ID of the token to be transferred
976      */
977     function _transferFrom(address from, address to, uint256 tokenId) internal {
978         super._transferFrom(from, to, tokenId);
979 
980         _removeTokenFromOwnerEnumeration(from, tokenId);
981 
982         _addTokenToOwnerEnumeration(to, tokenId);
983     }
984 
985     /**
986      * @dev Internal function to mint a new token.
987      * Reverts if the given token ID already exists.
988      * @param to address the beneficiary that will own the minted token
989      * @param tokenId uint256 ID of the token to be minted
990      */
991     function _mint(address to, uint256 tokenId) internal {
992         super._mint(to, tokenId);
993 
994         _addTokenToOwnerEnumeration(to, tokenId);
995 
996         _addTokenToAllTokensEnumeration(tokenId);
997     }
998 
999     /**
1000      * @dev Internal function to burn a specific token.
1001      * Reverts if the token does not exist.
1002      * Deprecated, use {ERC721-_burn} instead.
1003      * @param owner owner of the token to burn
1004      * @param tokenId uint256 ID of the token being burned
1005      */
1006     function _burn(address owner, uint256 tokenId) internal {
1007         super._burn(owner, tokenId);
1008 
1009         _removeTokenFromOwnerEnumeration(owner, tokenId);
1010         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1011         _ownedTokensIndex[tokenId] = 0;
1012 
1013         _removeTokenFromAllTokensEnumeration(tokenId);
1014     }
1015 
1016     /**
1017      * @dev Gets the list of token IDs of the requested owner.
1018      * @param owner address owning the tokens
1019      * @return uint256[] List of token IDs owned by the requested address
1020      */
1021     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1022         return _ownedTokens[owner];
1023     }
1024 
1025     /**
1026      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1027      * @param to address representing the new owner of the given token ID
1028      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1029      */
1030     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1031         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1032         _ownedTokens[to].push(tokenId);
1033     }
1034 
1035     /**
1036      * @dev Private function to add a token to this extension's token tracking data structures.
1037      * @param tokenId uint256 ID of the token to be added to the tokens list
1038      */
1039     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1040         _allTokensIndex[tokenId] = _allTokens.length;
1041         _allTokens.push(tokenId);
1042     }
1043 
1044     /**
1045      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1046      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1047      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1048      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1049      * @param from address representing the previous owner of the given token ID
1050      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1051      */
1052     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1053         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1054         // then delete the last slot (swap and pop).
1055 
1056         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1057         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1058 
1059         // When the token to delete is the last token, the swap operation is unnecessary
1060         if (tokenIndex != lastTokenIndex) {
1061             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1062 
1063             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1064             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1065         }
1066 
1067         // This also deletes the contents at the last position of the array
1068         _ownedTokens[from].length--;
1069 
1070         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1071         // lastTokenId, or just over the end of the array if the token was the last one).
1072     }
1073 
1074     /**
1075      * @dev Private function to remove a token from this extension's token tracking data structures.
1076      * This has O(1) time complexity, but alters the order of the _allTokens array.
1077      * @param tokenId uint256 ID of the token to be removed from the tokens list
1078      */
1079     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1080         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1081         // then delete the last slot (swap and pop).
1082 
1083         uint256 lastTokenIndex = _allTokens.length.sub(1);
1084         uint256 tokenIndex = _allTokensIndex[tokenId];
1085 
1086         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1087         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1088         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1089         uint256 lastTokenId = _allTokens[lastTokenIndex];
1090 
1091         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1092         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1093 
1094         // This also deletes the contents at the last position of the array
1095         _allTokens.length--;
1096         _allTokensIndex[tokenId] = 0;
1097     }
1098 }
1099 
1100 library UintLibrary {
1101     function toString(uint256 _i) internal pure returns (string memory) {
1102         if (_i == 0) {
1103             return "0";
1104         }
1105         uint j = _i;
1106         uint len;
1107         while (j != 0) {
1108             len++;
1109             j /= 10;
1110         }
1111         bytes memory bstr = new bytes(len);
1112         uint k = len - 1;
1113         while (_i != 0) {
1114             bstr[k--] = byte(uint8(48 + _i % 10));
1115             _i /= 10;
1116         }
1117         return string(bstr);
1118     }
1119 }
1120 
1121 library StringLibrary {
1122     using UintLibrary for uint256;
1123 
1124     function append(string memory _a, string memory _b) internal pure returns (string memory) {
1125         bytes memory _ba = bytes(_a);
1126         bytes memory _bb = bytes(_b);
1127         bytes memory bab = new bytes(_ba.length + _bb.length);
1128         uint k = 0;
1129         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1130         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1131         return string(bab);
1132     }
1133 
1134     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1135         bytes memory _ba = bytes(_a);
1136         bytes memory _bb = bytes(_b);
1137         bytes memory _bc = bytes(_c);
1138         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
1139         uint k = 0;
1140         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
1141         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
1142         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
1143         return string(bbb);
1144     }
1145 
1146     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1147         bytes memory msgBytes = bytes(message);
1148         bytes memory fullMessage = concat(
1149             bytes("\x19Ethereum Signed Message:\n"),
1150             bytes(msgBytes.length.toString()),
1151             msgBytes,
1152             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1153         );
1154         return ecrecover(keccak256(fullMessage), v, r, s);
1155     }
1156 
1157     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1158         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1159         uint k = 0;
1160         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1161         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1162         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1163         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1164         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1165         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1166         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1167         return resultBytes;
1168     }
1169 }
1170 
1171 
1172 contract HasTokenURI {
1173     using StringLibrary for string;
1174 
1175     //Token URI prefix
1176     string public tokenURIPrefix;
1177 
1178     // Optional mapping for token URIs
1179     mapping(uint256 => string) private _tokenURIs;
1180 
1181     constructor(string memory _tokenURIPrefix) public {
1182         tokenURIPrefix = _tokenURIPrefix;
1183     }
1184 
1185     /**
1186      * @dev Returns an URI for a given token ID.
1187      * Throws if the token ID does not exist. May return an empty string.
1188      * @param tokenId uint256 ID of the token to query
1189      */
1190     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1191         return tokenURIPrefix.append(_tokenURIs[tokenId]);
1192     }
1193 
1194     /**
1195      * @dev Internal function to set the token URI for a given token.
1196      * Reverts if the token ID does not exist.
1197      * @param tokenId uint256 ID of the token to set its URI
1198      * @param uri string URI to assign
1199      */
1200     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1201         _tokenURIs[tokenId] = uri;
1202     }
1203 
1204     /**
1205      * @dev Internal function to set the token URI prefix.
1206      * @param _tokenURIPrefix string URI prefix to assign
1207      */
1208     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
1209         tokenURIPrefix = _tokenURIPrefix;
1210     }
1211 
1212     function _clearTokenURI(uint256 tokenId) internal {
1213         if (bytes(_tokenURIs[tokenId]).length != 0) {
1214             delete _tokenURIs[tokenId];
1215         }
1216     }
1217 }
1218 
1219 contract HasSecondarySaleFees is ERC165 {
1220 
1221     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
1222 
1223     /*
1224      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1225      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1226      *
1227      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1228      */
1229     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1230 
1231     constructor() public {
1232         _registerInterface(_INTERFACE_ID_FEES);
1233     }
1234 
1235     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
1236     function getFeeBps(uint256 id) public view returns (uint[] memory);
1237 }
1238 
1239 /**
1240  * @title Full ERC721 Token with support for tokenURIPrefix
1241  * This implementation includes all the required and some optional functionality of the ERC721 standard
1242  * Moreover, it includes approve all functionality using operator terminology
1243  * @dev see https://eips.ethereum.org/EIPS/eip-721
1244  */
1245 contract ERC721Base is HasSecondarySaleFees, ERC721, HasTokenURI, ERC721Enumerable {
1246     // Token name
1247     string public name;
1248 
1249     // Token symbol
1250     string public symbol;
1251 
1252     struct Fee {
1253         address payable recipient;
1254         uint256 value;
1255     }
1256 
1257     // id => fees
1258     mapping (uint256 => Fee[]) public fees;
1259 
1260     /*
1261      *     bytes4(keccak256('name()')) == 0x06fdde03
1262      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1263      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1264      *
1265      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1266      */
1267     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1268 
1269     /**
1270      * @dev Constructor function
1271      */
1272     constructor (string memory _name, string memory _symbol, string memory _tokenURIPrefix)  HasTokenURI(_tokenURIPrefix) public {
1273         name = _name;
1274         symbol = _symbol;
1275 
1276         // register the supported interfaces to conform to ERC721 via ERC165
1277         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1278     }
1279 
1280     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
1281         Fee[] memory _fees = fees[id];
1282         address payable[] memory result = new address payable[](_fees.length);
1283         for (uint i = 0; i < _fees.length; i++) {
1284             result[i] = _fees[i].recipient;
1285         }
1286         return result;
1287     }
1288 
1289     function getFeeBps(uint256 id) public view returns (uint[] memory) {
1290         Fee[] memory _fees = fees[id];
1291         uint[] memory result = new uint[](_fees.length);
1292         for (uint i = 0; i < _fees.length; i++) {
1293             result[i] = _fees[i].value;
1294         }
1295         return result;
1296     }
1297 
1298     function _mint(address to, uint256 tokenId, address payable recpt) internal {
1299         _mint(to, tokenId);
1300         
1301         fees[tokenId].push(Fee(recpt, 1000));
1302         
1303         // emit SecondarySaleFees(tokenId, to, 1000);
1304     }
1305 
1306     /**
1307      * @dev Returns an URI for a given token ID.
1308      * Throws if the token ID does not exist. May return an empty string.
1309      * @param tokenId uint256 ID of the token to query
1310      */
1311     function tokenURI(uint256 tokenId) external view returns (string memory) {
1312         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1313         return super._tokenURI(tokenId);
1314     }
1315 
1316     /**
1317      * @dev Internal function to set the token URI for a given token.
1318      * Reverts if the token ID does not exist.
1319      * @param tokenId uint256 ID of the token to set its URI
1320      * @param uri string URI to assign
1321      */
1322     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1323         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1324         super._setTokenURI(tokenId, uri);
1325     }
1326 
1327     /**
1328      * @dev Internal function to burn a specific token.
1329      * Reverts if the token does not exist.
1330      * Deprecated, use _burn(uint256) instead.
1331      * @param owner owner of the token to burn
1332      * @param tokenId uint256 ID of the token being burned by the msg.sender
1333      */
1334     function _burn(address owner, uint256 tokenId) internal {
1335         super._burn(owner, tokenId);
1336         _clearTokenURI(tokenId);
1337     }
1338 }
1339 
1340 
1341 
1342 
1343 
1344 
1345 
1346 /**
1347  * @title JorrToken
1348  * @dev only owner can mint token.
1349  */
1350 contract JorrToken is Ownable, IERC721, IERC721Metadata, ERC721Burnable, ERC721Base {
1351     
1352     address payable public     royaltyAddress;
1353     uint256 public             royaltyBps;
1354     uint256 public tid;
1355 
1356     constructor (string memory name, string memory symbol, address newOwner, string memory tokenURIPrefix) public ERC721Base(name, symbol, tokenURIPrefix) {
1357         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1358         transferOwnership(newOwner);
1359         address payable addr1 = msg.sender;
1360         royaltyAddress = addr1;
1361         royaltyBps = 1000;
1362     }
1363 
1364     function mint(address user, uint256 tokenId, string memory tokenURI) public onlyOwner returns(uint256) {
1365         _mint(user, tokenId, royaltyAddress);
1366         _setTokenURI(tokenId, tokenURI);
1367         tid = tokenId;
1368         return tokenId;
1369     }
1370     
1371     function multiMint(uint256 tokenId, uint256 count, string memory tokenURI) public onlyOwner returns(uint256, uint256) {
1372         
1373         for(uint256 i = 1; i <= count; i++){
1374             _mint(msg.sender, tid + i, royaltyAddress);
1375             _setTokenURI(tid + i, tokenURI);
1376         }
1377         tid += count;
1378         return (tid - count, tid);
1379     }
1380 
1381     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1382         _setTokenURIPrefix(tokenURIPrefix);
1383     }
1384 
1385 
1386 }