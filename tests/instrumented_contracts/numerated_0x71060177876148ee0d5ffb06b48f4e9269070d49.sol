1 //      __    ______   _    ____  ____  ____  __  __________________
2 //     / /   /  _/ /  ( )  / __ )/ __ \/ __ \/  |/  /  _/ ____/ ___/
3 //    / /    / // /   |/  / __  / / / / / / / /|_/ // // __/  \__ \ 
4 //   / /____/ // /___    / /_/ / /_/ / /_/ / /  / // // /___ ___/ / 
5 //  /_____/___/_____/   /_____/\____/\____/_/  /_/___/_____//____/  
6 //
7 //                          www.lilboomies.io       
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 // SPDX-License-Identifier: MIT
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
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/introspection/IERC165.sol
37 
38 
39 
40 pragma solidity >=0.6.0 <0.8.0;
41 
42 /**
43  * @dev Interface of the ERC165 standard, as defined in the
44  * https://eips.ethereum.org/EIPS/eip-165[EIP].
45  *
46  * Implementers can declare support of contract interfaces, which can then be
47  * queried by others ({ERC165Checker}).
48  *
49  * For an implementation, see {ERC165}.
50  */
51 interface IERC165 {
52     /**
53      * @dev Returns true if this contract implements the interface defined by
54      * `interfaceId`. See the corresponding
55      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
56      * to learn more about how these ids are created.
57      *
58      * This function call must use less than 30 000 gas.
59      */
60     function supportsInterface(bytes4 interfaceId) external view returns (bool);
61 }
62 
63 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
64 
65 
66 
67 pragma solidity >=0.6.2 <0.8.0;
68 
69 
70 /**
71  * @dev Required interface of an ERC721 compliant contract.
72  */
73 interface IERC721 is IERC165 {
74     /**
75      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
81      */
82     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
83 
84     /**
85      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
86      */
87     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
88 
89     /**
90      * @dev Returns the number of tokens in ``owner``'s account.
91      */
92     function balanceOf(address owner) external view returns (uint256 balance);
93 
94     /**
95      * @dev Returns the owner of the `tokenId` token.
96      *
97      * Requirements:
98      *
99      * - `tokenId` must exist.
100      */
101     function ownerOf(uint256 tokenId) external view returns (address owner);
102 
103     /**
104      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
105      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must exist and be owned by `from`.
112      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
114      *
115      * Emits a {Transfer} event.
116      */
117     function safeTransferFrom(address from, address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Transfers `tokenId` token from `from` to `to`.
121      *
122      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must be owned by `from`.
129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(address from, address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
137      * The approval is cleared when the token is transferred.
138      *
139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
140      *
141      * Requirements:
142      *
143      * - The caller must own the token or be an approved operator.
144      * - `tokenId` must exist.
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address to, uint256 tokenId) external;
149 
150     /**
151      * @dev Returns the account approved for `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function getApproved(uint256 tokenId) external view returns (address operator);
158 
159     /**
160      * @dev Approve or remove `operator` as an operator for the caller.
161      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
162      *
163      * Requirements:
164      *
165      * - The `operator` cannot be the caller.
166      *
167      * Emits an {ApprovalForAll} event.
168      */
169     function setApprovalForAll(address operator, bool _approved) external;
170 
171     /**
172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
173      *
174      * See {setApprovalForAll}
175      */
176     function isApprovedForAll(address owner, address operator) external view returns (bool);
177 
178     /**
179       * @dev Safely transfers `tokenId` token from `from` to `to`.
180       *
181       * Requirements:
182       *
183       * - `from` cannot be the zero address.
184       * - `to` cannot be the zero address.
185       * - `tokenId` token must exist and be owned by `from`.
186       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188       *
189       * Emits a {Transfer} event.
190       */
191     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
192 }
193 
194 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
195 
196 
197 
198 pragma solidity >=0.6.2 <0.8.0;
199 
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Metadata is IERC721 {
206 
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
224 
225 
226 
227 pragma solidity >=0.6.2 <0.8.0;
228 
229 
230 /**
231  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
232  * @dev See https://eips.ethereum.org/EIPS/eip-721
233  */
234 interface IERC721Enumerable is IERC721 {
235 
236     /**
237      * @dev Returns the total amount of tokens stored by the contract.
238      */
239     function totalSupply() external view returns (uint256);
240 
241     /**
242      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
243      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
244      */
245     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
246 
247     /**
248      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
249      * Use along with {totalSupply} to enumerate all tokens.
250      */
251     function tokenByIndex(uint256 index) external view returns (uint256);
252 }
253 
254 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
255 
256 
257 
258 pragma solidity >=0.6.0 <0.8.0;
259 
260 /**
261  * @title ERC721 token receiver interface
262  * @dev Interface for any contract that wants to support safeTransfers
263  * from ERC721 asset contracts.
264  */
265 interface IERC721Receiver {
266     /**
267      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
268      * by `operator` from `from`, this function is called.
269      *
270      * It must return its Solidity selector to confirm the token transfer.
271      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
272      *
273      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
274      */
275     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
276 }
277 
278 // File: @openzeppelin/contracts/introspection/ERC165.sol
279 
280 
281 
282 pragma solidity >=0.6.0 <0.8.0;
283 
284 
285 /**
286  * @dev Implementation of the {IERC165} interface.
287  *
288  * Contracts may inherit from this and call {_registerInterface} to declare
289  * their support of an interface.
290  */
291 abstract contract ERC165 is IERC165 {
292     /*
293      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
294      */
295     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
296 
297     /**
298      * @dev Mapping of interface ids to whether or not it's supported.
299      */
300     mapping(bytes4 => bool) private _supportedInterfaces;
301 
302     constructor () internal {
303         // Derived contracts need only register support for their own interfaces,
304         // we register support for ERC165 itself here
305         _registerInterface(_INTERFACE_ID_ERC165);
306     }
307 
308     /**
309      * @dev See {IERC165-supportsInterface}.
310      *
311      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return _supportedInterfaces[interfaceId];
315     }
316 
317     /**
318      * @dev Registers the contract as an implementer of the interface defined by
319      * `interfaceId`. Support of the actual ERC165 interface is automatic and
320      * registering its interface id is not required.
321      *
322      * See {IERC165-supportsInterface}.
323      *
324      * Requirements:
325      *
326      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
327      */
328     function _registerInterface(bytes4 interfaceId) internal virtual {
329         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
330         _supportedInterfaces[interfaceId] = true;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/math/SafeMath.sol
335 
336 
337 
338 pragma solidity >=0.6.0 <0.8.0;
339 
340 /**
341  * @dev Wrappers over Solidity's arithmetic operations with added overflow
342  * checks.
343  *
344  * Arithmetic operations in Solidity wrap on overflow. This can easily result
345  * in bugs, because programmers usually assume that an overflow raises an
346  * error, which is the standard behavior in high level programming languages.
347  * `SafeMath` restores this intuition by reverting the transaction when an
348  * operation overflows.
349  *
350  * Using this library instead of the unchecked operations eliminates an entire
351  * class of bugs, so it's recommended to use it always.
352  */
353 library SafeMath {
354     /**
355      * @dev Returns the addition of two unsigned integers, with an overflow flag.
356      *
357      * _Available since v3.4._
358      */
359     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         uint256 c = a + b;
361         if (c < a) return (false, 0);
362         return (true, c);
363     }
364 
365     /**
366      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
367      *
368      * _Available since v3.4._
369      */
370     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
371         if (b > a) return (false, 0);
372         return (true, a - b);
373     }
374 
375     /**
376      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
384         if (a == 0) return (true, 0);
385         uint256 c = a * b;
386         if (c / a != b) return (false, 0);
387         return (true, c);
388     }
389 
390     /**
391      * @dev Returns the division of two unsigned integers, with a division by zero flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         if (b == 0) return (false, 0);
397         return (true, a / b);
398     }
399 
400     /**
401      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
402      *
403      * _Available since v3.4._
404      */
405     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
406         if (b == 0) return (false, 0);
407         return (true, a % b);
408     }
409 
410     /**
411      * @dev Returns the addition of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `+` operator.
415      *
416      * Requirements:
417      *
418      * - Addition cannot overflow.
419      */
420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
421         uint256 c = a + b;
422         require(c >= a, "SafeMath: addition overflow");
423         return c;
424     }
425 
426     /**
427      * @dev Returns the subtraction of two unsigned integers, reverting on
428      * overflow (when the result is negative).
429      *
430      * Counterpart to Solidity's `-` operator.
431      *
432      * Requirements:
433      *
434      * - Subtraction cannot overflow.
435      */
436     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
437         require(b <= a, "SafeMath: subtraction overflow");
438         return a - b;
439     }
440 
441     /**
442      * @dev Returns the multiplication of two unsigned integers, reverting on
443      * overflow.
444      *
445      * Counterpart to Solidity's `*` operator.
446      *
447      * Requirements:
448      *
449      * - Multiplication cannot overflow.
450      */
451     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
452         if (a == 0) return 0;
453         uint256 c = a * b;
454         require(c / a == b, "SafeMath: multiplication overflow");
455         return c;
456     }
457 
458     /**
459      * @dev Returns the integer division of two unsigned integers, reverting on
460      * division by zero. The result is rounded towards zero.
461      *
462      * Counterpart to Solidity's `/` operator. Note: this function uses a
463      * `revert` opcode (which leaves remaining gas untouched) while Solidity
464      * uses an invalid opcode to revert (consuming all remaining gas).
465      *
466      * Requirements:
467      *
468      * - The divisor cannot be zero.
469      */
470     function div(uint256 a, uint256 b) internal pure returns (uint256) {
471         require(b > 0, "SafeMath: division by zero");
472         return a / b;
473     }
474 
475     /**
476      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
477      * reverting when dividing by zero.
478      *
479      * Counterpart to Solidity's `%` operator. This function uses a `revert`
480      * opcode (which leaves remaining gas untouched) while Solidity uses an
481      * invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
488         require(b > 0, "SafeMath: modulo by zero");
489         return a % b;
490     }
491 
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
494      * overflow (when the result is negative).
495      *
496      * CAUTION: This function is deprecated because it requires allocating memory for the error
497      * message unnecessarily. For custom revert reasons use {trySub}.
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      *
503      * - Subtraction cannot overflow.
504      */
505     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b <= a, errorMessage);
507         return a - b;
508     }
509 
510     /**
511      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
512      * division by zero. The result is rounded towards zero.
513      *
514      * CAUTION: This function is deprecated because it requires allocating memory for the error
515      * message unnecessarily. For custom revert reasons use {tryDiv}.
516      *
517      * Counterpart to Solidity's `/` operator. Note: this function uses a
518      * `revert` opcode (which leaves remaining gas untouched) while Solidity
519      * uses an invalid opcode to revert (consuming all remaining gas).
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
526         require(b > 0, errorMessage);
527         return a / b;
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * reverting with custom message when dividing by zero.
533      *
534      * CAUTION: This function is deprecated because it requires allocating memory for the error
535      * message unnecessarily. For custom revert reasons use {tryMod}.
536      *
537      * Counterpart to Solidity's `%` operator. This function uses a `revert`
538      * opcode (which leaves remaining gas untouched) while Solidity uses an
539      * invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
546         require(b > 0, errorMessage);
547         return a % b;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/utils/Address.sol
552 
553 
554 
555 pragma solidity >=0.6.2 <0.8.0;
556 
557 /**
558  * @dev Collection of functions related to the address type
559  */
560 library Address {
561     /**
562      * @dev Returns true if `account` is a contract.
563      *
564      * [IMPORTANT]
565      * ====
566      * It is unsafe to assume that an address for which this function returns
567      * false is an externally-owned account (EOA) and not a contract.
568      *
569      * Among others, `isContract` will return false for the following
570      * types of addresses:
571      *
572      *  - an externally-owned account
573      *  - a contract in construction
574      *  - an address where a contract will be created
575      *  - an address where a contract lived, but was destroyed
576      * ====
577      */
578     function isContract(address account) internal view returns (bool) {
579         // This method relies on extcodesize, which returns 0 for contracts in
580         // construction, since the code is only stored at the end of the
581         // constructor execution.
582 
583         uint256 size;
584         // solhint-disable-next-line no-inline-assembly
585         assembly { size := extcodesize(account) }
586         return size > 0;
587     }
588 
589     /**
590      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
591      * `recipient`, forwarding all available gas and reverting on errors.
592      *
593      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
594      * of certain opcodes, possibly making contracts go over the 2300 gas limit
595      * imposed by `transfer`, making them unable to receive funds via
596      * `transfer`. {sendValue} removes this limitation.
597      *
598      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
599      *
600      * IMPORTANT: because control is transferred to `recipient`, care must be
601      * taken to not create reentrancy vulnerabilities. Consider using
602      * {ReentrancyGuard} or the
603      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
604      */
605     function sendValue(address payable recipient, uint256 amount) internal {
606         require(address(this).balance >= amount, "Address: insufficient balance");
607 
608         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
609         (bool success, ) = recipient.call{ value: amount }("");
610         require(success, "Address: unable to send value, recipient may have reverted");
611     }
612 
613     /**
614      * @dev Performs a Solidity function call using a low level `call`. A
615      * plain`call` is an unsafe replacement for a function call: use this
616      * function instead.
617      *
618      * If `target` reverts with a revert reason, it is bubbled up by this
619      * function (like regular Solidity function calls).
620      *
621      * Returns the raw returned data. To convert to the expected return value,
622      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
623      *
624      * Requirements:
625      *
626      * - `target` must be a contract.
627      * - calling `target` with `data` must not revert.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
632       return functionCall(target, data, "Address: low-level call failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
637      * `errorMessage` as a fallback revert reason when `target` reverts.
638      *
639      * _Available since v3.1._
640      */
641     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
642         return functionCallWithValue(target, data, 0, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but also transferring `value` wei to `target`.
648      *
649      * Requirements:
650      *
651      * - the calling contract must have an ETH balance of at least `value`.
652      * - the called Solidity function must be `payable`.
653      *
654      * _Available since v3.1._
655      */
656     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
657         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
662      * with `errorMessage` as a fallback revert reason when `target` reverts.
663      *
664      * _Available since v3.1._
665      */
666     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
667         require(address(this).balance >= value, "Address: insufficient balance for call");
668         require(isContract(target), "Address: call to non-contract");
669 
670         // solhint-disable-next-line avoid-low-level-calls
671         (bool success, bytes memory returndata) = target.call{ value: value }(data);
672         return _verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but performing a static call.
678      *
679      * _Available since v3.3._
680      */
681     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
682         return functionStaticCall(target, data, "Address: low-level static call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
687      * but performing a static call.
688      *
689      * _Available since v3.3._
690      */
691     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
692         require(isContract(target), "Address: static call to non-contract");
693 
694         // solhint-disable-next-line avoid-low-level-calls
695         (bool success, bytes memory returndata) = target.staticcall(data);
696         return _verifyCallResult(success, returndata, errorMessage);
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
701      * but performing a delegate call.
702      *
703      * _Available since v3.4._
704      */
705     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
706         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
711      * but performing a delegate call.
712      *
713      * _Available since v3.4._
714      */
715     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
716         require(isContract(target), "Address: delegate call to non-contract");
717 
718         // solhint-disable-next-line avoid-low-level-calls
719         (bool success, bytes memory returndata) = target.delegatecall(data);
720         return _verifyCallResult(success, returndata, errorMessage);
721     }
722 
723     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
724         if (success) {
725             return returndata;
726         } else {
727             // Look for revert reason and bubble it up if present
728             if (returndata.length > 0) {
729                 // The easiest way to bubble the revert reason is using memory via assembly
730 
731                 // solhint-disable-next-line no-inline-assembly
732                 assembly {
733                     let returndata_size := mload(returndata)
734                     revert(add(32, returndata), returndata_size)
735                 }
736             } else {
737                 revert(errorMessage);
738             }
739         }
740     }
741 }
742 
743 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
744 
745 
746 
747 pragma solidity >=0.6.0 <0.8.0;
748 
749 /**
750  * @dev Library for managing
751  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
752  * types.
753  *
754  * Sets have the following properties:
755  *
756  * - Elements are added, removed, and checked for existence in constant time
757  * (O(1)).
758  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
759  *
760  * ```
761  * contract Example {
762  *     // Add the library methods
763  *     using EnumerableSet for EnumerableSet.AddressSet;
764  *
765  *     // Declare a set state variable
766  *     EnumerableSet.AddressSet private mySet;
767  * }
768  * ```
769  *
770  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
771  * and `uint256` (`UintSet`) are supported.
772  */
773 library EnumerableSet {
774     // To implement this library for multiple types with as little code
775     // repetition as possible, we write it in terms of a generic Set type with
776     // bytes32 values.
777     // The Set implementation uses private functions, and user-facing
778     // implementations (such as AddressSet) are just wrappers around the
779     // underlying Set.
780     // This means that we can only create new EnumerableSets for types that fit
781     // in bytes32.
782 
783     struct Set {
784         // Storage of set values
785         bytes32[] _values;
786 
787         // Position of the value in the `values` array, plus 1 because index 0
788         // means a value is not in the set.
789         mapping (bytes32 => uint256) _indexes;
790     }
791 
792     /**
793      * @dev Add a value to a set. O(1).
794      *
795      * Returns true if the value was added to the set, that is if it was not
796      * already present.
797      */
798     function _add(Set storage set, bytes32 value) private returns (bool) {
799         if (!_contains(set, value)) {
800             set._values.push(value);
801             // The value is stored at length-1, but we add 1 to all indexes
802             // and use 0 as a sentinel value
803             set._indexes[value] = set._values.length;
804             return true;
805         } else {
806             return false;
807         }
808     }
809 
810     /**
811      * @dev Removes a value from a set. O(1).
812      *
813      * Returns true if the value was removed from the set, that is if it was
814      * present.
815      */
816     function _remove(Set storage set, bytes32 value) private returns (bool) {
817         // We read and store the value's index to prevent multiple reads from the same storage slot
818         uint256 valueIndex = set._indexes[value];
819 
820         if (valueIndex != 0) { // Equivalent to contains(set, value)
821             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
822             // the array, and then remove the last element (sometimes called as 'swap and pop').
823             // This modifies the order of the array, as noted in {at}.
824 
825             uint256 toDeleteIndex = valueIndex - 1;
826             uint256 lastIndex = set._values.length - 1;
827 
828             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
829             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
830 
831             bytes32 lastvalue = set._values[lastIndex];
832 
833             // Move the last value to the index where the value to delete is
834             set._values[toDeleteIndex] = lastvalue;
835             // Update the index for the moved value
836             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
837 
838             // Delete the slot where the moved value was stored
839             set._values.pop();
840 
841             // Delete the index for the deleted slot
842             delete set._indexes[value];
843 
844             return true;
845         } else {
846             return false;
847         }
848     }
849 
850     /**
851      * @dev Returns true if the value is in the set. O(1).
852      */
853     function _contains(Set storage set, bytes32 value) private view returns (bool) {
854         return set._indexes[value] != 0;
855     }
856 
857     /**
858      * @dev Returns the number of values on the set. O(1).
859      */
860     function _length(Set storage set) private view returns (uint256) {
861         return set._values.length;
862     }
863 
864    /**
865     * @dev Returns the value stored at position `index` in the set. O(1).
866     *
867     * Note that there are no guarantees on the ordering of values inside the
868     * array, and it may change when more values are added or removed.
869     *
870     * Requirements:
871     *
872     * - `index` must be strictly less than {length}.
873     */
874     function _at(Set storage set, uint256 index) private view returns (bytes32) {
875         require(set._values.length > index, "EnumerableSet: index out of bounds");
876         return set._values[index];
877     }
878 
879     // Bytes32Set
880 
881     struct Bytes32Set {
882         Set _inner;
883     }
884 
885     /**
886      * @dev Add a value to a set. O(1).
887      *
888      * Returns true if the value was added to the set, that is if it was not
889      * already present.
890      */
891     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
892         return _add(set._inner, value);
893     }
894 
895     /**
896      * @dev Removes a value from a set. O(1).
897      *
898      * Returns true if the value was removed from the set, that is if it was
899      * present.
900      */
901     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
902         return _remove(set._inner, value);
903     }
904 
905     /**
906      * @dev Returns true if the value is in the set. O(1).
907      */
908     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
909         return _contains(set._inner, value);
910     }
911 
912     /**
913      * @dev Returns the number of values in the set. O(1).
914      */
915     function length(Bytes32Set storage set) internal view returns (uint256) {
916         return _length(set._inner);
917     }
918 
919    /**
920     * @dev Returns the value stored at position `index` in the set. O(1).
921     *
922     * Note that there are no guarantees on the ordering of values inside the
923     * array, and it may change when more values are added or removed.
924     *
925     * Requirements:
926     *
927     * - `index` must be strictly less than {length}.
928     */
929     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
930         return _at(set._inner, index);
931     }
932 
933     // AddressSet
934 
935     struct AddressSet {
936         Set _inner;
937     }
938 
939     /**
940      * @dev Add a value to a set. O(1).
941      *
942      * Returns true if the value was added to the set, that is if it was not
943      * already present.
944      */
945     function add(AddressSet storage set, address value) internal returns (bool) {
946         return _add(set._inner, bytes32(uint256(uint160(value))));
947     }
948 
949     /**
950      * @dev Removes a value from a set. O(1).
951      *
952      * Returns true if the value was removed from the set, that is if it was
953      * present.
954      */
955     function remove(AddressSet storage set, address value) internal returns (bool) {
956         return _remove(set._inner, bytes32(uint256(uint160(value))));
957     }
958 
959     /**
960      * @dev Returns true if the value is in the set. O(1).
961      */
962     function contains(AddressSet storage set, address value) internal view returns (bool) {
963         return _contains(set._inner, bytes32(uint256(uint160(value))));
964     }
965 
966     /**
967      * @dev Returns the number of values in the set. O(1).
968      */
969     function length(AddressSet storage set) internal view returns (uint256) {
970         return _length(set._inner);
971     }
972 
973    /**
974     * @dev Returns the value stored at position `index` in the set. O(1).
975     *
976     * Note that there are no guarantees on the ordering of values inside the
977     * array, and it may change when more values are added or removed.
978     *
979     * Requirements:
980     *
981     * - `index` must be strictly less than {length}.
982     */
983     function at(AddressSet storage set, uint256 index) internal view returns (address) {
984         return address(uint160(uint256(_at(set._inner, index))));
985     }
986 
987 
988     // UintSet
989 
990     struct UintSet {
991         Set _inner;
992     }
993 
994     /**
995      * @dev Add a value to a set. O(1).
996      *
997      * Returns true if the value was added to the set, that is if it was not
998      * already present.
999      */
1000     function add(UintSet storage set, uint256 value) internal returns (bool) {
1001         return _add(set._inner, bytes32(value));
1002     }
1003 
1004     /**
1005      * @dev Removes a value from a set. O(1).
1006      *
1007      * Returns true if the value was removed from the set, that is if it was
1008      * present.
1009      */
1010     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1011         return _remove(set._inner, bytes32(value));
1012     }
1013 
1014     /**
1015      * @dev Returns true if the value is in the set. O(1).
1016      */
1017     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1018         return _contains(set._inner, bytes32(value));
1019     }
1020 
1021     /**
1022      * @dev Returns the number of values on the set. O(1).
1023      */
1024     function length(UintSet storage set) internal view returns (uint256) {
1025         return _length(set._inner);
1026     }
1027 
1028    /**
1029     * @dev Returns the value stored at position `index` in the set. O(1).
1030     *
1031     * Note that there are no guarantees on the ordering of values inside the
1032     * array, and it may change when more values are added or removed.
1033     *
1034     * Requirements:
1035     *
1036     * - `index` must be strictly less than {length}.
1037     */
1038     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1039         return uint256(_at(set._inner, index));
1040     }
1041 }
1042 
1043 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1044 
1045 
1046 
1047 pragma solidity >=0.6.0 <0.8.0;
1048 
1049 /**
1050  * @dev Library for managing an enumerable variant of Solidity's
1051  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1052  * type.
1053  *
1054  * Maps have the following properties:
1055  *
1056  * - Entries are added, removed, and checked for existence in constant time
1057  * (O(1)).
1058  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1059  *
1060  * ```
1061  * contract Example {
1062  *     // Add the library methods
1063  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1064  *
1065  *     // Declare a set state variable
1066  *     EnumerableMap.UintToAddressMap private myMap;
1067  * }
1068  * ```
1069  *
1070  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1071  * supported.
1072  */
1073 library EnumerableMap {
1074     // To implement this library for multiple types with as little code
1075     // repetition as possible, we write it in terms of a generic Map type with
1076     // bytes32 keys and values.
1077     // The Map implementation uses private functions, and user-facing
1078     // implementations (such as Uint256ToAddressMap) are just wrappers around
1079     // the underlying Map.
1080     // This means that we can only create new EnumerableMaps for types that fit
1081     // in bytes32.
1082 
1083     struct MapEntry {
1084         bytes32 _key;
1085         bytes32 _value;
1086     }
1087 
1088     struct Map {
1089         // Storage of map keys and values
1090         MapEntry[] _entries;
1091 
1092         // Position of the entry defined by a key in the `entries` array, plus 1
1093         // because index 0 means a key is not in the map.
1094         mapping (bytes32 => uint256) _indexes;
1095     }
1096 
1097     /**
1098      * @dev Adds a key-value pair to a map, or updates the value for an existing
1099      * key. O(1).
1100      *
1101      * Returns true if the key was added to the map, that is if it was not
1102      * already present.
1103      */
1104     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1105         // We read and store the key's index to prevent multiple reads from the same storage slot
1106         uint256 keyIndex = map._indexes[key];
1107 
1108         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1109             map._entries.push(MapEntry({ _key: key, _value: value }));
1110             // The entry is stored at length-1, but we add 1 to all indexes
1111             // and use 0 as a sentinel value
1112             map._indexes[key] = map._entries.length;
1113             return true;
1114         } else {
1115             map._entries[keyIndex - 1]._value = value;
1116             return false;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Removes a key-value pair from a map. O(1).
1122      *
1123      * Returns true if the key was removed from the map, that is if it was present.
1124      */
1125     function _remove(Map storage map, bytes32 key) private returns (bool) {
1126         // We read and store the key's index to prevent multiple reads from the same storage slot
1127         uint256 keyIndex = map._indexes[key];
1128 
1129         if (keyIndex != 0) { // Equivalent to contains(map, key)
1130             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1131             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1132             // This modifies the order of the array, as noted in {at}.
1133 
1134             uint256 toDeleteIndex = keyIndex - 1;
1135             uint256 lastIndex = map._entries.length - 1;
1136 
1137             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1138             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1139 
1140             MapEntry storage lastEntry = map._entries[lastIndex];
1141 
1142             // Move the last entry to the index where the entry to delete is
1143             map._entries[toDeleteIndex] = lastEntry;
1144             // Update the index for the moved entry
1145             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1146 
1147             // Delete the slot where the moved entry was stored
1148             map._entries.pop();
1149 
1150             // Delete the index for the deleted slot
1151             delete map._indexes[key];
1152 
1153             return true;
1154         } else {
1155             return false;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Returns true if the key is in the map. O(1).
1161      */
1162     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1163         return map._indexes[key] != 0;
1164     }
1165 
1166     /**
1167      * @dev Returns the number of key-value pairs in the map. O(1).
1168      */
1169     function _length(Map storage map) private view returns (uint256) {
1170         return map._entries.length;
1171     }
1172 
1173    /**
1174     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1175     *
1176     * Note that there are no guarantees on the ordering of entries inside the
1177     * array, and it may change when more entries are added or removed.
1178     *
1179     * Requirements:
1180     *
1181     * - `index` must be strictly less than {length}.
1182     */
1183     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1184         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1185 
1186         MapEntry storage entry = map._entries[index];
1187         return (entry._key, entry._value);
1188     }
1189 
1190     /**
1191      * @dev Tries to returns the value associated with `key`.  O(1).
1192      * Does not revert if `key` is not in the map.
1193      */
1194     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1195         uint256 keyIndex = map._indexes[key];
1196         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1197         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1198     }
1199 
1200     /**
1201      * @dev Returns the value associated with `key`.  O(1).
1202      *
1203      * Requirements:
1204      *
1205      * - `key` must be in the map.
1206      */
1207     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1208         uint256 keyIndex = map._indexes[key];
1209         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1210         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1211     }
1212 
1213     /**
1214      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1215      *
1216      * CAUTION: This function is deprecated because it requires allocating memory for the error
1217      * message unnecessarily. For custom revert reasons use {_tryGet}.
1218      */
1219     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1220         uint256 keyIndex = map._indexes[key];
1221         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1222         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1223     }
1224 
1225     // UintToAddressMap
1226 
1227     struct UintToAddressMap {
1228         Map _inner;
1229     }
1230 
1231     /**
1232      * @dev Adds a key-value pair to a map, or updates the value for an existing
1233      * key. O(1).
1234      *
1235      * Returns true if the key was added to the map, that is if it was not
1236      * already present.
1237      */
1238     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1239         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1240     }
1241 
1242     /**
1243      * @dev Removes a value from a set. O(1).
1244      *
1245      * Returns true if the key was removed from the map, that is if it was present.
1246      */
1247     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1248         return _remove(map._inner, bytes32(key));
1249     }
1250 
1251     /**
1252      * @dev Returns true if the key is in the map. O(1).
1253      */
1254     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1255         return _contains(map._inner, bytes32(key));
1256     }
1257 
1258     /**
1259      * @dev Returns the number of elements in the map. O(1).
1260      */
1261     function length(UintToAddressMap storage map) internal view returns (uint256) {
1262         return _length(map._inner);
1263     }
1264 
1265    /**
1266     * @dev Returns the element stored at position `index` in the set. O(1).
1267     * Note that there are no guarantees on the ordering of values inside the
1268     * array, and it may change when more values are added or removed.
1269     *
1270     * Requirements:
1271     *
1272     * - `index` must be strictly less than {length}.
1273     */
1274     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1275         (bytes32 key, bytes32 value) = _at(map._inner, index);
1276         return (uint256(key), address(uint160(uint256(value))));
1277     }
1278 
1279     /**
1280      * @dev Tries to returns the value associated with `key`.  O(1).
1281      * Does not revert if `key` is not in the map.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1286         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1287         return (success, address(uint160(uint256(value))));
1288     }
1289 
1290     /**
1291      * @dev Returns the value associated with `key`.  O(1).
1292      *
1293      * Requirements:
1294      *
1295      * - `key` must be in the map.
1296      */
1297     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1298         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1299     }
1300 
1301     /**
1302      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1303      *
1304      * CAUTION: This function is deprecated because it requires allocating memory for the error
1305      * message unnecessarily. For custom revert reasons use {tryGet}.
1306      */
1307     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1308         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1309     }
1310 }
1311 
1312 // File: @openzeppelin/contracts/utils/Strings.sol
1313 
1314 
1315 
1316 pragma solidity >=0.6.0 <0.8.0;
1317 
1318 /**
1319  * @dev String operations.
1320  */
1321 library Strings {
1322     /**
1323      * @dev Converts a `uint256` to its ASCII `string` representation.
1324      */
1325     function toString(uint256 value) internal pure returns (string memory) {
1326         // Inspired by OraclizeAPI's implementation - MIT licence
1327         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1328 
1329         if (value == 0) {
1330             return "0";
1331         }
1332         uint256 temp = value;
1333         uint256 digits;
1334         while (temp != 0) {
1335             digits++;
1336             temp /= 10;
1337         }
1338         bytes memory buffer = new bytes(digits);
1339         uint256 index = digits - 1;
1340         temp = value;
1341         while (temp != 0) {
1342             buffer[index--] = bytes1(uint8(48 + temp % 10));
1343             temp /= 10;
1344         }
1345         return string(buffer);
1346     }
1347 }
1348 
1349 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1350 
1351 
1352 
1353 pragma solidity >=0.6.0 <0.8.0;
1354 
1355 /**
1356  * @title ERC721 Non-Fungible Token Standard basic implementation
1357  * @dev see https://eips.ethereum.org/EIPS/eip-721
1358  */
1359 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1360     using SafeMath for uint256;
1361     using Address for address;
1362     using EnumerableSet for EnumerableSet.UintSet;
1363     using EnumerableMap for EnumerableMap.UintToAddressMap;
1364     using Strings for uint256;
1365 
1366     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1367     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1368     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1369 
1370     // Mapping from holder address to their (enumerable) set of owned tokens
1371     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1372 
1373     // Enumerable mapping from token ids to their owners
1374     EnumerableMap.UintToAddressMap private _tokenOwners;
1375 
1376     // Mapping from token ID to approved address
1377     mapping (uint256 => address) private _tokenApprovals;
1378 
1379     // Mapping from owner to operator approvals
1380     mapping (address => mapping (address => bool)) private _operatorApprovals;
1381 
1382     // Token name
1383     string private _name;
1384 
1385     // Token symbol
1386     string private _symbol;
1387 
1388     // Optional mapping for token URIs
1389     mapping (uint256 => string) private _tokenURIs;
1390 
1391     // Base URI
1392     string private _baseURI;
1393 
1394     /*
1395      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1396      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1397      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1398      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1399      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1400      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1401      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1402      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1403      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1404      *
1405      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1406      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1407      */
1408     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1409 
1410     /*
1411      *     bytes4(keccak256('name()')) == 0x06fdde03
1412      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1413      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1414      *
1415      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1416      */
1417     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1418 
1419     /*
1420      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1421      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1422      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1423      *
1424      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1425      */
1426     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1427 
1428     /**
1429      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1430      */
1431     constructor (string memory name_, string memory symbol_) public {
1432         _name = name_;
1433         _symbol = symbol_;
1434 
1435         // register the supported interfaces to conform to ERC721 via ERC165
1436         _registerInterface(_INTERFACE_ID_ERC721);
1437         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1438         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-balanceOf}.
1443      */
1444     function balanceOf(address owner) public view virtual override returns (uint256) {
1445         require(owner != address(0), "ERC721: balance query for the zero address");
1446         return _holderTokens[owner].length();
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-ownerOf}.
1451      */
1452     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1453         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Metadata-name}.
1458      */
1459     function name() public view virtual override returns (string memory) {
1460         return _name;
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Metadata-symbol}.
1465      */
1466     function symbol() public view virtual override returns (string memory) {
1467         return _symbol;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Metadata-tokenURI}.
1472      */
1473     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1474         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1475 
1476         string memory _tokenURI = _tokenURIs[tokenId];
1477         string memory base = baseURI();
1478 
1479         // If there is no base URI, return the token URI.
1480         if (bytes(base).length == 0) {
1481             return _tokenURI;
1482         }
1483         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1484         if (bytes(_tokenURI).length > 0) {
1485             return string(abi.encodePacked(base, _tokenURI));
1486         }
1487         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1488         return string(abi.encodePacked(base, tokenId.toString()));
1489     }
1490 
1491     /**
1492     * @dev Returns the base URI set via {_setBaseURI}. This will be
1493     * automatically added as a prefix in {tokenURI} to each token's URI, or
1494     * to the token ID if no specific URI is set for that token ID.
1495     */
1496     function baseURI() public view virtual returns (string memory) {
1497         return _baseURI;
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1502      */
1503     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1504         return _holderTokens[owner].at(index);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-totalSupply}.
1509      */
1510     function totalSupply() public view virtual override returns (uint256) {
1511         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1512         return _tokenOwners.length();
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-tokenByIndex}.
1517      */
1518     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1519         (uint256 tokenId, ) = _tokenOwners.at(index);
1520         return tokenId;
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-approve}.
1525      */
1526     function approve(address to, uint256 tokenId) public virtual override {
1527         address owner = ERC721.ownerOf(tokenId);
1528         require(to != owner, "ERC721: approval to current owner");
1529 
1530         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1531             "ERC721: approve caller is not owner nor approved for all"
1532         );
1533 
1534         _approve(to, tokenId);
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-getApproved}.
1539      */
1540     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1541         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1542 
1543         return _tokenApprovals[tokenId];
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-setApprovalForAll}.
1548      */
1549     function setApprovalForAll(address operator, bool approved) public virtual override {
1550         require(operator != _msgSender(), "ERC721: approve to caller");
1551 
1552         _operatorApprovals[_msgSender()][operator] = approved;
1553         emit ApprovalForAll(_msgSender(), operator, approved);
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-isApprovedForAll}.
1558      */
1559     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1560         return _operatorApprovals[owner][operator];
1561     }
1562 
1563     /**
1564      * @dev See {IERC721-transferFrom}.
1565      */
1566     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1567         //solhint-disable-next-line max-line-length
1568         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1569 
1570         _transfer(from, to, tokenId);
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-safeTransferFrom}.
1575      */
1576     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1577         safeTransferFrom(from, to, tokenId, "");
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-safeTransferFrom}.
1582      */
1583     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1584         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1585         _safeTransfer(from, to, tokenId, _data);
1586     }
1587 
1588     /**
1589      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1590      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1591      *
1592      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1593      *
1594      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1595      * implement alternative mechanisms to perform token transfer, such as signature-based.
1596      *
1597      * Requirements:
1598      *
1599      * - `from` cannot be the zero address.
1600      * - `to` cannot be the zero address.
1601      * - `tokenId` token must exist and be owned by `from`.
1602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1603      *
1604      * Emits a {Transfer} event.
1605      */
1606     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1607         _transfer(from, to, tokenId);
1608         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1609     }
1610 
1611     /**
1612      * @dev Returns whether `tokenId` exists.
1613      *
1614      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1615      *
1616      * Tokens start existing when they are minted (`_mint`),
1617      * and stop existing when they are burned (`_burn`).
1618      */
1619     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1620         return _tokenOwners.contains(tokenId);
1621     }
1622 
1623     /**
1624      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      */
1630     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1631         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1632         address owner = ERC721.ownerOf(tokenId);
1633         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1634     }
1635 
1636     /**
1637      * @dev Safely mints `tokenId` and transfers it to `to`.
1638      *
1639      * Requirements:
1640      d*
1641      * - `tokenId` must not exist.
1642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1643      *
1644      * Emits a {Transfer} event.
1645      */
1646     function _safeMint(address to, uint256 tokenId) internal virtual {
1647         _safeMint(to, tokenId, "");
1648     }
1649 
1650     /**
1651      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1652      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1653      */
1654     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1655         _mint(to, tokenId);
1656         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1657     }
1658 
1659     /**
1660      * @dev Mints `tokenId` and transfers it to `to`.
1661      *
1662      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1663      *
1664      * Requirements:
1665      *
1666      * - `tokenId` must not exist.
1667      * - `to` cannot be the zero address.
1668      *
1669      * Emits a {Transfer} event.
1670      */
1671     function _mint(address to, uint256 tokenId) internal virtual {
1672         require(to != address(0), "ERC721: mint to the zero address");
1673         require(!_exists(tokenId), "ERC721: token already minted");
1674 
1675         _beforeTokenTransfer(address(0), to, tokenId);
1676 
1677         _holderTokens[to].add(tokenId);
1678 
1679         _tokenOwners.set(tokenId, to);
1680 
1681         emit Transfer(address(0), to, tokenId);
1682     }
1683 
1684     /**
1685      * @dev Destroys `tokenId`.
1686      * The approval is cleared when the token is burned.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function _burn(uint256 tokenId) internal virtual {
1695         address owner = ERC721.ownerOf(tokenId); // internal owner
1696 
1697         _beforeTokenTransfer(owner, address(0), tokenId);
1698 
1699         // Clear approvals
1700         _approve(address(0), tokenId);
1701 
1702         // Clear metadata (if any)
1703         if (bytes(_tokenURIs[tokenId]).length != 0) {
1704             delete _tokenURIs[tokenId];
1705         }
1706 
1707         _holderTokens[owner].remove(tokenId);
1708 
1709         _tokenOwners.remove(tokenId);
1710 
1711         emit Transfer(owner, address(0), tokenId);
1712     }
1713 
1714     /**
1715      * @dev Transfers `tokenId` from `from` to `to`.
1716      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1717      *
1718      * Requirements:
1719      *
1720      * - `to` cannot be the zero address.
1721      * - `tokenId` token must be owned by `from`.
1722      *
1723      * Emits a {Transfer} event.
1724      */
1725     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1726         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1727         require(to != address(0), "ERC721: transfer to the zero address");
1728 
1729         _beforeTokenTransfer(from, to, tokenId);
1730 
1731         // Clear approvals from the previous owner
1732         _approve(address(0), tokenId);
1733 
1734         _holderTokens[from].remove(tokenId);
1735         _holderTokens[to].add(tokenId);
1736 
1737         _tokenOwners.set(tokenId, to);
1738 
1739         emit Transfer(from, to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1744      *
1745      * Requirements:
1746      *
1747      * - `tokenId` must exist.
1748      */
1749     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1750         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1751         _tokenURIs[tokenId] = _tokenURI;
1752     }
1753 
1754     /**
1755      * @dev Internal function to set the base URI for all token IDs. It is
1756      * automatically added as a prefix to the value returned in {tokenURI},
1757      * or to the token ID if {tokenURI} is empty.
1758      */
1759     function _setBaseURI(string memory baseURI_) internal virtual {
1760         _baseURI = baseURI_;
1761     }
1762 
1763     /**
1764      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1765      * The call is not executed if the target address is not a contract.
1766      *
1767      * @param from address representing the previous owner of the given token ID
1768      * @param to target address that will receive the tokens
1769      * @param tokenId uint256 ID of the token to be transferred
1770      * @param _data bytes optional data to send along with the call
1771      * @return bool whether the call correctly returned the expected magic value
1772      */
1773     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1774         private returns (bool)
1775     {
1776         if (!to.isContract()) {
1777             return true;
1778         }
1779         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1780             IERC721Receiver(to).onERC721Received.selector,
1781             _msgSender(),
1782             from,
1783             tokenId,
1784             _data
1785         ), "ERC721: transfer to non ERC721Receiver implementer");
1786         bytes4 retval = abi.decode(returndata, (bytes4));
1787         return (retval == _ERC721_RECEIVED);
1788     }
1789 
1790     /**
1791      * @dev Approve `to` to operate on `tokenId`
1792      *
1793      * Emits an {Approval} event.
1794      */
1795     function _approve(address to, uint256 tokenId) internal virtual {
1796         _tokenApprovals[tokenId] = to;
1797         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1798     }
1799 
1800     /**
1801      * @dev Hook that is called before any token transfer. This includes minting
1802      * and burning.
1803      *
1804      * Calling conditions:
1805      *
1806      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1807      * transferred to `to`.
1808      * - When `from` is zero, `tokenId` will be minted for `to`.
1809      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1810      * - `from` cannot be the zero address.
1811      * - `to` cannot be the zero address.
1812      *
1813      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1814      */
1815     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1816 }
1817 
1818 // File: @openzeppelin/contracts/access/Ownable.sol
1819 
1820 
1821 
1822 pragma solidity >=0.6.0 <0.8.0;
1823 
1824 /**
1825  * @dev Contract module which provides a basic access control mechanism, where
1826  * there is an account (an owner) that can be granted exclusive access to
1827  * specific functions.
1828  *
1829  * By default, the owner account will be the one that deploys the contract. This
1830  * can later be changed with {transferOwnership}.
1831  *
1832  * This module is used through inheritance. It will make available the modifier
1833  * `onlyOwner`, which can be applied to your functions to restrict their use to
1834  * the owner.
1835  */
1836 abstract contract Ownable is Context {
1837     address private _owner;
1838 
1839     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1840 
1841     /**
1842      * @dev Initializes the contract setting the deployer as the initial owner.
1843      */
1844     constructor () internal {
1845         address msgSender = _msgSender();
1846         _owner = msgSender;
1847         emit OwnershipTransferred(address(0), msgSender);
1848     }
1849 
1850     /**
1851      * @dev Returns the address of the current owner.
1852      */
1853     function owner() public view virtual returns (address) {
1854         return _owner;
1855     }
1856 
1857     /**
1858      * @dev Throws if called by any account other than the owner.
1859      */
1860     modifier onlyOwner() {
1861         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1862         _;
1863     }
1864 
1865     /**
1866      * @dev Leaves the contract without owner. It will not be possible to call
1867      * `onlyOwner` functions anymore. Can only be called by the current owner.
1868      *
1869      * NOTE: Renouncing ownership will leave the contract without an owner,
1870      * thereby removing any functionality that is only available to the owner.
1871      */
1872     function renounceOwnership() public virtual onlyOwner {
1873         emit OwnershipTransferred(_owner, address(0));
1874         _owner = address(0);
1875     }
1876 
1877     /**
1878      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1879      * Can only be called by the current owner.
1880      */
1881     function transferOwnership(address newOwner) public virtual onlyOwner {
1882         require(newOwner != address(0), "Ownable: new owner is the zero address");
1883         emit OwnershipTransferred(_owner, newOwner);
1884         _owner = newOwner;
1885     }
1886 }
1887 
1888 
1889 
1890 
1891 
1892 // File: contracts/LilBoomies.sol
1893 
1894 pragma solidity 0.7.0;
1895 
1896 /**
1897  * @title Lil Boomie Contract, inspired from the DD & BoringBananaCo contracts. 
1898  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1899  */
1900 
1901 contract LilBoomies is ERC721, Ownable {
1902     using SafeMath for uint256;
1903 
1904     string public PROV = "";
1905     uint256 public boomiePrice = 60000000000000000; // 0.06 ETH
1906     uint public maxBoomiePurchase = 10;
1907     uint public boomieReserve = 200;
1908     uint256 public maxBoomies = 10000;
1909     bool public saleIsActive = false;
1910 
1911     constructor() ERC721("Lil Boomies", "BOX") {
1912     }
1913 
1914     function withdraw() public onlyOwner {
1915         uint balance = address(this).balance;
1916         msg.sender.transfer(balance);
1917     }
1918 
1919     function reserveBoomies(address _to, uint256 _reserveAmount) public onlyOwner {        
1920         uint supply = totalSupply();
1921         require(_reserveAmount > 0 && _reserveAmount <= boomieReserve, "Not enough reserve left for team");
1922         for (uint i = 0; i < _reserveAmount; i++) {
1923             _safeMint(_to, supply + i);
1924         }
1925         boomieReserve = boomieReserve.sub(_reserveAmount);
1926     }
1927     
1928     function flipSaleState() public onlyOwner {
1929         saleIsActive = !saleIsActive;
1930     }
1931 
1932     function setPrice(uint256 price) public onlyOwner {
1933         boomiePrice = price;
1934     }
1935 
1936     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1937         PROV = provenanceHash;
1938     }
1939 
1940     function setBaseURI(string memory baseURI) public onlyOwner {
1941         _setBaseURI(baseURI);
1942     }
1943 
1944 
1945     function mintLilBoomie(uint numberOfTokens) public payable {
1946         require(saleIsActive, "Sale must be active to mint Lil Boomies");
1947         require(numberOfTokens <= maxBoomiePurchase, "Can only mint 25 Lil Boomies at a time");
1948         require(totalSupply().add(numberOfTokens) <= maxBoomies, "Purchase would exceed the max supply of Lil Boomies");
1949         require(boomiePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1950         
1951         for(uint i = 0; i < numberOfTokens; i++) {
1952             uint mintIndex = totalSupply();
1953             if (totalSupply() < maxBoomies) {
1954                 _safeMint(msg.sender, mintIndex);
1955             }
1956         }
1957     }
1958 
1959 }