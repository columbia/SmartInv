1 pragma solidity 0.6.6;
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
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC165 standard, as defined in the
26  * https://eips.ethereum.org/EIPS/eip-165[EIP].
27  *
28  * Implementers can declare support of contract interfaces, which can then be
29  * queried by others ({ERC165Checker}).
30  *
31  * For an implementation, see {ERC165}.
32  */
33 interface IERC165 {
34     /**
35      * @dev Returns true if this contract implements the interface defined by
36      * `interfaceId`. See the corresponding
37      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
38      * to learn more about how these ids are created.
39      *
40      * This function call must use less than 30 000 gas.
41      */
42     function supportsInterface(bytes4 interfaceId) external view returns (bool);
43 }
44 
45 
46 /**
47  * @dev Required interface of an ERC721 compliant contract.
48  */
49 interface IERC721 is IERC165 {
50     /**
51      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
52      */
53     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
57      */
58     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
62      */
63     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(address from, address to, uint256 tokenId) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address from, address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155       * @dev Safely transfers `tokenId` token from `from` to `to`.
156       *
157       * Requirements:
158       *
159       * - `from` cannot be the zero address.
160       * - `to` cannot be the zero address.
161       * - `tokenId` token must exist and be owned by `from`.
162       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164       *
165       * Emits a {Transfer} event.
166       */
167     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
168 }
169 
170 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Metadata.sol
171 
172 // SPDX-License-Identifier: MIT
173 
174 pragma solidity >=0.6.2 <0.8.0;
175 
176 
177 /**
178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
179  * @dev See https://eips.ethereum.org/EIPS/eip-721
180  */
181 interface IERC721Metadata is IERC721 {
182 
183     /**
184      * @dev Returns the token collection name.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the token collection symbol.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
195      */
196     function tokenURI(uint256 tokenId) external view returns (string memory);
197 }
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Enumerable is IERC721 {
205 
206     /**
207      * @dev Returns the total amount of tokens stored by the contract.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
213      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
214      */
215     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
216 
217     /**
218      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
219      * Use along with {totalSupply} to enumerate all tokens.
220      */
221     function tokenByIndex(uint256 index) external view returns (uint256);
222 }
223 
224 
225 /**
226  * @title ERC721 token receiver interface
227  * @dev Interface for any contract that wants to support safeTransfers
228  * from ERC721 asset contracts.
229  */
230 interface IERC721Receiver {
231     /**
232      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
233      * by `operator` from `from`, this function is called.
234      *
235      * It must return its Solidity selector to confirm the token transfer.
236      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
237      *
238      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
239      */
240     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
241 }
242 
243 
244 /**
245  * @dev Implementation of the {IERC165} interface.
246  *
247  * Contracts may inherit from this and call {_registerInterface} to declare
248  * their support of an interface.
249  */
250 abstract contract ERC165 is IERC165 {
251     /*
252      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
253      */
254     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
255 
256     /**
257      * @dev Mapping of interface ids to whether or not it's supported.
258      */
259     mapping(bytes4 => bool) private _supportedInterfaces;
260 
261     constructor () internal {
262         // Derived contracts need only register support for their own interfaces,
263         // we register support for ERC165 itself here
264         _registerInterface(_INTERFACE_ID_ERC165);
265     }
266 
267     /**
268      * @dev See {IERC165-supportsInterface}.
269      *
270      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
271      */
272     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
273         return _supportedInterfaces[interfaceId];
274     }
275 
276     /**
277      * @dev Registers the contract as an implementer of the interface defined by
278      * `interfaceId`. Support of the actual ERC165 interface is automatic and
279      * registering its interface id is not required.
280      *
281      * See {IERC165-supportsInterface}.
282      *
283      * Requirements:
284      *
285      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
286      */
287     function _registerInterface(bytes4 interfaceId) internal virtual {
288         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
289         _supportedInterfaces[interfaceId] = true;
290     }
291 }
292 
293 
294 /**
295  * @dev Wrappers over Solidity's arithmetic operations with added overflow
296  * checks.
297  *
298  * Arithmetic operations in Solidity wrap on overflow. This can easily result
299  * in bugs, because programmers usually assume that an overflow raises an
300  * error, which is the standard behavior in high level programming languages.
301  * `SafeMath` restores this intuition by reverting the transaction when an
302  * operation overflows.
303  *
304  * Using this library instead of the unchecked operations eliminates an entire
305  * class of bugs, so it's recommended to use it always.
306  */
307 library SafeMath {
308     /**
309      * @dev Returns the addition of two unsigned integers, with an overflow flag.
310      *
311      * _Available since v3.4._
312      */
313     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
314         uint256 c = a + b;
315         if (c < a) return (false, 0);
316         return (true, c);
317     }
318 
319     /**
320      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
321      *
322      * _Available since v3.4._
323      */
324     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         if (b > a) return (false, 0);
326         return (true, a - b);
327     }
328 
329     /**
330      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
331      *
332      * _Available since v3.4._
333      */
334     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
335         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
336         // benefit is lost if 'b' is also tested.
337         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
338         if (a == 0) return (true, 0);
339         uint256 c = a * b;
340         if (c / a != b) return (false, 0);
341         return (true, c);
342     }
343 
344     /**
345      * @dev Returns the division of two unsigned integers, with a division by zero flag.
346      *
347      * _Available since v3.4._
348      */
349     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
350         if (b == 0) return (false, 0);
351         return (true, a / b);
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
356      *
357      * _Available since v3.4._
358      */
359     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         if (b == 0) return (false, 0);
361         return (true, a % b);
362     }
363 
364     /**
365      * @dev Returns the addition of two unsigned integers, reverting on
366      * overflow.
367      *
368      * Counterpart to Solidity's `+` operator.
369      *
370      * Requirements:
371      *
372      * - Addition cannot overflow.
373      */
374     function add(uint256 a, uint256 b) internal pure returns (uint256) {
375         uint256 c = a + b;
376         require(c >= a, "SafeMath: addition overflow");
377         return c;
378     }
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting on
382      * overflow (when the result is negative).
383      *
384      * Counterpart to Solidity's `-` operator.
385      *
386      * Requirements:
387      *
388      * - Subtraction cannot overflow.
389      */
390     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
391         require(b <= a, "SafeMath: subtraction overflow");
392         return a - b;
393     }
394 
395     /**
396      * @dev Returns the multiplication of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `*` operator.
400      *
401      * Requirements:
402      *
403      * - Multiplication cannot overflow.
404      */
405     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406         if (a == 0) return 0;
407         uint256 c = a * b;
408         require(c / a == b, "SafeMath: multiplication overflow");
409         return c;
410     }
411 
412     /**
413      * @dev Returns the integer division of two unsigned integers, reverting on
414      * division by zero. The result is rounded towards zero.
415      *
416      * Counterpart to Solidity's `/` operator. Note: this function uses a
417      * `revert` opcode (which leaves remaining gas untouched) while Solidity
418      * uses an invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function div(uint256 a, uint256 b) internal pure returns (uint256) {
425         require(b > 0, "SafeMath: division by zero");
426         return a / b;
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
431      * reverting when dividing by zero.
432      *
433      * Counterpart to Solidity's `%` operator. This function uses a `revert`
434      * opcode (which leaves remaining gas untouched) while Solidity uses an
435      * invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      *
439      * - The divisor cannot be zero.
440      */
441     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
442         require(b > 0, "SafeMath: modulo by zero");
443         return a % b;
444     }
445 
446     /**
447      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
448      * overflow (when the result is negative).
449      *
450      * CAUTION: This function is deprecated because it requires allocating memory for the error
451      * message unnecessarily. For custom revert reasons use {trySub}.
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      *
457      * - Subtraction cannot overflow.
458      */
459     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         require(b <= a, errorMessage);
461         return a - b;
462     }
463 
464     /**
465      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
466      * division by zero. The result is rounded towards zero.
467      *
468      * CAUTION: This function is deprecated because it requires allocating memory for the error
469      * message unnecessarily. For custom revert reasons use {tryDiv}.
470      *
471      * Counterpart to Solidity's `/` operator. Note: this function uses a
472      * `revert` opcode (which leaves remaining gas untouched) while Solidity
473      * uses an invalid opcode to revert (consuming all remaining gas).
474      *
475      * Requirements:
476      *
477      * - The divisor cannot be zero.
478      */
479     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         require(b > 0, errorMessage);
481         return a / b;
482     }
483 
484     /**
485      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
486      * reverting with custom message when dividing by zero.
487      *
488      * CAUTION: This function is deprecated because it requires allocating memory for the error
489      * message unnecessarily. For custom revert reasons use {tryMod}.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b > 0, errorMessage);
501         return a % b;
502     }
503 }
504 
505 
506 /**
507  * @dev Collection of functions related to the address type
508  */
509 library Address {
510     /**
511      * @dev Returns true if `account` is a contract.
512      *
513      * [IMPORTANT]
514      * ====
515      * It is unsafe to assume that an address for which this function returns
516      * false is an externally-owned account (EOA) and not a contract.
517      *
518      * Among others, `isContract` will return false for the following
519      * types of addresses:
520      *
521      *  - an externally-owned account
522      *  - a contract in construction
523      *  - an address where a contract will be created
524      *  - an address where a contract lived, but was destroyed
525      * ====
526      */
527     function isContract(address account) internal view returns (bool) {
528         // This method relies on extcodesize, which returns 0 for contracts in
529         // construction, since the code is only stored at the end of the
530         // constructor execution.
531 
532         uint256 size;
533         // solhint-disable-next-line no-inline-assembly
534         assembly { size := extcodesize(account) }
535         return size > 0;
536     }
537 
538     /**
539      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
540      * `recipient`, forwarding all available gas and reverting on errors.
541      *
542      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
543      * of certain opcodes, possibly making contracts go over the 2300 gas limit
544      * imposed by `transfer`, making them unable to receive funds via
545      * `transfer`. {sendValue} removes this limitation.
546      *
547      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
548      *
549      * IMPORTANT: because control is transferred to `recipient`, care must be
550      * taken to not create reentrancy vulnerabilities. Consider using
551      * {ReentrancyGuard} or the
552      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
553      */
554     function sendValue(address payable recipient, uint256 amount) internal {
555         require(address(this).balance >= amount, "Address: insufficient balance");
556 
557         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
558         (bool success, ) = recipient.call{ value: amount }("");
559         require(success, "Address: unable to send value, recipient may have reverted");
560     }
561 
562     /**
563      * @dev Performs a Solidity function call using a low level `call`. A
564      * plain`call` is an unsafe replacement for a function call: use this
565      * function instead.
566      *
567      * If `target` reverts with a revert reason, it is bubbled up by this
568      * function (like regular Solidity function calls).
569      *
570      * Returns the raw returned data. To convert to the expected return value,
571      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
572      *
573      * Requirements:
574      *
575      * - `target` must be a contract.
576      * - calling `target` with `data` must not revert.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
581       return functionCall(target, data, "Address: low-level call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
586      * `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, 0, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but also transferring `value` wei to `target`.
597      *
598      * Requirements:
599      *
600      * - the calling contract must have an ETH balance of at least `value`.
601      * - the called Solidity function must be `payable`.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
606         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
611      * with `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
616         require(address(this).balance >= value, "Address: insufficient balance for call");
617         require(isContract(target), "Address: call to non-contract");
618 
619         // solhint-disable-next-line avoid-low-level-calls
620         (bool success, bytes memory returndata) = target.call{ value: value }(data);
621         return _verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
631         return functionStaticCall(target, data, "Address: low-level static call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
641         require(isContract(target), "Address: static call to non-contract");
642 
643         // solhint-disable-next-line avoid-low-level-calls
644         (bool success, bytes memory returndata) = target.staticcall(data);
645         return _verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
660      * but performing a delegate call.
661      *
662      * _Available since v3.4._
663      */
664     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
665         require(isContract(target), "Address: delegate call to non-contract");
666 
667         // solhint-disable-next-line avoid-low-level-calls
668         (bool success, bytes memory returndata) = target.delegatecall(data);
669         return _verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
673         if (success) {
674             return returndata;
675         } else {
676             // Look for revert reason and bubble it up if present
677             if (returndata.length > 0) {
678                 // The easiest way to bubble the revert reason is using memory via assembly
679 
680                 // solhint-disable-next-line no-inline-assembly
681                 assembly {
682                     let returndata_size := mload(returndata)
683                     revert(add(32, returndata), returndata_size)
684                 }
685             } else {
686                 revert(errorMessage);
687             }
688         }
689     }
690 }
691 
692 
693 /**
694  * @dev Library for managing
695  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
696  * types.
697  *
698  * Sets have the following properties:
699  *
700  * - Elements are added, removed, and checked for existence in constant time
701  * (O(1)).
702  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
703  *
704  * ```
705  * contract Example {
706  *     // Add the library methods
707  *     using EnumerableSet for EnumerableSet.AddressSet;
708  *
709  *     // Declare a set state variable
710  *     EnumerableSet.AddressSet private mySet;
711  * }
712  * ```
713  *
714  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
715  * and `uint256` (`UintSet`) are supported.
716  */
717 library EnumerableSet {
718     // To implement this library for multiple types with as little code
719     // repetition as possible, we write it in terms of a generic Set type with
720     // bytes32 values.
721     // The Set implementation uses private functions, and user-facing
722     // implementations (such as AddressSet) are just wrappers around the
723     // underlying Set.
724     // This means that we can only create new EnumerableSets for types that fit
725     // in bytes32.
726 
727     struct Set {
728         // Storage of set values
729         bytes32[] _values;
730 
731         // Position of the value in the `values` array, plus 1 because index 0
732         // means a value is not in the set.
733         mapping (bytes32 => uint256) _indexes;
734     }
735 
736     /**
737      * @dev Add a value to a set. O(1).
738      *
739      * Returns true if the value was added to the set, that is if it was not
740      * already present.
741      */
742     function _add(Set storage set, bytes32 value) private returns (bool) {
743         if (!_contains(set, value)) {
744             set._values.push(value);
745             // The value is stored at length-1, but we add 1 to all indexes
746             // and use 0 as a sentinel value
747             set._indexes[value] = set._values.length;
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754     /**
755      * @dev Removes a value from a set. O(1).
756      *
757      * Returns true if the value was removed from the set, that is if it was
758      * present.
759      */
760     function _remove(Set storage set, bytes32 value) private returns (bool) {
761         // We read and store the value's index to prevent multiple reads from the same storage slot
762         uint256 valueIndex = set._indexes[value];
763 
764         if (valueIndex != 0) { // Equivalent to contains(set, value)
765             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
766             // the array, and then remove the last element (sometimes called as 'swap and pop').
767             // This modifies the order of the array, as noted in {at}.
768 
769             uint256 toDeleteIndex = valueIndex - 1;
770             uint256 lastIndex = set._values.length - 1;
771 
772             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
773             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
774 
775             bytes32 lastvalue = set._values[lastIndex];
776 
777             // Move the last value to the index where the value to delete is
778             set._values[toDeleteIndex] = lastvalue;
779             // Update the index for the moved value
780             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
781 
782             // Delete the slot where the moved value was stored
783             set._values.pop();
784 
785             // Delete the index for the deleted slot
786             delete set._indexes[value];
787 
788             return true;
789         } else {
790             return false;
791         }
792     }
793 
794     /**
795      * @dev Returns true if the value is in the set. O(1).
796      */
797     function _contains(Set storage set, bytes32 value) private view returns (bool) {
798         return set._indexes[value] != 0;
799     }
800 
801     /**
802      * @dev Returns the number of values on the set. O(1).
803      */
804     function _length(Set storage set) private view returns (uint256) {
805         return set._values.length;
806     }
807 
808    /**
809     * @dev Returns the value stored at position `index` in the set. O(1).
810     *
811     * Note that there are no guarantees on the ordering of values inside the
812     * array, and it may change when more values are added or removed.
813     *
814     * Requirements:
815     *
816     * - `index` must be strictly less than {length}.
817     */
818     function _at(Set storage set, uint256 index) private view returns (bytes32) {
819         require(set._values.length > index, "EnumerableSet: index out of bounds");
820         return set._values[index];
821     }
822 
823     // Bytes32Set
824 
825     struct Bytes32Set {
826         Set _inner;
827     }
828 
829     /**
830      * @dev Add a value to a set. O(1).
831      *
832      * Returns true if the value was added to the set, that is if it was not
833      * already present.
834      */
835     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
836         return _add(set._inner, value);
837     }
838 
839     /**
840      * @dev Removes a value from a set. O(1).
841      *
842      * Returns true if the value was removed from the set, that is if it was
843      * present.
844      */
845     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
846         return _remove(set._inner, value);
847     }
848 
849     /**
850      * @dev Returns true if the value is in the set. O(1).
851      */
852     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
853         return _contains(set._inner, value);
854     }
855 
856     /**
857      * @dev Returns the number of values in the set. O(1).
858      */
859     function length(Bytes32Set storage set) internal view returns (uint256) {
860         return _length(set._inner);
861     }
862 
863    /**
864     * @dev Returns the value stored at position `index` in the set. O(1).
865     *
866     * Note that there are no guarantees on the ordering of values inside the
867     * array, and it may change when more values are added or removed.
868     *
869     * Requirements:
870     *
871     * - `index` must be strictly less than {length}.
872     */
873     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
874         return _at(set._inner, index);
875     }
876 
877     // AddressSet
878 
879     struct AddressSet {
880         Set _inner;
881     }
882 
883     /**
884      * @dev Add a value to a set. O(1).
885      *
886      * Returns true if the value was added to the set, that is if it was not
887      * already present.
888      */
889     function add(AddressSet storage set, address value) internal returns (bool) {
890         return _add(set._inner, bytes32(uint256(uint160(value))));
891     }
892 
893     /**
894      * @dev Removes a value from a set. O(1).
895      *
896      * Returns true if the value was removed from the set, that is if it was
897      * present.
898      */
899     function remove(AddressSet storage set, address value) internal returns (bool) {
900         return _remove(set._inner, bytes32(uint256(uint160(value))));
901     }
902 
903     /**
904      * @dev Returns true if the value is in the set. O(1).
905      */
906     function contains(AddressSet storage set, address value) internal view returns (bool) {
907         return _contains(set._inner, bytes32(uint256(uint160(value))));
908     }
909 
910     /**
911      * @dev Returns the number of values in the set. O(1).
912      */
913     function length(AddressSet storage set) internal view returns (uint256) {
914         return _length(set._inner);
915     }
916 
917    /**
918     * @dev Returns the value stored at position `index` in the set. O(1).
919     *
920     * Note that there are no guarantees on the ordering of values inside the
921     * array, and it may change when more values are added or removed.
922     *
923     * Requirements:
924     *
925     * - `index` must be strictly less than {length}.
926     */
927     function at(AddressSet storage set, uint256 index) internal view returns (address) {
928         return address(uint160(uint256(_at(set._inner, index))));
929     }
930 
931 
932     // UintSet
933 
934     struct UintSet {
935         Set _inner;
936     }
937 
938     /**
939      * @dev Add a value to a set. O(1).
940      *
941      * Returns true if the value was added to the set, that is if it was not
942      * already present.
943      */
944     function add(UintSet storage set, uint256 value) internal returns (bool) {
945         return _add(set._inner, bytes32(value));
946     }
947 
948     /**
949      * @dev Removes a value from a set. O(1).
950      *
951      * Returns true if the value was removed from the set, that is if it was
952      * present.
953      */
954     function remove(UintSet storage set, uint256 value) internal returns (bool) {
955         return _remove(set._inner, bytes32(value));
956     }
957 
958     /**
959      * @dev Returns true if the value is in the set. O(1).
960      */
961     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
962         return _contains(set._inner, bytes32(value));
963     }
964 
965     /**
966      * @dev Returns the number of values on the set. O(1).
967      */
968     function length(UintSet storage set) internal view returns (uint256) {
969         return _length(set._inner);
970     }
971 
972    /**
973     * @dev Returns the value stored at position `index` in the set. O(1).
974     *
975     * Note that there are no guarantees on the ordering of values inside the
976     * array, and it may change when more values are added or removed.
977     *
978     * Requirements:
979     *
980     * - `index` must be strictly less than {length}.
981     */
982     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
983         return uint256(_at(set._inner, index));
984     }
985 }
986 
987 
988 /**
989  * @dev Library for managing an enumerable variant of Solidity's
990  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
991  * type.
992  *
993  * Maps have the following properties:
994  *
995  * - Entries are added, removed, and checked for existence in constant time
996  * (O(1)).
997  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
998  *
999  * ```
1000  * contract Example {
1001  *     // Add the library methods
1002  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1003  *
1004  *     // Declare a set state variable
1005  *     EnumerableMap.UintToAddressMap private myMap;
1006  * }
1007  * ```
1008  *
1009  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1010  * supported.
1011  */
1012 library EnumerableMap {
1013     // To implement this library for multiple types with as little code
1014     // repetition as possible, we write it in terms of a generic Map type with
1015     // bytes32 keys and values.
1016     // The Map implementation uses private functions, and user-facing
1017     // implementations (such as Uint256ToAddressMap) are just wrappers around
1018     // the underlying Map.
1019     // This means that we can only create new EnumerableMaps for types that fit
1020     // in bytes32.
1021 
1022     struct MapEntry {
1023         bytes32 _key;
1024         bytes32 _value;
1025     }
1026 
1027     struct Map {
1028         // Storage of map keys and values
1029         MapEntry[] _entries;
1030 
1031         // Position of the entry defined by a key in the `entries` array, plus 1
1032         // because index 0 means a key is not in the map.
1033         mapping (bytes32 => uint256) _indexes;
1034     }
1035 
1036     /**
1037      * @dev Adds a key-value pair to a map, or updates the value for an existing
1038      * key. O(1).
1039      *
1040      * Returns true if the key was added to the map, that is if it was not
1041      * already present.
1042      */
1043     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1044         // We read and store the key's index to prevent multiple reads from the same storage slot
1045         uint256 keyIndex = map._indexes[key];
1046 
1047         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1048             map._entries.push(MapEntry({ _key: key, _value: value }));
1049             // The entry is stored at length-1, but we add 1 to all indexes
1050             // and use 0 as a sentinel value
1051             map._indexes[key] = map._entries.length;
1052             return true;
1053         } else {
1054             map._entries[keyIndex - 1]._value = value;
1055             return false;
1056         }
1057     }
1058 
1059     /**
1060      * @dev Removes a key-value pair from a map. O(1).
1061      *
1062      * Returns true if the key was removed from the map, that is if it was present.
1063      */
1064     function _remove(Map storage map, bytes32 key) private returns (bool) {
1065         // We read and store the key's index to prevent multiple reads from the same storage slot
1066         uint256 keyIndex = map._indexes[key];
1067 
1068         if (keyIndex != 0) { // Equivalent to contains(map, key)
1069             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1070             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1071             // This modifies the order of the array, as noted in {at}.
1072 
1073             uint256 toDeleteIndex = keyIndex - 1;
1074             uint256 lastIndex = map._entries.length - 1;
1075 
1076             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1077             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1078 
1079             MapEntry storage lastEntry = map._entries[lastIndex];
1080 
1081             // Move the last entry to the index where the entry to delete is
1082             map._entries[toDeleteIndex] = lastEntry;
1083             // Update the index for the moved entry
1084             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1085 
1086             // Delete the slot where the moved entry was stored
1087             map._entries.pop();
1088 
1089             // Delete the index for the deleted slot
1090             delete map._indexes[key];
1091 
1092             return true;
1093         } else {
1094             return false;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Returns true if the key is in the map. O(1).
1100      */
1101     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1102         return map._indexes[key] != 0;
1103     }
1104 
1105     /**
1106      * @dev Returns the number of key-value pairs in the map. O(1).
1107      */
1108     function _length(Map storage map) private view returns (uint256) {
1109         return map._entries.length;
1110     }
1111 
1112    /**
1113     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1114     *
1115     * Note that there are no guarantees on the ordering of entries inside the
1116     * array, and it may change when more entries are added or removed.
1117     *
1118     * Requirements:
1119     *
1120     * - `index` must be strictly less than {length}.
1121     */
1122     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1123         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1124 
1125         MapEntry storage entry = map._entries[index];
1126         return (entry._key, entry._value);
1127     }
1128 
1129     /**
1130      * @dev Tries to returns the value associated with `key`.  O(1).
1131      * Does not revert if `key` is not in the map.
1132      */
1133     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1134         uint256 keyIndex = map._indexes[key];
1135         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1136         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1137     }
1138 
1139     /**
1140      * @dev Returns the value associated with `key`.  O(1).
1141      *
1142      * Requirements:
1143      *
1144      * - `key` must be in the map.
1145      */
1146     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1147         uint256 keyIndex = map._indexes[key];
1148         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1149         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1150     }
1151 
1152     /**
1153      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1154      *
1155      * CAUTION: This function is deprecated because it requires allocating memory for the error
1156      * message unnecessarily. For custom revert reasons use {_tryGet}.
1157      */
1158     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1159         uint256 keyIndex = map._indexes[key];
1160         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1161         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1162     }
1163 
1164     // UintToAddressMap
1165 
1166     struct UintToAddressMap {
1167         Map _inner;
1168     }
1169 
1170     /**
1171      * @dev Adds a key-value pair to a map, or updates the value for an existing
1172      * key. O(1).
1173      *
1174      * Returns true if the key was added to the map, that is if it was not
1175      * already present.
1176      */
1177     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1178         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1179     }
1180 
1181     /**
1182      * @dev Removes a value from a set. O(1).
1183      *
1184      * Returns true if the key was removed from the map, that is if it was present.
1185      */
1186     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1187         return _remove(map._inner, bytes32(key));
1188     }
1189 
1190     /**
1191      * @dev Returns true if the key is in the map. O(1).
1192      */
1193     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1194         return _contains(map._inner, bytes32(key));
1195     }
1196 
1197     /**
1198      * @dev Returns the number of elements in the map. O(1).
1199      */
1200     function length(UintToAddressMap storage map) internal view returns (uint256) {
1201         return _length(map._inner);
1202     }
1203 
1204    /**
1205     * @dev Returns the element stored at position `index` in the set. O(1).
1206     * Note that there are no guarantees on the ordering of values inside the
1207     * array, and it may change when more values are added or removed.
1208     *
1209     * Requirements:
1210     *
1211     * - `index` must be strictly less than {length}.
1212     */
1213     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1214         (bytes32 key, bytes32 value) = _at(map._inner, index);
1215         return (uint256(key), address(uint160(uint256(value))));
1216     }
1217 
1218     /**
1219      * @dev Tries to returns the value associated with `key`.  O(1).
1220      * Does not revert if `key` is not in the map.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1225         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1226         return (success, address(uint160(uint256(value))));
1227     }
1228 
1229     /**
1230      * @dev Returns the value associated with `key`.  O(1).
1231      *
1232      * Requirements:
1233      *
1234      * - `key` must be in the map.
1235      */
1236     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1237         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1238     }
1239 
1240     /**
1241      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1242      *
1243      * CAUTION: This function is deprecated because it requires allocating memory for the error
1244      * message unnecessarily. For custom revert reasons use {tryGet}.
1245      */
1246     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1247         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1248     }
1249 }
1250 
1251 
1252 /**
1253  * @dev String operations.
1254  */
1255 library Strings {
1256     /**
1257      * @dev Converts a `uint256` to its ASCII `string` representation.
1258      */
1259     function toString(uint256 value) internal pure returns (string memory) {
1260         // Inspired by OraclizeAPI's implementation - MIT licence
1261         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1262 
1263         if (value == 0) {
1264             return "0";
1265         }
1266         uint256 temp = value;
1267         uint256 digits;
1268         while (temp != 0) {
1269             digits++;
1270             temp /= 10;
1271         }
1272         bytes memory buffer = new bytes(digits);
1273         uint256 index = digits - 1;
1274         temp = value;
1275         while (temp != 0) {
1276             buffer[index--] = bytes1(uint8(48 + temp % 10));
1277             temp /= 10;
1278         }
1279         return string(buffer);
1280     }
1281 }
1282 
1283 
1284 
1285 /**
1286  * @title ERC721 Non-Fungible Token Standard basic implementation
1287  * @dev see https://eips.ethereum.org/EIPS/eip-721
1288  */
1289 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1290     using SafeMath for uint256;
1291     using Address for address;
1292     using EnumerableSet for EnumerableSet.UintSet;
1293     using EnumerableMap for EnumerableMap.UintToAddressMap;
1294     using Strings for uint256;
1295 
1296     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1297     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1298     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1299 
1300     // Mapping from holder address to their (enumerable) set of owned tokens
1301     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1302 
1303     // Enumerable mapping from token ids to their owners
1304     EnumerableMap.UintToAddressMap private _tokenOwners;
1305 
1306     // Mapping from token ID to approved address
1307     mapping (uint256 => address) private _tokenApprovals;
1308 
1309     // Mapping from owner to operator approvals
1310     mapping (address => mapping (address => bool)) private _operatorApprovals;
1311 
1312     // Token name
1313     string private _name;
1314 
1315     // Token symbol
1316     string private _symbol;
1317 
1318     // Optional mapping for token URIs
1319     mapping (uint256 => string) private _tokenURIs;
1320 
1321     // Base URI
1322     string private _baseURI;
1323 
1324     /*
1325      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1326      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1327      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1328      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1329      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1330      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1331      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1332      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1333      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1334      *
1335      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1336      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1337      */
1338     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1339 
1340     /*
1341      *     bytes4(keccak256('name()')) == 0x06fdde03
1342      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1343      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1344      *
1345      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1346      */
1347     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1348 
1349     /*
1350      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1351      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1352      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1353      *
1354      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1355      */
1356     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1357 
1358     /**
1359      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1360      */
1361     constructor (string memory name_, string memory symbol_) public {
1362         _name = name_;
1363         _symbol = symbol_;
1364 
1365         // register the supported interfaces to conform to ERC721 via ERC165
1366         _registerInterface(_INTERFACE_ID_ERC721);
1367         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1368         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-balanceOf}.
1373      */
1374     function balanceOf(address owner) public view virtual override returns (uint256) {
1375         require(owner != address(0), "ERC721: balance query for the zero address");
1376         return _holderTokens[owner].length();
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-ownerOf}.
1381      */
1382     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1383         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1384     }
1385 
1386     /**
1387      * @dev See {IERC721Metadata-name}.
1388      */
1389     function name() public view virtual override returns (string memory) {
1390         return _name;
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Metadata-symbol}.
1395      */
1396     function symbol() public view virtual override returns (string memory) {
1397         return _symbol;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721Metadata-tokenURI}.
1402      */
1403     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1404         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1405 
1406         string memory _tokenURI = _tokenURIs[tokenId];
1407         string memory base = baseURI();
1408 
1409         // If there is no base URI, return the token URI.
1410         if (bytes(base).length == 0) {
1411             return _tokenURI;
1412         }
1413         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1414         if (bytes(_tokenURI).length > 0) {
1415             return string(abi.encodePacked(base, _tokenURI));
1416         }
1417         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1418         return string(abi.encodePacked(base, tokenId.toString()));
1419     }
1420 
1421     /**
1422     * @dev Returns the base URI set via {_setBaseURI}. This will be
1423     * automatically added as a prefix in {tokenURI} to each token's URI, or
1424     * to the token ID if no specific URI is set for that token ID.
1425     */
1426     function baseURI() public view virtual returns (string memory) {
1427         return _baseURI;
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1432      */
1433     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1434         return _holderTokens[owner].at(index);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Enumerable-totalSupply}.
1439      */
1440     function totalSupply() public view virtual override returns (uint256) {
1441         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1442         return _tokenOwners.length();
1443     }
1444 
1445     /**
1446      * @dev See {IERC721Enumerable-tokenByIndex}.
1447      */
1448     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1449         (uint256 tokenId, ) = _tokenOwners.at(index);
1450         return tokenId;
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-approve}.
1455      */
1456     function approve(address to, uint256 tokenId) public virtual override {
1457         address owner = ERC721.ownerOf(tokenId);
1458         require(to != owner, "ERC721: approval to current owner");
1459 
1460         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1461             "ERC721: approve caller is not owner nor approved for all"
1462         );
1463 
1464         _approve(to, tokenId);
1465     }
1466 
1467     /**
1468      * @dev See {IERC721-getApproved}.
1469      */
1470     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1471         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1472 
1473         return _tokenApprovals[tokenId];
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-setApprovalForAll}.
1478      */
1479     function setApprovalForAll(address operator, bool approved) public virtual override {
1480         require(operator != _msgSender(), "ERC721: approve to caller");
1481 
1482         _operatorApprovals[_msgSender()][operator] = approved;
1483         emit ApprovalForAll(_msgSender(), operator, approved);
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-isApprovedForAll}.
1488      */
1489     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1490         return _operatorApprovals[owner][operator];
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-transferFrom}.
1495      */
1496     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1497         //solhint-disable-next-line max-line-length
1498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1499 
1500         _transfer(from, to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-safeTransferFrom}.
1505      */
1506     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1507         safeTransferFrom(from, to, tokenId, "");
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-safeTransferFrom}.
1512      */
1513     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1514         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1515         _safeTransfer(from, to, tokenId, _data);
1516     }
1517 
1518     /**
1519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1521      *
1522      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1523      *
1524      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1525      * implement alternative mechanisms to perform token transfer, such as signature-based.
1526      *
1527      * Requirements:
1528      *
1529      * - `from` cannot be the zero address.
1530      * - `to` cannot be the zero address.
1531      * - `tokenId` token must exist and be owned by `from`.
1532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1537         _transfer(from, to, tokenId);
1538         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1539     }
1540 
1541     /**
1542      * @dev Returns whether `tokenId` exists.
1543      *
1544      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1545      *
1546      * Tokens start existing when they are minted (`_mint`),
1547      * and stop existing when they are burned (`_burn`).
1548      */
1549     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1550         return _tokenOwners.contains(tokenId);
1551     }
1552 
1553     /**
1554      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1555      *
1556      * Requirements:
1557      *
1558      * - `tokenId` must exist.
1559      */
1560     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1561         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1562         address owner = ERC721.ownerOf(tokenId);
1563         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1564     }
1565 
1566     /**
1567      * @dev Safely mints `tokenId` and transfers it to `to`.
1568      *
1569      * Requirements:
1570      d*
1571      * - `tokenId` must not exist.
1572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _safeMint(address to, uint256 tokenId) internal virtual {
1577         _safeMint(to, tokenId, "");
1578     }
1579 
1580     /**
1581      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1582      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1583      */
1584     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1585         _mint(to, tokenId);
1586         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1587     }
1588 
1589     /**
1590      * @dev Mints `tokenId` and transfers it to `to`.
1591      *
1592      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1593      *
1594      * Requirements:
1595      *
1596      * - `tokenId` must not exist.
1597      * - `to` cannot be the zero address.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function _mint(address to, uint256 tokenId) internal virtual {
1602         require(to != address(0), "ERC721: mint to the zero address");
1603         require(!_exists(tokenId), "ERC721: token already minted");
1604 
1605         _beforeTokenTransfer(address(0), to, tokenId);
1606 
1607         _holderTokens[to].add(tokenId);
1608 
1609         _tokenOwners.set(tokenId, to);
1610 
1611         emit Transfer(address(0), to, tokenId);
1612     }
1613 
1614     /**
1615      * @dev Destroys `tokenId`.
1616      * The approval is cleared when the token is burned.
1617      *
1618      * Requirements:
1619      *
1620      * - `tokenId` must exist.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _burn(uint256 tokenId) internal virtual {
1625         address owner = ERC721.ownerOf(tokenId); // internal owner
1626 
1627         _beforeTokenTransfer(owner, address(0), tokenId);
1628 
1629         // Clear approvals
1630         _approve(address(0), tokenId);
1631 
1632         // Clear metadata (if any)
1633         if (bytes(_tokenURIs[tokenId]).length != 0) {
1634             delete _tokenURIs[tokenId];
1635         }
1636 
1637         _holderTokens[owner].remove(tokenId);
1638 
1639         _tokenOwners.remove(tokenId);
1640 
1641         emit Transfer(owner, address(0), tokenId);
1642     }
1643 
1644     /**
1645      * @dev Transfers `tokenId` from `from` to `to`.
1646      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1647      *
1648      * Requirements:
1649      *
1650      * - `to` cannot be the zero address.
1651      * - `tokenId` token must be owned by `from`.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1656         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1657         require(to != address(0), "ERC721: transfer to the zero address");
1658 
1659         _beforeTokenTransfer(from, to, tokenId);
1660 
1661         // Clear approvals from the previous owner
1662         _approve(address(0), tokenId);
1663 
1664         _holderTokens[from].remove(tokenId);
1665         _holderTokens[to].add(tokenId);
1666 
1667         _tokenOwners.set(tokenId, to);
1668 
1669         emit Transfer(from, to, tokenId);
1670     }
1671 
1672     /**
1673      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1674      *
1675      * Requirements:
1676      *
1677      * - `tokenId` must exist.
1678      */
1679     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1680         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1681         _tokenURIs[tokenId] = _tokenURI;
1682     }
1683 
1684     /**
1685      * @dev Internal function to set the base URI for all token IDs. It is
1686      * automatically added as a prefix to the value returned in {tokenURI},
1687      * or to the token ID if {tokenURI} is empty.
1688      */
1689     function _setBaseURI(string memory baseURI_) internal virtual {
1690         _baseURI = baseURI_;
1691     }
1692 
1693     /**
1694      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1695      * The call is not executed if the target address is not a contract.
1696      *
1697      * @param from address representing the previous owner of the given token ID
1698      * @param to target address that will receive the tokens
1699      * @param tokenId uint256 ID of the token to be transferred
1700      * @param _data bytes optional data to send along with the call
1701      * @return bool whether the call correctly returned the expected magic value
1702      */
1703     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1704         private returns (bool)
1705     {
1706         if (!to.isContract()) {
1707             return true;
1708         }
1709         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1710             IERC721Receiver(to).onERC721Received.selector,
1711             _msgSender(),
1712             from,
1713             tokenId,
1714             _data
1715         ), "ERC721: transfer to non ERC721Receiver implementer");
1716         bytes4 retval = abi.decode(returndata, (bytes4));
1717         return (retval == _ERC721_RECEIVED);
1718     }
1719 
1720     function _approve(address to, uint256 tokenId) private {
1721         _tokenApprovals[tokenId] = to;
1722         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1723     }
1724 
1725     /**
1726      * @dev Hook that is called before any token transfer. This includes minting
1727      * and burning.
1728      *
1729      * Calling conditions:
1730      *
1731      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1732      * transferred to `to`.
1733      * - When `from` is zero, `tokenId` will be minted for `to`.
1734      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1735      * - `from` cannot be the zero address.
1736      * - `to` cannot be the zero address.
1737      *
1738      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1739      */
1740     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1741 }
1742 
1743 
1744 /**
1745  * @dev Contract module which provides a basic access control mechanism, where
1746  * there is an account (an owner) that can be granted exclusive access to
1747  * specific functions.
1748  *
1749  * By default, the owner account will be the one that deploys the contract. This
1750  * can later be changed with {transferOwnership}.
1751  *
1752  * This module is used through inheritance. It will make available the modifier
1753  * `onlyOwner`, which can be applied to your functions to restrict their use to
1754  * the owner.
1755  */
1756 abstract contract Ownable is Context {
1757     address private _owner;
1758 
1759     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1760 
1761     /**
1762      * @dev Initializes the contract setting the deployer as the initial owner.
1763      */
1764     constructor () internal {
1765         address msgSender = _msgSender();
1766         _owner = msgSender;
1767         emit OwnershipTransferred(address(0), msgSender);
1768     }
1769 
1770     /**
1771      * @dev Returns the address of the current owner.
1772      */
1773     function owner() public view virtual returns (address) {
1774         return _owner;
1775     }
1776 
1777     /**
1778      * @dev Throws if called by any account other than the owner.
1779      */
1780     modifier onlyOwner() {
1781         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1782         _;
1783     }
1784 
1785     /**
1786      * @dev Leaves the contract without owner. It will not be possible to call
1787      * `onlyOwner` functions anymore. Can only be called by the current owner.
1788      *
1789      * NOTE: Renouncing ownership will leave the contract without an owner,
1790      * thereby removing any functionality that is only available to the owner.
1791      */
1792     function renounceOwnership() public virtual onlyOwner {
1793         emit OwnershipTransferred(_owner, address(0));
1794         _owner = address(0);
1795     }
1796 
1797     /**
1798      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1799      * Can only be called by the current owner.
1800      */
1801     function transferOwnership(address newOwner) public virtual onlyOwner {
1802         require(newOwner != address(0), "Ownable: new owner is the zero address");
1803         emit OwnershipTransferred(_owner, newOwner);
1804         _owner = newOwner;
1805     }
1806 }
1807 
1808 
1809 contract CryptoBears is ERC721,Ownable {
1810     
1811   
1812     uint256 public constant MAX_TOKENS = 3333;
1813     
1814     uint256 public constant MAX_TOKENS_PER_PURCHASE = 20;
1815 
1816     uint256 private price = 25000000000000000; // 0.025 Ether
1817 
1818     bool public isSaleActive = false;
1819 
1820     constructor() public 
1821     ERC721("CryptoBears NFT", "CBEARS") {
1822        
1823     }
1824 
1825         
1826     function reserveTokens(address _to, uint256 _reserveAmount) public onlyOwner {        
1827         uint supply = totalSupply();
1828         for (uint i = 0; i < _reserveAmount; i++) {
1829             _safeMint(_to, supply + i);
1830         }
1831     }
1832     
1833     function mint(uint256 _count) public payable {
1834         uint256 totalSupply = totalSupply();
1835 
1836         require(isSaleActive, "Sale is not active" );
1837         require(_count > 0 && _count < MAX_TOKENS_PER_PURCHASE + 1, "Exceeds maximum tokens you can purchase in a single transaction");
1838         require(totalSupply + _count < MAX_TOKENS + 1, "Exceeds maximum tokens available for purchase");
1839         require(msg.value >= price.mul(_count), "Ether value sent is not correct");
1840         
1841         for(uint256 i = 0; i < _count; i++){
1842             _safeMint(msg.sender, totalSupply + i);
1843         }
1844     }
1845 
1846     function setBaseURI(string memory _baseURI) public onlyOwner {
1847         _setBaseURI(_baseURI);
1848     }
1849 
1850     function flipSaleStatus() public onlyOwner {
1851         isSaleActive = !isSaleActive;
1852     }
1853      
1854     function setPrice(uint256 _newPrice) public onlyOwner() {
1855         price = _newPrice;
1856     }
1857 
1858     function getPrice() public view returns (uint256){
1859         return price;
1860     }
1861 
1862     function withdraw() public onlyOwner {
1863         uint256 balance = address(this).balance;
1864         msg.sender.transfer(balance);
1865     }
1866     
1867     function tokensByOwner(address _owner) external view returns(uint256[] memory ) {
1868         uint256 tokenCount = balanceOf(_owner);
1869         if (tokenCount == 0) {
1870             return new uint256[](0);
1871         } else {
1872             uint256[] memory result = new uint256[](tokenCount);
1873             uint256 index;
1874             for (index = 0; index < tokenCount; index++) {
1875                 result[index] = tokenOfOwnerByIndex(_owner, index);
1876             }
1877             return result;
1878         }
1879     }
1880 }