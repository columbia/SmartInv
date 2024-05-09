1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 //          ____                           __                 __
6 //         / __ \_________  ________  ____/ /_  ___________ _/ /
7 //        / /_/ / ___/ __ \/ ___/ _ \/ __  / / / / ___/ __ `/ / 
8 //       / ____/ /  / /_/ / /__/  __/ /_/ / /_/ / /  / /_/ / /  
9 //      /_/   /_/   \____/\___/\___/\__,_/\__,_/_/   \__,_/_/   
10 //         _____
11 //        / ___/____  ____ _________ 
12 //        \__ \/ __ \/ __ `/ ___/ _ \
13 //       ___/ / /_/ / /_/ / /__/  __/
14 //      /____/ .___/\__,_/\___/\___/ 
15 //          /_/                      
16 //         ______                     _     
17 //        / ____/__  ____  ___  _____(_)____
18 //       / / __/ _ \/ __ \/ _ \/ ___/ / ___/
19 //      / /_/ /  __/ / / /  __(__  ) (__  ) 
20 //      \____/\___/_/ /_/\___/____/_/____/  
21 //
22                                     
23 pragma solidity >=0.6.0 <0.8.0;
24 
25 /*
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with GSN meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address payable) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/introspection/IERC165.sol
47 pragma solidity >=0.6.0 <0.8.0;
48 
49 /**
50  * @dev Interface of the ERC165 standard, as defined in the
51  * https://eips.ethereum.org/EIPS/eip-165[EIP].
52  *
53  * Implementers can declare support of contract interfaces, which can then be
54  * queried by others ({ERC165Checker}).
55  *
56  * For an implementation, see {ERC165}.
57  */
58 interface IERC165 {
59     /**
60      * @dev Returns true if this contract implements the interface defined by
61      * `interfaceId`. See the corresponding
62      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
63      * to learn more about how these ids are created.
64      *
65      * This function call must use less than 30 000 gas.
66      */
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
71 pragma solidity >=0.6.2 <0.8.0;
72 
73 /**
74  * @dev Required interface of an ERC721 compliant contract.
75  */
76 interface IERC721 is IERC165 {
77     /**
78      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
81 
82     /**
83      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
84      */
85     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
86 
87     /**
88      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
89      */
90     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
91 
92     /**
93      * @dev Returns the number of tokens in ``owner``'s account.
94      */
95     function balanceOf(address owner) external view returns (uint256 balance);
96 
97     /**
98      * @dev Returns the owner of the `tokenId` token.
99      *
100      * Requirements:
101      *
102      * - `tokenId` must exist.
103      */
104     function ownerOf(uint256 tokenId) external view returns (address owner);
105 
106     /**
107      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
108      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must exist and be owned by `from`.
115      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
117      *
118      * Emits a {Transfer} event.
119      */
120     function safeTransferFrom(address from, address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(address from, address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId) external view returns (address operator);
161 
162     /**
163      * @dev Approve or remove `operator` as an operator for the caller.
164      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
165      *
166      * Requirements:
167      *
168      * - The `operator` cannot be the caller.
169      *
170      * Emits an {ApprovalForAll} event.
171      */
172     function setApprovalForAll(address operator, bool _approved) external;
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 
181     /**
182       * @dev Safely transfers `tokenId` token from `from` to `to`.
183       *
184       * Requirements:
185       *
186       * - `from` cannot be the zero address.
187       * - `to` cannot be the zero address.
188       * - `tokenId` token must exist and be owned by `from`.
189       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191       *
192       * Emits a {Transfer} event.
193       */
194     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
198 pragma solidity >=0.6.2 <0.8.0;
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205 
206     /**
207      * @dev Returns the token collection name.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the token collection symbol.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
218      */
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
223 pragma solidity >=0.6.2 <0.8.0;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Enumerable is IERC721 {
230 
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
239      */
240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
250 pragma solidity >=0.6.0 <0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/introspection/ERC165.sol
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 /**
274  * @dev Implementation of the {IERC165} interface.
275  *
276  * Contracts may inherit from this and call {_registerInterface} to declare
277  * their support of an interface.
278  */
279 abstract contract ERC165 is IERC165 {
280     /*
281      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
282      */
283     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
284 
285     /**
286      * @dev Mapping of interface ids to whether or not it's supported.
287      */
288     mapping(bytes4 => bool) private _supportedInterfaces;
289 
290     constructor () internal {
291         // Derived contracts need only register support for their own interfaces,
292         // we register support for ERC165 itself here
293         _registerInterface(_INTERFACE_ID_ERC165);
294     }
295 
296     /**
297      * @dev See {IERC165-supportsInterface}.
298      *
299      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302         return _supportedInterfaces[interfaceId];
303     }
304 
305     /**
306      * @dev Registers the contract as an implementer of the interface defined by
307      * `interfaceId`. Support of the actual ERC165 interface is automatic and
308      * registering its interface id is not required.
309      *
310      * See {IERC165-supportsInterface}.
311      *
312      * Requirements:
313      *
314      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
315      */
316     function _registerInterface(bytes4 interfaceId) internal virtual {
317         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
318         _supportedInterfaces[interfaceId] = true;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/math/SafeMath.sol
323 pragma solidity >=0.6.0 <0.8.0;
324 
325 /**
326  * @dev Wrappers over Solidity's arithmetic operations with added overflow
327  * checks.
328  *
329  * Arithmetic operations in Solidity wrap on overflow. This can easily result
330  * in bugs, because programmers usually assume that an overflow raises an
331  * error, which is the standard behavior in high level programming languages.
332  * `SafeMath` restores this intuition by reverting the transaction when an
333  * operation overflows.
334  *
335  * Using this library instead of the unchecked operations eliminates an entire
336  * class of bugs, so it's recommended to use it always.
337  */
338 library SafeMath {
339     /**
340      * @dev Returns the addition of two unsigned integers, with an overflow flag.
341      *
342      * _Available since v3.4._
343      */
344     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
345         uint256 c = a + b;
346         if (c < a) return (false, 0);
347         return (true, c);
348     }
349 
350     /**
351      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
352      *
353      * _Available since v3.4._
354      */
355     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b > a) return (false, 0);
357         return (true, a - b);
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
367         // benefit is lost if 'b' is also tested.
368         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
369         if (a == 0) return (true, 0);
370         uint256 c = a * b;
371         if (c / a != b) return (false, 0);
372         return (true, c);
373     }
374 
375     /**
376      * @dev Returns the division of two unsigned integers, with a division by zero flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         if (b == 0) return (false, 0);
382         return (true, a / b);
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
387      *
388      * _Available since v3.4._
389      */
390     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
391         if (b == 0) return (false, 0);
392         return (true, a % b);
393     }
394 
395     /**
396      * @dev Returns the addition of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `+` operator.
400      *
401      * Requirements:
402      *
403      * - Addition cannot overflow.
404      */
405     function add(uint256 a, uint256 b) internal pure returns (uint256) {
406         uint256 c = a + b;
407         require(c >= a, "SafeMath: addition overflow");
408         return c;
409     }
410 
411     /**
412      * @dev Returns the subtraction of two unsigned integers, reverting on
413      * overflow (when the result is negative).
414      *
415      * Counterpart to Solidity's `-` operator.
416      *
417      * Requirements:
418      *
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         require(b <= a, "SafeMath: subtraction overflow");
423         return a - b;
424     }
425 
426     /**
427      * @dev Returns the multiplication of two unsigned integers, reverting on
428      * overflow.
429      *
430      * Counterpart to Solidity's `*` operator.
431      *
432      * Requirements:
433      *
434      * - Multiplication cannot overflow.
435      */
436     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
437         if (a == 0) return 0;
438         uint256 c = a * b;
439         require(c / a == b, "SafeMath: multiplication overflow");
440         return c;
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting on
445      * division by zero. The result is rounded towards zero.
446      *
447      * Counterpart to Solidity's `/` operator. Note: this function uses a
448      * `revert` opcode (which leaves remaining gas untouched) while Solidity
449      * uses an invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function div(uint256 a, uint256 b) internal pure returns (uint256) {
456         require(b > 0, "SafeMath: division by zero");
457         return a / b;
458     }
459 
460     /**
461      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
462      * reverting when dividing by zero.
463      *
464      * Counterpart to Solidity's `%` operator. This function uses a `revert`
465      * opcode (which leaves remaining gas untouched) while Solidity uses an
466      * invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b > 0, "SafeMath: modulo by zero");
474         return a % b;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
479      * overflow (when the result is negative).
480      *
481      * CAUTION: This function is deprecated because it requires allocating memory for the error
482      * message unnecessarily. For custom revert reasons use {trySub}.
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
491         require(b <= a, errorMessage);
492         return a - b;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
497      * division by zero. The result is rounded towards zero.
498      *
499      * CAUTION: This function is deprecated because it requires allocating memory for the error
500      * message unnecessarily. For custom revert reasons use {tryDiv}.
501      *
502      * Counterpart to Solidity's `/` operator. Note: this function uses a
503      * `revert` opcode (which leaves remaining gas untouched) while Solidity
504      * uses an invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b > 0, errorMessage);
512         return a / b;
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * reverting with custom message when dividing by zero.
518      *
519      * CAUTION: This function is deprecated because it requires allocating memory for the error
520      * message unnecessarily. For custom revert reasons use {tryMod}.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         require(b > 0, errorMessage);
532         return a % b;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/Address.sol
537 pragma solidity >=0.6.2 <0.8.0;
538 
539 /**
540  * @dev Collection of functions related to the address type
541  */
542 library Address {
543     /**
544      * @dev Returns true if `account` is a contract.
545      *
546      * [IMPORTANT]
547      * ====
548      * It is unsafe to assume that an address for which this function returns
549      * false is an externally-owned account (EOA) and not a contract.
550      *
551      * Among others, `isContract` will return false for the following
552      * types of addresses:
553      *
554      *  - an externally-owned account
555      *  - a contract in construction
556      *  - an address where a contract will be created
557      *  - an address where a contract lived, but was destroyed
558      * ====
559      */
560     function isContract(address account) internal view returns (bool) {
561         // This method relies on extcodesize, which returns 0 for contracts in
562         // construction, since the code is only stored at the end of the
563         // constructor execution.
564 
565         uint256 size;
566         // solhint-disable-next-line no-inline-assembly
567         assembly { size := extcodesize(account) }
568         return size > 0;
569     }
570 
571     /**
572      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
573      * `recipient`, forwarding all available gas and reverting on errors.
574      *
575      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
576      * of certain opcodes, possibly making contracts go over the 2300 gas limit
577      * imposed by `transfer`, making them unable to receive funds via
578      * `transfer`. {sendValue} removes this limitation.
579      *
580      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
581      *
582      * IMPORTANT: because control is transferred to `recipient`, care must be
583      * taken to not create reentrancy vulnerabilities. Consider using
584      * {ReentrancyGuard} or the
585      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
586      */
587     function sendValue(address payable recipient, uint256 amount) internal {
588         require(address(this).balance >= amount, "Address: insufficient balance");
589 
590         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
591         (bool success, ) = recipient.call{ value: amount }("");
592         require(success, "Address: unable to send value, recipient may have reverted");
593     }
594 
595     /**
596      * @dev Performs a Solidity function call using a low level `call`. A
597      * plain`call` is an unsafe replacement for a function call: use this
598      * function instead.
599      *
600      * If `target` reverts with a revert reason, it is bubbled up by this
601      * function (like regular Solidity function calls).
602      *
603      * Returns the raw returned data. To convert to the expected return value,
604      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
605      *
606      * Requirements:
607      *
608      * - `target` must be a contract.
609      * - calling `target` with `data` must not revert.
610      *
611      * _Available since v3.1._
612      */
613     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
614       return functionCall(target, data, "Address: low-level call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
619      * `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
624         return functionCallWithValue(target, data, 0, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but also transferring `value` wei to `target`.
630      *
631      * Requirements:
632      *
633      * - the calling contract must have an ETH balance of at least `value`.
634      * - the called Solidity function must be `payable`.
635      *
636      * _Available since v3.1._
637      */
638     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
639         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
644      * with `errorMessage` as a fallback revert reason when `target` reverts.
645      *
646      * _Available since v3.1._
647      */
648     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
649         require(address(this).balance >= value, "Address: insufficient balance for call");
650         require(isContract(target), "Address: call to non-contract");
651 
652         // solhint-disable-next-line avoid-low-level-calls
653         (bool success, bytes memory returndata) = target.call{ value: value }(data);
654         return _verifyCallResult(success, returndata, errorMessage);
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
659      * but performing a static call.
660      *
661      * _Available since v3.3._
662      */
663     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
664         return functionStaticCall(target, data, "Address: low-level static call failed");
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
669      * but performing a static call.
670      *
671      * _Available since v3.3._
672      */
673     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
674         require(isContract(target), "Address: static call to non-contract");
675 
676         // solhint-disable-next-line avoid-low-level-calls
677         (bool success, bytes memory returndata) = target.staticcall(data);
678         return _verifyCallResult(success, returndata, errorMessage);
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
683      * but performing a delegate call.
684      *
685      * _Available since v3.4._
686      */
687     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
688         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
693      * but performing a delegate call.
694      *
695      * _Available since v3.4._
696      */
697     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
698         require(isContract(target), "Address: delegate call to non-contract");
699 
700         // solhint-disable-next-line avoid-low-level-calls
701         (bool success, bytes memory returndata) = target.delegatecall(data);
702         return _verifyCallResult(success, returndata, errorMessage);
703     }
704 
705     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
706         if (success) {
707             return returndata;
708         } else {
709             // Look for revert reason and bubble it up if present
710             if (returndata.length > 0) {
711                 // The easiest way to bubble the revert reason is using memory via assembly
712 
713                 // solhint-disable-next-line no-inline-assembly
714                 assembly {
715                     let returndata_size := mload(returndata)
716                     revert(add(32, returndata), returndata_size)
717                 }
718             } else {
719                 revert(errorMessage);
720             }
721         }
722     }
723 }
724 
725 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
726 pragma solidity >=0.6.0 <0.8.0;
727 
728 /**
729  * @dev Library for managing
730  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
731  * types.
732  *
733  * Sets have the following properties:
734  *
735  * - Elements are added, removed, and checked for existence in constant time
736  * (O(1)).
737  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
738  *
739  * ```
740  * contract Example {
741  *     // Add the library methods
742  *     using EnumerableSet for EnumerableSet.AddressSet;
743  *
744  *     // Declare a set state variable
745  *     EnumerableSet.AddressSet private mySet;
746  * }
747  * ```
748  *
749  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
750  * and `uint256` (`UintSet`) are supported.
751  */
752 library EnumerableSet {
753     // To implement this library for multiple types with as little code
754     // repetition as possible, we write it in terms of a generic Set type with
755     // bytes32 values.
756     // The Set implementation uses private functions, and user-facing
757     // implementations (such as AddressSet) are just wrappers around the
758     // underlying Set.
759     // This means that we can only create new EnumerableSets for types that fit
760     // in bytes32.
761 
762     struct Set {
763         // Storage of set values
764         bytes32[] _values;
765 
766         // Position of the value in the `values` array, plus 1 because index 0
767         // means a value is not in the set.
768         mapping (bytes32 => uint256) _indexes;
769     }
770 
771     /**
772      * @dev Add a value to a set. O(1).
773      *
774      * Returns true if the value was added to the set, that is if it was not
775      * already present.
776      */
777     function _add(Set storage set, bytes32 value) private returns (bool) {
778         if (!_contains(set, value)) {
779             set._values.push(value);
780             // The value is stored at length-1, but we add 1 to all indexes
781             // and use 0 as a sentinel value
782             set._indexes[value] = set._values.length;
783             return true;
784         } else {
785             return false;
786         }
787     }
788 
789     /**
790      * @dev Removes a value from a set. O(1).
791      *
792      * Returns true if the value was removed from the set, that is if it was
793      * present.
794      */
795     function _remove(Set storage set, bytes32 value) private returns (bool) {
796         // We read and store the value's index to prevent multiple reads from the same storage slot
797         uint256 valueIndex = set._indexes[value];
798 
799         if (valueIndex != 0) { // Equivalent to contains(set, value)
800             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
801             // the array, and then remove the last element (sometimes called as 'swap and pop').
802             // This modifies the order of the array, as noted in {at}.
803 
804             uint256 toDeleteIndex = valueIndex - 1;
805             uint256 lastIndex = set._values.length - 1;
806 
807             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
808             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
809 
810             bytes32 lastvalue = set._values[lastIndex];
811 
812             // Move the last value to the index where the value to delete is
813             set._values[toDeleteIndex] = lastvalue;
814             // Update the index for the moved value
815             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
816 
817             // Delete the slot where the moved value was stored
818             set._values.pop();
819 
820             // Delete the index for the deleted slot
821             delete set._indexes[value];
822 
823             return true;
824         } else {
825             return false;
826         }
827     }
828 
829     /**
830      * @dev Returns true if the value is in the set. O(1).
831      */
832     function _contains(Set storage set, bytes32 value) private view returns (bool) {
833         return set._indexes[value] != 0;
834     }
835 
836     /**
837      * @dev Returns the number of values on the set. O(1).
838      */
839     function _length(Set storage set) private view returns (uint256) {
840         return set._values.length;
841     }
842 
843    /**
844     * @dev Returns the value stored at position `index` in the set. O(1).
845     *
846     * Note that there are no guarantees on the ordering of values inside the
847     * array, and it may change when more values are added or removed.
848     *
849     * Requirements:
850     *
851     * - `index` must be strictly less than {length}.
852     */
853     function _at(Set storage set, uint256 index) private view returns (bytes32) {
854         require(set._values.length > index, "EnumerableSet: index out of bounds");
855         return set._values[index];
856     }
857 
858     // Bytes32Set
859 
860     struct Bytes32Set {
861         Set _inner;
862     }
863 
864     /**
865      * @dev Add a value to a set. O(1).
866      *
867      * Returns true if the value was added to the set, that is if it was not
868      * already present.
869      */
870     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
871         return _add(set._inner, value);
872     }
873 
874     /**
875      * @dev Removes a value from a set. O(1).
876      *
877      * Returns true if the value was removed from the set, that is if it was
878      * present.
879      */
880     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
881         return _remove(set._inner, value);
882     }
883 
884     /**
885      * @dev Returns true if the value is in the set. O(1).
886      */
887     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
888         return _contains(set._inner, value);
889     }
890 
891     /**
892      * @dev Returns the number of values in the set. O(1).
893      */
894     function length(Bytes32Set storage set) internal view returns (uint256) {
895         return _length(set._inner);
896     }
897 
898    /**
899     * @dev Returns the value stored at position `index` in the set. O(1).
900     *
901     * Note that there are no guarantees on the ordering of values inside the
902     * array, and it may change when more values are added or removed.
903     *
904     * Requirements:
905     *
906     * - `index` must be strictly less than {length}.
907     */
908     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
909         return _at(set._inner, index);
910     }
911 
912     // AddressSet
913 
914     struct AddressSet {
915         Set _inner;
916     }
917 
918     /**
919      * @dev Add a value to a set. O(1).
920      *
921      * Returns true if the value was added to the set, that is if it was not
922      * already present.
923      */
924     function add(AddressSet storage set, address value) internal returns (bool) {
925         return _add(set._inner, bytes32(uint256(uint160(value))));
926     }
927 
928     /**
929      * @dev Removes a value from a set. O(1).
930      *
931      * Returns true if the value was removed from the set, that is if it was
932      * present.
933      */
934     function remove(AddressSet storage set, address value) internal returns (bool) {
935         return _remove(set._inner, bytes32(uint256(uint160(value))));
936     }
937 
938     /**
939      * @dev Returns true if the value is in the set. O(1).
940      */
941     function contains(AddressSet storage set, address value) internal view returns (bool) {
942         return _contains(set._inner, bytes32(uint256(uint160(value))));
943     }
944 
945     /**
946      * @dev Returns the number of values in the set. O(1).
947      */
948     function length(AddressSet storage set) internal view returns (uint256) {
949         return _length(set._inner);
950     }
951 
952    /**
953     * @dev Returns the value stored at position `index` in the set. O(1).
954     *
955     * Note that there are no guarantees on the ordering of values inside the
956     * array, and it may change when more values are added or removed.
957     *
958     * Requirements:
959     *
960     * - `index` must be strictly less than {length}.
961     */
962     function at(AddressSet storage set, uint256 index) internal view returns (address) {
963         return address(uint160(uint256(_at(set._inner, index))));
964     }
965 
966 
967     // UintSet
968 
969     struct UintSet {
970         Set _inner;
971     }
972 
973     /**
974      * @dev Add a value to a set. O(1).
975      *
976      * Returns true if the value was added to the set, that is if it was not
977      * already present.
978      */
979     function add(UintSet storage set, uint256 value) internal returns (bool) {
980         return _add(set._inner, bytes32(value));
981     }
982 
983     /**
984      * @dev Removes a value from a set. O(1).
985      *
986      * Returns true if the value was removed from the set, that is if it was
987      * present.
988      */
989     function remove(UintSet storage set, uint256 value) internal returns (bool) {
990         return _remove(set._inner, bytes32(value));
991     }
992 
993     /**
994      * @dev Returns true if the value is in the set. O(1).
995      */
996     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
997         return _contains(set._inner, bytes32(value));
998     }
999 
1000     /**
1001      * @dev Returns the number of values on the set. O(1).
1002      */
1003     function length(UintSet storage set) internal view returns (uint256) {
1004         return _length(set._inner);
1005     }
1006 
1007    /**
1008     * @dev Returns the value stored at position `index` in the set. O(1).
1009     *
1010     * Note that there are no guarantees on the ordering of values inside the
1011     * array, and it may change when more values are added or removed.
1012     *
1013     * Requirements:
1014     *
1015     * - `index` must be strictly less than {length}.
1016     */
1017     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1018         return uint256(_at(set._inner, index));
1019     }
1020 }
1021 
1022 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1023 pragma solidity >=0.6.0 <0.8.0;
1024 
1025 /**
1026  * @dev Library for managing an enumerable variant of Solidity's
1027  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1028  * type.
1029  *
1030  * Maps have the following properties:
1031  *
1032  * - Entries are added, removed, and checked for existence in constant time
1033  * (O(1)).
1034  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1035  *
1036  * ```
1037  * contract Example {
1038  *     // Add the library methods
1039  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1040  *
1041  *     // Declare a set state variable
1042  *     EnumerableMap.UintToAddressMap private myMap;
1043  * }
1044  * ```
1045  *
1046  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1047  * supported.
1048  */
1049 library EnumerableMap {
1050     // To implement this library for multiple types with as little code
1051     // repetition as possible, we write it in terms of a generic Map type with
1052     // bytes32 keys and values.
1053     // The Map implementation uses private functions, and user-facing
1054     // implementations (such as Uint256ToAddressMap) are just wrappers around
1055     // the underlying Map.
1056     // This means that we can only create new EnumerableMaps for types that fit
1057     // in bytes32.
1058 
1059     struct MapEntry {
1060         bytes32 _key;
1061         bytes32 _value;
1062     }
1063 
1064     struct Map {
1065         // Storage of map keys and values
1066         MapEntry[] _entries;
1067 
1068         // Position of the entry defined by a key in the `entries` array, plus 1
1069         // because index 0 means a key is not in the map.
1070         mapping (bytes32 => uint256) _indexes;
1071     }
1072 
1073     /**
1074      * @dev Adds a key-value pair to a map, or updates the value for an existing
1075      * key. O(1).
1076      *
1077      * Returns true if the key was added to the map, that is if it was not
1078      * already present.
1079      */
1080     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1081         // We read and store the key's index to prevent multiple reads from the same storage slot
1082         uint256 keyIndex = map._indexes[key];
1083 
1084         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1085             map._entries.push(MapEntry({ _key: key, _value: value }));
1086             // The entry is stored at length-1, but we add 1 to all indexes
1087             // and use 0 as a sentinel value
1088             map._indexes[key] = map._entries.length;
1089             return true;
1090         } else {
1091             map._entries[keyIndex - 1]._value = value;
1092             return false;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Removes a key-value pair from a map. O(1).
1098      *
1099      * Returns true if the key was removed from the map, that is if it was present.
1100      */
1101     function _remove(Map storage map, bytes32 key) private returns (bool) {
1102         // We read and store the key's index to prevent multiple reads from the same storage slot
1103         uint256 keyIndex = map._indexes[key];
1104 
1105         if (keyIndex != 0) { // Equivalent to contains(map, key)
1106             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1107             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1108             // This modifies the order of the array, as noted in {at}.
1109 
1110             uint256 toDeleteIndex = keyIndex - 1;
1111             uint256 lastIndex = map._entries.length - 1;
1112 
1113             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1114             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1115 
1116             MapEntry storage lastEntry = map._entries[lastIndex];
1117 
1118             // Move the last entry to the index where the entry to delete is
1119             map._entries[toDeleteIndex] = lastEntry;
1120             // Update the index for the moved entry
1121             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1122 
1123             // Delete the slot where the moved entry was stored
1124             map._entries.pop();
1125 
1126             // Delete the index for the deleted slot
1127             delete map._indexes[key];
1128 
1129             return true;
1130         } else {
1131             return false;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns true if the key is in the map. O(1).
1137      */
1138     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1139         return map._indexes[key] != 0;
1140     }
1141 
1142     /**
1143      * @dev Returns the number of key-value pairs in the map. O(1).
1144      */
1145     function _length(Map storage map) private view returns (uint256) {
1146         return map._entries.length;
1147     }
1148 
1149    /**
1150     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1151     *
1152     * Note that there are no guarantees on the ordering of entries inside the
1153     * array, and it may change when more entries are added or removed.
1154     *
1155     * Requirements:
1156     *
1157     * - `index` must be strictly less than {length}.
1158     */
1159     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1160         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1161 
1162         MapEntry storage entry = map._entries[index];
1163         return (entry._key, entry._value);
1164     }
1165 
1166     /**
1167      * @dev Tries to returns the value associated with `key`.  O(1).
1168      * Does not revert if `key` is not in the map.
1169      */
1170     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1171         uint256 keyIndex = map._indexes[key];
1172         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1173         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1174     }
1175 
1176     /**
1177      * @dev Returns the value associated with `key`.  O(1).
1178      *
1179      * Requirements:
1180      *
1181      * - `key` must be in the map.
1182      */
1183     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1184         uint256 keyIndex = map._indexes[key];
1185         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1186         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1187     }
1188 
1189     /**
1190      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1191      *
1192      * CAUTION: This function is deprecated because it requires allocating memory for the error
1193      * message unnecessarily. For custom revert reasons use {_tryGet}.
1194      */
1195     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1196         uint256 keyIndex = map._indexes[key];
1197         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1198         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1199     }
1200 
1201     // UintToAddressMap
1202 
1203     struct UintToAddressMap {
1204         Map _inner;
1205     }
1206 
1207     /**
1208      * @dev Adds a key-value pair to a map, or updates the value for an existing
1209      * key. O(1).
1210      *
1211      * Returns true if the key was added to the map, that is if it was not
1212      * already present.
1213      */
1214     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1215         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1216     }
1217 
1218     /**
1219      * @dev Removes a value from a set. O(1).
1220      *
1221      * Returns true if the key was removed from the map, that is if it was present.
1222      */
1223     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1224         return _remove(map._inner, bytes32(key));
1225     }
1226 
1227     /**
1228      * @dev Returns true if the key is in the map. O(1).
1229      */
1230     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1231         return _contains(map._inner, bytes32(key));
1232     }
1233 
1234     /**
1235      * @dev Returns the number of elements in the map. O(1).
1236      */
1237     function length(UintToAddressMap storage map) internal view returns (uint256) {
1238         return _length(map._inner);
1239     }
1240 
1241    /**
1242     * @dev Returns the element stored at position `index` in the set. O(1).
1243     * Note that there are no guarantees on the ordering of values inside the
1244     * array, and it may change when more values are added or removed.
1245     *
1246     * Requirements:
1247     *
1248     * - `index` must be strictly less than {length}.
1249     */
1250     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1251         (bytes32 key, bytes32 value) = _at(map._inner, index);
1252         return (uint256(key), address(uint160(uint256(value))));
1253     }
1254 
1255     /**
1256      * @dev Tries to returns the value associated with `key`.  O(1).
1257      * Does not revert if `key` is not in the map.
1258      *
1259      * _Available since v3.4._
1260      */
1261     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1262         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1263         return (success, address(uint160(uint256(value))));
1264     }
1265 
1266     /**
1267      * @dev Returns the value associated with `key`.  O(1).
1268      *
1269      * Requirements:
1270      *
1271      * - `key` must be in the map.
1272      */
1273     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1274         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1275     }
1276 
1277     /**
1278      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1279      *
1280      * CAUTION: This function is deprecated because it requires allocating memory for the error
1281      * message unnecessarily. For custom revert reasons use {tryGet}.
1282      */
1283     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1284         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1285     }
1286 }
1287 
1288 // File: @openzeppelin/contracts/utils/Strings.sol
1289 pragma solidity >=0.6.0 <0.8.0;
1290 
1291 /**
1292  * @dev String operations.
1293  */
1294 library Strings {
1295     /**
1296      * @dev Converts a `uint256` to its ASCII `string` representation.
1297      */
1298     function toString(uint256 value) internal pure returns (string memory) {
1299         // Inspired by OraclizeAPI's implementation - MIT licence
1300         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1301 
1302         if (value == 0) {
1303             return "0";
1304         }
1305         uint256 temp = value;
1306         uint256 digits;
1307         while (temp != 0) {
1308             digits++;
1309             temp /= 10;
1310         }
1311         bytes memory buffer = new bytes(digits);
1312         uint256 index = digits - 1;
1313         temp = value;
1314         while (temp != 0) {
1315             buffer[index--] = bytes1(uint8(48 + temp % 10));
1316             temp /= 10;
1317         }
1318         return string(buffer);
1319     }
1320 }
1321 
1322 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1323 pragma solidity >=0.6.0 <0.8.0;
1324 
1325 /**
1326  * @title ERC721 Non-Fungible Token Standard basic implementation
1327  * @dev see https://eips.ethereum.org/EIPS/eip-721
1328  */
1329 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1330     using SafeMath for uint256;
1331     using Address for address;
1332     using EnumerableSet for EnumerableSet.UintSet;
1333     using EnumerableMap for EnumerableMap.UintToAddressMap;
1334     using Strings for uint256;
1335 
1336     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1337     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1338     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1339 
1340     // Mapping from holder address to their (enumerable) set of owned tokens
1341     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1342 
1343     // Enumerable mapping from token ids to their owners
1344     EnumerableMap.UintToAddressMap private _tokenOwners;
1345 
1346     // Mapping from token ID to approved address
1347     mapping (uint256 => address) private _tokenApprovals;
1348 
1349     // Mapping from owner to operator approvals
1350     mapping (address => mapping (address => bool)) private _operatorApprovals;
1351 
1352     // Token name
1353     string private _name;
1354 
1355     // Token symbol
1356     string private _symbol;
1357 
1358     // Optional mapping for token URIs
1359     mapping (uint256 => string) private _tokenURIs;
1360 
1361     // Base URI
1362     string private _baseURI;
1363 
1364     /*
1365      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1366      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1367      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1368      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1369      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1370      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1371      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1372      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1373      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1374      *
1375      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1376      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1377      */
1378     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1379 
1380     /*
1381      *     bytes4(keccak256('name()')) == 0x06fdde03
1382      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1383      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1384      *
1385      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1386      */
1387     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1388 
1389     /*
1390      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1391      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1392      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1393      *
1394      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1395      */
1396     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1397 
1398     /**
1399      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1400      */
1401     constructor (string memory name_, string memory symbol_) public {
1402         _name = name_;
1403         _symbol = symbol_;
1404 
1405         // register the supported interfaces to conform to ERC721 via ERC165
1406         _registerInterface(_INTERFACE_ID_ERC721);
1407         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1408         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1409     }
1410 
1411     /**
1412      * @dev See {IERC721-balanceOf}.
1413      */
1414     function balanceOf(address owner) public view virtual override returns (uint256) {
1415         require(owner != address(0), "ERC721: balance query for the zero address");
1416         return _holderTokens[owner].length();
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-ownerOf}.
1421      */
1422     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1423         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1424     }
1425 
1426     /**
1427      * @dev See {IERC721Metadata-name}.
1428      */
1429     function name() public view virtual override returns (string memory) {
1430         return _name;
1431     }
1432 
1433     /**
1434      * @dev See {IERC721Metadata-symbol}.
1435      */
1436     function symbol() public view virtual override returns (string memory) {
1437         return _symbol;
1438     }
1439 
1440     /**
1441      * @dev See {IERC721Metadata-tokenURI}.
1442      */
1443     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1444         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1445 
1446         string memory _tokenURI = _tokenURIs[tokenId];
1447         string memory base = baseURI();
1448 
1449         // If there is no base URI, return the token URI.
1450         if (bytes(base).length == 0) {
1451             return _tokenURI;
1452         }
1453         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1454         if (bytes(_tokenURI).length > 0) {
1455             return string(abi.encodePacked(base, _tokenURI));
1456         }
1457         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1458         return string(abi.encodePacked(base, tokenId.toString()));
1459     }
1460 
1461     /**
1462     * @dev Returns the base URI set via {_setBaseURI}. This will be
1463     * automatically added as a prefix in {tokenURI} to each token's URI, or
1464     * to the token ID if no specific URI is set for that token ID.
1465     */
1466     function baseURI() public view virtual returns (string memory) {
1467         return _baseURI;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1472      */
1473     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1474         return _holderTokens[owner].at(index);
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Enumerable-totalSupply}.
1479      */
1480     function totalSupply() public view virtual override returns (uint256) {
1481         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1482         return _tokenOwners.length();
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Enumerable-tokenByIndex}.
1487      */
1488     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1489         (uint256 tokenId, ) = _tokenOwners.at(index);
1490         return tokenId;
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-approve}.
1495      */
1496     function approve(address to, uint256 tokenId) public virtual override {
1497         address owner = ERC721.ownerOf(tokenId);
1498         require(to != owner, "ERC721: approval to current owner");
1499 
1500         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1501             "ERC721: approve caller is not owner nor approved for all"
1502         );
1503 
1504         _approve(to, tokenId);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-getApproved}.
1509      */
1510     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1511         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1512 
1513         return _tokenApprovals[tokenId];
1514     }
1515 
1516     /**
1517      * @dev See {IERC721-setApprovalForAll}.
1518      */
1519     function setApprovalForAll(address operator, bool approved) public virtual override {
1520         require(operator != _msgSender(), "ERC721: approve to caller");
1521 
1522         _operatorApprovals[_msgSender()][operator] = approved;
1523         emit ApprovalForAll(_msgSender(), operator, approved);
1524     }
1525 
1526     /**
1527      * @dev See {IERC721-isApprovedForAll}.
1528      */
1529     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1530         return _operatorApprovals[owner][operator];
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-transferFrom}.
1535      */
1536     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1537         //solhint-disable-next-line max-line-length
1538         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1539 
1540         _transfer(from, to, tokenId);
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-safeTransferFrom}.
1545      */
1546     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1547         safeTransferFrom(from, to, tokenId, "");
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-safeTransferFrom}.
1552      */
1553     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1554         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1555         _safeTransfer(from, to, tokenId, _data);
1556     }
1557 
1558     /**
1559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1561      *
1562      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1563      *
1564      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1565      * implement alternative mechanisms to perform token transfer, such as signature-based.
1566      *
1567      * Requirements:
1568      *
1569      * - `from` cannot be the zero address.
1570      * - `to` cannot be the zero address.
1571      * - `tokenId` token must exist and be owned by `from`.
1572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1573      *
1574      * Emits a {Transfer} event.
1575      */
1576     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1577         _transfer(from, to, tokenId);
1578         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1579     }
1580 
1581     /**
1582      * @dev Returns whether `tokenId` exists.
1583      *
1584      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1585      *
1586      * Tokens start existing when they are minted (`_mint`),
1587      * and stop existing when they are burned (`_burn`).
1588      */
1589     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1590         return _tokenOwners.contains(tokenId);
1591     }
1592 
1593     /**
1594      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1595      *
1596      * Requirements:
1597      *
1598      * - `tokenId` must exist.
1599      */
1600     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1601         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1602         address owner = ERC721.ownerOf(tokenId);
1603         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1604     }
1605 
1606     /**
1607      * @dev Safely mints `tokenId` and transfers it to `to`.
1608      *
1609      * Requirements:
1610      d*
1611      * - `tokenId` must not exist.
1612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function _safeMint(address to, uint256 tokenId) internal virtual {
1617         _safeMint(to, tokenId, "");
1618     }
1619 
1620     /**
1621      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1622      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1623      */
1624     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1625         _mint(to, tokenId);
1626         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1627     }
1628 
1629     /**
1630      * @dev Mints `tokenId` and transfers it to `to`.
1631      *
1632      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must not exist.
1637      * - `to` cannot be the zero address.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function _mint(address to, uint256 tokenId) internal virtual {
1642         require(to != address(0), "ERC721: mint to the zero address");
1643         require(!_exists(tokenId), "ERC721: token already minted");
1644 
1645         _beforeTokenTransfer(address(0), to, tokenId);
1646 
1647         _holderTokens[to].add(tokenId);
1648 
1649         _tokenOwners.set(tokenId, to);
1650 
1651         emit Transfer(address(0), to, tokenId);
1652     }
1653 
1654     /**
1655      * @dev Destroys `tokenId`.
1656      * The approval is cleared when the token is burned.
1657      *
1658      * Requirements:
1659      *
1660      * - `tokenId` must exist.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function _burn(uint256 tokenId) internal virtual {
1665         address owner = ERC721.ownerOf(tokenId); // internal owner
1666 
1667         _beforeTokenTransfer(owner, address(0), tokenId);
1668 
1669         // Clear approvals
1670         _approve(address(0), tokenId);
1671 
1672         // Clear metadata (if any)
1673         if (bytes(_tokenURIs[tokenId]).length != 0) {
1674             delete _tokenURIs[tokenId];
1675         }
1676 
1677         _holderTokens[owner].remove(tokenId);
1678 
1679         _tokenOwners.remove(tokenId);
1680 
1681         emit Transfer(owner, address(0), tokenId);
1682     }
1683 
1684     /**
1685      * @dev Transfers `tokenId` from `from` to `to`.
1686      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1687      *
1688      * Requirements:
1689      *
1690      * - `to` cannot be the zero address.
1691      * - `tokenId` token must be owned by `from`.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1696         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1697         require(to != address(0), "ERC721: transfer to the zero address");
1698 
1699         _beforeTokenTransfer(from, to, tokenId);
1700 
1701         // Clear approvals from the previous owner
1702         _approve(address(0), tokenId);
1703 
1704         _holderTokens[from].remove(tokenId);
1705         _holderTokens[to].add(tokenId);
1706 
1707         _tokenOwners.set(tokenId, to);
1708 
1709         emit Transfer(from, to, tokenId);
1710     }
1711 
1712     /**
1713      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      */
1719     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1720         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1721         _tokenURIs[tokenId] = _tokenURI;
1722     }
1723 
1724     /**
1725      * @dev Internal function to set the base URI for all token IDs. It is
1726      * automatically added as a prefix to the value returned in {tokenURI},
1727      * or to the token ID if {tokenURI} is empty.
1728      */
1729     function _setBaseURI(string memory baseURI_) internal virtual {
1730         _baseURI = baseURI_;
1731     }
1732 
1733     /**
1734      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1735      * The call is not executed if the target address is not a contract.
1736      *
1737      * @param from address representing the previous owner of the given token ID
1738      * @param to target address that will receive the tokens
1739      * @param tokenId uint256 ID of the token to be transferred
1740      * @param _data bytes optional data to send along with the call
1741      * @return bool whether the call correctly returned the expected magic value
1742      */
1743     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1744         private returns (bool)
1745     {
1746         if (!to.isContract()) {
1747             return true;
1748         }
1749         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1750             IERC721Receiver(to).onERC721Received.selector,
1751             _msgSender(),
1752             from,
1753             tokenId,
1754             _data
1755         ), "ERC721: transfer to non ERC721Receiver implementer");
1756         bytes4 retval = abi.decode(returndata, (bytes4));
1757         return (retval == _ERC721_RECEIVED);
1758     }
1759 
1760     /**
1761      * @dev Approve `to` to operate on `tokenId`
1762      *
1763      * Emits an {Approval} event.
1764      */
1765     function _approve(address to, uint256 tokenId) internal virtual {
1766         _tokenApprovals[tokenId] = to;
1767         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1768     }
1769 
1770     /**
1771      * @dev Hook that is called before any token transfer. This includes minting
1772      * and burning.
1773      *
1774      * Calling conditions:
1775      *
1776      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1777      * transferred to `to`.
1778      * - When `from` is zero, `tokenId` will be minted for `to`.
1779      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1780      * - `from` cannot be the zero address.
1781      * - `to` cannot be the zero address.
1782      *
1783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1784      */
1785     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1786 }
1787 
1788 // File: @openzeppelin/contracts/access/Ownable.sol
1789 pragma solidity >=0.6.0 <0.8.0;
1790 
1791 /**
1792  * @dev Contract module which provides a basic access control mechanism, where
1793  * there is an account (an owner) that can be granted exclusive access to
1794  * specific functions.
1795  *
1796  * By default, the owner account will be the one that deploys the contract. This
1797  * can later be changed with {transferOwnership}.
1798  *
1799  * This module is used through inheritance. It will make available the modifier
1800  * `onlyOwner`, which can be applied to your functions to restrict their use to
1801  * the owner.
1802  */
1803 abstract contract Ownable is Context {
1804     address private _owner;
1805 
1806     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1807 
1808     /**
1809      * @dev Initializes the contract setting the deployer as the initial owner.
1810      */
1811     constructor () internal {
1812         address msgSender = _msgSender();
1813         _owner = msgSender;
1814         emit OwnershipTransferred(address(0), msgSender);
1815     }
1816 
1817     /**
1818      * @dev Returns the address of the current owner.
1819      */
1820     function owner() public view virtual returns (address) {
1821         return _owner;
1822     }
1823 
1824     /**
1825      * @dev Throws if called by any account other than the owner.
1826      */
1827     modifier onlyOwner() {
1828         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1829         _;
1830     }
1831 
1832     /**
1833      * @dev Leaves the contract without owner. It will not be possible to call
1834      * `onlyOwner` functions anymore. Can only be called by the current owner.
1835      *
1836      * NOTE: Renouncing ownership will leave the contract without an owner,
1837      * thereby removing any functionality that is only available to the owner.
1838      */
1839     function renounceOwnership() public virtual onlyOwner {
1840         emit OwnershipTransferred(_owner, address(0));
1841         _owner = address(0);
1842     }
1843 
1844     /**
1845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1846      * Can only be called by the current owner.
1847      */
1848     function transferOwnership(address newOwner) public virtual onlyOwner {
1849         require(newOwner != address(0), "Ownable: new owner is the zero address");
1850         emit OwnershipTransferred(_owner, newOwner);
1851         _owner = newOwner;
1852     }
1853 }
1854 
1855 // File: contracts/ProceduralSpace.sol
1856 pragma solidity ^0.7.0;
1857 
1858 /**
1859  * @title ProceduralSpace contract
1860  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1861  */
1862 contract ProceduralSpace is ERC721, Ownable {
1863     uint256 public count = 0;
1864     
1865     event Increment(address who);
1866 
1867     using SafeMath for uint256;
1868     uint256 public planetPrice = 100000000000000000; //0.1 ETH
1869     uint public constant maxPlanetPurchase = 20;
1870     uint256 public MAX_PLANETS;
1871     bool public saleIsActive = false;
1872 
1873     constructor(string memory name, string memory symbol, uint256 maxNftSupply) ERC721(name, symbol) {
1874         MAX_PLANETS = maxNftSupply;
1875     }
1876 
1877     function withdraw() public onlyOwner {
1878         uint balance = address(this).balance;
1879         msg.sender.transfer(balance);
1880     }
1881 
1882     // Reserves 30 planets
1883     function reservePlanets() public onlyOwner {        
1884         uint supply = totalSupply();
1885         uint i;
1886         for (i = 0; i < 30; i++) {
1887             _safeMint(msg.sender, supply + i);
1888             count += 1;
1889         }
1890         emit Increment(msg.sender);
1891     }
1892 
1893     function setBaseURI(string memory baseURI) public onlyOwner {
1894         _setBaseURI(baseURI);
1895     }
1896 
1897     function flipSaleState() public onlyOwner {
1898         saleIsActive = !saleIsActive;
1899     }
1900 
1901     function discoverPlanet(uint numberOfTokens) public payable {
1902         require(saleIsActive, "Sale must be active to mint Planet");
1903         require(numberOfTokens <= maxPlanetPurchase, "Can only mint 20 tokens at a time");
1904         require(totalSupply().add(numberOfTokens) <= MAX_PLANETS, "Purchase would exceed max supply of Planets");
1905         require(planetPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1906         
1907         for(uint i = 0; i < numberOfTokens; i++) {
1908             uint mintIndex = totalSupply();
1909             if (totalSupply() < MAX_PLANETS) {
1910                 _safeMint(msg.sender, mintIndex);
1911                 count += 1;
1912             }
1913         }
1914 
1915         emit Increment(msg.sender);
1916     }
1917 
1918     function getCount() public view returns(uint256) {
1919         return count;
1920     }
1921 
1922     // Emergency: can be changed to account for large fluctuations in ETH price
1923     function emergencyChangePrice(uint256 newPrice) public onlyOwner {
1924         planetPrice = newPrice;
1925     }
1926 }