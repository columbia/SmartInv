1 // SPDX-License-Identifier: MIT
2 
3 /*
4   ___ _   _ _  _ _  _____ _  _   ___  ___  _   _ ___ ___  ___ 
5  / __| | | | \| | |/ / __| \| | / __|/ _ \| | | |_ _|   \/ __|
6  \__ \ |_| | .` | ' <| _|| .` | \__ \ (_) | |_| || || |) \__ \
7  |___/\___/|_|\_|_|\_\___|_|\_| |___/\__\_\\___/|___|___/|___/
8                                                               
9 
10 */
11 
12 // File: @openzeppelin/contracts/utils/Context.sol
13 
14 pragma solidity >=0.6.0 <0.8.0;
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/introspection/IERC165.sol
38 
39 
40 
41 pragma solidity >=0.6.0 <0.8.0;
42 
43 /**
44  * @dev Interface of the ERC165 standard, as defined in the
45  * https://eips.ethereum.org/EIPS/eip-165[EIP].
46  *
47  * Implementers can declare support of contract interfaces, which can then be
48  * queried by others ({ERC165Checker}).
49  *
50  * For an implementation, see {ERC165}.
51  */
52 interface IERC165 {
53     /**
54      * @dev Returns true if this contract implements the interface defined by
55      * `interfaceId`. See the corresponding
56      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
57      * to learn more about how these ids are created.
58      *
59      * This function call must use less than 30 000 gas.
60      */
61     function supportsInterface(bytes4 interfaceId) external view returns (bool);
62 }
63 
64 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
65 
66 
67 
68 pragma solidity >=0.6.2 <0.8.0;
69 
70 
71 /**
72  * @dev Required interface of an ERC721 compliant contract.
73  */
74 interface IERC721 is IERC165 {
75     /**
76      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
82      */
83     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
89 
90     /**
91      * @dev Returns the number of tokens in ``owner``'s account.
92      */
93     function balanceOf(address owner) external view returns (uint256 balance);
94 
95     /**
96      * @dev Returns the owner of the `tokenId` token.
97      *
98      * Requirements:
99      *
100      * - `tokenId` must exist.
101      */
102     function ownerOf(uint256 tokenId) external view returns (address owner);
103 
104     /**
105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must exist and be owned by `from`.
113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
115      *
116      * Emits a {Transfer} event.
117      */
118     function safeTransferFrom(address from, address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(address from, address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
138      * The approval is cleared when the token is transferred.
139      *
140      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
141      *
142      * Requirements:
143      *
144      * - The caller must own the token or be an approved operator.
145      * - `tokenId` must exist.
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Returns the account approved for `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function getApproved(uint256 tokenId) external view returns (address operator);
159 
160     /**
161      * @dev Approve or remove `operator` as an operator for the caller.
162      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
163      *
164      * Requirements:
165      *
166      * - The `operator` cannot be the caller.
167      *
168      * Emits an {ApprovalForAll} event.
169      */
170     function setApprovalForAll(address operator, bool _approved) external;
171 
172     /**
173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
174      *
175      * See {setApprovalForAll}
176      */
177     function isApprovedForAll(address owner, address operator) external view returns (bool);
178 
179     /**
180       * @dev Safely transfers `tokenId` token from `from` to `to`.
181       *
182       * Requirements:
183       *
184       * - `from` cannot be the zero address.
185       * - `to` cannot be the zero address.
186       * - `tokenId` token must exist and be owned by `from`.
187       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189       *
190       * Emits a {Transfer} event.
191       */
192     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
196 
197 
198 
199 pragma solidity >=0.6.2 <0.8.0;
200 
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207 
208     /**
209      * @dev Returns the token collection name.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the token collection symbol.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
220      */
221     function tokenURI(uint256 tokenId) external view returns (string memory);
222 }
223 
224 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
225 
226 
227 
228 pragma solidity >=0.6.2 <0.8.0;
229 
230 
231 /**
232  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
233  * @dev See https://eips.ethereum.org/EIPS/eip-721
234  */
235 interface IERC721Enumerable is IERC721 {
236 
237     /**
238      * @dev Returns the total amount of tokens stored by the contract.
239      */
240     function totalSupply() external view returns (uint256);
241 
242     /**
243      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
244      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
245      */
246     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
247 
248     /**
249      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
250      * Use along with {totalSupply} to enumerate all tokens.
251      */
252     function tokenByIndex(uint256 index) external view returns (uint256);
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
256 
257 
258 
259 pragma solidity >=0.6.0 <0.8.0;
260 
261 /**
262  * @title ERC721 token receiver interface
263  * @dev Interface for any contract that wants to support safeTransfers
264  * from ERC721 asset contracts.
265  */
266 interface IERC721Receiver {
267     /**
268      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
269      * by `operator` from `from`, this function is called.
270      *
271      * It must return its Solidity selector to confirm the token transfer.
272      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
273      *
274      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
275      */
276     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
277 }
278 
279 // File: @openzeppelin/contracts/introspection/ERC165.sol
280 
281 
282 
283 pragma solidity >=0.6.0 <0.8.0;
284 
285 
286 /**
287  * @dev Implementation of the {IERC165} interface.
288  *
289  * Contracts may inherit from this and call {_registerInterface} to declare
290  * their support of an interface.
291  */
292 abstract contract ERC165 is IERC165 {
293     /*
294      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
295      */
296     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
297 
298     /**
299      * @dev Mapping of interface ids to whether or not it's supported.
300      */
301     mapping(bytes4 => bool) private _supportedInterfaces;
302 
303     constructor () internal {
304         // Derived contracts need only register support for their own interfaces,
305         // we register support for ERC165 itself here
306         _registerInterface(_INTERFACE_ID_ERC165);
307     }
308 
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      *
312      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return _supportedInterfaces[interfaceId];
316     }
317 
318     /**
319      * @dev Registers the contract as an implementer of the interface defined by
320      * `interfaceId`. Support of the actual ERC165 interface is automatic and
321      * registering its interface id is not required.
322      *
323      * See {IERC165-supportsInterface}.
324      *
325      * Requirements:
326      *
327      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
328      */
329     function _registerInterface(bytes4 interfaceId) internal virtual {
330         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
331         _supportedInterfaces[interfaceId] = true;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/math/SafeMath.sol
336 
337 
338 
339 pragma solidity >=0.6.0 <0.8.0;
340 
341 /**
342  * @dev Wrappers over Solidity's arithmetic operations with added overflow
343  * checks.
344  *
345  * Arithmetic operations in Solidity wrap on overflow. This can easily result
346  * in bugs, because programmers usually assume that an overflow raises an
347  * error, which is the standard behavior in high level programming languages.
348  * `SafeMath` restores this intuition by reverting the transaction when an
349  * operation overflows.
350  *
351  * Using this library instead of the unchecked operations eliminates an entire
352  * class of bugs, so it's recommended to use it always.
353  */
354 library SafeMath {
355     /**
356      * @dev Returns the addition of two unsigned integers, with an overflow flag.
357      *
358      * _Available since v3.4._
359      */
360     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         uint256 c = a + b;
362         if (c < a) return (false, 0);
363         return (true, c);
364     }
365 
366     /**
367      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
368      *
369      * _Available since v3.4._
370      */
371     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         if (b > a) return (false, 0);
373         return (true, a - b);
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
378      *
379      * _Available since v3.4._
380      */
381     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
382         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
383         // benefit is lost if 'b' is also tested.
384         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
385         if (a == 0) return (true, 0);
386         uint256 c = a * b;
387         if (c / a != b) return (false, 0);
388         return (true, c);
389     }
390 
391     /**
392      * @dev Returns the division of two unsigned integers, with a division by zero flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         if (b == 0) return (false, 0);
398         return (true, a / b);
399     }
400 
401     /**
402      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
403      *
404      * _Available since v3.4._
405      */
406     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
407         if (b == 0) return (false, 0);
408         return (true, a % b);
409     }
410 
411     /**
412      * @dev Returns the addition of two unsigned integers, reverting on
413      * overflow.
414      *
415      * Counterpart to Solidity's `+` operator.
416      *
417      * Requirements:
418      *
419      * - Addition cannot overflow.
420      */
421     function add(uint256 a, uint256 b) internal pure returns (uint256) {
422         uint256 c = a + b;
423         require(c >= a, "SafeMath: addition overflow");
424         return c;
425     }
426 
427     /**
428      * @dev Returns the subtraction of two unsigned integers, reverting on
429      * overflow (when the result is negative).
430      *
431      * Counterpart to Solidity's `-` operator.
432      *
433      * Requirements:
434      *
435      * - Subtraction cannot overflow.
436      */
437     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
438         require(b <= a, "SafeMath: subtraction overflow");
439         return a - b;
440     }
441 
442     /**
443      * @dev Returns the multiplication of two unsigned integers, reverting on
444      * overflow.
445      *
446      * Counterpart to Solidity's `*` operator.
447      *
448      * Requirements:
449      *
450      * - Multiplication cannot overflow.
451      */
452     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
453         if (a == 0) return 0;
454         uint256 c = a * b;
455         require(c / a == b, "SafeMath: multiplication overflow");
456         return c;
457     }
458 
459     /**
460      * @dev Returns the integer division of two unsigned integers, reverting on
461      * division by zero. The result is rounded towards zero.
462      *
463      * Counterpart to Solidity's `/` operator. Note: this function uses a
464      * `revert` opcode (which leaves remaining gas untouched) while Solidity
465      * uses an invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function div(uint256 a, uint256 b) internal pure returns (uint256) {
472         require(b > 0, "SafeMath: division by zero");
473         return a / b;
474     }
475 
476     /**
477      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
478      * reverting when dividing by zero.
479      *
480      * Counterpart to Solidity's `%` operator. This function uses a `revert`
481      * opcode (which leaves remaining gas untouched) while Solidity uses an
482      * invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
489         require(b > 0, "SafeMath: modulo by zero");
490         return a % b;
491     }
492 
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
495      * overflow (when the result is negative).
496      *
497      * CAUTION: This function is deprecated because it requires allocating memory for the error
498      * message unnecessarily. For custom revert reasons use {trySub}.
499      *
500      * Counterpart to Solidity's `-` operator.
501      *
502      * Requirements:
503      *
504      * - Subtraction cannot overflow.
505      */
506     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b <= a, errorMessage);
508         return a - b;
509     }
510 
511     /**
512      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
513      * division by zero. The result is rounded towards zero.
514      *
515      * CAUTION: This function is deprecated because it requires allocating memory for the error
516      * message unnecessarily. For custom revert reasons use {tryDiv}.
517      *
518      * Counterpart to Solidity's `/` operator. Note: this function uses a
519      * `revert` opcode (which leaves remaining gas untouched) while Solidity
520      * uses an invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b > 0, errorMessage);
528         return a / b;
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * reverting with custom message when dividing by zero.
534      *
535      * CAUTION: This function is deprecated because it requires allocating memory for the error
536      * message unnecessarily. For custom revert reasons use {tryMod}.
537      *
538      * Counterpart to Solidity's `%` operator. This function uses a `revert`
539      * opcode (which leaves remaining gas untouched) while Solidity uses an
540      * invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
547         require(b > 0, errorMessage);
548         return a % b;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/utils/Address.sol
553 
554 
555 
556 pragma solidity >=0.6.2 <0.8.0;
557 
558 /**
559  * @dev Collection of functions related to the address type
560  */
561 library Address {
562     /**
563      * @dev Returns true if `account` is a contract.
564      *
565      * [IMPORTANT]
566      * ====
567      * It is unsafe to assume that an address for which this function returns
568      * false is an externally-owned account (EOA) and not a contract.
569      *
570      * Among others, `isContract` will return false for the following
571      * types of addresses:
572      *
573      *  - an externally-owned account
574      *  - a contract in construction
575      *  - an address where a contract will be created
576      *  - an address where a contract lived, but was destroyed
577      * ====
578      */
579     function isContract(address account) internal view returns (bool) {
580         // This method relies on extcodesize, which returns 0 for contracts in
581         // construction, since the code is only stored at the end of the
582         // constructor execution.
583 
584         uint256 size;
585         // solhint-disable-next-line no-inline-assembly
586         assembly { size := extcodesize(account) }
587         return size > 0;
588     }
589 
590     /**
591      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
592      * `recipient`, forwarding all available gas and reverting on errors.
593      *
594      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
595      * of certain opcodes, possibly making contracts go over the 2300 gas limit
596      * imposed by `transfer`, making them unable to receive funds via
597      * `transfer`. {sendValue} removes this limitation.
598      *
599      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
600      *
601      * IMPORTANT: because control is transferred to `recipient`, care must be
602      * taken to not create reentrancy vulnerabilities. Consider using
603      * {ReentrancyGuard} or the
604      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
605      */
606     function sendValue(address payable recipient, uint256 amount) internal {
607         require(address(this).balance >= amount, "Address: insufficient balance");
608 
609         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
610         (bool success, ) = recipient.call{ value: amount }("");
611         require(success, "Address: unable to send value, recipient may have reverted");
612     }
613 
614     /**
615      * @dev Performs a Solidity function call using a low level `call`. A
616      * plain`call` is an unsafe replacement for a function call: use this
617      * function instead.
618      *
619      * If `target` reverts with a revert reason, it is bubbled up by this
620      * function (like regular Solidity function calls).
621      *
622      * Returns the raw returned data. To convert to the expected return value,
623      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
624      *
625      * Requirements:
626      *
627      * - `target` must be a contract.
628      * - calling `target` with `data` must not revert.
629      *
630      * _Available since v3.1._
631      */
632     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
633       return functionCall(target, data, "Address: low-level call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
638      * `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
643         return functionCallWithValue(target, data, 0, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but also transferring `value` wei to `target`.
649      *
650      * Requirements:
651      *
652      * - the calling contract must have an ETH balance of at least `value`.
653      * - the called Solidity function must be `payable`.
654      *
655      * _Available since v3.1._
656      */
657     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
658         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
663      * with `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
668         require(address(this).balance >= value, "Address: insufficient balance for call");
669         require(isContract(target), "Address: call to non-contract");
670 
671         // solhint-disable-next-line avoid-low-level-calls
672         (bool success, bytes memory returndata) = target.call{ value: value }(data);
673         return _verifyCallResult(success, returndata, errorMessage);
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
678      * but performing a static call.
679      *
680      * _Available since v3.3._
681      */
682     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
683         return functionStaticCall(target, data, "Address: low-level static call failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
688      * but performing a static call.
689      *
690      * _Available since v3.3._
691      */
692     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
693         require(isContract(target), "Address: static call to non-contract");
694 
695         // solhint-disable-next-line avoid-low-level-calls
696         (bool success, bytes memory returndata) = target.staticcall(data);
697         return _verifyCallResult(success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
702      * but performing a delegate call.
703      *
704      * _Available since v3.4._
705      */
706     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
707         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
712      * but performing a delegate call.
713      *
714      * _Available since v3.4._
715      */
716     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
717         require(isContract(target), "Address: delegate call to non-contract");
718 
719         // solhint-disable-next-line avoid-low-level-calls
720         (bool success, bytes memory returndata) = target.delegatecall(data);
721         return _verifyCallResult(success, returndata, errorMessage);
722     }
723 
724     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
725         if (success) {
726             return returndata;
727         } else {
728             // Look for revert reason and bubble it up if present
729             if (returndata.length > 0) {
730                 // The easiest way to bubble the revert reason is using memory via assembly
731 
732                 // solhint-disable-next-line no-inline-assembly
733                 assembly {
734                     let returndata_size := mload(returndata)
735                     revert(add(32, returndata), returndata_size)
736                 }
737             } else {
738                 revert(errorMessage);
739             }
740         }
741     }
742 }
743 
744 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
745 
746 
747 
748 pragma solidity >=0.6.0 <0.8.0;
749 
750 /**
751  * @dev Library for managing
752  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
753  * types.
754  *
755  * Sets have the following properties:
756  *
757  * - Elements are added, removed, and checked for existence in constant time
758  * (O(1)).
759  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
760  *
761  * ```
762  * contract Example {
763  *     // Add the library methods
764  *     using EnumerableSet for EnumerableSet.AddressSet;
765  *
766  *     // Declare a set state variable
767  *     EnumerableSet.AddressSet private mySet;
768  * }
769  * ```
770  *
771  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
772  * and `uint256` (`UintSet`) are supported.
773  */
774 library EnumerableSet {
775     // To implement this library for multiple types with as little code
776     // repetition as possible, we write it in terms of a generic Set type with
777     // bytes32 values.
778     // The Set implementation uses private functions, and user-facing
779     // implementations (such as AddressSet) are just wrappers around the
780     // underlying Set.
781     // This means that we can only create new EnumerableSets for types that fit
782     // in bytes32.
783 
784     struct Set {
785         // Storage of set values
786         bytes32[] _values;
787 
788         // Position of the value in the `values` array, plus 1 because index 0
789         // means a value is not in the set.
790         mapping (bytes32 => uint256) _indexes;
791     }
792 
793     /**
794      * @dev Add a value to a set. O(1).
795      *
796      * Returns true if the value was added to the set, that is if it was not
797      * already present.
798      */
799     function _add(Set storage set, bytes32 value) private returns (bool) {
800         if (!_contains(set, value)) {
801             set._values.push(value);
802             // The value is stored at length-1, but we add 1 to all indexes
803             // and use 0 as a sentinel value
804             set._indexes[value] = set._values.length;
805             return true;
806         } else {
807             return false;
808         }
809     }
810 
811     /**
812      * @dev Removes a value from a set. O(1).
813      *
814      * Returns true if the value was removed from the set, that is if it was
815      * present.
816      */
817     function _remove(Set storage set, bytes32 value) private returns (bool) {
818         // We read and store the value's index to prevent multiple reads from the same storage slot
819         uint256 valueIndex = set._indexes[value];
820 
821         if (valueIndex != 0) { // Equivalent to contains(set, value)
822             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
823             // the array, and then remove the last element (sometimes called as 'swap and pop').
824             // This modifies the order of the array, as noted in {at}.
825 
826             uint256 toDeleteIndex = valueIndex - 1;
827             uint256 lastIndex = set._values.length - 1;
828 
829             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
830             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
831 
832             bytes32 lastvalue = set._values[lastIndex];
833 
834             // Move the last value to the index where the value to delete is
835             set._values[toDeleteIndex] = lastvalue;
836             // Update the index for the moved value
837             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
838 
839             // Delete the slot where the moved value was stored
840             set._values.pop();
841 
842             // Delete the index for the deleted slot
843             delete set._indexes[value];
844 
845             return true;
846         } else {
847             return false;
848         }
849     }
850 
851     /**
852      * @dev Returns true if the value is in the set. O(1).
853      */
854     function _contains(Set storage set, bytes32 value) private view returns (bool) {
855         return set._indexes[value] != 0;
856     }
857 
858     /**
859      * @dev Returns the number of values on the set. O(1).
860      */
861     function _length(Set storage set) private view returns (uint256) {
862         return set._values.length;
863     }
864 
865    /**
866     * @dev Returns the value stored at position `index` in the set. O(1).
867     *
868     * Note that there are no guarantees on the ordering of values inside the
869     * array, and it may change when more values are added or removed.
870     *
871     * Requirements:
872     *
873     * - `index` must be strictly less than {length}.
874     */
875     function _at(Set storage set, uint256 index) private view returns (bytes32) {
876         require(set._values.length > index, "EnumerableSet: index out of bounds");
877         return set._values[index];
878     }
879 
880     // Bytes32Set
881 
882     struct Bytes32Set {
883         Set _inner;
884     }
885 
886     /**
887      * @dev Add a value to a set. O(1).
888      *
889      * Returns true if the value was added to the set, that is if it was not
890      * already present.
891      */
892     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
893         return _add(set._inner, value);
894     }
895 
896     /**
897      * @dev Removes a value from a set. O(1).
898      *
899      * Returns true if the value was removed from the set, that is if it was
900      * present.
901      */
902     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
903         return _remove(set._inner, value);
904     }
905 
906     /**
907      * @dev Returns true if the value is in the set. O(1).
908      */
909     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
910         return _contains(set._inner, value);
911     }
912 
913     /**
914      * @dev Returns the number of values in the set. O(1).
915      */
916     function length(Bytes32Set storage set) internal view returns (uint256) {
917         return _length(set._inner);
918     }
919 
920    /**
921     * @dev Returns the value stored at position `index` in the set. O(1).
922     *
923     * Note that there are no guarantees on the ordering of values inside the
924     * array, and it may change when more values are added or removed.
925     *
926     * Requirements:
927     *
928     * - `index` must be strictly less than {length}.
929     */
930     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
931         return _at(set._inner, index);
932     }
933 
934     // AddressSet
935 
936     struct AddressSet {
937         Set _inner;
938     }
939 
940     /**
941      * @dev Add a value to a set. O(1).
942      *
943      * Returns true if the value was added to the set, that is if it was not
944      * already present.
945      */
946     function add(AddressSet storage set, address value) internal returns (bool) {
947         return _add(set._inner, bytes32(uint256(uint160(value))));
948     }
949 
950     /**
951      * @dev Removes a value from a set. O(1).
952      *
953      * Returns true if the value was removed from the set, that is if it was
954      * present.
955      */
956     function remove(AddressSet storage set, address value) internal returns (bool) {
957         return _remove(set._inner, bytes32(uint256(uint160(value))));
958     }
959 
960     /**
961      * @dev Returns true if the value is in the set. O(1).
962      */
963     function contains(AddressSet storage set, address value) internal view returns (bool) {
964         return _contains(set._inner, bytes32(uint256(uint160(value))));
965     }
966 
967     /**
968      * @dev Returns the number of values in the set. O(1).
969      */
970     function length(AddressSet storage set) internal view returns (uint256) {
971         return _length(set._inner);
972     }
973 
974    /**
975     * @dev Returns the value stored at position `index` in the set. O(1).
976     *
977     * Note that there are no guarantees on the ordering of values inside the
978     * array, and it may change when more values are added or removed.
979     *
980     * Requirements:
981     *
982     * - `index` must be strictly less than {length}.
983     */
984     function at(AddressSet storage set, uint256 index) internal view returns (address) {
985         return address(uint160(uint256(_at(set._inner, index))));
986     }
987 
988 
989     // UintSet
990 
991     struct UintSet {
992         Set _inner;
993     }
994 
995     /**
996      * @dev Add a value to a set. O(1).
997      *
998      * Returns true if the value was added to the set, that is if it was not
999      * already present.
1000      */
1001     function add(UintSet storage set, uint256 value) internal returns (bool) {
1002         return _add(set._inner, bytes32(value));
1003     }
1004 
1005     /**
1006      * @dev Removes a value from a set. O(1).
1007      *
1008      * Returns true if the value was removed from the set, that is if it was
1009      * present.
1010      */
1011     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1012         return _remove(set._inner, bytes32(value));
1013     }
1014 
1015     /**
1016      * @dev Returns true if the value is in the set. O(1).
1017      */
1018     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1019         return _contains(set._inner, bytes32(value));
1020     }
1021 
1022     /**
1023      * @dev Returns the number of values on the set. O(1).
1024      */
1025     function length(UintSet storage set) internal view returns (uint256) {
1026         return _length(set._inner);
1027     }
1028 
1029    /**
1030     * @dev Returns the value stored at position `index` in the set. O(1).
1031     *
1032     * Note that there are no guarantees on the ordering of values inside the
1033     * array, and it may change when more values are added or removed.
1034     *
1035     * Requirements:
1036     *
1037     * - `index` must be strictly less than {length}.
1038     */
1039     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1040         return uint256(_at(set._inner, index));
1041     }
1042 }
1043 
1044 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1045 
1046 
1047 
1048 pragma solidity >=0.6.0 <0.8.0;
1049 
1050 /**
1051  * @dev Library for managing an enumerable variant of Solidity's
1052  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1053  * type.
1054  *
1055  * Maps have the following properties:
1056  *
1057  * - Entries are added, removed, and checked for existence in constant time
1058  * (O(1)).
1059  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1060  *
1061  * ```
1062  * contract Example {
1063  *     // Add the library methods
1064  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1065  *
1066  *     // Declare a set state variable
1067  *     EnumerableMap.UintToAddressMap private myMap;
1068  * }
1069  * ```
1070  *
1071  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1072  * supported.
1073  */
1074 library EnumerableMap {
1075     // To implement this library for multiple types with as little code
1076     // repetition as possible, we write it in terms of a generic Map type with
1077     // bytes32 keys and values.
1078     // The Map implementation uses private functions, and user-facing
1079     // implementations (such as Uint256ToAddressMap) are just wrappers around
1080     // the underlying Map.
1081     // This means that we can only create new EnumerableMaps for types that fit
1082     // in bytes32.
1083 
1084     struct MapEntry {
1085         bytes32 _key;
1086         bytes32 _value;
1087     }
1088 
1089     struct Map {
1090         // Storage of map keys and values
1091         MapEntry[] _entries;
1092 
1093         // Position of the entry defined by a key in the `entries` array, plus 1
1094         // because index 0 means a key is not in the map.
1095         mapping (bytes32 => uint256) _indexes;
1096     }
1097 
1098     /**
1099      * @dev Adds a key-value pair to a map, or updates the value for an existing
1100      * key. O(1).
1101      *
1102      * Returns true if the key was added to the map, that is if it was not
1103      * already present.
1104      */
1105     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1106         // We read and store the key's index to prevent multiple reads from the same storage slot
1107         uint256 keyIndex = map._indexes[key];
1108 
1109         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1110             map._entries.push(MapEntry({ _key: key, _value: value }));
1111             // The entry is stored at length-1, but we add 1 to all indexes
1112             // and use 0 as a sentinel value
1113             map._indexes[key] = map._entries.length;
1114             return true;
1115         } else {
1116             map._entries[keyIndex - 1]._value = value;
1117             return false;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Removes a key-value pair from a map. O(1).
1123      *
1124      * Returns true if the key was removed from the map, that is if it was present.
1125      */
1126     function _remove(Map storage map, bytes32 key) private returns (bool) {
1127         // We read and store the key's index to prevent multiple reads from the same storage slot
1128         uint256 keyIndex = map._indexes[key];
1129 
1130         if (keyIndex != 0) { // Equivalent to contains(map, key)
1131             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1132             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1133             // This modifies the order of the array, as noted in {at}.
1134 
1135             uint256 toDeleteIndex = keyIndex - 1;
1136             uint256 lastIndex = map._entries.length - 1;
1137 
1138             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1139             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1140 
1141             MapEntry storage lastEntry = map._entries[lastIndex];
1142 
1143             // Move the last entry to the index where the entry to delete is
1144             map._entries[toDeleteIndex] = lastEntry;
1145             // Update the index for the moved entry
1146             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1147 
1148             // Delete the slot where the moved entry was stored
1149             map._entries.pop();
1150 
1151             // Delete the index for the deleted slot
1152             delete map._indexes[key];
1153 
1154             return true;
1155         } else {
1156             return false;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Returns true if the key is in the map. O(1).
1162      */
1163     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1164         return map._indexes[key] != 0;
1165     }
1166 
1167     /**
1168      * @dev Returns the number of key-value pairs in the map. O(1).
1169      */
1170     function _length(Map storage map) private view returns (uint256) {
1171         return map._entries.length;
1172     }
1173 
1174    /**
1175     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1176     *
1177     * Note that there are no guarantees on the ordering of entries inside the
1178     * array, and it may change when more entries are added or removed.
1179     *
1180     * Requirements:
1181     *
1182     * - `index` must be strictly less than {length}.
1183     */
1184     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1185         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1186 
1187         MapEntry storage entry = map._entries[index];
1188         return (entry._key, entry._value);
1189     }
1190 
1191     /**
1192      * @dev Tries to returns the value associated with `key`.  O(1).
1193      * Does not revert if `key` is not in the map.
1194      */
1195     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1196         uint256 keyIndex = map._indexes[key];
1197         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1198         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1199     }
1200 
1201     /**
1202      * @dev Returns the value associated with `key`.  O(1).
1203      *
1204      * Requirements:
1205      *
1206      * - `key` must be in the map.
1207      */
1208     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1209         uint256 keyIndex = map._indexes[key];
1210         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1211         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1212     }
1213 
1214     /**
1215      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1216      *
1217      * CAUTION: This function is deprecated because it requires allocating memory for the error
1218      * message unnecessarily. For custom revert reasons use {_tryGet}.
1219      */
1220     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1221         uint256 keyIndex = map._indexes[key];
1222         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1223         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1224     }
1225 
1226     // UintToAddressMap
1227 
1228     struct UintToAddressMap {
1229         Map _inner;
1230     }
1231 
1232     /**
1233      * @dev Adds a key-value pair to a map, or updates the value for an existing
1234      * key. O(1).
1235      *
1236      * Returns true if the key was added to the map, that is if it was not
1237      * already present.
1238      */
1239     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1240         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1241     }
1242 
1243     /**
1244      * @dev Removes a value from a set. O(1).
1245      *
1246      * Returns true if the key was removed from the map, that is if it was present.
1247      */
1248     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1249         return _remove(map._inner, bytes32(key));
1250     }
1251 
1252     /**
1253      * @dev Returns true if the key is in the map. O(1).
1254      */
1255     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1256         return _contains(map._inner, bytes32(key));
1257     }
1258 
1259     /**
1260      * @dev Returns the number of elements in the map. O(1).
1261      */
1262     function length(UintToAddressMap storage map) internal view returns (uint256) {
1263         return _length(map._inner);
1264     }
1265 
1266    /**
1267     * @dev Returns the element stored at position `index` in the set. O(1).
1268     * Note that there are no guarantees on the ordering of values inside the
1269     * array, and it may change when more values are added or removed.
1270     *
1271     * Requirements:
1272     *
1273     * - `index` must be strictly less than {length}.
1274     */
1275     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1276         (bytes32 key, bytes32 value) = _at(map._inner, index);
1277         return (uint256(key), address(uint160(uint256(value))));
1278     }
1279 
1280     /**
1281      * @dev Tries to returns the value associated with `key`.  O(1).
1282      * Does not revert if `key` is not in the map.
1283      *
1284      * _Available since v3.4._
1285      */
1286     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1287         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1288         return (success, address(uint160(uint256(value))));
1289     }
1290 
1291     /**
1292      * @dev Returns the value associated with `key`.  O(1).
1293      *
1294      * Requirements:
1295      *
1296      * - `key` must be in the map.
1297      */
1298     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1299         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1300     }
1301 
1302     /**
1303      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1304      *
1305      * CAUTION: This function is deprecated because it requires allocating memory for the error
1306      * message unnecessarily. For custom revert reasons use {tryGet}.
1307      */
1308     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1309         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1310     }
1311 }
1312 
1313 // File: @openzeppelin/contracts/utils/Strings.sol
1314 
1315 
1316 
1317 pragma solidity >=0.6.0 <0.8.0;
1318 
1319 /**
1320  * @dev String operations.
1321  */
1322 library Strings {
1323     /**
1324      * @dev Converts a `uint256` to its ASCII `string` representation.
1325      */
1326     function toString(uint256 value) internal pure returns (string memory) {
1327         // Inspired by OraclizeAPI's implementation - MIT licence
1328         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1329 
1330         if (value == 0) {
1331             return "0";
1332         }
1333         uint256 temp = value;
1334         uint256 digits;
1335         while (temp != 0) {
1336             digits++;
1337             temp /= 10;
1338         }
1339         bytes memory buffer = new bytes(digits);
1340         uint256 index = digits - 1;
1341         temp = value;
1342         while (temp != 0) {
1343             buffer[index--] = bytes1(uint8(48 + temp % 10));
1344             temp /= 10;
1345         }
1346         return string(buffer);
1347     }
1348 }
1349 
1350 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1351 
1352 
1353 
1354 pragma solidity >=0.6.0 <0.8.0;
1355 
1356 /**
1357  * @title ERC721 Non-Fungible Token Standard basic implementation
1358  * @dev see https://eips.ethereum.org/EIPS/eip-721
1359  */
1360  
1361 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1362     using SafeMath for uint256;
1363     using Address for address;
1364     using EnumerableSet for EnumerableSet.UintSet;
1365     using EnumerableMap for EnumerableMap.UintToAddressMap;
1366     using Strings for uint256;
1367 
1368     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1369     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1370     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1371 
1372     // Mapping from holder address to their (enumerable) set of owned tokens
1373     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1374 
1375     // Enumerable mapping from token ids to their owners
1376     EnumerableMap.UintToAddressMap private _tokenOwners;
1377 
1378     // Mapping from token ID to approved address
1379     mapping (uint256 => address) private _tokenApprovals;
1380 
1381     // Mapping from owner to operator approvals
1382     mapping (address => mapping (address => bool)) private _operatorApprovals;
1383 
1384     // Token name
1385     string private _name;
1386 
1387     // Token symbol
1388     string private _symbol;
1389 
1390     // Optional mapping for token URIs
1391     mapping (uint256 => string) private _tokenURIs;
1392 
1393     // Base URI
1394     string private _baseURI;
1395 
1396     /*
1397      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1398      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1399      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1400      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1401      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1402      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1403      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1404      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1405      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1406      *
1407      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1408      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1409      */
1410     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1411 
1412     /*
1413      *     bytes4(keccak256('name()')) == 0x06fdde03
1414      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1415      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1416      *
1417      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1418      */
1419     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1420 
1421     /*
1422      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1423      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1424      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1425      *
1426      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1427      */
1428     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1429 
1430     /**
1431      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1432      */
1433     constructor (string memory name_, string memory symbol_) public {
1434         _name = name_;
1435         _symbol = symbol_;
1436 
1437         // register the supported interfaces to conform to ERC721 via ERC165
1438         _registerInterface(_INTERFACE_ID_ERC721);
1439         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1440         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1441     }
1442 
1443     /**
1444      * @dev See {IERC721-balanceOf}.
1445      */
1446     function balanceOf(address owner) public view virtual override returns (uint256) {
1447         require(owner != address(0), "ERC721: balance query for the zero address");
1448         return _holderTokens[owner].length();
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-ownerOf}.
1453      */
1454     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1455         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Metadata-name}.
1460      */
1461     function name() public view virtual override returns (string memory) {
1462         return _name;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Metadata-symbol}.
1467      */
1468     function symbol() public view virtual override returns (string memory) {
1469         return _symbol;
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Metadata-tokenURI}.
1474      */
1475     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1476         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1477 
1478         string memory _tokenURI = _tokenURIs[tokenId];
1479         string memory base = baseURI();
1480 
1481         // If there is no base URI, return the token URI.
1482         if (bytes(base).length == 0) {
1483             return _tokenURI;
1484         }
1485         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1486         if (bytes(_tokenURI).length > 0) {
1487             return string(abi.encodePacked(base, _tokenURI));
1488         }
1489         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1490         return string(abi.encodePacked(base, tokenId.toString()));
1491     }
1492 
1493     /**
1494     * @dev Returns the base URI set via {_setBaseURI}. This will be
1495     * automatically added as a prefix in {tokenURI} to each token's URI, or
1496     * to the token ID if no specific URI is set for that token ID.
1497     */
1498     function baseURI() public view virtual returns (string memory) {
1499         return _baseURI;
1500     }
1501 
1502     /**
1503      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1504      */
1505     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1506         return _holderTokens[owner].at(index);
1507     }
1508 
1509     /**
1510      * @dev See {IERC721Enumerable-totalSupply}.
1511      */
1512     function totalSupply() public view virtual override returns (uint256) {
1513         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1514         return _tokenOwners.length();
1515     }
1516 
1517     /**
1518      * @dev See {IERC721Enumerable-tokenByIndex}.
1519      */
1520     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1521         (uint256 tokenId, ) = _tokenOwners.at(index);
1522         return tokenId;
1523     }
1524 
1525     /**
1526      * @dev See {IERC721-approve}.
1527      */
1528     function approve(address to, uint256 tokenId) public virtual override {
1529         address owner = ERC721.ownerOf(tokenId);
1530         require(to != owner, "ERC721: approval to current owner");
1531 
1532         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1533             "ERC721: approve caller is not owner nor approved for all"
1534         );
1535 
1536         _approve(to, tokenId);
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-getApproved}.
1541      */
1542     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1543         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1544 
1545         return _tokenApprovals[tokenId];
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-setApprovalForAll}.
1550      */
1551     function setApprovalForAll(address operator, bool approved) public virtual override {
1552         require(operator != _msgSender(), "ERC721: approve to caller");
1553 
1554         _operatorApprovals[_msgSender()][operator] = approved;
1555         emit ApprovalForAll(_msgSender(), operator, approved);
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-isApprovedForAll}.
1560      */
1561     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1562         return _operatorApprovals[owner][operator];
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-transferFrom}.
1567      */
1568     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1569         //solhint-disable-next-line max-line-length
1570         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1571 
1572         _transfer(from, to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-safeTransferFrom}.
1577      */
1578     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1579         safeTransferFrom(from, to, tokenId, "");
1580     }
1581 
1582     /**
1583      * @dev See {IERC721-safeTransferFrom}.
1584      */
1585     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1586         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1587         _safeTransfer(from, to, tokenId, _data);
1588     }
1589 
1590     /**
1591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1593      *
1594      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1595      *
1596      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1597      * implement alternative mechanisms to perform token transfer, such as signature-based.
1598      *
1599      * Requirements:
1600      *
1601      * - `from` cannot be the zero address.
1602      * - `to` cannot be the zero address.
1603      * - `tokenId` token must exist and be owned by `from`.
1604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1609         _transfer(from, to, tokenId);
1610         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1611     }
1612 
1613     /**
1614      * @dev Returns whether `tokenId` exists.
1615      *
1616      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1617      *
1618      * Tokens start existing when they are minted (`_mint`),
1619      * and stop existing when they are burned (`_burn`).
1620      */
1621     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1622         return _tokenOwners.contains(tokenId);
1623     }
1624 
1625     /**
1626      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      */
1632     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1633         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1634         address owner = ERC721.ownerOf(tokenId);
1635         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1636     }
1637 
1638     /**
1639      * @dev Safely mints `tokenId` and transfers it to `to`.
1640      *
1641      * Requirements:
1642      d*
1643      * - `tokenId` must not exist.
1644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _safeMint(address to, uint256 tokenId) internal virtual {
1649         _safeMint(to, tokenId, "");
1650     }
1651 
1652     /**
1653      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1654      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1655      */
1656     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1657         _mint(to, tokenId);
1658         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1659     }
1660 
1661     /**
1662      * @dev Mints `tokenId` and transfers it to `to`.
1663      *
1664      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1665      *
1666      * Requirements:
1667      *
1668      * - `tokenId` must not exist.
1669      * - `to` cannot be the zero address.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _mint(address to, uint256 tokenId) internal virtual {
1674         require(to != address(0), "ERC721: mint to the zero address");
1675         require(!_exists(tokenId), "ERC721: token already minted");
1676 
1677         _beforeTokenTransfer(address(0), to, tokenId);
1678 
1679         _holderTokens[to].add(tokenId);
1680 
1681         _tokenOwners.set(tokenId, to);
1682 
1683         emit Transfer(address(0), to, tokenId);
1684     }
1685 
1686     /**
1687      * @dev Destroys `tokenId`.
1688      * The approval is cleared when the token is burned.
1689      *
1690      * Requirements:
1691      *
1692      * - `tokenId` must exist.
1693      *
1694      * Emits a {Transfer} event.
1695      */
1696     function _burn(uint256 tokenId) internal virtual {
1697         address owner = ERC721.ownerOf(tokenId); // internal owner
1698 
1699         _beforeTokenTransfer(owner, address(0), tokenId);
1700 
1701         // Clear approvals
1702         _approve(address(0), tokenId);
1703 
1704         // Clear metadata (if any)
1705         if (bytes(_tokenURIs[tokenId]).length != 0) {
1706             delete _tokenURIs[tokenId];
1707         }
1708 
1709         _holderTokens[owner].remove(tokenId);
1710 
1711         _tokenOwners.remove(tokenId);
1712 
1713         emit Transfer(owner, address(0), tokenId);
1714     }
1715 
1716     /**
1717      * @dev Transfers `tokenId` from `from` to `to`.
1718      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1719      *
1720      * Requirements:
1721      *
1722      * - `to` cannot be the zero address.
1723      * - `tokenId` token must be owned by `from`.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1728         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1729         require(to != address(0), "ERC721: transfer to the zero address");
1730 
1731         _beforeTokenTransfer(from, to, tokenId);
1732 
1733         // Clear approvals from the previous owner
1734         _approve(address(0), tokenId);
1735 
1736         _holderTokens[from].remove(tokenId);
1737         _holderTokens[to].add(tokenId);
1738 
1739         _tokenOwners.set(tokenId, to);
1740 
1741         emit Transfer(from, to, tokenId);
1742     }
1743 
1744     /**
1745      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1746      *
1747      * Requirements:
1748      *
1749      * - `tokenId` must exist.
1750      */
1751     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1752         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1753         _tokenURIs[tokenId] = _tokenURI;
1754     }
1755 
1756     /**
1757      * @dev Internal function to set the base URI for all token IDs. It is
1758      * automatically added as a prefix to the value returned in {tokenURI},
1759      * or to the token ID if {tokenURI} is empty.
1760      */
1761     function _setBaseURI(string memory baseURI_) internal virtual {
1762         _baseURI = baseURI_;
1763     }
1764 
1765     /**
1766      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1767      * The call is not executed if the target address is not a contract.
1768      *
1769      * @param from address representing the previous owner of the given token ID
1770      * @param to target address that will receive the tokens
1771      * @param tokenId uint256 ID of the token to be transferred
1772      * @param _data bytes optional data to send along with the call
1773      * @return bool whether the call correctly returned the expected magic value
1774      */
1775     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1776         private returns (bool)
1777     {
1778         if (!to.isContract()) {
1779             return true;
1780         }
1781         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1782             IERC721Receiver(to).onERC721Received.selector,
1783             _msgSender(),
1784             from,
1785             tokenId,
1786             _data
1787         ), "ERC721: transfer to non ERC721Receiver implementer");
1788         bytes4 retval = abi.decode(returndata, (bytes4));
1789         return (retval == _ERC721_RECEIVED);
1790     }
1791 
1792     /**
1793      * @dev Approve `to` to operate on `tokenId`
1794      *
1795      * Emits an {Approval} event.
1796      */
1797     function _approve(address to, uint256 tokenId) internal virtual {
1798         _tokenApprovals[tokenId] = to;
1799         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1800     }
1801 
1802     /**
1803      * @dev Hook that is called before any token transfer. This includes minting
1804      * and burning.
1805      *
1806      * Calling conditions:
1807      *
1808      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1809      * transferred to `to`.
1810      * - When `from` is zero, `tokenId` will be minted for `to`.
1811      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1812      * - `from` cannot be the zero address.
1813      * - `to` cannot be the zero address.
1814      *
1815      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1816      */
1817     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1818 }
1819 
1820 // File: @openzeppelin/contracts/access/Ownable.sol
1821 
1822 
1823 
1824 pragma solidity >=0.6.0 <0.8.0;
1825 
1826 /**
1827  * @dev Contract module which provides a basic access control mechanism, where
1828  * there is an account (an owner) that can be granted exclusive access to
1829  * specific functions.
1830  *
1831  * By default, the owner account will be the one that deploys the contract. This
1832  * can later be changed with {transferOwnership}.
1833  *
1834  * This module is used through inheritance. It will make available the modifier
1835  * `onlyOwner`, which can be applied to your functions to restrict their use to
1836  * the owner.
1837  */
1838 abstract contract Ownable is Context {
1839     address private _owner;
1840 
1841     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1842 
1843     /**
1844      * @dev Initializes the contract setting the deployer as the initial owner.
1845      */
1846     constructor () internal {
1847         address msgSender = _msgSender();
1848         _owner = msgSender;
1849         emit OwnershipTransferred(address(0), msgSender);
1850     }
1851 
1852     /**
1853      * @dev Returns the address of the current owner.
1854      */
1855     function owner() public view virtual returns (address) {
1856         return _owner;
1857     }
1858 
1859     /**
1860      * @dev Throws if called by any account other than the owner.
1861      */
1862     modifier onlyOwner() {
1863         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1864         _;
1865     }
1866 
1867     /**
1868      * @dev Leaves the contract without owner. It will not be possible to call
1869      * `onlyOwner` functions anymore. Can only be called by the current owner.
1870      *
1871      * NOTE: Renouncing ownership will leave the contract without an owner,
1872      * thereby removing any functionality that is only available to the owner.
1873      */
1874     function renounceOwnership() public virtual onlyOwner {
1875         emit OwnershipTransferred(_owner, address(0));
1876         _owner = address(0);
1877     }
1878 
1879     /**
1880      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1881      * Can only be called by the current owner.
1882      */
1883     function transferOwnership(address newOwner) public virtual onlyOwner {
1884         require(newOwner != address(0), "Ownable: new owner is the zero address");
1885         emit OwnershipTransferred(_owner, newOwner);
1886         _owner = newOwner;
1887     }
1888 }
1889 
1890 
1891 /*
1892   ___ _   _ _  _ _  _____ _  _   ___  ___  _   _ ___ ___  ___ 
1893  / __| | | | \| | |/ / __| \| | / __|/ _ \| | | |_ _|   \/ __|
1894  \__ \ |_| | .` | ' <| _|| .` | \__ \ (_) | |_| || || |) \__ \
1895  |___/\___/|_|\_|_|\_\___|_|\_| |___/\__\_\\___/|___|___/|___/
1896                                                               
1897 10,000 squids living on the Ethereum Blockchain, just trying to make the world a better place.
1898 
1899 
1900 */
1901 
1902 pragma solidity ^0.7.0;
1903 pragma abicoder v2;
1904 
1905 contract SunkenSquids is ERC721, Ownable {
1906     
1907     using SafeMath for uint256;
1908 
1909     string public NFT_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN NFT ARE ALL SOLD OUT
1910     
1911     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1912     
1913     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1914 
1915     uint256 public constant nftPrice = 50000000000000000; // .05 ETH
1916 
1917     uint public constant maxNftPurchase = 20; // Max NFT per purchase
1918 
1919     uint256 public constant MAX_NFT = 10000; // Max Supply
1920 
1921     bool public saleIsActive = false;
1922         
1923     // Reserve 125 Tokens for giveaways, prizes, and team members
1924     uint public nftReserveAmount = 125;
1925     
1926     
1927     event licenseisLocked(string _licenseText);
1928 
1929     constructor() ERC721("Sunken Squids", "SQUIDS") { }
1930     
1931     function withdraw() public onlyOwner {
1932         uint balance = address(this).balance;
1933         msg.sender.transfer(balance);
1934     }
1935     
1936     function reserveNFTs(address _to, uint256 _reserveAmount) public onlyOwner {        
1937         uint supply = totalSupply();
1938         require(_reserveAmount > 0 && _reserveAmount <= nftReserveAmount, "You are trying to mint more than what's left in the reserve.");
1939         for (uint i = 0; i < _reserveAmount; i++) {
1940             _safeMint(_to, supply + i);
1941         }
1942         nftReserveAmount = nftReserveAmount.sub(_reserveAmount);
1943     }
1944 
1945 
1946     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1947         NFT_PROVENANCE = provenanceHash;
1948     }
1949 
1950     function setBaseURI(string memory baseURI) public onlyOwner {
1951         _setBaseURI(baseURI);
1952     }
1953 
1954 
1955     function flipSaleState() public onlyOwner {
1956         saleIsActive = !saleIsActive;
1957     }
1958     
1959     
1960     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1961         uint256 tokenCount = balanceOf(_owner);
1962         if (tokenCount == 0) {
1963             // Return an empty array
1964             return new uint256[](0);
1965         } else {
1966             uint256[] memory result = new uint256[](tokenCount);
1967             uint256 index;
1968             for (index = 0; index < tokenCount; index++) {
1969                 result[index] = tokenOfOwnerByIndex(_owner, index);
1970             }
1971             return result;
1972         }
1973     }
1974     
1975     // Returns the license for tokens
1976     function tokenLicense(uint _id) public view returns(string memory) {
1977         require(_id < totalSupply(), "CHOOSE A TOKEN WITHIN RANGE");
1978         return LICENSE_TEXT;
1979     }
1980     
1981     // Locks the license to prevent further changes 
1982     function lockLicense() public onlyOwner {
1983         licenseLocked =  true;
1984         emit licenseisLocked(LICENSE_TEXT);
1985     }
1986     
1987     // Change the license
1988     function changeLicense(string memory _license) public onlyOwner {
1989         require(licenseLocked == false, "License already locked");
1990         LICENSE_TEXT = _license;
1991     }
1992     
1993     
1994     function mintNFT(uint numberOfTokens) public payable {
1995         require(saleIsActive, "Sale must be active to mint token");
1996         require(numberOfTokens > 0 && numberOfTokens <= maxNftPurchase, "Can only mint 20 tokens at a time");
1997         require(totalSupply().add(numberOfTokens) <= MAX_NFT, "Purchase would exceed max supply of tokens");
1998         require(msg.value >= nftPrice.mul(numberOfTokens), "Ether value sent is not correct");
1999         
2000         for(uint i = 0; i < numberOfTokens; i++) {
2001             uint mintIndex = totalSupply();
2002             if (totalSupply() < MAX_NFT) {
2003                 _safeMint(msg.sender, mintIndex);
2004             }
2005         }
2006 
2007     }
2008     
2009 }