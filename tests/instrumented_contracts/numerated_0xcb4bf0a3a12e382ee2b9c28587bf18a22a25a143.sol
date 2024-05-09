1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.6.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // SPDX-License-Identifier: MIT
52 
53 pragma solidity ^0.6.0;
54 
55 /**
56  * @dev Implementation of the {IERC165} interface.
57  *
58  * Contracts may inherit from this and call {_registerInterface} to declare
59  * their support of an interface.
60  */
61 contract ERC165 is IERC165 {
62     /*
63      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
64      */
65     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
66 
67     /**
68      * @dev Mapping of interface ids to whether or not it's supported.
69      */
70     mapping(bytes4 => bool) private _supportedInterfaces;
71 
72     constructor () internal {
73         // Derived contracts need only register support for their own interfaces,
74         // we register support for ERC165 itself here
75         _registerInterface(_INTERFACE_ID_ERC165);
76     }
77 
78     /**
79      * @dev See {IERC165-supportsInterface}.
80      *
81      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
82      */
83     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
84         return _supportedInterfaces[interfaceId];
85     }
86 
87     /**
88      * @dev Registers the contract as an implementer of the interface defined by
89      * `interfaceId`. Support of the actual ERC165 interface is automatic and
90      * registering its interface id is not required.
91      *
92      * See {IERC165-supportsInterface}.
93      *
94      * Requirements:
95      *
96      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
97      */
98     function _registerInterface(bytes4 interfaceId) internal virtual {
99         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
100         _supportedInterfaces[interfaceId] = true;
101     }
102 }
103 
104 // SPDX-License-Identifier: MIT
105 
106 pragma solidity ^0.6.2;
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 interface IERC721 is IERC165 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
143      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(address from, address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Transfers `tokenId` token from `from` to `to`.
159      *
160      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(address from, address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
175      * The approval is cleared when the token is transferred.
176      *
177      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
178      *
179      * Requirements:
180      *
181      * - The caller must own the token or be an approved operator.
182      * - `tokenId` must exist.
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address to, uint256 tokenId) external;
187 
188     /**
189      * @dev Returns the account approved for `tokenId` token.
190      *
191      * Requirements:
192      *
193      * - `tokenId` must exist.
194      */
195     function getApproved(uint256 tokenId) external view returns (address operator);
196 
197     /**
198      * @dev Approve or remove `operator` as an operator for the caller.
199      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
200      *
201      * Requirements:
202      *
203      * - The `operator` cannot be the caller.
204      *
205      * Emits an {ApprovalForAll} event.
206      */
207     function setApprovalForAll(address operator, bool _approved) external;
208 
209     /**
210      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
211      *
212      * See {setApprovalForAll}
213      */
214     function isApprovedForAll(address owner, address operator) external view returns (bool);
215 
216     /**
217       * @dev Safely transfers `tokenId` token from `from` to `to`.
218       *
219       * Requirements:
220       *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223       * - `tokenId` token must exist and be owned by `from`.
224       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
225       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
226       *
227       * Emits a {Transfer} event.
228       */
229     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
230 }
231 
232 // SPDX-License-Identifier: MIT
233 
234 pragma solidity ^0.6.2;
235 
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
239  * @dev See https://eips.ethereum.org/EIPS/eip-721
240  */
241 interface IERC721Metadata is IERC721 {
242 
243     /**
244      * @dev Returns the token collection name.
245      */
246     function name() external view returns (string memory);
247 
248     /**
249      * @dev Returns the token collection symbol.
250      */
251     function symbol() external view returns (string memory);
252 
253     /**
254      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
255      */
256     function tokenURI(uint256 tokenId) external view returns (string memory);
257 }
258 
259 // SPDX-License-Identifier: MIT
260 
261 pragma solidity ^0.6.2;
262 
263 /**
264  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
265  * @dev See https://eips.ethereum.org/EIPS/eip-721
266  */
267 interface IERC721Enumerable is IERC721 {
268 
269     /**
270      * @dev Returns the total amount of tokens stored by the contract.
271      */
272     function totalSupply() external view returns (uint256);
273 
274     /**
275      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
276      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
277      */
278     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
279 
280     /**
281      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
282      * Use along with {totalSupply} to enumerate all tokens.
283      */
284     function tokenByIndex(uint256 index) external view returns (uint256);
285 }
286 
287 // SPDX-License-Identifier: MIT
288 
289 pragma solidity ^0.6.0;
290 
291 /**
292  * @title ERC721 token receiver interface
293  * @dev Interface for any contract that wants to support safeTransfers
294  * from ERC721 asset contracts.
295  */
296 interface IERC721Receiver {
297     /**
298      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
299      * by `operator` from `from`, this function is called.
300      *
301      * It must return its Solidity selector to confirm the token transfer.
302      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
303      *
304      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
305      */
306     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
307 }
308 
309 // SPDX-License-Identifier: MIT
310 
311 pragma solidity ^0.6.0;
312 
313 /**
314  * @dev Wrappers over Solidity's arithmetic operations with added overflow
315  * checks.
316  *
317  * Arithmetic operations in Solidity wrap on overflow. This can easily result
318  * in bugs, because programmers usually assume that an overflow raises an
319  * error, which is the standard behavior in high level programming languages.
320  * `SafeMath` restores this intuition by reverting the transaction when an
321  * operation overflows.
322  *
323  * Using this library instead of the unchecked operations eliminates an entire
324  * class of bugs, so it's recommended to use it always.
325  */
326 library SafeMath {
327     /**
328      * @dev Returns the addition of two unsigned integers, reverting on
329      * overflow.
330      *
331      * Counterpart to Solidity's `+` operator.
332      *
333      * Requirements:
334      *
335      * - Addition cannot overflow.
336      */
337     function add(uint256 a, uint256 b) internal pure returns (uint256) {
338         uint256 c = a + b;
339         require(c >= a, "SafeMath: addition overflow");
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the subtraction of two unsigned integers, reverting on
346      * overflow (when the result is negative).
347      *
348      * Counterpart to Solidity's `-` operator.
349      *
350      * Requirements:
351      *
352      * - Subtraction cannot overflow.
353      */
354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355         return sub(a, b, "SafeMath: subtraction overflow");
356     }
357 
358     /**
359      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
360      * overflow (when the result is negative).
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b <= a, errorMessage);
370         uint256 c = a - b;
371 
372         return c;
373     }
374 
375     /**
376      * @dev Returns the multiplication of two unsigned integers, reverting on
377      * overflow.
378      *
379      * Counterpart to Solidity's `*` operator.
380      *
381      * Requirements:
382      *
383      * - Multiplication cannot overflow.
384      */
385     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
386         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
387         // benefit is lost if 'b' is also tested.
388         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
389         if (a == 0) {
390             return 0;
391         }
392 
393         uint256 c = a * b;
394         require(c / a == b, "SafeMath: multiplication overflow");
395 
396         return c;
397     }
398 
399     /**
400      * @dev Returns the integer division of two unsigned integers. Reverts on
401      * division by zero. The result is rounded towards zero.
402      *
403      * Counterpart to Solidity's `/` operator. Note: this function uses a
404      * `revert` opcode (which leaves remaining gas untouched) while Solidity
405      * uses an invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      *
409      * - The divisor cannot be zero.
410      */
411     function div(uint256 a, uint256 b) internal pure returns (uint256) {
412         return div(a, b, "SafeMath: division by zero");
413     }
414 
415     /**
416      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
417      * division by zero. The result is rounded towards zero.
418      *
419      * Counterpart to Solidity's `/` operator. Note: this function uses a
420      * `revert` opcode (which leaves remaining gas untouched) while Solidity
421      * uses an invalid opcode to revert (consuming all remaining gas).
422      *
423      * Requirements:
424      *
425      * - The divisor cannot be zero.
426      */
427     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
428         require(b > 0, errorMessage);
429         uint256 c = a / b;
430         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
431 
432         return c;
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * Reverts when dividing by zero.
438      *
439      * Counterpart to Solidity's `%` operator. This function uses a `revert`
440      * opcode (which leaves remaining gas untouched) while Solidity uses an
441      * invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
448         return mod(a, b, "SafeMath: modulo by zero");
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
453      * Reverts with custom message when dividing by zero.
454      *
455      * Counterpart to Solidity's `%` operator. This function uses a `revert`
456      * opcode (which leaves remaining gas untouched) while Solidity uses an
457      * invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
464         require(b != 0, errorMessage);
465         return a % b;
466     }
467 }
468 
469 // SPDX-License-Identifier: MIT
470 
471 pragma solidity ^0.6.2;
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies on extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         // solhint-disable-next-line no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
525         (bool success, ) = recipient.call{ value: amount }("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain`call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         require(isContract(target), "Address: call to non-contract");
585 
586         // solhint-disable-next-line avoid-low-level-calls
587         (bool success, bytes memory returndata) = target.call{ value: value }(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         // solhint-disable-next-line avoid-low-level-calls
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.3._
620      */
621     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
622         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
627      * but performing a delegate call.
628      *
629      * _Available since v3.3._
630      */
631     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
632         require(isContract(target), "Address: delegate call to non-contract");
633 
634         // solhint-disable-next-line avoid-low-level-calls
635         (bool success, bytes memory returndata) = target.delegatecall(data);
636         return _verifyCallResult(success, returndata, errorMessage);
637     }
638 
639     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 // solhint-disable-next-line no-inline-assembly
648                 assembly {
649                     let returndata_size := mload(returndata)
650                     revert(add(32, returndata), returndata_size)
651                 }
652             } else {
653                 revert(errorMessage);
654             }
655         }
656     }
657 }
658 
659 // SPDX-License-Identifier: MIT
660 
661 pragma solidity ^0.6.0;
662 
663 /**
664  * @dev Library for managing
665  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
666  * types.
667  *
668  * Sets have the following properties:
669  *
670  * - Elements are added, removed, and checked for existence in constant time
671  * (O(1)).
672  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
673  *
674  * ```
675  * contract Example {
676  *     // Add the library methods
677  *     using EnumerableSet for EnumerableSet.AddressSet;
678  *
679  *     // Declare a set state variable
680  *     EnumerableSet.AddressSet private mySet;
681  * }
682  * ```
683  *
684  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
685  * (`UintSet`) are supported.
686  */
687 library EnumerableSet {
688     // To implement this library for multiple types with as little code
689     // repetition as possible, we write it in terms of a generic Set type with
690     // bytes32 values.
691     // The Set implementation uses private functions, and user-facing
692     // implementations (such as AddressSet) are just wrappers around the
693     // underlying Set.
694     // This means that we can only create new EnumerableSets for types that fit
695     // in bytes32.
696 
697     struct Set {
698         // Storage of set values
699         bytes32[] _values;
700 
701         // Position of the value in the `values` array, plus 1 because index 0
702         // means a value is not in the set.
703         mapping (bytes32 => uint256) _indexes;
704     }
705 
706     /**
707      * @dev Add a value to a set. O(1).
708      *
709      * Returns true if the value was added to the set, that is if it was not
710      * already present.
711      */
712     function _add(Set storage set, bytes32 value) private returns (bool) {
713         if (!_contains(set, value)) {
714             set._values.push(value);
715             // The value is stored at length-1, but we add 1 to all indexes
716             // and use 0 as a sentinel value
717             set._indexes[value] = set._values.length;
718             return true;
719         } else {
720             return false;
721         }
722     }
723 
724     /**
725      * @dev Removes a value from a set. O(1).
726      *
727      * Returns true if the value was removed from the set, that is if it was
728      * present.
729      */
730     function _remove(Set storage set, bytes32 value) private returns (bool) {
731         // We read and store the value's index to prevent multiple reads from the same storage slot
732         uint256 valueIndex = set._indexes[value];
733 
734         if (valueIndex != 0) { // Equivalent to contains(set, value)
735             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
736             // the array, and then remove the last element (sometimes called as 'swap and pop').
737             // This modifies the order of the array, as noted in {at}.
738 
739             uint256 toDeleteIndex = valueIndex - 1;
740             uint256 lastIndex = set._values.length - 1;
741 
742             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
743             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
744 
745             bytes32 lastvalue = set._values[lastIndex];
746 
747             // Move the last value to the index where the value to delete is
748             set._values[toDeleteIndex] = lastvalue;
749             // Update the index for the moved value
750             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
751 
752             // Delete the slot where the moved value was stored
753             set._values.pop();
754 
755             // Delete the index for the deleted slot
756             delete set._indexes[value];
757 
758             return true;
759         } else {
760             return false;
761         }
762     }
763 
764     /**
765      * @dev Returns true if the value is in the set. O(1).
766      */
767     function _contains(Set storage set, bytes32 value) private view returns (bool) {
768         return set._indexes[value] != 0;
769     }
770 
771     /**
772      * @dev Returns the number of values on the set. O(1).
773      */
774     function _length(Set storage set) private view returns (uint256) {
775         return set._values.length;
776     }
777 
778     /**
779      * @dev Returns the value stored at position `index` in the set. O(1).
780      *
781      * Note that there are no guarantees on the ordering of values inside the
782      * array, and it may change when more values are added or removed.
783      *
784      * Requirements:
785      *
786      * - `index` must be strictly less than {length}.
787      */
788     function _at(Set storage set, uint256 index) private view returns (bytes32) {
789         require(set._values.length > index, "EnumerableSet: index out of bounds");
790         return set._values[index];
791     }
792 
793     // AddressSet
794 
795     struct AddressSet {
796         Set _inner;
797     }
798 
799     /**
800      * @dev Add a value to a set. O(1).
801      *
802      * Returns true if the value was added to the set, that is if it was not
803      * already present.
804      */
805     function add(AddressSet storage set, address value) internal returns (bool) {
806         return _add(set._inner, bytes32(uint256(value)));
807     }
808 
809     /**
810      * @dev Removes a value from a set. O(1).
811      *
812      * Returns true if the value was removed from the set, that is if it was
813      * present.
814      */
815     function remove(AddressSet storage set, address value) internal returns (bool) {
816         return _remove(set._inner, bytes32(uint256(value)));
817     }
818 
819     /**
820      * @dev Returns true if the value is in the set. O(1).
821      */
822     function contains(AddressSet storage set, address value) internal view returns (bool) {
823         return _contains(set._inner, bytes32(uint256(value)));
824     }
825 
826     /**
827      * @dev Returns the number of values in the set. O(1).
828      */
829     function length(AddressSet storage set) internal view returns (uint256) {
830         return _length(set._inner);
831     }
832 
833     /**
834      * @dev Returns the value stored at position `index` in the set. O(1).
835      *
836      * Note that there are no guarantees on the ordering of values inside the
837      * array, and it may change when more values are added or removed.
838      *
839      * Requirements:
840      *
841      * - `index` must be strictly less than {length}.
842      */
843     function at(AddressSet storage set, uint256 index) internal view returns (address) {
844         return address(uint256(_at(set._inner, index)));
845     }
846 
847 
848     // UintSet
849 
850     struct UintSet {
851         Set _inner;
852     }
853 
854     /**
855      * @dev Add a value to a set. O(1).
856      *
857      * Returns true if the value was added to the set, that is if it was not
858      * already present.
859      */
860     function add(UintSet storage set, uint256 value) internal returns (bool) {
861         return _add(set._inner, bytes32(value));
862     }
863 
864     /**
865      * @dev Removes a value from a set. O(1).
866      *
867      * Returns true if the value was removed from the set, that is if it was
868      * present.
869      */
870     function remove(UintSet storage set, uint256 value) internal returns (bool) {
871         return _remove(set._inner, bytes32(value));
872     }
873 
874     /**
875      * @dev Returns true if the value is in the set. O(1).
876      */
877     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
878         return _contains(set._inner, bytes32(value));
879     }
880 
881     /**
882      * @dev Returns the number of values on the set. O(1).
883      */
884     function length(UintSet storage set) internal view returns (uint256) {
885         return _length(set._inner);
886     }
887 
888     /**
889      * @dev Returns the value stored at position `index` in the set. O(1).
890      *
891      * Note that there are no guarantees on the ordering of values inside the
892      * array, and it may change when more values are added or removed.
893      *
894      * Requirements:
895      *
896      * - `index` must be strictly less than {length}.
897      */
898     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
899         return uint256(_at(set._inner, index));
900     }
901 }
902 
903 // SPDX-License-Identifier: MIT
904 
905 pragma solidity ^0.6.0;
906 
907 /**
908  * @dev Library for managing an enumerable variant of Solidity's
909  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
910  * type.
911  *
912  * Maps have the following properties:
913  *
914  * - Entries are added, removed, and checked for existence in constant time
915  * (O(1)).
916  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
917  *
918  * ```
919  * contract Example {
920  *     // Add the library methods
921  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
922  *
923  *     // Declare a set state variable
924  *     EnumerableMap.UintToAddressMap private myMap;
925  * }
926  * ```
927  *
928  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
929  * supported.
930  */
931 library EnumerableMap {
932     // To implement this library for multiple types with as little code
933     // repetition as possible, we write it in terms of a generic Map type with
934     // bytes32 keys and values.
935     // The Map implementation uses private functions, and user-facing
936     // implementations (such as Uint256ToAddressMap) are just wrappers around
937     // the underlying Map.
938     // This means that we can only create new EnumerableMaps for types that fit
939     // in bytes32.
940 
941     struct MapEntry {
942         bytes32 _key;
943         bytes32 _value;
944     }
945 
946     struct Map {
947         // Storage of map keys and values
948         MapEntry[] _entries;
949 
950         // Position of the entry defined by a key in the `entries` array, plus 1
951         // because index 0 means a key is not in the map.
952         mapping (bytes32 => uint256) _indexes;
953     }
954 
955     /**
956      * @dev Adds a key-value pair to a map, or updates the value for an existing
957      * key. O(1).
958      *
959      * Returns true if the key was added to the map, that is if it was not
960      * already present.
961      */
962     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
963         // We read and store the key's index to prevent multiple reads from the same storage slot
964         uint256 keyIndex = map._indexes[key];
965 
966         if (keyIndex == 0) { // Equivalent to !contains(map, key)
967             map._entries.push(MapEntry({ _key: key, _value: value }));
968             // The entry is stored at length-1, but we add 1 to all indexes
969             // and use 0 as a sentinel value
970             map._indexes[key] = map._entries.length;
971             return true;
972         } else {
973             map._entries[keyIndex - 1]._value = value;
974             return false;
975         }
976     }
977 
978     /**
979      * @dev Removes a key-value pair from a map. O(1).
980      *
981      * Returns true if the key was removed from the map, that is if it was present.
982      */
983     function _remove(Map storage map, bytes32 key) private returns (bool) {
984         // We read and store the key's index to prevent multiple reads from the same storage slot
985         uint256 keyIndex = map._indexes[key];
986 
987         if (keyIndex != 0) { // Equivalent to contains(map, key)
988             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
989             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
990             // This modifies the order of the array, as noted in {at}.
991 
992             uint256 toDeleteIndex = keyIndex - 1;
993             uint256 lastIndex = map._entries.length - 1;
994 
995             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
996             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
997 
998             MapEntry storage lastEntry = map._entries[lastIndex];
999 
1000             // Move the last entry to the index where the entry to delete is
1001             map._entries[toDeleteIndex] = lastEntry;
1002             // Update the index for the moved entry
1003             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1004 
1005             // Delete the slot where the moved entry was stored
1006             map._entries.pop();
1007 
1008             // Delete the index for the deleted slot
1009             delete map._indexes[key];
1010 
1011             return true;
1012         } else {
1013             return false;
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns true if the key is in the map. O(1).
1019      */
1020     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1021         return map._indexes[key] != 0;
1022     }
1023 
1024     /**
1025      * @dev Returns the number of key-value pairs in the map. O(1).
1026      */
1027     function _length(Map storage map) private view returns (uint256) {
1028         return map._entries.length;
1029     }
1030 
1031     /**
1032      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1033      *
1034      * Note that there are no guarantees on the ordering of entries inside the
1035      * array, and it may change when more entries are added or removed.
1036      *
1037      * Requirements:
1038      *
1039      * - `index` must be strictly less than {length}.
1040      */
1041     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1042         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1043 
1044         MapEntry storage entry = map._entries[index];
1045         return (entry._key, entry._value);
1046     }
1047 
1048     /**
1049      * @dev Returns the value associated with `key`.  O(1).
1050      *
1051      * Requirements:
1052      *
1053      * - `key` must be in the map.
1054      */
1055     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1056         return _get(map, key, "EnumerableMap: nonexistent key");
1057     }
1058 
1059     /**
1060      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1061      */
1062     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1063         uint256 keyIndex = map._indexes[key];
1064         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1065         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1066     }
1067 
1068     // UintToAddressMap
1069 
1070     struct UintToAddressMap {
1071         Map _inner;
1072     }
1073 
1074     /**
1075      * @dev Adds a key-value pair to a map, or updates the value for an existing
1076      * key. O(1).
1077      *
1078      * Returns true if the key was added to the map, that is if it was not
1079      * already present.
1080      */
1081     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1082         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1083     }
1084 
1085     /**
1086      * @dev Removes a value from a set. O(1).
1087      *
1088      * Returns true if the key was removed from the map, that is if it was present.
1089      */
1090     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1091         return _remove(map._inner, bytes32(key));
1092     }
1093 
1094     /**
1095      * @dev Returns true if the key is in the map. O(1).
1096      */
1097     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1098         return _contains(map._inner, bytes32(key));
1099     }
1100 
1101     /**
1102      * @dev Returns the number of elements in the map. O(1).
1103      */
1104     function length(UintToAddressMap storage map) internal view returns (uint256) {
1105         return _length(map._inner);
1106     }
1107 
1108     /**
1109      * @dev Returns the element stored at position `index` in the set. O(1).
1110      * Note that there are no guarantees on the ordering of values inside the
1111      * array, and it may change when more values are added or removed.
1112      *
1113      * Requirements:
1114      *
1115      * - `index` must be strictly less than {length}.
1116      */
1117     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1118         (bytes32 key, bytes32 value) = _at(map._inner, index);
1119         return (uint256(key), address(uint256(value)));
1120     }
1121 
1122     /**
1123      * @dev Returns the value associated with `key`.  O(1).
1124      *
1125      * Requirements:
1126      *
1127      * - `key` must be in the map.
1128      */
1129     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1130         return address(uint256(_get(map._inner, bytes32(key))));
1131     }
1132 
1133     /**
1134      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1135      */
1136     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1137         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1138     }
1139 }
1140 
1141 // SPDX-License-Identifier: MIT
1142 
1143 pragma solidity ^0.6.0;
1144 
1145 /**
1146  * @dev String operations.
1147  */
1148 library Strings {
1149     /**
1150      * @dev Converts a `uint256` to its ASCII `string` representation.
1151      */
1152     function toString(uint256 value) internal pure returns (string memory) {
1153         // Inspired by OraclizeAPI's implementation - MIT licence
1154         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1155 
1156         if (value == 0) {
1157             return "0";
1158         }
1159         uint256 temp = value;
1160         uint256 digits;
1161         while (temp != 0) {
1162             digits++;
1163             temp /= 10;
1164         }
1165         bytes memory buffer = new bytes(digits);
1166         uint256 index = digits - 1;
1167         temp = value;
1168         while (temp != 0) {
1169             buffer[index--] = byte(uint8(48 + temp % 10));
1170             temp /= 10;
1171         }
1172         return string(buffer);
1173     }
1174 }
1175 
1176 // SPDX-License-Identifier: MIT
1177 
1178 pragma solidity ^0.6.0;
1179 
1180 /**
1181  * @title ERC721 Non-Fungible Token Standard basic implementation
1182  * @dev see https://eips.ethereum.org/EIPS/eip-721
1183  */
1184 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1185     using SafeMath for uint256;
1186     using Address for address;
1187     using EnumerableSet for EnumerableSet.UintSet;
1188     using EnumerableMap for EnumerableMap.UintToAddressMap;
1189     using Strings for uint256;
1190 
1191     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1192     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1193     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1194 
1195     // Mapping from holder address to their (enumerable) set of owned tokens
1196     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1197 
1198     // Enumerable mapping from token ids to their owners
1199     EnumerableMap.UintToAddressMap private _tokenOwners;
1200 
1201     // Mapping from token ID to approved address
1202     mapping (uint256 => address) private _tokenApprovals;
1203 
1204     // Mapping from owner to operator approvals
1205     mapping (address => mapping (address => bool)) private _operatorApprovals;
1206 
1207     // Token name
1208     string private _name;
1209 
1210     // Token symbol
1211     string private _symbol;
1212 
1213     // Optional mapping for token URIs
1214     mapping (uint256 => string) private _tokenURIs;
1215 
1216     // Base URI
1217     string private _baseURI;
1218 
1219     /*
1220      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1221      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1222      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1223      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1224      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1225      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1226      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1227      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1228      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1229      *
1230      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1231      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1232      */
1233     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1234 
1235     /*
1236      *     bytes4(keccak256('name()')) == 0x06fdde03
1237      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1238      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1239      *
1240      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1241      */
1242     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1243 
1244     /*
1245      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1246      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1247      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1248      *
1249      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1250      */
1251     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1252 
1253     /**
1254      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1255      */
1256     constructor (string memory name, string memory symbol) public {
1257         _name = name;
1258         _symbol = symbol;
1259 
1260         // register the supported interfaces to conform to ERC721 via ERC165
1261         _registerInterface(_INTERFACE_ID_ERC721);
1262         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1263         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-balanceOf}.
1268      */
1269     function balanceOf(address owner) public view override returns (uint256) {
1270         require(owner != address(0), "ERC721: balance query for the zero address");
1271 
1272         return _holderTokens[owner].length();
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-ownerOf}.
1277      */
1278     function ownerOf(uint256 tokenId) public view override returns (address) {
1279         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Metadata-name}.
1284      */
1285     function name() public view override returns (string memory) {
1286         return _name;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Metadata-symbol}.
1291      */
1292     function symbol() public view override returns (string memory) {
1293         return _symbol;
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Metadata-tokenURI}.
1298      */
1299     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1300         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1301 
1302         string memory _tokenURI = _tokenURIs[tokenId];
1303 
1304         // If there is no base URI, return the token URI.
1305         if (bytes(_baseURI).length == 0) {
1306             return _tokenURI;
1307         }
1308         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1309         if (bytes(_tokenURI).length > 0) {
1310             return string(abi.encodePacked(_baseURI, _tokenURI));
1311         }
1312         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1313         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1314     }
1315 
1316     /**
1317     * @dev Returns the base URI set via {_setBaseURI}. This will be
1318     * automatically added as a prefix in {tokenURI} to each token's URI, or
1319     * to the token ID if no specific URI is set for that token ID.
1320     */
1321     function baseURI() public view returns (string memory) {
1322         return _baseURI;
1323     }
1324 
1325     /**
1326      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1327      */
1328     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1329         return _holderTokens[owner].at(index);
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Enumerable-totalSupply}.
1334      */
1335     function totalSupply() public view override returns (uint256) {
1336         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1337         return _tokenOwners.length();
1338     }
1339 
1340     /**
1341      * @dev See {IERC721Enumerable-tokenByIndex}.
1342      */
1343     function tokenByIndex(uint256 index) public view override returns (uint256) {
1344         (uint256 tokenId, ) = _tokenOwners.at(index);
1345         return tokenId;
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-approve}.
1350      */
1351     function approve(address to, uint256 tokenId) public virtual override {
1352         address owner = ownerOf(tokenId);
1353         require(to != owner, "ERC721: approval to current owner");
1354 
1355         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1356             "ERC721: approve caller is not owner nor approved for all"
1357         );
1358 
1359         _approve(to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-getApproved}.
1364      */
1365     function getApproved(uint256 tokenId) public view override returns (address) {
1366         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1367 
1368         return _tokenApprovals[tokenId];
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-setApprovalForAll}.
1373      */
1374     function setApprovalForAll(address operator, bool approved) public virtual override {
1375         require(operator != _msgSender(), "ERC721: approve to caller");
1376 
1377         _operatorApprovals[_msgSender()][operator] = approved;
1378         emit ApprovalForAll(_msgSender(), operator, approved);
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-isApprovedForAll}.
1383      */
1384     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1385         return _operatorApprovals[owner][operator];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-transferFrom}.
1390      */
1391     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1392         //solhint-disable-next-line max-line-length
1393         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1394 
1395         _transfer(from, to, tokenId);
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-safeTransferFrom}.
1400      */
1401     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1402         safeTransferFrom(from, to, tokenId, "");
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-safeTransferFrom}.
1407      */
1408     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1409         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1410         _safeTransfer(from, to, tokenId, _data);
1411     }
1412 
1413     /**
1414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1416      *
1417      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1418      *
1419      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1420      * implement alternative mechanisms to perform token transfer, such as signature-based.
1421      *
1422      * Requirements:
1423      *
1424      * - `from` cannot be the zero address.
1425      * - `to` cannot be the zero address.
1426      * - `tokenId` token must exist and be owned by `from`.
1427      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1432         _transfer(from, to, tokenId);
1433         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1434     }
1435 
1436     /**
1437      * @dev Returns whether `tokenId` exists.
1438      *
1439      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1440      *
1441      * Tokens start existing when they are minted (`_mint`),
1442      * and stop existing when they are burned (`_burn`).
1443      */
1444     function _exists(uint256 tokenId) internal view returns (bool) {
1445         return _tokenOwners.contains(tokenId);
1446     }
1447 
1448     /**
1449      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must exist.
1454      */
1455     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1456         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1457         address owner = ownerOf(tokenId);
1458         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1459     }
1460 
1461     /**
1462      * @dev Safely mints `tokenId` and transfers it to `to`.
1463      *
1464      * Requirements:
1465      d*
1466      * - `tokenId` must not exist.
1467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function _safeMint(address to, uint256 tokenId) internal virtual {
1472         _safeMint(to, tokenId, "");
1473     }
1474 
1475     /**
1476      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1477      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1478      */
1479     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1480         _mint(to, tokenId);
1481         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1482     }
1483 
1484     /**
1485      * @dev Mints `tokenId` and transfers it to `to`.
1486      *
1487      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1488      *
1489      * Requirements:
1490      *
1491      * - `tokenId` must not exist.
1492      * - `to` cannot be the zero address.
1493      *
1494      * Emits a {Transfer} event.
1495      */
1496     function _mint(address to, uint256 tokenId) internal virtual {
1497         require(to != address(0), "ERC721: mint to the zero address");
1498         require(!_exists(tokenId), "ERC721: token already minted");
1499 
1500         _beforeTokenTransfer(address(0), to, tokenId);
1501 
1502         _holderTokens[to].add(tokenId);
1503 
1504         _tokenOwners.set(tokenId, to);
1505 
1506         emit Transfer(address(0), to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Destroys `tokenId`.
1511      * The approval is cleared when the token is burned.
1512      *
1513      * Requirements:
1514      *
1515      * - `tokenId` must exist.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _burn(uint256 tokenId) internal virtual {
1520         address owner = ownerOf(tokenId);
1521 
1522         _beforeTokenTransfer(owner, address(0), tokenId);
1523 
1524         // Clear approvals
1525         _approve(address(0), tokenId);
1526 
1527         // Clear metadata (if any)
1528         if (bytes(_tokenURIs[tokenId]).length != 0) {
1529             delete _tokenURIs[tokenId];
1530         }
1531 
1532         _holderTokens[owner].remove(tokenId);
1533 
1534         _tokenOwners.remove(tokenId);
1535 
1536         emit Transfer(owner, address(0), tokenId);
1537     }
1538 
1539     /**
1540      * @dev Transfers `tokenId` from `from` to `to`.
1541      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1542      *
1543      * Requirements:
1544      *
1545      * - `to` cannot be the zero address.
1546      * - `tokenId` token must be owned by `from`.
1547      *
1548      * Emits a {Transfer} event.
1549      */
1550     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1551         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1552         require(to != address(0), "ERC721: transfer to the zero address");
1553 
1554         _beforeTokenTransfer(from, to, tokenId);
1555 
1556         // Clear approvals from the previous owner
1557         _approve(address(0), tokenId);
1558 
1559         _holderTokens[from].remove(tokenId);
1560         _holderTokens[to].add(tokenId);
1561 
1562         _tokenOwners.set(tokenId, to);
1563 
1564         emit Transfer(from, to, tokenId);
1565     }
1566 
1567     /**
1568      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1569      *
1570      * Requirements:
1571      *
1572      * - `tokenId` must exist.
1573      */
1574     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1575         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1576         _tokenURIs[tokenId] = _tokenURI;
1577     }
1578 
1579     /**
1580      * @dev Internal function to set the base URI for all token IDs. It is
1581      * automatically added as a prefix to the value returned in {tokenURI},
1582      * or to the token ID if {tokenURI} is empty.
1583      */
1584     function _setBaseURI(string memory baseURI_) internal virtual {
1585         _baseURI = baseURI_;
1586     }
1587 
1588     /**
1589      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1590      * The call is not executed if the target address is not a contract.
1591      *
1592      * @param from address representing the previous owner of the given token ID
1593      * @param to target address that will receive the tokens
1594      * @param tokenId uint256 ID of the token to be transferred
1595      * @param _data bytes optional data to send along with the call
1596      * @return bool whether the call correctly returned the expected magic value
1597      */
1598     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1599     private returns (bool)
1600     {
1601         if (!to.isContract()) {
1602             return true;
1603         }
1604         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1605                 IERC721Receiver(to).onERC721Received.selector,
1606                 _msgSender(),
1607                 from,
1608                 tokenId,
1609                 _data
1610             ), "ERC721: transfer to non ERC721Receiver implementer");
1611         bytes4 retval = abi.decode(returndata, (bytes4));
1612         return (retval == _ERC721_RECEIVED);
1613     }
1614 
1615     function _approve(address to, uint256 tokenId) private {
1616         _tokenApprovals[tokenId] = to;
1617         emit Approval(ownerOf(tokenId), to, tokenId);
1618     }
1619 
1620     /**
1621      * @dev Hook that is called before any token transfer. This includes minting
1622      * and burning.
1623      *
1624      * Calling conditions:
1625      *
1626      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1627      * transferred to `to`.
1628      * - When `from` is zero, `tokenId` will be minted for `to`.
1629      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1630      * - `from` cannot be the zero address.
1631      * - `to` cannot be the zero address.
1632      *
1633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1634      */
1635     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1636 }
1637 
1638 // SPDX-License-Identifier: MIT
1639 
1640 pragma solidity ^0.6.0;
1641 
1642 /**
1643  * @dev Contract module which allows children to implement an emergency stop
1644  * mechanism that can be triggered by an authorized account.
1645  *
1646  * This module is used through inheritance. It will make available the
1647  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1648  * the functions of your contract. Note that they will not be pausable by
1649  * simply including this module, only once the modifiers are put in place.
1650  */
1651 contract Pausable is Context {
1652     /**
1653      * @dev Emitted when the pause is triggered by `account`.
1654      */
1655     event Paused(address account);
1656 
1657     /**
1658      * @dev Emitted when the pause is lifted by `account`.
1659      */
1660     event Unpaused(address account);
1661 
1662     bool private _paused;
1663 
1664     /**
1665      * @dev Initializes the contract in unpaused state.
1666      */
1667     constructor () internal {
1668         _paused = false;
1669     }
1670 
1671     /**
1672      * @dev Returns true if the contract is paused, and false otherwise.
1673      */
1674     function paused() public view returns (bool) {
1675         return _paused;
1676     }
1677 
1678     /**
1679      * @dev Modifier to make a function callable only when the contract is not paused.
1680      *
1681      * Requirements:
1682      *
1683      * - The contract must not be paused.
1684      */
1685     modifier whenNotPaused() {
1686         require(!_paused, "Pausable: paused");
1687         _;
1688     }
1689 
1690     /**
1691      * @dev Modifier to make a function callable only when the contract is paused.
1692      *
1693      * Requirements:
1694      *
1695      * - The contract must be paused.
1696      */
1697     modifier whenPaused() {
1698         require(_paused, "Pausable: not paused");
1699         _;
1700     }
1701 
1702     /**
1703      * @dev Triggers stopped state.
1704      *
1705      * Requirements:
1706      *
1707      * - The contract must not be paused.
1708      */
1709     function _pause() internal virtual whenNotPaused {
1710         _paused = true;
1711         emit Paused(_msgSender());
1712     }
1713 
1714     /**
1715      * @dev Returns to normal state.
1716      *
1717      * Requirements:
1718      *
1719      * - The contract must be paused.
1720      */
1721     function _unpause() internal virtual whenPaused {
1722         _paused = false;
1723         emit Unpaused(_msgSender());
1724     }
1725 }
1726 
1727 // SPDX-License-Identifier: MIT
1728 
1729 pragma solidity ^0.6.0;
1730 
1731 /**
1732  * @dev ERC721 token with pausable token transfers, minting and burning.
1733  *
1734  * Useful for scenarios such as preventing trades until the end of an evaluation
1735  * period, or having an emergency switch for freezing all token transfers in the
1736  * event of a large bug.
1737  */
1738 abstract contract ERC721Pausable is ERC721, Pausable {
1739     /**
1740      * @dev See {ERC721-_beforeTokenTransfer}.
1741      *
1742      * Requirements:
1743      *
1744      * - the contract must not be paused.
1745      */
1746     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1747         super._beforeTokenTransfer(from, to, tokenId);
1748 
1749         require(!paused(), "ERC721Pausable: token transfer while paused");
1750     }
1751 }
1752 
1753 
1754 // SPDX-License-Identifier: MIT
1755 
1756 pragma solidity ^0.6.0;
1757 
1758 /**
1759  * @dev Contract module which provides a basic access control mechanism, where
1760  * there is an account (an owner) that can be granted exclusive access to
1761  * specific functions.
1762  *
1763  * By default, the owner account will be the one that deploys the contract. This
1764  * can later be changed with {transferOwnership}.
1765  *
1766  * This module is used through inheritance. It will make available the modifier
1767  * `onlyOwner`, which can be applied to your functions to restrict their use to
1768  * the owner.
1769  */
1770 contract Ownable is Context {
1771     address private _owner;
1772 
1773     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1774 
1775     /**
1776      * @dev Initializes the contract setting the deployer as the initial owner.
1777      */
1778     constructor () internal {
1779         address msgSender = _msgSender();
1780         _owner = msgSender;
1781         emit OwnershipTransferred(address(0), msgSender);
1782     }
1783 
1784     /**
1785      * @dev Returns the address of the current owner.
1786      */
1787     function owner() public view returns (address) {
1788         return _owner;
1789     }
1790 
1791     /**
1792      * @dev Throws if called by any account other than the owner.
1793      */
1794     modifier onlyOwner() {
1795         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1796         _;
1797     }
1798 
1799     /**
1800      * @dev Leaves the contract without owner. It will not be possible to call
1801      * `onlyOwner` functions anymore. Can only be called by the current owner.
1802      *
1803      * NOTE: Renouncing ownership will leave the contract without an owner,
1804      * thereby removing any functionality that is only available to the owner.
1805      */
1806     function renounceOwnership() public virtual onlyOwner {
1807         emit OwnershipTransferred(_owner, address(0));
1808         _owner = address(0);
1809     }
1810 
1811     /**
1812      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1813      * Can only be called by the current owner.
1814      */
1815     function transferOwnership(address newOwner) public virtual onlyOwner {
1816         require(newOwner != address(0), "Ownable: new owner is the zero address");
1817         emit OwnershipTransferred(_owner, newOwner);
1818         _owner = newOwner;
1819     }
1820 }
1821 
1822 pragma solidity ^0.6.0;
1823 
1824 /**
1825  * @title Counters
1826  * @author Matt Condon (@shrugs)
1827  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1828  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1829  *
1830  * Include with `using Counters for Counters.Counter;`
1831  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1832  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1833  * directly accessed.
1834  */
1835 library Counters {
1836     using SafeMath for uint256;
1837 
1838     struct Counter {
1839         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1840         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1841         // this feature: see https://github.com/ethereum/solidity/issues/4637
1842         uint256 _value; // default: 0
1843     }
1844 
1845     function current(Counter storage counter) internal view returns (uint256) {
1846         return counter._value;
1847     }
1848 
1849     function increment(Counter storage counter) internal {
1850         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1851         counter._value += 1;
1852     }
1853 
1854     function decrement(Counter storage counter) internal {
1855         counter._value = counter._value.sub(1);
1856     }
1857 }
1858 
1859 pragma solidity ^0.6.0;
1860 
1861 contract YeaHammer is ERC721Pausable, Ownable {
1862 
1863     uint256 private _maxTotalSupply;
1864 
1865     mapping(address => bool) public _minters;
1866 
1867     constructor() public ERC721("yea.hammer", "yeah") {
1868         _maxTotalSupply = 66600;
1869         setBaseURI("https://www.douyea.com/hammer-resources/hammer/");
1870         addMinter(_msgSender());
1871     }
1872 
1873     /**
1874      * @dev Throws if called by any account other than the owner.
1875      */
1876     modifier onlyMinter() {
1877         require(_minters[msg.sender], "Minter: caller is not the owner");
1878         _;
1879     }
1880 
1881     function mint(address player, uint256 id) public onlyMinter returns (uint256) {
1882 
1883         require(id <= _maxTotalSupply && id > 0, "Minter: mine pool is empty");
1884 
1885         _mint(player, id);
1886         _setTokenURI(id, Strings.toString(id));
1887 
1888         return id;
1889     }
1890 
1891 
1892     function setBaseURI(string memory baseURI) public onlyOwner virtual {
1893         _setBaseURI(baseURI);
1894     }
1895 
1896     /**
1897      * @dev Triggers stopped state.
1898      *
1899      * Requirements:
1900      *
1901      * - The contract must not be paused.
1902      */
1903     function pause() public virtual onlyOwner whenNotPaused {
1904         _pause();
1905     }
1906 
1907     /**
1908      * @dev Returns to normal state.
1909      *
1910      * Requirements:
1911      *
1912      * - The contract must be paused.
1913      */
1914     function unpause() public virtual onlyOwner whenPaused {
1915         _unpause();
1916     }
1917 
1918     function addMinter(address minter) public onlyOwner {
1919         _minters[minter] = true;
1920     }
1921 
1922     function removeMinter(address minter) public onlyOwner {
1923         _minters[minter] = false;
1924     }
1925 
1926     function burn(uint256 tokenId) public onlyOwner {
1927         _burn(tokenId);
1928     }
1929 
1930 }