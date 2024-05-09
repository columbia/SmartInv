1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.2 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/introspection/IERC165.sol
27 
28 
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
54 
55 
56 
57 pragma solidity >=0.6.2 <0.8.0;
58 
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     /**
80      * @dev Returns the number of tokens in ``owner``'s account.
81      */
82     function balanceOf(address owner) external view returns (uint256 balance);
83 
84     /**
85      * @dev Returns the owner of the `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     /**
94      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
95      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must exist and be owned by `from`.
102      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
104      *
105      * Emits a {Transfer} event.
106      */
107     function safeTransferFrom(address from, address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(address from, address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169       * @dev Safely transfers `tokenId` token from `from` to `to`.
170       *
171       * Requirements:
172       *
173       * - `from` cannot be the zero address.
174       * - `to` cannot be the zero address.
175       * - `tokenId` token must exist and be owned by `from`.
176       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178       *
179       * Emits a {Transfer} event.
180       */
181     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
182 }
183 
184 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
185 
186 
187 
188 pragma solidity >=0.6.2 <0.8.0;
189 
190 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193  * @dev See https://eips.ethereum.org/EIPS/eip-721
194  */
195 interface IERC721Metadata is IERC721 {
196 
197     /**
198      * @dev Returns the token collection name.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the token collection symbol.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
209      */
210     function tokenURI(uint256 tokenId) external view returns (string memory);
211 }
212 
213 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
214 
215 
216 
217 pragma solidity >=0.6.2 <0.8.0;
218 
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Enumerable is IERC721 {
225 
226     /**
227      * @dev Returns the total amount of tokens stored by the contract.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     /**
232      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
233      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
234      */
235     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
236 
237     /**
238      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
239      * Use along with {totalSupply} to enumerate all tokens.
240      */
241     function tokenByIndex(uint256 index) external view returns (uint256);
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
245 
246 
247 
248 pragma solidity >=0.6.0 <0.8.0;
249 
250 /**
251  * @title ERC721 token receiver interface
252  * @dev Interface for any contract that wants to support safeTransfers
253  * from ERC721 asset contracts.
254  */
255 interface IERC721Receiver {
256     /**
257      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
258      * by `operator` from `from`, this function is called.
259      *
260      * It must return its Solidity selector to confirm the token transfer.
261      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
262      *
263      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
264      */
265     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
266 }
267 
268 // File: @openzeppelin/contracts/introspection/ERC165.sol
269 
270 
271 
272 pragma solidity >=0.6.0 <0.8.0;
273 
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
292     constructor () {
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
324 // File: @openzeppelin/contracts/math/SafeMath.sol
325 
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
541 // File: @openzeppelin/contracts/utils/Address.sol
542 
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
604      * @dev Performs a Solipragma solidity >=0.6.0 <0.8.0;dity function call using a low level `call`. A
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
733 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
734 
735 
736 
737 pragma solidity >=0.6.0 <0.8.0;
738 
739 /**
740  * @dev Library for managing
741  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
742  * types.
743  *
744  * Sets have the following properties:
745  *
746  * - Elements are added, removed, and checked for existence in constant time
747  * (O(1)).
748  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
749  *
750  * ```
751  * contract Example {
752  *     // Add the library methods
753  *     using EnumerableSet for EnumerableSet.AddressSet;
754  *
755  *     // Declare a set state variable
756  *     EnumerableSet.AddressSet private mySet;
757  * }
758  * ```
759  *
760  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
761  * and `uint256` (`UintSet`) are supported.
762  */
763 library EnumerableSet {
764     // To implement this library for multiple types with as little code
765     // repetition as possible, we write it in terms of a generic Set type with
766     // bytes32 values.
767     // The Set implementation uses private functions, and user-facing
768     // implementations (such as AddressSet) are just wrappers around the
769     // underlying Set.
770     // This means that we can only create new EnumerableSets for types that fit
771     // in bytes32.
772 
773     struct Set {
774         // Storage of set values
775         bytes32[] _values;
776 
777         // Position of the value in the `values` array, plus 1 because index 0
778         // means a value is not in the set.
779         mapping (bytes32 => uint256) _indexes;
780     }
781 
782     /**
783      * @dev Add a value to a set. O(1).
784      *
785      * Returns true if the value was added to the set, that is if it was not
786      * already present.
787      */
788     function _add(Set storage set, bytes32 value) private returns (bool) {
789         if (!_contains(set, value)) {
790             set._values.push(value);
791             // The value is stored at length-1, but we add 1 to all indexes
792             // and use 0 as a sentinel value
793             set._indexes[value] = set._values.length;
794             return true;
795         } else {
796             return false;
797         }
798     }
799 
800     /**
801      * @dev Removes a value from a set. O(1).
802      *
803      * Returns true if the value was removed from the set, that is if it was
804      * present.
805      */
806     function _remove(Set storage set, bytes32 value) private returns (bool) {
807         // We read and store the value's index to prevent multiple reads from the same storage slot
808         uint256 valueIndex = set._indexes[value];
809 
810         if (valueIndex != 0) { // Equivalent to contains(set, value)
811             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
812             // the array, and then remove the last element (sometimes called as 'swap and pop').
813             // This modifies the order of the array, as noted in {at}.
814 
815             uint256 toDeleteIndex = valueIndex - 1;
816             uint256 lastIndex = set._values.length - 1;
817 
818             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
819             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
820 
821             bytes32 lastvalue = set._values[lastIndex];
822 
823             // Move the last value to the index where the value to delete is
824             set._values[toDeleteIndex] = lastvalue;
825             // Update the index for the moved value
826             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
827 
828             // Delete the slot where the moved value was stored
829             set._values.pop();
830 
831             // Delete the index for the deleted slot
832             delete set._indexes[value];
833 
834             return true;
835         } else {
836             return false;
837         }
838     }
839 
840     /**
841      * @dev Returns true if the value is in the set. O(1).
842      */
843     function _contains(Set storage set, bytes32 value) private view returns (bool) {
844         return set._indexes[value] != 0;
845     }
846 
847     /**
848      * @dev Returns the number of values on the set. O(1).
849      */
850     function _length(Set storage set) private view returns (uint256) {
851         return set._values.length;
852     }
853 
854    /**
855     * @dev Returns the value stored at position `index` in the set. O(1).
856     *
857     * Note that there are no guarantees on the ordering of values inside the
858     * array, and it may change when more values are added or removed.
859     *
860     * Requirements:
861     *
862     * - `index` must be strictly less than {length}.
863     */
864     function _at(Set storage set, uint256 index) private view returns (bytes32) {
865         require(set._values.length > index, "EnumerableSet: index out of bounds");
866         return set._values[index];
867     }
868 
869     // Bytes32Set
870 
871     struct Bytes32Set {
872         Set _inner;
873     }
874 
875     /**
876      * @dev Add a value to a set. O(1).
877      *
878      * Returns true if the value was added to the set, that is if it was not
879      * already present.
880      */
881     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
882         return _add(set._inner, value);
883     }
884 
885     /**
886      * @dev Removes a value from a set. O(1).
887      *
888      * Returns true if the value was removed from the set, that is if it was
889      * present.
890      */
891     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
892         return _remove(set._inner, value);
893     }
894 
895     /**
896      * @dev Returns true if the value is in the set. O(1).
897      */
898     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
899         return _contains(set._inner, value);
900     }
901 
902     /**
903      * @dev Returns the number of values in the set. O(1).
904      */
905     function length(Bytes32Set storage set) internal view returns (uint256) {
906         return _length(set._inner);
907     }
908 
909    /**
910     * @dev Returns the value stored at position `index` in the set. O(1).
911     *
912     * Note that there are no guarantees on the ordering of values inside the
913     * array, and it may change when more values are added or removed.
914     *
915     * Requirements:
916     *
917     * - `index` must be strictly less than {length}.
918     */
919     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
920         return _at(set._inner, index);
921     }
922 
923     // AddressSet
924 
925     struct AddressSet {
926         Set _inner;
927     }
928 
929     /**
930      * @dev Add a value to a set. O(1).
931      *
932      * Returns true if the value was added to the set, that is if it was not
933      * already present.
934      */
935     function add(AddressSet storage set, address value) internal returns (bool) {
936         return _add(set._inner, bytes32(uint256(uint160(value))));
937     }
938 
939     /**
940      * @dev Removes a value from a set. O(1).
941      *
942      * Returns true if the value was removed from the set, that is if it was
943      * present.
944      */
945     function remove(AddressSet storage set, address value) internal returns (bool) {
946         return _remove(set._inner, bytes32(uint256(uint160(value))));
947     }
948 
949     /**
950      * @dev Returns true if the value is in the set. O(1).
951      */
952     function contains(AddressSet storage set, address value) internal view returns (bool) {
953         return _contains(set._inner, bytes32(uint256(uint160(value))));
954     }
955 
956     /**
957      * @dev Returns the number of values in the set. O(1).
958      */
959     function length(AddressSet storage set) internal view returns (uint256) {
960         return _length(set._inner);
961     }
962 
963    /**
964     * @dev Returns the value stored at position `index` in the set. O(1).
965     *
966     * Note that there are no guarantees on the ordering of values inside the
967     * array, and it may change when more values are added or removed.
968     *
969     * Requirements:
970     *
971     * - `index` must be strictly less than {length}.
972     */
973     function at(AddressSet storage set, uint256 index) internal view returns (address) {
974         return address(uint160(uint256(_at(set._inner, index))));
975     }
976 
977 
978     // UintSet
979 
980     struct UintSet {
981         Set _inner;
982     }
983 
984     /**
985      * @dev Add a value to a set. O(1).
986      *
987      * Returns true if the value was added to the set, that is if it was not
988      * already present.
989      */
990     function add(UintSet storage set, uint256 value) internal returns (bool) {
991         return _add(set._inner, bytes32(value));
992     }
993 
994     /**
995      * @dev Removes a value from a set. O(1).
996      *
997      * Returns true if the value was removed from the set, that is if it was
998      * present.
999      */
1000     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1001         return _remove(set._inner, bytes32(value));
1002     }
1003 
1004     /**
1005      * @dev Returns true if the value is in the set. O(1).
1006      */
1007     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1008         return _contains(set._inner, bytes32(value));
1009     }
1010 
1011     /**
1012      * @dev Returns the number of values on the set. O(1).
1013      */
1014     function length(UintSet storage set) internal view returns (uint256) {
1015         return _length(set._inner);
1016     }
1017 
1018    /**
1019     * @dev Returns the value stored at position `index` in the set. O(1).
1020     *
1021     * Note that there are no guarantees on the ordering of values inside the
1022     * array, and it may change when more values are added or removed.
1023     *
1024     * Requirements:
1025     *
1026     * - `index` must be strictly less than {length}.
1027     */
1028     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1029         return uint256(_at(set._inner, index));
1030     }
1031 }
1032 
1033 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1034 
1035 
1036 
1037 pragma solidity >=0.6.0 <0.8.0;
1038 
1039 /**
1040  * @dev Library for managing an enumerable variant of Solidity's
1041  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1042  * type.
1043  *
1044  * Maps have the following properties:
1045  *
1046  * - Entries are added, removed, and checked for existence in constant time
1047  * (O(1)).
1048  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1049  *
1050  * ```
1051  * contract Example {
1052  *     // Add the library methods
1053  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1054  *
1055  *     // Declare a set state variable
1056  *     EnumerableMap.UintToAddressMap private myMap;
1057  * }
1058  * ```
1059  *
1060  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1061  * supported.
1062  */
1063 library EnumerableMap {
1064     // To implement this library for multiple types with as little code
1065     // repetition as possible, we write it in terms of a generic Map type with
1066     // bytes32 keys and values.
1067     // The Map implementation uses private functions, and user-facing
1068     // implementations (such as Uint256ToAddressMap) are just wrappers around
1069     // the underlying Map.
1070     // This means that we can only create new EnumerableMaps for types that fit
1071     // in bytes32.
1072 
1073     struct MapEntry {
1074         bytes32 _key;
1075         bytes32 _value;
1076     }
1077 
1078     struct Map {
1079         // Storage of map keys and values
1080         MapEntry[] _entries;
1081 
1082         // Position of the entry defined by a key in the `entries` array, plus 1
1083         // because index 0 means a key is not in the map.
1084         mapping (bytes32 => uint256) _indexes;
1085     }
1086 
1087     /**
1088      * @dev Adds a key-value pair to a map, or updates the value for an existing
1089      * key. O(1).
1090      *
1091      * Returns true if the key was added to the map, that is if it was not
1092      * already present.
1093      */
1094     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1095         // We read and store the key's index to prevent multiple reads from the same storage slot
1096         uint256 keyIndex = map._indexes[key];
1097 
1098         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1099             map._entries.push(MapEntry({ _key: key, _value: value }));
1100             // The entry is stored at length-1, but we add 1 to all indexes
1101             // and use 0 as a sentinel value
1102             map._indexes[key] = map._entries.length;
1103             return true;
1104         } else {
1105             map._entries[keyIndex - 1]._value = value;
1106             return false;
1107         }
1108     }
1109 
1110     /**
1111      * @dev Removes a key-value pair from a map. O(1).
1112      *
1113      * Returns true if the key was removed from the map, that is if it was present.
1114      */
1115     function _remove(Map storage map, bytes32 key) private returns (bool) {
1116         // We read and store the key's index to prevent multiple reads from the same storage slot
1117         uint256 keyIndex = map._indexes[key];
1118 
1119         if (keyIndex != 0) { // Equivalent to contains(map, key)
1120             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1121             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1122             // This modifies the order of the array, as noted in {at}.
1123 
1124             uint256 toDeleteIndex = keyIndex - 1;
1125             uint256 lastIndex = map._entries.length - 1;
1126 
1127             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1128             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1129 
1130             MapEntry storage lastEntry = map._entries[lastIndex];
1131 
1132             // Move the last entry to the index where the entry to delete is
1133             map._entries[toDeleteIndex] = lastEntry;
1134             // Update the index for the moved entry
1135             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1136 
1137             // Delete the slot where the moved entry was stored
1138             map._entries.pop();
1139 
1140             // Delete the index for the deleted slot
1141             delete map._indexes[key];
1142 
1143             return true;
1144         } else {
1145             return false;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Returns true if the key is in the map. O(1).
1151      */
1152     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1153         return map._indexes[key] != 0;
1154     }
1155 
1156     /**
1157      * @dev Returns the number of key-value pairs in the map. O(1).
1158      */
1159     function _length(Map storage map) private view returns (uint256) {
1160         return map._entries.length;
1161     }
1162 
1163    /**
1164     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1165     *
1166     * Note that there are no guarantees on the ordering of entries inside the
1167     * array, and it may change when more entries are added or removed.
1168     *
1169     * Requirements:
1170     *
1171     * - `index` must be strictly less than {length}.
1172     */
1173     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1174         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1175 
1176         MapEntry storage entry = map._entries[index];
1177         return (entry._key, entry._value);
1178     }
1179 
1180     /**
1181      * @dev Tries to returns the value associated with `key`.  O(1).
1182      * Does not revert if `key` is not in the map.
1183      */
1184     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1185         uint256 keyIndex = map._indexes[key];
1186         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1187         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1188     }
1189 
1190     /**
1191      * @dev Returns the value associated with `key`.  O(1).
1192      *
1193      * Requirements:
1194      *
1195      * - `key` must be in the map.
1196      */
1197     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1198         uint256 keyIndex = map._indexes[key];
1199         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1200         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1201     }
1202 
1203     /**
1204      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1205      *
1206      * CAUTION: This function is deprecated because it requires allocating memory for the error
1207      * message unnecessarily. For custom revert reasons use {_tryGet}.
1208      */
1209     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1210         uint256 keyIndex = map._indexes[key];
1211         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1212         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1213     }
1214 
1215     // UintToAddressMap
1216 
1217     struct UintToAddressMap {
1218         Map _inner;
1219     }
1220 
1221     /**
1222      * @dev Adds a key-value pair to a map, or updates the value for an existing
1223      * key. O(1).
1224      *
1225      * Returns true if the key was added to the map, that is if it was not
1226      * already present.
1227      */
1228     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1229         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1230     }
1231 
1232     /**
1233      * @dev Removes a value from a set. O(1).
1234      *
1235      * Returns true if the key was removed from the map, that is if it was present.
1236      */
1237     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1238         return _remove(map._inner, bytes32(key));
1239     }
1240 
1241     /**
1242      * @dev Returns true if the key is in the map. O(1).
1243      */
1244     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1245         return _contains(map._inner, bytes32(key));
1246     }
1247 
1248     /**
1249      * @dev Returns the number of elements in the map. O(1).
1250      */
1251     function length(UintToAddressMap storage map) internal view returns (uint256) {
1252         return _length(map._inner);
1253     }
1254 
1255    /**
1256     * @dev Returns the element stored at position `index` in the set. O(1).
1257     * Note that there are no guarantees on the ordering of values inside the
1258     * array, and it may change when more values are added or removed.
1259     *
1260     * Requirements:
1261     *
1262     * - `index` must be strictly less than {length}.
1263     */
1264     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1265         (bytes32 key, bytes32 value) = _at(map._inner, index);
1266         return (uint256(key), address(uint160(uint256(value))));
1267     }
1268 
1269     /**
1270      * @dev Tries to returns the value associated with `key`.  O(1).
1271      * Does not revert if `key` is not in the map.
1272      *
1273      * _Available since v3.4._
1274      */
1275     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1276         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1277         return (success, address(uint160(uint256(value))));
1278     }
1279 
1280     /**
1281      * @dev Returns the value associated with `key`.  O(1).
1282      *
1283      * Requirements:
1284      *
1285      * - `key` must be in the map.
1286      */
1287     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1288         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1289     }
1290 
1291     /**
1292      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1293      *
1294      * CAUTION: This function is deprecated because it requires allocating memory for the error
1295      * message unnecessarily. For custom revert reasons use {tryGet}.
1296      */
1297     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1298         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1299     }
1300 }
1301 
1302 // File: @openzeppelin/contracts/utils/Strings.sol
1303 
1304 
1305 
1306 pragma solidity >=0.6.0 <0.8.0;
1307 
1308 /**
1309  * @dev String operations.
1310  */
1311 library Strings {
1312     /**
1313      * @dev Converts a `uint256` to its ASCII `string` representation.
1314      */
1315     function toString(uint256 value) internal pure returns (string memory) {
1316         // Inspired by OraclizeAPI's implementation - MIT licence
1317         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1318 
1319         if (value == 0) {
1320             return "0";
1321         }
1322         uint256 temp = value;
1323         uint256 digits;
1324         while (temp != 0) {
1325             digits++;
1326             temp /= 10;
1327         }
1328         bytes memory buffer = new bytes(digits);
1329         uint256 index = digits - 1;
1330         temp = value;
1331         while (temp != 0) {
1332             buffer[index--] = bytes1(uint8(48 + temp % 10));
1333             temp /= 10;
1334         }
1335         return string(buffer);
1336     }
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1340 
1341 
1342 
1343 pragma solidity >=0.6.0 <0.8.0;
1344 
1345 /**
1346  * @title ERC721 Non-Fungible Token Standard basic implementation
1347  * @dev see https://eips.ethereum.org/EIPS/eip-721
1348  */
1349 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1350     using SafeMath for uint256;
1351     using Address for address;
1352     using EnumerableSet for EnumerableSet.UintSet;
1353     using EnumerableMap for EnumerableMap.UintToAddressMap;
1354     using Strings for uint256;
1355 
1356     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1357     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1358     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1359 
1360     // Mapping from holder address to their (enumerable) set of owned tokens
1361     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1362 
1363     // Enumerable mapping from token ids to their owners
1364     EnumerableMap.UintToAddressMap private _tokenOwners;
1365 
1366     // Mapping from token ID to approved address
1367     mapping (uint256 => address) private _tokenApprovals;
1368 
1369     // Mapping from owner to operator approvals
1370     mapping (address => mapping (address => bool)) private _operatorApprovals;
1371 
1372     // Token name
1373     string private _name;
1374 
1375     // Token symbol
1376     string private _symbol;
1377 
1378     // Optional mapping for token URIs
1379     mapping (uint256 => string) private _tokenURIs;
1380 
1381     // Base URI
1382     string private _baseURI;
1383 
1384     /*
1385      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1386      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1387      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1388      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1389      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1390      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1391      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1392      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1393      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1394      *
1395      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1396      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1397      */
1398     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1399 
1400     /*
1401      *     bytes4(keccak256('name()')) == 0x06fdde03
1402      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1403      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1404      *
1405      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1406      */
1407     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1408 
1409     /*
1410      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1411      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1412      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1413      *
1414      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1415      */
1416     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1417 
1418     /**
1419      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1420      */
1421     constructor (string memory name_, string memory symbol_)  {
1422         _name = name_;
1423         _symbol = symbol_;
1424 
1425         // register the supported interfaces to conform to ERC721 via ERC165
1426         _registerInterface(_INTERFACE_ID_ERC721);
1427         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1428         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-balanceOf}.
1433      */
1434     function balanceOf(address owner) public view virtual override returns (uint256) {
1435         require(owner != address(0), "ERC721: balance query for the zero address");
1436         return _holderTokens[owner].length();
1437     }
1438 
1439     /**
1440      * @dev See {IERC721-ownerOf}.
1441      */
1442     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1443         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Metadata-name}.
1448      */
1449     function name() public view virtual override returns (string memory) {
1450         return _name;
1451     }
1452 
1453     /**
1454      * @dev See {IERC721Metadata-symbol}.
1455      */
1456     function symbol() public view virtual override returns (string memory) {
1457         return _symbol;
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Metadata-tokenURI}.
1462      */
1463     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1464         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1465 
1466         string memory _tokenURI = _tokenURIs[tokenId];
1467         string memory base = baseURI();
1468 
1469         // If there is no base URI, return the token URI.
1470         if (bytes(base).length == 0) {
1471             return _tokenURI;
1472         }
1473         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1474         if (bytes(_tokenURI).length > 0) {
1475             return string(abi.encodePacked(base, _tokenURI));
1476         }
1477         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1478         return string(abi.encodePacked(base, tokenId.toString()));
1479     }
1480 
1481     /**
1482     * @dev Returns the base URI set via {_setBaseURI}. This will be
1483     * automatically added as a prefix in {tokenURI} to each token's URI, or
1484     * to the token ID if no specific URI is set for that token ID.
1485     */
1486     function baseURI() public view virtual returns (string memory) {
1487         return _baseURI;
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1492      */
1493     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1494         return _holderTokens[owner].at(index);
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Enumerable-totalSupply}.
1499      */
1500     function totalSupply() public view virtual override returns (uint256) {
1501         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1502         return _tokenOwners.length();
1503     }
1504 
1505     /**
1506      * @dev See {IERC721Enumerable-tokenByIndex}.
1507      */
1508     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1509         (uint256 tokenId, ) = _tokenOwners.at(index);
1510         return tokenId;
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-approve}.
1515      */
1516     function approve(address to, uint256 tokenId) public virtual override {
1517         address owner = ERC721.ownerOf(tokenId);
1518         require(to != owner, "ERC721: approval to current owner");
1519 
1520         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1521             "ERC721: approve caller is not owner nor approved for all"
1522         );
1523 
1524         _approve(to, tokenId);
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-getApproved}.
1529      */
1530     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1531         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1532 
1533         return _tokenApprovals[tokenId];
1534     }
1535 
1536     /**
1537      * @dev See {IERC721-setApprovalForAll}.
1538      */
1539     function setApprovalForAll(address operator, bool approved) public virtual override {
1540         require(operator != _msgSender(), "ERC721: approve to caller");
1541 
1542         _operatorApprovals[_msgSender()][operator] = approved;
1543         emit ApprovalForAll(_msgSender(), operator, approved);
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-isApprovedForAll}.
1548      */
1549     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1550         return _operatorApprovals[owner][operator];
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-transferFrom}.
1555      */
1556     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1557         //solhint-disable-next-line max-line-length
1558         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1559 
1560         _transfer(from, to, tokenId);
1561     }
1562 
1563     /**
1564      * @dev See {IERC721-safeTransferFrom}.
1565      */
1566     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1567         safeTransferFrom(from, to, tokenId, "");
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-safeTransferFrom}.
1572      */
1573     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1574         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1575         _safeTransfer(from, to, tokenId, _data);
1576     }
1577 
1578     /**
1579      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1580      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1581      *
1582      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1583      *
1584      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1585      * implement alternative mechanisms to perform token transfer, such as signature-based.
1586      *
1587      * Requirements:
1588      *
1589      * - `from` cannot be the zero address.
1590      * - `to` cannot be the zero address.
1591      * - `tokenId` token must exist and be owned by `from`.
1592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1597         _transfer(from, to, tokenId);
1598         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1599     }
1600 
1601     /**
1602      * @dev Returns whether `tokenId` exists.
1603      *
1604      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1605      *
1606      * Tokens start existing when they are minted (`_mint`),
1607      * and stop existing when they are burned (`_burn`).
1608      */
1609     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1610         return _tokenOwners.contains(tokenId);
1611     }
1612 
1613     /**
1614      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must exist.
1619      */
1620     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1621         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1622         address owner = ERC721.ownerOf(tokenId);
1623         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1624     }
1625 
1626     /**
1627      * @dev Safely mints `tokenId` and transfers it to `to`.
1628      *
1629      * Requirements:
1630      d*
1631      * - `tokenId` must not exist.
1632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _safeMint(address to, uint256 tokenId) internal virtual {
1637         _safeMint(to, tokenId, "");
1638     }
1639 
1640     /**
1641      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1642      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1643      */
1644     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1645         _mint(to, tokenId);
1646         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1647     }
1648 
1649     /**
1650      * @dev Mints `tokenId` and transfers it to `to`.
1651      *
1652      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1653      *
1654      * Requirements:
1655      *
1656      * - `tokenId` must not exist.
1657      * - `to` cannot be the zero address.
1658      *
1659      * Emits a {Transfer} event.
1660      */
1661     function _mint(address to, uint256 tokenId) internal virtual {
1662         require(to != address(0), "ERC721: mint to the zero address");
1663         require(!_exists(tokenId), "ERC721: token already minted");
1664 
1665         _beforeTokenTransfer(address(0), to, tokenId);
1666 
1667         _holderTokens[to].add(tokenId);
1668 
1669         _tokenOwners.set(tokenId, to);
1670 
1671         emit Transfer(address(0), to, tokenId);
1672     }
1673 
1674     /**
1675      * @dev Destroys `tokenId`.
1676      * The approval is cleared when the token is burned.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _burn(uint256 tokenId) internal virtual {
1685         address owner = ERC721.ownerOf(tokenId); // internal owner
1686 
1687         _beforeTokenTransfer(owner, address(0), tokenId);
1688 
1689         // Clear approvals
1690         _approve(address(0), tokenId);
1691 
1692         // Clear metadata (if any)
1693         if (bytes(_tokenURIs[tokenId]).length != 0) {
1694             delete _tokenURIs[tokenId];
1695         }
1696 
1697         _holderTokens[owner].remove(tokenId);
1698 
1699         _tokenOwners.remove(tokenId);
1700 
1701         emit Transfer(owner, address(0), tokenId);
1702     }
1703 
1704     /**
1705      * @dev Transfers `tokenId` from `from` to `to`.
1706      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - `tokenId` token must be owned by `from`.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1716         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1717         require(to != address(0), "ERC721: transfer to the zero address");
1718 
1719         _beforeTokenTransfer(from, to, tokenId);
1720 
1721         // Clear approvals from the previous owner
1722         _approve(address(0), tokenId);
1723 
1724         _holderTokens[from].remove(tokenId);
1725         _holderTokens[to].add(tokenId);
1726 
1727         _tokenOwners.set(tokenId, to);
1728 
1729         emit Transfer(from, to, tokenId);
1730     }
1731 
1732     /**
1733      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1734      *
1735      * Requirements:
1736      *
1737      * - `tokenId` must exist.
1738      */
1739     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1740         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1741         _tokenURIs[tokenId] = _tokenURI;
1742     }
1743 
1744     /**
1745      * @dev Internal function to set the base URI for all token IDs. It is
1746      * automatically added as a prefix to the value returned in {tokenURI},
1747      * or to the token ID if {tokenURI} is empty.
1748      */
1749     function _setBaseURI(string memory baseURI_) internal virtual {
1750         _baseURI = baseURI_;
1751     }
1752 
1753     /**
1754      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1755      * The call is not executed if the target address is not a contract.
1756      *
1757      * @param from address representing the previous owner of the given token ID
1758      * @param to target address that will receive the tokens
1759      * @param tokenId uint256 ID of the token to be transferred
1760      * @param _data bytes optional data to send along with the call
1761      * @return bool whether the call correctly returned the expected magic value
1762      */
1763     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1764         private returns (bool)
1765     {
1766         if (!to.isContract()) {
1767             return true;
1768         }
1769         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1770             IERC721Receiver(to).onERC721Received.selector,
1771             _msgSender(),
1772             from,
1773             tokenId,
1774             _data
1775         ), "ERC721: transfer to non ERC721Receiver implementer");
1776         bytes4 retval = abi.decode(returndata, (bytes4));
1777         return (retval == _ERC721_RECEIVED);
1778     }
1779 
1780     /**
1781      * @dev Approve `to` to operate on `tokenId`
1782      *
1783      * Emits an {Approval} event.
1784      */
1785     function _approve(address to, uint256 tokenId) internal virtual {
1786         _tokenApprovals[tokenId] = to;
1787         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1788     }
1789 
1790     /**
1791      * @dev Hook that is called before any token transfer. This includes minting
1792      * and burning.
1793      *
1794      * Calling conditions:
1795      *
1796      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1797      * transferred to `to`.
1798      * - When `from` is zero, `tokenId` will be minted for `to`.
1799      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1800      * - `from` cannot be the zero address.
1801      * - `to` cannot be the zero address.
1802      *
1803      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1804      */
1805     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1806 }
1807 
1808 // File: @openzeppelin/contracts/access/Ownable.sol
1809 
1810 
1811 
1812 pragma solidity >=0.6.0 <0.8.0;
1813 
1814 /**
1815  * @dev Contract module which provides a basic access control mechanism, where
1816  * there is an account (an owner) that can be granted exclusive access to
1817  * specific functions.
1818  *
1819  * By default, the owner account will be the one that deploys the contract. This
1820  * can later be changed with {transferOwnership}.
1821  *
1822  * This module is used through inheritance. It will make available the modifier
1823  * `onlyOwner`, which can be applied to your functions to restrict their use to
1824  * the owner.
1825  */
1826 abstract contract Ownable is Context {
1827     address private _owner;
1828 
1829     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1830 
1831     /**
1832      * @dev Initializes the contract setting the deployer as the initial owner.
1833      */
1834     constructor () {
1835         address msgSender = _msgSender();
1836         _owner = msgSender;
1837         emit OwnershipTransferred(address(0), msgSender);
1838     }
1839 
1840     /**
1841      * @dev Returns the address of the current owner.
1842      */
1843     function owner() public view virtual returns (address) {
1844         return _owner;
1845     }
1846 
1847     /**
1848      * @dev Throws if called by any account other than the owner.
1849      */
1850     modifier onlyOwner() {
1851         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1852         _;
1853     }
1854 
1855     /**
1856      * @dev Leaves the contract without owner. It will not be possible to call
1857      * `onlyOwner` functions anymore. Can only be called by the current owner.
1858      *
1859      * NOTE: Renouncing ownership will leave the contract without an owner,
1860      * thereby removing any functionality that is only available to the owner.
1861      */
1862     function renounceOwnership() public virtual onlyOwner {
1863         emit OwnershipTransferred(_owner, address(0));
1864         _owner = address(0);
1865     }
1866 
1867     /**
1868      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1869      * Can only be called by the current owner.
1870      */
1871     function transferOwnership(address newOwner) public virtual onlyOwner {
1872         require(newOwner != address(0), "Ownable: new owner is the zero address");
1873         emit OwnershipTransferred(_owner, newOwner);
1874         _owner = newOwner;
1875     }
1876 }
1877 
1878 // File: contracts/BoredApeYachtClub.sol
1879 
1880 
1881 pragma solidity ^0.7.0;
1882 
1883 
1884 
1885 /**
1886  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1887  */
1888 contract Devils is ERC721, Ownable {
1889     using SafeMath for uint256;
1890 
1891     string public LASD_PROVENANCE = "";
1892 
1893     uint256 public startingIndexBlock;
1894 
1895     uint256 public startingIndex;
1896 
1897     uint256 public constant devilPrice = 66600000000000000; //0.0666 ETH
1898 
1899     uint public constant maxDevilPurchase = 20;
1900 
1901     uint256 public MAX_DEVILS;
1902 
1903     bool public saleIsActive = false;
1904 
1905     uint256 public REVEAL_TIMESTAMP;
1906 
1907     constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart) ERC721(name, symbol) {
1908         MAX_DEVILS = maxNftSupply;
1909         REVEAL_TIMESTAMP = saleStart + (86400 * 5);
1910     }
1911 
1912     function withdraw() public onlyOwner {
1913         uint balance = address(this).balance;
1914         msg.sender.transfer(balance);
1915     }
1916 
1917     /**
1918      * Set Devils aside
1919      */
1920     function reserveDevils(uint256 _count) public onlyOwner {        
1921         uint supply = totalSupply();
1922         uint i;
1923         for (i = 0; i < _count; i++) {
1924             _safeMint(msg.sender, supply + i);
1925         }
1926     }
1927 
1928     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1929         REVEAL_TIMESTAMP = revealTimeStamp;
1930     } 
1931 
1932     /*     
1933     * Set provenance once it's calculated
1934     */
1935     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1936         LASD_PROVENANCE = provenanceHash;
1937     }
1938 
1939     function setBaseURI(string memory baseURI) public onlyOwner {
1940         _setBaseURI(baseURI);
1941     }
1942 
1943     /*
1944     * Pause sale if active, make active if paused
1945     */
1946     function flipSaleState() public onlyOwner {
1947         saleIsActive = !saleIsActive;
1948     }
1949 
1950     /**
1951     * Mints Devils
1952     */
1953     function mintDevil(uint numberOfTokens) public payable {
1954         require(saleIsActive, "Sale must be active to mint Devil");
1955         require(numberOfTokens <= maxDevilPurchase, "Can only mint 20 tokens at a time");
1956         require(totalSupply().add(numberOfTokens) <= MAX_DEVILS, "Purchase would exceed max supply of Apes");
1957         require(devilPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1958         
1959         for(uint i = 0; i < numberOfTokens; i++) {
1960             uint mintIndex = totalSupply();
1961             if (totalSupply() < MAX_DEVILS) {
1962                 _safeMint(msg.sender, mintIndex);
1963             }
1964         }
1965 
1966         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
1967         // the end of pre-sale, set the starting index block
1968         if (startingIndexBlock == 0 && (totalSupply() == MAX_DEVILS || block.timestamp >= REVEAL_TIMESTAMP)) {
1969             startingIndexBlock = block.number;
1970         } 
1971     }
1972 
1973     /**
1974      * Set the starting index for the collection
1975      */
1976     function setStartingIndex() public {
1977         require(startingIndex == 0, "Starting index is already set");
1978         require(startingIndexBlock != 0, "Starting index block must be set");
1979         
1980         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_DEVILS;
1981         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1982         if (block.number.sub(startingIndexBlock) > 255) {
1983             startingIndex = uint(blockhash(block.number - 1)) % MAX_DEVILS;
1984         }
1985         // Prevent default sequence
1986         if (startingIndex == 0) {
1987             startingIndex = startingIndex.add(1);
1988         }
1989     }
1990 
1991     /**
1992      * Set the starting index block for the collection, essentially unblocking
1993      * setting starting index
1994      */
1995     function emergencySetStartingIndexBlock() public onlyOwner {
1996         require(startingIndex == 0, "Starting index is already set");
1997         
1998         startingIndexBlock = block.number;
1999     }
2000 }