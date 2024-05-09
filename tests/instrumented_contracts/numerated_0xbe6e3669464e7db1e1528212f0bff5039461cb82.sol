1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Implementation of the {IERC165} interface.
35  *
36  * Contracts may inherit from this and call {_registerInterface} to declare
37  * their support of an interface.
38  */
39 abstract contract ERC165 is IERC165 {
40     /*
41      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
42      */
43     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
44 
45     /**
46      * @dev Mapping of interface ids to whether or not it's supported.
47      */
48     mapping(bytes4 => bool) private _supportedInterfaces;
49 
50     constructor () internal {
51         // Derived contracts need only register support for their own interfaces,
52         // we register support for ERC165 itself here
53         _registerInterface(_INTERFACE_ID_ERC165);
54     }
55 
56     /**
57      * @dev See {IERC165-supportsInterface}.
58      *
59      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
60      */
61     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
62         return _supportedInterfaces[interfaceId];
63     }
64 
65     /**
66      * @dev Registers the contract as an implementer of the interface defined by
67      * `interfaceId`. Support of the actual ERC165 interface is automatic and
68      * registering its interface id is not required.
69      *
70      * See {IERC165-supportsInterface}.
71      *
72      * Requirements:
73      *
74      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
75      */
76     function _registerInterface(bytes4 interfaceId) internal virtual {
77         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
78         _supportedInterfaces[interfaceId] = true;
79     }
80 }
81 
82 
83 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
84 
85 pragma solidity >=0.6.0 <0.8.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
110 
111 pragma solidity >=0.6.2 <0.8.0;
112 
113 /**
114  * @dev Required interface of an ERC721 compliant contract.
115  */
116 interface IERC721 is IERC165 {
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
124      */
125     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
131 
132     /**
133      * @dev Returns the number of tokens in ``owner``'s account.
134      */
135     function balanceOf(address owner) external view returns (uint256 balance);
136 
137     /**
138      * @dev Returns the owner of the `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function ownerOf(uint256 tokenId) external view returns (address owner);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(address from, address to, uint256 tokenId) external;
161 
162     /**
163      * @dev Transfers `tokenId` token from `from` to `to`.
164      *
165      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(address from, address to, uint256 tokenId) external;
177 
178     /**
179      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
180      * The approval is cleared when the token is transferred.
181      *
182      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
183      *
184      * Requirements:
185      *
186      * - The caller must own the token or be an approved operator.
187      * - `tokenId` must exist.
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Returns the account approved for `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function getApproved(uint256 tokenId) external view returns (address operator);
201 
202     /**
203      * @dev Approve or remove `operator` as an operator for the caller.
204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
205      *
206      * Requirements:
207      *
208      * - The `operator` cannot be the caller.
209      *
210      * Emits an {ApprovalForAll} event.
211      */
212     function setApprovalForAll(address operator, bool _approved) external;
213 
214     /**
215      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
216      *
217      * See {setApprovalForAll}
218      */
219     function isApprovedForAll(address owner, address operator) external view returns (bool);
220 
221     /**
222       * @dev Safely transfers `tokenId` token from `from` to `to`.
223       *
224       * Requirements:
225       *
226       * - `from` cannot be the zero address.
227       * - `to` cannot be the zero address.
228       * - `tokenId` token must exist and be owned by `from`.
229       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
231       *
232       * Emits a {Transfer} event.
233       */
234     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
235 }
236 
237 
238 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
239 
240 pragma solidity >=0.6.2 <0.8.0;
241 
242 /**
243  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
244  * @dev See https://eips.ethereum.org/EIPS/eip-721
245  */
246 interface IERC721Metadata is IERC721 {
247 
248     /**
249      * @dev Returns the token collection name.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the token collection symbol.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
260      */
261     function tokenURI(uint256 tokenId) external view returns (string memory);
262 }
263 
264 
265 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
266 
267 pragma solidity >=0.6.2 <0.8.0;
268 
269 /**
270  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
271  * @dev See https://eips.ethereum.org/EIPS/eip-721
272  */
273 interface IERC721Enumerable is IERC721 {
274 
275     /**
276      * @dev Returns the total amount of tokens stored by the contract.
277      */
278     function totalSupply() external view returns (uint256);
279 
280     /**
281      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
282      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
283      */
284     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
285 
286     /**
287      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
288      * Use along with {totalSupply} to enumerate all tokens.
289      */
290     function tokenByIndex(uint256 index) external view returns (uint256);
291 }
292 
293 
294 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
295 
296 pragma solidity >=0.6.0 <0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
314 }
315 
316 
317 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
318 
319 pragma solidity >=0.6.0 <0.8.0;
320 
321 /**
322  * @dev Wrappers over Solidity's arithmetic operations with added overflow
323  * checks.
324  *
325  * Arithmetic operations in Solidity wrap on overflow. This can easily result
326  * in bugs, because programmers usually assume that an overflow raises an
327  * error, which is the standard behavior in high level programming languages.
328  * `SafeMath` restores this intuition by reverting the transaction when an
329  * operation overflows.
330  *
331  * Using this library instead of the unchecked operations eliminates an entire
332  * class of bugs, so it's recommended to use it always.
333  */
334 library SafeMath {
335     /**
336      * @dev Returns the addition of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         uint256 c = a + b;
342         if (c < a) return (false, 0);
343         return (true, c);
344     }
345 
346     /**
347      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
352         if (b > a) return (false, 0);
353         return (true, a - b);
354     }
355 
356     /**
357      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
358      *
359      * _Available since v3.4._
360      */
361     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
363         // benefit is lost if 'b' is also tested.
364         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
365         if (a == 0) return (true, 0);
366         uint256 c = a * b;
367         if (c / a != b) return (false, 0);
368         return (true, c);
369     }
370 
371     /**
372      * @dev Returns the division of two unsigned integers, with a division by zero flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         if (b == 0) return (false, 0);
378         return (true, a / b);
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
383      *
384      * _Available since v3.4._
385      */
386     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         if (b == 0) return (false, 0);
388         return (true, a % b);
389     }
390 
391     /**
392      * @dev Returns the addition of two unsigned integers, reverting on
393      * overflow.
394      *
395      * Counterpart to Solidity's `+` operator.
396      *
397      * Requirements:
398      *
399      * - Addition cannot overflow.
400      */
401     function add(uint256 a, uint256 b) internal pure returns (uint256) {
402         uint256 c = a + b;
403         require(c >= a, "SafeMath: addition overflow");
404         return c;
405     }
406 
407     /**
408      * @dev Returns the subtraction of two unsigned integers, reverting on
409      * overflow (when the result is negative).
410      *
411      * Counterpart to Solidity's `-` operator.
412      *
413      * Requirements:
414      *
415      * - Subtraction cannot overflow.
416      */
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         require(b <= a, "SafeMath: subtraction overflow");
419         return a - b;
420     }
421 
422     /**
423      * @dev Returns the multiplication of two unsigned integers, reverting on
424      * overflow.
425      *
426      * Counterpart to Solidity's `*` operator.
427      *
428      * Requirements:
429      *
430      * - Multiplication cannot overflow.
431      */
432     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
433         if (a == 0) return 0;
434         uint256 c = a * b;
435         require(c / a == b, "SafeMath: multiplication overflow");
436         return c;
437     }
438 
439     /**
440      * @dev Returns the integer division of two unsigned integers, reverting on
441      * division by zero. The result is rounded towards zero.
442      *
443      * Counterpart to Solidity's `/` operator. Note: this function uses a
444      * `revert` opcode (which leaves remaining gas untouched) while Solidity
445      * uses an invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(uint256 a, uint256 b) internal pure returns (uint256) {
452         require(b > 0, "SafeMath: division by zero");
453         return a / b;
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
458      * reverting when dividing by zero.
459      *
460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
461      * opcode (which leaves remaining gas untouched) while Solidity uses an
462      * invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
469         require(b > 0, "SafeMath: modulo by zero");
470         return a % b;
471     }
472 
473     /**
474      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
475      * overflow (when the result is negative).
476      *
477      * CAUTION: This function is deprecated because it requires allocating memory for the error
478      * message unnecessarily. For custom revert reasons use {trySub}.
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
487         require(b <= a, errorMessage);
488         return a - b;
489     }
490 
491     /**
492      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
493      * division by zero. The result is rounded towards zero.
494      *
495      * CAUTION: This function is deprecated because it requires allocating memory for the error
496      * message unnecessarily. For custom revert reasons use {tryDiv}.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b > 0, errorMessage);
508         return a / b;
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * reverting with custom message when dividing by zero.
514      *
515      * CAUTION: This function is deprecated because it requires allocating memory for the error
516      * message unnecessarily. For custom revert reasons use {tryMod}.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
527         require(b > 0, errorMessage);
528         return a % b;
529     }
530 }
531 
532 
533 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
534 
535 pragma solidity >=0.6.2 <0.8.0;
536 
537 /**
538  * @dev Collection of functions related to the address type
539  */
540 library Address {
541     /**
542      * @dev Returns true if `account` is a contract.
543      *
544      * [IMPORTANT]
545      * ====
546      * It is unsafe to assume that an address for which this function returns
547      * false is an externally-owned account (EOA) and not a contract.
548      *
549      * Among others, `isContract` will return false for the following
550      * types of addresses:
551      *
552      *  - an externally-owned account
553      *  - a contract in construction
554      *  - an address where a contract will be created
555      *  - an address where a contract lived, but was destroyed
556      * ====
557      */
558     function isContract(address account) internal view returns (bool) {
559         // This method relies on extcodesize, which returns 0 for contracts in
560         // construction, since the code is only stored at the end of the
561         // constructor execution.
562 
563         uint256 size;
564         // solhint-disable-next-line no-inline-assembly
565         assembly { size := extcodesize(account) }
566         return size > 0;
567     }
568 
569     /**
570      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
571      * `recipient`, forwarding all available gas and reverting on errors.
572      *
573      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
574      * of certain opcodes, possibly making contracts go over the 2300 gas limit
575      * imposed by `transfer`, making them unable to receive funds via
576      * `transfer`. {sendValue} removes this limitation.
577      *
578      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
579      *
580      * IMPORTANT: because control is transferred to `recipient`, care must be
581      * taken to not create reentrancy vulnerabilities. Consider using
582      * {ReentrancyGuard} or the
583      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
584      */
585     function sendValue(address payable recipient, uint256 amount) internal {
586         require(address(this).balance >= amount, "Address: insufficient balance");
587 
588         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
589         (bool success, ) = recipient.call{ value: amount }("");
590         require(success, "Address: unable to send value, recipient may have reverted");
591     }
592 
593     /**
594      * @dev Performs a Solidity function call using a low level `call`. A
595      * plain`call` is an unsafe replacement for a function call: use this
596      * function instead.
597      *
598      * If `target` reverts with a revert reason, it is bubbled up by this
599      * function (like regular Solidity function calls).
600      *
601      * Returns the raw returned data. To convert to the expected return value,
602      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
603      *
604      * Requirements:
605      *
606      * - `target` must be a contract.
607      * - calling `target` with `data` must not revert.
608      *
609      * _Available since v3.1._
610      */
611     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
612       return functionCall(target, data, "Address: low-level call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
617      * `errorMessage` as a fallback revert reason when `target` reverts.
618      *
619      * _Available since v3.1._
620      */
621     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, 0, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but also transferring `value` wei to `target`.
628      *
629      * Requirements:
630      *
631      * - the calling contract must have an ETH balance of at least `value`.
632      * - the called Solidity function must be `payable`.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
637         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
642      * with `errorMessage` as a fallback revert reason when `target` reverts.
643      *
644      * _Available since v3.1._
645      */
646     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
647         require(address(this).balance >= value, "Address: insufficient balance for call");
648         require(isContract(target), "Address: call to non-contract");
649 
650         // solhint-disable-next-line avoid-low-level-calls
651         (bool success, bytes memory returndata) = target.call{ value: value }(data);
652         return _verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a static call.
658      *
659      * _Available since v3.3._
660      */
661     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
662         return functionStaticCall(target, data, "Address: low-level static call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a static call.
668      *
669      * _Available since v3.3._
670      */
671     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
672         require(isContract(target), "Address: static call to non-contract");
673 
674         // solhint-disable-next-line avoid-low-level-calls
675         (bool success, bytes memory returndata) = target.staticcall(data);
676         return _verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but performing a delegate call.
682      *
683      * _Available since v3.4._
684      */
685     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
686         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
691      * but performing a delegate call.
692      *
693      * _Available since v3.4._
694      */
695     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
696         require(isContract(target), "Address: delegate call to non-contract");
697 
698         // solhint-disable-next-line avoid-low-level-calls
699         (bool success, bytes memory returndata) = target.delegatecall(data);
700         return _verifyCallResult(success, returndata, errorMessage);
701     }
702 
703     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
704         if (success) {
705             return returndata;
706         } else {
707             // Look for revert reason and bubble it up if present
708             if (returndata.length > 0) {
709                 // The easiest way to bubble the revert reason is using memory via assembly
710 
711                 // solhint-disable-next-line no-inline-assembly
712                 assembly {
713                     let returndata_size := mload(returndata)
714                     revert(add(32, returndata), returndata_size)
715                 }
716             } else {
717                 revert(errorMessage);
718             }
719         }
720     }
721 }
722 
723 
724 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
725 
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
1022 
1023 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
1024 
1025 pragma solidity >=0.6.0 <0.8.0;
1026 
1027 /**
1028  * @dev Library for managing an enumerable variant of Solidity's
1029  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1030  * type.
1031  *
1032  * Maps have the following properties:
1033  *
1034  * - Entries are added, removed, and checked for existence in constant time
1035  * (O(1)).
1036  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1037  *
1038  * ```
1039  * contract Example {
1040  *     // Add the library methods
1041  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1042  *
1043  *     // Declare a set state variable
1044  *     EnumerableMap.UintToAddressMap private myMap;
1045  * }
1046  * ```
1047  *
1048  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1049  * supported.
1050  */
1051 library EnumerableMap {
1052     // To implement this library for multiple types with as little code
1053     // repetition as possible, we write it in terms of a generic Map type with
1054     // bytes32 keys and values.
1055     // The Map implementation uses private functions, and user-facing
1056     // implementations (such as Uint256ToAddressMap) are just wrappers around
1057     // the underlying Map.
1058     // This means that we can only create new EnumerableMaps for types that fit
1059     // in bytes32.
1060 
1061     struct MapEntry {
1062         bytes32 _key;
1063         bytes32 _value;
1064     }
1065 
1066     struct Map {
1067         // Storage of map keys and values
1068         MapEntry[] _entries;
1069 
1070         // Position of the entry defined by a key in the `entries` array, plus 1
1071         // because index 0 means a key is not in the map.
1072         mapping (bytes32 => uint256) _indexes;
1073     }
1074 
1075     /**
1076      * @dev Adds a key-value pair to a map, or updates the value for an existing
1077      * key. O(1).
1078      *
1079      * Returns true if the key was added to the map, that is if it was not
1080      * already present.
1081      */
1082     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1083         // We read and store the key's index to prevent multiple reads from the same storage slot
1084         uint256 keyIndex = map._indexes[key];
1085 
1086         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1087             map._entries.push(MapEntry({ _key: key, _value: value }));
1088             // The entry is stored at length-1, but we add 1 to all indexes
1089             // and use 0 as a sentinel value
1090             map._indexes[key] = map._entries.length;
1091             return true;
1092         } else {
1093             map._entries[keyIndex - 1]._value = value;
1094             return false;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Removes a key-value pair from a map. O(1).
1100      *
1101      * Returns true if the key was removed from the map, that is if it was present.
1102      */
1103     function _remove(Map storage map, bytes32 key) private returns (bool) {
1104         // We read and store the key's index to prevent multiple reads from the same storage slot
1105         uint256 keyIndex = map._indexes[key];
1106 
1107         if (keyIndex != 0) { // Equivalent to contains(map, key)
1108             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1109             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1110             // This modifies the order of the array, as noted in {at}.
1111 
1112             uint256 toDeleteIndex = keyIndex - 1;
1113             uint256 lastIndex = map._entries.length - 1;
1114 
1115             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1116             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1117 
1118             MapEntry storage lastEntry = map._entries[lastIndex];
1119 
1120             // Move the last entry to the index where the entry to delete is
1121             map._entries[toDeleteIndex] = lastEntry;
1122             // Update the index for the moved entry
1123             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1124 
1125             // Delete the slot where the moved entry was stored
1126             map._entries.pop();
1127 
1128             // Delete the index for the deleted slot
1129             delete map._indexes[key];
1130 
1131             return true;
1132         } else {
1133             return false;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Returns true if the key is in the map. O(1).
1139      */
1140     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1141         return map._indexes[key] != 0;
1142     }
1143 
1144     /**
1145      * @dev Returns the number of key-value pairs in the map. O(1).
1146      */
1147     function _length(Map storage map) private view returns (uint256) {
1148         return map._entries.length;
1149     }
1150 
1151    /**
1152     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1153     *
1154     * Note that there are no guarantees on the ordering of entries inside the
1155     * array, and it may change when more entries are added or removed.
1156     *
1157     * Requirements:
1158     *
1159     * - `index` must be strictly less than {length}.
1160     */
1161     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1162         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1163 
1164         MapEntry storage entry = map._entries[index];
1165         return (entry._key, entry._value);
1166     }
1167 
1168     /**
1169      * @dev Tries to returns the value associated with `key`.  O(1).
1170      * Does not revert if `key` is not in the map.
1171      */
1172     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1173         uint256 keyIndex = map._indexes[key];
1174         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1175         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1176     }
1177 
1178     /**
1179      * @dev Returns the value associated with `key`.  O(1).
1180      *
1181      * Requirements:
1182      *
1183      * - `key` must be in the map.
1184      */
1185     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1186         uint256 keyIndex = map._indexes[key];
1187         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1188         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1189     }
1190 
1191     /**
1192      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1193      *
1194      * CAUTION: This function is deprecated because it requires allocating memory for the error
1195      * message unnecessarily. For custom revert reasons use {_tryGet}.
1196      */
1197     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1198         uint256 keyIndex = map._indexes[key];
1199         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1200         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1201     }
1202 
1203     // UintToAddressMap
1204 
1205     struct UintToAddressMap {
1206         Map _inner;
1207     }
1208 
1209     /**
1210      * @dev Adds a key-value pair to a map, or updates the value for an existing
1211      * key. O(1).
1212      *
1213      * Returns true if the key was added to the map, that is if it was not
1214      * already present.
1215      */
1216     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1217         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1218     }
1219 
1220     /**
1221      * @dev Removes a value from a set. O(1).
1222      *
1223      * Returns true if the key was removed from the map, that is if it was present.
1224      */
1225     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1226         return _remove(map._inner, bytes32(key));
1227     }
1228 
1229     /**
1230      * @dev Returns true if the key is in the map. O(1).
1231      */
1232     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1233         return _contains(map._inner, bytes32(key));
1234     }
1235 
1236     /**
1237      * @dev Returns the number of elements in the map. O(1).
1238      */
1239     function length(UintToAddressMap storage map) internal view returns (uint256) {
1240         return _length(map._inner);
1241     }
1242 
1243    /**
1244     * @dev Returns the element stored at position `index` in the set. O(1).
1245     * Note that there are no guarantees on the ordering of values inside the
1246     * array, and it may change when more values are added or removed.
1247     *
1248     * Requirements:
1249     *
1250     * - `index` must be strictly less than {length}.
1251     */
1252     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1253         (bytes32 key, bytes32 value) = _at(map._inner, index);
1254         return (uint256(key), address(uint160(uint256(value))));
1255     }
1256 
1257     /**
1258      * @dev Tries to returns the value associated with `key`.  O(1).
1259      * Does not revert if `key` is not in the map.
1260      *
1261      * _Available since v3.4._
1262      */
1263     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1264         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1265         return (success, address(uint160(uint256(value))));
1266     }
1267 
1268     /**
1269      * @dev Returns the value associated with `key`.  O(1).
1270      *
1271      * Requirements:
1272      *
1273      * - `key` must be in the map.
1274      */
1275     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1276         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1277     }
1278 
1279     /**
1280      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1281      *
1282      * CAUTION: This function is deprecated because it requires allocating memory for the error
1283      * message unnecessarily. For custom revert reasons use {tryGet}.
1284      */
1285     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1286         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1287     }
1288 }
1289 
1290 
1291 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
1292 
1293 pragma solidity >=0.6.0 <0.8.0;
1294 
1295 /**
1296  * @dev String operations.
1297  */
1298 library Strings {
1299     /**
1300      * @dev Converts a `uint256` to its ASCII `string` representation.
1301      */
1302     function toString(uint256 value) internal pure returns (string memory) {
1303         // Inspired by OraclizeAPI's implementation - MIT licence
1304         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1305 
1306         if (value == 0) {
1307             return "0";
1308         }
1309         uint256 temp = value;
1310         uint256 digits;
1311         while (temp != 0) {
1312             digits++;
1313             temp /= 10;
1314         }
1315         bytes memory buffer = new bytes(digits);
1316         uint256 index = digits - 1;
1317         temp = value;
1318         while (temp != 0) {
1319             buffer[index--] = bytes1(uint8(48 + temp % 10));
1320             temp /= 10;
1321         }
1322         return string(buffer);
1323     }
1324 }
1325 
1326 
1327 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1328 
1329 pragma solidity >=0.6.0 <0.8.0;
1330 
1331 
1332 
1333 
1334 
1335 
1336 
1337 
1338 
1339 
1340 
1341 /**
1342  * @title ERC721 Non-Fungible Token Standard basic implementation
1343  * @dev see https://eips.ethereum.org/EIPS/eip-721
1344  */
1345 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1346     using SafeMath for uint256;
1347     using Address for address;
1348     using EnumerableSet for EnumerableSet.UintSet;
1349     using EnumerableMap for EnumerableMap.UintToAddressMap;
1350     using Strings for uint256;
1351 
1352     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1353     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1354     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1355 
1356     // Mapping from holder address to their (enumerable) set of owned tokens
1357     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1358 
1359     // Enumerable mapping from token ids to their owners
1360     EnumerableMap.UintToAddressMap private _tokenOwners;
1361 
1362     // Mapping from token ID to approved address
1363     mapping (uint256 => address) private _tokenApprovals;
1364 
1365     // Mapping from owner to operator approvals
1366     mapping (address => mapping (address => bool)) private _operatorApprovals;
1367 
1368     // Token name
1369     string private _name;
1370 
1371     // Token symbol
1372     string private _symbol;
1373 
1374     // Optional mapping for token URIs
1375     mapping (uint256 => string) private _tokenURIs;
1376 
1377     // Base URI
1378     string private _baseURI;
1379 
1380     /*
1381      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1382      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1383      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1384      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1385      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1386      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1387      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1388      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1389      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1390      *
1391      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1392      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1393      */
1394     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1395 
1396     /*
1397      *     bytes4(keccak256('name()')) == 0x06fdde03
1398      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1399      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1400      *
1401      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1402      */
1403     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1404 
1405     /*
1406      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1407      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1408      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1409      *
1410      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1411      */
1412     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1413 
1414     /**
1415      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1416      */
1417     constructor (string memory name_, string memory symbol_) public {
1418         _name = name_;
1419         _symbol = symbol_;
1420 
1421         // register the supported interfaces to conform to ERC721 via ERC165
1422         _registerInterface(_INTERFACE_ID_ERC721);
1423         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1424         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-balanceOf}.
1429      */
1430     function balanceOf(address owner) public view virtual override returns (uint256) {
1431         require(owner != address(0), "ERC721: balance query for the zero address");
1432         return _holderTokens[owner].length();
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-ownerOf}.
1437      */
1438     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1439         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Metadata-name}.
1444      */
1445     function name() public view virtual override returns (string memory) {
1446         return _name;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Metadata-symbol}.
1451      */
1452     function symbol() public view virtual override returns (string memory) {
1453         return _symbol;
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Metadata-tokenURI}.
1458      */
1459     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1460         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1461 
1462         string memory _tokenURI = _tokenURIs[tokenId];
1463         string memory base = baseURI();
1464 
1465         // If there is no base URI, return the token URI.
1466         if (bytes(base).length == 0) {
1467             return _tokenURI;
1468         }
1469         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1470         if (bytes(_tokenURI).length > 0) {
1471             return string(abi.encodePacked(base, _tokenURI));
1472         }
1473         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1474         return string(abi.encodePacked(base, tokenId.toString()));
1475     }
1476 
1477     /**
1478     * @dev Returns the base URI set via {_setBaseURI}. This will be
1479     * automatically added as a prefix in {tokenURI} to each token's URI, or
1480     * to the token ID if no specific URI is set for that token ID.
1481     */
1482     function baseURI() public view virtual returns (string memory) {
1483         return _baseURI;
1484     }
1485 
1486     /**
1487      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1488      */
1489     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1490         return _holderTokens[owner].at(index);
1491     }
1492 
1493     /**
1494      * @dev See {IERC721Enumerable-totalSupply}.
1495      */
1496     function totalSupply() public view virtual override returns (uint256) {
1497         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1498         return _tokenOwners.length();
1499     }
1500 
1501     /**
1502      * @dev See {IERC721Enumerable-tokenByIndex}.
1503      */
1504     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1505         (uint256 tokenId, ) = _tokenOwners.at(index);
1506         return tokenId;
1507     }
1508 
1509     /**
1510      * @dev See {IERC721-approve}.
1511      */
1512     function approve(address to, uint256 tokenId) public virtual override {
1513         address owner = ERC721.ownerOf(tokenId);
1514         require(to != owner, "ERC721: approval to current owner");
1515 
1516         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1517             "ERC721: approve caller is not owner nor approved for all"
1518         );
1519 
1520         _approve(to, tokenId);
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-getApproved}.
1525      */
1526     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1527         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1528 
1529         return _tokenApprovals[tokenId];
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-setApprovalForAll}.
1534      */
1535     function setApprovalForAll(address operator, bool approved) public virtual override {
1536         require(operator != _msgSender(), "ERC721: approve to caller");
1537 
1538         _operatorApprovals[_msgSender()][operator] = approved;
1539         emit ApprovalForAll(_msgSender(), operator, approved);
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-isApprovedForAll}.
1544      */
1545     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1546         return _operatorApprovals[owner][operator];
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-transferFrom}.
1551      */
1552     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1553         //solhint-disable-next-line max-line-length
1554         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1555 
1556         _transfer(from, to, tokenId);
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-safeTransferFrom}.
1561      */
1562     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1563         safeTransferFrom(from, to, tokenId, "");
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-safeTransferFrom}.
1568      */
1569     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1570         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1571         _safeTransfer(from, to, tokenId, _data);
1572     }
1573 
1574     /**
1575      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1576      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1577      *
1578      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1579      *
1580      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1581      * implement alternative mechanisms to perform token transfer, such as signature-based.
1582      *
1583      * Requirements:
1584      *
1585      * - `from` cannot be the zero address.
1586      * - `to` cannot be the zero address.
1587      * - `tokenId` token must exist and be owned by `from`.
1588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1593         _transfer(from, to, tokenId);
1594         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1595     }
1596 
1597     /**
1598      * @dev Returns whether `tokenId` exists.
1599      *
1600      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1601      *
1602      * Tokens start existing when they are minted (`_mint`),
1603      * and stop existing when they are burned (`_burn`).
1604      */
1605     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1606         return _tokenOwners.contains(tokenId);
1607     }
1608 
1609     /**
1610      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      */
1616     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1617         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1618         address owner = ERC721.ownerOf(tokenId);
1619         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1620     }
1621 
1622     /**
1623      * @dev Safely mints `tokenId` and transfers it to `to`.
1624      *
1625      * Requirements:
1626      d*
1627      * - `tokenId` must not exist.
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _safeMint(address to, uint256 tokenId) internal virtual {
1633         _safeMint(to, tokenId, "");
1634     }
1635 
1636     /**
1637      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1638      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1639      */
1640     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1641         _mint(to, tokenId);
1642         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1643     }
1644 
1645     /**
1646      * @dev Mints `tokenId` and transfers it to `to`.
1647      *
1648      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1649      *
1650      * Requirements:
1651      *
1652      * - `tokenId` must not exist.
1653      * - `to` cannot be the zero address.
1654      *
1655      * Emits a {Transfer} event.
1656      */
1657     function _mint(address to, uint256 tokenId) internal virtual {
1658         require(to != address(0), "ERC721: mint to the zero address");
1659         require(!_exists(tokenId), "ERC721: token already minted");
1660 
1661         _beforeTokenTransfer(address(0), to, tokenId);
1662 
1663         _holderTokens[to].add(tokenId);
1664 
1665         _tokenOwners.set(tokenId, to);
1666 
1667         emit Transfer(address(0), to, tokenId);
1668     }
1669 
1670     /**
1671      * @dev Destroys `tokenId`.
1672      * The approval is cleared when the token is burned.
1673      *
1674      * Requirements:
1675      *
1676      * - `tokenId` must exist.
1677      *
1678      * Emits a {Transfer} event.
1679      */
1680     function _burn(uint256 tokenId) internal virtual {
1681         address owner = ERC721.ownerOf(tokenId); // internal owner
1682 
1683         _beforeTokenTransfer(owner, address(0), tokenId);
1684 
1685         // Clear approvals
1686         _approve(address(0), tokenId);
1687 
1688         // Clear metadata (if any)
1689         if (bytes(_tokenURIs[tokenId]).length != 0) {
1690             delete _tokenURIs[tokenId];
1691         }
1692 
1693         _holderTokens[owner].remove(tokenId);
1694 
1695         _tokenOwners.remove(tokenId);
1696 
1697         emit Transfer(owner, address(0), tokenId);
1698     }
1699 
1700     /**
1701      * @dev Transfers `tokenId` from `from` to `to`.
1702      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1703      *
1704      * Requirements:
1705      *
1706      * - `to` cannot be the zero address.
1707      * - `tokenId` token must be owned by `from`.
1708      *
1709      * Emits a {Transfer} event.
1710      */
1711     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1712         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1713         require(to != address(0), "ERC721: transfer to the zero address");
1714 
1715         _beforeTokenTransfer(from, to, tokenId);
1716 
1717         // Clear approvals from the previous owner
1718         _approve(address(0), tokenId);
1719 
1720         _holderTokens[from].remove(tokenId);
1721         _holderTokens[to].add(tokenId);
1722 
1723         _tokenOwners.set(tokenId, to);
1724 
1725         emit Transfer(from, to, tokenId);
1726     }
1727 
1728     /**
1729      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1730      *
1731      * Requirements:
1732      *
1733      * - `tokenId` must exist.
1734      */
1735     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1736         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1737         _tokenURIs[tokenId] = _tokenURI;
1738     }
1739 
1740     /**
1741      * @dev Internal function to set the base URI for all token IDs. It is
1742      * automatically added as a prefix to the value returned in {tokenURI},
1743      * or to the token ID if {tokenURI} is empty.
1744      */
1745     function _setBaseURI(string memory baseURI_) internal virtual {
1746         _baseURI = baseURI_;
1747     }
1748 
1749     /**
1750      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1751      * The call is not executed if the target address is not a contract.
1752      *
1753      * @param from address representing the previous owner of the given token ID
1754      * @param to target address that will receive the tokens
1755      * @param tokenId uint256 ID of the token to be transferred
1756      * @param _data bytes optional data to send along with the call
1757      * @return bool whether the call correctly returned the expected magic value
1758      */
1759     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1760         private returns (bool)
1761     {
1762         if (!to.isContract()) {
1763             return true;
1764         }
1765         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1766             IERC721Receiver(to).onERC721Received.selector,
1767             _msgSender(),
1768             from,
1769             tokenId,
1770             _data
1771         ), "ERC721: transfer to non ERC721Receiver implementer");
1772         bytes4 retval = abi.decode(returndata, (bytes4));
1773         return (retval == _ERC721_RECEIVED);
1774     }
1775 
1776     /**
1777      * @dev Approve `to` to operate on `tokenId`
1778      *
1779      * Emits an {Approval} event.
1780      */
1781     function _approve(address to, uint256 tokenId) internal virtual {
1782         _tokenApprovals[tokenId] = to;
1783         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1784     }
1785 
1786     /**
1787      * @dev Hook that is called before any token transfer. This includes minting
1788      * and burning.
1789      *
1790      * Calling conditions:
1791      *
1792      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1793      * transferred to `to`.
1794      * - When `from` is zero, `tokenId` will be minted for `to`.
1795      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1796      * - `from` cannot be the zero address.
1797      * - `to` cannot be the zero address.
1798      *
1799      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1800      */
1801     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1802 }
1803 
1804 
1805 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
1806 
1807 pragma solidity >=0.6.0 <0.8.0;
1808 
1809 /**
1810  * @dev Interface of the ERC20 standard as defined in the EIP.
1811  */
1812 interface IERC20 {
1813     /**
1814      * @dev Returns the amount of tokens in existence.
1815      */
1816     function totalSupply() external view returns (uint256);
1817 
1818     /**
1819      * @dev Returns the amount of tokens owned by `account`.
1820      */
1821     function balanceOf(address account) external view returns (uint256);
1822 
1823     /**
1824      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1825      *
1826      * Returns a boolean value indicating whether the operation succeeded.
1827      *
1828      * Emits a {Transfer} event.
1829      */
1830     function transfer(address recipient, uint256 amount) external returns (bool);
1831 
1832     /**
1833      * @dev Returns the remaining number of tokens that `spender` will be
1834      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1835      * zero by default.
1836      *
1837      * This value changes when {approve} or {transferFrom} are called.
1838      */
1839     function allowance(address owner, address spender) external view returns (uint256);
1840 
1841     /**
1842      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1843      *
1844      * Returns a boolean value indicating whether the operation succeeded.
1845      *
1846      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1847      * that someone may use both the old and the new allowance by unfortunate
1848      * transaction ordering. One possible solution to mitigate this race
1849      * condition is to first reduce the spender's allowance to 0 and set the
1850      * desired value afterwards:
1851      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1852      *
1853      * Emits an {Approval} event.
1854      */
1855     function approve(address spender, uint256 amount) external returns (bool);
1856 
1857     /**
1858      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1859      * allowance mechanism. `amount` is then deducted from the caller's
1860      * allowance.
1861      *
1862      * Returns a boolean value indicating whether the operation succeeded.
1863      *
1864      * Emits a {Transfer} event.
1865      */
1866     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1867 
1868     /**
1869      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1870      * another (`to`).
1871      *
1872      * Note that `value` may be zero.
1873      */
1874     event Transfer(address indexed from, address indexed to, uint256 value);
1875 
1876     /**
1877      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1878      * a call to {approve}. `value` is the new allowance.
1879      */
1880     event Approval(address indexed owner, address indexed spender, uint256 value);
1881 }
1882 
1883 
1884 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1885 
1886 pragma solidity >=0.6.0 <0.8.0;
1887 
1888 /**
1889  * @dev Contract module which provides a basic access control mechanism, where
1890  * there is an account (an owner) that can be granted exclusive access to
1891  * specific functions.
1892  *
1893  * By default, the owner account will be the one that deploys the contract. This
1894  * can later be changed with {transferOwnership}.
1895  *
1896  * This module is used through inheritance. It will make available the modifier
1897  * `onlyOwner`, which can be applied to your functions to restrict their use to
1898  * the owner.
1899  */
1900 abstract contract Ownable is Context {
1901     address private _owner;
1902 
1903     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1904 
1905     /**
1906      * @dev Initializes the contract setting the deployer as the initial owner.
1907      */
1908     constructor () internal {
1909         address msgSender = _msgSender();
1910         _owner = msgSender;
1911         emit OwnershipTransferred(address(0), msgSender);
1912     }
1913 
1914     /**
1915      * @dev Returns the address of the current owner.
1916      */
1917     function owner() public view virtual returns (address) {
1918         return _owner;
1919     }
1920 
1921     /**
1922      * @dev Throws if called by any account other than the owner.
1923      */
1924     modifier onlyOwner() {
1925         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1926         _;
1927     }
1928 
1929     /**
1930      * @dev Leaves the contract without owner. It will not be possible to call
1931      * `onlyOwner` functions anymore. Can only be called by the current owner.
1932      *
1933      * NOTE: Renouncing ownership will leave the contract without an owner,
1934      * thereby removing any functionality that is only available to the owner.
1935      */
1936     function renounceOwnership() public virtual onlyOwner {
1937         emit OwnershipTransferred(_owner, address(0));
1938         _owner = address(0);
1939     }
1940 
1941     /**
1942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1943      * Can only be called by the current owner.
1944      */
1945     function transferOwnership(address newOwner) public virtual onlyOwner {
1946         require(newOwner != address(0), "Ownable: new owner is the zero address");
1947         emit OwnershipTransferred(_owner, newOwner);
1948         _owner = newOwner;
1949     }
1950 }
1951 
1952 
1953 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1954 
1955 pragma solidity >=0.6.0 <0.8.0;
1956 
1957 /**
1958  * @title Counters
1959  * @author Matt Condon (@shrugs)
1960  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1961  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1962  *
1963  * Include with `using Counters for Counters.Counter;`
1964  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1965  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1966  * directly accessed.
1967  */
1968 library Counters {
1969     using SafeMath for uint256;
1970 
1971     struct Counter {
1972         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1973         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1974         // this feature: see https://github.com/ethereum/solidity/issues/4637
1975         uint256 _value; // default: 0
1976     }
1977 
1978     function current(Counter storage counter) internal view returns (uint256) {
1979         return counter._value;
1980     }
1981 
1982     function increment(Counter storage counter) internal {
1983         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1984         counter._value += 1;
1985     }
1986 
1987     function decrement(Counter storage counter) internal {
1988         counter._value = counter._value.sub(1);
1989     }
1990 }
1991 
1992 
1993 // File contracts/WickedApes.sol
1994 pragma solidity ^0.7.3;
1995 
1996 
1997 
1998 
1999 
2000 
2001 
2002 contract WickedApes is Ownable, ERC165, ERC721 {
2003     // Libraries
2004     using Counters for Counters.Counter;
2005     using Strings for uint256;
2006     using SafeMath for uint256;
2007 
2008     // Private fields
2009     Counters.Counter private _tokenIds;
2010     string private ipfsUri = "https://ipfs.io/ipfs/";
2011 
2012     // Public constants
2013     uint256 public constant MAX_SUPPLY = 10000;
2014 
2015     // Public fields
2016     bool public open = false;
2017 
2018     string public folder = "";
2019 
2020     string public provenance = "";
2021 
2022     string public provenanceURI = "";
2023 
2024     bool public locked = false;
2025 
2026     uint256 public mintPrice = 0.0333 ether;
2027 
2028     modifier notLocked() {
2029         require(!locked, "Contract has been locked");
2030         _;
2031     }
2032 
2033     constructor() ERC721("Wicked Apes", "WKDAPE") {
2034         _setBaseURI(
2035             "https://us-central1-wicked-apes.cloudfunctions.net/app/v1/"
2036         );
2037         ownerMint(20);
2038     }
2039 
2040     // Public methods
2041     function mint(uint256 quantity) public payable {
2042         require(open, "Drop not open yet");
2043         require(quantity > 0, "Quantity must be at least 1");
2044 
2045         // Limit buys
2046         if (quantity > 100) {
2047             quantity = 100;
2048         }
2049 
2050         // Limit buys that exceed MAX_SUPPLY
2051         if (quantity.add(totalSupply()) > MAX_SUPPLY) {
2052             quantity = MAX_SUPPLY.sub(totalSupply());
2053         }
2054 
2055         uint256 price = getPrice(quantity);
2056 
2057         // Ensure enough ETH
2058         require(msg.value >= price, "Not enough ETH sent");
2059 
2060         for (uint256 i = 0; i < quantity; i++) {
2061             _mintInternal(msg.sender);
2062         }
2063 
2064         // Return any remaining ether after the buy
2065         uint256 remaining = msg.value.sub(price);
2066 
2067         if (remaining > 0) {
2068             (bool success, ) = msg.sender.call{value: remaining}("");
2069             require(success);
2070         }
2071     }
2072 
2073     function getQuantityFromValue(uint256 value) public view returns (uint256) {
2074         return value.div(mintPrice);
2075     }
2076 
2077     function getPrice(uint256 quantity) public view returns (uint256) {
2078         require(quantity <= MAX_SUPPLY);
2079         return quantity.mul(mintPrice);
2080     }
2081 
2082     function tokenURI(uint256 tokenId)
2083         public
2084         view
2085         virtual
2086         override
2087         returns (string memory)
2088     {
2089         require(
2090             tokenId > 0 && tokenId <= totalSupply(),
2091             "URI query for nonexistent token"
2092         );
2093         if (bytes(folder).length > 0) {
2094             return
2095                 string(
2096                     abi.encodePacked(ipfsUri, folder, "/", tokenId.toString())
2097                 );
2098         }
2099         return string(abi.encodePacked(baseURI(), tokenId.toString()));
2100     }
2101 
2102     // Admin methods
2103     function ownerMint(uint256 quantity) public onlyOwner {
2104         for (uint256 i = 0; i < quantity; i++) {
2105             _mintInternal(msg.sender);
2106         }
2107     }
2108 
2109     function setOpen(bool shouldOpen) external onlyOwner {
2110         open = shouldOpen;
2111     }
2112 
2113     function setBaseURI(string memory newBaseURI) external onlyOwner notLocked {
2114         _setBaseURI(newBaseURI);
2115     }
2116 
2117     function setIpfsURI(string memory _ipfsUri) external onlyOwner notLocked {
2118         ipfsUri = _ipfsUri;
2119     }
2120 
2121     function setFolder(string memory _folder) external onlyOwner notLocked {
2122         folder = _folder;
2123     }
2124 
2125     function setProvenanceURI(string memory _provenanceURI)
2126         external
2127         onlyOwner
2128         notLocked
2129     {
2130         provenanceURI = _provenanceURI;
2131     }
2132 
2133     function setProvenance(string memory _provenance)
2134         external
2135         onlyOwner
2136         notLocked
2137     {
2138         provenance = _provenance;
2139     }
2140 
2141     function lock() external onlyOwner {
2142         locked = true;
2143     }
2144 
2145     function withdraw() external {
2146         require(
2147             msg.sender == 0x61ddb27eF08006D23a50283d334CCE1D74faCa4D ||
2148                 msg.sender == 0xd880e1494bfBE60f221B8a8506b5a1959c36127C ||
2149                 msg.sender == 0xF1e000b6fE51AeD56a8d162A95B0C7A8a7511922 ||
2150                 msg.sender == 0x3AD232dDE2e84b782e2Ff044C6e3832Eb9e78A21 ||
2151                 msg.sender == 0xda6776bfbA3252E6720911c4ed6a317e98d4954F ||
2152                 msg.sender == 0x8f4e56e3F90Bc938E6Ea9861f94BE2D56fc95db1
2153         );
2154 
2155         uint256 bal = address(this).balance;
2156 
2157         uint256 fifteen = bal.mul(15).div(100);
2158         payable(address(0x8f4e56e3F90Bc938E6Ea9861f94BE2D56fc95db1)).call{
2159             value: fifteen
2160         }("");
2161 
2162         uint256 two = bal.mul(2).div(100);
2163         payable(address(0xda6776bfbA3252E6720911c4ed6a317e98d4954F)).call{
2164             value: two
2165         }("");
2166 
2167         uint256 eight = bal.mul(8).div(100);
2168         payable(address(0x3AD232dDE2e84b782e2Ff044C6e3832Eb9e78A21)).call{
2169             value: eight
2170         }("");
2171 
2172         uint256 twentyfive = bal.mul(25).div(100);
2173         payable(address(0xF1e000b6fE51AeD56a8d162A95B0C7A8a7511922)).call{
2174             value: twentyfive
2175         }("");
2176 
2177         uint256 twentyfive2 = bal.mul(25).div(100);
2178         payable(address(0xd880e1494bfBE60f221B8a8506b5a1959c36127C)).call{
2179             value: twentyfive2
2180         }("");
2181 
2182         uint256 twentyfive3 = bal.mul(25).div(100);
2183         payable(address(0x61ddb27eF08006D23a50283d334CCE1D74faCa4D)).call{
2184             value: twentyfive3
2185         }("");
2186 
2187         uint256 remaining = address(this).balance;
2188         payable(address(0x8f4e56e3F90Bc938E6Ea9861f94BE2D56fc95db1)).call{
2189             value: remaining
2190         }("");
2191     }
2192 
2193     function emergencyWithdraw() external {
2194         require(msg.sender == 0x8f4e56e3F90Bc938E6Ea9861f94BE2D56fc95db1);
2195         (bool success, ) = payable(0x8f4e56e3F90Bc938E6Ea9861f94BE2D56fc95db1)
2196             .call{value: address(this).balance}("");
2197         require(success);
2198     }
2199 
2200     function setMintPrice(uint256 price) public onlyOwner {
2201         mintPrice = price;
2202     }
2203 
2204     // Private Methods
2205     function _mintInternal(address owner) private {
2206         _tokenIds.increment();
2207         uint256 newItemId = _tokenIds.current();
2208         _mint(owner, newItemId);
2209     }
2210 }