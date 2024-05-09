1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-31
3 */
4 
5 // https://opensea.io/collection/loot-familiars
6 
7 // File: @openzeppelin/contracts/utils/Context.sol
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.7.6;
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
37 pragma solidity 0.7.6;
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
64 pragma solidity 0.7.6;
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
195 pragma solidity 0.7.6;
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
224 pragma solidity 0.7.6;
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
255 pragma solidity 0.7.6;
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
279 pragma solidity 0.7.6;
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
335 pragma solidity 0.7.6;
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
552 pragma solidity 0.7.6;
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
744 pragma solidity 0.7.6;
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
1044 pragma solidity 0.7.6;
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
1313 pragma solidity 0.7.6;
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
1350 pragma solidity 0.7.6;
1351 
1352 
1353 
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
1822 pragma solidity 0.7.6;
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
1890 /**
1891  * @dev Contract module that helps prevent reentrant calls to a function.
1892  *
1893  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1894  * available, which can be applied to functions to make sure there are no nested
1895  * (reentrant) calls to them.
1896  *
1897  * Note that because there is a single `nonReentrant` guard, functions marked as
1898  * `nonReentrant` may not call one another. This can be worked around by making
1899  * those functions `private`, and then adding `external` `nonReentrant` entry
1900  * points to them.
1901  *
1902  * TIP: If you would like to learn more about reentrancy and alternative ways
1903  * to protect against it, check out our blog post
1904  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1905  */
1906 abstract contract ReentrancyGuard {
1907     // Booleans are more expensive than uint256 or any type that takes up a full
1908     // word because each write operation emits an extra SLOAD to first read the
1909     // slot's contents, replace the bits taken up by the boolean, and then write
1910     // back. This is the compiler's defense against contract upgrades and
1911     // pointer aliasing, and it cannot be disabled.
1912 
1913     // The values being non-zero value makes deployment a bit more expensive,
1914     // but in exchange the refund on every call to nonReentrant will be lower in
1915     // amount. Since refunds are capped to a percentage of the total
1916     // transaction's gas, it is best to keep them low in cases like this one, to
1917     // increase the likelihood of the full refund coming into effect.
1918     uint256 private constant _NOT_ENTERED = 1;
1919     uint256 private constant _ENTERED = 2;
1920 
1921     uint256 private _status;
1922 
1923     constructor() {
1924         _status = _NOT_ENTERED;
1925     }
1926 
1927     /**
1928      * @dev Prevents a contract from calling itself, directly or indirectly.
1929      * Calling a `nonReentrant` function from another `nonReentrant`
1930      * function is not supported. It is possible to prevent this from happening
1931      * by making the `nonReentrant` function external, and make it call a
1932      * `private` function that does the actual work.
1933      */
1934     modifier nonReentrant() {
1935         // On the first call to nonReentrant, _notEntered will be true
1936         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1937 
1938         // Any calls to nonReentrant after this point will fail
1939         _status = _ENTERED;
1940 
1941         _;
1942 
1943         // By storing the original value once again, a refund is triggered (see
1944         // https://eips.ethereum.org/EIPS/eip-2200)
1945         _status = _NOT_ENTERED;
1946     }
1947 }
1948 
1949 pragma solidity ^0.7.6;
1950 
1951 
1952 interface ERC721Interface {
1953     function ownerOf(uint256 tokenId) external view returns (address owner);
1954     function balanceOf(address owner) external view returns (uint256 balance);
1955     function tokenOfOwnerByIndex(address owner, uint256 index)
1956         external
1957         view
1958         returns (uint256 tokenId);
1959 }
1960 
1961 
1962 /**
1963  * @title Familiars (For Adventurers) contract. All revenue from Familiars will
1964  * be used to purchase floor Loots, which will then be fractionalized to Familiars
1965  * owners.
1966  */
1967 contract LootFamiliars is ERC721, ReentrancyGuard, Ownable {
1968     using SafeMath for uint256;
1969 
1970     uint256 public publicPrice = 200000000000000000; //0.2 ETH
1971     bool public saleIsActive = true;
1972 
1973     //Loot Contract
1974     address public immutable V1_FAMILIAR_ADDRESS;
1975     ERC721Interface immutable v1FamiliarContract;
1976 
1977     constructor(address v1Address) ERC721("Familiars (for Adventurers)", "LootFamiliars") {
1978       V1_FAMILIAR_ADDRESS = v1Address;
1979       v1FamiliarContract = ERC721Interface(v1Address);
1980     }
1981 
1982     function withdraw() public onlyOwner {
1983         uint balance = address(this).balance;
1984         msg.sender.transfer(balance);
1985     }
1986 
1987     function flipSaleState() public onlyOwner {
1988         saleIsActive = !saleIsActive;
1989     }
1990 
1991     function setPublicPrice(uint256 newPrice) public onlyOwner {
1992         publicPrice = newPrice;
1993     }
1994 
1995     function setBaseURI(string memory baseURI) public onlyOwner {
1996         _setBaseURI(baseURI);
1997     }
1998     
1999     // Anyone can airdrop V1 familiars to their respective owner, which are reserved to them
2000     function airdropWithV1Familiars(uint256[] memory familiarIds) external nonReentrant {
2001         require(saleIsActive, "Sale must be active to mint");
2002         for (uint256 i=0; i<familiarIds.length; i++) {
2003             require(!_exists(familiarIds[i]),"Familiar has already been minted");
2004             // note: ownerOf() will revert if non-existent
2005             address lootOwner = v1FamiliarContract.ownerOf(familiarIds[i]);
2006             _safeMint(lootOwner, familiarIds[i]);
2007         }
2008     }
2009 
2010     //Public sale minting where all the revenue will be used to buy floor loots and fractionalize them
2011     function mint(uint256 familiarId) external payable nonReentrant {
2012         require(publicPrice <= msg.value, "Ether amount sent is insufficient");
2013         _mint(familiarId);
2014     }
2015     
2016     //Public sale minting where all the revenue will be used to buy floor loots and fractionalize them
2017     function multiMint(uint256[] memory familiarIds) external payable nonReentrant {
2018         require((publicPrice * familiarIds.length) <= msg.value, "Ether amount sent is insufficient");
2019         for (uint256 i=0; i<familiarIds.length; i++) {
2020             _mint(familiarIds[i]);
2021         }
2022     }
2023 
2024     function _mint(uint256 familiarId) private {
2025       require(saleIsActive, "Sale must be active to mint");
2026       require(familiarId > 0 && familiarId < 8001, "Token ID invalid");
2027       require(!_exists(familiarId), "Familiar has already been minted");
2028 
2029       // Check if tokenID is reserved for V1 familiar 
2030       try v1FamiliarContract.ownerOf(familiarId) {
2031         revert('Familiar is reserved for V1 familiar owner');
2032       } catch {
2033         // If ownerOf() throws, then we know this familiar was not minted on V1
2034         // Mint familiar to msg.sender since not reserved for V1 familiar
2035         _safeMint(msg.sender, familiarId);
2036       }
2037     }
2038 
2039     // To comply with future loot registry
2040     function lootExpansionTokenUri(uint256 tokenId) public view returns (string memory) {
2041       return tokenURI(tokenId);
2042     }
2043 
2044     // Check if you can claim a given familiar
2045     function isClaimable(uint256 familiarId) public view returns (bool claimable) {
2046       if (_exists(familiarId) ) {
2047         // Familiar was already minted on V2
2048         return false;
2049       } else {
2050         try v1FamiliarContract.ownerOf(familiarId) {
2051           // If ownerOf() returns a valid value, this means familiar was minted on V1
2052           return false;
2053         } catch {
2054           // If ownerOf() throws, then we know this familiar was not minted on V1 either
2055           return true;
2056         }
2057       }
2058     }
2059 
2060     // Will return ID of familiars that can still be claimed within the range of _startingID (inclusive) and _endID (exclusive)
2061     function findClaimable(uint256 _startingID, uint256 _endID) external view returns (uint256[] memory) {
2062       require(_startingID <= _endID, "Invalid range");
2063       uint256 n_ids = _endID - _startingID;
2064       uint256[] memory claimableIDs = new uint256[](n_ids);
2065       for (uint256 i = 0; i < n_ids; i++) {
2066         uint256 id = _startingID + i;
2067         if (isClaimable(id)) {
2068           claimableIDs[i] = id;
2069         }
2070       }
2071       return claimableIDs;
2072     }
2073 }