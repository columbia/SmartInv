1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-06-12
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-04-22
11 */
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity >=0.6.0 <0.8.0;
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/introspection/IERC165.sol
41 
42 
43 
44 pragma solidity >=0.6.0 <0.8.0;
45 
46 /**
47  * @dev Interface of the ERC165 standard, as defined in the
48  * https://eips.ethereum.org/EIPS/eip-165[EIP].
49  *
50  * Implementers can declare support of contract interfaces, which can then be
51  * queried by others ({ERC165Checker}).
52  *
53  * For an implementation, see {ERC165}.
54  */
55 interface IERC165 {
56     /**
57      * @dev Returns true if this contract implements the interface defined by
58      * `interfaceId`. See the corresponding
59      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
60      * to learn more about how these ids are created.
61      *
62      * This function call must use less than 30 000 gas.
63      */
64     function supportsInterface(bytes4 interfaceId) external view returns (bool);
65 }
66 
67 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
68 
69 
70 
71 pragma solidity >=0.6.2 <0.8.0;
72 
73 
74 /**
75  * @dev Required interface of an ERC721 compliant contract.
76  */
77 interface IERC721 is IERC165 {
78     /**
79      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
82 
83     /**
84      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
85      */
86     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
87 
88     /**
89      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
90      */
91     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
92 
93     /**
94      * @dev Returns the number of tokens in ``owner``'s account.
95      */
96     function balanceOf(address owner) external view returns (uint256 balance);
97 
98     /**
99      * @dev Returns the owner of the `tokenId` token.
100      *
101      * Requirements:
102      *
103      * - `tokenId` must exist.
104      */
105     function ownerOf(uint256 tokenId) external view returns (address owner);
106 
107     /**
108      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
109      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must exist and be owned by `from`.
116      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
118      *
119      * Emits a {Transfer} event.
120      */
121     function safeTransferFrom(address from, address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Transfers `tokenId` token from `from` to `to`.
125      *
126      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
127      *
128      * Requirements:
129      *
130      * - `from` cannot be the zero address.
131      * - `to` cannot be the zero address.
132      * - `tokenId` token must be owned by `from`.
133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(address from, address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
141      * The approval is cleared when the token is transferred.
142      *
143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
144      *
145      * Requirements:
146      *
147      * - The caller must own the token or be an approved operator.
148      * - `tokenId` must exist.
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Approve or remove `operator` as an operator for the caller.
165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
166      *
167      * Requirements:
168      *
169      * - The `operator` cannot be the caller.
170      *
171      * Emits an {ApprovalForAll} event.
172      */
173     function setApprovalForAll(address operator, bool _approved) external;
174 
175     /**
176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
177      *
178      * See {setApprovalForAll}
179      */
180     function isApprovedForAll(address owner, address operator) external view returns (bool);
181 
182     /**
183       * @dev Safely transfers `tokenId` token from `from` to `to`.
184       *
185       * Requirements:
186       *
187       * - `from` cannot be the zero address.
188       * - `to` cannot be the zero address.
189       * - `tokenId` token must exist and be owned by `from`.
190       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192       *
193       * Emits a {Transfer} event.
194       */
195     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
199 
200 
201 
202 pragma solidity >=0.6.2 <0.8.0;
203 
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210 
211     /**
212      * @dev Returns the token collection name.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the token collection symbol.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
223      */
224     function tokenURI(uint256 tokenId) external view returns (string memory);
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
228 
229 
230 
231 pragma solidity >=0.6.2 <0.8.0;
232 
233 
234 /**
235  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
236  * @dev See https://eips.ethereum.org/EIPS/eip-721
237  */
238 interface IERC721Enumerable is IERC721 {
239 
240     /**
241      * @dev Returns the total amount of tokens stored by the contract.
242      */
243     function totalSupply() external view returns (uint256);
244 
245     /**
246      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
247      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
248      */
249     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
250 
251     /**
252      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
253      * Use along with {totalSupply} to enumerate all tokens.
254      */
255     function tokenByIndex(uint256 index) external view returns (uint256);
256 }
257 
258 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
259 
260 
261 
262 pragma solidity >=0.6.0 <0.8.0;
263 
264 /**
265  * @title ERC721 token receiver interface
266  * @dev Interface for any contract that wants to support safeTransfers
267  * from ERC721 asset contracts.
268  */
269 interface IERC721Receiver {
270     /**
271      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
272      * by `operator` from `from`, this function is called.
273      *
274      * It must return its Solidity selector to confirm the token transfer.
275      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
276      *
277      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
278      */
279     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
280 }
281 
282 // File: @openzeppelin/contracts/introspection/ERC165.sol
283 
284 
285 
286 pragma solidity >=0.6.0 <0.8.0;
287 
288 
289 /**
290  * @dev Implementation of the {IERC165} interface.
291  *
292  * Contracts may inherit from this and call {_registerInterface} to declare
293  * their support of an interface.
294  */
295 abstract contract ERC165 is IERC165 {
296     /*
297      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
298      */
299     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
300 
301     /**
302      * @dev Mapping of interface ids to whether or not it's supported.
303      */
304     mapping(bytes4 => bool) private _supportedInterfaces;
305 
306     constructor () internal {
307         // Derived contracts need only register support for their own interfaces,
308         // we register support for ERC165 itself here
309         _registerInterface(_INTERFACE_ID_ERC165);
310     }
311 
312     /**
313      * @dev See {IERC165-supportsInterface}.
314      *
315      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
316      */
317     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318         return _supportedInterfaces[interfaceId];
319     }
320 
321     /**
322      * @dev Registers the contract as an implementer of the interface defined by
323      * `interfaceId`. Support of the actual ERC165 interface is automatic and
324      * registering its interface id is not required.
325      *
326      * See {IERC165-supportsInterface}.
327      *
328      * Requirements:
329      *
330      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
331      */
332     function _registerInterface(bytes4 interfaceId) internal virtual {
333         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
334         _supportedInterfaces[interfaceId] = true;
335     }
336 }
337 
338 // File: @openzeppelin/contracts/math/SafeMath.sol
339 
340 
341 
342 pragma solidity >=0.6.0 <0.8.0;
343 
344 /**
345  * @dev Wrappers over Solidity's arithmetic operations with added overflow
346  * checks.
347  *
348  * Arithmetic operations in Solidity wrap on overflow. This can easily result
349  * in bugs, because programmers usually assume that an overflow raises an
350  * error, which is the standard behavior in high level programming languages.
351  * `SafeMath` restores this intuition by reverting the transaction when an
352  * operation overflows.
353  *
354  * Using this library instead of the unchecked operations eliminates an entire
355  * class of bugs, so it's recommended to use it always.
356  */
357 library SafeMath {
358     /**
359      * @dev Returns the addition of two unsigned integers, with an overflow flag.
360      *
361      * _Available since v3.4._
362      */
363     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
364         uint256 c = a + b;
365         if (c < a) return (false, 0);
366         return (true, c);
367     }
368 
369     /**
370      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         if (b > a) return (false, 0);
376         return (true, a - b);
377     }
378 
379     /**
380      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
386         // benefit is lost if 'b' is also tested.
387         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
388         if (a == 0) return (true, 0);
389         uint256 c = a * b;
390         if (c / a != b) return (false, 0);
391         return (true, c);
392     }
393 
394     /**
395      * @dev Returns the division of two unsigned integers, with a division by zero flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
400         if (b == 0) return (false, 0);
401         return (true, a / b);
402     }
403 
404     /**
405      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
406      *
407      * _Available since v3.4._
408      */
409     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
410         if (b == 0) return (false, 0);
411         return (true, a % b);
412     }
413 
414     /**
415      * @dev Returns the addition of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `+` operator.
419      *
420      * Requirements:
421      *
422      * - Addition cannot overflow.
423      */
424     function add(uint256 a, uint256 b) internal pure returns (uint256) {
425         uint256 c = a + b;
426         require(c >= a, "SafeMath: addition overflow");
427         return c;
428     }
429 
430     /**
431      * @dev Returns the subtraction of two unsigned integers, reverting on
432      * overflow (when the result is negative).
433      *
434      * Counterpart to Solidity's `-` operator.
435      *
436      * Requirements:
437      *
438      * - Subtraction cannot overflow.
439      */
440     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
441         require(b <= a, "SafeMath: subtraction overflow");
442         return a - b;
443     }
444 
445     /**
446      * @dev Returns the multiplication of two unsigned integers, reverting on
447      * overflow.
448      *
449      * Counterpart to Solidity's `*` operator.
450      *
451      * Requirements:
452      *
453      * - Multiplication cannot overflow.
454      */
455     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
456         if (a == 0) return 0;
457         uint256 c = a * b;
458         require(c / a == b, "SafeMath: multiplication overflow");
459         return c;
460     }
461 
462     /**
463      * @dev Returns the integer division of two unsigned integers, reverting on
464      * division by zero. The result is rounded towards zero.
465      *
466      * Counterpart to Solidity's `/` operator. Note: this function uses a
467      * `revert` opcode (which leaves remaining gas untouched) while Solidity
468      * uses an invalid opcode to revert (consuming all remaining gas).
469      *
470      * Requirements:
471      *
472      * - The divisor cannot be zero.
473      */
474     function div(uint256 a, uint256 b) internal pure returns (uint256) {
475         require(b > 0, "SafeMath: division by zero");
476         return a / b;
477     }
478 
479     /**
480      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
481      * reverting when dividing by zero.
482      *
483      * Counterpart to Solidity's `%` operator. This function uses a `revert`
484      * opcode (which leaves remaining gas untouched) while Solidity uses an
485      * invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
492         require(b > 0, "SafeMath: modulo by zero");
493         return a % b;
494     }
495 
496     /**
497      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
498      * overflow (when the result is negative).
499      *
500      * CAUTION: This function is deprecated because it requires allocating memory for the error
501      * message unnecessarily. For custom revert reasons use {trySub}.
502      *
503      * Counterpart to Solidity's `-` operator.
504      *
505      * Requirements:
506      *
507      * - Subtraction cannot overflow.
508      */
509     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b <= a, errorMessage);
511         return a - b;
512     }
513 
514     /**
515      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
516      * division by zero. The result is rounded towards zero.
517      *
518      * CAUTION: This function is deprecated because it requires allocating memory for the error
519      * message unnecessarily. For custom revert reasons use {tryDiv}.
520      *
521      * Counterpart to Solidity's `/` operator. Note: this function uses a
522      * `revert` opcode (which leaves remaining gas untouched) while Solidity
523      * uses an invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      *
527      * - The divisor cannot be zero.
528      */
529     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
530         require(b > 0, errorMessage);
531         return a / b;
532     }
533 
534     /**
535      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
536      * reverting with custom message when dividing by zero.
537      *
538      * CAUTION: This function is deprecated because it requires allocating memory for the error
539      * message unnecessarily. For custom revert reasons use {tryMod}.
540      *
541      * Counterpart to Solidity's `%` operator. This function uses a `revert`
542      * opcode (which leaves remaining gas untouched) while Solidity uses an
543      * invalid opcode to revert (consuming all remaining gas).
544      *
545      * Requirements:
546      *
547      * - The divisor cannot be zero.
548      */
549     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
550         require(b > 0, errorMessage);
551         return a % b;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/Address.sol
556 
557 
558 
559 pragma solidity >=0.6.2 <0.8.0;
560 
561 /**
562  * @dev Collection of functions related to the address type
563  */
564 library Address {
565     /**
566      * @dev Returns true if `account` is a contract.
567      *
568      * [IMPORTANT]
569      * ====
570      * It is unsafe to assume that an address for which this function returns
571      * false is an externally-owned account (EOA) and not a contract.
572      *
573      * Among others, `isContract` will return false for the following
574      * types of addresses:
575      *
576      *  - an externally-owned account
577      *  - a contract in construction
578      *  - an address where a contract will be created
579      *  - an address where a contract lived, but was destroyed
580      * ====
581      */
582     function isContract(address account) internal view returns (bool) {
583         // This method relies on extcodesize, which returns 0 for contracts in
584         // construction, since the code is only stored at the end of the
585         // constructor execution.
586 
587         uint256 size;
588         // solhint-disable-next-line no-inline-assembly
589         assembly { size := extcodesize(account) }
590         return size > 0;
591     }
592 
593     /**
594      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
595      * `recipient`, forwarding all available gas and reverting on errors.
596      *
597      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
598      * of certain opcodes, possibly making contracts go over the 2300 gas limit
599      * imposed by `transfer`, making them unable to receive funds via
600      * `transfer`. {sendValue} removes this limitation.
601      *
602      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
603      *
604      * IMPORTANT: because control is transferred to `recipient`, care must be
605      * taken to not create reentrancy vulnerabilities. Consider using
606      * {ReentrancyGuard} or the
607      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
608      */
609     function sendValue(address payable recipient, uint256 amount) internal {
610         require(address(this).balance >= amount, "Address: insufficient balance");
611 
612         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
613         (bool success, ) = recipient.call{ value: amount }("");
614         require(success, "Address: unable to send value, recipient may have reverted");
615     }
616 
617     /**
618      * @dev Performs a Solidity function call using a low level `call`. A
619      * plain`call` is an unsafe replacement for a function call: use this
620      * function instead.
621      *
622      * If `target` reverts with a revert reason, it is bubbled up by this
623      * function (like regular Solidity function calls).
624      *
625      * Returns the raw returned data. To convert to the expected return value,
626      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
627      *
628      * Requirements:
629      *
630      * - `target` must be a contract.
631      * - calling `target` with `data` must not revert.
632      *
633      * _Available since v3.1._
634      */
635     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
636       return functionCall(target, data, "Address: low-level call failed");
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
641      * `errorMessage` as a fallback revert reason when `target` reverts.
642      *
643      * _Available since v3.1._
644      */
645     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, 0, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but also transferring `value` wei to `target`.
652      *
653      * Requirements:
654      *
655      * - the calling contract must have an ETH balance of at least `value`.
656      * - the called Solidity function must be `payable`.
657      *
658      * _Available since v3.1._
659      */
660     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
661         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
666      * with `errorMessage` as a fallback revert reason when `target` reverts.
667      *
668      * _Available since v3.1._
669      */
670     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
671         require(address(this).balance >= value, "Address: insufficient balance for call");
672         require(isContract(target), "Address: call to non-contract");
673 
674         // solhint-disable-next-line avoid-low-level-calls
675         (bool success, bytes memory returndata) = target.call{ value: value }(data);
676         return _verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but performing a static call.
682      *
683      * _Available since v3.3._
684      */
685     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
686         return functionStaticCall(target, data, "Address: low-level static call failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
691      * but performing a static call.
692      *
693      * _Available since v3.3._
694      */
695     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
696         require(isContract(target), "Address: static call to non-contract");
697 
698         // solhint-disable-next-line avoid-low-level-calls
699         (bool success, bytes memory returndata) = target.staticcall(data);
700         return _verifyCallResult(success, returndata, errorMessage);
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
705      * but performing a delegate call.
706      *
707      * _Available since v3.4._
708      */
709     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
710         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
715      * but performing a delegate call.
716      *
717      * _Available since v3.4._
718      */
719     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
720         require(isContract(target), "Address: delegate call to non-contract");
721 
722         // solhint-disable-next-line avoid-low-level-calls
723         (bool success, bytes memory returndata) = target.delegatecall(data);
724         return _verifyCallResult(success, returndata, errorMessage);
725     }
726 
727     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
728         if (success) {
729             return returndata;
730         } else {
731             // Look for revert reason and bubble it up if present
732             if (returndata.length > 0) {
733                 // The easiest way to bubble the revert reason is using memory via assembly
734 
735                 // solhint-disable-next-line no-inline-assembly
736                 assembly {
737                     let returndata_size := mload(returndata)
738                     revert(add(32, returndata), returndata_size)
739                 }
740             } else {
741                 revert(errorMessage);
742             }
743         }
744     }
745 }
746 
747 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
748 
749 
750 
751 pragma solidity >=0.6.0 <0.8.0;
752 
753 /**
754  * @dev Library for managing
755  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
756  * types.
757  *
758  * Sets have the following properties:
759  *
760  * - Elements are added, removed, and checked for existence in constant time
761  * (O(1)).
762  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
763  *
764  * ```
765  * contract Example {
766  *     // Add the library methods
767  *     using EnumerableSet for EnumerableSet.AddressSet;
768  *
769  *     // Declare a set state variable
770  *     EnumerableSet.AddressSet private mySet;
771  * }
772  * ```
773  *
774  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
775  * and `uint256` (`UintSet`) are supported.
776  */
777 library EnumerableSet {
778     // To implement this library for multiple types with as little code
779     // repetition as possible, we write it in terms of a generic Set type with
780     // bytes32 values.
781     // The Set implementation uses private functions, and user-facing
782     // implementations (such as AddressSet) are just wrappers around the
783     // underlying Set.
784     // This means that we can only create new EnumerableSets for types that fit
785     // in bytes32.
786 
787     struct Set {
788         // Storage of set values
789         bytes32[] _values;
790 
791         // Position of the value in the `values` array, plus 1 because index 0
792         // means a value is not in the set.
793         mapping (bytes32 => uint256) _indexes;
794     }
795 
796     /**
797      * @dev Add a value to a set. O(1).
798      *
799      * Returns true if the value was added to the set, that is if it was not
800      * already present.
801      */
802     function _add(Set storage set, bytes32 value) private returns (bool) {
803         if (!_contains(set, value)) {
804             set._values.push(value);
805             // The value is stored at length-1, but we add 1 to all indexes
806             // and use 0 as a sentinel value
807             set._indexes[value] = set._values.length;
808             return true;
809         } else {
810             return false;
811         }
812     }
813 
814     /**
815      * @dev Removes a value from a set. O(1).
816      *
817      * Returns true if the value was removed from the set, that is if it was
818      * present.
819      */
820     function _remove(Set storage set, bytes32 value) private returns (bool) {
821         // We read and store the value's index to prevent multiple reads from the same storage slot
822         uint256 valueIndex = set._indexes[value];
823 
824         if (valueIndex != 0) { // Equivalent to contains(set, value)
825             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
826             // the array, and then remove the last element (sometimes called as 'swap and pop').
827             // This modifies the order of the array, as noted in {at}.
828 
829             uint256 toDeleteIndex = valueIndex - 1;
830             uint256 lastIndex = set._values.length - 1;
831 
832             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
833             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
834 
835             bytes32 lastvalue = set._values[lastIndex];
836 
837             // Move the last value to the index where the value to delete is
838             set._values[toDeleteIndex] = lastvalue;
839             // Update the index for the moved value
840             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
841 
842             // Delete the slot where the moved value was stored
843             set._values.pop();
844 
845             // Delete the index for the deleted slot
846             delete set._indexes[value];
847 
848             return true;
849         } else {
850             return false;
851         }
852     }
853 
854     /**
855      * @dev Returns true if the value is in the set. O(1).
856      */
857     function _contains(Set storage set, bytes32 value) private view returns (bool) {
858         return set._indexes[value] != 0;
859     }
860 
861     /**
862      * @dev Returns the number of values on the set. O(1).
863      */
864     function _length(Set storage set) private view returns (uint256) {
865         return set._values.length;
866     }
867 
868    /**
869     * @dev Returns the value stored at position `index` in the set. O(1).
870     *
871     * Note that there are no guarantees on the ordering of values inside the
872     * array, and it may change when more values are added or removed.
873     *
874     * Requirements:
875     *
876     * - `index` must be strictly less than {length}.
877     */
878     function _at(Set storage set, uint256 index) private view returns (bytes32) {
879         require(set._values.length > index, "EnumerableSet: index out of bounds");
880         return set._values[index];
881     }
882 
883     // Bytes32Set
884 
885     struct Bytes32Set {
886         Set _inner;
887     }
888 
889     /**
890      * @dev Add a value to a set. O(1).
891      *
892      * Returns true if the value was added to the set, that is if it was not
893      * already present.
894      */
895     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
896         return _add(set._inner, value);
897     }
898 
899     /**
900      * @dev Removes a value from a set. O(1).
901      *
902      * Returns true if the value was removed from the set, that is if it was
903      * present.
904      */
905     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
906         return _remove(set._inner, value);
907     }
908 
909     /**
910      * @dev Returns true if the value is in the set. O(1).
911      */
912     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
913         return _contains(set._inner, value);
914     }
915 
916     /**
917      * @dev Returns the number of values in the set. O(1).
918      */
919     function length(Bytes32Set storage set) internal view returns (uint256) {
920         return _length(set._inner);
921     }
922 
923    /**
924     * @dev Returns the value stored at position `index` in the set. O(1).
925     *
926     * Note that there are no guarantees on the ordering of values inside the
927     * array, and it may change when more values are added or removed.
928     *
929     * Requirements:
930     *
931     * - `index` must be strictly less than {length}.
932     */
933     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
934         return _at(set._inner, index);
935     }
936 
937     // AddressSet
938 
939     struct AddressSet {
940         Set _inner;
941     }
942 
943     /**
944      * @dev Add a value to a set. O(1).
945      *
946      * Returns true if the value was added to the set, that is if it was not
947      * already present.
948      */
949     function add(AddressSet storage set, address value) internal returns (bool) {
950         return _add(set._inner, bytes32(uint256(uint160(value))));
951     }
952 
953     /**
954      * @dev Removes a value from a set. O(1).
955      *
956      * Returns true if the value was removed from the set, that is if it was
957      * present.
958      */
959     function remove(AddressSet storage set, address value) internal returns (bool) {
960         return _remove(set._inner, bytes32(uint256(uint160(value))));
961     }
962 
963     /**
964      * @dev Returns true if the value is in the set. O(1).
965      */
966     function contains(AddressSet storage set, address value) internal view returns (bool) {
967         return _contains(set._inner, bytes32(uint256(uint160(value))));
968     }
969 
970     /**
971      * @dev Returns the number of values in the set. O(1).
972      */
973     function length(AddressSet storage set) internal view returns (uint256) {
974         return _length(set._inner);
975     }
976 
977    /**
978     * @dev Returns the value stored at position `index` in the set. O(1).
979     *
980     * Note that there are no guarantees on the ordering of values inside the
981     * array, and it may change when more values are added or removed.
982     *
983     * Requirements:
984     *
985     * - `index` must be strictly less than {length}.
986     */
987     function at(AddressSet storage set, uint256 index) internal view returns (address) {
988         return address(uint160(uint256(_at(set._inner, index))));
989     }
990 
991 
992     // UintSet
993 
994     struct UintSet {
995         Set _inner;
996     }
997 
998     /**
999      * @dev Add a value to a set. O(1).
1000      *
1001      * Returns true if the value was added to the set, that is if it was not
1002      * already present.
1003      */
1004     function add(UintSet storage set, uint256 value) internal returns (bool) {
1005         return _add(set._inner, bytes32(value));
1006     }
1007 
1008     /**
1009      * @dev Removes a value from a set. O(1).
1010      *
1011      * Returns true if the value was removed from the set, that is if it was
1012      * present.
1013      */
1014     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1015         return _remove(set._inner, bytes32(value));
1016     }
1017 
1018     /**
1019      * @dev Returns true if the value is in the set. O(1).
1020      */
1021     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1022         return _contains(set._inner, bytes32(value));
1023     }
1024 
1025     /**
1026      * @dev Returns the number of values on the set. O(1).
1027      */
1028     function length(UintSet storage set) internal view returns (uint256) {
1029         return _length(set._inner);
1030     }
1031 
1032    /**
1033     * @dev Returns the value stored at position `index` in the set. O(1).
1034     *
1035     * Note that there are no guarantees on the ordering of values inside the
1036     * array, and it may change when more values are added or removed.
1037     *
1038     * Requirements:
1039     *
1040     * - `index` must be strictly less than {length}.
1041     */
1042     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1043         return uint256(_at(set._inner, index));
1044     }
1045 }
1046 
1047 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1048 
1049 
1050 
1051 pragma solidity >=0.6.0 <0.8.0;
1052 
1053 /**
1054  * @dev Library for managing an enumerable variant of Solidity's
1055  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1056  * type.
1057  *
1058  * Maps have the following properties:
1059  *
1060  * - Entries are added, removed, and checked for existence in constant time
1061  * (O(1)).
1062  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1063  *
1064  * ```
1065  * contract Example {
1066  *     // Add the library methods
1067  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1068  *
1069  *     // Declare a set state variable
1070  *     EnumerableMap.UintToAddressMap private myMap;
1071  * }
1072  * ```
1073  *
1074  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1075  * supported.
1076  */
1077 library EnumerableMap {
1078     // To implement this library for multiple types with as little code
1079     // repetition as possible, we write it in terms of a generic Map type with
1080     // bytes32 keys and values.
1081     // The Map implementation uses private functions, and user-facing
1082     // implementations (such as Uint256ToAddressMap) are just wrappers around
1083     // the underlying Map.
1084     // This means that we can only create new EnumerableMaps for types that fit
1085     // in bytes32.
1086 
1087     struct MapEntry {
1088         bytes32 _key;
1089         bytes32 _value;
1090     }
1091 
1092     struct Map {
1093         // Storage of map keys and values
1094         MapEntry[] _entries;
1095 
1096         // Position of the entry defined by a key in the `entries` array, plus 1
1097         // because index 0 means a key is not in the map.
1098         mapping (bytes32 => uint256) _indexes;
1099     }
1100 
1101     /**
1102      * @dev Adds a key-value pair to a map, or updates the value for an existing
1103      * key. O(1).
1104      *
1105      * Returns true if the key was added to the map, that is if it was not
1106      * already present.
1107      */
1108     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1109         // We read and store the key's index to prevent multiple reads from the same storage slot
1110         uint256 keyIndex = map._indexes[key];
1111 
1112         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1113             map._entries.push(MapEntry({ _key: key, _value: value }));
1114             // The entry is stored at length-1, but we add 1 to all indexes
1115             // and use 0 as a sentinel value
1116             map._indexes[key] = map._entries.length;
1117             return true;
1118         } else {
1119             map._entries[keyIndex - 1]._value = value;
1120             return false;
1121         }
1122     }
1123 
1124     /**
1125      * @dev Removes a key-value pair from a map. O(1).
1126      *
1127      * Returns true if the key was removed from the map, that is if it was present.
1128      */
1129     function _remove(Map storage map, bytes32 key) private returns (bool) {
1130         // We read and store the key's index to prevent multiple reads from the same storage slot
1131         uint256 keyIndex = map._indexes[key];
1132 
1133         if (keyIndex != 0) { // Equivalent to contains(map, key)
1134             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1135             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1136             // This modifies the order of the array, as noted in {at}.
1137 
1138             uint256 toDeleteIndex = keyIndex - 1;
1139             uint256 lastIndex = map._entries.length - 1;
1140 
1141             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1142             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1143 
1144             MapEntry storage lastEntry = map._entries[lastIndex];
1145 
1146             // Move the last entry to the index where the entry to delete is
1147             map._entries[toDeleteIndex] = lastEntry;
1148             // Update the index for the moved entry
1149             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1150 
1151             // Delete the slot where the moved entry was stored
1152             map._entries.pop();
1153 
1154             // Delete the index for the deleted slot
1155             delete map._indexes[key];
1156 
1157             return true;
1158         } else {
1159             return false;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Returns true if the key is in the map. O(1).
1165      */
1166     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1167         return map._indexes[key] != 0;
1168     }
1169 
1170     /**
1171      * @dev Returns the number of key-value pairs in the map. O(1).
1172      */
1173     function _length(Map storage map) private view returns (uint256) {
1174         return map._entries.length;
1175     }
1176 
1177    /**
1178     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1179     *
1180     * Note that there are no guarantees on the ordering of entries inside the
1181     * array, and it may change when more entries are added or removed.
1182     *
1183     * Requirements:
1184     *
1185     * - `index` must be strictly less than {length}.
1186     */
1187     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1188         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1189 
1190         MapEntry storage entry = map._entries[index];
1191         return (entry._key, entry._value);
1192     }
1193 
1194     /**
1195      * @dev Tries to returns the value associated with `key`.  O(1).
1196      * Does not revert if `key` is not in the map.
1197      */
1198     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1199         uint256 keyIndex = map._indexes[key];
1200         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1201         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1202     }
1203 
1204     /**
1205      * @dev Returns the value associated with `key`.  O(1).
1206      *
1207      * Requirements:
1208      *
1209      * - `key` must be in the map.
1210      */
1211     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1212         uint256 keyIndex = map._indexes[key];
1213         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1214         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1215     }
1216 
1217     /**
1218      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1219      *
1220      * CAUTION: This function is deprecated because it requires allocating memory for the error
1221      * message unnecessarily. For custom revert reasons use {_tryGet}.
1222      */
1223     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1224         uint256 keyIndex = map._indexes[key];
1225         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1226         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1227     }
1228 
1229     // UintToAddressMap
1230 
1231     struct UintToAddressMap {
1232         Map _inner;
1233     }
1234 
1235     /**
1236      * @dev Adds a key-value pair to a map, or updates the value for an existing
1237      * key. O(1).
1238      *
1239      * Returns true if the key was added to the map, that is if it was not
1240      * already present.
1241      */
1242     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1243         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1244     }
1245 
1246     /**
1247      * @dev Removes a value from a set. O(1).
1248      *
1249      * Returns true if the key was removed from the map, that is if it was present.
1250      */
1251     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1252         return _remove(map._inner, bytes32(key));
1253     }
1254 
1255     /**
1256      * @dev Returns true if the key is in the map. O(1).
1257      */
1258     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1259         return _contains(map._inner, bytes32(key));
1260     }
1261 
1262     /**
1263      * @dev Returns the number of elements in the map. O(1).
1264      */
1265     function length(UintToAddressMap storage map) internal view returns (uint256) {
1266         return _length(map._inner);
1267     }
1268 
1269    /**
1270     * @dev Returns the element stored at position `index` in the set. O(1).
1271     * Note that there are no guarantees on the ordering of values inside the
1272     * array, and it may change when more values are added or removed.
1273     *
1274     * Requirements:
1275     *
1276     * - `index` must be strictly less than {length}.
1277     */
1278     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1279         (bytes32 key, bytes32 value) = _at(map._inner, index);
1280         return (uint256(key), address(uint160(uint256(value))));
1281     }
1282 
1283     /**
1284      * @dev Tries to returns the value associated with `key`.  O(1).
1285      * Does not revert if `key` is not in the map.
1286      *
1287      * _Available since v3.4._
1288      */
1289     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1290         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1291         return (success, address(uint160(uint256(value))));
1292     }
1293 
1294     /**
1295      * @dev Returns the value associated with `key`.  O(1).
1296      *
1297      * Requirements:
1298      *
1299      * - `key` must be in the map.
1300      */
1301     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1302         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1303     }
1304 
1305     /**
1306      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1307      *
1308      * CAUTION: This function is deprecated because it requires allocating memory for the error
1309      * message unnecessarily. For custom revert reasons use {tryGet}.
1310      */
1311     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1312         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/utils/Strings.sol
1317 
1318 
1319 
1320 pragma solidity >=0.6.0 <0.8.0;
1321 
1322 /**
1323  * @dev String operations.
1324  */
1325 library Strings {
1326     /**
1327      * @dev Converts a `uint256` to its ASCII `string` representation.
1328      */
1329     function toString(uint256 value) internal pure returns (string memory) {
1330         // Inspired by OraclizeAPI's implementation - MIT licence
1331         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1332 
1333         if (value == 0) {
1334             return "0";
1335         }
1336         uint256 temp = value;
1337         uint256 digits;
1338         while (temp != 0) {
1339             digits++;
1340             temp /= 10;
1341         }
1342         bytes memory buffer = new bytes(digits);
1343         uint256 index = digits - 1;
1344         temp = value;
1345         while (temp != 0) {
1346             buffer[index--] = bytes1(uint8(48 + temp % 10));
1347             temp /= 10;
1348         }
1349         return string(buffer);
1350     }
1351 }
1352 
1353 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1354 
1355 
1356 
1357 pragma solidity >=0.6.0 <0.8.0;
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 /**
1371  * @title ERC721 Non-Fungible Token Standard basic implementation
1372  * @dev see https://eips.ethereum.org/EIPS/eip-721
1373  */
1374 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1375     using SafeMath for uint256;
1376     using Address for address;
1377     using EnumerableSet for EnumerableSet.UintSet;
1378     using EnumerableMap for EnumerableMap.UintToAddressMap;
1379     using Strings for uint256;
1380 
1381     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1382     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1383     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1384 
1385     // Mapping from holder address to their (enumerable) set of owned tokens
1386     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1387 
1388     // Enumerable mapping from token ids to their owners
1389     EnumerableMap.UintToAddressMap private _tokenOwners;
1390 
1391     // Mapping from token ID to approved address
1392     mapping (uint256 => address) private _tokenApprovals;
1393 
1394     // Mapping from owner to operator approvals
1395     mapping (address => mapping (address => bool)) private _operatorApprovals;
1396 
1397     // Token name
1398     string private _name;
1399 
1400     // Token symbol
1401     string private _symbol;
1402 
1403     // Optional mapping for token URIs
1404     mapping (uint256 => string) private _tokenURIs;
1405 
1406     // Base URI
1407     string private _baseURI;
1408 
1409     /*
1410      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1411      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1412      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1413      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1414      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1415      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1416      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1417      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1418      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1419      *
1420      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1421      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1422      */
1423     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1424 
1425     /*
1426      *     bytes4(keccak256('name()')) == 0x06fdde03
1427      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1428      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1429      *
1430      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1431      */
1432     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1433 
1434     /*
1435      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1436      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1437      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1438      *
1439      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1440      */
1441     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1442 
1443     /**
1444      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1445      */
1446     constructor (string memory name_, string memory symbol_) public {
1447         _name = name_;
1448         _symbol = symbol_;
1449 
1450         // register the supported interfaces to conform to ERC721 via ERC165
1451         _registerInterface(_INTERFACE_ID_ERC721);
1452         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1453         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-balanceOf}.
1458      */
1459     function balanceOf(address owner) public view virtual override returns (uint256) {
1460         require(owner != address(0), "ERC721: balance query for the zero address");
1461         return _holderTokens[owner].length();
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-ownerOf}.
1466      */
1467     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1468         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Metadata-name}.
1473      */
1474     function name() public view virtual override returns (string memory) {
1475         return _name;
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Metadata-symbol}.
1480      */
1481     function symbol() public view virtual override returns (string memory) {
1482         return _symbol;
1483     }
1484 
1485     /**
1486      * @dev See {IERC721Metadata-tokenURI}.
1487      */
1488     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1489         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1490 
1491         string memory _tokenURI = _tokenURIs[tokenId];
1492         string memory base = baseURI();
1493 
1494         // If there is no base URI, return the token URI.
1495         if (bytes(base).length == 0) {
1496             return _tokenURI;
1497         }
1498         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1499         if (bytes(_tokenURI).length > 0) {
1500             return string(abi.encodePacked(base, _tokenURI));
1501         }
1502         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1503         return string(abi.encodePacked(base, tokenId.toString()));
1504     }
1505 
1506     /**
1507     * @dev Returns the base URI set via {_setBaseURI}. This will be
1508     * automatically added as a prefix in {tokenURI} to each token's URI, or
1509     * to the token ID if no specific URI is set for that token ID.
1510     */
1511     function baseURI() public view virtual returns (string memory) {
1512         return _baseURI;
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1517      */
1518     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1519         return _holderTokens[owner].at(index);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721Enumerable-totalSupply}.
1524      */
1525     function totalSupply() public view virtual override returns (uint256) {
1526         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1527         return _tokenOwners.length();
1528     }
1529 
1530     /**
1531      * @dev See {IERC721Enumerable-tokenByIndex}.
1532      */
1533     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1534         (uint256 tokenId, ) = _tokenOwners.at(index);
1535         return tokenId;
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-approve}.
1540      */
1541     function approve(address to, uint256 tokenId) public virtual override {
1542         address owner = ERC721.ownerOf(tokenId);
1543         require(to != owner, "ERC721: approval to current owner");
1544 
1545         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1546             "ERC721: approve caller is not owner nor approved for all"
1547         );
1548 
1549         _approve(to, tokenId);
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-getApproved}.
1554      */
1555     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1556         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1557 
1558         return _tokenApprovals[tokenId];
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-setApprovalForAll}.
1563      */
1564     function setApprovalForAll(address operator, bool approved) public virtual override {
1565         require(operator != _msgSender(), "ERC721: approve to caller");
1566 
1567         _operatorApprovals[_msgSender()][operator] = approved;
1568         emit ApprovalForAll(_msgSender(), operator, approved);
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-isApprovedForAll}.
1573      */
1574     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1575         return _operatorApprovals[owner][operator];
1576     }
1577 
1578     /**
1579      * @dev See {IERC721-transferFrom}.
1580      */
1581     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1582         //solhint-disable-next-line max-line-length
1583         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1584 
1585         _transfer(from, to, tokenId);
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-safeTransferFrom}.
1590      */
1591     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1592         safeTransferFrom(from, to, tokenId, "");
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-safeTransferFrom}.
1597      */
1598     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1599         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1600         _safeTransfer(from, to, tokenId, _data);
1601     }
1602 
1603     /**
1604      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1605      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1606      *
1607      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1608      *
1609      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1610      * implement alternative mechanisms to perform token transfer, such as signature-based.
1611      *
1612      * Requirements:
1613      *
1614      * - `from` cannot be the zero address.
1615      * - `to` cannot be the zero address.
1616      * - `tokenId` token must exist and be owned by `from`.
1617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1618      *
1619      * Emits a {Transfer} event.
1620      */
1621     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1622         _transfer(from, to, tokenId);
1623         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1624     }
1625 
1626     /**
1627      * @dev Returns whether `tokenId` exists.
1628      *
1629      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1630      *
1631      * Tokens start existing when they are minted (`_mint`),
1632      * and stop existing when they are burned (`_burn`).
1633      */
1634     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1635         return _tokenOwners.contains(tokenId);
1636     }
1637 
1638     /**
1639      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1640      *
1641      * Requirements:
1642      *
1643      * - `tokenId` must exist.
1644      */
1645     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1646         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1647         address owner = ERC721.ownerOf(tokenId);
1648         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1649     }
1650 
1651     /**
1652      * @dev Safely mints `tokenId` and transfers it to `to`.
1653      *
1654      * Requirements:
1655      d*
1656      * - `tokenId` must not exist.
1657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1658      *
1659      * Emits a {Transfer} event.
1660      */
1661     function _safeMint(address to, uint256 tokenId) internal virtual {
1662         _safeMint(to, tokenId, "");
1663     }
1664 
1665     /**
1666      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1667      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1668      */
1669     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1670         _mint(to, tokenId);
1671         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1672     }
1673 
1674     /**
1675      * @dev Mints `tokenId` and transfers it to `to`.
1676      *
1677      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1678      *
1679      * Requirements:
1680      *
1681      * - `tokenId` must not exist.
1682      * - `to` cannot be the zero address.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _mint(address to, uint256 tokenId) internal virtual {
1687         require(to != address(0), "ERC721: mint to the zero address");
1688         require(!_exists(tokenId), "ERC721: token already minted");
1689 
1690         _beforeTokenTransfer(address(0), to, tokenId);
1691 
1692         _holderTokens[to].add(tokenId);
1693 
1694         _tokenOwners.set(tokenId, to);
1695 
1696         emit Transfer(address(0), to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Destroys `tokenId`.
1701      * The approval is cleared when the token is burned.
1702      *
1703      * Requirements:
1704      *
1705      * - `tokenId` must exist.
1706      *
1707      * Emits a {Transfer} event.
1708      */
1709     function _burn(uint256 tokenId) internal virtual {
1710         address owner = ERC721.ownerOf(tokenId); // internal owner
1711 
1712         _beforeTokenTransfer(owner, address(0), tokenId);
1713 
1714         // Clear approvals
1715         _approve(address(0), tokenId);
1716 
1717         // Clear metadata (if any)
1718         if (bytes(_tokenURIs[tokenId]).length != 0) {
1719             delete _tokenURIs[tokenId];
1720         }
1721 
1722         _holderTokens[owner].remove(tokenId);
1723 
1724         _tokenOwners.remove(tokenId);
1725 
1726         emit Transfer(owner, address(0), tokenId);
1727     }
1728 
1729     /**
1730      * @dev Transfers `tokenId` from `from` to `to`.
1731      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1732      *
1733      * Requirements:
1734      *
1735      * - `to` cannot be the zero address.
1736      * - `tokenId` token must be owned by `from`.
1737      *
1738      * Emits a {Transfer} event.
1739      */
1740     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1741         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1742         require(to != address(0), "ERC721: transfer to the zero address");
1743 
1744         _beforeTokenTransfer(from, to, tokenId);
1745 
1746         // Clear approvals from the previous owner
1747         _approve(address(0), tokenId);
1748 
1749         _holderTokens[from].remove(tokenId);
1750         _holderTokens[to].add(tokenId);
1751 
1752         _tokenOwners.set(tokenId, to);
1753 
1754         emit Transfer(from, to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1759      *
1760      * Requirements:
1761      *
1762      * - `tokenId` must exist.
1763      */
1764     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1765         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1766         _tokenURIs[tokenId] = _tokenURI;
1767     }
1768 
1769     /**
1770      * @dev Internal function to set the base URI for all token IDs. It is
1771      * automatically added as a prefix to the value returned in {tokenURI},
1772      * or to the token ID if {tokenURI} is empty.
1773      */
1774     function _setBaseURI(string memory baseURI_) internal virtual {
1775         _baseURI = baseURI_;
1776     }
1777 
1778     /**
1779      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1780      * The call is not executed if the target address is not a contract.
1781      *
1782      * @param from address representing the previous owner of the given token ID
1783      * @param to target address that will receive the tokens
1784      * @param tokenId uint256 ID of the token to be transferred
1785      * @param _data bytes optional data to send along with the call
1786      * @return bool whether the call correctly returned the expected magic value
1787      */
1788     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1789         private returns (bool)
1790     {
1791         if (!to.isContract()) {
1792             return true;
1793         }
1794         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1795             IERC721Receiver(to).onERC721Received.selector,
1796             _msgSender(),
1797             from,
1798             tokenId,
1799             _data
1800         ), "ERC721: transfer to non ERC721Receiver implementer");
1801         bytes4 retval = abi.decode(returndata, (bytes4));
1802         return (retval == _ERC721_RECEIVED);
1803     }
1804 
1805     /**
1806      * @dev Approve `to` to operate on `tokenId`
1807      *
1808      * Emits an {Approval} event.
1809      */
1810     function _approve(address to, uint256 tokenId) internal virtual {
1811         _tokenApprovals[tokenId] = to;
1812         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1813     }
1814 
1815     /**
1816      * @dev Hook that is called before any token transfer. This includes minting
1817      * and burning.
1818      *
1819      * Calling conditions:
1820      *
1821      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1822      * transferred to `to`.
1823      * - When `from` is zero, `tokenId` will be minted for `to`.
1824      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1825      * - `from` cannot be the zero address.
1826      * - `to` cannot be the zero address.
1827      *
1828      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1829      */
1830     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1831 }
1832 
1833 // File: @openzeppelin/contracts/access/Ownable.sol
1834 
1835 
1836 
1837 pragma solidity >=0.6.0 <0.8.0;
1838 
1839 /**
1840  * @dev Contract module which provides a basic access control mechanism, where
1841  * there is an account (an owner) that can be granted exclusive access to
1842  * specific functions.
1843  *
1844  * By default, the owner account will be the one that deploys the contract. This
1845  * can later be changed with {transferOwnership}.
1846  *
1847  * This module is used through inheritance. It will make available the modifier
1848  * `onlyOwner`, which can be applied to your functions to restrict their use to
1849  * the owner.
1850  */
1851 abstract contract Ownable is Context {
1852     address private _owner;
1853 
1854     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1855 
1856     /**
1857      * @dev Initializes the contract setting the deployer as the initial owner.
1858      */
1859     constructor () internal {
1860         address msgSender = _msgSender();
1861         _owner = msgSender;
1862         emit OwnershipTransferred(address(0), msgSender);
1863     }
1864 
1865     /**
1866      * @dev Returns the address of the current owner.
1867      */
1868     function owner() public view virtual returns (address) {
1869         return _owner;
1870     }
1871 
1872     /**
1873      * @dev Throws if called by any account other than the owner.
1874      */
1875     modifier onlyOwner() {
1876         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1877         _;
1878     }
1879 
1880     /**
1881      * @dev Leaves the contract without owner. It will not be possible to call
1882      * `onlyOwner` functions anymore. Can only be called by the current owner.
1883      *
1884      * NOTE: Renouncing ownership will leave the contract without an owner,
1885      * thereby removing any functionality that is only available to the owner.
1886      */
1887     function renounceOwnership() public virtual onlyOwner {
1888         emit OwnershipTransferred(_owner, address(0));
1889         _owner = address(0);
1890     }
1891 
1892     /**
1893      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1894      * Can only be called by the current owner.
1895      */
1896     function transferOwnership(address newOwner) public virtual onlyOwner {
1897         require(newOwner != address(0), "Ownable: new owner is the zero address");
1898         emit OwnershipTransferred(_owner, newOwner);
1899         _owner = newOwner;
1900     }
1901 }
1902 
1903 // File: contracts/WickedCraniums.sol
1904 
1905 pragma solidity 0.7.0;
1906 
1907 /**
1908  * @title WickedCraniums contract
1909  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1910  */
1911 contract WickedCraniums is ERC721, Ownable {
1912     using SafeMath for uint256;
1913 
1914     string public PROV = "b80d60a4defcca5af3ed6526d8c0f86089b9400659c89da2b2725b32f8686d4a";
1915     uint256 public constant craniumPrice = 60000000000000000; // 0.06 ETH
1916     uint public constant maxCraniumPurchase = 100;
1917     uint256 public MAX_CRANIUMS = 10762;
1918     bool public saleIsActive = false;
1919 
1920     constructor() ERC721("TheWickedCraniums", "TWC") {
1921     }
1922 
1923     function withdraw() public onlyOwner {
1924         uint balance = address(this).balance;
1925         msg.sender.transfer(balance);
1926     }
1927 
1928     function reserveCraniums() public onlyOwner {        
1929         uint supply = totalSupply();
1930         uint i;
1931         for (i = 0; i < 40; i++) {
1932             _safeMint(msg.sender, supply + i);
1933         }
1934     }
1935     
1936     function flipSaleState() public onlyOwner {
1937         saleIsActive = !saleIsActive;
1938     }
1939     
1940     function setBaseURI(string memory baseURI) public onlyOwner {
1941         _setBaseURI(baseURI);
1942     }
1943 
1944     function mintCraniums(uint numberOfTokens) public payable {
1945         require(saleIsActive, "Sale must be active to mint Craniums");
1946         require(numberOfTokens <= maxCraniumPurchase, "Can only mint 100 tokens at a time");
1947         require(totalSupply().add(numberOfTokens) <= MAX_CRANIUMS, "Purchase would exceed max supply of Craniums");
1948         require(craniumPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1949         
1950         for(uint i = 0; i < numberOfTokens; i++) {
1951             uint mintIndex = totalSupply();
1952             if (totalSupply() < MAX_CRANIUMS) {
1953                 _safeMint(msg.sender, mintIndex);
1954             }
1955         }
1956     }
1957 
1958 }