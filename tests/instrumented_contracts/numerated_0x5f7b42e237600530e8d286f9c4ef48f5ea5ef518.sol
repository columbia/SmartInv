1 //
2 //   ██████╗ ██╗  ██╗ ██████╗██████╗ ██╗   ██╗███████╗████████╗ █████╗ ██╗     ███████╗
3 //  ██╔═████╗╚██╗██╔╝██╔════╝██╔══██╗╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔══██╗██║     ██╔════╝
4 //  ██║██╔██║ ╚███╔╝ ██║     ██████╔╝ ╚████╔╝ ███████╗   ██║   ███████║██║     ███████╗
5 //  ████╔╝██║ ██╔██╗ ██║     ██╔══██╗  ╚██╔╝  ╚════██║   ██║   ██╔══██║██║     ╚════██║
6 //  ╚██████╔╝██╔╝ ██╗╚██████╗██║  ██║   ██║   ███████║   ██║   ██║  ██║███████╗███████║
7 //   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
8 //                                                                                     
9 
10 
11 // SPDX-License-Identifier: MIT
12 // Developer: jawadklair
13 
14 pragma solidity ^0.7.0;
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
41 //pragma solidity >=0.6.0 <0.8.0;
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
68 //pragma solidity >=0.6.2 <0.8.0;
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
199 //pragma solidity >=0.6.2 <0.8.0;
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
228 //pragma solidity >=0.6.2 <0.8.0;
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
259 //pragma solidity >=0.6.0 <0.8.0;
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
283 //pragma solidity >=0.6.0 <0.8.0;
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
303     constructor () {
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
339 //pragma solidity >=0.6.0 <0.8.0;
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
556 //pragma solidity >=0.6.2 <0.8.0;
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
748 //pragma solidity >=0.6.0 <0.8.0;
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
1048 //pragma solidity >=0.6.0 <0.8.0;
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
1317 //pragma solidity >=0.6.0 <0.8.0;
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
1352 //pragma solidity >=0.6.0 <0.8.0;
1353 
1354 /**
1355  * @title ERC721 Non-Fungible Token Standard basic implementation
1356  * @dev see https://eips.ethereum.org/EIPS/eip-721
1357  */
1358 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1359     using SafeMath for uint256;
1360     using Address for address;
1361     using EnumerableSet for EnumerableSet.UintSet;
1362     using EnumerableMap for EnumerableMap.UintToAddressMap;
1363     using Strings for uint256;
1364 
1365     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1366     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1367     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1368 
1369     // Mapping from holder address to their (enumerable) set of owned tokens
1370     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1371 
1372     // Enumerable mapping from token ids to their owners
1373     EnumerableMap.UintToAddressMap private _tokenOwners;
1374 
1375     // Mapping from token ID to approved address
1376     mapping (uint256 => address) private _tokenApprovals;
1377 
1378     // Mapping from owner to operator approvals
1379     mapping (address => mapping (address => bool)) private _operatorApprovals;
1380 
1381     // Token name
1382     string private _name;
1383 
1384     // Token symbol
1385     string private _symbol;
1386 
1387     // Optional mapping for token URIs
1388     mapping (uint256 => string) private _tokenURIs;
1389 
1390     // Base URI
1391     string private _baseURI;
1392 
1393     /*
1394      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1395      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1396      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1397      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1398      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1399      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1400      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1401      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1402      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1403      *
1404      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1405      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1406      */
1407     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1408 
1409     /*
1410      *     bytes4(keccak256('name()')) == 0x06fdde03
1411      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1412      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1413      *
1414      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1415      */
1416     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1417 
1418     /*
1419      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1420      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1421      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1422      *
1423      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1424      */
1425     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1426 
1427     /**
1428      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1429      */
1430     constructor (string memory name_, string memory symbol_) {
1431         _name = name_;
1432         _symbol = symbol_;
1433 
1434         // register the supported interfaces to conform to ERC721 via ERC165
1435         _registerInterface(_INTERFACE_ID_ERC721);
1436         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1437         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-balanceOf}.
1442      */
1443     function balanceOf(address owner) public view virtual override returns (uint256) {
1444         require(owner != address(0), "ERC721: balance query for the zero address");
1445         return _holderTokens[owner].length();
1446     }
1447 
1448     /**
1449      * @dev See {IERC721-ownerOf}.
1450      */
1451     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1452         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Metadata-name}.
1457      */
1458     function name() public view virtual override returns (string memory) {
1459         return _name;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Metadata-symbol}.
1464      */
1465     function symbol() public view virtual override returns (string memory) {
1466         return _symbol;
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Metadata-tokenURI}.
1471      */
1472     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1473         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1474 
1475         string memory _tokenURI = _tokenURIs[tokenId];
1476         string memory base = baseURI();
1477 
1478         // If there is no base URI, return the token URI.
1479         if (bytes(base).length == 0) {
1480             return _tokenURI;
1481         }
1482         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1483         if (bytes(_tokenURI).length > 0) {
1484             return string(abi.encodePacked(base, _tokenURI));
1485         }
1486         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1487         return string(abi.encodePacked(base, tokenId.toString()));
1488     }
1489 
1490     /**
1491     * @dev Returns the base URI set via {_setBaseURI}. This will be
1492     * automatically added as a prefix in {tokenURI} to each token's URI, or
1493     * to the token ID if no specific URI is set for that token ID.
1494     */
1495     function baseURI() public view virtual returns (string memory) {
1496         return _baseURI;
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1501      */
1502     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1503         return _holderTokens[owner].at(index);
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Enumerable-totalSupply}.
1508      */
1509     function totalSupply() public view virtual override returns (uint256) {
1510         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1511         return _tokenOwners.length();
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Enumerable-tokenByIndex}.
1516      */
1517     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1518         (uint256 tokenId, ) = _tokenOwners.at(index);
1519         return tokenId;
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-approve}.
1524      */
1525     function approve(address to, uint256 tokenId) public virtual override {
1526         address owner = ERC721.ownerOf(tokenId);
1527         require(to != owner, "ERC721: approval to current owner");
1528 
1529         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1530             "ERC721: approve caller is not owner nor approved for all"
1531         );
1532 
1533         _approve(to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev See {IERC721-getApproved}.
1538      */
1539     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1540         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1541 
1542         return _tokenApprovals[tokenId];
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-setApprovalForAll}.
1547      */
1548     function setApprovalForAll(address operator, bool approved) public virtual override {
1549         require(operator != _msgSender(), "ERC721: approve to caller");
1550 
1551         _operatorApprovals[_msgSender()][operator] = approved;
1552         emit ApprovalForAll(_msgSender(), operator, approved);
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-isApprovedForAll}.
1557      */
1558     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1559         return _operatorApprovals[owner][operator];
1560     }
1561 
1562     /**
1563      * @dev See {IERC721-transferFrom}.
1564      */
1565     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1566         //solhint-disable-next-line max-line-length
1567         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1568 
1569         _transfer(from, to, tokenId);
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-safeTransferFrom}.
1574      */
1575     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1576         safeTransferFrom(from, to, tokenId, "");
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-safeTransferFrom}.
1581      */
1582     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1583         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1584         _safeTransfer(from, to, tokenId, _data);
1585     }
1586 
1587     /**
1588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1590      *
1591      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1592      *
1593      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1594      * implement alternative mechanisms to perform token transfer, such as signature-based.
1595      *
1596      * Requirements:
1597      *
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      * - `tokenId` token must exist and be owned by `from`.
1601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1606         _transfer(from, to, tokenId);
1607         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1608     }
1609 
1610     /**
1611      * @dev Returns whether `tokenId` exists.
1612      *
1613      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1614      *
1615      * Tokens start existing when they are minted (`_mint`),
1616      * and stop existing when they are burned (`_burn`).
1617      */
1618     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1619         return _tokenOwners.contains(tokenId);
1620     }
1621 
1622     /**
1623      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must exist.
1628      */
1629     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1630         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1631         address owner = ERC721.ownerOf(tokenId);
1632         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1633     }
1634 
1635     /**
1636      * @dev Safely mints `tokenId` and transfers it to `to`.
1637      *
1638      * Requirements:
1639      d*
1640      * - `tokenId` must not exist.
1641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function _safeMint(address to, uint256 tokenId) internal virtual {
1646         _safeMint(to, tokenId, "");
1647     }
1648 
1649     /**
1650      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1651      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1652      */
1653     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1654         _mint(to, tokenId);
1655         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1656     }
1657 
1658     /**
1659      * @dev Mints `tokenId` and transfers it to `to`.
1660      *
1661      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must not exist.
1666      * - `to` cannot be the zero address.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function _mint(address to, uint256 tokenId) internal virtual {
1671         require(to != address(0), "ERC721: mint to the zero address");
1672         require(!_exists(tokenId), "ERC721: token already minted");
1673 
1674         _beforeTokenTransfer(address(0), to, tokenId);
1675 
1676         _holderTokens[to].add(tokenId);
1677 
1678         _tokenOwners.set(tokenId, to);
1679 
1680         emit Transfer(address(0), to, tokenId);
1681     }
1682 
1683     /**
1684      * @dev Destroys `tokenId`.
1685      * The approval is cleared when the token is burned.
1686      *
1687      * Requirements:
1688      *
1689      * - `tokenId` must exist.
1690      *
1691      * Emits a {Transfer} event.
1692      */
1693     function _burn(uint256 tokenId) internal virtual {
1694         address owner = ERC721.ownerOf(tokenId); // internal owner
1695 
1696         _beforeTokenTransfer(owner, address(0), tokenId);
1697 
1698         // Clear approvals
1699         _approve(address(0), tokenId);
1700 
1701         // Clear metadata (if any)
1702         if (bytes(_tokenURIs[tokenId]).length != 0) {
1703             delete _tokenURIs[tokenId];
1704         }
1705 
1706         _holderTokens[owner].remove(tokenId);
1707 
1708         _tokenOwners.remove(tokenId);
1709 
1710         emit Transfer(owner, address(0), tokenId);
1711     }
1712 
1713     /**
1714      * @dev Transfers `tokenId` from `from` to `to`.
1715      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1716      *
1717      * Requirements:
1718      *
1719      * - `to` cannot be the zero address.
1720      * - `tokenId` token must be owned by `from`.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1725         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1726         require(to != address(0), "ERC721: transfer to the zero address");
1727 
1728         _beforeTokenTransfer(from, to, tokenId);
1729 
1730         // Clear approvals from the previous owner
1731         _approve(address(0), tokenId);
1732 
1733         _holderTokens[from].remove(tokenId);
1734         _holderTokens[to].add(tokenId);
1735 
1736         _tokenOwners.set(tokenId, to);
1737 
1738         emit Transfer(from, to, tokenId);
1739     }
1740 
1741     /**
1742      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1743      *
1744      * Requirements:
1745      *
1746      * - `tokenId` must exist.
1747      */
1748     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1749         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1750         _tokenURIs[tokenId] = _tokenURI;
1751     }
1752 
1753     /**
1754      * @dev Internal function to set the base URI for all token IDs. It is
1755      * automatically added as a prefix to the value returned in {tokenURI},
1756      * or to the token ID if {tokenURI} is empty.
1757      */
1758     function _setBaseURI(string memory baseURI_) internal virtual {
1759         _baseURI = baseURI_;
1760     }
1761 
1762     /**
1763      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1764      * The call is not executed if the target address is not a contract.
1765      *
1766      * @param from address representing the previous owner of the given token ID
1767      * @param to target address that will receive the tokens
1768      * @param tokenId uint256 ID of the token to be transferred
1769      * @param _data bytes optional data to send along with the call
1770      * @return bool whether the call correctly returned the expected magic value
1771      */
1772     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1773         private returns (bool)
1774     {
1775         if (!to.isContract()) {
1776             return true;
1777         }
1778         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1779             IERC721Receiver(to).onERC721Received.selector,
1780             _msgSender(),
1781             from,
1782             tokenId,
1783             _data
1784         ), "ERC721: transfer to non ERC721Receiver implementer");
1785         bytes4 retval = abi.decode(returndata, (bytes4));
1786         return (retval == _ERC721_RECEIVED);
1787     }
1788 
1789     /**
1790      * @dev Approve `to` to operate on `tokenId`
1791      *
1792      * Emits an {Approval} event.
1793      */
1794     function _approve(address to, uint256 tokenId) internal virtual {
1795         _tokenApprovals[tokenId] = to;
1796         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1797     }
1798 
1799     /**
1800      * @dev Hook that is called before any token transfer. This includes minting
1801      * and burning.
1802      *
1803      * Calling conditions:
1804      *
1805      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1806      * transferred to `to`.
1807      * - When `from` is zero, `tokenId` will be minted for `to`.
1808      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1809      * - `from` cannot be the zero address.
1810      * - `to` cannot be the zero address.
1811      *
1812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1813      */
1814     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1815 }
1816 
1817 // File: @openzeppelin/contracts/access/Ownable.sol
1818 
1819 
1820 
1821 //pragma solidity >=0.6.0 <0.8.0;
1822 
1823 /**
1824  * @dev Contract module which provides a basic access control mechanism, where
1825  * there is an account (an owner) that can be granted exclusive access to
1826  * specific functions.
1827  *
1828  * By default, the owner account will be the one that deploys the contract. This
1829  * can later be changed with {transferOwnership}.
1830  *
1831  * This module is used through inheritance. It will make available the modifier
1832  * `onlyOwner`, which can be applied to your functions to restrict their use to
1833  * the owner.
1834  */
1835 abstract contract Ownable is Context {
1836     address private _owner;
1837 
1838     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1839 
1840     /**
1841      * @dev Initializes the contract setting the deployer as the initial owner.
1842      */
1843     constructor () {
1844         address msgSender = _msgSender();
1845         _owner = msgSender;
1846         emit OwnershipTransferred(address(0), msgSender);
1847     }
1848 
1849     /**
1850      * @dev Returns the address of the current owner.
1851      */
1852     function owner() public view virtual returns (address) {
1853         return _owner;
1854     }
1855 
1856     /**
1857      * @dev Throws if called by any account other than the owner.
1858      */
1859     modifier onlyOwner() {
1860         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1861         _;
1862     }
1863 
1864     /**
1865      * @dev Leaves the contract without owner. It will not be possible to call
1866      * `onlyOwner` functions anymore. Can only be called by the current owner.
1867      *
1868      * NOTE: Renouncing ownership will leave the contract without an owner,
1869      * thereby removing any functionality that is only available to the owner.
1870      */
1871     function renounceOwnership() public virtual onlyOwner {
1872         emit OwnershipTransferred(_owner, address(0));
1873         _owner = address(0);
1874     }
1875 
1876     /**
1877      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1878      * Can only be called by the current owner.
1879      */
1880     function transferOwnership(address newOwner) public virtual onlyOwner {
1881         require(newOwner != address(0), "Ownable: new owner is the zero address");
1882         emit OwnershipTransferred(_owner, newOwner);
1883         _owner = newOwner;
1884     }
1885 }
1886 
1887 /**
1888  * @title 0xcubes
1889  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1890  */
1891 contract OxCubes is ERC721, Ownable {
1892     using SafeMath for uint256;
1893 
1894     string public OXCUBES_PROVENANCE = "";
1895 
1896     uint256 public immutable MAX_0XCUBES;
1897     uint256 public constant oxcubePrice = 210000000000000000; //0.21 ETH
1898     uint256 public constant max0xcubesPurchase = 10;
1899 
1900     bool public mintIsActive = false;
1901     bool public OxCubesReserved = false;
1902 
1903     constructor(string memory name, string memory symbol, uint256 maxNftSupply) ERC721(name, symbol) {
1904         MAX_0XCUBES = maxNftSupply;
1905     }
1906 
1907     function withdraw() public onlyOwner {
1908         uint balance = address(this).balance;
1909         msg.sender.transfer(balance);
1910     }
1911 
1912     /**
1913      * Set some 0xCubes aside
1914      */
1915     function reserve0xCubes(uint num0xCubes) public onlyOwner { 
1916         require(!OxCubesReserved, "Already reserved 0xCubes");       
1917         uint supply = totalSupply();
1918         for (uint i = 0; i < num0xCubes; i++) {
1919             _safeMint(msg.sender, supply + i);
1920         }
1921         OxCubesReserved = true;
1922     }
1923 
1924     /*     
1925     * Set provenance once it's calculated
1926     */
1927     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1928         OXCUBES_PROVENANCE = provenanceHash;
1929     }
1930 
1931     function setBaseURI(string memory baseURI) public onlyOwner {
1932         _setBaseURI(baseURI);
1933     }
1934 
1935     /*
1936     * Pause sale if active, make active if paused
1937     */
1938     function flipMintState() public onlyOwner {
1939         mintIsActive = !mintIsActive;
1940     }
1941 
1942     /**
1943     * Mints 0xcubes
1944     */
1945     function mint0xCube(uint256 numberOfTokens) public payable {
1946         require(mintIsActive, "0xcubes minting is not active");
1947         require(numberOfTokens <= max0xcubesPurchase, "Can only mint max 10 tokens per transaction");
1948         require(totalSupply().add(numberOfTokens) <= MAX_0XCUBES, "Purchase would exceed max supply of 0xcubes");
1949         require(oxcubePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1950         
1951         for(uint i = 0; i < numberOfTokens; i++) {
1952             uint mintIndex = totalSupply();
1953             if (totalSupply() < MAX_0XCUBES) {
1954                 _safeMint(msg.sender, mintIndex);
1955             }
1956         }
1957     }
1958 }