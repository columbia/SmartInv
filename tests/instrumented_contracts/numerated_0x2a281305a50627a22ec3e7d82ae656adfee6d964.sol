1 // SPDX-License-Identifier: MIT
2  
3 // File: @openzeppelin/contracts/utils/Context.sol
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
1347 /**
1348  * @title ERC721 Non-Fungible Token Standard basic implementation
1349  * @dev see https://eips.ethereum.org/EIPS/eip-721
1350  */
1351  
1352 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1353     using SafeMath for uint256;
1354     using Address for address;
1355     using EnumerableSet for EnumerableSet.UintSet;
1356     using EnumerableMap for EnumerableMap.UintToAddressMap;
1357     using Strings for uint256;
1358 
1359     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1360     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1361     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1362 
1363     // Mapping from holder address to their (enumerable) set of owned tokens
1364     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1365 
1366     // Enumerable mapping from token ids to their owners
1367     EnumerableMap.UintToAddressMap private _tokenOwners;
1368 
1369     // Mapping from token ID to approved address
1370     mapping (uint256 => address) private _tokenApprovals;
1371 
1372     // Mapping from owner to operator approvals
1373     mapping (address => mapping (address => bool)) private _operatorApprovals;
1374 
1375     // Token name
1376     string private _name;
1377 
1378     // Token symbol
1379     string private _symbol;
1380 
1381     // Optional mapping for token URIs
1382     mapping (uint256 => string) private _tokenURIs;
1383 
1384     // Base URI
1385     string private _baseURI;
1386 
1387     /*
1388      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1389      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1390      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1391      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1392      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1393      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1394      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1395      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1396      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1397      *
1398      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1399      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1400      */
1401     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1402 
1403     /*
1404      *     bytes4(keccak256('name()')) == 0x06fdde03
1405      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1406      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1407      *
1408      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1409      */
1410     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1411 
1412     /*
1413      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1414      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1415      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1416      *
1417      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1418      */
1419     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1420 
1421     /**
1422      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1423      */
1424     constructor (string memory name_, string memory symbol_) public {
1425         _name = name_;
1426         _symbol = symbol_;
1427 
1428         // register the supported interfaces to conform to ERC721 via ERC165
1429         _registerInterface(_INTERFACE_ID_ERC721);
1430         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1431         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-balanceOf}.
1436      */
1437     function balanceOf(address owner) public view virtual override returns (uint256) {
1438         require(owner != address(0), "ERC721: balance query for the zero address");
1439         return _holderTokens[owner].length();
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-ownerOf}.
1444      */
1445     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1446         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Metadata-name}.
1451      */
1452     function name() public view virtual override returns (string memory) {
1453         return _name;
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Metadata-symbol}.
1458      */
1459     function symbol() public view virtual override returns (string memory) {
1460         return _symbol;
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Metadata-tokenURI}.
1465      */
1466     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1467         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1468 
1469         string memory _tokenURI = _tokenURIs[tokenId];
1470         string memory base = baseURI();
1471 
1472         // If there is no base URI, return the token URI.
1473         if (bytes(base).length == 0) {
1474             return _tokenURI;
1475         }
1476         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1477         if (bytes(_tokenURI).length > 0) {
1478             return string(abi.encodePacked(base, _tokenURI));
1479         }
1480         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1481         return string(abi.encodePacked(base, tokenId.toString()));
1482     }
1483 
1484     /**
1485     * @dev Returns the base URI set via {_setBaseURI}. This will be
1486     * automatically added as a prefix in {tokenURI} to each token's URI, or
1487     * to the token ID if no specific URI is set for that token ID.
1488     */
1489     function baseURI() public view virtual returns (string memory) {
1490         return _baseURI;
1491     }
1492 
1493     /**
1494      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1495      */
1496     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1497         return _holderTokens[owner].at(index);
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-totalSupply}.
1502      */
1503     function totalSupply() public view virtual override returns (uint256) {
1504         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1505         return _tokenOwners.length();
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Enumerable-tokenByIndex}.
1510      */
1511     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1512         (uint256 tokenId, ) = _tokenOwners.at(index);
1513         return tokenId;
1514     }
1515 
1516     /**
1517      * @dev See {IERC721-approve}.
1518      */
1519     function approve(address to, uint256 tokenId) public virtual override {
1520         address owner = ERC721.ownerOf(tokenId);
1521         require(to != owner, "ERC721: approval to current owner");
1522 
1523         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1524             "ERC721: approve caller is not owner nor approved for all"
1525         );
1526 
1527         _approve(to, tokenId);
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-getApproved}.
1532      */
1533     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1534         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1535 
1536         return _tokenApprovals[tokenId];
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-setApprovalForAll}.
1541      */
1542     function setApprovalForAll(address operator, bool approved) public virtual override {
1543         require(operator != _msgSender(), "ERC721: approve to caller");
1544 
1545         _operatorApprovals[_msgSender()][operator] = approved;
1546         emit ApprovalForAll(_msgSender(), operator, approved);
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-isApprovedForAll}.
1551      */
1552     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1553         return _operatorApprovals[owner][operator];
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-transferFrom}.
1558      */
1559     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1560         //solhint-disable-next-line max-line-length
1561         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1562 
1563         _transfer(from, to, tokenId);
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-safeTransferFrom}.
1568      */
1569     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1570         safeTransferFrom(from, to, tokenId, "");
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-safeTransferFrom}.
1575      */
1576     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1577         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1578         _safeTransfer(from, to, tokenId, _data);
1579     }
1580 
1581     /**
1582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1584      *
1585      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1586      *
1587      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1588      * implement alternative mechanisms to perform token transfer, such as signature-based.
1589      *
1590      * Requirements:
1591      *
1592      * - `from` cannot be the zero address.
1593      * - `to` cannot be the zero address.
1594      * - `tokenId` token must exist and be owned by `from`.
1595      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1596      *
1597      * Emits a {Transfer} event.
1598      */
1599     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1600         _transfer(from, to, tokenId);
1601         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1602     }
1603 
1604     /**
1605      * @dev Returns whether `tokenId` exists.
1606      *
1607      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1608      *
1609      * Tokens start existing when they are minted (`_mint`),
1610      * and stop existing when they are burned (`_burn`).
1611      */
1612     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1613         return _tokenOwners.contains(tokenId);
1614     }
1615 
1616     /**
1617      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1618      *
1619      * Requirements:
1620      *
1621      * - `tokenId` must exist.
1622      */
1623     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1624         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1625         address owner = ERC721.ownerOf(tokenId);
1626         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1627     }
1628 
1629     /**
1630      * @dev Safely mints `tokenId` and transfers it to `to`.
1631      *
1632      * Requirements:
1633      d*
1634      * - `tokenId` must not exist.
1635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _safeMint(address to, uint256 tokenId) internal virtual {
1640         _safeMint(to, tokenId, "");
1641     }
1642 
1643     /**
1644      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1645      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1646      */
1647     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1648         _mint(to, tokenId);
1649         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1650     }
1651 
1652     /**
1653      * @dev Mints `tokenId` and transfers it to `to`.
1654      *
1655      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1656      *
1657      * Requirements:
1658      *
1659      * - `tokenId` must not exist.
1660      * - `to` cannot be the zero address.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function _mint(address to, uint256 tokenId) internal virtual {
1665         require(to != address(0), "ERC721: mint to the zero address");
1666         require(!_exists(tokenId), "ERC721: token already minted");
1667 
1668         _beforeTokenTransfer(address(0), to, tokenId);
1669 
1670         _holderTokens[to].add(tokenId);
1671 
1672         _tokenOwners.set(tokenId, to);
1673 
1674         emit Transfer(address(0), to, tokenId);
1675     }
1676 
1677     /**
1678      * @dev Destroys `tokenId`.
1679      * The approval is cleared when the token is burned.
1680      *
1681      * Requirements:
1682      *
1683      * - `tokenId` must exist.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function _burn(uint256 tokenId) internal virtual {
1688         address owner = ERC721.ownerOf(tokenId); // internal owner
1689 
1690         _beforeTokenTransfer(owner, address(0), tokenId);
1691 
1692         // Clear approvals
1693         _approve(address(0), tokenId);
1694 
1695         // Clear metadata (if any)
1696         if (bytes(_tokenURIs[tokenId]).length != 0) {
1697             delete _tokenURIs[tokenId];
1698         }
1699 
1700         _holderTokens[owner].remove(tokenId);
1701 
1702         _tokenOwners.remove(tokenId);
1703 
1704         emit Transfer(owner, address(0), tokenId);
1705     }
1706 
1707     /**
1708      * @dev Transfers `tokenId` from `from` to `to`.
1709      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1710      *
1711      * Requirements:
1712      *
1713      * - `to` cannot be the zero address.
1714      * - `tokenId` token must be owned by `from`.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1719         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1720         require(to != address(0), "ERC721: transfer to the zero address");
1721 
1722         _beforeTokenTransfer(from, to, tokenId);
1723 
1724         // Clear approvals from the previous owner
1725         _approve(address(0), tokenId);
1726 
1727         _holderTokens[from].remove(tokenId);
1728         _holderTokens[to].add(tokenId);
1729 
1730         _tokenOwners.set(tokenId, to);
1731 
1732         emit Transfer(from, to, tokenId);
1733     }
1734 
1735     /**
1736      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1737      *
1738      * Requirements:
1739      *
1740      * - `tokenId` must exist.
1741      */
1742     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1743         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1744         _tokenURIs[tokenId] = _tokenURI;
1745     }
1746 
1747     /**
1748      * @dev Internal function to set the base URI for all token IDs. It is
1749      * automatically added as a prefix to the value returned in {tokenURI},
1750      * or to the token ID if {tokenURI} is empty.
1751      */
1752     function _setBaseURI(string memory baseURI_) internal virtual {
1753         _baseURI = baseURI_;
1754     }
1755 
1756     /**
1757      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1758      * The call is not executed if the target address is not a contract.
1759      *
1760      * @param from address representing the previous owner of the given token ID
1761      * @param to target address that will receive the tokens
1762      * @param tokenId uint256 ID of the token to be transferred
1763      * @param _data bytes optional data to send along with the call
1764      * @return bool whether the call correctly returned the expected magic value
1765      */
1766     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1767         private returns (bool)
1768     {
1769         if (!to.isContract()) {
1770             return true;
1771         }
1772         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1773             IERC721Receiver(to).onERC721Received.selector,
1774             _msgSender(),
1775             from,
1776             tokenId,
1777             _data
1778         ), "ERC721: transfer to non ERC721Receiver implementer");
1779         bytes4 retval = abi.decode(returndata, (bytes4));
1780         return (retval == _ERC721_RECEIVED);
1781     }
1782 
1783     /**
1784      * @dev Approve `to` to operate on `tokenId`
1785      *
1786      * Emits an {Approval} event.
1787      */
1788     function _approve(address to, uint256 tokenId) internal virtual {
1789         _tokenApprovals[tokenId] = to;
1790         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1791     }
1792 
1793     /**
1794      * @dev Hook that is called before any token transfer. This includes minting
1795      * and burning.
1796      *
1797      * Calling conditions:
1798      *
1799      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1800      * transferred to `to`.
1801      * - When `from` is zero, `tokenId` will be minted for `to`.
1802      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1803      * - `from` cannot be the zero address.
1804      * - `to` cannot be the zero address.
1805      *
1806      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1807      */
1808     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1809 }
1810 
1811 // File: @openzeppelin/contracts/access/Ownable.sol
1812 
1813 
1814 
1815 pragma solidity >=0.6.0 <0.8.0;
1816 
1817 /**
1818  * @dev Contract module which provides a basic access control mechanism, where
1819  * there is an account (an owner) that can be granted exclusive access to
1820  * specific functions.
1821  *
1822  * By default, the owner account will be the one that deploys the contract. This
1823  * can later be changed with {transferOwnership}.
1824  *
1825  * This module is used through inheritance. It will make available the modifier
1826  * `onlyOwner`, which can be applied to your functions to restrict their use to
1827  * the owner.
1828  */
1829 abstract contract Ownable is Context {
1830     address private _owner;
1831 
1832     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1833 
1834     /**
1835      * @dev Initializes the contract setting the deployer as the initial owner.
1836      */
1837     constructor () internal {
1838         address msgSender = _msgSender();
1839         _owner = msgSender;
1840         emit OwnershipTransferred(address(0), msgSender);
1841     }
1842 
1843     /**
1844      * @dev Returns the address of the current owner.
1845      */
1846     function owner() public view virtual returns (address) {
1847         return _owner;
1848     }
1849 
1850     /**
1851      * @dev Throws if called by any account other than the owner.
1852      */
1853     modifier onlyOwner() {
1854         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1855         _;
1856     }
1857 
1858     /**
1859      * @dev Leaves the contract without owner. It will not be possible to call
1860      * `onlyOwner` functions anymore. Can only be called by the current owner.
1861      *
1862      * NOTE: Renouncing ownership will leave the contract without an owner,
1863      * thereby removing any functionality that is only available to the owner.
1864      */
1865     function renounceOwnership() public virtual onlyOwner {
1866         emit OwnershipTransferred(_owner, address(0));
1867         _owner = address(0);
1868     }
1869 
1870     /**
1871      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1872      * Can only be called by the current owner.
1873      */
1874     function transferOwnership(address newOwner) public virtual onlyOwner {
1875         require(newOwner != address(0), "Ownable: new owner is the zero address");
1876         emit OwnershipTransferred(_owner, newOwner);
1877         _owner = newOwner;
1878     }
1879 }
1880 
1881 pragma solidity ^0.7.0;
1882 pragma abicoder v2;
1883 
1884 contract BarnOwlz is ERC721, Ownable {
1885     
1886     using SafeMath for uint256;
1887 
1888     string public OWL_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN OWLS ARE ALL SOLD OUT
1889     
1890     string public LICENSE_TEXT = ""; 
1891     
1892     bool licenseLocked = false; 
1893 
1894     uint256 public constant owlPrice = 20000000000000000; // 0.02 ETH
1895 
1896     uint public constant maxOwlPurchase = 3;
1897 
1898     uint256 public constant MAX_OWLS = 3000;
1899 
1900     bool public saleIsActive = false;
1901     
1902     mapping(uint => string) public owlNames;
1903     
1904     // Reserve 25 owls for giveaways
1905     uint public owlReserve = 25;
1906     
1907     event owlNameChange(address _by, uint _tokenId, string _name);
1908     
1909     event licenseisLocked(string _licenseText);
1910 
1911     constructor() ERC721("Barn Owlz", "OWLZ") { }
1912     
1913     function withdraw() public onlyOwner {
1914         uint balance = address(this).balance;
1915         msg.sender.transfer(balance);
1916     }
1917     
1918     function reserveOwls(address _to, uint256 _reserveAmount) public onlyOwner {        
1919         uint supply = totalSupply();
1920         require(_reserveAmount > 0 && _reserveAmount <= owlReserve, "Not enough reserve left for team");
1921         for (uint i = 0; i < _reserveAmount; i++) {
1922             _safeMint(_to, supply + i);
1923         }
1924         owlReserve = owlReserve.sub(_reserveAmount);
1925     }
1926 
1927 
1928     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1929         OWL_PROVENANCE = provenanceHash;
1930     }
1931 
1932     function setBaseURI(string memory baseURI) public onlyOwner {
1933         _setBaseURI(baseURI);
1934     }
1935 
1936 
1937     function flipSaleState() public onlyOwner {
1938         saleIsActive = !saleIsActive;
1939     }
1940     
1941     
1942     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1943         uint256 tokenCount = balanceOf(_owner);
1944         if (tokenCount == 0) {
1945             // Return an empty array
1946             return new uint256[](0);
1947         } else {
1948             uint256[] memory result = new uint256[](tokenCount);
1949             uint256 index;
1950             for (index = 0; index < tokenCount; index++) {
1951                 result[index] = tokenOfOwnerByIndex(_owner, index);
1952             }
1953             return result;
1954         }
1955     }
1956     
1957     // Returns the license for tokens
1958     function tokenLicense(uint _id) public view returns(string memory) {
1959         require(_id < totalSupply(), "CHOOSE A OWL WITHIN RANGE");
1960         return LICENSE_TEXT;
1961     }
1962     
1963     // Locks the license to prevent further changes 
1964     function lockLicense() public onlyOwner {
1965         licenseLocked =  true;
1966         emit licenseisLocked(LICENSE_TEXT);
1967     }
1968     
1969     // Change the license
1970     function changeLicense(string memory _license) public onlyOwner {
1971         require(licenseLocked == false, "License already locked");
1972         LICENSE_TEXT = _license;
1973     }
1974     
1975     
1976     function mintOwl(uint numberOfTokens) public payable {
1977         require(saleIsActive, "Sale must be active to mint Owl");
1978         require(numberOfTokens > 0 && numberOfTokens <= maxOwlPurchase, "Can only mint 3 tokens at a time");
1979         require(totalSupply().add(numberOfTokens) <= MAX_OWLS, "Purchase would exceed max supply of Owls");
1980         require(msg.value >= owlPrice.mul(numberOfTokens), "Ether value sent is not correct");
1981         
1982         for(uint i = 0; i < numberOfTokens; i++) {
1983             uint mintIndex = totalSupply();
1984             if (totalSupply() < MAX_OWLS) {
1985                 _safeMint(msg.sender, mintIndex);
1986             }
1987         }
1988 
1989     }
1990      
1991     function changeOwlName(uint _tokenId, string memory _name) public {
1992         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this owl!");
1993         require(sha256(bytes(_name)) != sha256(bytes(owlNames[_tokenId])), "New name is same as the current one");
1994         owlNames[_tokenId] = _name;
1995         
1996         emit owlNameChange(msg.sender, _tokenId, _name);
1997         
1998     }
1999     
2000     function viewOwlName(uint _tokenId) public view returns( string memory ){
2001         require( _tokenId < totalSupply(), "Choose a owl within range" );
2002         return owlNames[_tokenId];
2003     }
2004     
2005     function owlNamesOfOwner(address _owner) external view returns(string[] memory ) {
2006         uint256 tokenCount = balanceOf(_owner);
2007         if (tokenCount == 0) {
2008             // Return an empty array
2009             return new string[](0);
2010         } else {
2011             string[] memory result = new string[](tokenCount);
2012             uint256 index;
2013             for (index = 0; index < tokenCount; index++) {
2014                 result[index] = owlNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2015             }
2016             return result;
2017         }
2018     }
2019 }