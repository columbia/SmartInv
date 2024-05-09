1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-10
3 */
4 
5 pragma solidity ^0.7.3;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(address from, address to, uint256 tokenId) external;
75 
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address from, address to, uint256 tokenId) external;
91 
92     /**
93      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
94      * The approval is cleared when the token is transferred.
95      *
96      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
97      *
98      * Requirements:
99      *
100      * - The caller must own the token or be an approved operator.
101      * - `tokenId` must exist.
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Returns the account approved for `tokenId` token.
109      *
110      * Requirements:
111      *
112      * - `tokenId` must exist.
113      */
114     function getApproved(uint256 tokenId) external view returns (address operator);
115 
116     /**
117      * @dev Approve or remove `operator` as an operator for the caller.
118      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
119      *
120      * Requirements:
121      *
122      * - The `operator` cannot be the caller.
123      *
124      * Emits an {ApprovalForAll} event.
125      */
126     function setApprovalForAll(address operator, bool _approved) external;
127 
128     /**
129      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
130      *
131      * See {setApprovalForAll}
132      */
133     function isApprovedForAll(address owner, address operator) external view returns (bool);
134 
135     /**
136       * @dev Safely transfers `tokenId` token from `from` to `to`.
137       *
138       * Requirements:
139       *
140       * - `from` cannot be the zero address.
141       * - `to` cannot be the zero address.
142       * - `tokenId` token must exist and be owned by `from`.
143       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
144       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
145       *
146       * Emits a {Transfer} event.
147       */
148     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
149 }
150 
151 interface IERC721Metadata is IERC721 {
152 
153     /**
154      * @dev Returns the token collection name.
155      */
156     function name() external view returns (string memory);
157 
158     /**
159      * @dev Returns the token collection symbol.
160      */
161     function symbol() external view returns (string memory);
162 
163     /**
164      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
165      */
166     function tokenURI(uint256 tokenId) external view returns (string memory);
167 }
168 
169 interface IERC721Enumerable is IERC721 {
170 
171     /**
172      * @dev Returns the total amount of tokens stored by the contract.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
178      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
179      */
180     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
181 
182     /**
183      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
184      * Use along with {totalSupply} to enumerate all tokens.
185      */
186     function tokenByIndex(uint256 index) external view returns (uint256);
187 }
188 
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
200 }
201 
202 /**
203  * @dev Implementation of the {IERC165} interface.
204  *
205  * Contracts may inherit from this and call {_registerInterface} to declare
206  * their support of an interface.
207  */
208 abstract contract ERC165 is IERC165 {
209     /*
210      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
211      */
212     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
213 
214     /**
215      * @dev Mapping of interface ids to whether or not it's supported.
216      */
217     mapping(bytes4 => bool) private _supportedInterfaces;
218 
219     constructor () internal {
220         // Derived contracts need only register support for their own interfaces,
221         // we register support for ERC165 itself here
222         _registerInterface(_INTERFACE_ID_ERC165);
223     }
224 
225     /**
226      * @dev See {IERC165-supportsInterface}.
227      *
228      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
231         return _supportedInterfaces[interfaceId];
232     }
233 
234     /**
235      * @dev Registers the contract as an implementer of the interface defined by
236      * `interfaceId`. Support of the actual ERC165 interface is automatic and
237      * registering its interface id is not required.
238      *
239      * See {IERC165-supportsInterface}.
240      *
241      * Requirements:
242      *
243      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
244      */
245     function _registerInterface(bytes4 interfaceId) internal virtual {
246         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
247         _supportedInterfaces[interfaceId] = true;
248     }
249 }
250 
251 /**
252  * @dev Wrappers over Solidity's arithmetic operations with added overflow
253  * checks.
254  *
255  * Arithmetic operations in Solidity wrap on overflow. This can easily result
256  * in bugs, because programmers usually assume that an overflow raises an
257  * error, which is the standard behavior in high level programming languages.
258  * `SafeMath` restores this intuition by reverting the transaction when an
259  * operation overflows.
260  *
261  * Using this library instead of the unchecked operations eliminates an entire
262  * class of bugs, so it's recommended to use it always.
263  */
264 library SafeMath {
265     /**
266      * @dev Returns the addition of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         uint256 c = a + b;
272         if (c < a) return (false, 0);
273         return (true, c);
274     }
275 
276     /**
277      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
278      *
279      * _Available since v3.4._
280      */
281     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         if (b > a) return (false, 0);
283         return (true, a - b);
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
288      *
289      * _Available since v3.4._
290      */
291     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295         if (a == 0) return (true, 0);
296         uint256 c = a * b;
297         if (c / a != b) return (false, 0);
298         return (true, c);
299     }
300 
301     /**
302      * @dev Returns the division of two unsigned integers, with a division by zero flag.
303      *
304      * _Available since v3.4._
305      */
306     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         if (b == 0) return (false, 0);
308         return (true, a / b);
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
313      *
314      * _Available since v3.4._
315      */
316     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         if (b == 0) return (false, 0);
318         return (true, a % b);
319     }
320 
321     /**
322      * @dev Returns the addition of two unsigned integers, reverting on
323      * overflow.
324      *
325      * Counterpart to Solidity's `+` operator.
326      *
327      * Requirements:
328      *
329      * - Addition cannot overflow.
330      */
331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a + b;
333         require(c >= a, "SafeMath: addition overflow");
334         return c;
335     }
336 
337     /**
338      * @dev Returns the subtraction of two unsigned integers, reverting on
339      * overflow (when the result is negative).
340      *
341      * Counterpart to Solidity's `-` operator.
342      *
343      * Requirements:
344      *
345      * - Subtraction cannot overflow.
346      */
347     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348         require(b <= a, "SafeMath: subtraction overflow");
349         return a - b;
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, reverting on
354      * overflow.
355      *
356      * Counterpart to Solidity's `*` operator.
357      *
358      * Requirements:
359      *
360      * - Multiplication cannot overflow.
361      */
362     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363         if (a == 0) return 0;
364         uint256 c = a * b;
365         require(c / a == b, "SafeMath: multiplication overflow");
366         return c;
367     }
368 
369     /**
370      * @dev Returns the integer division of two unsigned integers, reverting on
371      * division by zero. The result is rounded towards zero.
372      *
373      * Counterpart to Solidity's `/` operator. Note: this function uses a
374      * `revert` opcode (which leaves remaining gas untouched) while Solidity
375      * uses an invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      *
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         require(b > 0, "SafeMath: division by zero");
383         return a / b;
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * reverting when dividing by zero.
389      *
390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
391      * opcode (which leaves remaining gas untouched) while Solidity uses an
392      * invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
399         require(b > 0, "SafeMath: modulo by zero");
400         return a % b;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
405      * overflow (when the result is negative).
406      *
407      * CAUTION: This function is deprecated because it requires allocating memory for the error
408      * message unnecessarily. For custom revert reasons use {trySub}.
409      *
410      * Counterpart to Solidity's `-` operator.
411      *
412      * Requirements:
413      *
414      * - Subtraction cannot overflow.
415      */
416     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
417         require(b <= a, errorMessage);
418         return a - b;
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
423      * division by zero. The result is rounded towards zero.
424      *
425      * CAUTION: This function is deprecated because it requires allocating memory for the error
426      * message unnecessarily. For custom revert reasons use {tryDiv}.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
437         require(b > 0, errorMessage);
438         return a / b;
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * reverting with custom message when dividing by zero.
444      *
445      * CAUTION: This function is deprecated because it requires allocating memory for the error
446      * message unnecessarily. For custom revert reasons use {tryMod}.
447      *
448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
449      * opcode (which leaves remaining gas untouched) while Solidity uses an
450      * invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      *
454      * - The divisor cannot be zero.
455      */
456     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
457         require(b > 0, errorMessage);
458         return a % b;
459     }
460 }
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // This method relies on extcodesize, which returns 0 for contracts in
485         // construction, since the code is only stored at the end of the
486         // constructor execution.
487 
488         uint256 size;
489         // solhint-disable-next-line no-inline-assembly
490         assembly { size := extcodesize(account) }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
514         (bool success, ) = recipient.call{ value: amount }("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain`call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537       return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
567      * with `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         require(isContract(target), "Address: call to non-contract");
574 
575         // solhint-disable-next-line avoid-low-level-calls
576         (bool success, bytes memory returndata) = target.call{ value: value }(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
597         require(isContract(target), "Address: static call to non-contract");
598 
599         // solhint-disable-next-line avoid-low-level-calls
600         (bool success, bytes memory returndata) = target.staticcall(data);
601         return _verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
606      * but performing a delegate call.
607      *
608      * _Available since v3.4._
609      */
610     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
611         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
621         require(isContract(target), "Address: delegate call to non-contract");
622 
623         // solhint-disable-next-line avoid-low-level-calls
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return _verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
629         if (success) {
630             return returndata;
631         } else {
632             // Look for revert reason and bubble it up if present
633             if (returndata.length > 0) {
634                 // The easiest way to bubble the revert reason is using memory via assembly
635 
636                 // solhint-disable-next-line no-inline-assembly
637                 assembly {
638                     let returndata_size := mload(returndata)
639                     revert(add(32, returndata), returndata_size)
640                 }
641             } else {
642                 revert(errorMessage);
643             }
644         }
645     }
646 }
647 
648 /**
649  * @dev Library for managing
650  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
651  * types.
652  *
653  * Sets have the following properties:
654  *
655  * - Elements are added, removed, and checked for existence in constant time
656  * (O(1)).
657  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
658  *
659  * ```
660  * contract Example {
661  *     // Add the library methods
662  *     using EnumerableSet for EnumerableSet.AddressSet;
663  *
664  *     // Declare a set state variable
665  *     EnumerableSet.AddressSet private mySet;
666  * }
667  * ```
668  *
669  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
670  * and `uint256` (`UintSet`) are supported.
671  */
672 library EnumerableSet {
673     // To implement this library for multiple types with as little code
674     // repetition as possible, we write it in terms of a generic Set type with
675     // bytes32 values.
676     // The Set implementation uses private functions, and user-facing
677     // implementations (such as AddressSet) are just wrappers around the
678     // underlying Set.
679     // This means that we can only create new EnumerableSets for types that fit
680     // in bytes32.
681 
682     struct Set {
683         // Storage of set values
684         bytes32[] _values;
685 
686         // Position of the value in the `values` array, plus 1 because index 0
687         // means a value is not in the set.
688         mapping (bytes32 => uint256) _indexes;
689     }
690 
691     /**
692      * @dev Add a value to a set. O(1).
693      *
694      * Returns true if the value was added to the set, that is if it was not
695      * already present.
696      */
697     function _add(Set storage set, bytes32 value) private returns (bool) {
698         if (!_contains(set, value)) {
699             set._values.push(value);
700             // The value is stored at length-1, but we add 1 to all indexes
701             // and use 0 as a sentinel value
702             set._indexes[value] = set._values.length;
703             return true;
704         } else {
705             return false;
706         }
707     }
708 
709     /**
710      * @dev Removes a value from a set. O(1).
711      *
712      * Returns true if the value was removed from the set, that is if it was
713      * present.
714      */
715     function _remove(Set storage set, bytes32 value) private returns (bool) {
716         // We read and store the value's index to prevent multiple reads from the same storage slot
717         uint256 valueIndex = set._indexes[value];
718 
719         if (valueIndex != 0) { // Equivalent to contains(set, value)
720             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
721             // the array, and then remove the last element (sometimes called as 'swap and pop').
722             // This modifies the order of the array, as noted in {at}.
723 
724             uint256 toDeleteIndex = valueIndex - 1;
725             uint256 lastIndex = set._values.length - 1;
726 
727             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
728             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
729 
730             bytes32 lastvalue = set._values[lastIndex];
731 
732             // Move the last value to the index where the value to delete is
733             set._values[toDeleteIndex] = lastvalue;
734             // Update the index for the moved value
735             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
736 
737             // Delete the slot where the moved value was stored
738             set._values.pop();
739 
740             // Delete the index for the deleted slot
741             delete set._indexes[value];
742 
743             return true;
744         } else {
745             return false;
746         }
747     }
748 
749     /**
750      * @dev Returns true if the value is in the set. O(1).
751      */
752     function _contains(Set storage set, bytes32 value) private view returns (bool) {
753         return set._indexes[value] != 0;
754     }
755 
756     /**
757      * @dev Returns the number of values on the set. O(1).
758      */
759     function _length(Set storage set) private view returns (uint256) {
760         return set._values.length;
761     }
762 
763    /**
764     * @dev Returns the value stored at position `index` in the set. O(1).
765     *
766     * Note that there are no guarantees on the ordering of values inside the
767     * array, and it may change when more values are added or removed.
768     *
769     * Requirements:
770     *
771     * - `index` must be strictly less than {length}.
772     */
773     function _at(Set storage set, uint256 index) private view returns (bytes32) {
774         require(set._values.length > index, "EnumerableSet: index out of bounds");
775         return set._values[index];
776     }
777 
778     // Bytes32Set
779 
780     struct Bytes32Set {
781         Set _inner;
782     }
783 
784     /**
785      * @dev Add a value to a set. O(1).
786      *
787      * Returns true if the value was added to the set, that is if it was not
788      * already present.
789      */
790     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
791         return _add(set._inner, value);
792     }
793 
794     /**
795      * @dev Removes a value from a set. O(1).
796      *
797      * Returns true if the value was removed from the set, that is if it was
798      * present.
799      */
800     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
801         return _remove(set._inner, value);
802     }
803 
804     /**
805      * @dev Returns true if the value is in the set. O(1).
806      */
807     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
808         return _contains(set._inner, value);
809     }
810 
811     /**
812      * @dev Returns the number of values in the set. O(1).
813      */
814     function length(Bytes32Set storage set) internal view returns (uint256) {
815         return _length(set._inner);
816     }
817 
818    /**
819     * @dev Returns the value stored at position `index` in the set. O(1).
820     *
821     * Note that there are no guarantees on the ordering of values inside the
822     * array, and it may change when more values are added or removed.
823     *
824     * Requirements:
825     *
826     * - `index` must be strictly less than {length}.
827     */
828     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
829         return _at(set._inner, index);
830     }
831 
832     // AddressSet
833 
834     struct AddressSet {
835         Set _inner;
836     }
837 
838     /**
839      * @dev Add a value to a set. O(1).
840      *
841      * Returns true if the value was added to the set, that is if it was not
842      * already present.
843      */
844     function add(AddressSet storage set, address value) internal returns (bool) {
845         return _add(set._inner, bytes32(uint256(uint160(value))));
846     }
847 
848     /**
849      * @dev Removes a value from a set. O(1).
850      *
851      * Returns true if the value was removed from the set, that is if it was
852      * present.
853      */
854     function remove(AddressSet storage set, address value) internal returns (bool) {
855         return _remove(set._inner, bytes32(uint256(uint160(value))));
856     }
857 
858     /**
859      * @dev Returns true if the value is in the set. O(1).
860      */
861     function contains(AddressSet storage set, address value) internal view returns (bool) {
862         return _contains(set._inner, bytes32(uint256(uint160(value))));
863     }
864 
865     /**
866      * @dev Returns the number of values in the set. O(1).
867      */
868     function length(AddressSet storage set) internal view returns (uint256) {
869         return _length(set._inner);
870     }
871 
872    /**
873     * @dev Returns the value stored at position `index` in the set. O(1).
874     *
875     * Note that there are no guarantees on the ordering of values inside the
876     * array, and it may change when more values are added or removed.
877     *
878     * Requirements:
879     *
880     * - `index` must be strictly less than {length}.
881     */
882     function at(AddressSet storage set, uint256 index) internal view returns (address) {
883         return address(uint160(uint256(_at(set._inner, index))));
884     }
885 
886 
887     // UintSet
888 
889     struct UintSet {
890         Set _inner;
891     }
892 
893     /**
894      * @dev Add a value to a set. O(1).
895      *
896      * Returns true if the value was added to the set, that is if it was not
897      * already present.
898      */
899     function add(UintSet storage set, uint256 value) internal returns (bool) {
900         return _add(set._inner, bytes32(value));
901     }
902 
903     /**
904      * @dev Removes a value from a set. O(1).
905      *
906      * Returns true if the value was removed from the set, that is if it was
907      * present.
908      */
909     function remove(UintSet storage set, uint256 value) internal returns (bool) {
910         return _remove(set._inner, bytes32(value));
911     }
912 
913     /**
914      * @dev Returns true if the value is in the set. O(1).
915      */
916     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
917         return _contains(set._inner, bytes32(value));
918     }
919 
920     /**
921      * @dev Returns the number of values on the set. O(1).
922      */
923     function length(UintSet storage set) internal view returns (uint256) {
924         return _length(set._inner);
925     }
926 
927    /**
928     * @dev Returns the value stored at position `index` in the set. O(1).
929     *
930     * Note that there are no guarantees on the ordering of values inside the
931     * array, and it may change when more values are added or removed.
932     *
933     * Requirements:
934     *
935     * - `index` must be strictly less than {length}.
936     */
937     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
938         return uint256(_at(set._inner, index));
939     }
940 }
941 
942 /**
943  * @dev Library for managing an enumerable variant of Solidity's
944  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
945  * type.
946  *
947  * Maps have the following properties:
948  *
949  * - Entries are added, removed, and checked for existence in constant time
950  * (O(1)).
951  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
952  *
953  * ```
954  * contract Example {
955  *     // Add the library methods
956  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
957  *
958  *     // Declare a set state variable
959  *     EnumerableMap.UintToAddressMap private myMap;
960  * }
961  * ```
962  *
963  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
964  * supported.
965  */
966 library EnumerableMap {
967     // To implement this library for multiple types with as little code
968     // repetition as possible, we write it in terms of a generic Map type with
969     // bytes32 keys and values.
970     // The Map implementation uses private functions, and user-facing
971     // implementations (such as Uint256ToAddressMap) are just wrappers around
972     // the underlying Map.
973     // This means that we can only create new EnumerableMaps for types that fit
974     // in bytes32.
975 
976     struct MapEntry {
977         bytes32 _key;
978         bytes32 _value;
979     }
980 
981     struct Map {
982         // Storage of map keys and values
983         MapEntry[] _entries;
984 
985         // Position of the entry defined by a key in the `entries` array, plus 1
986         // because index 0 means a key is not in the map.
987         mapping (bytes32 => uint256) _indexes;
988     }
989 
990     /**
991      * @dev Adds a key-value pair to a map, or updates the value for an existing
992      * key. O(1).
993      *
994      * Returns true if the key was added to the map, that is if it was not
995      * already present.
996      */
997     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
998         // We read and store the key's index to prevent multiple reads from the same storage slot
999         uint256 keyIndex = map._indexes[key];
1000 
1001         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1002             map._entries.push(MapEntry({ _key: key, _value: value }));
1003             // The entry is stored at length-1, but we add 1 to all indexes
1004             // and use 0 as a sentinel value
1005             map._indexes[key] = map._entries.length;
1006             return true;
1007         } else {
1008             map._entries[keyIndex - 1]._value = value;
1009             return false;
1010         }
1011     }
1012 
1013     /**
1014      * @dev Removes a key-value pair from a map. O(1).
1015      *
1016      * Returns true if the key was removed from the map, that is if it was present.
1017      */
1018     function _remove(Map storage map, bytes32 key) private returns (bool) {
1019         // We read and store the key's index to prevent multiple reads from the same storage slot
1020         uint256 keyIndex = map._indexes[key];
1021 
1022         if (keyIndex != 0) { // Equivalent to contains(map, key)
1023             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1024             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1025             // This modifies the order of the array, as noted in {at}.
1026 
1027             uint256 toDeleteIndex = keyIndex - 1;
1028             uint256 lastIndex = map._entries.length - 1;
1029 
1030             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1031             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1032 
1033             MapEntry storage lastEntry = map._entries[lastIndex];
1034 
1035             // Move the last entry to the index where the entry to delete is
1036             map._entries[toDeleteIndex] = lastEntry;
1037             // Update the index for the moved entry
1038             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1039 
1040             // Delete the slot where the moved entry was stored
1041             map._entries.pop();
1042 
1043             // Delete the index for the deleted slot
1044             delete map._indexes[key];
1045 
1046             return true;
1047         } else {
1048             return false;
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns true if the key is in the map. O(1).
1054      */
1055     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1056         return map._indexes[key] != 0;
1057     }
1058 
1059     /**
1060      * @dev Returns the number of key-value pairs in the map. O(1).
1061      */
1062     function _length(Map storage map) private view returns (uint256) {
1063         return map._entries.length;
1064     }
1065 
1066    /**
1067     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1068     *
1069     * Note that there are no guarantees on the ordering of entries inside the
1070     * array, and it may change when more entries are added or removed.
1071     *
1072     * Requirements:
1073     *
1074     * - `index` must be strictly less than {length}.
1075     */
1076     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1077         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1078 
1079         MapEntry storage entry = map._entries[index];
1080         return (entry._key, entry._value);
1081     }
1082 
1083     /**
1084      * @dev Tries to returns the value associated with `key`.  O(1).
1085      * Does not revert if `key` is not in the map.
1086      */
1087     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1088         uint256 keyIndex = map._indexes[key];
1089         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1090         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1091     }
1092 
1093     /**
1094      * @dev Returns the value associated with `key`.  O(1).
1095      *
1096      * Requirements:
1097      *
1098      * - `key` must be in the map.
1099      */
1100     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1101         uint256 keyIndex = map._indexes[key];
1102         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1103         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1104     }
1105 
1106     /**
1107      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1108      *
1109      * CAUTION: This function is deprecated because it requires allocating memory for the error
1110      * message unnecessarily. For custom revert reasons use {_tryGet}.
1111      */
1112     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1113         uint256 keyIndex = map._indexes[key];
1114         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1115         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1116     }
1117 
1118     // UintToAddressMap
1119 
1120     struct UintToAddressMap {
1121         Map _inner;
1122     }
1123 
1124     /**
1125      * @dev Adds a key-value pair to a map, or updates the value for an existing
1126      * key. O(1).
1127      *
1128      * Returns true if the key was added to the map, that is if it was not
1129      * already present.
1130      */
1131     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1132         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1133     }
1134 
1135     /**
1136      * @dev Removes a value from a set. O(1).
1137      *
1138      * Returns true if the key was removed from the map, that is if it was present.
1139      */
1140     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1141         return _remove(map._inner, bytes32(key));
1142     }
1143 
1144     /**
1145      * @dev Returns true if the key is in the map. O(1).
1146      */
1147     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1148         return _contains(map._inner, bytes32(key));
1149     }
1150 
1151     /**
1152      * @dev Returns the number of elements in the map. O(1).
1153      */
1154     function length(UintToAddressMap storage map) internal view returns (uint256) {
1155         return _length(map._inner);
1156     }
1157 
1158    /**
1159     * @dev Returns the element stored at position `index` in the set. O(1).
1160     * Note that there are no guarantees on the ordering of values inside the
1161     * array, and it may change when more values are added or removed.
1162     *
1163     * Requirements:
1164     *
1165     * - `index` must be strictly less than {length}.
1166     */
1167     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1168         (bytes32 key, bytes32 value) = _at(map._inner, index);
1169         return (uint256(key), address(uint160(uint256(value))));
1170     }
1171 
1172     /**
1173      * @dev Tries to returns the value associated with `key`.  O(1).
1174      * Does not revert if `key` is not in the map.
1175      *
1176      * _Available since v3.4._
1177      */
1178     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1179         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1180         return (success, address(uint160(uint256(value))));
1181     }
1182 
1183     /**
1184      * @dev Returns the value associated with `key`.  O(1).
1185      *
1186      * Requirements:
1187      *
1188      * - `key` must be in the map.
1189      */
1190     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1191         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1192     }
1193 
1194     /**
1195      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1196      *
1197      * CAUTION: This function is deprecated because it requires allocating memory for the error
1198      * message unnecessarily. For custom revert reasons use {tryGet}.
1199      */
1200     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1201         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1202     }
1203 }
1204 
1205 /**
1206  * @dev String operations.
1207  */
1208 library Strings {
1209     /**
1210      * @dev Converts a `uint256` to its ASCII `string` representation.
1211      */
1212     function toString(uint256 value) internal pure returns (string memory) {
1213         // Inspired by OraclizeAPI's implementation - MIT licence
1214         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1215 
1216         if (value == 0) {
1217             return "0";
1218         }
1219         uint256 temp = value;
1220         uint256 digits;
1221         while (temp != 0) {
1222             digits++;
1223             temp /= 10;
1224         }
1225         bytes memory buffer = new bytes(digits);
1226         uint256 index = digits - 1;
1227         temp = value;
1228         while (temp != 0) {
1229             buffer[index--] = bytes1(uint8(48 + temp % 10));
1230             temp /= 10;
1231         }
1232         return string(buffer);
1233     }
1234 }
1235 
1236 /**
1237  * @title ERC721 Non-Fungible Token Standard basic implementation
1238  * @dev see https://eips.ethereum.org/EIPS/eip-721
1239  */
1240 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1241     using SafeMath for uint256;
1242     using Address for address;
1243     using EnumerableSet for EnumerableSet.UintSet;
1244     using EnumerableMap for EnumerableMap.UintToAddressMap;
1245     using Strings for uint256;
1246 
1247     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1248     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1249     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1250 
1251     // Mapping from holder address to their (enumerable) set of owned tokens
1252     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1253 
1254     // Enumerable mapping from token ids to their owners
1255     EnumerableMap.UintToAddressMap private _tokenOwners;
1256 
1257     // Mapping from token ID to approved address
1258     mapping (uint256 => address) private _tokenApprovals;
1259 
1260     // Mapping from owner to operator approvals
1261     mapping (address => mapping (address => bool)) private _operatorApprovals;
1262 
1263     // Token name
1264     string private _name;
1265 
1266     // Token symbol
1267     string private _symbol;
1268 
1269     // Optional mapping for token URIs
1270     mapping (uint256 => string) private _tokenURIs;
1271 
1272     // Base URI
1273     string private _baseURI;
1274 
1275     /*
1276      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1277      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1278      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1279      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1280      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1281      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1282      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1283      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1284      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1285      *
1286      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1287      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1288      */
1289     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1290 
1291     /*
1292      *     bytes4(keccak256('name()')) == 0x06fdde03
1293      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1294      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1295      *
1296      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1297      */
1298     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1299 
1300     /*
1301      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1302      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1303      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1304      *
1305      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1306      */
1307     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1308 
1309     /**
1310      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1311      */
1312     constructor (string memory name_, string memory symbol_) public {
1313         _name = name_;
1314         _symbol = symbol_;
1315 
1316         // register the supported interfaces to conform to ERC721 via ERC165
1317         _registerInterface(_INTERFACE_ID_ERC721);
1318         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1319         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-balanceOf}.
1324      */
1325     function balanceOf(address owner) public view virtual override returns (uint256) {
1326         require(owner != address(0), "ERC721: balance query for the zero address");
1327         return _holderTokens[owner].length();
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-ownerOf}.
1332      */
1333     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1334         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1335     }
1336 
1337     /**
1338      * @dev See {IERC721Metadata-name}.
1339      */
1340     function name() public view virtual override returns (string memory) {
1341         return _name;
1342     }
1343 
1344     /**
1345      * @dev See {IERC721Metadata-symbol}.
1346      */
1347     function symbol() public view virtual override returns (string memory) {
1348         return _symbol;
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Metadata-tokenURI}.
1353      */
1354     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1355         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1356 
1357         string memory _tokenURI = _tokenURIs[tokenId];
1358         string memory base = baseURI();
1359 
1360         // If there is no base URI, return the token URI.
1361         if (bytes(base).length == 0) {
1362             return _tokenURI;
1363         }
1364         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1365         if (bytes(_tokenURI).length > 0) {
1366             return string(abi.encodePacked(base, _tokenURI));
1367         }
1368         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1369         return string(abi.encodePacked(base, tokenId.toString()));
1370     }
1371 
1372     /**
1373     * @dev Returns the base URI set via {_setBaseURI}. This will be
1374     * automatically added as a prefix in {tokenURI} to each token's URI, or
1375     * to the token ID if no specific URI is set for that token ID.
1376     */
1377     function baseURI() public view virtual returns (string memory) {
1378         return _baseURI;
1379     }
1380 
1381     /**
1382      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1383      */
1384     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1385         return _holderTokens[owner].at(index);
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Enumerable-totalSupply}.
1390      */
1391     function totalSupply() public view virtual override returns (uint256) {
1392         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1393         return _tokenOwners.length();
1394     }
1395 
1396     /**
1397      * @dev See {IERC721Enumerable-tokenByIndex}.
1398      */
1399     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1400         (uint256 tokenId, ) = _tokenOwners.at(index);
1401         return tokenId;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-approve}.
1406      */
1407     function approve(address to, uint256 tokenId) public virtual override {
1408         address owner = ERC721.ownerOf(tokenId);
1409         require(to != owner, "ERC721: approval to current owner");
1410 
1411         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1412             "ERC721: approve caller is not owner nor approved for all"
1413         );
1414 
1415         _approve(to, tokenId);
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-getApproved}.
1420      */
1421     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1422         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1423 
1424         return _tokenApprovals[tokenId];
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-setApprovalForAll}.
1429      */
1430     function setApprovalForAll(address operator, bool approved) public virtual override {
1431         require(operator != _msgSender(), "ERC721: approve to caller");
1432 
1433         _operatorApprovals[_msgSender()][operator] = approved;
1434         emit ApprovalForAll(_msgSender(), operator, approved);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-isApprovedForAll}.
1439      */
1440     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1441         return _operatorApprovals[owner][operator];
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-transferFrom}.
1446      */
1447     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1448         //solhint-disable-next-line max-line-length
1449         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1450 
1451         _transfer(from, to, tokenId);
1452     }
1453 
1454     /**
1455      * @dev See {IERC721-safeTransferFrom}.
1456      */
1457     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1458         safeTransferFrom(from, to, tokenId, "");
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-safeTransferFrom}.
1463      */
1464     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1465         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1466         _safeTransfer(from, to, tokenId, _data);
1467     }
1468 
1469     /**
1470      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1471      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1472      *
1473      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1474      *
1475      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1476      * implement alternative mechanisms to perform token transfer, such as signature-based.
1477      *
1478      * Requirements:
1479      *
1480      * - `from` cannot be the zero address.
1481      * - `to` cannot be the zero address.
1482      * - `tokenId` token must exist and be owned by `from`.
1483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1488         _transfer(from, to, tokenId);
1489         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1490     }
1491 
1492     /**
1493      * @dev Returns whether `tokenId` exists.
1494      *
1495      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1496      *
1497      * Tokens start existing when they are minted (`_mint`),
1498      * and stop existing when they are burned (`_burn`).
1499      */
1500     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1501         return _tokenOwners.contains(tokenId);
1502     }
1503 
1504     /**
1505      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1506      *
1507      * Requirements:
1508      *
1509      * - `tokenId` must exist.
1510      */
1511     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1512         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1513         address owner = ERC721.ownerOf(tokenId);
1514         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1515     }
1516 
1517     /**
1518      * @dev Safely mints `tokenId` and transfers it to `to`.
1519      *
1520      * Requirements:
1521      d*
1522      * - `tokenId` must not exist.
1523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1524      *
1525      * Emits a {Transfer} event.
1526      */
1527     function _safeMint(address to, uint256 tokenId) internal virtual {
1528         _safeMint(to, tokenId, "");
1529     }
1530 
1531     /**
1532      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1533      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1534      */
1535     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1536         _mint(to, tokenId);
1537         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1538     }
1539 
1540     /**
1541      * @dev Mints `tokenId` and transfers it to `to`.
1542      *
1543      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1544      *
1545      * Requirements:
1546      *
1547      * - `tokenId` must not exist.
1548      * - `to` cannot be the zero address.
1549      *
1550      * Emits a {Transfer} event.
1551      */
1552     function _mint(address to, uint256 tokenId) internal virtual {
1553         require(to != address(0), "ERC721: mint to the zero address");
1554         require(!_exists(tokenId), "ERC721: token already minted");
1555 
1556         _beforeTokenTransfer(address(0), to, tokenId);
1557 
1558         _holderTokens[to].add(tokenId);
1559 
1560         _tokenOwners.set(tokenId, to);
1561 
1562         emit Transfer(address(0), to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev Destroys `tokenId`.
1567      * The approval is cleared when the token is burned.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function _burn(uint256 tokenId) internal virtual {
1576         address owner = ERC721.ownerOf(tokenId); // internal owner
1577 
1578         _beforeTokenTransfer(owner, address(0), tokenId);
1579 
1580         // Clear approvals
1581         _approve(address(0), tokenId);
1582 
1583         // Clear metadata (if any)
1584         if (bytes(_tokenURIs[tokenId]).length != 0) {
1585             delete _tokenURIs[tokenId];
1586         }
1587 
1588         _holderTokens[owner].remove(tokenId);
1589 
1590         _tokenOwners.remove(tokenId);
1591 
1592         emit Transfer(owner, address(0), tokenId);
1593     }
1594 
1595     /**
1596      * @dev Transfers `tokenId` from `from` to `to`.
1597      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1598      *
1599      * Requirements:
1600      *
1601      * - `to` cannot be the zero address.
1602      * - `tokenId` token must be owned by `from`.
1603      *
1604      * Emits a {Transfer} event.
1605      */
1606     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1607         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1608         require(to != address(0), "ERC721: transfer to the zero address");
1609 
1610         _beforeTokenTransfer(from, to, tokenId);
1611 
1612         // Clear approvals from the previous owner
1613         _approve(address(0), tokenId);
1614 
1615         _holderTokens[from].remove(tokenId);
1616         _holderTokens[to].add(tokenId);
1617 
1618         _tokenOwners.set(tokenId, to);
1619 
1620         emit Transfer(from, to, tokenId);
1621     }
1622 
1623     /**
1624      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      */
1630     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1631         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1632         _tokenURIs[tokenId] = _tokenURI;
1633     }
1634 
1635     /**
1636      * @dev Internal function to set the base URI for all token IDs. It is
1637      * automatically added as a prefix to the value returned in {tokenURI},
1638      * or to the token ID if {tokenURI} is empty.
1639      */
1640     function _setBaseURI(string memory baseURI_) internal virtual {
1641         _baseURI = baseURI_;
1642     }
1643 
1644     /**
1645      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1646      * The call is not executed if the target address is not a contract.
1647      *
1648      * @param from address representing the previous owner of the given token ID
1649      * @param to target address that will receive the tokens
1650      * @param tokenId uint256 ID of the token to be transferred
1651      * @param _data bytes optional data to send along with the call
1652      * @return bool whether the call correctly returned the expected magic value
1653      */
1654     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1655         private returns (bool)
1656     {
1657         if (!to.isContract()) {
1658             return true;
1659         }
1660         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1661             IERC721Receiver(to).onERC721Received.selector,
1662             _msgSender(),
1663             from,
1664             tokenId,
1665             _data
1666         ), "ERC721: transfer to non ERC721Receiver implementer");
1667         bytes4 retval = abi.decode(returndata, (bytes4));
1668         return (retval == _ERC721_RECEIVED);
1669     }
1670 
1671     /**
1672      * @dev Approve `to` to operate on `tokenId`
1673      *
1674      * Emits an {Approval} event.
1675      */
1676     function _approve(address to, uint256 tokenId) internal virtual {
1677         _tokenApprovals[tokenId] = to;
1678         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1679     }
1680 
1681     /**
1682      * @dev Hook that is called before any token transfer. This includes minting
1683      * and burning.
1684      *
1685      * Calling conditions:
1686      *
1687      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1688      * transferred to `to`.
1689      * - When `from` is zero, `tokenId` will be minted for `to`.
1690      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1691      * - `from` cannot be the zero address.
1692      * - `to` cannot be the zero address.
1693      *
1694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1695      */
1696     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1697 }
1698 
1699 /**
1700  * @title Counters
1701  * @author Matt Condon (@shrugs)
1702  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1703  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1704  *
1705  * Include with `using Counters for Counters.Counter;`
1706  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1707  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1708  * directly accessed.
1709  */
1710 library Counters {
1711     using SafeMath for uint256;
1712 
1713     struct Counter {
1714         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1715         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1716         // this feature: see https://github.com/ethereum/solidity/issues/4637
1717         uint256 _value; // default: 0
1718     }
1719 
1720     function current(Counter storage counter) internal view returns (uint256) {
1721         return counter._value;
1722     }
1723 
1724     function increment(Counter storage counter) internal {
1725         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1726         counter._value += 1;
1727     }
1728 
1729     function decrement(Counter storage counter) internal {
1730         counter._value = counter._value.sub(1);
1731     }
1732 }
1733 
1734 /**
1735  * @dev Contract module which provides a basic access control mechanism, where
1736  * there is an account (an owner) that can be granted exclusive access to
1737  * specific functions.
1738  *
1739  * By default, the owner account will be the one that deploys the contract. This
1740  * can later be changed with {transferOwnership}.
1741  *
1742  * This module is used through inheritance. It will make available the modifier
1743  * `onlyOwner`, which can be applied to your functions to restrict their use to
1744  * the owner.
1745  */
1746 abstract contract Ownable is Context {
1747     address private _owner;
1748 
1749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1750 
1751     /**
1752      * @dev Initializes the contract setting the deployer as the initial owner.
1753      */
1754     constructor () internal {
1755         address msgSender = _msgSender();
1756         _owner = msgSender;
1757         emit OwnershipTransferred(address(0), msgSender);
1758     }
1759 
1760     /**
1761      * @dev Returns the address of the current owner.
1762      */
1763     function owner() public view virtual returns (address) {
1764         return _owner;
1765     }
1766 
1767     /**
1768      * @dev Throws if called by any account other than the owner.
1769      */
1770     modifier onlyOwner() {
1771         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1772         _;
1773     }
1774 
1775     /**
1776      * @dev Leaves the contract without owner. It will not be possible to call
1777      * `onlyOwner` functions anymore. Can only be called by the current owner.
1778      *
1779      * NOTE: Renouncing ownership will leave the contract without an owner,
1780      * thereby removing any functionality that is only available to the owner.
1781      */
1782     function renounceOwnership() public virtual onlyOwner {
1783         emit OwnershipTransferred(_owner, address(0));
1784         _owner = address(0);
1785     }
1786 
1787     /**
1788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1789      * Can only be called by the current owner.
1790      */
1791     function transferOwnership(address newOwner) public virtual onlyOwner {
1792         require(newOwner != address(0), "Ownable: new owner is the zero address");
1793         emit OwnershipTransferred(_owner, newOwner);
1794         _owner = newOwner;
1795     }
1796 }
1797 
1798 library console {
1799 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1800 
1801 	function _sendLogPayload(bytes memory payload) private view {
1802 		uint256 payloadLength = payload.length;
1803 		address consoleAddress = CONSOLE_ADDRESS;
1804 		assembly {
1805 			let payloadStart := add(payload, 32)
1806 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1807 		}
1808 	}
1809 
1810 	function log() internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log()"));
1812 	}
1813 
1814 	function logInt(int p0) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1816 	}
1817 
1818 	function logUint(uint p0) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1820 	}
1821 
1822 	function logString(string memory p0) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1824 	}
1825 
1826 	function logBool(bool p0) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1828 	}
1829 
1830 	function logAddress(address p0) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1832 	}
1833 
1834 	function logBytes(bytes memory p0) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1836 	}
1837 
1838 	function logByte(byte p0) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
1840 	}
1841 
1842 	function logBytes1(bytes1 p0) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1844 	}
1845 
1846 	function logBytes2(bytes2 p0) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1848 	}
1849 
1850 	function logBytes3(bytes3 p0) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1852 	}
1853 
1854 	function logBytes4(bytes4 p0) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1856 	}
1857 
1858 	function logBytes5(bytes5 p0) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1860 	}
1861 
1862 	function logBytes6(bytes6 p0) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1864 	}
1865 
1866 	function logBytes7(bytes7 p0) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1868 	}
1869 
1870 	function logBytes8(bytes8 p0) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1872 	}
1873 
1874 	function logBytes9(bytes9 p0) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1876 	}
1877 
1878 	function logBytes10(bytes10 p0) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1880 	}
1881 
1882 	function logBytes11(bytes11 p0) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1884 	}
1885 
1886 	function logBytes12(bytes12 p0) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1888 	}
1889 
1890 	function logBytes13(bytes13 p0) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1892 	}
1893 
1894 	function logBytes14(bytes14 p0) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1896 	}
1897 
1898 	function logBytes15(bytes15 p0) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1900 	}
1901 
1902 	function logBytes16(bytes16 p0) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1904 	}
1905 
1906 	function logBytes17(bytes17 p0) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1908 	}
1909 
1910 	function logBytes18(bytes18 p0) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1912 	}
1913 
1914 	function logBytes19(bytes19 p0) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1916 	}
1917 
1918 	function logBytes20(bytes20 p0) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1920 	}
1921 
1922 	function logBytes21(bytes21 p0) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1924 	}
1925 
1926 	function logBytes22(bytes22 p0) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1928 	}
1929 
1930 	function logBytes23(bytes23 p0) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1932 	}
1933 
1934 	function logBytes24(bytes24 p0) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1936 	}
1937 
1938 	function logBytes25(bytes25 p0) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1940 	}
1941 
1942 	function logBytes26(bytes26 p0) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1944 	}
1945 
1946 	function logBytes27(bytes27 p0) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1948 	}
1949 
1950 	function logBytes28(bytes28 p0) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1952 	}
1953 
1954 	function logBytes29(bytes29 p0) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1956 	}
1957 
1958 	function logBytes30(bytes30 p0) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1960 	}
1961 
1962 	function logBytes31(bytes31 p0) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1964 	}
1965 
1966 	function logBytes32(bytes32 p0) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1968 	}
1969 
1970 	function log(uint p0) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1972 	}
1973 
1974 	function log(string memory p0) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1976 	}
1977 
1978 	function log(bool p0) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1980 	}
1981 
1982 	function log(address p0) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1984 	}
1985 
1986 	function log(uint p0, uint p1) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1988 	}
1989 
1990 	function log(uint p0, string memory p1) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1992 	}
1993 
1994 	function log(uint p0, bool p1) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1996 	}
1997 
1998 	function log(uint p0, address p1) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
2000 	}
2001 
2002 	function log(string memory p0, uint p1) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
2004 	}
2005 
2006 	function log(string memory p0, string memory p1) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2008 	}
2009 
2010 	function log(string memory p0, bool p1) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2012 	}
2013 
2014 	function log(string memory p0, address p1) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2016 	}
2017 
2018 	function log(bool p0, uint p1) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
2020 	}
2021 
2022 	function log(bool p0, string memory p1) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2024 	}
2025 
2026 	function log(bool p0, bool p1) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2028 	}
2029 
2030 	function log(bool p0, address p1) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2032 	}
2033 
2034 	function log(address p0, uint p1) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
2036 	}
2037 
2038 	function log(address p0, string memory p1) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2040 	}
2041 
2042 	function log(address p0, bool p1) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2044 	}
2045 
2046 	function log(address p0, address p1) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2048 	}
2049 
2050 	function log(uint p0, uint p1, uint p2) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
2052 	}
2053 
2054 	function log(uint p0, uint p1, string memory p2) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
2056 	}
2057 
2058 	function log(uint p0, uint p1, bool p2) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
2060 	}
2061 
2062 	function log(uint p0, uint p1, address p2) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
2064 	}
2065 
2066 	function log(uint p0, string memory p1, uint p2) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
2068 	}
2069 
2070 	function log(uint p0, string memory p1, string memory p2) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
2072 	}
2073 
2074 	function log(uint p0, string memory p1, bool p2) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
2076 	}
2077 
2078 	function log(uint p0, string memory p1, address p2) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
2080 	}
2081 
2082 	function log(uint p0, bool p1, uint p2) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
2084 	}
2085 
2086 	function log(uint p0, bool p1, string memory p2) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
2088 	}
2089 
2090 	function log(uint p0, bool p1, bool p2) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
2092 	}
2093 
2094 	function log(uint p0, bool p1, address p2) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
2096 	}
2097 
2098 	function log(uint p0, address p1, uint p2) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
2100 	}
2101 
2102 	function log(uint p0, address p1, string memory p2) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
2104 	}
2105 
2106 	function log(uint p0, address p1, bool p2) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
2108 	}
2109 
2110 	function log(uint p0, address p1, address p2) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
2112 	}
2113 
2114 	function log(string memory p0, uint p1, uint p2) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
2116 	}
2117 
2118 	function log(string memory p0, uint p1, string memory p2) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
2120 	}
2121 
2122 	function log(string memory p0, uint p1, bool p2) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
2124 	}
2125 
2126 	function log(string memory p0, uint p1, address p2) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
2128 	}
2129 
2130 	function log(string memory p0, string memory p1, uint p2) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
2132 	}
2133 
2134 	function log(string memory p0, string memory p1, string memory p2) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2136 	}
2137 
2138 	function log(string memory p0, string memory p1, bool p2) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2140 	}
2141 
2142 	function log(string memory p0, string memory p1, address p2) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2144 	}
2145 
2146 	function log(string memory p0, bool p1, uint p2) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
2148 	}
2149 
2150 	function log(string memory p0, bool p1, string memory p2) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2152 	}
2153 
2154 	function log(string memory p0, bool p1, bool p2) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2156 	}
2157 
2158 	function log(string memory p0, bool p1, address p2) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2160 	}
2161 
2162 	function log(string memory p0, address p1, uint p2) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
2164 	}
2165 
2166 	function log(string memory p0, address p1, string memory p2) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2168 	}
2169 
2170 	function log(string memory p0, address p1, bool p2) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2172 	}
2173 
2174 	function log(string memory p0, address p1, address p2) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2176 	}
2177 
2178 	function log(bool p0, uint p1, uint p2) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
2180 	}
2181 
2182 	function log(bool p0, uint p1, string memory p2) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
2184 	}
2185 
2186 	function log(bool p0, uint p1, bool p2) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2188 	}
2189 
2190 	function log(bool p0, uint p1, address p2) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2192 	}
2193 
2194 	function log(bool p0, string memory p1, uint p2) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2196 	}
2197 
2198 	function log(bool p0, string memory p1, string memory p2) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2200 	}
2201 
2202 	function log(bool p0, string memory p1, bool p2) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2204 	}
2205 
2206 	function log(bool p0, string memory p1, address p2) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2208 	}
2209 
2210 	function log(bool p0, bool p1, uint p2) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2212 	}
2213 
2214 	function log(bool p0, bool p1, string memory p2) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2216 	}
2217 
2218 	function log(bool p0, bool p1, bool p2) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2220 	}
2221 
2222 	function log(bool p0, bool p1, address p2) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2224 	}
2225 
2226 	function log(bool p0, address p1, uint p2) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2228 	}
2229 
2230 	function log(bool p0, address p1, string memory p2) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2232 	}
2233 
2234 	function log(bool p0, address p1, bool p2) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2236 	}
2237 
2238 	function log(bool p0, address p1, address p2) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2240 	}
2241 
2242 	function log(address p0, uint p1, uint p2) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2244 	}
2245 
2246 	function log(address p0, uint p1, string memory p2) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2248 	}
2249 
2250 	function log(address p0, uint p1, bool p2) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2252 	}
2253 
2254 	function log(address p0, uint p1, address p2) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2256 	}
2257 
2258 	function log(address p0, string memory p1, uint p2) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2260 	}
2261 
2262 	function log(address p0, string memory p1, string memory p2) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2264 	}
2265 
2266 	function log(address p0, string memory p1, bool p2) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2268 	}
2269 
2270 	function log(address p0, string memory p1, address p2) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2272 	}
2273 
2274 	function log(address p0, bool p1, uint p2) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2276 	}
2277 
2278 	function log(address p0, bool p1, string memory p2) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2280 	}
2281 
2282 	function log(address p0, bool p1, bool p2) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2284 	}
2285 
2286 	function log(address p0, bool p1, address p2) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2288 	}
2289 
2290 	function log(address p0, address p1, uint p2) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2292 	}
2293 
2294 	function log(address p0, address p1, string memory p2) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2296 	}
2297 
2298 	function log(address p0, address p1, bool p2) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2300 	}
2301 
2302 	function log(address p0, address p1, address p2) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2304 	}
2305 
2306 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2308 	}
2309 
2310 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2312 	}
2313 
2314 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2316 	}
2317 
2318 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2320 	}
2321 
2322 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2324 	}
2325 
2326 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2328 	}
2329 
2330 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2332 	}
2333 
2334 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2336 	}
2337 
2338 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2340 	}
2341 
2342 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2344 	}
2345 
2346 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2348 	}
2349 
2350 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2352 	}
2353 
2354 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2356 	}
2357 
2358 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2359 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2360 	}
2361 
2362 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2363 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2364 	}
2365 
2366 	function log(uint p0, uint p1, address p2, address p3) internal view {
2367 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2368 	}
2369 
2370 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2371 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2372 	}
2373 
2374 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2375 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2376 	}
2377 
2378 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2379 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2380 	}
2381 
2382 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2383 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2384 	}
2385 
2386 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2387 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2388 	}
2389 
2390 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2391 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2392 	}
2393 
2394 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2395 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2396 	}
2397 
2398 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2399 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2400 	}
2401 
2402 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2403 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2404 	}
2405 
2406 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2407 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2408 	}
2409 
2410 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2411 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2412 	}
2413 
2414 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2415 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2416 	}
2417 
2418 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2419 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2420 	}
2421 
2422 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2423 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2424 	}
2425 
2426 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2427 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2428 	}
2429 
2430 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2431 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2432 	}
2433 
2434 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2435 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2436 	}
2437 
2438 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2439 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2440 	}
2441 
2442 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2443 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2444 	}
2445 
2446 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2447 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2448 	}
2449 
2450 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2451 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2452 	}
2453 
2454 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2455 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2456 	}
2457 
2458 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2459 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2460 	}
2461 
2462 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2463 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2464 	}
2465 
2466 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2467 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2468 	}
2469 
2470 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2471 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2472 	}
2473 
2474 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2475 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2476 	}
2477 
2478 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2479 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2480 	}
2481 
2482 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2483 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2484 	}
2485 
2486 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2487 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2488 	}
2489 
2490 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2491 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2492 	}
2493 
2494 	function log(uint p0, bool p1, address p2, address p3) internal view {
2495 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2496 	}
2497 
2498 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2499 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2500 	}
2501 
2502 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2503 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2504 	}
2505 
2506 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2507 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2508 	}
2509 
2510 	function log(uint p0, address p1, uint p2, address p3) internal view {
2511 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2512 	}
2513 
2514 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2515 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2516 	}
2517 
2518 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2519 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2520 	}
2521 
2522 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2523 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2524 	}
2525 
2526 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2527 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2528 	}
2529 
2530 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2531 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2532 	}
2533 
2534 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2535 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2536 	}
2537 
2538 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2539 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2540 	}
2541 
2542 	function log(uint p0, address p1, bool p2, address p3) internal view {
2543 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2544 	}
2545 
2546 	function log(uint p0, address p1, address p2, uint p3) internal view {
2547 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2548 	}
2549 
2550 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2551 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2552 	}
2553 
2554 	function log(uint p0, address p1, address p2, bool p3) internal view {
2555 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2556 	}
2557 
2558 	function log(uint p0, address p1, address p2, address p3) internal view {
2559 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2560 	}
2561 
2562 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2563 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2564 	}
2565 
2566 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2567 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2568 	}
2569 
2570 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2571 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2572 	}
2573 
2574 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2575 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2576 	}
2577 
2578 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2579 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2580 	}
2581 
2582 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2583 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2584 	}
2585 
2586 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2587 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2588 	}
2589 
2590 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2591 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2592 	}
2593 
2594 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2595 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2596 	}
2597 
2598 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2599 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2600 	}
2601 
2602 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2603 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2604 	}
2605 
2606 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2607 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2608 	}
2609 
2610 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2611 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2612 	}
2613 
2614 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2615 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2616 	}
2617 
2618 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2619 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2620 	}
2621 
2622 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2623 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2624 	}
2625 
2626 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2627 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2628 	}
2629 
2630 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2631 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2632 	}
2633 
2634 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2635 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2636 	}
2637 
2638 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2639 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2640 	}
2641 
2642 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2643 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2644 	}
2645 
2646 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2647 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2648 	}
2649 
2650 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2651 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2652 	}
2653 
2654 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2655 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2656 	}
2657 
2658 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2659 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2660 	}
2661 
2662 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2663 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2664 	}
2665 
2666 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2667 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2668 	}
2669 
2670 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2671 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2672 	}
2673 
2674 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2675 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2676 	}
2677 
2678 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2679 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2680 	}
2681 
2682 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2683 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2684 	}
2685 
2686 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2687 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2688 	}
2689 
2690 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2691 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2692 	}
2693 
2694 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2695 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2696 	}
2697 
2698 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2699 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2700 	}
2701 
2702 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2703 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2704 	}
2705 
2706 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2707 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2708 	}
2709 
2710 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2711 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2712 	}
2713 
2714 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2715 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2716 	}
2717 
2718 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2719 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2720 	}
2721 
2722 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2723 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2724 	}
2725 
2726 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2727 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2728 	}
2729 
2730 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2731 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2732 	}
2733 
2734 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2735 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2736 	}
2737 
2738 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2739 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2740 	}
2741 
2742 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2743 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2744 	}
2745 
2746 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2747 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2748 	}
2749 
2750 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2751 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2752 	}
2753 
2754 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2755 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2756 	}
2757 
2758 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2759 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2760 	}
2761 
2762 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2763 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2764 	}
2765 
2766 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2767 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2768 	}
2769 
2770 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2771 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2772 	}
2773 
2774 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2775 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2776 	}
2777 
2778 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2779 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2780 	}
2781 
2782 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2783 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2784 	}
2785 
2786 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2787 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2788 	}
2789 
2790 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2791 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2792 	}
2793 
2794 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2795 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2796 	}
2797 
2798 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2799 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2800 	}
2801 
2802 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2803 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2804 	}
2805 
2806 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2807 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2808 	}
2809 
2810 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2811 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2812 	}
2813 
2814 	function log(string memory p0, address p1, address p2, address p3) internal view {
2815 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2816 	}
2817 
2818 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2819 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2820 	}
2821 
2822 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2823 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2824 	}
2825 
2826 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2827 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2828 	}
2829 
2830 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2831 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2832 	}
2833 
2834 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2835 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2836 	}
2837 
2838 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2839 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2840 	}
2841 
2842 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2843 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2844 	}
2845 
2846 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2847 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2848 	}
2849 
2850 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2851 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2852 	}
2853 
2854 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2855 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2856 	}
2857 
2858 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2859 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2860 	}
2861 
2862 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2863 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2864 	}
2865 
2866 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2867 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2868 	}
2869 
2870 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2871 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2872 	}
2873 
2874 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2875 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2876 	}
2877 
2878 	function log(bool p0, uint p1, address p2, address p3) internal view {
2879 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2880 	}
2881 
2882 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2883 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2884 	}
2885 
2886 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2887 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2888 	}
2889 
2890 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2891 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2892 	}
2893 
2894 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2895 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2896 	}
2897 
2898 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2899 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2900 	}
2901 
2902 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2903 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2904 	}
2905 
2906 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2907 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2908 	}
2909 
2910 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2911 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2912 	}
2913 
2914 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2915 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2916 	}
2917 
2918 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2919 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2920 	}
2921 
2922 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2923 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2924 	}
2925 
2926 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2927 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2928 	}
2929 
2930 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2931 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2932 	}
2933 
2934 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2935 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2936 	}
2937 
2938 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2939 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2940 	}
2941 
2942 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2943 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2944 	}
2945 
2946 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2947 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2948 	}
2949 
2950 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2951 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2952 	}
2953 
2954 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2955 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2956 	}
2957 
2958 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2959 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2960 	}
2961 
2962 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2963 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2964 	}
2965 
2966 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2967 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2968 	}
2969 
2970 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2971 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2972 	}
2973 
2974 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2975 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2976 	}
2977 
2978 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2979 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2980 	}
2981 
2982 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2983 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2984 	}
2985 
2986 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2987 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2988 	}
2989 
2990 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2991 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2992 	}
2993 
2994 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2995 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2996 	}
2997 
2998 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2999 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3000 	}
3001 
3002 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3003 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3004 	}
3005 
3006 	function log(bool p0, bool p1, address p2, address p3) internal view {
3007 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3008 	}
3009 
3010 	function log(bool p0, address p1, uint p2, uint p3) internal view {
3011 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
3012 	}
3013 
3014 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
3015 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
3016 	}
3017 
3018 	function log(bool p0, address p1, uint p2, bool p3) internal view {
3019 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
3020 	}
3021 
3022 	function log(bool p0, address p1, uint p2, address p3) internal view {
3023 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
3024 	}
3025 
3026 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
3027 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
3028 	}
3029 
3030 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3031 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3032 	}
3033 
3034 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3035 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3036 	}
3037 
3038 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3039 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3040 	}
3041 
3042 	function log(bool p0, address p1, bool p2, uint p3) internal view {
3043 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
3044 	}
3045 
3046 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3047 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3048 	}
3049 
3050 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3051 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3052 	}
3053 
3054 	function log(bool p0, address p1, bool p2, address p3) internal view {
3055 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3056 	}
3057 
3058 	function log(bool p0, address p1, address p2, uint p3) internal view {
3059 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
3060 	}
3061 
3062 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3063 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3064 	}
3065 
3066 	function log(bool p0, address p1, address p2, bool p3) internal view {
3067 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3068 	}
3069 
3070 	function log(bool p0, address p1, address p2, address p3) internal view {
3071 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3072 	}
3073 
3074 	function log(address p0, uint p1, uint p2, uint p3) internal view {
3075 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
3076 	}
3077 
3078 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
3079 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
3080 	}
3081 
3082 	function log(address p0, uint p1, uint p2, bool p3) internal view {
3083 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
3084 	}
3085 
3086 	function log(address p0, uint p1, uint p2, address p3) internal view {
3087 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
3088 	}
3089 
3090 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
3091 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
3092 	}
3093 
3094 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
3095 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
3096 	}
3097 
3098 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
3099 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
3100 	}
3101 
3102 	function log(address p0, uint p1, string memory p2, address p3) internal view {
3103 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
3104 	}
3105 
3106 	function log(address p0, uint p1, bool p2, uint p3) internal view {
3107 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
3108 	}
3109 
3110 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
3111 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
3112 	}
3113 
3114 	function log(address p0, uint p1, bool p2, bool p3) internal view {
3115 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
3116 	}
3117 
3118 	function log(address p0, uint p1, bool p2, address p3) internal view {
3119 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
3120 	}
3121 
3122 	function log(address p0, uint p1, address p2, uint p3) internal view {
3123 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
3124 	}
3125 
3126 	function log(address p0, uint p1, address p2, string memory p3) internal view {
3127 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
3128 	}
3129 
3130 	function log(address p0, uint p1, address p2, bool p3) internal view {
3131 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
3132 	}
3133 
3134 	function log(address p0, uint p1, address p2, address p3) internal view {
3135 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
3136 	}
3137 
3138 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
3139 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
3140 	}
3141 
3142 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
3143 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
3144 	}
3145 
3146 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
3147 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
3148 	}
3149 
3150 	function log(address p0, string memory p1, uint p2, address p3) internal view {
3151 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
3152 	}
3153 
3154 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
3155 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
3156 	}
3157 
3158 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3159 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3160 	}
3161 
3162 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3163 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3164 	}
3165 
3166 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3167 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3168 	}
3169 
3170 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
3171 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
3172 	}
3173 
3174 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3175 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3176 	}
3177 
3178 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3179 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3180 	}
3181 
3182 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3183 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3184 	}
3185 
3186 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3187 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3188 	}
3189 
3190 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3191 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3192 	}
3193 
3194 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3195 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3196 	}
3197 
3198 	function log(address p0, string memory p1, address p2, address p3) internal view {
3199 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3200 	}
3201 
3202 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3203 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3204 	}
3205 
3206 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3207 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3208 	}
3209 
3210 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3211 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3212 	}
3213 
3214 	function log(address p0, bool p1, uint p2, address p3) internal view {
3215 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3216 	}
3217 
3218 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3219 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3220 	}
3221 
3222 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3223 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3224 	}
3225 
3226 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3227 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3228 	}
3229 
3230 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3231 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3232 	}
3233 
3234 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3235 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3236 	}
3237 
3238 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3239 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3240 	}
3241 
3242 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3243 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3244 	}
3245 
3246 	function log(address p0, bool p1, bool p2, address p3) internal view {
3247 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3248 	}
3249 
3250 	function log(address p0, bool p1, address p2, uint p3) internal view {
3251 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3252 	}
3253 
3254 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3255 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3256 	}
3257 
3258 	function log(address p0, bool p1, address p2, bool p3) internal view {
3259 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3260 	}
3261 
3262 	function log(address p0, bool p1, address p2, address p3) internal view {
3263 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3264 	}
3265 
3266 	function log(address p0, address p1, uint p2, uint p3) internal view {
3267 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3268 	}
3269 
3270 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3271 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3272 	}
3273 
3274 	function log(address p0, address p1, uint p2, bool p3) internal view {
3275 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3276 	}
3277 
3278 	function log(address p0, address p1, uint p2, address p3) internal view {
3279 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3280 	}
3281 
3282 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3283 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3284 	}
3285 
3286 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3287 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3288 	}
3289 
3290 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3291 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3292 	}
3293 
3294 	function log(address p0, address p1, string memory p2, address p3) internal view {
3295 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3296 	}
3297 
3298 	function log(address p0, address p1, bool p2, uint p3) internal view {
3299 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3300 	}
3301 
3302 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3303 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3304 	}
3305 
3306 	function log(address p0, address p1, bool p2, bool p3) internal view {
3307 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3308 	}
3309 
3310 	function log(address p0, address p1, bool p2, address p3) internal view {
3311 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3312 	}
3313 
3314 	function log(address p0, address p1, address p2, uint p3) internal view {
3315 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3316 	}
3317 
3318 	function log(address p0, address p1, address p2, string memory p3) internal view {
3319 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3320 	}
3321 
3322 	function log(address p0, address p1, address p2, bool p3) internal view {
3323 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3324 	}
3325 
3326 	function log(address p0, address p1, address p2, address p3) internal view {
3327 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3328 	}
3329 
3330 }
3331 
3332 contract NFT is ERC721, Ownable {
3333     using SafeMath for uint256;
3334 
3335 
3336     string public _abi_hash = "";
3337     string public _provenance_hash = "";
3338     uint256 public _price = 0; 
3339     uint256 public _max_supply = 0; 
3340     string public _baseURI = "";
3341     uint256 public _airdrop_available = 0;
3342     uint256 public _networkid = 0; 
3343 
3344     using Counters for Counters.Counter;
3345     Counters.Counter private _tokenIds;
3346 
3347     mapping(bytes32 => bool) public airdrop_tickets;
3348 
3349     constructor(string memory name, string memory symbol, string memory abi_hash, string memory provenance_hash, uint256 price, uint256 max_supply, uint16 networkid) ERC721(name, symbol) {
3350         _abi_hash = abi_hash;
3351         _provenance_hash = provenance_hash;
3352         _price = price;
3353         _max_supply = max_supply;
3354         _networkid = networkid;
3355         if (_networkid == 1) {
3356             _baseURI = string(abi.encodePacked("https://defra.systems/metadata/", _provenance_hash, "/asset/"));
3357         } else {
3358             _baseURI = string(abi.encodePacked("https://test.defra.systems/metadata/", _provenance_hash, "/asset/"));
3359         }
3360         _setBaseURI(_baseURI);
3361     }
3362 
3363     function update(string memory provenance_hash, uint256 price, uint256 max_supply) public onlyOwner {
3364         _provenance_hash = provenance_hash;
3365         _price = price;
3366         _max_supply = max_supply; 
3367 
3368         if (_networkid == 1) {
3369             _baseURI = string(abi.encodePacked("https://defra.systems/metadata/", _provenance_hash, "/asset/"));
3370         } else {
3371             _baseURI = string(abi.encodePacked("https://test.defra.systems/metadata/", _provenance_hash, "/asset/"));
3372         }
3373     }
3374 
3375     function withdraw() public onlyOwner {
3376         uint balance = address(this).balance;
3377         msg.sender.transfer(balance);
3378     }
3379 
3380     function updateBaseTokenURI(string memory baseURI) public onlyOwner {
3381         _setBaseURI(baseURI);
3382         _baseURI = baseURI;
3383     }
3384 
3385     function baseTokenURI() public view returns (string memory) {
3386         return _baseURI;
3387     }
3388 
3389     function mintToSender(uint numberOfTokens) internal {
3390         require(totalSupply().add(numberOfTokens).add(_airdrop_available) <= _max_supply, "Minting would exceed max supply");
3391         
3392         for(uint i = 0; i < numberOfTokens; i++) {
3393             uint mintIndex = totalSupply();
3394             _mint(msg.sender, mintIndex);
3395         }
3396     }
3397 
3398     function reserve(uint numberOfTokens) public onlyOwner {
3399         mintToSender(numberOfTokens);
3400     }
3401 
3402     function purchase(uint numberOfTokens) public payable {
3403         require(numberOfTokens <= 30, "Can only purchase a maximum of 30");
3404         require(_price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
3405         mintToSender(numberOfTokens);
3406     }
3407 
3408     function redeemCodeCreate(bytes32 code_hashed) public onlyOwner {
3409         require(!airdrop_tickets[code_hashed], "Cannot create the same ticket twice");
3410         require(totalSupply().add(1) <= _max_supply, "Codes would exceed max supply");
3411         airdrop_tickets[code_hashed] = true;
3412         _airdrop_available += 1;
3413     }
3414 
3415     function redeemCodeCreateBulk(bytes32[] memory code_hashed_arr) public onlyOwner {
3416         require(totalSupply().add(code_hashed_arr.length) <= _max_supply, "Codes would exceed max supply");
3417         for (uint i = 0; i < code_hashed_arr.length; i++) {
3418             redeemCodeCreate(code_hashed_arr[i]);
3419         }
3420     }
3421 
3422     function airdrop(bytes memory code) public {
3423         require(_airdrop_available > 0, "No airdrop tokens available or the airdrop is over");
3424         require(airdrop_tickets[sha256(code)], "The given airdrop ticket does not exist");
3425         delete airdrop_tickets[sha256(code)];
3426         _airdrop_available -= 1;
3427         mintToSender(1);
3428     }
3429 
3430     function disableAirdrop() public onlyOwner {
3431         _airdrop_available = 0;
3432     }
3433 
3434     function abiHash() public view virtual  returns (string memory) {
3435         return _abi_hash;
3436     }
3437 
3438     function provenanceHash() public view virtual  returns (string memory) {
3439         return _provenance_hash;
3440     }
3441 
3442     function price() public view virtual returns (uint256) {
3443         return _price;
3444     }
3445 
3446     function max_supply() public view virtual returns (uint256) {
3447         return _max_supply;
3448     }
3449 }