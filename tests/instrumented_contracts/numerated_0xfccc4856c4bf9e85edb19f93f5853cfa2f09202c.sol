1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
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
55 pragma solidity >=0.6.2 <0.8.0;
56 
57 /**
58  * @dev Required interface of an ERC721 compliant contract.
59  */
60 interface IERC721 is IERC165 {
61     /**
62      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
68      */
69     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
73      */
74     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
75 
76     /**
77      * @dev Returns the number of tokens in ``owner``'s account.
78      */
79     function balanceOf(address owner) external view returns (uint256 balance);
80 
81     /**
82      * @dev Returns the owner of the `tokenId` token.
83      *
84      * Requirements:
85      *
86      * - `tokenId` must exist.
87      */
88     function ownerOf(uint256 tokenId) external view returns (address owner);
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(address from, address to, uint256 tokenId) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address from, address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId) external view returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator) external view returns (bool);
164 
165     /**
166       * @dev Safely transfers `tokenId` token from `from` to `to`.
167       *
168       * Requirements:
169       *
170       * - `from` cannot be the zero address.
171       * - `to` cannot be the zero address.
172       * - `tokenId` token must exist and be owned by `from`.
173       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175       *
176       * Emits a {Transfer} event.
177       */
178     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
179 }
180 
181 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
182 
183 pragma solidity >=0.6.2 <0.8.0;
184 
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Metadata is IERC721 {
190 
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
208 
209 pragma solidity >=0.6.2 <0.8.0;
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Enumerable is IERC721 {
216 
217     /**
218      * @dev Returns the total amount of tokens stored by the contract.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     /**
223      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
224      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
225      */
226     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
227 
228     /**
229      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
230      * Use along with {totalSupply} to enumerate all tokens.
231      */
232     function tokenByIndex(uint256 index) external view returns (uint256);
233 }
234 
235 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
236 
237 pragma solidity >=0.6.0 <0.8.0;
238 
239 /**
240  * @title ERC721 token receiver interface
241  * @dev Interface for any contract that wants to support safeTransfers
242  * from ERC721 asset contracts.
243  */
244 interface IERC721Receiver {
245     /**
246      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
247      * by `operator` from `from`, this function is called.
248      *
249      * It must return its Solidity selector to confirm the token transfer.
250      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
251      *
252      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
253      */
254     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
255 }
256 
257 // File: @openzeppelin/contracts/introspection/ERC165.sol
258 
259 pragma solidity >=0.6.0 <0.8.0;
260 
261 /**
262  * @dev Implementation of the {IERC165} interface.
263  *
264  * Contracts may inherit from this and call {_registerInterface} to declare
265  * their support of an interface.
266  */
267 abstract contract ERC165 is IERC165 {
268     /*
269      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
270      */
271     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
272 
273     /**
274      * @dev Mapping of interface ids to whether or not it's supported.
275      */
276     mapping(bytes4 => bool) private _supportedInterfaces;
277 
278     constructor () internal {
279         // Derived contracts need only register support for their own interfaces,
280         // we register support for ERC165 itself here
281         _registerInterface(_INTERFACE_ID_ERC165);
282     }
283 
284     /**
285      * @dev See {IERC165-supportsInterface}.
286      *
287      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
290         return _supportedInterfaces[interfaceId];
291     }
292 
293     /**
294      * @dev Registers the contract as an implementer of the interface defined by
295      * `interfaceId`. Support of the actual ERC165 interface is automatic and
296      * registering its interface id is not required.
297      *
298      * See {IERC165-supportsInterface}.
299      *
300      * Requirements:
301      *
302      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
303      */
304     function _registerInterface(bytes4 interfaceId) internal virtual {
305         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
306         _supportedInterfaces[interfaceId] = true;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/math/SafeMath.sol
311 
312 pragma solidity >=0.6.0 <0.8.0;
313 
314 /**
315  * @dev Wrappers over Solidity's arithmetic operations with added overflow
316  * checks.
317  *
318  * Arithmetic operations in Solidity wrap on overflow. This can easily result
319  * in bugs, because programmers usually assume that an overflow raises an
320  * error, which is the standard behavior in high level programming languages.
321  * `SafeMath` restores this intuition by reverting the transaction when an
322  * operation overflows.
323  *
324  * Using this library instead of the unchecked operations eliminates an entire
325  * class of bugs, so it's recommended to use it always.
326  */
327 library SafeMath {
328     /**
329      * @dev Returns the addition of two unsigned integers, with an overflow flag.
330      *
331      * _Available since v3.4._
332      */
333     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
334         uint256 c = a + b;
335         if (c < a) return (false, 0);
336         return (true, c);
337     }
338 
339     /**
340      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
341      *
342      * _Available since v3.4._
343      */
344     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
345         if (b > a) return (false, 0);
346         return (true, a - b);
347     }
348 
349     /**
350      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
351      *
352      * _Available since v3.4._
353      */
354     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
356         // benefit is lost if 'b' is also tested.
357         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
358         if (a == 0) return (true, 0);
359         uint256 c = a * b;
360         if (c / a != b) return (false, 0);
361         return (true, c);
362     }
363 
364     /**
365      * @dev Returns the division of two unsigned integers, with a division by zero flag.
366      *
367      * _Available since v3.4._
368      */
369     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         if (b == 0) return (false, 0);
371         return (true, a / b);
372     }
373 
374     /**
375      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
376      *
377      * _Available since v3.4._
378      */
379     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
380         if (b == 0) return (false, 0);
381         return (true, a % b);
382     }
383 
384     /**
385      * @dev Returns the addition of two unsigned integers, reverting on
386      * overflow.
387      *
388      * Counterpart to Solidity's `+` operator.
389      *
390      * Requirements:
391      *
392      * - Addition cannot overflow.
393      */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         require(c >= a, "SafeMath: addition overflow");
397         return c;
398     }
399 
400     /**
401      * @dev Returns the subtraction of two unsigned integers, reverting on
402      * overflow (when the result is negative).
403      *
404      * Counterpart to Solidity's `-` operator.
405      *
406      * Requirements:
407      *
408      * - Subtraction cannot overflow.
409      */
410     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411         require(b <= a, "SafeMath: subtraction overflow");
412         return a - b;
413     }
414 
415     /**
416      * @dev Returns the multiplication of two unsigned integers, reverting on
417      * overflow.
418      *
419      * Counterpart to Solidity's `*` operator.
420      *
421      * Requirements:
422      *
423      * - Multiplication cannot overflow.
424      */
425     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
426         if (a == 0) return 0;
427         uint256 c = a * b;
428         require(c / a == b, "SafeMath: multiplication overflow");
429         return c;
430     }
431 
432     /**
433      * @dev Returns the integer division of two unsigned integers, reverting on
434      * division by zero. The result is rounded towards zero.
435      *
436      * Counterpart to Solidity's `/` operator. Note: this function uses a
437      * `revert` opcode (which leaves remaining gas untouched) while Solidity
438      * uses an invalid opcode to revert (consuming all remaining gas).
439      *
440      * Requirements:
441      *
442      * - The divisor cannot be zero.
443      */
444     function div(uint256 a, uint256 b) internal pure returns (uint256) {
445         require(b > 0, "SafeMath: division by zero");
446         return a / b;
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * reverting when dividing by zero.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
462         require(b > 0, "SafeMath: modulo by zero");
463         return a % b;
464     }
465 
466     /**
467      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
468      * overflow (when the result is negative).
469      *
470      * CAUTION: This function is deprecated because it requires allocating memory for the error
471      * message unnecessarily. For custom revert reasons use {trySub}.
472      *
473      * Counterpart to Solidity's `-` operator.
474      *
475      * Requirements:
476      *
477      * - Subtraction cannot overflow.
478      */
479     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         require(b <= a, errorMessage);
481         return a - b;
482     }
483 
484     /**
485      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
486      * division by zero. The result is rounded towards zero.
487      *
488      * CAUTION: This function is deprecated because it requires allocating memory for the error
489      * message unnecessarily. For custom revert reasons use {tryDiv}.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b > 0, errorMessage);
501         return a / b;
502     }
503 
504     /**
505      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
506      * reverting with custom message when dividing by zero.
507      *
508      * CAUTION: This function is deprecated because it requires allocating memory for the error
509      * message unnecessarily. For custom revert reasons use {tryMod}.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
520         require(b > 0, errorMessage);
521         return a % b;
522     }
523 }
524 
525 // File: @openzeppelin/contracts/utils/Address.sol
526 
527 pragma solidity >=0.6.2 <0.8.0;
528 
529 /**
530  * @dev Collection of functions related to the address type
531  */
532 library Address {
533     /**
534      * @dev Returns true if `account` is a contract.
535      *
536      * [IMPORTANT]
537      * ====
538      * It is unsafe to assume that an address for which this function returns
539      * false is an externally-owned account (EOA) and not a contract.
540      *
541      * Among others, `isContract` will return false for the following
542      * types of addresses:
543      *
544      *  - an externally-owned account
545      *  - a contract in construction
546      *  - an address where a contract will be created
547      *  - an address where a contract lived, but was destroyed
548      * ====
549      */
550     function isContract(address account) internal view returns (bool) {
551         // This method relies on extcodesize, which returns 0 for contracts in
552         // construction, since the code is only stored at the end of the
553         // constructor execution.
554 
555         uint256 size;
556         // solhint-disable-next-line no-inline-assembly
557         assembly { size := extcodesize(account) }
558         return size > 0;
559     }
560 
561     /**
562      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
563      * `recipient`, forwarding all available gas and reverting on errors.
564      *
565      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
566      * of certain opcodes, possibly making contracts go over the 2300 gas limit
567      * imposed by `transfer`, making them unable to receive funds via
568      * `transfer`. {sendValue} removes this limitation.
569      *
570      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
571      *
572      * IMPORTANT: because control is transferred to `recipient`, care must be
573      * taken to not create reentrancy vulnerabilities. Consider using
574      * {ReentrancyGuard} or the
575      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
576      */
577     function sendValue(address payable recipient, uint256 amount) internal {
578         require(address(this).balance >= amount, "Address: insufficient balance");
579 
580         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
581         (bool success, ) = recipient.call{ value: amount }("");
582         require(success, "Address: unable to send value, recipient may have reverted");
583     }
584 
585     /**
586      * @dev Performs a Solidity function call using a low level `call`. A
587      * plain`call` is an unsafe replacement for a function call: use this
588      * function instead.
589      *
590      * If `target` reverts with a revert reason, it is bubbled up by this
591      * function (like regular Solidity function calls).
592      *
593      * Returns the raw returned data. To convert to the expected return value,
594      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
595      *
596      * Requirements:
597      *
598      * - `target` must be a contract.
599      * - calling `target` with `data` must not revert.
600      *
601      * _Available since v3.1._
602      */
603     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
604       return functionCall(target, data, "Address: low-level call failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
609      * `errorMessage` as a fallback revert reason when `target` reverts.
610      *
611      * _Available since v3.1._
612      */
613     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, 0, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but also transferring `value` wei to `target`.
620      *
621      * Requirements:
622      *
623      * - the calling contract must have an ETH balance of at least `value`.
624      * - the called Solidity function must be `payable`.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
629         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
634      * with `errorMessage` as a fallback revert reason when `target` reverts.
635      *
636      * _Available since v3.1._
637      */
638     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
639         require(address(this).balance >= value, "Address: insufficient balance for call");
640         require(isContract(target), "Address: call to non-contract");
641 
642         // solhint-disable-next-line avoid-low-level-calls
643         (bool success, bytes memory returndata) = target.call{ value: value }(data);
644         return _verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but performing a static call.
650      *
651      * _Available since v3.3._
652      */
653     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
654         return functionStaticCall(target, data, "Address: low-level static call failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a static call.
660      *
661      * _Available since v3.3._
662      */
663     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
664         require(isContract(target), "Address: static call to non-contract");
665 
666         // solhint-disable-next-line avoid-low-level-calls
667         (bool success, bytes memory returndata) = target.staticcall(data);
668         return _verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a delegate call.
674      *
675      * _Available since v3.4._
676      */
677     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
678         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a delegate call.
684      *
685      * _Available since v3.4._
686      */
687     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
688         require(isContract(target), "Address: delegate call to non-contract");
689 
690         // solhint-disable-next-line avoid-low-level-calls
691         (bool success, bytes memory returndata) = target.delegatecall(data);
692         return _verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
696         if (success) {
697             return returndata;
698         } else {
699             // Look for revert reason and bubble it up if present
700             if (returndata.length > 0) {
701                 // The easiest way to bubble the revert reason is using memory via assembly
702 
703                 // solhint-disable-next-line no-inline-assembly
704                 assembly {
705                     let returndata_size := mload(returndata)
706                     revert(add(32, returndata), returndata_size)
707                 }
708             } else {
709                 revert(errorMessage);
710             }
711         }
712     }
713 }
714 
715 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
716 
717 pragma solidity >=0.6.0 <0.8.0;
718 
719 /**
720  * @dev Library for managing
721  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
722  * types.
723  *
724  * Sets have the following properties:
725  *
726  * - Elements are added, removed, and checked for existence in constant time
727  * (O(1)).
728  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
729  *
730  * ```
731  * contract Example {
732  *     // Add the library methods
733  *     using EnumerableSet for EnumerableSet.AddressSet;
734  *
735  *     // Declare a set state variable
736  *     EnumerableSet.AddressSet private mySet;
737  * }
738  * ```
739  *
740  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
741  * and `uint256` (`UintSet`) are supported.
742  */
743 library EnumerableSet {
744     // To implement this library for multiple types with as little code
745     // repetition as possible, we write it in terms of a generic Set type with
746     // bytes32 values.
747     // The Set implementation uses private functions, and user-facing
748     // implementations (such as AddressSet) are just wrappers around the
749     // underlying Set.
750     // This means that we can only create new EnumerableSets for types that fit
751     // in bytes32.
752 
753     struct Set {
754         // Storage of set values
755         bytes32[] _values;
756 
757         // Position of the value in the `values` array, plus 1 because index 0
758         // means a value is not in the set.
759         mapping (bytes32 => uint256) _indexes;
760     }
761 
762     /**
763      * @dev Add a value to a set. O(1).
764      *
765      * Returns true if the value was added to the set, that is if it was not
766      * already present.
767      */
768     function _add(Set storage set, bytes32 value) private returns (bool) {
769         if (!_contains(set, value)) {
770             set._values.push(value);
771             // The value is stored at length-1, but we add 1 to all indexes
772             // and use 0 as a sentinel value
773             set._indexes[value] = set._values.length;
774             return true;
775         } else {
776             return false;
777         }
778     }
779 
780     /**
781      * @dev Removes a value from a set. O(1).
782      *
783      * Returns true if the value was removed from the set, that is if it was
784      * present.
785      */
786     function _remove(Set storage set, bytes32 value) private returns (bool) {
787         // We read and store the value's index to prevent multiple reads from the same storage slot
788         uint256 valueIndex = set._indexes[value];
789 
790         if (valueIndex != 0) { // Equivalent to contains(set, value)
791             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
792             // the array, and then remove the last element (sometimes called as 'swap and pop').
793             // This modifies the order of the array, as noted in {at}.
794 
795             uint256 toDeleteIndex = valueIndex - 1;
796             uint256 lastIndex = set._values.length - 1;
797 
798             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
799             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
800 
801             bytes32 lastvalue = set._values[lastIndex];
802 
803             // Move the last value to the index where the value to delete is
804             set._values[toDeleteIndex] = lastvalue;
805             // Update the index for the moved value
806             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
807 
808             // Delete the slot where the moved value was stored
809             set._values.pop();
810 
811             // Delete the index for the deleted slot
812             delete set._indexes[value];
813 
814             return true;
815         } else {
816             return false;
817         }
818     }
819 
820     /**
821      * @dev Returns true if the value is in the set. O(1).
822      */
823     function _contains(Set storage set, bytes32 value) private view returns (bool) {
824         return set._indexes[value] != 0;
825     }
826 
827     /**
828      * @dev Returns the number of values on the set. O(1).
829      */
830     function _length(Set storage set) private view returns (uint256) {
831         return set._values.length;
832     }
833 
834    /**
835     * @dev Returns the value stored at position `index` in the set. O(1).
836     *
837     * Note that there are no guarantees on the ordering of values inside the
838     * array, and it may change when more values are added or removed.
839     *
840     * Requirements:
841     *
842     * - `index` must be strictly less than {length}.
843     */
844     function _at(Set storage set, uint256 index) private view returns (bytes32) {
845         require(set._values.length > index, "EnumerableSet: index out of bounds");
846         return set._values[index];
847     }
848 
849     // Bytes32Set
850 
851     struct Bytes32Set {
852         Set _inner;
853     }
854 
855     /**
856      * @dev Add a value to a set. O(1).
857      *
858      * Returns true if the value was added to the set, that is if it was not
859      * already present.
860      */
861     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
862         return _add(set._inner, value);
863     }
864 
865     /**
866      * @dev Removes a value from a set. O(1).
867      *
868      * Returns true if the value was removed from the set, that is if it was
869      * present.
870      */
871     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
872         return _remove(set._inner, value);
873     }
874 
875     /**
876      * @dev Returns true if the value is in the set. O(1).
877      */
878     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
879         return _contains(set._inner, value);
880     }
881 
882     /**
883      * @dev Returns the number of values in the set. O(1).
884      */
885     function length(Bytes32Set storage set) internal view returns (uint256) {
886         return _length(set._inner);
887     }
888 
889    /**
890     * @dev Returns the value stored at position `index` in the set. O(1).
891     *
892     * Note that there are no guarantees on the ordering of values inside the
893     * array, and it may change when more values are added or removed.
894     *
895     * Requirements:
896     *
897     * - `index` must be strictly less than {length}.
898     */
899     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
900         return _at(set._inner, index);
901     }
902 
903     // AddressSet
904 
905     struct AddressSet {
906         Set _inner;
907     }
908 
909     /**
910      * @dev Add a value to a set. O(1).
911      *
912      * Returns true if the value was added to the set, that is if it was not
913      * already present.
914      */
915     function add(AddressSet storage set, address value) internal returns (bool) {
916         return _add(set._inner, bytes32(uint256(uint160(value))));
917     }
918 
919     /**
920      * @dev Removes a value from a set. O(1).
921      *
922      * Returns true if the value was removed from the set, that is if it was
923      * present.
924      */
925     function remove(AddressSet storage set, address value) internal returns (bool) {
926         return _remove(set._inner, bytes32(uint256(uint160(value))));
927     }
928 
929     /**
930      * @dev Returns true if the value is in the set. O(1).
931      */
932     function contains(AddressSet storage set, address value) internal view returns (bool) {
933         return _contains(set._inner, bytes32(uint256(uint160(value))));
934     }
935 
936     /**
937      * @dev Returns the number of values in the set. O(1).
938      */
939     function length(AddressSet storage set) internal view returns (uint256) {
940         return _length(set._inner);
941     }
942 
943    /**
944     * @dev Returns the value stored at position `index` in the set. O(1).
945     *
946     * Note that there are no guarantees on the ordering of values inside the
947     * array, and it may change when more values are added or removed.
948     *
949     * Requirements:
950     *
951     * - `index` must be strictly less than {length}.
952     */
953     function at(AddressSet storage set, uint256 index) internal view returns (address) {
954         return address(uint160(uint256(_at(set._inner, index))));
955     }
956 
957 
958     // UintSet
959 
960     struct UintSet {
961         Set _inner;
962     }
963 
964     /**
965      * @dev Add a value to a set. O(1).
966      *
967      * Returns true if the value was added to the set, that is if it was not
968      * already present.
969      */
970     function add(UintSet storage set, uint256 value) internal returns (bool) {
971         return _add(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Removes a value from a set. O(1).
976      *
977      * Returns true if the value was removed from the set, that is if it was
978      * present.
979      */
980     function remove(UintSet storage set, uint256 value) internal returns (bool) {
981         return _remove(set._inner, bytes32(value));
982     }
983 
984     /**
985      * @dev Returns true if the value is in the set. O(1).
986      */
987     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
988         return _contains(set._inner, bytes32(value));
989     }
990 
991     /**
992      * @dev Returns the number of values on the set. O(1).
993      */
994     function length(UintSet storage set) internal view returns (uint256) {
995         return _length(set._inner);
996     }
997 
998    /**
999     * @dev Returns the value stored at position `index` in the set. O(1).
1000     *
1001     * Note that there are no guarantees on the ordering of values inside the
1002     * array, and it may change when more values are added or removed.
1003     *
1004     * Requirements:
1005     *
1006     * - `index` must be strictly less than {length}.
1007     */
1008     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1009         return uint256(_at(set._inner, index));
1010     }
1011 }
1012 
1013 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1014 
1015 pragma solidity >=0.6.0 <0.8.0;
1016 
1017 /**
1018  * @dev Library for managing an enumerable variant of Solidity's
1019  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1020  * type.
1021  *
1022  * Maps have the following properties:
1023  *
1024  * - Entries are added, removed, and checked for existence in constant time
1025  * (O(1)).
1026  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1027  *
1028  * ```
1029  * contract Example {
1030  *     // Add the library methods
1031  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1032  *
1033  *     // Declare a set state variable
1034  *     EnumerableMap.UintToAddressMap private myMap;
1035  * }
1036  * ```
1037  *
1038  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1039  * supported.
1040  */
1041 library EnumerableMap {
1042     // To implement this library for multiple types with as little code
1043     // repetition as possible, we write it in terms of a generic Map type with
1044     // bytes32 keys and values.
1045     // The Map implementation uses private functions, and user-facing
1046     // implementations (such as Uint256ToAddressMap) are just wrappers around
1047     // the underlying Map.
1048     // This means that we can only create new EnumerableMaps for types that fit
1049     // in bytes32.
1050 
1051     struct MapEntry {
1052         bytes32 _key;
1053         bytes32 _value;
1054     }
1055 
1056     struct Map {
1057         // Storage of map keys and values
1058         MapEntry[] _entries;
1059 
1060         // Position of the entry defined by a key in the `entries` array, plus 1
1061         // because index 0 means a key is not in the map.
1062         mapping (bytes32 => uint256) _indexes;
1063     }
1064 
1065     /**
1066      * @dev Adds a key-value pair to a map, or updates the value for an existing
1067      * key. O(1).
1068      *
1069      * Returns true if the key was added to the map, that is if it was not
1070      * already present.
1071      */
1072     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1073         // We read and store the key's index to prevent multiple reads from the same storage slot
1074         uint256 keyIndex = map._indexes[key];
1075 
1076         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1077             map._entries.push(MapEntry({ _key: key, _value: value }));
1078             // The entry is stored at length-1, but we add 1 to all indexes
1079             // and use 0 as a sentinel value
1080             map._indexes[key] = map._entries.length;
1081             return true;
1082         } else {
1083             map._entries[keyIndex - 1]._value = value;
1084             return false;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Removes a key-value pair from a map. O(1).
1090      *
1091      * Returns true if the key was removed from the map, that is if it was present.
1092      */
1093     function _remove(Map storage map, bytes32 key) private returns (bool) {
1094         // We read and store the key's index to prevent multiple reads from the same storage slot
1095         uint256 keyIndex = map._indexes[key];
1096 
1097         if (keyIndex != 0) { // Equivalent to contains(map, key)
1098             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1099             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1100             // This modifies the order of the array, as noted in {at}.
1101 
1102             uint256 toDeleteIndex = keyIndex - 1;
1103             uint256 lastIndex = map._entries.length - 1;
1104 
1105             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1106             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1107 
1108             MapEntry storage lastEntry = map._entries[lastIndex];
1109 
1110             // Move the last entry to the index where the entry to delete is
1111             map._entries[toDeleteIndex] = lastEntry;
1112             // Update the index for the moved entry
1113             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1114 
1115             // Delete the slot where the moved entry was stored
1116             map._entries.pop();
1117 
1118             // Delete the index for the deleted slot
1119             delete map._indexes[key];
1120 
1121             return true;
1122         } else {
1123             return false;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns true if the key is in the map. O(1).
1129      */
1130     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1131         return map._indexes[key] != 0;
1132     }
1133 
1134     /**
1135      * @dev Returns the number of key-value pairs in the map. O(1).
1136      */
1137     function _length(Map storage map) private view returns (uint256) {
1138         return map._entries.length;
1139     }
1140 
1141    /**
1142     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1143     *
1144     * Note that there are no guarantees on the ordering of entries inside the
1145     * array, and it may change when more entries are added or removed.
1146     *
1147     * Requirements:
1148     *
1149     * - `index` must be strictly less than {length}.
1150     */
1151     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1152         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1153 
1154         MapEntry storage entry = map._entries[index];
1155         return (entry._key, entry._value);
1156     }
1157 
1158     /**
1159      * @dev Tries to returns the value associated with `key`.  O(1).
1160      * Does not revert if `key` is not in the map.
1161      */
1162     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1163         uint256 keyIndex = map._indexes[key];
1164         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1165         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1166     }
1167 
1168     /**
1169      * @dev Returns the value associated with `key`.  O(1).
1170      *
1171      * Requirements:
1172      *
1173      * - `key` must be in the map.
1174      */
1175     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1176         uint256 keyIndex = map._indexes[key];
1177         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1178         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1179     }
1180 
1181     /**
1182      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1183      *
1184      * CAUTION: This function is deprecated because it requires allocating memory for the error
1185      * message unnecessarily. For custom revert reasons use {_tryGet}.
1186      */
1187     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1188         uint256 keyIndex = map._indexes[key];
1189         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1190         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1191     }
1192 
1193     // UintToAddressMap
1194 
1195     struct UintToAddressMap {
1196         Map _inner;
1197     }
1198 
1199     /**
1200      * @dev Adds a key-value pair to a map, or updates the value for an existing
1201      * key. O(1).
1202      *
1203      * Returns true if the key was added to the map, that is if it was not
1204      * already present.
1205      */
1206     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1207         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1208     }
1209 
1210     /**
1211      * @dev Removes a value from a set. O(1).
1212      *
1213      * Returns true if the key was removed from the map, that is if it was present.
1214      */
1215     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1216         return _remove(map._inner, bytes32(key));
1217     }
1218 
1219     /**
1220      * @dev Returns true if the key is in the map. O(1).
1221      */
1222     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1223         return _contains(map._inner, bytes32(key));
1224     }
1225 
1226     /**
1227      * @dev Returns the number of elements in the map. O(1).
1228      */
1229     function length(UintToAddressMap storage map) internal view returns (uint256) {
1230         return _length(map._inner);
1231     }
1232 
1233    /**
1234     * @dev Returns the element stored at position `index` in the set. O(1).
1235     * Note that there are no guarantees on the ordering of values inside the
1236     * array, and it may change when more values are added or removed.
1237     *
1238     * Requirements:
1239     *
1240     * - `index` must be strictly less than {length}.
1241     */
1242     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1243         (bytes32 key, bytes32 value) = _at(map._inner, index);
1244         return (uint256(key), address(uint160(uint256(value))));
1245     }
1246 
1247     /**
1248      * @dev Tries to returns the value associated with `key`.  O(1).
1249      * Does not revert if `key` is not in the map.
1250      *
1251      * _Available since v3.4._
1252      */
1253     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1254         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1255         return (success, address(uint160(uint256(value))));
1256     }
1257 
1258     /**
1259      * @dev Returns the value associated with `key`.  O(1).
1260      *
1261      * Requirements:
1262      *
1263      * - `key` must be in the map.
1264      */
1265     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1266         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1267     }
1268 
1269     /**
1270      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1271      *
1272      * CAUTION: This function is deprecated because it requires allocating memory for the error
1273      * message unnecessarily. For custom revert reasons use {tryGet}.
1274      */
1275     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1276         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1277     }
1278 }
1279 
1280 // File: @openzeppelin/contracts/utils/Strings.sol
1281 
1282 pragma solidity >=0.6.0 <0.8.0;
1283 
1284 /**
1285  * @dev String operations.
1286  */
1287 library Strings {
1288     /**
1289      * @dev Converts a `uint256` to its ASCII `string` representation.
1290      */
1291     function toString(uint256 value) internal pure returns (string memory) {
1292         // Inspired by OraclizeAPI's implementation - MIT licence
1293         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1294 
1295         if (value == 0) {
1296             return "0";
1297         }
1298         uint256 temp = value;
1299         uint256 digits;
1300         while (temp != 0) {
1301             digits++;
1302             temp /= 10;
1303         }
1304         bytes memory buffer = new bytes(digits);
1305         uint256 index = digits - 1;
1306         temp = value;
1307         while (temp != 0) {
1308             buffer[index--] = bytes1(uint8(48 + temp % 10));
1309             temp /= 10;
1310         }
1311         return string(buffer);
1312     }
1313 }
1314 
1315 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1316 
1317 pragma solidity >=0.6.0 <0.8.0;
1318 
1319 /**
1320  * @title ERC721 Non-Fungible Token Standard basic implementation
1321  * @dev see https://eips.ethereum.org/EIPS/eip-721
1322  */
1323 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1324     using SafeMath for uint256;
1325     using Address for address;
1326     using EnumerableSet for EnumerableSet.UintSet;
1327     using EnumerableMap for EnumerableMap.UintToAddressMap;
1328     using Strings for uint256;
1329 
1330     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1331     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1332     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1333 
1334     // Mapping from holder address to their (enumerable) set of owned tokens
1335     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1336 
1337     // Enumerable mapping from token ids to their owners
1338     EnumerableMap.UintToAddressMap private _tokenOwners;
1339 
1340     // Mapping from token ID to approved address
1341     mapping (uint256 => address) private _tokenApprovals;
1342 
1343     // Mapping from owner to operator approvals
1344     mapping (address => mapping (address => bool)) private _operatorApprovals;
1345 
1346     // Token name
1347     string private _name;
1348 
1349     // Token symbol
1350     string private _symbol;
1351 
1352     // Optional mapping for token URIs
1353     mapping (uint256 => string) private _tokenURIs;
1354 
1355     // Base URI
1356     string private _baseURI;
1357 
1358     /*
1359      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1360      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1361      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1362      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1363      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1364      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1365      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1366      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1367      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1368      *
1369      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1370      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1371      */
1372     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1373 
1374     /*
1375      *     bytes4(keccak256('name()')) == 0x06fdde03
1376      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1377      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1378      *
1379      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1380      */
1381     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1382 
1383     /*
1384      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1385      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1386      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1387      *
1388      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1389      */
1390     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1391 
1392     /**
1393      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1394      */
1395     constructor (string memory name_, string memory symbol_) public {
1396         _name = name_;
1397         _symbol = symbol_;
1398 
1399         // register the supported interfaces to conform to ERC721 via ERC165
1400         _registerInterface(_INTERFACE_ID_ERC721);
1401         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1402         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-balanceOf}.
1407      */
1408     function balanceOf(address owner) public view virtual override returns (uint256) {
1409         require(owner != address(0), "ERC721: balance query for the zero address");
1410         return _holderTokens[owner].length();
1411     }
1412 
1413     /**
1414      * @dev See {IERC721-ownerOf}.
1415      */
1416     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1417         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Metadata-name}.
1422      */
1423     function name() public view virtual override returns (string memory) {
1424         return _name;
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Metadata-symbol}.
1429      */
1430     function symbol() public view virtual override returns (string memory) {
1431         return _symbol;
1432     }
1433 
1434     /**
1435      * @dev See {IERC721Metadata-tokenURI}.
1436      */
1437     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1438         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1439 
1440         string memory _tokenURI = _tokenURIs[tokenId];
1441         string memory base = baseURI();
1442 
1443         // If there is no base URI, return the token URI.
1444         if (bytes(base).length == 0) {
1445             return _tokenURI;
1446         }
1447         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1448         if (bytes(_tokenURI).length > 0) {
1449             return string(abi.encodePacked(base, _tokenURI));
1450         }
1451         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1452         return string(abi.encodePacked(base, tokenId.toString()));
1453     }
1454 
1455     /**
1456     * @dev Returns the base URI set via {_setBaseURI}. This will be
1457     * automatically added as a prefix in {tokenURI} to each token's URI, or
1458     * to the token ID if no specific URI is set for that token ID.
1459     */
1460     function baseURI() public view virtual returns (string memory) {
1461         return _baseURI;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1466      */
1467     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1468         return _holderTokens[owner].at(index);
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Enumerable-totalSupply}.
1473      */
1474     function totalSupply() public view virtual override returns (uint256) {
1475         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1476         return _tokenOwners.length();
1477     }
1478 
1479     /**
1480      * @dev See {IERC721Enumerable-tokenByIndex}.
1481      */
1482     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1483         (uint256 tokenId, ) = _tokenOwners.at(index);
1484         return tokenId;
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-approve}.
1489      */
1490     function approve(address to, uint256 tokenId) public virtual override {
1491         address owner = ERC721.ownerOf(tokenId);
1492         require(to != owner, "ERC721: approval to current owner");
1493 
1494         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1495             "ERC721: approve caller is not owner nor approved for all"
1496         );
1497 
1498         _approve(to, tokenId);
1499     }
1500 
1501     /**
1502      * @dev See {IERC721-getApproved}.
1503      */
1504     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1505         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1506 
1507         return _tokenApprovals[tokenId];
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-setApprovalForAll}.
1512      */
1513     function setApprovalForAll(address operator, bool approved) public virtual override {
1514         require(operator != _msgSender(), "ERC721: approve to caller");
1515 
1516         _operatorApprovals[_msgSender()][operator] = approved;
1517         emit ApprovalForAll(_msgSender(), operator, approved);
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-isApprovedForAll}.
1522      */
1523     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1524         return _operatorApprovals[owner][operator];
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-transferFrom}.
1529      */
1530     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1531         //solhint-disable-next-line max-line-length
1532         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1533 
1534         _transfer(from, to, tokenId);
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-safeTransferFrom}.
1539      */
1540     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1541         safeTransferFrom(from, to, tokenId, "");
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-safeTransferFrom}.
1546      */
1547     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1548         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1549         _safeTransfer(from, to, tokenId, _data);
1550     }
1551 
1552     /**
1553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1555      *
1556      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1557      *
1558      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1559      * implement alternative mechanisms to perform token transfer, such as signature-based.
1560      *
1561      * Requirements:
1562      *
1563      * - `from` cannot be the zero address.
1564      * - `to` cannot be the zero address.
1565      * - `tokenId` token must exist and be owned by `from`.
1566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1571         _transfer(from, to, tokenId);
1572         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1573     }
1574 
1575     /**
1576      * @dev Returns whether `tokenId` exists.
1577      *
1578      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1579      *
1580      * Tokens start existing when they are minted (`_mint`),
1581      * and stop existing when they are burned (`_burn`).
1582      */
1583     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1584         return _tokenOwners.contains(tokenId);
1585     }
1586 
1587     /**
1588      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1589      *
1590      * Requirements:
1591      *
1592      * - `tokenId` must exist.
1593      */
1594     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1595         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1596         address owner = ERC721.ownerOf(tokenId);
1597         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1598     }
1599 
1600     /**
1601      * @dev Safely mints `tokenId` and transfers it to `to`.
1602      *
1603      * Requirements:
1604      d*
1605      * - `tokenId` must not exist.
1606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _safeMint(address to, uint256 tokenId) internal virtual {
1611         _safeMint(to, tokenId, "");
1612     }
1613 
1614     /**
1615      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1616      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1617      */
1618     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1619         _mint(to, tokenId);
1620         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1621     }
1622 
1623     /**
1624      * @dev Mints `tokenId` and transfers it to `to`.
1625      *
1626      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must not exist.
1631      * - `to` cannot be the zero address.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function _mint(address to, uint256 tokenId) internal virtual {
1636         require(to != address(0), "ERC721: mint to the zero address");
1637         require(!_exists(tokenId), "ERC721: token already minted");
1638 
1639         _beforeTokenTransfer(address(0), to, tokenId);
1640 
1641         _holderTokens[to].add(tokenId);
1642 
1643         _tokenOwners.set(tokenId, to);
1644 
1645         emit Transfer(address(0), to, tokenId);
1646     }
1647 
1648     /**
1649      * @dev Destroys `tokenId`.
1650      * The approval is cleared when the token is burned.
1651      *
1652      * Requirements:
1653      *
1654      * - `tokenId` must exist.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function _burn(uint256 tokenId) internal virtual {
1659         address owner = ERC721.ownerOf(tokenId); // internal owner
1660 
1661         _beforeTokenTransfer(owner, address(0), tokenId);
1662 
1663         // Clear approvals
1664         _approve(address(0), tokenId);
1665 
1666         // Clear metadata (if any)
1667         if (bytes(_tokenURIs[tokenId]).length != 0) {
1668             delete _tokenURIs[tokenId];
1669         }
1670 
1671         _holderTokens[owner].remove(tokenId);
1672 
1673         _tokenOwners.remove(tokenId);
1674 
1675         emit Transfer(owner, address(0), tokenId);
1676     }
1677 
1678     /**
1679      * @dev Transfers `tokenId` from `from` to `to`.
1680      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1681      *
1682      * Requirements:
1683      *
1684      * - `to` cannot be the zero address.
1685      * - `tokenId` token must be owned by `from`.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1690         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1691         require(to != address(0), "ERC721: transfer to the zero address");
1692 
1693         _beforeTokenTransfer(from, to, tokenId);
1694 
1695         // Clear approvals from the previous owner
1696         _approve(address(0), tokenId);
1697 
1698         _holderTokens[from].remove(tokenId);
1699         _holderTokens[to].add(tokenId);
1700 
1701         _tokenOwners.set(tokenId, to);
1702 
1703         emit Transfer(from, to, tokenId);
1704     }
1705 
1706     /**
1707      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must exist.
1712      */
1713     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1714         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1715         _tokenURIs[tokenId] = _tokenURI;
1716     }
1717 
1718     /**
1719      * @dev Internal function to set the base URI for all token IDs. It is
1720      * automatically added as a prefix to the value returned in {tokenURI},
1721      * or to the token ID if {tokenURI} is empty.
1722      */
1723     function _setBaseURI(string memory baseURI_) internal virtual {
1724         _baseURI = baseURI_;
1725     }
1726 
1727     /**
1728      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1729      * The call is not executed if the target address is not a contract.
1730      *
1731      * @param from address representing the previous owner of the given token ID
1732      * @param to target address that will receive the tokens
1733      * @param tokenId uint256 ID of the token to be transferred
1734      * @param _data bytes optional data to send along with the call
1735      * @return bool whether the call correctly returned the expected magic value
1736      */
1737     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1738         private returns (bool)
1739     {
1740         if (!to.isContract()) {
1741             return true;
1742         }
1743         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1744             IERC721Receiver(to).onERC721Received.selector,
1745             _msgSender(),
1746             from,
1747             tokenId,
1748             _data
1749         ), "ERC721: transfer to non ERC721Receiver implementer");
1750         bytes4 retval = abi.decode(returndata, (bytes4));
1751         return (retval == _ERC721_RECEIVED);
1752     }
1753 
1754     /**
1755      * @dev Approve `to` to operate on `tokenId`
1756      *
1757      * Emits an {Approval} event.
1758      */
1759     function _approve(address to, uint256 tokenId) internal virtual {
1760         _tokenApprovals[tokenId] = to;
1761         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1762     }
1763 
1764     /**
1765      * @dev Hook that is called before any token transfer. This includes minting
1766      * and burning.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1774      * - `from` cannot be the zero address.
1775      * - `to` cannot be the zero address.
1776      *
1777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1778      */
1779     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1780 }
1781 
1782 // File: @openzeppelin/contracts/access/Ownable.sol
1783 
1784 pragma solidity >=0.6.0 <0.8.0;
1785 
1786 /**
1787  * @dev Contract module which provides a basic access control mechanism, where
1788  * there is an account (an owner) that can be granted exclusive access to
1789  * specific functions.
1790  *
1791  * By default, the owner account will be the one that deploys the contract. This
1792  * can later be changed with {transferOwnership}.
1793  *
1794  * This module is used through inheritance. It will make available the modifier
1795  * `onlyOwner`, which can be applied to your functions to restrict their use to
1796  * the owner.
1797  */
1798 abstract contract Ownable is Context {
1799     address private _owner;
1800 
1801     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1802 
1803     /**
1804      * @dev Initializes the contract setting the deployer as the initial owner.
1805      */
1806     constructor () internal {
1807         address msgSender = _msgSender();
1808         _owner = msgSender;
1809         emit OwnershipTransferred(address(0), msgSender);
1810     }
1811 
1812     /**
1813      * @dev Returns the address of the current owner.
1814      */
1815     function owner() public view virtual returns (address) {
1816         return _owner;
1817     }
1818 
1819     /**
1820      * @dev Throws if called by any account other than the owner.
1821      */
1822     modifier onlyOwner() {
1823         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1824         _;
1825     }
1826 
1827     /**
1828      * @dev Leaves the contract without owner. It will not be possible to call
1829      * `onlyOwner` functions anymore. Can only be called by the current owner.
1830      *
1831      * NOTE: Renouncing ownership will leave the contract without an owner,
1832      * thereby removing any functionality that is only available to the owner.
1833      */
1834     function renounceOwnership() public virtual onlyOwner {
1835         emit OwnershipTransferred(_owner, address(0));
1836         _owner = address(0);
1837     }
1838 
1839     /**
1840      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1841      * Can only be called by the current owner.
1842      */
1843     function transferOwnership(address newOwner) public virtual onlyOwner {
1844         require(newOwner != address(0), "Ownable: new owner is the zero address");
1845         emit OwnershipTransferred(_owner, newOwner);
1846         _owner = newOwner;
1847     }
1848 }
1849 
1850 // File: contracts/CryptoRick.sol
1851 
1852 pragma solidity ^0.7.0;
1853 
1854 /**
1855  * @title CryptoRick contract
1856  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1857  */
1858 contract CryptoRick is ERC721, Ownable {
1859     using SafeMath for uint256;
1860 
1861     string public RICK_PROVENANCE = "";
1862 
1863     uint256 public startingIndexBlock;
1864 
1865     uint256 public startingIndex;
1866 
1867     uint256 public constant rickPrice = 50000000000000000; //0.05 ETH
1868 
1869     uint public constant maxRickPurchase = 5;
1870 
1871     uint256 public MAX_RICK;
1872 
1873     bool public saleIsActive = false;
1874 
1875     uint256 public REVEAL_TIMESTAMP;
1876 
1877     constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart) ERC721(name, symbol) {
1878         MAX_RICK = maxNftSupply;
1879         REVEAL_TIMESTAMP = saleStart + (90000 * 9);
1880     }
1881 
1882     address[] withdrawAddresses = [0x3DcCb509199B52C21f60489D421080eA9167674D, 0xADDaF99990b665D8553f08653966fa8995Cc1209];
1883     uint256[] withdrawPercents = [90, 10]; // Withdraw function sends the ETH to multiple addresses divided by percentages. 
1884     
1885     function withdrawAll() public onlyOwner {
1886         uint256 contractBalance = address(this).balance;
1887         for(uint256 i=0;i<withdrawAddresses.length;i++) {
1888             uint256 amount = contractBalance * withdrawPercents[i] / 100;
1889             require(payable(withdrawAddresses[i]).send(amount));
1890         }
1891     }
1892 
1893     /**
1894      * Set some Ricks aside
1895      */
1896     function reserveRick() public onlyOwner {        
1897         uint supply = totalSupply();
1898         uint i;
1899         for (i = 0; i < 30; i++) {
1900             _safeMint(msg.sender, supply + i);
1901         }
1902     }
1903 
1904     /**
1905      * CryptoRick NFTs.
1906      */
1907     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1908         REVEAL_TIMESTAMP = revealTimeStamp;
1909     } 
1910 
1911     /*     
1912     * Set provenance once it's calculated
1913     */
1914     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1915         RICK_PROVENANCE = provenanceHash;
1916     }
1917 
1918     function setBaseURI(string memory baseURI) public onlyOwner {
1919         _setBaseURI(baseURI);
1920     }
1921 
1922     /*
1923     * Pause sale if active, make active if paused
1924     */
1925     function flipSaleState() public onlyOwner {
1926         saleIsActive = !saleIsActive;
1927     }
1928 
1929     /**
1930     * Mints CryptoRick
1931     */
1932     function mintRick(uint numberOfTokens) public payable {
1933         require(saleIsActive, "Sale must be active to mint Ricks");
1934         require(numberOfTokens <= maxRickPurchase, "Can only mint 20 tokens at a time");
1935         require(totalSupply().add(numberOfTokens) <= MAX_RICK, "Purchase would exceed max supply of Ricks");
1936         require(rickPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1937         
1938         for(uint i = 0; i < numberOfTokens; i++) {
1939             uint mintIndex = totalSupply();
1940             if (totalSupply() < MAX_RICK) {
1941                 _safeMint(msg.sender, mintIndex);
1942             }
1943         }
1944 
1945         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
1946         // the end of pre-sale, set the starting index block
1947         if (startingIndexBlock == 0 && (totalSupply() == MAX_RICK || block.timestamp >= REVEAL_TIMESTAMP)) {
1948             startingIndexBlock = block.number;
1949         } 
1950     }
1951 
1952     /**
1953      * Set the starting index for the collection
1954      */
1955     function setStartingIndex() public {
1956         require(startingIndex == 0, "Starting index is already set");
1957         require(startingIndexBlock != 0, "Starting index block must be set");
1958         
1959         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_RICK;
1960         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1961         if (block.number.sub(startingIndexBlock) > 255) {
1962             startingIndex = uint(blockhash(block.number - 1)) % MAX_RICK;
1963         }
1964         // Prevent default sequence
1965         if (startingIndex == 0) {
1966             startingIndex = startingIndex.add(1);
1967         }
1968     }
1969 
1970     /**
1971      * Set the starting index block for the collection, essentially unblocking
1972      * setting starting index
1973      */
1974     function emergencySetStartingIndexBlock() public onlyOwner {
1975         require(startingIndex == 0, "Starting index is already set");
1976         
1977         startingIndexBlock = block.number;
1978     }
1979 }