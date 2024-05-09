1 /*
2 
3 ooooo                                        o8o
4 `888'                                        `"'
5  888          .ooooo.   .ooooo.   .oooooooo oooo   .ooooo.   .oooo.o
6  888         d88' `88b d88' `88b 888' `88b  `888  d88' `88b d88(  "8
7  888         888   888 888   888 888   888   888  888ooo888 `"Y88b.
8  888       o 888   888 888   888 `88bod8P'   888  888    .o o.  )88b
9 o888ooooood8 `Y8bod8P' `Y8bod8P' `8oooooo.  o888o `Y8bod8P' 8""888P'
10                                  d"     YD
11                                  "Y88888P'
12 
13 https://github.com/austintgriffith/scaffold-eth/tree/loogies-svg-nft
14 
15 
16 */
17 // Sources flattened with hardhat v2.1.1 https://hardhat.org
18 
19 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
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
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 
47 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
48 
49 // SPDX-License-Identifier: MIT
50 
51 pragma solidity >=0.6.0 <0.8.0;
52 
53 /**
54  * @dev Interface of the ERC165 standard, as defined in the
55  * https://eips.ethereum.org/EIPS/eip-165[EIP].
56  *
57  * Implementers can declare support of contract interfaces, which can then be
58  * queried by others ({ERC165Checker}).
59  *
60  * For an implementation, see {ERC165}.
61  */
62 interface IERC165 {
63     /**
64      * @dev Returns true if this contract implements the interface defined by
65      * `interfaceId`. See the corresponding
66      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
67      * to learn more about how these ids are created.
68      *
69      * This function call must use less than 30 000 gas.
70      */
71     function supportsInterface(bytes4 interfaceId) external view returns (bool);
72 }
73 
74 
75 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
76 
77 // SPDX-License-Identifier: MIT
78 
79 pragma solidity >=0.6.2 <0.8.0;
80 
81 /**
82  * @dev Required interface of an ERC721 compliant contract.
83  */
84 interface IERC721 is IERC165 {
85     /**
86      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
89 
90     /**
91      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
92      */
93     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
94 
95     /**
96      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
97      */
98     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
99 
100     /**
101      * @dev Returns the number of tokens in ``owner``'s account.
102      */
103     function balanceOf(address owner) external view returns (uint256 balance);
104 
105     /**
106      * @dev Returns the owner of the `tokenId` token.
107      *
108      * Requirements:
109      *
110      * - `tokenId` must exist.
111      */
112     function ownerOf(uint256 tokenId) external view returns (address owner);
113 
114     /**
115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
117      *
118      * Requirements:
119      *
120      * - `from` cannot be the zero address.
121      * - `to` cannot be the zero address.
122      * - `tokenId` token must exist and be owned by `from`.
123      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
125      *
126      * Emits a {Transfer} event.
127      */
128     function safeTransferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Transfers `tokenId` token from `from` to `to`.
132      *
133      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
134      *
135      * Requirements:
136      *
137      * - `from` cannot be the zero address.
138      * - `to` cannot be the zero address.
139      * - `tokenId` token must be owned by `from`.
140      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(address from, address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
148      * The approval is cleared when the token is transferred.
149      *
150      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
151      *
152      * Requirements:
153      *
154      * - The caller must own the token or be an approved operator.
155      * - `tokenId` must exist.
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address to, uint256 tokenId) external;
160 
161     /**
162      * @dev Returns the account approved for `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function getApproved(uint256 tokenId) external view returns (address operator);
169 
170     /**
171      * @dev Approve or remove `operator` as an operator for the caller.
172      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
173      *
174      * Requirements:
175      *
176      * - The `operator` cannot be the caller.
177      *
178      * Emits an {ApprovalForAll} event.
179      */
180     function setApprovalForAll(address operator, bool _approved) external;
181 
182     /**
183      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
184      *
185      * See {setApprovalForAll}
186      */
187     function isApprovedForAll(address owner, address operator) external view returns (bool);
188 
189     /**
190       * @dev Safely transfers `tokenId` token from `from` to `to`.
191       *
192       * Requirements:
193       *
194       * - `from` cannot be the zero address.
195       * - `to` cannot be the zero address.
196       * - `tokenId` token must exist and be owned by `from`.
197       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
199       *
200       * Emits a {Transfer} event.
201       */
202     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
207 
208 // SPDX-License-Identifier: MIT
209 
210 pragma solidity >=0.6.2 <0.8.0;
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217 
218     /**
219      * @dev Returns the token collection name.
220      */
221     function name() external view returns (string memory);
222 
223     /**
224      * @dev Returns the token collection symbol.
225      */
226     function symbol() external view returns (string memory);
227 
228     /**
229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
230      */
231     function tokenURI(uint256 tokenId) external view returns (string memory);
232 }
233 
234 
235 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
236 
237 // SPDX-License-Identifier: MIT
238 
239 pragma solidity >=0.6.2 <0.8.0;
240 
241 /**
242  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
243  * @dev See https://eips.ethereum.org/EIPS/eip-721
244  */
245 interface IERC721Enumerable is IERC721 {
246 
247     /**
248      * @dev Returns the total amount of tokens stored by the contract.
249      */
250     function totalSupply() external view returns (uint256);
251 
252     /**
253      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
254      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
255      */
256     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
257 
258     /**
259      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
260      * Use along with {totalSupply} to enumerate all tokens.
261      */
262     function tokenByIndex(uint256 index) external view returns (uint256);
263 }
264 
265 
266 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
267 
268 // SPDX-License-Identifier: MIT
269 
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
286      */
287     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
288 }
289 
290 
291 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
292 
293 // SPDX-License-Identifier: MIT
294 
295 pragma solidity >=0.6.0 <0.8.0;
296 
297 /**
298  * @dev Implementation of the {IERC165} interface.
299  *
300  * Contracts may inherit from this and call {_registerInterface} to declare
301  * their support of an interface.
302  */
303 abstract contract ERC165 is IERC165 {
304     /*
305      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
306      */
307     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
308 
309     /**
310      * @dev Mapping of interface ids to whether or not it's supported.
311      */
312     mapping(bytes4 => bool) private _supportedInterfaces;
313 
314     constructor () internal {
315         // Derived contracts need only register support for their own interfaces,
316         // we register support for ERC165 itself here
317         _registerInterface(_INTERFACE_ID_ERC165);
318     }
319 
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      *
323      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
324      */
325     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326         return _supportedInterfaces[interfaceId];
327     }
328 
329     /**
330      * @dev Registers the contract as an implementer of the interface defined by
331      * `interfaceId`. Support of the actual ERC165 interface is automatic and
332      * registering its interface id is not required.
333      *
334      * See {IERC165-supportsInterface}.
335      *
336      * Requirements:
337      *
338      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
339      */
340     function _registerInterface(bytes4 interfaceId) internal virtual {
341         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
342         _supportedInterfaces[interfaceId] = true;
343     }
344 }
345 
346 
347 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
348 
349 // SPDX-License-Identifier: MIT
350 
351 pragma solidity >=0.6.0 <0.8.0;
352 
353 /**
354  * @dev Wrappers over Solidity's arithmetic operations with added overflow
355  * checks.
356  *
357  * Arithmetic operations in Solidity wrap on overflow. This can easily result
358  * in bugs, because programmers usually assume that an overflow raises an
359  * error, which is the standard behavior in high level programming languages.
360  * `SafeMath` restores this intuition by reverting the transaction when an
361  * operation overflows.
362  *
363  * Using this library instead of the unchecked operations eliminates an entire
364  * class of bugs, so it's recommended to use it always.
365  */
366 library SafeMath {
367     /**
368      * @dev Returns the addition of two unsigned integers, with an overflow flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         uint256 c = a + b;
374         if (c < a) return (false, 0);
375         return (true, c);
376     }
377 
378     /**
379      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
380      *
381      * _Available since v3.4._
382      */
383     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         if (b > a) return (false, 0);
385         return (true, a - b);
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
395         // benefit is lost if 'b' is also tested.
396         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
397         if (a == 0) return (true, 0);
398         uint256 c = a * b;
399         if (c / a != b) return (false, 0);
400         return (true, c);
401     }
402 
403     /**
404      * @dev Returns the division of two unsigned integers, with a division by zero flag.
405      *
406      * _Available since v3.4._
407      */
408     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
409         if (b == 0) return (false, 0);
410         return (true, a / b);
411     }
412 
413     /**
414      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
415      *
416      * _Available since v3.4._
417      */
418     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
419         if (b == 0) return (false, 0);
420         return (true, a % b);
421     }
422 
423     /**
424      * @dev Returns the addition of two unsigned integers, reverting on
425      * overflow.
426      *
427      * Counterpart to Solidity's `+` operator.
428      *
429      * Requirements:
430      *
431      * - Addition cannot overflow.
432      */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         require(c >= a, "SafeMath: addition overflow");
436         return c;
437     }
438 
439     /**
440      * @dev Returns the subtraction of two unsigned integers, reverting on
441      * overflow (when the result is negative).
442      *
443      * Counterpart to Solidity's `-` operator.
444      *
445      * Requirements:
446      *
447      * - Subtraction cannot overflow.
448      */
449     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
450         require(b <= a, "SafeMath: subtraction overflow");
451         return a - b;
452     }
453 
454     /**
455      * @dev Returns the multiplication of two unsigned integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `*` operator.
459      *
460      * Requirements:
461      *
462      * - Multiplication cannot overflow.
463      */
464     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465         if (a == 0) return 0;
466         uint256 c = a * b;
467         require(c / a == b, "SafeMath: multiplication overflow");
468         return c;
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers, reverting on
473      * division by zero. The result is rounded towards zero.
474      *
475      * Counterpart to Solidity's `/` operator. Note: this function uses a
476      * `revert` opcode (which leaves remaining gas untouched) while Solidity
477      * uses an invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         require(b > 0, "SafeMath: division by zero");
485         return a / b;
486     }
487 
488     /**
489      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
490      * reverting when dividing by zero.
491      *
492      * Counterpart to Solidity's `%` operator. This function uses a `revert`
493      * opcode (which leaves remaining gas untouched) while Solidity uses an
494      * invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
501         require(b > 0, "SafeMath: modulo by zero");
502         return a % b;
503     }
504 
505     /**
506      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
507      * overflow (when the result is negative).
508      *
509      * CAUTION: This function is deprecated because it requires allocating memory for the error
510      * message unnecessarily. For custom revert reasons use {trySub}.
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      *
516      * - Subtraction cannot overflow.
517      */
518     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b <= a, errorMessage);
520         return a - b;
521     }
522 
523     /**
524      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
525      * division by zero. The result is rounded towards zero.
526      *
527      * CAUTION: This function is deprecated because it requires allocating memory for the error
528      * message unnecessarily. For custom revert reasons use {tryDiv}.
529      *
530      * Counterpart to Solidity's `/` operator. Note: this function uses a
531      * `revert` opcode (which leaves remaining gas untouched) while Solidity
532      * uses an invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
539         require(b > 0, errorMessage);
540         return a / b;
541     }
542 
543     /**
544      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
545      * reverting with custom message when dividing by zero.
546      *
547      * CAUTION: This function is deprecated because it requires allocating memory for the error
548      * message unnecessarily. For custom revert reasons use {tryMod}.
549      *
550      * Counterpart to Solidity's `%` operator. This function uses a `revert`
551      * opcode (which leaves remaining gas untouched) while Solidity uses an
552      * invalid opcode to revert (consuming all remaining gas).
553      *
554      * Requirements:
555      *
556      * - The divisor cannot be zero.
557      */
558     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
559         require(b > 0, errorMessage);
560         return a % b;
561     }
562 }
563 
564 
565 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
566 
567 // SPDX-License-Identifier: MIT
568 
569 pragma solidity >=0.6.2 <0.8.0;
570 
571 /**
572  * @dev Collection of functions related to the address type
573  */
574 library Address {
575     /**
576      * @dev Returns true if `account` is a contract.
577      *
578      * [IMPORTANT]
579      * ====
580      * It is unsafe to assume that an address for which this function returns
581      * false is an externally-owned account (EOA) and not a contract.
582      *
583      * Among others, `isContract` will return false for the following
584      * types of addresses:
585      *
586      *  - an externally-owned account
587      *  - a contract in construction
588      *  - an address where a contract will be created
589      *  - an address where a contract lived, but was destroyed
590      * ====
591      */
592     function isContract(address account) internal view returns (bool) {
593         // This method relies on extcodesize, which returns 0 for contracts in
594         // construction, since the code is only stored at the end of the
595         // constructor execution.
596 
597         uint256 size;
598         // solhint-disable-next-line no-inline-assembly
599         assembly { size := extcodesize(account) }
600         return size > 0;
601     }
602 
603     /**
604      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
605      * `recipient`, forwarding all available gas and reverting on errors.
606      *
607      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
608      * of certain opcodes, possibly making contracts go over the 2300 gas limit
609      * imposed by `transfer`, making them unable to receive funds via
610      * `transfer`. {sendValue} removes this limitation.
611      *
612      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
613      *
614      * IMPORTANT: because control is transferred to `recipient`, care must be
615      * taken to not create reentrancy vulnerabilities. Consider using
616      * {ReentrancyGuard} or the
617      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
618      */
619     function sendValue(address payable recipient, uint256 amount) internal {
620         require(address(this).balance >= amount, "Address: insufficient balance");
621 
622         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
623         (bool success, ) = recipient.call{ value: amount }("");
624         require(success, "Address: unable to send value, recipient may have reverted");
625     }
626 
627     /**
628      * @dev Performs a Solidity function call using a low level `call`. A
629      * plain`call` is an unsafe replacement for a function call: use this
630      * function instead.
631      *
632      * If `target` reverts with a revert reason, it is bubbled up by this
633      * function (like regular Solidity function calls).
634      *
635      * Returns the raw returned data. To convert to the expected return value,
636      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
637      *
638      * Requirements:
639      *
640      * - `target` must be a contract.
641      * - calling `target` with `data` must not revert.
642      *
643      * _Available since v3.1._
644      */
645     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
646       return functionCall(target, data, "Address: low-level call failed");
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
651      * `errorMessage` as a fallback revert reason when `target` reverts.
652      *
653      * _Available since v3.1._
654      */
655     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
656         return functionCallWithValue(target, data, 0, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but also transferring `value` wei to `target`.
662      *
663      * Requirements:
664      *
665      * - the calling contract must have an ETH balance of at least `value`.
666      * - the called Solidity function must be `payable`.
667      *
668      * _Available since v3.1._
669      */
670     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
671         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
676      * with `errorMessage` as a fallback revert reason when `target` reverts.
677      *
678      * _Available since v3.1._
679      */
680     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
681         require(address(this).balance >= value, "Address: insufficient balance for call");
682         require(isContract(target), "Address: call to non-contract");
683 
684         // solhint-disable-next-line avoid-low-level-calls
685         (bool success, bytes memory returndata) = target.call{ value: value }(data);
686         return _verifyCallResult(success, returndata, errorMessage);
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
691      * but performing a static call.
692      *
693      * _Available since v3.3._
694      */
695     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
696         return functionStaticCall(target, data, "Address: low-level static call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
701      * but performing a static call.
702      *
703      * _Available since v3.3._
704      */
705     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
706         require(isContract(target), "Address: static call to non-contract");
707 
708         // solhint-disable-next-line avoid-low-level-calls
709         (bool success, bytes memory returndata) = target.staticcall(data);
710         return _verifyCallResult(success, returndata, errorMessage);
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
715      * but performing a delegate call.
716      *
717      * _Available since v3.4._
718      */
719     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
720         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
725      * but performing a delegate call.
726      *
727      * _Available since v3.4._
728      */
729     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
730         require(isContract(target), "Address: delegate call to non-contract");
731 
732         // solhint-disable-next-line avoid-low-level-calls
733         (bool success, bytes memory returndata) = target.delegatecall(data);
734         return _verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
738         if (success) {
739             return returndata;
740         } else {
741             // Look for revert reason and bubble it up if present
742             if (returndata.length > 0) {
743                 // The easiest way to bubble the revert reason is using memory via assembly
744 
745                 // solhint-disable-next-line no-inline-assembly
746                 assembly {
747                     let returndata_size := mload(returndata)
748                     revert(add(32, returndata), returndata_size)
749                 }
750             } else {
751                 revert(errorMessage);
752             }
753         }
754     }
755 }
756 
757 
758 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
759 
760 // SPDX-License-Identifier: MIT
761 
762 pragma solidity >=0.6.0 <0.8.0;
763 
764 /**
765  * @dev Library for managing
766  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
767  * types.
768  *
769  * Sets have the following properties:
770  *
771  * - Elements are added, removed, and checked for existence in constant time
772  * (O(1)).
773  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
774  *
775  * ```
776  * contract Example {
777  *     // Add the library methods
778  *     using EnumerableSet for EnumerableSet.AddressSet;
779  *
780  *     // Declare a set state variable
781  *     EnumerableSet.AddressSet private mySet;
782  * }
783  * ```
784  *
785  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
786  * and `uint256` (`UintSet`) are supported.
787  */
788 library EnumerableSet {
789     // To implement this library for multiple types with as little code
790     // repetition as possible, we write it in terms of a generic Set type with
791     // bytes32 values.
792     // The Set implementation uses private functions, and user-facing
793     // implementations (such as AddressSet) are just wrappers around the
794     // underlying Set.
795     // This means that we can only create new EnumerableSets for types that fit
796     // in bytes32.
797 
798     struct Set {
799         // Storage of set values
800         bytes32[] _values;
801 
802         // Position of the value in the `values` array, plus 1 because index 0
803         // means a value is not in the set.
804         mapping (bytes32 => uint256) _indexes;
805     }
806 
807     /**
808      * @dev Add a value to a set. O(1).
809      *
810      * Returns true if the value was added to the set, that is if it was not
811      * already present.
812      */
813     function _add(Set storage set, bytes32 value) private returns (bool) {
814         if (!_contains(set, value)) {
815             set._values.push(value);
816             // The value is stored at length-1, but we add 1 to all indexes
817             // and use 0 as a sentinel value
818             set._indexes[value] = set._values.length;
819             return true;
820         } else {
821             return false;
822         }
823     }
824 
825     /**
826      * @dev Removes a value from a set. O(1).
827      *
828      * Returns true if the value was removed from the set, that is if it was
829      * present.
830      */
831     function _remove(Set storage set, bytes32 value) private returns (bool) {
832         // We read and store the value's index to prevent multiple reads from the same storage slot
833         uint256 valueIndex = set._indexes[value];
834 
835         if (valueIndex != 0) { // Equivalent to contains(set, value)
836             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
837             // the array, and then remove the last element (sometimes called as 'swap and pop').
838             // This modifies the order of the array, as noted in {at}.
839 
840             uint256 toDeleteIndex = valueIndex - 1;
841             uint256 lastIndex = set._values.length - 1;
842 
843             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
844             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
845 
846             bytes32 lastvalue = set._values[lastIndex];
847 
848             // Move the last value to the index where the value to delete is
849             set._values[toDeleteIndex] = lastvalue;
850             // Update the index for the moved value
851             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
852 
853             // Delete the slot where the moved value was stored
854             set._values.pop();
855 
856             // Delete the index for the deleted slot
857             delete set._indexes[value];
858 
859             return true;
860         } else {
861             return false;
862         }
863     }
864 
865     /**
866      * @dev Returns true if the value is in the set. O(1).
867      */
868     function _contains(Set storage set, bytes32 value) private view returns (bool) {
869         return set._indexes[value] != 0;
870     }
871 
872     /**
873      * @dev Returns the number of values on the set. O(1).
874      */
875     function _length(Set storage set) private view returns (uint256) {
876         return set._values.length;
877     }
878 
879    /**
880     * @dev Returns the value stored at position `index` in the set. O(1).
881     *
882     * Note that there are no guarantees on the ordering of values inside the
883     * array, and it may change when more values are added or removed.
884     *
885     * Requirements:
886     *
887     * - `index` must be strictly less than {length}.
888     */
889     function _at(Set storage set, uint256 index) private view returns (bytes32) {
890         require(set._values.length > index, "EnumerableSet: index out of bounds");
891         return set._values[index];
892     }
893 
894     // Bytes32Set
895 
896     struct Bytes32Set {
897         Set _inner;
898     }
899 
900     /**
901      * @dev Add a value to a set. O(1).
902      *
903      * Returns true if the value was added to the set, that is if it was not
904      * already present.
905      */
906     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
907         return _add(set._inner, value);
908     }
909 
910     /**
911      * @dev Removes a value from a set. O(1).
912      *
913      * Returns true if the value was removed from the set, that is if it was
914      * present.
915      */
916     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
917         return _remove(set._inner, value);
918     }
919 
920     /**
921      * @dev Returns true if the value is in the set. O(1).
922      */
923     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
924         return _contains(set._inner, value);
925     }
926 
927     /**
928      * @dev Returns the number of values in the set. O(1).
929      */
930     function length(Bytes32Set storage set) internal view returns (uint256) {
931         return _length(set._inner);
932     }
933 
934    /**
935     * @dev Returns the value stored at position `index` in the set. O(1).
936     *
937     * Note that there are no guarantees on the ordering of values inside the
938     * array, and it may change when more values are added or removed.
939     *
940     * Requirements:
941     *
942     * - `index` must be strictly less than {length}.
943     */
944     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
945         return _at(set._inner, index);
946     }
947 
948     // AddressSet
949 
950     struct AddressSet {
951         Set _inner;
952     }
953 
954     /**
955      * @dev Add a value to a set. O(1).
956      *
957      * Returns true if the value was added to the set, that is if it was not
958      * already present.
959      */
960     function add(AddressSet storage set, address value) internal returns (bool) {
961         return _add(set._inner, bytes32(uint256(uint160(value))));
962     }
963 
964     /**
965      * @dev Removes a value from a set. O(1).
966      *
967      * Returns true if the value was removed from the set, that is if it was
968      * present.
969      */
970     function remove(AddressSet storage set, address value) internal returns (bool) {
971         return _remove(set._inner, bytes32(uint256(uint160(value))));
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function contains(AddressSet storage set, address value) internal view returns (bool) {
978         return _contains(set._inner, bytes32(uint256(uint160(value))));
979     }
980 
981     /**
982      * @dev Returns the number of values in the set. O(1).
983      */
984     function length(AddressSet storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988    /**
989     * @dev Returns the value stored at position `index` in the set. O(1).
990     *
991     * Note that there are no guarantees on the ordering of values inside the
992     * array, and it may change when more values are added or removed.
993     *
994     * Requirements:
995     *
996     * - `index` must be strictly less than {length}.
997     */
998     function at(AddressSet storage set, uint256 index) internal view returns (address) {
999         return address(uint160(uint256(_at(set._inner, index))));
1000     }
1001 
1002 
1003     // UintSet
1004 
1005     struct UintSet {
1006         Set _inner;
1007     }
1008 
1009     /**
1010      * @dev Add a value to a set. O(1).
1011      *
1012      * Returns true if the value was added to the set, that is if it was not
1013      * already present.
1014      */
1015     function add(UintSet storage set, uint256 value) internal returns (bool) {
1016         return _add(set._inner, bytes32(value));
1017     }
1018 
1019     /**
1020      * @dev Removes a value from a set. O(1).
1021      *
1022      * Returns true if the value was removed from the set, that is if it was
1023      * present.
1024      */
1025     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1026         return _remove(set._inner, bytes32(value));
1027     }
1028 
1029     /**
1030      * @dev Returns true if the value is in the set. O(1).
1031      */
1032     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1033         return _contains(set._inner, bytes32(value));
1034     }
1035 
1036     /**
1037      * @dev Returns the number of values on the set. O(1).
1038      */
1039     function length(UintSet storage set) internal view returns (uint256) {
1040         return _length(set._inner);
1041     }
1042 
1043    /**
1044     * @dev Returns the value stored at position `index` in the set. O(1).
1045     *
1046     * Note that there are no guarantees on the ordering of values inside the
1047     * array, and it may change when more values are added or removed.
1048     *
1049     * Requirements:
1050     *
1051     * - `index` must be strictly less than {length}.
1052     */
1053     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1054         return uint256(_at(set._inner, index));
1055     }
1056 }
1057 
1058 
1059 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
1060 
1061 // SPDX-License-Identifier: MIT
1062 
1063 pragma solidity >=0.6.0 <0.8.0;
1064 
1065 /**
1066  * @dev Library for managing an enumerable variant of Solidity's
1067  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1068  * type.
1069  *
1070  * Maps have the following properties:
1071  *
1072  * - Entries are added, removed, and checked for existence in constant time
1073  * (O(1)).
1074  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1075  *
1076  * ```
1077  * contract Example {
1078  *     // Add the library methods
1079  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1080  *
1081  *     // Declare a set state variable
1082  *     EnumerableMap.UintToAddressMap private myMap;
1083  * }
1084  * ```
1085  *
1086  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1087  * supported.
1088  */
1089 library EnumerableMap {
1090     // To implement this library for multiple types with as little code
1091     // repetition as possible, we write it in terms of a generic Map type with
1092     // bytes32 keys and values.
1093     // The Map implementation uses private functions, and user-facing
1094     // implementations (such as Uint256ToAddressMap) are just wrappers around
1095     // the underlying Map.
1096     // This means that we can only create new EnumerableMaps for types that fit
1097     // in bytes32.
1098 
1099     struct MapEntry {
1100         bytes32 _key;
1101         bytes32 _value;
1102     }
1103 
1104     struct Map {
1105         // Storage of map keys and values
1106         MapEntry[] _entries;
1107 
1108         // Position of the entry defined by a key in the `entries` array, plus 1
1109         // because index 0 means a key is not in the map.
1110         mapping (bytes32 => uint256) _indexes;
1111     }
1112 
1113     /**
1114      * @dev Adds a key-value pair to a map, or updates the value for an existing
1115      * key. O(1).
1116      *
1117      * Returns true if the key was added to the map, that is if it was not
1118      * already present.
1119      */
1120     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1121         // We read and store the key's index to prevent multiple reads from the same storage slot
1122         uint256 keyIndex = map._indexes[key];
1123 
1124         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1125             map._entries.push(MapEntry({ _key: key, _value: value }));
1126             // The entry is stored at length-1, but we add 1 to all indexes
1127             // and use 0 as a sentinel value
1128             map._indexes[key] = map._entries.length;
1129             return true;
1130         } else {
1131             map._entries[keyIndex - 1]._value = value;
1132             return false;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Removes a key-value pair from a map. O(1).
1138      *
1139      * Returns true if the key was removed from the map, that is if it was present.
1140      */
1141     function _remove(Map storage map, bytes32 key) private returns (bool) {
1142         // We read and store the key's index to prevent multiple reads from the same storage slot
1143         uint256 keyIndex = map._indexes[key];
1144 
1145         if (keyIndex != 0) { // Equivalent to contains(map, key)
1146             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1147             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1148             // This modifies the order of the array, as noted in {at}.
1149 
1150             uint256 toDeleteIndex = keyIndex - 1;
1151             uint256 lastIndex = map._entries.length - 1;
1152 
1153             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1154             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1155 
1156             MapEntry storage lastEntry = map._entries[lastIndex];
1157 
1158             // Move the last entry to the index where the entry to delete is
1159             map._entries[toDeleteIndex] = lastEntry;
1160             // Update the index for the moved entry
1161             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1162 
1163             // Delete the slot where the moved entry was stored
1164             map._entries.pop();
1165 
1166             // Delete the index for the deleted slot
1167             delete map._indexes[key];
1168 
1169             return true;
1170         } else {
1171             return false;
1172         }
1173     }
1174 
1175     /**
1176      * @dev Returns true if the key is in the map. O(1).
1177      */
1178     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1179         return map._indexes[key] != 0;
1180     }
1181 
1182     /**
1183      * @dev Returns the number of key-value pairs in the map. O(1).
1184      */
1185     function _length(Map storage map) private view returns (uint256) {
1186         return map._entries.length;
1187     }
1188 
1189    /**
1190     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1191     *
1192     * Note that there are no guarantees on the ordering of entries inside the
1193     * array, and it may change when more entries are added or removed.
1194     *
1195     * Requirements:
1196     *
1197     * - `index` must be strictly less than {length}.
1198     */
1199     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1200         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1201 
1202         MapEntry storage entry = map._entries[index];
1203         return (entry._key, entry._value);
1204     }
1205 
1206     /**
1207      * @dev Tries to returns the value associated with `key`.  O(1).
1208      * Does not revert if `key` is not in the map.
1209      */
1210     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1211         uint256 keyIndex = map._indexes[key];
1212         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1213         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1214     }
1215 
1216     /**
1217      * @dev Returns the value associated with `key`.  O(1).
1218      *
1219      * Requirements:
1220      *
1221      * - `key` must be in the map.
1222      */
1223     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1224         uint256 keyIndex = map._indexes[key];
1225         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1226         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1227     }
1228 
1229     /**
1230      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1231      *
1232      * CAUTION: This function is deprecated because it requires allocating memory for the error
1233      * message unnecessarily. For custom revert reasons use {_tryGet}.
1234      */
1235     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1236         uint256 keyIndex = map._indexes[key];
1237         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1238         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1239     }
1240 
1241     // UintToAddressMap
1242 
1243     struct UintToAddressMap {
1244         Map _inner;
1245     }
1246 
1247     /**
1248      * @dev Adds a key-value pair to a map, or updates the value for an existing
1249      * key. O(1).
1250      *
1251      * Returns true if the key was added to the map, that is if it was not
1252      * already present.
1253      */
1254     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1255         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1256     }
1257 
1258     /**
1259      * @dev Removes a value from a set. O(1).
1260      *
1261      * Returns true if the key was removed from the map, that is if it was present.
1262      */
1263     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1264         return _remove(map._inner, bytes32(key));
1265     }
1266 
1267     /**
1268      * @dev Returns true if the key is in the map. O(1).
1269      */
1270     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1271         return _contains(map._inner, bytes32(key));
1272     }
1273 
1274     /**
1275      * @dev Returns the number of elements in the map. O(1).
1276      */
1277     function length(UintToAddressMap storage map) internal view returns (uint256) {
1278         return _length(map._inner);
1279     }
1280 
1281    /**
1282     * @dev Returns the element stored at position `index` in the set. O(1).
1283     * Note that there are no guarantees on the ordering of values inside the
1284     * array, and it may change when more values are added or removed.
1285     *
1286     * Requirements:
1287     *
1288     * - `index` must be strictly less than {length}.
1289     */
1290     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1291         (bytes32 key, bytes32 value) = _at(map._inner, index);
1292         return (uint256(key), address(uint160(uint256(value))));
1293     }
1294 
1295     /**
1296      * @dev Tries to returns the value associated with `key`.  O(1).
1297      * Does not revert if `key` is not in the map.
1298      *
1299      * _Available since v3.4._
1300      */
1301     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1302         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1303         return (success, address(uint160(uint256(value))));
1304     }
1305 
1306     /**
1307      * @dev Returns the value associated with `key`.  O(1).
1308      *
1309      * Requirements:
1310      *
1311      * - `key` must be in the map.
1312      */
1313     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1314         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1315     }
1316 
1317     /**
1318      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1319      *
1320      * CAUTION: This function is deprecated because it requires allocating memory for the error
1321      * message unnecessarily. For custom revert reasons use {tryGet}.
1322      */
1323     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1324         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1325     }
1326 }
1327 
1328 
1329 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
1330 
1331 // SPDX-License-Identifier: MIT
1332 
1333 pragma solidity >=0.6.0 <0.8.0;
1334 
1335 /**
1336  * @dev String operations.
1337  */
1338 library Strings {
1339     /**
1340      * @dev Converts a `uint256` to its ASCII `string` representation.
1341      */
1342     function toString(uint256 value) internal pure returns (string memory) {
1343         // Inspired by OraclizeAPI's implementation - MIT licence
1344         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1345 
1346         if (value == 0) {
1347             return "0";
1348         }
1349         uint256 temp = value;
1350         uint256 digits;
1351         while (temp != 0) {
1352             digits++;
1353             temp /= 10;
1354         }
1355         bytes memory buffer = new bytes(digits);
1356         uint256 index = digits - 1;
1357         temp = value;
1358         while (temp != 0) {
1359             buffer[index--] = bytes1(uint8(48 + temp % 10));
1360             temp /= 10;
1361         }
1362         return string(buffer);
1363     }
1364 }
1365 
1366 
1367 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1368 
1369 // SPDX-License-Identifier: MIT
1370 
1371 pragma solidity >=0.6.0 <0.8.0;
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 
1380 
1381 
1382 
1383 /**
1384  * @title ERC721 Non-Fungible Token Standard basic implementation
1385  * @dev see https://eips.ethereum.org/EIPS/eip-721
1386  */
1387 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1388     using SafeMath for uint256;
1389     using Address for address;
1390     using EnumerableSet for EnumerableSet.UintSet;
1391     using EnumerableMap for EnumerableMap.UintToAddressMap;
1392     using Strings for uint256;
1393 
1394     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1395     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1396     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1397 
1398     // Mapping from holder address to their (enumerable) set of owned tokens
1399     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1400 
1401     // Enumerable mapping from token ids to their owners
1402     EnumerableMap.UintToAddressMap private _tokenOwners;
1403 
1404     // Mapping from token ID to approved address
1405     mapping (uint256 => address) private _tokenApprovals;
1406 
1407     // Mapping from owner to operator approvals
1408     mapping (address => mapping (address => bool)) private _operatorApprovals;
1409 
1410     // Token name
1411     string private _name;
1412 
1413     // Token symbol
1414     string private _symbol;
1415 
1416     // Optional mapping for token URIs
1417     mapping (uint256 => string) private _tokenURIs;
1418 
1419     // Base URI
1420     string private _baseURI;
1421 
1422     /*
1423      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1424      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1425      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1426      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1427      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1428      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1429      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1430      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1431      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1432      *
1433      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1434      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1435      */
1436     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1437 
1438     /*
1439      *     bytes4(keccak256('name()')) == 0x06fdde03
1440      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1441      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1442      *
1443      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1444      */
1445     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1446 
1447     /*
1448      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1449      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1450      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1451      *
1452      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1453      */
1454     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1455 
1456     /**
1457      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1458      */
1459     constructor (string memory name_, string memory symbol_) public {
1460         _name = name_;
1461         _symbol = symbol_;
1462 
1463         // register the supported interfaces to conform to ERC721 via ERC165
1464         _registerInterface(_INTERFACE_ID_ERC721);
1465         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1466         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1467     }
1468 
1469     /**
1470      * @dev See {IERC721-balanceOf}.
1471      */
1472     function balanceOf(address owner) public view virtual override returns (uint256) {
1473         require(owner != address(0), "ERC721: balance query for the zero address");
1474         return _holderTokens[owner].length();
1475     }
1476 
1477     /**
1478      * @dev See {IERC721-ownerOf}.
1479      */
1480     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1481         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-name}.
1486      */
1487     function name() public view virtual override returns (string memory) {
1488         return _name;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-symbol}.
1493      */
1494     function symbol() public view virtual override returns (string memory) {
1495         return _symbol;
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Metadata-tokenURI}.
1500      */
1501     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1502         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1503 
1504         string memory _tokenURI = _tokenURIs[tokenId];
1505         string memory base = baseURI();
1506 
1507         // If there is no base URI, return the token URI.
1508         if (bytes(base).length == 0) {
1509             return _tokenURI;
1510         }
1511         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1512         if (bytes(_tokenURI).length > 0) {
1513             return string(abi.encodePacked(base, _tokenURI));
1514         }
1515         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1516         return string(abi.encodePacked(base, tokenId.toString()));
1517     }
1518 
1519     /**
1520     * @dev Returns the base URI set via {_setBaseURI}. This will be
1521     * automatically added as a prefix in {tokenURI} to each token's URI, or
1522     * to the token ID if no specific URI is set for that token ID.
1523     */
1524     function baseURI() public view virtual returns (string memory) {
1525         return _baseURI;
1526     }
1527 
1528     /**
1529      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1530      */
1531     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1532         return _holderTokens[owner].at(index);
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Enumerable-totalSupply}.
1537      */
1538     function totalSupply() public view virtual override returns (uint256) {
1539         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1540         return _tokenOwners.length();
1541     }
1542 
1543     /**
1544      * @dev See {IERC721Enumerable-tokenByIndex}.
1545      */
1546     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1547         (uint256 tokenId, ) = _tokenOwners.at(index);
1548         return tokenId;
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-approve}.
1553      */
1554     function approve(address to, uint256 tokenId) public virtual override {
1555         address owner = ERC721.ownerOf(tokenId);
1556         require(to != owner, "ERC721: approval to current owner");
1557 
1558         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1559             "ERC721: approve caller is not owner nor approved for all"
1560         );
1561 
1562         _approve(to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-getApproved}.
1567      */
1568     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1569         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1570 
1571         return _tokenApprovals[tokenId];
1572     }
1573 
1574     /**
1575      * @dev See {IERC721-setApprovalForAll}.
1576      */
1577     function setApprovalForAll(address operator, bool approved) public virtual override {
1578         require(operator != _msgSender(), "ERC721: approve to caller");
1579 
1580         _operatorApprovals[_msgSender()][operator] = approved;
1581         emit ApprovalForAll(_msgSender(), operator, approved);
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-isApprovedForAll}.
1586      */
1587     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1588         return _operatorApprovals[owner][operator];
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-transferFrom}.
1593      */
1594     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1595         //solhint-disable-next-line max-line-length
1596         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1597 
1598         _transfer(from, to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-safeTransferFrom}.
1603      */
1604     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1605         safeTransferFrom(from, to, tokenId, "");
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-safeTransferFrom}.
1610      */
1611     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1612         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1613         _safeTransfer(from, to, tokenId, _data);
1614     }
1615 
1616     /**
1617      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1618      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1619      *
1620      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1621      *
1622      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1623      * implement alternative mechanisms to perform token transfer, such as signature-based.
1624      *
1625      * Requirements:
1626      *
1627      * - `from` cannot be the zero address.
1628      * - `to` cannot be the zero address.
1629      * - `tokenId` token must exist and be owned by `from`.
1630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1631      *
1632      * Emits a {Transfer} event.
1633      */
1634     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1635         _transfer(from, to, tokenId);
1636         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1637     }
1638 
1639     /**
1640      * @dev Returns whether `tokenId` exists.
1641      *
1642      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1643      *
1644      * Tokens start existing when they are minted (`_mint`),
1645      * and stop existing when they are burned (`_burn`).
1646      */
1647     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1648         return _tokenOwners.contains(tokenId);
1649     }
1650 
1651     /**
1652      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1653      *
1654      * Requirements:
1655      *
1656      * - `tokenId` must exist.
1657      */
1658     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1659         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1660         address owner = ERC721.ownerOf(tokenId);
1661         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1662     }
1663 
1664     /**
1665      * @dev Safely mints `tokenId` and transfers it to `to`.
1666      *
1667      * Requirements:
1668      d*
1669      * - `tokenId` must not exist.
1670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function _safeMint(address to, uint256 tokenId) internal virtual {
1675         _safeMint(to, tokenId, "");
1676     }
1677 
1678     /**
1679      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1680      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1681      */
1682     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1683         _mint(to, tokenId);
1684         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1685     }
1686 
1687     /**
1688      * @dev Mints `tokenId` and transfers it to `to`.
1689      *
1690      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1691      *
1692      * Requirements:
1693      *
1694      * - `tokenId` must not exist.
1695      * - `to` cannot be the zero address.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _mint(address to, uint256 tokenId) internal virtual {
1700         require(to != address(0), "ERC721: mint to the zero address");
1701         require(!_exists(tokenId), "ERC721: token already minted");
1702 
1703         _beforeTokenTransfer(address(0), to, tokenId);
1704 
1705         _holderTokens[to].add(tokenId);
1706 
1707         _tokenOwners.set(tokenId, to);
1708 
1709         emit Transfer(address(0), to, tokenId);
1710     }
1711 
1712     /**
1713      * @dev Destroys `tokenId`.
1714      * The approval is cleared when the token is burned.
1715      *
1716      * Requirements:
1717      *
1718      * - `tokenId` must exist.
1719      *
1720      * Emits a {Transfer} event.
1721      */
1722     function _burn(uint256 tokenId) internal virtual {
1723         address owner = ERC721.ownerOf(tokenId); // internal owner
1724 
1725         _beforeTokenTransfer(owner, address(0), tokenId);
1726 
1727         // Clear approvals
1728         _approve(address(0), tokenId);
1729 
1730         // Clear metadata (if any)
1731         if (bytes(_tokenURIs[tokenId]).length != 0) {
1732             delete _tokenURIs[tokenId];
1733         }
1734 
1735         _holderTokens[owner].remove(tokenId);
1736 
1737         _tokenOwners.remove(tokenId);
1738 
1739         emit Transfer(owner, address(0), tokenId);
1740     }
1741 
1742     /**
1743      * @dev Transfers `tokenId` from `from` to `to`.
1744      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1745      *
1746      * Requirements:
1747      *
1748      * - `to` cannot be the zero address.
1749      * - `tokenId` token must be owned by `from`.
1750      *
1751      * Emits a {Transfer} event.
1752      */
1753     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1754         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1755         require(to != address(0), "ERC721: transfer to the zero address");
1756 
1757         _beforeTokenTransfer(from, to, tokenId);
1758 
1759         // Clear approvals from the previous owner
1760         _approve(address(0), tokenId);
1761 
1762         _holderTokens[from].remove(tokenId);
1763         _holderTokens[to].add(tokenId);
1764 
1765         _tokenOwners.set(tokenId, to);
1766 
1767         emit Transfer(from, to, tokenId);
1768     }
1769 
1770     /**
1771      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1772      *
1773      * Requirements:
1774      *
1775      * - `tokenId` must exist.
1776      */
1777     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1778         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1779         _tokenURIs[tokenId] = _tokenURI;
1780     }
1781 
1782     /**
1783      * @dev Internal function to set the base URI for all token IDs. It is
1784      * automatically added as a prefix to the value returned in {tokenURI},
1785      * or to the token ID if {tokenURI} is empty.
1786      */
1787     function _setBaseURI(string memory baseURI_) internal virtual {
1788         _baseURI = baseURI_;
1789     }
1790 
1791     /**
1792      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1793      * The call is not executed if the target address is not a contract.
1794      *
1795      * @param from address representing the previous owner of the given token ID
1796      * @param to target address that will receive the tokens
1797      * @param tokenId uint256 ID of the token to be transferred
1798      * @param _data bytes optional data to send along with the call
1799      * @return bool whether the call correctly returned the expected magic value
1800      */
1801     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1802         private returns (bool)
1803     {
1804         if (!to.isContract()) {
1805             return true;
1806         }
1807         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1808             IERC721Receiver(to).onERC721Received.selector,
1809             _msgSender(),
1810             from,
1811             tokenId,
1812             _data
1813         ), "ERC721: transfer to non ERC721Receiver implementer");
1814         bytes4 retval = abi.decode(returndata, (bytes4));
1815         return (retval == _ERC721_RECEIVED);
1816     }
1817 
1818     /**
1819      * @dev Approve `to` to operate on `tokenId`
1820      *
1821      * Emits an {Approval} event.
1822      */
1823     function _approve(address to, uint256 tokenId) internal virtual {
1824         _tokenApprovals[tokenId] = to;
1825         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1826     }
1827 
1828     /**
1829      * @dev Hook that is called before any token transfer. This includes minting
1830      * and burning.
1831      *
1832      * Calling conditions:
1833      *
1834      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1835      * transferred to `to`.
1836      * - When `from` is zero, `tokenId` will be minted for `to`.
1837      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1838      * - `from` cannot be the zero address.
1839      * - `to` cannot be the zero address.
1840      *
1841      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1842      */
1843     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1844 }
1845 
1846 
1847 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1848 
1849 // SPDX-License-Identifier: MIT
1850 
1851 pragma solidity >=0.6.0 <0.8.0;
1852 
1853 /**
1854  * @title Counters
1855  * @author Matt Condon (@shrugs)
1856  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1857  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1858  *
1859  * Include with `using Counters for Counters.Counter;`
1860  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1861  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1862  * directly accessed.
1863  */
1864 library Counters {
1865     using SafeMath for uint256;
1866 
1867     struct Counter {
1868         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1869         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1870         // this feature: see https://github.com/ethereum/solidity/issues/4637
1871         uint256 _value; // default: 0
1872     }
1873 
1874     function current(Counter storage counter) internal view returns (uint256) {
1875         return counter._value;
1876     }
1877 
1878     function increment(Counter storage counter) internal {
1879         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1880         counter._value += 1;
1881     }
1882 
1883     function decrement(Counter storage counter) internal {
1884         counter._value = counter._value.sub(1);
1885     }
1886 }
1887 
1888 
1889 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1890 
1891 // SPDX-License-Identifier: MIT
1892 
1893 pragma solidity >=0.6.0 <0.8.0;
1894 
1895 /**
1896  * @dev Contract module which provides a basic access control mechanism, where
1897  * there is an account (an owner) that can be granted exclusive access to
1898  * specific functions.
1899  *
1900  * By default, the owner account will be the one that deploys the contract. This
1901  * can later be changed with {transferOwnership}.
1902  *
1903  * This module is used through inheritance. It will make available the modifier
1904  * `onlyOwner`, which can be applied to your functions to restrict their use to
1905  * the owner.
1906  */
1907 abstract contract Ownable is Context {
1908     address private _owner;
1909 
1910     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1911 
1912     /**
1913      * @dev Initializes the contract setting the deployer as the initial owner.
1914      */
1915     constructor () internal {
1916         address msgSender = _msgSender();
1917         _owner = msgSender;
1918         emit OwnershipTransferred(address(0), msgSender);
1919     }
1920 
1921     /**
1922      * @dev Returns the address of the current owner.
1923      */
1924     function owner() public view virtual returns (address) {
1925         return _owner;
1926     }
1927 
1928     /**
1929      * @dev Throws if called by any account other than the owner.
1930      */
1931     modifier onlyOwner() {
1932         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1933         _;
1934     }
1935 
1936     /**
1937      * @dev Leaves the contract without owner. It will not be possible to call
1938      * `onlyOwner` functions anymore. Can only be called by the current owner.
1939      *
1940      * NOTE: Renouncing ownership will leave the contract without an owner,
1941      * thereby removing any functionality that is only available to the owner.
1942      */
1943     function renounceOwnership() public virtual onlyOwner {
1944         emit OwnershipTransferred(_owner, address(0));
1945         _owner = address(0);
1946     }
1947 
1948     /**
1949      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1950      * Can only be called by the current owner.
1951      */
1952     function transferOwnership(address newOwner) public virtual onlyOwner {
1953         require(newOwner != address(0), "Ownable: new owner is the zero address");
1954         emit OwnershipTransferred(_owner, newOwner);
1955         _owner = newOwner;
1956     }
1957 }
1958 
1959 
1960 // File base64-sol/base64.sol@v1.0.1
1961 
1962 // SPDX-License-Identifier: MIT
1963 
1964 /// @title Base64
1965 /// @author Brecht Devos - <brecht@loopring.org>
1966 /// @notice Provides a function for encoding some bytes in base64
1967 library Base64 {
1968     string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1969 
1970     function encode(bytes memory data) internal pure returns (string memory) {
1971         if (data.length == 0) return '';
1972 
1973         // load the table into memory
1974         string memory table = TABLE;
1975 
1976         // multiply by 4/3 rounded up
1977         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1978 
1979         // add some extra buffer at the end required for the writing
1980         string memory result = new string(encodedLen + 32);
1981 
1982         assembly {
1983             // set the actual output length
1984             mstore(result, encodedLen)
1985 
1986             // prepare the lookup table
1987             let tablePtr := add(table, 1)
1988 
1989             // input ptr
1990             let dataPtr := data
1991             let endPtr := add(dataPtr, mload(data))
1992 
1993             // result ptr, jump over length
1994             let resultPtr := add(result, 32)
1995 
1996             // run over the input, 3 bytes at a time
1997             for {} lt(dataPtr, endPtr) {}
1998             {
1999                dataPtr := add(dataPtr, 3)
2000 
2001                // read 3 bytes
2002                let input := mload(dataPtr)
2003 
2004                // write 4 characters
2005                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
2006                resultPtr := add(resultPtr, 1)
2007                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
2008                resultPtr := add(resultPtr, 1)
2009                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
2010                resultPtr := add(resultPtr, 1)
2011                mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
2012                resultPtr := add(resultPtr, 1)
2013             }
2014 
2015             // padding with '='
2016             switch mod(mload(data), 3)
2017             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2018             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2019         }
2020 
2021         return result;
2022     }
2023 }
2024 
2025 
2026 // File contracts/HexStrings.sol
2027 
2028 // SPDX-License-Identifier: MIT
2029 pragma solidity >=0.6.0 <0.7.0;
2030 
2031 library HexStrings {
2032     bytes16 internal constant ALPHABET = '0123456789abcdef';
2033 
2034     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2035         bytes memory buffer = new bytes(2 * length + 2);
2036         buffer[0] = '0';
2037         buffer[1] = 'x';
2038         for (uint256 i = 2 * length + 1; i > 1; --i) {
2039             buffer[i] = ALPHABET[value & 0xf];
2040             value >>= 4;
2041         }
2042         return string(buffer);
2043     }
2044 }
2045 
2046 
2047 // File contracts/ToColor.sol
2048 
2049 library ToColor {
2050     bytes16 internal constant ALPHABET = '0123456789abcdef';
2051 
2052     function toColor(bytes3 value) internal pure returns (string memory) {
2053       bytes memory buffer = new bytes(6);
2054       for (uint256 i = 0; i < 3; i++) {
2055           buffer[i*2+1] = ALPHABET[uint8(value[i]) & 0xf];
2056           buffer[i*2] = ALPHABET[uint8(value[i]>>4) & 0xf];
2057       }
2058       return string(buffer);
2059     }
2060 }
2061 
2062 
2063 // File contracts/MetadataGenerator.sol
2064 
2065 // SPDX-License-Identifier: MIT
2066 pragma solidity >=0.6.0 <0.7.0;
2067 
2068 
2069 
2070 
2071 /// @title NFTSVG
2072 /// @notice Provides a function for generating an SVG associated with a Uniswap NFT
2073 library MetadataGenerator {
2074 
2075   using Strings for uint256;
2076   using HexStrings for uint160;
2077   using ToColor for bytes3;
2078 
2079   function generateSVGofTokenById(address owner, uint256 tokenId, bytes3 color, uint256 chubbiness) internal pure returns (string memory) {
2080 
2081     string memory svg = string(abi.encodePacked(
2082       '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
2083         '<g id="eye1">',
2084           '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_1" cy="154.5" cx="181.5" stroke="#000" fill="#fff"/>',
2085           '<ellipse ry="3.5" rx="2.5" id="svg_3" cy="154.5" cx="173.5" stroke-width="3" stroke="#000" fill="#000000"/>',
2086         '</g>',
2087         '<g id="head">',
2088           '<ellipse fill="#',
2089           color.toColor(),
2090           '" stroke-width="3" cx="204.5" cy="211.80065" id="svg_5" rx="',
2091           chubbiness.toString(),
2092           '" ry="51.80065" stroke="#000"/>',
2093         '</g>',
2094         '<g id="eye2">',
2095           '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_2" cy="168.5" cx="209.5" stroke="#000" fill="#fff"/>',
2096           '<ellipse ry="3.5" rx="3" id="svg_4" cy="169.5" cx="208" stroke-width="3" fill="#000000" stroke="#000"/>',
2097         '</g>',
2098       '</svg>'
2099     ));
2100 
2101     return svg;
2102   }
2103 
2104   function tokenURI(address owner, uint256 tokenId, bytes3 color, uint256 chubbiness) internal pure returns (string memory) {
2105 
2106       string memory name = string(abi.encodePacked('Loogie #',tokenId.toString()));
2107       string memory description = string(abi.encodePacked('This Loogie is the color #',color.toColor(),' with a chubbiness of ',uint2str(chubbiness),'!!!'));
2108       string memory image = Base64.encode(bytes(generateSVGofTokenById(owner, tokenId, color, chubbiness)));
2109 
2110       return
2111           string(
2112               abi.encodePacked(
2113                 'data:application/json;base64,',
2114                 Base64.encode(
2115                     bytes(
2116                           abi.encodePacked(
2117                               '{"name":"',
2118                               name,
2119                               '", "description":"',
2120                               description,
2121                               '", "external_url":"https://loogies.io/',
2122                               tokenId.toString(),
2123                               '", "attributes": [{"trait_type": "color", "value": "#',
2124                               color.toColor(),
2125                               '"},{"trait_type": "chubbiness", "value": ',
2126                               uint2str(chubbiness),
2127                               '}], "owner":"',
2128                               (uint160(owner)).toHexString(20),
2129                               '", "image": "',
2130                               'data:image/svg+xml;base64,',
2131                               image,
2132                               '"}'
2133                           )
2134                         )
2135                     )
2136               )
2137           );
2138   }
2139 
2140   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
2141       if (_i == 0) {
2142           return "0";
2143       }
2144       uint j = _i;
2145       uint len;
2146       while (j != 0) {
2147           len++;
2148           j /= 10;
2149       }
2150       bytes memory bstr = new bytes(len);
2151       uint k = len;
2152       while (_i != 0) {
2153           k = k-1;
2154           uint8 temp = (48 + uint8(_i - _i / 10 * 10));
2155           bytes1 b1 = bytes1(temp);
2156           bstr[k] = b1;
2157           _i /= 10;
2158       }
2159       return string(bstr);
2160   }
2161 
2162 }
2163 
2164 
2165 // File contracts/Loogies.sol
2166 
2167 pragma solidity >=0.6.0 <0.7.0;
2168 //SPDX-License-Identifier: MIT
2169 
2170 
2171 
2172 //learn more: https://docs.openzeppelin.com/contracts/3.x/erc721
2173 
2174 // GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two
2175 
2176 contract Loogies is ERC721, Ownable {
2177 
2178   using Counters for Counters.Counter;
2179   Counters.Counter private _tokenIds;
2180 
2181   constructor() public ERC721("Loogies", "LOOG") {
2182     // RELEASE THE LOOGIES!
2183   }
2184 
2185   mapping (uint256 => bytes3) public color;
2186   mapping (uint256 => uint256) public chubbiness;
2187 
2188   uint256 mintDeadline = block.timestamp + 24 hours;
2189 
2190   function mintItem()
2191       public
2192       returns (uint256)
2193   {
2194       require( block.timestamp < mintDeadline, "DONE MINTING");
2195       _tokenIds.increment();
2196 
2197       uint256 id = _tokenIds.current();
2198       _mint(msg.sender, id);
2199 
2200       bytes32 predictableRandom = keccak256(abi.encodePacked( blockhash(block.number-1), msg.sender, address(this) ));
2201       color[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes2(predictableRandom[2]) >> 16 );
2202       chubbiness[id] = 35+((55*uint256(uint8(predictableRandom[3])))/255);
2203 
2204       return id;
2205   }
2206 
2207   function tokenURI(uint256 id) public view override returns (string memory) {
2208       require(_exists(id), "not exist");
2209       return MetadataGenerator.tokenURI( ownerOf(id), id, color[id], chubbiness[id] );
2210   }
2211 }