1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
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
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 
49 /**
50  * @dev Required interface of an ERC721 compliant contract.
51  */
52 interface IERC721 is IERC165 {
53     /**
54      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
60      */
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
65      */
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158       * @dev Safely transfers `tokenId` token from `from` to `to`.
159       *
160       * Requirements:
161       *
162       * - `from` cannot be the zero address.
163       * - `to` cannot be the zero address.
164       * - `tokenId` token must exist and be owned by `from`.
165       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167       *
168       * Emits a {Transfer} event.
169       */
170     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
171 }
172 
173 
174 /**
175  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
176  * @dev See https://eips.ethereum.org/EIPS/eip-721
177  */
178 interface IERC721Metadata is IERC721 {
179 
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token collection symbol.
187      */
188     function symbol() external view returns (string memory);
189 
190     /**
191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
192      */
193     function tokenURI(uint256 tokenId) external view returns (string memory);
194 }
195 
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Enumerable is IERC721 {
202 
203     /**
204      * @dev Returns the total amount of tokens stored by the contract.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
210      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
211      */
212     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
213 
214     /**
215      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
216      * Use along with {totalSupply} to enumerate all tokens.
217      */
218     function tokenByIndex(uint256 index) external view returns (uint256);
219 }
220 
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @title ERC721 token receiver interface
226  * @dev Interface for any contract that wants to support safeTransfers
227  * from ERC721 asset contracts.
228  */
229 interface IERC721Receiver {
230     /**
231      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
232      * by `operator` from `from`, this function is called.
233      *
234      * It must return its Solidity selector to confirm the token transfer.
235      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
236      *
237      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
238      */
239     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
240 }
241 
242 
243 /**
244  * @dev Implementation of the {IERC165} interface.
245  *
246  * Contracts may inherit from this and call {_registerInterface} to declare
247  * their support of an interface.
248  */
249 abstract contract ERC165 is IERC165 {
250     /*
251      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
252      */
253     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
254 
255     /**
256      * @dev Mapping of interface ids to whether or not it's supported.
257      */
258     mapping(bytes4 => bool) private _supportedInterfaces;
259 
260     constructor () {
261         // Derived contracts need only register support for their own interfaces,
262         // we register support for ERC165 itself here
263         _registerInterface(_INTERFACE_ID_ERC165);
264     }
265 
266     /**
267      * @dev See {IERC165-supportsInterface}.
268      *
269      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
270      */
271     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
272         return _supportedInterfaces[interfaceId];
273     }
274 
275     /**
276      * @dev Registers the contract as an implementer of the interface defined by
277      * `interfaceId`. Support of the actual ERC165 interface is automatic and
278      * registering its interface id is not required.
279      *
280      * See {IERC165-supportsInterface}.
281      *
282      * Requirements:
283      *
284      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
285      */
286     function _registerInterface(bytes4 interfaceId) internal virtual {
287         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
288         _supportedInterfaces[interfaceId] = true;
289     }
290 }
291 
292 
293 pragma solidity >=0.6.0 <0.8.0;
294 
295 /**
296  * @dev Wrappers over Solidity's arithmetic operations with added overflow
297  * checks.
298  *
299  * Arithmetic operations in Solidity wrap on overflow. This can easily result
300  * in bugs, because programmers usually assume that an overflow raises an
301  * error, which is the standard behavior in high level programming languages.
302  * `SafeMath` restores this intuition by reverting the transaction when an
303  * operation overflows.
304  *
305  * Using this library instead of the unchecked operations eliminates an entire
306  * class of bugs, so it's recommended to use it always.
307  */
308 library SafeMath {
309     /**
310      * @dev Returns the addition of two unsigned integers, with an overflow flag.
311      *
312      * _Available since v3.4._
313      */
314     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
315         uint256 c = a + b;
316         if (c < a) return (false, 0);
317         return (true, c);
318     }
319 
320     /**
321      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
322      *
323      * _Available since v3.4._
324      */
325     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
326         if (b > a) return (false, 0);
327         return (true, a - b);
328     }
329 
330     /**
331      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
337         // benefit is lost if 'b' is also tested.
338         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
339         if (a == 0) return (true, 0);
340         uint256 c = a * b;
341         if (c / a != b) return (false, 0);
342         return (true, c);
343     }
344 
345     /**
346      * @dev Returns the division of two unsigned integers, with a division by zero flag.
347      *
348      * _Available since v3.4._
349      */
350     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
351         if (b == 0) return (false, 0);
352         return (true, a / b);
353     }
354 
355     /**
356      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
357      *
358      * _Available since v3.4._
359      */
360     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         if (b == 0) return (false, 0);
362         return (true, a % b);
363     }
364 
365     /**
366      * @dev Returns the addition of two unsigned integers, reverting on
367      * overflow.
368      *
369      * Counterpart to Solidity's `+` operator.
370      *
371      * Requirements:
372      *
373      * - Addition cannot overflow.
374      */
375     function add(uint256 a, uint256 b) internal pure returns (uint256) {
376         uint256 c = a + b;
377         require(c >= a, "SafeMath: addition overflow");
378         return c;
379     }
380 
381     /**
382      * @dev Returns the subtraction of two unsigned integers, reverting on
383      * overflow (when the result is negative).
384      *
385      * Counterpart to Solidity's `-` operator.
386      *
387      * Requirements:
388      *
389      * - Subtraction cannot overflow.
390      */
391     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
392         require(b <= a, "SafeMath: subtraction overflow");
393         return a - b;
394     }
395 
396     /**
397      * @dev Returns the multiplication of two unsigned integers, reverting on
398      * overflow.
399      *
400      * Counterpart to Solidity's `*` operator.
401      *
402      * Requirements:
403      *
404      * - Multiplication cannot overflow.
405      */
406     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
407         if (a == 0) return 0;
408         uint256 c = a * b;
409         require(c / a == b, "SafeMath: multiplication overflow");
410         return c;
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers, reverting on
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
426         require(b > 0, "SafeMath: division by zero");
427         return a / b;
428     }
429 
430     /**
431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
432      * reverting when dividing by zero.
433      *
434      * Counterpart to Solidity's `%` operator. This function uses a `revert`
435      * opcode (which leaves remaining gas untouched) while Solidity uses an
436      * invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
443         require(b > 0, "SafeMath: modulo by zero");
444         return a % b;
445     }
446 
447     /**
448      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
449      * overflow (when the result is negative).
450      *
451      * CAUTION: This function is deprecated because it requires allocating memory for the error
452      * message unnecessarily. For custom revert reasons use {trySub}.
453      *
454      * Counterpart to Solidity's `-` operator.
455      *
456      * Requirements:
457      *
458      * - Subtraction cannot overflow.
459      */
460     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
461         require(b <= a, errorMessage);
462         return a - b;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
467      * division by zero. The result is rounded towards zero.
468      *
469      * CAUTION: This function is deprecated because it requires allocating memory for the error
470      * message unnecessarily. For custom revert reasons use {tryDiv}.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
481         require(b > 0, errorMessage);
482         return a / b;
483     }
484 
485     /**
486      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
487      * reverting with custom message when dividing by zero.
488      *
489      * CAUTION: This function is deprecated because it requires allocating memory for the error
490      * message unnecessarily. For custom revert reasons use {tryMod}.
491      *
492      * Counterpart to Solidity's `%` operator. This function uses a `revert`
493      * opcode (which leaves remaining gas untouched) while Solidity uses an
494      * invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b > 0, errorMessage);
502         return a % b;
503     }
504 }
505 
506 
507 /**
508  * @dev Collection of functions related to the address type
509  */
510 library Address {
511     /**
512      * @dev Returns true if `account` is a contract.
513      *
514      * [IMPORTANT]
515      * ====
516      * It is unsafe to assume that an address for which this function returns
517      * false is an externally-owned account (EOA) and not a contract.
518      *
519      * Among others, `isContract` will return false for the following
520      * types of addresses:
521      *
522      *  - an externally-owned account
523      *  - a contract in construction
524      *  - an address where a contract will be created
525      *  - an address where a contract lived, but was destroyed
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // This method relies on extcodesize, which returns 0 for contracts in
530         // construction, since the code is only stored at the end of the
531         // constructor execution.
532 
533         uint256 size;
534         // solhint-disable-next-line no-inline-assembly
535         assembly { size := extcodesize(account) }
536         return size > 0;
537     }
538 
539     /**
540      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
541      * `recipient`, forwarding all available gas and reverting on errors.
542      *
543      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
544      * of certain opcodes, possibly making contracts go over the 2300 gas limit
545      * imposed by `transfer`, making them unable to receive funds via
546      * `transfer`. {sendValue} removes this limitation.
547      *
548      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
549      *
550      * IMPORTANT: because control is transferred to `recipient`, care must be
551      * taken to not create reentrancy vulnerabilities. Consider using
552      * {ReentrancyGuard} or the
553      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
554      */
555     function sendValue(address payable recipient, uint256 amount) internal {
556         require(address(this).balance >= amount, "Address: insufficient balance");
557 
558         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
559         (bool success, ) = recipient.call{ value: amount }("");
560         require(success, "Address: unable to send value, recipient may have reverted");
561     }
562 
563     /**
564      * @dev Performs a Solidity function call using a low level `call`. A
565      * plain`call` is an unsafe replacement for a function call: use this
566      * function instead.
567      *
568      * If `target` reverts with a revert reason, it is bubbled up by this
569      * function (like regular Solidity function calls).
570      *
571      * Returns the raw returned data. To convert to the expected return value,
572      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
573      *
574      * Requirements:
575      *
576      * - `target` must be a contract.
577      * - calling `target` with `data` must not revert.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
582       return functionCall(target, data, "Address: low-level call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
587      * `errorMessage` as a fallback revert reason when `target` reverts.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, 0, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but also transferring `value` wei to `target`.
598      *
599      * Requirements:
600      *
601      * - the calling contract must have an ETH balance of at least `value`.
602      * - the called Solidity function must be `payable`.
603      *
604      * _Available since v3.1._
605      */
606     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
607         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
612      * with `errorMessage` as a fallback revert reason when `target` reverts.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
617         require(address(this).balance >= value, "Address: insufficient balance for call");
618         require(isContract(target), "Address: call to non-contract");
619 
620         // solhint-disable-next-line avoid-low-level-calls
621         (bool success, bytes memory returndata) = target.call{ value: value }(data);
622         return _verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
632         return functionStaticCall(target, data, "Address: low-level static call failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
637      * but performing a static call.
638      *
639      * _Available since v3.3._
640      */
641     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
642         require(isContract(target), "Address: static call to non-contract");
643 
644         // solhint-disable-next-line avoid-low-level-calls
645         (bool success, bytes memory returndata) = target.staticcall(data);
646         return _verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a delegate call.
652      *
653      * _Available since v3.4._
654      */
655     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
656         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
666         require(isContract(target), "Address: delegate call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.delegatecall(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
674         if (success) {
675             return returndata;
676         } else {
677             // Look for revert reason and bubble it up if present
678             if (returndata.length > 0) {
679                 // The easiest way to bubble the revert reason is using memory via assembly
680 
681                 // solhint-disable-next-line no-inline-assembly
682                 assembly {
683                     let returndata_size := mload(returndata)
684                     revert(add(32, returndata), returndata_size)
685                 }
686             } else {
687                 revert(errorMessage);
688             }
689         }
690     }
691 }
692 
693 
694 pragma solidity >=0.6.0 <0.8.0;
695 
696 /**
697  * @dev Library for managing
698  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
699  * types.
700  *
701  * Sets have the following properties:
702  *
703  * - Elements are added, removed, and checked for existence in constant time
704  * (O(1)).
705  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
706  *
707  * ```
708  * contract Example {
709  *     // Add the library methods
710  *     using EnumerableSet for EnumerableSet.AddressSet;
711  *
712  *     // Declare a set state variable
713  *     EnumerableSet.AddressSet private mySet;
714  * }
715  * ```
716  *
717  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
718  * and `uint256` (`UintSet`) are supported.
719  */
720 library EnumerableSet {
721     // To implement this library for multiple types with as little code
722     // repetition as possible, we write it in terms of a generic Set type with
723     // bytes32 values.
724     // The Set implementation uses private functions, and user-facing
725     // implementations (such as AddressSet) are just wrappers around the
726     // underlying Set.
727     // This means that we can only create new EnumerableSets for types that fit
728     // in bytes32.
729 
730     struct Set {
731         // Storage of set values
732         bytes32[] _values;
733 
734         // Position of the value in the `values` array, plus 1 because index 0
735         // means a value is not in the set.
736         mapping (bytes32 => uint256) _indexes;
737     }
738 
739     /**
740      * @dev Add a value to a set. O(1).
741      *
742      * Returns true if the value was added to the set, that is if it was not
743      * already present.
744      */
745     function _add(Set storage set, bytes32 value) private returns (bool) {
746         if (!_contains(set, value)) {
747             set._values.push(value);
748             // The value is stored at length-1, but we add 1 to all indexes
749             // and use 0 as a sentinel value
750             set._indexes[value] = set._values.length;
751             return true;
752         } else {
753             return false;
754         }
755     }
756 
757     /**
758      * @dev Removes a value from a set. O(1).
759      *
760      * Returns true if the value was removed from the set, that is if it was
761      * present.
762      */
763     function _remove(Set storage set, bytes32 value) private returns (bool) {
764         // We read and store the value's index to prevent multiple reads from the same storage slot
765         uint256 valueIndex = set._indexes[value];
766 
767         if (valueIndex != 0) { // Equivalent to contains(set, value)
768             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
769             // the array, and then remove the last element (sometimes called as 'swap and pop').
770             // This modifies the order of the array, as noted in {at}.
771 
772             uint256 toDeleteIndex = valueIndex - 1;
773             uint256 lastIndex = set._values.length - 1;
774 
775             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
776             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
777 
778             bytes32 lastvalue = set._values[lastIndex];
779 
780             // Move the last value to the index where the value to delete is
781             set._values[toDeleteIndex] = lastvalue;
782             // Update the index for the moved value
783             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
784 
785             // Delete the slot where the moved value was stored
786             set._values.pop();
787 
788             // Delete the index for the deleted slot
789             delete set._indexes[value];
790 
791             return true;
792         } else {
793             return false;
794         }
795     }
796 
797     /**
798      * @dev Returns true if the value is in the set. O(1).
799      */
800     function _contains(Set storage set, bytes32 value) private view returns (bool) {
801         return set._indexes[value] != 0;
802     }
803 
804     /**
805      * @dev Returns the number of values on the set. O(1).
806      */
807     function _length(Set storage set) private view returns (uint256) {
808         return set._values.length;
809     }
810 
811    /**
812     * @dev Returns the value stored at position `index` in the set. O(1).
813     *
814     * Note that there are no guarantees on the ordering of values inside the
815     * array, and it may change when more values are added or removed.
816     *
817     * Requirements:
818     *
819     * - `index` must be strictly less than {length}.
820     */
821     function _at(Set storage set, uint256 index) private view returns (bytes32) {
822         require(set._values.length > index, "EnumerableSet: index out of bounds");
823         return set._values[index];
824     }
825 
826     // Bytes32Set
827 
828     struct Bytes32Set {
829         Set _inner;
830     }
831 
832     /**
833      * @dev Add a value to a set. O(1).
834      *
835      * Returns true if the value was added to the set, that is if it was not
836      * already present.
837      */
838     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
839         return _add(set._inner, value);
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the value was removed from the set, that is if it was
846      * present.
847      */
848     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
849         return _remove(set._inner, value);
850     }
851 
852     /**
853      * @dev Returns true if the value is in the set. O(1).
854      */
855     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
856         return _contains(set._inner, value);
857     }
858 
859     /**
860      * @dev Returns the number of values in the set. O(1).
861      */
862     function length(Bytes32Set storage set) internal view returns (uint256) {
863         return _length(set._inner);
864     }
865 
866    /**
867     * @dev Returns the value stored at position `index` in the set. O(1).
868     *
869     * Note that there are no guarantees on the ordering of values inside the
870     * array, and it may change when more values are added or removed.
871     *
872     * Requirements:
873     *
874     * - `index` must be strictly less than {length}.
875     */
876     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
877         return _at(set._inner, index);
878     }
879 
880     // AddressSet
881 
882     struct AddressSet {
883         Set _inner;
884     }
885 
886     /**
887      * @dev Add a value to a set. O(1).
888      *
889      * Returns true if the value was added to the set, that is if it was not
890      * already present.
891      */
892     function add(AddressSet storage set, address value) internal returns (bool) {
893         return _add(set._inner, bytes32(uint256(uint160(value))));
894     }
895 
896     /**
897      * @dev Removes a value from a set. O(1).
898      *
899      * Returns true if the value was removed from the set, that is if it was
900      * present.
901      */
902     function remove(AddressSet storage set, address value) internal returns (bool) {
903         return _remove(set._inner, bytes32(uint256(uint160(value))));
904     }
905 
906     /**
907      * @dev Returns true if the value is in the set. O(1).
908      */
909     function contains(AddressSet storage set, address value) internal view returns (bool) {
910         return _contains(set._inner, bytes32(uint256(uint160(value))));
911     }
912 
913     /**
914      * @dev Returns the number of values in the set. O(1).
915      */
916     function length(AddressSet storage set) internal view returns (uint256) {
917         return _length(set._inner);
918     }
919 
920    /**
921     * @dev Returns the value stored at position `index` in the set. O(1).
922     *
923     * Note that there are no guarantees on the ordering of values inside the
924     * array, and it may change when more values are added or removed.
925     *
926     * Requirements:
927     *
928     * - `index` must be strictly less than {length}.
929     */
930     function at(AddressSet storage set, uint256 index) internal view returns (address) {
931         return address(uint160(uint256(_at(set._inner, index))));
932     }
933 
934 
935     // UintSet
936 
937     struct UintSet {
938         Set _inner;
939     }
940 
941     /**
942      * @dev Add a value to a set. O(1).
943      *
944      * Returns true if the value was added to the set, that is if it was not
945      * already present.
946      */
947     function add(UintSet storage set, uint256 value) internal returns (bool) {
948         return _add(set._inner, bytes32(value));
949     }
950 
951     /**
952      * @dev Removes a value from a set. O(1).
953      *
954      * Returns true if the value was removed from the set, that is if it was
955      * present.
956      */
957     function remove(UintSet storage set, uint256 value) internal returns (bool) {
958         return _remove(set._inner, bytes32(value));
959     }
960 
961     /**
962      * @dev Returns true if the value is in the set. O(1).
963      */
964     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
965         return _contains(set._inner, bytes32(value));
966     }
967 
968     /**
969      * @dev Returns the number of values on the set. O(1).
970      */
971     function length(UintSet storage set) internal view returns (uint256) {
972         return _length(set._inner);
973     }
974 
975    /**
976     * @dev Returns the value stored at position `index` in the set. O(1).
977     *
978     * Note that there are no guarantees on the ordering of values inside the
979     * array, and it may change when more values are added or removed.
980     *
981     * Requirements:
982     *
983     * - `index` must be strictly less than {length}.
984     */
985     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
986         return uint256(_at(set._inner, index));
987     }
988 }
989 
990 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
991 
992 
993 
994 pragma solidity >=0.6.0 <0.8.0;
995 
996 /**
997  * @dev Library for managing an enumerable variant of Solidity's
998  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
999  * type.
1000  *
1001  * Maps have the following properties:
1002  *
1003  * - Entries are added, removed, and checked for existence in constant time
1004  * (O(1)).
1005  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1006  *
1007  * ```
1008  * contract Example {
1009  *     // Add the library methods
1010  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1011  *
1012  *     // Declare a set state variable
1013  *     EnumerableMap.UintToAddressMap private myMap;
1014  * }
1015  * ```
1016  *
1017  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1018  * supported.
1019  */
1020 library EnumerableMap {
1021     // To implement this library for multiple types with as little code
1022     // repetition as possible, we write it in terms of a generic Map type with
1023     // bytes32 keys and values.
1024     // The Map implementation uses private functions, and user-facing
1025     // implementations (such as Uint256ToAddressMap) are just wrappers around
1026     // the underlying Map.
1027     // This means that we can only create new EnumerableMaps for types that fit
1028     // in bytes32.
1029 
1030     struct MapEntry {
1031         bytes32 _key;
1032         bytes32 _value;
1033     }
1034 
1035     struct Map {
1036         // Storage of map keys and values
1037         MapEntry[] _entries;
1038 
1039         // Position of the entry defined by a key in the `entries` array, plus 1
1040         // because index 0 means a key is not in the map.
1041         mapping (bytes32 => uint256) _indexes;
1042     }
1043 
1044     /**
1045      * @dev Adds a key-value pair to a map, or updates the value for an existing
1046      * key. O(1).
1047      *
1048      * Returns true if the key was added to the map, that is if it was not
1049      * already present.
1050      */
1051     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1052         // We read and store the key's index to prevent multiple reads from the same storage slot
1053         uint256 keyIndex = map._indexes[key];
1054 
1055         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1056             map._entries.push(MapEntry({ _key: key, _value: value }));
1057             // The entry is stored at length-1, but we add 1 to all indexes
1058             // and use 0 as a sentinel value
1059             map._indexes[key] = map._entries.length;
1060             return true;
1061         } else {
1062             map._entries[keyIndex - 1]._value = value;
1063             return false;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Removes a key-value pair from a map. O(1).
1069      *
1070      * Returns true if the key was removed from the map, that is if it was present.
1071      */
1072     function _remove(Map storage map, bytes32 key) private returns (bool) {
1073         // We read and store the key's index to prevent multiple reads from the same storage slot
1074         uint256 keyIndex = map._indexes[key];
1075 
1076         if (keyIndex != 0) { // Equivalent to contains(map, key)
1077             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1078             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1079             // This modifies the order of the array, as noted in {at}.
1080 
1081             uint256 toDeleteIndex = keyIndex - 1;
1082             uint256 lastIndex = map._entries.length - 1;
1083 
1084             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1085             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1086 
1087             MapEntry storage lastEntry = map._entries[lastIndex];
1088 
1089             // Move the last entry to the index where the entry to delete is
1090             map._entries[toDeleteIndex] = lastEntry;
1091             // Update the index for the moved entry
1092             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1093 
1094             // Delete the slot where the moved entry was stored
1095             map._entries.pop();
1096 
1097             // Delete the index for the deleted slot
1098             delete map._indexes[key];
1099 
1100             return true;
1101         } else {
1102             return false;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns true if the key is in the map. O(1).
1108      */
1109     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1110         return map._indexes[key] != 0;
1111     }
1112 
1113     /**
1114      * @dev Returns the number of key-value pairs in the map. O(1).
1115      */
1116     function _length(Map storage map) private view returns (uint256) {
1117         return map._entries.length;
1118     }
1119 
1120    /**
1121     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1122     *
1123     * Note that there are no guarantees on the ordering of entries inside the
1124     * array, and it may change when more entries are added or removed.
1125     *
1126     * Requirements:
1127     *
1128     * - `index` must be strictly less than {length}.
1129     */
1130     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1131         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1132 
1133         MapEntry storage entry = map._entries[index];
1134         return (entry._key, entry._value);
1135     }
1136 
1137     /**
1138      * @dev Tries to returns the value associated with `key`.  O(1).
1139      * Does not revert if `key` is not in the map.
1140      */
1141     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1142         uint256 keyIndex = map._indexes[key];
1143         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1144         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1145     }
1146 
1147     /**
1148      * @dev Returns the value associated with `key`.  O(1).
1149      *
1150      * Requirements:
1151      *
1152      * - `key` must be in the map.
1153      */
1154     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1155         uint256 keyIndex = map._indexes[key];
1156         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1157         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1158     }
1159 
1160     /**
1161      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1162      *
1163      * CAUTION: This function is deprecated because it requires allocating memory for the error
1164      * message unnecessarily. For custom revert reasons use {_tryGet}.
1165      */
1166     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1167         uint256 keyIndex = map._indexes[key];
1168         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1169         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1170     }
1171 
1172     // UintToAddressMap
1173 
1174     struct UintToAddressMap {
1175         Map _inner;
1176     }
1177 
1178     /**
1179      * @dev Adds a key-value pair to a map, or updates the value for an existing
1180      * key. O(1).
1181      *
1182      * Returns true if the key was added to the map, that is if it was not
1183      * already present.
1184      */
1185     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1186         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1187     }
1188 
1189     /**
1190      * @dev Removes a value from a set. O(1).
1191      *
1192      * Returns true if the key was removed from the map, that is if it was present.
1193      */
1194     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1195         return _remove(map._inner, bytes32(key));
1196     }
1197 
1198     /**
1199      * @dev Returns true if the key is in the map. O(1).
1200      */
1201     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1202         return _contains(map._inner, bytes32(key));
1203     }
1204 
1205     /**
1206      * @dev Returns the number of elements in the map. O(1).
1207      */
1208     function length(UintToAddressMap storage map) internal view returns (uint256) {
1209         return _length(map._inner);
1210     }
1211 
1212    /**
1213     * @dev Returns the element stored at position `index` in the set. O(1).
1214     * Note that there are no guarantees on the ordering of values inside the
1215     * array, and it may change when more values are added or removed.
1216     *
1217     * Requirements:
1218     *
1219     * - `index` must be strictly less than {length}.
1220     */
1221     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1222         (bytes32 key, bytes32 value) = _at(map._inner, index);
1223         return (uint256(key), address(uint160(uint256(value))));
1224     }
1225 
1226     /**
1227      * @dev Tries to returns the value associated with `key`.  O(1).
1228      * Does not revert if `key` is not in the map.
1229      *
1230      * _Available since v3.4._
1231      */
1232     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1233         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1234         return (success, address(uint160(uint256(value))));
1235     }
1236 
1237     /**
1238      * @dev Returns the value associated with `key`.  O(1).
1239      *
1240      * Requirements:
1241      *
1242      * - `key` must be in the map.
1243      */
1244     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1245         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1246     }
1247 
1248     /**
1249      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1250      *
1251      * CAUTION: This function is deprecated because it requires allocating memory for the error
1252      * message unnecessarily. For custom revert reasons use {tryGet}.
1253      */
1254     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1255         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1256     }
1257 }
1258 
1259 
1260 /**
1261  * @dev String operations.
1262  */
1263 library Strings {
1264     /**
1265      * @dev Converts a `uint256` to its ASCII `string` representation.
1266      */
1267     function toString(uint256 value) internal pure returns (string memory) {
1268         // Inspired by OraclizeAPI's implementation - MIT licence
1269         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1270 
1271         if (value == 0) {
1272             return "0";
1273         }
1274         uint256 temp = value;
1275         uint256 digits;
1276         while (temp != 0) {
1277             digits++;
1278             temp /= 10;
1279         }
1280         bytes memory buffer = new bytes(digits);
1281         uint256 index = digits - 1;
1282         temp = value;
1283         while (temp != 0) {
1284             buffer[index--] = bytes1(uint8(48 + temp % 10));
1285             temp /= 10;
1286         }
1287         return string(buffer);
1288     }
1289 }
1290 
1291 
1292 /**
1293  * @title ERC721 Non-Fungible Token Standard basic implementation
1294  * @dev see https://eips.ethereum.org/EIPS/eip-721
1295  */
1296 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1297     using SafeMath for uint256;
1298     using Address for address;
1299     using EnumerableSet for EnumerableSet.UintSet;
1300     using EnumerableMap for EnumerableMap.UintToAddressMap;
1301     using Strings for uint256;
1302 
1303     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1304     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1305     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1306 
1307     // Mapping from holder address to their (enumerable) set of owned tokens
1308     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1309 
1310     // Enumerable mapping from token ids to their owners
1311     EnumerableMap.UintToAddressMap private _tokenOwners;
1312 
1313     // Mapping from token ID to approved address
1314     mapping (uint256 => address) private _tokenApprovals;
1315 
1316     // Mapping from owner to operator approvals
1317     mapping (address => mapping (address => bool)) private _operatorApprovals;
1318 
1319     // Token name
1320     string private _name;
1321 
1322     // Token symbol
1323     string private _symbol;
1324 
1325     // Optional mapping for token URIs
1326     mapping (uint256 => string) private _tokenURIs;
1327 
1328     // Base URI
1329     string private _baseURI;
1330 
1331     /*
1332      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1333      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1334      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1335      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1336      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1337      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1338      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1339      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1340      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1341      *
1342      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1343      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1344      */
1345     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1346 
1347     /*
1348      *     bytes4(keccak256('name()')) == 0x06fdde03
1349      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1350      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1351      *
1352      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1353      */
1354     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1355 
1356     /*
1357      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1358      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1359      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1360      *
1361      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1362      */
1363     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1364 
1365     /**
1366      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1367      */
1368     constructor (string memory name_, string memory symbol_) {
1369         _name = name_;
1370         _symbol = symbol_;
1371 
1372         // register the supported interfaces to conform to ERC721 via ERC165
1373         _registerInterface(_INTERFACE_ID_ERC721);
1374         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1375         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-balanceOf}.
1380      */
1381     function balanceOf(address owner) public view virtual override returns (uint256) {
1382         require(owner != address(0), "ERC721: balance query for the zero address");
1383         return _holderTokens[owner].length();
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-ownerOf}.
1388      */
1389     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1390         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Metadata-name}.
1395      */
1396     function name() public view virtual override returns (string memory) {
1397         return _name;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721Metadata-symbol}.
1402      */
1403     function symbol() public view virtual override returns (string memory) {
1404         return _symbol;
1405     }
1406 
1407     /**
1408      * @dev See {IERC721Metadata-tokenURI}.
1409      */
1410     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1411         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1412 
1413         string memory _tokenURI = _tokenURIs[tokenId];
1414         string memory base = baseURI();
1415 
1416         // If there is no base URI, return the token URI.
1417         if (bytes(base).length == 0) {
1418             return _tokenURI;
1419         }
1420         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1421         if (bytes(_tokenURI).length > 0) {
1422             return string(abi.encodePacked(base, _tokenURI));
1423         }
1424         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1425         return string(abi.encodePacked(base, tokenId.toString()));
1426     }
1427 
1428     /**
1429     * @dev Returns the base URI set via {_setBaseURI}. This will be
1430     * automatically added as a prefix in {tokenURI} to each token's URI, or
1431     * to the token ID if no specific URI is set for that token ID.
1432     */
1433     function baseURI() public view virtual returns (string memory) {
1434         return _baseURI;
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1439      */
1440     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1441         return _holderTokens[owner].at(index);
1442     }
1443 
1444     /**
1445      * @dev See {IERC721Enumerable-totalSupply}.
1446      */
1447     function totalSupply() public view virtual override returns (uint256) {
1448         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1449         return _tokenOwners.length();
1450     }
1451 
1452     /**
1453      * @dev See {IERC721Enumerable-tokenByIndex}.
1454      */
1455     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1456         (uint256 tokenId, ) = _tokenOwners.at(index);
1457         return tokenId;
1458     }
1459 
1460     /**
1461      * @dev See {IERC721-approve}.
1462      */
1463     function approve(address to, uint256 tokenId) public virtual override {
1464         address owner = ERC721.ownerOf(tokenId);
1465         require(to != owner, "ERC721: approval to current owner");
1466 
1467         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1468             "ERC721: approve caller is not owner nor approved for all"
1469         );
1470 
1471         _approve(to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-getApproved}.
1476      */
1477     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1478         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1479 
1480         return _tokenApprovals[tokenId];
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-setApprovalForAll}.
1485      */
1486     function setApprovalForAll(address operator, bool approved) public virtual override {
1487         require(operator != _msgSender(), "ERC721: approve to caller");
1488 
1489         _operatorApprovals[_msgSender()][operator] = approved;
1490         emit ApprovalForAll(_msgSender(), operator, approved);
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-isApprovedForAll}.
1495      */
1496     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1497         return _operatorApprovals[owner][operator];
1498     }
1499 
1500     /**
1501      * @dev See {IERC721-transferFrom}.
1502      */
1503     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1504         //solhint-disable-next-line max-line-length
1505         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1506 
1507         _transfer(from, to, tokenId);
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-safeTransferFrom}.
1512      */
1513     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1514         safeTransferFrom(from, to, tokenId, "");
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-safeTransferFrom}.
1519      */
1520     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1521         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1522         _safeTransfer(from, to, tokenId, _data);
1523     }
1524 
1525     /**
1526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1528      *
1529      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1530      *
1531      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1532      * implement alternative mechanisms to perform token transfer, such as signature-based.
1533      *
1534      * Requirements:
1535      *
1536      * - `from` cannot be the zero address.
1537      * - `to` cannot be the zero address.
1538      * - `tokenId` token must exist and be owned by `from`.
1539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1540      *
1541      * Emits a {Transfer} event.
1542      */
1543     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1544         _transfer(from, to, tokenId);
1545         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1546     }
1547 
1548     /**
1549      * @dev Returns whether `tokenId` exists.
1550      *
1551      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1552      *
1553      * Tokens start existing when they are minted (`_mint`),
1554      * and stop existing when they are burned (`_burn`).
1555      */
1556     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1557         return _tokenOwners.contains(tokenId);
1558     }
1559 
1560     /**
1561      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1562      *
1563      * Requirements:
1564      *
1565      * - `tokenId` must exist.
1566      */
1567     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1568         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1569         address owner = ERC721.ownerOf(tokenId);
1570         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1571     }
1572 
1573     /**
1574      * @dev Safely mints `tokenId` and transfers it to `to`.
1575      *
1576      * Requirements:
1577      d*
1578      * - `tokenId` must not exist.
1579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function _safeMint(address to, uint256 tokenId) internal virtual {
1584         _safeMint(to, tokenId, "");
1585     }
1586 
1587     /**
1588      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1589      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1590      */
1591     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1592         _mint(to, tokenId);
1593         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1594     }
1595 
1596     /**
1597      * @dev Mints `tokenId` and transfers it to `to`.
1598      *
1599      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1600      *
1601      * Requirements:
1602      *
1603      * - `tokenId` must not exist.
1604      * - `to` cannot be the zero address.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _mint(address to, uint256 tokenId) internal virtual {
1609         require(to != address(0), "ERC721: mint to the zero address");
1610         require(!_exists(tokenId), "ERC721: token already minted");
1611 
1612         _beforeTokenTransfer(address(0), to, tokenId);
1613 
1614         _holderTokens[to].add(tokenId);
1615 
1616         _tokenOwners.set(tokenId, to);
1617 
1618         emit Transfer(address(0), to, tokenId);
1619     }
1620 
1621     /**
1622      * @dev Destroys `tokenId`.
1623      * The approval is cleared when the token is burned.
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must exist.
1628      *
1629      * Emits a {Transfer} event.
1630      */
1631     function _burn(uint256 tokenId) internal virtual {
1632         address owner = ERC721.ownerOf(tokenId); // internal owner
1633 
1634         _beforeTokenTransfer(owner, address(0), tokenId);
1635 
1636         // Clear approvals
1637         _approve(address(0), tokenId);
1638 
1639         // Clear metadata (if any)
1640         if (bytes(_tokenURIs[tokenId]).length != 0) {
1641             delete _tokenURIs[tokenId];
1642         }
1643 
1644         _holderTokens[owner].remove(tokenId);
1645 
1646         _tokenOwners.remove(tokenId);
1647 
1648         emit Transfer(owner, address(0), tokenId);
1649     }
1650 
1651     /**
1652      * @dev Transfers `tokenId` from `from` to `to`.
1653      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1654      *
1655      * Requirements:
1656      *
1657      * - `to` cannot be the zero address.
1658      * - `tokenId` token must be owned by `from`.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1663         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1664         require(to != address(0), "ERC721: transfer to the zero address");
1665 
1666         _beforeTokenTransfer(from, to, tokenId);
1667 
1668         // Clear approvals from the previous owner
1669         _approve(address(0), tokenId);
1670 
1671         _holderTokens[from].remove(tokenId);
1672         _holderTokens[to].add(tokenId);
1673 
1674         _tokenOwners.set(tokenId, to);
1675 
1676         emit Transfer(from, to, tokenId);
1677     }
1678 
1679     /**
1680      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      */
1686     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1687         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1688         _tokenURIs[tokenId] = _tokenURI;
1689     }
1690 
1691     /**
1692      * @dev Internal function to set the base URI for all token IDs. It is
1693      * automatically added as a prefix to the value returned in {tokenURI},
1694      * or to the token ID if {tokenURI} is empty.
1695      */
1696     function _setBaseURI(string memory baseURI_) internal virtual {
1697         _baseURI = baseURI_;
1698     }
1699 
1700     /**
1701      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1702      * The call is not executed if the target address is not a contract.
1703      *
1704      * @param from address representing the previous owner of the given token ID
1705      * @param to target address that will receive the tokens
1706      * @param tokenId uint256 ID of the token to be transferred
1707      * @param _data bytes optional data to send along with the call
1708      * @return bool whether the call correctly returned the expected magic value
1709      */
1710     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1711         private returns (bool)
1712     {
1713         if (!to.isContract()) {
1714             return true;
1715         }
1716         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1717             IERC721Receiver(to).onERC721Received.selector,
1718             _msgSender(),
1719             from,
1720             tokenId,
1721             _data
1722         ), "ERC721: transfer to non ERC721Receiver implementer");
1723         bytes4 retval = abi.decode(returndata, (bytes4));
1724         return (retval == _ERC721_RECEIVED);
1725     }
1726 
1727     /**
1728      * @dev Approve `to` to operate on `tokenId`
1729      *
1730      * Emits an {Approval} event.
1731      */
1732     function _approve(address to, uint256 tokenId) internal virtual {
1733         _tokenApprovals[tokenId] = to;
1734         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1735     }
1736 
1737     /**
1738      * @dev Hook that is called before any token transfer. This includes minting
1739      * and burning.
1740      *
1741      * Calling conditions:
1742      *
1743      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1744      * transferred to `to`.
1745      * - When `from` is zero, `tokenId` will be minted for `to`.
1746      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1747      * - `from` cannot be the zero address.
1748      * - `to` cannot be the zero address.
1749      *
1750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1751      */
1752     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1753 }
1754 
1755 
1756 /**
1757  * @dev Contract module which provides a basic access control mechanism, where
1758  * there is an account (an owner) that can be granted exclusive access to
1759  * specific functions.
1760  *
1761  * By default, the owner account will be the one that deploys the contract. This
1762  * can later be changed with {transferOwnership}.
1763  *
1764  * This module is used through inheritance. It will make available the modifier
1765  * `onlyOwner`, which can be applied to your functions to restrict their use to
1766  * the owner.
1767  */
1768 abstract contract Ownable is Context {
1769     address private _owner;
1770 
1771     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1772 
1773     /**
1774      * @dev Initializes the contract setting the deployer as the initial owner.
1775      */
1776     constructor () {
1777         address msgSender = _msgSender();
1778         _owner = msgSender;
1779         emit OwnershipTransferred(address(0), msgSender);
1780     }
1781 
1782     /**
1783      * @dev Returns the address of the current owner.
1784      */
1785     function owner() public view virtual returns (address) {
1786         return _owner;
1787     }
1788 
1789     /**
1790      * @dev Throws if called by any account other than the owner.
1791      */
1792     modifier onlyOwner() {
1793         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1794         _;
1795     }
1796 
1797     /**
1798      * @dev Leaves the contract without owner. It will not be possible to call
1799      * `onlyOwner` functions anymore. Can only be called by the current owner.
1800      *
1801      * NOTE: Renouncing ownership will leave the contract without an owner,
1802      * thereby removing any functionality that is only available to the owner.
1803      */
1804     function renounceOwnership() public virtual onlyOwner {
1805         emit OwnershipTransferred(_owner, address(0));
1806         _owner = address(0);
1807     }
1808 
1809     /**
1810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1811      * Can only be called by the current owner.
1812      */
1813     function transferOwnership(address newOwner) public virtual onlyOwner {
1814         require(newOwner != address(0), "Ownable: new owner is the zero address");
1815         emit OwnershipTransferred(_owner, newOwner);
1816         _owner = newOwner;
1817     }
1818 }
1819 
1820 /**
1821  * @title contract
1822  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1823  */
1824 contract Unc0vered is ERC721, Ownable {
1825     using SafeMath for uint256;
1826 
1827     uint256 public mintPrice;
1828     uint256 public maxPublicToMint;
1829     uint256 public maxPresaleToMint;
1830     uint256 public maxNftSupply;
1831     uint256 public maxPresaleSupply;
1832 
1833     mapping(address => uint256) public presaleNumOfUser;
1834     mapping(address => uint256) public publicNumOfUser;
1835 
1836     bool public presaleAllowed;
1837     bool public publicSaleAllowed;    
1838     uint256 public presaleStartTimestamp;
1839     uint256 public publicSaleStartTimestamp;    
1840 
1841     mapping(address => bool) private presaleWhitelist;
1842 
1843     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1844         maxNftSupply = 10000;
1845         maxPresaleSupply = 3500;
1846         mintPrice = 0.2 ether;
1847         maxPublicToMint = 5;
1848         maxPresaleToMint = 2;
1849 
1850         presaleAllowed = false;
1851         publicSaleAllowed = false;
1852 
1853         presaleStartTimestamp = 0;
1854         publicSaleStartTimestamp = 0;        
1855     }
1856 
1857     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1858         uint256 tokenCount = balanceOf(_owner);
1859         if (tokenCount == 0) {
1860             return new uint256[](0);
1861         } else {
1862             uint256[] memory result = new uint256[](tokenCount);
1863             for (uint256 index; index < tokenCount; index++) {
1864                 result[index] = tokenOfOwnerByIndex(_owner, index);
1865             }
1866             return result;
1867         }
1868     }
1869 
1870     function exists(uint256 _tokenId) public view returns (bool) {
1871         return _exists(_tokenId);
1872     }
1873 
1874     function isPresaleLive() public view returns(bool) {
1875         uint256 curTimestamp = block.timestamp;
1876         if (presaleAllowed && presaleStartTimestamp <= curTimestamp && totalSupply() < maxPresaleSupply) {
1877             return true;
1878         }
1879         return false;
1880     }
1881 
1882     function isPublicSaleLive() public view returns(bool) {
1883         uint256 curTimestamp = block.timestamp;
1884         if (publicSaleAllowed && publicSaleStartTimestamp <= curTimestamp) {
1885             return true;
1886         }
1887         return false;
1888     }
1889 
1890     function setMintPrice(uint256 _price) external onlyOwner {
1891         mintPrice = _price;
1892     }
1893 
1894     function setMaxNftSupply(uint256 _maxValue) external onlyOwner {
1895         maxNftSupply = _maxValue;
1896     }
1897 
1898     function setMaxPresaleSupply(uint256 _maxValue) external onlyOwner {
1899         maxPresaleSupply = _maxValue;
1900     }
1901 
1902     function setMaxPresaleToMint(uint256 _maxValue) external onlyOwner {
1903         maxPresaleToMint = _maxValue;
1904     }
1905 
1906     function setMaxPublicToMint(uint256 _maxValue) external onlyOwner {
1907         maxPublicToMint = _maxValue;
1908     }
1909 
1910     function reserveMannequins(address _to, uint256 _numberOfTokens) external onlyOwner {
1911         uint256 supply = totalSupply();
1912         require(supply + _numberOfTokens <= maxNftSupply, "Cannot reserve more than max supply");
1913         uint256 i;
1914         
1915         for (i = 0; i < _numberOfTokens; i++) {
1916             _safeMint(_to, supply + i);
1917         }
1918     }
1919 
1920     function setBaseURI(string memory baseURI) external onlyOwner {
1921         _setBaseURI(baseURI);
1922     }
1923 
1924     function updatePresaleState(bool newStatus, uint256 timeDiff) external onlyOwner {
1925         uint256 curTimestamp = block.timestamp;
1926         presaleAllowed = newStatus;
1927         presaleStartTimestamp = curTimestamp.add(timeDiff);
1928     }
1929 
1930     function updatePublicSaleState(bool newStatus, uint256 timeDiff) external onlyOwner {
1931         uint256 curTimestamp = block.timestamp;
1932         publicSaleAllowed = newStatus;
1933         publicSaleStartTimestamp = curTimestamp.add(timeDiff);
1934     }
1935 
1936     function addToPresale(address[] calldata addresses) external onlyOwner {
1937         for (uint256 i = 0; i < addresses.length; i++) {
1938             presaleWhitelist[addresses[i]] = true;
1939         }
1940     }
1941 
1942     function removeToPresale(address[] calldata addresses) external onlyOwner {
1943         for (uint256 i = 0; i < addresses.length; i++) {
1944             presaleWhitelist[addresses[i]] = false;
1945         }
1946     }
1947 
1948     function isInWhitelist(address user) external view returns (bool) {
1949         return presaleWhitelist[user];
1950     }
1951 
1952     function doPresale(uint256 numberOfTokens) external payable {
1953         uint256 numOfUser = presaleNumOfUser[_msgSender()];
1954         require(isPresaleLive(), "Whitelist sale has not started yet");
1955         require(presaleWhitelist[_msgSender()], "You are not on the whitelist");
1956         require(numberOfTokens.add(numOfUser) <= maxPresaleToMint, "Exceeds max whitelist mints allowed per user");
1957         require(totalSupply() <= maxPresaleSupply, "Exceeds max whitelist supply");
1958         require(numberOfTokens > 0, "Must mint at least one token");
1959         require(mintPrice.mul(numberOfTokens) == msg.value, "Ether value sent is incorrect");
1960 
1961         presaleNumOfUser[_msgSender()] = numberOfTokens.add(presaleNumOfUser[_msgSender()]);
1962         for(uint256 i = 0; i < numberOfTokens; i++) {
1963             uint256 mintIndex = totalSupply();
1964             _safeMint(_msgSender(), mintIndex);
1965         }
1966     }
1967 
1968     function doPublic(uint256 numberOfTokens) external payable {
1969         uint256 numOfUser = publicNumOfUser[_msgSender()];
1970         require(isPublicSaleLive(), "Public sale has not started yet");
1971         require(numberOfTokens.add(numOfUser) <= maxPublicToMint, "Exceeds max public sale allowed per user");
1972         require(totalSupply() + numberOfTokens <= maxNftSupply, "Exceeds max supply");
1973         require(numberOfTokens > 0, "Must mint at least one token");
1974         require(mintPrice.mul(numberOfTokens) == msg.value, "Ether value sent is not correct");
1975 
1976         publicNumOfUser[_msgSender()] = numberOfTokens.add(publicNumOfUser[_msgSender()]);
1977         for(uint256 i = 0; i < numberOfTokens; i++) {
1978             uint256 mintIndex = totalSupply();
1979             _safeMint(_msgSender(), mintIndex);
1980         }
1981     }
1982 
1983     function withdraw() external onlyOwner {
1984         uint balance = address(this).balance;
1985         msg.sender.transfer(balance);
1986     }
1987     
1988     function withdrawAll() public onlyOwner {
1989         uint balance = address(this).balance;
1990         require(balance > 0, "Ether balance must be > 0");
1991         payable(msg.sender).transfer(balance);
1992     }
1993 
1994 }