1 // File: contracts\GFarmInterface.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.7.5;
5 
6 interface GFarmInterface{
7 	function NFT_CREDITS_amount(address a) external view returns(uint);
8 	function spendCredits(address a, uint requiredCredits) external;
9 }
10 
11 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
12 
13 pragma solidity ^0.7.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
37 
38 pragma solidity ^0.7.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45  * queried by others ({ERC165Checker}).
46  *
47  * For an implementation, see {ERC165}.
48  */
49 interface IERC165 {
50     /**
51      * @dev Returns true if this contract implements the interface defined by
52      * `interfaceId`. See the corresponding
53      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
54      * to learn more about how these ids are created.
55      *
56      * This function call must use less than 30 000 gas.
57      */
58     function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 
61 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
62 
63 pragma solidity ^0.7.0;
64 
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
77      */
78     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
82      */
83     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(address from, address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Transfers `tokenId` token from `from` to `to`.
117      *
118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(address from, address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175       * @dev Safely transfers `tokenId` token from `from` to `to`.
176       *
177       * Requirements:
178       *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181       * - `tokenId` token must exist and be owned by `from`.
182       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184       *
185       * Emits a {Transfer} event.
186       */
187     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
188 }
189 
190 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
191 
192 pragma solidity ^0.7.0;
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
217 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Enumerable.sol
218 
219 pragma solidity ^0.7.0;
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
246 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
247 
248 pragma solidity ^0.7.0;
249 
250 /**
251  * @title ERC721 token receiver interface
252  * @dev Interface for any contract that wants to support safeTransfers
253  * from ERC721 asset contracts.
254  */
255 interface IERC721Receiver {
256     /**
257      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
258      * by `operator` from `from`, this function is called.
259      *
260      * It must return its Solidity selector to confirm the token transfer.
261      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
262      *
263      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
264      */
265     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
266     external returns (bytes4);
267 }
268 
269 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
270 
271 pragma solidity ^0.7.0;
272 
273 
274 /**
275  * @dev Implementation of the {IERC165} interface.
276  *
277  * Contracts may inherit from this and call {_registerInterface} to declare
278  * their support of an interface.
279  */
280 abstract contract ERC165 is IERC165 {
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
291     constructor () {
292         // Derived contracts need only register support for their own interfaces,
293         // we register support for ERC165 itself here
294         _registerInterface(_INTERFACE_ID_ERC165);
295     }
296 
297     /**
298      * @dev See {IERC165-supportsInterface}.
299      *
300      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
301      */
302     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
303         return _supportedInterfaces[interfaceId];
304     }
305 
306     /**
307      * @dev Registers the contract as an implementer of the interface defined by
308      * `interfaceId`. Support of the actual ERC165 interface is automatic and
309      * registering its interface id is not required.
310      *
311      * See {IERC165-supportsInterface}.
312      *
313      * Requirements:
314      *
315      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
316      */
317     function _registerInterface(bytes4 interfaceId) internal virtual {
318         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
319         _supportedInterfaces[interfaceId] = true;
320     }
321 }
322 
323 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
324 
325 pragma solidity ^0.7.0;
326 
327 /**
328  * @dev Wrappers over Solidity's arithmetic operations with added overflow
329  * checks.
330  *
331  * Arithmetic operations in Solidity wrap on overflow. This can easily result
332  * in bugs, because programmers usually assume that an overflow raises an
333  * error, which is the standard behavior in high level programming languages.
334  * `SafeMath` restores this intuition by reverting the transaction when an
335  * operation overflows.
336  *
337  * Using this library instead of the unchecked operations eliminates an entire
338  * class of bugs, so it's recommended to use it always.
339  */
340 library SafeMath {
341     /**
342      * @dev Returns the addition of two unsigned integers, reverting on
343      * overflow.
344      *
345      * Counterpart to Solidity's `+` operator.
346      *
347      * Requirements:
348      *
349      * - Addition cannot overflow.
350      */
351     function add(uint256 a, uint256 b) internal pure returns (uint256) {
352         uint256 c = a + b;
353         require(c >= a, "SafeMath: addition overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the subtraction of two unsigned integers, reverting on
360      * overflow (when the result is negative).
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
369         return sub(a, b, "SafeMath: subtraction overflow");
370     }
371 
372     /**
373      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
374      * overflow (when the result is negative).
375      *
376      * Counterpart to Solidity's `-` operator.
377      *
378      * Requirements:
379      *
380      * - Subtraction cannot overflow.
381      */
382     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
383         require(b <= a, errorMessage);
384         uint256 c = a - b;
385 
386         return c;
387     }
388 
389     /**
390      * @dev Returns the multiplication of two unsigned integers, reverting on
391      * overflow.
392      *
393      * Counterpart to Solidity's `*` operator.
394      *
395      * Requirements:
396      *
397      * - Multiplication cannot overflow.
398      */
399     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
401         // benefit is lost if 'b' is also tested.
402         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
403         if (a == 0) {
404             return 0;
405         }
406 
407         uint256 c = a * b;
408         require(c / a == b, "SafeMath: multiplication overflow");
409 
410         return c;
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers. Reverts on
415      * division by zero. The result is rounded towards zero.
416      *
417      * Counterpart to Solidity's `/` operator. Note: this function uses a
418      * `revert` opcode (which leaves remaining gas untouched) while Solidity
419      * uses an invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
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
438      *
439      * - The divisor cannot be zero.
440      */
441     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
462         return mod(a, b, "SafeMath: modulo by zero");
463     }
464 
465     /**
466      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
467      * Reverts with custom message when dividing by zero.
468      *
469      * Counterpart to Solidity's `%` operator. This function uses a `revert`
470      * opcode (which leaves remaining gas untouched) while Solidity uses an
471      * invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
478         require(b != 0, errorMessage);
479         return a % b;
480     }
481 }
482 
483 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
484 
485 pragma solidity ^0.7.0;
486 
487 /**
488  * @dev Collection of functions related to the address type
489  */
490 library Address {
491     /**
492      * @dev Returns true if `account` is a contract.
493      *
494      * [IMPORTANT]
495      * ====
496      * It is unsafe to assume that an address for which this function returns
497      * false is an externally-owned account (EOA) and not a contract.
498      *
499      * Among others, `isContract` will return false for the following
500      * types of addresses:
501      *
502      *  - an externally-owned account
503      *  - a contract in construction
504      *  - an address where a contract will be created
505      *  - an address where a contract lived, but was destroyed
506      * ====
507      */
508     function isContract(address account) internal view returns (bool) {
509         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
510         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
511         // for accounts without code, i.e. `keccak256('')`
512         bytes32 codehash;
513         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
514         // solhint-disable-next-line no-inline-assembly
515         assembly { codehash := extcodehash(account) }
516         return (codehash != accountHash && codehash != 0x0);
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
539         (bool success, ) = recipient.call{ value: amount }("");
540         require(success, "Address: unable to send value, recipient may have reverted");
541     }
542 
543     /**
544      * @dev Performs a Solidity function call using a low level `call`. A
545      * plain`call` is an unsafe replacement for a function call: use this
546      * function instead.
547      *
548      * If `target` reverts with a revert reason, it is bubbled up by this
549      * function (like regular Solidity function calls).
550      *
551      * Returns the raw returned data. To convert to the expected return value,
552      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
553      *
554      * Requirements:
555      *
556      * - `target` must be a contract.
557      * - calling `target` with `data` must not revert.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
562       return functionCall(target, data, "Address: low-level call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
567      * `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
572         return _functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
592      * with `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
597         require(address(this).balance >= value, "Address: insufficient balance for call");
598         return _functionCallWithValue(target, data, value, errorMessage);
599     }
600 
601     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
602         require(isContract(target), "Address: call to non-contract");
603 
604         // solhint-disable-next-line avoid-low-level-calls
605         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 // solhint-disable-next-line no-inline-assembly
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
626 
627 pragma solidity ^0.7.0;
628 
629 /**
630  * @dev Library for managing
631  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
632  * types.
633  *
634  * Sets have the following properties:
635  *
636  * - Elements are added, removed, and checked for existence in constant time
637  * (O(1)).
638  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
639  *
640  * ```
641  * contract Example {
642  *     // Add the library methods
643  *     using EnumerableSet for EnumerableSet.AddressSet;
644  *
645  *     // Declare a set state variable
646  *     EnumerableSet.AddressSet private mySet;
647  * }
648  * ```
649  *
650  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
651  * (`UintSet`) are supported.
652  */
653 library EnumerableSet {
654     // To implement this library for multiple types with as little code
655     // repetition as possible, we write it in terms of a generic Set type with
656     // bytes32 values.
657     // The Set implementation uses private functions, and user-facing
658     // implementations (such as AddressSet) are just wrappers around the
659     // underlying Set.
660     // This means that we can only create new EnumerableSets for types that fit
661     // in bytes32.
662 
663     struct Set {
664         // Storage of set values
665         bytes32[] _values;
666 
667         // Position of the value in the `values` array, plus 1 because index 0
668         // means a value is not in the set.
669         mapping (bytes32 => uint256) _indexes;
670     }
671 
672     /**
673      * @dev Add a value to a set. O(1).
674      *
675      * Returns true if the value was added to the set, that is if it was not
676      * already present.
677      */
678     function _add(Set storage set, bytes32 value) private returns (bool) {
679         if (!_contains(set, value)) {
680             set._values.push(value);
681             // The value is stored at length-1, but we add 1 to all indexes
682             // and use 0 as a sentinel value
683             set._indexes[value] = set._values.length;
684             return true;
685         } else {
686             return false;
687         }
688     }
689 
690     /**
691      * @dev Removes a value from a set. O(1).
692      *
693      * Returns true if the value was removed from the set, that is if it was
694      * present.
695      */
696     function _remove(Set storage set, bytes32 value) private returns (bool) {
697         // We read and store the value's index to prevent multiple reads from the same storage slot
698         uint256 valueIndex = set._indexes[value];
699 
700         if (valueIndex != 0) { // Equivalent to contains(set, value)
701             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
702             // the array, and then remove the last element (sometimes called as 'swap and pop').
703             // This modifies the order of the array, as noted in {at}.
704 
705             uint256 toDeleteIndex = valueIndex - 1;
706             uint256 lastIndex = set._values.length - 1;
707 
708             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
709             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
710 
711             bytes32 lastvalue = set._values[lastIndex];
712 
713             // Move the last value to the index where the value to delete is
714             set._values[toDeleteIndex] = lastvalue;
715             // Update the index for the moved value
716             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
717 
718             // Delete the slot where the moved value was stored
719             set._values.pop();
720 
721             // Delete the index for the deleted slot
722             delete set._indexes[value];
723 
724             return true;
725         } else {
726             return false;
727         }
728     }
729 
730     /**
731      * @dev Returns true if the value is in the set. O(1).
732      */
733     function _contains(Set storage set, bytes32 value) private view returns (bool) {
734         return set._indexes[value] != 0;
735     }
736 
737     /**
738      * @dev Returns the number of values on the set. O(1).
739      */
740     function _length(Set storage set) private view returns (uint256) {
741         return set._values.length;
742     }
743 
744    /**
745     * @dev Returns the value stored at position `index` in the set. O(1).
746     *
747     * Note that there are no guarantees on the ordering of values inside the
748     * array, and it may change when more values are added or removed.
749     *
750     * Requirements:
751     *
752     * - `index` must be strictly less than {length}.
753     */
754     function _at(Set storage set, uint256 index) private view returns (bytes32) {
755         require(set._values.length > index, "EnumerableSet: index out of bounds");
756         return set._values[index];
757     }
758 
759     // AddressSet
760 
761     struct AddressSet {
762         Set _inner;
763     }
764 
765     /**
766      * @dev Add a value to a set. O(1).
767      *
768      * Returns true if the value was added to the set, that is if it was not
769      * already present.
770      */
771     function add(AddressSet storage set, address value) internal returns (bool) {
772         return _add(set._inner, bytes32(uint256(value)));
773     }
774 
775     /**
776      * @dev Removes a value from a set. O(1).
777      *
778      * Returns true if the value was removed from the set, that is if it was
779      * present.
780      */
781     function remove(AddressSet storage set, address value) internal returns (bool) {
782         return _remove(set._inner, bytes32(uint256(value)));
783     }
784 
785     /**
786      * @dev Returns true if the value is in the set. O(1).
787      */
788     function contains(AddressSet storage set, address value) internal view returns (bool) {
789         return _contains(set._inner, bytes32(uint256(value)));
790     }
791 
792     /**
793      * @dev Returns the number of values in the set. O(1).
794      */
795     function length(AddressSet storage set) internal view returns (uint256) {
796         return _length(set._inner);
797     }
798 
799    /**
800     * @dev Returns the value stored at position `index` in the set. O(1).
801     *
802     * Note that there are no guarantees on the ordering of values inside the
803     * array, and it may change when more values are added or removed.
804     *
805     * Requirements:
806     *
807     * - `index` must be strictly less than {length}.
808     */
809     function at(AddressSet storage set, uint256 index) internal view returns (address) {
810         return address(uint256(_at(set._inner, index)));
811     }
812 
813 
814     // UintSet
815 
816     struct UintSet {
817         Set _inner;
818     }
819 
820     /**
821      * @dev Add a value to a set. O(1).
822      *
823      * Returns true if the value was added to the set, that is if it was not
824      * already present.
825      */
826     function add(UintSet storage set, uint256 value) internal returns (bool) {
827         return _add(set._inner, bytes32(value));
828     }
829 
830     /**
831      * @dev Removes a value from a set. O(1).
832      *
833      * Returns true if the value was removed from the set, that is if it was
834      * present.
835      */
836     function remove(UintSet storage set, uint256 value) internal returns (bool) {
837         return _remove(set._inner, bytes32(value));
838     }
839 
840     /**
841      * @dev Returns true if the value is in the set. O(1).
842      */
843     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
844         return _contains(set._inner, bytes32(value));
845     }
846 
847     /**
848      * @dev Returns the number of values on the set. O(1).
849      */
850     function length(UintSet storage set) internal view returns (uint256) {
851         return _length(set._inner);
852     }
853 
854    /**
855     * @dev Returns the value stored at position `index` in the set. O(1).
856     *
857     * Note that there are no guarantees on the ordering of values inside the
858     * array, and it may change when more values are added or removed.
859     *
860     * Requirements:
861     *
862     * - `index` must be strictly less than {length}.
863     */
864     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
865         return uint256(_at(set._inner, index));
866     }
867 }
868 
869 // File: node_modules\@openzeppelin\contracts\utils\EnumerableMap.sol
870 
871 pragma solidity ^0.7.0;
872 
873 /**
874  * @dev Library for managing an enumerable variant of Solidity's
875  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
876  * type.
877  *
878  * Maps have the following properties:
879  *
880  * - Entries are added, removed, and checked for existence in constant time
881  * (O(1)).
882  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
883  *
884  * ```
885  * contract Example {
886  *     // Add the library methods
887  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
888  *
889  *     // Declare a set state variable
890  *     EnumerableMap.UintToAddressMap private myMap;
891  * }
892  * ```
893  *
894  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
895  * supported.
896  */
897 library EnumerableMap {
898     // To implement this library for multiple types with as little code
899     // repetition as possible, we write it in terms of a generic Map type with
900     // bytes32 keys and values.
901     // The Map implementation uses private functions, and user-facing
902     // implementations (such as Uint256ToAddressMap) are just wrappers around
903     // the underlying Map.
904     // This means that we can only create new EnumerableMaps for types that fit
905     // in bytes32.
906 
907     struct MapEntry {
908         bytes32 _key;
909         bytes32 _value;
910     }
911 
912     struct Map {
913         // Storage of map keys and values
914         MapEntry[] _entries;
915 
916         // Position of the entry defined by a key in the `entries` array, plus 1
917         // because index 0 means a key is not in the map.
918         mapping (bytes32 => uint256) _indexes;
919     }
920 
921     /**
922      * @dev Adds a key-value pair to a map, or updates the value for an existing
923      * key. O(1).
924      *
925      * Returns true if the key was added to the map, that is if it was not
926      * already present.
927      */
928     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
929         // We read and store the key's index to prevent multiple reads from the same storage slot
930         uint256 keyIndex = map._indexes[key];
931 
932         if (keyIndex == 0) { // Equivalent to !contains(map, key)
933             map._entries.push(MapEntry({ _key: key, _value: value }));
934             // The entry is stored at length-1, but we add 1 to all indexes
935             // and use 0 as a sentinel value
936             map._indexes[key] = map._entries.length;
937             return true;
938         } else {
939             map._entries[keyIndex - 1]._value = value;
940             return false;
941         }
942     }
943 
944     /**
945      * @dev Removes a key-value pair from a map. O(1).
946      *
947      * Returns true if the key was removed from the map, that is if it was present.
948      */
949     function _remove(Map storage map, bytes32 key) private returns (bool) {
950         // We read and store the key's index to prevent multiple reads from the same storage slot
951         uint256 keyIndex = map._indexes[key];
952 
953         if (keyIndex != 0) { // Equivalent to contains(map, key)
954             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
955             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
956             // This modifies the order of the array, as noted in {at}.
957 
958             uint256 toDeleteIndex = keyIndex - 1;
959             uint256 lastIndex = map._entries.length - 1;
960 
961             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
962             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
963 
964             MapEntry storage lastEntry = map._entries[lastIndex];
965 
966             // Move the last entry to the index where the entry to delete is
967             map._entries[toDeleteIndex] = lastEntry;
968             // Update the index for the moved entry
969             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
970 
971             // Delete the slot where the moved entry was stored
972             map._entries.pop();
973 
974             // Delete the index for the deleted slot
975             delete map._indexes[key];
976 
977             return true;
978         } else {
979             return false;
980         }
981     }
982 
983     /**
984      * @dev Returns true if the key is in the map. O(1).
985      */
986     function _contains(Map storage map, bytes32 key) private view returns (bool) {
987         return map._indexes[key] != 0;
988     }
989 
990     /**
991      * @dev Returns the number of key-value pairs in the map. O(1).
992      */
993     function _length(Map storage map) private view returns (uint256) {
994         return map._entries.length;
995     }
996 
997    /**
998     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
999     *
1000     * Note that there are no guarantees on the ordering of entries inside the
1001     * array, and it may change when more entries are added or removed.
1002     *
1003     * Requirements:
1004     *
1005     * - `index` must be strictly less than {length}.
1006     */
1007     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1008         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1009 
1010         MapEntry storage entry = map._entries[index];
1011         return (entry._key, entry._value);
1012     }
1013 
1014     /**
1015      * @dev Returns the value associated with `key`.  O(1).
1016      *
1017      * Requirements:
1018      *
1019      * - `key` must be in the map.
1020      */
1021     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1022         return _get(map, key, "EnumerableMap: nonexistent key");
1023     }
1024 
1025     /**
1026      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1027      */
1028     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1029         uint256 keyIndex = map._indexes[key];
1030         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1031         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1032     }
1033 
1034     // UintToAddressMap
1035 
1036     struct UintToAddressMap {
1037         Map _inner;
1038     }
1039 
1040     /**
1041      * @dev Adds a key-value pair to a map, or updates the value for an existing
1042      * key. O(1).
1043      *
1044      * Returns true if the key was added to the map, that is if it was not
1045      * already present.
1046      */
1047     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1048         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1049     }
1050 
1051     /**
1052      * @dev Removes a value from a set. O(1).
1053      *
1054      * Returns true if the key was removed from the map, that is if it was present.
1055      */
1056     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1057         return _remove(map._inner, bytes32(key));
1058     }
1059 
1060     /**
1061      * @dev Returns true if the key is in the map. O(1).
1062      */
1063     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1064         return _contains(map._inner, bytes32(key));
1065     }
1066 
1067     /**
1068      * @dev Returns the number of elements in the map. O(1).
1069      */
1070     function length(UintToAddressMap storage map) internal view returns (uint256) {
1071         return _length(map._inner);
1072     }
1073 
1074    /**
1075     * @dev Returns the element stored at position `index` in the set. O(1).
1076     * Note that there are no guarantees on the ordering of values inside the
1077     * array, and it may change when more values are added or removed.
1078     *
1079     * Requirements:
1080     *
1081     * - `index` must be strictly less than {length}.
1082     */
1083     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1084         (bytes32 key, bytes32 value) = _at(map._inner, index);
1085         return (uint256(key), address(uint256(value)));
1086     }
1087 
1088     /**
1089      * @dev Returns the value associated with `key`.  O(1).
1090      *
1091      * Requirements:
1092      *
1093      * - `key` must be in the map.
1094      */
1095     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1096         return address(uint256(_get(map._inner, bytes32(key))));
1097     }
1098 
1099     /**
1100      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1101      */
1102     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1103         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1104     }
1105 }
1106 
1107 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
1108 
1109 pragma solidity ^0.7.0;
1110 
1111 /**
1112  * @dev String operations.
1113  */
1114 library Strings {
1115     /**
1116      * @dev Converts a `uint256` to its ASCII `string` representation.
1117      */
1118     function toString(uint256 value) internal pure returns (string memory) {
1119         // Inspired by OraclizeAPI's implementation - MIT licence
1120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1121 
1122         if (value == 0) {
1123             return "0";
1124         }
1125         uint256 temp = value;
1126         uint256 digits;
1127         while (temp != 0) {
1128             digits++;
1129             temp /= 10;
1130         }
1131         bytes memory buffer = new bytes(digits);
1132         uint256 index = digits - 1;
1133         temp = value;
1134         while (temp != 0) {
1135             buffer[index--] = byte(uint8(48 + temp % 10));
1136             temp /= 10;
1137         }
1138         return string(buffer);
1139     }
1140 }
1141 
1142 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
1143 
1144 pragma solidity ^0.7.0;
1145 
1146 
1147 /**
1148  * @title ERC721 Non-Fungible Token Standard basic implementation
1149  * @dev see https://eips.ethereum.org/EIPS/eip-721
1150  */
1151 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1152     using SafeMath for uint256;
1153     using Address for address;
1154     using EnumerableSet for EnumerableSet.UintSet;
1155     using EnumerableMap for EnumerableMap.UintToAddressMap;
1156     using Strings for uint256;
1157 
1158     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1159     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1160     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1161 
1162     // Mapping from holder address to their (enumerable) set of owned tokens
1163     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1164 
1165     // Enumerable mapping from token ids to their owners
1166     EnumerableMap.UintToAddressMap private _tokenOwners;
1167 
1168     // Mapping from token ID to approved address
1169     mapping (uint256 => address) private _tokenApprovals;
1170 
1171     // Mapping from owner to operator approvals
1172     mapping (address => mapping (address => bool)) private _operatorApprovals;
1173 
1174     // Token name
1175     string private _name;
1176 
1177     // Token symbol
1178     string private _symbol;
1179 
1180     // Optional mapping for token URIs
1181     mapping (uint256 => string) private _tokenURIs;
1182 
1183     // Base URI
1184     string private _baseURI;
1185 
1186     /*
1187      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1188      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1189      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1190      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1191      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1192      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1193      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1194      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1195      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1196      *
1197      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1198      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1199      */
1200     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1201 
1202     /*
1203      *     bytes4(keccak256('name()')) == 0x06fdde03
1204      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1205      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1206      *
1207      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1208      */
1209     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1210 
1211     /*
1212      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1213      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1214      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1215      *
1216      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1217      */
1218     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1219 
1220     /**
1221      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1222      */
1223     constructor (string memory name_, string memory symbol_) {
1224         _name = name_;
1225         _symbol = symbol_;
1226 
1227         // register the supported interfaces to conform to ERC721 via ERC165
1228         _registerInterface(_INTERFACE_ID_ERC721);
1229         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1230         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-balanceOf}.
1235      */
1236     function balanceOf(address owner) public view override returns (uint256) {
1237         require(owner != address(0), "ERC721: balance query for the zero address");
1238 
1239         return _holderTokens[owner].length();
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-ownerOf}.
1244      */
1245     function ownerOf(uint256 tokenId) public view override returns (address) {
1246         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Metadata-name}.
1251      */
1252     function name() public view override returns (string memory) {
1253         return _name;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Metadata-symbol}.
1258      */
1259     function symbol() public view override returns (string memory) {
1260         return _symbol;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Metadata-tokenURI}.
1265      */
1266     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1267         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1268 
1269         string memory _tokenURI = _tokenURIs[tokenId];
1270 
1271         // If there is no base URI, return the token URI.
1272         if (bytes(_baseURI).length == 0) {
1273             return _tokenURI;
1274         }
1275         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1276         if (bytes(_tokenURI).length > 0) {
1277             return string(abi.encodePacked(_baseURI, _tokenURI));
1278         }
1279         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1280         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1281     }
1282 
1283     /**
1284     * @dev Returns the base URI set via {_setBaseURI}. This will be
1285     * automatically added as a prefix in {tokenURI} to each token's URI, or
1286     * to the token ID if no specific URI is set for that token ID.
1287     */
1288     function baseURI() public view returns (string memory) {
1289         return _baseURI;
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1296         return _holderTokens[owner].at(index);
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Enumerable-totalSupply}.
1301      */
1302     function totalSupply() public view override returns (uint256) {
1303         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1304         return _tokenOwners.length();
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-tokenByIndex}.
1309      */
1310     function tokenByIndex(uint256 index) public view override returns (uint256) {
1311         (uint256 tokenId, ) = _tokenOwners.at(index);
1312         return tokenId;
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-approve}.
1317      */
1318     function approve(address to, uint256 tokenId) public virtual override {
1319         address owner = ownerOf(tokenId);
1320         require(to != owner, "ERC721: approval to current owner");
1321 
1322         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1323             "ERC721: approve caller is not owner nor approved for all"
1324         );
1325 
1326         _approve(to, tokenId);
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-getApproved}.
1331      */
1332     function getApproved(uint256 tokenId) public view override returns (address) {
1333         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1334 
1335         return _tokenApprovals[tokenId];
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-setApprovalForAll}.
1340      */
1341     function setApprovalForAll(address operator, bool approved) public virtual override {
1342         require(operator != _msgSender(), "ERC721: approve to caller");
1343 
1344         _operatorApprovals[_msgSender()][operator] = approved;
1345         emit ApprovalForAll(_msgSender(), operator, approved);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-isApprovedForAll}.
1350      */
1351     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1352         return _operatorApprovals[owner][operator];
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-transferFrom}.
1357      */
1358     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1359         //solhint-disable-next-line max-line-length
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1361 
1362         _transfer(from, to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-safeTransferFrom}.
1367      */
1368     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1369         safeTransferFrom(from, to, tokenId, "");
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-safeTransferFrom}.
1374      */
1375     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1376         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1377         _safeTransfer(from, to, tokenId, _data);
1378     }
1379 
1380     /**
1381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1383      *
1384      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1385      *
1386      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1387      * implement alternative mechanisms to perform token transfer, such as signature-based.
1388      *
1389      * Requirements:
1390      *
1391      * - `from` cannot be the zero address.
1392      * - `to` cannot be the zero address.
1393      * - `tokenId` token must exist and be owned by `from`.
1394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1399         _transfer(from, to, tokenId);
1400         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted (`_mint`),
1409      * and stop existing when they are burned (`_burn`).
1410      */
1411     function _exists(uint256 tokenId) internal view returns (bool) {
1412         return _tokenOwners.contains(tokenId);
1413     }
1414 
1415     /**
1416      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1424         address owner = ownerOf(tokenId);
1425         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1426     }
1427 
1428     /**
1429      * @dev Safely mints `tokenId` and transfers it to `to`.
1430      *
1431      * Requirements:
1432      d*
1433      * - `tokenId` must not exist.
1434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _safeMint(address to, uint256 tokenId) internal virtual {
1439         _safeMint(to, tokenId, "");
1440     }
1441 
1442     /**
1443      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1444      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1445      */
1446     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1447         _mint(to, tokenId);
1448         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1449     }
1450 
1451     /**
1452      * @dev Mints `tokenId` and transfers it to `to`.
1453      *
1454      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1455      *
1456      * Requirements:
1457      *
1458      * - `tokenId` must not exist.
1459      * - `to` cannot be the zero address.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _mint(address to, uint256 tokenId) internal virtual {
1464         require(to != address(0), "ERC721: mint to the zero address");
1465         require(!_exists(tokenId), "ERC721: token already minted");
1466 
1467         _beforeTokenTransfer(address(0), to, tokenId);
1468 
1469         _holderTokens[to].add(tokenId);
1470 
1471         _tokenOwners.set(tokenId, to);
1472 
1473         emit Transfer(address(0), to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev Destroys `tokenId`.
1478      * The approval is cleared when the token is burned.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _burn(uint256 tokenId) internal virtual {
1487         address owner = ownerOf(tokenId);
1488 
1489         _beforeTokenTransfer(owner, address(0), tokenId);
1490 
1491         // Clear approvals
1492         _approve(address(0), tokenId);
1493 
1494         // Clear metadata (if any)
1495         if (bytes(_tokenURIs[tokenId]).length != 0) {
1496             delete _tokenURIs[tokenId];
1497         }
1498 
1499         _holderTokens[owner].remove(tokenId);
1500 
1501         _tokenOwners.remove(tokenId);
1502 
1503         emit Transfer(owner, address(0), tokenId);
1504     }
1505 
1506     /**
1507      * @dev Transfers `tokenId` from `from` to `to`.
1508      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1509      *
1510      * Requirements:
1511      *
1512      * - `to` cannot be the zero address.
1513      * - `tokenId` token must be owned by `from`.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1518         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1519         require(to != address(0), "ERC721: transfer to the zero address");
1520 
1521         _beforeTokenTransfer(from, to, tokenId);
1522 
1523         // Clear approvals from the previous owner
1524         _approve(address(0), tokenId);
1525 
1526         _holderTokens[from].remove(tokenId);
1527         _holderTokens[to].add(tokenId);
1528 
1529         _tokenOwners.set(tokenId, to);
1530 
1531         emit Transfer(from, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      */
1541     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1542         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1543         _tokenURIs[tokenId] = _tokenURI;
1544     }
1545 
1546     /**
1547      * @dev Internal function to set the base URI for all token IDs. It is
1548      * automatically added as a prefix to the value returned in {tokenURI},
1549      * or to the token ID if {tokenURI} is empty.
1550      */
1551     function _setBaseURI(string memory baseURI_) internal virtual {
1552         _baseURI = baseURI_;
1553     }
1554 
1555     /**
1556      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1557      * The call is not executed if the target address is not a contract.
1558      *
1559      * @param from address representing the previous owner of the given token ID
1560      * @param to target address that will receive the tokens
1561      * @param tokenId uint256 ID of the token to be transferred
1562      * @param _data bytes optional data to send along with the call
1563      * @return bool whether the call correctly returned the expected magic value
1564      */
1565     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1566         private returns (bool)
1567     {
1568         if (!to.isContract()) {
1569             return true;
1570         }
1571         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1572             IERC721Receiver(to).onERC721Received.selector,
1573             _msgSender(),
1574             from,
1575             tokenId,
1576             _data
1577         ), "ERC721: transfer to non ERC721Receiver implementer");
1578         bytes4 retval = abi.decode(returndata, (bytes4));
1579         return (retval == _ERC721_RECEIVED);
1580     }
1581 
1582     function _approve(address to, uint256 tokenId) private {
1583         _tokenApprovals[tokenId] = to;
1584         emit Approval(ownerOf(tokenId), to, tokenId);
1585     }
1586 
1587     /**
1588      * @dev Hook that is called before any token transfer. This includes minting
1589      * and burning.
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1597      * - `from` cannot be the zero address.
1598      * - `to` cannot be the zero address.
1599      *
1600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1601      */
1602     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1603 }
1604 
1605 // File: contracts\GFarmNFT.sol
1606 
1607 pragma solidity 0.7.5;
1608 
1609 
1610 
1611 contract GFarmNFT is ERC721{
1612 
1613 	// VARIABLES & CONSTANTS
1614 
1615 	// 1. Current supply for each leverage
1616 	uint16[5] supply = [0, 0, 0, 0, 0];
1617 
1618 	// 2. Get the corresponding leverage for each NFT minted
1619 	mapping(uint => uint8) public idToLeverage;
1620 
1621 	// 3. Farm contract to check NFT credits
1622 	GFarmInterface public immutable farm;
1623 
1624 	constructor(GFarmInterface _farm) ERC721("GFarmNFT V2", "GFARM2NFT"){
1625 		farm = _farm;
1626 	}
1627 
1628 	// CONSTANT ARRAYS
1629 
1630 	// 1. Required credits for each leverage (constant)
1631 	function requiredCreditsArray() public pure returns(uint24[5] memory){
1632 		// (blocks) => 1, 2, 5, 10, 20
1633 		return [6400, 12800, 32000, 64000, 128000];
1634 	}
1635 	// 2. Max supply for each leverage (constant)
1636 	function maxSupplyArray() public pure returns(uint16[5] memory){
1637 		return [500, 400, 300, 200, 100];
1638 	}
1639 
1640 	// USEFUL HELPER FUNCTIONS
1641 
1642 	// 1. Verify leverage value (25, 50, 75, 100, 150)
1643 	modifier correctLeverage(uint8 _leverage){
1644 		require(_leverage >= 25 
1645 				&& _leverage <= 150 
1646 				&& _leverage % 25 == 0 
1647 				&& _leverage != 125,
1648 				"Wrong leverage value");
1649 		_;
1650 	}
1651 
1652 	// 2. Get ID from leverage (for arrays)
1653 	function leverageID(uint8 _leverage) public pure correctLeverage(_leverage) returns(uint8){
1654 		if(_leverage != 150){
1655 			// 25: 0, 50: 1, 75: 2, 100: 3
1656 			return (_leverage)/25-1;
1657 		}
1658 		// 150: 4
1659 		return 4;
1660 	}
1661 
1662 	// 3. Get required credits from leverage based on the constant array
1663 	function requiredCredits(uint8 _leverage) public pure returns(uint24){
1664 		return requiredCreditsArray()[leverageID(_leverage)];
1665 	}
1666 
1667 	// 4. Get max supply from leverage based on the constant array
1668 	function maxSupply(uint8 _leverage) public pure returns(uint16){
1669 		return maxSupplyArray()[leverageID(_leverage)];
1670 	}
1671 
1672 	// 5. Get current supply from leverage
1673 	function currentSupply(uint8 _leverage) public view returns(uint16){
1674 		return supply[leverageID(_leverage)];
1675 	}
1676 
1677 	// ACTIONS
1678 
1679 	// 1. Mint a leverage NFT to a user (only used internally)
1680 	function mint(uint8 _leverage, uint _userCredits) private{
1681 		require(_userCredits >= requiredCredits(_leverage), "Not enough NFT credits");
1682 		require(currentSupply(_leverage) < maxSupply(_leverage), "Max supply reached for this leverage");
1683 
1684 		uint nftID = totalSupply();
1685 		_mint(msg.sender, nftID);
1686 
1687 		idToLeverage[nftID] = _leverage;
1688 		supply[leverageID(_leverage)] += 1;
1689 	}
1690 
1691 	// 2. Claim NFT (called externally)
1692 	function claim(uint8 _leverage) external{
1693 		require(tx.origin == msg.sender, "Contracts not allowed.");
1694 		mint(_leverage, farm.NFT_CREDITS_amount(msg.sender));
1695 		farm.spendCredits(msg.sender, requiredCredits(_leverage));
1696 	}
1697 
1698     // EXTERNAL READ-ONLY FUNCTIONS
1699 
1700 	// 1. Get full current supply array for each NFT
1701 	function currentSupplyArray() external view returns(uint16[5] memory){
1702 		return supply;
1703 	}
1704 
1705 	// 2. Amount of each NFTs owned by msg.sender
1706 	function ownedCount() external view returns(uint[5] memory nfts){
1707     	for(uint i = 0; i < balanceOf(msg.sender); i++){
1708             uint id = leverageID(
1709                 idToLeverage[(
1710                     tokenOfOwnerByIndex(msg.sender, i)
1711                 )]
1712             );
1713             nfts[id] = nfts[id] + 1;
1714         }
1715     }
1716 }