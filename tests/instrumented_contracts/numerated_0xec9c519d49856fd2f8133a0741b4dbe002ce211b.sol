1 // Sources flattened with hardhat v2.2.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Implementation of the {IERC165} interface.
38  *
39  * Contracts may inherit from this and call {_registerInterface} to declare
40  * their support of an interface.
41  */
42 abstract contract ERC165 is IERC165 {
43     /*
44      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
45      */
46     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
47 
48     /**
49      * @dev Mapping of interface ids to whether or not it's supported.
50      */
51     mapping(bytes4 => bool) private _supportedInterfaces;
52 
53     constructor () internal {
54         // Derived contracts need only register support for their own interfaces,
55         // we register support for ERC165 itself here
56         _registerInterface(_INTERFACE_ID_ERC165);
57     }
58 
59     /**
60      * @dev See {IERC165-supportsInterface}.
61      *
62      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
63      */
64     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65         return _supportedInterfaces[interfaceId];
66     }
67 
68     /**
69      * @dev Registers the contract as an implementer of the interface defined by
70      * `interfaceId`. Support of the actual ERC165 interface is automatic and
71      * registering its interface id is not required.
72      *
73      * See {IERC165-supportsInterface}.
74      *
75      * Requirements:
76      *
77      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
78      */
79     function _registerInterface(bytes4 interfaceId) internal virtual {
80         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
81         _supportedInterfaces[interfaceId] = true;
82     }
83 }
84 
85 
86 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
87 
88 
89 pragma solidity >=0.6.0 <0.8.0;
90 
91 /*
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with GSN meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address payable) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes memory) {
107         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
108         return msg.data;
109     }
110 }
111 
112 
113 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
114 
115 
116 pragma solidity >=0.6.2 <0.8.0;
117 
118 /**
119  * @dev Required interface of an ERC721 compliant contract.
120  */
121 interface IERC721 is IERC165 {
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(address from, address to, uint256 tokenId) external;
166 
167     /**
168      * @dev Transfers `tokenId` token from `from` to `to`.
169      *
170      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(address from, address to, uint256 tokenId) external;
182 
183     /**
184      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
185      * The approval is cleared when the token is transferred.
186      *
187      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
188      *
189      * Requirements:
190      *
191      * - The caller must own the token or be an approved operator.
192      * - `tokenId` must exist.
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address to, uint256 tokenId) external;
197 
198     /**
199      * @dev Returns the account approved for `tokenId` token.
200      *
201      * Requirements:
202      *
203      * - `tokenId` must exist.
204      */
205     function getApproved(uint256 tokenId) external view returns (address operator);
206 
207     /**
208      * @dev Approve or remove `operator` as an operator for the caller.
209      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
210      *
211      * Requirements:
212      *
213      * - The `operator` cannot be the caller.
214      *
215      * Emits an {ApprovalForAll} event.
216      */
217     function setApprovalForAll(address operator, bool _approved) external;
218 
219     /**
220      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
221      *
222      * See {setApprovalForAll}
223      */
224     function isApprovedForAll(address owner, address operator) external view returns (bool);
225 
226     /**
227       * @dev Safely transfers `tokenId` token from `from` to `to`.
228       *
229       * Requirements:
230       *
231       * - `from` cannot be the zero address.
232       * - `to` cannot be the zero address.
233       * - `tokenId` token must exist and be owned by `from`.
234       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
235       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
236       *
237       * Emits a {Transfer} event.
238       */
239     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
240 }
241 
242 
243 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
244 
245 
246 pragma solidity >=0.6.2 <0.8.0;
247 
248 /**
249  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
250  * @dev See https://eips.ethereum.org/EIPS/eip-721
251  */
252 interface IERC721Metadata is IERC721 {
253 
254     /**
255      * @dev Returns the token collection name.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the token collection symbol.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
266      */
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 }
269 
270 
271 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
272 
273 
274 pragma solidity >=0.6.2 <0.8.0;
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Enumerable is IERC721 {
281 
282     /**
283      * @dev Returns the total amount of tokens stored by the contract.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
289      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
290      */
291     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
292 
293     /**
294      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
295      * Use along with {totalSupply} to enumerate all tokens.
296      */
297     function tokenByIndex(uint256 index) external view returns (uint256);
298 }
299 
300 
301 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
302 
303 
304 pragma solidity >=0.6.0 <0.8.0;
305 
306 /**
307  * @title ERC721 token receiver interface
308  * @dev Interface for any contract that wants to support safeTransfers
309  * from ERC721 asset contracts.
310  */
311 interface IERC721Receiver {
312     /**
313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
314      * by `operator` from `from`, this function is called.
315      *
316      * It must return its Solidity selector to confirm the token transfer.
317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
318      *
319      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
320      */
321     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
322 }
323 
324 
325 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
326 
327 
328 pragma solidity >=0.6.0 <0.8.0;
329 
330 /**
331  * @dev Wrappers over Solidity's arithmetic operations with added overflow
332  * checks.
333  *
334  * Arithmetic operations in Solidity wrap on overflow. This can easily result
335  * in bugs, because programmers usually assume that an overflow raises an
336  * error, which is the standard behavior in high level programming languages.
337  * `SafeMath` restores this intuition by reverting the transaction when an
338  * operation overflows.
339  *
340  * Using this library instead of the unchecked operations eliminates an entire
341  * class of bugs, so it's recommended to use it always.
342  */
343 library SafeMath {
344     /**
345      * @dev Returns the addition of two unsigned integers, with an overflow flag.
346      *
347      * _Available since v3.4._
348      */
349     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
350         uint256 c = a + b;
351         if (c < a) return (false, 0);
352         return (true, c);
353     }
354 
355     /**
356      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
357      *
358      * _Available since v3.4._
359      */
360     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         if (b > a) return (false, 0);
362         return (true, a - b);
363     }
364 
365     /**
366      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
367      *
368      * _Available since v3.4._
369      */
370     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
371         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
372         // benefit is lost if 'b' is also tested.
373         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
374         if (a == 0) return (true, 0);
375         uint256 c = a * b;
376         if (c / a != b) return (false, 0);
377         return (true, c);
378     }
379 
380     /**
381      * @dev Returns the division of two unsigned integers, with a division by zero flag.
382      *
383      * _Available since v3.4._
384      */
385     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
386         if (b == 0) return (false, 0);
387         return (true, a / b);
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         if (b == 0) return (false, 0);
397         return (true, a % b);
398     }
399 
400     /**
401      * @dev Returns the addition of two unsigned integers, reverting on
402      * overflow.
403      *
404      * Counterpart to Solidity's `+` operator.
405      *
406      * Requirements:
407      *
408      * - Addition cannot overflow.
409      */
410     function add(uint256 a, uint256 b) internal pure returns (uint256) {
411         uint256 c = a + b;
412         require(c >= a, "SafeMath: addition overflow");
413         return c;
414     }
415 
416     /**
417      * @dev Returns the subtraction of two unsigned integers, reverting on
418      * overflow (when the result is negative).
419      *
420      * Counterpart to Solidity's `-` operator.
421      *
422      * Requirements:
423      *
424      * - Subtraction cannot overflow.
425      */
426     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
427         require(b <= a, "SafeMath: subtraction overflow");
428         return a - b;
429     }
430 
431     /**
432      * @dev Returns the multiplication of two unsigned integers, reverting on
433      * overflow.
434      *
435      * Counterpart to Solidity's `*` operator.
436      *
437      * Requirements:
438      *
439      * - Multiplication cannot overflow.
440      */
441     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
442         if (a == 0) return 0;
443         uint256 c = a * b;
444         require(c / a == b, "SafeMath: multiplication overflow");
445         return c;
446     }
447 
448     /**
449      * @dev Returns the integer division of two unsigned integers, reverting on
450      * division by zero. The result is rounded towards zero.
451      *
452      * Counterpart to Solidity's `/` operator. Note: this function uses a
453      * `revert` opcode (which leaves remaining gas untouched) while Solidity
454      * uses an invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function div(uint256 a, uint256 b) internal pure returns (uint256) {
461         require(b > 0, "SafeMath: division by zero");
462         return a / b;
463     }
464 
465     /**
466      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
467      * reverting when dividing by zero.
468      *
469      * Counterpart to Solidity's `%` operator. This function uses a `revert`
470      * opcode (which leaves remaining gas untouched) while Solidity uses an
471      * invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
478         require(b > 0, "SafeMath: modulo by zero");
479         return a % b;
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
484      * overflow (when the result is negative).
485      *
486      * CAUTION: This function is deprecated because it requires allocating memory for the error
487      * message unnecessarily. For custom revert reasons use {trySub}.
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
496         require(b <= a, errorMessage);
497         return a - b;
498     }
499 
500     /**
501      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
502      * division by zero. The result is rounded towards zero.
503      *
504      * CAUTION: This function is deprecated because it requires allocating memory for the error
505      * message unnecessarily. For custom revert reasons use {tryDiv}.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      *
513      * - The divisor cannot be zero.
514      */
515     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b > 0, errorMessage);
517         return a / b;
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * reverting with custom message when dividing by zero.
523      *
524      * CAUTION: This function is deprecated because it requires allocating memory for the error
525      * message unnecessarily. For custom revert reasons use {tryMod}.
526      *
527      * Counterpart to Solidity's `%` operator. This function uses a `revert`
528      * opcode (which leaves remaining gas untouched) while Solidity uses an
529      * invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
536         require(b > 0, errorMessage);
537         return a % b;
538     }
539 }
540 
541 
542 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
543 
544 
545 pragma solidity >=0.6.2 <0.8.0;
546 
547 /**
548  * @dev Collection of functions related to the address type
549  */
550 library Address {
551     /**
552      * @dev Returns true if `account` is a contract.
553      *
554      * [IMPORTANT]
555      * ====
556      * It is unsafe to assume that an address for which this function returns
557      * false is an externally-owned account (EOA) and not a contract.
558      *
559      * Among others, `isContract` will return false for the following
560      * types of addresses:
561      *
562      *  - an externally-owned account
563      *  - a contract in construction
564      *  - an address where a contract will be created
565      *  - an address where a contract lived, but was destroyed
566      * ====
567      */
568     function isContract(address account) internal view returns (bool) {
569         // This method relies on extcodesize, which returns 0 for contracts in
570         // construction, since the code is only stored at the end of the
571         // constructor execution.
572 
573         uint256 size;
574         // solhint-disable-next-line no-inline-assembly
575         assembly { size := extcodesize(account) }
576         return size > 0;
577     }
578 
579     /**
580      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
581      * `recipient`, forwarding all available gas and reverting on errors.
582      *
583      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
584      * of certain opcodes, possibly making contracts go over the 2300 gas limit
585      * imposed by `transfer`, making them unable to receive funds via
586      * `transfer`. {sendValue} removes this limitation.
587      *
588      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
589      *
590      * IMPORTANT: because control is transferred to `recipient`, care must be
591      * taken to not create reentrancy vulnerabilities. Consider using
592      * {ReentrancyGuard} or the
593      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
594      */
595     function sendValue(address payable recipient, uint256 amount) internal {
596         require(address(this).balance >= amount, "Address: insufficient balance");
597 
598         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
599         (bool success, ) = recipient.call{ value: amount }("");
600         require(success, "Address: unable to send value, recipient may have reverted");
601     }
602 
603     /**
604      * @dev Performs a Solidity function call using a low level `call`. A
605      * plain`call` is an unsafe replacement for a function call: use this
606      * function instead.
607      *
608      * If `target` reverts with a revert reason, it is bubbled up by this
609      * function (like regular Solidity function calls).
610      *
611      * Returns the raw returned data. To convert to the expected return value,
612      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
613      *
614      * Requirements:
615      *
616      * - `target` must be a contract.
617      * - calling `target` with `data` must not revert.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
622       return functionCall(target, data, "Address: low-level call failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
627      * `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
632         return functionCallWithValue(target, data, 0, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but also transferring `value` wei to `target`.
638      *
639      * Requirements:
640      *
641      * - the calling contract must have an ETH balance of at least `value`.
642      * - the called Solidity function must be `payable`.
643      *
644      * _Available since v3.1._
645      */
646     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
647         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
652      * with `errorMessage` as a fallback revert reason when `target` reverts.
653      *
654      * _Available since v3.1._
655      */
656     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
657         require(address(this).balance >= value, "Address: insufficient balance for call");
658         require(isContract(target), "Address: call to non-contract");
659 
660         // solhint-disable-next-line avoid-low-level-calls
661         (bool success, bytes memory returndata) = target.call{ value: value }(data);
662         return _verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but performing a static call.
668      *
669      * _Available since v3.3._
670      */
671     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
672         return functionStaticCall(target, data, "Address: low-level static call failed");
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
677      * but performing a static call.
678      *
679      * _Available since v3.3._
680      */
681     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
682         require(isContract(target), "Address: static call to non-contract");
683 
684         // solhint-disable-next-line avoid-low-level-calls
685         (bool success, bytes memory returndata) = target.staticcall(data);
686         return _verifyCallResult(success, returndata, errorMessage);
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
691      * but performing a delegate call.
692      *
693      * _Available since v3.4._
694      */
695     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
696         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
701      * but performing a delegate call.
702      *
703      * _Available since v3.4._
704      */
705     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
706         require(isContract(target), "Address: delegate call to non-contract");
707 
708         // solhint-disable-next-line avoid-low-level-calls
709         (bool success, bytes memory returndata) = target.delegatecall(data);
710         return _verifyCallResult(success, returndata, errorMessage);
711     }
712 
713     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
714         if (success) {
715             return returndata;
716         } else {
717             // Look for revert reason and bubble it up if present
718             if (returndata.length > 0) {
719                 // The easiest way to bubble the revert reason is using memory via assembly
720 
721                 // solhint-disable-next-line no-inline-assembly
722                 assembly {
723                     let returndata_size := mload(returndata)
724                     revert(add(32, returndata), returndata_size)
725                 }
726             } else {
727                 revert(errorMessage);
728             }
729         }
730     }
731 }
732 
733 
734 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
735 
736 
737 
738 pragma solidity >=0.6.0 <0.8.0;
739 
740 /**
741  * @dev Library for managing
742  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
743  * types.
744  *
745  * Sets have the following properties:
746  *
747  * - Elements are added, removed, and checked for existence in constant time
748  * (O(1)).
749  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
750  *
751  * ```
752  * contract Example {
753  *     // Add the library methods
754  *     using EnumerableSet for EnumerableSet.AddressSet;
755  *
756  *     // Declare a set state variable
757  *     EnumerableSet.AddressSet private mySet;
758  * }
759  * ```
760  *
761  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
762  * and `uint256` (`UintSet`) are supported.
763  */
764 library EnumerableSet {
765     // To implement this library for multiple types with as little code
766     // repetition as possible, we write it in terms of a generic Set type with
767     // bytes32 values.
768     // The Set implementation uses private functions, and user-facing
769     // implementations (such as AddressSet) are just wrappers around the
770     // underlying Set.
771     // This means that we can only create new EnumerableSets for types that fit
772     // in bytes32.
773 
774     struct Set {
775         // Storage of set values
776         bytes32[] _values;
777 
778         // Position of the value in the `values` array, plus 1 because index 0
779         // means a value is not in the set.
780         mapping (bytes32 => uint256) _indexes;
781     }
782 
783     /**
784      * @dev Add a value to a set. O(1).
785      *
786      * Returns true if the value was added to the set, that is if it was not
787      * already present.
788      */
789     function _add(Set storage set, bytes32 value) private returns (bool) {
790         if (!_contains(set, value)) {
791             set._values.push(value);
792             // The value is stored at length-1, but we add 1 to all indexes
793             // and use 0 as a sentinel value
794             set._indexes[value] = set._values.length;
795             return true;
796         } else {
797             return false;
798         }
799     }
800 
801     /**
802      * @dev Removes a value from a set. O(1).
803      *
804      * Returns true if the value was removed from the set, that is if it was
805      * present.
806      */
807     function _remove(Set storage set, bytes32 value) private returns (bool) {
808         // We read and store the value's index to prevent multiple reads from the same storage slot
809         uint256 valueIndex = set._indexes[value];
810 
811         if (valueIndex != 0) { // Equivalent to contains(set, value)
812             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
813             // the array, and then remove the last element (sometimes called as 'swap and pop').
814             // This modifies the order of the array, as noted in {at}.
815 
816             uint256 toDeleteIndex = valueIndex - 1;
817             uint256 lastIndex = set._values.length - 1;
818 
819             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
820             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
821 
822             bytes32 lastvalue = set._values[lastIndex];
823 
824             // Move the last value to the index where the value to delete is
825             set._values[toDeleteIndex] = lastvalue;
826             // Update the index for the moved value
827             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
828 
829             // Delete the slot where the moved value was stored
830             set._values.pop();
831 
832             // Delete the index for the deleted slot
833             delete set._indexes[value];
834 
835             return true;
836         } else {
837             return false;
838         }
839     }
840 
841     /**
842      * @dev Returns true if the value is in the set. O(1).
843      */
844     function _contains(Set storage set, bytes32 value) private view returns (bool) {
845         return set._indexes[value] != 0;
846     }
847 
848     /**
849      * @dev Returns the number of values on the set. O(1).
850      */
851     function _length(Set storage set) private view returns (uint256) {
852         return set._values.length;
853     }
854 
855    /**
856     * @dev Returns the value stored at position `index` in the set. O(1).
857     *
858     * Note that there are no guarantees on the ordering of values inside the
859     * array, and it may change when more values are added or removed.
860     *
861     * Requirements:
862     *
863     * - `index` must be strictly less than {length}.
864     */
865     function _at(Set storage set, uint256 index) private view returns (bytes32) {
866         require(set._values.length > index, "EnumerableSet: index out of bounds");
867         return set._values[index];
868     }
869 
870     // Bytes32Set
871 
872     struct Bytes32Set {
873         Set _inner;
874     }
875 
876     /**
877      * @dev Add a value to a set. O(1).
878      *
879      * Returns true if the value was added to the set, that is if it was not
880      * already present.
881      */
882     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
883         return _add(set._inner, value);
884     }
885 
886     /**
887      * @dev Removes a value from a set. O(1).
888      *
889      * Returns true if the value was removed from the set, that is if it was
890      * present.
891      */
892     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
893         return _remove(set._inner, value);
894     }
895 
896     /**
897      * @dev Returns true if the value is in the set. O(1).
898      */
899     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
900         return _contains(set._inner, value);
901     }
902 
903     /**
904      * @dev Returns the number of values in the set. O(1).
905      */
906     function length(Bytes32Set storage set) internal view returns (uint256) {
907         return _length(set._inner);
908     }
909 
910    /**
911     * @dev Returns the value stored at position `index` in the set. O(1).
912     *
913     * Note that there are no guarantees on the ordering of values inside the
914     * array, and it may change when more values are added or removed.
915     *
916     * Requirements:
917     *
918     * - `index` must be strictly less than {length}.
919     */
920     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
921         return _at(set._inner, index);
922     }
923 
924     // AddressSet
925 
926     struct AddressSet {
927         Set _inner;
928     }
929 
930     /**
931      * @dev Add a value to a set. O(1).
932      *
933      * Returns true if the value was added to the set, that is if it was not
934      * already present.
935      */
936     function add(AddressSet storage set, address value) internal returns (bool) {
937         return _add(set._inner, bytes32(uint256(uint160(value))));
938     }
939 
940     /**
941      * @dev Removes a value from a set. O(1).
942      *
943      * Returns true if the value was removed from the set, that is if it was
944      * present.
945      */
946     function remove(AddressSet storage set, address value) internal returns (bool) {
947         return _remove(set._inner, bytes32(uint256(uint160(value))));
948     }
949 
950     /**
951      * @dev Returns true if the value is in the set. O(1).
952      */
953     function contains(AddressSet storage set, address value) internal view returns (bool) {
954         return _contains(set._inner, bytes32(uint256(uint160(value))));
955     }
956 
957     /**
958      * @dev Returns the number of values in the set. O(1).
959      */
960     function length(AddressSet storage set) internal view returns (uint256) {
961         return _length(set._inner);
962     }
963 
964    /**
965     * @dev Returns the value stored at position `index` in the set. O(1).
966     *
967     * Note that there are no guarantees on the ordering of values inside the
968     * array, and it may change when more values are added or removed.
969     *
970     * Requirements:
971     *
972     * - `index` must be strictly less than {length}.
973     */
974     function at(AddressSet storage set, uint256 index) internal view returns (address) {
975         return address(uint160(uint256(_at(set._inner, index))));
976     }
977 
978 
979     // UintSet
980 
981     struct UintSet {
982         Set _inner;
983     }
984 
985     /**
986      * @dev Add a value to a set. O(1).
987      *
988      * Returns true if the value was added to the set, that is if it was not
989      * already present.
990      */
991     function add(UintSet storage set, uint256 value) internal returns (bool) {
992         return _add(set._inner, bytes32(value));
993     }
994 
995     /**
996      * @dev Removes a value from a set. O(1).
997      *
998      * Returns true if the value was removed from the set, that is if it was
999      * present.
1000      */
1001     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1002         return _remove(set._inner, bytes32(value));
1003     }
1004 
1005     /**
1006      * @dev Returns true if the value is in the set. O(1).
1007      */
1008     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1009         return _contains(set._inner, bytes32(value));
1010     }
1011 
1012     /**
1013      * @dev Returns the number of values on the set. O(1).
1014      */
1015     function length(UintSet storage set) internal view returns (uint256) {
1016         return _length(set._inner);
1017     }
1018 
1019    /**
1020     * @dev Returns the value stored at position `index` in the set. O(1).
1021     *
1022     * Note that there are no guarantees on the ordering of values inside the
1023     * array, and it may change when more values are added or removed.
1024     *
1025     * Requirements:
1026     *
1027     * - `index` must be strictly less than {length}.
1028     */
1029     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1030         return uint256(_at(set._inner, index));
1031     }
1032 }
1033 
1034 
1035 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
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
1304 
1305 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
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
1342 
1343 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1344 
1345 
1346 
1347 pragma solidity >=0.6.0 <0.8.0;
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
1358 
1359 /**
1360  * @title ERC721 Non-Fungible Token Standard basic implementation
1361  * @dev see https://eips.ethereum.org/EIPS/eip-721
1362  */
1363 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1364     using SafeMath for uint256;
1365     using Address for address;
1366     using EnumerableSet for EnumerableSet.UintSet;
1367     using EnumerableMap for EnumerableMap.UintToAddressMap;
1368     using Strings for uint256;
1369 
1370     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1371     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1372     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1373 
1374     // Mapping from holder address to their (enumerable) set of owned tokens
1375     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1376 
1377     // Enumerable mapping from token ids to their owners
1378     EnumerableMap.UintToAddressMap private _tokenOwners;
1379 
1380     // Mapping from token ID to approved address
1381     mapping (uint256 => address) private _tokenApprovals;
1382 
1383     // Mapping from owner to operator approvals
1384     mapping (address => mapping (address => bool)) private _operatorApprovals;
1385 
1386     // Token name
1387     string private _name;
1388 
1389     // Token symbol
1390     string private _symbol;
1391 
1392     // Optional mapping for token URIs
1393     mapping (uint256 => string) private _tokenURIs;
1394 
1395     // Base URI
1396     string private _baseURI;
1397 
1398     /*
1399      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1400      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1401      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1402      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1403      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1404      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1405      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1406      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1407      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1408      *
1409      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1410      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1411      */
1412     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1413 
1414     /*
1415      *     bytes4(keccak256('name()')) == 0x06fdde03
1416      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1417      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1418      *
1419      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1420      */
1421     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1422 
1423     /*
1424      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1425      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1426      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1427      *
1428      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1429      */
1430     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1431 
1432     /**
1433      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1434      */
1435     constructor (string memory name_, string memory symbol_) public {
1436         _name = name_;
1437         _symbol = symbol_;
1438 
1439         // register the supported interfaces to conform to ERC721 via ERC165
1440         _registerInterface(_INTERFACE_ID_ERC721);
1441         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1442         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-balanceOf}.
1447      */
1448     function balanceOf(address owner) public view virtual override returns (uint256) {
1449         require(owner != address(0), "ERC721: balance query for the zero address");
1450         return _holderTokens[owner].length();
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-ownerOf}.
1455      */
1456     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1457         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Metadata-name}.
1462      */
1463     function name() public view virtual override returns (string memory) {
1464         return _name;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Metadata-symbol}.
1469      */
1470     function symbol() public view virtual override returns (string memory) {
1471         return _symbol;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Metadata-tokenURI}.
1476      */
1477     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1478         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1479 
1480         string memory _tokenURI = _tokenURIs[tokenId];
1481         string memory base = baseURI();
1482 
1483         // If there is no base URI, return the token URI.
1484         if (bytes(base).length == 0) {
1485             return _tokenURI;
1486         }
1487         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1488         if (bytes(_tokenURI).length > 0) {
1489             return string(abi.encodePacked(base, _tokenURI));
1490         }
1491         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1492         return string(abi.encodePacked(base, tokenId.toString()));
1493     }
1494 
1495     /**
1496     * @dev Returns the base URI set via {_setBaseURI}. This will be
1497     * automatically added as a prefix in {tokenURI} to each token's URI, or
1498     * to the token ID if no specific URI is set for that token ID.
1499     */
1500     function baseURI() public view virtual returns (string memory) {
1501         return _baseURI;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1506      */
1507     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1508         return _holderTokens[owner].at(index);
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Enumerable-totalSupply}.
1513      */
1514     function totalSupply() public view virtual override returns (uint256) {
1515         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1516         return _tokenOwners.length();
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Enumerable-tokenByIndex}.
1521      */
1522     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1523         (uint256 tokenId, ) = _tokenOwners.at(index);
1524         return tokenId;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-approve}.
1529      */
1530     function approve(address to, uint256 tokenId) public virtual override {
1531         address owner = ERC721.ownerOf(tokenId);
1532         require(to != owner, "ERC721: approval to current owner");
1533 
1534         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1535             "ERC721: approve caller is not owner nor approved for all"
1536         );
1537 
1538         _approve(to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-getApproved}.
1543      */
1544     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1545         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1546 
1547         return _tokenApprovals[tokenId];
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-setApprovalForAll}.
1552      */
1553     function setApprovalForAll(address operator, bool approved) public virtual override {
1554         require(operator != _msgSender(), "ERC721: approve to caller");
1555 
1556         _operatorApprovals[_msgSender()][operator] = approved;
1557         emit ApprovalForAll(_msgSender(), operator, approved);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-isApprovedForAll}.
1562      */
1563     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1564         return _operatorApprovals[owner][operator];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-transferFrom}.
1569      */
1570     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1571         //solhint-disable-next-line max-line-length
1572         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1573 
1574         _transfer(from, to, tokenId);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-safeTransferFrom}.
1579      */
1580     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1581         safeTransferFrom(from, to, tokenId, "");
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-safeTransferFrom}.
1586      */
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1588         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1589         _safeTransfer(from, to, tokenId, _data);
1590     }
1591 
1592     /**
1593      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1594      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1595      *
1596      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1597      *
1598      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1599      * implement alternative mechanisms to perform token transfer, such as signature-based.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      * - `tokenId` token must exist and be owned by `from`.
1606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1611         _transfer(from, to, tokenId);
1612         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1613     }
1614 
1615     /**
1616      * @dev Returns whether `tokenId` exists.
1617      *
1618      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1619      *
1620      * Tokens start existing when they are minted (`_mint`),
1621      * and stop existing when they are burned (`_burn`).
1622      */
1623     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1624         return _tokenOwners.contains(tokenId);
1625     }
1626 
1627     /**
1628      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1629      *
1630      * Requirements:
1631      *
1632      * - `tokenId` must exist.
1633      */
1634     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1635         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1636         address owner = ERC721.ownerOf(tokenId);
1637         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1638     }
1639 
1640     /**
1641      * @dev Safely mints `tokenId` and transfers it to `to`.
1642      *
1643      * Requirements:
1644      d*
1645      * - `tokenId` must not exist.
1646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _safeMint(address to, uint256 tokenId) internal virtual {
1651         _safeMint(to, tokenId, "");
1652     }
1653 
1654     /**
1655      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1656      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1657      */
1658     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1659         _mint(to, tokenId);
1660         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1661     }
1662 
1663     /**
1664      * @dev Mints `tokenId` and transfers it to `to`.
1665      *
1666      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must not exist.
1671      * - `to` cannot be the zero address.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _mint(address to, uint256 tokenId) internal virtual {
1676         require(to != address(0), "ERC721: mint to the zero address");
1677         require(!_exists(tokenId), "ERC721: token already minted");
1678 
1679         _beforeTokenTransfer(address(0), to, tokenId);
1680 
1681         _holderTokens[to].add(tokenId);
1682 
1683         _tokenOwners.set(tokenId, to);
1684 
1685         emit Transfer(address(0), to, tokenId);
1686     }
1687 
1688     /**
1689      * @dev Destroys `tokenId`.
1690      * The approval is cleared when the token is burned.
1691      *
1692      * Requirements:
1693      *
1694      * - `tokenId` must exist.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _burn(uint256 tokenId) internal virtual {
1699         address owner = ERC721.ownerOf(tokenId); // internal owner
1700 
1701         _beforeTokenTransfer(owner, address(0), tokenId);
1702 
1703         // Clear approvals
1704         _approve(address(0), tokenId);
1705 
1706         // Clear metadata (if any)
1707         if (bytes(_tokenURIs[tokenId]).length != 0) {
1708             delete _tokenURIs[tokenId];
1709         }
1710 
1711         _holderTokens[owner].remove(tokenId);
1712 
1713         _tokenOwners.remove(tokenId);
1714 
1715         emit Transfer(owner, address(0), tokenId);
1716     }
1717 
1718     /**
1719      * @dev Transfers `tokenId` from `from` to `to`.
1720      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1721      *
1722      * Requirements:
1723      *
1724      * - `to` cannot be the zero address.
1725      * - `tokenId` token must be owned by `from`.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1730         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1731         require(to != address(0), "ERC721: transfer to the zero address");
1732 
1733         _beforeTokenTransfer(from, to, tokenId);
1734 
1735         // Clear approvals from the previous owner
1736         _approve(address(0), tokenId);
1737 
1738         _holderTokens[from].remove(tokenId);
1739         _holderTokens[to].add(tokenId);
1740 
1741         _tokenOwners.set(tokenId, to);
1742 
1743         emit Transfer(from, to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1748      *
1749      * Requirements:
1750      *
1751      * - `tokenId` must exist.
1752      */
1753     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1754         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1755         _tokenURIs[tokenId] = _tokenURI;
1756     }
1757 
1758     /**
1759      * @dev Internal function to set the base URI for all token IDs. It is
1760      * automatically added as a prefix to the value returned in {tokenURI},
1761      * or to the token ID if {tokenURI} is empty.
1762      */
1763     function _setBaseURI(string memory baseURI_) internal virtual {
1764         _baseURI = baseURI_;
1765     }
1766 
1767     /**
1768      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1769      * The call is not executed if the target address is not a contract.
1770      *
1771      * @param from address representing the previous owner of the given token ID
1772      * @param to target address that will receive the tokens
1773      * @param tokenId uint256 ID of the token to be transferred
1774      * @param _data bytes optional data to send along with the call
1775      * @return bool whether the call correctly returned the expected magic value
1776      */
1777     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1778         private returns (bool)
1779     {
1780         if (!to.isContract()) {
1781             return true;
1782         }
1783         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1784             IERC721Receiver(to).onERC721Received.selector,
1785             _msgSender(),
1786             from,
1787             tokenId,
1788             _data
1789         ), "ERC721: transfer to non ERC721Receiver implementer");
1790         bytes4 retval = abi.decode(returndata, (bytes4));
1791         return (retval == _ERC721_RECEIVED);
1792     }
1793 
1794     /**
1795      * @dev Approve `to` to operate on `tokenId`
1796      *
1797      * Emits an {Approval} event.
1798      */
1799     function _approve(address to, uint256 tokenId) internal virtual {
1800         _tokenApprovals[tokenId] = to;
1801         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1802     }
1803 
1804     /**
1805      * @dev Hook that is called before any token transfer. This includes minting
1806      * and burning.
1807      *
1808      * Calling conditions:
1809      *
1810      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1811      * transferred to `to`.
1812      * - When `from` is zero, `tokenId` will be minted for `to`.
1813      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1814      * - `from` cannot be the zero address.
1815      * - `to` cannot be the zero address.
1816      *
1817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1818      */
1819     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1820 }
1821 
1822 
1823 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
1824 
1825 
1826 
1827 pragma solidity >=0.6.0 <0.8.0;
1828 
1829 /**
1830  * @dev Interface of the ERC20 standard as defined in the EIP.
1831  */
1832 interface IERC20 {
1833     /**
1834      * @dev Returns the amount of tokens in existence.
1835      */
1836     function totalSupply() external view returns (uint256);
1837 
1838     /**
1839      * @dev Returns the amount of tokens owned by `account`.
1840      */
1841     function balanceOf(address account) external view returns (uint256);
1842 
1843     /**
1844      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1845      *
1846      * Returns a boolean value indicating whether the operation succeeded.
1847      *
1848      * Emits a {Transfer} event.
1849      */
1850     function transfer(address recipient, uint256 amount) external returns (bool);
1851 
1852     /**
1853      * @dev Returns the remaining number of tokens that `spender` will be
1854      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1855      * zero by default.
1856      *
1857      * This value changes when {approve} or {transferFrom} are called.
1858      */
1859     function allowance(address owner, address spender) external view returns (uint256);
1860 
1861     /**
1862      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1863      *
1864      * Returns a boolean value indicating whether the operation succeeded.
1865      *
1866      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1867      * that someone may use both the old and the new allowance by unfortunate
1868      * transaction ordering. One possible solution to mitigate this race
1869      * condition is to first reduce the spender's allowance to 0 and set the
1870      * desired value afterwards:
1871      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1872      *
1873      * Emits an {Approval} event.
1874      */
1875     function approve(address spender, uint256 amount) external returns (bool);
1876 
1877     /**
1878      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1879      * allowance mechanism. `amount` is then deducted from the caller's
1880      * allowance.
1881      *
1882      * Returns a boolean value indicating whether the operation succeeded.
1883      *
1884      * Emits a {Transfer} event.
1885      */
1886     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1887 
1888     /**
1889      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1890      * another (`to`).
1891      *
1892      * Note that `value` may be zero.
1893      */
1894     event Transfer(address indexed from, address indexed to, uint256 value);
1895 
1896     /**
1897      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1898      * a call to {approve}. `value` is the new allowance.
1899      */
1900     event Approval(address indexed owner, address indexed spender, uint256 value);
1901 }
1902 
1903 
1904 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1905 
1906 
1907 
1908 pragma solidity >=0.6.0 <0.8.0;
1909 
1910 /**
1911  * @dev Contract module which provides a basic access control mechanism, where
1912  * there is an account (an owner) that can be granted exclusive access to
1913  * specific functions.
1914  *
1915  * By default, the owner account will be the one that deploys the contract. This
1916  * can later be changed with {transferOwnership}.
1917  *
1918  * This module is used through inheritance. It will make available the modifier
1919  * `onlyOwner`, which can be applied to your functions to restrict their use to
1920  * the owner.
1921  */
1922 abstract contract Ownable is Context {
1923     address private _owner;
1924 
1925     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1926 
1927     /**
1928      * @dev Initializes the contract setting the deployer as the initial owner.
1929      */
1930     constructor () internal {
1931         address msgSender = _msgSender();
1932         _owner = msgSender;
1933         emit OwnershipTransferred(address(0), msgSender);
1934     }
1935 
1936     /**
1937      * @dev Returns the address of the current owner.
1938      */
1939     function owner() public view virtual returns (address) {
1940         return _owner;
1941     }
1942 
1943     /**
1944      * @dev Throws if called by any account other than the owner.
1945      */
1946     modifier onlyOwner() {
1947         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1948         _;
1949     }
1950 
1951     /**
1952      * @dev Leaves the contract without owner. It will not be possible to call
1953      * `onlyOwner` functions anymore. Can only be called by the current owner.
1954      *
1955      * NOTE: Renouncing ownership will leave the contract without an owner,
1956      * thereby removing any functionality that is only available to the owner.
1957      */
1958     function renounceOwnership() public virtual onlyOwner {
1959         emit OwnershipTransferred(_owner, address(0));
1960         _owner = address(0);
1961     }
1962 
1963     /**
1964      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1965      * Can only be called by the current owner.
1966      */
1967     function transferOwnership(address newOwner) public virtual onlyOwner {
1968         require(newOwner != address(0), "Ownable: new owner is the zero address");
1969         emit OwnershipTransferred(_owner, newOwner);
1970         _owner = newOwner;
1971     }
1972 }
1973 
1974 
1975 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1976 
1977 
1978 
1979 pragma solidity >=0.6.0 <0.8.0;
1980 
1981 /**
1982  * @title Counters
1983  * @author Matt Condon (@shrugs)
1984  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1985  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1986  *
1987  * Include with `using Counters for Counters.Counter;`
1988  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1989  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1990  * directly accessed.
1991  */
1992 library Counters {
1993     using SafeMath for uint256;
1994 
1995     struct Counter {
1996         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1997         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1998         // this feature: see https://github.com/ethereum/solidity/issues/4637
1999         uint256 _value; // default: 0
2000     }
2001 
2002     function current(Counter storage counter) internal view returns (uint256) {
2003         return counter._value;
2004     }
2005 
2006     function increment(Counter storage counter) internal {
2007         // The {SafeMath} overflow check can be skipped here, see the comment at the top
2008         counter._value += 1;
2009     }
2010 
2011     function decrement(Counter storage counter) internal {
2012         counter._value = counter._value.sub(1);
2013     }
2014 }
2015 
2016 
2017 // File contracts/Bonsai.sol
2018 
2019 
2020 pragma solidity ^0.7.3;
2021 
2022 
2023 
2024 
2025 
2026 
2027 
2028 contract Bonsai is Ownable, ERC165, ERC721 {
2029     // Libraries
2030     using Counters for Counters.Counter;
2031     using Strings for uint256;
2032     using SafeMath for uint256;
2033 
2034     // Private fields
2035     Counters.Counter private _tokenIds;
2036     string private ipfsUri = "https://ipfs.io/ipfs/";
2037 
2038     // Public constants
2039     uint256 public constant MAX_SUPPLY = 8888;
2040 
2041     // Public fields
2042     bool public open = false;
2043 
2044     // This hash is the SHA256 output of the concatenation of the IPFS image hash data for all 8888 Bonsai.
2045     string public provenance = "";
2046 
2047     // This contract will then return a decentralised IPFS URI when tokenURI() is called.
2048     string public folder;
2049 
2050     // This value will be set by an admin to an IPFS url that will list the hash and CID of all Bonsai.
2051     string public provenanceURI = "";
2052 
2053     // After sale is complete, and provenance records updated, the contract will be locked by an admin and then
2054     // the state of the contract will be immutable for the rest of time.
2055     bool public locked = false;
2056 
2057     address public WATER_ADDRESS = 0x65040331cD089670fFB25eE15845a7c876B8A728;
2058 
2059     modifier notLocked() {
2060         require(!locked, "Contract has been locked");
2061         _;
2062     }
2063 
2064     constructor() ERC721("Bonsai", "BNSI") {
2065         _setBaseURI("https://us-central1-zenft-65a6d.cloudfunctions.net/app/");
2066         ownerMint(50);
2067         folder = "";
2068     }
2069 
2070     fallback() external payable {
2071         uint256 quantity = getQuantityFromValue(msg.value);
2072         mint(quantity);
2073     }
2074 
2075     // Public methods
2076     function mint(uint256 quantity) public payable {
2077         require(open, "Bonsai drop not open yet");
2078         require(quantity > 0, "Quantity must be at least 1");
2079 
2080         // Limit buys to 888 Bonsai
2081         if (quantity > 888) {
2082             quantity = 888;
2083         }
2084 
2085         // Limit buys that exceed MAX_SUPPLY
2086         if (quantity.add(totalSupply()) > MAX_SUPPLY) {
2087             quantity = MAX_SUPPLY.sub(totalSupply());
2088         }
2089 
2090         uint256 price = getPrice(quantity);
2091 
2092         // Ensure enough ETH
2093         require(msg.value >= price, "Not enough ETH sent");
2094 
2095         for (uint256 i = 0; i < quantity; i++) {
2096             _mintBonsai(msg.sender);
2097         }
2098     }
2099 
2100     function mintWithWater(uint256 quantity) public payable {
2101         require(open, "Bonsai drop not open yet");
2102         require(quantity > 0, "Quantity must be at least 1");
2103 
2104         // Limit buys to 888 Bonsai
2105         if (quantity > 888) {
2106             quantity = 888;
2107         }
2108 
2109         // Limit buys that exceed MAX_SUPPLY
2110         if (quantity.add(totalSupply()) > MAX_SUPPLY) {
2111             quantity = MAX_SUPPLY.sub(totalSupply());
2112         }
2113 
2114         uint256 price = getWaterPrice(quantity);
2115 
2116         IERC20(WATER_ADDRESS).transferFrom(msg.sender, address(this), price);
2117 
2118         for (uint256 i = 0; i < quantity; i++) {
2119             _mintBonsai(msg.sender);
2120         }
2121     }
2122 
2123     function getQuantityFromValue(uint256 value) public view returns (uint256) {
2124         return value.div(0.08 ether);
2125     }
2126 
2127     function getPrice(uint256 quantity) public view returns (uint256) {
2128         require(quantity <= MAX_SUPPLY);
2129         return quantity.mul(0.08 ether);
2130     }
2131 
2132     function getWaterPrice(uint256 quantity) public view returns (uint256) {
2133         require(quantity <= MAX_SUPPLY);
2134         return quantity.mul(3e24);
2135     }
2136 
2137     function tokenURI(uint256 tokenId)
2138         public
2139         view
2140         virtual
2141         override
2142         returns (string memory)
2143     {
2144         require(
2145             tokenId > 0 && tokenId <= totalSupply(),
2146             "URI query for nonexistent token"
2147         );
2148         // Construct IPFS URI or fallback
2149         if (bytes(folder).length > 0) {
2150             return
2151                 string(
2152                     abi.encodePacked(ipfsUri, folder, "/", tokenId.toString())
2153                 );
2154         }
2155         // Fallback to centralised URI
2156         return string(abi.encodePacked(baseURI(), tokenId.toString()));
2157     }
2158 
2159     // Admin methods
2160     function ownerMint(uint256 quantity) public onlyOwner {
2161         require(!open, "Owner cannot mint after sale opens");
2162 
2163         for (uint256 i = 0; i < quantity; i++) {
2164             _mintBonsai(msg.sender);
2165         }
2166     }
2167 
2168     function openSale() external onlyOwner {
2169         open = true;
2170     }
2171 
2172     function setBaseURI(string memory newBaseURI) external onlyOwner notLocked {
2173         _setBaseURI(newBaseURI);
2174     }
2175 
2176     function setIpfsURI(string memory _ipfsUri) external onlyOwner notLocked {
2177         ipfsUri = _ipfsUri;
2178     }
2179 
2180     function setFolder(string memory _folder) external onlyOwner notLocked {
2181         folder = _folder;
2182     }
2183 
2184     function setProvenanceURI(string memory _provenanceURI)
2185         external
2186         onlyOwner
2187         notLocked
2188     {
2189         provenanceURI = _provenanceURI;
2190     }
2191 
2192     function setProvenance(string memory _provenance)
2193         external
2194         onlyOwner
2195         notLocked
2196     {
2197         provenance = _provenance;
2198     }
2199 
2200     function lock() external onlyOwner {
2201         locked = true;
2202     }
2203 
2204     function withdraw() external onlyOwner {
2205         (bool success, ) =
2206             payable(owner()).call{value: address(this).balance}("");
2207         require(success);
2208     }
2209 
2210     // Private Methods
2211     function _mintBonsai(address owner) private {
2212         _tokenIds.increment();
2213         uint256 newItemId = _tokenIds.current();
2214         _mint(owner, newItemId);
2215     }
2216 }