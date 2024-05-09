1 /**
2  *Submitted for verification at BscScan.com on 2021-12-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-01
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-08-18
11 */
12 
13 pragma solidity >=0.6.0 <0.8.0;
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
31         this;
32         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     /**
80      * @dev Returns the number of tokens in ``owner``'s account.
81      */
82     function balanceOf(address owner) external view returns (uint256 balance);
83 
84     /**
85      * @dev Returns the owner of the `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     /**
94      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
95      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must exist and be owned by `from`.
102      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
104      *
105      * Emits a {Transfer} event.
106      */
107     function safeTransferFrom(address from, address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(address from, address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169       * @dev Safely transfers `tokenId` token from `from` to `to`.
170       *
171       * Requirements:
172       *
173       * - `from` cannot be the zero address.
174       * - `to` cannot be the zero address.
175       * - `tokenId` token must exist and be owned by `from`.
176       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178       *
179       * Emits a {Transfer} event.
180       */
181     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
182 }
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189 
190     /**
191      * @dev Returns the token collection name.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the token collection symbol.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
202      */
203     function tokenURI(uint256 tokenId) external view returns (string memory);
204 }
205 
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Enumerable is IERC721 {
212 
213     /**
214      * @dev Returns the total amount of tokens stored by the contract.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     /**
219      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
220      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
221      */
222     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
223 
224     /**
225      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
226      * Use along with {totalSupply} to enumerate all tokens.
227      */
228     function tokenByIndex(uint256 index) external view returns (uint256);
229 }
230 
231 
232 /**
233  * @title ERC721 token receiver interface
234  * @dev Interface for any contract that wants to support safeTransfers
235  * from ERC721 asset contracts.
236  */
237 interface IERC721Receiver {
238     /**
239      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
240      * by `operator` from `from`, this function is called.
241      *
242      * It must return its Solidity selector to confirm the token transfer.
243      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
244      *
245      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
246      */
247     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
248 }
249 
250 /**
251  * @dev Implementation of the {IERC165} interface.
252  *
253  * Contracts may inherit from this and call {_registerInterface} to declare
254  * their support of an interface.
255  */
256 abstract contract ERC165 is IERC165 {
257     /*
258      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
259      */
260     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
261 
262     /**
263      * @dev Mapping of interface ids to whether or not it's supported.
264      */
265     mapping(bytes4 => bool) private _supportedInterfaces;
266 
267     constructor () internal {
268         // Derived contracts need only register support for their own interfaces,
269         // we register support for ERC165 itself here
270         _registerInterface(_INTERFACE_ID_ERC165);
271     }
272 
273     /**
274      * @dev See {IERC165-supportsInterface}.
275      *
276      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
277      */
278     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
279         return _supportedInterfaces[interfaceId];
280     }
281 
282     /**
283      * @dev Registers the contract as an implementer of the interface defined by
284      * `interfaceId`. Support of the actual ERC165 interface is automatic and
285      * registering its interface id is not required.
286      *
287      * See {IERC165-supportsInterface}.
288      *
289      * Requirements:
290      *
291      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
292      */
293     function _registerInterface(bytes4 interfaceId) internal virtual {
294         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
295         _supportedInterfaces[interfaceId] = true;
296     }
297 }
298 
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, with an overflow flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         uint256 c = a + b;
321         if (c < a) return (false, 0);
322         return (true, c);
323     }
324 
325     /**
326      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
327      *
328      * _Available since v3.4._
329      */
330     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         if (b > a) return (false, 0);
332         return (true, a - b);
333     }
334 
335     /**
336      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
342         // benefit is lost if 'b' is also tested.
343         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
344         if (a == 0) return (true, 0);
345         uint256 c = a * b;
346         if (c / a != b) return (false, 0);
347         return (true, c);
348     }
349 
350     /**
351      * @dev Returns the division of two unsigned integers, with a division by zero flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b == 0) return (false, 0);
357         return (true, a / b);
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         if (b == 0) return (false, 0);
367         return (true, a % b);
368     }
369 
370     /**
371      * @dev Returns the addition of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `+` operator.
375      *
376      * Requirements:
377      *
378      * - Addition cannot overflow.
379      */
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         require(c >= a, "SafeMath: addition overflow");
383         return c;
384     }
385 
386     /**
387      * @dev Returns the subtraction of two unsigned integers, reverting on
388      * overflow (when the result is negative).
389      *
390      * Counterpart to Solidity's `-` operator.
391      *
392      * Requirements:
393      *
394      * - Subtraction cannot overflow.
395      */
396     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
397         require(b <= a, "SafeMath: subtraction overflow");
398         return a - b;
399     }
400 
401     /**
402      * @dev Returns the multiplication of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `*` operator.
406      *
407      * Requirements:
408      *
409      * - Multiplication cannot overflow.
410      */
411     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
412         if (a == 0) return 0;
413         uint256 c = a * b;
414         require(c / a == b, "SafeMath: multiplication overflow");
415         return c;
416     }
417 
418     /**
419      * @dev Returns the integer division of two unsigned integers, reverting on
420      * division by zero. The result is rounded towards zero.
421      *
422      * Counterpart to Solidity's `/` operator. Note: this function uses a
423      * `revert` opcode (which leaves remaining gas untouched) while Solidity
424      * uses an invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
431         require(b > 0, "SafeMath: division by zero");
432         return a / b;
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * reverting when dividing by zero.
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
448         require(b > 0, "SafeMath: modulo by zero");
449         return a % b;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
454      * overflow (when the result is negative).
455      *
456      * CAUTION: This function is deprecated because it requires allocating memory for the error
457      * message unnecessarily. For custom revert reasons use {trySub}.
458      *
459      * Counterpart to Solidity's `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b <= a, errorMessage);
467         return a - b;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
472      * division by zero. The result is rounded towards zero.
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {tryDiv}.
476      *
477      * Counterpart to Solidity's `/` operator. Note: this function uses a
478      * `revert` opcode (which leaves remaining gas untouched) while Solidity
479      * uses an invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b > 0, errorMessage);
487         return a / b;
488     }
489 
490     /**
491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492      * reverting with custom message when dividing by zero.
493      *
494      * CAUTION: This function is deprecated because it requires allocating memory for the error
495      * message unnecessarily. For custom revert reasons use {tryMod}.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      *
503      * - The divisor cannot be zero.
504      */
505     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b > 0, errorMessage);
507         return a % b;
508     }
509 }
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // This method relies on extcodesize, which returns 0 for contracts in
534         // construction, since the code is only stored at the end of the
535         // constructor execution.
536 
537         uint256 size;
538         // solhint-disable-next-line no-inline-assembly
539         assembly {size := extcodesize(account)}
540         return size > 0;
541     }
542 
543     /**
544      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
545      * `recipient`, forwarding all available gas and reverting on errors.
546      *
547      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
548      * of certain opcodes, possibly making contracts go over the 2300 gas limit
549      * imposed by `transfer`, making them unable to receive funds via
550      * `transfer`. {sendValue} removes this limitation.
551      *
552      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
553      *
554      * IMPORTANT: because control is transferred to `recipient`, care must be
555      * taken to not create reentrancy vulnerabilities. Consider using
556      * {ReentrancyGuard} or the
557      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
558      */
559     function sendValue(address payable recipient, uint256 amount) internal {
560         require(address(this).balance >= amount, "Address: insufficient balance");
561 
562         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
563         (bool success,) = recipient.call{value : amount}("");
564         require(success, "Address: unable to send value, recipient may have reverted");
565     }
566 
567     /**
568      * @dev Performs a Solidity function call using a low level `call`. A
569      * plain`call` is an unsafe replacement for a function call: use this
570      * function instead.
571      *
572      * If `target` reverts with a revert reason, it is bubbled up by this
573      * function (like regular Solidity function calls).
574      *
575      * Returns the raw returned data. To convert to the expected return value,
576      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
577      *
578      * Requirements:
579      *
580      * - `target` must be a contract.
581      * - calling `target` with `data` must not revert.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionCall(target, data, "Address: low-level call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
591      * `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, 0, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but also transferring `value` wei to `target`.
602      *
603      * Requirements:
604      *
605      * - the calling contract must have an ETH balance of at least `value`.
606      * - the called Solidity function must be `payable`.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
611         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
616      * with `errorMessage` as a fallback revert reason when `target` reverts.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
621         require(address(this).balance >= value, "Address: insufficient balance for call");
622         require(isContract(target), "Address: call to non-contract");
623 
624         // solhint-disable-next-line avoid-low-level-calls
625         (bool success, bytes memory returndata) = target.call{value : value}(data);
626         return _verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a static call.
632      *
633      * _Available since v3.3._
634      */
635     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
636         return functionStaticCall(target, data, "Address: low-level static call failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
641      * but performing a static call.
642      *
643      * _Available since v3.3._
644      */
645     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
646         require(isContract(target), "Address: static call to non-contract");
647 
648         // solhint-disable-next-line avoid-low-level-calls
649         (bool success, bytes memory returndata) = target.staticcall(data);
650         return _verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
660         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
665      * but performing a delegate call.
666      *
667      * _Available since v3.4._
668      */
669     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
670         require(isContract(target), "Address: delegate call to non-contract");
671 
672         // solhint-disable-next-line avoid-low-level-calls
673         (bool success, bytes memory returndata) = target.delegatecall(data);
674         return _verifyCallResult(success, returndata, errorMessage);
675     }
676 
677     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
678         if (success) {
679             return returndata;
680         } else {
681             // Look for revert reason and bubble it up if present
682             if (returndata.length > 0) {
683                 // The easiest way to bubble the revert reason is using memory via assembly
684 
685                 // solhint-disable-next-line no-inline-assembly
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 /**
698  * @dev Library for managing
699  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
700  * types.
701  *
702  * Sets have the following properties:
703  *
704  * - Elements are added, removed, and checked for existence in constant time
705  * (O(1)).
706  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
707  *
708  * ```
709  * contract Example {
710  *     // Add the library methods
711  *     using EnumerableSet for EnumerableSet.AddressSet;
712  *
713  *     // Declare a set state variable
714  *     EnumerableSet.AddressSet private mySet;
715  * }
716  * ```
717  *
718  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
719  * and `uint256` (`UintSet`) are supported.
720  */
721 library EnumerableSet {
722     // To implement this library for multiple types with as little code
723     // repetition as possible, we write it in terms of a generic Set type with
724     // bytes32 values.
725     // The Set implementation uses private functions, and user-facing
726     // implementations (such as AddressSet) are just wrappers around the
727     // underlying Set.
728     // This means that we can only create new EnumerableSets for types that fit
729     // in bytes32.
730 
731     struct Set {
732         // Storage of set values
733         bytes32[] _values;
734 
735         // Position of the value in the `values` array, plus 1 because index 0
736         // means a value is not in the set.
737         mapping(bytes32 => uint256) _indexes;
738     }
739 
740     /**
741      * @dev Add a value to a set. O(1).
742      *
743      * Returns true if the value was added to the set, that is if it was not
744      * already present.
745      */
746     function _add(Set storage set, bytes32 value) private returns (bool) {
747         if (!_contains(set, value)) {
748             set._values.push(value);
749             // The value is stored at length-1, but we add 1 to all indexes
750             // and use 0 as a sentinel value
751             set._indexes[value] = set._values.length;
752             return true;
753         } else {
754             return false;
755         }
756     }
757 
758     /**
759      * @dev Removes a value from a set. O(1).
760      *
761      * Returns true if the value was removed from the set, that is if it was
762      * present.
763      */
764     function _remove(Set storage set, bytes32 value) private returns (bool) {
765         // We read and store the value's index to prevent multiple reads from the same storage slot
766         uint256 valueIndex = set._indexes[value];
767 
768         if (valueIndex != 0) {// Equivalent to contains(set, value)
769             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
770             // the array, and then remove the last element (sometimes called as 'swap and pop').
771             // This modifies the order of the array, as noted in {at}.
772 
773             uint256 toDeleteIndex = valueIndex - 1;
774             uint256 lastIndex = set._values.length - 1;
775 
776             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
777             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
778 
779             bytes32 lastvalue = set._values[lastIndex];
780 
781             // Move the last value to the index where the value to delete is
782             set._values[toDeleteIndex] = lastvalue;
783             // Update the index for the moved value
784             set._indexes[lastvalue] = toDeleteIndex + 1;
785             // All indexes are 1-based
786 
787             // Delete the slot where the moved value was stored
788             set._values.pop();
789 
790             // Delete the index for the deleted slot
791             delete set._indexes[value];
792 
793             return true;
794         } else {
795             return false;
796         }
797     }
798 
799     /**
800      * @dev Returns true if the value is in the set. O(1).
801      */
802     function _contains(Set storage set, bytes32 value) private view returns (bool) {
803         return set._indexes[value] != 0;
804     }
805 
806     /**
807      * @dev Returns the number of values on the set. O(1).
808      */
809     function _length(Set storage set) private view returns (uint256) {
810         return set._values.length;
811     }
812 
813     /**
814      * @dev Returns the value stored at position `index` in the set. O(1).
815      *
816      * Note that there are no guarantees on the ordering of values inside the
817      * array, and it may change when more values are added or removed.
818      *
819      * Requirements:
820      *
821      * - `index` must be strictly less than {length}.
822      */
823     function _at(Set storage set, uint256 index) private view returns (bytes32) {
824         require(set._values.length > index, "EnumerableSet: index out of bounds");
825         return set._values[index];
826     }
827 
828     // Bytes32Set
829 
830     struct Bytes32Set {
831         Set _inner;
832     }
833 
834     /**
835      * @dev Add a value to a set. O(1).
836      *
837      * Returns true if the value was added to the set, that is if it was not
838      * already present.
839      */
840     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
841         return _add(set._inner, value);
842     }
843 
844     /**
845      * @dev Removes a value from a set. O(1).
846      *
847      * Returns true if the value was removed from the set, that is if it was
848      * present.
849      */
850     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
851         return _remove(set._inner, value);
852     }
853 
854     /**
855      * @dev Returns true if the value is in the set. O(1).
856      */
857     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
858         return _contains(set._inner, value);
859     }
860 
861     /**
862      * @dev Returns the number of values in the set. O(1).
863      */
864     function length(Bytes32Set storage set) internal view returns (uint256) {
865         return _length(set._inner);
866     }
867 
868     /**
869      * @dev Returns the value stored at position `index` in the set. O(1).
870      *
871      * Note that there are no guarantees on the ordering of values inside the
872      * array, and it may change when more values are added or removed.
873      *
874      * Requirements:
875      *
876      * - `index` must be strictly less than {length}.
877      */
878     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
879         return _at(set._inner, index);
880     }
881 
882     // AddressSet
883 
884     struct AddressSet {
885         Set _inner;
886     }
887 
888     /**
889      * @dev Add a value to a set. O(1).
890      *
891      * Returns true if the value was added to the set, that is if it was not
892      * already present.
893      */
894     function add(AddressSet storage set, address value) internal returns (bool) {
895         return _add(set._inner, bytes32(uint256(uint160(value))));
896     }
897 
898     /**
899      * @dev Removes a value from a set. O(1).
900      *
901      * Returns true if the value was removed from the set, that is if it was
902      * present.
903      */
904     function remove(AddressSet storage set, address value) internal returns (bool) {
905         return _remove(set._inner, bytes32(uint256(uint160(value))));
906     }
907 
908     /**
909      * @dev Returns true if the value is in the set. O(1).
910      */
911     function contains(AddressSet storage set, address value) internal view returns (bool) {
912         return _contains(set._inner, bytes32(uint256(uint160(value))));
913     }
914 
915     /**
916      * @dev Returns the number of values in the set. O(1).
917      */
918     function length(AddressSet storage set) internal view returns (uint256) {
919         return _length(set._inner);
920     }
921 
922     /**
923      * @dev Returns the value stored at position `index` in the set. O(1).
924      *
925      * Note that there are no guarantees on the ordering of values inside the
926      * array, and it may change when more values are added or removed.
927      *
928      * Requirements:
929      *
930      * - `index` must be strictly less than {length}.
931      */
932     function at(AddressSet storage set, uint256 index) internal view returns (address) {
933         return address(uint160(uint256(_at(set._inner, index))));
934     }
935 
936 
937     // UintSet
938 
939     struct UintSet {
940         Set _inner;
941     }
942 
943     /**
944      * @dev Add a value to a set. O(1).
945      *
946      * Returns true if the value was added to the set, that is if it was not
947      * already present.
948      */
949     function add(UintSet storage set, uint256 value) internal returns (bool) {
950         return _add(set._inner, bytes32(value));
951     }
952 
953     /**
954      * @dev Removes a value from a set. O(1).
955      *
956      * Returns true if the value was removed from the set, that is if it was
957      * present.
958      */
959     function remove(UintSet storage set, uint256 value) internal returns (bool) {
960         return _remove(set._inner, bytes32(value));
961     }
962 
963     /**
964      * @dev Returns true if the value is in the set. O(1).
965      */
966     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
967         return _contains(set._inner, bytes32(value));
968     }
969 
970     /**
971      * @dev Returns the number of values on the set. O(1).
972      */
973     function length(UintSet storage set) internal view returns (uint256) {
974         return _length(set._inner);
975     }
976 
977     /**
978      * @dev Returns the value stored at position `index` in the set. O(1).
979      *
980      * Note that there are no guarantees on the ordering of values inside the
981      * array, and it may change when more values are added or removed.
982      *
983      * Requirements:
984      *
985      * - `index` must be strictly less than {length}.
986      */
987     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
988         return uint256(_at(set._inner, index));
989     }
990 }
991 
992 /**
993  * @dev Library for managing an enumerable variant of Solidity's
994  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
995  * type.
996  *
997  * Maps have the following properties:
998  *
999  * - Entries are added, removed, and checked for existence in constant time
1000  * (O(1)).
1001  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1002  *
1003  * ```
1004  * contract Example {
1005  *     // Add the library methods
1006  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1007  *
1008  *     // Declare a set state variable
1009  *     EnumerableMap.UintToAddressMap private myMap;
1010  * }
1011  * ```
1012  *
1013  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1014  * supported.
1015  */
1016 library EnumerableMap {
1017     // To implement this library for multiple types with as little code
1018     // repetition as possible, we write it in terms of a generic Map type with
1019     // bytes32 keys and values.
1020     // The Map implementation uses private functions, and user-facing
1021     // implementations (such as Uint256ToAddressMap) are just wrappers around
1022     // the underlying Map.
1023     // This means that we can only create new EnumerableMaps for types that fit
1024     // in bytes32.
1025 
1026     struct MapEntry {
1027         bytes32 _key;
1028         bytes32 _value;
1029     }
1030 
1031     struct Map {
1032         // Storage of map keys and values
1033         MapEntry[] _entries;
1034 
1035         // Position of the entry defined by a key in the `entries` array, plus 1
1036         // because index 0 means a key is not in the map.
1037         mapping(bytes32 => uint256) _indexes;
1038     }
1039 
1040     /**
1041      * @dev Adds a key-value pair to a map, or updates the value for an existing
1042      * key. O(1).
1043      *
1044      * Returns true if the key was added to the map, that is if it was not
1045      * already present.
1046      */
1047     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1048         // We read and store the key's index to prevent multiple reads from the same storage slot
1049         uint256 keyIndex = map._indexes[key];
1050 
1051         if (keyIndex == 0) {// Equivalent to !contains(map, key)
1052             map._entries.push(MapEntry({_key : key, _value : value}));
1053             // The entry is stored at length-1, but we add 1 to all indexes
1054             // and use 0 as a sentinel value
1055             map._indexes[key] = map._entries.length;
1056             return true;
1057         } else {
1058             map._entries[keyIndex - 1]._value = value;
1059             return false;
1060         }
1061     }
1062 
1063     /**
1064      * @dev Removes a key-value pair from a map. O(1).
1065      *
1066      * Returns true if the key was removed from the map, that is if it was present.
1067      */
1068     function _remove(Map storage map, bytes32 key) private returns (bool) {
1069         // We read and store the key's index to prevent multiple reads from the same storage slot
1070         uint256 keyIndex = map._indexes[key];
1071 
1072         if (keyIndex != 0) {// Equivalent to contains(map, key)
1073             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1074             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1075             // This modifies the order of the array, as noted in {at}.
1076 
1077             uint256 toDeleteIndex = keyIndex - 1;
1078             uint256 lastIndex = map._entries.length - 1;
1079 
1080             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1081             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1082 
1083             MapEntry storage lastEntry = map._entries[lastIndex];
1084 
1085             // Move the last entry to the index where the entry to delete is
1086             map._entries[toDeleteIndex] = lastEntry;
1087             // Update the index for the moved entry
1088             map._indexes[lastEntry._key] = toDeleteIndex + 1;
1089             // All indexes are 1-based
1090 
1091             // Delete the slot where the moved entry was stored
1092             map._entries.pop();
1093 
1094             // Delete the index for the deleted slot
1095             delete map._indexes[key];
1096 
1097             return true;
1098         } else {
1099             return false;
1100         }
1101     }
1102 
1103     /**
1104      * @dev Returns true if the key is in the map. O(1).
1105      */
1106     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1107         return map._indexes[key] != 0;
1108     }
1109 
1110     /**
1111      * @dev Returns the number of key-value pairs in the map. O(1).
1112      */
1113     function _length(Map storage map) private view returns (uint256) {
1114         return map._entries.length;
1115     }
1116 
1117     /**
1118      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1119      *
1120      * Note that there are no guarantees on the ordering of entries inside the
1121      * array, and it may change when more entries are added or removed.
1122      *
1123      * Requirements:
1124      *
1125      * - `index` must be strictly less than {length}.
1126      */
1127     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1128         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1129 
1130         MapEntry storage entry = map._entries[index];
1131         return (entry._key, entry._value);
1132     }
1133 
1134     /**
1135      * @dev Tries to returns the value associated with `key`.  O(1).
1136      * Does not revert if `key` is not in the map.
1137      */
1138     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1139         uint256 keyIndex = map._indexes[key];
1140         if (keyIndex == 0) return (false, 0);
1141         // Equivalent to contains(map, key)
1142         return (true, map._entries[keyIndex - 1]._value);
1143         // All indexes are 1-based
1144     }
1145 
1146     /**
1147      * @dev Returns the value associated with `key`.  O(1).
1148      *
1149      * Requirements:
1150      *
1151      * - `key` must be in the map.
1152      */
1153     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1154         uint256 keyIndex = map._indexes[key];
1155         require(keyIndex != 0, "EnumerableMap: nonexistent key");
1156         // Equivalent to contains(map, key)
1157         return map._entries[keyIndex - 1]._value;
1158         // All indexes are 1-based
1159     }
1160 
1161     /**
1162      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1163      *
1164      * CAUTION: This function is deprecated because it requires allocating memory for the error
1165      * message unnecessarily. For custom revert reasons use {_tryGet}.
1166      */
1167     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1168         uint256 keyIndex = map._indexes[key];
1169         require(keyIndex != 0, errorMessage);
1170         // Equivalent to contains(map, key)
1171         return map._entries[keyIndex - 1]._value;
1172         // All indexes are 1-based
1173     }
1174 
1175     // UintToAddressMap
1176 
1177     struct UintToAddressMap {
1178         Map _inner;
1179     }
1180 
1181     /**
1182      * @dev Adds a key-value pair to a map, or updates the value for an existing
1183      * key. O(1).
1184      *
1185      * Returns true if the key was added to the map, that is if it was not
1186      * already present.
1187      */
1188     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1189         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1190     }
1191 
1192     /**
1193      * @dev Removes a value from a set. O(1).
1194      *
1195      * Returns true if the key was removed from the map, that is if it was present.
1196      */
1197     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1198         return _remove(map._inner, bytes32(key));
1199     }
1200 
1201     /**
1202      * @dev Returns true if the key is in the map. O(1).
1203      */
1204     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1205         return _contains(map._inner, bytes32(key));
1206     }
1207 
1208     /**
1209      * @dev Returns the number of elements in the map. O(1).
1210      */
1211     function length(UintToAddressMap storage map) internal view returns (uint256) {
1212         return _length(map._inner);
1213     }
1214 
1215     /**
1216      * @dev Returns the element stored at position `index` in the set. O(1).
1217      * Note that there are no guarantees on the ordering of values inside the
1218      * array, and it may change when more values are added or removed.
1219      *
1220      * Requirements:
1221      *
1222      * - `index` must be strictly less than {length}.
1223      */
1224     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1225         (bytes32 key, bytes32 value) = _at(map._inner, index);
1226         return (uint256(key), address(uint160(uint256(value))));
1227     }
1228 
1229     /**
1230      * @dev Tries to returns the value associated with `key`.  O(1).
1231      * Does not revert if `key` is not in the map.
1232      *
1233      * _Available since v3.4._
1234      */
1235     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1236         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1237         return (success, address(uint160(uint256(value))));
1238     }
1239 
1240     /**
1241      * @dev Returns the value associated with `key`.  O(1).
1242      *
1243      * Requirements:
1244      *
1245      * - `key` must be in the map.
1246      */
1247     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1248         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1249     }
1250 
1251     /**
1252      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1253      *
1254      * CAUTION: This function is deprecated because it requires allocating memory for the error
1255      * message unnecessarily. For custom revert reasons use {tryGet}.
1256      */
1257     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1258         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1259     }
1260 }
1261 
1262 /**
1263  * @dev String operations.
1264  */
1265 library Strings {
1266     /**
1267      * @dev Converts a `uint256` to its ASCII `string` representation.
1268      */
1269     function toString(uint256 value) internal pure returns (string memory) {
1270         // Inspired by OraclizeAPI's implementation - MIT licence
1271         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1272 
1273         if (value == 0) {
1274             return "0";
1275         }
1276         uint256 temp = value;
1277         uint256 digits;
1278         while (temp != 0) {
1279             digits++;
1280             temp /= 10;
1281         }
1282         bytes memory buffer = new bytes(digits);
1283         uint256 index = digits - 1;
1284         temp = value;
1285         while (temp != 0) {
1286             buffer[index--] = bytes1(uint8(48 + temp % 10));
1287             temp /= 10;
1288         }
1289         return string(buffer);
1290     }
1291 }
1292 
1293 
1294 /**
1295  * @title ERC721 Non-Fungible Token Standard basic implementation
1296  * @dev see https://eips.ethereum.org/EIPS/eip-721
1297  */
1298 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1299     using SafeMath for uint256;
1300     using Address for address;
1301     using EnumerableSet for EnumerableSet.UintSet;
1302     using EnumerableMap for EnumerableMap.UintToAddressMap;
1303     using Strings for uint256;
1304 
1305     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1306     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1307     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1308 
1309     // Mapping from holder address to their (enumerable) set of owned tokens
1310     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1311 
1312     // Enumerable mapping from token ids to their owners
1313     EnumerableMap.UintToAddressMap private _tokenOwners;
1314     EnumerableMap.UintToAddressMap private _onlytokenOwners;
1315 
1316     // Mapping from token ID to approved address
1317     mapping(uint256 => address) private _tokenApprovals;
1318 
1319     // Mapping from owner to operator approvals
1320     mapping(address => mapping(address => bool)) private _operatorApprovals;
1321 
1322     // Token name
1323     string private _name;
1324 
1325     // Token symbol
1326     string private _symbol;
1327 
1328     // Optional mapping for token URIs
1329     mapping(uint256 => string) private _tokenURIs;
1330 
1331     // Base URI
1332     string private _baseURI;
1333 
1334     /*
1335      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1336      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1337      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1338      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1339      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1340      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1341      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1342      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1343      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1344      *
1345      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1346      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1347      */
1348     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1349 
1350     /*
1351      *     bytes4(keccak256('name()')) == 0x06fdde03
1352      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1353      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1354      *
1355      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1356      */
1357     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1358 
1359     /*
1360      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1361      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1362      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1363      *
1364      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1365      */
1366     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1367 
1368     /**
1369      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1370      */
1371     constructor (string memory name_, string memory symbol_) public {
1372         _name = name_;
1373         _symbol = symbol_;
1374 
1375         // register the supported interfaces to conform to ERC721 via ERC165
1376         _registerInterface(_INTERFACE_ID_ERC721);
1377         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1378         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-balanceOf}.
1383      */
1384     function balanceOf(address owner) public view virtual override returns (uint256) {
1385         require(owner != address(0), "ERC721: balance query for the zero address");
1386         return _holderTokens[owner].length();
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-ownerOf}.
1391      */
1392     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1393         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1394     }
1395 
1396     /**
1397      * @dev See {IERC721Metadata-name}.
1398      */
1399     function name() public view virtual override returns (string memory) {
1400         return _name;
1401     }
1402 
1403     /**
1404      * @dev See {IERC721Metadata-symbol}.
1405      */
1406     function symbol() public view virtual override returns (string memory) {
1407         return _symbol;
1408     }
1409 
1410     /**
1411      * @dev See {IERC721Metadata-tokenURI}.
1412      */
1413     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1414         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1415 
1416         string memory _tokenURI = _tokenURIs[tokenId];
1417         string memory base = baseURI();
1418 
1419         // If there is no base URI, return the token URI.
1420         if (bytes(base).length == 0) {
1421             return _tokenURI;
1422         }
1423         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1424         if (bytes(_tokenURI).length > 0) {
1425             return string(abi.encodePacked(base, _tokenURI, '.json'));
1426         }
1427         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1428         return string(abi.encodePacked(base, (tokenId.toString()), ".json"));
1429     }
1430 
1431     /**
1432     * @dev Returns the base URI set via {_setBaseURI}. This will be
1433     * automatically added as a prefix in {tokenURI} to each token's URI, or
1434     * to the token ID if no specific URI is set for that token ID.
1435     */
1436     function baseURI() public view virtual returns (string memory) {
1437         return _baseURI;
1438     }
1439 
1440     /**
1441      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1442      */
1443     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1444         return _holderTokens[owner].at(index);
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Enumerable-totalSupply}.
1449      */
1450     function totalSupply() public view virtual override returns (uint256) {
1451         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1452         return _tokenOwners.length();
1453     }
1454 
1455 
1456     /**
1457      * @dev See {IERC721Enumerable-totalSupply}.
1458      */
1459     function onlyTotalSupply() public view virtual returns (uint256) {
1460         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1461         return _onlytokenOwners.length();
1462     }
1463 
1464 
1465 
1466     /**
1467      * @dev See {IERC721Enumerable-tokenByIndex}.
1468      */
1469     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1470         (uint256 tokenId,) = _tokenOwners.at(index);
1471         return tokenId;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-approve}.
1476      */
1477     function approve(address to, uint256 tokenId) public virtual override {
1478         address owner = ERC721.ownerOf(tokenId);
1479         require(to != owner, "ERC721: approval to current owner");
1480 
1481         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1482             "ERC721: approve caller is not owner nor approved for all"
1483         );
1484 
1485         _approve(to, tokenId);
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-getApproved}.
1490      */
1491     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1492         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1493 
1494         return _tokenApprovals[tokenId];
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-setApprovalForAll}.
1499      */
1500     function setApprovalForAll(address operator, bool approved) public virtual override {
1501         require(operator != _msgSender(), "ERC721: approve to caller");
1502 
1503         _operatorApprovals[_msgSender()][operator] = approved;
1504         emit ApprovalForAll(_msgSender(), operator, approved);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-isApprovedForAll}.
1509      */
1510     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1511         return _operatorApprovals[owner][operator];
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-transferFrom}.
1516      */
1517     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1518         //solhint-disable-next-line max-line-length
1519         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1520 
1521         _transfer(from, to, tokenId);
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-safeTransferFrom}.
1526      */
1527     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1528         safeTransferFrom(from, to, tokenId, "");
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-safeTransferFrom}.
1533      */
1534     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1535         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1536         _safeTransfer(from, to, tokenId, _data);
1537     }
1538 
1539     /**
1540      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1541      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1542      *
1543      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1544      *
1545      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1546      * implement alternative mechanisms to perform token transfer, such as signature-based.
1547      *
1548      * Requirements:
1549      *
1550      * - `from` cannot be the zero address.
1551      * - `to` cannot be the zero address.
1552      * - `tokenId` token must exist and be owned by `from`.
1553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1558         _transfer(from, to, tokenId);
1559         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1560     }
1561 
1562     /**
1563      * @dev Returns whether `tokenId` exists.
1564      *
1565      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1566      *
1567      * Tokens start existing when they are minted (`_mint`),
1568      * and stop existing when they are burned (`_burn`).
1569      */
1570     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1571         return _tokenOwners.contains(tokenId);
1572     }
1573 
1574     /**
1575      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1576      *
1577      * Requirements:
1578      *
1579      * - `tokenId` must exist.
1580      */
1581     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1582         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1583         address owner = ERC721.ownerOf(tokenId);
1584         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1585     }
1586 
1587     /**
1588      * @dev Safely mints `tokenId` and transfers it to `to`.
1589      *
1590      * Requirements:
1591      d*
1592      * - `tokenId` must not exist.
1593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _safeMint(address to, uint256 tokenId) internal virtual {
1598         _safeMint(to, tokenId, "");
1599     }
1600 
1601     /**
1602      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1603      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1604      */
1605     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1606         _mint(to, tokenId);
1607         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1608     }
1609 
1610     /**
1611      * @dev Mints `tokenId` and transfers it to `to`.
1612      *
1613      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1614      *
1615      * Requirements:
1616      *
1617      * - `tokenId` must not exist.
1618      * - `to` cannot be the zero address.
1619      *
1620      * Emits a {Transfer} event.
1621      */
1622     function _mint(address to, uint256 tokenId) internal virtual {
1623         require(to != address(0), "ERC721: mint to the zero address");
1624 
1625         require(!_exists(tokenId), "ERC721: token already minted");
1626 
1627         _beforeTokenTransfer(address(0), to, tokenId);
1628 
1629         _holderTokens[to].add(tokenId);
1630 
1631         _tokenOwners.set(tokenId, to);
1632 
1633         emit Transfer(address(0), to, tokenId);
1634     }
1635 
1636 
1637     function _tokenOwnerSet(address to, uint256 tokenId) internal virtual {
1638         require(to != address(0), "ERC721: mint to the zero address");
1639         _onlytokenOwners.set(tokenId, to);
1640     }
1641 
1642 
1643 
1644     /**
1645      * @dev Destroys `tokenId`.
1646      * The approval is cleared when the token is burned.
1647      *
1648      * Requirements:
1649      *
1650      * - `tokenId` must exist.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function _burn(uint256 tokenId) internal virtual {
1655         address owner = ERC721.ownerOf(tokenId);
1656         // internal owner
1657 
1658         _beforeTokenTransfer(owner, address(0), tokenId);
1659 
1660         // Clear approvals
1661         _approve(address(0), tokenId);
1662 
1663         // Clear metadata (if any)
1664         if (bytes(_tokenURIs[tokenId]).length != 0) {
1665             delete _tokenURIs[tokenId];
1666         }
1667 
1668         _holderTokens[owner].remove(tokenId);
1669 
1670         _tokenOwners.remove(tokenId);
1671 
1672         emit Transfer(owner, address(0), tokenId);
1673     }
1674 
1675     /**
1676      * @dev Transfers `tokenId` from `from` to `to`.
1677      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - `tokenId` token must be owned by `from`.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1687         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1688         // internal owner
1689         require(to != address(0), "ERC721: transfer to the zero address");
1690 
1691         _beforeTokenTransfer(from, to, tokenId);
1692 
1693         // Clear approvals from the previous owner
1694         _approve(address(0), tokenId);
1695 
1696         _holderTokens[from].remove(tokenId);
1697         _holderTokens[to].add(tokenId);
1698 
1699         _tokenOwners.set(tokenId, to);
1700 
1701         emit Transfer(from, to, tokenId);
1702     }
1703 
1704     /**
1705      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1706      *
1707      * Requirements:
1708      *
1709      * - `tokenId` must exist.
1710      */
1711     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1712         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1713         _tokenURIs[tokenId] = _tokenURI;
1714     }
1715 
1716     /**
1717      * @dev Internal function to set the base URI for all token IDs. It is
1718      * automatically added as a prefix to the value returned in {tokenURI},
1719      * or to the token ID if {tokenURI} is empty.
1720      */
1721     function _setBaseURI(string memory baseURI_) internal virtual {
1722         _baseURI = baseURI_;
1723     }
1724 
1725     /**
1726      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1727      * The call is not executed if the target address is not a contract.
1728      *
1729      * @param from address representing the previous owner of the given token ID
1730      * @param to target address that will receive the tokens
1731      * @param tokenId uint256 ID of the token to be transferred
1732      * @param _data bytes optional data to send along with the call
1733      * @return bool whether the call correctly returned the expected magic value
1734      */
1735     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1736     private returns (bool)
1737     {
1738         if (!to.isContract()) {
1739             return true;
1740         }
1741         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1742                 IERC721Receiver(to).onERC721Received.selector,
1743                 _msgSender(),
1744                 from,
1745                 tokenId,
1746                 _data
1747             ), "ERC721: transfer to non ERC721Receiver implementer");
1748         bytes4 retval = abi.decode(returndata, (bytes4));
1749         return (retval == _ERC721_RECEIVED);
1750     }
1751 
1752     /**
1753      * @dev Approve `to` to operate on `tokenId`
1754      *
1755      * Emits an {Approval} event.
1756      */
1757     function _approve(address to, uint256 tokenId) internal virtual {
1758         _tokenApprovals[tokenId] = to;
1759         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1760         // internal owner
1761     }
1762 
1763     /**
1764      * @dev Hook that is called before any token transfer. This includes minting
1765      * and burning.
1766      *
1767      * Calling conditions:
1768      *
1769      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1770      * transferred to `to`.
1771      * - When `from` is zero, `tokenId` will be minted for `to`.
1772      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1773      * - `from` cannot be the zero address.
1774      * - `to` cannot be the zero address.
1775      *
1776      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1777      */
1778     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
1779 }
1780 
1781 /**
1782  * @dev Contract module which provides a basic access control mechanism, where
1783  * there is an account (an owner) that can be granted exclusive access to
1784  * specific functions.
1785  *
1786  * By default, the owner account will be the one that deploys the contract. This
1787  * can later be changed with {transferOwnership}.
1788  *
1789  * This module is used through inheritance. It will make available the modifier
1790  * `onlyOwner`, which can be applied to your functions to restrict their use to
1791  * the owner.
1792  */
1793 
1794 abstract contract Ownable is Context {
1795     address private _owner;
1796 
1797     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1798 
1799     /**
1800      * @dev Initializes the contract setting the deployer as the initial owner.
1801      */
1802     constructor () internal {
1803         address msgSender = _msgSender();
1804         _owner = msgSender;
1805         emit OwnershipTransferred(address(0), msgSender);
1806     }
1807 
1808     /**
1809      * @dev Returns the address of the current owner.
1810      */
1811     function owner() public view virtual returns (address) {
1812         return _owner;
1813     }
1814 
1815     /**
1816      * @dev Throws if called by any account other than the owner.
1817      */
1818     modifier onlyOwner() {
1819         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1820         _;
1821     }
1822 
1823     /**
1824      * @dev Leaves the contract without owner. It will not be possible to call
1825      * `onlyOwner` functions anymore. Can only be called by the current owner.
1826      *
1827      * NOTE: Renouncing ownership will leave the contract without an owner,
1828      * thereby removing any functionality that is only available to the owner.
1829      */
1830     function renounceOwnership() public virtual onlyOwner {
1831         emit OwnershipTransferred(_owner, address(0));
1832         _owner = address(0);
1833     }
1834 
1835     /**
1836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1837      * Can only be called by the current owner.
1838      */
1839     function transferOwnership(address newOwner) public virtual onlyOwner {
1840         require(newOwner != address(0), "Ownable: new owner is the zero address");
1841         emit OwnershipTransferred(_owner, newOwner);
1842         _owner = newOwner;
1843     }
1844 }
1845 
1846 interface IERC20 {
1847     /**
1848      * @dev Returns the amount of tokens in existence.
1849      */
1850     function totalSupply() external view returns (uint256);
1851 
1852     /**
1853      * @dev Returns the amount of tokens owned by `account`.
1854      */
1855     function balanceOf(address account) external view returns (uint256);
1856 
1857     /**
1858      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1859      *
1860      * Returns a boolean value indicating whether the operation succeeded.
1861      *
1862      * Emits a {Transfer} event.
1863      */
1864     function transfer(address recipient, uint256 amount) external returns (bool);
1865 
1866     /**
1867      * @dev Returns the remaining number of tokens that `spender` will be
1868      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1869      * zero by default.
1870      *
1871      * This value changes when {approve} or {transferFrom} are called.
1872      */
1873     function allowance(address owner, address spender) external view returns (uint256);
1874 
1875     /**
1876      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1877      *
1878      * Returns a boolean value indicating whether the operation succeeded.
1879      *
1880      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1881      * that someone may use both the old and the new allowance by unfortunate
1882      * transaction ordering. One possible solution to mitigate this race
1883      * condition is to first reduce the spender's allowance to 0 and set the
1884      * desired value afterwards:
1885      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1886      *
1887      * Emits an {Approval} event.
1888      */
1889     function approve(address spender, uint256 amount) external returns (bool);
1890 
1891     /**
1892      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1893      * allowance mechanism. `amount` is then deducted from the caller's
1894      * allowance.
1895      *
1896      * Returns a boolean value indicating whether the operation succeeded.
1897      *
1898      * Emits a {Transfer} event.
1899      */
1900     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1901 
1902     /**
1903      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1904      * another (`to`).
1905      *
1906      * Note that `value` may be zero.
1907      */
1908     event Transfer(address indexed from, address indexed to, uint256 value);
1909 
1910     /**
1911      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1912      * a call to {approve}. `value` is the new allowance.
1913      */
1914     event Approval(address indexed owner, address indexed spender, uint256 value);
1915 }
1916 
1917 contract CashRabbit is ERC721, Ownable {
1918     using SafeMath for uint256; //
1919 
1920     uint256 public immutable maxPerTx; //
1921     uint256 public  maxNumber; //
1922     uint256 public  baseNumber; //
1923     uint256 public  levelPrice; //
1924     address public cash;
1925     address public ferc;
1926     uint256 public level;
1927     uint256 public destroy;
1928     address public destroyAddr;
1929 
1930 
1931     bool public isSaleActive;
1932 
1933     constructor()
1934     public
1935     ERC721("CashRabbit", "CashRabbit") //
1936     {
1937         maxNumber = 1016;
1938         baseNumber = 1000;
1939         cash = 0xf32cFbAf4000e6820a95B3A3fCdbF27FB4eFC9af;
1940         ferc = 0x2eCBa91da63C29EA80Fbe7b52632CA2d1F8e5Be0;
1941         levelPrice = 5 * 10 ** 16;
1942         level = 33;
1943         destroy = 30;
1944         destroyAddr = 0x0000000000000000000000000000000000000001;
1945         maxPerTx = 10;
1946     }
1947 
1948 
1949     function setData(uint256 levela, uint256 destroya, uint256 levelPricea, uint256 baseNumbera) public onlyOwner {
1950         level = levela;
1951         destroy = destroya;
1952         levelPrice = levelPricea;
1953         baseNumber = baseNumbera;
1954     }
1955 
1956 
1957     //
1958     function getPrice() public view returns (uint256) {
1959         return totalSupply() + 100;
1960     }
1961 
1962 
1963 
1964     //pay  pay
1965     function mintPay(uint payType) public {
1966         require(isSaleActive, "Sale is not active");
1967         require(balanceOf(msg.sender) <= 2, "Already Mint 2");
1968         require(payType == 1 || payType == 2, "payType is wr");
1969         require(totalSupply().add(1) <= baseNumber, "Purchase would exceed max supply of Martial");
1970         if (payType == 1) {//cash
1971             uint256 price = getPrice();
1972             IERC20 token = IERC20(cash);
1973             token.transferFrom(msg.sender, destroyAddr, price * 10 ** 18 * destroy / 100);
1974             token.transferFrom(msg.sender, owner(), price * 10 ** 18 * (100 - destroy) / 100);
1975         } else if (payType == 2) {//ferc
1976             IERC20 token = IERC20(ferc);
1977             uint256 price = (2 * 10 ** 18) + (levelPrice * (getPrice() - 100));
1978             token.transferFrom(msg.sender, destroyAddr, price * destroy / 100);
1979             token.transferFrom(msg.sender, owner(), price * (100 - destroy) / 100);
1980         }
1981         uint256 mintIndexN = totalSupply().add(1);
1982         if (totalSupply() < maxNumber) {//
1983             _safeMint(msg.sender, mintIndexN);
1984         }
1985     }
1986 
1987 
1988     //
1989     function mintOnly(address[] memory addList, uint256[] memory numberOfTokensList) public onlyOwner {
1990         for (uint i = 0; i < addList.length; i++) {//
1991             address newOwner = addList[i];
1992             //
1993             uint256 numberOfTokens = numberOfTokensList[i];
1994             require(totalSupply().add(numberOfTokens) <= maxNumber, "Purchase would exceed max supply of Martial");
1995             //
1996             if (numberOfTokens > maxPerTx) {//
1997                 continue;
1998             } else {
1999                 for (uint256 i = 0; i < numberOfTokens; i++) {
2000                     uint256 mintIndexN = totalSupply().add(1);
2001                     if (totalSupply() < maxNumber) {//
2002                         _safeMint(newOwner, mintIndexN);
2003                     }
2004                 }
2005             }
2006         }
2007     }
2008 
2009     // eixt  true  nonexit  false
2010     function isExitA(uint256 tokenId) public view returns (bool) {
2011         if (_exists(tokenId)) {
2012             return true;
2013         } else {
2014             return false;
2015         }
2016     }
2017 
2018     // baseuri
2019     function setBaseURI(string memory baseURI) public onlyOwner {
2020         _setBaseURI(baseURI);
2021     }
2022 
2023     function getIsSale() public view returns (bool){
2024         return isSaleActive;
2025     }
2026 
2027     //
2028     function flipSaleState() public onlyOwner {
2029         isSaleActive = !isSaleActive;
2030     }
2031 
2032 }