1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
56 
57 
58 
59 pragma solidity >=0.6.2 <0.8.0;
60 
61 
62 /**
63  * @dev Required interface of an ERC721 compliant contract.
64  */
65 interface IERC721 is IERC165 {
66     /**
67      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
73      */
74     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
80 
81     /**
82      * @dev Returns the number of tokens in ``owner``'s account.
83      */
84     function balanceOf(address owner) external view returns (uint256 balance);
85 
86     /**
87      * @dev Returns the owner of the `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(address from, address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address from, address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171       * @dev Safely transfers `tokenId` token from `from` to `to`.
172       *
173       * Requirements:
174       *
175       * - `from` cannot be the zero address.
176       * - `to` cannot be the zero address.
177       * - `tokenId` token must exist and be owned by `from`.
178       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180       *
181       * Emits a {Transfer} event.
182       */
183     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
187 
188 
189 
190 pragma solidity >=0.6.2 <0.8.0;
191 
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198 
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
216 
217 
218 
219 pragma solidity >=0.6.2 <0.8.0;
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Enumerable is IERC721 {
227 
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
247 
248 
249 
250 pragma solidity >=0.6.0 <0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/introspection/ERC165.sol
271 
272 
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 /**
278  * @dev Implementation of the {IERC165} interface.
279  *
280  * Contracts may inherit from this and call {_registerInterface} to declare
281  * their support of an interface.
282  */
283 abstract contract ERC165 is IERC165 {
284     /*
285      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
286      */
287     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
288 
289     /**
290      * @dev Mapping of interface ids to whether or not it's supported.
291      */
292     mapping(bytes4 => bool) private _supportedInterfaces;
293 
294     constructor () internal {
295         // Derived contracts need only register support for their own interfaces,
296         // we register support for ERC165 itself here
297         _registerInterface(_INTERFACE_ID_ERC165);
298     }
299 
300     /**
301      * @dev See {IERC165-supportsInterface}.
302      *
303      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
304      */
305     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306         return _supportedInterfaces[interfaceId];
307     }
308 
309     /**
310      * @dev Registers the contract as an implementer of the interface defined by
311      * `interfaceId`. Support of the actual ERC165 interface is automatic and
312      * registering its interface id is not required.
313      *
314      * See {IERC165-supportsInterface}.
315      *
316      * Requirements:
317      *
318      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
319      */
320     function _registerInterface(bytes4 interfaceId) internal virtual {
321         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
322         _supportedInterfaces[interfaceId] = true;
323     }
324 }
325 
326 // File: @openzeppelin/contracts/math/SafeMath.sol
327 
328 
329 
330 pragma solidity >=0.6.0 <0.8.0;
331 
332 /**
333  * @dev Wrappers over Solidity's arithmetic operations with added overflow
334  * checks.
335  *
336  * Arithmetic operations in Solidity wrap on overflow. This can easily result
337  * in bugs, because programmers usually assume that an overflow raises an
338  * error, which is the standard behavior in high level programming languages.
339  * `SafeMath` restores this intuition by reverting the transaction when an
340  * operation overflows.
341  *
342  * Using this library instead of the unchecked operations eliminates an entire
343  * class of bugs, so it's recommended to use it always.
344  */
345 library SafeMath {
346     /**
347      * @dev Returns the addition of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
352         uint256 c = a + b;
353         if (c < a) return (false, 0);
354         return (true, c);
355     }
356 
357     /**
358      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
359      *
360      * _Available since v3.4._
361      */
362     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
363         if (b > a) return (false, 0);
364         return (true, a - b);
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374         // benefit is lost if 'b' is also tested.
375         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
376         if (a == 0) return (true, 0);
377         uint256 c = a * b;
378         if (c / a != b) return (false, 0);
379         return (true, c);
380     }
381 
382     /**
383      * @dev Returns the division of two unsigned integers, with a division by zero flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         if (b == 0) return (false, 0);
389         return (true, a / b);
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
394      *
395      * _Available since v3.4._
396      */
397     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         if (b == 0) return (false, 0);
399         return (true, a % b);
400     }
401 
402     /**
403      * @dev Returns the addition of two unsigned integers, reverting on
404      * overflow.
405      *
406      * Counterpart to Solidity's `+` operator.
407      *
408      * Requirements:
409      *
410      * - Addition cannot overflow.
411      */
412     function add(uint256 a, uint256 b) internal pure returns (uint256) {
413         uint256 c = a + b;
414         require(c >= a, "SafeMath: addition overflow");
415         return c;
416     }
417 
418     /**
419      * @dev Returns the subtraction of two unsigned integers, reverting on
420      * overflow (when the result is negative).
421      *
422      * Counterpart to Solidity's `-` operator.
423      *
424      * Requirements:
425      *
426      * - Subtraction cannot overflow.
427      */
428     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
429         require(b <= a, "SafeMath: subtraction overflow");
430         return a - b;
431     }
432 
433     /**
434      * @dev Returns the multiplication of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `*` operator.
438      *
439      * Requirements:
440      *
441      * - Multiplication cannot overflow.
442      */
443     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
444         if (a == 0) return 0;
445         uint256 c = a * b;
446         require(c / a == b, "SafeMath: multiplication overflow");
447         return c;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers, reverting on
452      * division by zero. The result is rounded towards zero.
453      *
454      * Counterpart to Solidity's `/` operator. Note: this function uses a
455      * `revert` opcode (which leaves remaining gas untouched) while Solidity
456      * uses an invalid opcode to revert (consuming all remaining gas).
457      *
458      * Requirements:
459      *
460      * - The divisor cannot be zero.
461      */
462     function div(uint256 a, uint256 b) internal pure returns (uint256) {
463         require(b > 0, "SafeMath: division by zero");
464         return a / b;
465     }
466 
467     /**
468      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
469      * reverting when dividing by zero.
470      *
471      * Counterpart to Solidity's `%` operator. This function uses a `revert`
472      * opcode (which leaves remaining gas untouched) while Solidity uses an
473      * invalid opcode to revert (consuming all remaining gas).
474      *
475      * Requirements:
476      *
477      * - The divisor cannot be zero.
478      */
479     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
480         require(b > 0, "SafeMath: modulo by zero");
481         return a % b;
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
486      * overflow (when the result is negative).
487      *
488      * CAUTION: This function is deprecated because it requires allocating memory for the error
489      * message unnecessarily. For custom revert reasons use {trySub}.
490      *
491      * Counterpart to Solidity's `-` operator.
492      *
493      * Requirements:
494      *
495      * - Subtraction cannot overflow.
496      */
497     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
498         require(b <= a, errorMessage);
499         return a - b;
500     }
501 
502     /**
503      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
504      * division by zero. The result is rounded towards zero.
505      *
506      * CAUTION: This function is deprecated because it requires allocating memory for the error
507      * message unnecessarily. For custom revert reasons use {tryDiv}.
508      *
509      * Counterpart to Solidity's `/` operator. Note: this function uses a
510      * `revert` opcode (which leaves remaining gas untouched) while Solidity
511      * uses an invalid opcode to revert (consuming all remaining gas).
512      *
513      * Requirements:
514      *
515      * - The divisor cannot be zero.
516      */
517     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b > 0, errorMessage);
519         return a / b;
520     }
521 
522     /**
523      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
524      * reverting with custom message when dividing by zero.
525      *
526      * CAUTION: This function is deprecated because it requires allocating memory for the error
527      * message unnecessarily. For custom revert reasons use {tryMod}.
528      *
529      * Counterpart to Solidity's `%` operator. This function uses a `revert`
530      * opcode (which leaves remaining gas untouched) while Solidity uses an
531      * invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b > 0, errorMessage);
539         return a % b;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/utils/Address.sol
544 
545 
546 
547 pragma solidity >=0.6.2 <0.8.0;
548 
549 /**
550  * @dev Collection of functions related to the address type
551  */
552 library Address {
553     /**
554      * @dev Returns true if `account` is a contract.
555      *
556      * [IMPORTANT]
557      * ====
558      * It is unsafe to assume that an address for which this function returns
559      * false is an externally-owned account (EOA) and not a contract.
560      *
561      * Among others, `isContract` will return false for the following
562      * types of addresses:
563      *
564      *  - an externally-owned account
565      *  - a contract in construction
566      *  - an address where a contract will be created
567      *  - an address where a contract lived, but was destroyed
568      * ====
569      */
570     function isContract(address account) internal view returns (bool) {
571         // This method relies on extcodesize, which returns 0 for contracts in
572         // construction, since the code is only stored at the end of the
573         // constructor execution.
574 
575         uint256 size;
576         // solhint-disable-next-line no-inline-assembly
577         assembly { size := extcodesize(account) }
578         return size > 0;
579     }
580 
581     /**
582      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
583      * `recipient`, forwarding all available gas and reverting on errors.
584      *
585      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
586      * of certain opcodes, possibly making contracts go over the 2300 gas limit
587      * imposed by `transfer`, making them unable to receive funds via
588      * `transfer`. {sendValue} removes this limitation.
589      *
590      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
591      *
592      * IMPORTANT: because control is transferred to `recipient`, care must be
593      * taken to not create reentrancy vulnerabilities. Consider using
594      * {ReentrancyGuard} or the
595      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
596      */
597     function sendValue(address payable recipient, uint256 amount) internal {
598         require(address(this).balance >= amount, "Address: insufficient balance");
599 
600         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
601         (bool success, ) = recipient.call{ value: amount }("");
602         require(success, "Address: unable to send value, recipient may have reverted");
603     }
604 
605     /**
606      * @dev Performs a Solidity function call using a low level `call`. A
607      * plain`call` is an unsafe replacement for a function call: use this
608      * function instead.
609      *
610      * If `target` reverts with a revert reason, it is bubbled up by this
611      * function (like regular Solidity function calls).
612      *
613      * Returns the raw returned data. To convert to the expected return value,
614      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
615      *
616      * Requirements:
617      *
618      * - `target` must be a contract.
619      * - calling `target` with `data` must not revert.
620      *
621      * _Available since v3.1._
622      */
623     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
624       return functionCall(target, data, "Address: low-level call failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
629      * `errorMessage` as a fallback revert reason when `target` reverts.
630      *
631      * _Available since v3.1._
632      */
633     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
634         return functionCallWithValue(target, data, 0, errorMessage);
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
639      * but also transferring `value` wei to `target`.
640      *
641      * Requirements:
642      *
643      * - the calling contract must have an ETH balance of at least `value`.
644      * - the called Solidity function must be `payable`.
645      *
646      * _Available since v3.1._
647      */
648     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
654      * with `errorMessage` as a fallback revert reason when `target` reverts.
655      *
656      * _Available since v3.1._
657      */
658     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
659         require(address(this).balance >= value, "Address: insufficient balance for call");
660         require(isContract(target), "Address: call to non-contract");
661 
662         // solhint-disable-next-line avoid-low-level-calls
663         (bool success, bytes memory returndata) = target.call{ value: value }(data);
664         return _verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but performing a static call.
670      *
671      * _Available since v3.3._
672      */
673     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
674         return functionStaticCall(target, data, "Address: low-level static call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a static call.
680      *
681      * _Available since v3.3._
682      */
683     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
684         require(isContract(target), "Address: static call to non-contract");
685 
686         // solhint-disable-next-line avoid-low-level-calls
687         (bool success, bytes memory returndata) = target.staticcall(data);
688         return _verifyCallResult(success, returndata, errorMessage);
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
693      * but performing a delegate call.
694      *
695      * _Available since v3.4._
696      */
697     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
698         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
703      * but performing a delegate call.
704      *
705      * _Available since v3.4._
706      */
707     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
708         require(isContract(target), "Address: delegate call to non-contract");
709 
710         // solhint-disable-next-line avoid-low-level-calls
711         (bool success, bytes memory returndata) = target.delegatecall(data);
712         return _verifyCallResult(success, returndata, errorMessage);
713     }
714 
715     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
716         if (success) {
717             return returndata;
718         } else {
719             // Look for revert reason and bubble it up if present
720             if (returndata.length > 0) {
721                 // The easiest way to bubble the revert reason is using memory via assembly
722 
723                 // solhint-disable-next-line no-inline-assembly
724                 assembly {
725                     let returndata_size := mload(returndata)
726                     revert(add(32, returndata), returndata_size)
727                 }
728             } else {
729                 revert(errorMessage);
730             }
731         }
732     }
733 }
734 
735 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
736 
737 
738 
739 pragma solidity >=0.6.0 <0.8.0;
740 
741 /**
742  * @dev Library for managing
743  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
744  * types.
745  *
746  * Sets have the following properties:
747  *
748  * - Elements are added, removed, and checked for existence in constant time
749  * (O(1)).
750  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
751  *
752  * ```
753  * contract Example {
754  *     // Add the library methods
755  *     using EnumerableSet for EnumerableSet.AddressSet;
756  *
757  *     // Declare a set state variable
758  *     EnumerableSet.AddressSet private mySet;
759  * }
760  * ```
761  *
762  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
763  * and `uint256` (`UintSet`) are supported.
764  */
765 library EnumerableSet {
766     // To implement this library for multiple types with as little code
767     // repetition as possible, we write it in terms of a generic Set type with
768     // bytes32 values.
769     // The Set implementation uses private functions, and user-facing
770     // implementations (such as AddressSet) are just wrappers around the
771     // underlying Set.
772     // This means that we can only create new EnumerableSets for types that fit
773     // in bytes32.
774 
775     struct Set {
776         // Storage of set values
777         bytes32[] _values;
778 
779         // Position of the value in the `values` array, plus 1 because index 0
780         // means a value is not in the set.
781         mapping (bytes32 => uint256) _indexes;
782     }
783 
784     /**
785      * @dev Add a value to a set. O(1).
786      *
787      * Returns true if the value was added to the set, that is if it was not
788      * already present.
789      */
790     function _add(Set storage set, bytes32 value) private returns (bool) {
791         if (!_contains(set, value)) {
792             set._values.push(value);
793             // The value is stored at length-1, but we add 1 to all indexes
794             // and use 0 as a sentinel value
795             set._indexes[value] = set._values.length;
796             return true;
797         } else {
798             return false;
799         }
800     }
801 
802     /**
803      * @dev Removes a value from a set. O(1).
804      *
805      * Returns true if the value was removed from the set, that is if it was
806      * present.
807      */
808     function _remove(Set storage set, bytes32 value) private returns (bool) {
809         // We read and store the value's index to prevent multiple reads from the same storage slot
810         uint256 valueIndex = set._indexes[value];
811 
812         if (valueIndex != 0) { // Equivalent to contains(set, value)
813             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
814             // the array, and then remove the last element (sometimes called as 'swap and pop').
815             // This modifies the order of the array, as noted in {at}.
816 
817             uint256 toDeleteIndex = valueIndex - 1;
818             uint256 lastIndex = set._values.length - 1;
819 
820             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
821             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
822 
823             bytes32 lastvalue = set._values[lastIndex];
824 
825             // Move the last value to the index where the value to delete is
826             set._values[toDeleteIndex] = lastvalue;
827             // Update the index for the moved value
828             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
829 
830             // Delete the slot where the moved value was stored
831             set._values.pop();
832 
833             // Delete the index for the deleted slot
834             delete set._indexes[value];
835 
836             return true;
837         } else {
838             return false;
839         }
840     }
841 
842     /**
843      * @dev Returns true if the value is in the set. O(1).
844      */
845     function _contains(Set storage set, bytes32 value) private view returns (bool) {
846         return set._indexes[value] != 0;
847     }
848 
849     /**
850      * @dev Returns the number of values on the set. O(1).
851      */
852     function _length(Set storage set) private view returns (uint256) {
853         return set._values.length;
854     }
855 
856    /**
857     * @dev Returns the value stored at position `index` in the set. O(1).
858     *
859     * Note that there are no guarantees on the ordering of values inside the
860     * array, and it may change when more values are added or removed.
861     *
862     * Requirements:
863     *
864     * - `index` must be strictly less than {length}.
865     */
866     function _at(Set storage set, uint256 index) private view returns (bytes32) {
867         require(set._values.length > index, "EnumerableSet: index out of bounds");
868         return set._values[index];
869     }
870 
871     // Bytes32Set
872 
873     struct Bytes32Set {
874         Set _inner;
875     }
876 
877     /**
878      * @dev Add a value to a set. O(1).
879      *
880      * Returns true if the value was added to the set, that is if it was not
881      * already present.
882      */
883     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
884         return _add(set._inner, value);
885     }
886 
887     /**
888      * @dev Removes a value from a set. O(1).
889      *
890      * Returns true if the value was removed from the set, that is if it was
891      * present.
892      */
893     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
894         return _remove(set._inner, value);
895     }
896 
897     /**
898      * @dev Returns true if the value is in the set. O(1).
899      */
900     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
901         return _contains(set._inner, value);
902     }
903 
904     /**
905      * @dev Returns the number of values in the set. O(1).
906      */
907     function length(Bytes32Set storage set) internal view returns (uint256) {
908         return _length(set._inner);
909     }
910 
911    /**
912     * @dev Returns the value stored at position `index` in the set. O(1).
913     *
914     * Note that there are no guarantees on the ordering of values inside the
915     * array, and it may change when more values are added or removed.
916     *
917     * Requirements:
918     *
919     * - `index` must be strictly less than {length}.
920     */
921     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
922         return _at(set._inner, index);
923     }
924 
925     // AddressSet
926 
927     struct AddressSet {
928         Set _inner;
929     }
930 
931     /**
932      * @dev Add a value to a set. O(1).
933      *
934      * Returns true if the value was added to the set, that is if it was not
935      * already present.
936      */
937     function add(AddressSet storage set, address value) internal returns (bool) {
938         return _add(set._inner, bytes32(uint256(uint160(value))));
939     }
940 
941     /**
942      * @dev Removes a value from a set. O(1).
943      *
944      * Returns true if the value was removed from the set, that is if it was
945      * present.
946      */
947     function remove(AddressSet storage set, address value) internal returns (bool) {
948         return _remove(set._inner, bytes32(uint256(uint160(value))));
949     }
950 
951     /**
952      * @dev Returns true if the value is in the set. O(1).
953      */
954     function contains(AddressSet storage set, address value) internal view returns (bool) {
955         return _contains(set._inner, bytes32(uint256(uint160(value))));
956     }
957 
958     /**
959      * @dev Returns the number of values in the set. O(1).
960      */
961     function length(AddressSet storage set) internal view returns (uint256) {
962         return _length(set._inner);
963     }
964 
965    /**
966     * @dev Returns the value stored at position `index` in the set. O(1).
967     *
968     * Note that there are no guarantees on the ordering of values inside the
969     * array, and it may change when more values are added or removed.
970     *
971     * Requirements:
972     *
973     * - `index` must be strictly less than {length}.
974     */
975     function at(AddressSet storage set, uint256 index) internal view returns (address) {
976         return address(uint160(uint256(_at(set._inner, index))));
977     }
978 
979 
980     // UintSet
981 
982     struct UintSet {
983         Set _inner;
984     }
985 
986     /**
987      * @dev Add a value to a set. O(1).
988      *
989      * Returns true if the value was added to the set, that is if it was not
990      * already present.
991      */
992     function add(UintSet storage set, uint256 value) internal returns (bool) {
993         return _add(set._inner, bytes32(value));
994     }
995 
996     /**
997      * @dev Removes a value from a set. O(1).
998      *
999      * Returns true if the value was removed from the set, that is if it was
1000      * present.
1001      */
1002     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1003         return _remove(set._inner, bytes32(value));
1004     }
1005 
1006     /**
1007      * @dev Returns true if the value is in the set. O(1).
1008      */
1009     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1010         return _contains(set._inner, bytes32(value));
1011     }
1012 
1013     /**
1014      * @dev Returns the number of values on the set. O(1).
1015      */
1016     function length(UintSet storage set) internal view returns (uint256) {
1017         return _length(set._inner);
1018     }
1019 
1020    /**
1021     * @dev Returns the value stored at position `index` in the set. O(1).
1022     *
1023     * Note that there are no guarantees on the ordering of values inside the
1024     * array, and it may change when more values are added or removed.
1025     *
1026     * Requirements:
1027     *
1028     * - `index` must be strictly less than {length}.
1029     */
1030     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1031         return uint256(_at(set._inner, index));
1032     }
1033 }
1034 
1035 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1036 
1037 
1038 
1039 pragma solidity >=0.6.0 <0.8.0;
1040 
1041 /**
1042  * @dev Library for managing an enumerable variant of Solidity's
1043  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1044  * type.
1045  *
1046  * Maps have the following properties:
1047  *
1048  * - Entries are added, removed, and checked for existence in constant time
1049  * (O(1)).
1050  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1051  *
1052  * ```
1053  * contract Example {
1054  *     // Add the library methods
1055  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1056  *
1057  *     // Declare a set state variable
1058  *     EnumerableMap.UintToAddressMap private myMap;
1059  * }
1060  * ```
1061  *
1062  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1063  * supported.
1064  */
1065 library EnumerableMap {
1066     // To implement this library for multiple types with as little code
1067     // repetition as possible, we write it in terms of a generic Map type with
1068     // bytes32 keys and values.
1069     // The Map implementation uses private functions, and user-facing
1070     // implementations (such as Uint256ToAddressMap) are just wrappers around
1071     // the underlying Map.
1072     // This means that we can only create new EnumerableMaps for types that fit
1073     // in bytes32.
1074 
1075     struct MapEntry {
1076         bytes32 _key;
1077         bytes32 _value;
1078     }
1079 
1080     struct Map {
1081         // Storage of map keys and values
1082         MapEntry[] _entries;
1083 
1084         // Position of the entry defined by a key in the `entries` array, plus 1
1085         // because index 0 means a key is not in the map.
1086         mapping (bytes32 => uint256) _indexes;
1087     }
1088 
1089     /**
1090      * @dev Adds a key-value pair to a map, or updates the value for an existing
1091      * key. O(1).
1092      *
1093      * Returns true if the key was added to the map, that is if it was not
1094      * already present.
1095      */
1096     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1097         // We read and store the key's index to prevent multiple reads from the same storage slot
1098         uint256 keyIndex = map._indexes[key];
1099 
1100         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1101             map._entries.push(MapEntry({ _key: key, _value: value }));
1102             // The entry is stored at length-1, but we add 1 to all indexes
1103             // and use 0 as a sentinel value
1104             map._indexes[key] = map._entries.length;
1105             return true;
1106         } else {
1107             map._entries[keyIndex - 1]._value = value;
1108             return false;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Removes a key-value pair from a map. O(1).
1114      *
1115      * Returns true if the key was removed from the map, that is if it was present.
1116      */
1117     function _remove(Map storage map, bytes32 key) private returns (bool) {
1118         // We read and store the key's index to prevent multiple reads from the same storage slot
1119         uint256 keyIndex = map._indexes[key];
1120 
1121         if (keyIndex != 0) { // Equivalent to contains(map, key)
1122             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1123             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1124             // This modifies the order of the array, as noted in {at}.
1125 
1126             uint256 toDeleteIndex = keyIndex - 1;
1127             uint256 lastIndex = map._entries.length - 1;
1128 
1129             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1130             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1131 
1132             MapEntry storage lastEntry = map._entries[lastIndex];
1133 
1134             // Move the last entry to the index where the entry to delete is
1135             map._entries[toDeleteIndex] = lastEntry;
1136             // Update the index for the moved entry
1137             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1138 
1139             // Delete the slot where the moved entry was stored
1140             map._entries.pop();
1141 
1142             // Delete the index for the deleted slot
1143             delete map._indexes[key];
1144 
1145             return true;
1146         } else {
1147             return false;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Returns true if the key is in the map. O(1).
1153      */
1154     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1155         return map._indexes[key] != 0;
1156     }
1157 
1158     /**
1159      * @dev Returns the number of key-value pairs in the map. O(1).
1160      */
1161     function _length(Map storage map) private view returns (uint256) {
1162         return map._entries.length;
1163     }
1164 
1165    /**
1166     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1167     *
1168     * Note that there are no guarantees on the ordering of entries inside the
1169     * array, and it may change when more entries are added or removed.
1170     *
1171     * Requirements:
1172     *
1173     * - `index` must be strictly less than {length}.
1174     */
1175     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1176         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1177 
1178         MapEntry storage entry = map._entries[index];
1179         return (entry._key, entry._value);
1180     }
1181 
1182     /**
1183      * @dev Tries to returns the value associated with `key`.  O(1).
1184      * Does not revert if `key` is not in the map.
1185      */
1186     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1187         uint256 keyIndex = map._indexes[key];
1188         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1189         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1190     }
1191 
1192     /**
1193      * @dev Returns the value associated with `key`.  O(1).
1194      *
1195      * Requirements:
1196      *
1197      * - `key` must be in the map.
1198      */
1199     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1200         uint256 keyIndex = map._indexes[key];
1201         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1202         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1203     }
1204 
1205     /**
1206      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1207      *
1208      * CAUTION: This function is deprecated because it requires allocating memory for the error
1209      * message unnecessarily. For custom revert reasons use {_tryGet}.
1210      */
1211     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1212         uint256 keyIndex = map._indexes[key];
1213         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1214         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1215     }
1216 
1217     // UintToAddressMap
1218 
1219     struct UintToAddressMap {
1220         Map _inner;
1221     }
1222 
1223     /**
1224      * @dev Adds a key-value pair to a map, or updates the value for an existing
1225      * key. O(1).
1226      *
1227      * Returns true if the key was added to the map, that is if it was not
1228      * already present.
1229      */
1230     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1231         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1232     }
1233 
1234     /**
1235      * @dev Removes a value from a set. O(1).
1236      *
1237      * Returns true if the key was removed from the map, that is if it was present.
1238      */
1239     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1240         return _remove(map._inner, bytes32(key));
1241     }
1242 
1243     /**
1244      * @dev Returns true if the key is in the map. O(1).
1245      */
1246     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1247         return _contains(map._inner, bytes32(key));
1248     }
1249 
1250     /**
1251      * @dev Returns the number of elements in the map. O(1).
1252      */
1253     function length(UintToAddressMap storage map) internal view returns (uint256) {
1254         return _length(map._inner);
1255     }
1256 
1257    /**
1258     * @dev Returns the element stored at position `index` in the set. O(1).
1259     * Note that there are no guarantees on the ordering of values inside the
1260     * array, and it may change when more values are added or removed.
1261     *
1262     * Requirements:
1263     *
1264     * - `index` must be strictly less than {length}.
1265     */
1266     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1267         (bytes32 key, bytes32 value) = _at(map._inner, index);
1268         return (uint256(key), address(uint160(uint256(value))));
1269     }
1270 
1271     /**
1272      * @dev Tries to returns the value associated with `key`.  O(1).
1273      * Does not revert if `key` is not in the map.
1274      *
1275      * _Available since v3.4._
1276      */
1277     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1278         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1279         return (success, address(uint160(uint256(value))));
1280     }
1281 
1282     /**
1283      * @dev Returns the value associated with `key`.  O(1).
1284      *
1285      * Requirements:
1286      *
1287      * - `key` must be in the map.
1288      */
1289     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1290         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1291     }
1292 
1293     /**
1294      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1295      *
1296      * CAUTION: This function is deprecated because it requires allocating memory for the error
1297      * message unnecessarily. For custom revert reasons use {tryGet}.
1298      */
1299     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1300         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1301     }
1302 }
1303 
1304 // File: @openzeppelin/contracts/utils/Strings.sol
1305 
1306 
1307 
1308 pragma solidity >=0.6.0 <0.8.0;
1309 
1310 /**
1311  * @dev String operations.
1312  */
1313 library Strings {
1314     /**
1315      * @dev Converts a `uint256` to its ASCII `string` representation.
1316      */
1317     function toString(uint256 value) internal pure returns (string memory) {
1318         // Inspired by OraclizeAPI's implementation - MIT licence
1319         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1320 
1321         if (value == 0) {
1322             return "0";
1323         }
1324         uint256 temp = value;
1325         uint256 digits;
1326         while (temp != 0) {
1327             digits++;
1328             temp /= 10;
1329         }
1330         bytes memory buffer = new bytes(digits);
1331         uint256 index = digits - 1;
1332         temp = value;
1333         while (temp != 0) {
1334             buffer[index--] = bytes1(uint8(48 + temp % 10));
1335             temp /= 10;
1336         }
1337         return string(buffer);
1338     }
1339 }
1340 
1341 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1342 
1343 
1344 
1345 pragma solidity >=0.6.0 <0.8.0;
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 /**
1359  * @title ERC721 Non-Fungible Token Standard basic implementation
1360  * @dev see https://eips.ethereum.org/EIPS/eip-721
1361  */
1362 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1363     using SafeMath for uint256;
1364     using Address for address;
1365     using EnumerableSet for EnumerableSet.UintSet;
1366     using EnumerableMap for EnumerableMap.UintToAddressMap;
1367     using Strings for uint256;
1368 
1369     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1370     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1371     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1372 
1373     // Mapping from holder address to their (enumerable) set of owned tokens
1374     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1375 
1376     // Enumerable mapping from token ids to their owners
1377     EnumerableMap.UintToAddressMap private _tokenOwners;
1378 
1379     // Mapping from token ID to approved address
1380     mapping (uint256 => address) private _tokenApprovals;
1381 
1382     // Mapping from owner to operator approvals
1383     mapping (address => mapping (address => bool)) private _operatorApprovals;
1384 
1385     // Token name
1386     string private _name;
1387 
1388     // Token symbol
1389     string private _symbol;
1390 
1391     // Optional mapping for token URIs
1392     mapping (uint256 => string) private _tokenURIs;
1393 
1394     // Base URI
1395     string private _baseURI;
1396 
1397     /*
1398      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1399      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1400      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1401      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1402      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1403      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1404      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1405      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1406      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1407      *
1408      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1409      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1410      */
1411     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1412 
1413     /*
1414      *     bytes4(keccak256('name()')) == 0x06fdde03
1415      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1416      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1417      *
1418      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1419      */
1420     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1421 
1422     /*
1423      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1424      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1425      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1426      *
1427      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1428      */
1429     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1430 
1431     /**
1432      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1433      */
1434     constructor (string memory name_, string memory symbol_) public {
1435         _name = name_;
1436         _symbol = symbol_;
1437 
1438         // register the supported interfaces to conform to ERC721 via ERC165
1439         _registerInterface(_INTERFACE_ID_ERC721);
1440         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1441         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-balanceOf}.
1446      */
1447     function balanceOf(address owner) public view virtual override returns (uint256) {
1448         require(owner != address(0), "ERC721: balance query for the zero address");
1449         return _holderTokens[owner].length();
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-ownerOf}.
1454      */
1455     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1456         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Metadata-name}.
1461      */
1462     function name() public view virtual override returns (string memory) {
1463         return _name;
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Metadata-symbol}.
1468      */
1469     function symbol() public view virtual override returns (string memory) {
1470         return _symbol;
1471     }
1472 
1473     /**
1474      * @dev See {IERC721Metadata-tokenURI}.
1475      */
1476     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1477         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1478 
1479         string memory _tokenURI = _tokenURIs[tokenId];
1480         string memory base = baseURI();
1481 
1482         // If there is no base URI, return the token URI.
1483         if (bytes(base).length == 0) {
1484             return _tokenURI;
1485         }
1486         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1487         if (bytes(_tokenURI).length > 0) {
1488             return string(abi.encodePacked(base, _tokenURI));
1489         }
1490         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1491         return string(abi.encodePacked(base, tokenId.toString()));
1492     }
1493 
1494     /**
1495     * @dev Returns the base URI set via {_setBaseURI}. This will be
1496     * automatically added as a prefix in {tokenURI} to each token's URI, or
1497     * to the token ID if no specific URI is set for that token ID.
1498     */
1499     function baseURI() public view virtual returns (string memory) {
1500         return _baseURI;
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1505      */
1506     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1507         return _holderTokens[owner].at(index);
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Enumerable-totalSupply}.
1512      */
1513     function totalSupply() public view virtual override returns (uint256) {
1514         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1515         return _tokenOwners.length();
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Enumerable-tokenByIndex}.
1520      */
1521     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1522         (uint256 tokenId, ) = _tokenOwners.at(index);
1523         return tokenId;
1524     }
1525 
1526     /**
1527      * @dev See {IERC721-approve}.
1528      */
1529     function approve(address to, uint256 tokenId) public virtual override {
1530         address owner = ERC721.ownerOf(tokenId);
1531         require(to != owner, "ERC721: approval to current owner");
1532 
1533         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1534             "ERC721: approve caller is not owner nor approved for all"
1535         );
1536 
1537         _approve(to, tokenId);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-getApproved}.
1542      */
1543     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1544         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1545 
1546         return _tokenApprovals[tokenId];
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-setApprovalForAll}.
1551      */
1552     function setApprovalForAll(address operator, bool approved) public virtual override {
1553         require(operator != _msgSender(), "ERC721: approve to caller");
1554 
1555         _operatorApprovals[_msgSender()][operator] = approved;
1556         emit ApprovalForAll(_msgSender(), operator, approved);
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-isApprovedForAll}.
1561      */
1562     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1563         return _operatorApprovals[owner][operator];
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-transferFrom}.
1568      */
1569     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1570         //solhint-disable-next-line max-line-length
1571         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1572 
1573         _transfer(from, to, tokenId);
1574     }
1575 
1576     /**
1577      * @dev See {IERC721-safeTransferFrom}.
1578      */
1579     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1580         safeTransferFrom(from, to, tokenId, "");
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-safeTransferFrom}.
1585      */
1586     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1587         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1588         _safeTransfer(from, to, tokenId, _data);
1589     }
1590 
1591     /**
1592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1594      *
1595      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1596      *
1597      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1598      * implement alternative mechanisms to perform token transfer, such as signature-based.
1599      *
1600      * Requirements:
1601      *
1602      * - `from` cannot be the zero address.
1603      * - `to` cannot be the zero address.
1604      * - `tokenId` token must exist and be owned by `from`.
1605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1606      *
1607      * Emits a {Transfer} event.
1608      */
1609     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1610         _transfer(from, to, tokenId);
1611         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1612     }
1613 
1614     /**
1615      * @dev Returns whether `tokenId` exists.
1616      *
1617      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1618      *
1619      * Tokens start existing when they are minted (`_mint`),
1620      * and stop existing when they are burned (`_burn`).
1621      */
1622     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1623         return _tokenOwners.contains(tokenId);
1624     }
1625 
1626     /**
1627      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must exist.
1632      */
1633     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1634         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1635         address owner = ERC721.ownerOf(tokenId);
1636         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1637     }
1638 
1639     /**
1640      * @dev Safely mints `tokenId` and transfers it to `to`.
1641      *
1642      * Requirements:
1643      d*
1644      * - `tokenId` must not exist.
1645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _safeMint(address to, uint256 tokenId) internal virtual {
1650         _safeMint(to, tokenId, "");
1651     }
1652 
1653     /**
1654      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1655      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1656      */
1657     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1658         _mint(to, tokenId);
1659         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1660     }
1661 
1662     /**
1663      * @dev Mints `tokenId` and transfers it to `to`.
1664      *
1665      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1666      *
1667      * Requirements:
1668      *
1669      * - `tokenId` must not exist.
1670      * - `to` cannot be the zero address.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function _mint(address to, uint256 tokenId) internal virtual {
1675         require(to != address(0), "ERC721: mint to the zero address");
1676         require(!_exists(tokenId), "ERC721: token already minted");
1677 
1678         _beforeTokenTransfer(address(0), to, tokenId);
1679 
1680         _holderTokens[to].add(tokenId);
1681 
1682         _tokenOwners.set(tokenId, to);
1683 
1684         emit Transfer(address(0), to, tokenId);
1685     }
1686 
1687     /**
1688      * @dev Destroys `tokenId`.
1689      * The approval is cleared when the token is burned.
1690      *
1691      * Requirements:
1692      *
1693      * - `tokenId` must exist.
1694      *
1695      * Emits a {Transfer} event.
1696      */
1697     function _burn(uint256 tokenId) internal virtual {
1698         address owner = ERC721.ownerOf(tokenId); // internal owner
1699 
1700         _beforeTokenTransfer(owner, address(0), tokenId);
1701 
1702         // Clear approvals
1703         _approve(address(0), tokenId);
1704 
1705         // Clear metadata (if any)
1706         if (bytes(_tokenURIs[tokenId]).length != 0) {
1707             delete _tokenURIs[tokenId];
1708         }
1709 
1710         _holderTokens[owner].remove(tokenId);
1711 
1712         _tokenOwners.remove(tokenId);
1713 
1714         emit Transfer(owner, address(0), tokenId);
1715     }
1716 
1717     /**
1718      * @dev Transfers `tokenId` from `from` to `to`.
1719      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1720      *
1721      * Requirements:
1722      *
1723      * - `to` cannot be the zero address.
1724      * - `tokenId` token must be owned by `from`.
1725      *
1726      * Emits a {Transfer} event.
1727      */
1728     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1729         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1730         require(to != address(0), "ERC721: transfer to the zero address");
1731 
1732         _beforeTokenTransfer(from, to, tokenId);
1733 
1734         // Clear approvals from the previous owner
1735         _approve(address(0), tokenId);
1736 
1737         _holderTokens[from].remove(tokenId);
1738         _holderTokens[to].add(tokenId);
1739 
1740         _tokenOwners.set(tokenId, to);
1741 
1742         emit Transfer(from, to, tokenId);
1743     }
1744 
1745     /**
1746      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1747      *
1748      * Requirements:
1749      *
1750      * - `tokenId` must exist.
1751      */
1752     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1753         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1754         _tokenURIs[tokenId] = _tokenURI;
1755     }
1756 
1757     /**
1758      * @dev Internal function to set the base URI for all token IDs. It is
1759      * automatically added as a prefix to the value returned in {tokenURI},
1760      * or to the token ID if {tokenURI} is empty.
1761      */
1762     function _setBaseURI(string memory baseURI_) internal virtual {
1763         _baseURI = baseURI_;
1764     }
1765 
1766     /**
1767      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1768      * The call is not executed if the target address is not a contract.
1769      *
1770      * @param from address representing the previous owner of the given token ID
1771      * @param to target address that will receive the tokens
1772      * @param tokenId uint256 ID of the token to be transferred
1773      * @param _data bytes optional data to send along with the call
1774      * @return bool whether the call correctly returned the expected magic value
1775      */
1776     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1777         private returns (bool)
1778     {
1779         if (!to.isContract()) {
1780             return true;
1781         }
1782         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1783             IERC721Receiver(to).onERC721Received.selector,
1784             _msgSender(),
1785             from,
1786             tokenId,
1787             _data
1788         ), "ERC721: transfer to non ERC721Receiver implementer");
1789         bytes4 retval = abi.decode(returndata, (bytes4));
1790         return (retval == _ERC721_RECEIVED);
1791     }
1792 
1793     function _approve(address to, uint256 tokenId) private {
1794         _tokenApprovals[tokenId] = to;
1795         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1796     }
1797 
1798     /**
1799      * @dev Hook that is called before any token transfer. This includes minting
1800      * and burning.
1801      *
1802      * Calling conditions:
1803      *
1804      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1805      * transferred to `to`.
1806      * - When `from` is zero, `tokenId` will be minted for `to`.
1807      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1808      * - `from` cannot be the zero address.
1809      * - `to` cannot be the zero address.
1810      *
1811      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1812      */
1813     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1814 }
1815 
1816 // File: @openzeppelin/contracts/utils/Counters.sol
1817 
1818 
1819 
1820 pragma solidity >=0.6.0 <0.8.0;
1821 
1822 
1823 /**
1824  * @title Counters
1825  * @author Matt Condon (@shrugs)
1826  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1827  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1828  *
1829  * Include with `using Counters for Counters.Counter;`
1830  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1831  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1832  * directly accessed.
1833  */
1834 library Counters {
1835     using SafeMath for uint256;
1836 
1837     struct Counter {
1838         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1839         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1840         // this feature: see https://github.com/ethereum/solidity/issues/4637
1841         uint256 _value; // default: 0
1842     }
1843 
1844     function current(Counter storage counter) internal view returns (uint256) {
1845         return counter._value;
1846     }
1847 
1848     function increment(Counter storage counter) internal {
1849         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1850         counter._value += 1;
1851     }
1852 
1853     function decrement(Counter storage counter) internal {
1854         counter._value = counter._value.sub(1);
1855     }
1856 }
1857 
1858 // File: @openzeppelin/contracts/utils/Pausable.sol
1859 
1860 
1861 
1862 pragma solidity >=0.6.0 <0.8.0;
1863 
1864 
1865 /**
1866  * @dev Contract module which allows children to implement an emergency stop
1867  * mechanism that can be triggered by an authorized account.
1868  *
1869  * This module is used through inheritance. It will make available the
1870  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1871  * the functions of your contract. Note that they will not be pausable by
1872  * simply including this module, only once the modifiers are put in place.
1873  */
1874 abstract contract Pausable is Context {
1875     /**
1876      * @dev Emitted when the pause is triggered by `account`.
1877      */
1878     event Paused(address account);
1879 
1880     /**
1881      * @dev Emitted when the pause is lifted by `account`.
1882      */
1883     event Unpaused(address account);
1884 
1885     bool private _paused;
1886 
1887     /**
1888      * @dev Initializes the contract in unpaused state.
1889      */
1890     constructor () internal {
1891         _paused = false;
1892     }
1893 
1894     /**
1895      * @dev Returns true if the contract is paused, and false otherwise.
1896      */
1897     function paused() public view virtual returns (bool) {
1898         return _paused;
1899     }
1900 
1901     /**
1902      * @dev Modifier to make a function callable only when the contract is not paused.
1903      *
1904      * Requirements:
1905      *
1906      * - The contract must not be paused.
1907      */
1908     modifier whenNotPaused() {
1909         require(!paused(), "Pausable: paused");
1910         _;
1911     }
1912 
1913     /**
1914      * @dev Modifier to make a function callable only when the contract is paused.
1915      *
1916      * Requirements:
1917      *
1918      * - The contract must be paused.
1919      */
1920     modifier whenPaused() {
1921         require(paused(), "Pausable: not paused");
1922         _;
1923     }
1924 
1925     /**
1926      * @dev Triggers stopped state.
1927      *
1928      * Requirements:
1929      *
1930      * - The contract must not be paused.
1931      */
1932     function _pause() internal virtual whenNotPaused {
1933         _paused = true;
1934         emit Paused(_msgSender());
1935     }
1936 
1937     /**
1938      * @dev Returns to normal state.
1939      *
1940      * Requirements:
1941      *
1942      * - The contract must be paused.
1943      */
1944     function _unpause() internal virtual whenPaused {
1945         _paused = false;
1946         emit Unpaused(_msgSender());
1947     }
1948 }
1949 
1950 // File: @openzeppelin/contracts/access/Ownable.sol
1951 
1952 
1953 
1954 pragma solidity >=0.6.0 <0.8.0;
1955 
1956 /**
1957  * @dev Contract module which provides a basic access control mechanism, where
1958  * there is an account (an owner) that can be granted exclusive access to
1959  * specific functions.
1960  *
1961  * By default, the owner account will be the one that deploys the contract. This
1962  * can later be changed with {transferOwnership}.
1963  *
1964  * This module is used through inheritance. It will make available the modifier
1965  * `onlyOwner`, which can be applied to your functions to restrict their use to
1966  * the owner.
1967  */
1968 abstract contract Ownable is Context {
1969     address private _owner;
1970 
1971     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1972 
1973     /**
1974      * @dev Initializes the contract setting the deployer as the initial owner.
1975      */
1976     constructor () internal {
1977         address msgSender = _msgSender();
1978         _owner = msgSender;
1979         emit OwnershipTransferred(address(0), msgSender);
1980     }
1981 
1982     /**
1983      * @dev Returns the address of the current owner.
1984      */
1985     function owner() public view virtual returns (address) {
1986         return _owner;
1987     }
1988 
1989     /**
1990      * @dev Throws if called by any account other than the owner.
1991      */
1992     modifier onlyOwner() {
1993         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1994         _;
1995     }
1996 
1997     /**
1998      * @dev Leaves the contract without owner. It will not be possible to call
1999      * `onlyOwner` functions anymore. Can only be called by the current owner.
2000      *
2001      * NOTE: Renouncing ownership will leave the contract without an owner,
2002      * thereby removing any functionality that is only available to the owner.
2003      */
2004     function renounceOwnership() public virtual onlyOwner {
2005         emit OwnershipTransferred(_owner, address(0));
2006         _owner = address(0);
2007     }
2008 
2009     /**
2010      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2011      * Can only be called by the current owner.
2012      */
2013     function transferOwnership(address newOwner) public virtual onlyOwner {
2014         require(newOwner != address(0), "Ownable: new owner is the zero address");
2015         emit OwnershipTransferred(_owner, newOwner);
2016         _owner = newOwner;
2017     }
2018 }
2019 
2020 // File: contracts/Niftydudes.sol
2021 
2022 
2023 
2024 pragma solidity ^0.7.6;
2025 
2026 
2027 
2028 
2029 
2030 
2031 contract Niftydudes is ERC721, Ownable, Pausable {
2032 
2033     event NameUpdated(uint256 indexed dudeID, string previousName, string newName);
2034     event GeneratorUpdated(string previousArweaveHash, string newArweaveHash, string previousIpfsHash, string newIpfsHash);
2035 
2036     using Counters for Counters.Counter;
2037     using SafeMath for uint;
2038 
2039     string constant arweaveImgHash = "QRz8SYEKUXPl6b13pIKizKb7jji1v95RKmlUGqspuMQ";
2040     string constant ipfsImgHash = "QmNWdHPzZ2qcd1JJXuZZGUzeqExzLfSSMrgJMoNWf1fQgs";
2041 
2042     string arweaveGeneratorHash = "-eEz1VUXZE9EDaEyEe927S_TV53OGBPN4LXobDGkaWA";
2043     string ipfsGeneratorHash = "Qmc4sLXQPVyuGCi71Z2G7ezanhn9NjmyPwxAw2BFaCFsgT";
2044 
2045     uint constant maxSupply = 1024;
2046 
2047     uint constant skinLower = 606;
2048     uint constant beardLower = 536;
2049     uint constant mouthLower = 524;
2050     uint constant hairLower = 426;
2051     uint constant eyeLower = 600;
2052     uint constant shoesLower = 139;
2053     uint constant glassesLower = 199;
2054     uint constant hatsLower = 163;    
2055     uint constant bodytraitsLower = 389;
2056     uint constant dresstopLower = 252;
2057     uint constant dressbottomLower = 336;
2058     uint constant accessoiresLower = 211;  
2059     uint constant leftHandLower = 100;
2060     uint constant rightHandLower = 119;         
2061 
2062     uint constant skinUpper = 623;
2063     uint constant beardUpper = 599;
2064     uint constant mouthUpper = 535;
2065     uint constant hairUpper = 523;
2066     uint constant eyeUpper = 605;
2067     uint constant shoesUpper = 162;  
2068     uint constant glassesUpper = 210;
2069     uint constant hatsUpper = 198;      
2070     uint constant bodytraitsUpper = 425;
2071     uint constant dresstopUpper = 335;
2072     uint constant dressbottomUpper = 388;
2073     uint constant accessoireUpper = 251;    
2074     uint constant leftHandUpper = 118;
2075     uint constant rightHandUpper = 138;      
2076 
2077     uint constant emptyTrait = 999;   
2078 
2079     uint traitCost = 50000000000000000;
2080     uint baseCost = 300000000000000000;
2081 
2082     uint freeTraits = 14;
2083 
2084     mapping (string => bool) private nameAssigned;
2085     mapping (uint => bool) private removedTraitsMap;
2086     mapping (uint => uint) private tokenTraits;
2087     mapping (uint => bool) private existMap;
2088     mapping (uint => string) private dudeNames;
2089 
2090     uint[] private removedTraits;
2091 
2092     Counters.Counter private dudeCounter;
2093 
2094     uint skillBase;
2095     uint skillActivationBlock;
2096 
2097     constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
2098         _setBaseURI("https://niftydudes.com/metadata/");          
2099         _pause();
2100     }
2101 
2102     function purchase(uint[] memory singleTraits, uint[] memory bodyTraits, uint[] memory dresstop, uint[] memory dressbottom, uint[] memory accessoires) external payable {
2103         
2104         require(!paused() || msg.sender == owner(), "Purchases are paused.");
2105         require(singleTraits.length == 10);
2106 
2107         require(singleTraits[0] >= skinLower && singleTraits[0] <= skinUpper && !removedTraitsMap[singleTraits[0]], "At least one of the provided traits does not exist");
2108         require((singleTraits[1] == emptyTrait || singleTraits[1] >= beardLower && singleTraits[1] <= beardUpper) && !removedTraitsMap[singleTraits[1]], "At least one of the provided traits does not exist");
2109         require((singleTraits[2] == emptyTrait || singleTraits[2] >= mouthLower && singleTraits[2] <= mouthUpper) && !removedTraitsMap[singleTraits[2]], "At least one of the provided traits does not exist");
2110         require((singleTraits[3] == emptyTrait || singleTraits[3] >= hairLower && singleTraits[3] <= hairUpper) && !removedTraitsMap[singleTraits[3]], "At least one of the provided traits does not exist");
2111         require((singleTraits[4] == emptyTrait || singleTraits[4] >= eyeLower && singleTraits[4] <= eyeUpper) && !removedTraitsMap[singleTraits[4]], "At least one of the provided traits does not exist");
2112         require((singleTraits[5] == emptyTrait || singleTraits[5] >= hatsLower && singleTraits[5] <= hatsUpper) && !removedTraitsMap[singleTraits[5]], "At least one of the provided traits does not exist");
2113         require((singleTraits[6] == emptyTrait || singleTraits[6] >= glassesLower && singleTraits[6] <= glassesUpper) && !removedTraitsMap[singleTraits[6]], "At least one of the provided traits does not exist");
2114         require((singleTraits[7] == emptyTrait || singleTraits[7] >= leftHandLower && singleTraits[7] <= leftHandUpper) && !removedTraitsMap[singleTraits[7]], "At least one of the provided traits does not exist");
2115         require((singleTraits[8] == emptyTrait || singleTraits[8] >= rightHandLower && singleTraits[8] <= rightHandUpper) && !removedTraitsMap[singleTraits[8]], "At least one of the provided traits does not exist");
2116         require((singleTraits[9] == emptyTrait || singleTraits[9] >= shoesLower && singleTraits[9] <= shoesUpper) && !removedTraitsMap[singleTraits[9]], "At least one of the provided traits does not exist");
2117 
2118         uint numberOfTraits = bodyTraits.length.add(dresstop.length).add(dressbottom.length).add(accessoires.length).add(1);
2119         if(singleTraits[1]!=emptyTrait) numberOfTraits++;
2120         if(singleTraits[2]!=emptyTrait) numberOfTraits++;
2121         if(singleTraits[3]!=emptyTrait) numberOfTraits++;
2122         if(singleTraits[4]!=emptyTrait) numberOfTraits++;
2123         if(singleTraits[5]!=emptyTrait) numberOfTraits++;
2124         if(singleTraits[6]!=emptyTrait) numberOfTraits++;
2125         if(singleTraits[7]!=emptyTrait) numberOfTraits++;
2126         if(singleTraits[8]!=emptyTrait) numberOfTraits++;
2127         if(singleTraits[9]!=emptyTrait) numberOfTraits++;
2128 
2129         uint traitsToBill = 0;
2130         if(numberOfTraits > freeTraits) {
2131             traitsToBill = numberOfTraits.sub(freeTraits);
2132         }
2133 
2134         require((msg.value == baseCost + (traitsToBill * traitCost) || msg.sender == owner()), "ether amount incorrect");
2135         require(numberOfTraits <= 25, "must not provide more than 25 traits");
2136         require(dudeCounter.current() < maxSupply, "all dudes have been minted");
2137 
2138         uint traitCombination = lowLayerSingleCombi(singleTraits[0], singleTraits[1], singleTraits[2], singleTraits[3], singleTraits[4]);
2139         traitCombination = getMultiLayerCombi(traitCombination, bodyTraits, dresstop, dressbottom, accessoires);
2140         traitCombination = upperLayerSingleCombi(traitCombination, singleTraits[5], singleTraits[6], singleTraits[7], singleTraits[8], singleTraits[9]);
2141 
2142         storeNewDude(traitCombination);
2143     }
2144 
2145     function storeNewDude(uint traitCombi) private {
2146         require(!existMap[traitCombi], "dude already exists");
2147         existMap[traitCombi] = true;
2148 
2149         dudeCounter.increment();
2150         uint256 newDudeId = dudeCounter.current();
2151 
2152         tokenTraits[newDudeId] = traitCombi;
2153 
2154         if(newDudeId%2==0) {
2155             uint random = (rngTrait(1, newDudeId) % (skinLower-100)) + 100;
2156             if(!removedTraitsMap[random]) {
2157                 removedTraits.push(random); 
2158             }
2159             removedTraitsMap[random] = true;
2160         }
2161 
2162 
2163         _safeMint(msg.sender, newDudeId);
2164 
2165         if (skillActivationBlock == 0 && newDudeId == maxSupply) {
2166             skillActivationBlock = block.number+2;
2167         }
2168     }
2169 
2170     function lowLayerSingleCombi(uint skin, uint beard, uint mouth, uint hair, uint eye) private pure returns (uint256) {
2171         uint result = skin;
2172 
2173         if(beard != emptyTrait) { result = result.mul(1000).add(beard); }
2174         if(mouth != emptyTrait) { result = result.mul(1000).add(mouth); }        
2175         if(hair != emptyTrait) { result = result.mul(1000).add(hair); }
2176         if(eye != emptyTrait) { result = result.mul(1000).add(eye); }        
2177 
2178         return result;
2179     }
2180 
2181     function getMultiLayerCombi(uint base, uint[] memory bodyTraits, uint[] memory dresstop, uint[] memory dressbottom, uint[] memory accessoires) private view returns (uint256) {
2182         base = base.mul(10**(bodyTraits.length*3)).add(validateAndCalculate(bodyTraits, bodytraitsLower, bodytraitsUpper));
2183         base = base.mul(10**(dresstop.length*3)).add(validateAndCalculate(dresstop,dresstopLower, dresstopUpper));
2184         base = base.mul(10**(dressbottom.length*3)).add(validateAndCalculate(dressbottom,dressbottomLower, dressbottomUpper));
2185         base = base.mul(10**(accessoires.length*3)).add(validateAndCalculate(accessoires,accessoiresLower, accessoireUpper));
2186 
2187         return base;
2188     }
2189 
2190     function upperLayerSingleCombi(uint base, uint hat, uint glasses, uint leftHand, uint rightHand, uint shoes) private pure returns (uint256) {
2191         if(hat != emptyTrait) { base = base.mul(1000).add(hat); }
2192         if(glasses != emptyTrait) { base = base.mul(1000).add(glasses); }
2193         if(shoes != emptyTrait) { base = base.mul(1000).add(shoes); }  
2194         if(leftHand != emptyTrait) { base = base.mul(1000).add(leftHand); }
2195         if(rightHand != emptyTrait) { base = base.mul(1000).add(rightHand); }
2196 
2197         return base;
2198     }
2199 
2200     function validateAndCalculate(uint[] memory traitCollection, uint lower, uint upper) private view returns (uint256) {
2201         uint traitCombi = 0;
2202 
2203         for (uint i=0; i < traitCollection.length; i++) {
2204             require(traitCollection[i] >= lower && traitCollection[i] <= upper, "At least one of the provided traits does not exist");
2205             require(!removedTraitsMap[traitCollection[i]], "At least one of the provided traits is not available anymore");
2206             
2207             bool unique = true;
2208             for(uint j=i+1; j<traitCollection.length; j++) {
2209                 if(traitCollection[j] == traitCollection[i]) {
2210                     unique = false;
2211                 }
2212             }
2213             require(unique, "Each trait can only be applied once");
2214 
2215             traitCombi = traitCombi.mul(1000).add(traitCollection[i]);
2216         }
2217         return traitCombi;
2218     }
2219 
2220     function withdraw() onlyOwner external {
2221         uint balance = address(this).balance;
2222         msg.sender.transfer(balance);
2223     }
2224 
2225     function changePrice(uint _basePrice, uint _traitPrice, uint _freeTraits) external onlyOwner {
2226         baseCost = _basePrice;
2227         traitCost = _traitPrice;
2228         freeTraits = _freeTraits;
2229     }
2230 
2231     function setBaseURI(string memory baseURI) external onlyOwner {
2232         _setBaseURI(baseURI);
2233     }
2234 
2235     function rngTrait(uint nonce, uint id) private view returns (uint) {
2236         return uint(keccak256(abi.encodePacked(nonce, id, block.timestamp, block.difficulty, blockhash(block.number-1))));
2237     }
2238 
2239     function rngSkills(uint nonce, uint id) private view returns (uint) {
2240         return uint(keccak256(abi.encodePacked(skillBase, nonce, id)));
2241     }
2242 
2243     function getRemovedTraits() external view returns (uint[] memory) {
2244         return removedTraits;
2245     }
2246 
2247     function getTraits(uint256 tokenId) external view returns (uint) {
2248         require(_exists(tokenId), "nonexistent token");
2249         return tokenTraits[tokenId];
2250     }
2251 
2252     function setGeneratorHashes(string memory newArweave, string memory newIpfs) external onlyOwner {
2253         string memory prevArweave = arweaveGeneratorHash;
2254         string memory prevIpfs = ipfsGeneratorHash;
2255 
2256         arweaveGeneratorHash = newArweave;
2257         ipfsGeneratorHash = newIpfs;
2258 
2259         emit GeneratorUpdated(prevArweave, newArweave, prevIpfs, newIpfs);
2260     }
2261 
2262     function getArweaveImgHash() external pure returns (string memory) {
2263         return arweaveImgHash;
2264     }
2265 
2266     function getIpfsImgHash() external pure returns (string memory) {
2267         return ipfsImgHash;
2268     }
2269 
2270     function getArweaveGeneratorHash() external view returns (string memory) {
2271         return arweaveGeneratorHash;
2272     }
2273 
2274     function getIpfsGeneratorHash() external view returns (string memory) {
2275         return ipfsGeneratorHash;
2276     }    
2277 
2278     function isUnique(uint traitCombi) external view returns (bool) {
2279         return !existMap[traitCombi];
2280     }    
2281 
2282     function shuffle(uint[] memory a, uint id) private view returns (uint[] memory){
2283         uint j;
2284         uint x;
2285 
2286         for (uint i = 5; i > 0; i--) {
2287             j = rngSkills(i, id) % (i + 1);
2288             x = a[i];
2289             a[i] = a[j];
2290             a[j] = x;
2291         }
2292         return a;
2293     }
2294 
2295     function getSkills(uint256 tokenId) external view returns (uint, uint, uint, uint, uint, uint) {
2296         require(_exists(tokenId), "nonexistent token");
2297 
2298         if(skillBase == 0) {
2299             return (0,0,0,0,0,0);
2300         } else {
2301             uint remainingSkills = 0;
2302 
2303             uint randDudeBase = rngSkills(1, tokenId);
2304 
2305             if(randDudeBase % maxSupply == 512) {
2306                 remainingSkills = (rngSkills(2, tokenId) % 50) + 550;
2307             } else if(randDudeBase % maxSupply < 8) {
2308                 remainingSkills = (rngSkills(2, tokenId) % 50) + 500;
2309             } else if((randDudeBase % maxSupply) + 8 < 40) {
2310                 remainingSkills = (rngSkills(2, tokenId) % 100) + 400;
2311             } else if(randDudeBase % maxSupply > 895) {
2312                 remainingSkills = (rngSkills(2, tokenId) % 100) + 300;
2313             } else {
2314                 remainingSkills = (rngSkills(2, tokenId) % 100) + 200;
2315             }
2316             uint diff=0;
2317             
2318             uint[] memory skillArray = new uint[](6);
2319 
2320             if(remainingSkills > 500) {
2321                 diff = remainingSkills-500;
2322                 skillArray[0] = (rngSkills(3, tokenId) % (101-diff)) + diff;
2323             } else {
2324                 skillArray[0] = rngSkills(3, tokenId) % 101;
2325             }
2326             remainingSkills -= skillArray[0];
2327 
2328             if(remainingSkills > 400) {
2329                 diff = remainingSkills-400;
2330                 skillArray[1] = (rngSkills(4, tokenId) % (101-diff)) + diff;
2331             } else {
2332                 skillArray[1] = rngSkills(4, tokenId) % (remainingSkills > 100 ? 101 : (remainingSkills + 1));
2333             }
2334             remainingSkills -= skillArray[1];
2335 
2336             if(remainingSkills > 300) {
2337                 diff = remainingSkills-300;
2338                 skillArray[2] = (rngSkills(5, tokenId) % (101-diff)) + diff;
2339             } else {
2340                 skillArray[2] = rngSkills(5, tokenId) % (remainingSkills > 100 ? 101 : (remainingSkills + 1));
2341             }
2342             remainingSkills -= skillArray[2];
2343 
2344             if(remainingSkills > 200) {
2345                 diff = remainingSkills-200;
2346                 skillArray[3] = (rngSkills(6, tokenId) % (101-diff)) + diff;
2347             } else {
2348                 skillArray[3] = rngSkills(6, tokenId) % (remainingSkills > 100 ? 101 : (remainingSkills + 1));
2349             }
2350             remainingSkills -= skillArray[3];
2351 
2352             if(remainingSkills > 100) {
2353                 diff = remainingSkills-100;
2354                 skillArray[4] = (rngSkills(7, tokenId) % (101-diff)) + diff;
2355             } else {
2356                 skillArray[4] = rngSkills(7, tokenId) % (remainingSkills > 100 ? 101 : (remainingSkills + 1));
2357             }
2358             remainingSkills -= skillArray[4];
2359 
2360             skillArray[5] = remainingSkills;
2361 
2362             skillArray = shuffle(skillArray, tokenId);
2363 
2364             return (skillArray[0], skillArray[1], skillArray[2], skillArray[3], skillArray[4], skillArray[5] );
2365         }
2366     }    
2367 
2368     function pauseMinting() external onlyOwner {
2369         _pause();
2370     }
2371 
2372     function unpauseMinting() external onlyOwner {
2373         _unpause();
2374     }    
2375 
2376     function activateSkills() external {
2377         require(skillBase == 0, "skill base is already set");
2378         require(skillActivationBlock != 0, "skill activation block must be set");
2379         require(block.number > skillActivationBlock, "block number too small");
2380 
2381         skillBase = uint(blockhash(skillActivationBlock));
2382 
2383         if (block.number.sub(skillActivationBlock) > 255) {
2384             skillBase = uint(blockhash(block.number-1));
2385         }
2386     }
2387 
2388     function getName(uint256 tokenID) external view returns (string memory) {
2389         require(_exists(tokenID), "nonexistent token");
2390         return dudeNames[tokenID];
2391     }
2392 
2393     function updateName(uint256 tokenID, string memory newName) external returns (string memory) {
2394         require(_exists(tokenID), "nonexistent token");
2395         require(sha256(bytes(newName)) != sha256(bytes(dudeNames[tokenID])), "New name and old name are equal");
2396         require(_isApprovedOrOwner(_msgSender(), tokenID), "caller is not owner nor approved");
2397         require(isNameAllowed(newName), "name is not allowed");
2398         require(!isNameReserved(newName), "Name already reserved");
2399 
2400         string memory prevName = dudeNames[tokenID];
2401 
2402         if (bytes(dudeNames[tokenID]).length > 0) {
2403             toggleAssignName(dudeNames[tokenID], false);
2404         }
2405         toggleAssignName(newName, true);
2406 
2407         dudeNames[tokenID] = newName;
2408 
2409         emit NameUpdated(tokenID, prevName, newName);
2410 
2411         return prevName;
2412     }
2413 
2414     function toggleAssignName(string memory str, bool isReserve) private {
2415         nameAssigned[toLower(str)] = isReserve;
2416     }
2417 
2418     function isNameReserved(string memory nameString) public view returns (bool) {
2419         return nameAssigned[toLower(nameString)];
2420     }
2421 
2422     function isNameAllowed(string memory newName) public pure returns (bool) {
2423         bytes memory byteName = bytes(newName);
2424         if(byteName.length < 1 || byteName.length > 25) return false;
2425         if(byteName[0] == 0x20 || byteName[byteName.length - 1] == 0x20) return false; // reject leading and trailing space
2426 
2427         bytes1 lastChar = byteName[0];
2428 
2429         for(uint i; i < byteName.length; i++){
2430             bytes1 currentChar = byteName[i];
2431 
2432             if (currentChar == 0x20 && lastChar == 0x20) return false; // reject double spaces
2433 
2434             if(
2435                 !(currentChar >= 0x30 && currentChar <= 0x39) && //9-0
2436                 !(currentChar >= 0x41 && currentChar <= 0x5A) && //A-Z
2437                 !(currentChar >= 0x61 && currentChar <= 0x7A) && //a-z
2438                 !(currentChar == 0x20) //space
2439             )
2440                 return false;
2441 
2442             lastChar = currentChar;
2443         }
2444 
2445         return true;
2446     }
2447 
2448     function toLower(string memory str) private pure returns (string memory){
2449         bytes memory bStr = bytes(str);
2450         bytes memory bLower = new bytes(bStr.length);
2451         for (uint i = 0; i < bStr.length; i++) {
2452             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
2453                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
2454             } else {
2455                 bLower[i] = bStr[i];
2456             }
2457         }
2458         return string(bLower);
2459     }
2460  }