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
735 // File: @openzeppelin/contracts/utils/Strings.sol
736 
737 
738 
739 pragma solidity >=0.6.0 <0.8.0;
740 
741 /**
742  * @dev String operations.
743  */
744 library Strings {
745     /**
746      * @dev Converts a `uint256` to its ASCII `string` representation.
747      */
748     function toString(uint256 value) internal pure returns (string memory) {
749         // Inspired by OraclizeAPI's implementation - MIT licence
750         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
751 
752         if (value == 0) {
753             return "0";
754         }
755         uint256 temp = value;
756         uint256 digits;
757         while (temp != 0) {
758             digits++;
759             temp /= 10;
760         }
761         bytes memory buffer = new bytes(digits);
762         uint256 index = digits - 1;
763         temp = value;
764         while (temp != 0) {
765             buffer[index--] = bytes1(uint8(48 + temp % 10));
766             temp /= 10;
767         }
768         return string(buffer);
769     }
770 }
771 
772 // File: contracts/ERC721A.sol
773 
774 // Creator: Chiru Labs
775 
776 pragma solidity >=0.6.0 <0.8.0;
777 
778 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
779 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
780 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
781 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
782 // import "@openzeppelin/contracts/utils/Address.sol";
783 // import "@openzeppelin/contracts/utils/Context.sol";
784 // import "@openzeppelin/contracts/utils/Strings.sol";
785 // import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
790  *
791  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
792  *
793  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
794  *
795  * Does not support burning tokens to address(0).
796  */
797 contract ERC721A is
798   Context,
799   ERC165,
800   IERC721,
801   IERC721Metadata,
802   IERC721Enumerable
803 {
804   using SafeMath for uint256;
805   using Address for address;
806   using Strings for uint256;
807 
808   struct TokenOwnership {
809     address addr;
810     uint64 startTimestamp;
811   }
812 
813   struct AddressData {
814     uint128 balance;
815     uint128 numberMinted;
816   }
817 
818   uint256 private currentIndex = 0;
819 
820   uint256 internal immutable collectionSize;
821   uint256 internal immutable maxBatchSize;
822 
823   // Token name
824   string private _name;
825 
826   // Token symbol
827   string private _symbol;
828 
829   // Mapping from token ID to ownership details
830   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
831   mapping(uint256 => TokenOwnership) private _ownerships;
832 
833   // Mapping owner address to address data
834   mapping(address => AddressData) private _addressData;
835 
836   // Mapping from token ID to approved address
837   mapping(uint256 => address) private _tokenApprovals;
838 
839   // Mapping from owner to operator approvals
840   mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842   /**
843    * @dev
844    * `maxBatchSize` refers to how much a minter can mint at a time.
845    * `collectionSize_` refers to how many tokens are in the collection.
846    */
847   constructor(
848     string memory name_,
849     string memory symbol_,
850     uint256 maxBatchSize_,
851     uint256 collectionSize_
852   ) {
853     require(
854       collectionSize_ > 0,
855       "ERC721A: collection must have a nonzero supply"
856     );
857     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
858     _name = name_;
859     _symbol = symbol_;
860     maxBatchSize = maxBatchSize_;
861     collectionSize = collectionSize_;
862   }
863 
864   /**
865    * @dev See {IERC721Enumerable-totalSupply}.
866    */
867   function totalSupply() public view override returns (uint256) {
868     return currentIndex;
869   }
870 
871   /**
872    * @dev See {IERC721Enumerable-tokenByIndex}.
873    */
874   function tokenByIndex(uint256 index) public view override returns (uint256) {
875     require(index < totalSupply(), "ERC721A: global index out of bounds");
876     return index;
877   }
878 
879   /**
880    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
881    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
882    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
883    */
884   function tokenOfOwnerByIndex(address owner, uint256 index)
885     public
886     view
887     override
888     returns (uint256)
889   {
890     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
891     uint256 numMintedSoFar = totalSupply();
892     uint256 tokenIdsIdx = 0;
893     address currOwnershipAddr = address(0);
894     for (uint256 i = 0; i < numMintedSoFar; i++) {
895       TokenOwnership memory ownership = _ownerships[i];
896       if (ownership.addr != address(0)) {
897         currOwnershipAddr = ownership.addr;
898       }
899       if (currOwnershipAddr == owner) {
900         if (tokenIdsIdx == index) {
901           return i;
902         }
903         tokenIdsIdx++;
904       }
905     }
906     revert("ERC721A: unable to get token of owner by index");
907   }
908 
909   /**
910    * @dev See {IERC165-supportsInterface}.
911    */
912   function supportsInterface(bytes4 interfaceId)
913     public
914     view
915     virtual
916     override(ERC165, IERC165)
917     returns (bool)
918   {
919     return
920       interfaceId == type(IERC721).interfaceId ||
921       interfaceId == type(IERC721Metadata).interfaceId ||
922       interfaceId == type(IERC721Enumerable).interfaceId ||
923       super.supportsInterface(interfaceId);
924   }
925 
926   /**
927    * @dev See {IERC721-balanceOf}.
928    */
929   function balanceOf(address owner) public view override returns (uint256) {
930     require(owner != address(0), "ERC721A: balance query for the zero address");
931     return uint256(_addressData[owner].balance);
932   }
933 
934   function _numberMinted(address owner) internal view returns (uint256) {
935     require(
936       owner != address(0),
937       "ERC721A: number minted query for the zero address"
938     );
939     return uint256(_addressData[owner].numberMinted);
940   }
941 
942   function ownershipOf(uint256 tokenId)
943     internal
944     view
945     returns (TokenOwnership memory)
946   {
947     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
948 
949     uint256 lowestTokenToCheck;
950     if (tokenId >= maxBatchSize) {
951       lowestTokenToCheck = tokenId - maxBatchSize + 1;
952     }
953 
954     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
955       TokenOwnership memory ownership = _ownerships[curr];
956       if (ownership.addr != address(0)) {
957         return ownership;
958       }
959     }
960 
961     revert("ERC721A: unable to determine the owner of token");
962   }
963 
964   /**
965    * @dev See {IERC721-ownerOf}.
966    */
967   function ownerOf(uint256 tokenId) public view override returns (address) {
968     return ownershipOf(tokenId).addr;
969   }
970 
971   /**
972    * @dev See {IERC721Metadata-name}.
973    */
974   function name() public view virtual override returns (string memory) {
975     return _name;
976   }
977 
978   /**
979    * @dev See {IERC721Metadata-symbol}.
980    */
981   function symbol() public view virtual override returns (string memory) {
982     return _symbol;
983   }
984 
985   /**
986    * @dev See {IERC721Metadata-tokenURI}.
987    */
988   function tokenURI(uint256 tokenId)
989     public
990     view
991     virtual
992     override
993     returns (string memory)
994   {
995     require(
996       _exists(tokenId),
997       "ERC721Metadata: URI query for nonexistent token"
998     );
999 
1000     string memory baseURI = _baseURI();
1001     return
1002       bytes(baseURI).length > 0
1003         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1004         : "";
1005   }
1006 
1007   /**
1008    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1009    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1010    * by default, can be overriden in child contracts.
1011    */
1012   function _baseURI() internal view virtual returns (string memory) {
1013     return "";
1014   }
1015 
1016   /**
1017    * @dev See {IERC721-approve}.
1018    */
1019   function approve(address to, uint256 tokenId) public override {
1020     address owner = ERC721A.ownerOf(tokenId);
1021     require(to != owner, "ERC721A: approval to current owner");
1022 
1023     require(
1024       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1025       "ERC721A: approve caller is not owner nor approved for all"
1026     );
1027 
1028     _approve(to, tokenId, owner);
1029   }
1030 
1031   /**
1032    * @dev See {IERC721-getApproved}.
1033    */
1034   function getApproved(uint256 tokenId) public view override returns (address) {
1035     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1036 
1037     return _tokenApprovals[tokenId];
1038   }
1039 
1040   /**
1041    * @dev See {IERC721-setApprovalForAll}.
1042    */
1043   function setApprovalForAll(address operator, bool approved) public override {
1044     require(operator != _msgSender(), "ERC721A: approve to caller");
1045 
1046     _operatorApprovals[_msgSender()][operator] = approved;
1047     emit ApprovalForAll(_msgSender(), operator, approved);
1048   }
1049 
1050   /**
1051    * @dev See {IERC721-isApprovedForAll}.
1052    */
1053   function isApprovedForAll(address owner, address operator)
1054     public
1055     view
1056     virtual
1057     override
1058     returns (bool)
1059   {
1060     return _operatorApprovals[owner][operator];
1061   }
1062 
1063   /**
1064    * @dev See {IERC721-transferFrom}.
1065    */
1066   function transferFrom(
1067     address from,
1068     address to,
1069     uint256 tokenId
1070   ) public override {
1071     _transfer(from, to, tokenId);
1072   }
1073 
1074   /**
1075    * @dev See {IERC721-safeTransferFrom}.
1076    */
1077   function safeTransferFrom(
1078     address from,
1079     address to,
1080     uint256 tokenId
1081   ) public override {
1082     safeTransferFrom(from, to, tokenId, "");
1083   }
1084 
1085   /**
1086    * @dev See {IERC721-safeTransferFrom}.
1087    */
1088   function safeTransferFrom(
1089     address from,
1090     address to,
1091     uint256 tokenId,
1092     bytes memory _data
1093   ) public override {
1094     _transfer(from, to, tokenId);
1095     require(
1096       _checkOnERC721Received(from, to, tokenId, _data),
1097       "ERC721A: transfer to non ERC721Receiver implementer"
1098     );
1099   }
1100 
1101   /**
1102    * @dev Returns whether `tokenId` exists.
1103    *
1104    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1105    *
1106    * Tokens start existing when they are minted (`_mint`),
1107    */
1108   function _exists(uint256 tokenId) internal view returns (bool) {
1109     return tokenId < currentIndex;
1110   }
1111 
1112   function _safeMint(address to, uint256 quantity) internal {
1113     _safeMint(to, quantity, "");
1114   }
1115 
1116   /**
1117    * @dev Mints `quantity` tokens and transfers them to `to`.
1118    *
1119    * Requirements:
1120    *
1121    * - there must be `quantity` tokens remaining unminted in the total collection.
1122    * - `to` cannot be the zero address.
1123    * - `quantity` cannot be larger than the max batch size.
1124    *
1125    * Emits a {Transfer} event.
1126    */
1127   function _safeMint(
1128     address to,
1129     uint256 quantity,
1130     bytes memory _data
1131   ) internal {
1132     uint256 startTokenId = currentIndex;
1133     require(to != address(0), "ERC721A: mint to the zero address");
1134     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1135     require(!_exists(startTokenId), "ERC721A: token already minted");
1136     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1137 
1138     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1139 
1140     AddressData memory addressData = _addressData[to];
1141     _addressData[to] = AddressData(
1142       addressData.balance + uint128(quantity),
1143       addressData.numberMinted + uint128(quantity)
1144     );
1145     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1146 
1147     uint256 updatedIndex = startTokenId;
1148 
1149     for (uint256 i = 0; i < quantity; i++) {
1150       emit Transfer(address(0), to, updatedIndex);
1151       require(
1152         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1153         "ERC721A: transfer to non ERC721Receiver implementer"
1154       );
1155       updatedIndex++;
1156     }
1157 
1158     currentIndex = updatedIndex;
1159     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160   }
1161 
1162   /**
1163    * @dev Transfers `tokenId` from `from` to `to`.
1164    *
1165    * Requirements:
1166    *
1167    * - `to` cannot be the zero address.
1168    * - `tokenId` token must be owned by `from`.
1169    *
1170    * Emits a {Transfer} event.
1171    */
1172   function _transfer(
1173     address from,
1174     address to,
1175     uint256 tokenId
1176   ) private {
1177     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1178 
1179     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1180       getApproved(tokenId) == _msgSender() ||
1181       isApprovedForAll(prevOwnership.addr, _msgSender()));
1182 
1183     require(
1184       isApprovedOrOwner,
1185       "ERC721A: transfer caller is not owner nor approved"
1186     );
1187 
1188     require(
1189       prevOwnership.addr == from,
1190       "ERC721A: transfer from incorrect owner"
1191     );
1192     require(to != address(0), "ERC721A: transfer to the zero address");
1193 
1194     _beforeTokenTransfers(from, to, tokenId, 1);
1195 
1196     // Clear approvals from the previous owner
1197     _approve(address(0), tokenId, prevOwnership.addr);
1198 
1199     _addressData[from].balance -= 1;
1200     _addressData[to].balance += 1;
1201     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1202 
1203     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1204     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205     uint256 nextTokenId = tokenId + 1;
1206     if (_ownerships[nextTokenId].addr == address(0)) {
1207       if (_exists(nextTokenId)) {
1208         _ownerships[nextTokenId] = TokenOwnership(
1209           prevOwnership.addr,
1210           prevOwnership.startTimestamp
1211         );
1212       }
1213     }
1214 
1215     emit Transfer(from, to, tokenId);
1216     _afterTokenTransfers(from, to, tokenId, 1);
1217   }
1218 
1219   /**
1220    * @dev Approve `to` to operate on `tokenId`
1221    *
1222    * Emits a {Approval} event.
1223    */
1224   function _approve(
1225     address to,
1226     uint256 tokenId,
1227     address owner
1228   ) private {
1229     _tokenApprovals[tokenId] = to;
1230     emit Approval(owner, to, tokenId);
1231   }
1232 
1233   uint256 public nextOwnerToExplicitlySet = 0;
1234 
1235   /**
1236    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1237    */
1238   function _setOwnersExplicit(uint256 quantity) internal {
1239     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1240     require(quantity > 0, "quantity must be nonzero");
1241     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1242     if (endIndex > collectionSize - 1) {
1243       endIndex = collectionSize - 1;
1244     }
1245     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1246     require(_exists(endIndex), "not enough minted yet for this cleanup");
1247     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1248       if (_ownerships[i].addr == address(0)) {
1249         TokenOwnership memory ownership = ownershipOf(i);
1250         _ownerships[i] = TokenOwnership(
1251           ownership.addr,
1252           ownership.startTimestamp
1253         );
1254       }
1255     }
1256     nextOwnerToExplicitlySet = endIndex + 1;
1257   }
1258 
1259   /**
1260    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1261    * The call is not executed if the target address is not a contract.
1262    *
1263    * @param from address representing the previous owner of the given token ID
1264    * @param to target address that will receive the tokens
1265    * @param tokenId uint256 ID of the token to be transferred
1266    * @param _data bytes optional data to send along with the call
1267    * @return bool whether the call correctly returned the expected magic value
1268    */
1269   function _checkOnERC721Received(
1270     address from,
1271     address to,
1272     uint256 tokenId,
1273     bytes memory _data
1274   ) private returns (bool) {
1275     if (to.isContract()) {
1276       try
1277         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1278       returns (bytes4 retval) {
1279         return retval == IERC721Receiver(to).onERC721Received.selector;
1280       } catch (bytes memory reason) {
1281         if (reason.length == 0) {
1282           revert("ERC721A: transfer to non ERC721Receiver implementer");
1283         } else {
1284           assembly {
1285             revert(add(32, reason), mload(reason))
1286           }
1287         }
1288       }
1289     } else {
1290       return true;
1291     }
1292   }
1293 
1294   /**
1295    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1296    *
1297    * startTokenId - the first token id to be transferred
1298    * quantity - the amount to be transferred
1299    *
1300    * Calling conditions:
1301    *
1302    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1303    * transferred to `to`.
1304    * - When `from` is zero, `tokenId` will be minted for `to`.
1305    */
1306   function _beforeTokenTransfers(
1307     address from,
1308     address to,
1309     uint256 startTokenId,
1310     uint256 quantity
1311   ) internal virtual {}
1312 
1313   /**
1314    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1315    * minting.
1316    *
1317    * startTokenId - the first token id to be transferred
1318    * quantity - the amount to be transferred
1319    *
1320    * Calling conditions:
1321    *
1322    * - when `from` and `to` are both non-zero.
1323    * - `from` and `to` are never both zero.
1324    */
1325   function _afterTokenTransfers(
1326     address from,
1327     address to,
1328     uint256 startTokenId,
1329     uint256 quantity
1330   ) internal virtual {}
1331 }
1332 
1333 // File: @openzeppelin/contracts/access/Ownable.sol
1334 
1335 
1336 
1337 pragma solidity >=0.6.0 <0.8.0;
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1355 
1356     /**
1357      * @dev Initializes the contract setting the deployer as the initial owner.
1358      */
1359     constructor () internal {
1360         address msgSender = _msgSender();
1361         _owner = msgSender;
1362         emit OwnershipTransferred(address(0), msgSender);
1363     }
1364 
1365     /**
1366      * @dev Returns the address of the current owner.
1367      */
1368     function owner() public view virtual returns (address) {
1369         return _owner;
1370     }
1371 
1372     /**
1373      * @dev Throws if called by any account other than the owner.
1374      */
1375     modifier onlyOwner() {
1376         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1377         _;
1378     }
1379 
1380     /**
1381      * @dev Leaves the contract without owner. It will not be possible to call
1382      * `onlyOwner` functions anymore. Can only be called by the current owner.
1383      *
1384      * NOTE: Renouncing ownership will leave the contract without an owner,
1385      * thereby removing any functionality that is only available to the owner.
1386      */
1387     function renounceOwnership() public virtual onlyOwner {
1388         emit OwnershipTransferred(_owner, address(0));
1389         _owner = address(0);
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(newOwner != address(0), "Ownable: new owner is the zero address");
1398         emit OwnershipTransferred(_owner, newOwner);
1399         _owner = newOwner;
1400     }
1401 }
1402 
1403 
1404 // File: contracts/WorldOfDypians.sol
1405 
1406 
1407 pragma solidity ^0.7.0;
1408 
1409 interface StakeContract {
1410     function calculateReward(address account, uint256 tokenId)  external view returns (uint256);
1411 }
1412 
1413 interface CawsContract {
1414     function ownerOf(uint256 tokenId) external view returns (address);
1415 }
1416 
1417 /**
1418  * @title WorldOfDypians contract
1419  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1420  */
1421 contract WorldOfDypians is ERC721A, Ownable {
1422     using SafeMath for uint256;
1423 
1424     string public WOD_PROVENANCE = "";
1425 
1426     string public baseURI;
1427 
1428     uint256 public startingIndexBlock;
1429 
1430     uint256 public startingIndex;
1431 
1432     uint256 public constant landPrice = 720000000000000000; //0.72 ETH
1433 
1434     uint256 public constant LandPriceDiscount = 580000000000000000; //0.58 ETH
1435     
1436     uint public constant maxLandPurchase = 10;
1437 
1438     uint256 public MAX_WOD;
1439 
1440     uint256 public MAX_MINT = 999;
1441 
1442     bool public saleIsActive = false;
1443 
1444     uint256 public REVEAL_TIMESTAMP;
1445 
1446     CawsContract public cawsContract;
1447     StakeContract public stakeContract;
1448 
1449     // Mapping to keep track of CAWS token IDs that have been used to mint a new NFT
1450     mapping (uint256 => bool) public cawsUsed;
1451 
1452     constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart) ERC721A(name, symbol, maxLandPurchase, maxNftSupply) {
1453         MAX_WOD = maxNftSupply;
1454         REVEAL_TIMESTAMP = saleStart + (86400 * 13);
1455 
1456         cawsContract = CawsContract(0xd06cF9e1189FEAb09c844C597abc3767BC12608c);
1457         stakeContract = StakeContract(0xEe425BbbEC5e9Bf4a59a1c19eFff522AD8b7A47A);
1458     }
1459 
1460     function withdraw() public onlyOwner {
1461         uint balance = address(this).balance;
1462         msg.sender.transfer(balance);
1463     }
1464 
1465     /**
1466      * Mint the rest of WOD
1467      */
1468     function reserveWod(uint numberOfTokens) public onlyOwner {
1469         require(numberOfTokens > 0, "Mint at least 1 NFT");
1470         // require(totalSupply() >= 999, "Genesis Mint is not Finished");
1471         require(totalSupply().add(numberOfTokens) <= MAX_WOD, "Mint would exceed max WOD Lands");
1472         
1473         _safeMint(msg.sender, numberOfTokens);
1474     }
1475 
1476     /**
1477      * Set Reveal Timestamp.
1478      */
1479     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1480         REVEAL_TIMESTAMP = revealTimeStamp;
1481     } 
1482 
1483     /*     
1484     * Set provenance once it's calculated
1485     */
1486     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1487         WOD_PROVENANCE = provenanceHash;
1488     }
1489 
1490     function _baseURI() internal view virtual override returns (string memory) {
1491         return baseURI;
1492     }
1493 
1494     function setBaseURI(string calldata tokenURI) external onlyOwner {
1495         baseURI = tokenURI;
1496     }
1497 
1498     /*
1499     * Pause sale if active, make active if paused
1500     */
1501     function flipSaleState() public onlyOwner {
1502         saleIsActive = !saleIsActive;
1503     }
1504 
1505     /**
1506     * Mints WOD
1507     */
1508     function mintWodGenesis(uint numberOfTokens, uint[] calldata tokenIds) public payable {
1509         require(saleIsActive, "Sale must be active to mint WOD");
1510         require(numberOfTokens <= maxLandPurchase, "Can only mint 10 tokens at a time");
1511         require(numberOfTokens > 0, "Mint at least 1 NFT");
1512         require(totalSupply().add(numberOfTokens) <= MAX_MINT, "Purchase would exceed max Genesis Lands");
1513 
1514         require(tokenIds.length <= numberOfTokens, "Cannot provide more than 10 CAWS");
1515 
1516         uint countDiscount = 0;
1517 
1518         if (tokenIds.length != 0) {
1519             for (uint i = 0; i < tokenIds.length; i++) {
1520 
1521                 if (cawsUsed[tokenIds[i]] != true) {
1522                     //Check if user is ownerOf Caws
1523                     if (cawsContract.ownerOf(tokenIds[i]) == msg.sender) {
1524                         cawsUsed[tokenIds[i]] = true;
1525                         countDiscount++;
1526                         continue;
1527                     }
1528 
1529                     //Check if user has deposited Caws in Staking
1530                     if (stakeContract.calculateReward(msg.sender, tokenIds[i]) > 0) {
1531                         cawsUsed[tokenIds[i]] = true;
1532                         countDiscount++;
1533                     }
1534                 }
1535             }
1536         }
1537 
1538         if (countDiscount != 0) {
1539             require(LandPriceDiscount.mul(countDiscount).add(landPrice.mul(numberOfTokens.sub(countDiscount))) <= msg.value, "Ether value sent is not correct");
1540         } else {
1541             require(landPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1542         }
1543 
1544         _safeMint(msg.sender, numberOfTokens);
1545 
1546         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
1547         // the end of pre-sale, set the starting index block
1548         if (startingIndexBlock == 0 && (totalSupply() == MAX_WOD || block.timestamp >= REVEAL_TIMESTAMP)) {
1549             startingIndexBlock = block.number;
1550         } 
1551     }
1552 
1553     /**
1554      * Set the starting index for the collection
1555      */
1556     function setStartingIndex() public {
1557         require(startingIndex == 0, "Starting index is already set");
1558         require(startingIndexBlock != 0, "Starting index block must be set");
1559         
1560         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_WOD;
1561         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1562         if (block.number.sub(startingIndexBlock) > 255) {
1563             startingIndex = uint(blockhash(block.number - 1)) % MAX_WOD;
1564         }
1565         // Prevent default sequence
1566         if (startingIndex == 0) {
1567             startingIndex = startingIndex.add(1);
1568         }
1569     }
1570 
1571     /**
1572      * Set the starting index block for the collection, essentially unblocking
1573      * setting starting index
1574      */
1575     function emergencySetStartingIndexBlock() public onlyOwner {
1576         require(startingIndex == 0, "Starting index is already set");
1577         
1578         startingIndexBlock = block.number;
1579     }
1580 }