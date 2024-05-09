1 pragma solidity ^0.5.14;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File: node_modules\@openzeppelin\contracts\ownership\Ownable.sol
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         _owner = _msgSender();
52         emit OwnershipTransferred(address(0), _owner);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(isOwner(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Returns true if the caller is the current owner.
72      */
73     function isOwner() public view returns (bool) {
74         return _msgSender() == _owner;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      */
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 contract IERC721 is IERC165 {
132     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
135 
136     /**
137      * @dev Returns the number of NFTs in `owner`'s account.
138      */
139     function balanceOf(address owner) public view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the NFT specified by `tokenId`.
143      */
144     function ownerOf(uint256 tokenId) public view returns (address owner);
145 
146     /**
147      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
148      * another (`to`).
149      *
150      *
151      *
152      * Requirements:
153      * - `from`, `to` cannot be zero.
154      * - `tokenId` must be owned by `from`.
155      * - If the caller is not `from`, it must be have been allowed to move this
156      * NFT by either {approve} or {setApprovalForAll}.
157      */
158     function safeTransferFrom(address from, address to, uint256 tokenId) public;
159     /**
160      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
161      * another (`to`).
162      *
163      * Requirements:
164      * - If the caller is not `from`, it must be approved to move this NFT by
165      * either {approve} or {setApprovalForAll}.
166      */
167     function transferFrom(address from, address to, uint256 tokenId) public;
168     function approve(address to, uint256 tokenId) public;
169     function getApproved(uint256 tokenId) public view returns (address operator);
170 
171     function setApprovalForAll(address operator, bool _approved) public;
172     function isApprovedForAll(address owner, address operator) public view returns (bool);
173 
174 
175     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
176 }
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 contract IERC721Receiver {
184     /**
185      * @notice Handle the receipt of an NFT
186      * @dev The ERC721 smart contract calls this function on the recipient
187      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
188      * otherwise the caller will revert the transaction. The selector to be
189      * returned can be obtained as `this.onERC721Received.selector`. This
190      * function MAY throw to revert and reject the transfer.
191      * Note: the ERC721 contract address is always the message sender.
192      * @param operator The address which called `safeTransferFrom` function
193      * @param from The address which previously owned the token
194      * @param tokenId The NFT identifier which is being transferred
195      * @param data Additional data with no specified format
196      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
197      */
198     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
199     public returns (bytes4);
200 }
201 
202 /**
203  * @dev Wrappers over Solidity's arithmetic operations with added overflow
204  * checks.
205  *
206  * Arithmetic operations in Solidity wrap on overflow. This can easily result
207  * in bugs, because programmers usually assume that an overflow raises an
208  * error, which is the standard behavior in high level programming languages.
209  * `SafeMath` restores this intuition by reverting the transaction when an
210  * operation overflows.
211  *
212  * Using this library instead of the unchecked operations eliminates an entire
213  * class of bugs, so it's recommended to use it always.
214  */
215 library SafeMath {
216     /**
217      * @dev Returns the addition of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `+` operator.
221      *
222      * Requirements:
223      * - Addition cannot overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         return sub(a, b, "SafeMath: subtraction overflow");
243     }
244 
245     /**
246      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
247      * overflow (when the result is negative).
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      * - Subtraction cannot overflow.
253      *
254      * _Available since v2.4.0._
255      */
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `*` operator.
268      *
269      * Requirements:
270      * - Multiplication cannot overflow.
271      */
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
274         // benefit is lost if 'b' is also tested.
275         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
276         if (a == 0) {
277             return 0;
278         }
279 
280         uint256 c = a * b;
281         require(c / a == b, "SafeMath: multiplication overflow");
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return div(a, b, "SafeMath: division by zero");
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      *
312      * _Available since v2.4.0._
313      */
314     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         // Solidity only automatically asserts when dividing by 0
316         require(b > 0, errorMessage);
317         uint256 c = a / b;
318         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         return mod(a, b, "SafeMath: modulo by zero");
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * Reverts with custom message when dividing by zero.
341      *
342      * Counterpart to Solidity's `%` operator. This function uses a `revert`
343      * opcode (which leaves remaining gas untouched) while Solidity uses an
344      * invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      *
349      * _Available since v2.4.0._
350      */
351     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b != 0, errorMessage);
353         return a % b;
354     }
355 }
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * This test is non-exhaustive, and there may be false-negatives: during the
365      * execution of a contract's constructor, its address will be reported as
366      * not containing a contract.
367      *
368      * IMPORTANT: It is unsafe to assume that an address for which this
369      * function returns false is an externally-owned account (EOA) and not a
370      * contract.
371      */
372     function isContract(address account) internal view returns (bool) {
373         // This method relies in extcodesize, which returns 0 for contracts in
374         // construction, since the code is only stored at the end of the
375         // constructor execution.
376 
377         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
378         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
379         // for accounts without code, i.e. `keccak256('')`
380         bytes32 codehash;
381         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
382         // solhint-disable-next-line no-inline-assembly
383         assembly { codehash := extcodehash(account) }
384         return (codehash != 0x0 && codehash != accountHash);
385     }
386 
387     /**
388      * @dev Converts an `address` into `address payable`. Note that this is
389      * simply a type cast: the actual underlying value is not changed.
390      *
391      * _Available since v2.4.0._
392      */
393     function toPayable(address account) internal pure returns (address payable) {
394         return address(uint160(account));
395     }
396 
397     /**
398      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
399      * `recipient`, forwarding all available gas and reverting on errors.
400      *
401      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
402      * of certain opcodes, possibly making contracts go over the 2300 gas limit
403      * imposed by `transfer`, making them unable to receive funds via
404      * `transfer`. {sendValue} removes this limitation.
405      *
406      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
407      *
408      * IMPORTANT: because control is transferred to `recipient`, care must be
409      * taken to not create reentrancy vulnerabilities. Consider using
410      * {ReentrancyGuard} or the
411      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
412      *
413      * _Available since v2.4.0._
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         // solhint-disable-next-line avoid-call-value
419         (bool success, ) = recipient.call.value(amount)("");
420         require(success, "Address: unable to send value, recipient may have reverted");
421     }
422 }
423 
424 /**
425  * @title Counters
426  * @author Matt Condon (@shrugs)
427  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
428  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
429  *
430  * Include with `using Counters for Counters.Counter;`
431  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
432  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
433  * directly accessed.
434  */
435 library Counters {
436     using SafeMath for uint256;
437 
438     struct Counter {
439         // This variable should never be directly accessed by users of the library: interactions must be restricted to
440         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
441         // this feature: see https://github.com/ethereum/solidity/issues/4637
442         uint256 _value; // default: 0
443     }
444 
445     function current(Counter storage counter) internal view returns (uint256) {
446         return counter._value;
447     }
448 
449     function increment(Counter storage counter) internal {
450         counter._value += 1;
451     }
452 
453     function decrement(Counter storage counter) internal {
454         counter._value = counter._value.sub(1);
455     }
456 }
457 
458 /**
459  * @dev Implementation of the {IERC165} interface.
460  *
461  * Contracts may inherit from this and call {_registerInterface} to declare
462  * their support of an interface.
463  */
464 contract ERC165 is IERC165 {
465     /*
466      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
467      */
468     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
469 
470     /**
471      * @dev Mapping of interface ids to whether or not it's supported.
472      */
473     mapping(bytes4 => bool) private _supportedInterfaces;
474 
475     constructor () internal {
476         // Derived contracts need only register support for their own interfaces,
477         // we register support for ERC165 itself here
478         _registerInterface(_INTERFACE_ID_ERC165);
479     }
480 
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      *
484      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
485      */
486     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
487         return _supportedInterfaces[interfaceId];
488     }
489 
490     /**
491      * @dev Registers the contract as an implementer of the interface defined by
492      * `interfaceId`. Support of the actual ERC165 interface is automatic and
493      * registering its interface id is not required.
494      *
495      * See {IERC165-supportsInterface}.
496      *
497      * Requirements:
498      *
499      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
500      */
501     function _registerInterface(bytes4 interfaceId) internal {
502         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
503         _supportedInterfaces[interfaceId] = true;
504     }
505 }
506 
507 /**
508  * @title ERC721 Non-Fungible Token Standard basic implementation
509  * @dev see https://eips.ethereum.org/EIPS/eip-721
510  */
511 contract ERC721 is Context, ERC165, IERC721 {
512     using SafeMath for uint256;
513     using Address for address;
514     using Counters for Counters.Counter;
515 
516     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
517     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
518     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
519 
520     // Mapping from token ID to owner
521     mapping (uint256 => address) private _tokenOwner;
522 
523     // Mapping from token ID to approved address
524     mapping (uint256 => address) private _tokenApprovals;
525 
526     // Mapping from owner to number of owned token
527     mapping (address => Counters.Counter) private _ownedTokensCount;
528 
529     // Mapping from owner to operator approvals
530     mapping (address => mapping (address => bool)) private _operatorApprovals;
531 
532     /*
533      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
534      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
535      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
536      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
537      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
538      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
539      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
540      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
541      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
542      *
543      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
544      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
545      */
546     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
547 
548     constructor () public {
549         // register the supported interfaces to conform to ERC721 via ERC165
550         _registerInterface(_INTERFACE_ID_ERC721);
551     }
552 
553     /**
554      * @dev Gets the balance of the specified address.
555      * @param owner address to query the balance of
556      * @return uint256 representing the amount owned by the passed address
557      */
558     function balanceOf(address owner) public view returns (uint256) {
559         require(owner != address(0), "ERC721: balance query for the zero address");
560 
561         return _ownedTokensCount[owner].current();
562     }
563 
564     /**
565      * @dev Gets the owner of the specified token ID.
566      * @param tokenId uint256 ID of the token to query the owner of
567      * @return address currently marked as the owner of the given token ID
568      */
569     function ownerOf(uint256 tokenId) public view returns (address) {
570         address owner = _tokenOwner[tokenId];
571         require(owner != address(0), "ERC721: owner query for nonexistent token");
572 
573         return owner;
574     }
575 
576     /**
577      * @dev Approves another address to transfer the given token ID
578      * The zero address indicates there is no approved address.
579      * There can only be one approved address per token at a given time.
580      * Can only be called by the token owner or an approved operator.
581      * @param to address to be approved for the given token ID
582      * @param tokenId uint256 ID of the token to be approved
583      */
584     function approve(address to, uint256 tokenId) public {
585         address owner = ownerOf(tokenId);
586         require(to != owner, "ERC721: approval to current owner");
587 
588         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
589             "ERC721: approve caller is not owner nor approved for all"
590         );
591 
592         _tokenApprovals[tokenId] = to;
593         emit Approval(owner, to, tokenId);
594     }
595 
596     /**
597      * @dev Gets the approved address for a token ID, or zero if no address set
598      * Reverts if the token ID does not exist.
599      * @param tokenId uint256 ID of the token to query the approval of
600      * @return address currently approved for the given token ID
601      */
602     function getApproved(uint256 tokenId) public view returns (address) {
603         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
604 
605         return _tokenApprovals[tokenId];
606     }
607 
608     /**
609      * @dev Sets or unsets the approval of a given operator
610      * An operator is allowed to transfer all tokens of the sender on their behalf.
611      * @param to operator address to set the approval
612      * @param approved representing the status of the approval to be set
613      */
614     function setApprovalForAll(address to, bool approved) public {
615         require(to != _msgSender(), "ERC721: approve to caller");
616 
617         _operatorApprovals[_msgSender()][to] = approved;
618         emit ApprovalForAll(_msgSender(), to, approved);
619     }
620 
621     /**
622      * @dev Tells whether an operator is approved by a given owner.
623      * @param owner owner address which you want to query the approval of
624      * @param operator operator address which you want to query the approval of
625      * @return bool whether the given operator is approved by the given owner
626      */
627     function isApprovedForAll(address owner, address operator) public view returns (bool) {
628         return _operatorApprovals[owner][operator];
629     }
630 
631     /**
632      * @dev Transfers the ownership of a given token ID to another address.
633      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
634      * Requires the msg.sender to be the owner, approved, or operator.
635      * @param from current owner of the token
636      * @param to address to receive the ownership of the given token ID
637      * @param tokenId uint256 ID of the token to be transferred
638      */
639     function transferFrom(address from, address to, uint256 tokenId) public {
640         //solhint-disable-next-line max-line-length
641         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
642 
643         _transferFrom(from, to, tokenId);
644     }
645 
646     /**
647      * @dev Safely transfers the ownership of a given token ID to another address
648      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
649      * which is called upon a safe transfer, and return the magic value
650      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
651      * the transfer is reverted.
652      * Requires the msg.sender to be the owner, approved, or operator
653      * @param from current owner of the token
654      * @param to address to receive the ownership of the given token ID
655      * @param tokenId uint256 ID of the token to be transferred
656      */
657     function safeTransferFrom(address from, address to, uint256 tokenId) public {
658         safeTransferFrom(from, to, tokenId, "");
659     }
660 
661     /**
662      * @dev Safely transfers the ownership of a given token ID to another address
663      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
664      * which is called upon a safe transfer, and return the magic value
665      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
666      * the transfer is reverted.
667      * Requires the _msgSender() to be the owner, approved, or operator
668      * @param from current owner of the token
669      * @param to address to receive the ownership of the given token ID
670      * @param tokenId uint256 ID of the token to be transferred
671      * @param _data bytes data to send along with a safe transfer check
672      */
673     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675         _safeTransferFrom(from, to, tokenId, _data);
676     }
677 
678     /**
679      * @dev Safely transfers the ownership of a given token ID to another address
680      * If the target address is a contract, it must implement `onERC721Received`,
681      * which is called upon a safe transfer, and return the magic value
682      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
683      * the transfer is reverted.
684      * Requires the msg.sender to be the owner, approved, or operator
685      * @param from current owner of the token
686      * @param to address to receive the ownership of the given token ID
687      * @param tokenId uint256 ID of the token to be transferred
688      * @param _data bytes data to send along with a safe transfer check
689      */
690     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
691         _transferFrom(from, to, tokenId);
692         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
693     }
694 
695     /**
696      * @dev Returns whether the specified token exists.
697      * @param tokenId uint256 ID of the token to query the existence of
698      * @return bool whether the token exists
699      */
700     function _exists(uint256 tokenId) internal view returns (bool) {
701         address owner = _tokenOwner[tokenId];
702         return owner != address(0);
703     }
704 
705     /**
706      * @dev Returns whether the given spender can transfer a given token ID.
707      * @param spender address of the spender to query
708      * @param tokenId uint256 ID of the token to be transferred
709      * @return bool whether the msg.sender is approved for the given token ID,
710      * is an operator of the owner, or is the owner of the token
711      */
712     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
713         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
714         address owner = ownerOf(tokenId);
715         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
716     }
717 
718     /**
719      * @dev Internal function to safely mint a new token.
720      * Reverts if the given token ID already exists.
721      * If the target address is a contract, it must implement `onERC721Received`,
722      * which is called upon a safe transfer, and return the magic value
723      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
724      * the transfer is reverted.
725      * @param to The address that will own the minted token
726      * @param tokenId uint256 ID of the token to be minted
727      */
728     function _safeMint(address to, uint256 tokenId) internal {
729         _safeMint(to, tokenId, "");
730     }
731 
732     /**
733      * @dev Internal function to safely mint a new token.
734      * Reverts if the given token ID already exists.
735      * If the target address is a contract, it must implement `onERC721Received`,
736      * which is called upon a safe transfer, and return the magic value
737      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
738      * the transfer is reverted.
739      * @param to The address that will own the minted token
740      * @param tokenId uint256 ID of the token to be minted
741      * @param _data bytes data to send along with a safe transfer check
742      */
743     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
744         _mint(to, tokenId);
745         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
746     }
747 
748     /**
749      * @dev Internal function to mint a new token.
750      * Reverts if the given token ID already exists.
751      * @param to The address that will own the minted token
752      * @param tokenId uint256 ID of the token to be minted
753      */
754     function _mint(address to, uint256 tokenId) internal {
755         require(to != address(0), "ERC721: mint to the zero address");
756         require(!_exists(tokenId), "ERC721: token already minted");
757 
758         _tokenOwner[tokenId] = to;
759         _ownedTokensCount[to].increment();
760 
761         emit Transfer(address(0), to, tokenId);
762     }
763 
764     /**
765      * @dev Internal function to burn a specific token.
766      * Reverts if the token does not exist.
767      * Deprecated, use {_burn} instead.
768      * @param owner owner of the token to burn
769      * @param tokenId uint256 ID of the token being burned
770      */
771     function _burn(address owner, uint256 tokenId) internal {
772         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
773 
774         _clearApproval(tokenId);
775 
776         _ownedTokensCount[owner].decrement();
777         _tokenOwner[tokenId] = address(0);
778 
779         emit Transfer(owner, address(0), tokenId);
780     }
781 
782     /**
783      * @dev Internal function to burn a specific token.
784      * Reverts if the token does not exist.
785      * @param tokenId uint256 ID of the token being burned
786      */
787     function _burn(uint256 tokenId) internal {
788         _burn(ownerOf(tokenId), tokenId);
789     }
790 
791     /**
792      * @dev Internal function to transfer ownership of a given token ID to another address.
793      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
794      * @param from current owner of the token
795      * @param to address to receive the ownership of the given token ID
796      * @param tokenId uint256 ID of the token to be transferred
797      */
798     function _transferFrom(address from, address to, uint256 tokenId) internal {
799         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
800         require(to != address(0), "ERC721: transfer to the zero address");
801 
802         _clearApproval(tokenId);
803 
804         _ownedTokensCount[from].decrement();
805         _ownedTokensCount[to].increment();
806 
807         _tokenOwner[tokenId] = to;
808 
809         emit Transfer(from, to, tokenId);
810     }
811 
812     /**
813      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
814      * The call is not executed if the target address is not a contract.
815      *
816      * This function is deprecated.
817      * @param from address representing the previous owner of the given token ID
818      * @param to target address that will receive the tokens
819      * @param tokenId uint256 ID of the token to be transferred
820      * @param _data bytes optional data to send along with the call
821      * @return bool whether the call correctly returned the expected magic value
822      */
823     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
824         internal returns (bool)
825     {
826         if (!to.isContract()) {
827             return true;
828         }
829 
830         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
831         return (retval == _ERC721_RECEIVED);
832     }
833 
834     /**
835      * @dev Private function to clear current approval of a given token ID.
836      * @param tokenId uint256 ID of the token to be transferred
837      */
838     function _clearApproval(uint256 tokenId) private {
839         if (_tokenApprovals[tokenId] != address(0)) {
840             _tokenApprovals[tokenId] = address(0);
841         }
842     }
843 }
844 
845 /**
846  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
847  * @dev See https://eips.ethereum.org/EIPS/eip-721
848  */
849 contract IERC721Enumerable is IERC721 {
850     function totalSupply() public view returns (uint256);
851     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
852 
853     function tokenByIndex(uint256 index) public view returns (uint256);
854 }
855 
856 /**
857  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
858  * @dev See https://eips.ethereum.org/EIPS/eip-721
859  */
860 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
861     // Mapping from owner to list of owned token IDs
862     mapping(address => uint256[]) private _ownedTokens;
863 
864     // Mapping from token ID to index of the owner tokens list
865     mapping(uint256 => uint256) private _ownedTokensIndex;
866 
867     // Array with all token ids, used for enumeration
868     uint256[] private _allTokens;
869 
870     // Mapping from token id to position in the allTokens array
871     mapping(uint256 => uint256) private _allTokensIndex;
872 
873     /*
874      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
875      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
876      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
877      *
878      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
879      */
880     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
881 
882     /**
883      * @dev Constructor function.
884      */
885     constructor () public {
886         // register the supported interface to conform to ERC721Enumerable via ERC165
887         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
888     }
889 
890     /**
891      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
892      * @param owner address owning the tokens list to be accessed
893      * @param index uint256 representing the index to be accessed of the requested tokens list
894      * @return uint256 token ID at the given index of the tokens list owned by the requested address
895      */
896     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
897         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
898         return _ownedTokens[owner][index];
899     }
900 
901     /**
902      * @dev Gets the total amount of tokens stored by the contract.
903      * @return uint256 representing the total amount of tokens
904      */
905     function totalSupply() public view returns (uint256) {
906         return _allTokens.length;
907     }
908 
909     /**
910      * @dev Gets the token ID at a given index of all the tokens in this contract
911      * Reverts if the index is greater or equal to the total number of tokens.
912      * @param index uint256 representing the index to be accessed of the tokens list
913      * @return uint256 token ID at the given index of the tokens list
914      */
915     function tokenByIndex(uint256 index) public view returns (uint256) {
916         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
917         return _allTokens[index];
918     }
919 
920     /**
921      * @dev Internal function to transfer ownership of a given token ID to another address.
922      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
923      * @param from current owner of the token
924      * @param to address to receive the ownership of the given token ID
925      * @param tokenId uint256 ID of the token to be transferred
926      */
927     function _transferFrom(address from, address to, uint256 tokenId) internal {
928         super._transferFrom(from, to, tokenId);
929 
930         _removeTokenFromOwnerEnumeration(from, tokenId);
931 
932         _addTokenToOwnerEnumeration(to, tokenId);
933     }
934 
935     /**
936      * @dev Internal function to mint a new token.
937      * Reverts if the given token ID already exists.
938      * @param to address the beneficiary that will own the minted token
939      * @param tokenId uint256 ID of the token to be minted
940      */
941     function _mint(address to, uint256 tokenId) internal {
942         super._mint(to, tokenId);
943 
944         _addTokenToOwnerEnumeration(to, tokenId);
945 
946         _addTokenToAllTokensEnumeration(tokenId);
947     }
948 
949     /**
950      * @dev Internal function to burn a specific token.
951      * Reverts if the token does not exist.
952      * Deprecated, use {ERC721-_burn} instead.
953      * @param owner owner of the token to burn
954      * @param tokenId uint256 ID of the token being burned
955      */
956     function _burn(address owner, uint256 tokenId) internal {
957         super._burn(owner, tokenId);
958 
959         _removeTokenFromOwnerEnumeration(owner, tokenId);
960         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
961         _ownedTokensIndex[tokenId] = 0;
962 
963         _removeTokenFromAllTokensEnumeration(tokenId);
964     }
965 
966     /**
967      * @dev Gets the list of token IDs of the requested owner.
968      * @param owner address owning the tokens
969      * @return uint256[] List of token IDs owned by the requested address
970      */
971     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
972         return _ownedTokens[owner];
973     }
974 
975     /**
976      * @dev Private function to add a token to this extension's ownership-tracking data structures.
977      * @param to address representing the new owner of the given token ID
978      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
979      */
980     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
981         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
982         _ownedTokens[to].push(tokenId);
983     }
984 
985     /**
986      * @dev Private function to add a token to this extension's token tracking data structures.
987      * @param tokenId uint256 ID of the token to be added to the tokens list
988      */
989     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
990         _allTokensIndex[tokenId] = _allTokens.length;
991         _allTokens.push(tokenId);
992     }
993 
994     /**
995      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
996      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
997      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
998      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
999      * @param from address representing the previous owner of the given token ID
1000      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1001      */
1002     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1003         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1004         // then delete the last slot (swap and pop).
1005 
1006         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1007         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1008 
1009         // When the token to delete is the last token, the swap operation is unnecessary
1010         if (tokenIndex != lastTokenIndex) {
1011             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1012 
1013             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1014             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1015         }
1016 
1017         // This also deletes the contents at the last position of the array
1018         _ownedTokens[from].length--;
1019 
1020         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1021         // lastTokenId, or just over the end of the array if the token was the last one).
1022     }
1023 
1024     /**
1025      * @dev Private function to remove a token from this extension's token tracking data structures.
1026      * This has O(1) time complexity, but alters the order of the _allTokens array.
1027      * @param tokenId uint256 ID of the token to be removed from the tokens list
1028      */
1029     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1030         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1031         // then delete the last slot (swap and pop).
1032 
1033         uint256 lastTokenIndex = _allTokens.length.sub(1);
1034         uint256 tokenIndex = _allTokensIndex[tokenId];
1035 
1036         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1037         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1038         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1039         uint256 lastTokenId = _allTokens[lastTokenIndex];
1040 
1041         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1042         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1043 
1044         // This also deletes the contents at the last position of the array
1045         _allTokens.length--;
1046         _allTokensIndex[tokenId] = 0;
1047     }
1048 }
1049 
1050 /**
1051  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1052  * @dev See https://eips.ethereum.org/EIPS/eip-721
1053  */
1054 contract IERC721Metadata is IERC721 {
1055     function name() external view returns (string memory);
1056     function symbol() external view returns (string memory);
1057     function tokenURI(uint256 tokenId) external view returns (string memory);
1058 }
1059 
1060 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1061     // Token name
1062     string private _name;
1063 
1064     // Token symbol
1065     string private _symbol;
1066 
1067     // Optional mapping for token URIs
1068     mapping(uint256 => string) private _tokenURIs;
1069     /*
1070      *     bytes4(keccak256('name()')) == 0x06fdde03
1071      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1072      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1073      *
1074      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1075      */
1076     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1077 
1078     /**
1079      * @dev Constructor function
1080      */
1081     constructor (string memory name, string memory symbol) public {
1082         _name = name;
1083         _symbol = symbol;
1084 
1085         // register the supported interfaces to conform to ERC721 via ERC165
1086         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1087     }
1088 
1089     /**
1090      * @dev Gets the token name.
1091      * @return string representing the token name
1092      */
1093     function name() external view returns (string memory) {
1094         return _name;
1095     }
1096 
1097     /**
1098      * @dev Gets the token symbol.
1099      * @return string representing the token symbol
1100      */
1101     function symbol() external view returns (string memory) {
1102         return _symbol;
1103     }
1104      
1105 
1106     /**
1107      * @dev Internal function to set the token URI for a given token.
1108      * Reverts if the token ID does not exist.
1109      * @param tokenId uint256 ID of the token to set its URI
1110      * @param uri string URI to assign
1111      */
1112     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1113         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1114         _tokenURIs[tokenId] = uri;
1115     }
1116 
1117     /**
1118      * @dev Internal function to burn a specific token.
1119      * Reverts if the token does not exist.
1120      * Deprecated, use _burn(uint256) instead.
1121      * @param owner owner of the token to burn
1122      * @param tokenId uint256 ID of the token being burned by the msg.sender
1123      */
1124     function _burn(address owner, uint256 tokenId) internal {
1125         super._burn(owner, tokenId);
1126 
1127         // Clear metadata (if any)
1128         if (bytes(_tokenURIs[tokenId]).length != 0) {
1129             delete _tokenURIs[tokenId];
1130         }
1131     }
1132 }
1133 
1134 /**
1135  * @title Full ERC721 Token
1136  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1137  * Moreover, it includes approve all functionality using operator terminology.
1138  *
1139  * See https://eips.ethereum.org/EIPS/eip-721
1140  */
1141 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1142     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1143         // solhint-disable-previous-line no-empty-blocks
1144     }
1145 }
1146 
1147 /**
1148  * @title Helps contracts guard against reentrancy attacks.
1149  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
1150  * @dev If you mark a function `nonReentrant`, you should also
1151  * mark it `external`.
1152  */
1153 contract ReentrancyGuard {
1154     /// @dev counter to allow mutex lock with only one SSTORE operation
1155     uint256 private _guardCounter;
1156 
1157     constructor() public {
1158         // The counter starts at one to prevent changing it from zero to a non-zero
1159         // value, which is a more expensive operation.
1160         _guardCounter = 1;
1161     }
1162 
1163     /**
1164      * @dev Prevents a contract from calling itself, directly or indirectly.
1165      * Calling a `nonReentrant` function from another `nonReentrant`
1166      * function is not supported. It is possible to prevent this from happening
1167      * by making the `nonReentrant` function external, and make it call a
1168      * `private` function that does the actual work.
1169      */
1170     modifier nonReentrant() {
1171         _guardCounter += 1;
1172         uint256 localCounter = _guardCounter;
1173         _;
1174         require(localCounter == _guardCounter);
1175     }
1176 }
1177 
1178 
1179 /**
1180  * @title Roles
1181  * @dev Library for managing addresses assigned to a Role.
1182  */
1183 library Roles {
1184     struct Role {
1185         mapping (address => bool) bearer;
1186     }
1187 
1188     /**
1189      * @dev Give an account access to this role.
1190      */
1191     function add(Role storage role, address account) internal {
1192         require(!has(role, account), "Roles: account already has role");
1193         role.bearer[account] = true;
1194     }
1195 
1196     /**
1197      * @dev Remove an account's access to this role.
1198      */
1199     function remove(Role storage role, address account) internal {
1200         require(has(role, account), "Roles: account does not have role");
1201         role.bearer[account] = false;
1202     }
1203 
1204     /**
1205      * @dev Check if an account has this role.
1206      * @return bool
1207      */
1208     function has(Role storage role, address account) internal view returns (bool) {
1209         require(account != address(0), "Roles: account is the zero address");
1210         return role.bearer[account];
1211     }
1212 }
1213 
1214 
1215 library RandomSalt
1216 {
1217 	/**
1218 	* Initialize the pool with the entropy of the blockhashes of the blocks in the closed interval [earliestBlock, latestBlock]
1219 	* The argument "seed" is optional and can be left zero in most cases.
1220 	* This extra seed allows you to select a different sequence of random numbers for the same block range.
1221 	*/
1222 	function init(uint256 earliestBlock, uint256 latestBlock, uint256 seed) internal view returns (bytes32[] memory) {
1223 		require(block.number-1 >= latestBlock && latestBlock >= earliestBlock, "RandomSalt.init: invalid block interval");
1224 		bytes32[] memory pool = new bytes32[](latestBlock-earliestBlock+2);
1225 		bytes32 salt = keccak256(abi.encodePacked(block.number,seed));
1226 		for(uint256 i=0; i<=latestBlock-earliestBlock; i++) {
1227 			// Add some salt to each blockhash so that we don't reuse those hash chains
1228 			// when this function gets called again in another block.
1229 			pool[i+1] = keccak256(abi.encodePacked(blockhash(earliestBlock+i),salt));
1230 		}
1231 		return pool;
1232 	}
1233 	
1234 	/**
1235 	* Initialize the pool from the latest "num" blocks.
1236 	*/
1237 	function initLatest(uint256 num, uint256 seed) internal view returns (bytes32[] memory) {
1238 		return init(block.number-num, block.number-1, seed);
1239 	}
1240 	
1241 	/**
1242 	* Advances to the next 256-bit random number in the pool of hash chains.
1243 	*/
1244 	function next(bytes32[] memory pool) internal pure returns (uint256) {
1245 		require(pool.length > 1, "RandomSalt.next: invalid pool");
1246 		uint256 roundRobinIdx = uint256(pool[0]) % (pool.length-1) + 1;
1247 		bytes32 hash = keccak256(abi.encodePacked(pool[roundRobinIdx]));
1248 		pool[0] = bytes32(uint256(pool[0])+1);
1249 		pool[roundRobinIdx] = hash;
1250 		return uint256(hash);
1251 	}
1252 	
1253 	/**
1254 	* Produces random integer values, uniformly distributed on the closed interval [a, b]
1255 	*/
1256 	function uniform(bytes32[] memory pool, int256 a, int256 b) internal pure returns (int256) {
1257 		require(a <= b, "RandomSalt.uniform: invalid interval");
1258 		return int256(next(pool)%uint256(b-a+1))+a;
1259 	}
1260 }
1261 
1262 library Random {
1263     /**
1264     * Initialize the pool from some seed.
1265     */
1266     function init(uint256 seed) internal pure returns (bytes32[] memory) {
1267         bytes32[] memory hashchain = new bytes32[](1);
1268         hashchain[0] = bytes32(seed);
1269         return hashchain;
1270     }
1271     
1272     /**
1273     * Advances to the next 256-bit random number in the pool of hash chains.
1274     */
1275     function next(bytes32[] memory hashchain) internal pure returns (uint256) {
1276         require(hashchain.length == 1, "Random.next: invalid param");
1277         hashchain[0] = keccak256(abi.encodePacked(hashchain[0]));
1278         return uint256(hashchain[0]);
1279     }
1280     
1281     /**
1282     * Produces random integer values, uniformly distributed on the closed interval [a, b]
1283     */
1284     function uniform_int(bytes32[] memory hashchain, int256 a, int256 b) internal pure returns (int256) {
1285         require(a <= b, "Random.uniform_int: invalid interval");
1286         return int256(next(hashchain)%uint256(b-a+1))+a;
1287     }
1288     
1289     /**
1290     * Produces random integer values, uniformly distributed on the closed interval [a, b]
1291     */
1292     function uniform_uint(bytes32[] memory hashchain, uint256 a, uint256 b) internal pure returns (uint256) {
1293         require(a <= b, "Random.uniform_uint: invalid interval");
1294         return next(hashchain)%(b-a+1)+a;
1295     }
1296 }
1297  
1298 library Buffer {
1299     function hasCapacityFor(bytes memory buffer, uint256 needed) internal pure returns (bool) {
1300         uint256 size;
1301         uint256 used;
1302         assembly {
1303             size := mload(buffer)
1304             used := mload(add(buffer, 32))
1305         }
1306         return size >= 32 && used <= size - 32 && used + needed <= size - 32;
1307     }
1308     
1309     function toString(bytes memory buffer) internal pure returns (string memory) {
1310         require(hasCapacityFor(buffer, 0), "Buffer.toString: invalid buffer");
1311         string memory ret;
1312         assembly {
1313             ret := add(buffer, 32)
1314         }
1315         return ret;
1316     }
1317     
1318     function append(bytes memory buffer, string memory str) internal view {
1319         require(hasCapacityFor(buffer, bytes(str).length), "Buffer.append: no capacity");
1320         assembly {
1321             let len := mload(add(buffer, 32))
1322             pop(staticcall(gas, 0x4, add(str, 32), mload(str), add(len, add(buffer, 64)), mload(str)))
1323             mstore(add(buffer, 32), add(len, mload(str)))
1324         }
1325     }
1326     
1327     /**
1328      * value must be in the closed interval [-999, 999]
1329      * otherwise only the last 3 digits will be converted
1330      */
1331     function numbie(bytes memory buffer, int256 value) internal pure {
1332         require(hasCapacityFor(buffer, 4), "Buffer.numbie: no capacity");
1333         assembly {
1334             function numbx1(x, v) -> y {
1335                 // v must be in the closed interval [0, 9]
1336                 // otherwise it outputs junk
1337                 mstore8(x, add(v, 48))
1338                 y := add(x, 1)
1339             }
1340             function numbx2(x, v) -> y {
1341                 // v must be in the closed interval [0, 99]
1342                 // otherwise it outputs junk
1343                 y := numbx1(numbx1(x, div(v, 10)), mod(v, 10))
1344             }
1345             function numbu3(x, v) -> y {
1346                 // v must be in the closed interval [0, 999]
1347                 // otherwise only the last 3 digits will be converted
1348                 switch lt(v, 100)
1349                 case 0 {
1350                     // without input value sanitation: y := numbx2(numbx1(x, div(v, 100)), mod(v, 100))
1351                     y := numbx2(numbx1(x, mod(div(v, 100), 10)), mod(v, 100))
1352                 }
1353                 default {
1354                     switch lt(v, 10)
1355                     case 0 { y := numbx2(x, v) }
1356                     default { y := numbx1(x, v) }
1357                 }
1358             }
1359             function numbi3(x, v) -> y {
1360                 // v must be in the closed interval [-999, 999]
1361                 // otherwise only the last 3 digits will be converted
1362                 if slt(v, 0) {
1363                     v := add(not(v), 1)
1364                     mstore8(x, 45)  // minus sign
1365                     x := add(x, 1)
1366                 }
1367                 y := numbu3(x, v)
1368             }
1369             let strIdx := add(mload(add(buffer, 32)), add(buffer, 64))
1370             strIdx := numbi3(strIdx, value)
1371             mstore(add(buffer, 32), sub(sub(strIdx, buffer), 64))
1372         }
1373     }
1374     
1375     function hexrgb(bytes memory buffer, uint256 r, uint256 g, uint256 b) internal pure {
1376         require(hasCapacityFor(buffer, 6), "Buffer.hexrgb: no capacity");
1377         assembly {
1378             function hexrgb(x, r, g, b) -> y {
1379                 let rhi := and(shr(4, r), 0xf)
1380                 let rlo := and(r, 0xf)
1381                 let ghi := and(shr(4, g), 0xf)
1382                 let glo := and(g, 0xf)
1383                 let bhi := and(shr(4, b), 0xf)
1384                 let blo := and(b, 0xf)
1385                 mstore8(x,         add(add(rhi, mul(div(rhi, 10), 39)), 48))
1386                 mstore8(add(x, 1), add(add(rlo, mul(div(rlo, 10), 39)), 48))
1387                 mstore8(add(x, 2), add(add(ghi, mul(div(ghi, 10), 39)), 48))
1388                 mstore8(add(x, 3), add(add(glo, mul(div(glo, 10), 39)), 48))
1389                 mstore8(add(x, 4), add(add(bhi, mul(div(bhi, 10), 39)), 48))
1390                 mstore8(add(x, 5), add(add(blo, mul(div(blo, 10), 39)), 48))
1391                 y := add(x, 6)
1392             }
1393             let strIdx := add(mload(add(buffer, 32)), add(buffer, 64))
1394             strIdx := hexrgb(strIdx, r, g, b)
1395             mstore(add(buffer, 32), sub(sub(strIdx, buffer), 64))
1396         }
1397     }
1398 }
1399  
1400 contract squigglyWTF is ERC721Full, Ownable, ReentrancyGuard {
1401     using SafeMath for uint256;    
1402     using Roles for Roles.Role;
1403 
1404     Roles.Role private _auctioneers;
1405     
1406     uint8 public totalPromoClaimants;
1407 
1408     mapping(uint256 => address) internal promoClaimantStorage;
1409     mapping(address => uint256) addressToInkAll;
1410     mapping(uint8 => address) inkToAddress;
1411     mapping(uint256 => address) idToCreator;
1412     mapping(uint256 => uint256) idToSVGSeed;
1413     mapping(uint256 => string) idToPromoSVG;
1414 
1415     string public squigglyGalleryLink;
1416     string public referenceURI;
1417     
1418     uint8 public totalInk;
1419     uint8 public constant maximumInk = 100;
1420     uint8 public constant tokenLimit = 99;
1421     uint256 public priceOfInk;
1422     bool public auctionIsLive;
1423     bool public priceGoUp;
1424     bool public priceGoDown;
1425     bool public auctionStarted;
1426     uint256 public blockTimeCounter;
1427 
1428     constructor() ERC721Full("Squiggly", "~~") public {
1429 
1430     auctionStarted = false;
1431     auctionIsLive = false;
1432     priceGoUp = false;
1433     priceGoDown = false;
1434     totalPromoClaimants = 0;
1435     priceOfInk = 20000000000000000;
1436     referenceURI = "https://squigglywtf.azurewebsites.net/api/HttpTrigger?id=";
1437     _auctioneers.add(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3);
1438     
1439     }    
1440     
1441     function getNumber(uint seed, int min, int max) internal view returns (int256 randomNumber){
1442 
1443     bytes32[] memory pool = RandomSalt.initLatest(1, seed);        
1444 		randomNumber = RandomSalt.uniform(pool, min, max); 
1445     }
1446     
1447     function renderFromSeed(uint256 seed) public view returns (string memory) {
1448         bytes32[] memory hashchain = Random.init(seed);
1449         
1450         bytes memory buffer = new bytes(8192);
1451         
1452         uint256 curveType = Random.uniform_uint(hashchain,1,5);
1453         uint8 squiggleCount = uint8(curveType) + 2;
1454         uint stopColorBW;
1455         
1456         Buffer.append(buffer, "<svg xmlns='http://www.w3.org/2000/svg' width='640' height='640' viewBox='0 0 640 640' style='stroke-width:0; background-color:#121212;'>");
1457         
1458         // Draw squiggles. Each squiggle is a pair of <radialGradient> and <path>.
1459         for(int i=0; i<squiggleCount; i++) {
1460         
1461             // append the <radialGradient>
1462             
1463             Buffer.append(buffer, "<radialGradient id='grad");
1464             Buffer.numbie(buffer, i);
1465             Buffer.append(buffer, "'><stop offset='0%' style='stop-color:#");
1466             // gradient start color:
1467             Buffer.hexrgb(buffer, Random.uniform_uint(hashchain,16,255), Random.uniform_uint(hashchain,16,255), Random.uniform_uint(hashchain,16,255));
1468             
1469             Buffer.append(buffer, ";stop-opacity:0' /><stop offset='100%' style='stop-color:#");
1470             // gradient stop color:
1471             stopColorBW = Random.uniform_uint(hashchain,16,255);
1472             Buffer.hexrgb(buffer, stopColorBW, stopColorBW, stopColorBW);
1473             Buffer.append(buffer, ";stop-opacity:1' /></radialGradient>");
1474             
1475             // append the <path>
1476             
1477             Buffer.append(buffer, "<path fill='url(#grad");
1478             Buffer.numbie(buffer, i);
1479             Buffer.append(buffer, ")' stroke='#");
1480             // path stroke color:
1481             Buffer.hexrgb(buffer, Random.uniform_uint(hashchain,16,255), Random.uniform_uint(hashchain,16,255), Random.uniform_uint(hashchain,16,255));
1482             Buffer.append(buffer, "' stroke-width='0' d='m ");
1483             // path command 'm': Move the current point by shifting the last known position of the path by dx along the x-axis and by dy along the y-axis.
1484             Buffer.numbie(buffer, Random.uniform_int(hashchain,240,400));  // move dx
1485             Buffer.append(buffer, " ");
1486             Buffer.numbie(buffer, Random.uniform_int(hashchain,240,400));  // move dy
1487             
1488             if(curveType == 1) {
1489                 Buffer.append(buffer, ' c');
1490                 
1491                 for(int j=0; j<77; j++) {
1492                     // path command 'c': Draw a cubic Bézier curve.
1493                     Buffer.append(buffer, " ");
1494                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dx1
1495                     Buffer.append(buffer, " ");
1496                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dy1
1497                     Buffer.append(buffer, " ");
1498                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dx2
1499                     Buffer.append(buffer, " ");
1500                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dy2
1501                     Buffer.append(buffer, " ");
1502                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dx
1503                     Buffer.append(buffer, " ");
1504                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-77,77));  // curve dy
1505                 }
1506                 
1507             } else if(curveType == 2) {
1508                 Buffer.append(buffer, " s");
1509                 
1510                 for(int j=0; j<91; j++) {
1511                     // path command 's': Draw a smooth cubic Bézier curve.
1512                     Buffer.append(buffer, " ");
1513                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-69,69));  // curve dx2
1514                     Buffer.append(buffer, " ");
1515                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-69,69));  // curve dy2
1516                     Buffer.append(buffer, " ");
1517                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-69,69));  // curve dx
1518                     Buffer.append(buffer, " ");
1519                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-69,69));  // curve dy
1520                 }
1521                 
1522             } else if(curveType == 3) {
1523                 Buffer.append(buffer, ' q');
1524                 
1525                 for(int j=0; j<77; j++) {
1526                     // path command 'q': Draw a quadratic Bézier curve.
1527                     Buffer.append(buffer, " ");
1528                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-47,47));  // curve dx1
1529                     Buffer.append(buffer, " ");
1530                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-47,47));  // curve dy1
1531                     Buffer.append(buffer, " ");
1532                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-47,47));  // curve dx
1533                     Buffer.append(buffer, " ");
1534                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-47,47));  // curve dy
1535                 }
1536                 
1537             } else if(curveType == 4) {
1538                 Buffer.append(buffer, ' t');
1539                 
1540                 for(int j=0; j<123; j++) {
1541                     // path command 't': Draw a smooth quadratic Bézier curve.
1542                     Buffer.append(buffer, " ");
1543                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-29,29));  // curve dx
1544                     Buffer.append(buffer, " ");
1545                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-29,29));  // curve dy
1546                 }
1547                 
1548             } else if(curveType == 5) {
1549                 
1550                 for(int j=0; j<99; j++) {
1551                     // no path command: No curve.
1552                     Buffer.append(buffer, " ");
1553                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-37,37));  // point dx
1554                     Buffer.append(buffer, " ");
1555                     Buffer.numbie(buffer, Random.uniform_int(hashchain,-37,37));  // point dy
1556                 }
1557                 
1558             }
1559             
1560             Buffer.append(buffer, "' />");
1561             
1562         }
1563         
1564         Buffer.append(buffer, "</svg>");
1565         
1566         return Buffer.toString(buffer);
1567     }
1568 
1569     function ribbonCut() public onlyOwner {
1570         auctionStarted = true;
1571     }    
1572 
1573     function startAuction() public nonReentrant {
1574         require(auctionStarted == true);
1575         require(auctionIsLive == false);
1576         require(totalSupply() <= tokenLimit, "Squiggly sale has concluded. Good luck prying one out of the hands of someone on the secondary market.");
1577         priceOfInk = calculateInkValue();
1578         blockTimeCounter = block.timestamp + 15000;
1579         auctionIsLive = true;
1580         
1581         inkToAddress[0] = msg.sender;
1582         inkToAddress[1] = msg.sender;
1583         addressToInkAll[msg.sender] = addressToInkAll[msg.sender] + 2;
1584         
1585         totalInk = 2;
1586     }
1587     
1588     function participateInAuction(uint8 ink) public nonReentrant payable {
1589         require(ink <= maximumInk - totalInk);
1590         require(msg.value >= ink * priceOfInk);
1591         require(auctionIsLive == true);
1592         require(block.timestamp < blockTimeCounter);
1593 
1594         for(uint8 i=totalInk; i < totalInk + ink; i++){
1595             inkToAddress[i] = msg.sender;
1596         }
1597         
1598         totalInk = totalInk + ink;
1599         
1600         addressToInkAll[msg.sender] = addressToInkAll[msg.sender] + ink;
1601 
1602         uint256 totalSquigglies = totalSupply();
1603  
1604         address(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3).transfer(msg.value/100*65);
1605         address payable luckyBastard = address(uint160(getLuckyBastard(totalSquigglies)));
1606         luckyBastard.transfer(msg.value/10);
1607 
1608     }
1609     
1610     function calculateInkValue() public view returns (uint256 priceOfInkCalc) {
1611         if (auctionIsLive == false) {
1612             if (priceGoUp == true) {
1613                 priceOfInkCalc = priceOfInk*101/100;
1614             }
1615             else if (priceGoDown == true) {
1616                 priceOfInkCalc = priceOfInk*99/100;
1617             }
1618             else {
1619                 priceOfInkCalc = priceOfInk;
1620             }
1621         }
1622         else {
1623         priceOfInkCalc = priceOfInk;    
1624         }
1625     }
1626     
1627     function createSVG() private nonReentrant {
1628         
1629         require(totalSupply() <= tokenLimit, "Claimed. Sorry.");
1630         
1631         uint256 tokenId = totalSupply();
1632         
1633         int luckyCollectorID = getNumber(totalSupply(),0,totalInk - 1);
1634         address luckyCollectorAddress = inkToAddress[uint8(luckyCollectorID)];
1635         uint256 seedSVG = uint256(getNumber(1,1,99999999));
1636         
1637         idToSVGSeed[tokenId] = seedSVG;
1638         idToCreator[tokenId] = msg.sender;
1639         
1640         _mint(luckyCollectorAddress, tokenId);
1641         
1642     }
1643     
1644     function createPromo(string memory promoSVG) public onlyOwner {
1645         require(totalSupply() <= 4);
1646         
1647         uint256 tokenId = totalSupply();
1648         
1649         idToPromoSVG[tokenId] = promoSVG;
1650         idToCreator[tokenId] = msg.sender;
1651         addressToInkAll[msg.sender] = addressToInkAll[msg.sender] + 100;
1652         
1653         _mint(msg.sender, tokenId);
1654     }
1655     
1656     function endAuction() public {
1657         
1658         if (totalSupply() <= 19) {
1659         require(block.timestamp >= blockTimeCounter || totalInk == 100);    
1660         }
1661         else {
1662         require(block.timestamp >= blockTimeCounter);            
1663         }
1664 
1665         require(_auctioneers.has(msg.sender), "Only official Auctioneers can end an auction.");
1666         
1667         createSVG();
1668         auctionIsLive = false;
1669 
1670         for(uint8 i=0; i < 100; i++){
1671             inkToAddress[i] = 0x0000000000000000000000000000000000000000;
1672         }
1673                 
1674         if (totalInk > 80) {
1675             priceGoUp = true;
1676             priceGoDown = false;
1677         }
1678         else if (totalInk < 60) {
1679             priceGoDown = true;
1680             priceGoUp = false;
1681         }
1682         else {
1683             priceGoUp = false;
1684             priceGoDown = false;
1685         }
1686         
1687         totalInk = 0;
1688         
1689         uint256 contractBalance = uint256(address(this).balance);
1690         uint256 promoRewards = contractBalance/5*2;
1691         uint256 endAuctionBounty = contractBalance/5*3;
1692         
1693     for (uint8 i = 0; i < totalPromoClaimants; i++) {
1694         address payable promoTransferAddress = address(uint160(promoClaimantStorage[i]));
1695         promoTransferAddress.transfer(promoRewards/totalPromoClaimants);
1696         }
1697         
1698         address(msg.sender).transfer(endAuctionBounty);    
1699     }    
1700     
1701     function getLuckyBastard(uint256 seed) public view returns (address luckyBastardWinner) {
1702         uint8 squigglyID = uint8(getNumber(seed, 0, int256(seed - 1)));
1703         luckyBastardWinner = (ownerOf(squigglyID));
1704     }
1705 
1706     
1707     function updateGalleryLink(string memory newURL) public onlyOwner {
1708         squigglyGalleryLink = newURL;
1709     }
1710 
1711     function addPromoClaimant(address newPromoClaimant, uint8 newPromoSlot) public onlyOwner {
1712         require(totalPromoClaimants <= 16);
1713         require(newPromoSlot <= 15);
1714 
1715         if (promoClaimantStorage[newPromoSlot] == address(0x0000000000000000000000000000000000000000)) {
1716         totalPromoClaimants = totalPromoClaimants + 1;    
1717         }
1718         
1719         promoClaimantStorage[newPromoSlot] = newPromoClaimant;
1720     }
1721     
1722     function addAuctioneer(address newAuctioneer) public onlyOwner {
1723         _auctioneers.add(newAuctioneer);
1724     }
1725     
1726     function removeAuctioneer(address newAuctioneer) public onlyOwner {
1727         _auctioneers.remove(newAuctioneer);
1728     }
1729 
1730     function integerToString(uint _i) internal pure returns (string memory) {
1731       if (_i == 0) {
1732          return "0";
1733       }
1734       uint j = _i;
1735       uint len;
1736       
1737       while (j != 0) {
1738          len++;
1739          j /= 10;
1740       }
1741       bytes memory bstr = new bytes(len);
1742       uint k = len - 1;
1743       
1744       while (_i != 0) {
1745          bstr[k--] = byte(uint8(48 + _i % 10));
1746          _i /= 10;
1747       }
1748       return string(bstr);
1749    }
1750 
1751     function tokenURI(uint256 id) external view returns (string memory) {
1752         require(_exists(id), "ERC721Metadata: URI query for nonexistent token");
1753         return string(abi.encodePacked(referenceURI, integerToString(uint256(id))));
1754     }
1755     
1756     function getAddressToInkAll(address userAddress) public view returns (uint256 allTimeInk) {
1757         return addressToInkAll[userAddress];
1758     }
1759     
1760     function getAddressToInk(address userAddress) public view returns (uint8 currentInkCount) {
1761         for(uint8 i=0; i < 100; i++){
1762             if(inkToAddress[i] == userAddress) {
1763                 currentInkCount = currentInkCount + 1;
1764             }  
1765         }
1766     }
1767     
1768     function getInktoAddress(uint8 ink) public view returns (address userAddress) {
1769         return inkToAddress[ink];
1770     }
1771     
1772     function getIdToSVG(uint8 tokenId) public view returns (string memory squigglySVG) {
1773         if(tokenId <= 4){
1774         squigglySVG = idToPromoSVG[tokenId];
1775         }
1776         else {
1777         squigglySVG = renderFromSeed(idToSVGSeed[tokenId]);
1778         }
1779     }
1780     
1781     function getIdToCurveType(uint8 tokenId) public view returns (uint256 curveType) {
1782         bytes32[] memory hashchain = Random.init(idToSVGSeed[tokenId]);
1783         
1784         if(tokenId == 0){
1785         curveType = 4;
1786         }
1787         else if(tokenId == 1) {
1788         curveType = 1;    
1789         }
1790         else if(tokenId == 2) {
1791         curveType = 5;    
1792         }
1793         else if(tokenId == 3) {
1794         curveType = 2;    
1795         }
1796         else if(tokenId == 4) {
1797         curveType = 3;    
1798         }
1799         else {
1800         curveType = Random.uniform_uint(hashchain,1,5);
1801         }
1802     }
1803     
1804     function getIdToCreator(uint8 tokenId) public view returns (address userAddress) {
1805         return idToCreator[tokenId];
1806     }
1807     
1808     function updateURI(string memory newURI) public onlyOwner {
1809         referenceURI = newURI;
1810     }
1811     function readStats() public view returns (string memory auctionStatus, uint8 inkRemaining, uint256 artRemaining, int256 secondsRemaining) {
1812 
1813         artRemaining = 100 - totalSupply();
1814         inkRemaining = maximumInk - totalInk;
1815         secondsRemaining = int256(blockTimeCounter - block.timestamp);
1816         
1817         if (secondsRemaining > 0 && inkRemaining > 0) {
1818             secondsRemaining = secondsRemaining;
1819         }
1820         else if (secondsRemaining > 0 && totalSupply() > 19) {
1821             secondsRemaining = secondsRemaining;
1822         }
1823         else {
1824             secondsRemaining = 0;
1825         }
1826 
1827         if (artRemaining == 0) {
1828             auctionStatus = string('Art sale is over.');
1829         }
1830         else if (auctionIsLive == false) {
1831             auctionStatus = string(abi.encodePacked('Auction is not active. Next token is: ', integerToString(100 - artRemaining)));
1832         }
1833         else if (secondsRemaining <= 0) {
1834             auctionStatus = string('Waiting on Auctioneer to call End Auction.');
1835         }
1836         else {
1837             auctionStatus = string(abi.encodePacked('Auction for token #', integerToString(100 - artRemaining) ,' is live.'));
1838         }
1839         
1840     }    
1841     
1842 }