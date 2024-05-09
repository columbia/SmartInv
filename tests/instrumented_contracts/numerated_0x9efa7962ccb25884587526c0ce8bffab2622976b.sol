1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
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
56 
57 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
58 
59 
60 pragma solidity >=0.6.2 <0.8.0;
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
186 
187 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
188 
189 
190 
191 pragma solidity >=0.6.2 <0.8.0;
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
215 
216 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
217 
218 
219 pragma solidity >=0.6.2 <0.8.0;
220 
221 /**
222  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
223  * @dev See https://eips.ethereum.org/EIPS/eip-721
224  */
225 interface IERC721Enumerable is IERC721 {
226 
227     /**
228      * @dev Returns the total amount of tokens stored by the contract.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
234      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
235      */
236     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
237 
238     /**
239      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
240      * Use along with {totalSupply} to enumerate all tokens.
241      */
242     function tokenByIndex(uint256 index) external view returns (uint256);
243 }
244 
245 
246 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
247 
248 
249 pragma solidity >=0.6.0 <0.8.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by `operator` from `from`, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
265      */
266     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
267 }
268 
269 
270 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
271 
272 
273 pragma solidity >=0.6.0 <0.8.0;
274 
275 /**
276  * @dev Implementation of the {IERC165} interface.
277  *
278  * Contracts may inherit from this and call {_registerInterface} to declare
279  * their support of an interface.
280  */
281 abstract contract ERC165 is IERC165 {
282     /*
283      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
284      */
285     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
286 
287     /**
288      * @dev Mapping of interface ids to whether or not it's supported.
289      */
290     mapping(bytes4 => bool) private _supportedInterfaces;
291 
292     constructor () internal {
293         // Derived contracts need only register support for their own interfaces,
294         // we register support for ERC165 itself here
295         _registerInterface(_INTERFACE_ID_ERC165);
296     }
297 
298     /**
299      * @dev See {IERC165-supportsInterface}.
300      *
301      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
302      */
303     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
304         return _supportedInterfaces[interfaceId];
305     }
306 
307     /**
308      * @dev Registers the contract as an implementer of the interface defined by
309      * `interfaceId`. Support of the actual ERC165 interface is automatic and
310      * registering its interface id is not required.
311      *
312      * See {IERC165-supportsInterface}.
313      *
314      * Requirements:
315      *
316      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
317      */
318     function _registerInterface(bytes4 interfaceId) internal virtual {
319         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
320         _supportedInterfaces[interfaceId] = true;
321     }
322 }
323 
324 
325 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
326 
327 pragma solidity >=0.6.0 <0.8.0;
328 
329 /**
330  * @dev Wrappers over Solidity's arithmetic operations with added overflow
331  * checks.
332  *
333  * Arithmetic operations in Solidity wrap on overflow. This can easily result
334  * in bugs, because programmers usually assume that an overflow raises an
335  * error, which is the standard behavior in high level programming languages.
336  * `SafeMath` restores this intuition by reverting the transaction when an
337  * operation overflows.
338  *
339  * Using this library instead of the unchecked operations eliminates an entire
340  * class of bugs, so it's recommended to use it always.
341  */
342 library SafeMath {
343     /**
344      * @dev Returns the addition of two unsigned integers, with an overflow flag.
345      *
346      * _Available since v3.4._
347      */
348     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
349         uint256 c = a + b;
350         if (c < a) return (false, 0);
351         return (true, c);
352     }
353 
354     /**
355      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
356      *
357      * _Available since v3.4._
358      */
359     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         if (b > a) return (false, 0);
361         return (true, a - b);
362     }
363 
364     /**
365      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
366      *
367      * _Available since v3.4._
368      */
369     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
371         // benefit is lost if 'b' is also tested.
372         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
373         if (a == 0) return (true, 0);
374         uint256 c = a * b;
375         if (c / a != b) return (false, 0);
376         return (true, c);
377     }
378 
379     /**
380      * @dev Returns the division of two unsigned integers, with a division by zero flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385         if (b == 0) return (false, 0);
386         return (true, a / b);
387     }
388 
389     /**
390      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
395         if (b == 0) return (false, 0);
396         return (true, a % b);
397     }
398 
399     /**
400      * @dev Returns the addition of two unsigned integers, reverting on
401      * overflow.
402      *
403      * Counterpart to Solidity's `+` operator.
404      *
405      * Requirements:
406      *
407      * - Addition cannot overflow.
408      */
409     function add(uint256 a, uint256 b) internal pure returns (uint256) {
410         uint256 c = a + b;
411         require(c >= a, "SafeMath: addition overflow");
412         return c;
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting on
417      * overflow (when the result is negative).
418      *
419      * Counterpart to Solidity's `-` operator.
420      *
421      * Requirements:
422      *
423      * - Subtraction cannot overflow.
424      */
425     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
426         require(b <= a, "SafeMath: subtraction overflow");
427         return a - b;
428     }
429 
430     /**
431      * @dev Returns the multiplication of two unsigned integers, reverting on
432      * overflow.
433      *
434      * Counterpart to Solidity's `*` operator.
435      *
436      * Requirements:
437      *
438      * - Multiplication cannot overflow.
439      */
440     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
441         if (a == 0) return 0;
442         uint256 c = a * b;
443         require(c / a == b, "SafeMath: multiplication overflow");
444         return c;
445     }
446 
447     /**
448      * @dev Returns the integer division of two unsigned integers, reverting on
449      * division by zero. The result is rounded towards zero.
450      *
451      * Counterpart to Solidity's `/` operator. Note: this function uses a
452      * `revert` opcode (which leaves remaining gas untouched) while Solidity
453      * uses an invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function div(uint256 a, uint256 b) internal pure returns (uint256) {
460         require(b > 0, "SafeMath: division by zero");
461         return a / b;
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
466      * reverting when dividing by zero.
467      *
468      * Counterpart to Solidity's `%` operator. This function uses a `revert`
469      * opcode (which leaves remaining gas untouched) while Solidity uses an
470      * invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      *
474      * - The divisor cannot be zero.
475      */
476     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
477         require(b > 0, "SafeMath: modulo by zero");
478         return a % b;
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
483      * overflow (when the result is negative).
484      *
485      * CAUTION: This function is deprecated because it requires allocating memory for the error
486      * message unnecessarily. For custom revert reasons use {trySub}.
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
495         require(b <= a, errorMessage);
496         return a - b;
497     }
498 
499     /**
500      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
501      * division by zero. The result is rounded towards zero.
502      *
503      * CAUTION: This function is deprecated because it requires allocating memory for the error
504      * message unnecessarily. For custom revert reasons use {tryDiv}.
505      *
506      * Counterpart to Solidity's `/` operator. Note: this function uses a
507      * `revert` opcode (which leaves remaining gas untouched) while Solidity
508      * uses an invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      *
512      * - The divisor cannot be zero.
513      */
514     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
515         require(b > 0, errorMessage);
516         return a / b;
517     }
518 
519     /**
520      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
521      * reverting with custom message when dividing by zero.
522      *
523      * CAUTION: This function is deprecated because it requires allocating memory for the error
524      * message unnecessarily. For custom revert reasons use {tryMod}.
525      *
526      * Counterpart to Solidity's `%` operator. This function uses a `revert`
527      * opcode (which leaves remaining gas untouched) while Solidity uses an
528      * invalid opcode to revert (consuming all remaining gas).
529      *
530      * Requirements:
531      *
532      * - The divisor cannot be zero.
533      */
534     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
535         require(b > 0, errorMessage);
536         return a % b;
537     }
538 }
539 
540 
541 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
542 
543 
544 pragma solidity >=0.6.2 <0.8.0;
545 
546 /**
547  * @dev Collection of functions related to the address type
548  */
549 library Address {
550     /**
551      * @dev Returns true if `account` is a contract.
552      *
553      * [IMPORTANT]
554      * ====
555      * It is unsafe to assume that an address for which this function returns
556      * false is an externally-owned account (EOA) and not a contract.
557      *
558      * Among others, `isContract` will return false for the following
559      * types of addresses:
560      *
561      *  - an externally-owned account
562      *  - a contract in construction
563      *  - an address where a contract will be created
564      *  - an address where a contract lived, but was destroyed
565      * ====
566      */
567     function isContract(address account) internal view returns (bool) {
568         // This method relies on extcodesize, which returns 0 for contracts in
569         // construction, since the code is only stored at the end of the
570         // constructor execution.
571 
572         uint256 size;
573         // solhint-disable-next-line no-inline-assembly
574         assembly { size := extcodesize(account) }
575         return size > 0;
576     }
577 
578     /**
579      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
580      * `recipient`, forwarding all available gas and reverting on errors.
581      *
582      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
583      * of certain opcodes, possibly making contracts go over the 2300 gas limit
584      * imposed by `transfer`, making them unable to receive funds via
585      * `transfer`. {sendValue} removes this limitation.
586      *
587      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
588      *
589      * IMPORTANT: because control is transferred to `recipient`, care must be
590      * taken to not create reentrancy vulnerabilities. Consider using
591      * {ReentrancyGuard} or the
592      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
593      */
594     function sendValue(address payable recipient, uint256 amount) internal {
595         require(address(this).balance >= amount, "Address: insufficient balance");
596 
597         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
598         (bool success, ) = recipient.call{ value: amount }("");
599         require(success, "Address: unable to send value, recipient may have reverted");
600     }
601 
602     /**
603      * @dev Performs a Solidity function call using a low level `call`. A
604      * plain`call` is an unsafe replacement for a function call: use this
605      * function instead.
606      *
607      * If `target` reverts with a revert reason, it is bubbled up by this
608      * function (like regular Solidity function calls).
609      *
610      * Returns the raw returned data. To convert to the expected return value,
611      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
612      *
613      * Requirements:
614      *
615      * - `target` must be a contract.
616      * - calling `target` with `data` must not revert.
617      *
618      * _Available since v3.1._
619      */
620     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
621       return functionCall(target, data, "Address: low-level call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
626      * `errorMessage` as a fallback revert reason when `target` reverts.
627      *
628      * _Available since v3.1._
629      */
630     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
631         return functionCallWithValue(target, data, 0, errorMessage);
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
636      * but also transferring `value` wei to `target`.
637      *
638      * Requirements:
639      *
640      * - the calling contract must have an ETH balance of at least `value`.
641      * - the called Solidity function must be `payable`.
642      *
643      * _Available since v3.1._
644      */
645     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
651      * with `errorMessage` as a fallback revert reason when `target` reverts.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
656         require(address(this).balance >= value, "Address: insufficient balance for call");
657         require(isContract(target), "Address: call to non-contract");
658 
659         // solhint-disable-next-line avoid-low-level-calls
660         (bool success, bytes memory returndata) = target.call{ value: value }(data);
661         return _verifyCallResult(success, returndata, errorMessage);
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
666      * but performing a static call.
667      *
668      * _Available since v3.3._
669      */
670     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
671         return functionStaticCall(target, data, "Address: low-level static call failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
676      * but performing a static call.
677      *
678      * _Available since v3.3._
679      */
680     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
681         require(isContract(target), "Address: static call to non-contract");
682 
683         // solhint-disable-next-line avoid-low-level-calls
684         (bool success, bytes memory returndata) = target.staticcall(data);
685         return _verifyCallResult(success, returndata, errorMessage);
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
690      * but performing a delegate call.
691      *
692      * _Available since v3.4._
693      */
694     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
695         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
705         require(isContract(target), "Address: delegate call to non-contract");
706 
707         // solhint-disable-next-line avoid-low-level-calls
708         (bool success, bytes memory returndata) = target.delegatecall(data);
709         return _verifyCallResult(success, returndata, errorMessage);
710     }
711 
712     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
713         if (success) {
714             return returndata;
715         } else {
716             // Look for revert reason and bubble it up if present
717             if (returndata.length > 0) {
718                 // The easiest way to bubble the revert reason is using memory via assembly
719 
720                 // solhint-disable-next-line no-inline-assembly
721                 assembly {
722                     let returndata_size := mload(returndata)
723                     revert(add(32, returndata), returndata_size)
724                 }
725             } else {
726                 revert(errorMessage);
727             }
728         }
729     }
730 }
731 
732 
733 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
734 
735 
736 pragma solidity >=0.6.0 <0.8.0;
737 
738 /**
739  * @dev Library for managing
740  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
741  * types.
742  *
743  * Sets have the following properties:
744  *
745  * - Elements are added, removed, and checked for existence in constant time
746  * (O(1)).
747  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
748  *
749  * ```
750  * contract Example {
751  *     // Add the library methods
752  *     using EnumerableSet for EnumerableSet.AddressSet;
753  *
754  *     // Declare a set state variable
755  *     EnumerableSet.AddressSet private mySet;
756  * }
757  * ```
758  *
759  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
760  * and `uint256` (`UintSet`) are supported.
761  */
762 library EnumerableSet {
763     // To implement this library for multiple types with as little code
764     // repetition as possible, we write it in terms of a generic Set type with
765     // bytes32 values.
766     // The Set implementation uses private functions, and user-facing
767     // implementations (such as AddressSet) are just wrappers around the
768     // underlying Set.
769     // This means that we can only create new EnumerableSets for types that fit
770     // in bytes32.
771 
772     struct Set {
773         // Storage of set values
774         bytes32[] _values;
775 
776         // Position of the value in the `values` array, plus 1 because index 0
777         // means a value is not in the set.
778         mapping (bytes32 => uint256) _indexes;
779     }
780 
781     /**
782      * @dev Add a value to a set. O(1).
783      *
784      * Returns true if the value was added to the set, that is if it was not
785      * already present.
786      */
787     function _add(Set storage set, bytes32 value) private returns (bool) {
788         if (!_contains(set, value)) {
789             set._values.push(value);
790             // The value is stored at length-1, but we add 1 to all indexes
791             // and use 0 as a sentinel value
792             set._indexes[value] = set._values.length;
793             return true;
794         } else {
795             return false;
796         }
797     }
798 
799     /**
800      * @dev Removes a value from a set. O(1).
801      *
802      * Returns true if the value was removed from the set, that is if it was
803      * present.
804      */
805     function _remove(Set storage set, bytes32 value) private returns (bool) {
806         // We read and store the value's index to prevent multiple reads from the same storage slot
807         uint256 valueIndex = set._indexes[value];
808 
809         if (valueIndex != 0) { // Equivalent to contains(set, value)
810             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
811             // the array, and then remove the last element (sometimes called as 'swap and pop').
812             // This modifies the order of the array, as noted in {at}.
813 
814             uint256 toDeleteIndex = valueIndex - 1;
815             uint256 lastIndex = set._values.length - 1;
816 
817             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
818             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
819 
820             bytes32 lastvalue = set._values[lastIndex];
821 
822             // Move the last value to the index where the value to delete is
823             set._values[toDeleteIndex] = lastvalue;
824             // Update the index for the moved value
825             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
826 
827             // Delete the slot where the moved value was stored
828             set._values.pop();
829 
830             // Delete the index for the deleted slot
831             delete set._indexes[value];
832 
833             return true;
834         } else {
835             return false;
836         }
837     }
838 
839     /**
840      * @dev Returns true if the value is in the set. O(1).
841      */
842     function _contains(Set storage set, bytes32 value) private view returns (bool) {
843         return set._indexes[value] != 0;
844     }
845 
846     /**
847      * @dev Returns the number of values on the set. O(1).
848      */
849     function _length(Set storage set) private view returns (uint256) {
850         return set._values.length;
851     }
852 
853    /**
854     * @dev Returns the value stored at position `index` in the set. O(1).
855     *
856     * Note that there are no guarantees on the ordering of values inside the
857     * array, and it may change when more values are added or removed.
858     *
859     * Requirements:
860     *
861     * - `index` must be strictly less than {length}.
862     */
863     function _at(Set storage set, uint256 index) private view returns (bytes32) {
864         require(set._values.length > index, "EnumerableSet: index out of bounds");
865         return set._values[index];
866     }
867 
868     // Bytes32Set
869 
870     struct Bytes32Set {
871         Set _inner;
872     }
873 
874     /**
875      * @dev Add a value to a set. O(1).
876      *
877      * Returns true if the value was added to the set, that is if it was not
878      * already present.
879      */
880     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
881         return _add(set._inner, value);
882     }
883 
884     /**
885      * @dev Removes a value from a set. O(1).
886      *
887      * Returns true if the value was removed from the set, that is if it was
888      * present.
889      */
890     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
891         return _remove(set._inner, value);
892     }
893 
894     /**
895      * @dev Returns true if the value is in the set. O(1).
896      */
897     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
898         return _contains(set._inner, value);
899     }
900 
901     /**
902      * @dev Returns the number of values in the set. O(1).
903      */
904     function length(Bytes32Set storage set) internal view returns (uint256) {
905         return _length(set._inner);
906     }
907 
908    /**
909     * @dev Returns the value stored at position `index` in the set. O(1).
910     *
911     * Note that there are no guarantees on the ordering of values inside the
912     * array, and it may change when more values are added or removed.
913     *
914     * Requirements:
915     *
916     * - `index` must be strictly less than {length}.
917     */
918     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
919         return _at(set._inner, index);
920     }
921 
922     // AddressSet
923 
924     struct AddressSet {
925         Set _inner;
926     }
927 
928     /**
929      * @dev Add a value to a set. O(1).
930      *
931      * Returns true if the value was added to the set, that is if it was not
932      * already present.
933      */
934     function add(AddressSet storage set, address value) internal returns (bool) {
935         return _add(set._inner, bytes32(uint256(uint160(value))));
936     }
937 
938     /**
939      * @dev Removes a value from a set. O(1).
940      *
941      * Returns true if the value was removed from the set, that is if it was
942      * present.
943      */
944     function remove(AddressSet storage set, address value) internal returns (bool) {
945         return _remove(set._inner, bytes32(uint256(uint160(value))));
946     }
947 
948     /**
949      * @dev Returns true if the value is in the set. O(1).
950      */
951     function contains(AddressSet storage set, address value) internal view returns (bool) {
952         return _contains(set._inner, bytes32(uint256(uint160(value))));
953     }
954 
955     /**
956      * @dev Returns the number of values in the set. O(1).
957      */
958     function length(AddressSet storage set) internal view returns (uint256) {
959         return _length(set._inner);
960     }
961 
962    /**
963     * @dev Returns the value stored at position `index` in the set. O(1).
964     *
965     * Note that there are no guarantees on the ordering of values inside the
966     * array, and it may change when more values are added or removed.
967     *
968     * Requirements:
969     *
970     * - `index` must be strictly less than {length}.
971     */
972     function at(AddressSet storage set, uint256 index) internal view returns (address) {
973         return address(uint160(uint256(_at(set._inner, index))));
974     }
975 
976 
977     // UintSet
978 
979     struct UintSet {
980         Set _inner;
981     }
982 
983     /**
984      * @dev Add a value to a set. O(1).
985      *
986      * Returns true if the value was added to the set, that is if it was not
987      * already present.
988      */
989     function add(UintSet storage set, uint256 value) internal returns (bool) {
990         return _add(set._inner, bytes32(value));
991     }
992 
993     /**
994      * @dev Removes a value from a set. O(1).
995      *
996      * Returns true if the value was removed from the set, that is if it was
997      * present.
998      */
999     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1000         return _remove(set._inner, bytes32(value));
1001     }
1002 
1003     /**
1004      * @dev Returns true if the value is in the set. O(1).
1005      */
1006     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1007         return _contains(set._inner, bytes32(value));
1008     }
1009 
1010     /**
1011      * @dev Returns the number of values on the set. O(1).
1012      */
1013     function length(UintSet storage set) internal view returns (uint256) {
1014         return _length(set._inner);
1015     }
1016 
1017    /**
1018     * @dev Returns the value stored at position `index` in the set. O(1).
1019     *
1020     * Note that there are no guarantees on the ordering of values inside the
1021     * array, and it may change when more values are added or removed.
1022     *
1023     * Requirements:
1024     *
1025     * - `index` must be strictly less than {length}.
1026     */
1027     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1028         return uint256(_at(set._inner, index));
1029     }
1030 }
1031 
1032 
1033 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
1034 
1035 
1036 pragma solidity >=0.6.0 <0.8.0;
1037 
1038 /**
1039  * @dev Library for managing an enumerable variant of Solidity's
1040  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1041  * type.
1042  *
1043  * Maps have the following properties:
1044  *
1045  * - Entries are added, removed, and checked for existence in constant time
1046  * (O(1)).
1047  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1048  *
1049  * ```
1050  * contract Example {
1051  *     // Add the library methods
1052  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1053  *
1054  *     // Declare a set state variable
1055  *     EnumerableMap.UintToAddressMap private myMap;
1056  * }
1057  * ```
1058  *
1059  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1060  * supported.
1061  */
1062 library EnumerableMap {
1063     // To implement this library for multiple types with as little code
1064     // repetition as possible, we write it in terms of a generic Map type with
1065     // bytes32 keys and values.
1066     // The Map implementation uses private functions, and user-facing
1067     // implementations (such as Uint256ToAddressMap) are just wrappers around
1068     // the underlying Map.
1069     // This means that we can only create new EnumerableMaps for types that fit
1070     // in bytes32.
1071 
1072     struct MapEntry {
1073         bytes32 _key;
1074         bytes32 _value;
1075     }
1076 
1077     struct Map {
1078         // Storage of map keys and values
1079         MapEntry[] _entries;
1080 
1081         // Position of the entry defined by a key in the `entries` array, plus 1
1082         // because index 0 means a key is not in the map.
1083         mapping (bytes32 => uint256) _indexes;
1084     }
1085 
1086     /**
1087      * @dev Adds a key-value pair to a map, or updates the value for an existing
1088      * key. O(1).
1089      *
1090      * Returns true if the key was added to the map, that is if it was not
1091      * already present.
1092      */
1093     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1094         // We read and store the key's index to prevent multiple reads from the same storage slot
1095         uint256 keyIndex = map._indexes[key];
1096 
1097         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1098             map._entries.push(MapEntry({ _key: key, _value: value }));
1099             // The entry is stored at length-1, but we add 1 to all indexes
1100             // and use 0 as a sentinel value
1101             map._indexes[key] = map._entries.length;
1102             return true;
1103         } else {
1104             map._entries[keyIndex - 1]._value = value;
1105             return false;
1106         }
1107     }
1108 
1109     /**
1110      * @dev Removes a key-value pair from a map. O(1).
1111      *
1112      * Returns true if the key was removed from the map, that is if it was present.
1113      */
1114     function _remove(Map storage map, bytes32 key) private returns (bool) {
1115         // We read and store the key's index to prevent multiple reads from the same storage slot
1116         uint256 keyIndex = map._indexes[key];
1117 
1118         if (keyIndex != 0) { // Equivalent to contains(map, key)
1119             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1120             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1121             // This modifies the order of the array, as noted in {at}.
1122 
1123             uint256 toDeleteIndex = keyIndex - 1;
1124             uint256 lastIndex = map._entries.length - 1;
1125 
1126             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1127             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1128 
1129             MapEntry storage lastEntry = map._entries[lastIndex];
1130 
1131             // Move the last entry to the index where the entry to delete is
1132             map._entries[toDeleteIndex] = lastEntry;
1133             // Update the index for the moved entry
1134             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1135 
1136             // Delete the slot where the moved entry was stored
1137             map._entries.pop();
1138 
1139             // Delete the index for the deleted slot
1140             delete map._indexes[key];
1141 
1142             return true;
1143         } else {
1144             return false;
1145         }
1146     }
1147 
1148     /**
1149      * @dev Returns true if the key is in the map. O(1).
1150      */
1151     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1152         return map._indexes[key] != 0;
1153     }
1154 
1155     /**
1156      * @dev Returns the number of key-value pairs in the map. O(1).
1157      */
1158     function _length(Map storage map) private view returns (uint256) {
1159         return map._entries.length;
1160     }
1161 
1162    /**
1163     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1164     *
1165     * Note that there are no guarantees on the ordering of entries inside the
1166     * array, and it may change when more entries are added or removed.
1167     *
1168     * Requirements:
1169     *
1170     * - `index` must be strictly less than {length}.
1171     */
1172     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1173         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1174 
1175         MapEntry storage entry = map._entries[index];
1176         return (entry._key, entry._value);
1177     }
1178 
1179     /**
1180      * @dev Tries to returns the value associated with `key`.  O(1).
1181      * Does not revert if `key` is not in the map.
1182      */
1183     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1184         uint256 keyIndex = map._indexes[key];
1185         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1186         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1187     }
1188 
1189     /**
1190      * @dev Returns the value associated with `key`.  O(1).
1191      *
1192      * Requirements:
1193      *
1194      * - `key` must be in the map.
1195      */
1196     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1197         uint256 keyIndex = map._indexes[key];
1198         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1199         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1200     }
1201 
1202     /**
1203      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1204      *
1205      * CAUTION: This function is deprecated because it requires allocating memory for the error
1206      * message unnecessarily. For custom revert reasons use {_tryGet}.
1207      */
1208     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1209         uint256 keyIndex = map._indexes[key];
1210         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1211         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1212     }
1213 
1214     // UintToAddressMap
1215 
1216     struct UintToAddressMap {
1217         Map _inner;
1218     }
1219 
1220     /**
1221      * @dev Adds a key-value pair to a map, or updates the value for an existing
1222      * key. O(1).
1223      *
1224      * Returns true if the key was added to the map, that is if it was not
1225      * already present.
1226      */
1227     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1228         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1229     }
1230 
1231     /**
1232      * @dev Removes a value from a set. O(1).
1233      *
1234      * Returns true if the key was removed from the map, that is if it was present.
1235      */
1236     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1237         return _remove(map._inner, bytes32(key));
1238     }
1239 
1240     /**
1241      * @dev Returns true if the key is in the map. O(1).
1242      */
1243     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1244         return _contains(map._inner, bytes32(key));
1245     }
1246 
1247     /**
1248      * @dev Returns the number of elements in the map. O(1).
1249      */
1250     function length(UintToAddressMap storage map) internal view returns (uint256) {
1251         return _length(map._inner);
1252     }
1253 
1254    /**
1255     * @dev Returns the element stored at position `index` in the set. O(1).
1256     * Note that there are no guarantees on the ordering of values inside the
1257     * array, and it may change when more values are added or removed.
1258     *
1259     * Requirements:
1260     *
1261     * - `index` must be strictly less than {length}.
1262     */
1263     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1264         (bytes32 key, bytes32 value) = _at(map._inner, index);
1265         return (uint256(key), address(uint160(uint256(value))));
1266     }
1267 
1268     /**
1269      * @dev Tries to returns the value associated with `key`.  O(1).
1270      * Does not revert if `key` is not in the map.
1271      *
1272      * _Available since v3.4._
1273      */
1274     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1275         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1276         return (success, address(uint160(uint256(value))));
1277     }
1278 
1279     /**
1280      * @dev Returns the value associated with `key`.  O(1).
1281      *
1282      * Requirements:
1283      *
1284      * - `key` must be in the map.
1285      */
1286     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1287         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1288     }
1289 
1290     /**
1291      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1292      *
1293      * CAUTION: This function is deprecated because it requires allocating memory for the error
1294      * message unnecessarily. For custom revert reasons use {tryGet}.
1295      */
1296     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1297         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1298     }
1299 }
1300 
1301 
1302 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
1303 
1304 pragma solidity >=0.6.0 <0.8.0;
1305 
1306 /**
1307  * @dev String operations.
1308  */
1309 library Strings {
1310     /**
1311      * @dev Converts a `uint256` to its ASCII `string` representation.
1312      */
1313     function toString(uint256 value) internal pure returns (string memory) {
1314         // Inspired by OraclizeAPI's implementation - MIT licence
1315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1316 
1317         if (value == 0) {
1318             return "0";
1319         }
1320         uint256 temp = value;
1321         uint256 digits;
1322         while (temp != 0) {
1323             digits++;
1324             temp /= 10;
1325         }
1326         bytes memory buffer = new bytes(digits);
1327         uint256 index = digits - 1;
1328         temp = value;
1329         while (temp != 0) {
1330             buffer[index--] = bytes1(uint8(48 + temp % 10));
1331             temp /= 10;
1332         }
1333         return string(buffer);
1334     }
1335 }
1336 
1337 
1338 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1339 
1340 pragma solidity >=0.6.0 <0.8.0;
1341 
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 
1351 
1352 /**
1353  * @title ERC721 Non-Fungible Token Standard basic implementation
1354  * @dev see https://eips.ethereum.org/EIPS/eip-721
1355  */
1356 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1357     using SafeMath for uint256;
1358     using Address for address;
1359     using EnumerableSet for EnumerableSet.UintSet;
1360     using EnumerableMap for EnumerableMap.UintToAddressMap;
1361     using Strings for uint256;
1362 
1363     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1364     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1365     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1366 
1367     // Mapping from holder address to their (enumerable) set of owned tokens
1368     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1369 
1370     // Enumerable mapping from token ids to their owners
1371     EnumerableMap.UintToAddressMap private _tokenOwners;
1372 
1373     // Mapping from token ID to approved address
1374     mapping (uint256 => address) private _tokenApprovals;
1375 
1376     // Mapping from owner to operator approvals
1377     mapping (address => mapping (address => bool)) private _operatorApprovals;
1378 
1379     // Token name
1380     string private _name;
1381 
1382     // Token symbol
1383     string private _symbol;
1384 
1385     // Optional mapping for token URIs
1386     mapping (uint256 => string) private _tokenURIs;
1387 
1388     // Base URI
1389     string private _baseURI;
1390 
1391     /*
1392      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1393      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1394      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1395      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1396      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1397      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1398      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1399      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1400      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1401      *
1402      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1403      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1404      */
1405     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1406 
1407     /*
1408      *     bytes4(keccak256('name()')) == 0x06fdde03
1409      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1410      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1411      *
1412      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1413      */
1414     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1415 
1416     /*
1417      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1418      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1419      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1420      *
1421      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1422      */
1423     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1424 
1425     /**
1426      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1427      */
1428     constructor (string memory name_, string memory symbol_) public {
1429         _name = name_;
1430         _symbol = symbol_;
1431 
1432         // register the supported interfaces to conform to ERC721 via ERC165
1433         _registerInterface(_INTERFACE_ID_ERC721);
1434         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1435         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-balanceOf}.
1440      */
1441     function balanceOf(address owner) public view virtual override returns (uint256) {
1442         require(owner != address(0), "ERC721: balance query for the zero address");
1443         return _holderTokens[owner].length();
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-ownerOf}.
1448      */
1449     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1450         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1451     }
1452 
1453     /**
1454      * @dev See {IERC721Metadata-name}.
1455      */
1456     function name() public view virtual override returns (string memory) {
1457         return _name;
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Metadata-symbol}.
1462      */
1463     function symbol() public view virtual override returns (string memory) {
1464         return _symbol;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Metadata-tokenURI}.
1469      */
1470     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1471         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1472 
1473         string memory _tokenURI = _tokenURIs[tokenId];
1474         string memory base = baseURI();
1475 
1476         // If there is no base URI, return the token URI.
1477         if (bytes(base).length == 0) {
1478             return _tokenURI;
1479         }
1480         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1481         if (bytes(_tokenURI).length > 0) {
1482             return string(abi.encodePacked(base, _tokenURI));
1483         }
1484         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1485         return string(abi.encodePacked(base, tokenId.toString()));
1486     }
1487 
1488     /**
1489     * @dev Returns the base URI set via {_setBaseURI}. This will be
1490     * automatically added as a prefix in {tokenURI} to each token's URI, or
1491     * to the token ID if no specific URI is set for that token ID.
1492     */
1493     function baseURI() public view virtual returns (string memory) {
1494         return _baseURI;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1499      */
1500     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1501         return _holderTokens[owner].at(index);
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Enumerable-totalSupply}.
1506      */
1507     function totalSupply() public view virtual override returns (uint256) {
1508         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1509         return _tokenOwners.length();
1510     }
1511 
1512     /**
1513      * @dev See {IERC721Enumerable-tokenByIndex}.
1514      */
1515     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1516         (uint256 tokenId, ) = _tokenOwners.at(index);
1517         return tokenId;
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-approve}.
1522      */
1523     function approve(address to, uint256 tokenId) public virtual override {
1524         address owner = ERC721.ownerOf(tokenId);
1525         require(to != owner, "ERC721: approval to current owner");
1526 
1527         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1528             "ERC721: approve caller is not owner nor approved for all"
1529         );
1530 
1531         _approve(to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-getApproved}.
1536      */
1537     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1538         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1539 
1540         return _tokenApprovals[tokenId];
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-setApprovalForAll}.
1545      */
1546     function setApprovalForAll(address operator, bool approved) public virtual override {
1547         require(operator != _msgSender(), "ERC721: approve to caller");
1548 
1549         _operatorApprovals[_msgSender()][operator] = approved;
1550         emit ApprovalForAll(_msgSender(), operator, approved);
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-isApprovedForAll}.
1555      */
1556     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1557         return _operatorApprovals[owner][operator];
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-transferFrom}.
1562      */
1563     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1564         //solhint-disable-next-line max-line-length
1565         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1566 
1567         _transfer(from, to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-safeTransferFrom}.
1572      */
1573     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1574         safeTransferFrom(from, to, tokenId, "");
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-safeTransferFrom}.
1579      */
1580     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1581         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1582         _safeTransfer(from, to, tokenId, _data);
1583     }
1584 
1585     /**
1586      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1587      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1588      *
1589      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1590      *
1591      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1592      * implement alternative mechanisms to perform token transfer, such as signature-based.
1593      *
1594      * Requirements:
1595      *
1596      * - `from` cannot be the zero address.
1597      * - `to` cannot be the zero address.
1598      * - `tokenId` token must exist and be owned by `from`.
1599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1604         _transfer(from, to, tokenId);
1605         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1606     }
1607 
1608     /**
1609      * @dev Returns whether `tokenId` exists.
1610      *
1611      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1612      *
1613      * Tokens start existing when they are minted (`_mint`),
1614      * and stop existing when they are burned (`_burn`).
1615      */
1616     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1617         return _tokenOwners.contains(tokenId);
1618     }
1619 
1620     /**
1621      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1622      *
1623      * Requirements:
1624      *
1625      * - `tokenId` must exist.
1626      */
1627     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1628         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1629         address owner = ERC721.ownerOf(tokenId);
1630         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1631     }
1632 
1633     /**
1634      * @dev Safely mints `tokenId` and transfers it to `to`.
1635      *
1636      * Requirements:
1637      d*
1638      * - `tokenId` must not exist.
1639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _safeMint(address to, uint256 tokenId) internal virtual {
1644         _safeMint(to, tokenId, "");
1645     }
1646 
1647     /**
1648      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1649      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1650      */
1651     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1652         _mint(to, tokenId);
1653         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1654     }
1655 
1656     /**
1657      * @dev Mints `tokenId` and transfers it to `to`.
1658      *
1659      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1660      *
1661      * Requirements:
1662      *
1663      * - `tokenId` must not exist.
1664      * - `to` cannot be the zero address.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function _mint(address to, uint256 tokenId) internal virtual {
1669         require(to != address(0), "ERC721: mint to the zero address");
1670         require(!_exists(tokenId), "ERC721: token already minted");
1671 
1672         _beforeTokenTransfer(address(0), to, tokenId);
1673 
1674         _holderTokens[to].add(tokenId);
1675 
1676         _tokenOwners.set(tokenId, to);
1677 
1678         emit Transfer(address(0), to, tokenId);
1679     }
1680 
1681     /**
1682      * @dev Destroys `tokenId`.
1683      * The approval is cleared when the token is burned.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must exist.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _burn(uint256 tokenId) internal virtual {
1692         address owner = ERC721.ownerOf(tokenId); // internal owner
1693 
1694         _beforeTokenTransfer(owner, address(0), tokenId);
1695 
1696         // Clear approvals
1697         _approve(address(0), tokenId);
1698 
1699         // Clear metadata (if any)
1700         if (bytes(_tokenURIs[tokenId]).length != 0) {
1701             delete _tokenURIs[tokenId];
1702         }
1703 
1704         _holderTokens[owner].remove(tokenId);
1705 
1706         _tokenOwners.remove(tokenId);
1707 
1708         emit Transfer(owner, address(0), tokenId);
1709     }
1710 
1711     /**
1712      * @dev Transfers `tokenId` from `from` to `to`.
1713      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1714      *
1715      * Requirements:
1716      *
1717      * - `to` cannot be the zero address.
1718      * - `tokenId` token must be owned by `from`.
1719      *
1720      * Emits a {Transfer} event.
1721      */
1722     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1723         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1724         require(to != address(0), "ERC721: transfer to the zero address");
1725 
1726         _beforeTokenTransfer(from, to, tokenId);
1727 
1728         // Clear approvals from the previous owner
1729         _approve(address(0), tokenId);
1730 
1731         _holderTokens[from].remove(tokenId);
1732         _holderTokens[to].add(tokenId);
1733 
1734         _tokenOwners.set(tokenId, to);
1735 
1736         emit Transfer(from, to, tokenId);
1737     }
1738 
1739     /**
1740      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1741      *
1742      * Requirements:
1743      *
1744      * - `tokenId` must exist.
1745      */
1746     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1747         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1748         _tokenURIs[tokenId] = _tokenURI;
1749     }
1750 
1751     /**
1752      * @dev Internal function to set the base URI for all token IDs. It is
1753      * automatically added as a prefix to the value returned in {tokenURI},
1754      * or to the token ID if {tokenURI} is empty.
1755      */
1756     function _setBaseURI(string memory baseURI_) internal virtual {
1757         _baseURI = baseURI_;
1758     }
1759 
1760     /**
1761      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1762      * The call is not executed if the target address is not a contract.
1763      *
1764      * @param from address representing the previous owner of the given token ID
1765      * @param to target address that will receive the tokens
1766      * @param tokenId uint256 ID of the token to be transferred
1767      * @param _data bytes optional data to send along with the call
1768      * @return bool whether the call correctly returned the expected magic value
1769      */
1770     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1771         private returns (bool)
1772     {
1773         if (!to.isContract()) {
1774             return true;
1775         }
1776         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1777             IERC721Receiver(to).onERC721Received.selector,
1778             _msgSender(),
1779             from,
1780             tokenId,
1781             _data
1782         ), "ERC721: transfer to non ERC721Receiver implementer");
1783         bytes4 retval = abi.decode(returndata, (bytes4));
1784         return (retval == _ERC721_RECEIVED);
1785     }
1786 
1787     /**
1788      * @dev Approve `to` to operate on `tokenId`
1789      *
1790      * Emits an {Approval} event.
1791      */
1792     function _approve(address to, uint256 tokenId) internal virtual {
1793         _tokenApprovals[tokenId] = to;
1794         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1795     }
1796 
1797     /**
1798      * @dev Hook that is called before any token transfer. This includes minting
1799      * and burning.
1800      *
1801      * Calling conditions:
1802      *
1803      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1804      * transferred to `to`.
1805      * - When `from` is zero, `tokenId` will be minted for `to`.
1806      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1807      * - `from` cannot be the zero address.
1808      * - `to` cannot be the zero address.
1809      *
1810      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1811      */
1812     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1813 }
1814 
1815 
1816 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1817 
1818 pragma solidity >=0.6.0 <0.8.0;
1819 
1820 /**
1821  * @title Counters
1822  * @author Matt Condon (@shrugs)
1823  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1824  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1825  *
1826  * Include with `using Counters for Counters.Counter;`
1827  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1828  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1829  * directly accessed.
1830  */
1831 library Counters {
1832     using SafeMath for uint256;
1833 
1834     struct Counter {
1835         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1836         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1837         // this feature: see https://github.com/ethereum/solidity/issues/4637
1838         uint256 _value; // default: 0
1839     }
1840 
1841     function current(Counter storage counter) internal view returns (uint256) {
1842         return counter._value;
1843     }
1844 
1845     function increment(Counter storage counter) internal {
1846         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1847         counter._value += 1;
1848     }
1849 
1850     function decrement(Counter storage counter) internal {
1851         counter._value = counter._value.sub(1);
1852     }
1853 }
1854 
1855 
1856 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1857 
1858 pragma solidity >=0.6.0 <0.8.0;
1859 
1860 /**
1861  * @dev Contract module which provides a basic access control mechanism, where
1862  * there is an account (an owner) that can be granted exclusive access to
1863  * specific functions.
1864  *
1865  * By default, the owner account will be the one that deploys the contract. This
1866  * can later be changed with {transferOwnership}.
1867  *
1868  * This module is used through inheritance. It will make available the modifier
1869  * `onlyOwner`, which can be applied to your functions to restrict their use to
1870  * the owner.
1871  */
1872 abstract contract Ownable is Context {
1873     address private _owner;
1874 
1875     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1876 
1877     /**
1878      * @dev Initializes the contract setting the deployer as the initial owner.
1879      */
1880     constructor () internal {
1881         address msgSender = _msgSender();
1882         _owner = msgSender;
1883         emit OwnershipTransferred(address(0), msgSender);
1884     }
1885 
1886     /**
1887      * @dev Returns the address of the current owner.
1888      */
1889     function owner() public view virtual returns (address) {
1890         return _owner;
1891     }
1892 
1893     /**
1894      * @dev Throws if called by any account other than the owner.
1895      */
1896     modifier onlyOwner() {
1897         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1898         _;
1899     }
1900 
1901     /**
1902      * @dev Leaves the contract without owner. It will not be possible to call
1903      * `onlyOwner` functions anymore. Can only be called by the current owner.
1904      *
1905      * NOTE: Renouncing ownership will leave the contract without an owner,
1906      * thereby removing any functionality that is only available to the owner.
1907      */
1908     function renounceOwnership() public virtual onlyOwner {
1909         emit OwnershipTransferred(_owner, address(0));
1910         _owner = address(0);
1911     }
1912 
1913     /**
1914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1915      * Can only be called by the current owner.
1916      */
1917     function transferOwnership(address newOwner) public virtual onlyOwner {
1918         require(newOwner != address(0), "Ownable: new owner is the zero address");
1919         emit OwnershipTransferred(_owner, newOwner);
1920         _owner = newOwner;
1921     }
1922 }
1923 
1924 
1925 // File contracts/FoxPunkContract.sol
1926 
1927 pragma solidity ^0.7.0;
1928 
1929 
1930 // Inspired/Copied from BGANPUNKS V2 (bastardganpunks.club) and Chubbies (chubbies.io)
1931 contract FOXPUNKJRS is ERC721, Ownable {
1932     using SafeMath for uint256;
1933     uint public constant MAX_FOXES = 5555;
1934     bool public hasSaleStarted = false;
1935 
1936     // THE IPFS HASH OF ALL TOKEN DATAS WILL BE ADDED HERE WHEN ALL FOXES ARE FINALIZED.
1937     string public METADATA_PROVENANCE_HASH = "";
1938 
1939 
1940     constructor() ERC721("FoxPunk Jrs","FOXPUNKJRS")  {
1941         setBaseURI("https://foxpunkapi.herokuapp.com/url/");
1942     }
1943 
1944     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1945         uint256 tokenCount = balanceOf(_owner);
1946         if (tokenCount == 0) {
1947             // Return an empty array
1948             return new uint256[](0);
1949         } else {
1950             uint256[] memory result = new uint256[](tokenCount);
1951             uint256 index;
1952             for (index = 0; index < tokenCount; index++) {
1953                 result[index] = tokenOfOwnerByIndex(_owner, index);
1954             }
1955             return result;
1956         }
1957     }
1958 
1959     function calculatePrice() public view returns (uint256) {
1960         require(hasSaleStarted == true, "Sale hasn't started");
1961 
1962         require(totalSupply() < MAX_FOXES, "Sale has already ended");
1963 
1964         uint currentSupply = totalSupply();
1965         
1966         if(currentSupply >= 5000){
1967             revert();
1968         }else if(currentSupply>=4949){
1969             return 10**18;
1970         }else if(currentSupply>=4499){
1971             return 64 * (10**16);
1972         }else if(currentSupply>=3999){
1973             return 32 * (10**16);
1974         }else if(currentSupply>=1999){
1975             return 16 * (10**16);
1976         }else if(currentSupply>=999){
1977             return 8 * (10**16);
1978         }else if(currentSupply<500){
1979             return 2 * (10**16);
1980         }
1981         return 4* (10**16);
1982 
1983     }
1984     
1985     function TotalSell() public view returns (uint256){
1986         return totalSupply();
1987     }
1988     
1989     function calculatePriceTest(uint _id) public view returns (uint256) {
1990 
1991 
1992         require(_id < MAX_FOXES, "Sale has already ended");
1993 
1994         if(_id >= 5000){
1995             revert();
1996         }else if(_id>=4949){
1997             return 10**18;
1998         }else if(_id>=4499){
1999             return 64 * (10**16);
2000         }else if(_id>=3999){
2001             return 32 * (10**16);
2002         }else if(_id>=1999){
2003             return 16 * (10**16);
2004         }else if(_id>=999){
2005             return 8 * (10**16);
2006         }else if(_id<500){
2007             return 2 * (10**16);
2008         }
2009         return 4* (10**16);
2010     }
2011 
2012    function adoptFox(uint256 numFoxes) public payable {
2013         require(totalSupply() < MAX_FOXES, "Sale has already ended");
2014         require(numFoxes > 0 && numFoxes <= 20, "You can adopt minimum 1, maximum 20 foxes");
2015         require(totalSupply().add(numFoxes) <= MAX_FOXES, "Exceeds MAX_FOXES");
2016         require(msg.value >= calculatePrice().mul(numFoxes), "Ether value sent is below the price");
2017 
2018         for (uint i = 0; i < numFoxes; i++) {
2019             uint mintIndex = totalSupply();
2020             _safeMint(msg.sender, mintIndex);
2021         }
2022 
2023     }
2024 
2025     // ONLYOWNER FUNCTIONS
2026 
2027     function setProvenanceHash(string memory _hash) public onlyOwner {
2028         METADATA_PROVENANCE_HASH = _hash;
2029     }
2030 
2031     function setBaseURI(string memory baseURI) public onlyOwner {
2032         _setBaseURI(baseURI);
2033     }
2034 
2035     function startDrop() public onlyOwner {
2036         hasSaleStarted = true;
2037     }
2038     function pauseDrop() public onlyOwner {
2039         hasSaleStarted = false;
2040     }
2041 
2042     function withdrawAll() public payable onlyOwner {
2043         require(payable(msg.sender).send(address(this).balance));
2044     }
2045 
2046 }