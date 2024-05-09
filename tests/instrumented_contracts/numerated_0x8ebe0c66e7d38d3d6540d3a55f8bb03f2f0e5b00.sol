1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-20
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-14
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-06-13
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2021-06-12
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2021-04-22
19 */
20 
21 // File: @openzeppelin/contracts/utils/Context.sol
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity >=0.6.0 <0.8.0;
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/introspection/IERC165.sol
49 
50 
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /**
55  * @dev Interface of the ERC165 standard, as defined in the
56  * https://eips.ethereum.org/EIPS/eip-165[EIP].
57  *
58  * Implementers can declare support of contract interfaces, which can then be
59  * queried by others ({ERC165Checker}).
60  *
61  * For an implementation, see {ERC165}.
62  */
63 interface IERC165 {
64     /**
65      * @dev Returns true if this contract implements the interface defined by
66      * `interfaceId`. See the corresponding
67      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
68      * to learn more about how these ids are created.
69      *
70      * This function call must use less than 30 000 gas.
71      */
72     function supportsInterface(bytes4 interfaceId) external view returns (bool);
73 }
74 
75 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
76 
77 
78 
79 pragma solidity >=0.6.2 <0.8.0;
80 
81 
82 /**
83  * @dev Required interface of an ERC721 compliant contract.
84  */
85 interface IERC721 is IERC165 {
86     /**
87      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
93      */
94     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
95 
96     /**
97      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
98      */
99     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
100 
101     /**
102      * @dev Returns the number of tokens in ``owner``'s account.
103      */
104     function balanceOf(address owner) external view returns (uint256 balance);
105 
106     /**
107      * @dev Returns the owner of the `tokenId` token.
108      *
109      * Requirements:
110      *
111      * - `tokenId` must exist.
112      */
113     function ownerOf(uint256 tokenId) external view returns (address owner);
114 
115     /**
116      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
117      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must exist and be owned by `from`.
124      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
126      *
127      * Emits a {Transfer} event.
128      */
129     function safeTransferFrom(address from, address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Transfers `tokenId` token from `from` to `to`.
133      *
134      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(address from, address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
149      * The approval is cleared when the token is transferred.
150      *
151      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
152      *
153      * Requirements:
154      *
155      * - The caller must own the token or be an approved operator.
156      * - `tokenId` must exist.
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address to, uint256 tokenId) external;
161 
162     /**
163      * @dev Returns the account approved for `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function getApproved(uint256 tokenId) external view returns (address operator);
170 
171     /**
172      * @dev Approve or remove `operator` as an operator for the caller.
173      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
174      *
175      * Requirements:
176      *
177      * - The `operator` cannot be the caller.
178      *
179      * Emits an {ApprovalForAll} event.
180      */
181     function setApprovalForAll(address operator, bool _approved) external;
182 
183     /**
184      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
185      *
186      * See {setApprovalForAll}
187      */
188     function isApprovedForAll(address owner, address operator) external view returns (bool);
189 
190     /**
191       * @dev Safely transfers `tokenId` token from `from` to `to`.
192       *
193       * Requirements:
194       *
195       * - `from` cannot be the zero address.
196       * - `to` cannot be the zero address.
197       * - `tokenId` token must exist and be owned by `from`.
198       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200       *
201       * Emits a {Transfer} event.
202       */
203     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
204 }
205 
206 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
207 
208 
209 
210 pragma solidity >=0.6.2 <0.8.0;
211 
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Metadata is IERC721 {
218 
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
236 
237 
238 
239 pragma solidity >=0.6.2 <0.8.0;
240 
241 
242 /**
243  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
244  * @dev See https://eips.ethereum.org/EIPS/eip-721
245  */
246 interface IERC721Enumerable is IERC721 {
247 
248     /**
249      * @dev Returns the total amount of tokens stored by the contract.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256      */
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
258 
259     /**
260      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
261      * Use along with {totalSupply} to enumerate all tokens.
262      */
263     function tokenByIndex(uint256 index) external view returns (uint256);
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
267 
268 
269 
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
286      */
287     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
288 }
289 
290 // File: @openzeppelin/contracts/introspection/ERC165.sol
291 
292 
293 
294 pragma solidity >=0.6.0 <0.8.0;
295 
296 
297 /**
298  * @dev Implementation of the {IERC165} interface.
299  *
300  * Contracts may inherit from this and call {_registerInterface} to declare
301  * their support of an interface.
302  */
303 abstract contract ERC165 is IERC165 {
304     /*
305      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
306      */
307     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
308 
309     /**
310      * @dev Mapping of interface ids to whether or not it's supported.
311      */
312     mapping(bytes4 => bool) private _supportedInterfaces;
313 
314     constructor () internal {
315         // Derived contracts need only register support for their own interfaces,
316         // we register support for ERC165 itself here
317         _registerInterface(_INTERFACE_ID_ERC165);
318     }
319 
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      *
323      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
324      */
325     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326         return _supportedInterfaces[interfaceId];
327     }
328 
329     /**
330      * @dev Registers the contract as an implementer of the interface defined by
331      * `interfaceId`. Support of the actual ERC165 interface is automatic and
332      * registering its interface id is not required.
333      *
334      * See {IERC165-supportsInterface}.
335      *
336      * Requirements:
337      *
338      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
339      */
340     function _registerInterface(bytes4 interfaceId) internal virtual {
341         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
342         _supportedInterfaces[interfaceId] = true;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/math/SafeMath.sol
347 
348 
349 
350 pragma solidity >=0.6.0 <0.8.0;
351 
352 /**
353  * @dev Wrappers over Solidity's arithmetic operations with added overflow
354  * checks.
355  *
356  * Arithmetic operations in Solidity wrap on overflow. This can easily result
357  * in bugs, because programmers usually assume that an overflow raises an
358  * error, which is the standard behavior in high level programming languages.
359  * `SafeMath` restores this intuition by reverting the transaction when an
360  * operation overflows.
361  *
362  * Using this library instead of the unchecked operations eliminates an entire
363  * class of bugs, so it's recommended to use it always.
364  */
365 library SafeMath {
366     /**
367      * @dev Returns the addition of two unsigned integers, with an overflow flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         uint256 c = a + b;
373         if (c < a) return (false, 0);
374         return (true, c);
375     }
376 
377     /**
378      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
379      *
380      * _Available since v3.4._
381      */
382     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         if (b > a) return (false, 0);
384         return (true, a - b);
385     }
386 
387     /**
388      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
393         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
394         // benefit is lost if 'b' is also tested.
395         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
396         if (a == 0) return (true, 0);
397         uint256 c = a * b;
398         if (c / a != b) return (false, 0);
399         return (true, c);
400     }
401 
402     /**
403      * @dev Returns the division of two unsigned integers, with a division by zero flag.
404      *
405      * _Available since v3.4._
406      */
407     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         if (b == 0) return (false, 0);
409         return (true, a / b);
410     }
411 
412     /**
413      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
414      *
415      * _Available since v3.4._
416      */
417     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
418         if (b == 0) return (false, 0);
419         return (true, a % b);
420     }
421 
422     /**
423      * @dev Returns the addition of two unsigned integers, reverting on
424      * overflow.
425      *
426      * Counterpart to Solidity's `+` operator.
427      *
428      * Requirements:
429      *
430      * - Addition cannot overflow.
431      */
432     function add(uint256 a, uint256 b) internal pure returns (uint256) {
433         uint256 c = a + b;
434         require(c >= a, "SafeMath: addition overflow");
435         return c;
436     }
437 
438     /**
439      * @dev Returns the subtraction of two unsigned integers, reverting on
440      * overflow (when the result is negative).
441      *
442      * Counterpart to Solidity's `-` operator.
443      *
444      * Requirements:
445      *
446      * - Subtraction cannot overflow.
447      */
448     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
449         require(b <= a, "SafeMath: subtraction overflow");
450         return a - b;
451     }
452 
453     /**
454      * @dev Returns the multiplication of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `*` operator.
458      *
459      * Requirements:
460      *
461      * - Multiplication cannot overflow.
462      */
463     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
464         if (a == 0) return 0;
465         uint256 c = a * b;
466         require(c / a == b, "SafeMath: multiplication overflow");
467         return c;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting on
472      * division by zero. The result is rounded towards zero.
473      *
474      * Counterpart to Solidity's `/` operator. Note: this function uses a
475      * `revert` opcode (which leaves remaining gas untouched) while Solidity
476      * uses an invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      *
480      * - The divisor cannot be zero.
481      */
482     function div(uint256 a, uint256 b) internal pure returns (uint256) {
483         require(b > 0, "SafeMath: division by zero");
484         return a / b;
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
489      * reverting when dividing by zero.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
500         require(b > 0, "SafeMath: modulo by zero");
501         return a % b;
502     }
503 
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
506      * overflow (when the result is negative).
507      *
508      * CAUTION: This function is deprecated because it requires allocating memory for the error
509      * message unnecessarily. For custom revert reasons use {trySub}.
510      *
511      * Counterpart to Solidity's `-` operator.
512      *
513      * Requirements:
514      *
515      * - Subtraction cannot overflow.
516      */
517     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b <= a, errorMessage);
519         return a - b;
520     }
521 
522     /**
523      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
524      * division by zero. The result is rounded towards zero.
525      *
526      * CAUTION: This function is deprecated because it requires allocating memory for the error
527      * message unnecessarily. For custom revert reasons use {tryDiv}.
528      *
529      * Counterpart to Solidity's `/` operator. Note: this function uses a
530      * `revert` opcode (which leaves remaining gas untouched) while Solidity
531      * uses an invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b > 0, errorMessage);
539         return a / b;
540     }
541 
542     /**
543      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
544      * reverting with custom message when dividing by zero.
545      *
546      * CAUTION: This function is deprecated because it requires allocating memory for the error
547      * message unnecessarily. For custom revert reasons use {tryMod}.
548      *
549      * Counterpart to Solidity's `%` operator. This function uses a `revert`
550      * opcode (which leaves remaining gas untouched) while Solidity uses an
551      * invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         return a % b;
560     }
561 }
562 
563 // File: @openzeppelin/contracts/utils/Address.sol
564 
565 
566 
567 pragma solidity >=0.6.2 <0.8.0;
568 
569 /**
570  * @dev Collection of functions related to the address type
571  */
572 library Address {
573     /**
574      * @dev Returns true if `account` is a contract.
575      *
576      * [IMPORTANT]
577      * ====
578      * It is unsafe to assume that an address for which this function returns
579      * false is an externally-owned account (EOA) and not a contract.
580      *
581      * Among others, `isContract` will return false for the following
582      * types of addresses:
583      *
584      *  - an externally-owned account
585      *  - a contract in construction
586      *  - an address where a contract will be created
587      *  - an address where a contract lived, but was destroyed
588      * ====
589      */
590     function isContract(address account) internal view returns (bool) {
591         // This method relies on extcodesize, which returns 0 for contracts in
592         // construction, since the code is only stored at the end of the
593         // constructor execution.
594 
595         uint256 size;
596         // solhint-disable-next-line no-inline-assembly
597         assembly { size := extcodesize(account) }
598         return size > 0;
599     }
600 
601     /**
602      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
603      * `recipient`, forwarding all available gas and reverting on errors.
604      *
605      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
606      * of certain opcodes, possibly making contracts go over the 2300 gas limit
607      * imposed by `transfer`, making them unable to receive funds via
608      * `transfer`. {sendValue} removes this limitation.
609      *
610      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
611      *
612      * IMPORTANT: because control is transferred to `recipient`, care must be
613      * taken to not create reentrancy vulnerabilities. Consider using
614      * {ReentrancyGuard} or the
615      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
616      */
617     function sendValue(address payable recipient, uint256 amount) internal {
618         require(address(this).balance >= amount, "Address: insufficient balance");
619 
620         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
621         (bool success, ) = recipient.call{ value: amount }("");
622         require(success, "Address: unable to send value, recipient may have reverted");
623     }
624 
625     /**
626      * @dev Performs a Solidity function call using a low level `call`. A
627      * plain`call` is an unsafe replacement for a function call: use this
628      * function instead.
629      *
630      * If `target` reverts with a revert reason, it is bubbled up by this
631      * function (like regular Solidity function calls).
632      *
633      * Returns the raw returned data. To convert to the expected return value,
634      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
635      *
636      * Requirements:
637      *
638      * - `target` must be a contract.
639      * - calling `target` with `data` must not revert.
640      *
641      * _Available since v3.1._
642      */
643     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
644       return functionCall(target, data, "Address: low-level call failed");
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
649      * `errorMessage` as a fallback revert reason when `target` reverts.
650      *
651      * _Available since v3.1._
652      */
653     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
654         return functionCallWithValue(target, data, 0, errorMessage);
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
659      * but also transferring `value` wei to `target`.
660      *
661      * Requirements:
662      *
663      * - the calling contract must have an ETH balance of at least `value`.
664      * - the called Solidity function must be `payable`.
665      *
666      * _Available since v3.1._
667      */
668     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
674      * with `errorMessage` as a fallback revert reason when `target` reverts.
675      *
676      * _Available since v3.1._
677      */
678     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
679         require(address(this).balance >= value, "Address: insufficient balance for call");
680         require(isContract(target), "Address: call to non-contract");
681 
682         // solhint-disable-next-line avoid-low-level-calls
683         (bool success, bytes memory returndata) = target.call{ value: value }(data);
684         return _verifyCallResult(success, returndata, errorMessage);
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
689      * but performing a static call.
690      *
691      * _Available since v3.3._
692      */
693     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
694         return functionStaticCall(target, data, "Address: low-level static call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
699      * but performing a static call.
700      *
701      * _Available since v3.3._
702      */
703     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
704         require(isContract(target), "Address: static call to non-contract");
705 
706         // solhint-disable-next-line avoid-low-level-calls
707         (bool success, bytes memory returndata) = target.staticcall(data);
708         return _verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but performing a delegate call.
714      *
715      * _Available since v3.4._
716      */
717     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
718         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
723      * but performing a delegate call.
724      *
725      * _Available since v3.4._
726      */
727     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
728         require(isContract(target), "Address: delegate call to non-contract");
729 
730         // solhint-disable-next-line avoid-low-level-calls
731         (bool success, bytes memory returndata) = target.delegatecall(data);
732         return _verifyCallResult(success, returndata, errorMessage);
733     }
734 
735     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
736         if (success) {
737             return returndata;
738         } else {
739             // Look for revert reason and bubble it up if present
740             if (returndata.length > 0) {
741                 // The easiest way to bubble the revert reason is using memory via assembly
742 
743                 // solhint-disable-next-line no-inline-assembly
744                 assembly {
745                     let returndata_size := mload(returndata)
746                     revert(add(32, returndata), returndata_size)
747                 }
748             } else {
749                 revert(errorMessage);
750             }
751         }
752     }
753 }
754 
755 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
756 
757 
758 
759 pragma solidity >=0.6.0 <0.8.0;
760 
761 /**
762  * @dev Library for managing
763  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
764  * types.
765  *
766  * Sets have the following properties:
767  *
768  * - Elements are added, removed, and checked for existence in constant time
769  * (O(1)).
770  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
771  *
772  * ```
773  * contract Example {
774  *     // Add the library methods
775  *     using EnumerableSet for EnumerableSet.AddressSet;
776  *
777  *     // Declare a set state variable
778  *     EnumerableSet.AddressSet private mySet;
779  * }
780  * ```
781  *
782  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
783  * and `uint256` (`UintSet`) are supported.
784  */
785 library EnumerableSet {
786     // To implement this library for multiple types with as little code
787     // repetition as possible, we write it in terms of a generic Set type with
788     // bytes32 values.
789     // The Set implementation uses private functions, and user-facing
790     // implementations (such as AddressSet) are just wrappers around the
791     // underlying Set.
792     // This means that we can only create new EnumerableSets for types that fit
793     // in bytes32.
794 
795     struct Set {
796         // Storage of set values
797         bytes32[] _values;
798 
799         // Position of the value in the `values` array, plus 1 because index 0
800         // means a value is not in the set.
801         mapping (bytes32 => uint256) _indexes;
802     }
803 
804     /**
805      * @dev Add a value to a set. O(1).
806      *
807      * Returns true if the value was added to the set, that is if it was not
808      * already present.
809      */
810     function _add(Set storage set, bytes32 value) private returns (bool) {
811         if (!_contains(set, value)) {
812             set._values.push(value);
813             // The value is stored at length-1, but we add 1 to all indexes
814             // and use 0 as a sentinel value
815             set._indexes[value] = set._values.length;
816             return true;
817         } else {
818             return false;
819         }
820     }
821 
822     /**
823      * @dev Removes a value from a set. O(1).
824      *
825      * Returns true if the value was removed from the set, that is if it was
826      * present.
827      */
828     function _remove(Set storage set, bytes32 value) private returns (bool) {
829         // We read and store the value's index to prevent multiple reads from the same storage slot
830         uint256 valueIndex = set._indexes[value];
831 
832         if (valueIndex != 0) { // Equivalent to contains(set, value)
833             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
834             // the array, and then remove the last element (sometimes called as 'swap and pop').
835             // This modifies the order of the array, as noted in {at}.
836 
837             uint256 toDeleteIndex = valueIndex - 1;
838             uint256 lastIndex = set._values.length - 1;
839 
840             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
841             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
842 
843             bytes32 lastvalue = set._values[lastIndex];
844 
845             // Move the last value to the index where the value to delete is
846             set._values[toDeleteIndex] = lastvalue;
847             // Update the index for the moved value
848             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
849 
850             // Delete the slot where the moved value was stored
851             set._values.pop();
852 
853             // Delete the index for the deleted slot
854             delete set._indexes[value];
855 
856             return true;
857         } else {
858             return false;
859         }
860     }
861 
862     /**
863      * @dev Returns true if the value is in the set. O(1).
864      */
865     function _contains(Set storage set, bytes32 value) private view returns (bool) {
866         return set._indexes[value] != 0;
867     }
868 
869     /**
870      * @dev Returns the number of values on the set. O(1).
871      */
872     function _length(Set storage set) private view returns (uint256) {
873         return set._values.length;
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
886     function _at(Set storage set, uint256 index) private view returns (bytes32) {
887         require(set._values.length > index, "EnumerableSet: index out of bounds");
888         return set._values[index];
889     }
890 
891     // Bytes32Set
892 
893     struct Bytes32Set {
894         Set _inner;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
904         return _add(set._inner, value);
905     }
906 
907     /**
908      * @dev Removes a value from a set. O(1).
909      *
910      * Returns true if the value was removed from the set, that is if it was
911      * present.
912      */
913     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
914         return _remove(set._inner, value);
915     }
916 
917     /**
918      * @dev Returns true if the value is in the set. O(1).
919      */
920     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
921         return _contains(set._inner, value);
922     }
923 
924     /**
925      * @dev Returns the number of values in the set. O(1).
926      */
927     function length(Bytes32Set storage set) internal view returns (uint256) {
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
941     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
942         return _at(set._inner, index);
943     }
944 
945     // AddressSet
946 
947     struct AddressSet {
948         Set _inner;
949     }
950 
951     /**
952      * @dev Add a value to a set. O(1).
953      *
954      * Returns true if the value was added to the set, that is if it was not
955      * already present.
956      */
957     function add(AddressSet storage set, address value) internal returns (bool) {
958         return _add(set._inner, bytes32(uint256(uint160(value))));
959     }
960 
961     /**
962      * @dev Removes a value from a set. O(1).
963      *
964      * Returns true if the value was removed from the set, that is if it was
965      * present.
966      */
967     function remove(AddressSet storage set, address value) internal returns (bool) {
968         return _remove(set._inner, bytes32(uint256(uint160(value))));
969     }
970 
971     /**
972      * @dev Returns true if the value is in the set. O(1).
973      */
974     function contains(AddressSet storage set, address value) internal view returns (bool) {
975         return _contains(set._inner, bytes32(uint256(uint160(value))));
976     }
977 
978     /**
979      * @dev Returns the number of values in the set. O(1).
980      */
981     function length(AddressSet storage set) internal view returns (uint256) {
982         return _length(set._inner);
983     }
984 
985    /**
986     * @dev Returns the value stored at position `index` in the set. O(1).
987     *
988     * Note that there are no guarantees on the ordering of values inside the
989     * array, and it may change when more values are added or removed.
990     *
991     * Requirements:
992     *
993     * - `index` must be strictly less than {length}.
994     */
995     function at(AddressSet storage set, uint256 index) internal view returns (address) {
996         return address(uint160(uint256(_at(set._inner, index))));
997     }
998 
999 
1000     // UintSet
1001 
1002     struct UintSet {
1003         Set _inner;
1004     }
1005 
1006     /**
1007      * @dev Add a value to a set. O(1).
1008      *
1009      * Returns true if the value was added to the set, that is if it was not
1010      * already present.
1011      */
1012     function add(UintSet storage set, uint256 value) internal returns (bool) {
1013         return _add(set._inner, bytes32(value));
1014     }
1015 
1016     /**
1017      * @dev Removes a value from a set. O(1).
1018      *
1019      * Returns true if the value was removed from the set, that is if it was
1020      * present.
1021      */
1022     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1023         return _remove(set._inner, bytes32(value));
1024     }
1025 
1026     /**
1027      * @dev Returns true if the value is in the set. O(1).
1028      */
1029     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1030         return _contains(set._inner, bytes32(value));
1031     }
1032 
1033     /**
1034      * @dev Returns the number of values on the set. O(1).
1035      */
1036     function length(UintSet storage set) internal view returns (uint256) {
1037         return _length(set._inner);
1038     }
1039 
1040    /**
1041     * @dev Returns the value stored at position `index` in the set. O(1).
1042     *
1043     * Note that there are no guarantees on the ordering of values inside the
1044     * array, and it may change when more values are added or removed.
1045     *
1046     * Requirements:
1047     *
1048     * - `index` must be strictly less than {length}.
1049     */
1050     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1051         return uint256(_at(set._inner, index));
1052     }
1053 }
1054 
1055 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1056 
1057 
1058 
1059 pragma solidity >=0.6.0 <0.8.0;
1060 
1061 /**
1062  * @dev Library for managing an enumerable variant of Solidity's
1063  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1064  * type.
1065  *
1066  * Maps have the following properties:
1067  *
1068  * - Entries are added, removed, and checked for existence in constant time
1069  * (O(1)).
1070  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1071  *
1072  * ```
1073  * contract Example {
1074  *     // Add the library methods
1075  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1076  *
1077  *     // Declare a set state variable
1078  *     EnumerableMap.UintToAddressMap private myMap;
1079  * }
1080  * ```
1081  *
1082  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1083  * supported.
1084  */
1085 library EnumerableMap {
1086     // To implement this library for multiple types with as little code
1087     // repetition as possible, we write it in terms of a generic Map type with
1088     // bytes32 keys and values.
1089     // The Map implementation uses private functions, and user-facing
1090     // implementations (such as Uint256ToAddressMap) are just wrappers around
1091     // the underlying Map.
1092     // This means that we can only create new EnumerableMaps for types that fit
1093     // in bytes32.
1094 
1095     struct MapEntry {
1096         bytes32 _key;
1097         bytes32 _value;
1098     }
1099 
1100     struct Map {
1101         // Storage of map keys and values
1102         MapEntry[] _entries;
1103 
1104         // Position of the entry defined by a key in the `entries` array, plus 1
1105         // because index 0 means a key is not in the map.
1106         mapping (bytes32 => uint256) _indexes;
1107     }
1108 
1109     /**
1110      * @dev Adds a key-value pair to a map, or updates the value for an existing
1111      * key. O(1).
1112      *
1113      * Returns true if the key was added to the map, that is if it was not
1114      * already present.
1115      */
1116     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1117         // We read and store the key's index to prevent multiple reads from the same storage slot
1118         uint256 keyIndex = map._indexes[key];
1119 
1120         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1121             map._entries.push(MapEntry({ _key: key, _value: value }));
1122             // The entry is stored at length-1, but we add 1 to all indexes
1123             // and use 0 as a sentinel value
1124             map._indexes[key] = map._entries.length;
1125             return true;
1126         } else {
1127             map._entries[keyIndex - 1]._value = value;
1128             return false;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Removes a key-value pair from a map. O(1).
1134      *
1135      * Returns true if the key was removed from the map, that is if it was present.
1136      */
1137     function _remove(Map storage map, bytes32 key) private returns (bool) {
1138         // We read and store the key's index to prevent multiple reads from the same storage slot
1139         uint256 keyIndex = map._indexes[key];
1140 
1141         if (keyIndex != 0) { // Equivalent to contains(map, key)
1142             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1143             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1144             // This modifies the order of the array, as noted in {at}.
1145 
1146             uint256 toDeleteIndex = keyIndex - 1;
1147             uint256 lastIndex = map._entries.length - 1;
1148 
1149             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1150             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1151 
1152             MapEntry storage lastEntry = map._entries[lastIndex];
1153 
1154             // Move the last entry to the index where the entry to delete is
1155             map._entries[toDeleteIndex] = lastEntry;
1156             // Update the index for the moved entry
1157             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1158 
1159             // Delete the slot where the moved entry was stored
1160             map._entries.pop();
1161 
1162             // Delete the index for the deleted slot
1163             delete map._indexes[key];
1164 
1165             return true;
1166         } else {
1167             return false;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Returns true if the key is in the map. O(1).
1173      */
1174     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1175         return map._indexes[key] != 0;
1176     }
1177 
1178     /**
1179      * @dev Returns the number of key-value pairs in the map. O(1).
1180      */
1181     function _length(Map storage map) private view returns (uint256) {
1182         return map._entries.length;
1183     }
1184 
1185    /**
1186     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1187     *
1188     * Note that there are no guarantees on the ordering of entries inside the
1189     * array, and it may change when more entries are added or removed.
1190     *
1191     * Requirements:
1192     *
1193     * - `index` must be strictly less than {length}.
1194     */
1195     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1196         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1197 
1198         MapEntry storage entry = map._entries[index];
1199         return (entry._key, entry._value);
1200     }
1201 
1202     /**
1203      * @dev Tries to returns the value associated with `key`.  O(1).
1204      * Does not revert if `key` is not in the map.
1205      */
1206     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1207         uint256 keyIndex = map._indexes[key];
1208         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1209         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1210     }
1211 
1212     /**
1213      * @dev Returns the value associated with `key`.  O(1).
1214      *
1215      * Requirements:
1216      *
1217      * - `key` must be in the map.
1218      */
1219     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1220         uint256 keyIndex = map._indexes[key];
1221         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1222         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1223     }
1224 
1225     /**
1226      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1227      *
1228      * CAUTION: This function is deprecated because it requires allocating memory for the error
1229      * message unnecessarily. For custom revert reasons use {_tryGet}.
1230      */
1231     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1232         uint256 keyIndex = map._indexes[key];
1233         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1234         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1235     }
1236 
1237     // UintToAddressMap
1238 
1239     struct UintToAddressMap {
1240         Map _inner;
1241     }
1242 
1243     /**
1244      * @dev Adds a key-value pair to a map, or updates the value for an existing
1245      * key. O(1).
1246      *
1247      * Returns true if the key was added to the map, that is if it was not
1248      * already present.
1249      */
1250     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1251         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1252     }
1253 
1254     /**
1255      * @dev Removes a value from a set. O(1).
1256      *
1257      * Returns true if the key was removed from the map, that is if it was present.
1258      */
1259     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1260         return _remove(map._inner, bytes32(key));
1261     }
1262 
1263     /**
1264      * @dev Returns true if the key is in the map. O(1).
1265      */
1266     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1267         return _contains(map._inner, bytes32(key));
1268     }
1269 
1270     /**
1271      * @dev Returns the number of elements in the map. O(1).
1272      */
1273     function length(UintToAddressMap storage map) internal view returns (uint256) {
1274         return _length(map._inner);
1275     }
1276 
1277    /**
1278     * @dev Returns the element stored at position `index` in the set. O(1).
1279     * Note that there are no guarantees on the ordering of values inside the
1280     * array, and it may change when more values are added or removed.
1281     *
1282     * Requirements:
1283     *
1284     * - `index` must be strictly less than {length}.
1285     */
1286     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1287         (bytes32 key, bytes32 value) = _at(map._inner, index);
1288         return (uint256(key), address(uint160(uint256(value))));
1289     }
1290 
1291     /**
1292      * @dev Tries to returns the value associated with `key`.  O(1).
1293      * Does not revert if `key` is not in the map.
1294      *
1295      * _Available since v3.4._
1296      */
1297     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1298         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1299         return (success, address(uint160(uint256(value))));
1300     }
1301 
1302     /**
1303      * @dev Returns the value associated with `key`.  O(1).
1304      *
1305      * Requirements:
1306      *
1307      * - `key` must be in the map.
1308      */
1309     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1310         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1311     }
1312 
1313     /**
1314      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1315      *
1316      * CAUTION: This function is deprecated because it requires allocating memory for the error
1317      * message unnecessarily. For custom revert reasons use {tryGet}.
1318      */
1319     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1320         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1321     }
1322 }
1323 
1324 // File: @openzeppelin/contracts/utils/Strings.sol
1325 
1326 
1327 
1328 pragma solidity >=0.6.0 <0.8.0;
1329 
1330 /**
1331  * @dev String operations.
1332  */
1333 library Strings {
1334     /**
1335      * @dev Converts a `uint256` to its ASCII `string` representation.
1336      */
1337     function toString(uint256 value) internal pure returns (string memory) {
1338         // Inspired by OraclizeAPI's implementation - MIT licence
1339         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1340 
1341         if (value == 0) {
1342             return "0";
1343         }
1344         uint256 temp = value;
1345         uint256 digits;
1346         while (temp != 0) {
1347             digits++;
1348             temp /= 10;
1349         }
1350         bytes memory buffer = new bytes(digits);
1351         uint256 index = digits - 1;
1352         temp = value;
1353         while (temp != 0) {
1354             buffer[index--] = bytes1(uint8(48 + temp % 10));
1355             temp /= 10;
1356         }
1357         return string(buffer);
1358     }
1359 }
1360 
1361 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1362 
1363 
1364 
1365 pragma solidity >=0.6.0 <0.8.0;
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 /**
1379  * @title ERC721 Non-Fungible Token Standard basic implementation
1380  * @dev see https://eips.ethereum.org/EIPS/eip-721
1381  */
1382 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1383     using SafeMath for uint256;
1384     using Address for address;
1385     using EnumerableSet for EnumerableSet.UintSet;
1386     using EnumerableMap for EnumerableMap.UintToAddressMap;
1387     using Strings for uint256;
1388 
1389     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1390     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1391     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1392 
1393     // Mapping from holder address to their (enumerable) set of owned tokens
1394     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1395 
1396     // Enumerable mapping from token ids to their owners
1397     EnumerableMap.UintToAddressMap private _tokenOwners;
1398 
1399     // Mapping from token ID to approved address
1400     mapping (uint256 => address) private _tokenApprovals;
1401 
1402     // Mapping from owner to operator approvals
1403     mapping (address => mapping (address => bool)) private _operatorApprovals;
1404 
1405     // Token name
1406     string private _name;
1407 
1408     // Token symbol
1409     string private _symbol;
1410 
1411     // Optional mapping for token URIs
1412     mapping (uint256 => string) private _tokenURIs;
1413 
1414     // Base URI
1415     string private _baseURI;
1416 
1417     /*
1418      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1419      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1420      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1421      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1422      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1423      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1424      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1425      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1426      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1427      *
1428      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1429      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1430      */
1431     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1432 
1433     /*
1434      *     bytes4(keccak256('name()')) == 0x06fdde03
1435      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1436      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1437      *
1438      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1439      */
1440     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1441 
1442     /*
1443      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1444      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1445      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1446      *
1447      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1448      */
1449     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1450 
1451     /**
1452      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1453      */
1454     constructor (string memory name_, string memory symbol_) public {
1455         _name = name_;
1456         _symbol = symbol_;
1457 
1458         // register the supported interfaces to conform to ERC721 via ERC165
1459         _registerInterface(_INTERFACE_ID_ERC721);
1460         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1461         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-balanceOf}.
1466      */
1467     function balanceOf(address owner) public view virtual override returns (uint256) {
1468         require(owner != address(0), "ERC721: balance query for the zero address");
1469         return _holderTokens[owner].length();
1470     }
1471 
1472     /**
1473      * @dev See {IERC721-ownerOf}.
1474      */
1475     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1476         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1477     }
1478 
1479     /**
1480      * @dev See {IERC721Metadata-name}.
1481      */
1482     function name() public view virtual override returns (string memory) {
1483         return _name;
1484     }
1485 
1486     /**
1487      * @dev See {IERC721Metadata-symbol}.
1488      */
1489     function symbol() public view virtual override returns (string memory) {
1490         return _symbol;
1491     }
1492 
1493     /**
1494      * @dev See {IERC721Metadata-tokenURI}.
1495      */
1496     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1497         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1498 
1499         string memory _tokenURI = _tokenURIs[tokenId];
1500         string memory base = baseURI();
1501 
1502         // If there is no base URI, return the token URI.
1503         if (bytes(base).length == 0) {
1504             return _tokenURI;
1505         }
1506         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1507         if (bytes(_tokenURI).length > 0) {
1508             return string(abi.encodePacked(base, _tokenURI));
1509         }
1510         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1511         return string(abi.encodePacked(base, tokenId.toString()));
1512     }
1513 
1514     /**
1515     * @dev Returns the base URI set via {_setBaseURI}. This will be
1516     * automatically added as a prefix in {tokenURI} to each token's URI, or
1517     * to the token ID if no specific URI is set for that token ID.
1518     */
1519     function baseURI() public view virtual returns (string memory) {
1520         return _baseURI;
1521     }
1522 
1523     /**
1524      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1525      */
1526     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1527         return _holderTokens[owner].at(index);
1528     }
1529 
1530     /**
1531      * @dev See {IERC721Enumerable-totalSupply}.
1532      */
1533     function totalSupply() public view virtual override returns (uint256) {
1534         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1535         return _tokenOwners.length();
1536     }
1537 
1538     /**
1539      * @dev See {IERC721Enumerable-tokenByIndex}.
1540      */
1541     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1542         (uint256 tokenId, ) = _tokenOwners.at(index);
1543         return tokenId;
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-approve}.
1548      */
1549     function approve(address to, uint256 tokenId) public virtual override {
1550         address owner = ERC721.ownerOf(tokenId);
1551         require(to != owner, "ERC721: approval to current owner");
1552 
1553         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1554             "ERC721: approve caller is not owner nor approved for all"
1555         );
1556 
1557         _approve(to, tokenId);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-getApproved}.
1562      */
1563     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1564         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1565 
1566         return _tokenApprovals[tokenId];
1567     }
1568 
1569     /**
1570      * @dev See {IERC721-setApprovalForAll}.
1571      */
1572     function setApprovalForAll(address operator, bool approved) public virtual override {
1573         require(operator != _msgSender(), "ERC721: approve to caller");
1574 
1575         _operatorApprovals[_msgSender()][operator] = approved;
1576         emit ApprovalForAll(_msgSender(), operator, approved);
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-isApprovedForAll}.
1581      */
1582     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1583         return _operatorApprovals[owner][operator];
1584     }
1585 
1586     /**
1587      * @dev See {IERC721-transferFrom}.
1588      */
1589     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1590         //solhint-disable-next-line max-line-length
1591         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1592 
1593         _transfer(from, to, tokenId);
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-safeTransferFrom}.
1598      */
1599     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1600         safeTransferFrom(from, to, tokenId, "");
1601     }
1602 
1603     /**
1604      * @dev See {IERC721-safeTransferFrom}.
1605      */
1606     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1607         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1608         _safeTransfer(from, to, tokenId, _data);
1609     }
1610 
1611     /**
1612      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1613      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1614      *
1615      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1616      *
1617      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1618      * implement alternative mechanisms to perform token transfer, such as signature-based.
1619      *
1620      * Requirements:
1621      *
1622      * - `from` cannot be the zero address.
1623      * - `to` cannot be the zero address.
1624      * - `tokenId` token must exist and be owned by `from`.
1625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1626      *
1627      * Emits a {Transfer} event.
1628      */
1629     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1630         _transfer(from, to, tokenId);
1631         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1632     }
1633 
1634     /**
1635      * @dev Returns whether `tokenId` exists.
1636      *
1637      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1638      *
1639      * Tokens start existing when they are minted (`_mint`),
1640      * and stop existing when they are burned (`_burn`).
1641      */
1642     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1643         return _tokenOwners.contains(tokenId);
1644     }
1645 
1646     /**
1647      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      */
1653     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1654         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1655         address owner = ERC721.ownerOf(tokenId);
1656         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1657     }
1658 
1659     /**
1660      * @dev Safely mints `tokenId` and transfers it to `to`.
1661      *
1662      * Requirements:
1663      d*
1664      * - `tokenId` must not exist.
1665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1666      *
1667      * Emits a {Transfer} event.
1668      */
1669     function _safeMint(address to, uint256 tokenId) internal virtual {
1670         _safeMint(to, tokenId, "");
1671     }
1672 
1673     /**
1674      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1675      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1676      */
1677     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1678         _mint(to, tokenId);
1679         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1680     }
1681 
1682     /**
1683      * @dev Mints `tokenId` and transfers it to `to`.
1684      *
1685      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1686      *
1687      * Requirements:
1688      *
1689      * - `tokenId` must not exist.
1690      * - `to` cannot be the zero address.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function _mint(address to, uint256 tokenId) internal virtual {
1695         require(to != address(0), "ERC721: mint to the zero address");
1696         require(!_exists(tokenId), "ERC721: token already minted");
1697 
1698         _beforeTokenTransfer(address(0), to, tokenId);
1699 
1700         _holderTokens[to].add(tokenId);
1701 
1702         _tokenOwners.set(tokenId, to);
1703 
1704         emit Transfer(address(0), to, tokenId);
1705     }
1706 
1707     /**
1708      * @dev Destroys `tokenId`.
1709      * The approval is cleared when the token is burned.
1710      *
1711      * Requirements:
1712      *
1713      * - `tokenId` must exist.
1714      *
1715      * Emits a {Transfer} event.
1716      */
1717     function _burn(uint256 tokenId) internal virtual {
1718         address owner = ERC721.ownerOf(tokenId); // internal owner
1719 
1720         _beforeTokenTransfer(owner, address(0), tokenId);
1721 
1722         // Clear approvals
1723         _approve(address(0), tokenId);
1724 
1725         // Clear metadata (if any)
1726         if (bytes(_tokenURIs[tokenId]).length != 0) {
1727             delete _tokenURIs[tokenId];
1728         }
1729 
1730         _holderTokens[owner].remove(tokenId);
1731 
1732         _tokenOwners.remove(tokenId);
1733 
1734         emit Transfer(owner, address(0), tokenId);
1735     }
1736 
1737     /**
1738      * @dev Transfers `tokenId` from `from` to `to`.
1739      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1740      *
1741      * Requirements:
1742      *
1743      * - `to` cannot be the zero address.
1744      * - `tokenId` token must be owned by `from`.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1749         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1750         require(to != address(0), "ERC721: transfer to the zero address");
1751 
1752         _beforeTokenTransfer(from, to, tokenId);
1753 
1754         // Clear approvals from the previous owner
1755         _approve(address(0), tokenId);
1756 
1757         _holderTokens[from].remove(tokenId);
1758         _holderTokens[to].add(tokenId);
1759 
1760         _tokenOwners.set(tokenId, to);
1761 
1762         emit Transfer(from, to, tokenId);
1763     }
1764 
1765     /**
1766      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1767      *
1768      * Requirements:
1769      *
1770      * - `tokenId` must exist.
1771      */
1772     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1773         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1774         _tokenURIs[tokenId] = _tokenURI;
1775     }
1776 
1777     /**
1778      * @dev Internal function to set the base URI for all token IDs. It is
1779      * automatically added as a prefix to the value returned in {tokenURI},
1780      * or to the token ID if {tokenURI} is empty.
1781      */
1782     function _setBaseURI(string memory baseURI_) internal virtual {
1783         _baseURI = baseURI_;
1784     }
1785 
1786     /**
1787      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1788      * The call is not executed if the target address is not a contract.
1789      *
1790      * @param from address representing the previous owner of the given token ID
1791      * @param to target address that will receive the tokens
1792      * @param tokenId uint256 ID of the token to be transferred
1793      * @param _data bytes optional data to send along with the call
1794      * @return bool whether the call correctly returned the expected magic value
1795      */
1796     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1797         private returns (bool)
1798     {
1799         if (!to.isContract()) {
1800             return true;
1801         }
1802         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1803             IERC721Receiver(to).onERC721Received.selector,
1804             _msgSender(),
1805             from,
1806             tokenId,
1807             _data
1808         ), "ERC721: transfer to non ERC721Receiver implementer");
1809         bytes4 retval = abi.decode(returndata, (bytes4));
1810         return (retval == _ERC721_RECEIVED);
1811     }
1812 
1813     /**
1814      * @dev Approve `to` to operate on `tokenId`
1815      *
1816      * Emits an {Approval} event.
1817      */
1818     function _approve(address to, uint256 tokenId) internal virtual {
1819         _tokenApprovals[tokenId] = to;
1820         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1821     }
1822 
1823     /**
1824      * @dev Hook that is called before any token transfer. This includes minting
1825      * and burning.
1826      *
1827      * Calling conditions:
1828      *
1829      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1830      * transferred to `to`.
1831      * - When `from` is zero, `tokenId` will be minted for `to`.
1832      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1833      * - `from` cannot be the zero address.
1834      * - `to` cannot be the zero address.
1835      *
1836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1837      */
1838     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1839 }
1840 
1841 // File: @openzeppelin/contracts/access/Ownable.sol
1842 
1843 
1844 
1845 pragma solidity >=0.6.0 <0.8.0;
1846 
1847 /**
1848  * @dev Contract module which provides a basic access control mechanism, where
1849  * there is an account (an owner) that can be granted exclusive access to
1850  * specific functions.
1851  *
1852  * By default, the owner account will be the one that deploys the contract. This
1853  * can later be changed with {transferOwnership}.
1854  *
1855  * This module is used through inheritance. It will make available the modifier
1856  * `onlyOwner`, which can be applied to your functions to restrict their use to
1857  * the owner.
1858  */
1859 abstract contract Ownable is Context {
1860     address private _owner;
1861 
1862     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1863 
1864     /**
1865      * @dev Initializes the contract setting the deployer as the initial owner.
1866      */
1867     constructor () internal {
1868         address msgSender = _msgSender();
1869         _owner = msgSender;
1870         emit OwnershipTransferred(address(0), msgSender);
1871     }
1872 
1873     /**
1874      * @dev Returns the address of the current owner.
1875      */
1876     function owner() public view virtual returns (address) {
1877         return _owner;
1878     }
1879 
1880     /**
1881      * @dev Throws if called by any account other than the owner.
1882      */
1883     modifier onlyOwner() {
1884         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1885         _;
1886     }
1887 
1888     /**
1889      * @dev Leaves the contract without owner. It will not be possible to call
1890      * `onlyOwner` functions anymore. Can only be called by the current owner.
1891      *
1892      * NOTE: Renouncing ownership will leave the contract without an owner,
1893      * thereby removing any functionality that is only available to the owner.
1894      */
1895     function renounceOwnership() public virtual onlyOwner {
1896         emit OwnershipTransferred(_owner, address(0));
1897         _owner = address(0);
1898     }
1899 
1900     /**
1901      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1902      * Can only be called by the current owner.
1903      */
1904     function transferOwnership(address newOwner) public virtual onlyOwner {
1905         require(newOwner != address(0), "Ownable: new owner is the zero address");
1906         emit OwnershipTransferred(_owner, newOwner);
1907         _owner = newOwner;
1908     }
1909 }
1910 
1911 // File: contracts/DDs.sol
1912 
1913 pragma solidity 0.7.0;
1914 
1915 /**
1916  * @title DD Contract, inspired from the WC contract. 
1917  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1918  */
1919 contract DeadDude is ERC721, Ownable {
1920     using SafeMath for uint256;
1921 
1922     string public PROV = "";
1923     uint256 public ddPrice = 80000000000000000; // 0.08 ETH
1924     uint public maxDDPurchase = 100;
1925     uint256 public max_dds = 4444;
1926     bool public saleIsActive = false;
1927 
1928     constructor() ERC721("DeadDudeProject", "DDP") {
1929     }
1930 
1931     function withdraw() public onlyOwner {
1932         uint balance = address(this).balance;
1933         msg.sender.transfer(balance);
1934     }
1935 
1936     function reserveDDs() public onlyOwner {        
1937         uint supply = totalSupply();
1938         uint i;
1939         for (i = 0; i < 44; i++) {
1940             _safeMint(msg.sender, supply + i);
1941         }
1942     }
1943     
1944     function flipSaleState() public onlyOwner {
1945         saleIsActive = !saleIsActive;
1946     }
1947 
1948     function setPrice(uint256 price) public onlyOwner {
1949         ddPrice = price;
1950     }
1951 
1952     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1953         PROV = provenanceHash;
1954     }
1955 
1956     function setBaseURI(string memory baseURI) public onlyOwner {
1957         _setBaseURI(baseURI);
1958     }
1959 
1960     function mintDDs(uint numberOfTokens) public payable {
1961         require(saleIsActive, "Sale must be active to mint DDs");
1962         require(numberOfTokens <= maxDDPurchase, "Can only mint 100 tokens at a time");
1963         require(totalSupply().add(numberOfTokens) <= max_dds, "Purchase would exceed max supply of DDs");
1964         require(ddPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1965         
1966         for(uint i = 0; i < numberOfTokens; i++) {
1967             uint mintIndex = totalSupply();
1968             if (totalSupply() < max_dds) {
1969                 _safeMint(msg.sender, mintIndex);
1970             }
1971         }
1972     }
1973 
1974 }