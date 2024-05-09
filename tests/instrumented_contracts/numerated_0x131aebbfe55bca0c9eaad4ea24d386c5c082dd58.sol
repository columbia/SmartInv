1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 contract IERC721 is IERC165 {
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     /**
34      * @dev Returns the number of NFTs in `owner`'s account.
35      */
36     function balanceOf(address owner) public view returns (uint256 balance);
37 
38     /**
39      * @dev Returns the owner of the NFT specified by `tokenId`.
40      */
41     function ownerOf(uint256 tokenId) public view returns (address owner);
42 
43     /**
44      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
45      * another (`to`).
46      *
47      *
48      *
49      * Requirements:
50      * - `from`, `to` cannot be zero.
51      * - `tokenId` must be owned by `from`.
52      * - If the caller is not `from`, it must be have been allowed to move this
53      * NFT by either {approve} or {setApprovalForAll}.
54      */
55     function safeTransferFrom(address from, address to, uint256 tokenId) public;
56     /**
57      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
58      * another (`to`).
59      *
60      * Requirements:
61      * - If the caller is not `from`, it must be approved to move this NFT by
62      * either {approve} or {setApprovalForAll}.
63      */
64     function transferFrom(address from, address to, uint256 tokenId) public;
65     function approve(address to, uint256 tokenId) public;
66     function getApproved(uint256 tokenId) public view returns (address operator);
67 
68     function setApprovalForAll(address operator, bool _approved) public;
69     function isApprovedForAll(address owner, address operator) public view returns (bool);
70 
71 
72     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
73 }
74 
75 /**
76  * @title ERC721 token receiver interface
77  * @dev Interface for any contract that wants to support safeTransfers
78  * from ERC721 asset contracts.
79  */
80 contract IERC721Receiver {
81     /**
82      * @notice Handle the receipt of an NFT
83      * @dev The ERC721 smart contract calls this function on the recipient
84      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
85      * otherwise the caller will revert the transaction. The selector to be
86      * returned can be obtained as `this.onERC721Received.selector`. This
87      * function MAY throw to revert and reject the transfer.
88      * Note: the ERC721 contract address is always the message sender.
89      * @param operator The address which called `safeTransferFrom` function
90      * @param from The address which previously owned the token
91      * @param tokenId The NFT identifier which is being transferred
92      * @param data Additional data with no specified format
93      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
94      */
95     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
96     public returns (bytes4);
97 }
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with GSN meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 contract Context {
110     // Empty internal constructor, to prevent people from mistakenly deploying
111     // an instance of this contract, which should be used via inheritance.
112     constructor () internal { }
113     // solhint-disable-previous-line no-empty-blocks
114 
115     function _msgSender() internal view returns (address payable) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view returns (bytes memory) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor () internal {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         emit OwnershipTransferred(address(0), msgSender);
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(isOwner(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Returns true if the caller is the current owner.
165      */
166     function isOwner() public view returns (bool) {
167         return _msgSender() == _owner;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * NOTE: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public onlyOwner {
178         emit OwnershipTransferred(_owner, address(0));
179         _owner = address(0);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public onlyOwner {
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      */
193     function _transferOwnership(address newOwner) internal {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 contract IERC721Metadata is IERC721 {
205     function name() external view returns (string memory);
206     function symbol() external view returns (string memory);
207     function tokenURI(uint256 tokenId) external view returns (string memory);
208 }
209 
210 /**
211  * @dev Wrappers over Solidity's arithmetic operations with added overflow
212  * checks.
213  *
214  * Arithmetic operations in Solidity wrap on overflow. This can easily result
215  * in bugs, because programmers usually assume that an overflow raises an
216  * error, which is the standard behavior in high level programming languages.
217  * `SafeMath` restores this intuition by reverting the transaction when an
218  * operation overflows.
219  *
220  * Using this library instead of the unchecked operations eliminates an entire
221  * class of bugs, so it's recommended to use it always.
222  */
223 library SafeMath {
224     /**
225      * @dev Returns the addition of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `+` operator.
229      *
230      * Requirements:
231      * - Addition cannot overflow.
232      */
233     function add(uint256 a, uint256 b) internal pure returns (uint256) {
234         uint256 c = a + b;
235         require(c >= a, "SafeMath: addition overflow");
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting on
242      * overflow (when the result is negative).
243      *
244      * Counterpart to Solidity's `-` operator.
245      *
246      * Requirements:
247      * - Subtraction cannot overflow.
248      */
249     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250         return sub(a, b, "SafeMath: subtraction overflow");
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
255      * overflow (when the result is negative).
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      * - Subtraction cannot overflow.
261      *
262      * _Available since v2.4.0._
263      */
264     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b <= a, errorMessage);
266         uint256 c = a - b;
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the multiplication of two unsigned integers, reverting on
273      * overflow.
274      *
275      * Counterpart to Solidity's `*` operator.
276      *
277      * Requirements:
278      * - Multiplication cannot overflow.
279      */
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
282         // benefit is lost if 'b' is also tested.
283         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
284         if (a == 0) {
285             return 0;
286         }
287 
288         uint256 c = a * b;
289         require(c / a == b, "SafeMath: multiplication overflow");
290 
291         return c;
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers. Reverts on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      * - The divisor cannot be zero.
304      */
305     function div(uint256 a, uint256 b) internal pure returns (uint256) {
306         return div(a, b, "SafeMath: division by zero");
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      * - The divisor cannot be zero.
319      *
320      * _Available since v2.4.0._
321      */
322     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         // Solidity only automatically asserts when dividing by 0
324         require(b > 0, errorMessage);
325         uint256 c = a / b;
326         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         return mod(a, b, "SafeMath: modulo by zero");
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * Reverts with custom message when dividing by zero.
349      *
350      * Counterpart to Solidity's `%` operator. This function uses a `revert`
351      * opcode (which leaves remaining gas untouched) while Solidity uses an
352      * invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      * - The divisor cannot be zero.
356      *
357      * _Available since v2.4.0._
358      */
359     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
360         require(b != 0, errorMessage);
361         return a % b;
362     }
363 }
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following 
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
388         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
389         // for accounts without code, i.e. `keccak256('')`
390         bytes32 codehash;
391         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
392         // solhint-disable-next-line no-inline-assembly
393         assembly { codehash := extcodehash(account) }
394         return (codehash != accountHash && codehash != 0x0);
395     }
396 
397     /**
398      * @dev Converts an `address` into `address payable`. Note that this is
399      * simply a type cast: the actual underlying value is not changed.
400      *
401      * _Available since v2.4.0._
402      */
403     function toPayable(address account) internal pure returns (address payable) {
404         return address(uint160(account));
405     }
406 
407     /**
408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
409      * `recipient`, forwarding all available gas and reverting on errors.
410      *
411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
413      * imposed by `transfer`, making them unable to receive funds via
414      * `transfer`. {sendValue} removes this limitation.
415      *
416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
417      *
418      * IMPORTANT: because control is transferred to `recipient`, care must be
419      * taken to not create reentrancy vulnerabilities. Consider using
420      * {ReentrancyGuard} or the
421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
422      *
423      * _Available since v2.4.0._
424      */
425     function sendValue(address payable recipient, uint256 amount) internal {
426         require(address(this).balance >= amount, "Address: insufficient balance");
427 
428         // solhint-disable-next-line avoid-call-value
429         (bool success, ) = recipient.call.value(amount)("");
430         require(success, "Address: unable to send value, recipient may have reverted");
431     }
432 }
433 
434 /**
435  * @title Counters
436  * @author Matt Condon (@shrugs)
437  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
438  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
439  *
440  * Include with `using Counters for Counters.Counter;`
441  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
442  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
443  * directly accessed.
444  */
445 library Counters {
446     using SafeMath for uint256;
447 
448     struct Counter {
449         // This variable should never be directly accessed by users of the library: interactions must be restricted to
450         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
451         // this feature: see https://github.com/ethereum/solidity/issues/4637
452         uint256 _value; // default: 0
453     }
454 
455     function current(Counter storage counter) internal view returns (uint256) {
456         return counter._value;
457     }
458 
459     function increment(Counter storage counter) internal {
460         // The {SafeMath} overflow check can be skipped here, see the comment at the top
461         counter._value += 1;
462     }
463 
464     function decrement(Counter storage counter) internal {
465         counter._value = counter._value.sub(1);
466     }
467 }
468 
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts may inherit from this and call {_registerInterface} to declare
473  * their support of an interface.
474  */
475 contract ERC165 is IERC165 {
476     /*
477      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
478      */
479     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
480 
481     /**
482      * @dev Mapping of interface ids to whether or not it's supported.
483      */
484     mapping(bytes4 => bool) private _supportedInterfaces;
485 
486     constructor () internal {
487         // Derived contracts need only register support for their own interfaces,
488         // we register support for ERC165 itself here
489         _registerInterface(_INTERFACE_ID_ERC165);
490     }
491 
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      *
495      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
498         return _supportedInterfaces[interfaceId];
499     }
500 
501     /**
502      * @dev Registers the contract as an implementer of the interface defined by
503      * `interfaceId`. Support of the actual ERC165 interface is automatic and
504      * registering its interface id is not required.
505      *
506      * See {IERC165-supportsInterface}.
507      *
508      * Requirements:
509      *
510      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
511      */
512     function _registerInterface(bytes4 interfaceId) internal {
513         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
514         _supportedInterfaces[interfaceId] = true;
515     }
516 }
517 
518 /**
519  * @title ERC721 Non-Fungible Token Standard basic implementation
520  * @dev see https://eips.ethereum.org/EIPS/eip-721
521  */
522 contract ERC721 is Context, ERC165, IERC721 {
523     using SafeMath for uint256;
524     using Address for address;
525     using Counters for Counters.Counter;
526 
527     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
528     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
529     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
530 
531     // Mapping from token ID to owner
532     mapping (uint256 => address) private _tokenOwner;
533 
534     // Mapping from token ID to approved address
535     mapping (uint256 => address) private _tokenApprovals;
536 
537     // Mapping from owner to number of owned token
538     mapping (address => Counters.Counter) private _ownedTokensCount;
539 
540     // Mapping from owner to operator approvals
541     mapping (address => mapping (address => bool)) private _operatorApprovals;
542 
543     /*
544      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
545      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
546      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
547      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
548      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
549      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
550      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
551      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
552      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
553      *
554      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
555      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
556      */
557     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
558 
559     constructor () public {
560         // register the supported interfaces to conform to ERC721 via ERC165
561         _registerInterface(_INTERFACE_ID_ERC721);
562     }
563 
564     /**
565      * @dev Gets the balance of the specified address.
566      * @param owner address to query the balance of
567      * @return uint256 representing the amount owned by the passed address
568      */
569     function balanceOf(address owner) public view returns (uint256) {
570         require(owner != address(0), "ERC721: balance query for the zero address");
571 
572         return _ownedTokensCount[owner].current();
573     }
574 
575     /**
576      * @dev Gets the owner of the specified token ID.
577      * @param tokenId uint256 ID of the token to query the owner of
578      * @return address currently marked as the owner of the given token ID
579      */
580     function ownerOf(uint256 tokenId) public view returns (address) {
581         address owner = _tokenOwner[tokenId];
582         require(owner != address(0), "ERC721: owner query for nonexistent token");
583 
584         return owner;
585     }
586 
587     /**
588      * @dev Approves another address to transfer the given token ID
589      * The zero address indicates there is no approved address.
590      * There can only be one approved address per token at a given time.
591      * Can only be called by the token owner or an approved operator.
592      * @param to address to be approved for the given token ID
593      * @param tokenId uint256 ID of the token to be approved
594      */
595     function approve(address to, uint256 tokenId) public {
596         address owner = ownerOf(tokenId);
597         require(to != owner, "ERC721: approval to current owner");
598 
599         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
600             "ERC721: approve caller is not owner nor approved for all"
601         );
602 
603         _tokenApprovals[tokenId] = to;
604         emit Approval(owner, to, tokenId);
605     }
606 
607     /**
608      * @dev Gets the approved address for a token ID, or zero if no address set
609      * Reverts if the token ID does not exist.
610      * @param tokenId uint256 ID of the token to query the approval of
611      * @return address currently approved for the given token ID
612      */
613     function getApproved(uint256 tokenId) public view returns (address) {
614         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
615 
616         return _tokenApprovals[tokenId];
617     }
618 
619     /**
620      * @dev Sets or unsets the approval of a given operator
621      * An operator is allowed to transfer all tokens of the sender on their behalf.
622      * @param to operator address to set the approval
623      * @param approved representing the status of the approval to be set
624      */
625     function setApprovalForAll(address to, bool approved) public {
626         require(to != _msgSender(), "ERC721: approve to caller");
627 
628         _operatorApprovals[_msgSender()][to] = approved;
629         emit ApprovalForAll(_msgSender(), to, approved);
630     }
631 
632     /**
633      * @dev Tells whether an operator is approved by a given owner.
634      * @param owner owner address which you want to query the approval of
635      * @param operator operator address which you want to query the approval of
636      * @return bool whether the given operator is approved by the given owner
637      */
638     function isApprovedForAll(address owner, address operator) public view returns (bool) {
639         return _operatorApprovals[owner][operator];
640     }
641 
642     /**
643      * @dev Transfers the ownership of a given token ID to another address.
644      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
645      * Requires the msg.sender to be the owner, approved, or operator.
646      * @param from current owner of the token
647      * @param to address to receive the ownership of the given token ID
648      * @param tokenId uint256 ID of the token to be transferred
649      */
650     function transferFrom(address from, address to, uint256 tokenId) public {
651         //solhint-disable-next-line max-line-length
652         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
653 
654         _transferFrom(from, to, tokenId);
655     }
656 
657     /**
658      * @dev Safely transfers the ownership of a given token ID to another address
659      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
660      * which is called upon a safe transfer, and return the magic value
661      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
662      * the transfer is reverted.
663      * Requires the msg.sender to be the owner, approved, or operator
664      * @param from current owner of the token
665      * @param to address to receive the ownership of the given token ID
666      * @param tokenId uint256 ID of the token to be transferred
667      */
668     function safeTransferFrom(address from, address to, uint256 tokenId) public {
669         safeTransferFrom(from, to, tokenId, "");
670     }
671 
672     /**
673      * @dev Safely transfers the ownership of a given token ID to another address
674      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
675      * which is called upon a safe transfer, and return the magic value
676      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
677      * the transfer is reverted.
678      * Requires the _msgSender() to be the owner, approved, or operator
679      * @param from current owner of the token
680      * @param to address to receive the ownership of the given token ID
681      * @param tokenId uint256 ID of the token to be transferred
682      * @param _data bytes data to send along with a safe transfer check
683      */
684     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
685         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
686         _safeTransferFrom(from, to, tokenId, _data);
687     }
688 
689     /**
690      * @dev Safely transfers the ownership of a given token ID to another address
691      * If the target address is a contract, it must implement `onERC721Received`,
692      * which is called upon a safe transfer, and return the magic value
693      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
694      * the transfer is reverted.
695      * Requires the msg.sender to be the owner, approved, or operator
696      * @param from current owner of the token
697      * @param to address to receive the ownership of the given token ID
698      * @param tokenId uint256 ID of the token to be transferred
699      * @param _data bytes data to send along with a safe transfer check
700      */
701     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
702         _transferFrom(from, to, tokenId);
703         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
704     }
705 
706     /**
707      * @dev Returns whether the specified token exists.
708      * @param tokenId uint256 ID of the token to query the existence of
709      * @return bool whether the token exists
710      */
711     function _exists(uint256 tokenId) internal view returns (bool) {
712         address owner = _tokenOwner[tokenId];
713         return owner != address(0);
714     }
715 
716     /**
717      * @dev Returns whether the given spender can transfer a given token ID.
718      * @param spender address of the spender to query
719      * @param tokenId uint256 ID of the token to be transferred
720      * @return bool whether the msg.sender is approved for the given token ID,
721      * is an operator of the owner, or is the owner of the token
722      */
723     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
724         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
725         address owner = ownerOf(tokenId);
726         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
727     }
728 
729     /**
730      * @dev Internal function to safely mint a new token.
731      * Reverts if the given token ID already exists.
732      * If the target address is a contract, it must implement `onERC721Received`,
733      * which is called upon a safe transfer, and return the magic value
734      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
735      * the transfer is reverted.
736      * @param to The address that will own the minted token
737      * @param tokenId uint256 ID of the token to be minted
738      */
739     function _safeMint(address to, uint256 tokenId) internal {
740         _safeMint(to, tokenId, "");
741     }
742 
743     /**
744      * @dev Internal function to safely mint a new token.
745      * Reverts if the given token ID already exists.
746      * If the target address is a contract, it must implement `onERC721Received`,
747      * which is called upon a safe transfer, and return the magic value
748      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
749      * the transfer is reverted.
750      * @param to The address that will own the minted token
751      * @param tokenId uint256 ID of the token to be minted
752      * @param _data bytes data to send along with a safe transfer check
753      */
754     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
755         _mint(to, tokenId);
756         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
757     }
758 
759     /**
760      * @dev Internal function to mint a new token.
761      * Reverts if the given token ID already exists.
762      * @param to The address that will own the minted token
763      * @param tokenId uint256 ID of the token to be minted
764      */
765     function _mint(address to, uint256 tokenId) internal {
766         require(to != address(0), "ERC721: mint to the zero address");
767         require(!_exists(tokenId), "ERC721: token already minted");
768 
769         _tokenOwner[tokenId] = to;
770         _ownedTokensCount[to].increment();
771 
772         emit Transfer(address(0), to, tokenId);
773     }
774 
775     /**
776      * @dev Internal function to burn a specific token.
777      * Reverts if the token does not exist.
778      * Deprecated, use {_burn} instead.
779      * @param owner owner of the token to burn
780      * @param tokenId uint256 ID of the token being burned
781      */
782     function _burn(address owner, uint256 tokenId) internal {
783         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
784 
785         _clearApproval(tokenId);
786 
787         _ownedTokensCount[owner].decrement();
788         _tokenOwner[tokenId] = address(0);
789 
790         emit Transfer(owner, address(0), tokenId);
791     }
792 
793     /**
794      * @dev Internal function to burn a specific token.
795      * Reverts if the token does not exist.
796      * @param tokenId uint256 ID of the token being burned
797      */
798     function _burn(uint256 tokenId) internal {
799         _burn(ownerOf(tokenId), tokenId);
800     }
801 
802     /**
803      * @dev Internal function to transfer ownership of a given token ID to another address.
804      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
805      * @param from current owner of the token
806      * @param to address to receive the ownership of the given token ID
807      * @param tokenId uint256 ID of the token to be transferred
808      */
809     function _transferFrom(address from, address to, uint256 tokenId) internal {
810         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
811         require(to != address(0), "ERC721: transfer to the zero address");
812 
813         _clearApproval(tokenId);
814 
815         _ownedTokensCount[from].decrement();
816         _ownedTokensCount[to].increment();
817 
818         _tokenOwner[tokenId] = to;
819 
820         emit Transfer(from, to, tokenId);
821     }
822 
823     /**
824      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
825      * The call is not executed if the target address is not a contract.
826      *
827      * This is an internal detail of the `ERC721` contract and its use is deprecated.
828      * @param from address representing the previous owner of the given token ID
829      * @param to target address that will receive the tokens
830      * @param tokenId uint256 ID of the token to be transferred
831      * @param _data bytes optional data to send along with the call
832      * @return bool whether the call correctly returned the expected magic value
833      */
834     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
835         internal returns (bool)
836     {
837         if (!to.isContract()) {
838             return true;
839         }
840         // solhint-disable-next-line avoid-low-level-calls
841         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
842             IERC721Receiver(to).onERC721Received.selector,
843             _msgSender(),
844             from,
845             tokenId,
846             _data
847         ));
848         if (!success) {
849             if (returndata.length > 0) {
850                 // solhint-disable-next-line no-inline-assembly
851                 assembly {
852                     let returndata_size := mload(returndata)
853                     revert(add(32, returndata), returndata_size)
854                 }
855             } else {
856                 revert("ERC721: transfer to non ERC721Receiver implementer");
857             }
858         } else {
859             bytes4 retval = abi.decode(returndata, (bytes4));
860             return (retval == _ERC721_RECEIVED);
861         }
862     }
863 
864     /**
865      * @dev Private function to clear current approval of a given token ID.
866      * @param tokenId uint256 ID of the token to be transferred
867      */
868     function _clearApproval(uint256 tokenId) private {
869         if (_tokenApprovals[tokenId] != address(0)) {
870             _tokenApprovals[tokenId] = address(0);
871         }
872     }
873 }
874 
875 /**
876  * @title ERC721 Burnable Token
877  * @dev ERC721 Token that can be irreversibly burned (destroyed).
878  */
879 contract ERC721Burnable is Context, ERC721 {
880     /**
881      * @dev Burns a specific ERC721 token.
882      * @param tokenId uint256 id of the ERC721 token to be burned.
883      */
884     function burn(uint256 tokenId) public {
885         //solhint-disable-next-line max-line-length
886         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
887         _burn(tokenId);
888     }
889 }
890 
891 /**
892  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
893  * @dev See https://eips.ethereum.org/EIPS/eip-721
894  */
895 contract IERC721Enumerable is IERC721 {
896     function totalSupply() public view returns (uint256);
897     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
898 
899     function tokenByIndex(uint256 index) public view returns (uint256);
900 }
901 
902 /**
903  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
904  * @dev See https://eips.ethereum.org/EIPS/eip-721
905  */
906 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
907     // Mapping from owner to list of owned token IDs
908     mapping(address => uint256[]) private _ownedTokens;
909 
910     // Mapping from token ID to index of the owner tokens list
911     mapping(uint256 => uint256) private _ownedTokensIndex;
912 
913     // Array with all token ids, used for enumeration
914     uint256[] private _allTokens;
915 
916     // Mapping from token id to position in the allTokens array
917     mapping(uint256 => uint256) private _allTokensIndex;
918 
919     /*
920      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
921      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
922      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
923      *
924      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
925      */
926     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
927 
928     /**
929      * @dev Constructor function.
930      */
931     constructor () public {
932         // register the supported interface to conform to ERC721Enumerable via ERC165
933         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
934     }
935 
936     /**
937      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
938      * @param owner address owning the tokens list to be accessed
939      * @param index uint256 representing the index to be accessed of the requested tokens list
940      * @return uint256 token ID at the given index of the tokens list owned by the requested address
941      */
942     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
943         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
944         return _ownedTokens[owner][index];
945     }
946 
947     /**
948      * @dev Gets the total amount of tokens stored by the contract.
949      * @return uint256 representing the total amount of tokens
950      */
951     function totalSupply() public view returns (uint256) {
952         return _allTokens.length;
953     }
954 
955     /**
956      * @dev Gets the token ID at a given index of all the tokens in this contract
957      * Reverts if the index is greater or equal to the total number of tokens.
958      * @param index uint256 representing the index to be accessed of the tokens list
959      * @return uint256 token ID at the given index of the tokens list
960      */
961     function tokenByIndex(uint256 index) public view returns (uint256) {
962         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
963         return _allTokens[index];
964     }
965 
966     /**
967      * @dev Internal function to transfer ownership of a given token ID to another address.
968      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
969      * @param from current owner of the token
970      * @param to address to receive the ownership of the given token ID
971      * @param tokenId uint256 ID of the token to be transferred
972      */
973     function _transferFrom(address from, address to, uint256 tokenId) internal {
974         super._transferFrom(from, to, tokenId);
975 
976         _removeTokenFromOwnerEnumeration(from, tokenId);
977 
978         _addTokenToOwnerEnumeration(to, tokenId);
979     }
980 
981     /**
982      * @dev Internal function to mint a new token.
983      * Reverts if the given token ID already exists.
984      * @param to address the beneficiary that will own the minted token
985      * @param tokenId uint256 ID of the token to be minted
986      */
987     function _mint(address to, uint256 tokenId) internal {
988         super._mint(to, tokenId);
989 
990         _addTokenToOwnerEnumeration(to, tokenId);
991 
992         _addTokenToAllTokensEnumeration(tokenId);
993     }
994 
995     /**
996      * @dev Internal function to burn a specific token.
997      * Reverts if the token does not exist.
998      * Deprecated, use {ERC721-_burn} instead.
999      * @param owner owner of the token to burn
1000      * @param tokenId uint256 ID of the token being burned
1001      */
1002     function _burn(address owner, uint256 tokenId) internal {
1003         super._burn(owner, tokenId);
1004 
1005         _removeTokenFromOwnerEnumeration(owner, tokenId);
1006         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1007         _ownedTokensIndex[tokenId] = 0;
1008 
1009         _removeTokenFromAllTokensEnumeration(tokenId);
1010     }
1011 
1012     /**
1013      * @dev Gets the list of token IDs of the requested owner.
1014      * @param owner address owning the tokens
1015      * @return uint256[] List of token IDs owned by the requested address
1016      */
1017     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1018         return _ownedTokens[owner];
1019     }
1020 
1021     /**
1022      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1023      * @param to address representing the new owner of the given token ID
1024      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1025      */
1026     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1027         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1028         _ownedTokens[to].push(tokenId);
1029     }
1030 
1031     /**
1032      * @dev Private function to add a token to this extension's token tracking data structures.
1033      * @param tokenId uint256 ID of the token to be added to the tokens list
1034      */
1035     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1036         _allTokensIndex[tokenId] = _allTokens.length;
1037         _allTokens.push(tokenId);
1038     }
1039 
1040     /**
1041      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1042      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1043      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1044      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1045      * @param from address representing the previous owner of the given token ID
1046      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1047      */
1048     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1049         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1050         // then delete the last slot (swap and pop).
1051 
1052         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1053         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1054 
1055         // When the token to delete is the last token, the swap operation is unnecessary
1056         if (tokenIndex != lastTokenIndex) {
1057             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1058 
1059             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1060             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1061         }
1062 
1063         // This also deletes the contents at the last position of the array
1064         _ownedTokens[from].length--;
1065 
1066         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1067         // lastTokenId, or just over the end of the array if the token was the last one).
1068     }
1069 
1070     /**
1071      * @dev Private function to remove a token from this extension's token tracking data structures.
1072      * This has O(1) time complexity, but alters the order of the _allTokens array.
1073      * @param tokenId uint256 ID of the token to be removed from the tokens list
1074      */
1075     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1076         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1077         // then delete the last slot (swap and pop).
1078 
1079         uint256 lastTokenIndex = _allTokens.length.sub(1);
1080         uint256 tokenIndex = _allTokensIndex[tokenId];
1081 
1082         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1083         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1084         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1085         uint256 lastTokenId = _allTokens[lastTokenIndex];
1086 
1087         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1088         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1089 
1090         // This also deletes the contents at the last position of the array
1091         _allTokens.length--;
1092         _allTokensIndex[tokenId] = 0;
1093     }
1094 }
1095 
1096 library UintLibrary {
1097     function toString(uint256 _i) internal pure returns (string memory) {
1098         if (_i == 0) {
1099             return "0";
1100         }
1101         uint j = _i;
1102         uint len;
1103         while (j != 0) {
1104             len++;
1105             j /= 10;
1106         }
1107         bytes memory bstr = new bytes(len);
1108         uint k = len - 1;
1109         while (_i != 0) {
1110             bstr[k--] = byte(uint8(48 + _i % 10));
1111             _i /= 10;
1112         }
1113         return string(bstr);
1114     }
1115 }
1116 
1117 library StringLibrary {
1118     using UintLibrary for uint256;
1119 
1120     function append(string memory _a, string memory _b) internal pure returns (string memory) {
1121         bytes memory _ba = bytes(_a);
1122         bytes memory _bb = bytes(_b);
1123         bytes memory bab = new bytes(_ba.length + _bb.length);
1124         uint k = 0;
1125         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1126         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1127         return string(bab);
1128     }
1129 
1130     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1131         bytes memory _ba = bytes(_a);
1132         bytes memory _bb = bytes(_b);
1133         bytes memory _bc = bytes(_c);
1134         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
1135         uint k = 0;
1136         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
1137         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
1138         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
1139         return string(bbb);
1140     }
1141 
1142     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1143         bytes memory msgBytes = bytes(message);
1144         bytes memory fullMessage = concat(
1145             bytes("\x19Ethereum Signed Message:\n"),
1146             bytes(msgBytes.length.toString()),
1147             msgBytes,
1148             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1149         );
1150         return ecrecover(keccak256(fullMessage), v, r, s);
1151     }
1152 
1153     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1154         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1155         uint k = 0;
1156         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1157         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1158         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1159         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1160         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1161         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1162         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1163         return resultBytes;
1164     }
1165 }
1166 
1167 contract HasContractURI is ERC165 {
1168 
1169     string public contractURI;
1170 
1171     /*
1172      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
1173      */
1174     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
1175 
1176     constructor(string memory _contractURI) public {
1177         contractURI = _contractURI;
1178         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
1179     }
1180 
1181     /**
1182      * @dev Internal function to set the contract URI
1183      * @param _contractURI string URI prefix to assign
1184      */
1185     function _setContractURI(string memory _contractURI) internal {
1186         contractURI = _contractURI;
1187     }
1188 }
1189 
1190 contract HasTokenURI {
1191     using StringLibrary for string;
1192 
1193     //Token URI prefix
1194     string public tokenURIPrefix;
1195 
1196     // Optional mapping for token URIs
1197     mapping(uint256 => string) private _tokenURIs;
1198 
1199     constructor(string memory _tokenURIPrefix) public {
1200         tokenURIPrefix = _tokenURIPrefix;
1201     }
1202 
1203     /**
1204      * @dev Returns an URI for a given token ID.
1205      * Throws if the token ID does not exist. May return an empty string.
1206      * @param tokenId uint256 ID of the token to query
1207      */
1208     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1209         return tokenURIPrefix.append(_tokenURIs[tokenId]);
1210     }
1211 
1212     /**
1213      * @dev Internal function to set the token URI for a given token.
1214      * Reverts if the token ID does not exist.
1215      * @param tokenId uint256 ID of the token to set its URI
1216      * @param uri string URI to assign
1217      */
1218     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1219         _tokenURIs[tokenId] = uri;
1220     }
1221 
1222     /**
1223      * @dev Internal function to set the token URI prefix.
1224      * @param _tokenURIPrefix string URI prefix to assign
1225      */
1226     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
1227         tokenURIPrefix = _tokenURIPrefix;
1228     }
1229 
1230     function _clearTokenURI(uint256 tokenId) internal {
1231         if (bytes(_tokenURIs[tokenId]).length != 0) {
1232             delete _tokenURIs[tokenId];
1233         }
1234     }
1235 }
1236 
1237 contract HasSecondarySaleFees is ERC165 {
1238 
1239     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
1240 
1241     /*
1242      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1243      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1244      *
1245      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1246      */
1247     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1248 
1249     constructor() public {
1250         _registerInterface(_INTERFACE_ID_FEES);
1251     }
1252 
1253     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
1254     function getFeeBps(uint256 id) public view returns (uint[] memory);
1255 }
1256 
1257 /**
1258  * @title Full ERC721 Token with support for tokenURIPrefix
1259  * This implementation includes all the required and some optional functionality of the ERC721 standard
1260  * Moreover, it includes approve all functionality using operator terminology
1261  * @dev see https://eips.ethereum.org/EIPS/eip-721
1262  */
1263 contract ERC721Base is HasSecondarySaleFees, ERC721, HasContractURI, HasTokenURI, ERC721Enumerable {
1264     // Token name
1265     string public name;
1266 
1267     // Token symbol
1268     string public symbol;
1269 
1270     struct Fee {
1271         address payable recipient;
1272         uint256 value;
1273     }
1274 
1275     // id => fees
1276     mapping (uint256 => Fee[]) public fees;
1277 
1278     /*
1279      *     bytes4(keccak256('name()')) == 0x06fdde03
1280      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1281      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1282      *
1283      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1284      */
1285     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1286 
1287     /**
1288      * @dev Constructor function
1289      */
1290     constructor (string memory _name, string memory _symbol, string memory contractURI, string memory _tokenURIPrefix) HasContractURI(contractURI) HasTokenURI(_tokenURIPrefix) public {
1291         name = _name;
1292         symbol = _symbol;
1293 
1294         // register the supported interfaces to conform to ERC721 via ERC165
1295         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1296     }
1297 
1298     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
1299         Fee[] memory _fees = fees[id];
1300         address payable[] memory result = new address payable[](_fees.length);
1301         for (uint i = 0; i < _fees.length; i++) {
1302             result[i] = _fees[i].recipient;
1303         }
1304         return result;
1305     }
1306 
1307     function getFeeBps(uint256 id) public view returns (uint[] memory) {
1308         Fee[] memory _fees = fees[id];
1309         uint[] memory result = new uint[](_fees.length);
1310         for (uint i = 0; i < _fees.length; i++) {
1311             result[i] = _fees[i].value;
1312         }
1313         return result;
1314     }
1315 
1316     function _mint(address to, uint256 tokenId, Fee[] memory _fees) internal {
1317         _mint(to, tokenId);
1318         address[] memory recipients = new address[](_fees.length);
1319         uint[] memory bps = new uint[](_fees.length);
1320         for (uint i = 0; i < _fees.length; i++) {
1321             require(_fees[i].recipient != address(0x0), "Recipient should be present");
1322             require(_fees[i].value != 0, "Fee value should be positive");
1323             fees[tokenId].push(_fees[i]);
1324             recipients[i] = _fees[i].recipient;
1325             bps[i] = _fees[i].value;
1326         }
1327         if (_fees.length > 0) {
1328             emit SecondarySaleFees(tokenId, recipients, bps);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns an URI for a given token ID.
1334      * Throws if the token ID does not exist. May return an empty string.
1335      * @param tokenId uint256 ID of the token to query
1336      */
1337     function tokenURI(uint256 tokenId) external view returns (string memory) {
1338         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1339         return super._tokenURI(tokenId);
1340     }
1341 
1342     /**
1343      * @dev Internal function to set the token URI for a given token.
1344      * Reverts if the token ID does not exist.
1345      * @param tokenId uint256 ID of the token to set its URI
1346      * @param uri string URI to assign
1347      */
1348     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1349         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1350         super._setTokenURI(tokenId, uri);
1351     }
1352 
1353     /**
1354      * @dev Internal function to burn a specific token.
1355      * Reverts if the token does not exist.
1356      * Deprecated, use _burn(uint256) instead.
1357      * @param owner owner of the token to burn
1358      * @param tokenId uint256 ID of the token being burned by the msg.sender
1359      */
1360     function _burn(address owner, uint256 tokenId) internal {
1361         super._burn(owner, tokenId);
1362         _clearTokenURI(tokenId);
1363     }
1364 }
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 /**
1374  * @title MintableToken
1375  * @dev anyone can mint token.
1376  */
1377 contract MintableToken is Ownable, IERC721, IERC721Metadata, ERC721Burnable, ERC721Base {
1378 
1379     constructor (string memory name, string memory symbol, address newOwner, string memory contractURI, string memory tokenURIPrefix) public ERC721Base(name, symbol, contractURI, tokenURIPrefix) {
1380         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1381         transferOwnership(newOwner);
1382     }
1383 
1384     function mint(uint256 tokenId, uint8 v, bytes32 r, bytes32 s, Fee[] memory _fees, string memory tokenURI) public {
1385         require(owner() == ecrecover(keccak256(abi.encodePacked(this, tokenId)), v, r, s), "owner should sign tokenId");
1386         _mint(msg.sender, tokenId, _fees);
1387         _setTokenURI(tokenId, tokenURI);
1388     }
1389 
1390     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
1391         _setTokenURIPrefix(tokenURIPrefix);
1392     }
1393 
1394     function setContractURI(string memory contractURI) public onlyOwner {
1395         _setContractURI(contractURI);
1396     }
1397 }
1398 
1399 library AddressLibrary {
1400     function toString(address _addr) internal pure returns (string memory) {
1401         bytes32 value = bytes32(uint256(_addr));
1402         bytes memory alphabet = "0123456789abcdef";
1403         bytes memory str = new bytes(42);
1404         str[0] = '0';
1405         str[1] = 'x';
1406         for (uint256 i = 0; i < 20; i++) {
1407             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1408             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1409         }
1410         return string(str);
1411     }
1412 }
1413 
1414 contract AbstractSale is Ownable {
1415     using UintLibrary for uint256;
1416     using AddressLibrary for address;
1417     using StringLibrary for string;
1418     using SafeMath for uint256;
1419 
1420     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1421 
1422     uint public buyerFee = 0;
1423     address payable public beneficiary;
1424 
1425     /* An ECDSA signature. */
1426     struct Sig {
1427         /* v parameter */
1428         uint8 v;
1429         /* r parameter */
1430         bytes32 r;
1431         /* s parameter */
1432         bytes32 s;
1433     }
1434 
1435     constructor(address payable _beneficiary) public {
1436         beneficiary = _beneficiary;
1437     }
1438 
1439     function setBuyerFee(uint256 _buyerFee) public onlyOwner {
1440         buyerFee = _buyerFee;
1441     }
1442 
1443     function setBeneficiary(address payable _beneficiary) public onlyOwner {
1444         beneficiary = _beneficiary;
1445     }
1446 
1447     function prepareMessage(address token, uint256 tokenId, uint256 price, uint256 fee, uint256 nonce) internal pure returns (string memory) {
1448         string memory result = string(strConcat(
1449                 bytes(token.toString()),
1450                 bytes(". tokenId: "),
1451                 bytes(tokenId.toString()),
1452                 bytes(". price: "),
1453                 bytes(price.toString()),
1454                 bytes(". nonce: "),
1455                 bytes(nonce.toString())
1456             ));
1457         if (fee != 0) {
1458             return result.append(". fee: ", fee.toString());
1459         } else {
1460             return result;
1461         }
1462     }
1463 
1464     function strConcat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1465         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1466         uint k = 0;
1467         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1468         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1469         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1470         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1471         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1472         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1473         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1474         return resultBytes;
1475     }
1476 
1477     function transferEther(IERC165 token, uint256 tokenId, address payable owner, uint256 total, uint256 sellerFee) internal {
1478         uint value = transferFeeToBeneficiary(total, sellerFee);
1479         if (token.supportsInterface(_INTERFACE_ID_FEES)) {
1480             HasSecondarySaleFees withFees = HasSecondarySaleFees(address(token));
1481             address payable[] memory recipients = withFees.getFeeRecipients(tokenId);
1482             uint[] memory fees = withFees.getFeeBps(tokenId);
1483             require(fees.length == recipients.length);
1484             for (uint256 i = 0; i < fees.length; i++) {
1485                 (uint newValue, uint current) = subFee(value, total.mul(fees[i]).div(10000));
1486                 value = newValue;
1487                 recipients[i].transfer(current);
1488             }
1489         }
1490         owner.transfer(value);
1491     }
1492 
1493     function transferFeeToBeneficiary(uint total, uint sellerFee) internal returns (uint) {
1494         (uint value, uint sellerFeeValue) = subFee(total, total.mul(sellerFee).div(10000));
1495         uint buyerFeeValue = total.mul(buyerFee).div(10000);
1496         uint beneficiaryFee = buyerFeeValue.add(sellerFeeValue);
1497         if (beneficiaryFee > 0) {
1498             beneficiary.transfer(beneficiaryFee);
1499         }
1500         return value;
1501     }
1502 
1503     function subFee(uint value, uint fee) internal pure returns (uint newValue, uint realFee) {
1504         if (value > fee) {
1505             newValue = value - fee;
1506             realFee = fee;
1507         } else {
1508             newValue = 0;
1509             realFee = value;
1510         }
1511     }
1512 }
1513 
1514 /**
1515     @title ERC-1155 Multi Token Standard
1516     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
1517     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
1518  */
1519 contract IERC1155 is IERC165 {
1520     /**
1521         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
1522         The `_operator` argument MUST be msg.sender.
1523         The `_from` argument MUST be the address of the holder whose balance is decreased.
1524         The `_to` argument MUST be the address of the recipient whose balance is increased.
1525         The `_id` argument MUST be the token type being transferred.
1526         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
1527         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
1528         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
1529     */
1530     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
1531 
1532     /**
1533         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
1534         The `_operator` argument MUST be msg.sender.
1535         The `_from` argument MUST be the address of the holder whose balance is decreased.
1536         The `_to` argument MUST be the address of the recipient whose balance is increased.
1537         The `_ids` argument MUST be the list of tokens being transferred.
1538         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
1539         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
1540         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
1541     */
1542     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
1543 
1544     /**
1545         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
1546     */
1547     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1548 
1549     /**
1550         @dev MUST emit when the URI is updated for a token ID.
1551         URIs are defined in RFC 3986.
1552         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
1553     */
1554     event URI(string _value, uint256 indexed _id);
1555 
1556     /**
1557         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
1558         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
1559         MUST revert if `_to` is the zero address.
1560         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
1561         MUST revert on any other error.
1562         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
1563         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
1564         @param _from    Source address
1565         @param _to      Target address
1566         @param _id      ID of the token type
1567         @param _value   Transfer amount
1568         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
1569     */
1570     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
1571 
1572     /**
1573         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
1574         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
1575         MUST revert if `_to` is the zero address.
1576         MUST revert if length of `_ids` is not the same as length of `_values`.
1577         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
1578         MUST revert on any other error.
1579         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
1580         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
1581         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
1582         @param _from    Source address
1583         @param _to      Target address
1584         @param _ids     IDs of each token type (order and length must match _values array)
1585         @param _values  Transfer amounts per token type (order and length must match _ids array)
1586         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
1587     */
1588     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
1589 
1590     /**
1591         @notice Get the balance of an account's Tokens.
1592         @param _owner  The address of the token holder
1593         @param _id     ID of the Token
1594         @return        The _owner's balance of the Token type requested
1595      */
1596     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
1597 
1598     /**
1599         @notice Get the balance of multiple account/token pairs
1600         @param _owners The addresses of the token holders
1601         @param _ids    ID of the Tokens
1602         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1603      */
1604     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
1605 
1606     /**
1607         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
1608         @dev MUST emit the ApprovalForAll event on success.
1609         @param _operator  Address to add to the set of authorized operators
1610         @param _approved  True if the operator is approved, false to revoke approval
1611     */
1612     function setApprovalForAll(address _operator, bool _approved) external;
1613 
1614     /**
1615         @notice Queries the approval status of an operator for a given owner.
1616         @param _owner     The owner of the Tokens
1617         @param _operator  Address of authorized operator
1618         @return           True if the operator is approved, false if not
1619     */
1620     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
1621 }
1622 
1623 /**
1624  * @title Roles
1625  * @dev Library for managing addresses assigned to a Role.
1626  */
1627 library Roles {
1628     struct Role {
1629         mapping (address => bool) bearer;
1630     }
1631 
1632     /**
1633      * @dev Give an account access to this role.
1634      */
1635     function add(Role storage role, address account) internal {
1636         require(!has(role, account), "Roles: account already has role");
1637         role.bearer[account] = true;
1638     }
1639 
1640     /**
1641      * @dev Remove an account's access to this role.
1642      */
1643     function remove(Role storage role, address account) internal {
1644         require(has(role, account), "Roles: account does not have role");
1645         role.bearer[account] = false;
1646     }
1647 
1648     /**
1649      * @dev Check if an account has this role.
1650      * @return bool
1651      */
1652     function has(Role storage role, address account) internal view returns (bool) {
1653         require(account != address(0), "Roles: account is the zero address");
1654         return role.bearer[account];
1655     }
1656 }
1657 
1658 contract OperatorRole is Context {
1659     using Roles for Roles.Role;
1660 
1661     event OperatorAdded(address indexed account);
1662     event OperatorRemoved(address indexed account);
1663 
1664     Roles.Role private _operators;
1665 
1666     constructor () internal {
1667 
1668     }
1669 
1670     modifier onlyOperator() {
1671         require(isOperator(_msgSender()), "OperatorRole: caller does not have the Operator role");
1672         _;
1673     }
1674 
1675     function isOperator(address account) public view returns (bool) {
1676         return _operators.has(account);
1677     }
1678 
1679     function _addOperator(address account) internal {
1680         _operators.add(account);
1681         emit OperatorAdded(account);
1682     }
1683 
1684     function _removeOperator(address account) internal {
1685         _operators.remove(account);
1686         emit OperatorRemoved(account);
1687     }
1688 }
1689 
1690 contract OwnableOperatorRole is Ownable, OperatorRole {
1691     function addOperator(address account) public onlyOwner {
1692         _addOperator(account);
1693     }
1694 
1695     function removeOperator(address account) public onlyOwner {
1696         _removeOperator(account);
1697     }
1698 }
1699 
1700 contract TransferProxy is OwnableOperatorRole {
1701 
1702     function erc721safeTransferFrom(IERC721 token, address from, address to, uint256 tokenId) external onlyOperator {
1703         token.safeTransferFrom(from, to, tokenId);
1704     }
1705 
1706     function erc1155safeTransferFrom(IERC1155 token, address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external onlyOperator {
1707         token.safeTransferFrom(_from, _to, _id, _value, _data);
1708     }
1709 }
1710 
1711 contract IERC721Sale {
1712     function getNonce(IERC721 token, uint256 tokenId) view public returns (uint256);
1713 }
1714 
1715 contract ERC721SaleNonceHolder is OwnableOperatorRole {
1716     mapping(bytes32 => uint256) public nonces;
1717     IERC721Sale public previous;
1718 
1719     constructor(IERC721Sale _previous) public {
1720         previous = _previous;
1721     }
1722 
1723     function getNonce(IERC721 token, uint256 tokenId) view public returns (uint256) {
1724         uint256 newNonce = nonces[getPositionKey(token, tokenId)];
1725         if (newNonce != 0) {
1726             return newNonce;
1727         }
1728         if (address(previous) == address(0x0)) {
1729             return 0;
1730         }
1731         return previous.getNonce(token, tokenId);
1732     }
1733 
1734     function setNonce(IERC721 token, uint256 tokenId, uint256 nonce) public onlyOperator {
1735         nonces[getPositionKey(token, tokenId)] = nonce;
1736     }
1737 
1738     function getPositionKey(IERC721 token, uint256 tokenId) pure public returns (bytes32) {
1739         return keccak256(abi.encodePacked(token, tokenId));
1740     }
1741 }
1742 
1743 
1744 
1745 
1746 
1747 
1748 
1749 
1750 
1751 
1752 
1753 
1754 contract ERC721Sale is Ownable, IERC721Receiver, AbstractSale {
1755     using AddressLibrary for address;
1756     using UintLibrary for uint256;
1757     using StringLibrary for string;
1758 
1759     event Cancel(address indexed token, uint256 indexed tokenId, address owner, uint256 nonce);
1760     event Buy(address indexed token, uint256 indexed tokenId, address seller, address buyer, uint256 price, uint256 nonce);
1761 
1762     TransferProxy public transferProxy;
1763     ERC721SaleNonceHolder public nonceHolder;
1764 
1765     constructor(TransferProxy _transferProxy, ERC721SaleNonceHolder _nonceHolder, address payable beneficiary) AbstractSale(beneficiary) public {
1766         transferProxy = _transferProxy;
1767         nonceHolder = _nonceHolder;
1768     }
1769 
1770     function cancel(IERC721 token, uint256 tokenId) public {
1771         address owner = token.ownerOf(tokenId);
1772         require(owner == msg.sender, "not an owner");
1773         uint256 nonce = nonceHolder.getNonce(token, tokenId) + 1;
1774         nonceHolder.setNonce(token, tokenId, nonce);
1775         emit Cancel(address(token), tokenId, owner, nonce);
1776     }
1777 
1778     function buy(IERC721 token, uint256 tokenId, uint256 price, uint256 sellerFee, Sig memory signature) public payable {
1779         address payable owner = address(uint160(token.ownerOf(tokenId)));
1780         uint256 nonce = nonceHolder.getNonce(token, tokenId);
1781         uint256 buyerFeeValue = price.mul(buyerFee).div(10000);
1782         require(msg.value == price + buyerFeeValue, "msg.value is incorrect");
1783         require(owner == prepareMessage(address(token), tokenId, price, sellerFee, nonce).recover(signature.v, signature.r, signature.s), "owner should sign correct message");
1784         transferProxy.erc721safeTransferFrom(token, owner, msg.sender, tokenId);
1785         transferEther(token, tokenId, owner, price, sellerFee);
1786         nonceHolder.setNonce(token, tokenId, nonce + 1);
1787         emit Buy(address(token), tokenId, owner, msg.sender, price, nonce + 1);
1788     }
1789 
1790     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
1791         return this.onERC721Received.selector;
1792     }
1793 }