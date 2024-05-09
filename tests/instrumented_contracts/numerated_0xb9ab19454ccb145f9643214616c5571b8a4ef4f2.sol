1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Context.sol
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/introspection/IERC165.sol
30 
31 
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Interface of the ERC165 standard, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-165[EIP].
38  *
39  * Implementers can declare support of contract interfaces, which can then be
40  * queried by others ({ERC165Checker}).
41  *
42  * For an implementation, see {ERC165}.
43  */
44 interface IERC165 {
45     /**
46      * @dev Returns true if this contract implements the interface defined by
47      * `interfaceId`. See the corresponding
48      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
49      * to learn more about how these ids are created.
50      *
51      * This function call must use less than 30 000 gas.
52      */
53     function supportsInterface(bytes4 interfaceId) external view returns (bool);
54 }
55 
56 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
57 
58 
59 
60 pragma solidity >=0.6.2 <0.8.0;
61 
62 
63 /**
64  * @dev Required interface of an ERC721 compliant contract.
65  */
66 interface IERC721 is IERC165 {
67     /**
68      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
74      */
75     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
76 
77     /**
78      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
79      */
80     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
81 
82     /**
83      * @dev Returns the number of tokens in ``owner``'s account.
84      */
85     function balanceOf(address owner) external view returns (uint256 balance);
86 
87     /**
88      * @dev Returns the owner of the `tokenId` token.
89      *
90      * Requirements:
91      *
92      * - `tokenId` must exist.
93      */
94     function ownerOf(uint256 tokenId) external view returns (address owner);
95 
96     /**
97      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
98      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must exist and be owned by `from`.
105      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
107      *
108      * Emits a {Transfer} event.
109      */
110     function safeTransferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(address from, address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172       * @dev Safely transfers `tokenId` token from `from` to `to`.
173       *
174       * Requirements:
175       *
176       * - `from` cannot be the zero address.
177       * - `to` cannot be the zero address.
178       * - `tokenId` token must exist and be owned by `from`.
179       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181       *
182       * Emits a {Transfer} event.
183       */
184     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
185 }
186 
187 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
188 
189 
190 
191 pragma solidity >=0.6.2 <0.8.0;
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199 
200     /**
201      * @dev Returns the token collection name.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the token collection symbol.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
212      */
213     function tokenURI(uint256 tokenId) external view returns (string memory);
214 }
215 
216 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
217 
218 
219 
220 pragma solidity >=0.6.2 <0.8.0;
221 
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Enumerable is IERC721 {
228 
229     /**
230      * @dev Returns the total amount of tokens stored by the contract.
231      */
232     function totalSupply() external view returns (uint256);
233 
234     /**
235      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
236      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
237      */
238     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
239 
240     /**
241      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
242      * Use along with {totalSupply} to enumerate all tokens.
243      */
244     function tokenByIndex(uint256 index) external view returns (uint256);
245 }
246 
247 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
248 
249 
250 
251 pragma solidity >=0.6.0 <0.8.0;
252 
253 /**
254  * @title ERC721 token receiver interface
255  * @dev Interface for any contract that wants to support safeTransfers
256  * from ERC721 asset contracts.
257  */
258 interface IERC721Receiver {
259     /**
260      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
261      * by `operator` from `from`, this function is called.
262      *
263      * It must return its Solidity selector to confirm the token transfer.
264      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
265      *
266      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
267      */
268     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
269 }
270 
271 // File: @openzeppelin/contracts/introspection/ERC165.sol
272 
273 
274 
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 
278 /**
279  * @dev Implementation of the {IERC165} interface.
280  *
281  * Contracts may inherit from this and call {_registerInterface} to declare
282  * their support of an interface.
283  */
284 abstract contract ERC165 is IERC165 {
285     /*
286      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
287      */
288     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
289 
290     /**
291      * @dev Mapping of interface ids to whether or not it's supported.
292      */
293     mapping(bytes4 => bool) private _supportedInterfaces;
294 
295     constructor () internal {
296         // Derived contracts need only register support for their own interfaces,
297         // we register support for ERC165 itself here
298         _registerInterface(_INTERFACE_ID_ERC165);
299     }
300 
301     /**
302      * @dev See {IERC165-supportsInterface}.
303      *
304      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
305      */
306     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
307         return _supportedInterfaces[interfaceId];
308     }
309 
310     /**
311      * @dev Registers the contract as an implementer of the interface defined by
312      * `interfaceId`. Support of the actual ERC165 interface is automatic and
313      * registering its interface id is not required.
314      *
315      * See {IERC165-supportsInterface}.
316      *
317      * Requirements:
318      *
319      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
320      */
321     function _registerInterface(bytes4 interfaceId) internal virtual {
322         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
323         _supportedInterfaces[interfaceId] = true;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/math/SafeMath.sol
328 
329 
330 
331 pragma solidity >=0.6.0 <0.8.0;
332 
333 /**
334  * @dev Wrappers over Solidity's arithmetic operations with added overflow
335  * checks.
336  *
337  * Arithmetic operations in Solidity wrap on overflow. This can easily result
338  * in bugs, because programmers usually assume that an overflow raises an
339  * error, which is the standard behavior in high level programming languages.
340  * `SafeMath` restores this intuition by reverting the transaction when an
341  * operation overflows.
342  *
343  * Using this library instead of the unchecked operations eliminates an entire
344  * class of bugs, so it's recommended to use it always.
345  */
346 library SafeMath {
347     /**
348      * @dev Returns the addition of two unsigned integers, with an overflow flag.
349      *
350      * _Available since v3.4._
351      */
352     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
353         uint256 c = a + b;
354         if (c < a) return (false, 0);
355         return (true, c);
356     }
357 
358     /**
359      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
360      *
361      * _Available since v3.4._
362      */
363     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
364         if (b > a) return (false, 0);
365         return (true, a - b);
366     }
367 
368     /**
369      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
370      *
371      * _Available since v3.4._
372      */
373     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
374         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
375         // benefit is lost if 'b' is also tested.
376         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
377         if (a == 0) return (true, 0);
378         uint256 c = a * b;
379         if (c / a != b) return (false, 0);
380         return (true, c);
381     }
382 
383     /**
384      * @dev Returns the division of two unsigned integers, with a division by zero flag.
385      *
386      * _Available since v3.4._
387      */
388     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
389         if (b == 0) return (false, 0);
390         return (true, a / b);
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         if (b == 0) return (false, 0);
400         return (true, a % b);
401     }
402 
403     /**
404      * @dev Returns the addition of two unsigned integers, reverting on
405      * overflow.
406      *
407      * Counterpart to Solidity's `+` operator.
408      *
409      * Requirements:
410      *
411      * - Addition cannot overflow.
412      */
413     function add(uint256 a, uint256 b) internal pure returns (uint256) {
414         uint256 c = a + b;
415         require(c >= a, "SafeMath: addition overflow");
416         return c;
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting on
421      * overflow (when the result is negative).
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      *
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
430         require(b <= a, "SafeMath: subtraction overflow");
431         return a - b;
432     }
433 
434     /**
435      * @dev Returns the multiplication of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `*` operator.
439      *
440      * Requirements:
441      *
442      * - Multiplication cannot overflow.
443      */
444     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
445         if (a == 0) return 0;
446         uint256 c = a * b;
447         require(c / a == b, "SafeMath: multiplication overflow");
448         return c;
449     }
450 
451     /**
452      * @dev Returns the integer division of two unsigned integers, reverting on
453      * division by zero. The result is rounded towards zero.
454      *
455      * Counterpart to Solidity's `/` operator. Note: this function uses a
456      * `revert` opcode (which leaves remaining gas untouched) while Solidity
457      * uses an invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
464         require(b > 0, "SafeMath: division by zero");
465         return a / b;
466     }
467 
468     /**
469      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
470      * reverting when dividing by zero.
471      *
472      * Counterpart to Solidity's `%` operator. This function uses a `revert`
473      * opcode (which leaves remaining gas untouched) while Solidity uses an
474      * invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
481         require(b > 0, "SafeMath: modulo by zero");
482         return a % b;
483     }
484 
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
487      * overflow (when the result is negative).
488      *
489      * CAUTION: This function is deprecated because it requires allocating memory for the error
490      * message unnecessarily. For custom revert reasons use {trySub}.
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b <= a, errorMessage);
500         return a - b;
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
505      * division by zero. The result is rounded towards zero.
506      *
507      * CAUTION: This function is deprecated because it requires allocating memory for the error
508      * message unnecessarily. For custom revert reasons use {tryDiv}.
509      *
510      * Counterpart to Solidity's `/` operator. Note: this function uses a
511      * `revert` opcode (which leaves remaining gas untouched) while Solidity
512      * uses an invalid opcode to revert (consuming all remaining gas).
513      *
514      * Requirements:
515      *
516      * - The divisor cannot be zero.
517      */
518     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b > 0, errorMessage);
520         return a / b;
521     }
522 
523     /**
524      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
525      * reverting with custom message when dividing by zero.
526      *
527      * CAUTION: This function is deprecated because it requires allocating memory for the error
528      * message unnecessarily. For custom revert reasons use {tryMod}.
529      *
530      * Counterpart to Solidity's `%` operator. This function uses a `revert`
531      * opcode (which leaves remaining gas untouched) while Solidity uses an
532      * invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         require(b > 0, errorMessage);
540         return a % b;
541     }
542 }
543 
544 // File: @openzeppelin/contracts/utils/Address.sol
545 
546 
547 
548 pragma solidity >=0.6.2 <0.8.0;
549 
550 /**
551  * @dev Collection of functions related to the address type
552  */
553 library Address {
554     /**
555      * @dev Returns true if `account` is a contract.
556      *
557      * [IMPORTANT]
558      * ====
559      * It is unsafe to assume that an address for which this function returns
560      * false is an externally-owned account (EOA) and not a contract.
561      *
562      * Among others, `isContract` will return false for the following
563      * types of addresses:
564      *
565      *  - an externally-owned account
566      *  - a contract in construction
567      *  - an address where a contract will be created
568      *  - an address where a contract lived, but was destroyed
569      * ====
570      */
571     function isContract(address account) internal view returns (bool) {
572         // This method relies on extcodesize, which returns 0 for contracts in
573         // construction, since the code is only stored at the end of the
574         // constructor execution.
575 
576         uint256 size;
577         // solhint-disable-next-line no-inline-assembly
578         assembly { size := extcodesize(account) }
579         return size > 0;
580     }
581 
582     /**
583      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
584      * `recipient`, forwarding all available gas and reverting on errors.
585      *
586      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
587      * of certain opcodes, possibly making contracts go over the 2300 gas limit
588      * imposed by `transfer`, making them unable to receive funds via
589      * `transfer`. {sendValue} removes this limitation.
590      *
591      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
592      *
593      * IMPORTANT: because control is transferred to `recipient`, care must be
594      * taken to not create reentrancy vulnerabilities. Consider using
595      * {ReentrancyGuard} or the
596      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
597      */
598     function sendValue(address payable recipient, uint256 amount) internal {
599         require(address(this).balance >= amount, "Address: insufficient balance");
600 
601         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
602         (bool success, ) = recipient.call{ value: amount }("");
603         require(success, "Address: unable to send value, recipient may have reverted");
604     }
605 
606     /**
607      * @dev Performs a Solidity function call using a low level `call`. A
608      * plain`call` is an unsafe replacement for a function call: use this
609      * function instead.
610      *
611      * If `target` reverts with a revert reason, it is bubbled up by this
612      * function (like regular Solidity function calls).
613      *
614      * Returns the raw returned data. To convert to the expected return value,
615      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
616      *
617      * Requirements:
618      *
619      * - `target` must be a contract.
620      * - calling `target` with `data` must not revert.
621      *
622      * _Available since v3.1._
623      */
624     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
625       return functionCall(target, data, "Address: low-level call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
630      * `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
635         return functionCallWithValue(target, data, 0, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but also transferring `value` wei to `target`.
641      *
642      * Requirements:
643      *
644      * - the calling contract must have an ETH balance of at least `value`.
645      * - the called Solidity function must be `payable`.
646      *
647      * _Available since v3.1._
648      */
649     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
650         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
655      * with `errorMessage` as a fallback revert reason when `target` reverts.
656      *
657      * _Available since v3.1._
658      */
659     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
660         require(address(this).balance >= value, "Address: insufficient balance for call");
661         require(isContract(target), "Address: call to non-contract");
662 
663         // solhint-disable-next-line avoid-low-level-calls
664         (bool success, bytes memory returndata) = target.call{ value: value }(data);
665         return _verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but performing a static call.
671      *
672      * _Available since v3.3._
673      */
674     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
675         return functionStaticCall(target, data, "Address: low-level static call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a static call.
681      *
682      * _Available since v3.3._
683      */
684     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
685         require(isContract(target), "Address: static call to non-contract");
686 
687         // solhint-disable-next-line avoid-low-level-calls
688         (bool success, bytes memory returndata) = target.staticcall(data);
689         return _verifyCallResult(success, returndata, errorMessage);
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
694      * but performing a delegate call.
695      *
696      * _Available since v3.4._
697      */
698     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
699         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
704      * but performing a delegate call.
705      *
706      * _Available since v3.4._
707      */
708     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
709         require(isContract(target), "Address: delegate call to non-contract");
710 
711         // solhint-disable-next-line avoid-low-level-calls
712         (bool success, bytes memory returndata) = target.delegatecall(data);
713         return _verifyCallResult(success, returndata, errorMessage);
714     }
715 
716     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
717         if (success) {
718             return returndata;
719         } else {
720             // Look for revert reason and bubble it up if present
721             if (returndata.length > 0) {
722                 // The easiest way to bubble the revert reason is using memory via assembly
723 
724                 // solhint-disable-next-line no-inline-assembly
725                 assembly {
726                     let returndata_size := mload(returndata)
727                     revert(add(32, returndata), returndata_size)
728                 }
729             } else {
730                 revert(errorMessage);
731             }
732         }
733     }
734 }
735 
736 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
737 
738 
739 
740 pragma solidity >=0.6.0 <0.8.0;
741 
742 /**
743  * @dev Library for managing
744  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
745  * types.
746  *
747  * Sets have the following properties:
748  *
749  * - Elements are added, removed, and checked for existence in constant time
750  * (O(1)).
751  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
752  *
753  * ```
754  * contract Example {
755  *     // Add the library methods
756  *     using EnumerableSet for EnumerableSet.AddressSet;
757  *
758  *     // Declare a set state variable
759  *     EnumerableSet.AddressSet private mySet;
760  * }
761  * ```
762  *
763  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
764  * and `uint256` (`UintSet`) are supported.
765  */
766 library EnumerableSet {
767     // To implement this library for multiple types with as little code
768     // repetition as possible, we write it in terms of a generic Set type with
769     // bytes32 values.
770     // The Set implementation uses private functions, and user-facing
771     // implementations (such as AddressSet) are just wrappers around the
772     // underlying Set.
773     // This means that we can only create new EnumerableSets for types that fit
774     // in bytes32.
775 
776     struct Set {
777         // Storage of set values
778         bytes32[] _values;
779 
780         // Position of the value in the `values` array, plus 1 because index 0
781         // means a value is not in the set.
782         mapping (bytes32 => uint256) _indexes;
783     }
784 
785     /**
786      * @dev Add a value to a set. O(1).
787      *
788      * Returns true if the value was added to the set, that is if it was not
789      * already present.
790      */
791     function _add(Set storage set, bytes32 value) private returns (bool) {
792         if (!_contains(set, value)) {
793             set._values.push(value);
794             // The value is stored at length-1, but we add 1 to all indexes
795             // and use 0 as a sentinel value
796             set._indexes[value] = set._values.length;
797             return true;
798         } else {
799             return false;
800         }
801     }
802 
803     /**
804      * @dev Removes a value from a set. O(1).
805      *
806      * Returns true if the value was removed from the set, that is if it was
807      * present.
808      */
809     function _remove(Set storage set, bytes32 value) private returns (bool) {
810         // We read and store the value's index to prevent multiple reads from the same storage slot
811         uint256 valueIndex = set._indexes[value];
812 
813         if (valueIndex != 0) { // Equivalent to contains(set, value)
814             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
815             // the array, and then remove the last element (sometimes called as 'swap and pop').
816             // This modifies the order of the array, as noted in {at}.
817 
818             uint256 toDeleteIndex = valueIndex - 1;
819             uint256 lastIndex = set._values.length - 1;
820 
821             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
822             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
823 
824             bytes32 lastvalue = set._values[lastIndex];
825 
826             // Move the last value to the index where the value to delete is
827             set._values[toDeleteIndex] = lastvalue;
828             // Update the index for the moved value
829             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
830 
831             // Delete the slot where the moved value was stored
832             set._values.pop();
833 
834             // Delete the index for the deleted slot
835             delete set._indexes[value];
836 
837             return true;
838         } else {
839             return false;
840         }
841     }
842 
843     /**
844      * @dev Returns true if the value is in the set. O(1).
845      */
846     function _contains(Set storage set, bytes32 value) private view returns (bool) {
847         return set._indexes[value] != 0;
848     }
849 
850     /**
851      * @dev Returns the number of values on the set. O(1).
852      */
853     function _length(Set storage set) private view returns (uint256) {
854         return set._values.length;
855     }
856 
857    /**
858     * @dev Returns the value stored at position `index` in the set. O(1).
859     *
860     * Note that there are no guarantees on the ordering of values inside the
861     * array, and it may change when more values are added or removed.
862     *
863     * Requirements:
864     *
865     * - `index` must be strictly less than {length}.
866     */
867     function _at(Set storage set, uint256 index) private view returns (bytes32) {
868         require(set._values.length > index, "EnumerableSet: index out of bounds");
869         return set._values[index];
870     }
871 
872     // Bytes32Set
873 
874     struct Bytes32Set {
875         Set _inner;
876     }
877 
878     /**
879      * @dev Add a value to a set. O(1).
880      *
881      * Returns true if the value was added to the set, that is if it was not
882      * already present.
883      */
884     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
885         return _add(set._inner, value);
886     }
887 
888     /**
889      * @dev Removes a value from a set. O(1).
890      *
891      * Returns true if the value was removed from the set, that is if it was
892      * present.
893      */
894     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
895         return _remove(set._inner, value);
896     }
897 
898     /**
899      * @dev Returns true if the value is in the set. O(1).
900      */
901     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
902         return _contains(set._inner, value);
903     }
904 
905     /**
906      * @dev Returns the number of values in the set. O(1).
907      */
908     function length(Bytes32Set storage set) internal view returns (uint256) {
909         return _length(set._inner);
910     }
911 
912    /**
913     * @dev Returns the value stored at position `index` in the set. O(1).
914     *
915     * Note that there are no guarantees on the ordering of values inside the
916     * array, and it may change when more values are added or removed.
917     *
918     * Requirements:
919     *
920     * - `index` must be strictly less than {length}.
921     */
922     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
923         return _at(set._inner, index);
924     }
925 
926     // AddressSet
927 
928     struct AddressSet {
929         Set _inner;
930     }
931 
932     /**
933      * @dev Add a value to a set. O(1).
934      *
935      * Returns true if the value was added to the set, that is if it was not
936      * already present.
937      */
938     function add(AddressSet storage set, address value) internal returns (bool) {
939         return _add(set._inner, bytes32(uint256(uint160(value))));
940     }
941 
942     /**
943      * @dev Removes a value from a set. O(1).
944      *
945      * Returns true if the value was removed from the set, that is if it was
946      * present.
947      */
948     function remove(AddressSet storage set, address value) internal returns (bool) {
949         return _remove(set._inner, bytes32(uint256(uint160(value))));
950     }
951 
952     /**
953      * @dev Returns true if the value is in the set. O(1).
954      */
955     function contains(AddressSet storage set, address value) internal view returns (bool) {
956         return _contains(set._inner, bytes32(uint256(uint160(value))));
957     }
958 
959     /**
960      * @dev Returns the number of values in the set. O(1).
961      */
962     function length(AddressSet storage set) internal view returns (uint256) {
963         return _length(set._inner);
964     }
965 
966    /**
967     * @dev Returns the value stored at position `index` in the set. O(1).
968     *
969     * Note that there are no guarantees on the ordering of values inside the
970     * array, and it may change when more values are added or removed.
971     *
972     * Requirements:
973     *
974     * - `index` must be strictly less than {length}.
975     */
976     function at(AddressSet storage set, uint256 index) internal view returns (address) {
977         return address(uint160(uint256(_at(set._inner, index))));
978     }
979 
980 
981     // UintSet
982 
983     struct UintSet {
984         Set _inner;
985     }
986 
987     /**
988      * @dev Add a value to a set. O(1).
989      *
990      * Returns true if the value was added to the set, that is if it was not
991      * already present.
992      */
993     function add(UintSet storage set, uint256 value) internal returns (bool) {
994         return _add(set._inner, bytes32(value));
995     }
996 
997     /**
998      * @dev Removes a value from a set. O(1).
999      *
1000      * Returns true if the value was removed from the set, that is if it was
1001      * present.
1002      */
1003     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1004         return _remove(set._inner, bytes32(value));
1005     }
1006 
1007     /**
1008      * @dev Returns true if the value is in the set. O(1).
1009      */
1010     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1011         return _contains(set._inner, bytes32(value));
1012     }
1013 
1014     /**
1015      * @dev Returns the number of values on the set. O(1).
1016      */
1017     function length(UintSet storage set) internal view returns (uint256) {
1018         return _length(set._inner);
1019     }
1020 
1021    /**
1022     * @dev Returns the value stored at position `index` in the set. O(1).
1023     *
1024     * Note that there are no guarantees on the ordering of values inside the
1025     * array, and it may change when more values are added or removed.
1026     *
1027     * Requirements:
1028     *
1029     * - `index` must be strictly less than {length}.
1030     */
1031     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1032         return uint256(_at(set._inner, index));
1033     }
1034 }
1035 
1036 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1037 
1038 
1039 
1040 pragma solidity >=0.6.0 <0.8.0;
1041 
1042 /**
1043  * @dev Library for managing an enumerable variant of Solidity's
1044  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1045  * type.
1046  *
1047  * Maps have the following properties:
1048  *
1049  * - Entries are added, removed, and checked for existence in constant time
1050  * (O(1)).
1051  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1052  *
1053  * ```
1054  * contract Example {
1055  *     // Add the library methods
1056  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1057  *
1058  *     // Declare a set state variable
1059  *     EnumerableMap.UintToAddressMap private myMap;
1060  * }
1061  * ```
1062  *
1063  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1064  * supported.
1065  */
1066 library EnumerableMap {
1067     // To implement this library for multiple types with as little code
1068     // repetition as possible, we write it in terms of a generic Map type with
1069     // bytes32 keys and values.
1070     // The Map implementation uses private functions, and user-facing
1071     // implementations (such as Uint256ToAddressMap) are just wrappers around
1072     // the underlying Map.
1073     // This means that we can only create new EnumerableMaps for types that fit
1074     // in bytes32.
1075 
1076     struct MapEntry {
1077         bytes32 _key;
1078         bytes32 _value;
1079     }
1080 
1081     struct Map {
1082         // Storage of map keys and values
1083         MapEntry[] _entries;
1084 
1085         // Position of the entry defined by a key in the `entries` array, plus 1
1086         // because index 0 means a key is not in the map.
1087         mapping (bytes32 => uint256) _indexes;
1088     }
1089 
1090     /**
1091      * @dev Adds a key-value pair to a map, or updates the value for an existing
1092      * key. O(1).
1093      *
1094      * Returns true if the key was added to the map, that is if it was not
1095      * already present.
1096      */
1097     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1098         // We read and store the key's index to prevent multiple reads from the same storage slot
1099         uint256 keyIndex = map._indexes[key];
1100 
1101         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1102             map._entries.push(MapEntry({ _key: key, _value: value }));
1103             // The entry is stored at length-1, but we add 1 to all indexes
1104             // and use 0 as a sentinel value
1105             map._indexes[key] = map._entries.length;
1106             return true;
1107         } else {
1108             map._entries[keyIndex - 1]._value = value;
1109             return false;
1110         }
1111     }
1112 
1113     /**
1114      * @dev Removes a key-value pair from a map. O(1).
1115      *
1116      * Returns true if the key was removed from the map, that is if it was present.
1117      */
1118     function _remove(Map storage map, bytes32 key) private returns (bool) {
1119         // We read and store the key's index to prevent multiple reads from the same storage slot
1120         uint256 keyIndex = map._indexes[key];
1121 
1122         if (keyIndex != 0) { // Equivalent to contains(map, key)
1123             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1124             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1125             // This modifies the order of the array, as noted in {at}.
1126 
1127             uint256 toDeleteIndex = keyIndex - 1;
1128             uint256 lastIndex = map._entries.length - 1;
1129 
1130             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1131             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1132 
1133             MapEntry storage lastEntry = map._entries[lastIndex];
1134 
1135             // Move the last entry to the index where the entry to delete is
1136             map._entries[toDeleteIndex] = lastEntry;
1137             // Update the index for the moved entry
1138             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1139 
1140             // Delete the slot where the moved entry was stored
1141             map._entries.pop();
1142 
1143             // Delete the index for the deleted slot
1144             delete map._indexes[key];
1145 
1146             return true;
1147         } else {
1148             return false;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Returns true if the key is in the map. O(1).
1154      */
1155     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1156         return map._indexes[key] != 0;
1157     }
1158 
1159     /**
1160      * @dev Returns the number of key-value pairs in the map. O(1).
1161      */
1162     function _length(Map storage map) private view returns (uint256) {
1163         return map._entries.length;
1164     }
1165 
1166    /**
1167     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1168     *
1169     * Note that there are no guarantees on the ordering of entries inside the
1170     * array, and it may change when more entries are added or removed.
1171     *
1172     * Requirements:
1173     *
1174     * - `index` must be strictly less than {length}.
1175     */
1176     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1177         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1178 
1179         MapEntry storage entry = map._entries[index];
1180         return (entry._key, entry._value);
1181     }
1182 
1183     /**
1184      * @dev Tries to returns the value associated with `key`.  O(1).
1185      * Does not revert if `key` is not in the map.
1186      */
1187     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1188         uint256 keyIndex = map._indexes[key];
1189         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1190         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1191     }
1192 
1193     /**
1194      * @dev Returns the value associated with `key`.  O(1).
1195      *
1196      * Requirements:
1197      *
1198      * - `key` must be in the map.
1199      */
1200     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1201         uint256 keyIndex = map._indexes[key];
1202         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1203         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1204     }
1205 
1206     /**
1207      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1208      *
1209      * CAUTION: This function is deprecated because it requires allocating memory for the error
1210      * message unnecessarily. For custom revert reasons use {_tryGet}.
1211      */
1212     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1213         uint256 keyIndex = map._indexes[key];
1214         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1215         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1216     }
1217 
1218     // UintToAddressMap
1219 
1220     struct UintToAddressMap {
1221         Map _inner;
1222     }
1223 
1224     /**
1225      * @dev Adds a key-value pair to a map, or updates the value for an existing
1226      * key. O(1).
1227      *
1228      * Returns true if the key was added to the map, that is if it was not
1229      * already present.
1230      */
1231     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1232         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1233     }
1234 
1235     /**
1236      * @dev Removes a value from a set. O(1).
1237      *
1238      * Returns true if the key was removed from the map, that is if it was present.
1239      */
1240     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1241         return _remove(map._inner, bytes32(key));
1242     }
1243 
1244     /**
1245      * @dev Returns true if the key is in the map. O(1).
1246      */
1247     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1248         return _contains(map._inner, bytes32(key));
1249     }
1250 
1251     /**
1252      * @dev Returns the number of elements in the map. O(1).
1253      */
1254     function length(UintToAddressMap storage map) internal view returns (uint256) {
1255         return _length(map._inner);
1256     }
1257 
1258    /**
1259     * @dev Returns the element stored at position `index` in the set. O(1).
1260     * Note that there are no guarantees on the ordering of values inside the
1261     * array, and it may change when more values are added or removed.
1262     *
1263     * Requirements:
1264     *
1265     * - `index` must be strictly less than {length}.
1266     */
1267     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1268         (bytes32 key, bytes32 value) = _at(map._inner, index);
1269         return (uint256(key), address(uint160(uint256(value))));
1270     }
1271 
1272     /**
1273      * @dev Tries to returns the value associated with `key`.  O(1).
1274      * Does not revert if `key` is not in the map.
1275      *
1276      * _Available since v3.4._
1277      */
1278     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1279         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1280         return (success, address(uint160(uint256(value))));
1281     }
1282 
1283     /**
1284      * @dev Returns the value associated with `key`.  O(1).
1285      *
1286      * Requirements:
1287      *
1288      * - `key` must be in the map.
1289      */
1290     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1291         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1292     }
1293 
1294     /**
1295      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1296      *
1297      * CAUTION: This function is deprecated because it requires allocating memory for the error
1298      * message unnecessarily. For custom revert reasons use {tryGet}.
1299      */
1300     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1301         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1302     }
1303 }
1304 
1305 // File: @openzeppelin/contracts/utils/Strings.sol
1306 
1307 
1308 
1309 pragma solidity >=0.6.0 <0.8.0;
1310 
1311 /**
1312  * @dev String operations.
1313  */
1314 library Strings {
1315     /**
1316      * @dev Converts a `uint256` to its ASCII `string` representation.
1317      */
1318     function toString(uint256 value) internal pure returns (string memory) {
1319         // Inspired by OraclizeAPI's implementation - MIT licence
1320         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1321 
1322         if (value == 0) {
1323             return "0";
1324         }
1325         uint256 temp = value;
1326         uint256 digits;
1327         while (temp != 0) {
1328             digits++;
1329             temp /= 10;
1330         }
1331         bytes memory buffer = new bytes(digits);
1332         uint256 index = digits - 1;
1333         temp = value;
1334         while (temp != 0) {
1335             buffer[index--] = bytes1(uint8(48 + temp % 10));
1336             temp /= 10;
1337         }
1338         return string(buffer);
1339     }
1340 }
1341 
1342 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1343 
1344 
1345 
1346 pragma solidity >=0.6.0 <0.8.0;
1347 
1348 /**
1349  * @title ERC721 Non-Fungible Token Standard basic implementation
1350  * @dev see https://eips.ethereum.org/EIPS/eip-721
1351  */
1352  
1353 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1354     using SafeMath for uint256;
1355     using Address for address;
1356     using EnumerableSet for EnumerableSet.UintSet;
1357     using EnumerableMap for EnumerableMap.UintToAddressMap;
1358     using Strings for uint256;
1359 
1360     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1361     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1362     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1363 
1364     // Mapping from holder address to their (enumerable) set of owned tokens
1365     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1366 
1367     // Enumerable mapping from token ids to their owners
1368     EnumerableMap.UintToAddressMap private _tokenOwners;
1369 
1370     // Mapping from token ID to approved address
1371     mapping (uint256 => address) private _tokenApprovals;
1372 
1373     // Mapping from owner to operator approvals
1374     mapping (address => mapping (address => bool)) private _operatorApprovals;
1375 
1376     // Token name
1377     string private _name;
1378 
1379     // Token symbol
1380     string private _symbol;
1381 
1382     // Optional mapping for token URIs
1383     mapping (uint256 => string) private _tokenURIs;
1384 
1385     // Base URI
1386     string private _baseURI;
1387 
1388     /*
1389      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1390      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1391      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1392      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1393      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1394      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1395      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1396      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1397      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1398      *
1399      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1400      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1401      */
1402     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1403 
1404     /*
1405      *     bytes4(keccak256('name()')) == 0x06fdde03
1406      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1407      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1408      *
1409      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1410      */
1411     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1412 
1413     /*
1414      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1415      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1416      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1417      *
1418      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1419      */
1420     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1421 
1422     /**
1423      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1424      */
1425     constructor (string memory name_, string memory symbol_) public {
1426         _name = name_;
1427         _symbol = symbol_;
1428 
1429         // register the supported interfaces to conform to ERC721 via ERC165
1430         _registerInterface(_INTERFACE_ID_ERC721);
1431         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1432         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-balanceOf}.
1437      */
1438     function balanceOf(address owner) public view virtual override returns (uint256) {
1439         require(owner != address(0), "ERC721: balance query for the zero address");
1440         return _holderTokens[owner].length();
1441     }
1442 
1443     /**
1444      * @dev See {IERC721-ownerOf}.
1445      */
1446     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1447         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-name}.
1452      */
1453     function name() public view virtual override returns (string memory) {
1454         return _name;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Metadata-symbol}.
1459      */
1460     function symbol() public view virtual override returns (string memory) {
1461         return _symbol;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-tokenURI}.
1466      */
1467     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1468         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1469 
1470         string memory _tokenURI = _tokenURIs[tokenId];
1471         string memory base = baseURI();
1472 
1473         // If there is no base URI, return the token URI.
1474         if (bytes(base).length == 0) {
1475             return _tokenURI;
1476         }
1477         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1478         if (bytes(_tokenURI).length > 0) {
1479             return string(abi.encodePacked(base, _tokenURI));
1480         }
1481         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1482         return string(abi.encodePacked(base, tokenId.toString()));
1483     }
1484 
1485     /**
1486     * @dev Returns the base URI set via {_setBaseURI}. This will be
1487     * automatically added as a prefix in {tokenURI} to each token's URI, or
1488     * to the token ID if no specific URI is set for that token ID.
1489     */
1490     function baseURI() public view virtual returns (string memory) {
1491         return _baseURI;
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1496      */
1497     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1498         return _holderTokens[owner].at(index);
1499     }
1500 
1501     /**
1502      * @dev See {IERC721Enumerable-totalSupply}.
1503      */
1504     function totalSupply() public view virtual override returns (uint256) {
1505         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1506         return _tokenOwners.length();
1507     }
1508 
1509     /**
1510      * @dev See {IERC721Enumerable-tokenByIndex}.
1511      */
1512     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1513         (uint256 tokenId, ) = _tokenOwners.at(index);
1514         return tokenId;
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-approve}.
1519      */
1520     function approve(address to, uint256 tokenId) public virtual override {
1521         address owner = ERC721.ownerOf(tokenId);
1522         require(to != owner, "ERC721: approval to current owner");
1523 
1524         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1525             "ERC721: approve caller is not owner nor approved for all"
1526         );
1527 
1528         _approve(to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-getApproved}.
1533      */
1534     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1535         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1536 
1537         return _tokenApprovals[tokenId];
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-setApprovalForAll}.
1542      */
1543     function setApprovalForAll(address operator, bool approved) public virtual override {
1544         require(operator != _msgSender(), "ERC721: approve to caller");
1545 
1546         _operatorApprovals[_msgSender()][operator] = approved;
1547         emit ApprovalForAll(_msgSender(), operator, approved);
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-isApprovedForAll}.
1552      */
1553     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1554         return _operatorApprovals[owner][operator];
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-transferFrom}.
1559      */
1560     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1561         //solhint-disable-next-line max-line-length
1562         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1563 
1564         _transfer(from, to, tokenId);
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-safeTransferFrom}.
1569      */
1570     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1571         safeTransferFrom(from, to, tokenId, "");
1572     }
1573 
1574     /**
1575      * @dev See {IERC721-safeTransferFrom}.
1576      */
1577     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1578         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1579         _safeTransfer(from, to, tokenId, _data);
1580     }
1581 
1582     /**
1583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1585      *
1586      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1587      *
1588      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1589      * implement alternative mechanisms to perform token transfer, such as signature-based.
1590      *
1591      * Requirements:
1592      *
1593      * - `from` cannot be the zero address.
1594      * - `to` cannot be the zero address.
1595      * - `tokenId` token must exist and be owned by `from`.
1596      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1597      *
1598      * Emits a {Transfer} event.
1599      */
1600     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1601         _transfer(from, to, tokenId);
1602         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1603     }
1604 
1605     /**
1606      * @dev Returns whether `tokenId` exists.
1607      *
1608      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1609      *
1610      * Tokens start existing when they are minted (`_mint`),
1611      * and stop existing when they are burned (`_burn`).
1612      */
1613     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1614         return _tokenOwners.contains(tokenId);
1615     }
1616 
1617     /**
1618      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1619      *
1620      * Requirements:
1621      *
1622      * - `tokenId` must exist.
1623      */
1624     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1625         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1626         address owner = ERC721.ownerOf(tokenId);
1627         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1628     }
1629 
1630     /**
1631      * @dev Safely mints `tokenId` and transfers it to `to`.
1632      *
1633      * Requirements:
1634      d*
1635      * - `tokenId` must not exist.
1636      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function _safeMint(address to, uint256 tokenId) internal virtual {
1641         _safeMint(to, tokenId, "");
1642     }
1643 
1644     /**
1645      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1646      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1647      */
1648     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1649         _mint(to, tokenId);
1650         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1651     }
1652 
1653     /**
1654      * @dev Mints `tokenId` and transfers it to `to`.
1655      *
1656      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1657      *
1658      * Requirements:
1659      *
1660      * - `tokenId` must not exist.
1661      * - `to` cannot be the zero address.
1662      *
1663      * Emits a {Transfer} event.
1664      */
1665     function _mint(address to, uint256 tokenId) internal virtual {
1666         require(to != address(0), "ERC721: mint to the zero address");
1667         require(!_exists(tokenId), "ERC721: token already minted");
1668 
1669         _beforeTokenTransfer(address(0), to, tokenId);
1670 
1671         _holderTokens[to].add(tokenId);
1672 
1673         _tokenOwners.set(tokenId, to);
1674 
1675         emit Transfer(address(0), to, tokenId);
1676     }
1677 
1678     /**
1679      * @dev Destroys `tokenId`.
1680      * The approval is cleared when the token is burned.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      *
1686      * Emits a {Transfer} event.
1687      */
1688     function _burn(uint256 tokenId) internal virtual {
1689         address owner = ERC721.ownerOf(tokenId); // internal owner
1690 
1691         _beforeTokenTransfer(owner, address(0), tokenId);
1692 
1693         // Clear approvals
1694         _approve(address(0), tokenId);
1695 
1696         // Clear metadata (if any)
1697         if (bytes(_tokenURIs[tokenId]).length != 0) {
1698             delete _tokenURIs[tokenId];
1699         }
1700 
1701         _holderTokens[owner].remove(tokenId);
1702 
1703         _tokenOwners.remove(tokenId);
1704 
1705         emit Transfer(owner, address(0), tokenId);
1706     }
1707 
1708     /**
1709      * @dev Transfers `tokenId` from `from` to `to`.
1710      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1711      *
1712      * Requirements:
1713      *
1714      * - `to` cannot be the zero address.
1715      * - `tokenId` token must be owned by `from`.
1716      *
1717      * Emits a {Transfer} event.
1718      */
1719     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1720         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1721         require(to != address(0), "ERC721: transfer to the zero address");
1722 
1723         _beforeTokenTransfer(from, to, tokenId);
1724 
1725         // Clear approvals from the previous owner
1726         _approve(address(0), tokenId);
1727 
1728         _holderTokens[from].remove(tokenId);
1729         _holderTokens[to].add(tokenId);
1730 
1731         _tokenOwners.set(tokenId, to);
1732 
1733         emit Transfer(from, to, tokenId);
1734     }
1735 
1736     /**
1737      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1738      *
1739      * Requirements:
1740      *
1741      * - `tokenId` must exist.
1742      */
1743     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1744         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1745         _tokenURIs[tokenId] = _tokenURI;
1746     }
1747 
1748     /**
1749      * @dev Internal function to set the base URI for all token IDs. It is
1750      * automatically added as a prefix to the value returned in {tokenURI},
1751      * or to the token ID if {tokenURI} is empty.
1752      */
1753     function _setBaseURI(string memory baseURI_) internal virtual {
1754         _baseURI = baseURI_;
1755     }
1756 
1757     /**
1758      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1759      * The call is not executed if the target address is not a contract.
1760      *
1761      * @param from address representing the previous owner of the given token ID
1762      * @param to target address that will receive the tokens
1763      * @param tokenId uint256 ID of the token to be transferred
1764      * @param _data bytes optional data to send along with the call
1765      * @return bool whether the call correctly returned the expected magic value
1766      */
1767     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1768         private returns (bool)
1769     {
1770         if (!to.isContract()) {
1771             return true;
1772         }
1773         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1774             IERC721Receiver(to).onERC721Received.selector,
1775             _msgSender(),
1776             from,
1777             tokenId,
1778             _data
1779         ), "ERC721: transfer to non ERC721Receiver implementer");
1780         bytes4 retval = abi.decode(returndata, (bytes4));
1781         return (retval == _ERC721_RECEIVED);
1782     }
1783 
1784     /**
1785      * @dev Approve `to` to operate on `tokenId`
1786      *
1787      * Emits an {Approval} event.
1788      */
1789     function _approve(address to, uint256 tokenId) internal virtual {
1790         _tokenApprovals[tokenId] = to;
1791         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1792     }
1793 
1794     /**
1795      * @dev Hook that is called before any token transfer. This includes minting
1796      * and burning.
1797      *
1798      * Calling conditions:
1799      *
1800      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1801      * transferred to `to`.
1802      * - When `from` is zero, `tokenId` will be minted for `to`.
1803      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1804      * - `from` cannot be the zero address.
1805      * - `to` cannot be the zero address.
1806      *
1807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1808      */
1809     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1810 }
1811 
1812 // File: @openzeppelin/contracts/access/Ownable.sol
1813 
1814 
1815 
1816 pragma solidity >=0.6.0 <0.8.0;
1817 
1818 /**
1819  * @dev Contract module which provides a basic access control mechanism, where
1820  * there is an account (an owner) that can be granted exclusive access to
1821  * specific functions.
1822  *
1823  * By default, the owner account will be the one that deploys the contract. This
1824  * can later be changed with {transferOwnership}.
1825  *
1826  * This module is used through inheritance. It will make available the modifier
1827  * `onlyOwner`, which can be applied to your functions to restrict their use to
1828  * the owner.
1829  */
1830 abstract contract Ownable is Context {
1831     address private _owner;
1832 
1833     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1834 
1835     /**
1836      * @dev Initializes the contract setting the deployer as the initial owner.
1837      */
1838     constructor () internal {
1839         address msgSender = _msgSender();
1840         _owner = msgSender;
1841         emit OwnershipTransferred(address(0), msgSender);
1842     }
1843 
1844     /**
1845      * @dev Returns the address of the current owner.
1846      */
1847     function owner() public view virtual returns (address) {
1848         return _owner;
1849     }
1850 
1851     /**
1852      * @dev Throws if called by any account other than the owner.
1853      */
1854     modifier onlyOwner() {
1855         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1856         _;
1857     }
1858 
1859     /**
1860      * @dev Leaves the contract without owner. It will not be possible to call
1861      * `onlyOwner` functions anymore. Can only be called by the current owner.
1862      *
1863      * NOTE: Renouncing ownership will leave the contract without an owner,
1864      * thereby removing any functionality that is only available to the owner.
1865      */
1866     function renounceOwnership() public virtual onlyOwner {
1867         emit OwnershipTransferred(_owner, address(0));
1868         _owner = address(0);
1869     }
1870 
1871     /**
1872      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1873      * Can only be called by the current owner.
1874      */
1875     function transferOwnership(address newOwner) public virtual onlyOwner {
1876         require(newOwner != address(0), "Ownable: new owner is the zero address");
1877         emit OwnershipTransferred(_owner, newOwner);
1878         _owner = newOwner;
1879     }
1880 }
1881 
1882 
1883 // Following the recent worldwide pandemic, emerging reports suggest that several banana species have begun exhibiting strange characteristics. Our research team located across the globe has commenced efforts to study and document these unusual phenomena.
1884 
1885 // Concerned about parties trying to suppress our research, the team has opted to store our findings on the blockchain to prevent interference. Although this is a costly endeavour, our mission has never been clearer.
1886 
1887 // The fate of the world's bananas depends on it.
1888 
1889 // from our website (https://boringbananas.co)
1890 
1891 // BoringBananasCo is a community-centered enterprise focussed on preserving our research about the emerging reports that several banana species have begun exhibiting strange characteristics following the recent worldwide pandemic. 
1892 // Our research team located across the globe has commenced efforts to study and document these unusual phenomena. 
1893 // Concerned about parties trying to suppress our research, the team has opted to store our findings on the blockchain to prevent interference. 
1894 // Although this is a costly endeavour, our mission has never been clearer. 
1895 // The fate of the world's bananas depends on it.
1896 
1897 // BANANA RESEARCH TEAM:
1898 
1899 // VEE - @thedigitalvee
1900 // MJDATA - @ChampagneMan
1901 // MADBOOGIE - @MadBoogieArt
1902 // JUI - @mz09art
1903 // BERK - @berkozdemir
1904 
1905 pragma solidity ^0.7.0;
1906 pragma abicoder v2;
1907 
1908 contract BoringBananasCo is ERC721, Ownable {
1909     
1910     using SafeMath for uint256;
1911 
1912     string public BANANA_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN BANANAS ARE ALL SOLD OUT
1913     
1914     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1915     
1916     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1917 
1918     uint256 public constant bananaPrice = 25000000000000000; // 0.025 ETH
1919 
1920     uint public constant maxBananaPurchase = 20;
1921 
1922     uint256 public constant MAX_BANANAS = 8888;
1923 
1924     bool public saleIsActive = false;
1925     
1926     mapping(uint => string) public bananaNames;
1927     
1928     // Reserve 125 Bananas for team - Giveaways/Prizes etc
1929     uint public bananaReserve = 125;
1930     
1931     event bananaNameChange(address _by, uint _tokenId, string _name);
1932     
1933     event licenseisLocked(string _licenseText);
1934 
1935     constructor() ERC721("Boring Bananas Co.", "BBC") { }
1936     
1937     function withdraw() public onlyOwner {
1938         uint balance = address(this).balance;
1939         msg.sender.transfer(balance);
1940     }
1941     
1942     function reserveBananas(address _to, uint256 _reserveAmount) public onlyOwner {        
1943         uint supply = totalSupply();
1944         require(_reserveAmount > 0 && _reserveAmount <= bananaReserve, "Not enough reserve left for team");
1945         for (uint i = 0; i < _reserveAmount; i++) {
1946             _safeMint(_to, supply + i);
1947         }
1948         bananaReserve = bananaReserve.sub(_reserveAmount);
1949     }
1950 
1951 
1952     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1953         BANANA_PROVENANCE = provenanceHash;
1954     }
1955 
1956     function setBaseURI(string memory baseURI) public onlyOwner {
1957         _setBaseURI(baseURI);
1958     }
1959 
1960 
1961     function flipSaleState() public onlyOwner {
1962         saleIsActive = !saleIsActive;
1963     }
1964     
1965     
1966     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1967         uint256 tokenCount = balanceOf(_owner);
1968         if (tokenCount == 0) {
1969             // Return an empty array
1970             return new uint256[](0);
1971         } else {
1972             uint256[] memory result = new uint256[](tokenCount);
1973             uint256 index;
1974             for (index = 0; index < tokenCount; index++) {
1975                 result[index] = tokenOfOwnerByIndex(_owner, index);
1976             }
1977             return result;
1978         }
1979     }
1980     
1981     // Returns the license for tokens
1982     function tokenLicense(uint _id) public view returns(string memory) {
1983         require(_id < totalSupply(), "CHOOSE A BANANA WITHIN RANGE");
1984         return LICENSE_TEXT;
1985     }
1986     
1987     // Locks the license to prevent further changes 
1988     function lockLicense() public onlyOwner {
1989         licenseLocked =  true;
1990         emit licenseisLocked(LICENSE_TEXT);
1991     }
1992     
1993     // Change the license
1994     function changeLicense(string memory _license) public onlyOwner {
1995         require(licenseLocked == false, "License already locked");
1996         LICENSE_TEXT = _license;
1997     }
1998     
1999     
2000     function mintBoringBanana(uint numberOfTokens) public payable {
2001         require(saleIsActive, "Sale must be active to mint Banana");
2002         require(numberOfTokens > 0 && numberOfTokens <= maxBananaPurchase, "Can only mint 20 tokens at a time");
2003         require(totalSupply().add(numberOfTokens) <= MAX_BANANAS, "Purchase would exceed max supply of Bananas");
2004         require(msg.value >= bananaPrice.mul(numberOfTokens), "Ether value sent is not correct");
2005         
2006         for(uint i = 0; i < numberOfTokens; i++) {
2007             uint mintIndex = totalSupply();
2008             if (totalSupply() < MAX_BANANAS) {
2009                 _safeMint(msg.sender, mintIndex);
2010             }
2011         }
2012 
2013     }
2014      
2015     function changeBananaName(uint _tokenId, string memory _name) public {
2016         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this banana!");
2017         require(sha256(bytes(_name)) != sha256(bytes(bananaNames[_tokenId])), "New name is same as the current one");
2018         bananaNames[_tokenId] = _name;
2019         
2020         emit bananaNameChange(msg.sender, _tokenId, _name);
2021         
2022     }
2023     
2024     function viewBananaName(uint _tokenId) public view returns( string memory ){
2025         require( _tokenId < totalSupply(), "Choose a banana within range" );
2026         return bananaNames[_tokenId];
2027     }
2028     
2029     
2030     // GET ALL BANANAS OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2031     function bananaNamesOfOwner(address _owner) external view returns(string[] memory ) {
2032         uint256 tokenCount = balanceOf(_owner);
2033         if (tokenCount == 0) {
2034             // Return an empty array
2035             return new string[](0);
2036         } else {
2037             string[] memory result = new string[](tokenCount);
2038             uint256 index;
2039             for (index = 0; index < tokenCount; index++) {
2040                 result[index] = bananaNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2041             }
2042             return result;
2043         }
2044     }
2045     
2046 }