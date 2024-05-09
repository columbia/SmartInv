1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 pragma solidity ^0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/introspection/IERC165.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 interface IERC721 is IERC165 {
65     /**
66      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
72      */
73     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
77      */
78     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
79 
80     /**
81      * @dev Returns the number of tokens in ``owner``'s account.
82      */
83     function balanceOf(address owner) external view returns (uint256 balance);
84 
85     /**
86      * @dev Returns the owner of the `tokenId` token.
87      *
88      * Requirements:
89      *
90      * - `tokenId` must exist.
91      */
92     function ownerOf(uint256 tokenId) external view returns (address owner);
93 
94     /**
95      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
96      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must exist and be owned by `from`.
103      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
105      *
106      * Emits a {Transfer} event.
107      */
108     function safeTransferFrom(address from, address to, uint256 tokenId) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(address from, address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
128      * The approval is cleared when the token is transferred.
129      *
130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
131      *
132      * Requirements:
133      *
134      * - The caller must own the token or be an approved operator.
135      * - `tokenId` must exist.
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address to, uint256 tokenId) external;
140 
141     /**
142      * @dev Returns the account approved for `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function getApproved(uint256 tokenId) external view returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator) external view returns (bool);
168 
169     /**
170       * @dev Safely transfers `tokenId` token from `from` to `to`.
171       *
172       * Requirements:
173       *
174       * - `from` cannot be the zero address.
175       * - `to` cannot be the zero address.
176       * - `tokenId` token must exist and be owned by `from`.
177       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179       *
180       * Emits a {Transfer} event.
181       */
182     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
186 
187 
188 
189 pragma solidity ^0.8.0;
190 
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197 
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
215 
216 
217 
218 pragma solidity ^0.8.0;
219 
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
245 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
246 
247 
248 
249 pragma solidity ^0.8.0;
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
269 // File: @openzeppelin/contracts/introspection/ERC165.sol
270 
271 
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @dev Implementation of the {IERC165} interface.
278  *
279  * Contracts may inherit from this and call {_registerInterface} to declare
280  * their support of an interface.
281  */
282 abstract contract ERC165 is IERC165 {
283     /*
284      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
285      */
286     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
287 
288     /**
289      * @dev Mapping of interface ids to whether or not it's supported.
290      */
291     mapping(bytes4 => bool) private _supportedInterfaces;
292 
293     constructor () internal {
294         // Derived contracts need only register support for their own interfaces,
295         // we register support for ERC165 itself here
296         _registerInterface(_INTERFACE_ID_ERC165);
297     }
298 
299     /**
300      * @dev See {IERC165-supportsInterface}.
301      *
302      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
303      */
304     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
305         return _supportedInterfaces[interfaceId];
306     }
307 
308     /**
309      * @dev Registers the contract as an implementer of the interface defined by
310      * `interfaceId`. Support of the actual ERC165 interface is automatic and
311      * registering its interface id is not required.
312      *
313      * See {IERC165-supportsInterface}.
314      *
315      * Requirements:
316      *
317      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
318      */
319     function _registerInterface(bytes4 interfaceId) internal virtual {
320         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
321         _supportedInterfaces[interfaceId] = true;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/math/SafeMath.sol
326 
327 
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Wrappers over Solidity's arithmetic operations with added overflow
333  * checks.
334  *
335  * Arithmetic operations in Solidity wrap on overflow. This can easily result
336  * in bugs, because programmers usually assume that an overflow raises an
337  * error, which is the standard behavior in high level programming languages.
338  * `SafeMath` restores this intuition by reverting the transaction when an
339  * operation overflows.
340  *
341  * Using this library instead of the unchecked operations eliminates an entire
342  * class of bugs, so it's recommended to use it always.
343  */
344 library SafeMath {
345     /**
346      * @dev Returns the addition of two unsigned integers, with an overflow flag.
347      *
348      * _Available since v3.4._
349      */
350     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
351         uint256 c = a + b;
352         if (c < a) return (false, 0);
353         return (true, c);
354     }
355 
356     /**
357      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
358      *
359      * _Available since v3.4._
360      */
361     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         if (b > a) return (false, 0);
363         return (true, a - b);
364     }
365 
366     /**
367      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
373         // benefit is lost if 'b' is also tested.
374         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
375         if (a == 0) return (true, 0);
376         uint256 c = a * b;
377         if (c / a != b) return (false, 0);
378         return (true, c);
379     }
380 
381     /**
382      * @dev Returns the division of two unsigned integers, with a division by zero flag.
383      *
384      * _Available since v3.4._
385      */
386     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         if (b == 0) return (false, 0);
388         return (true, a / b);
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         if (b == 0) return (false, 0);
398         return (true, a % b);
399     }
400 
401     /**
402      * @dev Returns the addition of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `+` operator.
406      *
407      * Requirements:
408      *
409      * - Addition cannot overflow.
410      */
411     function add(uint256 a, uint256 b) internal pure returns (uint256) {
412         uint256 c = a + b;
413         require(c >= a, "SafeMath: addition overflow");
414         return c;
415     }
416 
417     /**
418      * @dev Returns the subtraction of two unsigned integers, reverting on
419      * overflow (when the result is negative).
420      *
421      * Counterpart to Solidity's `-` operator.
422      *
423      * Requirements:
424      *
425      * - Subtraction cannot overflow.
426      */
427     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428         require(b <= a, "SafeMath: subtraction overflow");
429         return a - b;
430     }
431 
432     /**
433      * @dev Returns the multiplication of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `*` operator.
437      *
438      * Requirements:
439      *
440      * - Multiplication cannot overflow.
441      */
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         if (a == 0) return 0;
444         uint256 c = a * b;
445         require(c / a == b, "SafeMath: multiplication overflow");
446         return c;
447     }
448 
449     /**
450      * @dev Returns the integer division of two unsigned integers, reverting on
451      * division by zero. The result is rounded towards zero.
452      *
453      * Counterpart to Solidity's `/` operator. Note: this function uses a
454      * `revert` opcode (which leaves remaining gas untouched) while Solidity
455      * uses an invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function div(uint256 a, uint256 b) internal pure returns (uint256) {
462         require(b > 0, "SafeMath: division by zero");
463         return a / b;
464     }
465 
466     /**
467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
468      * reverting when dividing by zero.
469      *
470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
471      * opcode (which leaves remaining gas untouched) while Solidity uses an
472      * invalid opcode to revert (consuming all remaining gas).
473      *
474      * Requirements:
475      *
476      * - The divisor cannot be zero.
477      */
478     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
479         require(b > 0, "SafeMath: modulo by zero");
480         return a % b;
481     }
482 
483     /**
484      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
485      * overflow (when the result is negative).
486      *
487      * CAUTION: This function is deprecated because it requires allocating memory for the error
488      * message unnecessarily. For custom revert reasons use {trySub}.
489      *
490      * Counterpart to Solidity's `-` operator.
491      *
492      * Requirements:
493      *
494      * - Subtraction cannot overflow.
495      */
496     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b <= a, errorMessage);
498         return a - b;
499     }
500 
501     /**
502      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
503      * division by zero. The result is rounded towards zero.
504      *
505      * CAUTION: This function is deprecated because it requires allocating memory for the error
506      * message unnecessarily. For custom revert reasons use {tryDiv}.
507      *
508      * Counterpart to Solidity's `/` operator. Note: this function uses a
509      * `revert` opcode (which leaves remaining gas untouched) while Solidity
510      * uses an invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
517         require(b > 0, errorMessage);
518         return a / b;
519     }
520 
521     /**
522      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
523      * reverting with custom message when dividing by zero.
524      *
525      * CAUTION: This function is deprecated because it requires allocating memory for the error
526      * message unnecessarily. For custom revert reasons use {tryMod}.
527      *
528      * Counterpart to Solidity's `%` operator. This function uses a `revert`
529      * opcode (which leaves remaining gas untouched) while Solidity uses an
530      * invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
537         require(b > 0, errorMessage);
538         return a % b;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/utils/Address.sol
543 
544 
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Collection of functions related to the address type
550  */
551 library Address {
552     /**
553      * @dev Returns true if `account` is a contract.
554      *
555      * [IMPORTANT]
556      * ====
557      * It is unsafe to assume that an address for which this function returns
558      * false is an externally-owned account (EOA) and not a contract.
559      *
560      * Among others, `isContract` will return false for the following
561      * types of addresses:
562      *
563      *  - an externally-owned account
564      *  - a contract in construction
565      *  - an address where a contract will be created
566      *  - an address where a contract lived, but was destroyed
567      * ====
568      */
569     function isContract(address account) internal view returns (bool) {
570         // This method relies on extcodesize, which returns 0 for contracts in
571         // construction, since the code is only stored at the end of the
572         // constructor execution.
573 
574         uint256 size;
575         // solhint-disable-next-line no-inline-assembly
576         assembly { size := extcodesize(account) }
577         return size > 0;
578     }
579 
580     /**
581      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
582      * `recipient`, forwarding all available gas and reverting on errors.
583      *
584      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
585      * of certain opcodes, possibly making contracts go over the 2300 gas limit
586      * imposed by `transfer`, making them unable to receive funds via
587      * `transfer`. {sendValue} removes this limitation.
588      *
589      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
590      *
591      * IMPORTANT: because control is transferred to `recipient`, care must be
592      * taken to not create reentrancy vulnerabilities. Consider using
593      * {ReentrancyGuard} or the
594      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
595      */
596     function sendValue(address payable recipient, uint256 amount) internal {
597         require(address(this).balance >= amount, "Address: insufficient balance");
598 
599         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
600         (bool success, ) = recipient.call{ value: amount }("");
601         require(success, "Address: unable to send value, recipient may have reverted");
602     }
603 
604     /**
605      * @dev Performs a Solidity function call using a low level `call`. A
606      * plain`call` is an unsafe replacement for a function call: use this
607      * function instead.
608      *
609      * If `target` reverts with a revert reason, it is bubbled up by this
610      * function (like regular Solidity function calls).
611      *
612      * Returns the raw returned data. To convert to the expected return value,
613      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
614      *
615      * Requirements:
616      *
617      * - `target` must be a contract.
618      * - calling `target` with `data` must not revert.
619      *
620      * _Available since v3.1._
621      */
622     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
623       return functionCall(target, data, "Address: low-level call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
628      * `errorMessage` as a fallback revert reason when `target` reverts.
629      *
630      * _Available since v3.1._
631      */
632     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, 0, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but also transferring `value` wei to `target`.
639      *
640      * Requirements:
641      *
642      * - the calling contract must have an ETH balance of at least `value`.
643      * - the called Solidity function must be `payable`.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
648         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
653      * with `errorMessage` as a fallback revert reason when `target` reverts.
654      *
655      * _Available since v3.1._
656      */
657     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
658         require(address(this).balance >= value, "Address: insufficient balance for call");
659         require(isContract(target), "Address: call to non-contract");
660 
661         // solhint-disable-next-line avoid-low-level-calls
662         (bool success, bytes memory returndata) = target.call{ value: value }(data);
663         return _verifyCallResult(success, returndata, errorMessage);
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
668      * but performing a static call.
669      *
670      * _Available since v3.3._
671      */
672     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
673         return functionStaticCall(target, data, "Address: low-level static call failed");
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
678      * but performing a static call.
679      *
680      * _Available since v3.3._
681      */
682     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
683         require(isContract(target), "Address: static call to non-contract");
684 
685         // solhint-disable-next-line avoid-low-level-calls
686         (bool success, bytes memory returndata) = target.staticcall(data);
687         return _verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
692      * but performing a delegate call.
693      *
694      * _Available since v3.4._
695      */
696     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
697         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
702      * but performing a delegate call.
703      *
704      * _Available since v3.4._
705      */
706     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
707         require(isContract(target), "Address: delegate call to non-contract");
708 
709         // solhint-disable-next-line avoid-low-level-calls
710         (bool success, bytes memory returndata) = target.delegatecall(data);
711         return _verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
715         if (success) {
716             return returndata;
717         } else {
718             // Look for revert reason and bubble it up if present
719             if (returndata.length > 0) {
720                 // The easiest way to bubble the revert reason is using memory via assembly
721 
722                 // solhint-disable-next-line no-inline-assembly
723                 assembly {
724                     let returndata_size := mload(returndata)
725                     revert(add(32, returndata), returndata_size)
726                 }
727             } else {
728                 revert(errorMessage);
729             }
730         }
731     }
732 }
733 
734 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
735 
736 
737 
738 pragma solidity ^0.8.0;
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
1034 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1035 
1036 
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @dev Library for managing an enumerable variant of Solidity's
1042  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1043  * type.
1044  *
1045  * Maps have the following properties:
1046  *
1047  * - Entries are added, removed, and checked for existence in constant time
1048  * (O(1)).
1049  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1050  *
1051  * ```
1052  * contract Example {
1053  *     // Add the library methods
1054  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1055  *
1056  *     // Declare a set state variable
1057  *     EnumerableMap.UintToAddressMap private myMap;
1058  * }
1059  * ```
1060  *
1061  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1062  * supported.
1063  */
1064 library EnumerableMap {
1065     // To implement this library for multiple types with as little code
1066     // repetition as possible, we write it in terms of a generic Map type with
1067     // bytes32 keys and values.
1068     // The Map implementation uses private functions, and user-facing
1069     // implementations (such as Uint256ToAddressMap) are just wrappers around
1070     // the underlying Map.
1071     // This means that we can only create new EnumerableMaps for types that fit
1072     // in bytes32.
1073 
1074     struct MapEntry {
1075         bytes32 _key;
1076         bytes32 _value;
1077     }
1078 
1079     struct Map {
1080         // Storage of map keys and values
1081         MapEntry[] _entries;
1082 
1083         // Position of the entry defined by a key in the `entries` array, plus 1
1084         // because index 0 means a key is not in the map.
1085         mapping (bytes32 => uint256) _indexes;
1086     }
1087 
1088     /**
1089      * @dev Adds a key-value pair to a map, or updates the value for an existing
1090      * key. O(1).
1091      *
1092      * Returns true if the key was added to the map, that is if it was not
1093      * already present.
1094      */
1095     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1096         // We read and store the key's index to prevent multiple reads from the same storage slot
1097         uint256 keyIndex = map._indexes[key];
1098 
1099         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1100             map._entries.push(MapEntry({ _key: key, _value: value }));
1101             // The entry is stored at length-1, but we add 1 to all indexes
1102             // and use 0 as a sentinel value
1103             map._indexes[key] = map._entries.length;
1104             return true;
1105         } else {
1106             map._entries[keyIndex - 1]._value = value;
1107             return false;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Removes a key-value pair from a map. O(1).
1113      *
1114      * Returns true if the key was removed from the map, that is if it was present.
1115      */
1116     function _remove(Map storage map, bytes32 key) private returns (bool) {
1117         // We read and store the key's index to prevent multiple reads from the same storage slot
1118         uint256 keyIndex = map._indexes[key];
1119 
1120         if (keyIndex != 0) { // Equivalent to contains(map, key)
1121             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1122             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1123             // This modifies the order of the array, as noted in {at}.
1124 
1125             uint256 toDeleteIndex = keyIndex - 1;
1126             uint256 lastIndex = map._entries.length - 1;
1127 
1128             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1129             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1130 
1131             MapEntry storage lastEntry = map._entries[lastIndex];
1132 
1133             // Move the last entry to the index where the entry to delete is
1134             map._entries[toDeleteIndex] = lastEntry;
1135             // Update the index for the moved entry
1136             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1137 
1138             // Delete the slot where the moved entry was stored
1139             map._entries.pop();
1140 
1141             // Delete the index for the deleted slot
1142             delete map._indexes[key];
1143 
1144             return true;
1145         } else {
1146             return false;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Returns true if the key is in the map. O(1).
1152      */
1153     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1154         return map._indexes[key] != 0;
1155     }
1156 
1157     /**
1158      * @dev Returns the number of key-value pairs in the map. O(1).
1159      */
1160     function _length(Map storage map) private view returns (uint256) {
1161         return map._entries.length;
1162     }
1163 
1164    /**
1165     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1166     *
1167     * Note that there are no guarantees on the ordering of entries inside the
1168     * array, and it may change when more entries are added or removed.
1169     *
1170     * Requirements:
1171     *
1172     * - `index` must be strictly less than {length}.
1173     */
1174     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1175         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1176 
1177         MapEntry storage entry = map._entries[index];
1178         return (entry._key, entry._value);
1179     }
1180 
1181     /**
1182      * @dev Tries to returns the value associated with `key`.  O(1).
1183      * Does not revert if `key` is not in the map.
1184      */
1185     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1186         uint256 keyIndex = map._indexes[key];
1187         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1188         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1189     }
1190 
1191     /**
1192      * @dev Returns the value associated with `key`.  O(1).
1193      *
1194      * Requirements:
1195      *
1196      * - `key` must be in the map.
1197      */
1198     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1199         uint256 keyIndex = map._indexes[key];
1200         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1201         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1202     }
1203 
1204     /**
1205      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1206      *
1207      * CAUTION: This function is deprecated because it requires allocating memory for the error
1208      * message unnecessarily. For custom revert reasons use {_tryGet}.
1209      */
1210     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1211         uint256 keyIndex = map._indexes[key];
1212         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1213         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1214     }
1215 
1216     // UintToAddressMap
1217 
1218     struct UintToAddressMap {
1219         Map _inner;
1220     }
1221 
1222     /**
1223      * @dev Adds a key-value pair to a map, or updates the value for an existing
1224      * key. O(1).
1225      *
1226      * Returns true if the key was added to the map, that is if it was not
1227      * already present.
1228      */
1229     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1230         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1231     }
1232 
1233     /**
1234      * @dev Removes a value from a set. O(1).
1235      *
1236      * Returns true if the key was removed from the map, that is if it was present.
1237      */
1238     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1239         return _remove(map._inner, bytes32(key));
1240     }
1241 
1242     /**
1243      * @dev Returns true if the key is in the map. O(1).
1244      */
1245     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1246         return _contains(map._inner, bytes32(key));
1247     }
1248 
1249     /**
1250      * @dev Returns the number of elements in the map. O(1).
1251      */
1252     function length(UintToAddressMap storage map) internal view returns (uint256) {
1253         return _length(map._inner);
1254     }
1255 
1256    /**
1257     * @dev Returns the element stored at position `index` in the set. O(1).
1258     * Note that there are no guarantees on the ordering of values inside the
1259     * array, and it may change when more values are added or removed.
1260     *
1261     * Requirements:
1262     *
1263     * - `index` must be strictly less than {length}.
1264     */
1265     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1266         (bytes32 key, bytes32 value) = _at(map._inner, index);
1267         return (uint256(key), address(uint160(uint256(value))));
1268     }
1269 
1270     /**
1271      * @dev Tries to returns the value associated with `key`.  O(1).
1272      * Does not revert if `key` is not in the map.
1273      *
1274      * _Available since v3.4._
1275      */
1276     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1277         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1278         return (success, address(uint160(uint256(value))));
1279     }
1280 
1281     /**
1282      * @dev Returns the value associated with `key`.  O(1).
1283      *
1284      * Requirements:
1285      *
1286      * - `key` must be in the map.
1287      */
1288     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1289         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1290     }
1291 
1292     /**
1293      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1294      *
1295      * CAUTION: This function is deprecated because it requires allocating memory for the error
1296      * message unnecessarily. For custom revert reasons use {tryGet}.
1297      */
1298     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1299         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1300     }
1301 }
1302 
1303 // File: @openzeppelin/contracts/utils/Strings.sol
1304 
1305 
1306 
1307 pragma solidity ^0.8.0;
1308 
1309 /**
1310  * @dev String operations.
1311  */
1312 library Strings {
1313     /**
1314      * @dev Converts a `uint256` to its ASCII `string` representation.
1315      */
1316     function toString(uint256 value) internal pure returns (string memory) {
1317         // Inspired by OraclizeAPI's implementation - MIT licence
1318         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1319 
1320         if (value == 0) {
1321             return "0";
1322         }
1323         uint256 temp = value;
1324         uint256 digits;
1325         while (temp != 0) {
1326             digits++;
1327             temp /= 10;
1328         }
1329         bytes memory buffer = new bytes(digits);
1330         while (value != 0) {
1331             digits -= 1;
1332             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1333             value /= 10;
1334         }
1335         return string(buffer);
1336     }
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1340 
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 /**
1345  * @title ERC721 Non-Fungible Token Standard basic implementation
1346  * @dev see https://eips.ethereum.org/EIPS/eip-721
1347  */
1348  
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
1421     constructor (string memory name_, string memory symbol_) public {
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
1812 pragma solidity ^0.8.0;
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
1834     constructor () internal {
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
1878 pragma solidity ^0.8.0;
1879 pragma abicoder v2;
1880 
1881 contract EtherealCollectiveArtSupporter is ERC721, Ownable {
1882     
1883     using SafeMath for uint256;
1884 
1885     // Basic //
1886     string public ecasProvenance = ""; // IPFS URL WILL BE ADDED WHEN ALL SOLD OUT
1887     uint256 public collectiblePrice = 0.128 ether;
1888     uint256 public constant maxCollectiblePerPurchase = 3; // 1-3 tokens per transaction
1889     uint256 public constant maxCollectibles = 8168;
1890     uint256 public presalePurchaseLimit = 3; // PRESALE: 3 tokens per wallet maximum.
1891     uint256 public purchaseLimit = 10; // PUBLIC SALE: 10 tokens per wallet maximum.
1892     uint256 public collectibleReserve = 168; // FREE MINT FOR OWNER
1893 
1894     // Arrays //
1895     mapping(address => bool) public presalerList;
1896     mapping(address => uint256) public presalerListPurchases;
1897     mapping(address => uint256) public purchases;
1898 
1899     // Booleans 
1900     bool public saleIsActive = false;
1901     bool public presaleIsLive  = false;
1902     bool public locked = false;
1903 
1904     constructor() ERC721("Ethereal Collective Art Supporter", "ECAS") { }
1905     
1906     modifier notLocked {
1907         require(!locked, "Contract metadata methods are locked");
1908         _;
1909     }
1910 
1911     function addToPresaleList(address[] calldata entries) external onlyOwner {
1912         for(uint256 i = 0; i < entries.length; i++) {
1913             address entry = entries[i];
1914             require(entry != address(0), "Null address");
1915             require(!presalerList[entry], "Duplicated entry");
1916 
1917             presalerList[entry] = true;
1918         }   
1919     }
1920 
1921     function removeFromPresaleList(address[] calldata entries) external onlyOwner {
1922         for(uint256 i = 0; i < entries.length; i++) {
1923             address entry = entries[i];
1924             require(entry != address(0), "Null address");
1925             
1926             presalerList[entry] = false;
1927         }
1928     }
1929 
1930     function reserve(address _to, uint256 _reserveAmount) public onlyOwner {        
1931         uint supply = totalSupply() + 1;
1932         require(_reserveAmount > 0 && _reserveAmount <= collectibleReserve, "Not enough reserve left for team.");
1933         for (uint i = 0; i < _reserveAmount; i++) {
1934             _safeMint(_to, supply + i);
1935         }
1936         collectibleReserve = collectibleReserve.sub(_reserveAmount);
1937     }
1938 
1939     function withdraw() public onlyOwner {
1940         _withdraw(msg.sender, address(this).balance);
1941     }
1942     
1943     function _withdraw(address _address, uint256 _amount) private {
1944         (bool success, ) = _address.call{value: _amount}("");
1945         require(success, "Transfer failed.");
1946     }
1947 
1948     function setProvenanceHash(string memory provenanceHash) public onlyOwner notLocked {
1949         ecasProvenance = provenanceHash;
1950     }
1951 
1952     function setMintingPrice(uint256 mintingPrice) public onlyOwner notLocked {
1953         collectiblePrice = mintingPrice;
1954     }
1955 
1956     function setBaseURI(string memory baseURI) public onlyOwner notLocked {
1957         _setBaseURI(baseURI);
1958     }
1959 
1960     function flipSaleState() public onlyOwner {
1961         saleIsActive = !saleIsActive;
1962     }
1963 
1964     function flipPreSaleState() public onlyOwner {
1965         presaleIsLive = !presaleIsLive;
1966     }
1967 
1968     function lockMetadata() external onlyOwner {
1969         locked = true;
1970     }
1971     
1972     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1973         uint256 tokenCount = balanceOf(_owner);
1974         if (tokenCount == 0) {
1975             return new uint256[](0);
1976         } else {
1977             uint256[] memory result = new uint256[](tokenCount);
1978             uint256 index;
1979             for (index = 0; index < tokenCount; index++) {
1980                 result[index] = tokenOfOwnerByIndex(_owner, index);
1981             }
1982             return result;
1983         }
1984     }
1985     
1986     function mint(uint256 numberOfTokens) public payable {
1987         require(saleIsActive, "Sale must be active to mint");
1988         require(!presaleIsLive, "Only presale");
1989         require(numberOfTokens > 0 && numberOfTokens <= maxCollectiblePerPurchase, "Can only mint 3 tokens at a time.");
1990         require(totalSupply().add(numberOfTokens) <= maxCollectibles, "Purchase would exceed max supply");
1991         require(msg.value >= collectiblePrice.mul(numberOfTokens), "Ether value sent is not correct.");
1992         require(purchases[msg.sender] + numberOfTokens <= purchaseLimit, "Exceed Alloc");
1993         
1994         for(uint i = 0; i < numberOfTokens; i++) {
1995             uint mintIndex = totalSupply() +1;
1996             if (totalSupply() < maxCollectibles) {
1997                 purchases[msg.sender]++;
1998                 _safeMint(msg.sender, mintIndex);
1999             }
2000         }
2001     }
2002 
2003     function presaleMint(uint256 numberOfTokens) external payable {
2004         require(!saleIsActive && presaleIsLive, "Presale closed");
2005         require(presalerList[msg.sender], "Not qualified");
2006         require(totalSupply().add(numberOfTokens) <= maxCollectibles, "Purchase would exceed max supply");
2007         require(presalerListPurchases[msg.sender] + numberOfTokens <= presalePurchaseLimit, "Exceed Alloc");
2008         require(msg.value >= collectiblePrice.mul(numberOfTokens), "Ether value sent is not correct.");
2009         
2010         for (uint i = 0; i < numberOfTokens; i++) {
2011             uint mintIndex = totalSupply() +1;
2012             presalerListPurchases[msg.sender]++;
2013             _safeMint(msg.sender, mintIndex);
2014         }
2015     }
2016 }