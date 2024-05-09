1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an applimightygojiraion
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
357      * @dev Returns the multiplimightygojiraion of two unsigned integers, with an overflow flag.
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
423      * @dev Returns the multiplimightygojiraion of two unsigned integers, reverting on
424      * overflow.
425      *
426      * Counterpart to Solidity's `*` operator.
427      *
428      * Requirements:
429      *
430      * - Multiplimightygojiraion cannot overflow.
431      */
432     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
433         if (a == 0) return 0;
434         uint256 c = a * b;
435         require(c / a == b, "SafeMath: multiplimightygojiraion overflow");
436         return c;
437     }
438 
439     /**
440      * @dev Returns the integer division of two unsigned integers, reverting on
441      * division by zero. The result is rounded towards zero.
442      *
443      * Counterpart to Solidity's `/` operator. Note: this function uses a
444      * `revert` opcode (which leaves remaining gas untouched) while Solidity
445      * uses an invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(uint256 a, uint256 b) internal pure returns (uint256) {
452         require(b > 0, "SafeMath: division by zero");
453         return a / b;
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
458      * reverting when dividing by zero.
459      *
460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
461      * opcode (which leaves remaining gas untouched) while Solidity uses an
462      * invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
469         require(b > 0, "SafeMath: modulo by zero");
470         return a % b;
471     }
472 
473     /**
474      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
475      * overflow (when the result is negative).
476      *
477      * CAUTION: This function is depremightygojiraed because it requires allomightygojiraing memory for the error
478      * message unnecessarily. For custom revert reasons use {trySub}.
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
487         require(b <= a, errorMessage);
488         return a - b;
489     }
490 
491     /**
492      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
493      * division by zero. The result is rounded towards zero.
494      *
495      * CAUTION: This function is depremightygojiraed because it requires allomightygojiraing memory for the error
496      * message unnecessarily. For custom revert reasons use {tryDiv}.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b > 0, errorMessage);
508         return a / b;
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * reverting with custom message when dividing by zero.
514      *
515      * CAUTION: This function is depremightygojiraed because it requires allomightygojiraing memory for the error
516      * message unnecessarily. For custom revert reasons use {tryMod}.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b > 0, errorMessage);
528         return a % b;
529     }
530 }
531 
532 
533 
534 pragma solidity >=0.6.2 <0.8.0;
535 
536 /**
537  * @dev Collection of functions related to the address type
538  */
539 library Address {
540     /**
541      * @dev Returns true if `account` is a contract.
542      *
543      * [IMPORTANT]
544      * ====
545      * It is unsafe to assume that an address for which this function returns
546      * false is an externally-owned account (EOA) and not a contract.
547      *
548      * Among others, `isContract` will return false for the following
549      * types of addresses:
550      *
551      *  - an externally-owned account
552      *  - a contract in construction
553      *  - an address where a contract will be created
554      *  - an address where a contract lived, but was destroyed
555      * ====
556      */
557     function isContract(address account) internal view returns (bool) {
558         // This method relies on extcodesize, which returns 0 for contracts in
559         // construction, since the code is only stored at the end of the
560         // constructor execution.
561 
562         uint256 size;
563         // solhint-disable-next-line no-inline-assembly
564         assembly { size := extcodesize(account) }
565         return size > 0;
566     }
567 
568     /**
569      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
570      * `recipient`, forwarding all available gas and reverting on errors.
571      *
572      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
573      * of certain opcodes, possibly making contracts go over the 2300 gas limit
574      * imposed by `transfer`, making them unable to receive funds via
575      * `transfer`. {sendValue} removes this limitation.
576      *
577      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
578      *
579      * IMPORTANT: because control is transferred to `recipient`, care must be
580      * taken to not create reentrancy vulnerabilities. Consider using
581      * {ReentrancyGuard} or the
582      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
583      */
584     function sendValue(address payable recipient, uint256 amount) internal {
585         require(address(this).balance >= amount, "Address: insufficient balance");
586 
587         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
588         (bool success, ) = recipient.call{ value: amount }("");
589         require(success, "Address: unable to send value, recipient may have reverted");
590     }
591 
592     /**
593      * @dev Performs a Solidity function call using a low level `call`. A
594      * plain`call` is an unsafe replacement for a function call: use this
595      * function instead.
596      *
597      * If `target` reverts with a revert reason, it is bubbled up by this
598      * function (like regular Solidity function calls).
599      *
600      * Returns the raw returned data. To convert to the expected return value,
601      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
602      *
603      * Requirements:
604      *
605      * - `target` must be a contract.
606      * - calling `target` with `data` must not revert.
607      *
608      * _Available since v3.1._
609      */
610     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
611       return functionCall(target, data, "Address: low-level call failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
616      * `errorMessage` as a fallback revert reason when `target` reverts.
617      *
618      * _Available since v3.1._
619      */
620     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
621         return functionCallWithValue(target, data, 0, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but also transferring `value` wei to `target`.
627      *
628      * Requirements:
629      *
630      * - the calling contract must have an ETH balance of at least `value`.
631      * - the called Solidity function must be `payable`.
632      *
633      * _Available since v3.1._
634      */
635     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
636         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
641      * with `errorMessage` as a fallback revert reason when `target` reverts.
642      *
643      * _Available since v3.1._
644      */
645     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
646         require(address(this).balance >= value, "Address: insufficient balance for call");
647         require(isContract(target), "Address: call to non-contract");
648 
649         // solhint-disable-next-line avoid-low-level-calls
650         (bool success, bytes memory returndata) = target.call{ value: value }(data);
651         return _verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a static call.
657      *
658      * _Available since v3.3._
659      */
660     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
661         return functionStaticCall(target, data, "Address: low-level static call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
666      * but performing a static call.
667      *
668      * _Available since v3.3._
669      */
670     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
671         require(isContract(target), "Address: static call to non-contract");
672 
673         // solhint-disable-next-line avoid-low-level-calls
674         (bool success, bytes memory returndata) = target.staticcall(data);
675         return _verifyCallResult(success, returndata, errorMessage);
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
680      * but performing a delegate call.
681      *
682      * _Available since v3.4._
683      */
684     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
685         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
690      * but performing a delegate call.
691      *
692      * _Available since v3.4._
693      */
694     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
695         require(isContract(target), "Address: delegate call to non-contract");
696 
697         // solhint-disable-next-line avoid-low-level-calls
698         (bool success, bytes memory returndata) = target.delegatecall(data);
699         return _verifyCallResult(success, returndata, errorMessage);
700     }
701 
702     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
703         if (success) {
704             return returndata;
705         } else {
706             // Look for revert reason and bubble it up if present
707             if (returndata.length > 0) {
708                 // The easiest way to bubble the revert reason is using memory via assembly
709 
710                 // solhint-disable-next-line no-inline-assembly
711                 assembly {
712                     let returndata_size := mload(returndata)
713                     revert(add(32, returndata), returndata_size)
714                 }
715             } else {
716                 revert(errorMessage);
717             }
718         }
719     }
720 }
721 
722 
723 pragma solidity >=0.6.0 <0.8.0;
724 
725 /**
726  * @dev Library for managing
727  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
728  * types.
729  *
730  * Sets have the following properties:
731  *
732  * - Elements are added, removed, and checked for existence in constant time
733  * (O(1)).
734  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
735  *
736  * ```
737  * contract Example {
738  *     // Add the library methods
739  *     using EnumerableSet for EnumerableSet.AddressSet;
740  *
741  *     // Declare a set state variable
742  *     EnumerableSet.AddressSet private mySet;
743  * }
744  * ```
745  *
746  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
747  * and `uint256` (`UintSet`) are supported.
748  */
749 library EnumerableSet {
750     // To implement this library for multiple types with as little code
751     // repetition as possible, we write it in terms of a generic Set type with
752     // bytes32 values.
753     // The Set implementation uses private functions, and user-facing
754     // implementations (such as AddressSet) are just wrappers around the
755     // underlying Set.
756     // This means that we can only create new EnumerableSets for types that fit
757     // in bytes32.
758 
759     struct Set {
760         // Storage of set values
761         bytes32[] _values;
762 
763         // Position of the value in the `values` array, plus 1 because index 0
764         // means a value is not in the set.
765         mapping (bytes32 => uint256) _indexes;
766     }
767 
768     /**
769      * @dev Add a value to a set. O(1).
770      *
771      * Returns true if the value was added to the set, that is if it was not
772      * already present.
773      */
774     function _add(Set storage set, bytes32 value) private returns (bool) {
775         if (!_contains(set, value)) {
776             set._values.push(value);
777             // The value is stored at length-1, but we add 1 to all indexes
778             // and use 0 as a sentinel value
779             set._indexes[value] = set._values.length;
780             return true;
781         } else {
782             return false;
783         }
784     }
785 
786     /**
787      * @dev Removes a value from a set. O(1).
788      *
789      * Returns true if the value was removed from the set, that is if it was
790      * present.
791      */
792     function _remove(Set storage set, bytes32 value) private returns (bool) {
793         // We read and store the value's index to prevent multiple reads from the same storage slot
794         uint256 valueIndex = set._indexes[value];
795 
796         if (valueIndex != 0) { // Equivalent to contains(set, value)
797             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
798             // the array, and then remove the last element (sometimes called as 'swap and pop').
799             // This modifies the order of the array, as noted in {at}.
800 
801             uint256 toDeleteIndex = valueIndex - 1;
802             uint256 lastIndex = set._values.length - 1;
803 
804             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
805             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
806 
807             bytes32 lastvalue = set._values[lastIndex];
808 
809             // Move the last value to the index where the value to delete is
810             set._values[toDeleteIndex] = lastvalue;
811             // Update the index for the moved value
812             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
813 
814             // Delete the slot where the moved value was stored
815             set._values.pop();
816 
817             // Delete the index for the deleted slot
818             delete set._indexes[value];
819 
820             return true;
821         } else {
822             return false;
823         }
824     }
825 
826     /**
827      * @dev Returns true if the value is in the set. O(1).
828      */
829     function _contains(Set storage set, bytes32 value) private view returns (bool) {
830         return set._indexes[value] != 0;
831     }
832 
833     /**
834      * @dev Returns the number of values on the set. O(1).
835      */
836     function _length(Set storage set) private view returns (uint256) {
837         return set._values.length;
838     }
839 
840    /**
841     * @dev Returns the value stored at position `index` in the set. O(1).
842     *
843     * Note that there are no guarantees on the ordering of values inside the
844     * array, and it may change when more values are added or removed.
845     *
846     * Requirements:
847     *
848     * - `index` must be strictly less than {length}.
849     */
850     function _at(Set storage set, uint256 index) private view returns (bytes32) {
851         require(set._values.length > index, "EnumerableSet: index out of bounds");
852         return set._values[index];
853     }
854 
855     // Bytes32Set
856 
857     struct Bytes32Set {
858         Set _inner;
859     }
860 
861     /**
862      * @dev Add a value to a set. O(1).
863      *
864      * Returns true if the value was added to the set, that is if it was not
865      * already present.
866      */
867     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
868         return _add(set._inner, value);
869     }
870 
871     /**
872      * @dev Removes a value from a set. O(1).
873      *
874      * Returns true if the value was removed from the set, that is if it was
875      * present.
876      */
877     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
878         return _remove(set._inner, value);
879     }
880 
881     /**
882      * @dev Returns true if the value is in the set. O(1).
883      */
884     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
885         return _contains(set._inner, value);
886     }
887 
888     /**
889      * @dev Returns the number of values in the set. O(1).
890      */
891     function length(Bytes32Set storage set) internal view returns (uint256) {
892         return _length(set._inner);
893     }
894 
895    /**
896     * @dev Returns the value stored at position `index` in the set. O(1).
897     *
898     * Note that there are no guarantees on the ordering of values inside the
899     * array, and it may change when more values are added or removed.
900     *
901     * Requirements:
902     *
903     * - `index` must be strictly less than {length}.
904     */
905     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
906         return _at(set._inner, index);
907     }
908 
909     // AddressSet
910 
911     struct AddressSet {
912         Set _inner;
913     }
914 
915     /**
916      * @dev Add a value to a set. O(1).
917      *
918      * Returns true if the value was added to the set, that is if it was not
919      * already present.
920      */
921     function add(AddressSet storage set, address value) internal returns (bool) {
922         return _add(set._inner, bytes32(uint256(uint160(value))));
923     }
924 
925     /**
926      * @dev Removes a value from a set. O(1).
927      *
928      * Returns true if the value was removed from the set, that is if it was
929      * present.
930      */
931     function remove(AddressSet storage set, address value) internal returns (bool) {
932         return _remove(set._inner, bytes32(uint256(uint160(value))));
933     }
934 
935     /**
936      * @dev Returns true if the value is in the set. O(1).
937      */
938     function contains(AddressSet storage set, address value) internal view returns (bool) {
939         return _contains(set._inner, bytes32(uint256(uint160(value))));
940     }
941 
942     /**
943      * @dev Returns the number of values in the set. O(1).
944      */
945     function length(AddressSet storage set) internal view returns (uint256) {
946         return _length(set._inner);
947     }
948 
949    /**
950     * @dev Returns the value stored at position `index` in the set. O(1).
951     *
952     * Note that there are no guarantees on the ordering of values inside the
953     * array, and it may change when more values are added or removed.
954     *
955     * Requirements:
956     *
957     * - `index` must be strictly less than {length}.
958     */
959     function at(AddressSet storage set, uint256 index) internal view returns (address) {
960         return address(uint160(uint256(_at(set._inner, index))));
961     }
962 
963 
964     // UintSet
965 
966     struct UintSet {
967         Set _inner;
968     }
969 
970     /**
971      * @dev Add a value to a set. O(1).
972      *
973      * Returns true if the value was added to the set, that is if it was not
974      * already present.
975      */
976     function add(UintSet storage set, uint256 value) internal returns (bool) {
977         return _add(set._inner, bytes32(value));
978     }
979 
980     /**
981      * @dev Removes a value from a set. O(1).
982      *
983      * Returns true if the value was removed from the set, that is if it was
984      * present.
985      */
986     function remove(UintSet storage set, uint256 value) internal returns (bool) {
987         return _remove(set._inner, bytes32(value));
988     }
989 
990     /**
991      * @dev Returns true if the value is in the set. O(1).
992      */
993     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
994         return _contains(set._inner, bytes32(value));
995     }
996 
997     /**
998      * @dev Returns the number of values on the set. O(1).
999      */
1000     function length(UintSet storage set) internal view returns (uint256) {
1001         return _length(set._inner);
1002     }
1003 
1004    /**
1005     * @dev Returns the value stored at position `index` in the set. O(1).
1006     *
1007     * Note that there are no guarantees on the ordering of values inside the
1008     * array, and it may change when more values are added or removed.
1009     *
1010     * Requirements:
1011     *
1012     * - `index` must be strictly less than {length}.
1013     */
1014     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1015         return uint256(_at(set._inner, index));
1016     }
1017 }
1018 
1019 
1020 
1021 pragma solidity >=0.6.0 <0.8.0;
1022 
1023 /**
1024  * @dev Library for managing an enumerable variant of Solidity's
1025  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1026  * type.
1027  *
1028  * Maps have the following properties:
1029  *
1030  * - Entries are added, removed, and checked for existence in constant time
1031  * (O(1)).
1032  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1033  *
1034  * ```
1035  * contract Example {
1036  *     // Add the library methods
1037  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1038  *
1039  *     // Declare a set state variable
1040  *     EnumerableMap.UintToAddressMap private myMap;
1041  * }
1042  * ```
1043  *
1044  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1045  * supported.
1046  */
1047 library EnumerableMap {
1048     // To implement this library for multiple types with as little code
1049     // repetition as possible, we write it in terms of a generic Map type with
1050     // bytes32 keys and values.
1051     // The Map implementation uses private functions, and user-facing
1052     // implementations (such as Uint256ToAddressMap) are just wrappers around
1053     // the underlying Map.
1054     // This means that we can only create new EnumerableMaps for types that fit
1055     // in bytes32.
1056 
1057     struct MapEntry {
1058         bytes32 _key;
1059         bytes32 _value;
1060     }
1061 
1062     struct Map {
1063         // Storage of map keys and values
1064         MapEntry[] _entries;
1065 
1066         // Position of the entry defined by a key in the `entries` array, plus 1
1067         // because index 0 means a key is not in the map.
1068         mapping (bytes32 => uint256) _indexes;
1069     }
1070 
1071     /**
1072      * @dev Adds a key-value pair to a map, or updates the value for an existing
1073      * key. O(1).
1074      *
1075      * Returns true if the key was added to the map, that is if it was not
1076      * already present.
1077      */
1078     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1079         // We read and store the key's index to prevent multiple reads from the same storage slot
1080         uint256 keyIndex = map._indexes[key];
1081 
1082         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1083             map._entries.push(MapEntry({ _key: key, _value: value }));
1084             // The entry is stored at length-1, but we add 1 to all indexes
1085             // and use 0 as a sentinel value
1086             map._indexes[key] = map._entries.length;
1087             return true;
1088         } else {
1089             map._entries[keyIndex - 1]._value = value;
1090             return false;
1091         }
1092     }
1093 
1094     /**
1095      * @dev Removes a key-value pair from a map. O(1).
1096      *
1097      * Returns true if the key was removed from the map, that is if it was present.
1098      */
1099     function _remove(Map storage map, bytes32 key) private returns (bool) {
1100         // We read and store the key's index to prevent multiple reads from the same storage slot
1101         uint256 keyIndex = map._indexes[key];
1102 
1103         if (keyIndex != 0) { // Equivalent to contains(map, key)
1104             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1105             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1106             // This modifies the order of the array, as noted in {at}.
1107 
1108             uint256 toDeleteIndex = keyIndex - 1;
1109             uint256 lastIndex = map._entries.length - 1;
1110 
1111             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1112             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1113 
1114             MapEntry storage lastEntry = map._entries[lastIndex];
1115 
1116             // Move the last entry to the index where the entry to delete is
1117             map._entries[toDeleteIndex] = lastEntry;
1118             // Update the index for the moved entry
1119             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1120 
1121             // Delete the slot where the moved entry was stored
1122             map._entries.pop();
1123 
1124             // Delete the index for the deleted slot
1125             delete map._indexes[key];
1126 
1127             return true;
1128         } else {
1129             return false;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Returns true if the key is in the map. O(1).
1135      */
1136     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1137         return map._indexes[key] != 0;
1138     }
1139 
1140     /**
1141      * @dev Returns the number of key-value pairs in the map. O(1).
1142      */
1143     function _length(Map storage map) private view returns (uint256) {
1144         return map._entries.length;
1145     }
1146 
1147    /**
1148     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1149     *
1150     * Note that there are no guarantees on the ordering of entries inside the
1151     * array, and it may change when more entries are added or removed.
1152     *
1153     * Requirements:
1154     *
1155     * - `index` must be strictly less than {length}.
1156     */
1157     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1158         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1159 
1160         MapEntry storage entry = map._entries[index];
1161         return (entry._key, entry._value);
1162     }
1163 
1164     /**
1165      * @dev Tries to returns the value associated with `key`.  O(1).
1166      * Does not revert if `key` is not in the map.
1167      */
1168     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1169         uint256 keyIndex = map._indexes[key];
1170         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1171         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1172     }
1173 
1174     /**
1175      * @dev Returns the value associated with `key`.  O(1).
1176      *
1177      * Requirements:
1178      *
1179      * - `key` must be in the map.
1180      */
1181     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1182         uint256 keyIndex = map._indexes[key];
1183         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1184         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1185     }
1186 
1187     /**
1188      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1189      *
1190      * CAUTION: This function is depremightygojiraed because it requires allomightygojiraing memory for the error
1191      * message unnecessarily. For custom revert reasons use {_tryGet}.
1192      */
1193     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1194         uint256 keyIndex = map._indexes[key];
1195         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1196         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1197     }
1198 
1199     // UintToAddressMap
1200 
1201     struct UintToAddressMap {
1202         Map _inner;
1203     }
1204 
1205     /**
1206      * @dev Adds a key-value pair to a map, or updates the value for an existing
1207      * key. O(1).
1208      *
1209      * Returns true if the key was added to the map, that is if it was not
1210      * already present.
1211      */
1212     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1213         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1214     }
1215 
1216     /**
1217      * @dev Removes a value from a set. O(1).
1218      *
1219      * Returns true if the key was removed from the map, that is if it was present.
1220      */
1221     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1222         return _remove(map._inner, bytes32(key));
1223     }
1224 
1225     /**
1226      * @dev Returns true if the key is in the map. O(1).
1227      */
1228     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1229         return _contains(map._inner, bytes32(key));
1230     }
1231 
1232     /**
1233      * @dev Returns the number of elements in the map. O(1).
1234      */
1235     function length(UintToAddressMap storage map) internal view returns (uint256) {
1236         return _length(map._inner);
1237     }
1238 
1239    /**
1240     * @dev Returns the element stored at position `index` in the set. O(1).
1241     * Note that there are no guarantees on the ordering of values inside the
1242     * array, and it may change when more values are added or removed.
1243     *
1244     * Requirements:
1245     *
1246     * - `index` must be strictly less than {length}.
1247     */
1248     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1249         (bytes32 key, bytes32 value) = _at(map._inner, index);
1250         return (uint256(key), address(uint160(uint256(value))));
1251     }
1252 
1253     /**
1254      * @dev Tries to returns the value associated with `key`.  O(1).
1255      * Does not revert if `key` is not in the map.
1256      *
1257      * _Available since v3.4._
1258      */
1259     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1260         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1261         return (success, address(uint160(uint256(value))));
1262     }
1263 
1264     /**
1265      * @dev Returns the value associated with `key`.  O(1).
1266      *
1267      * Requirements:
1268      *
1269      * - `key` must be in the map.
1270      */
1271     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1272         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1273     }
1274 
1275     /**
1276      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1277      *
1278      * CAUTION: This function is depremightygojiraed because it requires allomightygojiraing memory for the error
1279      * message unnecessarily. For custom revert reasons use {tryGet}.
1280      */
1281     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1282         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1283     }
1284 }
1285 
1286 
1287 
1288 pragma solidity >=0.6.0 <0.8.0;
1289 
1290 /**
1291  * @dev String operations.
1292  */
1293 library Strings {
1294     /**
1295      * @dev Converts a `uint256` to its ASCII `string` representation.
1296      */
1297     function toString(uint256 value) internal pure returns (string memory) {
1298         // Inspired by OraclizeAPI's implementation - MIT licence
1299         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1300 
1301         if (value == 0) {
1302             return "0";
1303         }
1304         uint256 temp = value;
1305         uint256 digits;
1306         while (temp != 0) {
1307             digits++;
1308             temp /= 10;
1309         }
1310         bytes memory buffer = new bytes(digits);
1311         uint256 index = digits - 1;
1312         temp = value;
1313         while (temp != 0) {
1314             buffer[index--] = bytes1(uint8(48 + temp % 10));
1315             temp /= 10;
1316         }
1317         return string(buffer);
1318     }
1319 }
1320 
1321 
1322 
1323 pragma solidity >=0.6.0 <0.8.0;
1324 
1325 /**
1326  * @title ERC721 Non-Fungible Token Standard basic implementation
1327  * @dev see https://eips.ethereum.org/EIPS/eip-721
1328  */
1329  
1330 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1331     using SafeMath for uint256;
1332     using Address for address;
1333     using EnumerableSet for EnumerableSet.UintSet;
1334     using EnumerableMap for EnumerableMap.UintToAddressMap;
1335     using Strings for uint256;
1336 
1337     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1338     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1339     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1340 
1341     // Mapping from holder address to their (enumerable) set of owned tokens
1342     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1343 
1344     // Enumerable mapping from token ids to their owners
1345     EnumerableMap.UintToAddressMap private _tokenOwners;
1346 
1347     // Mapping from token ID to approved address
1348     mapping (uint256 => address) private _tokenApprovals;
1349 
1350     // Mapping from owner to operator approvals
1351     mapping (address => mapping (address => bool)) private _operatorApprovals;
1352 
1353     // Token name
1354     string private _name;
1355 
1356     // Token symbol
1357     string private _symbol;
1358 
1359     // Optional mapping for token URIs
1360     mapping (uint256 => string) private _tokenURIs;
1361 
1362     // Base URI
1363     string private _baseURI;
1364 
1365     /*
1366      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1367      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1368      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1369      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1370      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1371      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1372      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1373      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1374      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1375      *
1376      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1377      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1378      */
1379     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1380 
1381     /*
1382      *     bytes4(keccak256('name()')) == 0x06fdde03
1383      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1384      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1385      *
1386      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1387      */
1388     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1389 
1390     /*
1391      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1392      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1393      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1394      *
1395      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1396      */
1397     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1398 
1399     /**
1400      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1401      */
1402     constructor (string memory name_, string memory symbol_) public {
1403         _name = name_;
1404         _symbol = symbol_;
1405 
1406         // register the supported interfaces to conform to ERC721 via ERC165
1407         _registerInterface(_INTERFACE_ID_ERC721);
1408         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1409         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-balanceOf}.
1414      */
1415     function balanceOf(address owner) public view virtual override returns (uint256) {
1416         require(owner != address(0), "ERC721: balance query for the zero address");
1417         return _holderTokens[owner].length();
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-ownerOf}.
1422      */
1423     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1424         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Metadata-name}.
1429      */
1430     function name() public view virtual override returns (string memory) {
1431         return _name;
1432     }
1433 
1434     /**
1435      * @dev See {IERC721Metadata-symbol}.
1436      */
1437     function symbol() public view virtual override returns (string memory) {
1438         return _symbol;
1439     }
1440 
1441     /**
1442      * @dev See {IERC721Metadata-tokenURI}.
1443      */
1444     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1445         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1446 
1447         string memory _tokenURI = _tokenURIs[tokenId];
1448         string memory base = baseURI();
1449 
1450         // If there is no base URI, return the token URI.
1451         if (bytes(base).length == 0) {
1452             return _tokenURI;
1453         }
1454         // If both are set, conmightygojiraenate the baseURI and tokenURI (via abi.encodePacked).
1455         if (bytes(_tokenURI).length > 0) {
1456             return string(abi.encodePacked(base, _tokenURI));
1457         }
1458         // If there is a baseURI but no tokenURI, conmightygojiraenate the tokenID to the baseURI.
1459         return string(abi.encodePacked(base, tokenId.toString()));
1460     }
1461 
1462     /**
1463     * @dev Returns the base URI set via {_setBaseURI}. This will be
1464     * automatically added as a prefix in {tokenURI} to each token's URI, or
1465     * to the token ID if no specific URI is set for that token ID.
1466     */
1467     function baseURI() public view virtual returns (string memory) {
1468         return _baseURI;
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1473      */
1474     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1475         return _holderTokens[owner].at(index);
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Enumerable-totalSupply}.
1480      */
1481     function totalSupply() public view virtual override returns (uint256) {
1482         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1483         return _tokenOwners.length();
1484     }
1485 
1486     /**
1487      * @dev See {IERC721Enumerable-tokenByIndex}.
1488      */
1489     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1490         (uint256 tokenId, ) = _tokenOwners.at(index);
1491         return tokenId;
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-approve}.
1496      */
1497     function approve(address to, uint256 tokenId) public virtual override {
1498         address owner = ERC721.ownerOf(tokenId);
1499         require(to != owner, "ERC721: approval to current owner");
1500 
1501         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1502             "ERC721: approve caller is not owner nor approved for all"
1503         );
1504 
1505         _approve(to, tokenId);
1506     }
1507 
1508     /**
1509      * @dev See {IERC721-getApproved}.
1510      */
1511     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1512         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1513 
1514         return _tokenApprovals[tokenId];
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-setApprovalForAll}.
1519      */
1520     function setApprovalForAll(address operator, bool approved) public virtual override {
1521         require(operator != _msgSender(), "ERC721: approve to caller");
1522 
1523         _operatorApprovals[_msgSender()][operator] = approved;
1524         emit ApprovalForAll(_msgSender(), operator, approved);
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-isApprovedForAll}.
1529      */
1530     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1531         return _operatorApprovals[owner][operator];
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-transferFrom}.
1536      */
1537     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1538         //solhint-disable-next-line max-line-length
1539         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1540 
1541         _transfer(from, to, tokenId);
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-safeTransferFrom}.
1546      */
1547     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1548         safeTransferFrom(from, to, tokenId, "");
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-safeTransferFrom}.
1553      */
1554     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1555         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1556         _safeTransfer(from, to, tokenId, _data);
1557     }
1558 
1559     /**
1560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1562      *
1563      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1564      *
1565      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1566      * implement alternative mechanisms to perform token transfer, such as signature-based.
1567      *
1568      * Requirements:
1569      *
1570      * - `from` cannot be the zero address.
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must exist and be owned by `from`.
1573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1578         _transfer(from, to, tokenId);
1579         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1580     }
1581 
1582     /**
1583      * @dev Returns whether `tokenId` exists.
1584      *
1585      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1586      *
1587      * Tokens start existing when they are minted (`_mint`),
1588      * and stop existing when they are burned (`_burn`).
1589      */
1590     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1591         return _tokenOwners.contains(tokenId);
1592     }
1593 
1594     /**
1595      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1596      *
1597      * Requirements:
1598      *
1599      * - `tokenId` must exist.
1600      */
1601     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1602         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1603         address owner = ERC721.ownerOf(tokenId);
1604         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1605     }
1606 
1607     /**
1608      * @dev Safely mints `tokenId` and transfers it to `to`.
1609      *
1610      * Requirements:
1611      d*
1612      * - `tokenId` must not exist.
1613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1614      *
1615      * Emits a {Transfer} event.
1616      */
1617     function _safeMint(address to, uint256 tokenId) internal virtual {
1618         _safeMint(to, tokenId, "");
1619     }
1620 
1621     /**
1622      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1623      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1624      */
1625     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1626         _mint(to, tokenId);
1627         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1628     }
1629 
1630     /**
1631      * @dev Mints `tokenId` and transfers it to `to`.
1632      *
1633      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1634      *
1635      * Requirements:
1636      *
1637      * - `tokenId` must not exist.
1638      * - `to` cannot be the zero address.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function _mint(address to, uint256 tokenId) internal virtual {
1643         require(to != address(0), "ERC721: mint to the zero address");
1644         require(!_exists(tokenId), "ERC721: token already minted");
1645 
1646         _beforeTokenTransfer(address(0), to, tokenId);
1647 
1648         _holderTokens[to].add(tokenId);
1649 
1650         _tokenOwners.set(tokenId, to);
1651 
1652         emit Transfer(address(0), to, tokenId);
1653     }
1654 
1655     /**
1656      * @dev Destroys `tokenId`.
1657      * The approval is cleared when the token is burned.
1658      *
1659      * Requirements:
1660      *
1661      * - `tokenId` must exist.
1662      *
1663      * Emits a {Transfer} event.
1664      */
1665     function _burn(uint256 tokenId) internal virtual {
1666         address owner = ERC721.ownerOf(tokenId); // internal owner
1667 
1668         _beforeTokenTransfer(owner, address(0), tokenId);
1669 
1670         // Clear approvals
1671         _approve(address(0), tokenId);
1672 
1673         // Clear metadata (if any)
1674         if (bytes(_tokenURIs[tokenId]).length != 0) {
1675             delete _tokenURIs[tokenId];
1676         }
1677 
1678         _holderTokens[owner].remove(tokenId);
1679 
1680         _tokenOwners.remove(tokenId);
1681 
1682         emit Transfer(owner, address(0), tokenId);
1683     }
1684 
1685     /**
1686      * @dev Transfers `tokenId` from `from` to `to`.
1687      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1688      *
1689      * Requirements:
1690      *
1691      * - `to` cannot be the zero address.
1692      * - `tokenId` token must be owned by `from`.
1693      *
1694      * Emits a {Transfer} event.
1695      */
1696     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1697         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1698         require(to != address(0), "ERC721: transfer to the zero address");
1699 
1700         _beforeTokenTransfer(from, to, tokenId);
1701 
1702         // Clear approvals from the previous owner
1703         _approve(address(0), tokenId);
1704 
1705         _holderTokens[from].remove(tokenId);
1706         _holderTokens[to].add(tokenId);
1707 
1708         _tokenOwners.set(tokenId, to);
1709 
1710         emit Transfer(from, to, tokenId);
1711     }
1712 
1713     /**
1714      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1715      *
1716      * Requirements:
1717      *
1718      * - `tokenId` must exist.
1719      */
1720     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1721         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1722         _tokenURIs[tokenId] = _tokenURI;
1723     }
1724 
1725     /**
1726      * @dev Internal function to set the base URI for all token IDs. It is
1727      * automatically added as a prefix to the value returned in {tokenURI},
1728      * or to the token ID if {tokenURI} is empty.
1729      */
1730     function _setBaseURI(string memory baseURI_) internal virtual {
1731         _baseURI = baseURI_;
1732     }
1733 
1734     /**
1735      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1736      * The call is not executed if the target address is not a contract.
1737      *
1738      * @param from address representing the previous owner of the given token ID
1739      * @param to target address that will receive the tokens
1740      * @param tokenId uint256 ID of the token to be transferred
1741      * @param _data bytes optional data to send along with the call
1742      * @return bool whether the call correctly returned the expected magic value
1743      */
1744     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1745         private returns (bool)
1746     {
1747         if (!to.isContract()) {
1748             return true;
1749         }
1750         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1751             IERC721Receiver(to).onERC721Received.selector,
1752             _msgSender(),
1753             from,
1754             tokenId,
1755             _data
1756         ), "ERC721: transfer to non ERC721Receiver implementer");
1757         bytes4 retval = abi.decode(returndata, (bytes4));
1758         return (retval == _ERC721_RECEIVED);
1759     }
1760 
1761     /**
1762      * @dev Approve `to` to operate on `tokenId`
1763      *
1764      * Emits an {Approval} event.
1765      */
1766     function _approve(address to, uint256 tokenId) internal virtual {
1767         _tokenApprovals[tokenId] = to;
1768         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1769     }
1770 
1771     /**
1772      * @dev Hook that is called before any token transfer. This includes minting
1773      * and burning.
1774      *
1775      * Calling conditions:
1776      *
1777      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1778      * transferred to `to`.
1779      * - When `from` is zero, `tokenId` will be minted for `to`.
1780      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1781      * - `from` cannot be the zero address.
1782      * - `to` cannot be the zero address.
1783      *
1784      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1785      */
1786     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1787 }
1788 
1789 
1790 
1791 pragma solidity >=0.6.0 <0.8.0;
1792 
1793 /**
1794  * @dev Contract module which provides a basic access control mechanism, where
1795  * there is an account (an owner) that can be granted exclusive access to
1796  * specific functions.
1797  *
1798  * By default, the owner account will be the one that deploys the contract. This
1799  * can later be changed with {transferOwnership}.
1800  *
1801  * This module is used through inheritance. It will make available the modifier
1802  * `onlyOwner`, which can be applied to your functions to restrict their use to
1803  * the owner.
1804  */
1805 abstract contract Ownable is Context {
1806     address private _owner;
1807 
1808     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1809 
1810     /**
1811      * @dev Initializes the contract setting the deployer as the initial owner.
1812      */
1813     constructor () internal {
1814         address msgSender = _msgSender();
1815         _owner = msgSender;
1816         emit OwnershipTransferred(address(0), msgSender);
1817     }
1818 
1819     /**
1820      * @dev Returns the address of the current owner.
1821      */
1822     function owner() public view virtual returns (address) {
1823         return _owner;
1824     }
1825 
1826     /**
1827      * @dev Throws if called by any account other than the owner.
1828      */
1829     modifier onlyOwner() {
1830         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1831         _;
1832     }
1833 
1834     /**
1835      * @dev Leaves the contract without owner. It will not be possible to call
1836      * `onlyOwner` functions anymore. Can only be called by the current owner.
1837      *
1838      * NOTE: Renouncing ownership will leave the contract without an owner,
1839      * thereby removing any functionality that is only available to the owner.
1840      */
1841     function renounceOwnership() public virtual onlyOwner {
1842         emit OwnershipTransferred(_owner, address(0));
1843         _owner = address(0);
1844     }
1845 
1846     /**
1847      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1848      * Can only be called by the current owner.
1849      */
1850     function transferOwnership(address newOwner) public virtual onlyOwner {
1851         require(newOwner != address(0), "Ownable: new owner is the zero address");
1852         emit OwnershipTransferred(_owner, newOwner);
1853         _owner = newOwner;
1854     }
1855 }
1856 
1857 
1858 
1859 /**
1860  * @dev Interface of the ERC20 standard as defined in the EIP.
1861  */
1862 interface IERC20 {
1863     /**
1864      * @dev Returns the amount of tokens in existence.
1865      */
1866     function totalSupply() external view returns (uint256);
1867 
1868     /**
1869      * @dev Returns the amount of tokens owned by `account`.
1870      */
1871     function balanceOf(address account) external view returns (uint256);
1872 
1873     /**
1874      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1875      *
1876      * Returns a boolean value indimightygojiraing whether the operation succeeded.
1877      *
1878      * Emits a {Transfer} event.
1879      */
1880     function transfer(address recipient, uint256 amount) external returns (bool);
1881 
1882     /**
1883      * @dev Returns the remaining number of tokens that `spender` will be
1884      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1885      * zero by default.
1886      *
1887      * This value changes when {approve} or {transferFrom} are called.
1888      */
1889     function allowance(address owner, address spender) external view returns (uint256);
1890 
1891     /**
1892      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1893      *
1894      * Returns a boolean value indimightygojiraing whether the operation succeeded.
1895      *
1896      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1897      * that someone may use both the old and the new allowance by unfortunate
1898      * transaction ordering. One possible solution to mitigate this race
1899      * condition is to first reduce the spender's allowance to 0 and set the
1900      * desired value afterwards:
1901      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1902      *
1903      * Emits an {Approval} event.
1904      */
1905     function approve(address spender, uint256 amount) external returns (bool);
1906 
1907     /**
1908      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1909      * allowance mechanism. `amount` is then deducted from the caller's
1910      * allowance.
1911      *
1912      * Returns a boolean value indimightygojiraing whether the operation succeeded.
1913      *
1914      * Emits a {Transfer} event.
1915      */
1916     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1917 
1918     /**
1919      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1920      * another (`to`).
1921      *
1922      * Note that `value` may be zero.
1923      */
1924     event Transfer(address indexed from, address indexed to, uint256 value);
1925 
1926     /**
1927      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1928      * a call to {approve}. `value` is the new allowance.
1929      */
1930     event Approval(address indexed owner, address indexed spender, uint256 value);
1931 }
1932 
1933 
1934 
1935 
1936 /**
1937  * @dev Implementation of the {IERC20} interface.
1938  *
1939  * This implementation is agnostic to the way tokens are created. This means
1940  * that a supply mechanism has to be added in a derived contract using {_mint}.
1941  * For a generic mechanism see {ERC20PresetMinterPauser}.
1942  *
1943  * TIP: For a detailed writeup see our guide
1944  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1945  * to implement supply mechanisms].
1946  *
1947  * We have followed general OpenZeppelin guidelines: functions revert instead
1948  * of returning `false` on failure. This behavior is nonetheless conventional
1949  * and does not conflict with the expectations of ERC20 applimightygojiraions.
1950  *
1951  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1952  * This allows applimightygojiraions to reconstruct the allowance for all accounts just
1953  * by listening to said events. Other implementations of the EIP may not emit
1954  * these events, as it isn't required by the specifimightygojiraion.
1955  *
1956  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1957  * functions have been added to mitigate the well-known issues around setting
1958  * allowances. See {IERC20-approve}.
1959  */
1960 contract ERC20 is Context, IERC20 {
1961     using SafeMath for uint256;
1962     using Address for address;
1963 
1964     mapping (address => uint256) private _balances;
1965 
1966     mapping (address => mapping (address => uint256)) private _allowances;
1967 
1968     uint256 private _totalSupply;
1969 
1970     string private _name;
1971     string private _symbol;
1972     uint8 private _decimals;
1973 
1974     /**
1975      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1976      * a default value of 18.
1977      *
1978      * To select a different value for {decimals}, use {_setupDecimals}.
1979      *
1980      * All three of these values are immutable: they can only be set once during
1981      * construction.
1982      */
1983     constructor (string memory name, string memory symbol) public {
1984         _name = name;
1985         _symbol = symbol;
1986         _decimals = 18;
1987     }
1988 
1989     /**
1990      * @dev Returns the name of the token.
1991      */
1992     function name() public view returns (string memory) {
1993         return _name;
1994     }
1995 
1996     /**
1997      * @dev Returns the symbol of the token, usually a shorter version of the
1998      * name.
1999      */
2000     function symbol() public view returns (string memory) {
2001         return _symbol;
2002     }
2003 
2004     /**
2005      * @dev Returns the number of decimals used to get its user representation.
2006      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2007      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2008      *
2009      * Tokens usually opt for a value of 18, imitating the relationship between
2010      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2011      * called.
2012      *
2013      * NOTE: This information is only used for _display_ purposes: it in
2014      * no way affects any of the arithmetic of the contract, including
2015      * {IERC20-balanceOf} and {IERC20-transfer}.
2016      */
2017     function decimals() public view returns (uint8) {
2018         return _decimals;
2019     }
2020 
2021     /**
2022      * @dev See {IERC20-totalSupply}.
2023      */
2024     function totalSupply() public view override returns (uint256) {
2025         return _totalSupply;
2026     }
2027 
2028     /**
2029      * @dev See {IERC20-balanceOf}.
2030      */
2031     function balanceOf(address account) public view override returns (uint256) {
2032         return _balances[account];
2033     }
2034 
2035     /**
2036      * @dev See {IERC20-transfer}.
2037      *
2038      * Requirements:
2039      *
2040      * - `recipient` cannot be the zero address.
2041      * - the caller must have a balance of at least `amount`.
2042      */
2043     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2044         _transfer(_msgSender(), recipient, amount);
2045         return true;
2046     }
2047 
2048     /**
2049      * @dev See {IERC20-allowance}.
2050      */
2051     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2052         return _allowances[owner][spender];
2053     }
2054 
2055     /**
2056      * @dev See {IERC20-approve}.
2057      *
2058      * Requirements:
2059      *
2060      * - `spender` cannot be the zero address.
2061      */
2062     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2063         _approve(_msgSender(), spender, amount);
2064         return true;
2065     }
2066 
2067     /**
2068      * @dev See {IERC20-transferFrom}.
2069      *
2070      * Emits an {Approval} event indimightygojiraing the updated allowance. This is not
2071      * required by the EIP. See the note at the beginning of {ERC20};
2072      *
2073      * Requirements:
2074      * - `sender` and `recipient` cannot be the zero address.
2075      * - `sender` must have a balance of at least `amount`.
2076      * - the caller must have allowance for ``sender``'s tokens of at least
2077      * `amount`.
2078      */
2079     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2080         _transfer(sender, recipient, amount);
2081         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
2082         return true;
2083     }
2084 
2085     /**
2086      * @dev Atomically increases the allowance granted to `spender` by the caller.
2087      *
2088      * This is an alternative to {approve} that can be used as a mitigation for
2089      * problems described in {IERC20-approve}.
2090      *
2091      * Emits an {Approval} event indimightygojiraing the updated allowance.
2092      *
2093      * Requirements:
2094      *
2095      * - `spender` cannot be the zero address.
2096      */
2097     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2098         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2099         return true;
2100     }
2101 
2102     /**
2103      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2104      *
2105      * This is an alternative to {approve} that can be used as a mitigation for
2106      * problems described in {IERC20-approve}.
2107      *
2108      * Emits an {Approval} event indimightygojiraing the updated allowance.
2109      *
2110      * Requirements:
2111      *
2112      * - `spender` cannot be the zero address.
2113      * - `spender` must have allowance for the caller of at least
2114      * `subtractedValue`.
2115      */
2116     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2117         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2118         return true;
2119     }
2120 
2121     /**
2122      * @dev Moves tokens `amount` from `sender` to `recipient`.
2123      *
2124      * This is internal function is equivalent to {transfer}, and can be used to
2125      * e.g. implement automatic token fees, slashing mechanisms, etc.
2126      *
2127      * Emits a {Transfer} event.
2128      *
2129      * Requirements:
2130      *
2131      * - `sender` cannot be the zero address.
2132      * - `recipient` cannot be the zero address.
2133      * - `sender` must have a balance of at least `amount`.
2134      */
2135     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2136         require(sender != address(0), "ERC20: transfer from the zero address");
2137         require(recipient != address(0), "ERC20: transfer to the zero address");
2138 
2139         _beforeTokenTransfer(sender, recipient, amount);
2140 
2141         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2142         _balances[recipient] = _balances[recipient].add(amount);
2143         emit Transfer(sender, recipient, amount);
2144     }
2145 
2146     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2147      * the total supply.
2148      *
2149      * Emits a {Transfer} event with `from` set to the zero address.
2150      *
2151      * Requirements
2152      *
2153      * - `to` cannot be the zero address.
2154      */
2155     function _mint(address account, uint256 amount) internal virtual {
2156         require(account != address(0), "ERC20: mint to the zero address");
2157 
2158         _beforeTokenTransfer(address(0), account, amount);
2159 
2160         _totalSupply = _totalSupply.add(amount);
2161         _balances[account] = _balances[account].add(amount);
2162         emit Transfer(address(0), account, amount);
2163     }
2164 
2165     /**
2166      * @dev Destroys `amount` tokens from `account`, reducing the
2167      * total supply.
2168      *
2169      * Emits a {Transfer} event with `to` set to the zero address.
2170      *
2171      * Requirements
2172      *
2173      * - `account` cannot be the zero address.
2174      * - `account` must have at least `amount` tokens.
2175      */
2176     function _burn(address account, uint256 amount) internal virtual {
2177         require(account != address(0), "ERC20: burn from the zero address");
2178 
2179         _beforeTokenTransfer(account, address(0), amount);
2180 
2181         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2182         _totalSupply = _totalSupply.sub(amount);
2183         emit Transfer(account, address(0), amount);
2184     }
2185 
2186     /**
2187      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2188      *
2189      * This internal function is equivalent to `approve`, and can be used to
2190      * e.g. set automatic allowances for certain subsystems, etc.
2191      *
2192      * Emits an {Approval} event.
2193      *
2194      * Requirements:
2195      *
2196      * - `owner` cannot be the zero address.
2197      * - `spender` cannot be the zero address.
2198      */
2199     function _approve(address owner, address spender, uint256 amount) internal virtual {
2200         require(owner != address(0), "ERC20: approve from the zero address");
2201         require(spender != address(0), "ERC20: approve to the zero address");
2202 
2203         _allowances[owner][spender] = amount;
2204         emit Approval(owner, spender, amount);
2205     }
2206 
2207     /**
2208      * @dev Sets {decimals} to a value other than the default one of 18.
2209      *
2210      * WARNING: This function should only be called from the constructor. Most
2211      * applimightygojiraions that interact with token contracts will not expect
2212      * {decimals} to ever change, and may work incorrectly if it does.
2213      */
2214     function _setupDecimals(uint8 decimals_) internal {
2215         _decimals = decimals_;
2216     }
2217 
2218     /**
2219      * @dev Hook that is called before any transfer of tokens. This includes
2220      * minting and burning.
2221      *
2222      * Calling conditions:
2223      *
2224      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2225      * will be to transferred to `to`.
2226      * - when `from` is zero, `amount` tokens will be minted for `to`.
2227      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2228      * - `from` and `to` are never both zero.
2229      *
2230      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2231      */
2232     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2233 }
2234 
2235 
2236 
2237 pragma solidity ^0.7.0;
2238 pragma abicoder v2;
2239 
2240 /**
2241  * @dev Token GOJ 
2242 */
2243 
2244 interface IGOJ {
2245     function burn(address _from, uint256 _amount) external;
2246     function updateReward(address _from, address _to) external;
2247 } 
2248 
2249 /**
2250  * @dev mightygojiras
2251 */
2252 
2253 contract mightygojirascontract is ERC721, Ownable {
2254     using SafeMath for uint256;
2255     string public mightygojira_PROVENANCE = "";
2256     address public  CityContractAddress;
2257     uint256 public  mightygojiraPrice =   50000000000000000; // 0.05ETH
2258     uint256 public  mightygojiraWLPrice = 40000000000000000; // 0.04ETH    
2259     uint public constant MAX_WL_PURCHASE = 3;
2260     uint public constant MAX_mightygojira_PURCHASE = 10;    
2261     uint256 public  MAX_mightygojiras = 9000;
2262     uint256 public maxGenesisCount = 3000;
2263     uint256 constant public BREED_PRICE = 500 ether;
2264     uint256 public NAME_CHANGE_PRICE = 100 ether;
2265     uint256 public bebeCount;
2266 
2267     bool public WhiteListIsActive = false;
2268     bool public composeIsActive = false;
2269     bool public MintSaleIsActive = false;
2270 
2271     IGOJ public GOJ;      //GOJ token
2272     mapping(uint => uint256) public mightyCityTypeid;
2273     mapping (address => bool) whitelist;
2274     mapping(address => uint256) public minted;
2275     mapping(uint256 => uint256) public babymightygojira;
2276     mapping (address => uint256) public balanceGenesis;
2277       
2278     // Reserve 100 mightygojira for giveaway,prize
2279     uint public mightygojiraReserve = 100;
2280     event mightyCityTypeidChange(address _by, uint _tokenId,  uint256 CityTypeId);
2281 	event Newmightygojiraborn (uint256 tokenId, uint256 parent1, uint256 parent2);
2282 	event mightygojiraRevealed(uint256 tokenId);
2283     event NameChanged(uint256 tokenId, string Name);
2284 	
2285     constructor() ERC721("Mighty Gojiras", "MightyGojiras") { }
2286   
2287     modifier mightygojiraOwner(uint256 mightygojiraId) {
2288         require(ownerOf(mightygojiraId) == msg.sender, "You do not have this mightygojira");
2289         _;
2290     }
2291     
2292     function withdraw() public onlyOwner {
2293         uint balance = address(this).balance;
2294         msg.sender.transfer(balance);
2295     }
2296     
2297     function Reserve(address _to, uint256 _reserveAmount) public onlyOwner {        
2298         uint supply = totalSupply();
2299         require(_reserveAmount > 0 && supply.add(_reserveAmount) <= maxGenesisCount, "Not enough reserve left");
2300         for (uint i = 0; i < _reserveAmount; i++) {
2301             _safeMint(_to, supply + i);
2302             balanceGenesis[_to]++;
2303         }
2304         mightygojiraReserve = mightygojiraReserve.sub(_reserveAmount);
2305     }
2306     
2307     function setMintPrice(uint price) external onlyOwner {
2308         mightygojiraPrice = price;
2309     }
2310     
2311     function setWLMintPrice(uint price) external onlyOwner {
2312         mightygojiraWLPrice = price;
2313     }
2314     
2315     function setMaxmightygojiras(uint maxmightygojira) external onlyOwner {
2316         MAX_mightygojiras = maxmightygojira;
2317     }
2318 
2319     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2320         mightygojira_PROVENANCE = provenanceHash;
2321     }
2322 
2323     function setBaseURI(string memory baseURI) public onlyOwner {
2324         _setBaseURI(baseURI);
2325     }
2326 
2327     function flipWLSaleState() public onlyOwner {
2328         WhiteListIsActive = !WhiteListIsActive;
2329     }    
2330 
2331 	function changeGOJNamePrice(uint256 _price) external onlyOwner {
2332 		NAME_CHANGE_PRICE = _price;
2333 	}
2334 	
2335     function flipMintSaleState() public onlyOwner {
2336         MintSaleIsActive = !MintSaleIsActive;
2337     }
2338 
2339     function flipCityComposeState() public onlyOwner {
2340         composeIsActive = !composeIsActive;
2341     }    
2342     
2343 	function breed(uint256 parent1, uint256 parent2) external {
2344 		require(ownerOf(parent1) == msg.sender && ownerOf(parent2) == msg.sender);
2345         require(totalSupply() < MAX_mightygojiras,                "Cannot breed any more baby mightygojira");
2346         require(parent1 < maxGenesisCount && parent2 < maxGenesisCount,   "Cannot breed with baby mightygojira");
2347         require(parent1 != parent2,                               "Must select two unique parents");
2348 
2349 		GOJ.burn(msg.sender, BREED_PRICE);
2350 		uint256 id = maxGenesisCount + bebeCount;
2351 		babymightygojira[id] = 1;
2352 		bebeCount++;
2353 		_safeMint(msg.sender, id);
2354 		emit Newmightygojiraborn(id, parent1, parent2);
2355 	}
2356 
2357     function reveal(uint256 tokenID) external mightygojiraOwner(tokenID) {
2358         babymightygojira[tokenID] = 2;
2359         emit mightygojiraRevealed(tokenID);
2360     }
2361 
2362 
2363 	function setGOJTokenContract(address GOJAddress) external onlyOwner {
2364         GOJ = IGOJ(GOJAddress);
2365     }
2366 	    
2367     function mintmightygojiras(uint numberOfTokens) public payable {
2368         require(MintSaleIsActive, "Sale must be active to mint mightygojira");
2369         require(numberOfTokens > 0 && numberOfTokens <= MAX_mightygojira_PURCHASE, "Can only mint 10 mightygojira at a time");
2370         require(totalSupply().add(numberOfTokens) <= maxGenesisCount, "Purchase would exceed max supply of mightygojiras");
2371         require(msg.value >= mightygojiraPrice.mul(numberOfTokens), "Ether value sent is not correct");
2372 
2373         for (uint i = 0; i < numberOfTokens; i++) {
2374             if (totalSupply() < maxGenesisCount) {
2375             _safeMint(msg.sender, totalSupply());
2376             balanceGenesis[msg.sender]++;
2377             }
2378         }
2379    }
2380   
2381     function presalemightygojiras(uint numberOfTokens) public payable {
2382         require(WhiteListIsActive, "Pre Sale must be active to mint mightygojira");
2383         require(numberOfTokens > 0 && numberOfTokens <= MAX_WL_PURCHASE, "Can only mint 3 mightygojira at a time");
2384         require(totalSupply().add(numberOfTokens) <= maxGenesisCount, "Purchase would exceed max supply of mightygojiras");
2385         require(msg.value >= mightygojiraWLPrice.mul(numberOfTokens), "Ether value sent is not correct");
2386         require(minted[msg.sender].add(numberOfTokens) <= MAX_WL_PURCHASE, "Max 3 mightygojira per wallet");
2387         require(whitelist[msg.sender], "You are not in whitelist");
2388  
2389         for (uint i = 0; i < numberOfTokens; i++) {
2390             if (totalSupply() < maxGenesisCount) {
2391             _safeMint(msg.sender, totalSupply());
2392              balanceGenesis[msg.sender]++;
2393              minted[msg.sender]++;
2394             }
2395         }
2396    }
2397      
2398    function composeCityWithGojira(address owner, uint256 CitytokenId, uint256 mightygojiratokenId, uint256 CityTypeId) public returns (bool) {
2399         require(msg.sender == address(CityContractAddress));
2400         require(composeIsActive, "Compose is not active at the moment");
2401         require(ERC721.ownerOf(mightygojiratokenId) == owner, "You do not have this mightygojira");
2402         ICity city = ICity(CityContractAddress);
2403         require(city.ownerOf(CitytokenId) == owner, "You do not have this city");
2404 
2405         mightyCityTypeid[mightygojiratokenId] = CityTypeId;
2406         emit mightyCityTypeidChange(msg.sender,  mightygojiratokenId, CityTypeId);
2407         return true;
2408     }
2409 
2410     function isEligiblePrivateSale(address _wallet) public view virtual returns (bool){
2411         return whitelist[_wallet];
2412     }
2413 
2414     function addWalletsToWhiteList(address[] memory _wallets) public onlyOwner{
2415         for(uint i = 0; i < _wallets.length; i++) {
2416             whitelist[_wallets[i]] = true;
2417         }
2418     }
2419     
2420    function setCityContractAddress(address contractAddress) public onlyOwner {
2421         CityContractAddress = contractAddress;
2422    }    
2423 
2424   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2425         uint256 tokenCount = balanceOf(_owner);
2426         if (tokenCount == 0) {
2427             // Return an empty array
2428             return new uint256[](0);
2429         } else {
2430             uint256[] memory result = new uint256[](tokenCount);
2431             uint256 index;
2432             for (index = 0; index < tokenCount; index++) {
2433                 result[index] = tokenOfOwnerByIndex(_owner, index);
2434             }
2435             return result;
2436         }
2437     }
2438 
2439   function transferFrom(address from, address to, uint256 tokenId) public override {
2440         if (tokenId < maxGenesisCount) {
2441             GOJ.updateReward(from, to);
2442             balanceGenesis[from]--;
2443             balanceGenesis[to]++;
2444         }
2445         ERC721.transferFrom(from, to, tokenId);
2446     }
2447 
2448   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
2449         if (tokenId < maxGenesisCount) {
2450             GOJ.updateReward(from, to);
2451             balanceGenesis[from]--;
2452             balanceGenesis[to]++;
2453         }
2454         ERC721.safeTransferFrom(from, to, tokenId, data);
2455     }
2456     
2457 }
2458 
2459 
2460 
2461 /**
2462  * @dev City for GOJ
2463 */
2464 
2465 abstract contract ICity {
2466   function ownerOf(uint256 tokenId) public virtual view returns (address);
2467   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
2468   function balanceOf(address owner) external virtual view returns (uint256 balance);
2469 }