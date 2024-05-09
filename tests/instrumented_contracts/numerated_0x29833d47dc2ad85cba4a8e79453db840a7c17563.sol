1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an applition
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
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35 
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 
53 
54 
55 pragma solidity >=0.6.2 <0.8.0;
56 
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(address from, address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(address from, address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167       * @dev Safely transfers `tokenId` token from `from` to `to`.
168       *
169       * Requirements:
170       *
171       * - `from` cannot be the zero address.
172       * - `to` cannot be the zero address.
173       * - `tokenId` token must exist and be owned by `from`.
174       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176       *
177       * Emits a {Transfer} event.
178       */
179     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
180 }
181 
182 
183 
184 pragma solidity >=0.6.2 <0.8.0;
185 
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192 
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
210 
211 
212 
213 pragma solidity >=0.6.2 <0.8.0;
214 
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Enumerable is IERC721 {
221 
222     /**
223      * @dev Returns the total amount of tokens stored by the contract.
224      */
225     function totalSupply() external view returns (uint256);
226 
227     /**
228      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
229      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
230      */
231     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
232 
233     /**
234      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
235      * Use along with {totalSupply} to enumerate all tokens.
236      */
237     function tokenByIndex(uint256 index) external view returns (uint256);
238 }
239 
240 
241 
242 pragma solidity >=0.6.0 <0.8.0;
243 
244 /**
245  * @title ERC721 token receiver interface
246  * @dev Interface for any contract that wants to support safeTransfers
247  * from ERC721 asset contracts.
248  */
249 interface IERC721Receiver {
250     /**
251      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
252      * by `operator` from `from`, this function is called.
253      *
254      * It must return its Solidity selector to confirm the token transfer.
255      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
256      *
257      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
258      */
259     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
260 }
261 
262 
263 
264 pragma solidity >=0.6.0 <0.8.0;
265 
266 
267 /**
268  * @dev Implementation of the {IERC165} interface.
269  *
270  * Contracts may inherit from this and call {_registerInterface} to declare
271  * their support of an interface.
272  */
273 abstract contract ERC165 is IERC165 {
274     /*
275      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
276      */
277     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
278 
279     /**
280      * @dev Mapping of interface ids to whether or not it's supported.
281      */
282     mapping(bytes4 => bool) private _supportedInterfaces;
283 
284     constructor () internal {
285         // Derived contracts need only register support for their own interfaces,
286         // we register support for ERC165 itself here
287         _registerInterface(_INTERFACE_ID_ERC165);
288     }
289 
290     /**
291      * @dev See {IERC165-supportsInterface}.
292      *
293      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
296         return _supportedInterfaces[interfaceId];
297     }
298 
299     /**
300      * @dev Registers the contract as an implementer of the interface defined by
301      * `interfaceId`. Support of the actual ERC165 interface is automatic and
302      * registering its interface id is not required.
303      *
304      * See {IERC165-supportsInterface}.
305      *
306      * Requirements:
307      *
308      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
309      */
310     function _registerInterface(bytes4 interfaceId) internal virtual {
311         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
312         _supportedInterfaces[interfaceId] = true;
313     }
314 }
315 
316 
317 
318 
319 pragma solidity >=0.6.0 <0.8.0;
320 
321 /**
322  * @dev Wrappers over Solidity's arithmetic operations with added overflow
323  * checks.
324  *
325  * Arithmetic operations in Solidity wrap on overflow. This can easily result
326  * in bugs, because programmers usually assume that an overflow raises an
327  * error, which is the standard behavior in high level programming languages.
328  * `SafeMath` restores this intuition by reverting the transaction when an
329  * operation overflows.
330  *
331  * Using this library instead of the unchecked operations eliminates an entire
332  * class of bugs, so it's recommended to use it always.
333  */
334 library SafeMath {
335     /**
336      * @dev Returns the addition of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         uint256 c = a + b;
342         if (c < a) return (false, 0);
343         return (true, c);
344     }
345 
346     /**
347      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
352         if (b > a) return (false, 0);
353         return (true, a - b);
354     }
355 
356     /**
357      * @dev Returns two unsigned integers, with an overflow flag.
358      *
359      * _Available since v3.4._
360      */
361     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
363         // benefit is lost if 'b' is also tested.
364         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
365         if (a == 0) return (true, 0);
366         uint256 c = a * b;
367         if (c / a != b) return (false, 0);
368         return (true, c);
369     }
370 
371     /**
372      * @dev Returns the division of two unsigned integers, with a division by zero flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         if (b == 0) return (false, 0);
378         return (true, a / b);
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
383      *
384      * _Available since v3.4._
385      */
386     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         if (b == 0) return (false, 0);
388         return (true, a % b);
389     }
390 
391     /**
392      * @dev Returns the addition of two unsigned integers, reverting on
393      * overflow.
394      *
395      * Counterpart to Solidity's `+` operator.
396      *
397      * Requirements:
398      *
399      * - Addition cannot overflow.
400      */
401     function add(uint256 a, uint256 b) internal pure returns (uint256) {
402         uint256 c = a + b;
403         require(c >= a, "SafeMath: addition overflow");
404         return c;
405     }
406 
407     /**
408      * @dev Returns the subtraction of two unsigned integers, reverting on
409      * overflow (when the result is negative).
410      *
411      * Counterpart to Solidity's `-` operator.
412      *
413      * Requirements:
414      *
415      * - Subtraction cannot overflow.
416      */
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         require(b <= a, "SafeMath: subtraction overflow");
419         return a - b;
420     }
421 
422     /**
423      * @dev Returns two unsigned integers, reverting on
424      * overflow.
425 
426      */
427     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428         if (a == 0) return 0;
429         uint256 c = a * b;
430         require(c / a == b, "SafeMath: mul overflow");
431         return c;
432     }
433 
434     /**
435      * @dev Returns the integer division of two unsigned integers, reverting on
436      * division by zero. The result is rounded towards zero.
437      *
438      * Counterpart to Solidity's `/` operator. Note: this function uses a
439      * `revert` opcode (which leaves remaining gas untouched) while Solidity
440      * uses an invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function div(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b > 0, "SafeMath: division by zero");
448         return a / b;
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
453      * reverting when dividing by zero.
454      *
455      * Counterpart to Solidity's `%` operator. This function uses a `revert`
456      * opcode (which leaves remaining gas untouched) while Solidity uses an
457      * invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
464         require(b > 0, "SafeMath: modulo by zero");
465         return a % b;
466     }
467 
468     /**
469      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
470      * overflow (when the result is negative).
471 
472      */
473     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
474         require(b <= a, errorMessage);
475         return a - b;
476     }
477 
478     /**
479      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
480      * division by zero. The result is rounded towards zero.
481 
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
492         require(b > 0, errorMessage);
493         return a / b;
494     }
495 
496     /**
497      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
498      * reverting with custom message when dividing by zero.
499 
500      *
501      * Counterpart to Solidity's `%` operator. This function uses a `revert`
502      * opcode (which leaves remaining gas untouched) while Solidity uses an
503      * invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b > 0, errorMessage);
511         return a % b;
512     }
513 }
514 
515 
516 
517 pragma solidity >=0.6.2 <0.8.0;
518 
519 /**
520  * @dev Collection of functions related to the address type
521  */
522 library Address {
523     /**
524      * @dev Returns true if `account` is a contract.
525      *
526      * [IMPORTANT]
527      * ====
528      * It is unsafe to assume that an address for which this function returns
529      * false is an externally-owned account (EOA) and not a contract.
530      *
531      * Among others, `isContract` will return false for the following
532      * types of addresses:
533      *
534      *  - an externally-owned account
535      *  - a contract in construction
536      *  - an address where a contract will be created
537      *  - an address where a contract lived, but was destroyed
538      * ====
539      */
540     function isContract(address account) internal view returns (bool) {
541         // This method relies on extcodesize, which returns 0 for contracts in
542         // construction, since the code is only stored at the end of the
543         // constructor execution.
544 
545         uint256 size;
546         // solhint-disable-next-line no-inline-assembly
547         assembly { size := extcodesize(account) }
548         return size > 0;
549     }
550 
551     /**
552      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
553      * `recipient`, forwarding all available gas and reverting on errors.
554      *
555      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
556      * of certain opcodes, possibly making contracts go over the 2300 gas limit
557      * imposed by `transfer`, making them unable to receive funds via
558      * `transfer`. {sendValue} removes this limitation.
559      *
560      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
561      *
562      * IMPORTANT: because control is transferred to `recipient`, care must be
563      * taken to not create reentrancy vulnerabilities. Consider using
564      * {ReentrancyGuard} or the
565      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
566      */
567     function sendValue(address payable recipient, uint256 amount) internal {
568         require(address(this).balance >= amount, "Address: insufficient balance");
569 
570         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
571         (bool success, ) = recipient.call{ value: amount }("");
572         require(success, "Address: unable to send value, recipient may have reverted");
573     }
574 
575     /**
576      * @dev Performs a Solidity function call using a low level `call`. A
577      * plain`call` is an unsafe replacement for a function call: use this
578      * function instead.
579      *
580      * If `target` reverts with a revert reason, it is bubbled up by this
581      * function (like regular Solidity function calls).
582      *
583      * Returns the raw returned data. To convert to the expected return value,
584      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
585      *
586      * Requirements:
587      *
588      * - `target` must be a contract.
589      * - calling `target` with `data` must not revert.
590      *
591      * _Available since v3.1._
592      */
593     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
594       return functionCall(target, data, "Address: low-level call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
599      * `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
604         return functionCallWithValue(target, data, 0, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but also transferring `value` wei to `target`.
610      *
611      * Requirements:
612      *
613      * - the calling contract must have an ETH balance of at least `value`.
614      * - the called Solidity function must be `payable`.
615      *
616      * _Available since v3.1._
617      */
618     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
619         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
624      * with `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
629         require(address(this).balance >= value, "Address: insufficient balance for call");
630         require(isContract(target), "Address: call to non-contract");
631 
632         // solhint-disable-next-line avoid-low-level-calls
633         (bool success, bytes memory returndata) = target.call{ value: value }(data);
634         return _verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
639      * but performing a static call.
640      *
641      * _Available since v3.3._
642      */
643     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
644         return functionStaticCall(target, data, "Address: low-level static call failed");
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
649      * but performing a static call.
650      *
651      * _Available since v3.3._
652      */
653     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
654         require(isContract(target), "Address: static call to non-contract");
655 
656         // solhint-disable-next-line avoid-low-level-calls
657         (bool success, bytes memory returndata) = target.staticcall(data);
658         return _verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
663      * but performing a delegate call.
664      *
665      * _Available since v3.4._
666      */
667     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
668         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
673      * but performing a delegate call.
674      *
675      * _Available since v3.4._
676      */
677     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
678         require(isContract(target), "Address: delegate call to non-contract");
679 
680         // solhint-disable-next-line avoid-low-level-calls
681         (bool success, bytes memory returndata) = target.delegatecall(data);
682         return _verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
686         if (success) {
687             return returndata;
688         } else {
689             // Look for revert reason and bubble it up if present
690             if (returndata.length > 0) {
691                 // The easiest way to bubble the revert reason is using memory via assembly
692 
693                 // solhint-disable-next-line no-inline-assembly
694                 assembly {
695                     let returndata_size := mload(returndata)
696                     revert(add(32, returndata), returndata_size)
697                 }
698             } else {
699                 revert(errorMessage);
700             }
701         }
702     }
703 }
704 
705 
706 pragma solidity >=0.6.0 <0.8.0;
707 
708 /**
709  * @dev Library for managing
710  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
711  * types.
712  *
713  * Sets have the following properties:
714  *
715  * - Elements are added, removed, and checked for existence in constant time
716  * (O(1)).
717  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
718  *
719  * ```
720  * contract Example {
721  *     // Add the library methods
722  *     using EnumerableSet for EnumerableSet.AddressSet;
723  *
724  *     // Declare a set state variable
725  *     EnumerableSet.AddressSet private mySet;
726  * }
727  * ```
728  *
729  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
730  * and `uint256` (`UintSet`) are supported.
731  */
732 library EnumerableSet {
733     // To implement this library for multiple types with as little code
734     // repetition as possible, we write it in terms of a generic Set type with
735     // bytes32 values.
736     // The Set implementation uses private functions, and user-facing
737     // implementations (such as AddressSet) are just wrappers around the
738     // underlying Set.
739     // This means that we can only create new EnumerableSets for types that fit
740     // in bytes32.
741 
742     struct Set {
743         // Storage of set values
744         bytes32[] _values;
745 
746         // Position of the value in the `values` array, plus 1 because index 0
747         // means a value is not in the set.
748         mapping (bytes32 => uint256) _indexes;
749     }
750 
751     /**
752      * @dev Add a value to a set. O(1).
753      *
754      * Returns true if the value was added to the set, that is if it was not
755      * already present.
756      */
757     function _add(Set storage set, bytes32 value) private returns (bool) {
758         if (!_contains(set, value)) {
759             set._values.push(value);
760             // The value is stored at length-1, but we add 1 to all indexes
761             // and use 0 as a sentinel value
762             set._indexes[value] = set._values.length;
763             return true;
764         } else {
765             return false;
766         }
767     }
768 
769     /**
770      * @dev Removes a value from a set. O(1).
771      *
772      * Returns true if the value was removed from the set, that is if it was
773      * present.
774      */
775     function _remove(Set storage set, bytes32 value) private returns (bool) {
776         // We read and store the value's index to prevent multiple reads from the same storage slot
777         uint256 valueIndex = set._indexes[value];
778 
779         if (valueIndex != 0) { // Equivalent to contains(set, value)
780             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
781             // the array, and then remove the last element (sometimes called as 'swap and pop').
782             // This modifies the order of the array, as noted in {at}.
783 
784             uint256 toDeleteIndex = valueIndex - 1;
785             uint256 lastIndex = set._values.length - 1;
786 
787             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
788             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
789 
790             bytes32 lastvalue = set._values[lastIndex];
791 
792             // Move the last value to the index where the value to delete is
793             set._values[toDeleteIndex] = lastvalue;
794             // Update the index for the moved value
795             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
796 
797             // Delete the slot where the moved value was stored
798             set._values.pop();
799 
800             // Delete the index for the deleted slot
801             delete set._indexes[value];
802 
803             return true;
804         } else {
805             return false;
806         }
807     }
808 
809     /**
810      * @dev Returns true if the value is in the set. O(1).
811      */
812     function _contains(Set storage set, bytes32 value) private view returns (bool) {
813         return set._indexes[value] != 0;
814     }
815 
816     /**
817      * @dev Returns the number of values on the set. O(1).
818      */
819     function _length(Set storage set) private view returns (uint256) {
820         return set._values.length;
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
833     function _at(Set storage set, uint256 index) private view returns (bytes32) {
834         require(set._values.length > index, "EnumerableSet: index out of bounds");
835         return set._values[index];
836     }
837 
838     // Bytes32Set
839 
840     struct Bytes32Set {
841         Set _inner;
842     }
843 
844     /**
845      * @dev Add a value to a set. O(1).
846      *
847      * Returns true if the value was added to the set, that is if it was not
848      * already present.
849      */
850     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
851         return _add(set._inner, value);
852     }
853 
854     /**
855      * @dev Removes a value from a set. O(1).
856      *
857      * Returns true if the value was removed from the set, that is if it was
858      * present.
859      */
860     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
861         return _remove(set._inner, value);
862     }
863 
864     /**
865      * @dev Returns true if the value is in the set. O(1).
866      */
867     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
868         return _contains(set._inner, value);
869     }
870 
871     /**
872      * @dev Returns the number of values in the set. O(1).
873      */
874     function length(Bytes32Set storage set) internal view returns (uint256) {
875         return _length(set._inner);
876     }
877 
878    /**
879     * @dev Returns the value stored at position `index` in the set. O(1).
880     *
881     * Note that there are no guarantees on the ordering of values inside the
882     * array, and it may change when more values are added or removed.
883     *
884     * Requirements:
885     *
886     * - `index` must be strictly less than {length}.
887     */
888     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
889         return _at(set._inner, index);
890     }
891 
892     // AddressSet
893 
894     struct AddressSet {
895         Set _inner;
896     }
897 
898     /**
899      * @dev Add a value to a set. O(1).
900      *
901      * Returns true if the value was added to the set, that is if it was not
902      * already present.
903      */
904     function add(AddressSet storage set, address value) internal returns (bool) {
905         return _add(set._inner, bytes32(uint256(uint160(value))));
906     }
907 
908     /**
909      * @dev Removes a value from a set. O(1).
910      *
911      * Returns true if the value was removed from the set, that is if it was
912      * present.
913      */
914     function remove(AddressSet storage set, address value) internal returns (bool) {
915         return _remove(set._inner, bytes32(uint256(uint160(value))));
916     }
917 
918     /**
919      * @dev Returns true if the value is in the set. O(1).
920      */
921     function contains(AddressSet storage set, address value) internal view returns (bool) {
922         return _contains(set._inner, bytes32(uint256(uint160(value))));
923     }
924 
925     /**
926      * @dev Returns the number of values in the set. O(1).
927      */
928     function length(AddressSet storage set) internal view returns (uint256) {
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
942     function at(AddressSet storage set, uint256 index) internal view returns (address) {
943         return address(uint160(uint256(_at(set._inner, index))));
944     }
945 
946 
947     // UintSet
948 
949     struct UintSet {
950         Set _inner;
951     }
952 
953     /**
954      * @dev Add a value to a set. O(1).
955      *
956      * Returns true if the value was added to the set, that is if it was not
957      * already present.
958      */
959     function add(UintSet storage set, uint256 value) internal returns (bool) {
960         return _add(set._inner, bytes32(value));
961     }
962 
963     /**
964      * @dev Removes a value from a set. O(1).
965      *
966      * Returns true if the value was removed from the set, that is if it was
967      * present.
968      */
969     function remove(UintSet storage set, uint256 value) internal returns (bool) {
970         return _remove(set._inner, bytes32(value));
971     }
972 
973     /**
974      * @dev Returns true if the value is in the set. O(1).
975      */
976     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
977         return _contains(set._inner, bytes32(value));
978     }
979 
980     /**
981      * @dev Returns the number of values on the set. O(1).
982      */
983     function length(UintSet storage set) internal view returns (uint256) {
984         return _length(set._inner);
985     }
986 
987    /**
988     * @dev Returns the value stored at position `index` in the set. O(1).
989     *
990     * Note that there are no guarantees on the ordering of values inside the
991     * array, and it may change when more values are added or removed.
992     *
993     * Requirements:
994     *
995     * - `index` must be strictly less than {length}.
996     */
997     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
998         return uint256(_at(set._inner, index));
999     }
1000 }
1001 
1002 
1003 
1004 pragma solidity >=0.6.0 <0.8.0;
1005 
1006 /**
1007  * @dev Library for managing an enumerable variant of Solidity's
1008  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1009  * type.
1010  *
1011  * Maps have the following properties:
1012  *
1013  * - Entries are added, removed, and checked for existence in constant time
1014  * (O(1)).
1015  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1016  *
1017  * ```
1018  * contract Example {
1019  *     // Add the library methods
1020  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1021  *
1022  *     // Declare a set state variable
1023  *     EnumerableMap.UintToAddressMap private myMap;
1024  * }
1025  * ```
1026  *
1027  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1028  * supported.
1029  */
1030 library EnumerableMap {
1031     // To implement this library for multiple types with as little code
1032     // repetition as possible, we write it in terms of a generic Map type with
1033     // bytes32 keys and values.
1034     // The Map implementation uses private functions, and user-facing
1035     // implementations (such as Uint256ToAddressMap) are just wrappers around
1036     // the underlying Map.
1037     // This means that we can only create new EnumerableMaps for types that fit
1038     // in bytes32.
1039 
1040     struct MapEntry {
1041         bytes32 _key;
1042         bytes32 _value;
1043     }
1044 
1045     struct Map {
1046         // Storage of map keys and values
1047         MapEntry[] _entries;
1048 
1049         // Position of the entry defined by a key in the `entries` array, plus 1
1050         // because index 0 means a key is not in the map.
1051         mapping (bytes32 => uint256) _indexes;
1052     }
1053 
1054     /**
1055      * @dev Adds a key-value pair to a map, or updates the value for an existing
1056      * key. O(1).
1057      *
1058      * Returns true if the key was added to the map, that is if it was not
1059      * already present.
1060      */
1061     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1062         // We read and store the key's index to prevent multiple reads from the same storage slot
1063         uint256 keyIndex = map._indexes[key];
1064 
1065         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1066             map._entries.push(MapEntry({ _key: key, _value: value }));
1067             // The entry is stored at length-1, but we add 1 to all indexes
1068             // and use 0 as a sentinel value
1069             map._indexes[key] = map._entries.length;
1070             return true;
1071         } else {
1072             map._entries[keyIndex - 1]._value = value;
1073             return false;
1074         }
1075     }
1076 
1077     /**
1078      * @dev Removes a key-value pair from a map. O(1).
1079      *
1080      * Returns true if the key was removed from the map, that is if it was present.
1081      */
1082     function _remove(Map storage map, bytes32 key) private returns (bool) {
1083         // We read and store the key's index to prevent multiple reads from the same storage slot
1084         uint256 keyIndex = map._indexes[key];
1085 
1086         if (keyIndex != 0) { // Equivalent to contains(map, key)
1087             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1088             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1089             // This modifies the order of the array, as noted in {at}.
1090 
1091             uint256 toDeleteIndex = keyIndex - 1;
1092             uint256 lastIndex = map._entries.length - 1;
1093 
1094             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1095             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1096 
1097             MapEntry storage lastEntry = map._entries[lastIndex];
1098 
1099             // Move the last entry to the index where the entry to delete is
1100             map._entries[toDeleteIndex] = lastEntry;
1101             // Update the index for the moved entry
1102             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1103 
1104             // Delete the slot where the moved entry was stored
1105             map._entries.pop();
1106 
1107             // Delete the index for the deleted slot
1108             delete map._indexes[key];
1109 
1110             return true;
1111         } else {
1112             return false;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Returns true if the key is in the map. O(1).
1118      */
1119     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1120         return map._indexes[key] != 0;
1121     }
1122 
1123     /**
1124      * @dev Returns the number of key-value pairs in the map. O(1).
1125      */
1126     function _length(Map storage map) private view returns (uint256) {
1127         return map._entries.length;
1128     }
1129 
1130    /**
1131     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1132     *
1133     * Note that there are no guarantees on the ordering of entries inside the
1134     * array, and it may change when more entries are added or removed.
1135     *
1136     * Requirements:
1137     *
1138     * - `index` must be strictly less than {length}.
1139     */
1140     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1141         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1142 
1143         MapEntry storage entry = map._entries[index];
1144         return (entry._key, entry._value);
1145     }
1146 
1147     /**
1148      * @dev Tries to returns the value associated with `key`.  O(1).
1149      * Does not revert if `key` is not in the map.
1150      */
1151     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1152         uint256 keyIndex = map._indexes[key];
1153         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1154         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1155     }
1156 
1157     /**
1158      * @dev Returns the value associated with `key`.  O(1).
1159      *
1160      * Requirements:
1161      *
1162      * - `key` must be in the map.
1163      */
1164     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1165         uint256 keyIndex = map._indexes[key];
1166         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1167         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1168     }
1169 
1170     /**
1171      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1172      *
1173 
1174      */
1175     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1176         uint256 keyIndex = map._indexes[key];
1177         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1178         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1179     }
1180 
1181     // UintToAddressMap
1182 
1183     struct UintToAddressMap {
1184         Map _inner;
1185     }
1186 
1187     /**
1188      * @dev Adds a key-value pair to a map, or updates the value for an existing
1189      * key. O(1).
1190      *
1191      * Returns true if the key was added to the map, that is if it was not
1192      * already present.
1193      */
1194     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1195         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1196     }
1197 
1198     /**
1199      * @dev Removes a value from a set. O(1).
1200      *
1201      * Returns true if the key was removed from the map, that is if it was present.
1202      */
1203     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1204         return _remove(map._inner, bytes32(key));
1205     }
1206 
1207     /**
1208      * @dev Returns true if the key is in the map. O(1).
1209      */
1210     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1211         return _contains(map._inner, bytes32(key));
1212     }
1213 
1214     /**
1215      * @dev Returns the number of elements in the map. O(1).
1216      */
1217     function length(UintToAddressMap storage map) internal view returns (uint256) {
1218         return _length(map._inner);
1219     }
1220 
1221    /**
1222     * @dev Returns the element stored at position `index` in the set. O(1).
1223     * Note that there are no guarantees on the ordering of values inside the
1224     * array, and it may change when more values are added or removed.
1225     *
1226     * Requirements:
1227     *
1228     * - `index` must be strictly less than {length}.
1229     */
1230     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1231         (bytes32 key, bytes32 value) = _at(map._inner, index);
1232         return (uint256(key), address(uint160(uint256(value))));
1233     }
1234 
1235     /**
1236      * @dev Tries to returns the value associated with `key`.  O(1).
1237      * Does not revert if `key` is not in the map.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1242         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1243         return (success, address(uint160(uint256(value))));
1244     }
1245 
1246     /**
1247      * @dev Returns the value associated with `key`.  O(1).
1248      *
1249      * Requirements:
1250      *
1251      * - `key` must be in the map.
1252      */
1253     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1254         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1255     }
1256 
1257     /**
1258      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1259      *
1260 
1261      */
1262     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1263         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1264     }
1265 }
1266 
1267 
1268 
1269 pragma solidity >=0.6.0 <0.8.0;
1270 
1271 /**
1272  * @dev String operations.
1273  */
1274 library Strings {
1275     /**
1276      * @dev Converts a `uint256` to its ASCII `string` representation.
1277      */
1278     function toString(uint256 value) internal pure returns (string memory) {
1279         // Inspired by OraclizeAPI's implementation - MIT licence
1280         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1281 
1282         if (value == 0) {
1283             return "0";
1284         }
1285         uint256 temp = value;
1286         uint256 digits;
1287         while (temp != 0) {
1288             digits++;
1289             temp /= 10;
1290         }
1291         bytes memory buffer = new bytes(digits);
1292         uint256 index = digits - 1;
1293         temp = value;
1294         while (temp != 0) {
1295             buffer[index--] = bytes1(uint8(48 + temp % 10));
1296             temp /= 10;
1297         }
1298         return string(buffer);
1299     }
1300 }
1301 
1302 
1303 
1304 pragma solidity >=0.6.0 <0.8.0;
1305 
1306 /**
1307  * @title ERC721 Non-Fungible Token Standard basic implementation
1308  * @dev see https://eips.ethereum.org/EIPS/eip-721
1309  */
1310  
1311 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1312     using SafeMath for uint256;
1313     using Address for address;
1314     using EnumerableSet for EnumerableSet.UintSet;
1315     using EnumerableMap for EnumerableMap.UintToAddressMap;
1316     using Strings for uint256;
1317 
1318     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1319     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1320     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1321 
1322     // Mapping from holder address to their (enumerable) set of owned tokens
1323     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1324 
1325     // Enumerable mapping from token ids to their owners
1326     EnumerableMap.UintToAddressMap private _tokenOwners;
1327 
1328     // Mapping from token ID to approved address
1329     mapping (uint256 => address) private _tokenApprovals;
1330 
1331     // Mapping from owner to operator approvals
1332     mapping (address => mapping (address => bool)) private _operatorApprovals;
1333 
1334     // Token name
1335     string private _name;
1336 
1337     // Token symbol
1338     string private _symbol;
1339 
1340     // Optional mapping for token URIs
1341     mapping (uint256 => string) private _tokenURIs;
1342 
1343     // Base URI
1344     string private _baseURI;
1345 
1346     /*
1347      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1348      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1349      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1350      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1351      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1352      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1353      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1354      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1355      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1356      *
1357      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1358      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1359      */
1360     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1361 
1362     /*
1363      *     bytes4(keccak256('name()')) == 0x06fdde03
1364      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1365      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1366      *
1367      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1368      */
1369     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1370 
1371     /*
1372      *     bytes4(keccak256('totalSupply()')) == 0n18160ddd
1373      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1374      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1375      *
1376      *     => 0n18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1377      */
1378     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1379 
1380     /**
1381      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1382      */
1383     constructor (string memory name_, string memory symbol_) public {
1384         _name = name_;
1385         _symbol = symbol_;
1386 
1387         // register the supported interfaces to conform to ERC721 via ERC165
1388         _registerInterface(_INTERFACE_ID_ERC721);
1389         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1390         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-balanceOf}.
1395      */
1396     function balanceOf(address owner) public view virtual override returns (uint256) {
1397         require(owner != address(0), "ERC721: balance query for the zero address");
1398         return _holderTokens[owner].length();
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-ownerOf}.
1403      */
1404     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1405         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Metadata-name}.
1410      */
1411     function name() public view virtual override returns (string memory) {
1412         return _name;
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Metadata-symbol}.
1417      */
1418     function symbol() public view virtual override returns (string memory) {
1419         return _symbol;
1420     }
1421 
1422     /**
1423      * @dev See {IERC721Metadata-tokenURI}.
1424      */
1425     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1426         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1427 
1428         string memory _tokenURI = _tokenURIs[tokenId];
1429         string memory base = baseURI();
1430 
1431         // If there is no base URI, return the token URI.
1432         if (bytes(base).length == 0) {
1433             return _tokenURI;
1434         }
1435         // If both are set,  the baseURI and tokenURI (via abi.encodePacked).
1436         if (bytes(_tokenURI).length > 0) {
1437             return string(abi.encodePacked(base, _tokenURI));
1438         }
1439         // If there is a baseURI but no tokenURI,  the tokenID to the baseURI.
1440         return string(abi.encodePacked(base, tokenId.toString()));
1441     }
1442 
1443     /**
1444     * @dev Returns the base URI set via {_setBaseURI}. This will be
1445     * automatically added as a prefix in {tokenURI} to each token's URI, or
1446     * to the token ID if no specific URI is set for that token ID.
1447     */
1448     function baseURI() public view virtual returns (string memory) {
1449         return _baseURI;
1450     }
1451 
1452     /**
1453      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1454      */
1455     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1456         return _holderTokens[owner].at(index);
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Enumerable-totalSupply}.
1461      */
1462     function totalSupply() public view virtual override returns (uint256) {
1463         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1464         return _tokenOwners.length();
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-tokenByIndex}.
1469      */
1470     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1471         (uint256 tokenId, ) = _tokenOwners.at(index);
1472         return tokenId;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721-approve}.
1477      */
1478     function approve(address to, uint256 tokenId) public virtual override {
1479         address owner = ERC721.ownerOf(tokenId);
1480         require(to != owner, "ERC721: approval to current owner");
1481 
1482         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1483             "ERC721: approve caller is not owner nor approved for all"
1484         );
1485 
1486         _approve(to, tokenId);
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-getApproved}.
1491      */
1492     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1493         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1494 
1495         return _tokenApprovals[tokenId];
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-setApprovalForAll}.
1500      */
1501     function setApprovalForAll(address operator, bool approved) public virtual override {
1502         require(operator != _msgSender(), "ERC721: approve to caller");
1503 
1504         _operatorApprovals[_msgSender()][operator] = approved;
1505         emit ApprovalForAll(_msgSender(), operator, approved);
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-isApprovedForAll}.
1510      */
1511     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1512         return _operatorApprovals[owner][operator];
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-transferFrom}.
1517      */
1518     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1519         //solhint-disable-next-line max-line-length
1520         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1521 
1522         _transfer(from, to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev See {IERC721-safeTransferFrom}.
1527      */
1528     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1529         safeTransferFrom(from, to, tokenId, "");
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-safeTransferFrom}.
1534      */
1535     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1536         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1537         _safeTransfer(from, to, tokenId, _data);
1538     }
1539 
1540     /**
1541      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1542      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1543      *
1544      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1545      *
1546      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1547      * implement alternative mechanisms to perform token transfer, such as signature-based.
1548      *
1549      * Requirements:
1550      *
1551      * - `from` cannot be the zero address.
1552      * - `to` cannot be the zero address.
1553      * - `tokenId` token must exist and be owned by `from`.
1554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1555      *
1556      * Emits a {Transfer} event.
1557      */
1558     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1559         _transfer(from, to, tokenId);
1560         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1561     }
1562 
1563     /**
1564      * @dev Returns whether `tokenId` exists.
1565      *
1566      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1567      *
1568      * Tokens start existing when they are minted (`_mint`),
1569      * and stop existing when they are burned (`_burn`).
1570      */
1571     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1572         return _tokenOwners.contains(tokenId);
1573     }
1574 
1575     /**
1576      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1577      *
1578      * Requirements:
1579      *
1580      * - `tokenId` must exist.
1581      */
1582     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1583         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1584         address owner = ERC721.ownerOf(tokenId);
1585         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1586     }
1587 
1588     /**
1589      * @dev Safely mints `tokenId` and transfers it to `to`.
1590      *
1591      * Requirements:
1592      d*
1593      * - `tokenId` must not exist.
1594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function _safeMint(address to, uint256 tokenId) internal virtual {
1599         _safeMint(to, tokenId, "");
1600     }
1601 
1602     /**
1603      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1604      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1605      */
1606     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1607         _mint(to, tokenId);
1608         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1609     }
1610 
1611     /**
1612      * @dev Mints `tokenId` and transfers it to `to`.
1613      *
1614      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must not exist.
1619      * - `to` cannot be the zero address.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _mint(address to, uint256 tokenId) internal virtual {
1624         require(to != address(0), "ERC721: mint to the zero address");
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
1636     /**
1637      * @dev Destroys `tokenId`.
1638      * The approval is cleared when the token is burned.
1639      *
1640      * Requirements:
1641      *
1642      * - `tokenId` must exist.
1643      *
1644      * Emits a {Transfer} event.
1645      */
1646     function _burn(uint256 tokenId) internal virtual {
1647         address owner = ERC721.ownerOf(tokenId); // internal owner
1648 
1649         _beforeTokenTransfer(owner, address(0), tokenId);
1650 
1651         // Clear approvals
1652         _approve(address(0), tokenId);
1653 
1654         // Clear metadata (if any)
1655         if (bytes(_tokenURIs[tokenId]).length != 0) {
1656             delete _tokenURIs[tokenId];
1657         }
1658 
1659         _holderTokens[owner].remove(tokenId);
1660 
1661         _tokenOwners.remove(tokenId);
1662 
1663         emit Transfer(owner, address(0), tokenId);
1664     }
1665 
1666     /**
1667      * @dev Transfers `tokenId` from `from` to `to`.
1668      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `tokenId` token must be owned by `from`.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1678         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1679         require(to != address(0), "ERC721: transfer to the zero address");
1680 
1681         _beforeTokenTransfer(from, to, tokenId);
1682 
1683         // Clear approvals from the previous owner
1684         _approve(address(0), tokenId);
1685 
1686         _holderTokens[from].remove(tokenId);
1687         _holderTokens[to].add(tokenId);
1688 
1689         _tokenOwners.set(tokenId, to);
1690 
1691         emit Transfer(from, to, tokenId);
1692     }
1693 
1694     /**
1695      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must exist.
1700      */
1701     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1702         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1703         _tokenURIs[tokenId] = _tokenURI;
1704     }
1705 
1706     /**
1707      * @dev Internal function to set the base URI for all token IDs. It is
1708      * automatically added as a prefix to the value returned in {tokenURI},
1709      * or to the token ID if {tokenURI} is empty.
1710      */
1711     function _setBaseURI(string memory baseURI_) internal virtual {
1712         _baseURI = baseURI_;
1713     }
1714 
1715     /**
1716      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1717      * The call is not executed if the target address is not a contract.
1718      *
1719      * @param from address representing the previous owner of the given token ID
1720      * @param to target address that will receive the tokens
1721      * @param tokenId uint256 ID of the token to be transferred
1722      * @param _data bytes optional data to send along with the call
1723      * @return bool whether the call correctly returned the expected magic value
1724      */
1725     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1726         private returns (bool)
1727     {
1728         if (!to.isContract()) {
1729             return true;
1730         }
1731         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1732             IERC721Receiver(to).onERC721Received.selector,
1733             _msgSender(),
1734             from,
1735             tokenId,
1736             _data
1737         ), "ERC721: transfer to non ERC721Receiver implementer");
1738         bytes4 retval = abi.decode(returndata, (bytes4));
1739         return (retval == _ERC721_RECEIVED);
1740     }
1741 
1742     /**
1743      * @dev Approve `to` to operate on `tokenId`
1744      *
1745      * Emits an {Approval} event.
1746      */
1747     function _approve(address to, uint256 tokenId) internal virtual {
1748         _tokenApprovals[tokenId] = to;
1749         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1750     }
1751 
1752     /**
1753      * @dev Hook that is called before any token transfer. This includes minting
1754      * and burning.
1755      *
1756      * Calling conditions:
1757      *
1758      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1759      * transferred to `to`.
1760      * - When `from` is zero, `tokenId` will be minted for `to`.
1761      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1762      * - `from` cannot be the zero address.
1763      * - `to` cannot be the zero address.
1764      *
1765      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1766      */
1767     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1768 }
1769 
1770 
1771 
1772 pragma solidity >=0.6.0 <0.8.0;
1773 
1774 /**
1775  * @dev Contract module which provides a basic access control mechanism, where
1776  * there is an account (an owner) that can be granted exclusive access to
1777  * specific functions.
1778  *
1779  * By default, the owner account will be the one that deploys the contract. This
1780  * can later be changed with {transferOwnership}.
1781  *
1782  * This module is used through inheritance. It will make available the modifier
1783  * `onlyOwner`, which can be applied to your functions to restrict their use to
1784  * the owner.
1785  */
1786 abstract contract Ownable is Context {
1787     address private _owner;
1788 
1789     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1790 
1791     /**
1792      * @dev Initializes the contract setting the deployer as the initial owner.
1793      */
1794     constructor () internal {
1795         address msgSender = _msgSender();
1796         _owner = msgSender;
1797         emit OwnershipTransferred(address(0), msgSender);
1798     }
1799 
1800     /**
1801      * @dev Returns the address of the current owner.
1802      */
1803     function owner() public view virtual returns (address) {
1804         return _owner;
1805     }
1806 
1807     /**
1808      * @dev Throws if called by any account other than the owner.
1809      */
1810     modifier onlyOwner() {
1811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1812         _;
1813     }
1814 
1815     /**
1816      * @dev Leaves the contract without owner. It will not be possible to call
1817      * `onlyOwner` functions anymore. Can only be called by the current owner.
1818      *
1819      * NOTE: Renouncing ownership will leave the contract without an owner,
1820      * thereby removing any functionality that is only available to the owner.
1821      */
1822     function renounceOwnership() public virtual onlyOwner {
1823         emit OwnershipTransferred(_owner, address(0));
1824         _owner = address(0);
1825     }
1826 
1827     /**
1828      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1829      * Can only be called by the current owner.
1830      */
1831     function transferOwnership(address newOwner) public virtual onlyOwner {
1832         require(newOwner != address(0), "Ownable: new owner is the zero address");
1833         emit OwnershipTransferred(_owner, newOwner);
1834         _owner = newOwner;
1835     }
1836 }
1837 
1838 
1839 
1840 /**
1841  * @dev Interface of the ERC20 standard as defined in the EIP.
1842  */
1843 interface IERC20 {
1844     /**
1845      * @dev Returns the amount of tokens in existence.
1846      */
1847     function totalSupply() external view returns (uint256);
1848 
1849     /**
1850      * @dev Returns the amount of tokens owned by `account`.
1851      */
1852     function balanceOf(address account) external view returns (uint256);
1853 
1854     /**
1855      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1856      *
1857      * Returns a boolean value  whether the operation succeeded.
1858      *
1859      * Emits a {Transfer} event.
1860      */
1861     function transfer(address recipient, uint256 amount) external returns (bool);
1862 
1863     /**
1864      * @dev Returns the remaining number of tokens that `spender` will be
1865      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1866      * zero by default.
1867      *
1868      * This value changes when {approve} or {transferFrom} are called.
1869      */
1870     function allowance(address owner, address spender) external view returns (uint256);
1871 
1872     /**
1873      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1874      *
1875      * Returns a boolean value  whether the operation succeeded.
1876      *
1877      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1878      * that someone may use both the old and the new allowance by unfortunate
1879      * transaction ordering. One possible solution to mitigate this race
1880      * condition is to first reduce the spender's allowance to 0 and set the
1881      * desired value afterwards:
1882      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1883      *
1884      * Emits an {Approval} event.
1885      */
1886     function approve(address spender, uint256 amount) external returns (bool);
1887 
1888     /**
1889      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1890      * allowance mechanism. `amount` is then deducted from the caller's
1891      * allowance.
1892      *
1893      * Returns a boolean value  whether the operation succeeded.
1894      *
1895      * Emits a {Transfer} event.
1896      */
1897     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1898 
1899     /**
1900      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1901      * another (`to`).
1902      *
1903      * Note that `value` may be zero.
1904      */
1905     event Transfer(address indexed from, address indexed to, uint256 value);
1906 
1907     /**
1908      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1909      * a call to {approve}. `value` is the new allowance.
1910      */
1911     event Approval(address indexed owner, address indexed spender, uint256 value);
1912 }
1913 
1914 
1915 
1916 
1917 /**
1918  * @dev Implementation of the {IERC20} interface.
1919  *
1920  * This implementation is agnostic to the way tokens are created. This means
1921  * that a supply mechanism has to be added in a derived contract using {_mint}.
1922  * For a generic mechanism see {ERC20PresetMinterPauser}.
1923  *
1924  * TIP: For a detailed writeup see our guide
1925  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1926  * to implement supply mechanisms].
1927  *
1928  * We have followed general OpenZeppelin guidelines: functions revert instead
1929  * of returning `false` on failure. This behavior is nonetheless conventional
1930  * and does not conflict with the expectations of ERC20 .
1931  *
1932  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1933  * This allows  to reconstruct the allowance for all accounts just
1934  * by listening to said events. Other implementations of the EIP may not emit
1935  * these events, as it isn't required.
1936  *
1937  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1938  * functions have been added to mitigate the well-known issues around setting
1939  * allowances. See {IERC20-approve}.
1940  */
1941 contract ERC20 is Context, IERC20 {
1942     using SafeMath for uint256;
1943     using Address for address;
1944 
1945     mapping (address => uint256) private _balances;
1946 
1947     mapping (address => mapping (address => uint256)) private _allowances;
1948 
1949     uint256 private _totalSupply;
1950 
1951     string private _name;
1952     string private _symbol;
1953     uint8 private _decimals;
1954 
1955     /**
1956      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1957      * a default value of 18.
1958      *
1959      * To select a different value for {decimals}, use {_setupDecimals}.
1960      *
1961      * All three of these values are immutable: they can only be set once during
1962      * construction.
1963      */
1964     constructor (string memory name, string memory symbol) public {
1965         _name = name;
1966         _symbol = symbol;
1967         _decimals = 18;
1968     }
1969 
1970     /**
1971      * @dev Returns the name of the token.
1972      */
1973     function name() public view returns (string memory) {
1974         return _name;
1975     }
1976 
1977     /**
1978      * @dev Returns the symbol of the token, usually a shorter version of the
1979      * name.
1980      */
1981     function symbol() public view returns (string memory) {
1982         return _symbol;
1983     }
1984 
1985     /**
1986      * @dev Returns the number of decimals used to get its user representation.
1987      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1988      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1989      *
1990      * Tokens usually opt for a value of 18, imitating the relationship between
1991      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1992      * called.
1993      *
1994      * NOTE: This information is only used for _display_ purposes: it in
1995      * no way affects any of the arithmetic of the contract, including
1996      * {IERC20-balanceOf} and {IERC20-transfer}.
1997      */
1998     function decimals() public view returns (uint8) {
1999         return _decimals;
2000     }
2001 
2002     /**
2003      * @dev See {IERC20-totalSupply}.
2004      */
2005     function totalSupply() public view override returns (uint256) {
2006         return _totalSupply;
2007     }
2008 
2009     /**
2010      * @dev See {IERC20-balanceOf}.
2011      */
2012     function balanceOf(address account) public view override returns (uint256) {
2013         return _balances[account];
2014     }
2015 
2016     /**
2017      * @dev See {IERC20-transfer}.
2018      *
2019      * Requirements:
2020      *
2021      * - `recipient` cannot be the zero address.
2022      * - the caller must have a balance of at least `amount`.
2023      */
2024     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2025         _transfer(_msgSender(), recipient, amount);
2026         return true;
2027     }
2028 
2029     /**
2030      * @dev See {IERC20-allowance}.
2031      */
2032     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2033         return _allowances[owner][spender];
2034     }
2035 
2036     /**
2037      * @dev See {IERC20-approve}.
2038      *
2039      * Requirements:
2040      *
2041      * - `spender` cannot be the zero address.
2042      */
2043     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2044         _approve(_msgSender(), spender, amount);
2045         return true;
2046     }
2047 
2048     /**
2049      * @dev See {IERC20-transferFrom}.
2050      *
2051 
2052      * Requirements:
2053      * - `sender` and `recipient` cannot be the zero address.
2054      * - `sender` must have a balance of at least `amount`.
2055      * - the caller must have allowance for ``sender``'s tokens of at least
2056      * `amount`.
2057      */
2058     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2059         _transfer(sender, recipient, amount);
2060         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
2061         return true;
2062     }
2063 
2064     /**
2065      * @dev Atomically increases the allowance granted to `spender` by the caller.
2066      *
2067      * This is an alternative to {approve} that can be used as a mitigation for
2068      * problems described in {IERC20-approve}.
2069      *
2070 
2071      * Requirements:
2072      *
2073      * - `spender` cannot be the zero address.
2074      */
2075     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2076         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2077         return true;
2078     }
2079 
2080     /**
2081      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2082      *
2083      * This is an alternative to {approve} that can be used as a mitigation for
2084      * problems described in {IERC20-approve}.
2085      *
2086 
2087      * Requirements:
2088      *
2089      * - `spender` cannot be the zero address.
2090      * - `spender` must have allowance for the caller of at least
2091      * `subtractedValue`.
2092      */
2093     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2094         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2095         return true;
2096     }
2097 
2098     /**
2099      * @dev Moves tokens `amount` from `sender` to `recipient`.
2100      *
2101      * This is internal function is equivalent to {transfer}, and can be used to
2102      * e.g. implement automatic token fees, slashing mechanisms, etc.
2103      *
2104      * Emits a {Transfer} event.
2105      *
2106      * Requirements:
2107      *
2108      * - `sender` cannot be the zero address.
2109      * - `recipient` cannot be the zero address.
2110      * - `sender` must have a balance of at least `amount`.
2111      */
2112     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2113         require(sender != address(0), "ERC20: transfer from the zero address");
2114         require(recipient != address(0), "ERC20: transfer to the zero address");
2115 
2116         _beforeTokenTransfer(sender, recipient, amount);
2117 
2118         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2119         _balances[recipient] = _balances[recipient].add(amount);
2120         emit Transfer(sender, recipient, amount);
2121     }
2122 
2123     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2124      * the total supply.
2125      *
2126      * Emits a {Transfer} event with `from` set to the zero address.
2127      *
2128      * Requirements
2129      *
2130      * - `to` cannot be the zero address.
2131      */
2132     function _mint(address account, uint256 amount) internal virtual {
2133         require(account != address(0), "ERC20: mint to the zero address");
2134 
2135         _beforeTokenTransfer(address(0), account, amount);
2136 
2137         _totalSupply = _totalSupply.add(amount);
2138         _balances[account] = _balances[account].add(amount);
2139         emit Transfer(address(0), account, amount);
2140     }
2141 
2142     /**
2143      * @dev Destroys `amount` tokens from `account`, reducing the
2144      * total supply.
2145      *
2146      * Emits a {Transfer} event with `to` set to the zero address.
2147      *
2148      * Requirements
2149      *
2150      * - `account` cannot be the zero address.
2151      * - `account` must have at least `amount` tokens.
2152      */
2153     function _burn(address account, uint256 amount) internal virtual {
2154         require(account != address(0), "ERC20: burn from the zero address");
2155 
2156         _beforeTokenTransfer(account, address(0), amount);
2157 
2158         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2159         _totalSupply = _totalSupply.sub(amount);
2160         emit Transfer(account, address(0), amount);
2161     }
2162 
2163     /**
2164      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2165      *
2166      * This internal function is equivalent to `approve`, and can be used to
2167      * e.g. set automatic allowances for certain subsystems, etc.
2168      *
2169      * Emits an {Approval} event.
2170      *
2171      * Requirements:
2172      *
2173      * - `owner` cannot be the zero address.
2174      * - `spender` cannot be the zero address.
2175      */
2176     function _approve(address owner, address spender, uint256 amount) internal virtual {
2177         require(owner != address(0), "ERC20: approve from the zero address");
2178         require(spender != address(0), "ERC20: approve to the zero address");
2179 
2180         _allowances[owner][spender] = amount;
2181         emit Approval(owner, spender, amount);
2182     }
2183 
2184     /**
2185      * @dev Sets {decimals} to a value other than the default one of 18.
2186      *
2187 
2188      */
2189     function _setupDecimals(uint8 decimals_) internal {
2190         _decimals = decimals_;
2191     }
2192 
2193     /**
2194      * @dev Hook that is called before any transfer of tokens. This includes
2195      * minting and burning.
2196      *
2197      * Calling conditions:
2198      *
2199      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2200      * will be to transferred to `to`.
2201      * - when `from` is zero, `amount` tokens will be minted for `to`.
2202      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2203      * - `from` and `to` are never both zero.
2204      *
2205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2206      */
2207     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2208 }
2209 
2210 
2211 
2212 pragma solidity ^0.7.0;
2213 pragma abicoder v2;
2214 
2215 
2216 /**
2217  * @dev ERC721
2218 */
2219 interface IP0n1 {
2220     function updateReward(address _from, address _to) external;
2221 } 
2222 
2223 contract pixel0n1scontract is ERC721, Ownable {
2224     using SafeMath for uint256;
2225     string public pixel0n1_PROVENANCE = "";
2226     uint256 public  pixel0n1Price =   20000000000000000; // 0.02ETH
2227     uint public constant MAX_pixel0n1_PURCHASE = 20;    
2228     uint256 public  MAX_pixel0n1s = 7777;
2229     uint256 public  MAX_FREEMINT = 600;    
2230 
2231     bool public MintSaleIsActive = true;
2232 
2233     IP0n1 public P0n1;      //P0n1 token
2234     mapping (address => uint256) public balanceTokens;
2235 
2236     constructor() ERC721("Pixel 0n1", "pixel0n1") { }
2237     
2238     function withdraw() public onlyOwner {
2239         uint balance = address(this).balance;
2240         msg.sender.transfer(balance);
2241     }    
2242 
2243     function Reserve(uint _amount, address _address) public onlyOwner {
2244          require(totalSupply()  + _amount <= MAX_pixel0n1s, "All tokens minted");
2245 
2246          for (uint i = 0; i < _amount; i++) {
2247             _safeMint(_address, totalSupply() + i);
2248             balanceTokens[_address]++;           
2249          }
2250      }
2251     
2252     function setMintPrice(uint price) external onlyOwner {
2253         pixel0n1Price = price;
2254     }
2255     
2256     function setMaxFreeMint(uint _MAX_FREEMINT) external onlyOwner {
2257         MAX_FREEMINT = _MAX_FREEMINT;
2258     }   
2259 
2260     function setMaxpixel0n1s(uint maxpixel0n1) external onlyOwner {
2261         MAX_pixel0n1s = maxpixel0n1;
2262     }
2263 
2264     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2265         pixel0n1_PROVENANCE = provenanceHash;
2266     }
2267 
2268     function setBaseURI(string memory baseURI) public onlyOwner {
2269         _setBaseURI(baseURI);
2270     } 
2271 	
2272     function flipMintSaleState() public onlyOwner {
2273         MintSaleIsActive = !MintSaleIsActive;
2274     }
2275 
2276 	function setP0n1TokenContract(address P0n1Address) external onlyOwner {
2277         P0n1 = IP0n1(P0n1Address);
2278     }
2279 	    
2280     function mintpixel0n1s(uint numberOfTokens) public payable {
2281         require(MintSaleIsActive, "Sale must be active to mint pixel0n1");
2282         require(numberOfTokens > 0 && numberOfTokens <= MAX_pixel0n1_PURCHASE, "Can only mint 20 pixel0n1 at a time");
2283         require(totalSupply() + numberOfTokens <= MAX_pixel0n1s, "Purchase would exceed max supply of pixel0n1s");
2284         
2285         if(totalSupply()> MAX_FREEMINT) {
2286             require(msg.value >= pixel0n1Price.mul(numberOfTokens), "Ether value sent is not correct");
2287         }
2288 
2289         for (uint i = 0; i < numberOfTokens; i++) {
2290             if (totalSupply() < MAX_pixel0n1s) {
2291             _safeMint(msg.sender, totalSupply());
2292             balanceTokens[msg.sender]++;
2293             }
2294         }
2295    }  
2296 
2297   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2298         uint256 tokenCount = balanceOf(_owner);
2299         if (tokenCount == 0) {
2300             // Return an empty array
2301             return new uint256[](0);
2302         } else {
2303             uint256[] memory result = new uint256[](tokenCount);
2304             uint256 index;
2305             for (index = 0; index < tokenCount; index++) {
2306                 result[index] = tokenOfOwnerByIndex(_owner, index);
2307             }
2308             return result;
2309         }
2310     }
2311 
2312   function transferFrom(address from, address to, uint256 tokenId) public override {
2313         if (tokenId < MAX_pixel0n1s) {
2314             P0n1.updateReward(from, to);
2315             balanceTokens[from]--;
2316             balanceTokens[to]++;
2317         }
2318         ERC721.transferFrom(from, to, tokenId);
2319     }
2320 
2321   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
2322         if (tokenId < MAX_pixel0n1s) {
2323             P0n1.updateReward(from, to);
2324             balanceTokens[from]--;
2325             balanceTokens[to]++;
2326         }
2327         ERC721.safeTransferFrom(from, to, tokenId, data);
2328     }
2329     
2330 }