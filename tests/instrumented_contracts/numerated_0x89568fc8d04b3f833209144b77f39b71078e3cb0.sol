1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-19
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.7.6;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(address from, address to, uint256 tokenId) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address from, address to, uint256 tokenId) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141       * @dev Safely transfers `tokenId` token from `from` to `to`.
142       *
143       * Requirements:
144       *
145       * - `from` cannot be the zero address.
146       * - `to` cannot be the zero address.
147       * - `tokenId` token must exist and be owned by `from`.
148       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150       *
151       * Emits a {Transfer} event.
152       */
153     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
154 }
155 
156 interface IERC721Metadata is IERC721 {
157 
158     /**
159      * @dev Returns the token collection name.
160      */
161     function name() external view returns (string memory);
162 
163     /**
164      * @dev Returns the token collection symbol.
165      */
166     function symbol() external view returns (string memory);
167 
168     /**
169      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
170      */
171     function tokenURI(uint256 tokenId) external view returns (string memory);
172 }
173 
174 interface IERC721Enumerable is IERC721 {
175 
176     /**
177      * @dev Returns the total amount of tokens stored by the contract.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
183      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
184      */
185     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
186 
187     /**
188      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
189      * Use along with {totalSupply} to enumerate all tokens.
190      */
191     function tokenByIndex(uint256 index) external view returns (uint256);
192 }
193 
194 interface IERC721Receiver {
195     /**
196      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197      * by `operator` from `from`, this function is called.
198      *
199      * It must return its Solidity selector to confirm the token transfer.
200      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201      *
202      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203      */
204     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
205 }
206 
207 /**
208  * @dev Implementation of the {IERC165} interface.
209  *
210  * Contracts may inherit from this and call {_registerInterface} to declare
211  * their support of an interface.
212  */
213 abstract contract ERC165 is IERC165 {
214     /*
215      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
216      */
217     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
218 
219     /**
220      * @dev Mapping of interface ids to whether or not it's supported.
221      */
222     mapping(bytes4 => bool) private _supportedInterfaces;
223 
224     constructor () internal {
225         // Derived contracts need only register support for their own interfaces,
226         // we register support for ERC165 itself here
227         _registerInterface(_INTERFACE_ID_ERC165);
228     }
229 
230     /**
231      * @dev See {IERC165-supportsInterface}.
232      *
233      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
234      */
235     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236         return _supportedInterfaces[interfaceId];
237     }
238 
239     /**
240      * @dev Registers the contract as an implementer of the interface defined by
241      * `interfaceId`. Support of the actual ERC165 interface is automatic and
242      * registering its interface id is not required.
243      *
244      * See {IERC165-supportsInterface}.
245      *
246      * Requirements:
247      *
248      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
249      */
250     function _registerInterface(bytes4 interfaceId) internal virtual {
251         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
252         _supportedInterfaces[interfaceId] = true;
253     }
254 }
255 
256 /**
257  * @dev Wrappers over Solidity's arithmetic operations with added overflow
258  * checks.
259  *
260  * Arithmetic operations in Solidity wrap on overflow. This can easily result
261  * in bugs, because programmers usually assume that an overflow raises an
262  * error, which is the standard behavior in high level programming languages.
263  * `SafeMath` restores this intuition by reverting the transaction when an
264  * operation overflows.
265  *
266  * Using this library instead of the unchecked operations eliminates an entire
267  * class of bugs, so it's recommended to use it always.
268  */
269 library SafeMath {
270     /**
271      * @dev Returns the addition of two unsigned integers, with an overflow flag.
272      *
273      * _Available since v3.4._
274      */
275     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         uint256 c = a + b;
277         if (c < a) return (false, 0);
278         return (true, c);
279     }
280 
281     /**
282      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
283      *
284      * _Available since v3.4._
285      */
286     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         if (b > a) return (false, 0);
288         return (true, a - b);
289     }
290 
291     /**
292      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
293      *
294      * _Available since v3.4._
295      */
296     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
298         // benefit is lost if 'b' is also tested.
299         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
300         if (a == 0) return (true, 0);
301         uint256 c = a * b;
302         if (c / a != b) return (false, 0);
303         return (true, c);
304     }
305 
306     /**
307      * @dev Returns the division of two unsigned integers, with a division by zero flag.
308      *
309      * _Available since v3.4._
310      */
311     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
312         if (b == 0) return (false, 0);
313         return (true, a / b);
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
318      *
319      * _Available since v3.4._
320      */
321     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
322         if (b == 0) return (false, 0);
323         return (true, a % b);
324     }
325 
326     /**
327      * @dev Returns the addition of two unsigned integers, reverting on
328      * overflow.
329      *
330      * Counterpart to Solidity's `+` operator.
331      *
332      * Requirements:
333      *
334      * - Addition cannot overflow.
335      */
336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
337         uint256 c = a + b;
338         require(c >= a, "SafeMath: addition overflow");
339         return c;
340     }
341 
342     /**
343      * @dev Returns the subtraction of two unsigned integers, reverting on
344      * overflow (when the result is negative).
345      *
346      * Counterpart to Solidity's `-` operator.
347      *
348      * Requirements:
349      *
350      * - Subtraction cannot overflow.
351      */
352     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
353         require(b <= a, "SafeMath: subtraction overflow");
354         return a - b;
355     }
356 
357     /**
358      * @dev Returns the multiplication of two unsigned integers, reverting on
359      * overflow.
360      *
361      * Counterpart to Solidity's `*` operator.
362      *
363      * Requirements:
364      *
365      * - Multiplication cannot overflow.
366      */
367     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
368         if (a == 0) return 0;
369         uint256 c = a * b;
370         require(c / a == b, "SafeMath: multiplication overflow");
371         return c;
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers, reverting on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b) internal pure returns (uint256) {
387         require(b > 0, "SafeMath: division by zero");
388         return a / b;
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * reverting when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
404         require(b > 0, "SafeMath: modulo by zero");
405         return a % b;
406     }
407 
408     /**
409      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
410      * overflow (when the result is negative).
411      *
412      * CAUTION: This function is deprecated because it requires allocating memory for the error
413      * message unnecessarily. For custom revert reasons use {trySub}.
414      *
415      * Counterpart to Solidity's `-` operator.
416      *
417      * Requirements:
418      *
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b <= a, errorMessage);
423         return a - b;
424     }
425 
426     /**
427      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
428      * division by zero. The result is rounded towards zero.
429      *
430      * CAUTION: This function is deprecated because it requires allocating memory for the error
431      * message unnecessarily. For custom revert reasons use {tryDiv}.
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
443         return a / b;
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * reverting with custom message when dividing by zero.
449      *
450      * CAUTION: This function is deprecated because it requires allocating memory for the error
451      * message unnecessarily. For custom revert reasons use {tryMod}.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
462         require(b > 0, errorMessage);
463         return a % b;
464     }
465 }
466 
467 /**
468  * @dev Collection of functions related to the address type
469  */
470 library Address {
471     /**
472      * @dev Returns true if `account` is a contract.
473      *
474      * [IMPORTANT]
475      * ====
476      * It is unsafe to assume that an address for which this function returns
477      * false is an externally-owned account (EOA) and not a contract.
478      *
479      * Among others, `isContract` will return false for the following
480      * types of addresses:
481      *
482      *  - an externally-owned account
483      *  - a contract in construction
484      *  - an address where a contract will be created
485      *  - an address where a contract lived, but was destroyed
486      * ====
487      */
488     function isContract(address account) internal view returns (bool) {
489         // This method relies on extcodesize, which returns 0 for contracts in
490         // construction, since the code is only stored at the end of the
491         // constructor execution.
492 
493         uint256 size;
494         // solhint-disable-next-line no-inline-assembly
495         assembly { size := extcodesize(account) }
496         return size > 0;
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      */
515     function sendValue(address payable recipient, uint256 amount) internal {
516         require(address(this).balance >= amount, "Address: insufficient balance");
517 
518         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
519         (bool success, ) = recipient.call{ value: amount }("");
520         require(success, "Address: unable to send value, recipient may have reverted");
521     }
522 
523     /**
524      * @dev Performs a Solidity function call using a low level `call`. A
525      * plain`call` is an unsafe replacement for a function call: use this
526      * function instead.
527      *
528      * If `target` reverts with a revert reason, it is bubbled up by this
529      * function (like regular Solidity function calls).
530      *
531      * Returns the raw returned data. To convert to the expected return value,
532      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
533      *
534      * Requirements:
535      *
536      * - `target` must be a contract.
537      * - calling `target` with `data` must not revert.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
542       return functionCall(target, data, "Address: low-level call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
547      * `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, 0, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but also transferring `value` wei to `target`.
558      *
559      * Requirements:
560      *
561      * - the calling contract must have an ETH balance of at least `value`.
562      * - the called Solidity function must be `payable`.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
572      * with `errorMessage` as a fallback revert reason when `target` reverts.
573      *
574      * _Available since v3.1._
575      */
576     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
577         require(address(this).balance >= value, "Address: insufficient balance for call");
578         require(isContract(target), "Address: call to non-contract");
579 
580         // solhint-disable-next-line avoid-low-level-calls
581         (bool success, bytes memory returndata) = target.call{ value: value }(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but performing a static call.
588      *
589      * _Available since v3.3._
590      */
591     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
592         return functionStaticCall(target, data, "Address: low-level static call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         // solhint-disable-next-line avoid-low-level-calls
605         (bool success, bytes memory returndata) = target.staticcall(data);
606         return _verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
616         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
626         require(isContract(target), "Address: delegate call to non-contract");
627 
628         // solhint-disable-next-line avoid-low-level-calls
629         (bool success, bytes memory returndata) = target.delegatecall(data);
630         return _verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
634         if (success) {
635             return returndata;
636         } else {
637             // Look for revert reason and bubble it up if present
638             if (returndata.length > 0) {
639                 // The easiest way to bubble the revert reason is using memory via assembly
640 
641                 // solhint-disable-next-line no-inline-assembly
642                 assembly {
643                     let returndata_size := mload(returndata)
644                     revert(add(32, returndata), returndata_size)
645                 }
646             } else {
647                 revert(errorMessage);
648             }
649         }
650     }
651 }
652 
653 /**
654  * @dev Library for managing
655  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
656  * types.
657  *
658  * Sets have the following properties:
659  *
660  * - Elements are added, removed, and checked for existence in constant time
661  * (O(1)).
662  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
663  *
664  * ```
665  * contract Example {
666  *     // Add the library methods
667  *     using EnumerableSet for EnumerableSet.AddressSet;
668  *
669  *     // Declare a set state variable
670  *     EnumerableSet.AddressSet private mySet;
671  * }
672  * ```
673  *
674  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
675  * and `uint256` (`UintSet`) are supported.
676  */
677 library EnumerableSet {
678     // To implement this library for multiple types with as little code
679     // repetition as possible, we write it in terms of a generic Set type with
680     // bytes32 values.
681     // The Set implementation uses private functions, and user-facing
682     // implementations (such as AddressSet) are just wrappers around the
683     // underlying Set.
684     // This means that we can only create new EnumerableSets for types that fit
685     // in bytes32.
686 
687     struct Set {
688         // Storage of set values
689         bytes32[] _values;
690 
691         // Position of the value in the `values` array, plus 1 because index 0
692         // means a value is not in the set.
693         mapping (bytes32 => uint256) _indexes;
694     }
695 
696     /**
697      * @dev Add a value to a set. O(1).
698      *
699      * Returns true if the value was added to the set, that is if it was not
700      * already present.
701      */
702     function _add(Set storage set, bytes32 value) private returns (bool) {
703         if (!_contains(set, value)) {
704             set._values.push(value);
705             // The value is stored at length-1, but we add 1 to all indexes
706             // and use 0 as a sentinel value
707             set._indexes[value] = set._values.length;
708             return true;
709         } else {
710             return false;
711         }
712     }
713 
714     /**
715      * @dev Removes a value from a set. O(1).
716      *
717      * Returns true if the value was removed from the set, that is if it was
718      * present.
719      */
720     function _remove(Set storage set, bytes32 value) private returns (bool) {
721         // We read and store the value's index to prevent multiple reads from the same storage slot
722         uint256 valueIndex = set._indexes[value];
723 
724         if (valueIndex != 0) { // Equivalent to contains(set, value)
725             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
726             // the array, and then remove the last element (sometimes called as 'swap and pop').
727             // This modifies the order of the array, as noted in {at}.
728 
729             uint256 toDeleteIndex = valueIndex - 1;
730             uint256 lastIndex = set._values.length - 1;
731 
732             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
733             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
734 
735             bytes32 lastvalue = set._values[lastIndex];
736 
737             // Move the last value to the index where the value to delete is
738             set._values[toDeleteIndex] = lastvalue;
739             // Update the index for the moved value
740             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
741 
742             // Delete the slot where the moved value was stored
743             set._values.pop();
744 
745             // Delete the index for the deleted slot
746             delete set._indexes[value];
747 
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754     /**
755      * @dev Returns true if the value is in the set. O(1).
756      */
757     function _contains(Set storage set, bytes32 value) private view returns (bool) {
758         return set._indexes[value] != 0;
759     }
760 
761     /**
762      * @dev Returns the number of values on the set. O(1).
763      */
764     function _length(Set storage set) private view returns (uint256) {
765         return set._values.length;
766     }
767 
768    /**
769     * @dev Returns the value stored at position `index` in the set. O(1).
770     *
771     * Note that there are no guarantees on the ordering of values inside the
772     * array, and it may change when more values are added or removed.
773     *
774     * Requirements:
775     *
776     * - `index` must be strictly less than {length}.
777     */
778     function _at(Set storage set, uint256 index) private view returns (bytes32) {
779         require(set._values.length > index, "EnumerableSet: index out of bounds");
780         return set._values[index];
781     }
782 
783     // Bytes32Set
784 
785     struct Bytes32Set {
786         Set _inner;
787     }
788 
789     /**
790      * @dev Add a value to a set. O(1).
791      *
792      * Returns true if the value was added to the set, that is if it was not
793      * already present.
794      */
795     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
796         return _add(set._inner, value);
797     }
798 
799     /**
800      * @dev Removes a value from a set. O(1).
801      *
802      * Returns true if the value was removed from the set, that is if it was
803      * present.
804      */
805     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
806         return _remove(set._inner, value);
807     }
808 
809     /**
810      * @dev Returns true if the value is in the set. O(1).
811      */
812     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
813         return _contains(set._inner, value);
814     }
815 
816     /**
817      * @dev Returns the number of values in the set. O(1).
818      */
819     function length(Bytes32Set storage set) internal view returns (uint256) {
820         return _length(set._inner);
821     }
822 
823    /**
824     * @dev Returns the value stored at position `index` in the set. O(1).
825     *
826     * Note that there are no guarantees on the ordering of values inside the
827     * array, and it may change when more values are added or removed.
828     *
829     * Requirements:
830     *
831     * - `index` must be strictly less than {length}.
832     */
833     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
834         return _at(set._inner, index);
835     }
836 
837     // AddressSet
838 
839     struct AddressSet {
840         Set _inner;
841     }
842 
843     /**
844      * @dev Add a value to a set. O(1).
845      *
846      * Returns true if the value was added to the set, that is if it was not
847      * already present.
848      */
849     function add(AddressSet storage set, address value) internal returns (bool) {
850         return _add(set._inner, bytes32(uint256(uint160(value))));
851     }
852 
853     /**
854      * @dev Removes a value from a set. O(1).
855      *
856      * Returns true if the value was removed from the set, that is if it was
857      * present.
858      */
859     function remove(AddressSet storage set, address value) internal returns (bool) {
860         return _remove(set._inner, bytes32(uint256(uint160(value))));
861     }
862 
863     /**
864      * @dev Returns true if the value is in the set. O(1).
865      */
866     function contains(AddressSet storage set, address value) internal view returns (bool) {
867         return _contains(set._inner, bytes32(uint256(uint160(value))));
868     }
869 
870     /**
871      * @dev Returns the number of values in the set. O(1).
872      */
873     function length(AddressSet storage set) internal view returns (uint256) {
874         return _length(set._inner);
875     }
876 
877    /**
878     * @dev Returns the value stored at position `index` in the set. O(1).
879     *
880     * Note that there are no guarantees on the ordering of values inside the
881     * array, and it may change when more values are added or removed.
882     *
883     * Requirements:
884     *
885     * - `index` must be strictly less than {length}.
886     */
887     function at(AddressSet storage set, uint256 index) internal view returns (address) {
888         return address(uint160(uint256(_at(set._inner, index))));
889     }
890 
891 
892     // UintSet
893 
894     struct UintSet {
895         Set _inner;
896     }
897 
898     /**
899      * @dev Add a value to a set. O(1).
900      *
901      * Returns true if the value was added to the set, that is if it was not
902      * already present.
903      */
904     function add(UintSet storage set, uint256 value) internal returns (bool) {
905         return _add(set._inner, bytes32(value));
906     }
907 
908     /**
909      * @dev Removes a value from a set. O(1).
910      *
911      * Returns true if the value was removed from the set, that is if it was
912      * present.
913      */
914     function remove(UintSet storage set, uint256 value) internal returns (bool) {
915         return _remove(set._inner, bytes32(value));
916     }
917 
918     /**
919      * @dev Returns true if the value is in the set. O(1).
920      */
921     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
922         return _contains(set._inner, bytes32(value));
923     }
924 
925     /**
926      * @dev Returns the number of values on the set. O(1).
927      */
928     function length(UintSet storage set) internal view returns (uint256) {
929         return _length(set._inner);
930     }
931 
932    /**
933     * @dev Returns the value stored at position `index` in the set. O(1).
934     *
935     * Note that there are no guarantees on the ordering of values inside the
936     * array, and it may change when more values are added or removed.
937     *
938     * Requirements:
939     *
940     * - `index` must be strictly less than {length}.
941     */
942     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
943         return uint256(_at(set._inner, index));
944     }
945 }
946 
947 /**
948  * @dev Library for managing an enumerable variant of Solidity's
949  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
950  * type.
951  *
952  * Maps have the following properties:
953  *
954  * - Entries are added, removed, and checked for existence in constant time
955  * (O(1)).
956  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
957  *
958  * ```
959  * contract Example {
960  *     // Add the library methods
961  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
962  *
963  *     // Declare a set state variable
964  *     EnumerableMap.UintToAddressMap private myMap;
965  * }
966  * ```
967  *
968  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
969  * supported.
970  */
971 library EnumerableMap {
972     // To implement this library for multiple types with as little code
973     // repetition as possible, we write it in terms of a generic Map type with
974     // bytes32 keys and values.
975     // The Map implementation uses private functions, and user-facing
976     // implementations (such as Uint256ToAddressMap) are just wrappers around
977     // the underlying Map.
978     // This means that we can only create new EnumerableMaps for types that fit
979     // in bytes32.
980 
981     struct MapEntry {
982         bytes32 _key;
983         bytes32 _value;
984     }
985 
986     struct Map {
987         // Storage of map keys and values
988         MapEntry[] _entries;
989 
990         // Position of the entry defined by a key in the `entries` array, plus 1
991         // because index 0 means a key is not in the map.
992         mapping (bytes32 => uint256) _indexes;
993     }
994 
995     /**
996      * @dev Adds a key-value pair to a map, or updates the value for an existing
997      * key. O(1).
998      *
999      * Returns true if the key was added to the map, that is if it was not
1000      * already present.
1001      */
1002     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1003         // We read and store the key's index to prevent multiple reads from the same storage slot
1004         uint256 keyIndex = map._indexes[key];
1005 
1006         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1007             map._entries.push(MapEntry({ _key: key, _value: value }));
1008             // The entry is stored at length-1, but we add 1 to all indexes
1009             // and use 0 as a sentinel value
1010             map._indexes[key] = map._entries.length;
1011             return true;
1012         } else {
1013             map._entries[keyIndex - 1]._value = value;
1014             return false;
1015         }
1016     }
1017 
1018     /**
1019      * @dev Removes a key-value pair from a map. O(1).
1020      *
1021      * Returns true if the key was removed from the map, that is if it was present.
1022      */
1023     function _remove(Map storage map, bytes32 key) private returns (bool) {
1024         // We read and store the key's index to prevent multiple reads from the same storage slot
1025         uint256 keyIndex = map._indexes[key];
1026 
1027         if (keyIndex != 0) { // Equivalent to contains(map, key)
1028             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1029             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1030             // This modifies the order of the array, as noted in {at}.
1031 
1032             uint256 toDeleteIndex = keyIndex - 1;
1033             uint256 lastIndex = map._entries.length - 1;
1034 
1035             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1036             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1037 
1038             MapEntry storage lastEntry = map._entries[lastIndex];
1039 
1040             // Move the last entry to the index where the entry to delete is
1041             map._entries[toDeleteIndex] = lastEntry;
1042             // Update the index for the moved entry
1043             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1044 
1045             // Delete the slot where the moved entry was stored
1046             map._entries.pop();
1047 
1048             // Delete the index for the deleted slot
1049             delete map._indexes[key];
1050 
1051             return true;
1052         } else {
1053             return false;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns true if the key is in the map. O(1).
1059      */
1060     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1061         return map._indexes[key] != 0;
1062     }
1063 
1064     /**
1065      * @dev Returns the number of key-value pairs in the map. O(1).
1066      */
1067     function _length(Map storage map) private view returns (uint256) {
1068         return map._entries.length;
1069     }
1070 
1071    /**
1072     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1073     *
1074     * Note that there are no guarantees on the ordering of entries inside the
1075     * array, and it may change when more entries are added or removed.
1076     *
1077     * Requirements:
1078     *
1079     * - `index` must be strictly less than {length}.
1080     */
1081     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1082         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1083 
1084         MapEntry storage entry = map._entries[index];
1085         return (entry._key, entry._value);
1086     }
1087 
1088     /**
1089      * @dev Tries to returns the value associated with `key`.  O(1).
1090      * Does not revert if `key` is not in the map.
1091      */
1092     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1093         uint256 keyIndex = map._indexes[key];
1094         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1095         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1096     }
1097 
1098     /**
1099      * @dev Returns the value associated with `key`.  O(1).
1100      *
1101      * Requirements:
1102      *
1103      * - `key` must be in the map.
1104      */
1105     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1106         uint256 keyIndex = map._indexes[key];
1107         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1108         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1109     }
1110 
1111     /**
1112      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1113      *
1114      * CAUTION: This function is deprecated because it requires allocating memory for the error
1115      * message unnecessarily. For custom revert reasons use {_tryGet}.
1116      */
1117     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1118         uint256 keyIndex = map._indexes[key];
1119         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1120         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1121     }
1122 
1123     // UintToAddressMap
1124 
1125     struct UintToAddressMap {
1126         Map _inner;
1127     }
1128 
1129     /**
1130      * @dev Adds a key-value pair to a map, or updates the value for an existing
1131      * key. O(1).
1132      *
1133      * Returns true if the key was added to the map, that is if it was not
1134      * already present.
1135      */
1136     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1137         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1138     }
1139 
1140     /**
1141      * @dev Removes a value from a set. O(1).
1142      *
1143      * Returns true if the key was removed from the map, that is if it was present.
1144      */
1145     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1146         return _remove(map._inner, bytes32(key));
1147     }
1148 
1149     /**
1150      * @dev Returns true if the key is in the map. O(1).
1151      */
1152     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1153         return _contains(map._inner, bytes32(key));
1154     }
1155 
1156     /**
1157      * @dev Returns the number of elements in the map. O(1).
1158      */
1159     function length(UintToAddressMap storage map) internal view returns (uint256) {
1160         return _length(map._inner);
1161     }
1162 
1163    /**
1164     * @dev Returns the element stored at position `index` in the set. O(1).
1165     * Note that there are no guarantees on the ordering of values inside the
1166     * array, and it may change when more values are added or removed.
1167     *
1168     * Requirements:
1169     *
1170     * - `index` must be strictly less than {length}.
1171     */
1172     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1173         (bytes32 key, bytes32 value) = _at(map._inner, index);
1174         return (uint256(key), address(uint160(uint256(value))));
1175     }
1176 
1177     /**
1178      * @dev Tries to returns the value associated with `key`.  O(1).
1179      * Does not revert if `key` is not in the map.
1180      *
1181      * _Available since v3.4._
1182      */
1183     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1184         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1185         return (success, address(uint160(uint256(value))));
1186     }
1187 
1188     /**
1189      * @dev Returns the value associated with `key`.  O(1).
1190      *
1191      * Requirements:
1192      *
1193      * - `key` must be in the map.
1194      */
1195     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1196         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1197     }
1198 
1199     /**
1200      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1201      *
1202      * CAUTION: This function is deprecated because it requires allocating memory for the error
1203      * message unnecessarily. For custom revert reasons use {tryGet}.
1204      */
1205     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1206         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1207     }
1208 }
1209 
1210 /**
1211  * @dev String operations.
1212  */
1213 library Strings {
1214     /**
1215      * @dev Converts a `uint256` to its ASCII `string` representation.
1216      */
1217     function toString(uint256 value) internal pure returns (string memory) {
1218         // Inspired by OraclizeAPI's implementation - MIT licence
1219         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1220 
1221         if (value == 0) {
1222             return "0";
1223         }
1224         uint256 temp = value;
1225         uint256 digits;
1226         while (temp != 0) {
1227             digits++;
1228             temp /= 10;
1229         }
1230         bytes memory buffer = new bytes(digits);
1231         uint256 index = digits - 1;
1232         temp = value;
1233         while (temp != 0) {
1234             buffer[index--] = bytes1(uint8(48 + temp % 10));
1235             temp /= 10;
1236         }
1237         return string(buffer);
1238     }
1239 }
1240 
1241 /**
1242  * @title ERC721 Non-Fungible Token Standard basic implementation
1243  * @dev see https://eips.ethereum.org/EIPS/eip-721
1244  */
1245 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1246     using SafeMath for uint256;
1247     using Address for address;
1248     using EnumerableSet for EnumerableSet.UintSet;
1249     using EnumerableMap for EnumerableMap.UintToAddressMap;
1250     using Strings for uint256;
1251 
1252     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1253     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1254     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1255 
1256     // Mapping from holder address to their (enumerable) set of owned tokens
1257     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1258 
1259     // Enumerable mapping from token ids to their owners
1260     EnumerableMap.UintToAddressMap private _tokenOwners;
1261 
1262     // Mapping from token ID to approved address
1263     mapping (uint256 => address) private _tokenApprovals;
1264 
1265     // Mapping from owner to operator approvals
1266     mapping (address => mapping (address => bool)) private _operatorApprovals;
1267 
1268     // Token name
1269     string private _name;
1270 
1271     // Token symbol
1272     string private _symbol;
1273 
1274     // Optional mapping for token URIs
1275     mapping (uint256 => string) private _tokenURIs;
1276 
1277     // Base URI
1278     string private _baseURI;
1279 
1280     /*
1281      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1282      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1283      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1284      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1285      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1286      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1287      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1288      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1289      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1290      *
1291      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1292      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1293      */
1294     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1295 
1296     /*
1297      *     bytes4(keccak256('name()')) == 0x06fdde03
1298      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1299      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1300      *
1301      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1302      */
1303     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1304 
1305     /*
1306      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1307      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1308      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1309      *
1310      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1311      */
1312     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1313 
1314     /**
1315      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1316      */
1317     constructor (string memory name_, string memory symbol_) public {
1318         _name = name_;
1319         _symbol = symbol_;
1320 
1321         // register the supported interfaces to conform to ERC721 via ERC165
1322         _registerInterface(_INTERFACE_ID_ERC721);
1323         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1324         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-balanceOf}.
1329      */
1330     function balanceOf(address owner) public view virtual override returns (uint256) {
1331         require(owner != address(0), "ERC721: balance query for the zero address");
1332         return _holderTokens[owner].length();
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-ownerOf}.
1337      */
1338     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1339         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-name}.
1344      */
1345     function name() public view virtual override returns (string memory) {
1346         return _name;
1347     }
1348 
1349     /**
1350      * @dev See {IERC721Metadata-symbol}.
1351      */
1352     function symbol() public view virtual override returns (string memory) {
1353         return _symbol;
1354     }
1355 
1356     /**
1357      * @dev See {IERC721Metadata-tokenURI}.
1358      */
1359     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1360         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1361 
1362         string memory _tokenURI = _tokenURIs[tokenId];
1363         string memory base = baseURI();
1364 
1365         // If there is no base URI, return the token URI.
1366         if (bytes(base).length == 0) {
1367             return _tokenURI;
1368         }
1369         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1370         if (bytes(_tokenURI).length > 0) {
1371             return string(abi.encodePacked(base, _tokenURI));
1372         }
1373         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1374         return string(abi.encodePacked(base, tokenId.toString()));
1375     }
1376 
1377     /**
1378     * @dev Returns the base URI set via {_setBaseURI}. This will be
1379     * automatically added as a prefix in {tokenURI} to each token's URI, or
1380     * to the token ID if no specific URI is set for that token ID.
1381     */
1382     function baseURI() public view virtual returns (string memory) {
1383         return _baseURI;
1384     }
1385 
1386     /**
1387      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1388      */
1389     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1390         return _holderTokens[owner].at(index);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Enumerable-totalSupply}.
1395      */
1396     function totalSupply() public view virtual override returns (uint256) {
1397         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1398         return _tokenOwners.length();
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Enumerable-tokenByIndex}.
1403      */
1404     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1405         (uint256 tokenId, ) = _tokenOwners.at(index);
1406         return tokenId;
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-approve}.
1411      */
1412     function approve(address to, uint256 tokenId) public virtual override {
1413         address owner = ERC721.ownerOf(tokenId);
1414         require(to != owner, "ERC721: approval to current owner");
1415 
1416         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1417             "ERC721: approve caller is not owner nor approved for all"
1418         );
1419 
1420         _approve(to, tokenId);
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-getApproved}.
1425      */
1426     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1427         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1428 
1429         return _tokenApprovals[tokenId];
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-setApprovalForAll}.
1434      */
1435     function setApprovalForAll(address operator, bool approved) public virtual override {
1436         require(operator != _msgSender(), "ERC721: approve to caller");
1437 
1438         _operatorApprovals[_msgSender()][operator] = approved;
1439         emit ApprovalForAll(_msgSender(), operator, approved);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-isApprovedForAll}.
1444      */
1445     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1446         return _operatorApprovals[owner][operator];
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-transferFrom}.
1451      */
1452     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1453         //solhint-disable-next-line max-line-length
1454         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1455 
1456         _transfer(from, to, tokenId);
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-safeTransferFrom}.
1461      */
1462     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1463         safeTransferFrom(from, to, tokenId, "");
1464     }
1465 
1466     /**
1467      * @dev See {IERC721-safeTransferFrom}.
1468      */
1469     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1470         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1471         _safeTransfer(from, to, tokenId, _data);
1472     }
1473 
1474     /**
1475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1477      *
1478      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1479      *
1480      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1481      * implement alternative mechanisms to perform token transfer, such as signature-based.
1482      *
1483      * Requirements:
1484      *
1485      * - `from` cannot be the zero address.
1486      * - `to` cannot be the zero address.
1487      * - `tokenId` token must exist and be owned by `from`.
1488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1493         _transfer(from, to, tokenId);
1494         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1495     }
1496 
1497     /**
1498      * @dev Returns whether `tokenId` exists.
1499      *
1500      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1501      *
1502      * Tokens start existing when they are minted (`_mint`),
1503      * and stop existing when they are burned (`_burn`).
1504      */
1505     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1506         return _tokenOwners.contains(tokenId);
1507     }
1508 
1509     /**
1510      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1511      *
1512      * Requirements:
1513      *
1514      * - `tokenId` must exist.
1515      */
1516     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1517         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1518         address owner = ERC721.ownerOf(tokenId);
1519         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1520     }
1521 
1522     /**
1523      * @dev Safely mints `tokenId` and transfers it to `to`.
1524      *
1525      * Requirements:
1526      d*
1527      * - `tokenId` must not exist.
1528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _safeMint(address to, uint256 tokenId) internal virtual {
1533         _safeMint(to, tokenId, "");
1534     }
1535 
1536     /**
1537      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1538      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1539      */
1540     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1541         _mint(to, tokenId);
1542         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1543     }
1544 
1545     /**
1546      * @dev Mints `tokenId` and transfers it to `to`.
1547      *
1548      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1549      *
1550      * Requirements:
1551      *
1552      * - `tokenId` must not exist.
1553      * - `to` cannot be the zero address.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function _mint(address to, uint256 tokenId) internal virtual {
1558         require(to != address(0), "ERC721: mint to the zero address");
1559         require(!_exists(tokenId), "ERC721: token already minted");
1560 
1561         _beforeTokenTransfer(address(0), to, tokenId);
1562 
1563         _holderTokens[to].add(tokenId);
1564 
1565         _tokenOwners.set(tokenId, to);
1566 
1567         emit Transfer(address(0), to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev Destroys `tokenId`.
1572      * The approval is cleared when the token is burned.
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must exist.
1577      *
1578      * Emits a {Transfer} event.
1579      */
1580     function _burn(uint256 tokenId) internal virtual {
1581         address owner = ERC721.ownerOf(tokenId); // internal owner
1582 
1583         _beforeTokenTransfer(owner, address(0), tokenId);
1584 
1585         // Clear approvals
1586         _approve(address(0), tokenId);
1587 
1588         // Clear metadata (if any)
1589         if (bytes(_tokenURIs[tokenId]).length != 0) {
1590             delete _tokenURIs[tokenId];
1591         }
1592 
1593         _holderTokens[owner].remove(tokenId);
1594 
1595         _tokenOwners.remove(tokenId);
1596 
1597         emit Transfer(owner, address(0), tokenId);
1598     }
1599 
1600     /**
1601      * @dev Transfers `tokenId` from `from` to `to`.
1602      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1603      *
1604      * Requirements:
1605      *
1606      * - `to` cannot be the zero address.
1607      * - `tokenId` token must be owned by `from`.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1612         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1613         require(to != address(0), "ERC721: transfer to the zero address");
1614 
1615         _beforeTokenTransfer(from, to, tokenId);
1616 
1617         // Clear approvals from the previous owner
1618         _approve(address(0), tokenId);
1619 
1620         _holderTokens[from].remove(tokenId);
1621         _holderTokens[to].add(tokenId);
1622 
1623         _tokenOwners.set(tokenId, to);
1624 
1625         emit Transfer(from, to, tokenId);
1626     }
1627 
1628     /**
1629      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must exist.
1634      */
1635     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1636         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1637         _tokenURIs[tokenId] = _tokenURI;
1638     }
1639 
1640     /**
1641      * @dev Internal function to set the base URI for all token IDs. It is
1642      * automatically added as a prefix to the value returned in {tokenURI},
1643      * or to the token ID if {tokenURI} is empty.
1644      */
1645     function _setBaseURI(string memory baseURI_) internal virtual {
1646         _baseURI = baseURI_;
1647     }
1648 
1649     /**
1650      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1651      * The call is not executed if the target address is not a contract.
1652      *
1653      * @param from address representing the previous owner of the given token ID
1654      * @param to target address that will receive the tokens
1655      * @param tokenId uint256 ID of the token to be transferred
1656      * @param _data bytes optional data to send along with the call
1657      * @return bool whether the call correctly returned the expected magic value
1658      */
1659     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1660         private returns (bool)
1661     {
1662         if (!to.isContract()) {
1663             return true;
1664         }
1665         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1666             IERC721Receiver(to).onERC721Received.selector,
1667             _msgSender(),
1668             from,
1669             tokenId,
1670             _data
1671         ), "ERC721: transfer to non ERC721Receiver implementer");
1672         bytes4 retval = abi.decode(returndata, (bytes4));
1673         return (retval == _ERC721_RECEIVED);
1674     }
1675 
1676     /**
1677      * @dev Approve `to` to operate on `tokenId`
1678      *
1679      * Emits an {Approval} event.
1680      */
1681     function _approve(address to, uint256 tokenId) internal virtual {
1682         _tokenApprovals[tokenId] = to;
1683         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1684     }
1685 
1686     /**
1687      * @dev Hook that is called before any token transfer. This includes minting
1688      * and burning.
1689      *
1690      * Calling conditions:
1691      *
1692      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1693      * transferred to `to`.
1694      * - When `from` is zero, `tokenId` will be minted for `to`.
1695      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1696      * - `from` cannot be the zero address.
1697      * - `to` cannot be the zero address.
1698      *
1699      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1700      */
1701     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1702 }
1703 
1704 /**
1705  * @title Counters
1706  * @author Matt Condon (@shrugs)
1707  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1708  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1709  *
1710  * Include with `using Counters for Counters.Counter;`
1711  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1712  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1713  * directly accessed.
1714  */
1715 library Counters {
1716     using SafeMath for uint256;
1717 
1718     struct Counter {
1719         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1720         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1721         // this feature: see https://github.com/ethereum/solidity/issues/4637
1722         uint256 _value; // default: 0
1723     }
1724 
1725     function current(Counter storage counter) internal view returns (uint256) {
1726         return counter._value;
1727     }
1728 
1729     function increment(Counter storage counter) internal {
1730         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1731         counter._value += 1;
1732     }
1733 
1734     function decrement(Counter storage counter) internal {
1735         counter._value = counter._value.sub(1);
1736     }
1737 }
1738 
1739 /**
1740  * @dev Contract module which provides a basic access control mechanism, where
1741  * there is an account (an owner) that can be granted exclusive access to
1742  * specific functions.
1743  *
1744  * By default, the owner account will be the one that deploys the contract. This
1745  * can later be changed with {transferOwnership}.
1746  *
1747  * This module is used through inheritance. It will make available the modifier
1748  * `onlyOwner`, which can be applied to your functions to restrict their use to
1749  * the owner.
1750  */
1751 abstract contract Ownable is Context {
1752     address private _owner;
1753 
1754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1755 
1756     /**
1757      * @dev Initializes the contract setting the deployer as the initial owner.
1758      */
1759     constructor () internal {
1760         address msgSender = _msgSender();
1761         _owner = msgSender;
1762         emit OwnershipTransferred(address(0), msgSender);
1763     }
1764 
1765     /**
1766      * @dev Returns the address of the current owner.
1767      */
1768     function owner() public view virtual returns (address) {
1769         return _owner;
1770     }
1771 
1772     /**
1773      * @dev Throws if called by any account other than the owner.
1774      */
1775     modifier onlyOwner() {
1776         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1777         _;
1778     }
1779 
1780     /**
1781      * @dev Leaves the contract without owner. It will not be possible to call
1782      * `onlyOwner` functions anymore. Can only be called by the current owner.
1783      *
1784      * NOTE: Renouncing ownership will leave the contract without an owner,
1785      * thereby removing any functionality that is only available to the owner.
1786      */
1787     function renounceOwnership() public virtual onlyOwner {
1788         emit OwnershipTransferred(_owner, address(0));
1789         _owner = address(0);
1790     }
1791 
1792     /**
1793      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1794      * Can only be called by the current owner.
1795      */
1796     function transferOwnership(address newOwner) public virtual onlyOwner {
1797         require(newOwner != address(0), "Ownable: new owner is the zero address");
1798         emit OwnershipTransferred(_owner, newOwner);
1799         _owner = newOwner;
1800     }
1801 }
1802 
1803 contract NFT is ERC721, Ownable {
1804     using SafeMath for uint256;
1805 
1806     uint256 public _auctiontier = 0; //for opensea auction
1807     uint256 public _price = 0; 
1808     uint256 public _max_supply = 0; 
1809     string public _baseURI = "";
1810     uint256 public _airdrop_available = 0;
1811     uint256 public _networkid = 0;
1812     uint256 public _stopmint = 0;
1813  
1814 
1815     using Counters for Counters.Counter;
1816     Counters.Counter private _tokenIds;
1817 
1818 
1819     constructor(uint256 auctiontier, uint256 airdrop_available, string memory name, string memory symbol, uint256 price, uint256 max_supply, uint16 networkid) ERC721(name, symbol) {
1820         _max_supply = max_supply;
1821         _networkid = networkid;
1822         _price = price;
1823         _airdrop_available = airdrop_available;
1824         _auctiontier = auctiontier;
1825         if (_networkid == 1) {
1826             _baseURI = string(abi.encodePacked("http://metadata.miragegallery.com/api/v1/nfts/"));
1827         } else {
1828             _baseURI = string(abi.encodePacked("http://metadata.miragegallery.com/api/v1/nfts/"));
1829         }
1830         _setBaseURI(_baseURI);
1831     }
1832 
1833     function withdraw() public onlyOwner {
1834         uint balance = address(this).balance;
1835         msg.sender.transfer(balance);
1836     }
1837 
1838 
1839     function baseTokenURI() public view returns (string memory) {
1840         return _baseURI;
1841     }
1842 
1843     function mintToSender(uint numberOfTokens) internal {
1844         require(totalSupply().add(numberOfTokens).add(_airdrop_available) <= _max_supply, "Minting would exceed max supply");
1845         for(uint i = 0; i < numberOfTokens; i++) {
1846             uint mintIndex = totalSupply();
1847             _mint(msg.sender, mintIndex);
1848         }
1849     }
1850     
1851     function mintToAddress(uint numberOfTokens, address address_to_mint) internal {
1852         require(totalSupply().add(numberOfTokens) <= _max_supply, "Minting would exceed max supply");
1853         for(uint i = 0; i < numberOfTokens; i++) {
1854             uint mintIndex = totalSupply();
1855             _mint(address_to_mint, mintIndex);
1856         }
1857     }
1858 
1859     function auction_reserve() public onlyOwner {
1860         require(_auctiontier > 0, "The auction tier has already been minted");
1861         mintToSender(_auctiontier);
1862         _auctiontier = 0;
1863     }
1864     
1865     function stopmint() public onlyOwner {
1866         _stopmint = 1;
1867     }
1868 
1869     function purchase(uint numberOfTokens) public payable {
1870         require(totalSupply() >= 60, "Airdrop has not ended");
1871         require(numberOfTokens <= 10, "Can only purchase a maximum of 10 tokens at a time");
1872         require(_price.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1873         require(totalSupply() < 980, "Minting has ended");
1874         require(_stopmint == 0, "Minting has ended");
1875         mintToSender(numberOfTokens);
1876     }
1877     
1878     function airdrop(address addresstm, uint numberOfTokens) public onlyOwner {
1879         require(_airdrop_available > 0, "No airdrop tokens available");
1880         _airdrop_available -= numberOfTokens;
1881         mintToAddress(numberOfTokens, addresstm);
1882     }
1883 
1884 
1885     function max_supply() public view virtual returns (uint256) {
1886         return _max_supply;
1887     }
1888 }