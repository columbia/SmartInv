1 /*
2     https://twitter.com/LootRealms
3 
4 */
5 
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity >=0.6.0 <0.8.0;
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/introspection/IERC165.sol
34 
35 
36 
37 pragma solidity >=0.6.0 <0.8.0;
38 
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
61 
62 
63 
64 pragma solidity >=0.6.2 <0.8.0;
65 
66 
67 /**
68  * @dev Required interface of an ERC721 compliant contract.
69  */
70 interface IERC721 is IERC165 {
71     /**
72      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(address from, address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Transfers `tokenId` token from `from` to `to`.
118      *
119      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
120      *
121      * Requirements:
122      *
123      * - `from` cannot be the zero address.
124      * - `to` cannot be the zero address.
125      * - `tokenId` token must be owned by `from`.
126      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(address from, address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 
175     /**
176       * @dev Safely transfers `tokenId` token from `from` to `to`.
177       *
178       * Requirements:
179       *
180       * - `from` cannot be the zero address.
181       * - `to` cannot be the zero address.
182       * - `tokenId` token must exist and be owned by `from`.
183       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185       *
186       * Emits a {Transfer} event.
187       */
188     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
192 
193 
194 
195 pragma solidity >=0.6.2 <0.8.0;
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203 
204     /**
205      * @dev Returns the token collection name.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the token collection symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
216      */
217     function tokenURI(uint256 tokenId) external view returns (string memory);
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
221 
222 
223 
224 pragma solidity >=0.6.2 <0.8.0;
225 
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Enumerable is IERC721 {
232 
233     /**
234      * @dev Returns the total amount of tokens stored by the contract.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     /**
239      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
240      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
241      */
242     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
243 
244     /**
245      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
246      * Use along with {totalSupply} to enumerate all tokens.
247      */
248     function tokenByIndex(uint256 index) external view returns (uint256);
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
252 
253 
254 
255 pragma solidity >=0.6.0 <0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by `operator` from `from`, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
271      */
272     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin/contracts/introspection/ERC165.sol
276 
277 
278 
279 pragma solidity >=0.6.0 <0.8.0;
280 
281 
282 /**
283  * @dev Implementation of the {IERC165} interface.
284  *
285  * Contracts may inherit from this and call {_registerInterface} to declare
286  * their support of an interface.
287  */
288 abstract contract ERC165 is IERC165 {
289     /*
290      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
291      */
292     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
293 
294     /**
295      * @dev Mapping of interface ids to whether or not it's supported.
296      */
297     mapping(bytes4 => bool) private _supportedInterfaces;
298 
299     constructor () internal {
300         // Derived contracts need only register support for their own interfaces,
301         // we register support for ERC165 itself here
302         _registerInterface(_INTERFACE_ID_ERC165);
303     }
304 
305     /**
306      * @dev See {IERC165-supportsInterface}.
307      *
308      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return _supportedInterfaces[interfaceId];
312     }
313 
314     /**
315      * @dev Registers the contract as an implementer of the interface defined by
316      * `interfaceId`. Support of the actual ERC165 interface is automatic and
317      * registering its interface id is not required.
318      *
319      * See {IERC165-supportsInterface}.
320      *
321      * Requirements:
322      *
323      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
324      */
325     function _registerInterface(bytes4 interfaceId) internal virtual {
326         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
327         _supportedInterfaces[interfaceId] = true;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/math/SafeMath.sol
332 
333 
334 
335 pragma solidity >=0.6.0 <0.8.0;
336 
337 /**
338  * @dev Wrappers over Solidity's arithmetic operations with added overflow
339  * checks.
340  *
341  * Arithmetic operations in Solidity wrap on overflow. This can easily result
342  * in bugs, because programmers usually assume that an overflow raises an
343  * error, which is the standard behavior in high level programming languages.
344  * `SafeMath` restores this intuition by reverting the transaction when an
345  * operation overflows.
346  *
347  * Using this library instead of the unchecked operations eliminates an entire
348  * class of bugs, so it's recommended to use it always.
349  */
350 library SafeMath {
351     /**
352      * @dev Returns the addition of two unsigned integers, with an overflow flag.
353      *
354      * _Available since v3.4._
355      */
356     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
357         uint256 c = a + b;
358         if (c < a) return (false, 0);
359         return (true, c);
360     }
361 
362     /**
363      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
364      *
365      * _Available since v3.4._
366      */
367     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
368         if (b > a) return (false, 0);
369         return (true, a - b);
370     }
371 
372     /**
373      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
379         // benefit is lost if 'b' is also tested.
380         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
381         if (a == 0) return (true, 0);
382         uint256 c = a * b;
383         if (c / a != b) return (false, 0);
384         return (true, c);
385     }
386 
387     /**
388      * @dev Returns the division of two unsigned integers, with a division by zero flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
393         if (b == 0) return (false, 0);
394         return (true, a / b);
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
399      *
400      * _Available since v3.4._
401      */
402     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         if (b == 0) return (false, 0);
404         return (true, a % b);
405     }
406 
407     /**
408      * @dev Returns the addition of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `+` operator.
412      *
413      * Requirements:
414      *
415      * - Addition cannot overflow.
416      */
417     function add(uint256 a, uint256 b) internal pure returns (uint256) {
418         uint256 c = a + b;
419         require(c >= a, "SafeMath: addition overflow");
420         return c;
421     }
422 
423     /**
424      * @dev Returns the subtraction of two unsigned integers, reverting on
425      * overflow (when the result is negative).
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      *
431      * - Subtraction cannot overflow.
432      */
433     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434         require(b <= a, "SafeMath: subtraction overflow");
435         return a - b;
436     }
437 
438     /**
439      * @dev Returns the multiplication of two unsigned integers, reverting on
440      * overflow.
441      *
442      * Counterpart to Solidity's `*` operator.
443      *
444      * Requirements:
445      *
446      * - Multiplication cannot overflow.
447      */
448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
449         if (a == 0) return 0;
450         uint256 c = a * b;
451         require(c / a == b, "SafeMath: multiplication overflow");
452         return c;
453     }
454 
455     /**
456      * @dev Returns the integer division of two unsigned integers, reverting on
457      * division by zero. The result is rounded towards zero.
458      *
459      * Counterpart to Solidity's `/` operator. Note: this function uses a
460      * `revert` opcode (which leaves remaining gas untouched) while Solidity
461      * uses an invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function div(uint256 a, uint256 b) internal pure returns (uint256) {
468         require(b > 0, "SafeMath: division by zero");
469         return a / b;
470     }
471 
472     /**
473      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
474      * reverting when dividing by zero.
475      *
476      * Counterpart to Solidity's `%` operator. This function uses a `revert`
477      * opcode (which leaves remaining gas untouched) while Solidity uses an
478      * invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
485         require(b > 0, "SafeMath: modulo by zero");
486         return a % b;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
491      * overflow (when the result is negative).
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {trySub}.
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         return a - b;
505     }
506 
507     /**
508      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
509      * division by zero. The result is rounded towards zero.
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {tryDiv}.
513      *
514      * Counterpart to Solidity's `/` operator. Note: this function uses a
515      * `revert` opcode (which leaves remaining gas untouched) while Solidity
516      * uses an invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b > 0, errorMessage);
524         return a / b;
525     }
526 
527     /**
528      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
529      * reverting with custom message when dividing by zero.
530      *
531      * CAUTION: This function is deprecated because it requires allocating memory for the error
532      * message unnecessarily. For custom revert reasons use {tryMod}.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b > 0, errorMessage);
544         return a % b;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/Address.sol
549 
550 
551 
552 pragma solidity >=0.6.2 <0.8.0;
553 
554 /**
555  * @dev Collection of functions related to the address type
556  */
557 library Address {
558     /**
559      * @dev Returns true if `account` is a contract.
560      *
561      * [IMPORTANT]
562      * ====
563      * It is unsafe to assume that an address for which this function returns
564      * false is an externally-owned account (EOA) and not a contract.
565      *
566      * Among others, `isContract` will return false for the following
567      * types of addresses:
568      *
569      *  - an externally-owned account
570      *  - a contract in construction
571      *  - an address where a contract will be created
572      *  - an address where a contract lived, but was destroyed
573      * ====
574      */
575     function isContract(address account) internal view returns (bool) {
576         // This method relies on extcodesize, which returns 0 for contracts in
577         // construction, since the code is only stored at the end of the
578         // constructor execution.
579 
580         uint256 size;
581         // solhint-disable-next-line no-inline-assembly
582         assembly { size := extcodesize(account) }
583         return size > 0;
584     }
585 
586     /**
587      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
588      * `recipient`, forwarding all available gas and reverting on errors.
589      *
590      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
591      * of certain opcodes, possibly making contracts go over the 2300 gas limit
592      * imposed by `transfer`, making them unable to receive funds via
593      * `transfer`. {sendValue} removes this limitation.
594      *
595      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
596      *
597      * IMPORTANT: because control is transferred to `recipient`, care must be
598      * taken to not create reentrancy vulnerabilities. Consider using
599      * {ReentrancyGuard} or the
600      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
601      */
602     function sendValue(address payable recipient, uint256 amount) internal {
603         require(address(this).balance >= amount, "Address: insufficient balance");
604 
605         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
606         (bool success, ) = recipient.call{ value: amount }("");
607         require(success, "Address: unable to send value, recipient may have reverted");
608     }
609 
610     /**
611      * @dev Performs a Solidity function call using a low level `call`. A
612      * plain`call` is an unsafe replacement for a function call: use this
613      * function instead.
614      *
615      * If `target` reverts with a revert reason, it is bubbled up by this
616      * function (like regular Solidity function calls).
617      *
618      * Returns the raw returned data. To convert to the expected return value,
619      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
620      *
621      * Requirements:
622      *
623      * - `target` must be a contract.
624      * - calling `target` with `data` must not revert.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
629       return functionCall(target, data, "Address: low-level call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
634      * `errorMessage` as a fallback revert reason when `target` reverts.
635      *
636      * _Available since v3.1._
637      */
638     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
639         return functionCallWithValue(target, data, 0, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but also transferring `value` wei to `target`.
645      *
646      * Requirements:
647      *
648      * - the calling contract must have an ETH balance of at least `value`.
649      * - the called Solidity function must be `payable`.
650      *
651      * _Available since v3.1._
652      */
653     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
654         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
659      * with `errorMessage` as a fallback revert reason when `target` reverts.
660      *
661      * _Available since v3.1._
662      */
663     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
664         require(address(this).balance >= value, "Address: insufficient balance for call");
665         require(isContract(target), "Address: call to non-contract");
666 
667         // solhint-disable-next-line avoid-low-level-calls
668         (bool success, bytes memory returndata) = target.call{ value: value }(data);
669         return _verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but performing a static call.
675      *
676      * _Available since v3.3._
677      */
678     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
679         return functionStaticCall(target, data, "Address: low-level static call failed");
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
684      * but performing a static call.
685      *
686      * _Available since v3.3._
687      */
688     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
689         require(isContract(target), "Address: static call to non-contract");
690 
691         // solhint-disable-next-line avoid-low-level-calls
692         (bool success, bytes memory returndata) = target.staticcall(data);
693         return _verifyCallResult(success, returndata, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but performing a delegate call.
699      *
700      * _Available since v3.4._
701      */
702     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
703         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
708      * but performing a delegate call.
709      *
710      * _Available since v3.4._
711      */
712     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
713         require(isContract(target), "Address: delegate call to non-contract");
714 
715         // solhint-disable-next-line avoid-low-level-calls
716         (bool success, bytes memory returndata) = target.delegatecall(data);
717         return _verifyCallResult(success, returndata, errorMessage);
718     }
719 
720     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
721         if (success) {
722             return returndata;
723         } else {
724             // Look for revert reason and bubble it up if present
725             if (returndata.length > 0) {
726                 // The easiest way to bubble the revert reason is using memory via assembly
727 
728                 // solhint-disable-next-line no-inline-assembly
729                 assembly {
730                     let returndata_size := mload(returndata)
731                     revert(add(32, returndata), returndata_size)
732                 }
733             } else {
734                 revert(errorMessage);
735             }
736         }
737     }
738 }
739 
740 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
741 
742 
743 
744 pragma solidity >=0.6.0 <0.8.0;
745 
746 /**
747  * @dev Library for managing
748  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
749  * types.
750  *
751  * Sets have the following properties:
752  *
753  * - Elements are added, removed, and checked for existence in constant time
754  * (O(1)).
755  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
756  *
757  * ```
758  * contract Example {
759  *     // Add the library methods
760  *     using EnumerableSet for EnumerableSet.AddressSet;
761  *
762  *     // Declare a set state variable
763  *     EnumerableSet.AddressSet private mySet;
764  * }
765  * ```
766  *
767  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
768  * and `uint256` (`UintSet`) are supported.
769  */
770 library EnumerableSet {
771     // To implement this library for multiple types with as little code
772     // repetition as possible, we write it in terms of a generic Set type with
773     // bytes32 values.
774     // The Set implementation uses private functions, and user-facing
775     // implementations (such as AddressSet) are just wrappers around the
776     // underlying Set.
777     // This means that we can only create new EnumerableSets for types that fit
778     // in bytes32.
779 
780     struct Set {
781         // Storage of set values
782         bytes32[] _values;
783 
784         // Position of the value in the `values` array, plus 1 because index 0
785         // means a value is not in the set.
786         mapping (bytes32 => uint256) _indexes;
787     }
788 
789     /**
790      * @dev Add a value to a set. O(1).
791      *
792      * Returns true if the value was added to the set, that is if it was not
793      * already present.
794      */
795     function _add(Set storage set, bytes32 value) private returns (bool) {
796         if (!_contains(set, value)) {
797             set._values.push(value);
798             // The value is stored at length-1, but we add 1 to all indexes
799             // and use 0 as a sentinel value
800             set._indexes[value] = set._values.length;
801             return true;
802         } else {
803             return false;
804         }
805     }
806 
807     /**
808      * @dev Removes a value from a set. O(1).
809      *
810      * Returns true if the value was removed from the set, that is if it was
811      * present.
812      */
813     function _remove(Set storage set, bytes32 value) private returns (bool) {
814         // We read and store the value's index to prevent multiple reads from the same storage slot
815         uint256 valueIndex = set._indexes[value];
816 
817         if (valueIndex != 0) { // Equivalent to contains(set, value)
818             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
819             // the array, and then remove the last element (sometimes called as 'swap and pop').
820             // This modifies the order of the array, as noted in {at}.
821 
822             uint256 toDeleteIndex = valueIndex - 1;
823             uint256 lastIndex = set._values.length - 1;
824 
825             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
826             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
827 
828             bytes32 lastvalue = set._values[lastIndex];
829 
830             // Move the last value to the index where the value to delete is
831             set._values[toDeleteIndex] = lastvalue;
832             // Update the index for the moved value
833             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
834 
835             // Delete the slot where the moved value was stored
836             set._values.pop();
837 
838             // Delete the index for the deleted slot
839             delete set._indexes[value];
840 
841             return true;
842         } else {
843             return false;
844         }
845     }
846 
847     /**
848      * @dev Returns true if the value is in the set. O(1).
849      */
850     function _contains(Set storage set, bytes32 value) private view returns (bool) {
851         return set._indexes[value] != 0;
852     }
853 
854     /**
855      * @dev Returns the number of values on the set. O(1).
856      */
857     function _length(Set storage set) private view returns (uint256) {
858         return set._values.length;
859     }
860 
861    /**
862     * @dev Returns the value stored at position `index` in the set. O(1).
863     *
864     * Note that there are no guarantees on the ordering of values inside the
865     * array, and it may change when more values are added or removed.
866     *
867     * Requirements:
868     *
869     * - `index` must be strictly less than {length}.
870     */
871     function _at(Set storage set, uint256 index) private view returns (bytes32) {
872         require(set._values.length > index, "EnumerableSet: index out of bounds");
873         return set._values[index];
874     }
875 
876     // Bytes32Set
877 
878     struct Bytes32Set {
879         Set _inner;
880     }
881 
882     /**
883      * @dev Add a value to a set. O(1).
884      *
885      * Returns true if the value was added to the set, that is if it was not
886      * already present.
887      */
888     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
889         return _add(set._inner, value);
890     }
891 
892     /**
893      * @dev Removes a value from a set. O(1).
894      *
895      * Returns true if the value was removed from the set, that is if it was
896      * present.
897      */
898     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
899         return _remove(set._inner, value);
900     }
901 
902     /**
903      * @dev Returns true if the value is in the set. O(1).
904      */
905     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
906         return _contains(set._inner, value);
907     }
908 
909     /**
910      * @dev Returns the number of values in the set. O(1).
911      */
912     function length(Bytes32Set storage set) internal view returns (uint256) {
913         return _length(set._inner);
914     }
915 
916    /**
917     * @dev Returns the value stored at position `index` in the set. O(1).
918     *
919     * Note that there are no guarantees on the ordering of values inside the
920     * array, and it may change when more values are added or removed.
921     *
922     * Requirements:
923     *
924     * - `index` must be strictly less than {length}.
925     */
926     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
927         return _at(set._inner, index);
928     }
929 
930     // AddressSet
931 
932     struct AddressSet {
933         Set _inner;
934     }
935 
936     /**
937      * @dev Add a value to a set. O(1).
938      *
939      * Returns true if the value was added to the set, that is if it was not
940      * already present.
941      */
942     function add(AddressSet storage set, address value) internal returns (bool) {
943         return _add(set._inner, bytes32(uint256(uint160(value))));
944     }
945 
946     /**
947      * @dev Removes a value from a set. O(1).
948      *
949      * Returns true if the value was removed from the set, that is if it was
950      * present.
951      */
952     function remove(AddressSet storage set, address value) internal returns (bool) {
953         return _remove(set._inner, bytes32(uint256(uint160(value))));
954     }
955 
956     /**
957      * @dev Returns true if the value is in the set. O(1).
958      */
959     function contains(AddressSet storage set, address value) internal view returns (bool) {
960         return _contains(set._inner, bytes32(uint256(uint160(value))));
961     }
962 
963     /**
964      * @dev Returns the number of values in the set. O(1).
965      */
966     function length(AddressSet storage set) internal view returns (uint256) {
967         return _length(set._inner);
968     }
969 
970    /**
971     * @dev Returns the value stored at position `index` in the set. O(1).
972     *
973     * Note that there are no guarantees on the ordering of values inside the
974     * array, and it may change when more values are added or removed.
975     *
976     * Requirements:
977     *
978     * - `index` must be strictly less than {length}.
979     */
980     function at(AddressSet storage set, uint256 index) internal view returns (address) {
981         return address(uint160(uint256(_at(set._inner, index))));
982     }
983 
984 
985     // UintSet
986 
987     struct UintSet {
988         Set _inner;
989     }
990 
991     /**
992      * @dev Add a value to a set. O(1).
993      *
994      * Returns true if the value was added to the set, that is if it was not
995      * already present.
996      */
997     function add(UintSet storage set, uint256 value) internal returns (bool) {
998         return _add(set._inner, bytes32(value));
999     }
1000 
1001     /**
1002      * @dev Removes a value from a set. O(1).
1003      *
1004      * Returns true if the value was removed from the set, that is if it was
1005      * present.
1006      */
1007     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1008         return _remove(set._inner, bytes32(value));
1009     }
1010 
1011     /**
1012      * @dev Returns true if the value is in the set. O(1).
1013      */
1014     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1015         return _contains(set._inner, bytes32(value));
1016     }
1017 
1018     /**
1019      * @dev Returns the number of values on the set. O(1).
1020      */
1021     function length(UintSet storage set) internal view returns (uint256) {
1022         return _length(set._inner);
1023     }
1024 
1025    /**
1026     * @dev Returns the value stored at position `index` in the set. O(1).
1027     *
1028     * Note that there are no guarantees on the ordering of values inside the
1029     * array, and it may change when more values are added or removed.
1030     *
1031     * Requirements:
1032     *
1033     * - `index` must be strictly less than {length}.
1034     */
1035     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1036         return uint256(_at(set._inner, index));
1037     }
1038 }
1039 
1040 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1041 
1042 
1043 
1044 pragma solidity >=0.6.0 <0.8.0;
1045 
1046 /**
1047  * @dev Library for managing an enumerable variant of Solidity's
1048  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1049  * type.
1050  *
1051  * Maps have the following properties:
1052  *
1053  * - Entries are added, removed, and checked for existence in constant time
1054  * (O(1)).
1055  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1056  *
1057  * ```
1058  * contract Example {
1059  *     // Add the library methods
1060  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1061  *
1062  *     // Declare a set state variable
1063  *     EnumerableMap.UintToAddressMap private myMap;
1064  * }
1065  * ```
1066  *
1067  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1068  * supported.
1069  */
1070 library EnumerableMap {
1071     // To implement this library for multiple types with as little code
1072     // repetition as possible, we write it in terms of a generic Map type with
1073     // bytes32 keys and values.
1074     // The Map implementation uses private functions, and user-facing
1075     // implementations (such as Uint256ToAddressMap) are just wrappers around
1076     // the underlying Map.
1077     // This means that we can only create new EnumerableMaps for types that fit
1078     // in bytes32.
1079 
1080     struct MapEntry {
1081         bytes32 _key;
1082         bytes32 _value;
1083     }
1084 
1085     struct Map {
1086         // Storage of map keys and values
1087         MapEntry[] _entries;
1088 
1089         // Position of the entry defined by a key in the `entries` array, plus 1
1090         // because index 0 means a key is not in the map.
1091         mapping (bytes32 => uint256) _indexes;
1092     }
1093 
1094     /**
1095      * @dev Adds a key-value pair to a map, or updates the value for an existing
1096      * key. O(1).
1097      *
1098      * Returns true if the key was added to the map, that is if it was not
1099      * already present.
1100      */
1101     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1102         // We read and store the key's index to prevent multiple reads from the same storage slot
1103         uint256 keyIndex = map._indexes[key];
1104 
1105         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1106             map._entries.push(MapEntry({ _key: key, _value: value }));
1107             // The entry is stored at length-1, but we add 1 to all indexes
1108             // and use 0 as a sentinel value
1109             map._indexes[key] = map._entries.length;
1110             return true;
1111         } else {
1112             map._entries[keyIndex - 1]._value = value;
1113             return false;
1114         }
1115     }
1116 
1117     /**
1118      * @dev Removes a key-value pair from a map. O(1).
1119      *
1120      * Returns true if the key was removed from the map, that is if it was present.
1121      */
1122     function _remove(Map storage map, bytes32 key) private returns (bool) {
1123         // We read and store the key's index to prevent multiple reads from the same storage slot
1124         uint256 keyIndex = map._indexes[key];
1125 
1126         if (keyIndex != 0) { // Equivalent to contains(map, key)
1127             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1128             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1129             // This modifies the order of the array, as noted in {at}.
1130 
1131             uint256 toDeleteIndex = keyIndex - 1;
1132             uint256 lastIndex = map._entries.length - 1;
1133 
1134             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1135             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1136 
1137             MapEntry storage lastEntry = map._entries[lastIndex];
1138 
1139             // Move the last entry to the index where the entry to delete is
1140             map._entries[toDeleteIndex] = lastEntry;
1141             // Update the index for the moved entry
1142             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1143 
1144             // Delete the slot where the moved entry was stored
1145             map._entries.pop();
1146 
1147             // Delete the index for the deleted slot
1148             delete map._indexes[key];
1149 
1150             return true;
1151         } else {
1152             return false;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns true if the key is in the map. O(1).
1158      */
1159     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1160         return map._indexes[key] != 0;
1161     }
1162 
1163     /**
1164      * @dev Returns the number of key-value pairs in the map. O(1).
1165      */
1166     function _length(Map storage map) private view returns (uint256) {
1167         return map._entries.length;
1168     }
1169 
1170    /**
1171     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1172     *
1173     * Note that there are no guarantees on the ordering of entries inside the
1174     * array, and it may change when more entries are added or removed.
1175     *
1176     * Requirements:
1177     *
1178     * - `index` must be strictly less than {length}.
1179     */
1180     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1181         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1182 
1183         MapEntry storage entry = map._entries[index];
1184         return (entry._key, entry._value);
1185     }
1186 
1187     /**
1188      * @dev Tries to returns the value associated with `key`.  O(1).
1189      * Does not revert if `key` is not in the map.
1190      */
1191     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1192         uint256 keyIndex = map._indexes[key];
1193         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1194         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1195     }
1196 
1197     /**
1198      * @dev Returns the value associated with `key`.  O(1).
1199      *
1200      * Requirements:
1201      *
1202      * - `key` must be in the map.
1203      */
1204     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1205         uint256 keyIndex = map._indexes[key];
1206         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1207         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1208     }
1209 
1210     /**
1211      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1212      *
1213      * CAUTION: This function is deprecated because it requires allocating memory for the error
1214      * message unnecessarily. For custom revert reasons use {_tryGet}.
1215      */
1216     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1217         uint256 keyIndex = map._indexes[key];
1218         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1219         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1220     }
1221 
1222     // UintToAddressMap
1223 
1224     struct UintToAddressMap {
1225         Map _inner;
1226     }
1227 
1228     /**
1229      * @dev Adds a key-value pair to a map, or updates the value for an existing
1230      * key. O(1).
1231      *
1232      * Returns true if the key was added to the map, that is if it was not
1233      * already present.
1234      */
1235     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1236         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1237     }
1238 
1239     /**
1240      * @dev Removes a value from a set. O(1).
1241      *
1242      * Returns true if the key was removed from the map, that is if it was present.
1243      */
1244     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1245         return _remove(map._inner, bytes32(key));
1246     }
1247 
1248     /**
1249      * @dev Returns true if the key is in the map. O(1).
1250      */
1251     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1252         return _contains(map._inner, bytes32(key));
1253     }
1254 
1255     /**
1256      * @dev Returns the number of elements in the map. O(1).
1257      */
1258     function length(UintToAddressMap storage map) internal view returns (uint256) {
1259         return _length(map._inner);
1260     }
1261 
1262    /**
1263     * @dev Returns the element stored at position `index` in the set. O(1).
1264     * Note that there are no guarantees on the ordering of values inside the
1265     * array, and it may change when more values are added or removed.
1266     *
1267     * Requirements:
1268     *
1269     * - `index` must be strictly less than {length}.
1270     */
1271     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1272         (bytes32 key, bytes32 value) = _at(map._inner, index);
1273         return (uint256(key), address(uint160(uint256(value))));
1274     }
1275 
1276     /**
1277      * @dev Tries to returns the value associated with `key`.  O(1).
1278      * Does not revert if `key` is not in the map.
1279      *
1280      * _Available since v3.4._
1281      */
1282     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1283         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1284         return (success, address(uint160(uint256(value))));
1285     }
1286 
1287     /**
1288      * @dev Returns the value associated with `key`.  O(1).
1289      *
1290      * Requirements:
1291      *
1292      * - `key` must be in the map.
1293      */
1294     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1295         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1296     }
1297 
1298     /**
1299      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1300      *
1301      * CAUTION: This function is deprecated because it requires allocating memory for the error
1302      * message unnecessarily. For custom revert reasons use {tryGet}.
1303      */
1304     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1305         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1306     }
1307 }
1308 
1309 // File: @openzeppelin/contracts/utils/Strings.sol
1310 
1311 
1312 
1313 pragma solidity >=0.6.0 <0.8.0;
1314 
1315 /**
1316  * @dev String operations.
1317  */
1318 library Strings {
1319     /**
1320      * @dev Converts a `uint256` to its ASCII `string` representation.
1321      */
1322     function toString(uint256 value) internal pure returns (string memory) {
1323         // Inspired by OraclizeAPI's implementation - MIT licence
1324         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1325 
1326         if (value == 0) {
1327             return "0";
1328         }
1329         uint256 temp = value;
1330         uint256 digits;
1331         while (temp != 0) {
1332             digits++;
1333             temp /= 10;
1334         }
1335         bytes memory buffer = new bytes(digits);
1336         uint256 index = digits - 1;
1337         temp = value;
1338         while (temp != 0) {
1339             buffer[index--] = bytes1(uint8(48 + temp % 10));
1340             temp /= 10;
1341         }
1342         return string(buffer);
1343     }
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1347 
1348 
1349 
1350 pragma solidity >=0.6.0 <0.8.0;
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 /**
1364  * @title ERC721 Non-Fungible Token Standard basic implementation
1365  * @dev see https://eips.ethereum.org/EIPS/eip-721
1366  */
1367 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1368     using SafeMath for uint256;
1369     using Address for address;
1370     using EnumerableSet for EnumerableSet.UintSet;
1371     using EnumerableMap for EnumerableMap.UintToAddressMap;
1372     using Strings for uint256;
1373 
1374     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1375     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1376     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1377 
1378     // Mapping from holder address to their (enumerable) set of owned tokens
1379     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1380 
1381     // Enumerable mapping from token ids to their owners
1382     EnumerableMap.UintToAddressMap private _tokenOwners;
1383 
1384     // Mapping from token ID to approved address
1385     mapping (uint256 => address) private _tokenApprovals;
1386 
1387     // Mapping from owner to operator approvals
1388     mapping (address => mapping (address => bool)) private _operatorApprovals;
1389 
1390     // Token name
1391     string private _name;
1392 
1393     // Token symbol
1394     string private _symbol;
1395 
1396     // Optional mapping for token URIs
1397     mapping (uint256 => string) private _tokenURIs;
1398 
1399     // Base URI
1400     string private _baseURI;
1401 
1402     /*
1403      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1404      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1405      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1406      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1407      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1408      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1409      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1410      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1411      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1412      *
1413      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1414      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1415      */
1416     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1417 
1418     /*
1419      *     bytes4(keccak256('name()')) == 0x06fdde03
1420      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1421      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1422      *
1423      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1424      */
1425     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1426 
1427     /*
1428      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1429      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1430      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1431      *
1432      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1433      */
1434     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1435 
1436     /**
1437      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1438      */
1439     constructor (string memory name_, string memory symbol_) public {
1440         _name = name_;
1441         _symbol = symbol_;
1442 
1443         // register the supported interfaces to conform to ERC721 via ERC165
1444         _registerInterface(_INTERFACE_ID_ERC721);
1445         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1446         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-balanceOf}.
1451      */
1452     function balanceOf(address owner) public view virtual override returns (uint256) {
1453         require(owner != address(0), "ERC721: balance query for the zero address");
1454         return _holderTokens[owner].length();
1455     }
1456 
1457     /**
1458      * @dev See {IERC721-ownerOf}.
1459      */
1460     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1461         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-name}.
1466      */
1467     function name() public view virtual override returns (string memory) {
1468         return _name;
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Metadata-symbol}.
1473      */
1474     function symbol() public view virtual override returns (string memory) {
1475         return _symbol;
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Metadata-tokenURI}.
1480      */
1481     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1482         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1483 
1484         string memory _tokenURI = _tokenURIs[tokenId];
1485         string memory base = baseURI();
1486 
1487         // If there is no base URI, return the token URI.
1488         if (bytes(base).length == 0) {
1489             return _tokenURI;
1490         }
1491         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1492         if (bytes(_tokenURI).length > 0) {
1493             return string(abi.encodePacked(base, _tokenURI));
1494         }
1495         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1496         return string(abi.encodePacked(base, tokenId.toString()));
1497     }
1498 
1499     /**
1500     * @dev Returns the base URI set via {_setBaseURI}. This will be
1501     * automatically added as a prefix in {tokenURI} to each token's URI, or
1502     * to the token ID if no specific URI is set for that token ID.
1503     */
1504     function baseURI() public view virtual returns (string memory) {
1505         return _baseURI;
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1510      */
1511     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1512         return _holderTokens[owner].at(index);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-totalSupply}.
1517      */
1518     function totalSupply() public view virtual override returns (uint256) {
1519         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1520         return _tokenOwners.length();
1521     }
1522 
1523     /**
1524      * @dev See {IERC721Enumerable-tokenByIndex}.
1525      */
1526     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1527         (uint256 tokenId, ) = _tokenOwners.at(index);
1528         return tokenId;
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-approve}.
1533      */
1534     function approve(address to, uint256 tokenId) public virtual override {
1535         address owner = ERC721.ownerOf(tokenId);
1536         require(to != owner, "ERC721: approval to current owner");
1537 
1538         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1539             "ERC721: approve caller is not owner nor approved for all"
1540         );
1541 
1542         _approve(to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-getApproved}.
1547      */
1548     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1549         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1550 
1551         return _tokenApprovals[tokenId];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-setApprovalForAll}.
1556      */
1557     function setApprovalForAll(address operator, bool approved) public virtual override {
1558         require(operator != _msgSender(), "ERC721: approve to caller");
1559 
1560         _operatorApprovals[_msgSender()][operator] = approved;
1561         emit ApprovalForAll(_msgSender(), operator, approved);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-isApprovedForAll}.
1566      */
1567     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1568         return _operatorApprovals[owner][operator];
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-transferFrom}.
1573      */
1574     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1575         //solhint-disable-next-line max-line-length
1576         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1577 
1578         _transfer(from, to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-safeTransferFrom}.
1583      */
1584     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1585         safeTransferFrom(from, to, tokenId, "");
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-safeTransferFrom}.
1590      */
1591     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1592         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1593         _safeTransfer(from, to, tokenId, _data);
1594     }
1595 
1596     /**
1597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1599      *
1600      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1601      *
1602      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1603      * implement alternative mechanisms to perform token transfer, such as signature-based.
1604      *
1605      * Requirements:
1606      *
1607      * - `from` cannot be the zero address.
1608      * - `to` cannot be the zero address.
1609      * - `tokenId` token must exist and be owned by `from`.
1610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1615         _transfer(from, to, tokenId);
1616         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1617     }
1618 
1619     /**
1620      * @dev Returns whether `tokenId` exists.
1621      *
1622      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1623      *
1624      * Tokens start existing when they are minted (`_mint`),
1625      * and stop existing when they are burned (`_burn`).
1626      */
1627     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1628         return _tokenOwners.contains(tokenId);
1629     }
1630 
1631     /**
1632      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must exist.
1637      */
1638     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1639         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1640         address owner = ERC721.ownerOf(tokenId);
1641         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1642     }
1643 
1644     /**
1645      * @dev Safely mints `tokenId` and transfers it to `to`.
1646      *
1647      * Requirements:
1648      d*
1649      * - `tokenId` must not exist.
1650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function _safeMint(address to, uint256 tokenId) internal virtual {
1655         _safeMint(to, tokenId, "");
1656     }
1657 
1658     /**
1659      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1660      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1661      */
1662     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1663         _mint(to, tokenId);
1664         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1665     }
1666 
1667     /**
1668      * @dev Mints `tokenId` and transfers it to `to`.
1669      *
1670      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1671      *
1672      * Requirements:
1673      *
1674      * - `tokenId` must not exist.
1675      * - `to` cannot be the zero address.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _mint(address to, uint256 tokenId) internal virtual {
1680         require(to != address(0), "ERC721: mint to the zero address");
1681         require(!_exists(tokenId), "ERC721: token already minted");
1682 
1683         _beforeTokenTransfer(address(0), to, tokenId);
1684 
1685         _holderTokens[to].add(tokenId);
1686 
1687         _tokenOwners.set(tokenId, to);
1688 
1689         emit Transfer(address(0), to, tokenId);
1690     }
1691 
1692     /**
1693      * @dev Destroys `tokenId`.
1694      * The approval is cleared when the token is burned.
1695      *
1696      * Requirements:
1697      *
1698      * - `tokenId` must exist.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function _burn(uint256 tokenId) internal virtual {
1703         address owner = ERC721.ownerOf(tokenId); // internal owner
1704 
1705         _beforeTokenTransfer(owner, address(0), tokenId);
1706 
1707         // Clear approvals
1708         _approve(address(0), tokenId);
1709 
1710         // Clear metadata (if any)
1711         if (bytes(_tokenURIs[tokenId]).length != 0) {
1712             delete _tokenURIs[tokenId];
1713         }
1714 
1715         _holderTokens[owner].remove(tokenId);
1716 
1717         _tokenOwners.remove(tokenId);
1718 
1719         emit Transfer(owner, address(0), tokenId);
1720     }
1721 
1722     /**
1723      * @dev Transfers `tokenId` from `from` to `to`.
1724      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1725      *
1726      * Requirements:
1727      *
1728      * - `to` cannot be the zero address.
1729      * - `tokenId` token must be owned by `from`.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1734         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1735         require(to != address(0), "ERC721: transfer to the zero address");
1736 
1737         _beforeTokenTransfer(from, to, tokenId);
1738 
1739         // Clear approvals from the previous owner
1740         _approve(address(0), tokenId);
1741 
1742         _holderTokens[from].remove(tokenId);
1743         _holderTokens[to].add(tokenId);
1744 
1745         _tokenOwners.set(tokenId, to);
1746 
1747         emit Transfer(from, to, tokenId);
1748     }
1749 
1750     /**
1751      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1752      *
1753      * Requirements:
1754      *
1755      * - `tokenId` must exist.
1756      */
1757     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1758         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1759         _tokenURIs[tokenId] = _tokenURI;
1760     }
1761 
1762     /**
1763      * @dev Internal function to set the base URI for all token IDs. It is
1764      * automatically added as a prefix to the value returned in {tokenURI},
1765      * or to the token ID if {tokenURI} is empty.
1766      */
1767     function _setBaseURI(string memory baseURI_) internal virtual {
1768         _baseURI = baseURI_;
1769     }
1770 
1771     /**
1772      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1773      * The call is not executed if the target address is not a contract.
1774      *
1775      * @param from address representing the previous owner of the given token ID
1776      * @param to target address that will receive the tokens
1777      * @param tokenId uint256 ID of the token to be transferred
1778      * @param _data bytes optional data to send along with the call
1779      * @return bool whether the call correctly returned the expected magic value
1780      */
1781     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1782         private returns (bool)
1783     {
1784         if (!to.isContract()) {
1785             return true;
1786         }
1787         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1788             IERC721Receiver(to).onERC721Received.selector,
1789             _msgSender(),
1790             from,
1791             tokenId,
1792             _data
1793         ), "ERC721: transfer to non ERC721Receiver implementer");
1794         bytes4 retval = abi.decode(returndata, (bytes4));
1795         return (retval == _ERC721_RECEIVED);
1796     }
1797 
1798     /**
1799      * @dev Approve `to` to operate on `tokenId`
1800      *
1801      * Emits an {Approval} event.
1802      */
1803     function _approve(address to, uint256 tokenId) internal virtual {
1804         _tokenApprovals[tokenId] = to;
1805         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1806     }
1807 
1808     /**
1809      * @dev Hook that is called before any token transfer. This includes minting
1810      * and burning.
1811      *
1812      * Calling conditions:
1813      *
1814      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1815      * transferred to `to`.
1816      * - When `from` is zero, `tokenId` will be minted for `to`.
1817      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1818      * - `from` cannot be the zero address.
1819      * - `to` cannot be the zero address.
1820      *
1821      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1822      */
1823     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1824 }
1825 
1826 // File: @openzeppelin/contracts/access/Ownable.sol
1827 
1828 
1829 
1830 pragma solidity >=0.6.0 <0.8.0;
1831 
1832 /**
1833  * @dev Contract module which provides a basic access control mechanism, where
1834  * there is an account (an owner) that can be granted exclusive access to
1835  * specific functions.
1836  *
1837  * By default, the owner account will be the one that deploys the contract. This
1838  * can later be changed with {transferOwnership}.
1839  *
1840  * This module is used through inheritance. It will make available the modifier
1841  * `onlyOwner`, which can be applied to your functions to restrict their use to
1842  * the owner.
1843  */
1844 abstract contract Ownable is Context {
1845     address private _owner;
1846 
1847     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1848 
1849     /**
1850      * @dev Initializes the contract setting the deployer as the initial owner.
1851      */
1852     constructor () internal {
1853         address msgSender = _msgSender();
1854         _owner = msgSender;
1855         emit OwnershipTransferred(address(0), msgSender);
1856     }
1857 
1858     /**
1859      * @dev Returns the address of the current owner.
1860      */
1861     function owner() public view virtual returns (address) {
1862         return _owner;
1863     }
1864 
1865     /**
1866      * @dev Throws if called by any account other than the owner.
1867      */
1868     modifier onlyOwner() {
1869         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1870         _;
1871     }
1872 
1873     /**
1874      * @dev Leaves the contract without owner. It will not be possible to call
1875      * `onlyOwner` functions anymore. Can only be called by the current owner.
1876      *
1877      * NOTE: Renouncing ownership will leave the contract without an owner,
1878      * thereby removing any functionality that is only available to the owner.
1879      */
1880     function renounceOwnership() public virtual onlyOwner {
1881         emit OwnershipTransferred(_owner, address(0));
1882         _owner = address(0);
1883     }
1884 
1885     /**
1886      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1887      * Can only be called by the current owner.
1888      */
1889     function transferOwnership(address newOwner) public virtual onlyOwner {
1890         require(newOwner != address(0), "Ownable: new owner is the zero address");
1891         emit OwnershipTransferred(_owner, newOwner);
1892         _owner = newOwner;
1893     }
1894 }
1895 
1896 
1897 
1898 /**
1899  * @dev Contract module that helps prevent reentrant calls to a function.
1900  *
1901  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1902  * available, which can be applied to functions to make sure there are no nested
1903  * (reentrant) calls to them.
1904  *
1905  * Note that because there is a single `nonReentrant` guard, functions marked as
1906  * `nonReentrant` may not call one another. This can be worked around by making
1907  * those functions `private`, and then adding `external` `nonReentrant` entry
1908  * points to them.
1909  *
1910  * TIP: If you would like to learn more about reentrancy and alternative ways
1911  * to protect against it, check out our blog post
1912  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1913  */
1914 abstract contract ReentrancyGuard {
1915     // Booleans are more expensive than uint256 or any type that takes up a full
1916     // word because each write operation emits an extra SLOAD to first read the
1917     // slot's contents, replace the bits taken up by the boolean, and then write
1918     // back. This is the compiler's defense against contract upgrades and
1919     // pointer aliasing, and it cannot be disabled.
1920 
1921     // The values being non-zero value makes deployment a bit more expensive,
1922     // but in exchange the refund on every call to nonReentrant will be lower in
1923     // amount. Since refunds are capped to a percentage of the total
1924     // transaction's gas, it is best to keep them low in cases like this one, to
1925     // increase the likelihood of the full refund coming into effect.
1926     uint256 private constant _NOT_ENTERED = 1;
1927     uint256 private constant _ENTERED = 2;
1928 
1929     uint256 private _status;
1930 
1931     constructor() {
1932         _status = _NOT_ENTERED;
1933     }
1934 
1935     /**
1936      * @dev Prevents a contract from calling itself, directly or indirectly.
1937      * Calling a `nonReentrant` function from another `nonReentrant`
1938      * function is not supported. It is possible to prevent this from happening
1939      * by making the `nonReentrant` function external, and make it call a
1940      * `private` function that does the actual work.
1941      */
1942     modifier nonReentrant() {
1943         // On the first call to nonReentrant, _notEntered will be true
1944         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1945 
1946         // Any calls to nonReentrant after this point will fail
1947         _status = _ENTERED;
1948 
1949         _;
1950 
1951         // By storing the original value once again, a refund is triggered (see
1952         // https://eips.ethereum.org/EIPS/eip-2200)
1953         _status = _NOT_ENTERED;
1954     }
1955 }
1956 
1957 
1958 
1959 //File: contracts/Realms.sol
1960 
1961 pragma solidity ^0.7.0;
1962 
1963 
1964 interface LootInterface {
1965     function ownerOf(uint256 tokenId) external view returns (address owner);
1966 }
1967 
1968 
1969 /**
1970  * @title Realms contract
1971  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1972  */
1973 contract LootRealms is ERC721, ReentrancyGuard, Ownable {
1974     using SafeMath for uint256;
1975 
1976     string public PROVENANCE = "";
1977     uint256 public lootersPrice = 30000000000000000; //0.03 ETH
1978     uint256 public publicPrice = 150000000000000000; //0.15 ETH
1979     bool public saleIsActive = true;
1980     bool public privateSale = true;
1981 
1982     //Loot Contract
1983     address public lootAddress = 0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7;
1984     LootInterface lootContract = LootInterface(lootAddress);
1985 
1986     constructor() ERC721("Realms (for Adventurers)", "LootRealm") {
1987     }
1988 
1989     function withdraw() public onlyOwner {
1990         uint balance = address(this).balance;
1991         msg.sender.transfer(balance);
1992     }
1993 
1994     function deposit() public payable onlyOwner {}
1995 
1996     function flipSaleState() public onlyOwner {
1997         saleIsActive = !saleIsActive;
1998     }
1999 
2000     function endPrivateSale() public onlyOwner {
2001         require(privateSale);
2002         privateSale = false;
2003     }
2004 
2005     function setLootersPrice(uint256 newPrice) public onlyOwner {
2006         lootersPrice = newPrice;
2007     }
2008 
2009     function setPublicPrice(uint256 newPrice) public onlyOwner {
2010         publicPrice = newPrice;
2011     }
2012 
2013     function setBaseURI(string memory baseURI) public onlyOwner {
2014         _setBaseURI(baseURI);
2015     }
2016 
2017     function setProvenance(string memory prov) public onlyOwner {
2018         PROVENANCE = prov;
2019     }
2020 
2021     //Private sale minting (reserved for Loot owners)
2022     function mintWithLoot(uint lootId) public payable nonReentrant {
2023         require(privateSale, "Private sale minting is over");
2024         require(saleIsActive, "Sale must be active to mint");
2025         require(lootersPrice <= msg.value, "Ether value sent is not correct");
2026         require(lootContract.ownerOf(lootId) == msg.sender, "Not the owner of this loot");
2027         require(!_exists(lootId), "This token has already been minted");
2028 
2029         _safeMint(msg.sender, lootId);
2030     }
2031     function multiMintWithLoot(uint[] memory lootIds) public payable nonReentrant {
2032         require(privateSale, "Private sale minting is over");
2033         require(saleIsActive, "Sale must be active to mint");
2034         require((lootersPrice * lootIds.length) <= msg.value, "Ether value sent is not correct");
2035         
2036         for (uint i=0; i<lootIds.length; i++) {
2037             require(lootContract.ownerOf(lootIds[i]) == msg.sender, "Not the owner of this loot");
2038             require(!_exists(lootIds[i]), "One of these tokens has already been minted");
2039             _safeMint(msg.sender, lootIds[i]);
2040         }
2041         
2042     }
2043 
2044     //Public sale minting
2045     function mint(uint lootId) public payable nonReentrant {
2046         require(!privateSale, "Public sale minting not started");
2047         require(saleIsActive, "Sale must be active to mint");
2048         require(publicPrice <= msg.value, "Ether value sent is not correct");
2049         require(lootId > 0 && lootId < 8001, "Token ID invalid");
2050         require(!_exists(lootId), "This token has already been minted");
2051 
2052         _safeMint(msg.sender, lootId);
2053     }
2054     function multiMint(uint[] memory lootIds) public payable nonReentrant {
2055         require(!privateSale, "Public sale minting not started");
2056         require(saleIsActive, "Sale must be active to mint");
2057         require((publicPrice * lootIds.length) <= msg.value, "Ether value sent is not correct");
2058         
2059         for (uint i=0; i<lootIds.length; i++) {
2060             require(lootIds[i] > 0 && lootIds[i] < 8001, "Token ID invalid");
2061             require(!_exists(lootIds[i]), "One of these tokens have already been minted");
2062             _safeMint(msg.sender, lootIds[i]);
2063         }
2064         
2065     }
2066 }