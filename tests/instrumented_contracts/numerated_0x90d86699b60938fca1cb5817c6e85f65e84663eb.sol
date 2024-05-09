1 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: node_modules\@openzeppelin\contracts\math\Math.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Standard math utilities missing in the Solidity language.
166  */
167 library Math {
168     /**
169      * @dev Returns the largest of two numbers.
170      */
171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a >= b ? a : b;
173     }
174 
175     /**
176      * @dev Returns the smallest of two numbers.
177      */
178     function min(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a < b ? a : b;
180     }
181 
182     /**
183      * @dev Returns the average of two numbers. The result is rounded towards
184      * zero.
185      */
186     function average(uint256 a, uint256 b) internal pure returns (uint256) {
187         // (a + b) / 2 can overflow, so we distribute
188         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
189     }
190 }
191 
192 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: node_modules\@openzeppelin\contracts\ownership\Ownable.sol
223 
224 pragma solidity ^0.5.0;
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () internal {
244         _owner = _msgSender();
245         emit OwnershipTransferred(address(0), _owner);
246     }
247 
248     /**
249      * @dev Returns the address of the current owner.
250      */
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         require(isOwner(), "Ownable: caller is not the owner");
260         _;
261     }
262 
263     /**
264      * @dev Returns true if the caller is the current owner.
265      */
266     function isOwner() public view returns (bool) {
267         return _msgSender() == _owner;
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() public onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Can only be called by the current owner.
285      */
286     function transferOwnership(address newOwner) public onlyOwner {
287         _transferOwnership(newOwner);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      */
293     function _transferOwnership(address newOwner) internal {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
301 
302 pragma solidity ^0.5.0;
303 
304 /**
305  * @dev Interface of the ERC165 standard, as defined in the
306  * https://eips.ethereum.org/EIPS/eip-165[EIP].
307  *
308  * Implementers can declare support of contract interfaces, which can then be
309  * queried by others ({ERC165Checker}).
310  *
311  * For an implementation, see {ERC165}.
312  */
313 interface IERC165 {
314     /**
315      * @dev Returns true if this contract implements the interface defined by
316      * `interfaceId`. See the corresponding
317      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
318      * to learn more about how these ids are created.
319      *
320      * This function call must use less than 30 000 gas.
321      */
322     function supportsInterface(bytes4 interfaceId) external view returns (bool);
323 }
324 
325 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
326 
327 pragma solidity ^0.5.0;
328 
329 
330 /**
331  * @dev Required interface of an ERC721 compliant contract.
332  */
333 contract IERC721 is IERC165 {
334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
337 
338     /**
339      * @dev Returns the number of NFTs in `owner`'s account.
340      */
341     function balanceOf(address owner) public view returns (uint256 balance);
342 
343     /**
344      * @dev Returns the owner of the NFT specified by `tokenId`.
345      */
346     function ownerOf(uint256 tokenId) public view returns (address owner);
347 
348     /**
349      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
350      * another (`to`).
351      *
352      *
353      *
354      * Requirements:
355      * - `from`, `to` cannot be zero.
356      * - `tokenId` must be owned by `from`.
357      * - If the caller is not `from`, it must be have been allowed to move this
358      * NFT by either {approve} or {setApprovalForAll}.
359      */
360     function safeTransferFrom(address from, address to, uint256 tokenId) public;
361     /**
362      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
363      * another (`to`).
364      *
365      * Requirements:
366      * - If the caller is not `from`, it must be approved to move this NFT by
367      * either {approve} or {setApprovalForAll}.
368      */
369     function transferFrom(address from, address to, uint256 tokenId) public;
370     function approve(address to, uint256 tokenId) public;
371     function getApproved(uint256 tokenId) public view returns (address operator);
372 
373     function setApprovalForAll(address operator, bool _approved) public;
374     function isApprovedForAll(address owner, address operator) public view returns (bool);
375 
376 
377     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
378 }
379 
380 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
381 
382 pragma solidity ^0.5.0;
383 
384 /**
385  * @title ERC721 token receiver interface
386  * @dev Interface for any contract that wants to support safeTransfers
387  * from ERC721 asset contracts.
388  */
389 contract IERC721Receiver {
390     /**
391      * @notice Handle the receipt of an NFT
392      * @dev The ERC721 smart contract calls this function on the recipient
393      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
394      * otherwise the caller will revert the transaction. The selector to be
395      * returned can be obtained as `this.onERC721Received.selector`. This
396      * function MAY throw to revert and reject the transfer.
397      * Note: the ERC721 contract address is always the message sender.
398      * @param operator The address which called `safeTransferFrom` function
399      * @param from The address which previously owned the token
400      * @param tokenId The NFT identifier which is being transferred
401      * @param data Additional data with no specified format
402      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
403      */
404     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
405     public returns (bytes4);
406 }
407 
408 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
409 
410 pragma solidity ^0.5.5;
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * This test is non-exhaustive, and there may be false-negatives: during the
420      * execution of a contract's constructor, its address will be reported as
421      * not containing a contract.
422      *
423      * IMPORTANT: It is unsafe to assume that an address for which this
424      * function returns false is an externally-owned account (EOA) and not a
425      * contract.
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies in extcodesize, which returns 0 for contracts in
429         // construction, since the code is only stored at the end of the
430         // constructor execution.
431 
432         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
433         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
434         // for accounts without code, i.e. `keccak256('')`
435         bytes32 codehash;
436         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
437         // solhint-disable-next-line no-inline-assembly
438         assembly { codehash := extcodehash(account) }
439         return (codehash != 0x0 && codehash != accountHash);
440     }
441 
442     /**
443      * @dev Converts an `address` into `address payable`. Note that this is
444      * simply a type cast: the actual underlying value is not changed.
445      *
446      * _Available since v2.4.0._
447      */
448     function toPayable(address account) internal pure returns (address payable) {
449         return address(uint160(account));
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      *
468      * _Available since v2.4.0._
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         // solhint-disable-next-line avoid-call-value
474         (bool success, ) = recipient.call.value(amount)("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 }
478 
479 // File: node_modules\@openzeppelin\contracts\drafts\Counters.sol
480 
481 pragma solidity ^0.5.0;
482 
483 
484 /**
485  * @title Counters
486  * @author Matt Condon (@shrugs)
487  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
488  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
489  *
490  * Include with `using Counters for Counters.Counter;`
491  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
492  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
493  * directly accessed.
494  */
495 library Counters {
496     using SafeMath for uint256;
497 
498     struct Counter {
499         // This variable should never be directly accessed by users of the library: interactions must be restricted to
500         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
501         // this feature: see https://github.com/ethereum/solidity/issues/4637
502         uint256 _value; // default: 0
503     }
504 
505     function current(Counter storage counter) internal view returns (uint256) {
506         return counter._value;
507     }
508 
509     function increment(Counter storage counter) internal {
510         counter._value += 1;
511     }
512 
513     function decrement(Counter storage counter) internal {
514         counter._value = counter._value.sub(1);
515     }
516 }
517 
518 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
519 
520 pragma solidity ^0.5.0;
521 
522 
523 /**
524  * @dev Implementation of the {IERC165} interface.
525  *
526  * Contracts may inherit from this and call {_registerInterface} to declare
527  * their support of an interface.
528  */
529 contract ERC165 is IERC165 {
530     /*
531      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
532      */
533     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
534 
535     /**
536      * @dev Mapping of interface ids to whether or not it's supported.
537      */
538     mapping(bytes4 => bool) private _supportedInterfaces;
539 
540     constructor () internal {
541         // Derived contracts need only register support for their own interfaces,
542         // we register support for ERC165 itself here
543         _registerInterface(_INTERFACE_ID_ERC165);
544     }
545 
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      *
549      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
552         return _supportedInterfaces[interfaceId];
553     }
554 
555     /**
556      * @dev Registers the contract as an implementer of the interface defined by
557      * `interfaceId`. Support of the actual ERC165 interface is automatic and
558      * registering its interface id is not required.
559      *
560      * See {IERC165-supportsInterface}.
561      *
562      * Requirements:
563      *
564      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
565      */
566     function _registerInterface(bytes4 interfaceId) internal {
567         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
568         _supportedInterfaces[interfaceId] = true;
569     }
570 }
571 
572 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol
573 
574 pragma solidity ^0.5.0;
575 
576 
577 
578 
579 
580 
581 
582 
583 /**
584  * @title ERC721 Non-Fungible Token Standard basic implementation
585  * @dev see https://eips.ethereum.org/EIPS/eip-721
586  */
587 contract ERC721 is Context, ERC165, IERC721 {
588     using SafeMath for uint256;
589     using Address for address;
590     using Counters for Counters.Counter;
591 
592     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
593     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
594     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
595 
596     // Mapping from token ID to owner
597     mapping (uint256 => address) private _tokenOwner;
598 
599     // Mapping from token ID to approved address
600     mapping (uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to number of owned token
603     mapping (address => Counters.Counter) private _ownedTokensCount;
604 
605     // Mapping from owner to operator approvals
606     mapping (address => mapping (address => bool)) private _operatorApprovals;
607 
608     /*
609      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
610      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
611      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
612      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
613      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
614      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
615      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
616      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
617      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
618      *
619      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
620      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
621      */
622     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
623 
624     constructor () public {
625         // register the supported interfaces to conform to ERC721 via ERC165
626         _registerInterface(_INTERFACE_ID_ERC721);
627     }
628 
629     /**
630      * @dev Gets the balance of the specified address.
631      * @param owner address to query the balance of
632      * @return uint256 representing the amount owned by the passed address
633      */
634     function balanceOf(address owner) public view returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636 
637         return _ownedTokensCount[owner].current();
638     }
639 
640     /**
641      * @dev Gets the owner of the specified token ID.
642      * @param tokenId uint256 ID of the token to query the owner of
643      * @return address currently marked as the owner of the given token ID
644      */
645     function ownerOf(uint256 tokenId) public view returns (address) {
646         address owner = _tokenOwner[tokenId];
647         require(owner != address(0), "ERC721: owner query for nonexistent token");
648 
649         return owner;
650     }
651 
652     /**
653      * @dev Approves another address to transfer the given token ID
654      * The zero address indicates there is no approved address.
655      * There can only be one approved address per token at a given time.
656      * Can only be called by the token owner or an approved operator.
657      * @param to address to be approved for the given token ID
658      * @param tokenId uint256 ID of the token to be approved
659      */
660     function approve(address to, uint256 tokenId) public {
661         address owner = ownerOf(tokenId);
662         require(to != owner, "ERC721: approval to current owner");
663 
664         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
665             "ERC721: approve caller is not owner nor approved for all"
666         );
667 
668         _tokenApprovals[tokenId] = to;
669         emit Approval(owner, to, tokenId);
670     }
671 
672     /**
673      * @dev Gets the approved address for a token ID, or zero if no address set
674      * Reverts if the token ID does not exist.
675      * @param tokenId uint256 ID of the token to query the approval of
676      * @return address currently approved for the given token ID
677      */
678     function getApproved(uint256 tokenId) public view returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev Sets or unsets the approval of a given operator
686      * An operator is allowed to transfer all tokens of the sender on their behalf.
687      * @param to operator address to set the approval
688      * @param approved representing the status of the approval to be set
689      */
690     function setApprovalForAll(address to, bool approved) public {
691         require(to != _msgSender(), "ERC721: approve to caller");
692 
693         _operatorApprovals[_msgSender()][to] = approved;
694         emit ApprovalForAll(_msgSender(), to, approved);
695     }
696 
697     /**
698      * @dev Tells whether an operator is approved by a given owner.
699      * @param owner owner address which you want to query the approval of
700      * @param operator operator address which you want to query the approval of
701      * @return bool whether the given operator is approved by the given owner
702      */
703     function isApprovedForAll(address owner, address operator) public view returns (bool) {
704         return _operatorApprovals[owner][operator];
705     }
706 
707     /**
708      * @dev Transfers the ownership of a given token ID to another address.
709      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
710      * Requires the msg.sender to be the owner, approved, or operator.
711      * @param from current owner of the token
712      * @param to address to receive the ownership of the given token ID
713      * @param tokenId uint256 ID of the token to be transferred
714      */
715     function transferFrom(address from, address to, uint256 tokenId) public {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transferFrom(from, to, tokenId);
720     }
721 
722     /**
723      * @dev Safely transfers the ownership of a given token ID to another address
724      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
725      * which is called upon a safe transfer, and return the magic value
726      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
727      * the transfer is reverted.
728      * Requires the msg.sender to be the owner, approved, or operator
729      * @param from current owner of the token
730      * @param to address to receive the ownership of the given token ID
731      * @param tokenId uint256 ID of the token to be transferred
732      */
733     function safeTransferFrom(address from, address to, uint256 tokenId) public {
734         safeTransferFrom(from, to, tokenId, "");
735     }
736 
737     /**
738      * @dev Safely transfers the ownership of a given token ID to another address
739      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
740      * which is called upon a safe transfer, and return the magic value
741      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
742      * the transfer is reverted.
743      * Requires the _msgSender() to be the owner, approved, or operator
744      * @param from current owner of the token
745      * @param to address to receive the ownership of the given token ID
746      * @param tokenId uint256 ID of the token to be transferred
747      * @param _data bytes data to send along with a safe transfer check
748      */
749     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransferFrom(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers the ownership of a given token ID to another address
756      * If the target address is a contract, it must implement `onERC721Received`,
757      * which is called upon a safe transfer, and return the magic value
758      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
759      * the transfer is reverted.
760      * Requires the msg.sender to be the owner, approved, or operator
761      * @param from current owner of the token
762      * @param to address to receive the ownership of the given token ID
763      * @param tokenId uint256 ID of the token to be transferred
764      * @param _data bytes data to send along with a safe transfer check
765      */
766     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
767         _transferFrom(from, to, tokenId);
768         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
769     }
770 
771     /**
772      * @dev Returns whether the specified token exists.
773      * @param tokenId uint256 ID of the token to query the existence of
774      * @return bool whether the token exists
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         address owner = _tokenOwner[tokenId];
778         return owner != address(0);
779     }
780 
781     /**
782      * @dev Returns whether the given spender can transfer a given token ID.
783      * @param spender address of the spender to query
784      * @param tokenId uint256 ID of the token to be transferred
785      * @return bool whether the msg.sender is approved for the given token ID,
786      * is an operator of the owner, or is the owner of the token
787      */
788     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
789         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
790         address owner = ownerOf(tokenId);
791         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
792     }
793 
794     /**
795      * @dev Internal function to safely mint a new token.
796      * Reverts if the given token ID already exists.
797      * If the target address is a contract, it must implement `onERC721Received`,
798      * which is called upon a safe transfer, and return the magic value
799      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
800      * the transfer is reverted.
801      * @param to The address that will own the minted token
802      * @param tokenId uint256 ID of the token to be minted
803      */
804     function _safeMint(address to, uint256 tokenId) internal {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Internal function to safely mint a new token.
810      * Reverts if the given token ID already exists.
811      * If the target address is a contract, it must implement `onERC721Received`,
812      * which is called upon a safe transfer, and return the magic value
813      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
814      * the transfer is reverted.
815      * @param to The address that will own the minted token
816      * @param tokenId uint256 ID of the token to be minted
817      * @param _data bytes data to send along with a safe transfer check
818      */
819     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
820         _mint(to, tokenId);
821         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
822     }
823 
824     /**
825      * @dev Internal function to mint a new token.
826      * Reverts if the given token ID already exists.
827      * @param to The address that will own the minted token
828      * @param tokenId uint256 ID of the token to be minted
829      */
830     function _mint(address to, uint256 tokenId) internal {
831         require(to != address(0), "ERC721: mint to the zero address");
832         require(!_exists(tokenId), "ERC721: token already minted");
833 
834         _tokenOwner[tokenId] = to;
835         _ownedTokensCount[to].increment();
836 
837         emit Transfer(address(0), to, tokenId);
838     }
839 
840     /**
841      * @dev Internal function to burn a specific token.
842      * Reverts if the token does not exist.
843      * Deprecated, use {_burn} instead.
844      * @param owner owner of the token to burn
845      * @param tokenId uint256 ID of the token being burned
846      */
847     function _burn(address owner, uint256 tokenId) internal {
848         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
849 
850         _clearApproval(tokenId);
851 
852         _ownedTokensCount[owner].decrement();
853         _tokenOwner[tokenId] = address(0);
854 
855         emit Transfer(owner, address(0), tokenId);
856     }
857 
858     /**
859      * @dev Internal function to burn a specific token.
860      * Reverts if the token does not exist.
861      * @param tokenId uint256 ID of the token being burned
862      */
863     function _burn(uint256 tokenId) internal {
864         _burn(ownerOf(tokenId), tokenId);
865     }
866 
867     /**
868      * @dev Internal function to transfer ownership of a given token ID to another address.
869      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
870      * @param from current owner of the token
871      * @param to address to receive the ownership of the given token ID
872      * @param tokenId uint256 ID of the token to be transferred
873      */
874     function _transferFrom(address from, address to, uint256 tokenId) internal {
875         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
876         require(to != address(0), "ERC721: transfer to the zero address");
877 
878         _clearApproval(tokenId);
879 
880         _ownedTokensCount[from].decrement();
881         _ownedTokensCount[to].increment();
882 
883         _tokenOwner[tokenId] = to;
884 
885         emit Transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * This function is deprecated.
893      * @param from address representing the previous owner of the given token ID
894      * @param to target address that will receive the tokens
895      * @param tokenId uint256 ID of the token to be transferred
896      * @param _data bytes optional data to send along with the call
897      * @return bool whether the call correctly returned the expected magic value
898      */
899     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
900         internal returns (bool)
901     {
902         if (!to.isContract()) {
903             return true;
904         }
905 
906         bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
907         return (retval == _ERC721_RECEIVED);
908     }
909 
910     /**
911      * @dev Private function to clear current approval of a given token ID.
912      * @param tokenId uint256 ID of the token to be transferred
913      */
914     function _clearApproval(uint256 tokenId) private {
915         if (_tokenApprovals[tokenId] != address(0)) {
916             _tokenApprovals[tokenId] = address(0);
917         }
918     }
919 }
920 
921 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Enumerable.sol
922 
923 pragma solidity ^0.5.0;
924 
925 
926 /**
927  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
928  * @dev See https://eips.ethereum.org/EIPS/eip-721
929  */
930 contract IERC721Enumerable is IERC721 {
931     function totalSupply() public view returns (uint256);
932     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
933 
934     function tokenByIndex(uint256 index) public view returns (uint256);
935 }
936 
937 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721Enumerable.sol
938 
939 pragma solidity ^0.5.0;
940 
941 
942 
943 
944 
945 /**
946  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
947  * @dev See https://eips.ethereum.org/EIPS/eip-721
948  */
949 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
950     // Mapping from owner to list of owned token IDs
951     mapping(address => uint256[]) private _ownedTokens;
952 
953     // Mapping from token ID to index of the owner tokens list
954     mapping(uint256 => uint256) private _ownedTokensIndex;
955 
956     // Array with all token ids, used for enumeration
957     uint256[] private _allTokens;
958 
959     // Mapping from token id to position in the allTokens array
960     mapping(uint256 => uint256) private _allTokensIndex;
961 
962     /*
963      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
964      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
965      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
966      *
967      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
968      */
969     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
970 
971     /**
972      * @dev Constructor function.
973      */
974     constructor () public {
975         // register the supported interface to conform to ERC721Enumerable via ERC165
976         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
977     }
978 
979     /**
980      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
981      * @param owner address owning the tokens list to be accessed
982      * @param index uint256 representing the index to be accessed of the requested tokens list
983      * @return uint256 token ID at the given index of the tokens list owned by the requested address
984      */
985     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
986         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
987         return _ownedTokens[owner][index];
988     }
989 
990     /**
991      * @dev Gets the total amount of tokens stored by the contract.
992      * @return uint256 representing the total amount of tokens
993      */
994     function totalSupply() public view returns (uint256) {
995         return _allTokens.length;
996     }
997 
998     /**
999      * @dev Gets the token ID at a given index of all the tokens in this contract
1000      * Reverts if the index is greater or equal to the total number of tokens.
1001      * @param index uint256 representing the index to be accessed of the tokens list
1002      * @return uint256 token ID at the given index of the tokens list
1003      */
1004     function tokenByIndex(uint256 index) public view returns (uint256) {
1005         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1006         return _allTokens[index];
1007     }
1008 
1009     /**
1010      * @dev Internal function to transfer ownership of a given token ID to another address.
1011      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1012      * @param from current owner of the token
1013      * @param to address to receive the ownership of the given token ID
1014      * @param tokenId uint256 ID of the token to be transferred
1015      */
1016     function _transferFrom(address from, address to, uint256 tokenId) internal {
1017         super._transferFrom(from, to, tokenId);
1018 
1019         _removeTokenFromOwnerEnumeration(from, tokenId);
1020 
1021         _addTokenToOwnerEnumeration(to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Internal function to mint a new token.
1026      * Reverts if the given token ID already exists.
1027      * @param to address the beneficiary that will own the minted token
1028      * @param tokenId uint256 ID of the token to be minted
1029      */
1030     function _mint(address to, uint256 tokenId) internal {
1031         super._mint(to, tokenId);
1032 
1033         _addTokenToOwnerEnumeration(to, tokenId);
1034 
1035         _addTokenToAllTokensEnumeration(tokenId);
1036     }
1037 
1038     /**
1039      * @dev Internal function to burn a specific token.
1040      * Reverts if the token does not exist.
1041      * Deprecated, use {ERC721-_burn} instead.
1042      * @param owner owner of the token to burn
1043      * @param tokenId uint256 ID of the token being burned
1044      */
1045     function _burn(address owner, uint256 tokenId) internal {
1046         super._burn(owner, tokenId);
1047 
1048         _removeTokenFromOwnerEnumeration(owner, tokenId);
1049         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1050         _ownedTokensIndex[tokenId] = 0;
1051 
1052         _removeTokenFromAllTokensEnumeration(tokenId);
1053     }
1054 
1055     /**
1056      * @dev Gets the list of token IDs of the requested owner.
1057      * @param owner address owning the tokens
1058      * @return uint256[] List of token IDs owned by the requested address
1059      */
1060     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1061         return _ownedTokens[owner];
1062     }
1063 
1064     /**
1065      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1066      * @param to address representing the new owner of the given token ID
1067      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1068      */
1069     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1070         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1071         _ownedTokens[to].push(tokenId);
1072     }
1073 
1074     /**
1075      * @dev Private function to add a token to this extension's token tracking data structures.
1076      * @param tokenId uint256 ID of the token to be added to the tokens list
1077      */
1078     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1079         _allTokensIndex[tokenId] = _allTokens.length;
1080         _allTokens.push(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1085      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1086      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1087      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1088      * @param from address representing the previous owner of the given token ID
1089      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1090      */
1091     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1092         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1093         // then delete the last slot (swap and pop).
1094 
1095         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1096         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1097 
1098         // When the token to delete is the last token, the swap operation is unnecessary
1099         if (tokenIndex != lastTokenIndex) {
1100             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1101 
1102             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104         }
1105 
1106         // This also deletes the contents at the last position of the array
1107         _ownedTokens[from].length--;
1108 
1109         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1110         // lastTokenId, or just over the end of the array if the token was the last one).
1111     }
1112 
1113     /**
1114      * @dev Private function to remove a token from this extension's token tracking data structures.
1115      * This has O(1) time complexity, but alters the order of the _allTokens array.
1116      * @param tokenId uint256 ID of the token to be removed from the tokens list
1117      */
1118     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1119         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1120         // then delete the last slot (swap and pop).
1121 
1122         uint256 lastTokenIndex = _allTokens.length.sub(1);
1123         uint256 tokenIndex = _allTokensIndex[tokenId];
1124 
1125         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1126         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1127         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1128         uint256 lastTokenId = _allTokens[lastTokenIndex];
1129 
1130         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1131         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1132 
1133         // This also deletes the contents at the last position of the array
1134         _allTokens.length--;
1135         _allTokensIndex[tokenId] = 0;
1136     }
1137 }
1138 
1139 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
1140 
1141 pragma solidity ^0.5.0;
1142 
1143 
1144 /**
1145  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1146  * @dev See https://eips.ethereum.org/EIPS/eip-721
1147  */
1148 contract IERC721Metadata is IERC721 {
1149     function name() external view returns (string memory);
1150     function symbol() external view returns (string memory);
1151     function tokenURI(uint256 tokenId) external view returns (string memory);
1152 }
1153 
1154 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721Metadata.sol
1155 
1156 pragma solidity ^0.5.0;
1157 
1158 
1159 
1160 
1161 
1162 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
1163     // Token name
1164     string private _name;
1165 
1166     // Token symbol
1167     string private _symbol;
1168 
1169     // Optional mapping for token URIs
1170     mapping(uint256 => string) private _tokenURIs;
1171 
1172     /*
1173      *     bytes4(keccak256('name()')) == 0x06fdde03
1174      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1175      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1176      *
1177      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1178      */
1179     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1180 
1181     /**
1182      * @dev Constructor function
1183      */
1184     constructor (string memory name, string memory symbol) public {
1185         _name = name;
1186         _symbol = symbol;
1187 
1188         // register the supported interfaces to conform to ERC721 via ERC165
1189         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1190     }
1191 
1192     /**
1193      * @dev Gets the token name.
1194      * @return string representing the token name
1195      */
1196     function name() external view returns (string memory) {
1197         return _name;
1198     }
1199 
1200     /**
1201      * @dev Gets the token symbol.
1202      * @return string representing the token symbol
1203      */
1204     function symbol() external view returns (string memory) {
1205         return _symbol;
1206     }
1207 
1208     /**
1209      * @dev Returns an URI for a given token ID.
1210      * Throws if the token ID does not exist. May return an empty string.
1211      * @param tokenId uint256 ID of the token to query
1212      */
1213     function tokenURI(uint256 tokenId) external view returns (string memory) {
1214         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1215         return _tokenURIs[tokenId];
1216     }
1217 
1218     /**
1219      * @dev Internal function to set the token URI for a given token.
1220      * Reverts if the token ID does not exist.
1221      * @param tokenId uint256 ID of the token to set its URI
1222      * @param uri string URI to assign
1223      */
1224     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1225         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1226         _tokenURIs[tokenId] = uri;
1227     }
1228 
1229     /**
1230      * @dev Internal function to burn a specific token.
1231      * Reverts if the token does not exist.
1232      * Deprecated, use _burn(uint256) instead.
1233      * @param owner owner of the token to burn
1234      * @param tokenId uint256 ID of the token being burned by the msg.sender
1235      */
1236     function _burn(address owner, uint256 tokenId) internal {
1237         super._burn(owner, tokenId);
1238 
1239         // Clear metadata (if any)
1240         if (bytes(_tokenURIs[tokenId]).length != 0) {
1241             delete _tokenURIs[tokenId];
1242         }
1243     }
1244 }
1245 
1246 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721Full.sol
1247 
1248 pragma solidity ^0.5.0;
1249 
1250 
1251 
1252 
1253 /**
1254  * @title Full ERC721 Token
1255  * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
1256  * Moreover, it includes approve all functionality using operator terminology.
1257  *
1258  * See https://eips.ethereum.org/EIPS/eip-721
1259  */
1260 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1261     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1262         // solhint-disable-previous-line no-empty-blocks
1263     }
1264 }
1265 
1266 // File: node_modules\@openzeppelin\contracts\utils\ReentrancyGuard.sol
1267 
1268 pragma solidity ^0.5.0;
1269 
1270 /**
1271  * @dev Contract module that helps prevent reentrant calls to a function.
1272  *
1273  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1274  * available, which can be applied to functions to make sure there are no nested
1275  * (reentrant) calls to them.
1276  *
1277  * Note that because there is a single `nonReentrant` guard, functions marked as
1278  * `nonReentrant` may not call one another. This can be worked around by making
1279  * those functions `private`, and then adding `external` `nonReentrant` entry
1280  * points to them.
1281  */
1282 contract ReentrancyGuard {
1283     // counter to allow mutex lock with only one SSTORE operation
1284     uint256 private _guardCounter;
1285 
1286     constructor () internal {
1287         // The counter starts at one to prevent changing it from zero to a non-zero
1288         // value, which is a more expensive operation.
1289         _guardCounter = 1;
1290     }
1291 
1292     /**
1293      * @dev Prevents a contract from calling itself, directly or indirectly.
1294      * Calling a `nonReentrant` function from another `nonReentrant`
1295      * function is not supported. It is possible to prevent this from happening
1296      * by making the `nonReentrant` function external, and make it call a
1297      * `private` function that does the actual work.
1298      */
1299     modifier nonReentrant() {
1300         _guardCounter += 1;
1301         uint256 localCounter = _guardCounter;
1302         _;
1303         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
1304     }
1305 }
1306 
1307 // File: contracts\provableAPI.sol
1308 
1309 // <provableAPI>
1310 /*
1311 
1312 
1313 Copyright (c) 2015-2016 Oraclize SRL
1314 Copyright (c) 2016-2019 Oraclize LTD
1315 Copyright (c) 2019 Provable Things Limited
1316 
1317 Permission is hereby granted, free of charge, to any person obtaining a copy
1318 of this software and associated documentation files (the "Software"), to deal
1319 in the Software without restriction, including without limitation the rights
1320 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1321 copies of the Software, and to permit persons to whom the Software is
1322 furnished to do so, subject to the following conditions:
1323 
1324 The above copyright notice and this permission notice shall be included in
1325 all copies or substantial portions of the Software.
1326 
1327 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1328 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1329 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1330 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1331 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1332 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1333 THE SOFTWARE.
1334 
1335 */
1336 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the provableAPI!
1337 
1338 // Dummy contract only used to emit to end-user they are using wrong solc
1339 contract solcChecker {
1340 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
1341 }
1342 
1343 contract ProvableI {
1344 
1345     address public cbAddress;
1346 
1347     function setProofType(byte _proofType) external;
1348     function setCustomGasPrice(uint _gasPrice) external;
1349     function getPrice(string memory _datasource) public returns (uint _dsprice);
1350     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
1351     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
1352     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
1353     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
1354     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
1355     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
1356     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
1357     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
1358 }
1359 
1360 contract OracleAddrResolverI {
1361     function getAddress() public returns (address _address);
1362 }
1363 /*
1364 
1365 Begin solidity-cborutils
1366 
1367 https://github.com/smartcontractkit/solidity-cborutils
1368 
1369 MIT License
1370 
1371 Copyright (c) 2018 SmartContract ChainLink, Ltd.
1372 
1373 Permission is hereby granted, free of charge, to any person obtaining a copy
1374 of this software and associated documentation files (the "Software"), to deal
1375 in the Software without restriction, including without limitation the rights
1376 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1377 copies of the Software, and to permit persons to whom the Software is
1378 furnished to do so, subject to the following conditions:
1379 
1380 The above copyright notice and this permission notice shall be included in all
1381 copies or substantial portions of the Software.
1382 
1383 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1384 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1385 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1386 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1387 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1388 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1389 SOFTWARE.
1390 
1391 */
1392 library Buffer {
1393 
1394     struct buffer {
1395         bytes buf;
1396         uint capacity;
1397     }
1398 
1399     function init(buffer memory _buf, uint _capacity) internal pure {
1400         uint capacity = _capacity;
1401         if (capacity % 32 != 0) {
1402             capacity += 32 - (capacity % 32);
1403         }
1404         _buf.capacity = capacity; // Allocate space for the buffer data
1405         assembly {
1406             let ptr := mload(0x40)
1407             mstore(_buf, ptr)
1408             mstore(ptr, 0)
1409             mstore(0x40, add(ptr, capacity))
1410         }
1411     }
1412 
1413     function resize(buffer memory _buf, uint _capacity) private pure {
1414         bytes memory oldbuf = _buf.buf;
1415         init(_buf, _capacity);
1416         append(_buf, oldbuf);
1417     }
1418 
1419     function max(uint _a, uint _b) private pure returns (uint _max) {
1420         if (_a > _b) {
1421             return _a;
1422         }
1423         return _b;
1424     }
1425     /**
1426       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
1427       *      would exceed the capacity of the buffer.
1428       * @param _buf The buffer to append to.
1429       * @param _data The data to append.
1430       * @return The original buffer.
1431       *
1432       */
1433     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
1434         if (_data.length + _buf.buf.length > _buf.capacity) {
1435             resize(_buf, max(_buf.capacity, _data.length) * 2);
1436         }
1437         uint dest;
1438         uint src;
1439         uint len = _data.length;
1440         assembly {
1441             let bufptr := mload(_buf) // Memory address of the buffer data
1442             let buflen := mload(bufptr) // Length of existing buffer data
1443             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
1444             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
1445             src := add(_data, 32)
1446         }
1447         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
1448             assembly {
1449                 mstore(dest, mload(src))
1450             }
1451             dest += 32;
1452             src += 32;
1453         }
1454         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
1455         assembly {
1456             let srcpart := and(mload(src), not(mask))
1457             let destpart := and(mload(dest), mask)
1458             mstore(dest, or(destpart, srcpart))
1459         }
1460         return _buf;
1461     }
1462     /**
1463       *
1464       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1465       * exceed the capacity of the buffer.
1466       * @param _buf The buffer to append to.
1467       * @param _data The data to append.
1468       * @return The original buffer.
1469       *
1470       */
1471     function append(buffer memory _buf, uint8 _data) internal pure {
1472         if (_buf.buf.length + 1 > _buf.capacity) {
1473             resize(_buf, _buf.capacity * 2);
1474         }
1475         assembly {
1476             let bufptr := mload(_buf) // Memory address of the buffer data
1477             let buflen := mload(bufptr) // Length of existing buffer data
1478             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
1479             mstore8(dest, _data)
1480             mstore(bufptr, add(buflen, 1)) // Update buffer length
1481         }
1482     }
1483     /**
1484       *
1485       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1486       * exceed the capacity of the buffer.
1487       * @param _buf The buffer to append to.
1488       * @param _data The data to append.
1489       * @return The original buffer.
1490       *
1491       */
1492     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
1493         if (_len + _buf.buf.length > _buf.capacity) {
1494             resize(_buf, max(_buf.capacity, _len) * 2);
1495         }
1496         uint mask = 256 ** _len - 1;
1497         assembly {
1498             let bufptr := mload(_buf) // Memory address of the buffer data
1499             let buflen := mload(bufptr) // Length of existing buffer data
1500             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
1501             mstore(dest, or(and(mload(dest), not(mask)), _data))
1502             mstore(bufptr, add(buflen, _len)) // Update buffer length
1503         }
1504         return _buf;
1505     }
1506 }
1507 
1508 library CBOR {
1509 
1510     using Buffer for Buffer.buffer;
1511 
1512     uint8 private constant MAJOR_TYPE_INT = 0;
1513     uint8 private constant MAJOR_TYPE_MAP = 5;
1514     uint8 private constant MAJOR_TYPE_BYTES = 2;
1515     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1516     uint8 private constant MAJOR_TYPE_STRING = 3;
1517     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1518     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1519 
1520     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
1521         if (_value <= 23) {
1522             _buf.append(uint8((_major << 5) | _value));
1523         } else if (_value <= 0xFF) {
1524             _buf.append(uint8((_major << 5) | 24));
1525             _buf.appendInt(_value, 1);
1526         } else if (_value <= 0xFFFF) {
1527             _buf.append(uint8((_major << 5) | 25));
1528             _buf.appendInt(_value, 2);
1529         } else if (_value <= 0xFFFFFFFF) {
1530             _buf.append(uint8((_major << 5) | 26));
1531             _buf.appendInt(_value, 4);
1532         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
1533             _buf.append(uint8((_major << 5) | 27));
1534             _buf.appendInt(_value, 8);
1535         }
1536     }
1537 
1538     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
1539         _buf.append(uint8((_major << 5) | 31));
1540     }
1541 
1542     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
1543         encodeType(_buf, MAJOR_TYPE_INT, _value);
1544     }
1545 
1546     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
1547         if (_value >= 0) {
1548             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
1549         } else {
1550             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
1551         }
1552     }
1553 
1554     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
1555         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
1556         _buf.append(_value);
1557     }
1558 
1559     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
1560         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
1561         _buf.append(bytes(_value));
1562     }
1563 
1564     function startArray(Buffer.buffer memory _buf) internal pure {
1565         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
1566     }
1567 
1568     function startMap(Buffer.buffer memory _buf) internal pure {
1569         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
1570     }
1571 
1572     function endSequence(Buffer.buffer memory _buf) internal pure {
1573         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
1574     }
1575 }
1576 /*
1577 
1578 End solidity-cborutils
1579 
1580 */
1581 contract usingProvable {
1582 
1583     using CBOR for Buffer.buffer;
1584 
1585     ProvableI provable;
1586     OracleAddrResolverI OAR;
1587 
1588     uint constant day = 60 * 60 * 24;
1589     uint constant week = 60 * 60 * 24 * 7;
1590     uint constant month = 60 * 60 * 24 * 30;
1591 
1592     byte constant proofType_NONE = 0x00;
1593     byte constant proofType_Ledger = 0x30;
1594     byte constant proofType_Native = 0xF0;
1595     byte constant proofStorage_IPFS = 0x01;
1596     byte constant proofType_Android = 0x40;
1597     byte constant proofType_TLSNotary = 0x10;
1598 
1599     string provable_network_name;
1600     uint8 constant networkID_auto = 0;
1601     uint8 constant networkID_morden = 2;
1602     uint8 constant networkID_mainnet = 1;
1603     uint8 constant networkID_testnet = 2;
1604     uint8 constant networkID_consensys = 161;
1605 
1606     mapping(bytes32 => bytes32) provable_randomDS_args;
1607     mapping(bytes32 => bool) provable_randomDS_sessionKeysHashVerified;
1608 
1609     modifier provableAPI {
1610         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
1611             provable_setNetwork(networkID_auto);
1612         }
1613         if (address(provable) != OAR.getAddress()) {
1614             provable = ProvableI(OAR.getAddress());
1615         }
1616         _;
1617     }
1618 
1619     modifier provable_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
1620         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1621         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
1622         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
1623         require(proofVerified);
1624         _;
1625     }
1626 
1627     function provable_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
1628       _networkID; // NOTE: Silence the warning and remain backwards compatible
1629       return provable_setNetwork();
1630     }
1631 
1632     function provable_setNetworkName(string memory _network_name) internal {
1633         provable_network_name = _network_name;
1634     }
1635 
1636     function provable_getNetworkName() internal view returns (string memory _networkName) {
1637         return provable_network_name;
1638     }
1639 
1640     function provable_setNetwork() internal returns (bool _networkSet) {
1641         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
1642             OAR = OracleAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1643             provable_setNetworkName("eth_mainnet");
1644             return true;
1645         }
1646         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
1647             OAR = OracleAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1648             provable_setNetworkName("eth_ropsten3");
1649             return true;
1650         }
1651         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
1652             OAR = OracleAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1653             provable_setNetworkName("eth_kovan");
1654             return true;
1655         }
1656         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
1657             OAR = OracleAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1658             provable_setNetworkName("eth_rinkeby");
1659             return true;
1660         }
1661         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
1662             OAR = OracleAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
1663             provable_setNetworkName("eth_goerli");
1664             return true;
1665         }
1666         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
1667             OAR = OracleAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1668             return true;
1669         }
1670         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
1671             OAR = OracleAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1672             return true;
1673         }
1674         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
1675             OAR = OracleAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1676             return true;
1677         }
1678         return false;
1679     }
1680     /**
1681      * @dev The following `__callback` functions are just placeholders ideally
1682      *      meant to be defined in child contract when proofs are used.
1683      *      The function bodies simply silence compiler warnings.
1684      */
1685     function __callback(bytes32 _myid, string memory _result) public {
1686         __callback(_myid, _result, new bytes(0));
1687     }
1688 
1689     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
1690       _myid; _result; _proof;
1691       provable_randomDS_args[bytes32(0)] = bytes32(0);
1692     }
1693 
1694     function provable_getPrice(string memory _datasource) provableAPI internal returns (uint _queryPrice) {
1695         return provable.getPrice(_datasource);
1696     }
1697 
1698     function provable_getPrice(string memory _datasource, uint _gasLimit) provableAPI internal returns (uint _queryPrice) {
1699         return provable.getPrice(_datasource, _gasLimit);
1700     }
1701 
1702     function provable_query(string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
1703         uint price = provable.getPrice(_datasource);
1704         if (price > 1 ether + tx.gasprice * 200000) {
1705             return 0; // Unexpectedly high price
1706         }
1707         return provable.query.value(price)(0, _datasource, _arg);
1708     }
1709 
1710     function provable_query(uint _timestamp, string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
1711         uint price = provable.getPrice(_datasource);
1712         if (price > 1 ether + tx.gasprice * 200000) {
1713             return 0; // Unexpectedly high price
1714         }
1715         return provable.query.value(price)(_timestamp, _datasource, _arg);
1716     }
1717 
1718     function provable_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1719         uint price = provable.getPrice(_datasource,_gasLimit);
1720         if (price > 1 ether + tx.gasprice * _gasLimit) {
1721             return 0; // Unexpectedly high price
1722         }
1723         return provable.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
1724     }
1725 
1726     function provable_query(string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1727         uint price = provable.getPrice(_datasource, _gasLimit);
1728         if (price > 1 ether + tx.gasprice * _gasLimit) {
1729            return 0; // Unexpectedly high price
1730         }
1731         return provable.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
1732     }
1733 
1734     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
1735         uint price = provable.getPrice(_datasource);
1736         if (price > 1 ether + tx.gasprice * 200000) {
1737             return 0; // Unexpectedly high price
1738         }
1739         return provable.query2.value(price)(0, _datasource, _arg1, _arg2);
1740     }
1741 
1742     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
1743         uint price = provable.getPrice(_datasource);
1744         if (price > 1 ether + tx.gasprice * 200000) {
1745             return 0; // Unexpectedly high price
1746         }
1747         return provable.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
1748     }
1749 
1750     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1751         uint price = provable.getPrice(_datasource, _gasLimit);
1752         if (price > 1 ether + tx.gasprice * _gasLimit) {
1753             return 0; // Unexpectedly high price
1754         }
1755         return provable.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
1756     }
1757 
1758     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1759         uint price = provable.getPrice(_datasource, _gasLimit);
1760         if (price > 1 ether + tx.gasprice * _gasLimit) {
1761             return 0; // Unexpectedly high price
1762         }
1763         return provable.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
1764     }
1765 
1766     function provable_query(string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
1767         uint price = provable.getPrice(_datasource);
1768         if (price > 1 ether + tx.gasprice * 200000) {
1769             return 0; // Unexpectedly high price
1770         }
1771         bytes memory args = stra2cbor(_argN);
1772         return provable.queryN.value(price)(0, _datasource, args);
1773     }
1774 
1775     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
1776         uint price = provable.getPrice(_datasource);
1777         if (price > 1 ether + tx.gasprice * 200000) {
1778             return 0; // Unexpectedly high price
1779         }
1780         bytes memory args = stra2cbor(_argN);
1781         return provable.queryN.value(price)(_timestamp, _datasource, args);
1782     }
1783 
1784     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1785         uint price = provable.getPrice(_datasource, _gasLimit);
1786         if (price > 1 ether + tx.gasprice * _gasLimit) {
1787             return 0; // Unexpectedly high price
1788         }
1789         bytes memory args = stra2cbor(_argN);
1790         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1791     }
1792 
1793     function provable_query(string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1794         uint price = provable.getPrice(_datasource, _gasLimit);
1795         if (price > 1 ether + tx.gasprice * _gasLimit) {
1796             return 0; // Unexpectedly high price
1797         }
1798         bytes memory args = stra2cbor(_argN);
1799         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1800     }
1801 
1802     function provable_query(string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
1803         string[] memory dynargs = new string[](1);
1804         dynargs[0] = _args[0];
1805         return provable_query(_datasource, dynargs);
1806     }
1807 
1808     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
1809         string[] memory dynargs = new string[](1);
1810         dynargs[0] = _args[0];
1811         return provable_query(_timestamp, _datasource, dynargs);
1812     }
1813 
1814     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1815         string[] memory dynargs = new string[](1);
1816         dynargs[0] = _args[0];
1817         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1818     }
1819 
1820     function provable_query(string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1821         string[] memory dynargs = new string[](1);
1822         dynargs[0] = _args[0];
1823         return provable_query(_datasource, dynargs, _gasLimit);
1824     }
1825 
1826     function provable_query(string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
1827         string[] memory dynargs = new string[](2);
1828         dynargs[0] = _args[0];
1829         dynargs[1] = _args[1];
1830         return provable_query(_datasource, dynargs);
1831     }
1832 
1833     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
1834         string[] memory dynargs = new string[](2);
1835         dynargs[0] = _args[0];
1836         dynargs[1] = _args[1];
1837         return provable_query(_timestamp, _datasource, dynargs);
1838     }
1839 
1840     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1841         string[] memory dynargs = new string[](2);
1842         dynargs[0] = _args[0];
1843         dynargs[1] = _args[1];
1844         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1845     }
1846 
1847     function provable_query(string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1848         string[] memory dynargs = new string[](2);
1849         dynargs[0] = _args[0];
1850         dynargs[1] = _args[1];
1851         return provable_query(_datasource, dynargs, _gasLimit);
1852     }
1853 
1854     function provable_query(string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
1855         string[] memory dynargs = new string[](3);
1856         dynargs[0] = _args[0];
1857         dynargs[1] = _args[1];
1858         dynargs[2] = _args[2];
1859         return provable_query(_datasource, dynargs);
1860     }
1861 
1862     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
1863         string[] memory dynargs = new string[](3);
1864         dynargs[0] = _args[0];
1865         dynargs[1] = _args[1];
1866         dynargs[2] = _args[2];
1867         return provable_query(_timestamp, _datasource, dynargs);
1868     }
1869 
1870     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1871         string[] memory dynargs = new string[](3);
1872         dynargs[0] = _args[0];
1873         dynargs[1] = _args[1];
1874         dynargs[2] = _args[2];
1875         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1876     }
1877 
1878     function provable_query(string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1879         string[] memory dynargs = new string[](3);
1880         dynargs[0] = _args[0];
1881         dynargs[1] = _args[1];
1882         dynargs[2] = _args[2];
1883         return provable_query(_datasource, dynargs, _gasLimit);
1884     }
1885 
1886     function provable_query(string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
1887         string[] memory dynargs = new string[](4);
1888         dynargs[0] = _args[0];
1889         dynargs[1] = _args[1];
1890         dynargs[2] = _args[2];
1891         dynargs[3] = _args[3];
1892         return provable_query(_datasource, dynargs);
1893     }
1894 
1895     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
1896         string[] memory dynargs = new string[](4);
1897         dynargs[0] = _args[0];
1898         dynargs[1] = _args[1];
1899         dynargs[2] = _args[2];
1900         dynargs[3] = _args[3];
1901         return provable_query(_timestamp, _datasource, dynargs);
1902     }
1903 
1904     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1905         string[] memory dynargs = new string[](4);
1906         dynargs[0] = _args[0];
1907         dynargs[1] = _args[1];
1908         dynargs[2] = _args[2];
1909         dynargs[3] = _args[3];
1910         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1911     }
1912 
1913     function provable_query(string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1914         string[] memory dynargs = new string[](4);
1915         dynargs[0] = _args[0];
1916         dynargs[1] = _args[1];
1917         dynargs[2] = _args[2];
1918         dynargs[3] = _args[3];
1919         return provable_query(_datasource, dynargs, _gasLimit);
1920     }
1921 
1922     function provable_query(string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
1923         string[] memory dynargs = new string[](5);
1924         dynargs[0] = _args[0];
1925         dynargs[1] = _args[1];
1926         dynargs[2] = _args[2];
1927         dynargs[3] = _args[3];
1928         dynargs[4] = _args[4];
1929         return provable_query(_datasource, dynargs);
1930     }
1931 
1932     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
1933         string[] memory dynargs = new string[](5);
1934         dynargs[0] = _args[0];
1935         dynargs[1] = _args[1];
1936         dynargs[2] = _args[2];
1937         dynargs[3] = _args[3];
1938         dynargs[4] = _args[4];
1939         return provable_query(_timestamp, _datasource, dynargs);
1940     }
1941 
1942     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1943         string[] memory dynargs = new string[](5);
1944         dynargs[0] = _args[0];
1945         dynargs[1] = _args[1];
1946         dynargs[2] = _args[2];
1947         dynargs[3] = _args[3];
1948         dynargs[4] = _args[4];
1949         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1950     }
1951 
1952     function provable_query(string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1953         string[] memory dynargs = new string[](5);
1954         dynargs[0] = _args[0];
1955         dynargs[1] = _args[1];
1956         dynargs[2] = _args[2];
1957         dynargs[3] = _args[3];
1958         dynargs[4] = _args[4];
1959         return provable_query(_datasource, dynargs, _gasLimit);
1960     }
1961 
1962     function provable_query(string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
1963         uint price = provable.getPrice(_datasource);
1964         if (price > 1 ether + tx.gasprice * 200000) {
1965             return 0; // Unexpectedly high price
1966         }
1967         bytes memory args = ba2cbor(_argN);
1968         return provable.queryN.value(price)(0, _datasource, args);
1969     }
1970 
1971     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
1972         uint price = provable.getPrice(_datasource);
1973         if (price > 1 ether + tx.gasprice * 200000) {
1974             return 0; // Unexpectedly high price
1975         }
1976         bytes memory args = ba2cbor(_argN);
1977         return provable.queryN.value(price)(_timestamp, _datasource, args);
1978     }
1979 
1980     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1981         uint price = provable.getPrice(_datasource, _gasLimit);
1982         if (price > 1 ether + tx.gasprice * _gasLimit) {
1983             return 0; // Unexpectedly high price
1984         }
1985         bytes memory args = ba2cbor(_argN);
1986         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1987     }
1988 
1989     function provable_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1990         uint price = provable.getPrice(_datasource, _gasLimit);
1991         if (price > 1 ether + tx.gasprice * _gasLimit) {
1992             return 0; // Unexpectedly high price
1993         }
1994         bytes memory args = ba2cbor(_argN);
1995         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1996     }
1997 
1998     function provable_query(string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
1999         bytes[] memory dynargs = new bytes[](1);
2000         dynargs[0] = _args[0];
2001         return provable_query(_datasource, dynargs);
2002     }
2003 
2004     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
2005         bytes[] memory dynargs = new bytes[](1);
2006         dynargs[0] = _args[0];
2007         return provable_query(_timestamp, _datasource, dynargs);
2008     }
2009 
2010     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2011         bytes[] memory dynargs = new bytes[](1);
2012         dynargs[0] = _args[0];
2013         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
2014     }
2015 
2016     function provable_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2017         bytes[] memory dynargs = new bytes[](1);
2018         dynargs[0] = _args[0];
2019         return provable_query(_datasource, dynargs, _gasLimit);
2020     }
2021 
2022     function provable_query(string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
2023         bytes[] memory dynargs = new bytes[](2);
2024         dynargs[0] = _args[0];
2025         dynargs[1] = _args[1];
2026         return provable_query(_datasource, dynargs);
2027     }
2028 
2029     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
2030         bytes[] memory dynargs = new bytes[](2);
2031         dynargs[0] = _args[0];
2032         dynargs[1] = _args[1];
2033         return provable_query(_timestamp, _datasource, dynargs);
2034     }
2035 
2036     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2037         bytes[] memory dynargs = new bytes[](2);
2038         dynargs[0] = _args[0];
2039         dynargs[1] = _args[1];
2040         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
2041     }
2042 
2043     function provable_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2044         bytes[] memory dynargs = new bytes[](2);
2045         dynargs[0] = _args[0];
2046         dynargs[1] = _args[1];
2047         return provable_query(_datasource, dynargs, _gasLimit);
2048     }
2049 
2050     function provable_query(string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
2051         bytes[] memory dynargs = new bytes[](3);
2052         dynargs[0] = _args[0];
2053         dynargs[1] = _args[1];
2054         dynargs[2] = _args[2];
2055         return provable_query(_datasource, dynargs);
2056     }
2057 
2058     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
2059         bytes[] memory dynargs = new bytes[](3);
2060         dynargs[0] = _args[0];
2061         dynargs[1] = _args[1];
2062         dynargs[2] = _args[2];
2063         return provable_query(_timestamp, _datasource, dynargs);
2064     }
2065 
2066     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2067         bytes[] memory dynargs = new bytes[](3);
2068         dynargs[0] = _args[0];
2069         dynargs[1] = _args[1];
2070         dynargs[2] = _args[2];
2071         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
2072     }
2073 
2074     function provable_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2075         bytes[] memory dynargs = new bytes[](3);
2076         dynargs[0] = _args[0];
2077         dynargs[1] = _args[1];
2078         dynargs[2] = _args[2];
2079         return provable_query(_datasource, dynargs, _gasLimit);
2080     }
2081 
2082     function provable_query(string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
2083         bytes[] memory dynargs = new bytes[](4);
2084         dynargs[0] = _args[0];
2085         dynargs[1] = _args[1];
2086         dynargs[2] = _args[2];
2087         dynargs[3] = _args[3];
2088         return provable_query(_datasource, dynargs);
2089     }
2090 
2091     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
2092         bytes[] memory dynargs = new bytes[](4);
2093         dynargs[0] = _args[0];
2094         dynargs[1] = _args[1];
2095         dynargs[2] = _args[2];
2096         dynargs[3] = _args[3];
2097         return provable_query(_timestamp, _datasource, dynargs);
2098     }
2099 
2100     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2101         bytes[] memory dynargs = new bytes[](4);
2102         dynargs[0] = _args[0];
2103         dynargs[1] = _args[1];
2104         dynargs[2] = _args[2];
2105         dynargs[3] = _args[3];
2106         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
2107     }
2108 
2109     function provable_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2110         bytes[] memory dynargs = new bytes[](4);
2111         dynargs[0] = _args[0];
2112         dynargs[1] = _args[1];
2113         dynargs[2] = _args[2];
2114         dynargs[3] = _args[3];
2115         return provable_query(_datasource, dynargs, _gasLimit);
2116     }
2117 
2118     function provable_query(string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
2119         bytes[] memory dynargs = new bytes[](5);
2120         dynargs[0] = _args[0];
2121         dynargs[1] = _args[1];
2122         dynargs[2] = _args[2];
2123         dynargs[3] = _args[3];
2124         dynargs[4] = _args[4];
2125         return provable_query(_datasource, dynargs);
2126     }
2127 
2128     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
2129         bytes[] memory dynargs = new bytes[](5);
2130         dynargs[0] = _args[0];
2131         dynargs[1] = _args[1];
2132         dynargs[2] = _args[2];
2133         dynargs[3] = _args[3];
2134         dynargs[4] = _args[4];
2135         return provable_query(_timestamp, _datasource, dynargs);
2136     }
2137 
2138     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2139         bytes[] memory dynargs = new bytes[](5);
2140         dynargs[0] = _args[0];
2141         dynargs[1] = _args[1];
2142         dynargs[2] = _args[2];
2143         dynargs[3] = _args[3];
2144         dynargs[4] = _args[4];
2145         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
2146     }
2147 
2148     function provable_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
2149         bytes[] memory dynargs = new bytes[](5);
2150         dynargs[0] = _args[0];
2151         dynargs[1] = _args[1];
2152         dynargs[2] = _args[2];
2153         dynargs[3] = _args[3];
2154         dynargs[4] = _args[4];
2155         return provable_query(_datasource, dynargs, _gasLimit);
2156     }
2157 
2158     function provable_setProof(byte _proofP) provableAPI internal {
2159         return provable.setProofType(_proofP);
2160     }
2161 
2162 
2163     function provable_cbAddress() provableAPI internal returns (address _callbackAddress) {
2164         return provable.cbAddress();
2165     }
2166 
2167     function getCodeSize(address _addr) view internal returns (uint _size) {
2168         assembly {
2169             _size := extcodesize(_addr)
2170         }
2171     }
2172 
2173     function provable_setCustomGasPrice(uint _gasPrice) provableAPI internal {
2174         return provable.setCustomGasPrice(_gasPrice);
2175     }
2176 
2177     function provable_randomDS_getSessionPubKeyHash() provableAPI internal returns (bytes32 _sessionKeyHash) {
2178         return provable.randomDS_getSessionPubKeyHash();
2179     }
2180 
2181     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
2182         bytes memory tmp = bytes(_a);
2183         uint160 iaddr = 0;
2184         uint160 b1;
2185         uint160 b2;
2186         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
2187             iaddr *= 256;
2188             b1 = uint160(uint8(tmp[i]));
2189             b2 = uint160(uint8(tmp[i + 1]));
2190             if ((b1 >= 97) && (b1 <= 102)) {
2191                 b1 -= 87;
2192             } else if ((b1 >= 65) && (b1 <= 70)) {
2193                 b1 -= 55;
2194             } else if ((b1 >= 48) && (b1 <= 57)) {
2195                 b1 -= 48;
2196             }
2197             if ((b2 >= 97) && (b2 <= 102)) {
2198                 b2 -= 87;
2199             } else if ((b2 >= 65) && (b2 <= 70)) {
2200                 b2 -= 55;
2201             } else if ((b2 >= 48) && (b2 <= 57)) {
2202                 b2 -= 48;
2203             }
2204             iaddr += (b1 * 16 + b2);
2205         }
2206         return address(iaddr);
2207     }
2208 
2209     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
2210         bytes memory a = bytes(_a);
2211         bytes memory b = bytes(_b);
2212         uint minLength = a.length;
2213         if (b.length < minLength) {
2214             minLength = b.length;
2215         }
2216         for (uint i = 0; i < minLength; i ++) {
2217             if (a[i] < b[i]) {
2218                 return -1;
2219             } else if (a[i] > b[i]) {
2220                 return 1;
2221             }
2222         }
2223         if (a.length < b.length) {
2224             return -1;
2225         } else if (a.length > b.length) {
2226             return 1;
2227         } else {
2228             return 0;
2229         }
2230     }
2231 
2232     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
2233         bytes memory h = bytes(_haystack);
2234         bytes memory n = bytes(_needle);
2235         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
2236             return -1;
2237         } else if (h.length > (2 ** 128 - 1)) {
2238             return -1;
2239         } else {
2240             uint subindex = 0;
2241             for (uint i = 0; i < h.length; i++) {
2242                 if (h[i] == n[0]) {
2243                     subindex = 1;
2244                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
2245                         subindex++;
2246                     }
2247                     if (subindex == n.length) {
2248                         return int(i);
2249                     }
2250                 }
2251             }
2252             return -1;
2253         }
2254     }
2255 
2256     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
2257         return strConcat(_a, _b, "", "", "");
2258     }
2259 
2260     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
2261         return strConcat(_a, _b, _c, "", "");
2262     }
2263 
2264     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
2265         return strConcat(_a, _b, _c, _d, "");
2266     }
2267 
2268     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
2269         bytes memory _ba = bytes(_a);
2270         bytes memory _bb = bytes(_b);
2271         bytes memory _bc = bytes(_c);
2272         bytes memory _bd = bytes(_d);
2273         bytes memory _be = bytes(_e);
2274         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
2275         bytes memory babcde = bytes(abcde);
2276         uint k = 0;
2277         uint i = 0;
2278         for (i = 0; i < _ba.length; i++) {
2279             babcde[k++] = _ba[i];
2280         }
2281         for (i = 0; i < _bb.length; i++) {
2282             babcde[k++] = _bb[i];
2283         }
2284         for (i = 0; i < _bc.length; i++) {
2285             babcde[k++] = _bc[i];
2286         }
2287         for (i = 0; i < _bd.length; i++) {
2288             babcde[k++] = _bd[i];
2289         }
2290         for (i = 0; i < _be.length; i++) {
2291             babcde[k++] = _be[i];
2292         }
2293         return string(babcde);
2294     }
2295 
2296     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
2297         return safeParseInt(_a, 0);
2298     }
2299 
2300     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
2301         bytes memory bresult = bytes(_a);
2302         uint mint = 0;
2303         bool decimals = false;
2304         for (uint i = 0; i < bresult.length; i++) {
2305             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
2306                 if (decimals) {
2307                    if (_b == 0) break;
2308                     else _b--;
2309                 }
2310                 mint *= 10;
2311                 mint += uint(uint8(bresult[i])) - 48;
2312             } else if (uint(uint8(bresult[i])) == 46) {
2313                 require(!decimals, 'More than one decimal encountered in string!');
2314                 decimals = true;
2315             } else {
2316                 revert("Non-numeral character encountered in string!");
2317             }
2318         }
2319         if (_b > 0) {
2320             mint *= 10 ** _b;
2321         }
2322         return mint;
2323     }
2324 
2325     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
2326         return parseInt(_a, 0);
2327     }
2328 
2329     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
2330         bytes memory bresult = bytes(_a);
2331         uint mint = 0;
2332         bool decimals = false;
2333         for (uint i = 0; i < bresult.length; i++) {
2334             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
2335                 if (decimals) {
2336                    if (_b == 0) {
2337                        break;
2338                    } else {
2339                        _b--;
2340                    }
2341                 }
2342                 mint *= 10;
2343                 mint += uint(uint8(bresult[i])) - 48;
2344             } else if (uint(uint8(bresult[i])) == 46) {
2345                 decimals = true;
2346             }
2347         }
2348         if (_b > 0) {
2349             mint *= 10 ** _b;
2350         }
2351         return mint;
2352     }
2353 
2354     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
2355         if (_i == 0) {
2356             return "0";
2357         }
2358         uint j = _i;
2359         uint len;
2360         while (j != 0) {
2361             len++;
2362             j /= 10;
2363         }
2364         bytes memory bstr = new bytes(len);
2365         uint k = len - 1;
2366         while (_i != 0) {
2367             bstr[k--] = byte(uint8(48 + _i % 10));
2368             _i /= 10;
2369         }
2370         return string(bstr);
2371     }
2372 
2373     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
2374         safeMemoryCleaner();
2375         Buffer.buffer memory buf;
2376         Buffer.init(buf, 1024);
2377         buf.startArray();
2378         for (uint i = 0; i < _arr.length; i++) {
2379             buf.encodeString(_arr[i]);
2380         }
2381         buf.endSequence();
2382         return buf.buf;
2383     }
2384 
2385     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
2386         safeMemoryCleaner();
2387         Buffer.buffer memory buf;
2388         Buffer.init(buf, 1024);
2389         buf.startArray();
2390         for (uint i = 0; i < _arr.length; i++) {
2391             buf.encodeBytes(_arr[i]);
2392         }
2393         buf.endSequence();
2394         return buf.buf;
2395     }
2396 
2397     function provable_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
2398         require((_nbytes > 0) && (_nbytes <= 32));
2399         _delay *= 10; // Convert from seconds to ledger timer ticks
2400         bytes memory nbytes = new bytes(1);
2401         nbytes[0] = byte(uint8(_nbytes));
2402         bytes memory unonce = new bytes(32);
2403         bytes memory sessionKeyHash = new bytes(32);
2404         bytes32 sessionKeyHash_bytes32 = provable_randomDS_getSessionPubKeyHash();
2405         assembly {
2406             mstore(unonce, 0x20)
2407             /*
2408              The following variables can be relaxed.
2409              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
2410              for an idea on how to override and replace commit hash variables.
2411             */
2412             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
2413             mstore(sessionKeyHash, 0x20)
2414             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
2415         }
2416         bytes memory delay = new bytes(32);
2417         assembly {
2418             mstore(add(delay, 0x20), _delay)
2419         }
2420         bytes memory delay_bytes8 = new bytes(8);
2421         copyBytes(delay, 24, 8, delay_bytes8, 0);
2422         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
2423         bytes32 queryId = provable_query("random", args, _customGasLimit);
2424         bytes memory delay_bytes8_left = new bytes(8);
2425         assembly {
2426             let x := mload(add(delay_bytes8, 0x20))
2427             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
2428             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
2429             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
2430             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
2431             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
2432             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
2433             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
2434             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
2435         }
2436         provable_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
2437         return queryId;
2438     }
2439 
2440     function provable_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
2441         provable_randomDS_args[_queryId] = _commitment;
2442     }
2443 
2444     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
2445         bool sigok;
2446         address signer;
2447         bytes32 sigr;
2448         bytes32 sigs;
2449         bytes memory sigr_ = new bytes(32);
2450         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
2451         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
2452         bytes memory sigs_ = new bytes(32);
2453         offset += 32 + 2;
2454         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
2455         assembly {
2456             sigr := mload(add(sigr_, 32))
2457             sigs := mload(add(sigs_, 32))
2458         }
2459         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
2460         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
2461             return true;
2462         } else {
2463             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
2464             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
2465         }
2466     }
2467 
2468     function provable_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
2469         bool sigok;
2470         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
2471         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
2472         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
2473         bytes memory appkey1_pubkey = new bytes(64);
2474         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
2475         bytes memory tosign2 = new bytes(1 + 65 + 32);
2476         tosign2[0] = byte(uint8(1)); //role
2477         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
2478         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
2479         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
2480         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
2481         if (!sigok) {
2482             return false;
2483         }
2484         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
2485         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
2486         bytes memory tosign3 = new bytes(1 + 65);
2487         tosign3[0] = 0xFE;
2488         copyBytes(_proof, 3, 65, tosign3, 1);
2489         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
2490         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
2491         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2492         return sigok;
2493     }
2494 
2495     function provable_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
2496         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
2497         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
2498             return 1;
2499         }
2500         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
2501         if (!proofVerified) {
2502             return 2;
2503         }
2504         return 0;
2505     }
2506 
2507     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
2508         bool match_ = true;
2509         require(_prefix.length == _nRandomBytes);
2510         for (uint256 i = 0; i< _nRandomBytes; i++) {
2511             if (_content[i] != _prefix[i]) {
2512                 match_ = false;
2513             }
2514         }
2515         return match_;
2516     }
2517 
2518     function provable_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
2519         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
2520         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
2521         bytes memory keyhash = new bytes(32);
2522         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
2523         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
2524             return false;
2525         }
2526         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
2527         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
2528         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
2529         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
2530             return false;
2531         }
2532         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2533         // This is to verify that the computed args match with the ones specified in the query.
2534         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
2535         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
2536         bytes memory sessionPubkey = new bytes(64);
2537         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
2538         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
2539         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2540         if (provable_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
2541             delete provable_randomDS_args[_queryId];
2542         } else return false;
2543         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
2544         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
2545         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
2546         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
2547             return false;
2548         }
2549         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
2550         if (!provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
2551             provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = provable_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
2552         }
2553         return provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2554     }
2555     /*
2556      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2557     */
2558     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
2559         uint minLength = _length + _toOffset;
2560         require(_to.length >= minLength); // Buffer too small. Should be a better way?
2561         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2562         uint j = 32 + _toOffset;
2563         while (i < (32 + _fromOffset + _length)) {
2564             assembly {
2565                 let tmp := mload(add(_from, i))
2566                 mstore(add(_to, j), tmp)
2567             }
2568             i += 32;
2569             j += 32;
2570         }
2571         return _to;
2572     }
2573     /*
2574      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2575      Duplicate Solidity's ecrecover, but catching the CALL return value
2576     */
2577     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
2578         /*
2579          We do our own memory management here. Solidity uses memory offset
2580          0x40 to store the current end of memory. We write past it (as
2581          writes are memory extensions), but don't update the offset so
2582          Solidity will reuse it. The memory used here is only needed for
2583          this context.
2584          FIXME: inline assembly can't access return values
2585         */
2586         bool ret;
2587         address addr;
2588         assembly {
2589             let size := mload(0x40)
2590             mstore(size, _hash)
2591             mstore(add(size, 32), _v)
2592             mstore(add(size, 64), _r)
2593             mstore(add(size, 96), _s)
2594             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
2595             addr := mload(size)
2596         }
2597         return (ret, addr);
2598     }
2599     /*
2600      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2601     */
2602     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
2603         bytes32 r;
2604         bytes32 s;
2605         uint8 v;
2606         if (_sig.length != 65) {
2607             return (false, address(0));
2608         }
2609         /*
2610          The signature format is a compact form of:
2611            {bytes32 r}{bytes32 s}{uint8 v}
2612          Compact means, uint8 is not padded to 32 bytes.
2613         */
2614         assembly {
2615             r := mload(add(_sig, 32))
2616             s := mload(add(_sig, 64))
2617             /*
2618              Here we are loading the last 32 bytes. We exploit the fact that
2619              'mload' will pad with zeroes if we overread.
2620              There is no 'mload8' to do this, but that would be nicer.
2621             */
2622             v := byte(0, mload(add(_sig, 96)))
2623             /*
2624               Alternative solution:
2625               'byte' is not working due to the Solidity parser, so lets
2626               use the second best option, 'and'
2627               v := and(mload(add(_sig, 65)), 255)
2628             */
2629         }
2630         /*
2631          albeit non-transactional signatures are not specified by the YP, one would expect it
2632          to match the YP range of [27, 28]
2633          geth uses [0, 1] and some clients have followed. This might change, see:
2634          https://github.com/ethereum/go-ethereum/issues/2053
2635         */
2636         if (v < 27) {
2637             v += 27;
2638         }
2639         if (v != 27 && v != 28) {
2640             return (false, address(0));
2641         }
2642         return safer_ecrecover(_hash, v, r, s);
2643     }
2644 
2645     function safeMemoryCleaner() internal pure {
2646         assembly {
2647             let fmem := mload(0x40)
2648             codecopy(fmem, codesize, sub(msize, fmem))
2649         }
2650     }
2651 }
2652 // </provableAPI>
2653 
2654 // File: contracts\MetaGlitch.sol
2655 
2656 pragma solidity ^0.5.11;
2657 
2658 contract OwnableDelegateProxy { }
2659 
2660 contract ProxyRegistry {
2661     mapping(address => OwnableDelegateProxy) public proxies;
2662 }
2663 
2664 contract MetaGlitch is ERC721Full, Ownable, ReentrancyGuard, usingProvable {
2665     using SafeMath for uint;
2666     using Math for uint;
2667 
2668     address payable ethereal;
2669 
2670     //ERC721 PRIVATE VARIABLES
2671     string _name = "MetaGlitch";
2672     string _symbol = "Glitch";
2673     string _tokenURI = "https://api.metaglitch.xyz/tokenid/";
2674     uint _currentTokenId = 170; //after founder mints
2675     address proxyRegistryAddress;
2676 
2677     //MATH CONSTS
2678     uint constant BASIS_POINTS = 10000;
2679     uint constant GWEI = 1000000000;
2680 
2681     //PROVABLE ORACLE
2682     uint gasPrice = 2010000000; //many set exactly 3gwei, so adding 0.01 gwei increases speed much more than expected.
2683     uint gasAmount = 650000;
2684     uint constant NUM_RANDOM_BYTES_REQUESTED = 32;
2685     struct MintingData {
2686         uint baseId;
2687         uint sireId;
2688         uint tokenId;
2689         address baseContract;
2690         address minter;
2691     }
2692     
2693     mapping(bytes32 => MintingData) provableQueryToMintingData;
2694 
2695     //MINT FEES AND PAYOUTS
2696     uint constant mintFeeStart        = 8 finney;
2697     uint constant mintFeeIncrementBase = 2 finney;
2698     uint constant mintFeeIncrementBP   = 1000;
2699     uint constant sireRewardBP = 5000; //50% goes to sire after oracle fees. Remainder is for nft development and community events.
2700 
2701     //Founders + Speed mints
2702     //Founders are special mints reserved by early fans.
2703     uint founderMintStart;
2704     uint openMintStart;
2705     mapping(uint => address) public founderMintReservation;
2706 
2707     //Variable mins, maxes, steps (mx+min must add to less than 256)
2708     uint8 constant delayMin  = 0; //100x scale
2709     uint8 constant delayMax  = 50;
2710     uint8 constant seedMin   = 1; //1x
2711     uint8 constant seedMax   = 99;
2712     uint8 constant quantityMin  = 1; //1x
2713     uint8 constant quantityMax  = 20;
2714     uint8 constant timescaleMin = 1;
2715     uint8 constant timescaleMax = 50;
2716     uint8 constant sizeMin  = 5; //2x scale
2717     uint8 constant sizeMax  = 160;
2718     uint8 constant posMin   = 0; //2x scale
2719     uint8 constant posMax   = 160;
2720     uint8 constant mutabilityMin = 1; //1x
2721     uint8 constant mutabilityMax = 100;
2722     uint8 constant speedMin = 4; //1x
2723     uint8 constant speedMax = 168;
2724     uint8 constant glitchCountMin = 1; //1x
2725     uint8 constant glitchCountMax = 4;
2726 
2727     uint constant minArea = 1250; //2x
2728 
2729     uint constant foundersSireId = ~uint(0);
2730 
2731     //MetaGlitch NFT data
2732     struct Glitch{
2733       uint8 delay;
2734       uint8 seed;
2735       uint8 quantity;
2736       uint8 timescale;
2737       uint8 sizeW;
2738       uint8 sizeH;
2739       uint8 posX;
2740       uint8 posY;
2741     }
2742     struct Stats{
2743         uint8 glitchCount;
2744         uint8 speed;
2745         uint8 mutability;
2746         address baseContract;
2747         uint siringTimer;
2748         uint siringFee;
2749         uint sireId;
2750         uint baseId;
2751         uint generation;
2752         uint[4] glitchIds;
2753     }
2754     mapping(uint => Stats) public nftStats;
2755     mapping(uint => Glitch) public glitches;
2756     uint _currentGlitchId;
2757     mapping(address => mapping(uint => uint)) public baseAddressTokenIdToMetaGlitch;
2758     
2759     event LogBaseChange(uint metaGlitchID);
2760     event LogSired(uint sireId);
2761 
2762     //Allowed base contracts - NFTs who have agreed MetaGlitch complies with their licensing terms.
2763     mapping(address => bool) allowedBaseContracts;
2764 
2765     modifier onlyEthereal {
2766         require(msg.sender == ethereal,"Only @ethereal can do this.");
2767         _;
2768     }
2769     modifier whenStandardMinting {
2770         require(now.max(openMintStart)==now,"Must be after open minting starts.");
2771         _;
2772     }
2773     modifier whenFounderMinting {
2774         require(now.max(founderMintStart)==now,"Must be after founder minting starts.");
2775         _;
2776     }
2777 
2778     constructor(address _proxyRegistryAddress, uint startTime)  ERC721Full(_name,_symbol) public{
2779         ethereal = msg.sender;
2780         founderMintStart = startTime;
2781         openMintStart = founderMintStart + 24 hours;
2782         proxyRegistryAddress = _proxyRegistryAddress;
2783         provable_setCustomGasPrice(gasPrice);
2784     }
2785 
2786     function mintGlitch(uint sireId, uint baseId, address baseContract) public payable nonReentrant whenStandardMinting{
2787         Stats memory sireStats = nftStats[sireId];
2788         require(sireStats.siringFee==msg.value,"Eth sent must be equal to the siring fee of the selected sire.");
2789         require(now.max(sireStats.siringTimer)==now,"Sire must be available.");
2790         require(allowedBaseContracts[baseContract],"Token must be from participating NFT contract.");
2791         require(IERC721(baseContract).ownerOf(baseId)==msg.sender,"You must own the base token to mint a glitch for it.");
2792         require(baseAddressTokenIdToMetaGlitch[baseContract][baseId]==0,"Base NFT must not be currently glitched."); //Note: this theoretically allows 1 double glitch for metaglitch 0, but reduced cost is an acceptable tradeof.
2793 
2794         baseAddressTokenIdToMetaGlitch[baseContract][baseId] = _currentTokenId;
2795 
2796         sireStats.siringTimer = now.add(uint(sireStats.speed).mul(1 hours));
2797         uint siringFee = sireStats.siringTimer;
2798         sireStats.siringFee = GetNextSiringFee(sireId);
2799         nftStats[sireId] = sireStats;
2800         
2801         emit LogSired(sireId);
2802 
2803         bytes32 queryId = provable_newRandomDSQuery(
2804             0, //Execution delay
2805             NUM_RANDOM_BYTES_REQUESTED,
2806             gasAmount
2807         );
2808         provableQueryToMintingData[queryId] = MintingData({
2809             baseId: baseId,
2810             sireId: sireId,
2811             tokenId: _currentTokenId,
2812             baseContract: baseContract,
2813             minter: msg.sender
2814         });
2815 
2816         _currentTokenId = _currentTokenId.add(1);
2817 
2818         address(uint160(ownerOf(sireId)))
2819             .transfer(GetAmountFromBasisPoints(siringFee,sireRewardBP));
2820     }
2821 
2822     function mintFounderGlitch(uint metaGlitchId, uint baseId, address baseContract) public payable whenFounderMinting{
2823         require(msg.value==mintFeeStart,"Eth sent must be the base mint fee.");
2824         require(allowedBaseContracts[baseContract],"Token must be from participating NFT contract.");
2825         require(IERC721(baseContract).ownerOf(baseId)==msg.sender,"You must own the base token to mint a glitch for it.");
2826         require(founderMintReservation[metaGlitchId]==msg.sender,"Token ID must be reserved for sender.");
2827         require(baseAddressTokenIdToMetaGlitch[baseContract][baseId]==0,"Base NFT must not be currently glitched."); //Note: this theoretically allows 1 double glitch for metaglitch 0, but reduced cost is an acceptable tradeof.
2828 
2829         baseAddressTokenIdToMetaGlitch[baseContract][baseId] = metaGlitchId;
2830         
2831         bytes32 queryId = provable_newRandomDSQuery(
2832             0, //Execution delay
2833             NUM_RANDOM_BYTES_REQUESTED,
2834             gasAmount
2835         );
2836         provableQueryToMintingData[queryId] = MintingData({
2837             baseId: baseId,
2838             sireId: foundersSireId,
2839             tokenId: metaGlitchId,
2840             baseContract: baseContract,
2841             minter: msg.sender
2842         });
2843 
2844         delete founderMintReservation[metaGlitchId];
2845     }
2846 
2847     function changeBase(uint metaGlitchId, uint baseId, address baseContract) public {
2848         require(ownerOf(metaGlitchId)==msg.sender,"Sender most own the MetaGlitch token.");
2849         require(allowedBaseContracts[baseContract],"Base token must be from participating NFT contract.");
2850         require(IERC721(baseContract).ownerOf(baseId)==msg.sender,"Sender must own the base token to mint a glitch for it.");
2851         require(baseAddressTokenIdToMetaGlitch[baseContract][baseId]==0,"Base NFT must not be currently glitched."); //Note: this theoretically allows 1 double glitch for metaglitch 0, but reduced cost is an acceptable tradeof.
2852         Stats memory metaglitchStats = nftStats[metaGlitchId];
2853         
2854         //remove old base contract+ids
2855         delete baseAddressTokenIdToMetaGlitch[metaglitchStats.baseContract][metaglitchStats.baseId];
2856         
2857         baseAddressTokenIdToMetaGlitch[baseContract][baseId] = metaGlitchId;
2858         metaglitchStats.baseContract = baseContract;
2859         metaglitchStats.baseId = baseId;
2860         nftStats[metaGlitchId] = metaglitchStats;
2861         
2862         emit LogBaseChange(metaGlitchId);
2863     }
2864     function unsetBase(uint metaGlitchId) public {
2865         Stats memory stats = nftStats[metaGlitchId];
2866         require(ownerOf(metaGlitchId)!=IERC721(stats.baseContract).ownerOf(stats.baseId),"MetaGlitch owner must not own the base NFT.");
2867         delete baseAddressTokenIdToMetaGlitch[stats.baseContract][stats.baseId];
2868         stats.baseContract = address(0x0);
2869         stats.baseId = 0;
2870         nftStats[metaGlitchId] = stats;
2871     }
2872 
2873     function onlyEthereal_adjustOracleGas(uint newGasPrice, uint newGasAmount) public onlyEthereal{
2874         gasPrice = newGasPrice;
2875         provable_setCustomGasPrice(gasPrice);
2876         gasAmount = newGasAmount;
2877     }
2878     function onlyEthereal_changeBaseURI(string memory newURI) public onlyEthereal{
2879         _tokenURI = newURI;
2880     }
2881     function onlyEthereal_assignFounderMintReservation(address founder, uint[] memory ids) public onlyEthereal{
2882         for(uint i = 0; i<ids.length; i++)
2883             founderMintReservation[ids[i]] = founder;
2884     }
2885     function onlyEthereal_toggleBaseContract(address baseContract) public onlyEthereal{
2886         allowedBaseContracts[baseContract] = !allowedBaseContracts[baseContract];
2887     }
2888     function onlyEthereal_withdrawEth(uint weiAmt) public onlyEthereal{
2889         ethereal.transfer(weiAmt);
2890     }
2891 
2892     /**
2893      * Provable callback for minting
2894      */
2895     function __callback(
2896         bytes32 queryId,
2897         string memory _result
2898     ) public {
2899         require(msg.sender == provable_cbAddress(),"Callback can only come from Provable.");
2900 
2901         MintingData memory mintingData = provableQueryToMintingData[queryId];
2902 
2903         Stats memory sire;
2904         if(mintingData.sireId == foundersSireId){
2905             sire.mutability = mutabilityMax;
2906             sire.speed = speedMin;
2907             sire.glitchCount = glitchCountMax;
2908         }else{
2909             sire = nftStats[mintingData.sireId];
2910         }
2911 
2912         uint randStats = uint(
2913                 keccak256(abi.encodePacked(_result)) ^ blockhash(block.number-1)
2914             );
2915 
2916         uint[4] memory glitchIds;
2917         Stats memory metaglitchStats = Stats({
2918             speed: GetNewVal(sire.speed, speedMin, speedMax, sire.mutability, uint8(randStats)),
2919             mutability: GetNewVal(sire.mutability, mutabilityMin, mutabilityMax, sire.mutability, uint8(randStats>>8)),
2920             siringTimer: 0,
2921             siringFee: mintFeeStart,
2922             sireId: mintingData.sireId,
2923             baseId: mintingData.baseId,
2924             baseContract: mintingData.baseContract,
2925             glitchCount: GetNewVal(sire.glitchCount, glitchCountMin, glitchCountMax, sire.mutability, uint8(randStats>>16)),
2926             generation: mintingData.sireId == foundersSireId ? 0 : sire.generation.add(1),
2927             glitchIds: glitchIds
2928         });
2929         
2930         
2931 
2932         uint randGlitch = randStats ^ uint(blockhash(block.number-2)); //max 32 uint8 or 8 glitch properties
2933 
2934         for(uint i; i<metaglitchStats.glitchCount; i++){
2935             Glitch memory sireGlitch = glitches[sire.glitchIds[i]];
2936             Glitch memory glitch = Glitch({
2937                 delay: GetNewVal(sireGlitch.delay, delayMin, delayMax, sire.mutability, GetOffsetAtIndexUint8(0, i, randGlitch)),
2938                 seed: GetNewVal(sireGlitch.seed, seedMin, seedMax, sire.mutability, GetOffsetAtIndexUint8(1, i, randGlitch)),
2939                 quantity: GetNewVal(sireGlitch.quantity, quantityMin, quantityMax, sire.mutability, GetOffsetAtIndexUint8(2, i, randGlitch)),
2940                 timescale: GetNewVal(sireGlitch.timescale, timescaleMin, timescaleMax, sire.mutability, GetOffsetAtIndexUint8(3, i, randGlitch)),
2941                 sizeW: GetNewVal(sireGlitch.sizeW, sizeMin, sizeMax, sire.mutability, GetOffsetAtIndexUint8(4, i, randGlitch)),
2942                 sizeH: GetNewVal(sireGlitch.sizeH, sizeMin, sizeMax, sire.mutability, GetOffsetAtIndexUint8(5, i, randGlitch)),
2943                 posX: GetNewVal(sireGlitch.posX, posMin, posMax, sire.mutability, GetOffsetAtIndexUint8(6, i, randGlitch)),
2944                 posY: GetNewVal(sireGlitch.posY, posMin, posMax, sire.mutability, GetOffsetAtIndexUint8(7, i, randGlitch))
2945             });
2946             if(uint(glitch.sizeW) * uint(glitch.sizeH) < minArea){
2947                 if(glitch.sizeW > glitch.sizeH){
2948                     glitch.sizeW = uint8(minArea / glitch.sizeH);
2949                 }else{
2950                     glitch.sizeH = uint8(minArea / glitch.sizeW) ;
2951                 }
2952             }
2953             if(uint(glitch.posX) + uint(glitch.sizeW) > sizeMax)
2954                 glitch.posX = sizeMax - glitch.sizeW;
2955             if(uint(glitch.posY) + uint(glitch.sizeH) > sizeMax)
2956                 glitch.posY = sizeMax - glitch.sizeH;
2957 
2958             metaglitchStats.glitchIds[i] = _currentGlitchId;
2959             glitches[_currentGlitchId] = glitch;
2960             _currentGlitchId = _currentGlitchId.add(1);
2961         }
2962         
2963         nftStats[mintingData.tokenId] = metaglitchStats;
2964         
2965         _safeMint(mintingData.minter, mintingData.tokenId);
2966 
2967         delete provableQueryToMintingData[queryId];
2968     }
2969 
2970     /**
2971    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
2972    */
2973   function isApprovedForAll(
2974     address owner,
2975     address operator
2976   )
2977     public
2978     view
2979     returns (bool)
2980   {
2981     // Whitelist OpenSea proxy contract for easy trading.
2982     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
2983     if (address(proxyRegistry.proxies(owner)) == operator) {
2984         return true;
2985     }
2986 
2987     return super.isApprovedForAll(owner, operator);
2988   }
2989 
2990 
2991     function tokenURI(uint metaGlitchId) external view returns(string memory){
2992         return strConcat(_tokenURI,uint2str(metaGlitchId));
2993     }
2994 
2995     //MetaGlitch Utilities
2996     function GetGlitchID(uint tokenId, uint8 index) external view returns(uint){
2997         return nftStats[tokenId].glitchIds[index];
2998     }
2999     
3000     function GetNextSiringFee(uint sireId) internal view returns (uint) {
3001         Stats memory stats = nftStats[sireId];
3002         return stats.siringFee.add(
3003             GetAmountFromBasisPoints(
3004                 stats.siringFee,
3005                 mintFeeIncrementBP
3006             )
3007             ).add(
3008                 mintFeeIncrementBase
3009             );
3010     }
3011     function GetNewVal(uint8 valSire, uint8 valMin, uint8 valMax, uint8 mutability, uint8 roll) internal pure returns (uint8) {
3012         uint valSireStablized = uint(valSire).mul(10);
3013         uint rand = uint(roll % (valMax+1));
3014         uint8 val = uint8(
3015                         rand
3016                         .mul(uint(mutability))
3017                         .add(valSireStablized)
3018                         .div(uint(mutability+10))
3019                     );
3020         if(val<valMin)
3021             val = valMin;
3022         if(val>valMax)
3023             val = valMax;
3024         return val;
3025     }
3026 
3027     //Generic Utilities
3028     function GetAmountFromBasisPoints(uint amt, uint bp) internal pure returns (uint) {
3029         return amt.mul(bp).div(BASIS_POINTS);
3030     }
3031     function GetOffsetAtIndexUint8(uint8 bytesOffset, uint index, uint source) internal pure returns (uint8) {
3032         return uint8(source>>uint(bytesOffset).add(index.mul(8)).mul(8));
3033     }
3034 }