1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 pragma solidity >=0.6.0 <0.8.0;
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
17     function _msgSender() internal view virtual returns (address payable) {
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
31 pragma solidity >=0.6.0 <0.8.0;
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
58 pragma solidity >=0.6.2 <0.8.0;
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
189 pragma solidity >=0.6.2 <0.8.0;
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
218 pragma solidity >=0.6.2 <0.8.0;
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
269 // File: @openzeppelin/contracts/introspection/ERC165.sol
270 
271 
272 
273 pragma solidity >=0.6.0 <0.8.0;
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
329 pragma solidity >=0.6.0 <0.8.0;
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
546 pragma solidity >=0.6.2 <0.8.0;
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
1034 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1035 
1036 
1037 
1038 pragma solidity >=0.6.0 <0.8.0;
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
1307 pragma solidity >=0.6.0 <0.8.0;
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
1330         uint256 index = digits - 1;
1331         temp = value;
1332         while (temp != 0) {
1333             buffer[index--] = bytes1(uint8(48 + temp % 10));
1334             temp /= 10;
1335         }
1336         return string(buffer);
1337     }
1338 }
1339 
1340 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1341 
1342 
1343 
1344 pragma solidity >=0.6.0 <0.8.0;
1345 
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 
1357 /**
1358  * @title ERC721 Non-Fungible Token Standard basic implementation
1359  * @dev see https://eips.ethereum.org/EIPS/eip-721
1360  */
1361 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1362     using SafeMath for uint256;
1363     using Address for address;
1364     using EnumerableSet for EnumerableSet.UintSet;
1365     using EnumerableMap for EnumerableMap.UintToAddressMap;
1366     using Strings for uint256;
1367 
1368     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1369     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1370     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1371 
1372     // Mapping from holder address to their (enumerable) set of owned tokens
1373     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1374 
1375     // Enumerable mapping from token ids to their owners
1376     EnumerableMap.UintToAddressMap private _tokenOwners;
1377 
1378     // Mapping from token ID to approved address
1379     mapping (uint256 => address) private _tokenApprovals;
1380 
1381     // Mapping from owner to operator approvals
1382     mapping (address => mapping (address => bool)) private _operatorApprovals;
1383 
1384     // Token name
1385     string private _name;
1386 
1387     // Token symbol
1388     string private _symbol;
1389 
1390     // Optional mapping for token URIs
1391     mapping (uint256 => string) private _tokenURIs;
1392 
1393     // Base URI
1394     string private _baseURI;
1395 
1396     /*
1397      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1398      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1399      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1400      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1401      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1402      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1403      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1404      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1405      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1406      *
1407      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1408      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1409      */
1410     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1411 
1412     /*
1413      *     bytes4(keccak256('name()')) == 0x06fdde03
1414      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1415      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1416      *
1417      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1418      */
1419     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1420 
1421     /*
1422      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1423      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1424      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1425      *
1426      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1427      */
1428     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1429 
1430     /**
1431      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1432      */
1433     constructor (string memory name_, string memory symbol_) public {
1434         _name = name_;
1435         _symbol = symbol_;
1436 
1437         // register the supported interfaces to conform to ERC721 via ERC165
1438         _registerInterface(_INTERFACE_ID_ERC721);
1439         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1440         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1441     }
1442 
1443     /**
1444      * @dev See {IERC721-balanceOf}.
1445      */
1446     function balanceOf(address owner) public view virtual override returns (uint256) {
1447         require(owner != address(0), "ERC721: balance query for the zero address");
1448         return _holderTokens[owner].length();
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-ownerOf}.
1453      */
1454     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1455         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Metadata-name}.
1460      */
1461     function name() public view virtual override returns (string memory) {
1462         return _name;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Metadata-symbol}.
1467      */
1468     function symbol() public view virtual override returns (string memory) {
1469         return _symbol;
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Metadata-tokenURI}.
1474      */
1475     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1476         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1477 
1478         string memory _tokenURI = _tokenURIs[tokenId];
1479         string memory base = baseURI();
1480 
1481         // If there is no base URI, return the token URI.
1482         if (bytes(base).length == 0) {
1483             return _tokenURI;
1484         }
1485         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1486         if (bytes(_tokenURI).length > 0) {
1487             return string(abi.encodePacked(base, _tokenURI));
1488         }
1489         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1490         return string(abi.encodePacked(base, tokenId.toString()));
1491     }
1492 
1493     /**
1494     * @dev Returns the base URI set via {_setBaseURI}. This will be
1495     * automatically added as a prefix in {tokenURI} to each token's URI, or
1496     * to the token ID if no specific URI is set for that token ID.
1497     */
1498     function baseURI() public view virtual returns (string memory) {
1499         return _baseURI;
1500     }
1501 
1502     /**
1503      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1504      */
1505     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1506         return _holderTokens[owner].at(index);
1507     }
1508 
1509     /**
1510      * @dev See {IERC721Enumerable-totalSupply}.
1511      */
1512     function totalSupply() public view virtual override returns (uint256) {
1513         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1514         return _tokenOwners.length();
1515     }
1516 
1517     /**
1518      * @dev See {IERC721Enumerable-tokenByIndex}.
1519      */
1520     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1521         (uint256 tokenId, ) = _tokenOwners.at(index);
1522         return tokenId;
1523     }
1524 
1525     /**
1526      * @dev See {IERC721-approve}.
1527      */
1528     function approve(address to, uint256 tokenId) public virtual override {
1529         address owner = ERC721.ownerOf(tokenId);
1530         require(to != owner, "ERC721: approval to current owner");
1531 
1532         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1533             "ERC721: approve caller is not owner nor approved for all"
1534         );
1535 
1536         _approve(to, tokenId);
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-getApproved}.
1541      */
1542     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1543         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1544 
1545         return _tokenApprovals[tokenId];
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-setApprovalForAll}.
1550      */
1551     function setApprovalForAll(address operator, bool approved) public virtual override {
1552         require(operator != _msgSender(), "ERC721: approve to caller");
1553 
1554         _operatorApprovals[_msgSender()][operator] = approved;
1555         emit ApprovalForAll(_msgSender(), operator, approved);
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-isApprovedForAll}.
1560      */
1561     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1562         return _operatorApprovals[owner][operator];
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-transferFrom}.
1567      */
1568     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1569         //solhint-disable-next-line max-line-length
1570         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1571 
1572         _transfer(from, to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-safeTransferFrom}.
1577      */
1578     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1579         safeTransferFrom(from, to, tokenId, "");
1580     }
1581 
1582     /**
1583      * @dev See {IERC721-safeTransferFrom}.
1584      */
1585     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1586         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1587         _safeTransfer(from, to, tokenId, _data);
1588     }
1589 
1590     /**
1591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1593      *
1594      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1595      *
1596      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1597      * implement alternative mechanisms to perform token transfer, such as signature-based.
1598      *
1599      * Requirements:
1600      *
1601      * - `from` cannot be the zero address.
1602      * - `to` cannot be the zero address.
1603      * - `tokenId` token must exist and be owned by `from`.
1604      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1609         _transfer(from, to, tokenId);
1610         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1611     }
1612 
1613     /**
1614      * @dev Returns whether `tokenId` exists.
1615      *
1616      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1617      *
1618      * Tokens start existing when they are minted (`_mint`),
1619      * and stop existing when they are burned (`_burn`).
1620      */
1621     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1622         return _tokenOwners.contains(tokenId);
1623     }
1624 
1625     /**
1626      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      */
1632     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1633         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1634         address owner = ERC721.ownerOf(tokenId);
1635         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1636     }
1637 
1638     /**
1639      * @dev Safely mints `tokenId` and transfers it to `to`.
1640      *
1641      * Requirements:
1642      d*
1643      * - `tokenId` must not exist.
1644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _safeMint(address to, uint256 tokenId) internal virtual {
1649         _safeMint(to, tokenId, "");
1650     }
1651 
1652     /**
1653      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1654      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1655      */
1656     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1657         _mint(to, tokenId);
1658         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1659     }
1660 
1661     /**
1662      * @dev Mints `tokenId` and transfers it to `to`.
1663      *
1664      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1665      *
1666      * Requirements:
1667      *
1668      * - `tokenId` must not exist.
1669      * - `to` cannot be the zero address.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _mint(address to, uint256 tokenId) internal virtual {
1674         require(to != address(0), "ERC721: mint to the zero address");
1675         require(!_exists(tokenId), "ERC721: token already minted");
1676 
1677         _beforeTokenTransfer(address(0), to, tokenId);
1678 
1679         _holderTokens[to].add(tokenId);
1680 
1681         _tokenOwners.set(tokenId, to);
1682 
1683         emit Transfer(address(0), to, tokenId);
1684     }
1685 
1686     /**
1687      * @dev Destroys `tokenId`.
1688      * The approval is cleared when the token is burned.
1689      *
1690      * Requirements:
1691      *
1692      * - `tokenId` must exist.
1693      *
1694      * Emits a {Transfer} event.
1695      */
1696     function _burn(uint256 tokenId) internal virtual {
1697         address owner = ERC721.ownerOf(tokenId); // internal owner
1698 
1699         _beforeTokenTransfer(owner, address(0), tokenId);
1700 
1701         // Clear approvals
1702         _approve(address(0), tokenId);
1703 
1704         // Clear metadata (if any)
1705         if (bytes(_tokenURIs[tokenId]).length != 0) {
1706             delete _tokenURIs[tokenId];
1707         }
1708 
1709         _holderTokens[owner].remove(tokenId);
1710 
1711         _tokenOwners.remove(tokenId);
1712 
1713         emit Transfer(owner, address(0), tokenId);
1714     }
1715 
1716     /**
1717      * @dev Transfers `tokenId` from `from` to `to`.
1718      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1719      *
1720      * Requirements:
1721      *
1722      * - `to` cannot be the zero address.
1723      * - `tokenId` token must be owned by `from`.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1728         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1729         require(to != address(0), "ERC721: transfer to the zero address");
1730 
1731         _beforeTokenTransfer(from, to, tokenId);
1732 
1733         // Clear approvals from the previous owner
1734         _approve(address(0), tokenId);
1735 
1736         _holderTokens[from].remove(tokenId);
1737         _holderTokens[to].add(tokenId);
1738 
1739         _tokenOwners.set(tokenId, to);
1740 
1741         emit Transfer(from, to, tokenId);
1742     }
1743 
1744     /**
1745      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1746      *
1747      * Requirements:
1748      *
1749      * - `tokenId` must exist.
1750      */
1751     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1752         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1753         _tokenURIs[tokenId] = _tokenURI;
1754     }
1755 
1756     /**
1757      * @dev Internal function to set the base URI for all token IDs. It is
1758      * automatically added as a prefix to the value returned in {tokenURI},
1759      * or to the token ID if {tokenURI} is empty.
1760      */
1761     function _setBaseURI(string memory baseURI_) internal virtual {
1762         _baseURI = baseURI_;
1763     }
1764 
1765     /**
1766      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1767      * The call is not executed if the target address is not a contract.
1768      *
1769      * @param from address representing the previous owner of the given token ID
1770      * @param to target address that will receive the tokens
1771      * @param tokenId uint256 ID of the token to be transferred
1772      * @param _data bytes optional data to send along with the call
1773      * @return bool whether the call correctly returned the expected magic value
1774      */
1775     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1776         private returns (bool)
1777     {
1778         if (!to.isContract()) {
1779             return true;
1780         }
1781         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1782             IERC721Receiver(to).onERC721Received.selector,
1783             _msgSender(),
1784             from,
1785             tokenId,
1786             _data
1787         ), "ERC721: transfer to non ERC721Receiver implementer");
1788         bytes4 retval = abi.decode(returndata, (bytes4));
1789         return (retval == _ERC721_RECEIVED);
1790     }
1791 
1792     /**
1793      * @dev Approve `to` to operate on `tokenId`
1794      *
1795      * Emits an {Approval} event.
1796      */
1797     function _approve(address to, uint256 tokenId) internal virtual {
1798         _tokenApprovals[tokenId] = to;
1799         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1800     }
1801 
1802     /**
1803      * @dev Hook that is called before any token transfer. This includes minting
1804      * and burning.
1805      *
1806      * Calling conditions:
1807      *
1808      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1809      * transferred to `to`.
1810      * - When `from` is zero, `tokenId` will be minted for `to`.
1811      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1812      * - `from` cannot be the zero address.
1813      * - `to` cannot be the zero address.
1814      *
1815      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1816      */
1817     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1818 }
1819 
1820 // File: @openzeppelin/contracts/access/Ownable.sol
1821 
1822 
1823 
1824 pragma solidity >=0.6.0 <0.8.0;
1825 
1826 /**
1827  * @dev Contract module which provides a basic access control mechanism, where
1828  * there is an account (an owner) that can be granted exclusive access to
1829  * specific functions.
1830  *
1831  * By default, the owner account will be the one that deploys the contract. This
1832  * can later be changed with {transferOwnership}.
1833  *
1834  * This module is used through inheritance. It will make available the modifier
1835  * `onlyOwner`, which can be applied to your functions to restrict their use to
1836  * the owner.
1837  */
1838 abstract contract Ownable is Context {
1839     address private _owner;
1840 
1841     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1842 
1843     /**
1844      * @dev Initializes the contract setting the deployer as the initial owner.
1845      */
1846     constructor () internal {
1847         address msgSender = _msgSender();
1848         _owner = msgSender;
1849         emit OwnershipTransferred(address(0), msgSender);
1850     }
1851 
1852     /**
1853      * @dev Returns the address of the current owner.
1854      */
1855     function owner() public view virtual returns (address) {
1856         return _owner;
1857     }
1858 
1859     /**
1860      * @dev Throws if called by any account other than the owner.
1861      */
1862     modifier onlyOwner() {
1863         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1864         _;
1865     }
1866 
1867     /**
1868      * @dev Leaves the contract without owner. It will not be possible to call
1869      * `onlyOwner` functions anymore. Can only be called by the current owner.
1870      *
1871      * NOTE: Renouncing ownership will leave the contract without an owner,
1872      * thereby removing any functionality that is only available to the owner.
1873      */
1874     function renounceOwnership() public virtual onlyOwner {
1875         emit OwnershipTransferred(_owner, address(0));
1876         _owner = address(0);
1877     }
1878 
1879     /**
1880      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1881      * Can only be called by the current owner.
1882      */
1883     function transferOwnership(address newOwner) public virtual onlyOwner {
1884         require(newOwner != address(0), "Ownable: new owner is the zero address");
1885         emit OwnershipTransferred(_owner, newOwner);
1886         _owner = newOwner;
1887     }
1888 }
1889 
1890 // File: @openzeppelin/contracts/utils/Counters.sol
1891 
1892 
1893 
1894 pragma solidity >=0.6.0 <0.8.0;
1895 
1896 
1897 /**
1898  * @title Counters
1899  * @author Matt Condon (@shrugs)
1900  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1901  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1902  *
1903  * Include with `using Counters for Counters.Counter;`
1904  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1905  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1906  * directly accessed.
1907  */
1908 library Counters {
1909     using SafeMath for uint256;
1910 
1911     struct Counter {
1912         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1913         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1914         // this feature: see https://github.com/ethereum/solidity/issues/4637
1915         uint256 _value; // default: 0
1916     }
1917 
1918     function current(Counter storage counter) internal view returns (uint256) {
1919         return counter._value;
1920     }
1921 
1922     function increment(Counter storage counter) internal {
1923         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1924         counter._value += 1;
1925     }
1926 
1927     function decrement(Counter storage counter) internal {
1928         counter._value = counter._value.sub(1);
1929     }
1930 }
1931 
1932 // File: contracts/Etherpoems.sol
1933 
1934 
1935 pragma solidity >=0.7.6;
1936 
1937 /**
1938  *    __ _   _                ___
1939  *   /__\ |_| |__   ___ _ __ / _ \___   ___ _ __ ___  ___
1940  *  /_\ | __| '_ \ / _ \ '__/ /_)/ _ \ / _ \ '_ ` _ \/ __|
1941  * //__ | |_| | | |  __/ | / ___/ (_) |  __/ | | | | \__ \
1942  * \__/  \__|_| |_|\___|_| \/    \___/ \___|_| |_| |_|___/
1943  *
1944  */
1945 
1946 
1947 
1948 
1949 contract Etherpoems is ERC721, Ownable {
1950   using Counters for Counters.Counter;
1951   Counters.Counter private _tokenIds;
1952 
1953   mapping(string => uint8) public myTokenURI;
1954   mapping(string => uint8) public myTokenName;
1955   mapping(uint256 => Poem) public poems;
1956   mapping(uint256 => uint256) public rarefractalsNFTClaimed;
1957 
1958   uint256 public constant MAX_NFT_SUPPLY = 206;
1959   uint256 public constant currentPrice = 100000000000000000;
1960   address internal rarefractals;
1961   address internal paymentSplitter;
1962 
1963   bool private reentrancyLock = false;
1964   bool public communityGrant = true;
1965 
1966   struct Poem {
1967     string name;
1968     string text;
1969     string author;
1970   }
1971 
1972   event TokenBought(
1973     uint256 mintedTokenID,
1974     string poemName,
1975     string poemText,
1976     string author
1977   );
1978 
1979   modifier reentrancyGuard {
1980     if (reentrancyLock) {
1981       revert();
1982     }
1983     reentrancyLock = true;
1984     _;
1985     reentrancyLock = false;
1986   }
1987 
1988   constructor(address _rareFractals, address _paymentSplitter)
1989     public
1990     ERC721("Etherpoems", "ETHP")
1991   {
1992     rarefractals = _rareFractals;
1993     paymentSplitter = _paymentSplitter;
1994   }
1995 
1996   function mint(
1997     string memory _myTokenURI,
1998     string memory _poemName,
1999     string memory _poemText,
2000     string memory _poemAuthor
2001   ) external payable reentrancyGuard {
2002     // Validate token to be minted
2003     _validateTokenToBeMinted(_myTokenURI, _poemName);
2004     require(getNFTPrice() == msg.value, "Ether value sent is not correct");
2005     // Split payment with Authors
2006     (bool sent, ) = paymentSplitter.call{ value: msg.value }("");
2007     require(sent, "Failed to send Ether to payment splitter.");
2008     // Mint the token
2009     _mint(_myTokenURI, _poemName, _poemText, _poemAuthor);
2010   }
2011 
2012   /**
2013    * Community grant minting for each Rarefractals NFT Owner.
2014    */
2015   function mintWithRareFractals(
2016     uint256 _rareFractalsTokenID,
2017     string memory _myTokenURI,
2018     string memory _poemName,
2019     string memory _poemText,
2020     string memory _poemAuthor
2021   ) external reentrancyGuard {
2022     require(communityGrant);
2023     // RareFractals NFT is with in valid range
2024     require(
2025       _rareFractalsTokenID >= 0 && _rareFractalsTokenID < 500,
2026       "Invalid RareFractals NFT"
2027     );
2028     // RareFractals NFT is not already used to claim etherPoem NFT
2029     require(
2030       rarefractalsNFTClaimed[_rareFractalsTokenID] == 0,
2031       "Already minted with this RareFractals NFT"
2032     );
2033     // etherPoem claimer owns the RareFractals NFT
2034     require(
2035       IERC721(rarefractals).ownerOf(_rareFractalsTokenID) == msg.sender,
2036       "Not the owner of this RareFractals NFT"
2037     );
2038     _validateTokenToBeMinted(_myTokenURI, _poemName);
2039     // Mark the RareFractals NFT to be claimed
2040     rarefractalsNFTClaimed[_rareFractalsTokenID] = 1;
2041     _mint(_myTokenURI, _poemName, _poemText, _poemAuthor);
2042   }
2043 
2044   function _mint(
2045     string memory _myTokenURI,
2046     string memory _poemName,
2047     string memory _poemText,
2048     string memory _poemAuthor
2049   ) internal {
2050     // mark token URI as minted
2051     myTokenURI[_myTokenURI] = 1;
2052     // mark token name as taken
2053     myTokenName[_poemName] = 1;
2054     // new token id
2055     uint256 newItemId = _tokenIds.current();
2056     // save poem on chain
2057     poems[newItemId].text = _poemText;
2058     poems[newItemId].name = _poemName;
2059     poems[newItemId].author = _poemAuthor;
2060     // mint token && assign ownership of token to msg.sender
2061     _safeMint(msg.sender, newItemId);
2062     // set token url
2063     _setTokenURI(newItemId, _myTokenURI);
2064     // emit TokenBought event
2065     emit TokenBought(newItemId, _poemName, _poemText, _poemAuthor);
2066     // increment token counter for sold token
2067     _tokenIds.increment();
2068   }
2069 
2070   // The owner can mint without paying
2071   function ownerMint(
2072     string memory _myTokenURI,
2073     string memory _poemName,
2074     string memory _poemText,
2075     string memory _poemAuthor
2076   ) external reentrancyGuard onlyOwner {
2077     _validateTokenToBeMinted(_myTokenURI, _poemName);
2078     _mint(_myTokenURI, _poemName, _poemText, _poemAuthor);
2079   }
2080 
2081   function _validateTokenToBeMinted(
2082     string memory _myTokenURI,
2083     string memory _poemName
2084   ) internal view {
2085     require(_tokenIds.current() < MAX_NFT_SUPPLY, "Sale has already ended");
2086     require(myTokenURI[_myTokenURI] != 1, "Token URI is already minted");
2087     require(myTokenName[_poemName] != 1, "Token Name is already minted");
2088   }
2089 
2090   function withdraw() public payable onlyOwner {
2091     uint256 balance = address(this).balance;
2092     msg.sender.transfer(balance);
2093   }
2094 
2095   function getPoem(uint256 _tokenID) public view returns (string memory) {
2096     require(_tokenID <= _tokenIds.current());
2097     return (poems[_tokenID].text);
2098   }
2099 
2100   function getName(uint256 _tokenID) public view returns (string memory) {
2101     require(_tokenID <= _tokenIds.current());
2102     return (poems[_tokenID].name);
2103   }
2104 
2105   function getAuthor(uint256 _tokenID) public view returns (string memory) {
2106     require(_tokenID <= _tokenIds.current());
2107     return (poems[_tokenID].author);
2108   }
2109 
2110   function getNFTPrice() public pure returns (uint256) {
2111     return currentPrice;
2112   }
2113 
2114   function toggleCommunityGrant() external onlyOwner {
2115     communityGrant = !communityGrant;
2116   }
2117 
2118   receive() external payable {}
2119 }