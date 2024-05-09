1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-18
7 */
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(address from, address to, uint256 tokenId) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address from, address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122      * The approval is cleared when the token is transferred.
123      *
124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125      *
126      * Requirements:
127      *
128      * - The caller must own the token or be an approved operator.
129      * - `tokenId` must exist.
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Returns the account approved for `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function getApproved(uint256 tokenId) external view returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator) external view returns (bool);
162 
163     /**
164       * @dev Safely transfers `tokenId` token from `from` to `to`.
165       *
166       * Requirements:
167       *
168       * - `from` cannot be the zero address.
169       * - `to` cannot be the zero address.
170       * - `tokenId` token must exist and be owned by `from`.
171       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173       *
174       * Emits a {Transfer} event.
175       */
176     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
177 }
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Metadata is IERC721 {
184 
185     /**
186      * @dev Returns the token collection name.
187      */
188     function name() external view returns (string memory);
189 
190     /**
191      * @dev Returns the token collection symbol.
192      */
193     function symbol() external view returns (string memory);
194 
195     /**
196      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
197      */
198     function tokenURI(uint256 tokenId) external view returns (string memory);
199 }
200 
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Enumerable is IERC721 {
207 
208     /**
209      * @dev Returns the total amount of tokens stored by the contract.
210      */
211     function totalSupply() external view returns (uint256);
212 
213     /**
214      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
215      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
216      */
217     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
218 
219     /**
220      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
221      * Use along with {totalSupply} to enumerate all tokens.
222      */
223     function tokenByIndex(uint256 index) external view returns (uint256);
224 }
225 
226 
227 /**
228  * @title ERC721 token receiver interface
229  * @dev Interface for any contract that wants to support safeTransfers
230  * from ERC721 asset contracts.
231  */
232 interface IERC721Receiver {
233     /**
234      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
235      * by `operator` from `from`, this function is called.
236      *
237      * It must return its Solidity selector to confirm the token transfer.
238      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
239      *
240      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
241      */
242     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
243 }
244 
245 /**
246  * @dev Implementation of the {IERC165} interface.
247  *
248  * Contracts may inherit from this and call {_registerInterface} to declare
249  * their support of an interface.
250  */
251 abstract contract ERC165 is IERC165 {
252     /*
253      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
254      */
255     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
256 
257     /**
258      * @dev Mapping of interface ids to whether or not it's supported.
259      */
260     mapping(bytes4 => bool) private _supportedInterfaces;
261 
262     constructor () internal {
263         // Derived contracts need only register support for their own interfaces,
264         // we register support for ERC165 itself here
265         _registerInterface(_INTERFACE_ID_ERC165);
266     }
267 
268     /**
269      * @dev See {IERC165-supportsInterface}.
270      *
271      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
272      */
273     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
274         return _supportedInterfaces[interfaceId];
275     }
276 
277     /**
278      * @dev Registers the contract as an implementer of the interface defined by
279      * `interfaceId`. Support of the actual ERC165 interface is automatic and
280      * registering its interface id is not required.
281      *
282      * See {IERC165-supportsInterface}.
283      *
284      * Requirements:
285      *
286      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
287      */
288     function _registerInterface(bytes4 interfaceId) internal virtual {
289         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
290         _supportedInterfaces[interfaceId] = true;
291     }
292 }
293 
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
692 /**
693  * @dev Library for managing
694  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
695  * types.
696  *
697  * Sets have the following properties:
698  *
699  * - Elements are added, removed, and checked for existence in constant time
700  * (O(1)).
701  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
702  *
703  * ```
704  * contract Example {
705  *     // Add the library methods
706  *     using EnumerableSet for EnumerableSet.AddressSet;
707  *
708  *     // Declare a set state variable
709  *     EnumerableSet.AddressSet private mySet;
710  * }
711  * ```
712  *
713  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
714  * and `uint256` (`UintSet`) are supported.
715  */
716 library EnumerableSet {
717     // To implement this library for multiple types with as little code
718     // repetition as possible, we write it in terms of a generic Set type with
719     // bytes32 values.
720     // The Set implementation uses private functions, and user-facing
721     // implementations (such as AddressSet) are just wrappers around the
722     // underlying Set.
723     // This means that we can only create new EnumerableSets for types that fit
724     // in bytes32.
725 
726     struct Set {
727         // Storage of set values
728         bytes32[] _values;
729 
730         // Position of the value in the `values` array, plus 1 because index 0
731         // means a value is not in the set.
732         mapping (bytes32 => uint256) _indexes;
733     }
734 
735     /**
736      * @dev Add a value to a set. O(1).
737      *
738      * Returns true if the value was added to the set, that is if it was not
739      * already present.
740      */
741     function _add(Set storage set, bytes32 value) private returns (bool) {
742         if (!_contains(set, value)) {
743             set._values.push(value);
744             // The value is stored at length-1, but we add 1 to all indexes
745             // and use 0 as a sentinel value
746             set._indexes[value] = set._values.length;
747             return true;
748         } else {
749             return false;
750         }
751     }
752 
753     /**
754      * @dev Removes a value from a set. O(1).
755      *
756      * Returns true if the value was removed from the set, that is if it was
757      * present.
758      */
759     function _remove(Set storage set, bytes32 value) private returns (bool) {
760         // We read and store the value's index to prevent multiple reads from the same storage slot
761         uint256 valueIndex = set._indexes[value];
762 
763         if (valueIndex != 0) { // Equivalent to contains(set, value)
764             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
765             // the array, and then remove the last element (sometimes called as 'swap and pop').
766             // This modifies the order of the array, as noted in {at}.
767 
768             uint256 toDeleteIndex = valueIndex - 1;
769             uint256 lastIndex = set._values.length - 1;
770 
771             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
772             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
773 
774             bytes32 lastvalue = set._values[lastIndex];
775 
776             // Move the last value to the index where the value to delete is
777             set._values[toDeleteIndex] = lastvalue;
778             // Update the index for the moved value
779             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
780 
781             // Delete the slot where the moved value was stored
782             set._values.pop();
783 
784             // Delete the index for the deleted slot
785             delete set._indexes[value];
786 
787             return true;
788         } else {
789             return false;
790         }
791     }
792 
793     /**
794      * @dev Returns true if the value is in the set. O(1).
795      */
796     function _contains(Set storage set, bytes32 value) private view returns (bool) {
797         return set._indexes[value] != 0;
798     }
799 
800     /**
801      * @dev Returns the number of values on the set. O(1).
802      */
803     function _length(Set storage set) private view returns (uint256) {
804         return set._values.length;
805     }
806 
807    /**
808     * @dev Returns the value stored at position `index` in the set. O(1).
809     *
810     * Note that there are no guarantees on the ordering of values inside the
811     * array, and it may change when more values are added or removed.
812     *
813     * Requirements:
814     *
815     * - `index` must be strictly less than {length}.
816     */
817     function _at(Set storage set, uint256 index) private view returns (bytes32) {
818         require(set._values.length > index, "EnumerableSet: index out of bounds");
819         return set._values[index];
820     }
821 
822     // Bytes32Set
823 
824     struct Bytes32Set {
825         Set _inner;
826     }
827 
828     /**
829      * @dev Add a value to a set. O(1).
830      *
831      * Returns true if the value was added to the set, that is if it was not
832      * already present.
833      */
834     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
835         return _add(set._inner, value);
836     }
837 
838     /**
839      * @dev Removes a value from a set. O(1).
840      *
841      * Returns true if the value was removed from the set, that is if it was
842      * present.
843      */
844     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
845         return _remove(set._inner, value);
846     }
847 
848     /**
849      * @dev Returns true if the value is in the set. O(1).
850      */
851     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
852         return _contains(set._inner, value);
853     }
854 
855     /**
856      * @dev Returns the number of values in the set. O(1).
857      */
858     function length(Bytes32Set storage set) internal view returns (uint256) {
859         return _length(set._inner);
860     }
861 
862    /**
863     * @dev Returns the value stored at position `index` in the set. O(1).
864     *
865     * Note that there are no guarantees on the ordering of values inside the
866     * array, and it may change when more values are added or removed.
867     *
868     * Requirements:
869     *
870     * - `index` must be strictly less than {length}.
871     */
872     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
873         return _at(set._inner, index);
874     }
875 
876     // AddressSet
877 
878     struct AddressSet {
879         Set _inner;
880     }
881 
882     /**
883      * @dev Add a value to a set. O(1).
884      *
885      * Returns true if the value was added to the set, that is if it was not
886      * already present.
887      */
888     function add(AddressSet storage set, address value) internal returns (bool) {
889         return _add(set._inner, bytes32(uint256(uint160(value))));
890     }
891 
892     /**
893      * @dev Removes a value from a set. O(1).
894      *
895      * Returns true if the value was removed from the set, that is if it was
896      * present.
897      */
898     function remove(AddressSet storage set, address value) internal returns (bool) {
899         return _remove(set._inner, bytes32(uint256(uint160(value))));
900     }
901 
902     /**
903      * @dev Returns true if the value is in the set. O(1).
904      */
905     function contains(AddressSet storage set, address value) internal view returns (bool) {
906         return _contains(set._inner, bytes32(uint256(uint160(value))));
907     }
908 
909     /**
910      * @dev Returns the number of values in the set. O(1).
911      */
912     function length(AddressSet storage set) internal view returns (uint256) {
913         return _length(set._inner);
914     }
915 
916    /**
917     * @dev Returns the value stored at position `index` in the set. O(1).
918     *
919     * Note that there are no guarantees on the ordering of values inside the
920     * array, and it may change when more values are added or removed.
921     *
922     * Requirements:
923     *
924     * - `index` must be strictly less than {length}.
925     */
926     function at(AddressSet storage set, uint256 index) internal view returns (address) {
927         return address(uint160(uint256(_at(set._inner, index))));
928     }
929 
930 
931     // UintSet
932 
933     struct UintSet {
934         Set _inner;
935     }
936 
937     /**
938      * @dev Add a value to a set. O(1).
939      *
940      * Returns true if the value was added to the set, that is if it was not
941      * already present.
942      */
943     function add(UintSet storage set, uint256 value) internal returns (bool) {
944         return _add(set._inner, bytes32(value));
945     }
946 
947     /**
948      * @dev Removes a value from a set. O(1).
949      *
950      * Returns true if the value was removed from the set, that is if it was
951      * present.
952      */
953     function remove(UintSet storage set, uint256 value) internal returns (bool) {
954         return _remove(set._inner, bytes32(value));
955     }
956 
957     /**
958      * @dev Returns true if the value is in the set. O(1).
959      */
960     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
961         return _contains(set._inner, bytes32(value));
962     }
963 
964     /**
965      * @dev Returns the number of values on the set. O(1).
966      */
967     function length(UintSet storage set) internal view returns (uint256) {
968         return _length(set._inner);
969     }
970 
971    /**
972     * @dev Returns the value stored at position `index` in the set. O(1).
973     *
974     * Note that there are no guarantees on the ordering of values inside the
975     * array, and it may change when more values are added or removed.
976     *
977     * Requirements:
978     *
979     * - `index` must be strictly less than {length}.
980     */
981     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
982         return uint256(_at(set._inner, index));
983     }
984 }
985 
986 /**
987  * @dev Library for managing an enumerable variant of Solidity's
988  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
989  * type.
990  *
991  * Maps have the following properties:
992  *
993  * - Entries are added, removed, and checked for existence in constant time
994  * (O(1)).
995  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
996  *
997  * ```
998  * contract Example {
999  *     // Add the library methods
1000  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1001  *
1002  *     // Declare a set state variable
1003  *     EnumerableMap.UintToAddressMap private myMap;
1004  * }
1005  * ```
1006  *
1007  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1008  * supported.
1009  */
1010 library EnumerableMap {
1011     // To implement this library for multiple types with as little code
1012     // repetition as possible, we write it in terms of a generic Map type with
1013     // bytes32 keys and values.
1014     // The Map implementation uses private functions, and user-facing
1015     // implementations (such as Uint256ToAddressMap) are just wrappers around
1016     // the underlying Map.
1017     // This means that we can only create new EnumerableMaps for types that fit
1018     // in bytes32.
1019 
1020     struct MapEntry {
1021         bytes32 _key;
1022         bytes32 _value;
1023     }
1024 
1025     struct Map {
1026         // Storage of map keys and values
1027         MapEntry[] _entries;
1028 
1029         // Position of the entry defined by a key in the `entries` array, plus 1
1030         // because index 0 means a key is not in the map.
1031         mapping (bytes32 => uint256) _indexes;
1032     }
1033 
1034     /**
1035      * @dev Adds a key-value pair to a map, or updates the value for an existing
1036      * key. O(1).
1037      *
1038      * Returns true if the key was added to the map, that is if it was not
1039      * already present.
1040      */
1041     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1042         // We read and store the key's index to prevent multiple reads from the same storage slot
1043         uint256 keyIndex = map._indexes[key];
1044 
1045         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1046             map._entries.push(MapEntry({ _key: key, _value: value }));
1047             // The entry is stored at length-1, but we add 1 to all indexes
1048             // and use 0 as a sentinel value
1049             map._indexes[key] = map._entries.length;
1050             return true;
1051         } else {
1052             map._entries[keyIndex - 1]._value = value;
1053             return false;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Removes a key-value pair from a map. O(1).
1059      *
1060      * Returns true if the key was removed from the map, that is if it was present.
1061      */
1062     function _remove(Map storage map, bytes32 key) private returns (bool) {
1063         // We read and store the key's index to prevent multiple reads from the same storage slot
1064         uint256 keyIndex = map._indexes[key];
1065 
1066         if (keyIndex != 0) { // Equivalent to contains(map, key)
1067             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1068             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1069             // This modifies the order of the array, as noted in {at}.
1070 
1071             uint256 toDeleteIndex = keyIndex - 1;
1072             uint256 lastIndex = map._entries.length - 1;
1073 
1074             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1075             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1076 
1077             MapEntry storage lastEntry = map._entries[lastIndex];
1078 
1079             // Move the last entry to the index where the entry to delete is
1080             map._entries[toDeleteIndex] = lastEntry;
1081             // Update the index for the moved entry
1082             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1083 
1084             // Delete the slot where the moved entry was stored
1085             map._entries.pop();
1086 
1087             // Delete the index for the deleted slot
1088             delete map._indexes[key];
1089 
1090             return true;
1091         } else {
1092             return false;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns true if the key is in the map. O(1).
1098      */
1099     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1100         return map._indexes[key] != 0;
1101     }
1102 
1103     /**
1104      * @dev Returns the number of key-value pairs in the map. O(1).
1105      */
1106     function _length(Map storage map) private view returns (uint256) {
1107         return map._entries.length;
1108     }
1109 
1110    /**
1111     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1112     *
1113     * Note that there are no guarantees on the ordering of entries inside the
1114     * array, and it may change when more entries are added or removed.
1115     *
1116     * Requirements:
1117     *
1118     * - `index` must be strictly less than {length}.
1119     */
1120     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1121         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1122 
1123         MapEntry storage entry = map._entries[index];
1124         return (entry._key, entry._value);
1125     }
1126 
1127     /**
1128      * @dev Tries to returns the value associated with `key`.  O(1).
1129      * Does not revert if `key` is not in the map.
1130      */
1131     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1132         uint256 keyIndex = map._indexes[key];
1133         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1134         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1135     }
1136 
1137     /**
1138      * @dev Returns the value associated with `key`.  O(1).
1139      *
1140      * Requirements:
1141      *
1142      * - `key` must be in the map.
1143      */
1144     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1145         uint256 keyIndex = map._indexes[key];
1146         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1147         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1148     }
1149 
1150     /**
1151      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1152      *
1153      * CAUTION: This function is deprecated because it requires allocating memory for the error
1154      * message unnecessarily. For custom revert reasons use {_tryGet}.
1155      */
1156     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1157         uint256 keyIndex = map._indexes[key];
1158         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1159         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1160     }
1161 
1162     // UintToAddressMap
1163 
1164     struct UintToAddressMap {
1165         Map _inner;
1166     }
1167 
1168     /**
1169      * @dev Adds a key-value pair to a map, or updates the value for an existing
1170      * key. O(1).
1171      *
1172      * Returns true if the key was added to the map, that is if it was not
1173      * already present.
1174      */
1175     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1176         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1177     }
1178 
1179     /**
1180      * @dev Removes a value from a set. O(1).
1181      *
1182      * Returns true if the key was removed from the map, that is if it was present.
1183      */
1184     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1185         return _remove(map._inner, bytes32(key));
1186     }
1187 
1188     /**
1189      * @dev Returns true if the key is in the map. O(1).
1190      */
1191     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1192         return _contains(map._inner, bytes32(key));
1193     }
1194 
1195     /**
1196      * @dev Returns the number of elements in the map. O(1).
1197      */
1198     function length(UintToAddressMap storage map) internal view returns (uint256) {
1199         return _length(map._inner);
1200     }
1201 
1202    /**
1203     * @dev Returns the element stored at position `index` in the set. O(1).
1204     * Note that there are no guarantees on the ordering of values inside the
1205     * array, and it may change when more values are added or removed.
1206     *
1207     * Requirements:
1208     *
1209     * - `index` must be strictly less than {length}.
1210     */
1211     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1212         (bytes32 key, bytes32 value) = _at(map._inner, index);
1213         return (uint256(key), address(uint160(uint256(value))));
1214     }
1215 
1216     /**
1217      * @dev Tries to returns the value associated with `key`.  O(1).
1218      * Does not revert if `key` is not in the map.
1219      *
1220      * _Available since v3.4._
1221      */
1222     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1223         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1224         return (success, address(uint160(uint256(value))));
1225     }
1226 
1227     /**
1228      * @dev Returns the value associated with `key`.  O(1).
1229      *
1230      * Requirements:
1231      *
1232      * - `key` must be in the map.
1233      */
1234     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1235         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1236     }
1237 
1238     /**
1239      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1240      *
1241      * CAUTION: This function is deprecated because it requires allocating memory for the error
1242      * message unnecessarily. For custom revert reasons use {tryGet}.
1243      */
1244     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1245         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1246     }
1247 }
1248 
1249 /**
1250  * @dev String operations.
1251  */
1252 library Strings {
1253     /**
1254      * @dev Converts a `uint256` to its ASCII `string` representation.
1255      */
1256     function toString(uint256 value) internal pure returns (string memory) {
1257         // Inspired by OraclizeAPI's implementation - MIT licence
1258         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1259 
1260         if (value == 0) {
1261             return "0";
1262         }
1263         uint256 temp = value;
1264         uint256 digits;
1265         while (temp != 0) {
1266             digits++;
1267             temp /= 10;
1268         }
1269         bytes memory buffer = new bytes(digits);
1270         uint256 index = digits - 1;
1271         temp = value;
1272         while (temp != 0) {
1273             buffer[index--] = bytes1(uint8(48 + temp % 10));
1274             temp /= 10;
1275         }
1276         return string(buffer);
1277     }
1278 }
1279 
1280 
1281 /**
1282  * @title ERC721 Non-Fungible Token Standard basic implementation
1283  * @dev see https://eips.ethereum.org/EIPS/eip-721
1284  */
1285 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1286     using SafeMath for uint256;
1287     using Address for address;
1288     using EnumerableSet for EnumerableSet.UintSet;
1289     using EnumerableMap for EnumerableMap.UintToAddressMap;
1290     using Strings for uint256;
1291 
1292     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1293     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1294     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1295 
1296     // Mapping from holder address to their (enumerable) set of owned tokens
1297     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1298 
1299     // Enumerable mapping from token ids to their owners
1300     EnumerableMap.UintToAddressMap private _tokenOwners;
1301 
1302     // Mapping from token ID to approved address
1303     mapping (uint256 => address) private _tokenApprovals;
1304 
1305     // Mapping from owner to operator approvals
1306     mapping (address => mapping (address => bool)) private _operatorApprovals;
1307 
1308     // Token name
1309     string private _name;
1310 
1311     // Token symbol
1312     string private _symbol;
1313 
1314     // Optional mapping for token URIs
1315     mapping (uint256 => string) private _tokenURIs;
1316 
1317     // Base URI
1318     string private _baseURI;
1319 
1320     /*
1321      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1322      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1323      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1324      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1325      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1326      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1327      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1328      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1329      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1330      *
1331      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1332      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1333      */
1334     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1335 
1336     /*
1337      *     bytes4(keccak256('name()')) == 0x06fdde03
1338      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1339      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1340      *
1341      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1342      */
1343     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1344 
1345     /*
1346      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1347      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1348      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1349      *
1350      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1351      */
1352     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1353 
1354     /**
1355      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1356      */
1357     constructor (string memory name_, string memory symbol_) public {
1358         _name = name_;
1359         _symbol = symbol_;
1360 
1361         // register the supported interfaces to conform to ERC721 via ERC165
1362         _registerInterface(_INTERFACE_ID_ERC721);
1363         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1364         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-balanceOf}.
1369      */
1370     function balanceOf(address owner) public view virtual override returns (uint256) {
1371         require(owner != address(0), "ERC721: balance query for the zero address");
1372         return _holderTokens[owner].length();
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-ownerOf}.
1377      */
1378     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1379         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1380     }
1381 
1382     /**
1383      * @dev See {IERC721Metadata-name}.
1384      */
1385     function name() public view virtual override returns (string memory) {
1386         return _name;
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Metadata-symbol}.
1391      */
1392     function symbol() public view virtual override returns (string memory) {
1393         return _symbol;
1394     }
1395 
1396     /**
1397      * @dev See {IERC721Metadata-tokenURI}.
1398      */
1399     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1400         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1401 
1402         string memory _tokenURI = _tokenURIs[tokenId];
1403         string memory base = baseURI();
1404 
1405         // If there is no base URI, return the token URI.
1406         if (bytes(base).length == 0) {
1407             return _tokenURI;
1408         }
1409         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1410         if (bytes(_tokenURI).length > 0) {
1411             return string(abi.encodePacked(base, _tokenURI, '.json'));
1412         }
1413         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1414         return string(abi.encodePacked(base, (tokenId.toString())));
1415     }
1416 
1417     /**
1418     * @dev Returns the base URI set via {_setBaseURI}. This will be
1419     * automatically added as a prefix in {tokenURI} to each token's URI, or
1420     * to the token ID if no specific URI is set for that token ID.
1421     */
1422     function baseURI() public view virtual returns (string memory) {
1423         return _baseURI;
1424     }
1425 
1426     /**
1427      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1428      */
1429     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1430         return _holderTokens[owner].at(index);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721Enumerable-totalSupply}.
1435      */
1436     function totalSupply() public view virtual override returns (uint256) {
1437         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1438         return _tokenOwners.length();
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Enumerable-tokenByIndex}.
1443      */
1444     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1445         (uint256 tokenId, ) = _tokenOwners.at(index);
1446         return tokenId;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-approve}.
1451      */
1452     function approve(address to, uint256 tokenId) public virtual override {
1453         address owner = ERC721.ownerOf(tokenId);
1454         require(to != owner, "ERC721: approval to current owner");
1455 
1456         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1457             "ERC721: approve caller is not owner nor approved for all"
1458         );
1459 
1460         _approve(to, tokenId);
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-getApproved}.
1465      */
1466     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1467         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1468 
1469         return _tokenApprovals[tokenId];
1470     }
1471 
1472     /**
1473      * @dev See {IERC721-setApprovalForAll}.
1474      */
1475     function setApprovalForAll(address operator, bool approved) public virtual override {
1476         require(operator != _msgSender(), "ERC721: approve to caller");
1477 
1478         _operatorApprovals[_msgSender()][operator] = approved;
1479         emit ApprovalForAll(_msgSender(), operator, approved);
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-isApprovedForAll}.
1484      */
1485     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1486         return _operatorApprovals[owner][operator];
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-transferFrom}.
1491      */
1492     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1493         //solhint-disable-next-line max-line-length
1494         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1495 
1496         _transfer(from, to, tokenId);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721-safeTransferFrom}.
1501      */
1502     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1503         safeTransferFrom(from, to, tokenId, "");
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-safeTransferFrom}.
1508      */
1509     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1510         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1511         _safeTransfer(from, to, tokenId, _data);
1512     }
1513 
1514     /**
1515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1517      *
1518      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1519      *
1520      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1521      * implement alternative mechanisms to perform token transfer, such as signature-based.
1522      *
1523      * Requirements:
1524      *
1525      * - `from` cannot be the zero address.
1526      * - `to` cannot be the zero address.
1527      * - `tokenId` token must exist and be owned by `from`.
1528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1533         _transfer(from, to, tokenId);
1534         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1535     }
1536 
1537     /**
1538      * @dev Returns whether `tokenId` exists.
1539      *
1540      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1541      *
1542      * Tokens start existing when they are minted (`_mint`),
1543      * and stop existing when they are burned (`_burn`).
1544      */
1545     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1546         return _tokenOwners.contains(tokenId);
1547     }
1548 
1549     /**
1550      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1551      *
1552      * Requirements:
1553      *
1554      * - `tokenId` must exist.
1555      */
1556     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1557         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1558         address owner = ERC721.ownerOf(tokenId);
1559         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1560     }
1561 
1562     /**
1563      * @dev Safely mints `tokenId` and transfers it to `to`.
1564      *
1565      * Requirements:
1566      d*
1567      * - `tokenId` must not exist.
1568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1569      *
1570      * Emits a {Transfer} event.
1571      */
1572     function _safeMint(address to, uint256 tokenId) internal virtual {
1573         _safeMint(to, tokenId, "");
1574     }
1575 
1576     /**
1577      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1578      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1579      */
1580     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1581         _mint(to, tokenId);
1582         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1583     }
1584 
1585     /**
1586      * @dev Mints `tokenId` and transfers it to `to`.
1587      *
1588      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1589      *
1590      * Requirements:
1591      *
1592      * - `tokenId` must not exist.
1593      * - `to` cannot be the zero address.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _mint(address to, uint256 tokenId) internal virtual {
1598         require(to != address(0), "ERC721: mint to the zero address");
1599         require(!_exists(tokenId), "ERC721: token already minted");
1600 
1601         _beforeTokenTransfer(address(0), to, tokenId);
1602 
1603         _holderTokens[to].add(tokenId);
1604 
1605         _tokenOwners.set(tokenId, to);
1606 
1607         emit Transfer(address(0), to, tokenId);
1608     }
1609 
1610     /**
1611      * @dev Destroys `tokenId`.
1612      * The approval is cleared when the token is burned.
1613      *
1614      * Requirements:
1615      *
1616      * - `tokenId` must exist.
1617      *
1618      * Emits a {Transfer} event.
1619      */
1620     function _burn(uint256 tokenId) internal virtual {
1621         address owner = ERC721.ownerOf(tokenId); // internal owner
1622 
1623         _beforeTokenTransfer(owner, address(0), tokenId);
1624 
1625         // Clear approvals
1626         _approve(address(0), tokenId);
1627 
1628         // Clear metadata (if any)
1629         if (bytes(_tokenURIs[tokenId]).length != 0) {
1630             delete _tokenURIs[tokenId];
1631         }
1632 
1633         _holderTokens[owner].remove(tokenId);
1634 
1635         _tokenOwners.remove(tokenId);
1636 
1637         emit Transfer(owner, address(0), tokenId);
1638     }
1639 
1640     /**
1641      * @dev Transfers `tokenId` from `from` to `to`.
1642      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1643      *
1644      * Requirements:
1645      *
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must be owned by `from`.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1652         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1653         require(to != address(0), "ERC721: transfer to the zero address");
1654 
1655         _beforeTokenTransfer(from, to, tokenId);
1656 
1657         // Clear approvals from the previous owner
1658         _approve(address(0), tokenId);
1659 
1660         _holderTokens[from].remove(tokenId);
1661         _holderTokens[to].add(tokenId);
1662 
1663         _tokenOwners.set(tokenId, to);
1664 
1665         emit Transfer(from, to, tokenId);
1666     }
1667 
1668     /**
1669      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1670      *
1671      * Requirements:
1672      *
1673      * - `tokenId` must exist.
1674      */
1675     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1676         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1677         _tokenURIs[tokenId] = _tokenURI;
1678     }
1679 
1680     /**
1681      * @dev Internal function to set the base URI for all token IDs. It is
1682      * automatically added as a prefix to the value returned in {tokenURI},
1683      * or to the token ID if {tokenURI} is empty.
1684      */
1685     function _setBaseURI(string memory baseURI_) internal virtual {
1686         _baseURI = baseURI_;
1687     }
1688 
1689     /**
1690      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1691      * The call is not executed if the target address is not a contract.
1692      *
1693      * @param from address representing the previous owner of the given token ID
1694      * @param to target address that will receive the tokens
1695      * @param tokenId uint256 ID of the token to be transferred
1696      * @param _data bytes optional data to send along with the call
1697      * @return bool whether the call correctly returned the expected magic value
1698      */
1699     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1700         private returns (bool)
1701     {
1702         if (!to.isContract()) {
1703             return true;
1704         }
1705         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1706             IERC721Receiver(to).onERC721Received.selector,
1707             _msgSender(),
1708             from,
1709             tokenId,
1710             _data
1711         ), "ERC721: transfer to non ERC721Receiver implementer");
1712         bytes4 retval = abi.decode(returndata, (bytes4));
1713         return (retval == _ERC721_RECEIVED);
1714     }
1715 
1716     /**
1717      * @dev Approve `to` to operate on `tokenId`
1718      *
1719      * Emits an {Approval} event.
1720      */
1721     function _approve(address to, uint256 tokenId) internal virtual {
1722         _tokenApprovals[tokenId] = to;
1723         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1724     }
1725 
1726     /**
1727      * @dev Hook that is called before any token transfer. This includes minting
1728      * and burning.
1729      *
1730      * Calling conditions:
1731      *
1732      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1733      * transferred to `to`.
1734      * - When `from` is zero, `tokenId` will be minted for `to`.
1735      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1736      * - `from` cannot be the zero address.
1737      * - `to` cannot be the zero address.
1738      *
1739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1740      */
1741     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1742 }
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
1808 interface KILLAzInterface {
1809     function ownerOf(uint256 tokenId) external view returns (address owner);
1810     function balanceOf(address owner) external view returns (uint256 balance);
1811     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1812 }
1813 
1814 contract LadyKILLAz is ERC721, Ownable {
1815     using SafeMath for uint256;
1816 
1817     KILLAzInterface public immutable KILLAz;
1818     uint256 public immutable pricePerLadyKILLA;
1819     uint256 public immutable maxPerTx;
1820     uint256 public immutable maxLadyKILLAz;
1821     bool public isSaleActive;
1822     uint256 public saleStartTime;
1823 
1824     constructor(address _KILLAz)
1825         public
1826         ERC721("Lady KILLAz", "LKz")
1827     {
1828         pricePerLadyKILLA = 0.058 * 10 ** 18;
1829         maxPerTx = 5;
1830         maxLadyKILLAz = 9971;
1831         KILLAz = KILLAzInterface(_KILLAz);
1832     }
1833 
1834     function claim(uint256 [] memory _tokenIds) public {
1835         require(isSaleActive, "Sale is not active");
1836         require(isClaimTime(), "Claim time is finished");
1837         for (uint i = 0; i < _tokenIds.length; i++) {
1838             require(KILLAz_ownerOf(_tokenIds[i]) == msg.sender, "It is possible to claim only corresponding tokens");
1839              if (totalSupply() < maxLadyKILLAz) {
1840                 _safeMint(msg.sender, _tokenIds[i]);
1841             }
1842         }
1843     }
1844 
1845     function buy(uint256 [] memory _tokenIds) public payable {
1846         require(isSaleActive, "Sale is not active");
1847         require(!isClaimTime(), "The purchase of tokens will be possible after claim time");
1848         require(_tokenIds.length <= maxPerTx, "No more than 5 tokens per transaction");
1849         require(totalSupply().add(_tokenIds.length) <= maxLadyKILLAz, "Purchase would exceed max supply of Lady KILLAz");
1850         require(pricePerLadyKILLA.mul(_tokenIds.length) == msg.value, "Ether value is not correct");
1851 
1852         for (uint i = 0; i < _tokenIds.length; i++) {
1853             require(_tokenIds[i] < maxLadyKILLAz);
1854             if (totalSupply() < maxLadyKILLAz) {
1855                 _safeMint(msg.sender, _tokenIds[i]);
1856             }
1857         }
1858 
1859         payable(owner()).transfer(msg.value);
1860     }
1861 
1862 
1863 
1864 
1865 
1866     function startSale() public onlyOwner {
1867         isSaleActive = true;
1868         saleStartTime = block.timestamp;
1869     }
1870 
1871     function setBaseURI(string memory baseURI) public onlyOwner {
1872         _setBaseURI(baseURI);
1873     }
1874 
1875     function doesTokenExist(uint256 _tokenId) public view returns (bool) {
1876         return _exists(_tokenId);
1877     }
1878 
1879     function isClaimTime() public view returns (bool) {
1880         if(block.timestamp <= saleStartTime + 48 hours) return true;
1881         else return false;
1882     }
1883 
1884     function KILLAz_ownerOf(uint256 tokenId) public view returns (address) {
1885         return KILLAz.ownerOf(tokenId);
1886     }
1887 
1888     function KILLAz_balanceOf(address owner) public view returns (uint256) {
1889          return KILLAz.balanceOf(owner);
1890     }
1891 
1892     function KILLAz_tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1893         return KILLAz.tokenOfOwnerByIndex(owner, index);
1894     }
1895 
1896 }