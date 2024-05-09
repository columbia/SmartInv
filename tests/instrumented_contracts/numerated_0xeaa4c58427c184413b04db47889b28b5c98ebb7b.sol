1 // File: @openzeppelin/contracts/GSN/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/introspection/IERC165.sol
28 
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
54 
55 
56 pragma solidity >=0.6.2 <0.8.0;
57 
58 
59 /**
60  * @dev Required interface of an ERC721 compliant contract.
61  */
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
75      */
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns (uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns (address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(address from, address to, uint256 tokenId) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address from, address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId) external view returns (address operator);
147 
148     /**
149      * @dev Approve or remove `operator` as an operator for the caller.
150      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
151      *
152      * Requirements:
153      *
154      * - The `operator` cannot be the caller.
155      *
156      * Emits an {ApprovalForAll} event.
157      */
158     function setApprovalForAll(address operator, bool _approved) external;
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 
167     /**
168       * @dev Safely transfers `tokenId` token from `from` to `to`.
169       *
170       * Requirements:
171       *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174       * - `tokenId` token must exist and be owned by `from`.
175       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177       *
178       * Emits a {Transfer} event.
179       */
180     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
184 
185 
186 pragma solidity >=0.6.2 <0.8.0;
187 
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194 
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
212 
213 
214 pragma solidity >=0.6.2 <0.8.0;
215 
216 
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
219  * @dev See https://eips.ethereum.org/EIPS/eip-721
220  */
221 interface IERC721Enumerable is IERC721 {
222 
223     /**
224      * @dev Returns the total amount of tokens stored by the contract.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     /**
229      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
230      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
231      */
232     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
233 
234     /**
235      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
236      * Use along with {totalSupply} to enumerate all tokens.
237      */
238     function tokenByIndex(uint256 index) external view returns (uint256);
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
242 
243 
244 pragma solidity >=0.6.0 <0.8.0;
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by `operator` from `from`, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
260      */
261     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
262 }
263 
264 // File: @openzeppelin/contracts/introspection/ERC165.sol
265 
266 
267 pragma solidity >=0.6.0 <0.8.0;
268 
269 
270 /**
271  * @dev Implementation of the {IERC165} interface.
272  *
273  * Contracts may inherit from this and call {_registerInterface} to declare
274  * their support of an interface.
275  */
276 abstract contract ERC165 is IERC165 {
277     /*
278      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
279      */
280     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
281 
282     /**
283      * @dev Mapping of interface ids to whether or not it's supported.
284      */
285     mapping(bytes4 => bool) private _supportedInterfaces;
286 
287     constructor () internal {
288         // Derived contracts need only register support for their own interfaces,
289         // we register support for ERC165 itself here
290         _registerInterface(_INTERFACE_ID_ERC165);
291     }
292 
293     /**
294      * @dev See {IERC165-supportsInterface}.
295      *
296      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
297      */
298     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
299         return _supportedInterfaces[interfaceId];
300     }
301 
302     /**
303      * @dev Registers the contract as an implementer of the interface defined by
304      * `interfaceId`. Support of the actual ERC165 interface is automatic and
305      * registering its interface id is not required.
306      *
307      * See {IERC165-supportsInterface}.
308      *
309      * Requirements:
310      *
311      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
312      */
313     function _registerInterface(bytes4 interfaceId) internal virtual {
314         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
315         _supportedInterfaces[interfaceId] = true;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/math/SafeMath.sol
320 
321 
322 pragma solidity >=0.6.0 <0.8.0;
323 
324 /**
325  * @dev Wrappers over Solidity's arithmetic operations with added overflow
326  * checks.
327  *
328  * Arithmetic operations in Solidity wrap on overflow. This can easily result
329  * in bugs, because programmers usually assume that an overflow raises an
330  * error, which is the standard behavior in high level programming languages.
331  * `SafeMath` restores this intuition by reverting the transaction when an
332  * operation overflows.
333  *
334  * Using this library instead of the unchecked operations eliminates an entire
335  * class of bugs, so it's recommended to use it always.
336  */
337 library SafeMath {
338     /**
339      * @dev Returns the addition of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `+` operator.
343      *
344      * Requirements:
345      *
346      * - Addition cannot overflow.
347      */
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         uint256 c = a + b;
350         require(c >= a, "SafeMath: addition overflow");
351 
352         return c;
353     }
354 
355     /**
356      * @dev Returns the subtraction of two unsigned integers, reverting on
357      * overflow (when the result is negative).
358      *
359      * Counterpart to Solidity's `-` operator.
360      *
361      * Requirements:
362      *
363      * - Subtraction cannot overflow.
364      */
365     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
366         return sub(a, b, "SafeMath: subtraction overflow");
367     }
368 
369     /**
370      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
371      * overflow (when the result is negative).
372      *
373      * Counterpart to Solidity's `-` operator.
374      *
375      * Requirements:
376      *
377      * - Subtraction cannot overflow.
378      */
379     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
380         require(b <= a, errorMessage);
381         uint256 c = a - b;
382 
383         return c;
384     }
385 
386     /**
387      * @dev Returns the multiplication of two unsigned integers, reverting on
388      * overflow.
389      *
390      * Counterpart to Solidity's `*` operator.
391      *
392      * Requirements:
393      *
394      * - Multiplication cannot overflow.
395      */
396     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
397         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
398         // benefit is lost if 'b' is also tested.
399         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
400         if (a == 0) {
401             return 0;
402         }
403 
404         uint256 c = a * b;
405         require(c / a == b, "SafeMath: multiplication overflow");
406 
407         return c;
408     }
409 
410     /**
411      * @dev Returns the integer division of two unsigned integers. Reverts on
412      * division by zero. The result is rounded towards zero.
413      *
414      * Counterpart to Solidity's `/` operator. Note: this function uses a
415      * `revert` opcode (which leaves remaining gas untouched) while Solidity
416      * uses an invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function div(uint256 a, uint256 b) internal pure returns (uint256) {
423         return div(a, b, "SafeMath: division by zero");
424     }
425 
426     /**
427      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
428      * division by zero. The result is rounded towards zero.
429      *
430      * Counterpart to Solidity's `/` operator. Note: this function uses a
431      * `revert` opcode (which leaves remaining gas untouched) while Solidity
432      * uses an invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
439         require(b > 0, errorMessage);
440         uint256 c = a / b;
441         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
442 
443         return c;
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * Reverts when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
459         return mod(a, b, "SafeMath: modulo by zero");
460     }
461 
462     /**
463      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
464      * Reverts with custom message when dividing by zero.
465      *
466      * Counterpart to Solidity's `%` operator. This function uses a `revert`
467      * opcode (which leaves remaining gas untouched) while Solidity uses an
468      * invalid opcode to revert (consuming all remaining gas).
469      *
470      * Requirements:
471      *
472      * - The divisor cannot be zero.
473      */
474     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
475         require(b != 0, errorMessage);
476         return a % b;
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Address.sol
481 
482 
483 pragma solidity >=0.6.2 <0.8.0;
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
507         // This method relies on extcodesize, which returns 0 for contracts in
508         // construction, since the code is only stored at the end of the
509         // constructor execution.
510 
511         uint256 size;
512         // solhint-disable-next-line no-inline-assembly
513         assembly { size := extcodesize(account) }
514         return size > 0;
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
540 
541     /**
542      * @dev Performs a Solidity function call using a low level `call`. A
543      * plain`call` is an unsafe replacement for a function call: use this
544      * function instead.
545      *
546      * If `target` reverts with a revert reason, it is bubbled up by this
547      * function (like regular Solidity function calls).
548      *
549      * Returns the raw returned data. To convert to the expected return value,
550      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
551      *
552      * Requirements:
553      *
554      * - `target` must be a contract.
555      * - calling `target` with `data` must not revert.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
560       return functionCall(target, data, "Address: low-level call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
565      * `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, 0, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but also transferring `value` wei to `target`.
576      *
577      * Requirements:
578      *
579      * - the calling contract must have an ETH balance of at least `value`.
580      * - the called Solidity function must be `payable`.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
585         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
590      * with `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
595         require(address(this).balance >= value, "Address: insufficient balance for call");
596         require(isContract(target), "Address: call to non-contract");
597 
598         // solhint-disable-next-line avoid-low-level-calls
599         (bool success, bytes memory returndata) = target.call{ value: value }(data);
600         return _verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
610         return functionStaticCall(target, data, "Address: low-level static call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a static call.
616      *
617      * _Available since v3.3._
618      */
619     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
620         require(isContract(target), "Address: static call to non-contract");
621 
622         // solhint-disable-next-line avoid-low-level-calls
623         (bool success, bytes memory returndata) = target.staticcall(data);
624         return _verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
628         if (success) {
629             return returndata;
630         } else {
631             // Look for revert reason and bubble it up if present
632             if (returndata.length > 0) {
633                 // The easiest way to bubble the revert reason is using memory via assembly
634 
635                 // solhint-disable-next-line no-inline-assembly
636                 assembly {
637                     let returndata_size := mload(returndata)
638                     revert(add(32, returndata), returndata_size)
639                 }
640             } else {
641                 revert(errorMessage);
642             }
643         }
644     }
645 }
646 
647 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
648 
649 
650 pragma solidity >=0.6.0 <0.8.0;
651 
652 /**
653  * @dev Library for managing
654  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
655  * types.
656  *
657  * Sets have the following properties:
658  *
659  * - Elements are added, removed, and checked for existence in constant time
660  * (O(1)).
661  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
662  *
663  * ```
664  * contract Example {
665  *     // Add the library methods
666  *     using EnumerableSet for EnumerableSet.AddressSet;
667  *
668  *     // Declare a set state variable
669  *     EnumerableSet.AddressSet private mySet;
670  * }
671  * ```
672  *
673  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
674  * and `uint256` (`UintSet`) are supported.
675  */
676 library EnumerableSet {
677     // To implement this library for multiple types with as little code
678     // repetition as possible, we write it in terms of a generic Set type with
679     // bytes32 values.
680     // The Set implementation uses private functions, and user-facing
681     // implementations (such as AddressSet) are just wrappers around the
682     // underlying Set.
683     // This means that we can only create new EnumerableSets for types that fit
684     // in bytes32.
685 
686     struct Set {
687         // Storage of set values
688         bytes32[] _values;
689 
690         // Position of the value in the `values` array, plus 1 because index 0
691         // means a value is not in the set.
692         mapping (bytes32 => uint256) _indexes;
693     }
694 
695     /**
696      * @dev Add a value to a set. O(1).
697      *
698      * Returns true if the value was added to the set, that is if it was not
699      * already present.
700      */
701     function _add(Set storage set, bytes32 value) private returns (bool) {
702         if (!_contains(set, value)) {
703             set._values.push(value);
704             // The value is stored at length-1, but we add 1 to all indexes
705             // and use 0 as a sentinel value
706             set._indexes[value] = set._values.length;
707             return true;
708         } else {
709             return false;
710         }
711     }
712 
713     /**
714      * @dev Removes a value from a set. O(1).
715      *
716      * Returns true if the value was removed from the set, that is if it was
717      * present.
718      */
719     function _remove(Set storage set, bytes32 value) private returns (bool) {
720         // We read and store the value's index to prevent multiple reads from the same storage slot
721         uint256 valueIndex = set._indexes[value];
722 
723         if (valueIndex != 0) { // Equivalent to contains(set, value)
724             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
725             // the array, and then remove the last element (sometimes called as 'swap and pop').
726             // This modifies the order of the array, as noted in {at}.
727 
728             uint256 toDeleteIndex = valueIndex - 1;
729             uint256 lastIndex = set._values.length - 1;
730 
731             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
732             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
733 
734             bytes32 lastvalue = set._values[lastIndex];
735 
736             // Move the last value to the index where the value to delete is
737             set._values[toDeleteIndex] = lastvalue;
738             // Update the index for the moved value
739             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
740 
741             // Delete the slot where the moved value was stored
742             set._values.pop();
743 
744             // Delete the index for the deleted slot
745             delete set._indexes[value];
746 
747             return true;
748         } else {
749             return false;
750         }
751     }
752 
753     /**
754      * @dev Returns true if the value is in the set. O(1).
755      */
756     function _contains(Set storage set, bytes32 value) private view returns (bool) {
757         return set._indexes[value] != 0;
758     }
759 
760     /**
761      * @dev Returns the number of values on the set. O(1).
762      */
763     function _length(Set storage set) private view returns (uint256) {
764         return set._values.length;
765     }
766 
767    /**
768     * @dev Returns the value stored at position `index` in the set. O(1).
769     *
770     * Note that there are no guarantees on the ordering of values inside the
771     * array, and it may change when more values are added or removed.
772     *
773     * Requirements:
774     *
775     * - `index` must be strictly less than {length}.
776     */
777     function _at(Set storage set, uint256 index) private view returns (bytes32) {
778         require(set._values.length > index, "EnumerableSet: index out of bounds");
779         return set._values[index];
780     }
781 
782     // Bytes32Set
783 
784     struct Bytes32Set {
785         Set _inner;
786     }
787 
788     /**
789      * @dev Add a value to a set. O(1).
790      *
791      * Returns true if the value was added to the set, that is if it was not
792      * already present.
793      */
794     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
795         return _add(set._inner, value);
796     }
797 
798     /**
799      * @dev Removes a value from a set. O(1).
800      *
801      * Returns true if the value was removed from the set, that is if it was
802      * present.
803      */
804     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
805         return _remove(set._inner, value);
806     }
807 
808     /**
809      * @dev Returns true if the value is in the set. O(1).
810      */
811     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
812         return _contains(set._inner, value);
813     }
814 
815     /**
816      * @dev Returns the number of values in the set. O(1).
817      */
818     function length(Bytes32Set storage set) internal view returns (uint256) {
819         return _length(set._inner);
820     }
821 
822    /**
823     * @dev Returns the value stored at position `index` in the set. O(1).
824     *
825     * Note that there are no guarantees on the ordering of values inside the
826     * array, and it may change when more values are added or removed.
827     *
828     * Requirements:
829     *
830     * - `index` must be strictly less than {length}.
831     */
832     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
833         return _at(set._inner, index);
834     }
835 
836     // AddressSet
837 
838     struct AddressSet {
839         Set _inner;
840     }
841 
842     /**
843      * @dev Add a value to a set. O(1).
844      *
845      * Returns true if the value was added to the set, that is if it was not
846      * already present.
847      */
848     function add(AddressSet storage set, address value) internal returns (bool) {
849         return _add(set._inner, bytes32(uint256(value)));
850     }
851 
852     /**
853      * @dev Removes a value from a set. O(1).
854      *
855      * Returns true if the value was removed from the set, that is if it was
856      * present.
857      */
858     function remove(AddressSet storage set, address value) internal returns (bool) {
859         return _remove(set._inner, bytes32(uint256(value)));
860     }
861 
862     /**
863      * @dev Returns true if the value is in the set. O(1).
864      */
865     function contains(AddressSet storage set, address value) internal view returns (bool) {
866         return _contains(set._inner, bytes32(uint256(value)));
867     }
868 
869     /**
870      * @dev Returns the number of values in the set. O(1).
871      */
872     function length(AddressSet storage set) internal view returns (uint256) {
873         return _length(set._inner);
874     }
875 
876    /**
877     * @dev Returns the value stored at position `index` in the set. O(1).
878     *
879     * Note that there are no guarantees on the ordering of values inside the
880     * array, and it may change when more values are added or removed.
881     *
882     * Requirements:
883     *
884     * - `index` must be strictly less than {length}.
885     */
886     function at(AddressSet storage set, uint256 index) internal view returns (address) {
887         return address(uint256(_at(set._inner, index)));
888     }
889 
890 
891     // UintSet
892 
893     struct UintSet {
894         Set _inner;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function add(UintSet storage set, uint256 value) internal returns (bool) {
904         return _add(set._inner, bytes32(value));
905     }
906 
907     /**
908      * @dev Removes a value from a set. O(1).
909      *
910      * Returns true if the value was removed from the set, that is if it was
911      * present.
912      */
913     function remove(UintSet storage set, uint256 value) internal returns (bool) {
914         return _remove(set._inner, bytes32(value));
915     }
916 
917     /**
918      * @dev Returns true if the value is in the set. O(1).
919      */
920     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
921         return _contains(set._inner, bytes32(value));
922     }
923 
924     /**
925      * @dev Returns the number of values on the set. O(1).
926      */
927     function length(UintSet storage set) internal view returns (uint256) {
928         return _length(set._inner);
929     }
930 
931    /**
932     * @dev Returns the value stored at position `index` in the set. O(1).
933     *
934     * Note that there are no guarantees on the ordering of values inside the
935     * array, and it may change when more values are added or removed.
936     *
937     * Requirements:
938     *
939     * - `index` must be strictly less than {length}.
940     */
941     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
942         return uint256(_at(set._inner, index));
943     }
944 }
945 
946 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
947 
948 
949 pragma solidity >=0.6.0 <0.8.0;
950 
951 /**
952  * @dev Library for managing an enumerable variant of Solidity's
953  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
954  * type.
955  *
956  * Maps have the following properties:
957  *
958  * - Entries are added, removed, and checked for existence in constant time
959  * (O(1)).
960  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
961  *
962  * ```
963  * contract Example {
964  *     // Add the library methods
965  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
966  *
967  *     // Declare a set state variable
968  *     EnumerableMap.UintToAddressMap private myMap;
969  * }
970  * ```
971  *
972  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
973  * supported.
974  */
975 library EnumerableMap {
976     // To implement this library for multiple types with as little code
977     // repetition as possible, we write it in terms of a generic Map type with
978     // bytes32 keys and values.
979     // The Map implementation uses private functions, and user-facing
980     // implementations (such as Uint256ToAddressMap) are just wrappers around
981     // the underlying Map.
982     // This means that we can only create new EnumerableMaps for types that fit
983     // in bytes32.
984 
985     struct MapEntry {
986         bytes32 _key;
987         bytes32 _value;
988     }
989 
990     struct Map {
991         // Storage of map keys and values
992         MapEntry[] _entries;
993 
994         // Position of the entry defined by a key in the `entries` array, plus 1
995         // because index 0 means a key is not in the map.
996         mapping (bytes32 => uint256) _indexes;
997     }
998 
999     /**
1000      * @dev Adds a key-value pair to a map, or updates the value for an existing
1001      * key. O(1).
1002      *
1003      * Returns true if the key was added to the map, that is if it was not
1004      * already present.
1005      */
1006     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1007         // We read and store the key's index to prevent multiple reads from the same storage slot
1008         uint256 keyIndex = map._indexes[key];
1009 
1010         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1011             map._entries.push(MapEntry({ _key: key, _value: value }));
1012             // The entry is stored at length-1, but we add 1 to all indexes
1013             // and use 0 as a sentinel value
1014             map._indexes[key] = map._entries.length;
1015             return true;
1016         } else {
1017             map._entries[keyIndex - 1]._value = value;
1018             return false;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Removes a key-value pair from a map. O(1).
1024      *
1025      * Returns true if the key was removed from the map, that is if it was present.
1026      */
1027     function _remove(Map storage map, bytes32 key) private returns (bool) {
1028         // We read and store the key's index to prevent multiple reads from the same storage slot
1029         uint256 keyIndex = map._indexes[key];
1030 
1031         if (keyIndex != 0) { // Equivalent to contains(map, key)
1032             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1033             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1034             // This modifies the order of the array, as noted in {at}.
1035 
1036             uint256 toDeleteIndex = keyIndex - 1;
1037             uint256 lastIndex = map._entries.length - 1;
1038 
1039             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1040             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1041 
1042             MapEntry storage lastEntry = map._entries[lastIndex];
1043 
1044             // Move the last entry to the index where the entry to delete is
1045             map._entries[toDeleteIndex] = lastEntry;
1046             // Update the index for the moved entry
1047             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1048 
1049             // Delete the slot where the moved entry was stored
1050             map._entries.pop();
1051 
1052             // Delete the index for the deleted slot
1053             delete map._indexes[key];
1054 
1055             return true;
1056         } else {
1057             return false;
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns true if the key is in the map. O(1).
1063      */
1064     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1065         return map._indexes[key] != 0;
1066     }
1067 
1068     /**
1069      * @dev Returns the number of key-value pairs in the map. O(1).
1070      */
1071     function _length(Map storage map) private view returns (uint256) {
1072         return map._entries.length;
1073     }
1074 
1075    /**
1076     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1077     *
1078     * Note that there are no guarantees on the ordering of entries inside the
1079     * array, and it may change when more entries are added or removed.
1080     *
1081     * Requirements:
1082     *
1083     * - `index` must be strictly less than {length}.
1084     */
1085     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1086         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1087 
1088         MapEntry storage entry = map._entries[index];
1089         return (entry._key, entry._value);
1090     }
1091 
1092     /**
1093      * @dev Returns the value associated with `key`.  O(1).
1094      *
1095      * Requirements:
1096      *
1097      * - `key` must be in the map.
1098      */
1099     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1100         return _get(map, key, "EnumerableMap: nonexistent key");
1101     }
1102 
1103     /**
1104      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1105      */
1106     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1107         uint256 keyIndex = map._indexes[key];
1108         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1109         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1110     }
1111 
1112     // UintToAddressMap
1113 
1114     struct UintToAddressMap {
1115         Map _inner;
1116     }
1117 
1118     /**
1119      * @dev Adds a key-value pair to a map, or updates the value for an existing
1120      * key. O(1).
1121      *
1122      * Returns true if the key was added to the map, that is if it was not
1123      * already present.
1124      */
1125     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1126         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1127     }
1128 
1129     /**
1130      * @dev Removes a value from a set. O(1).
1131      *
1132      * Returns true if the key was removed from the map, that is if it was present.
1133      */
1134     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1135         return _remove(map._inner, bytes32(key));
1136     }
1137 
1138     /**
1139      * @dev Returns true if the key is in the map. O(1).
1140      */
1141     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1142         return _contains(map._inner, bytes32(key));
1143     }
1144 
1145     /**
1146      * @dev Returns the number of elements in the map. O(1).
1147      */
1148     function length(UintToAddressMap storage map) internal view returns (uint256) {
1149         return _length(map._inner);
1150     }
1151 
1152    /**
1153     * @dev Returns the element stored at position `index` in the set. O(1).
1154     * Note that there are no guarantees on the ordering of values inside the
1155     * array, and it may change when more values are added or removed.
1156     *
1157     * Requirements:
1158     *
1159     * - `index` must be strictly less than {length}.
1160     */
1161     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1162         (bytes32 key, bytes32 value) = _at(map._inner, index);
1163         return (uint256(key), address(uint256(value)));
1164     }
1165 
1166     /**
1167      * @dev Returns the value associated with `key`.  O(1).
1168      *
1169      * Requirements:
1170      *
1171      * - `key` must be in the map.
1172      */
1173     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1174         return address(uint256(_get(map._inner, bytes32(key))));
1175     }
1176 
1177     /**
1178      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1179      */
1180     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1181         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1182     }
1183 }
1184 
1185 // File: @openzeppelin/contracts/utils/Strings.sol
1186 
1187 
1188 pragma solidity >=0.6.0 <0.8.0;
1189 
1190 /**
1191  * @dev String operations.
1192  */
1193 library Strings {
1194     /**
1195      * @dev Converts a `uint256` to its ASCII `string` representation.
1196      */
1197     function toString(uint256 value) internal pure returns (string memory) {
1198         // Inspired by OraclizeAPI's implementation - MIT licence
1199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1200 
1201         if (value == 0) {
1202             return "0";
1203         }
1204         uint256 temp = value;
1205         uint256 digits;
1206         while (temp != 0) {
1207             digits++;
1208             temp /= 10;
1209         }
1210         bytes memory buffer = new bytes(digits);
1211         uint256 index = digits - 1;
1212         temp = value;
1213         while (temp != 0) {
1214             buffer[index--] = byte(uint8(48 + temp % 10));
1215             temp /= 10;
1216         }
1217         return string(buffer);
1218     }
1219 }
1220 
1221 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1222 
1223 
1224 pragma solidity >=0.6.0 <0.8.0;
1225 
1226 
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 
1236 
1237 /**
1238  * @title ERC721 Non-Fungible Token Standard basic implementation
1239  * @dev see https://eips.ethereum.org/EIPS/eip-721
1240  */
1241 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1242     using SafeMath for uint256;
1243     using Address for address;
1244     using EnumerableSet for EnumerableSet.UintSet;
1245     using EnumerableMap for EnumerableMap.UintToAddressMap;
1246     using Strings for uint256;
1247 
1248     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1249     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1250     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1251 
1252     // Mapping from holder address to their (enumerable) set of owned tokens
1253     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1254 
1255     // Enumerable mapping from token ids to their owners
1256     EnumerableMap.UintToAddressMap private _tokenOwners;
1257 
1258     // Mapping from token ID to approved address
1259     mapping (uint256 => address) private _tokenApprovals;
1260 
1261     // Mapping from owner to operator approvals
1262     mapping (address => mapping (address => bool)) private _operatorApprovals;
1263 
1264     // Token name
1265     string private _name;
1266 
1267     // Token symbol
1268     string private _symbol;
1269 
1270     // Optional mapping for token URIs
1271     mapping (uint256 => string) private _tokenURIs;
1272 
1273     // Base URI
1274     string private _baseURI;
1275 
1276     /*
1277      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1278      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1279      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1280      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1281      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1282      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1283      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1284      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1285      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1286      *
1287      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1288      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1289      */
1290     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1291 
1292     /*
1293      *     bytes4(keccak256('name()')) == 0x06fdde03
1294      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1295      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1296      *
1297      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1298      */
1299     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1300 
1301     /*
1302      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1303      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1304      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1305      *
1306      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1307      */
1308     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1309 
1310     /**
1311      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1312      */
1313     constructor (string memory name_, string memory symbol_) public {
1314         _name = name_;
1315         _symbol = symbol_;
1316 
1317         // register the supported interfaces to conform to ERC721 via ERC165
1318         _registerInterface(_INTERFACE_ID_ERC721);
1319         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1320         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-balanceOf}.
1325      */
1326     function balanceOf(address owner) public view override returns (uint256) {
1327         require(owner != address(0), "ERC721: balance query for the zero address");
1328 
1329         return _holderTokens[owner].length();
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-ownerOf}.
1334      */
1335     function ownerOf(uint256 tokenId) public view override returns (address) {
1336         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1337     }
1338 
1339     /**
1340      * @dev See {IERC721Metadata-name}.
1341      */
1342     function name() public view override returns (string memory) {
1343         return _name;
1344     }
1345 
1346     /**
1347      * @dev See {IERC721Metadata-symbol}.
1348      */
1349     function symbol() public view override returns (string memory) {
1350         return _symbol;
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Metadata-tokenURI}.
1355      */
1356     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1357         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1358 
1359         string memory _tokenURI = _tokenURIs[tokenId];
1360 
1361         // If there is no base URI, return the token URI.
1362         if (bytes(_baseURI).length == 0) {
1363             return _tokenURI;
1364         }
1365         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1366         if (bytes(_tokenURI).length > 0) {
1367             return string(abi.encodePacked(_baseURI, _tokenURI));
1368         }
1369         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1370         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1371     }
1372 
1373     /**
1374     * @dev Returns the base URI set via {_setBaseURI}. This will be
1375     * automatically added as a prefix in {tokenURI} to each token's URI, or
1376     * to the token ID if no specific URI is set for that token ID.
1377     */
1378     function baseURI() public view returns (string memory) {
1379         return _baseURI;
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1384      */
1385     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1386         return _holderTokens[owner].at(index);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Enumerable-totalSupply}.
1391      */
1392     function totalSupply() public view override returns (uint256) {
1393         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1394         return _tokenOwners.length();
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Enumerable-tokenByIndex}.
1399      */
1400     function tokenByIndex(uint256 index) public view override returns (uint256) {
1401         (uint256 tokenId, ) = _tokenOwners.at(index);
1402         return tokenId;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-approve}.
1407      */
1408     function approve(address to, uint256 tokenId) public virtual override {
1409         address owner = ownerOf(tokenId);
1410         require(to != owner, "ERC721: approval to current owner");
1411 
1412         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1413             "ERC721: approve caller is not owner nor approved for all"
1414         );
1415 
1416         _approve(to, tokenId);
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-getApproved}.
1421      */
1422     function getApproved(uint256 tokenId) public view override returns (address) {
1423         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1424 
1425         return _tokenApprovals[tokenId];
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-setApprovalForAll}.
1430      */
1431     function setApprovalForAll(address operator, bool approved) public virtual override {
1432         require(operator != _msgSender(), "ERC721: approve to caller");
1433 
1434         _operatorApprovals[_msgSender()][operator] = approved;
1435         emit ApprovalForAll(_msgSender(), operator, approved);
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-isApprovedForAll}.
1440      */
1441     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1442         return _operatorApprovals[owner][operator];
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-transferFrom}.
1447      */
1448     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1449         //solhint-disable-next-line max-line-length
1450         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1451 
1452         _transfer(from, to, tokenId);
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-safeTransferFrom}.
1457      */
1458     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1459         safeTransferFrom(from, to, tokenId, "");
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-safeTransferFrom}.
1464      */
1465     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1466         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1467         _safeTransfer(from, to, tokenId, _data);
1468     }
1469 
1470     /**
1471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1473      *
1474      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1475      *
1476      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1477      * implement alternative mechanisms to perform token transfer, such as signature-based.
1478      *
1479      * Requirements:
1480      *
1481      * - `from` cannot be the zero address.
1482      * - `to` cannot be the zero address.
1483      * - `tokenId` token must exist and be owned by `from`.
1484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1489         _transfer(from, to, tokenId);
1490         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1491     }
1492 
1493     /**
1494      * @dev Returns whether `tokenId` exists.
1495      *
1496      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1497      *
1498      * Tokens start existing when they are minted (`_mint`),
1499      * and stop existing when they are burned (`_burn`).
1500      */
1501     function _exists(uint256 tokenId) internal view returns (bool) {
1502         return _tokenOwners.contains(tokenId);
1503     }
1504 
1505     /**
1506      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1507      *
1508      * Requirements:
1509      *
1510      * - `tokenId` must exist.
1511      */
1512     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1513         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1514         address owner = ownerOf(tokenId);
1515         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1516     }
1517 
1518     /**
1519      * @dev Safely mints `tokenId` and transfers it to `to`.
1520      *
1521      * Requirements:
1522      d*
1523      * - `tokenId` must not exist.
1524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1525      *
1526      * Emits a {Transfer} event.
1527      */
1528     function _safeMint(address to, uint256 tokenId) internal virtual {
1529         _safeMint(to, tokenId, "");
1530     }
1531 
1532     /**
1533      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1534      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1535      */
1536     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1537         _mint(to, tokenId);
1538         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1539     }
1540 
1541     /**
1542      * @dev Mints `tokenId` and transfers it to `to`.
1543      *
1544      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1545      *
1546      * Requirements:
1547      *
1548      * - `tokenId` must not exist.
1549      * - `to` cannot be the zero address.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function _mint(address to, uint256 tokenId) internal virtual {
1554         require(to != address(0), "ERC721: mint to the zero address");
1555         require(!_exists(tokenId), "ERC721: token already minted");
1556 
1557         _beforeTokenTransfer(address(0), to, tokenId);
1558 
1559         _holderTokens[to].add(tokenId);
1560 
1561         _tokenOwners.set(tokenId, to);
1562 
1563         emit Transfer(address(0), to, tokenId);
1564     }
1565 
1566     /**
1567      * @dev Destroys `tokenId`.
1568      * The approval is cleared when the token is burned.
1569      *
1570      * Requirements:
1571      *
1572      * - `tokenId` must exist.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _burn(uint256 tokenId) internal virtual {
1577         address owner = ownerOf(tokenId);
1578 
1579         _beforeTokenTransfer(owner, address(0), tokenId);
1580 
1581         // Clear approvals
1582         _approve(address(0), tokenId);
1583 
1584         // Clear metadata (if any)
1585         if (bytes(_tokenURIs[tokenId]).length != 0) {
1586             delete _tokenURIs[tokenId];
1587         }
1588 
1589         _holderTokens[owner].remove(tokenId);
1590 
1591         _tokenOwners.remove(tokenId);
1592 
1593         emit Transfer(owner, address(0), tokenId);
1594     }
1595 
1596     /**
1597      * @dev Transfers `tokenId` from `from` to `to`.
1598      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1599      *
1600      * Requirements:
1601      *
1602      * - `to` cannot be the zero address.
1603      * - `tokenId` token must be owned by `from`.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1608         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1609         require(to != address(0), "ERC721: transfer to the zero address");
1610 
1611         _beforeTokenTransfer(from, to, tokenId);
1612 
1613         // Clear approvals from the previous owner
1614         _approve(address(0), tokenId);
1615 
1616         _holderTokens[from].remove(tokenId);
1617         _holderTokens[to].add(tokenId);
1618 
1619         _tokenOwners.set(tokenId, to);
1620 
1621         emit Transfer(from, to, tokenId);
1622     }
1623 
1624     /**
1625      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1626      *
1627      * Requirements:
1628      *
1629      * - `tokenId` must exist.
1630      */
1631     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1632         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1633         _tokenURIs[tokenId] = _tokenURI;
1634     }
1635 
1636     /**
1637      * @dev Internal function to set the base URI for all token IDs. It is
1638      * automatically added as a prefix to the value returned in {tokenURI},
1639      * or to the token ID if {tokenURI} is empty.
1640      */
1641     function _setBaseURI(string memory baseURI_) internal virtual {
1642         _baseURI = baseURI_;
1643     }
1644 
1645     /**
1646      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1647      * The call is not executed if the target address is not a contract.
1648      *
1649      * @param from address representing the previous owner of the given token ID
1650      * @param to target address that will receive the tokens
1651      * @param tokenId uint256 ID of the token to be transferred
1652      * @param _data bytes optional data to send along with the call
1653      * @return bool whether the call correctly returned the expected magic value
1654      */
1655     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1656         private returns (bool)
1657     {
1658         if (!to.isContract()) {
1659             return true;
1660         }
1661         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1662             IERC721Receiver(to).onERC721Received.selector,
1663             _msgSender(),
1664             from,
1665             tokenId,
1666             _data
1667         ), "ERC721: transfer to non ERC721Receiver implementer");
1668         bytes4 retval = abi.decode(returndata, (bytes4));
1669         return (retval == _ERC721_RECEIVED);
1670     }
1671 
1672     function _approve(address to, uint256 tokenId) private {
1673         _tokenApprovals[tokenId] = to;
1674         emit Approval(ownerOf(tokenId), to, tokenId);
1675     }
1676 
1677     /**
1678      * @dev Hook that is called before any token transfer. This includes minting
1679      * and burning.
1680      *
1681      * Calling conditions:
1682      *
1683      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1684      * transferred to `to`.
1685      * - When `from` is zero, `tokenId` will be minted for `to`.
1686      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1687      * - `from` cannot be the zero address.
1688      * - `to` cannot be the zero address.
1689      *
1690      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1691      */
1692     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1693 }
1694 
1695 // File: @openzeppelin/contracts/utils/Counters.sol
1696 
1697 
1698 pragma solidity >=0.6.0 <0.8.0;
1699 
1700 
1701 /**
1702  * @title Counters
1703  * @author Matt Condon (@shrugs)
1704  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1705  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1706  *
1707  * Include with `using Counters for Counters.Counter;`
1708  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1709  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1710  * directly accessed.
1711  */
1712 library Counters {
1713     using SafeMath for uint256;
1714 
1715     struct Counter {
1716         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1717         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1718         // this feature: see https://github.com/ethereum/solidity/issues/4637
1719         uint256 _value; // default: 0
1720     }
1721 
1722     function current(Counter storage counter) internal view returns (uint256) {
1723         return counter._value;
1724     }
1725 
1726     function increment(Counter storage counter) internal {
1727         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1728         counter._value += 1;
1729     }
1730 
1731     function decrement(Counter storage counter) internal {
1732         counter._value = counter._value.sub(1);
1733     }
1734 }
1735 
1736 // File: contracts/Nftrees.sol
1737 
1738 pragma solidity >=0.7.0 <0.8.0;
1739 
1740 
1741 
1742 
1743 contract Nftrees is ERC721 {
1744     using Counters for Counters.Counter;
1745     Counters.Counter private _tokenIds;
1746 
1747     address payable private _owner;
1748     uint256 private _cap = 0;
1749 
1750     event CapChanged(uint256 newCap);
1751 
1752     constructor(string memory myBase) ERC721("NFTrees", "TREE") {
1753         _setBaseURI(myBase);
1754         _owner = msg.sender;
1755     }
1756 
1757     function buyItem()
1758         public
1759         payable
1760         returns (uint256)
1761     {
1762         require(msg.value == 0.2 ether, "Need to send exactly 0.2 ether");
1763         _tokenIds.increment();
1764         uint256 newItemId = _tokenIds.current();
1765         _safeMint(msg.sender, newItemId);
1766         _owner.transfer(msg.value);
1767         return newItemId;
1768     }   
1769 
1770     function getOwner() public view returns (address) {
1771         return _owner;
1772     }
1773     
1774     function getCap() public view returns (uint256){
1775         return _cap;
1776     }
1777 
1778     function setCap(uint256 newCap) public {
1779         require(_owner==msg.sender);
1780         require(newCap<=420);
1781         _cap = newCap;
1782         emit CapChanged(newCap);
1783     }
1784 
1785     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1786         super._beforeTokenTransfer(from, to, tokenId);
1787         if (from == address(0)) { 
1788             require(totalSupply() < _cap, "ERC721 Capped: cap exceeded");
1789         }
1790     }
1791 }