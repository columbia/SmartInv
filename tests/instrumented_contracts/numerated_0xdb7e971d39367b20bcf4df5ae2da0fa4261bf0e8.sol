1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Collection of functions related to the address type,
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * This test is non-exhaustive, and there may be false-negatives: during the
11      * execution of a contract's constructor, its address will be reported as
12      * not containing a contract.
13      *
14      * > It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      */
17     function isContract(address account) internal view returns (bool) {
18         // This method relies in extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 }
28 pragma solidity ^0.5.0;
29 
30 /**
31  * @dev Wrappers over Solidity's arithmetic operations with added overflow
32  * checks.
33  *
34  * Arithmetic operations in Solidity wrap on overflow. This can easily result
35  * in bugs, because programmers usually assume that an overflow raises an
36  * error, which is the standard behavior in high level programming languages.
37  * `SafeMath` restores this intuition by reverting the transaction when an
38  * operation overflows.
39  *
40  * Using this library instead of the unchecked operations eliminates an entire
41  * class of bugs, so it's recommended to use it always.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting on
46      * overflow.
47      *
48      * Counterpart to Solidity's `+` operator.
49      *
50      * Requirements:
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a, "SafeMath: subtraction overflow");
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers. Reverts on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator. Note: this function uses a
104      * `revert` opcode (which leaves remaining gas untouched) while Solidity
105      * uses an invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Solidity only automatically asserts when dividing by 0
112         require(b > 0, "SafeMath: division by zero");
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
121      * Reverts when dividing by zero.
122      *
123      * Counterpart to Solidity's `%` operator. This function uses a `revert`
124      * opcode (which leaves remaining gas untouched) while Solidity uses an
125      * invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b != 0, "SafeMath: modulo by zero");
132         return a % b;
133     }
134 }
135 
136 pragma solidity ^0.5.0;
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * This module is used through inheritance. It will make available the modifier
144  * `onlyOwner`, which can be aplied to your functions to restrict their use to
145  * the owner.
146  */
147 contract Ownable {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor () internal {
156         _owner = msg.sender;
157         emit OwnershipTransferred(address(0), _owner);
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(isOwner(), "Ownable: caller is not the owner");
172         _;
173     }
174 
175     /**
176      * @dev Returns true if the caller is the current owner.
177      */
178     function isOwner() public view returns (bool) {
179         return msg.sender == _owner;
180     }
181 
182     /**
183      * @dev Leaves the contract without owner. It will not be possible to call
184      * `onlyOwner` functions anymore. Can only be called by the current owner.
185      *
186      * > Note: Renouncing ownership will leave the contract without an owner,
187      * thereby removing any functionality that is only available to the owner.
188      */
189     function renounceOwnership() public onlyOwner {
190         emit OwnershipTransferred(_owner, address(0));
191         _owner = address(0);
192     }
193 
194     /**
195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
196      * Can only be called by the current owner.
197      */
198     function transferOwnership(address newOwner) public onlyOwner {
199         _transferOwnership(newOwner);
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      */
205     function _transferOwnership(address newOwner) internal {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         emit OwnershipTransferred(_owner, newOwner);
208         _owner = newOwner;
209     }
210 }
211 
212 pragma solidity ^0.5.0;
213 
214 
215 /**
216  * @title Counters
217  * @author Matt Condon (@shrugs)
218  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
219  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
220  *
221  * Include with `using Counters for Counters.Counter;`
222  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
223  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
224  * directly accessed.
225  */
226 library Counters {
227     using SafeMath for uint256;
228 
229     struct Counter {
230         // This variable should never be directly accessed by users of the library: interactions must be restricted to
231         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
232         // this feature: see https://github.com/ethereum/solidity/issues/4637
233         uint256 _value; // default: 0
234     }
235 
236     function current(Counter storage counter) internal view returns (uint256) {
237         return counter._value;
238     }
239 
240     function increment(Counter storage counter) internal {
241         counter._value += 1;
242     }
243 
244     function decrement(Counter storage counter) internal {
245         counter._value = counter._value.sub(1);
246     }
247 }
248 
249 pragma solidity ^0.5.0;
250 
251 /**
252  * @dev Interface of the ERC165 standard, as defined in the
253  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
254  *
255  * Implementers can declare support of contract interfaces, which can then be
256  * queried by others (`ERC165Checker`).
257  *
258  * For an implementation, see `ERC165`.
259  */
260 interface IERC165 {
261     /**
262      * @dev Returns true if this contract implements the interface defined by
263      * `interfaceId`. See the corresponding
264      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
265      * to learn more about how these ids are created.
266      *
267      * This function call must use less than 30 000 gas.
268      */
269     function supportsInterface(bytes4 interfaceId) external view returns (bool);
270 }
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @title ERC721 token receiver interface
275  * @dev Interface for any contract that wants to support safeTransfers
276  * from ERC721 asset contracts.
277  */
278 interface DGXinterface {
279   /// @dev read transfer configurations
280 /// @return {
281 ///   "_base": "denominator for calculating transfer fees",
282 ///   "_rate": "numerator for calculating transfer fees",
283 ///   "_collector": "the ethereum address of the transfer fees collector",
284 ///   "_no_transfer_fee": "true if transfer fees is turned off globally",
285 ///   "_minimum_transfer_amount": "minimum amount of DGX that can be transferred"
286 /// }
287 function showTransferConfigs()
288  external
289   returns (uint256 _base, uint256 _rate, address _collector, bool _no_transfer_fee, uint256 _minimum_transfer_amount);
290   /// @dev read the demurrage configurations
291 /// @return {
292 ///   "_base": "denominator for calculating demurrage fees",
293 ///   "_rate": "numerator for calculating demurrage fees",
294 ///   "_collector": "ethereum address of the demurrage fees collector"
295 ///   "_no_demurrage_fee": "true if demurrage fees is turned off globally"
296 /// }
297 function showDemurrageConfigs()
298   external
299   returns (uint256 _base, uint256 _rate, address _collector, bool _no_demurrage_fee);
300       /**
301      * @dev Returns the amount of tokens in existence.
302      */
303     function totalSupply() external view returns (uint256);
304 
305     /**
306      * @dev Returns the amount of tokens owned by `account`.
307      */
308     function balanceOf(address account) external view returns (uint256);
309 
310     /**
311      * @dev Moves `amount` tokens from the caller's account to `recipient`.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a `Transfer` event.
316      */
317     function transfer(address recipient, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Returns the remaining number of tokens that `spender` will be
321      * allowed to spend on behalf of `owner` through `transferFrom`. This is
322      * zero by default.
323      *
324      * This value changes when `approve` or `transferFrom` are called.
325      */
326     function allowance(address owner, address spender) external view returns (uint256);
327 
328     /**
329      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * > Beware that changing an allowance with this method brings the risk
334      * that someone may use both the old and the new allowance by unfortunate
335      * transaction ordering. One possible solution to mitigate this race
336      * condition is to first reduce the spender's allowance to 0 and set the
337      * desired value afterwards:
338      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
339      *
340      * Emits an `Approval` event.
341      */
342     function approve(address spender, uint256 amount) external returns (bool);
343 
344     /**
345      * @dev Moves `amount` tokens from `sender` to `recipient` using the
346      * allowance mechanism. `amount` is then deducted from the caller's
347      * allowance.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a `Transfer` event.
352      */
353     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
354     
355     /**
356      @dev Returns the user data for an account
357      * Specifically calling this to get the last time of transfer to calculate demurrage fees
358      * 
359      *
360      * Returns bool _exists,
361      * Returns uint256 _raw_balance,
362      * Returns uint256 _payment_date,
363      * Returns bool _no_demurrage_fee,
364      * Returns bool _no_recast_fee,
365      * Returns bool _no_transfer_fee
366      *
367      * Emits a `Transfer` event.
368      **/
369 function read_user(address _account)
370         external
371     returns (
372         bool _exists,
373         uint256 _raw_balance,
374         uint256 _payment_date,
375         bool _no_demurrage_fee,
376         bool _no_recast_fee,
377         bool _no_transfer_fee
378     );
379 
380     /**
381      * @dev Emitted when `value` tokens are moved from one account (`from`) to
382      * another (`to`).
383      *
384      * Note that `value` may be zero.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     /**
389      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
390      * a call to `approve`. `value` is the new allowance.
391      */
392     event Approval(address indexed owner, address indexed spender, uint256 value);
393 }
394 pragma solidity ^0.5.0;
395 
396 
397 /**
398  * @dev Implementation of the `IERC165` interface.
399  *
400  * Contracts may inherit from this and call `_registerInterface` to declare
401  * their support of an interface.
402  */
403 contract ERC165 is IERC165 {
404     /*
405      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
406      */
407     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
408 
409     /**
410      * @dev Mapping of interface ids to whether or not it's supported.
411      */
412     mapping(bytes4 => bool) private _supportedInterfaces;
413 
414     constructor () internal {
415         // Derived contracts need only register support for their own interfaces,
416         // we register support for ERC165 itself here
417         _registerInterface(_INTERFACE_ID_ERC165);
418     }
419 
420     /**
421      * @dev See `IERC165.supportsInterface`.
422      *
423      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
424      */
425     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
426         return _supportedInterfaces[interfaceId];
427     }
428 
429     /**
430      * @dev Registers the contract as an implementer of the interface defined by
431      * `interfaceId`. Support of the actual ERC165 interface is automatic and
432      * registering its interface id is not required.
433      *
434      * See `IERC165.supportsInterface`.
435      *
436      * Requirements:
437      *
438      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
439      */
440     function _registerInterface(bytes4 interfaceId) internal {
441         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
442         _supportedInterfaces[interfaceId] = true;
443     }
444 }
445 pragma solidity ^0.5.0;
446 
447 
448 /**
449  * @dev Required interface of an ERC721 compliant contract.
450  */
451 contract IERC721 is IERC165 {
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of NFTs in `owner`'s account.
458      */
459     function balanceOf(address owner) public view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the NFT specified by `tokenId`.
463      */
464     function ownerOf(uint256 tokenId) public view returns (address owner);
465 
466     /**
467      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
468      * another (`to`).
469      *
470      * 
471      *
472      * Requirements:
473      * - `from`, `to` cannot be zero.
474      * - `tokenId` must be owned by `from`.
475      * - If the caller is not `from`, it must be have been allowed to move this
476      * NFT by either `approve` or `setApproveForAll`.
477      */
478     function safeTransferFrom(address from, address to, uint256 tokenId) public;
479     /**
480      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
481      * another (`to`).
482      *
483      * Requirements:
484      * - If the caller is not `from`, it must be approved to move this NFT by
485      * either `approve` or `setApproveForAll`.
486      */
487     function transferFrom(address from, address to, uint256 tokenId) public;
488     function approve(address to, uint256 tokenId) public;
489     function getApproved(uint256 tokenId) public view returns (address operator);
490 
491     function setApprovalForAll(address operator, bool _approved) public;
492     function isApprovedForAll(address owner, address operator) public view returns (bool);
493 
494 
495     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
496 }
497 pragma solidity ^0.5.0;
498 
499 /**
500  * @title ERC721 token receiver interface
501  * @dev Interface for any contract that wants to support safeTransfers
502  * from ERC721 asset contracts.
503  */
504 contract IERC721Receiver {
505     /**
506      * @notice Handle the receipt of an NFT
507      * @dev The ERC721 smart contract calls this function on the recipient
508      * after a `safeTransfer`. This function MUST return the function selector,
509      * otherwise the caller will revert the transaction. The selector to be
510      * returned can be obtained as `this.onERC721Received.selector`. This
511      * function MAY throw to revert and reject the transfer.
512      * Note: the ERC721 contract address is always the message sender.
513      * @param operator The address which called `safeTransferFrom` function
514      * @param from The address which previously owned the token
515      * @param tokenId The NFT identifier which is being transferred
516      * @param data Additional data with no specified format
517      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
518      */
519     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
520     public returns (bytes4);
521 }
522 pragma solidity ^0.5.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 contract IERC721Enumerable is IERC721 {
530     function totalSupply() public view returns (uint256);
531     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
532 
533     function tokenByIndex(uint256 index) public view returns (uint256);
534 }
535 
536 pragma solidity ^0.5.0;
537 
538 /**
539  * @title ERC721 Non-Fungible Token Standard basic implementation
540  * @dev see https://eips.ethereum.org/EIPS/eip-721
541  */
542 contract ERC721 is ERC165, IERC721 {
543     using SafeMath for uint256;
544     using Address for address;
545     using Counters for Counters.Counter;
546 
547     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
548     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
549     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
550 
551     // Mapping from token ID to owner
552     mapping (uint256 => address) private _tokenOwner;
553 
554     // Mapping from token ID to approved address
555     mapping (uint256 => address) private _tokenApprovals;
556 
557     // Mapping from owner to number of owned token
558     mapping (address => Counters.Counter) private _ownedTokensCount;
559 
560     // Mapping from owner to operator approvals
561     mapping (address => mapping (address => bool)) private _operatorApprovals;
562 
563     /*
564      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
565      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
566      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
567      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
568      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
569      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
570      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
571      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
572      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
573      *
574      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
575      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
576      */
577     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
578 
579     constructor () public {
580         // register the supported interfaces to conform to ERC721 via ERC165
581         _registerInterface(_INTERFACE_ID_ERC721);
582     }
583 
584     /**
585      * @dev Gets the balance of the specified address.
586      * @param owner address to query the balance of
587      * @return uint256 representing the amount owned by the passed address
588      */
589     function balanceOf(address owner) public view returns (uint256) {
590         require(owner != address(0), "ERC721: balance query for the zero address");
591 
592         return _ownedTokensCount[owner].current();
593     }
594 
595     /**
596      * @dev Gets the owner of the specified token ID.
597      * @param tokenId uint256 ID of the token to query the owner of
598      * @return address currently marked as the owner of the given token ID
599      */
600     function ownerOf(uint256 tokenId) public view returns (address) {
601         address owner = _tokenOwner[tokenId];
602         require(owner != address(0), "ERC721: owner query for nonexistent token");
603 
604         return owner;
605     }
606 
607     /**
608      * @dev Approves another address to transfer the given token ID
609      * The zero address indicates there is no approved address.
610      * There can only be one approved address per token at a given time.
611      * Can only be called by the token owner or an approved operator.
612      * @param to address to be approved for the given token ID
613      * @param tokenId uint256 ID of the token to be approved
614      */
615     function approve(address to, uint256 tokenId) public {
616         address owner = ownerOf(tokenId);
617         require(to != owner, "ERC721: approval to current owner");
618 
619         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
620             "ERC721: approve caller is not owner nor approved for all"
621         );
622 
623         _tokenApprovals[tokenId] = to;
624         emit Approval(owner, to, tokenId);
625     }
626 
627     /**
628      * @dev Gets the approved address for a token ID, or zero if no address set
629      * Reverts if the token ID does not exist.
630      * @param tokenId uint256 ID of the token to query the approval of
631      * @return address currently approved for the given token ID
632      */
633     function getApproved(uint256 tokenId) public view returns (address) {
634         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
635 
636         return _tokenApprovals[tokenId];
637     }
638 
639     /**
640      * @dev Sets or unsets the approval of a given operator
641      * An operator is allowed to transfer all tokens of the sender on their behalf.
642      * @param to operator address to set the approval
643      * @param approved representing the status of the approval to be set
644      */
645     function setApprovalForAll(address to, bool approved) public {
646         require(to != msg.sender, "ERC721: approve to caller");
647 
648         _operatorApprovals[msg.sender][to] = approved;
649         emit ApprovalForAll(msg.sender, to, approved);
650     }
651 
652     /**
653      * @dev Tells whether an operator is approved by a given owner.
654      * @param owner owner address which you want to query the approval of
655      * @param operator operator address which you want to query the approval of
656      * @return bool whether the given operator is approved by the given owner
657      */
658     function isApprovedForAll(address owner, address operator) public view returns (bool) {
659         return _operatorApprovals[owner][operator];
660     }
661 
662     /**
663      * @dev Transfers the ownership of a given token ID to another address.
664      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
665      * Requires the msg.sender to be the owner, approved, or operator.
666      * @param from current owner of the token
667      * @param to address to receive the ownership of the given token ID
668      * @param tokenId uint256 ID of the token to be transferred
669      */
670     function transferFrom(address from, address to, uint256 tokenId) public {
671         //solhint-disable-next-line max-line-length
672         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
673 
674         _transferFrom(from, to, tokenId);
675     }
676 
677     /**
678      * @dev Safely transfers the ownership of a given token ID to another address
679      * If the target address is a contract, it must implement `onERC721Received`,
680      * which is called upon a safe transfer, and return the magic value
681      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
682      * the transfer is reverted.
683      * Requires the msg.sender to be the owner, approved, or operator
684      * @param from current owner of the token
685      * @param to address to receive the ownership of the given token ID
686      * @param tokenId uint256 ID of the token to be transferred
687      */
688     function safeTransferFrom(address from, address to, uint256 tokenId) public {
689         safeTransferFrom(from, to, tokenId, "");
690     }
691 
692     /**
693      * @dev Safely transfers the ownership of a given token ID to another address
694      * If the target address is a contract, it must implement `onERC721Received`,
695      * which is called upon a safe transfer, and return the magic value
696      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
697      * the transfer is reverted.
698      * Requires the msg.sender to be the owner, approved, or operator
699      * @param from current owner of the token
700      * @param to address to receive the ownership of the given token ID
701      * @param tokenId uint256 ID of the token to be transferred
702      * @param _data bytes data to send along with a safe transfer check
703      */
704     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
705         transferFrom(from, to, tokenId);
706         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
707     }
708 
709     /**
710      * @dev Returns whether the specified token exists.
711      * @param tokenId uint256 ID of the token to query the existence of
712      * @return bool whether the token exists
713      */
714     function _exists(uint256 tokenId) internal view returns (bool) {
715         address owner = _tokenOwner[tokenId];
716         return owner != address(0);
717     }
718 
719     /**
720      * @dev Returns whether the given spender can transfer a given token ID.
721      * @param spender address of the spender to query
722      * @param tokenId uint256 ID of the token to be transferred
723      * @return bool whether the msg.sender is approved for the given token ID,
724      * is an operator of the owner, or is the owner of the token
725      */
726     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
727         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
728         address owner = ownerOf(tokenId);
729         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
730     }
731 
732     /**
733      * @dev Internal function to mint a new token.
734      * Reverts if the given token ID already exists.
735      * @param to The address that will own the minted token
736      * @param tokenId uint256 ID of the token to be minted
737      */
738     function _mint(address to, uint256 tokenId) internal {
739         require(to != address(0), "ERC721: mint to the zero address");
740         require(!_exists(tokenId), "ERC721: token already minted");
741 
742         _tokenOwner[tokenId] = to;
743         _ownedTokensCount[to].increment();
744 
745         emit Transfer(address(0), to, tokenId);
746     }
747 
748     /**
749      * @dev Internal function to burn a specific token.
750      * Reverts if the token does not exist.
751      * Deprecated, use _burn(uint256) instead.
752      * @param owner owner of the token to burn
753      * @param tokenId uint256 ID of the token being burned
754      */
755     function _burn(address owner, uint256 tokenId) internal {
756         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
757 
758         _clearApproval(tokenId);
759 
760         _ownedTokensCount[owner].decrement();
761         _tokenOwner[tokenId] = address(0);
762 
763         emit Transfer(owner, address(0), tokenId);
764     }
765 
766     /**
767      * @dev Internal function to burn a specific token.
768      * Reverts if the token does not exist.
769      * @param tokenId uint256 ID of the token being burned
770      */
771     function _burn(uint256 tokenId) internal {
772         _burn(ownerOf(tokenId), tokenId);
773     }
774 
775     /**
776      * @dev Internal function to transfer ownership of a given token ID to another address.
777      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
778      * @param from current owner of the token
779      * @param to address to receive the ownership of the given token ID
780      * @param tokenId uint256 ID of the token to be transferred
781      */
782     function _transferFrom(address from, address to, uint256 tokenId) internal {
783         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
784         require(to != address(0), "ERC721: transfer to the zero address");
785 
786         _clearApproval(tokenId);
787 
788         _ownedTokensCount[from].decrement();
789         _ownedTokensCount[to].increment();
790 
791         _tokenOwner[tokenId] = to;
792 
793         emit Transfer(from, to, tokenId);
794     }
795 
796     /**
797      * @dev Internal function to invoke `onERC721Received` on a target address.
798      * The call is not executed if the target address is not a contract.
799      *
800      * This function is deprecated.
801      * @param from address representing the previous owner of the given token ID
802      * @param to target address that will receive the tokens
803      * @param tokenId uint256 ID of the token to be transferred
804      * @param _data bytes optional data to send along with the call
805      * @return bool whether the call correctly returned the expected magic value
806      */
807     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
808         internal returns (bool)
809     {
810         if (!to.isContract()) {
811             return true;
812         }
813 
814         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
815         return (retval == _ERC721_RECEIVED);
816     }
817 
818     /**
819      * @dev Private function to clear current approval of a given token ID.
820      * @param tokenId uint256 ID of the token to be transferred
821      */
822     function _clearApproval(uint256 tokenId) private {
823         if (_tokenApprovals[tokenId] != address(0)) {
824             _tokenApprovals[tokenId] = address(0);
825         }
826     }
827 }
828 
829 pragma solidity ^0.5.0;
830 
831 
832 /**
833  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
834  * @dev See https://eips.ethereum.org/EIPS/eip-721
835  */
836 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
837     // Mapping from owner to list of owned token IDs
838     mapping(address => uint256[]) private _ownedTokens;
839 
840     // Mapping from token ID to index of the owner tokens list
841     mapping(uint256 => uint256) private _ownedTokensIndex;
842 
843     // Array with all token ids, used for enumeration
844     uint256[] private _allTokens;
845 
846     // Mapping from token id to position in the allTokens array
847     mapping(uint256 => uint256) private _allTokensIndex;
848 
849     /*
850      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
851      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
852      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
853      *
854      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
855      */
856     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
857 
858     /**
859      * @dev Constructor function.
860      */
861     constructor () public {
862         // register the supported interface to conform to ERC721Enumerable via ERC165
863         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
864     }
865 
866     /**
867      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
868      * @param owner address owning the tokens list to be accessed
869      * @param index uint256 representing the index to be accessed of the requested tokens list
870      * @return uint256 token ID at the given index of the tokens list owned by the requested address
871      */
872     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
873         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
874         return _ownedTokens[owner][index];
875     }
876 
877     /**
878      * @dev Gets the total amount of tokens stored by the contract.
879      * @return uint256 representing the total amount of tokens
880      */
881     function totalSupply() public view returns (uint256) {
882         return _allTokens.length;
883     }
884 
885     /**
886      * @dev Gets the token ID at a given index of all the tokens in this contract
887      * Reverts if the index is greater or equal to the total number of tokens.
888      * @param index uint256 representing the index to be accessed of the tokens list
889      * @return uint256 token ID at the given index of the tokens list
890      */
891     function tokenByIndex(uint256 index) public view returns (uint256) {
892         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
893         return _allTokens[index];
894     }
895 
896     /**
897      * @dev Internal function to transfer ownership of a given token ID to another address.
898      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
899      * @param from current owner of the token
900      * @param to address to receive the ownership of the given token ID
901      * @param tokenId uint256 ID of the token to be transferred
902      */
903     function _transferFrom(address from, address to, uint256 tokenId) internal {
904         super._transferFrom(from, to, tokenId);
905 
906         _removeTokenFromOwnerEnumeration(from, tokenId);
907 
908         _addTokenToOwnerEnumeration(to, tokenId);
909     }
910 
911     /**
912      * @dev Internal function to mint a new token.
913      * Reverts if the given token ID already exists.
914      * @param to address the beneficiary that will own the minted token
915      * @param tokenId uint256 ID of the token to be minted
916      */
917     function _mint(address to, uint256 tokenId) internal {
918         super._mint(to, tokenId);
919 
920         _addTokenToOwnerEnumeration(to, tokenId);
921 
922         _addTokenToAllTokensEnumeration(tokenId);
923     }
924 
925     /**
926      * @dev Internal function to burn a specific token.
927      * Reverts if the token does not exist.
928      * Deprecated, use _burn(uint256) instead.
929      * @param owner owner of the token to burn
930      * @param tokenId uint256 ID of the token being burned
931      */
932     function _burn(address owner, uint256 tokenId) internal {
933         super._burn(owner, tokenId);
934 
935         _removeTokenFromOwnerEnumeration(owner, tokenId);
936         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
937         _ownedTokensIndex[tokenId] = 0;
938 
939         _removeTokenFromAllTokensEnumeration(tokenId);
940     }
941 
942     /**
943      * @dev Gets the list of token IDs of the requested owner.
944      * @param owner address owning the tokens
945      * @return uint256[] List of token IDs owned by the requested address
946      */
947     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
948         return _ownedTokens[owner];
949     }
950 
951     /**
952      * @dev Private function to add a token to this extension's ownership-tracking data structures.
953      * @param to address representing the new owner of the given token ID
954      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
955      */
956     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
957         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
958         _ownedTokens[to].push(tokenId);
959     }
960 
961     /**
962      * @dev Private function to add a token to this extension's token tracking data structures.
963      * @param tokenId uint256 ID of the token to be added to the tokens list
964      */
965     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
966         _allTokensIndex[tokenId] = _allTokens.length;
967         _allTokens.push(tokenId);
968     }
969 
970     /**
971      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
972      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
973      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
974      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
975      * @param from address representing the previous owner of the given token ID
976      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
977      */
978     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
979         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
980         // then delete the last slot (swap and pop).
981 
982         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
983         uint256 tokenIndex = _ownedTokensIndex[tokenId];
984 
985         // When the token to delete is the last token, the swap operation is unnecessary
986         if (tokenIndex != lastTokenIndex) {
987             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
988 
989             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
990             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
991         }
992 
993         // This also deletes the contents at the last position of the array
994         _ownedTokens[from].length--;
995 
996         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
997         // lastTokenId, or just over the end of the array if the token was the last one).
998     }
999 
1000     /**
1001      * @dev Private function to remove a token from this extension's token tracking data structures.
1002      * This has O(1) time complexity, but alters the order of the _allTokens array.
1003      * @param tokenId uint256 ID of the token to be removed from the tokens list
1004      */
1005     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1006         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1007         // then delete the last slot (swap and pop).
1008 
1009         uint256 lastTokenIndex = _allTokens.length.sub(1);
1010         uint256 tokenIndex = _allTokensIndex[tokenId];
1011 
1012         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1013         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1014         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1015         uint256 lastTokenId = _allTokens[lastTokenIndex];
1016 
1017         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1018         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1019 
1020         // This also deletes the contents at the last position of the array
1021         _allTokens.length--;
1022         _allTokensIndex[tokenId] = 0;
1023     }
1024 }
1025 
1026 pragma solidity ^0.5.0;
1027 
1028 
1029 /**
1030  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1031  * @dev See https://eips.ethereum.org/EIPS/eip-721
1032  */
1033 contract IERC721Metadata is IERC721 {
1034     function name() external view returns (string memory);
1035     function symbol() external view returns (string memory);
1036     function tokenURI(uint256 tokenId) external view returns (string memory);
1037 }
1038 pragma solidity ^0.5.0;
1039 
1040 
1041 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
1042     // Token name
1043     string private _name;
1044 
1045     // Token symbol
1046     string private _symbol;
1047 
1048     // Optional mapping for token URIs
1049     mapping(uint256 => string) private _tokenURIs;
1050 
1051     /*
1052      *     bytes4(keccak256('name()')) == 0x06fdde03
1053      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1054      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1055      *
1056      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1057      */
1058     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1059 
1060     /**
1061      * @dev Constructor function
1062      */
1063     constructor (string memory name, string memory symbol) public {
1064         _name = name;
1065         _symbol = symbol;
1066 
1067         // register the supported interfaces to conform to ERC721 via ERC165
1068         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1069     }
1070 
1071     /**
1072      * @dev Gets the token name.
1073      * @return string representing the token name
1074      */
1075     function name() external view returns (string memory) {
1076         return _name;
1077     }
1078 
1079     /**
1080      * @dev Gets the token symbol.
1081      * @return string representing the token symbol
1082      */
1083     function symbol() external view returns (string memory) {
1084         return _symbol;
1085     }
1086 
1087     /**
1088      * @dev Returns an URI for a given token ID.
1089      * Throws if the token ID does not exist. May return an empty string.
1090      * @param tokenId uint256 ID of the token to query
1091      */
1092     function tokenURI(uint256 tokenId) external view returns (string memory) {
1093         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1094         return _tokenURIs[tokenId];
1095     }
1096 
1097     /**
1098      * @dev Internal function to set the token URI for a given token.
1099      * Reverts if the token ID does not exist.
1100      * @param tokenId uint256 ID of the token to set its URI
1101      * @param uri string URI to assign
1102      */
1103     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1104         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1105         _tokenURIs[tokenId] = uri;
1106     }
1107 
1108     /**
1109      * @dev Internal function to burn a specific token.
1110      * Reverts if the token does not exist.
1111      * Deprecated, use _burn(uint256) instead.
1112      * @param owner owner of the token to burn
1113      * @param tokenId uint256 ID of the token being burned by the msg.sender
1114      */
1115     function _burn(address owner, uint256 tokenId) internal {
1116         super._burn(owner, tokenId);
1117 
1118         // Clear metadata (if any)
1119         if (bytes(_tokenURIs[tokenId]).length != 0) {
1120             delete _tokenURIs[tokenId];
1121         }
1122     }
1123 }
1124 
1125 pragma solidity ^0.5.0;
1126 
1127 
1128 /**
1129  * @title Full ERC721 Token
1130  * This implementation includes all the required and some optional functionality of the ERC721 standard
1131  * Moreover, it includes approve all functionality using operator terminology
1132  * @dev see https://eips.ethereum.org/EIPS/eip-721
1133  */
1134 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
1135     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
1136         // solhint-disable-previous-line no-empty-blocks
1137     }
1138 }
1139 pragma solidity ^0.5.0;
1140 
1141 
1142 
1143 /**
1144  * @title ERC721MetadataMintable
1145  * @dev ERC721 minting logic with metadata.
1146  */
1147 contract ERC721MetadataMintable is ERC721, ERC721Metadata {
1148     /**
1149      * @dev Function to mint tokens.
1150      * @param to The address that will receive the minted tokens.
1151      * @param tokenId The token id to mint.
1152      * @param tokenURI The token URI of the minted token.
1153      * @return A boolean that indicates if the operation was successful.
1154      */
1155     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) internal  returns (bool) {
1156         _mint(to, tokenId);
1157         _setTokenURI(tokenId, tokenURI);
1158         return true;
1159     }
1160 }
1161 
1162 pragma solidity ^0.5.0;
1163 
1164 
1165 /**
1166  * @title ERC721 Burnable Token
1167  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1168  */
1169 contract ERC721Burnable is ERC721 {
1170     /**
1171      * @dev Burns a specific ERC721 token.
1172      * @param tokenId uint256 id of the ERC721 token to be burned.
1173      */
1174     function burn(uint256 tokenId) internal {
1175         //solhint-disable-next-line max-line-length
1176         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
1177         _burn(tokenId);
1178     }
1179 }
1180 pragma solidity >=0.4.22 <0.6.0;
1181 
1182 
1183 
1184 //Deployed using 0.5.0.commit1d4f56
1185 //optimization enabled
1186 //kovan deployed at - 0xf7E80D70963cc97566BA25E5A22F24837d59CE4e
1187 contract BullionixGenerator is
1188     ERC721Enumerable,
1189     ERC721MetadataMintable,
1190     ERC721Burnable,
1191     Ownable
1192 {
1193     modifier isActive {
1194         require(isOnline == true);
1195         _;
1196     }
1197     using SafeMath for uint256;
1198     /*
1199 * @dev Beginning state and init values
1200 **/
1201     DGXinterface dgx;
1202     DGXinterface dgxStorage;
1203     DGXinterface dgxToken;
1204     bool public isOnline = false;
1205     /*
1206 Kovan KDGX token contract - 0xAEd4fc9663420eC8a6c892065BBA49c935581Dce
1207 Kovan Storage contract - 0x3c5E7435190ecd13C88F3600Ca317A1A5FdD2Ae6
1208 Kovan TokenInformation - 0x2651586330d05411e6bcecF9c4ff48341E6d02D5
1209 
1210 
1211 Mainnet (storage) = 0xc672ec9cf3be7ad06be4c5650812aec23bbfb7e1
1212 Mainnet (token)    = 0x4f3afec4e5a3f2a6a1a411def7d7dfe50ee057bf
1213 Mainnet (token information) = 0xbb246ee3fa95b88b3b55a796346313738c6e0150
1214 Mainnet storage contract - 0xC672EC9CF3Be7Ad06Be4C5650812aEc23BBfB7E1
1215 */
1216     address payable public DGXTokenContract = 0x4f3AfEC4E5a3F2A6a1A411DEF7D7dFe50eE057bF;
1217     address payable public DGXContract = 0xBB246ee3FA95b88B3B55A796346313738c6E0150; //To be filled in
1218     address payable public DGXTokenStorage = 0xC672EC9CF3Be7Ad06Be4C5650812aEc23BBfB7E1; //To be filled in
1219     string constant name = "Bullionix";
1220     string constant title = "Bullionix"; //To be filled in
1221     string constant symbol = "BLX"; //To be filled in
1222     string constant version = "Bullionix v0.2";
1223     mapping(uint256 => uint256) public StakedValue;
1224     mapping(uint256 => seriesData) public seriesToTokenId;
1225     uint256 public totalSeries = 0;
1226     uint256 public totalFeesCollected = 0;
1227     struct seriesData {
1228         string url;
1229         uint256 numberInSeries;
1230         uint256 DGXcost;
1231         uint256 fee;
1232         bool alive;
1233     }
1234     /*
1235 * @dev Events
1236 * @dev Events to read when things happen
1237 **/
1238     event NewSeriesMade(string indexed url, uint256 indexed numberToMint);
1239     event Staked(address indexed _sender, uint256 _amount, uint256 tokenStaked);
1240     event Burned(address indexed _sender, uint256 _amount, uint256 _tokenId);
1241     event Withdrawal(address indexed _receiver, uint256 indexed _amount);
1242     event TransferFee(uint256 indexed transferFee);
1243     event DemurrageFee(uint256 indexed demurrageFee);
1244     event CheckFees(
1245         uint256 indexed feeValue,
1246         uint256 indexed stakedValue,
1247         uint256 indexed _totalWithdrawal
1248     );
1249 
1250     /*
1251 * @dev Constructor() and storge init
1252 * @dev Sets state
1253 **/
1254     constructor() public ERC721Metadata(name, symbol) {
1255         if (
1256             address(DGXContract) != address(0x0) &&
1257             address(DGXTokenStorage) != address(0x0)
1258         ) {
1259             isOnline = true;
1260             dgx = DGXinterface(DGXContract);
1261             dgxStorage = DGXinterface(DGXTokenStorage);
1262             dgxToken = DGXinterface(DGXTokenContract);
1263         }
1264     }
1265 
1266     /* 
1267 * @dev changes online status to disable contract, must be current owner
1268 *
1269 **/
1270     function toggleOnline() external onlyOwner {
1271         isOnline = !isOnline;
1272     }
1273     /**
1274      * @dev Create a new series of NFTs.
1275      * @param _url location of metadata on backend server. Will be tacked onto the end of set url using returnURL().
1276      * @param _numberToMint  The token number for this series. 10 would make 10 tokens avaliable 
1277      * @param _DGXcost The amount of DGX to send
1278      * @param _fee Bullionix fee for generation
1279      * @return A boolean that indicates if the operation was successful.
1280      */
1281     function createNewSeries(
1282         string memory _url,
1283         uint256 _numberToMint,
1284         uint256 _DGXcost,
1285         uint256 _fee
1286     ) public onlyOwner isActive returns (bool _success) {
1287         //takes input from admin to create a new nft series. Will have to define how many tokens to make, how much DGX they cost, and the url from s3.
1288         require(msg.sender == owner(), "Only Owner"); //optional as onlyOwner Modifier is used
1289         uint256 total = totalSeries;
1290         uint256 tempNumber = _numberToMint.add(totalSeries);
1291         for (uint256 i = total; i < tempNumber; i++) {
1292             seriesToTokenId[i].url = _url;
1293             seriesToTokenId[i].numberInSeries = _numberToMint;
1294             seriesToTokenId[i].DGXcost = _DGXcost;
1295             seriesToTokenId[i].fee = _fee;
1296             totalSeries = totalSeries.add(1);
1297         }
1298 
1299         emit NewSeriesMade(_url, _numberToMint);
1300         return true;
1301     }
1302 
1303     /* 
1304 * @dev Stake to series and mint tokens 
1305 *
1306 **/
1307     function stake(uint256 _tokenToBuy) public payable isActive returns (bool) {
1308         //takes input from admin to create a new nft series. Will have to define how many tokens to make, how much DGX they cost, and the url from s3.
1309         require(
1310             seriesToTokenId[_tokenToBuy].fee >= 0 &&
1311                 StakedValue[_tokenToBuy] == 0,
1312             "Can't stake to this token!"
1313         );
1314         uint256 amountRequired = (
1315             (
1316                 seriesToTokenId[_tokenToBuy].DGXcost.add(
1317                     seriesToTokenId[_tokenToBuy].fee
1318                 )
1319             )
1320         );
1321         uint256 transferFee = fetchTransferFee(amountRequired);
1322         uint256 adminFees = seriesToTokenId[_tokenToBuy].fee.sub(transferFee);
1323         totalFeesCollected = totalFeesCollected.add(adminFees);
1324         uint256 demurageFee = fetchDemurrageFee(msg.sender);
1325         //add demurage fee to transfer fee
1326         uint256 totalFees = transferFee.add(demurageFee);
1327         amountRequired = amountRequired.sub(totalFees);
1328         //require transfer to contract succeeds
1329         require(
1330             _checkAllowance(msg.sender, amountRequired),
1331             "Not enough allowance"
1332         );
1333         require(
1334             _transferFromDGX(msg.sender, amountRequired),
1335             "Transfer DGX failed"
1336         );
1337         //get url
1338         string memory fullURL = returnURL(_tokenToBuy);
1339 
1340         emit CheckFees(
1341             totalFees,
1342             amountRequired,
1343             (
1344                 (
1345                     seriesToTokenId[_tokenToBuy].DGXcost.add(
1346                         seriesToTokenId[_tokenToBuy].fee
1347                     )
1348                 )
1349             )
1350         );
1351         require(amountRequired > totalFees, "Math invalid");
1352         require(
1353             mintWithTokenURI(msg.sender, _tokenToBuy, fullURL),
1354             "Minting NFT failed"
1355         );
1356         //staked value is set to DGXCost sent by user minus the total fees
1357         StakedValue[_tokenToBuy] = amountRequired;
1358         emit Staked(msg.sender, StakedValue[_tokenToBuy], _tokenToBuy);
1359         seriesToTokenId[_tokenToBuy].alive = true;
1360         return true;
1361     }
1362 
1363     /**
1364      * @dev Burns a specific ERC721 token and refunds user the DGX on the NFT
1365      * @param _tokenId uint256 id of the ERC721 token to be burned.
1366      */
1367 
1368     //TODO: Finalize this function and transfer the DGX back to msg.sender for burning their nft
1369     function burnStake(uint256 _tokenId) public payable returns (bool) {
1370         //solhint-disable-next-line max-line-length
1371         //check token is staked
1372 
1373         require(
1374             StakedValue[_tokenId] > 0 && seriesToTokenId[_tokenId].alive,
1375             "NFT not burnable yet"
1376         );
1377         //check that you are owner of token
1378         require(
1379             _isApprovedOrOwner(msg.sender, _tokenId),
1380             "ERC721Burnable: caller is not owner nor approved"
1381         );
1382         //check balance of smart contract
1383         //get fees to calculate
1384         uint256 transferFee = fetchTransferFee(StakedValue[_tokenId]);
1385         uint256 demurrageFee = fetchDemurrageFee(address(this));
1386         //total fees
1387         uint256 feeValue = transferFee.add(demurrageFee);
1388         require(
1389             feeValue < StakedValue[_tokenId],
1390             "Fee is more than StakedValue"
1391         );
1392         uint256 UserWithdrawal = StakedValue[_tokenId].sub(feeValue);
1393         UserWithdrawal = UserWithdrawal.sub((seriesToTokenId[_tokenId].fee));
1394         require(_checkBalance() >= UserWithdrawal, "Balance check failed");
1395         seriesToTokenId[_tokenId].alive = false;
1396         //transfer 721 to 0x000
1397         _burn(_tokenId);
1398         //transfer dgx from contract to msg.sender
1399         require(dgxToken.transfer(msg.sender, UserWithdrawal));
1400         emit Burned(msg.sender, UserWithdrawal, _tokenId);
1401         return true;
1402     }
1403 
1404     function checkFeesForBurn(uint256 _tokenId)
1405         public
1406         payable
1407         returns (uint256)
1408     {
1409         uint256 transferFee = fetchTransferFee(
1410             (
1411                 seriesToTokenId[_tokenId].DGXcost.add(
1412                     seriesToTokenId[_tokenId].fee
1413                 )
1414             )
1415         );
1416         uint256 demurrageFee = fetchDemurrageFee(address(this));
1417         //total fees
1418         uint256 feeValue = transferFee.add(demurrageFee);
1419 
1420         uint256 UserWithdrawal = (
1421             (
1422                 seriesToTokenId[_tokenId].DGXcost.add(
1423                     seriesToTokenId[_tokenId].fee
1424                 )
1425             )
1426                 .sub(feeValue)
1427         );
1428         UserWithdrawal = UserWithdrawal.sub((seriesToTokenId[_tokenId].fee));
1429         emit CheckFees(
1430             feeValue,
1431             (
1432                 seriesToTokenId[_tokenId].DGXcost.add(
1433                     seriesToTokenId[_tokenId].fee
1434                 )
1435             ),
1436             UserWithdrawal
1437         );
1438     }
1439     /**
1440      * @dev Withdrawals DGX from the balance collected via fees only Owner.
1441      */
1442     function withdrawal() public onlyOwner returns (bool) {
1443         require(isOnline == false);
1444         uint256 temp = _checkBalance(); //calls checkBalance which will revert if no balance, if balance pass it into transfer as amount to withdrawal MAX
1445         require(
1446             temp >= totalFeesCollected,
1447             "Not enough balance to withdrawal the fees collected"
1448         );
1449         require(dgxToken.transfer(msg.sender, totalFeesCollected));
1450         emit Withdrawal(msg.sender, totalFeesCollected);
1451         totalFeesCollected = 0;
1452         return true;
1453     }
1454     function _checkBalance() internal view returns (uint256) {
1455         uint256 tempBalance = dgxToken.balanceOf(address(this)); //checking balance on DGX contract
1456         require(tempBalance > 0, "Revert: Balance is 0!"); //do I even have a balance? Lets see. If no balance revert.
1457         return tempBalance; //here is your balance! Fresh off the stove.
1458     }
1459     function _checkAllowance(address sender, uint256 amountNeeded)
1460         internal
1461         view
1462         returns (bool)
1463     {
1464         uint256 tempBalance = dgxToken.allowance(sender, address(this)); //checking balance on DGX contract
1465         require(tempBalance >= amountNeeded, "Revert: Balance is 0!"); //do I even have a balance? Lets see. If no balance revert.
1466         return true; //here is your balance! Fresh off the stove.
1467     }
1468     /*
1469   * @dev Gets the total amount of tokens owned by the sender
1470   * @return uint[] with the id of each token owned
1471   */
1472     function viewYourTokens()
1473         external
1474         view
1475         returns (uint256[] memory _yourTokens)
1476     {
1477         return super._tokensOfOwner(msg.sender);
1478     }
1479     function setDGXStorage(address payable newAddress)
1480         external
1481         onlyOwner
1482         returns (bool)
1483     {
1484         DGXTokenStorage = newAddress;
1485         dgxStorage = DGXinterface(DGXTokenStorage);
1486         return true;
1487     }
1488     function setDGXContract(address payable newAddress)
1489         external
1490         onlyOwner
1491         returns (bool)
1492     {
1493         DGXContract = newAddress;
1494         dgx = DGXinterface(DGXContract);
1495         return true;
1496     }
1497     function setDGXTokenContract(address payable newAddress)
1498         external
1499         onlyOwner
1500         returns (bool)
1501     {
1502         DGXContract = newAddress;
1503         dgxToken = DGXinterface(DGXContract);
1504         return true;
1505     }
1506     // Internals
1507     /*
1508   * TransferForm called after user has approved DGX to be spent by this contract.
1509   * If transferform fails, return false 
1510   * @dev returns the entire tokenURI 
1511   * @return uint256 with the id of the token
1512   */
1513 
1514     /*
1515   * @dev returns the entire tokenURI 
1516   * @return uint256 with the id of the token
1517   */
1518     function returnURL(uint256 _tokenId)
1519         internal
1520         view
1521         returns (string memory _URL)
1522     {
1523         require(
1524             checkURL(_tokenId),
1525             "ERC721: approved query for nonexistent token"
1526         ); //Does this token exist? Lets see.
1527         string memory uri = seriesToTokenId[_tokenId].url;
1528         return string(abi.encodePacked("https://app.bullionix.io/metadata/", uri)); //Here is your URL!
1529     }
1530 
1531     /*
1532   * @dev Returns the URL - internal 
1533   * @return URL of token with full website attached
1534   */
1535     function checkURL(uint256 _tokenId) internal view returns (bool) {
1536         string memory temp = seriesToTokenId[_tokenId].url;
1537         bytes memory tempEmptyStringTest = bytes(temp);
1538         require(tempEmptyStringTest.length >= 1, temp);
1539         return true;
1540     }
1541     function _transferFromDGX(address _owner, uint256 _amount)
1542         internal
1543         returns (bool)
1544     {
1545         require(dgxToken.transferFrom(_owner, address(this), _amount));
1546         return true;
1547     }
1548 
1549     function fetchTransferFee(uint256 _amountToBeTransferred)
1550         internal
1551         returns (uint256 rate)
1552     {
1553         (uint256 _base, uint256 _rate, address _collector, bool _no_transfer_fee, uint256 _minimum_transfer_amount) = dgx
1554             .showTransferConfigs();
1555         if (_no_transfer_fee) {
1556             return 0;
1557         }
1558         emit TransferFee(_rate.mul(_amountToBeTransferred).div(_base));
1559         return _rate.mul(_amountToBeTransferred).div(_base);
1560 
1561     }
1562 
1563     function fetchLastTransfer(address _user)
1564         internal
1565         returns (uint256 _payment_date)
1566     {
1567         //gets the timestamp from the DGX contract to help calculate the fees
1568         (bool _exists, uint256 _raw_balance, uint256 _payment_date, bool _no_demurrage_fee, bool _no_recast_fee, bool _no_transfer_fee) = dgxStorage
1569             .read_user(_user);
1570         require(
1571             _payment_date >= 0 && _payment_date < block.timestamp,
1572             "Last payment timestamp is invalid"
1573         );
1574 
1575         return _payment_date;
1576 
1577     }
1578 
1579     function fetchDemurrageFee(address _sender)
1580         internal
1581         returns (uint256 rate)
1582     {
1583         //calculate the fee taken by DGX using (rate/base)*(timestamp_now - last_payment) / number_of_seconds_in_a_day = demurrage fee
1584         (uint256 _base, uint256 _rate, address _collector, bool _no_demurrage_fee) = dgx
1585             .showDemurrageConfigs();
1586         if (_no_demurrage_fee) return 0;
1587         //get last transfer date
1588         uint256 last_timestamp = fetchLastTransfer(_sender);
1589         uint256 daysSinceTransfer = block.timestamp.sub(last_timestamp);
1590 
1591         //calculate total fees
1592         //get total demurage fee by taking fee*days
1593         uint256 totalFees = (
1594             (_rate * 10**8).div(_base).mul(daysSinceTransfer).div(86400)
1595         );
1596         emit DemurrageFee(totalFees);
1597         return totalFees;
1598 
1599     }
1600     function() external payable {
1601         revert("Please call a function");
1602     }
1603 }