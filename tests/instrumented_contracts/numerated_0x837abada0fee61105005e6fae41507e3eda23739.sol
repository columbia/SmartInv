1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-17
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // GO TO LINE 1904 TO SEE WHERE THE BANANA CONTRACT STARTS
8  
9 
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/introspection/IERC165.sol
35 
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45 
46  * queried by others ({ERC165Checker}).
47  *
48  * For an implementation, see {ERC165}.
49  */
50 interface IERC165 {
51     /**
52      * @dev Returns true if this contract implements the interface defined by
53      * `interfaceId`. See the corresponding
54      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
55      * to learn more about how these ids are created.
56      *
57      * This function call must use less than 30 000 gas.
58      */
59     function supportsInterface(bytes4 interfaceId) external view returns (bool);
60 }
61 
62 
63 
64 
65 pragma solidity >=0.6.2 <0.8.0;
66 
67 
68 /**
69  * @dev Required interface of an ERC721 compliant contract.
70  */
71 interface IERC721 is IERC165 {
72     /**
73      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
76 
77     /**
78      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
79      */
80     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
81 
82     /**
83      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
84      */
85     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
86 
87     /**
88      * @dev Returns the number of tokens in ``owner``'s account.
89      */
90     function balanceOf(address owner) external view returns (uint256 balance);
91 
92     /**
93      * @dev Returns the owner of the `tokenId` token.
94      *
95      * Requirements:
96      *
97      * - `tokenId` must exist.
98      */
99     function ownerOf(uint256 tokenId) external view returns (address owner);
100 
101     /**
102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(address from, address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Transfers `tokenId` token from `from` to `to`.
119      *
120      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must be owned by `from`.
127      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(address from, address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
135      * The approval is cleared when the token is transferred.
136      *
137      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
138      *
139      * Requirements:
140      *
141      * - The caller must own the token or be an approved operator.
142      * - `tokenId` must exist.
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address to, uint256 tokenId) external;
147 
148     /**
149      * @dev Returns the account approved for `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function getApproved(uint256 tokenId) external view returns (address operator);
156 
157     /**
158      * @dev Approve or remove `operator` as an operator for the caller.
159      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
160      *
161      * Requirements:
162      *
163      * - The `operator` cannot be the caller.
164      *
165      * Emits an {ApprovalForAll} event.
166      */
167     function setApprovalForAll(address operator, bool _approved) external;
168 
169     /**
170      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
171      *
172      * See {setApprovalForAll}
173      */
174     function isApprovedForAll(address owner, address operator) external view returns (bool);
175 
176     /**
177       * @dev Safely transfers `tokenId` token from `from` to `to`.
178       *
179       * Requirements:
180       *
181       * - `from` cannot be the zero address.
182       * - `to` cannot be the zero address.
183       * - `tokenId` token must exist and be owned by `from`.
184       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186       *
187       * Emits a {Transfer} event.
188       */
189     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
193 
194 
195 
196 pragma solidity >=0.6.2 <0.8.0;
197 
198 
199 /**
200  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
201  * @dev See https://eips.ethereum.org/EIPS/eip-721
202  */
203 interface IERC721Metadata is IERC721 {
204 
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
222 
223 
224 
225 pragma solidity >=0.6.2 <0.8.0;
226 
227 
228 /**
229  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
230  * @dev See https://eips.ethereum.org/EIPS/eip-721
231  */
232 interface IERC721Enumerable is IERC721 {
233 
234     /**
235      * @dev Returns the total amount of tokens stored by the contract.
236      */
237     function totalSupply() external view returns (uint256);
238 
239     /**
240      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
241      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
242      */
243     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
244 
245     /**
246      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
247      * Use along with {totalSupply} to enumerate all tokens.
248      */
249     function tokenByIndex(uint256 index) external view returns (uint256);
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
253 
254 
255 
256 pragma solidity >=0.6.0 <0.8.0;
257 
258 /**
259  * @title ERC721 token receiver interface
260  * @dev Interface for any contract that wants to support safeTransfers
261  * from ERC721 asset contracts.
262  */
263 interface IERC721Receiver {
264     /**
265      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
266      * by `operator` from `from`, this function is called.
267      *
268      * It must return its Solidity selector to confirm the token transfer.
269      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
270      *
271      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
272      */
273     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
274 }
275 
276 // File: @openzeppelin/contracts/introspection/ERC165.sol
277 
278 
279 
280 pragma solidity >=0.6.0 <0.8.0;
281 
282 
283 /**
284  * @dev Implementation of the {IERC165} interface.
285  *
286  * Contracts may inherit from this and call {_registerInterface} to declare
287  * their support of an interface.
288  */
289 abstract contract ERC165 is IERC165 {
290     /*
291      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
292      */
293     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
294 
295     /**
296      * @dev Mapping of interface ids to whether or not it's supported.
297      */
298     mapping(bytes4 => bool) private _supportedInterfaces;
299 
300     constructor () internal {
301         // Derived contracts need only register support for their own interfaces,
302         // we register support for ERC165 itself here
303         _registerInterface(_INTERFACE_ID_ERC165);
304     }
305 
306     /**
307      * @dev See {IERC165-supportsInterface}.
308      *
309      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312         return _supportedInterfaces[interfaceId];
313     }
314 
315     /**
316      * @dev Registers the contract as an implementer of the interface defined by
317      * `interfaceId`. Support of the actual ERC165 interface is automatic and
318      * registering its interface id is not required.
319      *
320      * See {IERC165-supportsInterface}.
321      *
322      * Requirements:
323      *
324      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
325      */
326     function _registerInterface(bytes4 interfaceId) internal virtual {
327         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
328         _supportedInterfaces[interfaceId] = true;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/math/SafeMath.sol
333 
334 
335 
336 pragma solidity >=0.6.0 <0.8.0;
337 
338 /**
339  * @dev Wrappers over Solidity's arithmetic operations with added overflow
340  * checks.
341  *
342  * Arithmetic operations in Solidity wrap on overflow. This can easily result
343  * in bugs, because programmers usually assume that an overflow raises an
344  * error, which is the standard behavior in high level programming languages.
345  * `SafeMath` restores this intuition by reverting the transaction when an
346  * operation overflows.
347  *
348  * Using this library instead of the unchecked operations eliminates an entire
349  * class of bugs, so it's recommended to use it always.
350  */
351 library SafeMath {
352     /**
353      * @dev Returns the addition of two unsigned integers, with an overflow flag.
354      *
355      * _Available since v3.4._
356      */
357     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
358         uint256 c = a + b;
359         if (c < a) return (false, 0);
360         return (true, c);
361     }
362 
363     /**
364      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
365      *
366      * _Available since v3.4._
367      */
368     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         if (b > a) return (false, 0);
370         return (true, a - b);
371     }
372 
373     /**
374      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
375      *
376      * _Available since v3.4._
377      */
378     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
379         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
380         // benefit is lost if 'b' is also tested.
381         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
382         if (a == 0) return (true, 0);
383         uint256 c = a * b;
384         if (c / a != b) return (false, 0);
385         return (true, c);
386     }
387 
388     /**
389      * @dev Returns the division of two unsigned integers, with a division by zero flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         if (b == 0) return (false, 0);
395         return (true, a / b);
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
400      *
401      * _Available since v3.4._
402      */
403     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404         if (b == 0) return (false, 0);
405         return (true, a % b);
406     }
407 
408     /**
409      * @dev Returns the addition of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Solidity's `+` operator.
413      *
414      * Requirements:
415      *
416      * - Addition cannot overflow.
417      */
418     function add(uint256 a, uint256 b) internal pure returns (uint256) {
419         uint256 c = a + b;
420         require(c >= a, "SafeMath: addition overflow");
421         return c;
422     }
423 
424     /**
425      * @dev Returns the subtraction of two unsigned integers, reverting on
426      * overflow (when the result is negative).
427      *
428      * Counterpart to Solidity's `-` operator.
429      *
430      * Requirements:
431      *
432      * - Subtraction cannot overflow.
433      */
434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435         require(b <= a, "SafeMath: subtraction overflow");
436         return a - b;
437     }
438 
439     /**
440      * @dev Returns the multiplication of two unsigned integers, reverting on
441      * overflow.
442      *
443      * Counterpart to Solidity's `*` operator.
444      *
445      * Requirements:
446      *
447      * - Multiplication cannot overflow.
448      */
449     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
450         if (a == 0) return 0;
451         uint256 c = a * b;
452         require(c / a == b, "SafeMath: multiplication overflow");
453         return c;
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers, reverting on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         require(b > 0, "SafeMath: division by zero");
470         return a / b;
471     }
472 
473     /**
474      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
475      * reverting when dividing by zero.
476      *
477      * Counterpart to Solidity's `%` operator. This function uses a `revert`
478      * opcode (which leaves remaining gas untouched) while Solidity uses an
479      * invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
486         require(b > 0, "SafeMath: modulo by zero");
487         return a % b;
488     }
489 
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
492      * overflow (when the result is negative).
493      *
494      * CAUTION: This function is deprecated because it requires allocating memory for the error
495      * message unnecessarily. For custom revert reasons use {trySub}.
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b <= a, errorMessage);
505         return a - b;
506     }
507 
508     /**
509      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
510      * division by zero. The result is rounded towards zero.
511      *
512      * CAUTION: This function is deprecated because it requires allocating memory for the error
513      * message unnecessarily. For custom revert reasons use {tryDiv}.
514      *
515      * Counterpart to Solidity's `/` operator. Note: this function uses a
516      * `revert` opcode (which leaves remaining gas untouched) while Solidity
517      * uses an invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b > 0, errorMessage);
525         return a / b;
526     }
527 
528     /**
529      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
530      * reverting with custom message when dividing by zero.
531      *
532      * CAUTION: This function is deprecated because it requires allocating memory for the error
533      * message unnecessarily. For custom revert reasons use {tryMod}.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         require(b > 0, errorMessage);
545         return a % b;
546     }
547 }
548 
549 // File: @openzeppelin/contracts/utils/Address.sol
550 
551 
552 
553 pragma solidity >=0.6.2 <0.8.0;
554 
555 /**
556  * @dev Collection of functions related to the address type
557  */
558 library Address {
559     /**
560      * @dev Returns true if `account` is a contract.
561      *
562      * [IMPORTANT]
563      * ====
564      * It is unsafe to assume that an address for which this function returns
565      * false is an externally-owned account (EOA) and not a contract.
566      *
567      * Among others, `isContract` will return false for the following
568      * types of addresses:
569      *
570      *  - an externally-owned account
571      *  - a contract in construction
572      *  - an address where a contract will be created
573      *  - an address where a contract lived, but was destroyed
574      * ====
575      */
576     function isContract(address account) internal view returns (bool) {
577         // This method relies on extcodesize, which returns 0 for contracts in
578         // construction, since the code is only stored at the end of the
579         // constructor execution.
580 
581         uint256 size;
582         // solhint-disable-next-line no-inline-assembly
583         assembly { size := extcodesize(account) }
584         return size > 0;
585     }
586 
587     /**
588      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
589      * `recipient`, forwarding all available gas and reverting on errors.
590      *
591      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
592      * of certain opcodes, possibly making contracts go over the 2300 gas limit
593      * imposed by `transfer`, making them unable to receive funds via
594      * `transfer`. {sendValue} removes this limitation.
595      *
596      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
597      *
598      * IMPORTANT: because control is transferred to `recipient`, care must be
599      * taken to not create reentrancy vulnerabilities. Consider using
600      * {ReentrancyGuard} or the
601      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
602      */
603     function sendValue(address payable recipient, uint256 amount) internal {
604         require(address(this).balance >= amount, "Address: insufficient balance");
605 
606         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
607         (bool success, ) = recipient.call{ value: amount }("");
608         require(success, "Address: unable to send value, recipient may have reverted");
609     }
610 
611     /**
612      * @dev Performs a Solidity function call using a low level `call`. A
613      * plain`call` is an unsafe replacement for a function call: use this
614      * function instead.
615      *
616      * If `target` reverts with a revert reason, it is bubbled up by this
617      * function (like regular Solidity function calls).
618      *
619      * Returns the raw returned data. To convert to the expected return value,
620      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
621      *
622      * Requirements:
623      *
624      * - `target` must be a contract.
625      * - calling `target` with `data` must not revert.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
630       return functionCall(target, data, "Address: low-level call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
635      * `errorMessage` as a fallback revert reason when `target` reverts.
636      *
637      * _Available since v3.1._
638      */
639     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
640         return functionCallWithValue(target, data, 0, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but also transferring `value` wei to `target`.
646      *
647      * Requirements:
648      *
649      * - the calling contract must have an ETH balance of at least `value`.
650      * - the called Solidity function must be `payable`.
651      *
652      * _Available since v3.1._
653      */
654     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
655         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
660      * with `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
665         require(address(this).balance >= value, "Address: insufficient balance for call");
666         require(isContract(target), "Address: call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.call{ value: value }(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a static call.
676      *
677      * _Available since v3.3._
678      */
679     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
680         return functionStaticCall(target, data, "Address: low-level static call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a static call.
686      *
687      * _Available since v3.3._
688      */
689     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
690         require(isContract(target), "Address: static call to non-contract");
691 
692         // solhint-disable-next-line avoid-low-level-calls
693         (bool success, bytes memory returndata) = target.staticcall(data);
694         return _verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
704         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
709      * but performing a delegate call.
710      *
711      * _Available since v3.4._
712      */
713     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
714         require(isContract(target), "Address: delegate call to non-contract");
715 
716         // solhint-disable-next-line avoid-low-level-calls
717         (bool success, bytes memory returndata) = target.delegatecall(data);
718         return _verifyCallResult(success, returndata, errorMessage);
719     }
720 
721     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
722         if (success) {
723             return returndata;
724         } else {
725             // Look for revert reason and bubble it up if present
726             if (returndata.length > 0) {
727                 // The easiest way to bubble the revert reason is using memory via assembly
728 
729                 // solhint-disable-next-line no-inline-assembly
730                 assembly {
731                     let returndata_size := mload(returndata)
732                     revert(add(32, returndata), returndata_size)
733                 }
734             } else {
735                 revert(errorMessage);
736             }
737         }
738     }
739 }
740 
741 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
742 
743 
744 
745 pragma solidity >=0.6.0 <0.8.0;
746 
747 /**
748  * @dev Library for managing
749  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
750  * types.
751  *
752  * Sets have the following properties:
753  *
754  * - Elements are added, removed, and checked for existence in constant time
755  * (O(1)).
756  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
757  *
758  * ```
759  * contract Example {
760  *     // Add the library methods
761  *     using EnumerableSet for EnumerableSet.AddressSet;
762  *
763  *     // Declare a set state variable
764  *     EnumerableSet.AddressSet private mySet;
765  * }
766  * ```
767  *
768  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
769  * and `uint256` (`UintSet`) are supported.
770  */
771 library EnumerableSet {
772     // To implement this library for multiple types with as little code
773     // repetition as possible, we write it in terms of a generic Set type with
774     // bytes32 values.
775     // The Set implementation uses private functions, and user-facing
776     // implementations (such as AddressSet) are just wrappers around the
777     // underlying Set.
778     // This means that we can only create new EnumerableSets for types that fit
779     // in bytes32.
780 
781     struct Set {
782         // Storage of set values
783         bytes32[] _values;
784 
785         // Position of the value in the `values` array, plus 1 because index 0
786         // means a value is not in the set.
787         mapping (bytes32 => uint256) _indexes;
788     }
789 
790     /**
791      * @dev Add a value to a set. O(1).
792      *
793      * Returns true if the value was added to the set, that is if it was not
794      * already present.
795      */
796     function _add(Set storage set, bytes32 value) private returns (bool) {
797         if (!_contains(set, value)) {
798             set._values.push(value);
799             // The value is stored at length-1, but we add 1 to all indexes
800             // and use 0 as a sentinel value
801             set._indexes[value] = set._values.length;
802             return true;
803         } else {
804             return false;
805         }
806     }
807 
808     /**
809      * @dev Removes a value from a set. O(1).
810      *
811      * Returns true if the value was removed from the set, that is if it was
812      * present.
813      */
814     function _remove(Set storage set, bytes32 value) private returns (bool) {
815         // We read and store the value's index to prevent multiple reads from the same storage slot
816         uint256 valueIndex = set._indexes[value];
817 
818         if (valueIndex != 0) { // Equivalent to contains(set, value)
819             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
820             // the array, and then remove the last element (sometimes called as 'swap and pop').
821             // This modifies the order of the array, as noted in {at}.
822 
823             uint256 toDeleteIndex = valueIndex - 1;
824             uint256 lastIndex = set._values.length - 1;
825 
826             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
827             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
828 
829             bytes32 lastvalue = set._values[lastIndex];
830 
831             // Move the last value to the index where the value to delete is
832             set._values[toDeleteIndex] = lastvalue;
833             // Update the index for the moved value
834             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
835 
836             // Delete the slot where the moved value was stored
837             set._values.pop();
838 
839             // Delete the index for the deleted slot
840             delete set._indexes[value];
841 
842             return true;
843         } else {
844             return false;
845         }
846     }
847 
848     /**
849      * @dev Returns true if the value is in the set. O(1).
850      */
851     function _contains(Set storage set, bytes32 value) private view returns (bool) {
852         return set._indexes[value] != 0;
853     }
854 
855     /**
856      * @dev Returns the number of values on the set. O(1).
857      */
858     function _length(Set storage set) private view returns (uint256) {
859         return set._values.length;
860     }
861 
862    /**
863     * @dev Returns the value stored at position `index` in the set. O(1).
864     *
865     * Note that there are no guarantees on the ordering of values inside the
866     * array, and it may change when more values are added or removed.
867     *
868     * Requirements:
869     *
870     * - `index` must be strictly less than {length}.
871     */
872     function _at(Set storage set, uint256 index) private view returns (bytes32) {
873         require(set._values.length > index, "EnumerableSet: index out of bounds");
874         return set._values[index];
875     }
876 
877     // Bytes32Set
878 
879     struct Bytes32Set {
880         Set _inner;
881     }
882 
883     /**
884      * @dev Add a value to a set. O(1).
885      *
886      * Returns true if the value was added to the set, that is if it was not
887      * already present.
888      */
889     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
890         return _add(set._inner, value);
891     }
892 
893     /**
894      * @dev Removes a value from a set. O(1).
895      *
896      * Returns true if the value was removed from the set, that is if it was
897      * present.
898      */
899     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
900         return _remove(set._inner, value);
901     }
902 
903     /**
904      * @dev Returns true if the value is in the set. O(1).
905      */
906     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
907         return _contains(set._inner, value);
908     }
909 
910     /**
911      * @dev Returns the number of values in the set. O(1).
912      */
913     function length(Bytes32Set storage set) internal view returns (uint256) {
914         return _length(set._inner);
915     }
916 
917    /**
918     * @dev Returns the value stored at position `index` in the set. O(1).
919     *
920     * Note that there are no guarantees on the ordering of values inside the
921     * array, and it may change when more values are added or removed.
922     *
923     * Requirements:
924     *
925     * - `index` must be strictly less than {length}.
926     */
927     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
928         return _at(set._inner, index);
929     }
930 
931     // AddressSet
932 
933     struct AddressSet {
934         Set _inner;
935     }
936 
937     /**
938      * @dev Add a value to a set. O(1).
939      *
940      * Returns true if the value was added to the set, that is if it was not
941      * already present.
942      */
943     function add(AddressSet storage set, address value) internal returns (bool) {
944         return _add(set._inner, bytes32(uint256(uint160(value))));
945     }
946 
947     /**
948      * @dev Removes a value from a set. O(1).
949      *
950      * Returns true if the value was removed from the set, that is if it was
951      * present.
952      */
953     function remove(AddressSet storage set, address value) internal returns (bool) {
954         return _remove(set._inner, bytes32(uint256(uint160(value))));
955     }
956 
957     /**
958      * @dev Returns true if the value is in the set. O(1).
959      */
960     function contains(AddressSet storage set, address value) internal view returns (bool) {
961         return _contains(set._inner, bytes32(uint256(uint160(value))));
962     }
963 
964     /**
965      * @dev Returns the number of values in the set. O(1).
966      */
967     function length(AddressSet storage set) internal view returns (uint256) {
968         return _length(set._inner);
969     }
970 
971    /**
972     * @dev Returns the value stored at position `index` in the set. O(1).
973     *
974     * Note that there are no guarantees on the ordering of values inside the
975     * array, and it may change when more values are added or removed.
976     *
977     * Requirements:
978     *
979     * - `index` must be strictly less than {length}.
980     */
981     function at(AddressSet storage set, uint256 index) internal view returns (address) {
982         return address(uint160(uint256(_at(set._inner, index))));
983     }
984 
985 
986     // UintSet
987 
988     struct UintSet {
989         Set _inner;
990     }
991 
992     /**
993      * @dev Add a value to a set. O(1).
994      *
995      * Returns true if the value was added to the set, that is if it was not
996      * already present.
997      */
998     function add(UintSet storage set, uint256 value) internal returns (bool) {
999         return _add(set._inner, bytes32(value));
1000     }
1001 
1002     /**
1003      * @dev Removes a value from a set. O(1).
1004      *
1005      * Returns true if the value was removed from the set, that is if it was
1006      * present.
1007      */
1008     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1009         return _remove(set._inner, bytes32(value));
1010     }
1011 
1012     /**
1013      * @dev Returns true if the value is in the set. O(1).
1014      */
1015     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1016         return _contains(set._inner, bytes32(value));
1017     }
1018 
1019     /**
1020      * @dev Returns the number of values on the set. O(1).
1021      */
1022     function length(UintSet storage set) internal view returns (uint256) {
1023         return _length(set._inner);
1024     }
1025 
1026    /**
1027     * @dev Returns the value stored at position `index` in the set. O(1).
1028     *
1029     * Note that there are no guarantees on the ordering of values inside the
1030     * array, and it may change when more values are added or removed.
1031     *
1032     * Requirements:
1033     *
1034     * - `index` must be strictly less than {length}.
1035     */
1036     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1037         return uint256(_at(set._inner, index));
1038     }
1039 }
1040 
1041 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1042 
1043 
1044 
1045 pragma solidity >=0.6.0 <0.8.0;
1046 
1047 /**
1048  * @dev Library for managing an enumerable variant of Solidity's
1049  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1050  * type.
1051  *
1052  * Maps have the following properties:
1053  *
1054  * - Entries are added, removed, and checked for existence in constant time
1055  * (O(1)).
1056  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1057  *
1058  * ```
1059  * contract Example {
1060  *     // Add the library methods
1061  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1062  *
1063  *     // Declare a set state variable
1064  *     EnumerableMap.UintToAddressMap private myMap;
1065  * }
1066  * ```
1067  *
1068  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1069  * supported.
1070  */
1071 library EnumerableMap {
1072     // To implement this library for multiple types with as little code
1073     // repetition as possible, we write it in terms of a generic Map type with
1074     // bytes32 keys and values.
1075     // The Map implementation uses private functions, and user-facing
1076     // implementations (such as Uint256ToAddressMap) are just wrappers around
1077     // the underlying Map.
1078     // This means that we can only create new EnumerableMaps for types that fit
1079     // in bytes32.
1080 
1081     struct MapEntry {
1082         bytes32 _key;
1083         bytes32 _value;
1084     }
1085 
1086     struct Map {
1087         // Storage of map keys and values
1088         MapEntry[] _entries;
1089 
1090         // Position of the entry defined by a key in the `entries` array, plus 1
1091         // because index 0 means a key is not in the map.
1092         mapping (bytes32 => uint256) _indexes;
1093     }
1094 
1095     /**
1096      * @dev Adds a key-value pair to a map, or updates the value for an existing
1097      * key. O(1).
1098      *
1099      * Returns true if the key was added to the map, that is if it was not
1100      * already present.
1101      */
1102     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1103         // We read and store the key's index to prevent multiple reads from the same storage slot
1104         uint256 keyIndex = map._indexes[key];
1105 
1106         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1107             map._entries.push(MapEntry({ _key: key, _value: value }));
1108             // The entry is stored at length-1, but we add 1 to all indexes
1109             // and use 0 as a sentinel value
1110             map._indexes[key] = map._entries.length;
1111             return true;
1112         } else {
1113             map._entries[keyIndex - 1]._value = value;
1114             return false;
1115         }
1116     }
1117 
1118     /**
1119      * @dev Removes a key-value pair from a map. O(1).
1120      *
1121      * Returns true if the key was removed from the map, that is if it was present.
1122      */
1123     function _remove(Map storage map, bytes32 key) private returns (bool) {
1124         // We read and store the key's index to prevent multiple reads from the same storage slot
1125         uint256 keyIndex = map._indexes[key];
1126 
1127         if (keyIndex != 0) { // Equivalent to contains(map, key)
1128             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1129             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1130             // This modifies the order of the array, as noted in {at}.
1131 
1132             uint256 toDeleteIndex = keyIndex - 1;
1133             uint256 lastIndex = map._entries.length - 1;
1134 
1135             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1136             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1137 
1138             MapEntry storage lastEntry = map._entries[lastIndex];
1139 
1140             // Move the last entry to the index where the entry to delete is
1141             map._entries[toDeleteIndex] = lastEntry;
1142             // Update the index for the moved entry
1143             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1144 
1145             // Delete the slot where the moved entry was stored
1146             map._entries.pop();
1147 
1148             // Delete the index for the deleted slot
1149             delete map._indexes[key];
1150 
1151             return true;
1152         } else {
1153             return false;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns true if the key is in the map. O(1).
1159      */
1160     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1161         return map._indexes[key] != 0;
1162     }
1163 
1164     /**
1165      * @dev Returns the number of key-value pairs in the map. O(1).
1166      */
1167     function _length(Map storage map) private view returns (uint256) {
1168         return map._entries.length;
1169     }
1170 
1171    /**
1172     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1173     *
1174     * Note that there are no guarantees on the ordering of entries inside the
1175     * array, and it may change when more entries are added or removed.
1176     *
1177     * Requirements:
1178     *
1179     * - `index` must be strictly less than {length}.
1180     */
1181     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1182         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1183 
1184         MapEntry storage entry = map._entries[index];
1185         return (entry._key, entry._value);
1186     }
1187 
1188     /**
1189      * @dev Tries to returns the value associated with `key`.  O(1).
1190      * Does not revert if `key` is not in the map.
1191      */
1192     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1193         uint256 keyIndex = map._indexes[key];
1194         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1195         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1196     }
1197 
1198     /**
1199      * @dev Returns the value associated with `key`.  O(1).
1200      *
1201      * Requirements:
1202      *
1203      * - `key` must be in the map.
1204      */
1205     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1206         uint256 keyIndex = map._indexes[key];
1207         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1208         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1209     }
1210 
1211     /**
1212      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1213      *
1214      * CAUTION: This function is deprecated because it requires allocating memory for the error
1215      * message unnecessarily. For custom revert reasons use {_tryGet}.
1216      */
1217     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1218         uint256 keyIndex = map._indexes[key];
1219         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1220         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1221     }
1222 
1223     // UintToAddressMap
1224 
1225     struct UintToAddressMap {
1226         Map _inner;
1227     }
1228 
1229     /**
1230      * @dev Adds a key-value pair to a map, or updates the value for an existing
1231      * key. O(1).
1232      *
1233      * Returns true if the key was added to the map, that is if it was not
1234      * already present.
1235      */
1236     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1237         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1238     }
1239 
1240     /**
1241      * @dev Removes a value from a set. O(1).
1242      *
1243      * Returns true if the key was removed from the map, that is if it was present.
1244      */
1245     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1246         return _remove(map._inner, bytes32(key));
1247     }
1248 
1249     /**
1250      * @dev Returns true if the key is in the map. O(1).
1251      */
1252     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1253         return _contains(map._inner, bytes32(key));
1254     }
1255 
1256     /**
1257      * @dev Returns the number of elements in the map. O(1).
1258      */
1259     function length(UintToAddressMap storage map) internal view returns (uint256) {
1260         return _length(map._inner);
1261     }
1262 
1263    /**
1264     * @dev Returns the element stored at position `index` in the set. O(1).
1265     * Note that there are no guarantees on the ordering of values inside the
1266     * array, and it may change when more values are added or removed.
1267     *
1268     * Requirements:
1269     *
1270     * - `index` must be strictly less than {length}.
1271     */
1272     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1273         (bytes32 key, bytes32 value) = _at(map._inner, index);
1274         return (uint256(key), address(uint160(uint256(value))));
1275     }
1276 
1277     /**
1278      * @dev Tries to returns the value associated with `key`.  O(1).
1279      * Does not revert if `key` is not in the map.
1280      *
1281      * _Available since v3.4._
1282      */
1283     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1284         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1285         return (success, address(uint160(uint256(value))));
1286     }
1287 
1288     /**
1289      * @dev Returns the value associated with `key`.  O(1).
1290      *
1291      * Requirements:
1292      *
1293      * - `key` must be in the map.
1294      */
1295     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1296         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1297     }
1298 
1299     /**
1300      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1301      *
1302      * CAUTION: This function is deprecated because it requires allocating memory for the error
1303      * message unnecessarily. For custom revert reasons use {tryGet}.
1304      */
1305     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1306         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1307     }
1308 }
1309 
1310 // File: @openzeppelin/contracts/utils/Strings.sol
1311 
1312 
1313 
1314 pragma solidity >=0.6.0 <0.8.0;
1315 
1316 /**
1317  * @dev String operations.
1318  */
1319 library Strings {
1320     /**
1321      * @dev Converts a `uint256` to its ASCII `string` representation.
1322      */
1323     function toString(uint256 value) internal pure returns (string memory) {
1324         // Inspired by OraclizeAPI's implementation - MIT licence
1325         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1326 
1327         if (value == 0) {
1328             return "0";
1329         }
1330         uint256 temp = value;
1331         uint256 digits;
1332         while (temp != 0) {
1333             digits++;
1334             temp /= 10;
1335         }
1336         bytes memory buffer = new bytes(digits);
1337         uint256 index = digits - 1;
1338         temp = value;
1339         while (temp != 0) {
1340             buffer[index--] = bytes1(uint8(48 + temp % 10));
1341             temp /= 10;
1342         }
1343         return string(buffer);
1344     }
1345 }
1346 
1347 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1348 
1349 
1350 
1351 pragma solidity >=0.6.0 <0.8.0;
1352 
1353 /**
1354  * @title ERC721 Non-Fungible Token Standard basic implementation
1355  * @dev see https://eips.ethereum.org/EIPS/eip-721
1356  */
1357  
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
1430     constructor (string memory name_, string memory symbol_) public {
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
1821 pragma solidity >=0.6.0 <0.8.0;
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
1843     constructor () internal {
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
1887 
1888 //hero
1889 
1890 pragma solidity ^0.7.0;
1891 pragma abicoder v2;
1892 
1893 abstract contract AdvText {
1894   function ownerOf(uint256 tokenId) public virtual view returns (address);
1895   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1896   function balanceOf(address owner) external virtual view returns (uint256 balance);
1897   function safeTransferFrom(address from, address to, uint256 tokenId) external virtual;
1898   function approve(address to, uint256 tokenId) external virtual; 
1899 }
1900 
1901 
1902 abstract contract AdvWeapon {
1903   function ownerOf(uint256 tokenId) public virtual view returns (address);
1904   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1905   function balanceOf(address owner) external virtual view returns (uint256 balance);
1906 }
1907 
1908 
1909 abstract contract AdvLegion {
1910   function ownerOf(uint256 tokenId) public virtual view returns (address);
1911   function safeTransferFrom(address from, address to, uint256 tokenId) external virtual;
1912   function approve(address to, uint256 tokenId) external virtual;   
1913 }
1914 
1915 interface AdventurersWizard {
1916     function composePFP(address owner, uint256 PFPtokenId, uint256 LegiontokenId) external returns (bool);
1917 } 
1918 
1919 contract theAdventurerscontract is ERC721, Ownable {
1920     using SafeMath for uint256;
1921 
1922     string public hero_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN
1923 
1924     uint256 public  heroPrice = 0; // 0.00 ETH
1925 
1926     uint public constant maxheroPurchase = 20;
1927     uint public maxReroll = 3;
1928     uint256 public  MAX_heroS = 5000;
1929 
1930     bool public saleIsActive = false;
1931     bool public composeIsActive = false;
1932     bool public MintSaleIsActive = false;
1933     
1934     address public  WeaponContractAddress;
1935     address public  TextContractAddress;   
1936     address public  WizardContractAddress;     
1937     address public  LegionContractAddress;      
1938     address private _burnaddress = 0x000000000000000000000000000000000000dEaD;
1939     mapping(uint => uint256) public Rerolltimes;
1940       
1941     mapping(uint => uint256) public minternaltokenid;
1942     mapping(address => bool) minted;
1943 
1944     
1945     // Reserve 300 hero for team - Giveaways/Prizes etc
1946     uint public heroReserve = 300;
1947 
1948     event heroInternaltokenidChange(address _by, uint _tokenId,  uint256 _internaltokenID);
1949     
1950     modifier mintOnlyOnce() {
1951         require(!minted[_msgSender()], 'Can only mint once');
1952         minted[_msgSender()] = true;
1953         _;
1954     }
1955     
1956     constructor() ERC721("The Adventurers Avatar", "The Adventurers Avatar") { }
1957     
1958     function withdraw() public onlyOwner {
1959         uint balance = address(this).balance;
1960         msg.sender.transfer(balance);
1961     }
1962     
1963     function reserveheros(address _to, uint256 _reserveAmount) public onlyOwner {        
1964        require(_reserveAmount > 0 && _reserveAmount <= heroReserve, "Not enough reserve lef");
1965 
1966        for (uint i = 0; i < _reserveAmount; i++) {
1967             for (uint k = 0; k < MAX_heroS; k++) {
1968             uint mintIndex = k;
1969             if (!_exists(mintIndex) && (mintIndex <MAX_heroS)) {
1970             _safeMint(_to, mintIndex);
1971             break;
1972             }
1973         }
1974         }
1975         heroReserve = heroReserve.sub(_reserveAmount);
1976     }
1977     
1978     function setMintPrice(uint price) external onlyOwner {
1979         heroPrice = price;
1980     }
1981 
1982     function setMaxRerolltimes(uint rerolltimes) external onlyOwner {
1983         maxReroll = rerolltimes;
1984     }
1985     
1986     function setMaxHeros(uint maxhero) external onlyOwner {
1987         MAX_heroS = maxhero;
1988     }
1989 
1990     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1991         hero_PROVENANCE = provenanceHash;
1992     }
1993 
1994     function setBaseURI(string memory baseURI) public onlyOwner {
1995         _setBaseURI(baseURI);
1996     }
1997 
1998 
1999     function flipSaleState() public onlyOwner {
2000         saleIsActive = !saleIsActive;
2001     }
2002     
2003     function flipMintSaleState() public onlyOwner {
2004         MintSaleIsActive = !MintSaleIsActive;
2005     }
2006 
2007     function flipComposeState() public onlyOwner {
2008         composeIsActive = !composeIsActive;
2009     }
2010     
2011     
2012     function claim() public mintOnlyOnce {
2013         require(MintSaleIsActive, "Sale must be active to mint hero");
2014         require(totalSupply().add(1) <= MAX_heroS, 'Purchase would exceed max supply of heros');
2015         
2016        for (uint i = 0; i < MAX_heroS; i++) {
2017         uint mintIndex = i;
2018         if (!_exists(mintIndex) && (mintIndex <MAX_heroS)) {
2019            _safeMint(msg.sender, mintIndex);
2020            return;
2021         }
2022         }
2023     }
2024     
2025     function mintheros(uint numberOfTokens) public payable {
2026     require(MintSaleIsActive, "Sale must be active to mint hero");
2027     require(numberOfTokens > 0 && numberOfTokens <= maxheroPurchase, "Can only mint 20 tokens at a time");
2028     require(totalSupply().add(numberOfTokens) <= MAX_heroS, "Purchase would exceed max supply of heros");
2029     require(msg.value >= heroPrice.mul(numberOfTokens), "Ether value sent is not correct");
2030 
2031     for (uint i = 0; i < numberOfTokens; i++) {
2032         for (uint k = 0; k < MAX_heroS; k++) {
2033             uint mintIndex = k;
2034             if (!_exists(mintIndex) && (mintIndex<MAX_heroS)) {
2035             _safeMint(msg.sender, mintIndex);
2036             break;
2037             }
2038         }
2039     }
2040   }
2041   
2042     function MintPFPbyText(uint256 tokenId) public {
2043     require(saleIsActive, "Sale must be active to mint a PFP");
2044     require(totalSupply() < MAX_heroS, "Purchase would exceed max supply of PFP");
2045     require(tokenId < MAX_heroS, "Requested tokenId exceeds upper bound");
2046     
2047 
2048     AdvText advText = AdvText(TextContractAddress);
2049     require(advText.ownerOf(tokenId) == msg.sender, "Must own the Text for requested tokenId to mint a PFP");
2050     require(!_exists(tokenId), "Token already minted");
2051     _safeMint(msg.sender, tokenId);
2052     
2053      advText.approve(_burnaddress, tokenId );
2054     advText.safeTransferFrom( advText.ownerOf(tokenId),_burnaddress, tokenId );
2055     
2056   }
2057   
2058    function composePFP(address owner, uint256 WeapontokenId, uint256 PFPtokenId, uint256 newPFPtokenId) public returns (bool) {
2059         require(composeIsActive, "Compose is not active at the moment");
2060         require(ERC721.ownerOf(PFPtokenId) == owner, "You do not have this PFP");
2061         AdvWeapon advWeapon = AdvWeapon(WeaponContractAddress);
2062             
2063         require(advWeapon.ownerOf(WeapontokenId) == owner, "You do not have this weapon");
2064 
2065         minternaltokenid[PFPtokenId] = newPFPtokenId;
2066         emit heroInternaltokenidChange(msg.sender,  PFPtokenId, newPFPtokenId);
2067         
2068         return true;
2069     }
2070 
2071   
2072    function composeWizard(uint256 PFPtokenId, uint256 LegiontokenId) public  {
2073         require(composeIsActive, "Not allowed");
2074         require(WizardContractAddress != address(0), "Wizard contract address need be set");
2075         require(ERC721.ownerOf(PFPtokenId) == msg.sender, "You do not have this PFP");
2076         
2077          _burn(PFPtokenId);
2078 
2079        AdvLegion advLegion = AdvLegion(LegionContractAddress);
2080        require(advLegion.ownerOf(LegiontokenId) == msg.sender, "Must own the Legion for requested tokenId to mint a Wizard");
2081     
2082        advLegion.approve(_burnaddress, LegiontokenId );
2083        advLegion.safeTransferFrom( advLegion.ownerOf(LegiontokenId),_burnaddress, LegiontokenId );
2084                 
2085         AdventurersWizard wizard = AdventurersWizard(WizardContractAddress);
2086         bool result = wizard.composePFP(msg.sender, PFPtokenId, LegiontokenId);
2087         require(result, "Wizard compose failed");
2088     }
2089 
2090     function setLegionContractAddress(address contractAddress) public onlyOwner {
2091         LegionContractAddress = contractAddress;
2092     }
2093     
2094     function setWeaponContractAddress(address contractAddress) public onlyOwner {
2095         WeaponContractAddress = contractAddress;
2096     }
2097     
2098     function seWizardContractAddress(address contractAddress) public onlyOwner {
2099         WizardContractAddress = contractAddress;
2100     }
2101     
2102     function setTextContractAddress(address contractAddress) public onlyOwner {
2103        TextContractAddress = contractAddress;
2104     }
2105     
2106   function getinternaltokenID(uint _tokenId) public  view returns( uint256  ){
2107     require(_tokenId <= totalSupply(), "ID would exceed max supply of heros");
2108     return minternaltokenid[_tokenId];
2109    }
2110     
2111     function getRerolltimes(uint _tokenId) public  view returns( uint256  ){
2112     require(_tokenId <= totalSupply(), "ID would exceed max supply of heros");
2113     return Rerolltimes[_tokenId];
2114   }    
2115   
2116     function reroll(uint _tokenId, uint256 _internaltokenID) public payable {
2117     require(saleIsActive, "Sale must be active to reroll");
2118     require(_tokenId <= totalSupply(), "Purchase would exceed max supply of heros");
2119     require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this hero!");
2120     require(Rerolltimes[_tokenId] < maxReroll, "Hey, this token has more than 3 reroll!");
2121     require(msg.value >= heroPrice.mul(1), "Ether value sent is not correct");
2122     
2123     Rerolltimes[_tokenId] = Rerolltimes[_tokenId] + 1;
2124     minternaltokenid[_tokenId] = _internaltokenID;
2125     emit heroInternaltokenidChange(msg.sender, _tokenId, _internaltokenID);
2126   }
2127   
2128     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2129         uint256 tokenCount = balanceOf(_owner);
2130         if (tokenCount == 0) {
2131             // Return an empty array
2132             return new uint256[](0);
2133         } else {
2134             uint256[] memory result = new uint256[](tokenCount);
2135             uint256 index;
2136             for (index = 0; index < tokenCount; index++) {
2137                 result[index] = tokenOfOwnerByIndex(_owner, index);
2138             }
2139             return result;
2140         }
2141     }
2142 
2143 }