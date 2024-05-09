1 /*
2  * Crypto stamp Golden Unicorn
3  * digital-physical collectible postage stamp
4  *
5  * Developed by Capacity Blockchain Solutions GmbH <capacity.at>
6  * for Österreichische Post AG <post.at>
7  */
8 
9 
10 // File: @openzeppelin/contracts/GSN/Context.sol
11 
12 pragma solidity ^0.6.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 contract Context {
25     // Empty internal constructor, to prevent people from mistakenly deploying
26     // an instance of this contract, which should be used via inheritance.
27     constructor () internal { }
28 
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/introspection/IERC165.sol
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Interface of the ERC165 standard, as defined in the
45  * https://eips.ethereum.org/EIPS/eip-165[EIP].
46  *
47  * Implementers can declare support of contract interfaces, which can then be
48  * queried by others ({ERC165Checker}).
49  *
50  * For an implementation, see {ERC165}.
51  */
52 interface IERC165 {
53     /**
54      * @dev Returns true if this contract implements the interface defined by
55      * `interfaceId`. See the corresponding
56      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
57      * to learn more about how these ids are created.
58      *
59      * This function call must use less than 30 000 gas.
60      */
61     function supportsInterface(bytes4 interfaceId) external view returns (bool);
62 }
63 
64 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
65 
66 pragma solidity ^0.6.2;
67 
68 
69 /**
70  * @dev Required interface of an ERC721 compliant contract.
71  */
72 interface IERC721 is IERC165 {
73     /**
74      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
77 
78     /**
79      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
80      */
81     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
82 
83     /**
84      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
85      */
86     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
87 
88     /**
89      * @dev Returns the number of tokens in ``owner``'s account.
90      */
91     function balanceOf(address owner) external view returns (uint256 balance);
92 
93     /**
94      * @dev Returns the owner of the `tokenId` token.
95      *
96      * Requirements:
97      *
98      * - `tokenId` must exist.
99      */
100     function ownerOf(uint256 tokenId) external view returns (address owner);
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from`, `to` cannot be zero.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(address from, address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Transfers `tokenId` token from `from` to `to`.
119      *
120      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
121      *
122      * Requirements:
123      *
124      * - `from`, `to` cannot be zero.
125      * - `tokenId` token must be owned by `from`.
126      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(address from, address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 
175     /**
176       * @dev Safely transfers `tokenId` token from `from` to `to`.
177       *
178       * Requirements:
179       *
180       * - `from`, `to` cannot be zero.
181       * - `tokenId` token must exist and be owned by `from`.
182       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184       *
185       * Emits a {Transfer} event.
186       */
187     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
191 
192 pragma solidity ^0.6.2;
193 
194 
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Metadata is IERC721 {
200 
201     /**
202      * @dev Returns the token collection name.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the token collection symbol.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
213      */
214     function tokenURI(uint256 tokenId) external view returns (string memory);
215 }
216 
217 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
218 
219 pragma solidity ^0.6.2;
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Enumerable is IERC721 {
227 
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
247 
248 pragma solidity ^0.6.0;
249 
250 /**
251  * @title ERC721 token receiver interface
252  * @dev Interface for any contract that wants to support safeTransfers
253  * from ERC721 asset contracts.
254  */
255 abstract contract IERC721Receiver {
256     /**
257      * @notice Handle the receipt of an NFT
258      * @dev The ERC721 smart contract calls this function on the recipient
259      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
260      * otherwise the caller will revert the transaction. The selector to be
261      * returned can be obtained as `this.onERC721Received.selector`. This
262      * function MAY throw to revert and reject the transfer.
263      * Note: the ERC721 contract address is always the message sender.
264      * @param operator The address which called `safeTransferFrom` function
265      * @param from The address which previously owned the token
266      * @param tokenId The NFT identifier which is being transferred
267      * @param data Additional data with no specified format
268      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
269      */
270     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
271     public virtual returns (bytes4);
272 }
273 
274 // File: @openzeppelin/contracts/introspection/ERC165.sol
275 
276 pragma solidity ^0.6.0;
277 
278 
279 /**
280  * @dev Implementation of the {IERC165} interface.
281  *
282  * Contracts may inherit from this and call {_registerInterface} to declare
283  * their support of an interface.
284  */
285 contract ERC165 is IERC165 {
286     /*
287      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
288      */
289     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
290 
291     /**
292      * @dev Mapping of interface ids to whether or not it's supported.
293      */
294     mapping(bytes4 => bool) private _supportedInterfaces;
295 
296     constructor () internal {
297         // Derived contracts need only register support for their own interfaces,
298         // we register support for ERC165 itself here
299         _registerInterface(_INTERFACE_ID_ERC165);
300     }
301 
302     /**
303      * @dev See {IERC165-supportsInterface}.
304      *
305      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
306      */
307     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
308         return _supportedInterfaces[interfaceId];
309     }
310 
311     /**
312      * @dev Registers the contract as an implementer of the interface defined by
313      * `interfaceId`. Support of the actual ERC165 interface is automatic and
314      * registering its interface id is not required.
315      *
316      * See {IERC165-supportsInterface}.
317      *
318      * Requirements:
319      *
320      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
321      */
322     function _registerInterface(bytes4 interfaceId) internal virtual {
323         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
324         _supportedInterfaces[interfaceId] = true;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/math/SafeMath.sol
329 
330 pragma solidity ^0.6.0;
331 
332 /**
333  * @dev Wrappers over Solidity's arithmetic operations with added overflow
334  * checks.
335  *
336  * Arithmetic operations in Solidity wrap on overflow. This can easily result
337  * in bugs, because programmers usually assume that an overflow raises an
338  * error, which is the standard behavior in high level programming languages.
339  * `SafeMath` restores this intuition by reverting the transaction when an
340  * operation overflows.
341  *
342  * Using this library instead of the unchecked operations eliminates an entire
343  * class of bugs, so it's recommended to use it always.
344  */
345 library SafeMath {
346     /**
347      * @dev Returns the addition of two unsigned integers, reverting on
348      * overflow.
349      *
350      * Counterpart to Solidity's `+` operator.
351      *
352      * Requirements:
353      * - Addition cannot overflow.
354      */
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         require(c >= a, "SafeMath: addition overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the subtraction of two unsigned integers, reverting on
364      * overflow (when the result is negative).
365      *
366      * Counterpart to Solidity's `-` operator.
367      *
368      * Requirements:
369      * - Subtraction cannot overflow.
370      */
371     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
372         return sub(a, b, "SafeMath: subtraction overflow");
373     }
374 
375     /**
376      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
377      * overflow (when the result is negative).
378      *
379      * Counterpart to Solidity's `-` operator.
380      *
381      * Requirements:
382      * - Subtraction cannot overflow.
383      */
384     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
385         require(b <= a, errorMessage);
386         uint256 c = a - b;
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the multiplication of two unsigned integers, reverting on
393      * overflow.
394      *
395      * Counterpart to Solidity's `*` operator.
396      *
397      * Requirements:
398      * - Multiplication cannot overflow.
399      */
400     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
401         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
402         // benefit is lost if 'b' is also tested.
403         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
404         if (a == 0) {
405             return 0;
406         }
407 
408         uint256 c = a * b;
409         require(c / a == b, "SafeMath: multiplication overflow");
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the integer division of two unsigned integers. Reverts on
416      * division by zero. The result is rounded towards zero.
417      *
418      * Counterpart to Solidity's `/` operator. Note: this function uses a
419      * `revert` opcode (which leaves remaining gas untouched) while Solidity
420      * uses an invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      * - The divisor cannot be zero.
424      */
425     function div(uint256 a, uint256 b) internal pure returns (uint256) {
426         return div(a, b, "SafeMath: division by zero");
427     }
428 
429     /**
430      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
431      * division by zero. The result is rounded towards zero.
432      *
433      * Counterpart to Solidity's `/` operator. Note: this function uses a
434      * `revert` opcode (which leaves remaining gas untouched) while Solidity
435      * uses an invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      * - The divisor cannot be zero.
439      */
440     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
441         // Solidity only automatically asserts when dividing by 0
442         require(b > 0, errorMessage);
443         uint256 c = a / b;
444         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * Reverts when dividing by zero.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      * - The divisor cannot be zero.
459      */
460     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
461         return mod(a, b, "SafeMath: modulo by zero");
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
466      * Reverts with custom message when dividing by zero.
467      *
468      * Counterpart to Solidity's `%` operator. This function uses a `revert`
469      * opcode (which leaves remaining gas untouched) while Solidity uses an
470      * invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      * - The divisor cannot be zero.
474      */
475     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         require(b != 0, errorMessage);
477         return a % b;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Address.sol
482 
483 pragma solidity ^0.6.2;
484 
485 /**
486  * @dev Collection of functions related to the address type
487  */
488 library Address {
489     /**
490      * @dev Returns true if `account` is a contract.
491      *
492      * [IMPORTANT]
493      * ====
494      * It is unsafe to assume that an address for which this function returns
495      * false is an externally-owned account (EOA) and not a contract.
496      *
497      * Among others, `isContract` will return false for the following
498      * types of addresses:
499      *
500      *  - an externally-owned account
501      *  - a contract in construction
502      *  - an address where a contract will be created
503      *  - an address where a contract lived, but was destroyed
504      * ====
505      */
506     function isContract(address account) internal view returns (bool) {
507         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
508         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
509         // for accounts without code, i.e. `keccak256('')`
510         bytes32 codehash;
511         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
512         // solhint-disable-next-line no-inline-assembly
513         assembly { codehash := extcodehash(account) }
514         return (codehash != accountHash && codehash != 0x0);
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
537         (bool success, ) = recipient.call{ value: amount }("");
538         require(success, "Address: unable to send value, recipient may have reverted");
539     }
540 }
541 
542 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
543 
544 pragma solidity ^0.6.0;
545 
546 /**
547  * @dev Library for managing
548  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
549  * types.
550  *
551  * Sets have the following properties:
552  *
553  * - Elements are added, removed, and checked for existence in constant time
554  * (O(1)).
555  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
556  *
557  * ```
558  * contract Example {
559  *     // Add the library methods
560  *     using EnumerableSet for EnumerableSet.AddressSet;
561  *
562  *     // Declare a set state variable
563  *     EnumerableSet.AddressSet private mySet;
564  * }
565  * ```
566  *
567  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
568  * (`UintSet`) are supported.
569  */
570 library EnumerableSet {
571     // To implement this library for multiple types with as little code
572     // repetition as possible, we write it in terms of a generic Set type with
573     // bytes32 values.
574     // The Set implementation uses private functions, and user-facing
575     // implementations (such as AddressSet) are just wrappers around the
576     // underlying Set.
577     // This means that we can only create new EnumerableSets for types that fit
578     // in bytes32.
579 
580     struct Set {
581         // Storage of set values
582         bytes32[] _values;
583 
584         // Position of the value in the `values` array, plus 1 because index 0
585         // means a value is not in the set.
586         mapping (bytes32 => uint256) _indexes;
587     }
588 
589     /**
590      * @dev Add a value to a set. O(1).
591      *
592      * Returns true if the value was added to the set, that is if it was not
593      * already present.
594      */
595     function _add(Set storage set, bytes32 value) private returns (bool) {
596         if (!_contains(set, value)) {
597             set._values.push(value);
598             // The value is stored at length-1, but we add 1 to all indexes
599             // and use 0 as a sentinel value
600             set._indexes[value] = set._values.length;
601             return true;
602         } else {
603             return false;
604         }
605     }
606 
607     /**
608      * @dev Removes a value from a set. O(1).
609      *
610      * Returns true if the value was removed from the set, that is if it was
611      * present.
612      */
613     function _remove(Set storage set, bytes32 value) private returns (bool) {
614         // We read and store the value's index to prevent multiple reads from the same storage slot
615         uint256 valueIndex = set._indexes[value];
616 
617         if (valueIndex != 0) { // Equivalent to contains(set, value)
618             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
619             // the array, and then remove the last element (sometimes called as 'swap and pop').
620             // This modifies the order of the array, as noted in {at}.
621 
622             uint256 toDeleteIndex = valueIndex - 1;
623             uint256 lastIndex = set._values.length - 1;
624 
625             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
626             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
627 
628             bytes32 lastvalue = set._values[lastIndex];
629 
630             // Move the last value to the index where the value to delete is
631             set._values[toDeleteIndex] = lastvalue;
632             // Update the index for the moved value
633             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
634 
635             // Delete the slot where the moved value was stored
636             set._values.pop();
637 
638             // Delete the index for the deleted slot
639             delete set._indexes[value];
640 
641             return true;
642         } else {
643             return false;
644         }
645     }
646 
647     /**
648      * @dev Returns true if the value is in the set. O(1).
649      */
650     function _contains(Set storage set, bytes32 value) private view returns (bool) {
651         return set._indexes[value] != 0;
652     }
653 
654     /**
655      * @dev Returns the number of values on the set. O(1).
656      */
657     function _length(Set storage set) private view returns (uint256) {
658         return set._values.length;
659     }
660 
661    /**
662     * @dev Returns the value stored at position `index` in the set. O(1).
663     *
664     * Note that there are no guarantees on the ordering of values inside the
665     * array, and it may change when more values are added or removed.
666     *
667     * Requirements:
668     *
669     * - `index` must be strictly less than {length}.
670     */
671     function _at(Set storage set, uint256 index) private view returns (bytes32) {
672         require(set._values.length > index, "EnumerableSet: index out of bounds");
673         return set._values[index];
674     }
675 
676     // AddressSet
677 
678     struct AddressSet {
679         Set _inner;
680     }
681 
682     /**
683      * @dev Add a value to a set. O(1).
684      *
685      * Returns true if the value was added to the set, that is if it was not
686      * already present.
687      */
688     function add(AddressSet storage set, address value) internal returns (bool) {
689         return _add(set._inner, bytes32(uint256(value)));
690     }
691 
692     /**
693      * @dev Removes a value from a set. O(1).
694      *
695      * Returns true if the value was removed from the set, that is if it was
696      * present.
697      */
698     function remove(AddressSet storage set, address value) internal returns (bool) {
699         return _remove(set._inner, bytes32(uint256(value)));
700     }
701 
702     /**
703      * @dev Returns true if the value is in the set. O(1).
704      */
705     function contains(AddressSet storage set, address value) internal view returns (bool) {
706         return _contains(set._inner, bytes32(uint256(value)));
707     }
708 
709     /**
710      * @dev Returns the number of values in the set. O(1).
711      */
712     function length(AddressSet storage set) internal view returns (uint256) {
713         return _length(set._inner);
714     }
715 
716    /**
717     * @dev Returns the value stored at position `index` in the set. O(1).
718     *
719     * Note that there are no guarantees on the ordering of values inside the
720     * array, and it may change when more values are added or removed.
721     *
722     * Requirements:
723     *
724     * - `index` must be strictly less than {length}.
725     */
726     function at(AddressSet storage set, uint256 index) internal view returns (address) {
727         return address(uint256(_at(set._inner, index)));
728     }
729 
730 
731     // UintSet
732 
733     struct UintSet {
734         Set _inner;
735     }
736 
737     /**
738      * @dev Add a value to a set. O(1).
739      *
740      * Returns true if the value was added to the set, that is if it was not
741      * already present.
742      */
743     function add(UintSet storage set, uint256 value) internal returns (bool) {
744         return _add(set._inner, bytes32(value));
745     }
746 
747     /**
748      * @dev Removes a value from a set. O(1).
749      *
750      * Returns true if the value was removed from the set, that is if it was
751      * present.
752      */
753     function remove(UintSet storage set, uint256 value) internal returns (bool) {
754         return _remove(set._inner, bytes32(value));
755     }
756 
757     /**
758      * @dev Returns true if the value is in the set. O(1).
759      */
760     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
761         return _contains(set._inner, bytes32(value));
762     }
763 
764     /**
765      * @dev Returns the number of values on the set. O(1).
766      */
767     function length(UintSet storage set) internal view returns (uint256) {
768         return _length(set._inner);
769     }
770 
771    /**
772     * @dev Returns the value stored at position `index` in the set. O(1).
773     *
774     * Note that there are no guarantees on the ordering of values inside the
775     * array, and it may change when more values are added or removed.
776     *
777     * Requirements:
778     *
779     * - `index` must be strictly less than {length}.
780     */
781     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
782         return uint256(_at(set._inner, index));
783     }
784 }
785 
786 // File: contracts/EnumerableRandomMapSimple.sol
787 
788 pragma solidity ^0.6.0;
789 
790 library EnumerableRandomMapSimple {
791     // To implement this library for multiple types with as little code
792     // repetition as possible, we write it in terms of a generic Map type with
793     // bytes32 keys and values.
794     // The Map implementation uses private functions, and user-facing
795     // implementations (such as Uint256ToAddressMap) are just wrappers around
796     // the underlying Map.
797     // This means that we can only create new EnumerableMaps for types that fit
798     // in bytes32.
799 
800     struct Map {
801         // Storage of map keys and values
802         mapping(bytes32 => bytes32) _entries;
803         uint256 _length;
804     }
805 
806     /**
807      * @dev Adds a key-value pair to a map, or updates the value for an existing
808      * key. O(1).
809      *
810      * Returns true if the key was added to the map, that is if it was not
811      * already present.
812      */
813     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
814         bool newVal;
815         if (map._entries[key] == bytes32("")) { // add new entry
816             map._length++;
817             newVal = true;
818         }
819         else if (value == bytes32("")) { // remove entry
820             map._length--;
821             newVal = false;
822         }
823         else {
824             newVal = false;
825         }
826         map._entries[key] = value;
827         return newVal;
828     }
829 
830     /**
831      * @dev Removes a key-value pair from a map. O(1).
832      *
833      * Returns true if the key was removed from the map, that is if it was present.
834      */
835     function _remove(Map storage /*map*/, bytes32 /*key*/) private pure returns (bool) {
836         revert("No removal supported");
837     }
838 
839     /**
840      * @dev Returns true if the key is in the map. O(1).
841      */
842     function _contains(Map storage map, bytes32 key) private view returns (bool) {
843         return map._entries[key] != bytes32("");
844     }
845 
846     /**
847      * @dev Returns the number of key-value pairs in the map. O(1).
848      */
849     function _length(Map storage map) private view returns (uint256) {
850         return map._length;
851     }
852 
853    /**
854     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
855     *
856     * Note that there are no guarantees on the ordering of entries inside the
857     * array, and it may change when more entries are added or removed.
858     *
859     * Requirements:
860     *
861     * - `index` must be strictly less than {length}.
862     */
863     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
864         bytes32 key = bytes32(index);
865         require(_contains(map, key), "EnumerableMap: index out of bounds");
866         return (key, map._entries[key]);
867     }
868 
869     /**
870      * @dev Returns the value associated with `key`.  O(1).
871      *
872      * Requirements:
873      *
874      * - `key` must be in the map.
875      */
876     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
877         return _get(map, key, "EnumerableMap: nonexistent key");
878     }
879 
880     /**
881      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
882      */
883     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
884         require(_contains(map, key), errorMessage); // Equivalent to contains(map, key)
885         return map._entries[key];
886     }
887 
888     // UintToAddressMap
889 
890     struct UintToAddressMap {
891         Map _inner;
892     }
893 
894     /**
895      * @dev Adds a key-value pair to a map, or updates the value for an existing
896      * key. O(1).
897      *
898      * Returns true if the key was added to the map, that is if it was not
899      * already present.
900      */
901     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
902         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
903     }
904 
905     /**
906      * @dev Removes a value from a set. O(1).
907      *
908      * Returns true if the key was removed from the map, that is if it was present.
909      */
910     function remove(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
911         return _remove(map._inner, bytes32(key));
912     }
913 
914     /**
915      * @dev Returns true if the key is in the map. O(1).
916      */
917     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
918         return _contains(map._inner, bytes32(key));
919     }
920 
921     /**
922      * @dev Returns the number of elements in the map. O(1).
923      */
924     function length(UintToAddressMap storage map) internal view returns (uint256) {
925         return _length(map._inner);
926     }
927 
928    /**
929     * @dev Returns the element stored at position `index` in the set. O(1).
930     * Note that there are no guarantees on the ordering of values inside the
931     * array, and it may change when more values are added or removed.
932     *
933     * Requirements:
934     *
935     * - `index` must be strictly less than {length}.
936     */
937     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
938         (bytes32 key, bytes32 value) = _at(map._inner, index);
939         return (uint256(key), address(uint256(value)));
940     }
941 
942     /**
943      * @dev Returns the value associated with `key`.  O(1).
944      *
945      * Requirements:
946      *
947      * - `key` must be in the map.
948      */
949     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
950         return address(uint256(_get(map._inner, bytes32(key))));
951     }
952 
953     /**
954      * @dev Same as {get}, with a custom error message when `key` is not in the map.
955      */
956     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
957         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
958     }
959 }
960 
961 // File: @openzeppelin/contracts/utils/Strings.sol
962 
963 pragma solidity ^0.6.0;
964 
965 /**
966  * @dev String operations.
967  */
968 library Strings {
969     /**
970      * @dev Converts a `uint256` to its ASCII `string` representation.
971      */
972     function toString(uint256 value) internal pure returns (string memory) {
973         // Inspired by OraclizeAPI's implementation - MIT licence
974         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
975 
976         if (value == 0) {
977             return "0";
978         }
979         uint256 temp = value;
980         uint256 digits;
981         while (temp != 0) {
982             digits++;
983             temp /= 10;
984         }
985         bytes memory buffer = new bytes(digits);
986         uint256 index = digits - 1;
987         temp = value;
988         while (temp != 0) {
989             buffer[index--] = byte(uint8(48 + temp % 10));
990             temp /= 10;
991         }
992         return string(buffer);
993     }
994 }
995 
996 // File: contracts/OZ_Clone/ERC721_simplemaps.sol
997 
998 pragma solidity ^0.6.0;
999 
1000 // Clone of OpenZeppelin 3.0.0 token/ERC721/ERC721.sol with just imports adapted and EnumerableMap exchanged for EnumerableMapSimple,
1001 // and totalSupply() marked as virtual.
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 
1012 
1013 
1014 /**
1015  * @title ERC721 Non-Fungible Token Standard basic implementation
1016  * @dev see https://eips.ethereum.org/EIPS/eip-721
1017  */
1018 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1019     using SafeMath for uint256;
1020     using Address for address;
1021     using EnumerableSet for EnumerableSet.UintSet;
1022     using EnumerableRandomMapSimple for EnumerableRandomMapSimple.UintToAddressMap;
1023     using Strings for uint256;
1024 
1025     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1026     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1027     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1028 
1029     // Mapping from holder address to their (enumerable) set of owned tokens
1030     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1031 
1032     // Enumerable mapping from token ids to their owners
1033     EnumerableRandomMapSimple.UintToAddressMap private _tokenOwners;
1034 
1035     // Mapping from token ID to approved address
1036     mapping (uint256 => address) private _tokenApprovals;
1037 
1038     // Mapping from owner to operator approvals
1039     mapping (address => mapping (address => bool)) private _operatorApprovals;
1040 
1041     // Token name
1042     string private _name;
1043 
1044     // Token symbol
1045     string private _symbol;
1046 
1047     // Optional mapping for token URIs
1048     mapping(uint256 => string) private _tokenURIs;
1049 
1050     // Base URI
1051     string private _baseURI;
1052 
1053     /*
1054      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1055      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1056      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1057      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1058      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1059      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1060      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1061      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1062      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1063      *
1064      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1065      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1066      */
1067     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1068 
1069     /*
1070      *     bytes4(keccak256('name()')) == 0x06fdde03
1071      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1072      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1073      *
1074      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1075      */
1076     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1077 
1078     /*
1079      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1080      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1081      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1082      *
1083      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1084      */
1085     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1086 
1087     constructor (string memory name, string memory symbol) public {
1088         _name = name;
1089         _symbol = symbol;
1090 
1091         // register the supported interfaces to conform to ERC721 via ERC165
1092         _registerInterface(_INTERFACE_ID_ERC721);
1093         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1094         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1095     }
1096 
1097     /**
1098      * @dev Gets the balance of the specified address.
1099      * @param owner address to query the balance of
1100      * @return uint256 representing the amount owned by the passed address
1101      */
1102     function balanceOf(address owner) public view override returns (uint256) {
1103         require(owner != address(0), "ERC721: balance query for the zero address");
1104 
1105         return _holderTokens[owner].length();
1106     }
1107 
1108     /**
1109      * @dev Gets the owner of the specified token ID.
1110      * @param tokenId uint256 ID of the token to query the owner of
1111      * @return address currently marked as the owner of the given token ID
1112      */
1113     function ownerOf(uint256 tokenId) public view override returns (address) {
1114         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1115     }
1116 
1117     /**
1118      * @dev Gets the token name.
1119      * @return string representing the token name
1120      */
1121     function name() public view override returns (string memory) {
1122         return _name;
1123     }
1124 
1125     /**
1126      * @dev Gets the token symbol.
1127      * @return string representing the token symbol
1128      */
1129     function symbol() public view override returns (string memory) {
1130         return _symbol;
1131     }
1132 
1133     /**
1134      * @dev Returns the URI for a given token ID. May return an empty string.
1135      *
1136      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1137      * token's own URI (via {_setTokenURI}).
1138      *
1139      * If there is a base URI but no token URI, the token's ID will be used as
1140      * its URI when appending it to the base URI. This pattern for autogenerated
1141      * token URIs can lead to large gas savings.
1142      *
1143      * .Examples
1144      * |===
1145      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1146      * | ""
1147      * | ""
1148      * | ""
1149      * | ""
1150      * | "token.uri/123"
1151      * | "token.uri/123"
1152      * | "token.uri/"
1153      * | "123"
1154      * | "token.uri/123"
1155      * | "token.uri/"
1156      * | ""
1157      * | "token.uri/<tokenId>"
1158      * |===
1159      *
1160      * Requirements:
1161      *
1162      * - `tokenId` must exist.
1163      */
1164     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1165         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1166 
1167         string memory _tokenURI = _tokenURIs[tokenId];
1168 
1169         // If there is no base URI, return the token URI.
1170         if (bytes(_baseURI).length == 0) {
1171             return _tokenURI;
1172         }
1173         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1174         if (bytes(_tokenURI).length > 0) {
1175             return string(abi.encodePacked(_baseURI, _tokenURI));
1176         }
1177         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1178         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1179     }
1180 
1181     /**
1182     * @dev Returns the base URI set via {_setBaseURI}. This will be
1183     * automatically added as a prefix in {tokenURI} to each token's URI, or
1184     * to the token ID if no specific URI is set for that token ID.
1185     */
1186     function baseURI() public view returns (string memory) {
1187         return _baseURI;
1188     }
1189 
1190     /**
1191      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1192      * @param owner address owning the tokens list to be accessed
1193      * @param index uint256 representing the index to be accessed of the requested tokens list
1194      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1195      */
1196     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1197         return _holderTokens[owner].at(index);
1198     }
1199 
1200     /**
1201      * @dev Gets the total amount of tokens stored by the contract.
1202      * @return uint256 representing the total amount of tokens
1203      */
1204     function totalSupply() public view override virtual returns (uint256) {
1205         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1206         return _tokenOwners.length();
1207     }
1208 
1209     /**
1210      * @dev Gets the token ID at a given index of all the tokens in this contract
1211      * Reverts if the index is greater or equal to the total number of tokens.
1212      * @param index uint256 representing the index to be accessed of the tokens list
1213      * @return uint256 token ID at the given index of the tokens list
1214      */
1215     function tokenByIndex(uint256 index) public view override returns (uint256) {
1216         (uint256 tokenId, ) = _tokenOwners.at(index);
1217         return tokenId;
1218     }
1219 
1220     /**
1221      * @dev Approves another address to transfer the given token ID
1222      * The zero address indicates there is no approved address.
1223      * There can only be one approved address per token at a given time.
1224      * Can only be called by the token owner or an approved operator.
1225      * @param to address to be approved for the given token ID
1226      * @param tokenId uint256 ID of the token to be approved
1227      */
1228     function approve(address to, uint256 tokenId) public virtual override {
1229         address owner = ownerOf(tokenId);
1230         require(to != owner, "ERC721: approval to current owner");
1231 
1232         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1233             "ERC721: approve caller is not owner nor approved for all"
1234         );
1235 
1236         _approve(to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev Gets the approved address for a token ID, or zero if no address set
1241      * Reverts if the token ID does not exist.
1242      * @param tokenId uint256 ID of the token to query the approval of
1243      * @return address currently approved for the given token ID
1244      */
1245     function getApproved(uint256 tokenId) public view override returns (address) {
1246         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1247 
1248         return _tokenApprovals[tokenId];
1249     }
1250 
1251     /**
1252      * @dev Sets or unsets the approval of a given operator
1253      * An operator is allowed to transfer all tokens of the sender on their behalf.
1254      * @param operator operator address to set the approval
1255      * @param approved representing the status of the approval to be set
1256      */
1257     function setApprovalForAll(address operator, bool approved) public virtual override {
1258         require(operator != _msgSender(), "ERC721: approve to caller");
1259 
1260         _operatorApprovals[_msgSender()][operator] = approved;
1261         emit ApprovalForAll(_msgSender(), operator, approved);
1262     }
1263 
1264     /**
1265      * @dev Tells whether an operator is approved by a given owner.
1266      * @param owner owner address which you want to query the approval of
1267      * @param operator operator address which you want to query the approval of
1268      * @return bool whether the given operator is approved by the given owner
1269      */
1270     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev Transfers the ownership of a given token ID to another address.
1276      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1277      * Requires the msg.sender to be the owner, approved, or operator.
1278      * @param from current owner of the token
1279      * @param to address to receive the ownership of the given token ID
1280      * @param tokenId uint256 ID of the token to be transferred
1281      */
1282     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1283         //solhint-disable-next-line max-line-length
1284         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1285 
1286         _transfer(from, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Safely transfers the ownership of a given token ID to another address
1291      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1292      * which is called upon a safe transfer, and return the magic value
1293      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1294      * the transfer is reverted.
1295      * Requires the msg.sender to be the owner, approved, or operator
1296      * @param from current owner of the token
1297      * @param to address to receive the ownership of the given token ID
1298      * @param tokenId uint256 ID of the token to be transferred
1299      */
1300     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1301         safeTransferFrom(from, to, tokenId, "");
1302     }
1303 
1304     /**
1305      * @dev Safely transfers the ownership of a given token ID to another address
1306      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1307      * which is called upon a safe transfer, and return the magic value
1308      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1309      * the transfer is reverted.
1310      * Requires the _msgSender() to be the owner, approved, or operator
1311      * @param from current owner of the token
1312      * @param to address to receive the ownership of the given token ID
1313      * @param tokenId uint256 ID of the token to be transferred
1314      * @param _data bytes data to send along with a safe transfer check
1315      */
1316     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1317         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1318         _safeTransfer(from, to, tokenId, _data);
1319     }
1320 
1321     /**
1322      * @dev Safely transfers the ownership of a given token ID to another address
1323      * If the target address is a contract, it must implement `onERC721Received`,
1324      * which is called upon a safe transfer, and return the magic value
1325      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1326      * the transfer is reverted.
1327      * Requires the msg.sender to be the owner, approved, or operator
1328      * @param from current owner of the token
1329      * @param to address to receive the ownership of the given token ID
1330      * @param tokenId uint256 ID of the token to be transferred
1331      * @param _data bytes data to send along with a safe transfer check
1332      */
1333     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1334         _transfer(from, to, tokenId);
1335         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1336     }
1337 
1338     /**
1339      * @dev Returns whether the specified token exists.
1340      * @param tokenId uint256 ID of the token to query the existence of
1341      * @return bool whether the token exists
1342      */
1343     function _exists(uint256 tokenId) internal view returns (bool) {
1344         return _tokenOwners.contains(tokenId);
1345     }
1346 
1347     /**
1348      * @dev Returns whether the given spender can transfer a given token ID.
1349      * @param spender address of the spender to query
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @return bool whether the msg.sender is approved for the given token ID,
1352      * is an operator of the owner, or is the owner of the token
1353      */
1354     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1355         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1356         address owner = ownerOf(tokenId);
1357         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1358     }
1359 
1360     /**
1361      * @dev Internal function to safely mint a new token.
1362      * Reverts if the given token ID already exists.
1363      * If the target address is a contract, it must implement `onERC721Received`,
1364      * which is called upon a safe transfer, and return the magic value
1365      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1366      * the transfer is reverted.
1367      * @param to The address that will own the minted token
1368      * @param tokenId uint256 ID of the token to be minted
1369      */
1370     function _safeMint(address to, uint256 tokenId) internal virtual {
1371         _safeMint(to, tokenId, "");
1372     }
1373 
1374     /**
1375      * @dev Internal function to safely mint a new token.
1376      * Reverts if the given token ID already exists.
1377      * If the target address is a contract, it must implement `onERC721Received`,
1378      * which is called upon a safe transfer, and return the magic value
1379      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1380      * the transfer is reverted.
1381      * @param to The address that will own the minted token
1382      * @param tokenId uint256 ID of the token to be minted
1383      * @param _data bytes data to send along with a safe transfer check
1384      */
1385     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1386         _mint(to, tokenId);
1387         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1388     }
1389 
1390     /**
1391      * @dev Internal function to mint a new token.
1392      * Reverts if the given token ID already exists.
1393      * @param to The address that will own the minted token
1394      * @param tokenId uint256 ID of the token to be minted
1395      */
1396     function _mint(address to, uint256 tokenId) internal virtual {
1397         require(to != address(0), "ERC721: mint to the zero address");
1398         require(!_exists(tokenId), "ERC721: token already minted");
1399 
1400         _beforeTokenTransfer(address(0), to, tokenId);
1401 
1402         _holderTokens[to].add(tokenId);
1403 
1404         _tokenOwners.set(tokenId, to);
1405 
1406         emit Transfer(address(0), to, tokenId);
1407     }
1408 
1409     /**
1410      * @dev Internal function to burn a specific token.
1411      * Reverts if the token does not exist.
1412      * @param tokenId uint256 ID of the token being burned
1413      */
1414     function _burn(uint256 tokenId) internal virtual {
1415         address owner = ownerOf(tokenId);
1416 
1417         _beforeTokenTransfer(owner, address(0), tokenId);
1418 
1419         // Clear approvals
1420         _approve(address(0), tokenId);
1421 
1422         // Clear metadata (if any)
1423         if (bytes(_tokenURIs[tokenId]).length != 0) {
1424             delete _tokenURIs[tokenId];
1425         }
1426 
1427         _holderTokens[owner].remove(tokenId);
1428 
1429         _tokenOwners.remove(tokenId);
1430 
1431         emit Transfer(owner, address(0), tokenId);
1432     }
1433 
1434     /**
1435      * @dev Internal function to transfer ownership of a given token ID to another address.
1436      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1437      * @param from current owner of the token
1438      * @param to address to receive the ownership of the given token ID
1439      * @param tokenId uint256 ID of the token to be transferred
1440      */
1441     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1442         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1443         require(to != address(0), "ERC721: transfer to the zero address");
1444 
1445         _beforeTokenTransfer(from, to, tokenId);
1446 
1447         // Clear approvals from the previous owner
1448         _approve(address(0), tokenId);
1449 
1450         _holderTokens[from].remove(tokenId);
1451         _holderTokens[to].add(tokenId);
1452 
1453         _tokenOwners.set(tokenId, to);
1454 
1455         emit Transfer(from, to, tokenId);
1456     }
1457 
1458     /**
1459      * @dev Internal function to set the token URI for a given token.
1460      *
1461      * Reverts if the token ID does not exist.
1462      *
1463      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1464      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1465      * it and save gas.
1466      */
1467     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1468         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1469         _tokenURIs[tokenId] = _tokenURI;
1470     }
1471 
1472     /**
1473      * @dev Internal function to set the base URI for all token IDs. It is
1474      * automatically added as a prefix to the value returned in {tokenURI},
1475      * or to the token ID if {tokenURI} is empty.
1476      */
1477     function _setBaseURI(string memory baseURI_) internal virtual {
1478         _baseURI = baseURI_;
1479     }
1480 
1481     /**
1482      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1483      * The call is not executed if the target address is not a contract.
1484      *
1485      * @param from address representing the previous owner of the given token ID
1486      * @param to target address that will receive the tokens
1487      * @param tokenId uint256 ID of the token to be transferred
1488      * @param _data bytes optional data to send along with the call
1489      * @return bool whether the call correctly returned the expected magic value
1490      */
1491     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1492         private returns (bool)
1493     {
1494         if (!to.isContract()) {
1495             return true;
1496         }
1497         // solhint-disable-next-line avoid-low-level-calls
1498         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1499             IERC721Receiver(to).onERC721Received.selector,
1500             _msgSender(),
1501             from,
1502             tokenId,
1503             _data
1504         ));
1505         if (!success) {
1506             if (returndata.length > 0) {
1507                 // solhint-disable-next-line no-inline-assembly
1508                 assembly {
1509                     let returndata_size := mload(returndata)
1510                     revert(add(32, returndata), returndata_size)
1511                 }
1512             } else {
1513                 revert("ERC721: transfer to non ERC721Receiver implementer");
1514             }
1515         } else {
1516             bytes4 retval = abi.decode(returndata, (bytes4));
1517             return (retval == _ERC721_RECEIVED);
1518         }
1519     }
1520 
1521     function _approve(address to, uint256 tokenId) private {
1522         _tokenApprovals[tokenId] = to;
1523         emit Approval(ownerOf(tokenId), to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev Hook that is called before any token transfer. This includes minting
1528      * and burning.
1529      *
1530      * Calling conditions:
1531      *
1532      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1533      * transferred to `to`.
1534      * - when `from` is zero, `tokenId` will be minted for `to`.
1535      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1536      * - `from` and `to` are never both zero.
1537      *
1538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1539      */
1540     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1541 }
1542 
1543 // File: contracts/ERC721SimpleMapsURI.sol
1544 
1545 pragma solidity ^0.6.0;
1546 
1547 
1548 /**
1549  * @title ERC721 With a nicer simple token URI
1550  * @dev see https://eips.ethereum.org/EIPS/eip-721
1551  */
1552 contract ERC721SimpleMapsURI is ERC721 {
1553 
1554     // Similar to ERC1155 URI() event, but without a token ID.
1555     event BaseURI(string value);
1556 
1557     constructor (string memory name, string memory symbol, string memory baseURI)
1558     ERC721(name, symbol)
1559     public
1560     {
1561         _setBaseURI(baseURI);
1562     }
1563 
1564     /**
1565      * @dev Internal function to set the base URI for all token IDs. It is
1566      * automatically added as a prefix to the value returned in {tokenURI}.
1567      */
1568     function _setBaseURI(string memory baseURI_) internal override virtual {
1569         super._setBaseURI(baseURI_);
1570         emit BaseURI(baseURI());
1571     }
1572 
1573 }
1574 
1575 // File: contracts/ENSReverseRegistrarI.sol
1576 
1577 /*
1578  * Interfaces for ENS Reverse Registrar
1579  * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
1580  * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
1581  *
1582  * Use this as follows (registryAddress is the address of the ENS registry to use):
1583  * -----
1584  * // This hex value is caclulated by namehash('addr.reverse')
1585  * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
1586  * function registerReverseENS(address registryAddress, string memory calldata) external {
1587  *     require(registryAddress != address(0), "need a valid registry");
1588  *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
1589  *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
1590  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
1591  * }
1592  * -----
1593  * or
1594  * -----
1595  * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
1596  *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
1597  *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
1598  * }
1599  * -----
1600  * ENS deployments can be found at https://docs.ens.domains/ens-deployments
1601  * E.g. Etherscan can be used to look up that owner on those contracts.
1602  * namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"
1603  * Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"
1604  * Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"
1605  */
1606 pragma solidity ^0.6.0;
1607 
1608 interface ENSRegistryOwnerI {
1609     function owner(bytes32 node) external view returns (address);
1610 }
1611 
1612 interface ENSReverseRegistrarI {
1613     function setName(string calldata name) external returns (bytes32 node);
1614 }
1615 
1616 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1617 
1618 pragma solidity ^0.6.0;
1619 
1620 /**
1621  * @dev Interface of the ERC20 standard as defined in the EIP.
1622  */
1623 interface IERC20 {
1624     /**
1625      * @dev Returns the amount of tokens in existence.
1626      */
1627     function totalSupply() external view returns (uint256);
1628 
1629     /**
1630      * @dev Returns the amount of tokens owned by `account`.
1631      */
1632     function balanceOf(address account) external view returns (uint256);
1633 
1634     /**
1635      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1636      *
1637      * Returns a boolean value indicating whether the operation succeeded.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function transfer(address recipient, uint256 amount) external returns (bool);
1642 
1643     /**
1644      * @dev Returns the remaining number of tokens that `spender` will be
1645      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1646      * zero by default.
1647      *
1648      * This value changes when {approve} or {transferFrom} are called.
1649      */
1650     function allowance(address owner, address spender) external view returns (uint256);
1651 
1652     /**
1653      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1654      *
1655      * Returns a boolean value indicating whether the operation succeeded.
1656      *
1657      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1658      * that someone may use both the old and the new allowance by unfortunate
1659      * transaction ordering. One possible solution to mitigate this race
1660      * condition is to first reduce the spender's allowance to 0 and set the
1661      * desired value afterwards:
1662      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1663      *
1664      * Emits an {Approval} event.
1665      */
1666     function approve(address spender, uint256 amount) external returns (bool);
1667 
1668     /**
1669      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1670      * allowance mechanism. `amount` is then deducted from the caller's
1671      * allowance.
1672      *
1673      * Returns a boolean value indicating whether the operation succeeded.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1678 
1679     /**
1680      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1681      * another (`to`).
1682      *
1683      * Note that `value` may be zero.
1684      */
1685     event Transfer(address indexed from, address indexed to, uint256 value);
1686 
1687     /**
1688      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1689      * a call to {approve}. `value` is the new allowance.
1690      */
1691     event Approval(address indexed owner, address indexed spender, uint256 value);
1692 }
1693 
1694 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
1695 
1696 pragma solidity ^0.6.0;
1697 
1698 /**
1699  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1700  *
1701  * These functions can be used to verify that a message was signed by the holder
1702  * of the private keys of a given address.
1703  */
1704 library ECDSA {
1705     /**
1706      * @dev Returns the address that signed a hashed message (`hash`) with
1707      * `signature`. This address can then be used for verification purposes.
1708      *
1709      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1710      * this function rejects them by requiring the `s` value to be in the lower
1711      * half order, and the `v` value to be either 27 or 28.
1712      *
1713      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1714      * verification to be secure: it is possible to craft signatures that
1715      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1716      * this is by receiving a hash of the original message (which may otherwise
1717      * be too long), and then calling {toEthSignedMessageHash} on it.
1718      */
1719     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1720         // Check the signature length
1721         if (signature.length != 65) {
1722             revert("ECDSA: invalid signature length");
1723         }
1724 
1725         // Divide the signature in r, s and v variables
1726         bytes32 r;
1727         bytes32 s;
1728         uint8 v;
1729 
1730         // ecrecover takes the signature parameters, and the only way to get them
1731         // currently is to use assembly.
1732         // solhint-disable-next-line no-inline-assembly
1733         assembly {
1734             r := mload(add(signature, 0x20))
1735             s := mload(add(signature, 0x40))
1736             v := byte(0, mload(add(signature, 0x60)))
1737         }
1738 
1739         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1740         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1741         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1742         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1743         //
1744         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1745         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1746         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1747         // these malleable signatures as well.
1748         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1749             revert("ECDSA: invalid signature 's' value");
1750         }
1751 
1752         if (v != 27 && v != 28) {
1753             revert("ECDSA: invalid signature 'v' value");
1754         }
1755 
1756         // If the signature is valid (and not malleable), return the signer address
1757         address signer = ecrecover(hash, v, r, s);
1758         require(signer != address(0), "ECDSA: invalid signature");
1759 
1760         return signer;
1761     }
1762 
1763     /**
1764      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1765      * replicates the behavior of the
1766      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1767      * JSON-RPC method.
1768      *
1769      * See {recover}.
1770      */
1771     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1772         // 32 is the length in bytes of hash,
1773         // enforced by the type signature above
1774         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1775     }
1776 }
1777 
1778 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
1779 
1780 pragma solidity ^0.6.0;
1781 
1782 /**
1783  * @dev These functions deal with verification of Merkle trees (hash trees),
1784  */
1785 library MerkleProof {
1786     /**
1787      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1788      * defined by `root`. For this, a `proof` must be provided, containing
1789      * sibling hashes on the branch from the leaf to the root of the tree. Each
1790      * pair of leaves and each pair of pre-images are assumed to be sorted.
1791      */
1792     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1793         bytes32 computedHash = leaf;
1794 
1795         for (uint256 i = 0; i < proof.length; i++) {
1796             bytes32 proofElement = proof[i];
1797 
1798             if (computedHash <= proofElement) {
1799                 // Hash(current computed hash + current element of the proof)
1800                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1801             } else {
1802                 // Hash(current element of the proof + current computed hash)
1803                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1804             }
1805         }
1806 
1807         // Check if the computed hash (root) is equal to the provided root
1808         return computedHash == root;
1809     }
1810 }
1811 
1812 // File: contracts/CryptostampGoldenUnicorn.sol
1813 
1814 /*
1815 Implements ERC 721 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1816 */
1817 pragma solidity ^0.6.0;
1818 
1819 
1820 
1821 
1822 
1823 
1824 /* The inheritance is very much the same as OpenZeppelin's ERC721Full,
1825  * but using simplified (and cheaper) versions of ERC721Enumerable and ERC721Metadata */
1826 contract CryptostampGoldenUnicorn is ERC721SimpleMapsURI {
1827     using SafeMath for uint256;
1828 
1829     address public createControl;
1830     address public shippingControl;
1831     address public tokenAssignmentControl;
1832 
1833     uint256 immutable finalSupply;
1834 
1835     mapping(address => uint256) public signedTransferNonce;
1836 
1837     event CreateControlTransferred(address indexed previousCreateControl, address indexed newCreateControl);
1838     event ShippingControlTransferred(address indexed previousShippingControl, address indexed newShippingControl);
1839     event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);
1840     event SignedTransfer(address operator, address indexed from, address indexed to, uint256 indexed tokenId, uint256 signedTransferNonce);
1841 
1842     constructor(address _createControl, address _shippingControl, address _tokenAssignmentControl, uint256 _finalSupply)
1843     ERC721SimpleMapsURI("Crypto stamp Golden Unicorn", "CSGU", "https://test.crypto.post.at/CSGU/meta/")
1844     public
1845     {
1846         createControl = _createControl;
1847         require(address(createControl) != address(0x0), "You need to provide an actual createControl address.");
1848         shippingControl = _shippingControl;
1849         require(address(shippingControl) != address(0x0), "You need to provide an actual shippingControl address.");
1850         tokenAssignmentControl = _tokenAssignmentControl;
1851         require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
1852         finalSupply = _finalSupply;
1853     }
1854 
1855     modifier onlyCreateControl()
1856     {
1857         require(msg.sender == createControl, "createControl key required for this function.");
1858         _;
1859     }
1860 
1861     modifier onlyShippingControl() {
1862         require(msg.sender == shippingControl, "shippingControl key required for this function.");
1863         _;
1864     }
1865 
1866     modifier onlyTokenAssignmentControl() {
1867         require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
1868         _;
1869     }
1870 
1871     modifier onlyMinter()
1872     {
1873         // Both the actual create control key and the shipping control key that delivers the on-chain raffle can mint Golden Unicorns.
1874         require(msg.sender == createControl || msg.sender == shippingControl, "createControl or shippingControl key required for this function.");
1875         _;
1876     }
1877 
1878     modifier requireMinting() {
1879         require(mintingFinished() == false, "This call only works when minting is not finished.");
1880         _;
1881     }
1882 
1883     /*** Enable adjusting variables after deployment ***/
1884 
1885     function transferTokenAssignmentControl(address _newTokenAssignmentControl)
1886     public
1887     onlyTokenAssignmentControl
1888     {
1889         require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");
1890         emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);
1891         tokenAssignmentControl = _newTokenAssignmentControl;
1892     }
1893 
1894     function transferCreateControl(address _newCreateControl)
1895     public
1896     onlyCreateControl
1897     {
1898         require(_newCreateControl != address(0), "createControl cannot be the zero address.");
1899         emit CreateControlTransferred(createControl, _newCreateControl);
1900         createControl = _newCreateControl;
1901     }
1902 
1903     function transferShippingControl(address _newShippingControl)
1904     public
1905     onlyShippingControl
1906     {
1907         require(_newShippingControl != address(0), "shippingControl cannot be the zero address.");
1908         emit ShippingControlTransferred(shippingControl, _newShippingControl);
1909         shippingControl = _newShippingControl;
1910     }
1911 
1912     /*** Base functionality: minting, URI, property getters, etc. ***/
1913 
1914     // Override totalSupply() so it reports the target final supply.
1915     /**
1916      * @dev Gets the total amount of tokens stored by the contract.
1917      * @return uint256 representing the total amount of tokens
1918      */
1919     function totalSupply()
1920     public view override
1921     returns (uint256) {
1922         return finalSupply;
1923     }
1924 
1925     /**
1926      * @dev Gets the actually minted amount of tokens in the contract.
1927      * @return uint256 representing the minted amount of tokens
1928      */
1929     function mintedSupply()
1930     public view
1931     returns (uint256) {
1932         return super.totalSupply();
1933     }
1934 
1935     // Issue a new crypto stamp asset, giving it to a specific owner address.
1936     // As appending the ID into a URI in Solidity is complicated, generate both
1937     // externally and hand them over to the asset here.
1938     function create(uint256 _tokenId, address _owner)
1939     public
1940     onlyMinter
1941     requireMinting
1942     {
1943         require(_tokenId < finalSupply, "Cannot mint token with too high ID");
1944         // _mint already ends up checking if owner != 0 and that tokenId doesn't exist yet.
1945         _mint(_owner, _tokenId);
1946     }
1947 
1948     // Batch-issue multiple crypto stamps with adjacent IDs.
1949     function createMulti(uint256 _tokenIdStart, address[] memory _owners)
1950     public
1951     onlyMinter
1952     requireMinting
1953     {
1954         uint256 addrcount = _owners.length;
1955         require(_tokenIdStart + addrcount - 1 < finalSupply, "Cannot mint token with too high ID");
1956         for (uint256 i = 0; i < addrcount; i++) {
1957             // Make sure this is in sync with what create() does.
1958             _mint(_owners[i], _tokenIdStart + i);
1959         }
1960     }
1961 
1962     // Determine if the creation/minting process is done.
1963     function mintingFinished()
1964     public view
1965     returns (bool)
1966     {
1967         return (super.totalSupply() >= finalSupply);
1968     }
1969 
1970     // Set new base for the token URI.
1971     function setBaseURI(string memory _newBaseURI)
1972     public
1973     onlyMinter
1974     {
1975         super._setBaseURI(_newBaseURI);
1976     }
1977 
1978     // Returns whether the specified token exists
1979     function exists(uint256 tokenId)
1980     public view
1981     returns (bool) {
1982         return _exists(tokenId);
1983     }
1984 
1985     /*** Special properties of Golden Unicorns ***/
1986 
1987     function sourceSale(uint256 _tokenId)
1988     public view
1989     returns (bool) {
1990         require(_tokenId < finalSupply, "Property query for nonexistent token");
1991         return _tokenId >= finalSupply / 2 - 1 && _tokenId < finalSupply - 1;
1992     }
1993 
1994     function sourceRaffle(uint256 _tokenId)
1995     public view
1996     returns (bool) {
1997         return !sourceSale(_tokenId);
1998     }
1999 
2000     function sourceOnChainRaffle(uint256 _tokenId)
2001     public view
2002     returns (bool) {
2003         require(_tokenId < finalSupply, "Property query for nonexistent token");
2004         return _tokenId <= finalSupply * 3 / 10 - 2;
2005     }
2006 
2007     function isLastUnicorn(uint256 _tokenId)
2008     public view
2009     returns (bool) {
2010         require(_tokenId < finalSupply, "Property query for nonexistent token");
2011         return _tokenId == finalSupply - 1;
2012     }
2013 
2014     /*** Allows any user to initiate a transfer with the signature of the current stamp owner  ***/
2015 
2016     // Outward-facing function for signed transfer: assembles the expected data and then calls the internal function to do the rest.
2017     // Can called by anyone knowing about the right signature, but can only transfer to the given specific target.
2018     function signedTransfer(uint256 _tokenId, address _to, bytes memory _signature)
2019     public
2020     {
2021         address currentOwner = ownerOf(_tokenId);
2022         // The signed data contains the token ID, the transfer target and a nonce.
2023         bytes32 data = keccak256(abi.encodePacked(address(this), this.signedTransfer.selector, currentOwner, _to, _tokenId, signedTransferNonce[currentOwner]));
2024         _signedTransferInternal(currentOwner, data, _tokenId, _to, _signature);
2025     }
2026 
2027     // Outward-facing function for operator-driven signed transfer: assembles the expected data and then calls the internal function to do the rest.
2028     // Can transfer to any target, but only be called by the trusted operator contained in the signature.
2029     function signedTransferWithOperator(uint256 _tokenId, address _to, bytes memory _signature)
2030     public
2031     {
2032         address currentOwner = ownerOf(_tokenId);
2033         // The signed data contains the operator, the token ID, and a nonce. Note that we use the selector of the external function here!
2034         bytes32 data = keccak256(abi.encodePacked(address(this), this.signedTransferWithOperator.selector, msg.sender, currentOwner, _tokenId, signedTransferNonce[currentOwner]));
2035         _signedTransferInternal(currentOwner, data, _tokenId, _to, _signature);
2036     }
2037 
2038     // Actually check the signature and perform a signed transfer.
2039     function _signedTransferInternal(address _currentOwner, bytes32 _data, uint256 _tokenId, address _to, bytes memory _signature)
2040     internal
2041     {
2042         bytes32 hash = ECDSA.toEthSignedMessageHash(_data);
2043         address signer = ECDSA.recover(hash, _signature);
2044         require(signer == _currentOwner, "Signature needs to match parameters, nonce, and current owner.");
2045         // Now that we checked that the signature is correct, do the actual transfer and increase the nonce.
2046         emit SignedTransfer(msg.sender, _currentOwner, _to, _tokenId, signedTransferNonce[_currentOwner]);
2047         signedTransferNonce[_currentOwner] = signedTransferNonce[_currentOwner].add(1);
2048         _safeTransfer(_currentOwner, _to, _tokenId, "");
2049     }
2050 
2051     /*** Enable reverse ENS registration ***/
2052 
2053     // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
2054     // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
2055     // See https://docs.ens.domains/ens-deployments for address of ENS deployments, e.g. Etherscan can be used to look up that owner on those.
2056     // namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"
2057     // Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"
2058     // Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"
2059     function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
2060     external
2061     onlyTokenAssignmentControl
2062     {
2063        require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
2064        ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
2065     }
2066 
2067     /*** Make sure currency doesn't get stranded in this contract ***/
2068 
2069     // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
2070     function rescueToken(IERC20 _foreignToken, address _to)
2071     external
2072     onlyTokenAssignmentControl
2073     {
2074         _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
2075     }
2076 
2077     // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
2078     function approveNFTrescue(IERC721 _foreignNFT, address _to)
2079     external
2080     onlyTokenAssignmentControl
2081     {
2082         _foreignNFT.setApprovalForAll(_to, true);
2083     }
2084 
2085     // Make sure this contract cannot receive ETH.
2086     receive()
2087     external payable
2088     {
2089         revert("The contract cannot receive ETH payments.");
2090     }
2091 }