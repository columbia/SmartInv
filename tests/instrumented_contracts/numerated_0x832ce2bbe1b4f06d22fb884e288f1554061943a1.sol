1 /**
2  
3 ██████╗░░█████╗░░█████╗░░█████╗░░█████╗░░█████╗░███╗░░██╗
4 ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗████╗░██║
5 ██████╔╝███████║██║░░╚═╝██║░░╚═╝██║░░██║██║░░██║██╔██╗██║
6 ██╔══██╗██╔══██║██║░░██╗██║░░██╗██║░░██║██║░░██║██║╚████║
7 ██║░░██║██║░░██║╚█████╔╝╚█████╔╝╚█████╔╝╚█████╔╝██║░╚███║
8 ╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░░╚════╝░░╚════╝░░╚════╝░╚═╝░░╚══╝
9 
10 ███╗░░░███╗░█████╗░███████╗██╗░█████╗░
11 ████╗░████║██╔══██╗██╔════╝██║██╔══██╗
12 ██╔████╔██║███████║█████╗░░██║███████║
13 ██║╚██╔╝██║██╔══██║██╔══╝░░██║██╔══██║
14 ██║░╚═╝░██║██║░░██║██║░░░░░██║██║░░██║
15 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝
16 
17 */
18 
19 // File: @openzeppelin/contracts/utils/Context.sol
20 
21 // SPDX-License-Identifier: MIT
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
37         return payable(msg.sender);
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/introspection/IERC165.sol
47 
48 
49 
50 pragma solidity >=0.6.0 <0.8.0;
51 
52 /**
53  * @dev Interface of the ERC165 standard, as defined in the
54  * https://eips.ethereum.org/EIPS/eip-165[EIP].
55  *
56  * Implementers can declare support of contract interfaces, which can then be
57  * queried by others ({ERC165Checker}).
58  *
59  * For an implementation, see {ERC165}.
60  */
61 interface IERC165 {
62     /**
63      * @dev Returns true if this contract implements the interface defined by
64      * `interfaceId`. See the corresponding
65      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
66      * to learn more about how these ids are created.
67      *
68      * This function call must use less than 30 000 gas.
69      */
70     function supportsInterface(bytes4 interfaceId) external view returns (bool);
71 }
72 
73 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
74 
75 
76 
77 pragma solidity >=0.6.2 <0.8.0;
78 
79 
80 /**
81  * @dev Required interface of an ERC721 compliant contract.
82  */
83 interface IERC721 is IERC165 {
84     /**
85      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
88 
89     /**
90      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
91      */
92     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
93 
94     /**
95      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
96      */
97     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
98 
99     /**
100      * @dev Returns the number of tokens in ``owner``'s account.
101      */
102     function balanceOf(address owner) external view returns (uint256 balance);
103 
104     /**
105      * @dev Returns the owner of the `tokenId` token.
106      *
107      * Requirements:
108      *
109      * - `tokenId` must exist.
110      */
111     function ownerOf(uint256 tokenId) external view returns (address owner);
112 
113     /**
114      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
115      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must exist and be owned by `from`.
122      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
124      *
125      * Emits a {Transfer} event.
126      */
127     function safeTransferFrom(address from, address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Transfers `tokenId` token from `from` to `to`.
131      *
132      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(address from, address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
147      * The approval is cleared when the token is transferred.
148      *
149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
150      *
151      * Requirements:
152      *
153      * - The caller must own the token or be an approved operator.
154      * - `tokenId` must exist.
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address to, uint256 tokenId) external;
159 
160     /**
161      * @dev Returns the account approved for `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function getApproved(uint256 tokenId) external view returns (address operator);
168 
169     /**
170      * @dev Approve or remove `operator` as an operator for the caller.
171      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
172      *
173      * Requirements:
174      *
175      * - The `operator` cannot be the caller.
176      *
177      * Emits an {ApprovalForAll} event.
178      */
179     function setApprovalForAll(address operator, bool _approved) external;
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator) external view returns (bool);
187 
188     /**
189       * @dev Safely transfers `tokenId` token from `from` to `to`.
190       *
191       * Requirements:
192       *
193       * - `from` cannot be the zero address.
194       * - `to` cannot be the zero address.
195       * - `tokenId` token must exist and be owned by `from`.
196       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
197       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198       *
199       * Emits a {Transfer} event.
200       */
201     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
205 
206 
207 
208 pragma solidity >=0.6.2 <0.8.0;
209 
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216 
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
234 
235 
236 
237 pragma solidity >=0.6.2 <0.8.0;
238 
239 
240 /**
241  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
242  * @dev See https://eips.ethereum.org/EIPS/eip-721
243  */
244 interface IERC721Enumerable is IERC721 {
245 
246     /**
247      * @dev Returns the total amount of tokens stored by the contract.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
253      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
254      */
255     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
256 
257     /**
258      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
259      * Use along with {totalSupply} to enumerate all tokens.
260      */
261     function tokenByIndex(uint256 index) external view returns (uint256);
262 }
263 
264 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
265 
266 
267 
268 pragma solidity >=0.6.0 <0.8.0;
269 
270 /**
271  * @title ERC721 token receiver interface
272  * @dev Interface for any contract that wants to support safeTransfers
273  * from ERC721 asset contracts.
274  */
275 interface IERC721Receiver {
276     /**
277      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
278      * by `operator` from `from`, this function is called.
279      *
280      * It must return its Solidity selector to confirm the token transfer.
281      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
282      *
283      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
284      */
285     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
286 }
287 
288 // File: @openzeppelin/contracts/introspection/ERC165.sol
289 
290 
291 
292 pragma solidity >=0.6.0 <0.8.0;
293 
294 
295 /**
296  * @dev Implementation of the {IERC165} interface.
297  *
298  * Contracts may inherit from this and call {_registerInterface} to declare
299  * their support of an interface.
300  */
301 abstract contract ERC165 is IERC165 {
302     /*
303      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
304      */
305     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
306 
307     /**
308      * @dev Mapping of interface ids to whether or not it's supported.
309      */
310     mapping(bytes4 => bool) private _supportedInterfaces;
311 
312     constructor () {
313         // Derived contracts need only register support for their own interfaces,
314         // we register support for ERC165 itself here
315         _registerInterface(_INTERFACE_ID_ERC165);
316     }
317 
318     /**
319      * @dev See {IERC165-supportsInterface}.
320      *
321      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return _supportedInterfaces[interfaceId];
325     }
326 
327     /**
328      * @dev Registers the contract as an implementer of the interface defined by
329      * `interfaceId`. Support of the actual ERC165 interface is automatic and
330      * registering its interface id is not required.
331      *
332      * See {IERC165-supportsInterface}.
333      *
334      * Requirements:
335      *
336      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
337      */
338     function _registerInterface(bytes4 interfaceId) internal virtual {
339         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
340         _supportedInterfaces[interfaceId] = true;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/math/SafeMath.sol
345 
346 
347 
348 pragma solidity >=0.6.0 <0.8.0;
349 
350 /**
351  * @dev Wrappers over Solidity's arithmetic operations with added overflow
352  * checks.
353  *
354  * Arithmetic operations in Solidity wrap on overflow. This can easily result
355  * in bugs, because programmers usually assume that an overflow raises an
356  * error, which is the standard behavior in high level programming languages.
357  * `SafeMath` restores this intuition by reverting the transaction when an
358  * operation overflows.
359  *
360  * Using this library instead of the unchecked operations eliminates an entire
361  * class of bugs, so it's recommended to use it always.
362  */
363 library SafeMath {
364     /**
365      * @dev Returns the addition of two unsigned integers, with an overflow flag.
366      *
367      * _Available since v3.4._
368      */
369     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         uint256 c = a + b;
371         if (c < a) return (false, 0);
372         return (true, c);
373     }
374 
375     /**
376      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
377      *
378      * _Available since v3.4._
379      */
380     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         if (b > a) return (false, 0);
382         return (true, a - b);
383     }
384 
385     /**
386      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
387      *
388      * _Available since v3.4._
389      */
390     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
391         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
392         // benefit is lost if 'b' is also tested.
393         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
394         if (a == 0) return (true, 0);
395         uint256 c = a * b;
396         if (c / a != b) return (false, 0);
397         return (true, c);
398     }
399 
400     /**
401      * @dev Returns the division of two unsigned integers, with a division by zero flag.
402      *
403      * _Available since v3.4._
404      */
405     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
406         if (b == 0) return (false, 0);
407         return (true, a / b);
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
412      *
413      * _Available since v3.4._
414      */
415     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
416         if (b == 0) return (false, 0);
417         return (true, a % b);
418     }
419 
420     /**
421      * @dev Returns the addition of two unsigned integers, reverting on
422      * overflow.
423      *
424      * Counterpart to Solidity's `+` operator.
425      *
426      * Requirements:
427      *
428      * - Addition cannot overflow.
429      */
430     function add(uint256 a, uint256 b) internal pure returns (uint256) {
431         uint256 c = a + b;
432         require(c >= a, "SafeMath: addition overflow");
433         return c;
434     }
435 
436     /**
437      * @dev Returns the subtraction of two unsigned integers, reverting on
438      * overflow (when the result is negative).
439      *
440      * Counterpart to Solidity's `-` operator.
441      *
442      * Requirements:
443      *
444      * - Subtraction cannot overflow.
445      */
446     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b <= a, "SafeMath: subtraction overflow");
448         return a - b;
449     }
450 
451     /**
452      * @dev Returns the multiplication of two unsigned integers, reverting on
453      * overflow.
454      *
455      * Counterpart to Solidity's `*` operator.
456      *
457      * Requirements:
458      *
459      * - Multiplication cannot overflow.
460      */
461     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
462         if (a == 0) return 0;
463         uint256 c = a * b;
464         require(c / a == b, "SafeMath: multiplication overflow");
465         return c;
466     }
467 
468     /**
469      * @dev Returns the integer division of two unsigned integers, reverting on
470      * division by zero. The result is rounded towards zero.
471      *
472      * Counterpart to Solidity's `/` operator. Note: this function uses a
473      * `revert` opcode (which leaves remaining gas untouched) while Solidity
474      * uses an invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         require(b > 0, "SafeMath: division by zero");
482         return a / b;
483     }
484 
485     /**
486      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
487      * reverting when dividing by zero.
488      *
489      * Counterpart to Solidity's `%` operator. This function uses a `revert`
490      * opcode (which leaves remaining gas untouched) while Solidity uses an
491      * invalid opcode to revert (consuming all remaining gas).
492      *
493      * Requirements:
494      *
495      * - The divisor cannot be zero.
496      */
497     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
498         require(b > 0, "SafeMath: modulo by zero");
499         return a % b;
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * CAUTION: This function is deprecated because it requires allocating memory for the error
507      * message unnecessarily. For custom revert reasons use {trySub}.
508      *
509      * Counterpart to Solidity's `-` operator.
510      *
511      * Requirements:
512      *
513      * - Subtraction cannot overflow.
514      */
515     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b <= a, errorMessage);
517         return a - b;
518     }
519 
520     /**
521      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
522      * division by zero. The result is rounded towards zero.
523      *
524      * CAUTION: This function is deprecated because it requires allocating memory for the error
525      * message unnecessarily. For custom revert reasons use {tryDiv}.
526      *
527      * Counterpart to Solidity's `/` operator. Note: this function uses a
528      * `revert` opcode (which leaves remaining gas untouched) while Solidity
529      * uses an invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
536         require(b > 0, errorMessage);
537         return a / b;
538     }
539 
540     /**
541      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
542      * reverting with custom message when dividing by zero.
543      *
544      * CAUTION: This function is deprecated because it requires allocating memory for the error
545      * message unnecessarily. For custom revert reasons use {tryMod}.
546      *
547      * Counterpart to Solidity's `%` operator. This function uses a `revert`
548      * opcode (which leaves remaining gas untouched) while Solidity uses an
549      * invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
556         require(b > 0, errorMessage);
557         return a % b;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/Address.sol
562 
563 
564 
565 pragma solidity >=0.6.2 <0.8.0;
566 
567 /**
568  * @dev Collection of functions related to the address type
569  */
570 library Address {
571     /**
572      * @dev Returns true if `account` is a contract.
573      *
574      * [IMPORTANT]
575      * ====
576      * It is unsafe to assume that an address for which this function returns
577      * false is an externally-owned account (EOA) and not a contract.
578      *
579      * Among others, `isContract` will return false for the following
580      * types of addresses:
581      *
582      *  - an externally-owned account
583      *  - a contract in construction
584      *  - an address where a contract will be created
585      *  - an address where a contract lived, but was destroyed
586      * ====
587      */
588     function isContract(address account) internal view returns (bool) {
589         // This method relies on extcodesize, which returns 0 for contracts in
590         // construction, since the code is only stored at the end of the
591         // constructor execution.
592 
593         uint256 size;
594         // solhint-disable-next-line no-inline-assembly
595         assembly { size := extcodesize(account) }
596         return size > 0;
597     }
598 
599     /**
600      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
601      * `recipient`, forwarding all available gas and reverting on errors.
602      *
603      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
604      * of certain opcodes, possibly making contracts go over the 2300 gas limit
605      * imposed by `transfer`, making them unable to receive funds via
606      * `transfer`. {sendValue} removes this limitation.
607      *
608      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
609      *
610      * IMPORTANT: because control is transferred to `recipient`, care must be
611      * taken to not create reentrancy vulnerabilities. Consider using
612      * {ReentrancyGuard} or the
613      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
614      */
615     function sendValue(address payable recipient, uint256 amount) internal {
616         require(address(this).balance >= amount, "Address: insufficient balance");
617 
618         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
619         (bool success, ) = recipient.call{ value: amount }("");
620         require(success, "Address: unable to send value, recipient may have reverted");
621     }
622 
623     /**
624      * @dev Performs a Solidity function call using a low level `call`. A
625      * plain`call` is an unsafe replacement for a function call: use this
626      * function instead.
627      *
628      * If `target` reverts with a revert reason, it is bubbled up by this
629      * function (like regular Solidity function calls).
630      *
631      * Returns the raw returned data. To convert to the expected return value,
632      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
633      *
634      * Requirements:
635      *
636      * - `target` must be a contract.
637      * - calling `target` with `data` must not revert.
638      *
639      * _Available since v3.1._
640      */
641     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
642         return functionCall(target, data, "Address: low-level call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
647      * `errorMessage` as a fallback revert reason when `target` reverts.
648      *
649      * _Available since v3.1._
650      */
651     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, 0, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but also transferring `value` wei to `target`.
658      *
659      * Requirements:
660      *
661      * - the calling contract must have an ETH balance of at least `value`.
662      * - the called Solidity function must be `payable`.
663      *
664      * _Available since v3.1._
665      */
666     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
667         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
672      * with `errorMessage` as a fallback revert reason when `target` reverts.
673      *
674      * _Available since v3.1._
675      */
676     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
677         require(address(this).balance >= value, "Address: insufficient balance for call");
678         require(isContract(target), "Address: call to non-contract");
679 
680         // solhint-disable-next-line avoid-low-level-calls
681         (bool success, bytes memory returndata) = target.call{ value: value }(data);
682         return _verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
687      * but performing a static call.
688      *
689      * _Available since v3.3._
690      */
691     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
692         return functionStaticCall(target, data, "Address: low-level static call failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
697      * but performing a static call.
698      *
699      * _Available since v3.3._
700      */
701     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
702         require(isContract(target), "Address: static call to non-contract");
703 
704         // solhint-disable-next-line avoid-low-level-calls
705         (bool success, bytes memory returndata) = target.staticcall(data);
706         return _verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
711      * but performing a delegate call.
712      *
713      * _Available since v3.4._
714      */
715     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
716         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
721      * but performing a delegate call.
722      *
723      * _Available since v3.4._
724      */
725     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
726         require(isContract(target), "Address: delegate call to non-contract");
727 
728         // solhint-disable-next-line avoid-low-level-calls
729         (bool success, bytes memory returndata) = target.delegatecall(data);
730         return _verifyCallResult(success, returndata, errorMessage);
731     }
732 
733     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
734         if (success) {
735             return returndata;
736         } else {
737             // Look for revert reason and bubble it up if present
738             if (returndata.length > 0) {
739                 // The easiest way to bubble the revert reason is using memory via assembly
740 
741                 // solhint-disable-next-line no-inline-assembly
742                 assembly {
743                     let returndata_size := mload(returndata)
744                     revert(add(32, returndata), returndata_size)
745                 }
746             } else {
747                 revert(errorMessage);
748             }
749         }
750     }
751 }
752 
753 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
754 
755 
756 
757 pragma solidity >=0.6.0 <0.8.0;
758 
759 /**
760  * @dev Library for managing
761  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
762  * types.
763  *
764  * Sets have the following properties:
765  *
766  * - Elements are added, removed, and checked for existence in constant time
767  * (O(1)).
768  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
769  *
770  * ```
771  * contract Example {
772  *     // Add the library methods
773  *     using EnumerableSet for EnumerableSet.AddressSet;
774  *
775  *     // Declare a set state variable
776  *     EnumerableSet.AddressSet private mySet;
777  * }
778  * ```
779  *
780  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
781  * and `uint256` (`UintSet`) are supported.
782  */
783 library EnumerableSet {
784     // To implement this library for multiple types with as little code
785     // repetition as possible, we write it in terms of a generic Set type with
786     // bytes32 values.
787     // The Set implementation uses private functions, and user-facing
788     // implementations (such as AddressSet) are just wrappers around the
789     // underlying Set.
790     // This means that we can only create new EnumerableSets for types that fit
791     // in bytes32.
792 
793     struct Set {
794         // Storage of set values
795         bytes32[] _values;
796 
797         // Position of the value in the `values` array, plus 1 because index 0
798         // means a value is not in the set.
799         mapping (bytes32 => uint256) _indexes;
800     }
801 
802     /**
803      * @dev Add a value to a set. O(1).
804      *
805      * Returns true if the value was added to the set, that is if it was not
806      * already present.
807      */
808     function _add(Set storage set, bytes32 value) private returns (bool) {
809         if (!_contains(set, value)) {
810             set._values.push(value);
811             // The value is stored at length-1, but we add 1 to all indexes
812             // and use 0 as a sentinel value
813             set._indexes[value] = set._values.length;
814             return true;
815         } else {
816             return false;
817         }
818     }
819 
820     /**
821      * @dev Removes a value from a set. O(1).
822      *
823      * Returns true if the value was removed from the set, that is if it was
824      * present.
825      */
826     function _remove(Set storage set, bytes32 value) private returns (bool) {
827         // We read and store the value's index to prevent multiple reads from the same storage slot
828         uint256 valueIndex = set._indexes[value];
829 
830         if (valueIndex != 0) { // Equivalent to contains(set, value)
831             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
832             // the array, and then remove the last element (sometimes called as 'swap and pop').
833             // This modifies the order of the array, as noted in {at}.
834 
835             uint256 toDeleteIndex = valueIndex - 1;
836             uint256 lastIndex = set._values.length - 1;
837 
838             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
839             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
840 
841             bytes32 lastvalue = set._values[lastIndex];
842 
843             // Move the last value to the index where the value to delete is
844             set._values[toDeleteIndex] = lastvalue;
845             // Update the index for the moved value
846             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
847 
848             // Delete the slot where the moved value was stored
849             set._values.pop();
850 
851             // Delete the index for the deleted slot
852             delete set._indexes[value];
853 
854             return true;
855         } else {
856             return false;
857         }
858     }
859 
860     /**
861      * @dev Returns true if the value is in the set. O(1).
862      */
863     function _contains(Set storage set, bytes32 value) private view returns (bool) {
864         return set._indexes[value] != 0;
865     }
866 
867     /**
868      * @dev Returns the number of values on the set. O(1).
869      */
870     function _length(Set storage set) private view returns (uint256) {
871         return set._values.length;
872     }
873 
874     /**
875      * @dev Returns the value stored at position `index` in the set. O(1).
876      *
877      * Note that there are no guarantees on the ordering of values inside the
878      * array, and it may change when more values are added or removed.
879      *
880      * Requirements:
881      *
882      * - `index` must be strictly less than {length}.
883      */
884     function _at(Set storage set, uint256 index) private view returns (bytes32) {
885         require(set._values.length > index, "EnumerableSet: index out of bounds");
886         return set._values[index];
887     }
888 
889     // Bytes32Set
890 
891     struct Bytes32Set {
892         Set _inner;
893     }
894 
895     /**
896      * @dev Add a value to a set. O(1).
897      *
898      * Returns true if the value was added to the set, that is if it was not
899      * already present.
900      */
901     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
902         return _add(set._inner, value);
903     }
904 
905     /**
906      * @dev Removes a value from a set. O(1).
907      *
908      * Returns true if the value was removed from the set, that is if it was
909      * present.
910      */
911     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
912         return _remove(set._inner, value);
913     }
914 
915     /**
916      * @dev Returns true if the value is in the set. O(1).
917      */
918     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
919         return _contains(set._inner, value);
920     }
921 
922     /**
923      * @dev Returns the number of values in the set. O(1).
924      */
925     function length(Bytes32Set storage set) internal view returns (uint256) {
926         return _length(set._inner);
927     }
928 
929     /**
930      * @dev Returns the value stored at position `index` in the set. O(1).
931      *
932      * Note that there are no guarantees on the ordering of values inside the
933      * array, and it may change when more values are added or removed.
934      *
935      * Requirements:
936      *
937      * - `index` must be strictly less than {length}.
938      */
939     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
940         return _at(set._inner, index);
941     }
942 
943     // AddressSet
944 
945     struct AddressSet {
946         Set _inner;
947     }
948 
949     /**
950      * @dev Add a value to a set. O(1).
951      *
952      * Returns true if the value was added to the set, that is if it was not
953      * already present.
954      */
955     function add(AddressSet storage set, address value) internal returns (bool) {
956         return _add(set._inner, bytes32(uint256(uint160(value))));
957     }
958 
959     /**
960      * @dev Removes a value from a set. O(1).
961      *
962      * Returns true if the value was removed from the set, that is if it was
963      * present.
964      */
965     function remove(AddressSet storage set, address value) internal returns (bool) {
966         return _remove(set._inner, bytes32(uint256(uint160(value))));
967     }
968 
969     /**
970      * @dev Returns true if the value is in the set. O(1).
971      */
972     function contains(AddressSet storage set, address value) internal view returns (bool) {
973         return _contains(set._inner, bytes32(uint256(uint160(value))));
974     }
975 
976     /**
977      * @dev Returns the number of values in the set. O(1).
978      */
979     function length(AddressSet storage set) internal view returns (uint256) {
980         return _length(set._inner);
981     }
982 
983     /**
984      * @dev Returns the value stored at position `index` in the set. O(1).
985      *
986      * Note that there are no guarantees on the ordering of values inside the
987      * array, and it may change when more values are added or removed.
988      *
989      * Requirements:
990      *
991      * - `index` must be strictly less than {length}.
992      */
993     function at(AddressSet storage set, uint256 index) internal view returns (address) {
994         return address(uint160(uint256(_at(set._inner, index))));
995     }
996 
997 
998     // UintSet
999 
1000     struct UintSet {
1001         Set _inner;
1002     }
1003 
1004     /**
1005      * @dev Add a value to a set. O(1).
1006      *
1007      * Returns true if the value was added to the set, that is if it was not
1008      * already present.
1009      */
1010     function add(UintSet storage set, uint256 value) internal returns (bool) {
1011         return _add(set._inner, bytes32(value));
1012     }
1013 
1014     /**
1015      * @dev Removes a value from a set. O(1).
1016      *
1017      * Returns true if the value was removed from the set, that is if it was
1018      * present.
1019      */
1020     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1021         return _remove(set._inner, bytes32(value));
1022     }
1023 
1024     /**
1025      * @dev Returns true if the value is in the set. O(1).
1026      */
1027     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1028         return _contains(set._inner, bytes32(value));
1029     }
1030 
1031     /**
1032      * @dev Returns the number of values on the set. O(1).
1033      */
1034     function length(UintSet storage set) internal view returns (uint256) {
1035         return _length(set._inner);
1036     }
1037 
1038     /**
1039      * @dev Returns the value stored at position `index` in the set. O(1).
1040      *
1041      * Note that there are no guarantees on the ordering of values inside the
1042      * array, and it may change when more values are added or removed.
1043      *
1044      * Requirements:
1045      *
1046      * - `index` must be strictly less than {length}.
1047      */
1048     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1049         return uint256(_at(set._inner, index));
1050     }
1051 }
1052 
1053 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1054 
1055 
1056 
1057 pragma solidity >=0.6.0 <0.8.0;
1058 
1059 /**
1060  * @dev Library for managing an enumerable variant of Solidity's
1061  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1062  * type.
1063  *
1064  * Maps have the following properties:
1065  *
1066  * - Entries are added, removed, and checked for existence in constant time
1067  * (O(1)).
1068  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1069  *
1070  * ```
1071  * contract Example {
1072  *     // Add the library methods
1073  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1074  *
1075  *     // Declare a set state variable
1076  *     EnumerableMap.UintToAddressMap private myMap;
1077  * }
1078  * ```
1079  *
1080  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1081  * supported.
1082  */
1083 library EnumerableMap {
1084     // To implement this library for multiple types with as little code
1085     // repetition as possible, we write it in terms of a generic Map type with
1086     // bytes32 keys and values.
1087     // The Map implementation uses private functions, and user-facing
1088     // implementations (such as Uint256ToAddressMap) are just wrappers around
1089     // the underlying Map.
1090     // This means that we can only create new EnumerableMaps for types that fit
1091     // in bytes32.
1092 
1093     struct MapEntry {
1094         bytes32 _key;
1095         bytes32 _value;
1096     }
1097 
1098     struct Map {
1099         // Storage of map keys and values
1100         MapEntry[] _entries;
1101 
1102         // Position of the entry defined by a key in the `entries` array, plus 1
1103         // because index 0 means a key is not in the map.
1104         mapping (bytes32 => uint256) _indexes;
1105     }
1106 
1107     /**
1108      * @dev Adds a key-value pair to a map, or updates the value for an existing
1109      * key. O(1).
1110      *
1111      * Returns true if the key was added to the map, that is if it was not
1112      * already present.
1113      */
1114     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1115         // We read and store the key's index to prevent multiple reads from the same storage slot
1116         uint256 keyIndex = map._indexes[key];
1117 
1118         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1119             map._entries.push(MapEntry({ _key: key, _value: value }));
1120             // The entry is stored at length-1, but we add 1 to all indexes
1121             // and use 0 as a sentinel value
1122             map._indexes[key] = map._entries.length;
1123             return true;
1124         } else {
1125             map._entries[keyIndex - 1]._value = value;
1126             return false;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Removes a key-value pair from a map. O(1).
1132      *
1133      * Returns true if the key was removed from the map, that is if it was present.
1134      */
1135     function _remove(Map storage map, bytes32 key) private returns (bool) {
1136         // We read and store the key's index to prevent multiple reads from the same storage slot
1137         uint256 keyIndex = map._indexes[key];
1138 
1139         if (keyIndex != 0) { // Equivalent to contains(map, key)
1140             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1141             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1142             // This modifies the order of the array, as noted in {at}.
1143 
1144             uint256 toDeleteIndex = keyIndex - 1;
1145             uint256 lastIndex = map._entries.length - 1;
1146 
1147             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1148             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1149 
1150             MapEntry storage lastEntry = map._entries[lastIndex];
1151 
1152             // Move the last entry to the index where the entry to delete is
1153             map._entries[toDeleteIndex] = lastEntry;
1154             // Update the index for the moved entry
1155             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1156 
1157             // Delete the slot where the moved entry was stored
1158             map._entries.pop();
1159 
1160             // Delete the index for the deleted slot
1161             delete map._indexes[key];
1162 
1163             return true;
1164         } else {
1165             return false;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Returns true if the key is in the map. O(1).
1171      */
1172     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1173         return map._indexes[key] != 0;
1174     }
1175 
1176     /**
1177      * @dev Returns the number of key-value pairs in the map. O(1).
1178      */
1179     function _length(Map storage map) private view returns (uint256) {
1180         return map._entries.length;
1181     }
1182 
1183     /**
1184      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1185      *
1186      * Note that there are no guarantees on the ordering of entries inside the
1187      * array, and it may change when more entries are added or removed.
1188      *
1189      * Requirements:
1190      *
1191      * - `index` must be strictly less than {length}.
1192      */
1193     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1194         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1195 
1196         MapEntry storage entry = map._entries[index];
1197         return (entry._key, entry._value);
1198     }
1199 
1200     /**
1201      * @dev Tries to returns the value associated with `key`.  O(1).
1202      * Does not revert if `key` is not in the map.
1203      */
1204     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1205         uint256 keyIndex = map._indexes[key];
1206         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1207         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1208     }
1209 
1210     /**
1211      * @dev Returns the value associated with `key`.  O(1).
1212      *
1213      * Requirements:
1214      *
1215      * - `key` must be in the map.
1216      */
1217     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1218         uint256 keyIndex = map._indexes[key];
1219         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1220         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1221     }
1222 
1223     /**
1224      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1225      *
1226      * CAUTION: This function is deprecated because it requires allocating memory for the error
1227      * message unnecessarily. For custom revert reasons use {_tryGet}.
1228      */
1229     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1230         uint256 keyIndex = map._indexes[key];
1231         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1232         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1233     }
1234 
1235     // UintToAddressMap
1236 
1237     struct UintToAddressMap {
1238         Map _inner;
1239     }
1240 
1241     /**
1242      * @dev Adds a key-value pair to a map, or updates the value for an existing
1243      * key. O(1).
1244      *
1245      * Returns true if the key was added to the map, that is if it was not
1246      * already present.
1247      */
1248     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1249         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1250     }
1251 
1252     /**
1253      * @dev Removes a value from a set. O(1).
1254      *
1255      * Returns true if the key was removed from the map, that is if it was present.
1256      */
1257     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1258         return _remove(map._inner, bytes32(key));
1259     }
1260 
1261     /**
1262      * @dev Returns true if the key is in the map. O(1).
1263      */
1264     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1265         return _contains(map._inner, bytes32(key));
1266     }
1267 
1268     /**
1269      * @dev Returns the number of elements in the map. O(1).
1270      */
1271     function length(UintToAddressMap storage map) internal view returns (uint256) {
1272         return _length(map._inner);
1273     }
1274 
1275     /**
1276      * @dev Returns the element stored at position `index` in the set. O(1).
1277      * Note that there are no guarantees on the ordering of values inside the
1278      * array, and it may change when more values are added or removed.
1279      *
1280      * Requirements:
1281      *
1282      * - `index` must be strictly less than {length}.
1283      */
1284     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1285         (bytes32 key, bytes32 value) = _at(map._inner, index);
1286         return (uint256(key), address(uint160(uint256(value))));
1287     }
1288 
1289     /**
1290      * @dev Tries to returns the value associated with `key`.  O(1).
1291      * Does not revert if `key` is not in the map.
1292      *
1293      * _Available since v3.4._
1294      */
1295     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1296         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1297         return (success, address(uint160(uint256(value))));
1298     }
1299 
1300     /**
1301      * @dev Returns the value associated with `key`.  O(1).
1302      *
1303      * Requirements:
1304      *
1305      * - `key` must be in the map.
1306      */
1307     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1308         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1309     }
1310 
1311     /**
1312      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1313      *
1314      * CAUTION: This function is deprecated because it requires allocating memory for the error
1315      * message unnecessarily. For custom revert reasons use {tryGet}.
1316      */
1317     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1318         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1319     }
1320 }
1321 
1322 // File: @openzeppelin/contracts/utils/Strings.sol
1323 
1324 
1325 
1326 pragma solidity >=0.6.0 <0.8.0;
1327 
1328 /**
1329  * @dev String operations.
1330  */
1331 library Strings {
1332     /**
1333      * @dev Converts a `uint256` to its ASCII `string` representation.
1334      */
1335     function toString(uint256 value) internal pure returns (string memory) {
1336         // Inspired by OraclizeAPI's implementation - MIT licence
1337         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1338 
1339         if (value == 0) {
1340             return "0";
1341         }
1342         uint256 temp = value;
1343         uint256 digits;
1344         while (temp != 0) {
1345             digits++;
1346             temp /= 10;
1347         }
1348         bytes memory buffer = new bytes(digits);
1349         uint256 index = digits - 1;
1350         temp = value;
1351         while (temp != 0) {
1352             buffer[index--] = bytes1(uint8(48 + temp % 10));
1353             temp /= 10;
1354         }
1355         return string(buffer);
1356     }
1357 }
1358 
1359 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1360 
1361 
1362 
1363 pragma solidity >=0.6.0 <0.8.0;
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 
1374 
1375 
1376 /**
1377  * @title ERC721 Non-Fungible Token Standard basic implementation
1378  * @dev see https://eips.ethereum.org/EIPS/eip-721
1379  */
1380 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1381     using SafeMath for uint256;
1382     using Address for address;
1383     using EnumerableSet for EnumerableSet.UintSet;
1384     using EnumerableMap for EnumerableMap.UintToAddressMap;
1385     using Strings for uint256;
1386 
1387     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1388     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1389     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1390 
1391     // Mapping from holder address to their (enumerable) set of owned tokens
1392     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1393 
1394     // Enumerable mapping from token ids to their owners
1395     EnumerableMap.UintToAddressMap private _tokenOwners;
1396 
1397     // Mapping from token ID to approved address
1398     mapping (uint256 => address) private _tokenApprovals;
1399 
1400     // Mapping from owner to operator approvals
1401     mapping (address => mapping (address => bool)) private _operatorApprovals;
1402 
1403     // Token name
1404     string private _name;
1405 
1406     // Token symbol
1407     string private _symbol;
1408 
1409     // Optional mapping for token URIs
1410     mapping (uint256 => string) private _tokenURIs;
1411 
1412     // Base URI
1413     string private _baseURI;
1414 
1415     /*
1416      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1417      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1418      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1419      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1420      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1421      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1422      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1423      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1424      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1425      *
1426      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1427      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1428      */
1429     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1430 
1431     /*
1432      *     bytes4(keccak256('name()')) == 0x06fdde03
1433      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1434      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1435      *
1436      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1437      */
1438     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1439 
1440     /*
1441      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1442      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1443      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1444      *
1445      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1446      */
1447     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1448 
1449     /**
1450      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1451      */
1452     constructor (string memory name_, string memory symbol_) {
1453         _name = name_;
1454         _symbol = symbol_;
1455 
1456         // register the supported interfaces to conform to ERC721 via ERC165
1457         _registerInterface(_INTERFACE_ID_ERC721);
1458         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1459         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-balanceOf}.
1464      */
1465     function balanceOf(address owner) public view virtual override returns (uint256) {
1466         require(owner != address(0), "ERC721: balance query for the zero address");
1467         return _holderTokens[owner].length();
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-ownerOf}.
1472      */
1473     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1474         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Metadata-name}.
1479      */
1480     function name() public view virtual override returns (string memory) {
1481         return _name;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-symbol}.
1486      */
1487     function symbol() public view virtual override returns (string memory) {
1488         return _symbol;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-tokenURI}.
1493      */
1494     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1495         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1496 
1497         string memory _tokenURI = _tokenURIs[tokenId];
1498         string memory base = baseURI();
1499 
1500         // If there is no base URI, return the token URI.
1501         if (bytes(base).length == 0) {
1502             return _tokenURI;
1503         }
1504         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1505         if (bytes(_tokenURI).length > 0) {
1506             return string(abi.encodePacked(base, _tokenURI));
1507         }
1508         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1509         return string(abi.encodePacked(base, tokenId.toString()));
1510     }
1511 
1512     /**
1513     * @dev Returns the base URI set via {_setBaseURI}. This will be
1514     * automatically added as a prefix in {tokenURI} to each token's URI, or
1515     * to the token ID if no specific URI is set for that token ID.
1516     */
1517     function baseURI() public view virtual returns (string memory) {
1518         return _baseURI;
1519     }
1520 
1521     /**
1522      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1523      */
1524     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1525         return _holderTokens[owner].at(index);
1526     }
1527 
1528     /**
1529      * @dev See {IERC721Enumerable-totalSupply}.
1530      */
1531     function totalSupply() public view virtual override returns (uint256) {
1532         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1533         return _tokenOwners.length();
1534     }
1535 
1536     /**
1537      * @dev See {IERC721Enumerable-tokenByIndex}.
1538      */
1539     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1540         (uint256 tokenId, ) = _tokenOwners.at(index);
1541         return tokenId;
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-approve}.
1546      */
1547     function approve(address to, uint256 tokenId) public virtual override {
1548         address owner = ERC721.ownerOf(tokenId);
1549         require(to != owner, "ERC721: approval to current owner");
1550 
1551         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1552             "ERC721: approve caller is not owner nor approved for all"
1553         );
1554 
1555         _approve(to, tokenId);
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-getApproved}.
1560      */
1561     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1562         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1563 
1564         return _tokenApprovals[tokenId];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-setApprovalForAll}.
1569      */
1570     function setApprovalForAll(address operator, bool approved) public virtual override {
1571         require(operator != _msgSender(), "ERC721: approve to caller");
1572 
1573         _operatorApprovals[_msgSender()][operator] = approved;
1574         emit ApprovalForAll(_msgSender(), operator, approved);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-isApprovedForAll}.
1579      */
1580     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1581         return _operatorApprovals[owner][operator];
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-transferFrom}.
1586      */
1587     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1588         //solhint-disable-next-line max-line-length
1589         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1590 
1591         _transfer(from, to, tokenId);
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-safeTransferFrom}.
1596      */
1597     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1598         safeTransferFrom(from, to, tokenId, "");
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-safeTransferFrom}.
1603      */
1604     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1605         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1606         _safeTransfer(from, to, tokenId, _data);
1607     }
1608 
1609     /**
1610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1612      *
1613      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1614      *
1615      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1616      * implement alternative mechanisms to perform token transfer, such as signature-based.
1617      *
1618      * Requirements:
1619      *
1620      * - `from` cannot be the zero address.
1621      * - `to` cannot be the zero address.
1622      * - `tokenId` token must exist and be owned by `from`.
1623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1628         _transfer(from, to, tokenId);
1629         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1630     }
1631 
1632     /**
1633      * @dev Returns whether `tokenId` exists.
1634      *
1635      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1636      *
1637      * Tokens start existing when they are minted (`_mint`),
1638      * and stop existing when they are burned (`_burn`).
1639      */
1640     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1641         return _tokenOwners.contains(tokenId);
1642     }
1643 
1644     /**
1645      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      */
1651     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1652         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1653         address owner = ERC721.ownerOf(tokenId);
1654         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1655     }
1656 
1657     /**
1658      * @dev Safely mints `tokenId` and transfers it to `to`.
1659      *
1660      * Requirements:
1661      d*
1662      * - `tokenId` must not exist.
1663      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _safeMint(address to, uint256 tokenId) internal virtual {
1668         _safeMint(to, tokenId, "");
1669     }
1670 
1671     /**
1672      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1673      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1674      */
1675     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1676         _mint(to, tokenId);
1677         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1678     }
1679 
1680     /**
1681      * @dev Mints `tokenId` and transfers it to `to`.
1682      *
1683      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must not exist.
1688      * - `to` cannot be the zero address.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _mint(address to, uint256 tokenId) internal virtual {
1693         require(to != address(0), "ERC721: mint to the zero address");
1694         require(!_exists(tokenId), "ERC721: token already minted");
1695 
1696         _beforeTokenTransfer(address(0), to, tokenId);
1697 
1698         _holderTokens[to].add(tokenId);
1699 
1700         _tokenOwners.set(tokenId, to);
1701 
1702         emit Transfer(address(0), to, tokenId);
1703     }
1704 
1705     /**
1706      * @dev Destroys `tokenId`.
1707      * The approval is cleared when the token is burned.
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must exist.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _burn(uint256 tokenId) internal virtual {
1716         address owner = ERC721.ownerOf(tokenId); // internal owner
1717 
1718         _beforeTokenTransfer(owner, address(0), tokenId);
1719 
1720         // Clear approvals
1721         _approve(address(0), tokenId);
1722 
1723         // Clear metadata (if any)
1724         if (bytes(_tokenURIs[tokenId]).length != 0) {
1725             delete _tokenURIs[tokenId];
1726         }
1727 
1728         _holderTokens[owner].remove(tokenId);
1729 
1730         _tokenOwners.remove(tokenId);
1731 
1732         emit Transfer(owner, address(0), tokenId);
1733     }
1734 
1735     /**
1736      * @dev Transfers `tokenId` from `from` to `to`.
1737      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1738      *
1739      * Requirements:
1740      *
1741      * - `to` cannot be the zero address.
1742      * - `tokenId` token must be owned by `from`.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1747         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1748         require(to != address(0), "ERC721: transfer to the zero address");
1749 
1750         _beforeTokenTransfer(from, to, tokenId);
1751 
1752         // Clear approvals from the previous owner
1753         _approve(address(0), tokenId);
1754 
1755         _holderTokens[from].remove(tokenId);
1756         _holderTokens[to].add(tokenId);
1757 
1758         _tokenOwners.set(tokenId, to);
1759 
1760         emit Transfer(from, to, tokenId);
1761     }
1762 
1763     /**
1764      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1765      *
1766      * Requirements:
1767      *
1768      * - `tokenId` must exist.
1769      */
1770     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1771         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1772         _tokenURIs[tokenId] = _tokenURI;
1773     }
1774 
1775     /**
1776      * @dev Internal function to set the base URI for all token IDs. It is
1777      * automatically added as a prefix to the value returned in {tokenURI},
1778      * or to the token ID if {tokenURI} is empty.
1779      */
1780     function _setBaseURI(string memory baseURI_) internal virtual {
1781         _baseURI = baseURI_;
1782     }
1783 
1784     /**
1785      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1786      * The call is not executed if the target address is not a contract.
1787      *
1788      * @param from address representing the previous owner of the given token ID
1789      * @param to target address that will receive the tokens
1790      * @param tokenId uint256 ID of the token to be transferred
1791      * @param _data bytes optional data to send along with the call
1792      * @return bool whether the call correctly returned the expected magic value
1793      */
1794     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1795     private returns (bool)
1796     {
1797         if (!to.isContract()) {
1798             return true;
1799         }
1800         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1801                 IERC721Receiver(to).onERC721Received.selector,
1802                 _msgSender(),
1803                 from,
1804                 tokenId,
1805                 _data
1806             ), "ERC721: transfer to non ERC721Receiver implementer");
1807         bytes4 retval = abi.decode(returndata, (bytes4));
1808         return (retval == _ERC721_RECEIVED);
1809     }
1810 
1811     /**
1812      * @dev Approve `to` to operate on `tokenId`
1813      *
1814      * Emits an {Approval} event.
1815      */
1816     function _approve(address to, uint256 tokenId) internal virtual {
1817         _tokenApprovals[tokenId] = to;
1818         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1819     }
1820 
1821     /**
1822      * @dev Hook that is called before any token transfer. This includes minting
1823      * and burning.
1824      *
1825      * Calling conditions:
1826      *
1827      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1828      * transferred to `to`.
1829      * - When `from` is zero, `tokenId` will be minted for `to`.
1830      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1831      * - `from` cannot be the zero address.
1832      * - `to` cannot be the zero address.
1833      *
1834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1835      */
1836     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1837 }
1838 
1839 // File: @openzeppelin/contracts/access/Ownable.sol
1840 
1841 
1842 
1843 pragma solidity >=0.6.0 <0.8.0;
1844 
1845 /**
1846  * @dev Contract module which provides a basic access control mechanism, where
1847  * there is an account (an owner) that can be granted exclusive access to
1848  * specific functions.
1849  *
1850  * By default, the owner account will be the one that deploys the contract. This
1851  * can later be changed with {transferOwnership}.
1852  *
1853  * This module is used through inheritance. It will make available the modifier
1854  * `onlyOwner`, which can be applied to your functions to restrict their use to
1855  * the owner.
1856  */
1857 abstract contract Ownable is Context {
1858     address private _owner;
1859 
1860     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1861 
1862     /**
1863      * @dev Initializes the contract setting the deployer as the initial owner.
1864      */
1865     constructor () {
1866         address msgSender = _msgSender();
1867         _owner = msgSender;
1868         emit OwnershipTransferred(address(0), msgSender);
1869     }
1870 
1871     /**
1872      * @dev Returns the address of the current owner.
1873      */
1874     function owner() public view virtual returns (address) {
1875         return _owner;
1876     }
1877 
1878     /**
1879      * @dev Throws if called by any account other than the owner.
1880      */
1881     modifier onlyOwner() {
1882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1883         _;
1884     }
1885 
1886     /**
1887      * @dev Leaves the contract without owner. It will not be possible to call
1888      * `onlyOwner` functions anymore. Can only be called by the current owner.
1889      *
1890      * NOTE: Renouncing ownership will leave the contract without an owner,
1891      * thereby removing any functionality that is only available to the owner.
1892      */
1893     function renounceOwnership() public virtual onlyOwner {
1894         emit OwnershipTransferred(_owner, address(0));
1895         _owner = address(0);
1896     }
1897 
1898     /**
1899      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1900      * Can only be called by the current owner.
1901      */
1902     function transferOwnership(address newOwner) public virtual onlyOwner {
1903         require(newOwner != address(0), "Ownable: new owner is the zero address");
1904         emit OwnershipTransferred(_owner, newOwner);
1905         _owner = newOwner;
1906     }
1907 }
1908 
1909 // File: contracts/RaccoonMafia.sol
1910 
1911 pragma solidity 0.7.0;
1912 
1913 /**
1914  * @title RaccoonMafia contract
1915  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1916  */
1917 contract RaccoonMafia is ERC721, Ownable {
1918     using SafeMath for uint256;
1919 
1920     uint256 public raccoonPrice = 50000000000000000; // 0.05 ETH
1921     uint256 public maxRaccoonPurchase = 20;
1922     uint256 public maxRaccoons = 10000;
1923 
1924     bool public saleIsActive = false;
1925     bool public reserved = false;
1926 
1927     event RaccoonPriceChanged(uint256 price);
1928     event MaxTokenAmountChanged(uint256 value);
1929     event MaxPurchaseChanged(uint256 value);
1930     event RaccoonsReserved();
1931     event RolledOver(bool status);
1932 
1933     constructor() ERC721("Raccoon Mafia", "RM") { }
1934 
1935     function withdraw() public onlyOwner {
1936         uint balance = address(this).balance;
1937         Address.sendValue(_msgSender(), balance);
1938     }
1939 
1940     function reserveRaccoons() public onlyOwner onReserve {
1941         uint supply = totalSupply();
1942         uint i;
1943         for (i; i < 100; i++) {
1944             _safeMint(_msgSender(), supply + i);
1945         }
1946     }
1947 
1948     function flipSaleState() public onlyOwner {
1949         saleIsActive = !saleIsActive;
1950         emit RolledOver(saleIsActive);
1951     }
1952 
1953     function setBaseURI(string memory baseURI) public onlyOwner {
1954         _setBaseURI(baseURI);
1955     }
1956 
1957     function mintRaccoons(uint numberOfTokens) public payable {
1958         require(saleIsActive, "Sale is not active");
1959         require(numberOfTokens <= maxRaccoonPurchase, "Exceeds max number of Raccoons in one transaction");
1960         require(totalSupply().add(numberOfTokens) <= maxRaccoons, "Purchase would exceed max supply of Raccoons");
1961         require(raccoonPrice.mul(numberOfTokens) == msg.value, "Ether value sent is not correct");
1962 
1963         uint i;
1964         uint mintIndex;
1965         for (i; i < numberOfTokens; i++) {
1966             mintIndex = totalSupply();
1967             if (totalSupply() < maxRaccoons) {
1968                 _safeMint(_msgSender(), mintIndex);
1969             }
1970         }
1971     }
1972 
1973     function setPrice(uint256 _price) external onlyOwner {
1974         require(_price > 0, "Zero price");
1975 
1976         raccoonPrice = _price;
1977         emit RaccoonPriceChanged(_price);
1978     }
1979 
1980     function setMaxTokenAmount(uint256 _value) external onlyOwner {
1981         require(
1982             _value > totalSupply() && _value <= 10_000,
1983             "Wrong value for max supply"
1984         );
1985 
1986         maxRaccoons = _value;
1987         emit MaxTokenAmountChanged(_value);
1988     }
1989 
1990     function setMaxPurchase(uint256 _value) external onlyOwner {
1991         require(_value > 0, "Very low value");
1992 
1993         maxRaccoonPurchase = _value;
1994         emit MaxPurchaseChanged(_value);
1995     }
1996 
1997     modifier onReserve() {
1998         require(!reserved, "Tokens reserved");
1999         _;
2000         reserved = true;
2001         emit RaccoonsReserved();
2002     }
2003 
2004 }