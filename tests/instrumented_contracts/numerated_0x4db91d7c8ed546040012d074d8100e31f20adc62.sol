1 // SPDX-License-Identifier: MIT
2 
3 // bizarro.club
4 
5 //  .-. .-')                .-') _     ('-.      _  .-')    _  .-')                  .-')    
6 //  \  ( OO )              (  OO) )   ( OO ).-. ( \( -O )  ( \( -O )                ( OO ).  
7 //   ;-----.\    ,-.-')  ,(_)----.    / . --. /  ,------.   ,------.   .-'),-----. (_)---\_) 
8 //   | .-.  |    |  |OO) |       |    | \-.  \   |   /`. '  |   /`. ' ( OO'  .-.  '/    _ |  
9 //   | '-' /_)   |  |  \ '--.   /   .-'-'  |  |  |  /  | |  |  /  | | /   |  | |  |\  :` `.  
10 //   | .-. `.    |  |(_/ (_/   /     \| |_.'  |  |  |_.' |  |  |_.' | \_) |  |\|  | '..`''.) 
11 //   | |  \  |  ,|  |_.'  /   /___    |  .-.  |  |  .  '.'  |  .  '.'   \ |  | |  |.-._)   \ 
12 //   | '--'  / (_|  |    |        |   |  | |  |  |  |\  \   |  |\  \     `'  '-'  '\       / 
13 //   `------'    `--'    `--------'   `--' `--'  `--' '--'  `--' '--'      `-----'  `-----'  
14 
15 // File: @openzeppelin/contracts/utils/Context.sol
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
1359 /**
1360  * @title ERC721 Non-Fungible Token Standard basic implementation
1361  * @dev see https://eips.ethereum.org/EIPS/eip-721
1362  */
1363 
1364 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1365     using SafeMath for uint256;
1366     using Address for address;
1367     using EnumerableSet for EnumerableSet.UintSet;
1368     using EnumerableMap for EnumerableMap.UintToAddressMap;
1369     using Strings for uint256;
1370 
1371     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1372     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1373     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1374 
1375     // Mapping from holder address to their (enumerable) set of owned tokens
1376     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1377 
1378     // Enumerable mapping from token ids to their owners
1379     EnumerableMap.UintToAddressMap private _tokenOwners;
1380 
1381     // Mapping from token ID to approved address
1382     mapping (uint256 => address) private _tokenApprovals;
1383 
1384     // Mapping from owner to operator approvals
1385     mapping (address => mapping (address => bool)) private _operatorApprovals;
1386 
1387     // Token name
1388     string private _name;
1389 
1390     // Token symbol
1391     string private _symbol;
1392 
1393     // Optional mapping for token URIs
1394     mapping (uint256 => string) private _tokenURIs;
1395 
1396     // Base URI
1397     string private _baseURI;
1398 
1399     /*
1400      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1401      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1402      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1403      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1404      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1405      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1406      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1407      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1408      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1409      *
1410      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1411      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1412      */
1413     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1414 
1415     /*
1416      *     bytes4(keccak256('name()')) == 0x06fdde03
1417      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1418      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1419      *
1420      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1421      */
1422     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1423 
1424     /*
1425      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1426      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1427      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1428      *
1429      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1430      */
1431     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1432 
1433     /**
1434      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1435      */
1436     constructor (string memory name_, string memory symbol_) public {
1437         _name = name_;
1438         _symbol = symbol_;
1439 
1440         // register the supported interfaces to conform to ERC721 via ERC165
1441         _registerInterface(_INTERFACE_ID_ERC721);
1442         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1443         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-balanceOf}.
1448      */
1449     function balanceOf(address owner) public view virtual override returns (uint256) {
1450         require(owner != address(0), "ERC721: balance query for the zero address");
1451         return _holderTokens[owner].length();
1452     }
1453 
1454     /**
1455      * @dev See {IERC721-ownerOf}.
1456      */
1457     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1458         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Metadata-name}.
1463      */
1464     function name() public view virtual override returns (string memory) {
1465         return _name;
1466     }
1467 
1468     /**
1469      * @dev See {IERC721Metadata-symbol}.
1470      */
1471     function symbol() public view virtual override returns (string memory) {
1472         return _symbol;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Metadata-tokenURI}.
1477      */
1478     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1479         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1480 
1481         string memory _tokenURI = _tokenURIs[tokenId];
1482         string memory base = baseURI();
1483 
1484         // If there is no base URI, return the token URI.
1485         if (bytes(base).length == 0) {
1486             return _tokenURI;
1487         }
1488         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1489         if (bytes(_tokenURI).length > 0) {
1490             return string(abi.encodePacked(base, _tokenURI));
1491         }
1492         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1493         return string(abi.encodePacked(base, tokenId.toString()));
1494     }
1495 
1496     /**
1497     * @dev Returns the base URI set via {_setBaseURI}. This will be
1498     * automatically added as a prefix in {tokenURI} to each token's URI, or
1499     * to the token ID if no specific URI is set for that token ID.
1500     */
1501     function baseURI() public view virtual returns (string memory) {
1502         return _baseURI;
1503     }
1504 
1505     /**
1506      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1507      */
1508     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1509         return _holderTokens[owner].at(index);
1510     }
1511 
1512     /**
1513      * @dev See {IERC721Enumerable-totalSupply}.
1514      */
1515     function totalSupply() public view virtual override returns (uint256) {
1516         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1517         return _tokenOwners.length();
1518     }
1519 
1520     /**
1521      * @dev See {IERC721Enumerable-tokenByIndex}.
1522      */
1523     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1524         (uint256 tokenId, ) = _tokenOwners.at(index);
1525         return tokenId;
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-approve}.
1530      */
1531     function approve(address to, uint256 tokenId) public virtual override {
1532         address owner = ERC721.ownerOf(tokenId);
1533         require(to != owner, "ERC721: approval to current owner");
1534 
1535         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1536             "ERC721: approve caller is not owner nor approved for all"
1537         );
1538 
1539         _approve(to, tokenId);
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-getApproved}.
1544      */
1545     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1546         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1547 
1548         return _tokenApprovals[tokenId];
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-setApprovalForAll}.
1553      */
1554     function setApprovalForAll(address operator, bool approved) public virtual override {
1555         require(operator != _msgSender(), "ERC721: approve to caller");
1556 
1557         _operatorApprovals[_msgSender()][operator] = approved;
1558         emit ApprovalForAll(_msgSender(), operator, approved);
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-isApprovedForAll}.
1563      */
1564     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1565         return _operatorApprovals[owner][operator];
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-transferFrom}.
1570      */
1571     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1572         //solhint-disable-next-line max-line-length
1573         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1574 
1575         _transfer(from, to, tokenId);
1576     }
1577 
1578     /**
1579      * @dev See {IERC721-safeTransferFrom}.
1580      */
1581     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1582         safeTransferFrom(from, to, tokenId, "");
1583     }
1584 
1585     /**
1586      * @dev See {IERC721-safeTransferFrom}.
1587      */
1588     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1589         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1590         _safeTransfer(from, to, tokenId, _data);
1591     }
1592 
1593     /**
1594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1596      *
1597      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1598      *
1599      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1600      * implement alternative mechanisms to perform token transfer, such as signature-based.
1601      *
1602      * Requirements:
1603      *
1604      * - `from` cannot be the zero address.
1605      * - `to` cannot be the zero address.
1606      * - `tokenId` token must exist and be owned by `from`.
1607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1612         _transfer(from, to, tokenId);
1613         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1614     }
1615 
1616     /**
1617      * @dev Returns whether `tokenId` exists.
1618      *
1619      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1620      *
1621      * Tokens start existing when they are minted (`_mint`),
1622      * and stop existing when they are burned (`_burn`).
1623      */
1624     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1625         return _tokenOwners.contains(tokenId);
1626     }
1627 
1628     /**
1629      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must exist.
1634      */
1635     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1636         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1637         address owner = ERC721.ownerOf(tokenId);
1638         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1639     }
1640 
1641     /**
1642      * @dev Safely mints `tokenId` and transfers it to `to`.
1643      *
1644      * Requirements:
1645      d*
1646      * - `tokenId` must not exist.
1647      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function _safeMint(address to, uint256 tokenId) internal virtual {
1652         _safeMint(to, tokenId, "");
1653     }
1654 
1655     /**
1656      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1657      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1658      */
1659     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1660         _mint(to, tokenId);
1661         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1662     }
1663 
1664     /**
1665      * @dev Mints `tokenId` and transfers it to `to`.
1666      *
1667      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1668      *
1669      * Requirements:
1670      *
1671      * - `tokenId` must not exist.
1672      * - `to` cannot be the zero address.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function _mint(address to, uint256 tokenId) internal virtual {
1677         require(to != address(0), "ERC721: mint to the zero address");
1678         require(!_exists(tokenId), "ERC721: token already minted");
1679 
1680         _beforeTokenTransfer(address(0), to, tokenId);
1681 
1682         _holderTokens[to].add(tokenId);
1683 
1684         _tokenOwners.set(tokenId, to);
1685 
1686         emit Transfer(address(0), to, tokenId);
1687     }
1688 
1689     /**
1690      * @dev Destroys `tokenId`.
1691      * The approval is cleared when the token is burned.
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must exist.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _burn(uint256 tokenId) internal virtual {
1700         address owner = ERC721.ownerOf(tokenId); // internal owner
1701 
1702         _beforeTokenTransfer(owner, address(0), tokenId);
1703 
1704         // Clear approvals
1705         _approve(address(0), tokenId);
1706 
1707         // Clear metadata (if any)
1708         if (bytes(_tokenURIs[tokenId]).length != 0) {
1709             delete _tokenURIs[tokenId];
1710         }
1711 
1712         _holderTokens[owner].remove(tokenId);
1713 
1714         _tokenOwners.remove(tokenId);
1715 
1716         emit Transfer(owner, address(0), tokenId);
1717     }
1718 
1719     /**
1720      * @dev Transfers `tokenId` from `from` to `to`.
1721      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1722      *
1723      * Requirements:
1724      *
1725      * - `to` cannot be the zero address.
1726      * - `tokenId` token must be owned by `from`.
1727      *
1728      * Emits a {Transfer} event.
1729      */
1730     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1731         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1732         require(to != address(0), "ERC721: transfer to the zero address");
1733 
1734         _beforeTokenTransfer(from, to, tokenId);
1735 
1736         // Clear approvals from the previous owner
1737         _approve(address(0), tokenId);
1738 
1739         _holderTokens[from].remove(tokenId);
1740         _holderTokens[to].add(tokenId);
1741 
1742         _tokenOwners.set(tokenId, to);
1743 
1744         emit Transfer(from, to, tokenId);
1745     }
1746 
1747     /**
1748      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1749      *
1750      * Requirements:
1751      *
1752      * - `tokenId` must exist.
1753      */
1754     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1755         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1756         _tokenURIs[tokenId] = _tokenURI;
1757     }
1758 
1759     /**
1760      * @dev Internal function to set the base URI for all token IDs. It is
1761      * automatically added as a prefix to the value returned in {tokenURI},
1762      * or to the token ID if {tokenURI} is empty.
1763      */
1764     function _setBaseURI(string memory baseURI_) internal virtual {
1765         _baseURI = baseURI_;
1766     }
1767 
1768     /**
1769      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1770      * The call is not executed if the target address is not a contract.
1771      *
1772      * @param from address representing the previous owner of the given token ID
1773      * @param to target address that will receive the tokens
1774      * @param tokenId uint256 ID of the token to be transferred
1775      * @param _data bytes optional data to send along with the call
1776      * @return bool whether the call correctly returned the expected magic value
1777      */
1778     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1779         private returns (bool)
1780     {
1781         if (!to.isContract()) {
1782             return true;
1783         }
1784         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1785             IERC721Receiver(to).onERC721Received.selector,
1786             _msgSender(),
1787             from,
1788             tokenId,
1789             _data
1790         ), "ERC721: transfer to non ERC721Receiver implementer");
1791         bytes4 retval = abi.decode(returndata, (bytes4));
1792         return (retval == _ERC721_RECEIVED);
1793     }
1794 
1795     /**
1796      * @dev Approve `to` to operate on `tokenId`
1797      *
1798      * Emits an {Approval} event.
1799      */
1800     function _approve(address to, uint256 tokenId) internal virtual {
1801         _tokenApprovals[tokenId] = to;
1802         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1803     }
1804 
1805     /**
1806      * @dev Hook that is called before any token transfer. This includes minting
1807      * and burning.
1808      *
1809      * Calling conditions:
1810      *
1811      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1812      * transferred to `to`.
1813      * - When `from` is zero, `tokenId` will be minted for `to`.
1814      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1815      * - `from` cannot be the zero address.
1816      * - `to` cannot be the zero address.
1817      *
1818      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1819      */
1820     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1821 }
1822 
1823 // File: @openzeppelin/contracts/access/Ownable.sol
1824 
1825 
1826 
1827 pragma solidity >=0.6.0 <0.8.0;
1828 
1829 /**
1830  * @dev Contract module which provides a basic access control mechanism, where
1831  * there is an account (an owner) that can be granted exclusive access to
1832  * specific functions.
1833  *
1834  * By default, the owner account will be the one that deploys the contract. This
1835  * can later be changed with {transferOwnership}.
1836  *
1837  * This module is used through inheritance. It will make available the modifier
1838  * `onlyOwner`, which can be applied to your functions to restrict their use to
1839  * the owner.
1840  */
1841 abstract contract Ownable is Context {
1842     address private _owner;
1843 
1844     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1845 
1846     /**
1847      * @dev Initializes the contract setting the deployer as the initial owner.
1848      */
1849     constructor () internal {
1850         address msgSender = _msgSender();
1851         _owner = msgSender;
1852         emit OwnershipTransferred(address(0), msgSender);
1853     }
1854 
1855     /**
1856      * @dev Returns the address of the current owner.
1857      */
1858     function owner() public view virtual returns (address) {
1859         return _owner;
1860     }
1861 
1862     /**
1863      * @dev Throws if called by any account other than the owner.
1864      */
1865     modifier onlyOwner() {
1866         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1867         _;
1868     }
1869 
1870     /**
1871      * @dev Leaves the contract without owner. It will not be possible to call
1872      * `onlyOwner` functions anymore. Can only be called by the current owner.
1873      *
1874      * NOTE: Renouncing ownership will leave the contract without an owner,
1875      * thereby removing any functionality that is only available to the owner.
1876      */
1877     function renounceOwnership() public virtual onlyOwner {
1878         emit OwnershipTransferred(_owner, address(0));
1879         _owner = address(0);
1880     }
1881 
1882     /**
1883      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1884      * Can only be called by the current owner.
1885      */
1886     function transferOwnership(address newOwner) public virtual onlyOwner {
1887         require(newOwner != address(0), "Ownable: new owner is the zero address");
1888         emit OwnershipTransferred(_owner, newOwner);
1889         _owner = newOwner;
1890     }
1891 }
1892 
1893 
1894 // Bizarros are a NFT collection create by _mintLabs for the purposes of facilitating an educational tutorial on how generative NFT collections are made.
1895 
1896 
1897 pragma solidity ^0.7.0;
1898 pragma abicoder v2;
1899 
1900 contract Bizarros is ERC721, Ownable {
1901 
1902     using SafeMath for uint256;
1903 
1904     string public BIZARRO_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN BIZARROS ARE ALL SOLD OUT
1905 
1906     string public LICENSE_TEXT = "Each Bizarro comes with FULL commercial rights for that specific Bizarro (i.e. that combination of traits), EXCEPT for the pre-defined royalty fee that is collected by the owner of this smart contract when the Bizarro is sold to a new owner. This royalty fee does not apply in any other situation (such as if you choose to rent/license your Bizarro, etc)."; // IT IS WHAT IT SAYS
1907 
1908     bool licenseLocked = true; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1909 
1910     uint256 public constant bizarroPrice = 80000000000000000; // 0.05 ETH
1911 
1912     uint public constant maxBizarroPurchase = 20;
1913 
1914     uint256 public constant MAX_BIZARROS = 10000;
1915 
1916     bool public saleIsActive = false;
1917 
1918     mapping(uint => string) public bizarroNames;
1919 
1920     // Reserve this many Bizarros for the team - Giveaways/Prizes etc
1921     uint public bizarroReserve = 130;
1922 
1923     event bizarroNameChange(address _by, uint _tokenId, string _name);
1924 
1925     event licenseisLocked(string _licenseText);
1926 
1927     constructor() ERC721("Bizarros", "BIZARRO") { }
1928 
1929     function withdraw() public onlyOwner {
1930         uint balance = address(this).balance;
1931         msg.sender.transfer(balance);
1932     }
1933 
1934     function reserveBizarros(address _to, uint256 _reserveAmount) public onlyOwner {
1935         uint supply = totalSupply();
1936         require(_reserveAmount > 0 && _reserveAmount <= bizarroReserve, "Not enough reserve left for team");
1937         for (uint i = 0; i < _reserveAmount; i++) {
1938             _safeMint(_to, supply + i);
1939         }
1940         bizarroReserve = bizarroReserve.sub(_reserveAmount);
1941     }
1942 
1943     function preSale(address _to, uint256 numberOfTokens) public onlyOwner() {
1944         uint supply = totalSupply();
1945         require(supply.add(numberOfTokens) <= MAX_BIZARROS, "Minting would exceed max supply of Bizarros");
1946         require(numberOfTokens <= 5, "Can only do 5 tokens at a time in presale");
1947         
1948         for(uint i = 0; i < numberOfTokens; i++){
1949             _safeMint( _to, supply + i );
1950         }
1951     }
1952 
1953 
1954     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1955         BIZARRO_PROVENANCE = provenanceHash;
1956     }
1957 
1958     function setBaseURI(string memory baseURI) public onlyOwner {
1959         _setBaseURI(baseURI);
1960     }
1961 
1962 
1963     function flipSaleState() public onlyOwner {
1964         saleIsActive = !saleIsActive;
1965     }
1966 
1967 
1968     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1969         uint256 tokenCount = balanceOf(_owner);
1970         if (tokenCount == 0) {
1971             // Return an empty array
1972             return new uint256[](0);
1973         } else {
1974             uint256[] memory result = new uint256[](tokenCount);
1975             uint256 index;
1976             for (index = 0; index < tokenCount; index++) {
1977                 result[index] = tokenOfOwnerByIndex(_owner, index);
1978             }
1979             return result;
1980         }
1981     }
1982 
1983     // Returns the license for tokens
1984     function tokenLicense(uint _id) public view returns(string memory) {
1985         require(_id < totalSupply(), "CHOOSE A BIZARRO WITHIN RANGE");
1986         return LICENSE_TEXT;
1987     }
1988 
1989     // Locks the license to prevent further changes
1990     function lockLicense() public onlyOwner {
1991         licenseLocked =  true;
1992         emit licenseisLocked(LICENSE_TEXT);
1993     }
1994 
1995     // Change the license
1996     function changeLicense(string memory _license) public onlyOwner {
1997         require(licenseLocked == false, "License already locked");
1998         LICENSE_TEXT = _license;
1999     }
2000 
2001 
2002     function mintBizarro(uint numberOfTokens) public payable {
2003         require(saleIsActive, "Sale must be active in order to mint Bizarro(s)");
2004         require(numberOfTokens > 0 && numberOfTokens <= maxBizarroPurchase, "Only mint 20 tokens at a time");
2005         require(totalSupply().add(numberOfTokens) <= MAX_BIZARROS, "Purchase would exceed max supply of Bizarros");
2006         require(msg.value >= bizarroPrice.mul(numberOfTokens), "Ether value sent is not correct");
2007 
2008         for(uint i = 0; i < numberOfTokens; i++) {
2009             uint mintIndex = totalSupply();
2010             if (totalSupply() < MAX_BIZARROS) {
2011                 _safeMint(msg.sender, mintIndex);
2012             }
2013         }
2014     }
2015 
2016     function changeBizarroName(uint _tokenId, string memory _name) public {
2017         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this Bizarro!");
2018         require(sha256(bytes(_name)) != sha256(bytes(bizarroNames[_tokenId])), "New name is the same as the current name");
2019         bizarroNames[_tokenId] = _name;
2020 
2021         emit bizarroNameChange(msg.sender, _tokenId, _name);
2022 
2023     }
2024 
2025     function viewBizarroName(uint _tokenId) public view returns( string memory ){
2026         require( _tokenId < totalSupply(), "Bizarro token ID provided is too high, exceeds the total number of Bizarros" );
2027         return bizarroNames[_tokenId];
2028     }
2029 
2030 
2031     // GET ALL BIZARROS OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2032     function bizarroNamesOfOwner(address _owner) external view returns(string[] memory ) {
2033         uint256 tokenCount = balanceOf(_owner);
2034         if (tokenCount == 0) {
2035             // Return an empty array
2036             return new string[](0);
2037         } else {
2038             string[] memory result = new string[](tokenCount);
2039             uint256 index;
2040             for (index = 0; index < tokenCount; index++) {
2041                 result[index] = bizarroNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2042             }
2043             return result;
2044         }
2045     }
2046 }