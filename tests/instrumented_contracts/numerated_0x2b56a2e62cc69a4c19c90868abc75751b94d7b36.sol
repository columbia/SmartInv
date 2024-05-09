1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity ^0.6.8;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 
49 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
50 
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 interface IERC721 is IERC165 {
55     /**
56      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
57      */
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62      */
63     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(address from, address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160       * @dev Safely transfers `tokenId` token from `from` to `to`.
161       *
162       * Requirements:
163       *
164       * - `from` cannot be the zero address.
165       * - `to` cannot be the zero address.
166       * - `tokenId` token must exist and be owned by `from`.
167       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169       *
170       * Emits a {Transfer} event.
171       */
172     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
173 }
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.0
176 
177 /**
178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
179  * @dev See https://eips.ethereum.org/EIPS/eip-721
180  */
181 interface IERC721Metadata is IERC721 {
182 
183     /**
184      * @dev Returns the token collection name.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the token collection symbol.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
195      */
196     function tokenURI(uint256 tokenId) external view returns (string memory);
197 }
198 
199 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.0
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Enumerable is IERC721 {
206 
207     /**
208      * @dev Returns the total amount of tokens stored by the contract.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
214      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
215      */
216     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
217 
218     /**
219      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
220      * Use along with {totalSupply} to enumerate all tokens.
221      */
222     function tokenByIndex(uint256 index) external view returns (uint256);
223 }
224 
225 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.0
226 
227 /**
228  * @title ERC721 token receiver interface
229  * @dev Interface for any contract that wants to support safeTransfers
230  * from ERC721 asset contracts.
231  */
232 interface IERC721Receiver {
233     /**
234      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
235      * by `operator` from `from`, this function is called.
236      *
237      * It must return its Solidity selector to confirm the token transfer.
238      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
239      *
240      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
241      */
242     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
243 }
244 
245 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.0
246 
247 /**
248  * @dev Implementation of the {IERC165} interface.
249  *
250  * Contracts may inherit from this and call {_registerInterface} to declare
251  * their support of an interface.
252  */
253 abstract contract ERC165 is IERC165 {
254     /*
255      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
256      */
257     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
258 
259     /**
260      * @dev Mapping of interface ids to whether or not it's supported.
261      */
262     mapping(bytes4 => bool) private _supportedInterfaces;
263 
264     constructor () internal {
265         // Derived contracts need only register support for their own interfaces,
266         // we register support for ERC165 itself here
267         _registerInterface(_INTERFACE_ID_ERC165);
268     }
269 
270     /**
271      * @dev See {IERC165-supportsInterface}.
272      *
273      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
274      */
275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
276         return _supportedInterfaces[interfaceId];
277     }
278 
279     /**
280      * @dev Registers the contract as an implementer of the interface defined by
281      * `interfaceId`. Support of the actual ERC165 interface is automatic and
282      * registering its interface id is not required.
283      *
284      * See {IERC165-supportsInterface}.
285      *
286      * Requirements:
287      *
288      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
289      */
290     function _registerInterface(bytes4 interfaceId) internal virtual {
291         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
292         _supportedInterfaces[interfaceId] = true;
293     }
294 }
295 
296 
297 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
298 
299 /**
300  * @dev Wrappers over Solidity's arithmetic operations with added overflow
301  * checks.
302  *
303  * Arithmetic operations in Solidity wrap on overflow. This can easily result
304  * in bugs, because programmers usually assume that an overflow raises an
305  * error, which is the standard behavior in high level programming languages.
306  * `SafeMath` restores this intuition by reverting the transaction when an
307  * operation overflows.
308  *
309  * Using this library instead of the unchecked operations eliminates an entire
310  * class of bugs, so it's recommended to use it always.
311  */
312 library SafeMath {
313     /**
314      * @dev Returns the addition of two unsigned integers, with an overflow flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
319         uint256 c = a + b;
320         if (c < a) return (false, 0);
321         return (true, c);
322     }
323 
324     /**
325      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
326      *
327      * _Available since v3.4._
328      */
329     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         if (b > a) return (false, 0);
331         return (true, a - b);
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
336      *
337      * _Available since v3.4._
338      */
339     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
340         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341         // benefit is lost if 'b' is also tested.
342         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
343         if (a == 0) return (true, 0);
344         uint256 c = a * b;
345         if (c / a != b) return (false, 0);
346         return (true, c);
347     }
348 
349     /**
350      * @dev Returns the division of two unsigned integers, with a division by zero flag.
351      *
352      * _Available since v3.4._
353      */
354     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         if (b == 0) return (false, 0);
356         return (true, a / b);
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
361      *
362      * _Available since v3.4._
363      */
364     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
365         if (b == 0) return (false, 0);
366         return (true, a % b);
367     }
368 
369     /**
370      * @dev Returns the addition of two unsigned integers, reverting on
371      * overflow.
372      *
373      * Counterpart to Solidity's `+` operator.
374      *
375      * Requirements:
376      *
377      * - Addition cannot overflow.
378      */
379     function add(uint256 a, uint256 b) internal pure returns (uint256) {
380         uint256 c = a + b;
381         require(c >= a, "SafeMath: addition overflow");
382         return c;
383     }
384 
385     /**
386      * @dev Returns the subtraction of two unsigned integers, reverting on
387      * overflow (when the result is negative).
388      *
389      * Counterpart to Solidity's `-` operator.
390      *
391      * Requirements:
392      *
393      * - Subtraction cannot overflow.
394      */
395     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
396         require(b <= a, "SafeMath: subtraction overflow");
397         return a - b;
398     }
399 
400     /**
401      * @dev Returns the multiplication of two unsigned integers, reverting on
402      * overflow.
403      *
404      * Counterpart to Solidity's `*` operator.
405      *
406      * Requirements:
407      *
408      * - Multiplication cannot overflow.
409      */
410     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
411         if (a == 0) return 0;
412         uint256 c = a * b;
413         require(c / a == b, "SafeMath: multiplication overflow");
414         return c;
415     }
416 
417     /**
418      * @dev Returns the integer division of two unsigned integers, reverting on
419      * division by zero. The result is rounded towards zero.
420      *
421      * Counterpart to Solidity's `/` operator. Note: this function uses a
422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
423      * uses an invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      *
427      * - The divisor cannot be zero.
428      */
429     function div(uint256 a, uint256 b) internal pure returns (uint256) {
430         require(b > 0, "SafeMath: division by zero");
431         return a / b;
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * reverting when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b > 0, "SafeMath: modulo by zero");
448         return a % b;
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
453      * overflow (when the result is negative).
454      *
455      * CAUTION: This function is deprecated because it requires allocating memory for the error
456      * message unnecessarily. For custom revert reasons use {trySub}.
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b <= a, errorMessage);
466         return a - b;
467     }
468 
469     /**
470      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
471      * division by zero. The result is rounded towards zero.
472      *
473      * CAUTION: This function is deprecated because it requires allocating memory for the error
474      * message unnecessarily. For custom revert reasons use {tryDiv}.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         require(b > 0, errorMessage);
486         return a / b;
487     }
488 
489     /**
490      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
491      * reverting with custom message when dividing by zero.
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {tryMod}.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b > 0, errorMessage);
506         return a % b;
507     }
508 }
509 
510 
511 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
512 
513 /**
514  * @dev Collection of functions related to the address type
515  */
516 library Address {
517     /**
518      * @dev Returns true if `account` is a contract.
519      *
520      * [IMPORTANT]
521      * ====
522      * It is unsafe to assume that an address for which this function returns
523      * false is an externally-owned account (EOA) and not a contract.
524      *
525      * Among others, `isContract` will return false for the following
526      * types of addresses:
527      *
528      *  - an externally-owned account
529      *  - a contract in construction
530      *  - an address where a contract will be created
531      *  - an address where a contract lived, but was destroyed
532      * ====
533      */
534     function isContract(address account) internal view returns (bool) {
535         // This method relies on extcodesize, which returns 0 for contracts in
536         // construction, since the code is only stored at the end of the
537         // constructor execution.
538 
539         uint256 size;
540         // solhint-disable-next-line no-inline-assembly
541         assembly { size := extcodesize(account) }
542         return size > 0;
543     }
544 
545     /**
546      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
547      * `recipient`, forwarding all available gas and reverting on errors.
548      *
549      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
550      * of certain opcodes, possibly making contracts go over the 2300 gas limit
551      * imposed by `transfer`, making them unable to receive funds via
552      * `transfer`. {sendValue} removes this limitation.
553      *
554      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
555      *
556      * IMPORTANT: because control is transferred to `recipient`, care must be
557      * taken to not create reentrancy vulnerabilities. Consider using
558      * {ReentrancyGuard} or the
559      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
560      */
561     function sendValue(address payable recipient, uint256 amount) internal {
562         require(address(this).balance >= amount, "Address: insufficient balance");
563 
564         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
565         (bool success, ) = recipient.call{ value: amount }("");
566         require(success, "Address: unable to send value, recipient may have reverted");
567     }
568 
569     /**
570      * @dev Performs a Solidity function call using a low level `call`. A
571      * plain`call` is an unsafe replacement for a function call: use this
572      * function instead.
573      *
574      * If `target` reverts with a revert reason, it is bubbled up by this
575      * function (like regular Solidity function calls).
576      *
577      * Returns the raw returned data. To convert to the expected return value,
578      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
579      *
580      * Requirements:
581      *
582      * - `target` must be a contract.
583      * - calling `target` with `data` must not revert.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
588       return functionCall(target, data, "Address: low-level call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
593      * `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
598         return functionCallWithValue(target, data, 0, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but also transferring `value` wei to `target`.
604      *
605      * Requirements:
606      *
607      * - the calling contract must have an ETH balance of at least `value`.
608      * - the called Solidity function must be `payable`.
609      *
610      * _Available since v3.1._
611      */
612     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
613         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
618      * with `errorMessage` as a fallback revert reason when `target` reverts.
619      *
620      * _Available since v3.1._
621      */
622     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
623         require(address(this).balance >= value, "Address: insufficient balance for call");
624         require(isContract(target), "Address: call to non-contract");
625 
626         // solhint-disable-next-line avoid-low-level-calls
627         (bool success, bytes memory returndata) = target.call{ value: value }(data);
628         return _verifyCallResult(success, returndata, errorMessage);
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
638         return functionStaticCall(target, data, "Address: low-level static call failed");
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
643      * but performing a static call.
644      *
645      * _Available since v3.3._
646      */
647     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
648         require(isContract(target), "Address: static call to non-contract");
649 
650         // solhint-disable-next-line avoid-low-level-calls
651         (bool success, bytes memory returndata) = target.staticcall(data);
652         return _verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
662         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
672         require(isContract(target), "Address: delegate call to non-contract");
673 
674         // solhint-disable-next-line avoid-low-level-calls
675         (bool success, bytes memory returndata) = target.delegatecall(data);
676         return _verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
680         if (success) {
681             return returndata;
682         } else {
683             // Look for revert reason and bubble it up if present
684             if (returndata.length > 0) {
685                 // The easiest way to bubble the revert reason is using memory via assembly
686 
687                 // solhint-disable-next-line no-inline-assembly
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 
700 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.0
701 
702 /**
703  * @dev Library for managing
704  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
705  * types.
706  *
707  * Sets have the following properties:
708  *
709  * - Elements are added, removed, and checked for existence in constant time
710  * (O(1)).
711  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
712  *
713  * ```
714  * contract Example {
715  *     // Add the library methods
716  *     using EnumerableSet for EnumerableSet.AddressSet;
717  *
718  *     // Declare a set state variable
719  *     EnumerableSet.AddressSet private mySet;
720  * }
721  * ```
722  *
723  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
724  * and `uint256` (`UintSet`) are supported.
725  */
726 library EnumerableSet {
727     // To implement this library for multiple types with as little code
728     // repetition as possible, we write it in terms of a generic Set type with
729     // bytes32 values.
730     // The Set implementation uses private functions, and user-facing
731     // implementations (such as AddressSet) are just wrappers around the
732     // underlying Set.
733     // This means that we can only create new EnumerableSets for types that fit
734     // in bytes32.
735 
736     struct Set {
737         // Storage of set values
738         bytes32[] _values;
739 
740         // Position of the value in the `values` array, plus 1 because index 0
741         // means a value is not in the set.
742         mapping (bytes32 => uint256) _indexes;
743     }
744 
745     /**
746      * @dev Add a value to a set. O(1).
747      *
748      * Returns true if the value was added to the set, that is if it was not
749      * already present.
750      */
751     function _add(Set storage set, bytes32 value) private returns (bool) {
752         if (!_contains(set, value)) {
753             set._values.push(value);
754             // The value is stored at length-1, but we add 1 to all indexes
755             // and use 0 as a sentinel value
756             set._indexes[value] = set._values.length;
757             return true;
758         } else {
759             return false;
760         }
761     }
762 
763     /**
764      * @dev Removes a value from a set. O(1).
765      *
766      * Returns true if the value was removed from the set, that is if it was
767      * present.
768      */
769     function _remove(Set storage set, bytes32 value) private returns (bool) {
770         // We read and store the value's index to prevent multiple reads from the same storage slot
771         uint256 valueIndex = set._indexes[value];
772 
773         if (valueIndex != 0) { // Equivalent to contains(set, value)
774             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
775             // the array, and then remove the last element (sometimes called as 'swap and pop').
776             // This modifies the order of the array, as noted in {at}.
777 
778             uint256 toDeleteIndex = valueIndex - 1;
779             uint256 lastIndex = set._values.length - 1;
780 
781             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
782             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
783 
784             bytes32 lastvalue = set._values[lastIndex];
785 
786             // Move the last value to the index where the value to delete is
787             set._values[toDeleteIndex] = lastvalue;
788             // Update the index for the moved value
789             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
790 
791             // Delete the slot where the moved value was stored
792             set._values.pop();
793 
794             // Delete the index for the deleted slot
795             delete set._indexes[value];
796 
797             return true;
798         } else {
799             return false;
800         }
801     }
802 
803     /**
804      * @dev Returns true if the value is in the set. O(1).
805      */
806     function _contains(Set storage set, bytes32 value) private view returns (bool) {
807         return set._indexes[value] != 0;
808     }
809 
810     /**
811      * @dev Returns the number of values on the set. O(1).
812      */
813     function _length(Set storage set) private view returns (uint256) {
814         return set._values.length;
815     }
816 
817    /**
818     * @dev Returns the value stored at position `index` in the set. O(1).
819     *
820     * Note that there are no guarantees on the ordering of values inside the
821     * array, and it may change when more values are added or removed.
822     *
823     * Requirements:
824     *
825     * - `index` must be strictly less than {length}.
826     */
827     function _at(Set storage set, uint256 index) private view returns (bytes32) {
828         require(set._values.length > index, "EnumerableSet: index out of bounds");
829         return set._values[index];
830     }
831 
832     // Bytes32Set
833 
834     struct Bytes32Set {
835         Set _inner;
836     }
837 
838     /**
839      * @dev Add a value to a set. O(1).
840      *
841      * Returns true if the value was added to the set, that is if it was not
842      * already present.
843      */
844     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
845         return _add(set._inner, value);
846     }
847 
848     /**
849      * @dev Removes a value from a set. O(1).
850      *
851      * Returns true if the value was removed from the set, that is if it was
852      * present.
853      */
854     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
855         return _remove(set._inner, value);
856     }
857 
858     /**
859      * @dev Returns true if the value is in the set. O(1).
860      */
861     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
862         return _contains(set._inner, value);
863     }
864 
865     /**
866      * @dev Returns the number of values in the set. O(1).
867      */
868     function length(Bytes32Set storage set) internal view returns (uint256) {
869         return _length(set._inner);
870     }
871 
872    /**
873     * @dev Returns the value stored at position `index` in the set. O(1).
874     *
875     * Note that there are no guarantees on the ordering of values inside the
876     * array, and it may change when more values are added or removed.
877     *
878     * Requirements:
879     *
880     * - `index` must be strictly less than {length}.
881     */
882     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
883         return _at(set._inner, index);
884     }
885 
886     // AddressSet
887 
888     struct AddressSet {
889         Set _inner;
890     }
891 
892     /**
893      * @dev Add a value to a set. O(1).
894      *
895      * Returns true if the value was added to the set, that is if it was not
896      * already present.
897      */
898     function add(AddressSet storage set, address value) internal returns (bool) {
899         return _add(set._inner, bytes32(uint256(uint160(value))));
900     }
901 
902     /**
903      * @dev Removes a value from a set. O(1).
904      *
905      * Returns true if the value was removed from the set, that is if it was
906      * present.
907      */
908     function remove(AddressSet storage set, address value) internal returns (bool) {
909         return _remove(set._inner, bytes32(uint256(uint160(value))));
910     }
911 
912     /**
913      * @dev Returns true if the value is in the set. O(1).
914      */
915     function contains(AddressSet storage set, address value) internal view returns (bool) {
916         return _contains(set._inner, bytes32(uint256(uint160(value))));
917     }
918 
919     /**
920      * @dev Returns the number of values in the set. O(1).
921      */
922     function length(AddressSet storage set) internal view returns (uint256) {
923         return _length(set._inner);
924     }
925 
926    /**
927     * @dev Returns the value stored at position `index` in the set. O(1).
928     *
929     * Note that there are no guarantees on the ordering of values inside the
930     * array, and it may change when more values are added or removed.
931     *
932     * Requirements:
933     *
934     * - `index` must be strictly less than {length}.
935     */
936     function at(AddressSet storage set, uint256 index) internal view returns (address) {
937         return address(uint160(uint256(_at(set._inner, index))));
938     }
939 
940 
941     // UintSet
942 
943     struct UintSet {
944         Set _inner;
945     }
946 
947     /**
948      * @dev Add a value to a set. O(1).
949      *
950      * Returns true if the value was added to the set, that is if it was not
951      * already present.
952      */
953     function add(UintSet storage set, uint256 value) internal returns (bool) {
954         return _add(set._inner, bytes32(value));
955     }
956 
957     /**
958      * @dev Removes a value from a set. O(1).
959      *
960      * Returns true if the value was removed from the set, that is if it was
961      * present.
962      */
963     function remove(UintSet storage set, uint256 value) internal returns (bool) {
964         return _remove(set._inner, bytes32(value));
965     }
966 
967     /**
968      * @dev Returns true if the value is in the set. O(1).
969      */
970     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
971         return _contains(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns the number of values on the set. O(1).
976      */
977     function length(UintSet storage set) internal view returns (uint256) {
978         return _length(set._inner);
979     }
980 
981    /**
982     * @dev Returns the value stored at position `index` in the set. O(1).
983     *
984     * Note that there are no guarantees on the ordering of values inside the
985     * array, and it may change when more values are added or removed.
986     *
987     * Requirements:
988     *
989     * - `index` must be strictly less than {length}.
990     */
991     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
992         return uint256(_at(set._inner, index));
993     }
994 }
995 
996 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.0
997 
998 /**
999  * @dev Library for managing an enumerable variant of Solidity's
1000  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1001  * type.
1002  *
1003  * Maps have the following properties:
1004  *
1005  * - Entries are added, removed, and checked for existence in constant time
1006  * (O(1)).
1007  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1008  *
1009  * ```
1010  * contract Example {
1011  *     // Add the library methods
1012  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1013  *
1014  *     // Declare a set state variable
1015  *     EnumerableMap.UintToAddressMap private myMap;
1016  * }
1017  * ```
1018  *
1019  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1020  * supported.
1021  */
1022 library EnumerableMap {
1023     // To implement this library for multiple types with as little code
1024     // repetition as possible, we write it in terms of a generic Map type with
1025     // bytes32 keys and values.
1026     // The Map implementation uses private functions, and user-facing
1027     // implementations (such as Uint256ToAddressMap) are just wrappers around
1028     // the underlying Map.
1029     // This means that we can only create new EnumerableMaps for types that fit
1030     // in bytes32.
1031 
1032     struct MapEntry {
1033         bytes32 _key;
1034         bytes32 _value;
1035     }
1036 
1037     struct Map {
1038         // Storage of map keys and values
1039         MapEntry[] _entries;
1040 
1041         // Position of the entry defined by a key in the `entries` array, plus 1
1042         // because index 0 means a key is not in the map.
1043         mapping (bytes32 => uint256) _indexes;
1044     }
1045 
1046     /**
1047      * @dev Adds a key-value pair to a map, or updates the value for an existing
1048      * key. O(1).
1049      *
1050      * Returns true if the key was added to the map, that is if it was not
1051      * already present.
1052      */
1053     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1054         // We read and store the key's index to prevent multiple reads from the same storage slot
1055         uint256 keyIndex = map._indexes[key];
1056 
1057         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1058             map._entries.push(MapEntry({ _key: key, _value: value }));
1059             // The entry is stored at length-1, but we add 1 to all indexes
1060             // and use 0 as a sentinel value
1061             map._indexes[key] = map._entries.length;
1062             return true;
1063         } else {
1064             map._entries[keyIndex - 1]._value = value;
1065             return false;
1066         }
1067     }
1068 
1069     /**
1070      * @dev Removes a key-value pair from a map. O(1).
1071      *
1072      * Returns true if the key was removed from the map, that is if it was present.
1073      */
1074     function _remove(Map storage map, bytes32 key) private returns (bool) {
1075         // We read and store the key's index to prevent multiple reads from the same storage slot
1076         uint256 keyIndex = map._indexes[key];
1077 
1078         if (keyIndex != 0) { // Equivalent to contains(map, key)
1079             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1080             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1081             // This modifies the order of the array, as noted in {at}.
1082 
1083             uint256 toDeleteIndex = keyIndex - 1;
1084             uint256 lastIndex = map._entries.length - 1;
1085 
1086             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1087             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1088 
1089             MapEntry storage lastEntry = map._entries[lastIndex];
1090 
1091             // Move the last entry to the index where the entry to delete is
1092             map._entries[toDeleteIndex] = lastEntry;
1093             // Update the index for the moved entry
1094             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1095 
1096             // Delete the slot where the moved entry was stored
1097             map._entries.pop();
1098 
1099             // Delete the index for the deleted slot
1100             delete map._indexes[key];
1101 
1102             return true;
1103         } else {
1104             return false;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Returns true if the key is in the map. O(1).
1110      */
1111     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1112         return map._indexes[key] != 0;
1113     }
1114 
1115     /**
1116      * @dev Returns the number of key-value pairs in the map. O(1).
1117      */
1118     function _length(Map storage map) private view returns (uint256) {
1119         return map._entries.length;
1120     }
1121 
1122    /**
1123     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1124     *
1125     * Note that there are no guarantees on the ordering of entries inside the
1126     * array, and it may change when more entries are added or removed.
1127     *
1128     * Requirements:
1129     *
1130     * - `index` must be strictly less than {length}.
1131     */
1132     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1133         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1134 
1135         MapEntry storage entry = map._entries[index];
1136         return (entry._key, entry._value);
1137     }
1138 
1139     /**
1140      * @dev Tries to returns the value associated with `key`.  O(1).
1141      * Does not revert if `key` is not in the map.
1142      */
1143     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1144         uint256 keyIndex = map._indexes[key];
1145         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1146         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1147     }
1148 
1149     /**
1150      * @dev Returns the value associated with `key`.  O(1).
1151      *
1152      * Requirements:
1153      *
1154      * - `key` must be in the map.
1155      */
1156     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1157         uint256 keyIndex = map._indexes[key];
1158         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1159         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1160     }
1161 
1162     /**
1163      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1164      *
1165      * CAUTION: This function is deprecated because it requires allocating memory for the error
1166      * message unnecessarily. For custom revert reasons use {_tryGet}.
1167      */
1168     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1169         uint256 keyIndex = map._indexes[key];
1170         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1171         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1172     }
1173 
1174     // UintToAddressMap
1175 
1176     struct UintToAddressMap {
1177         Map _inner;
1178     }
1179 
1180     /**
1181      * @dev Adds a key-value pair to a map, or updates the value for an existing
1182      * key. O(1).
1183      *
1184      * Returns true if the key was added to the map, that is if it was not
1185      * already present.
1186      */
1187     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1188         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1189     }
1190 
1191     /**
1192      * @dev Removes a value from a set. O(1).
1193      *
1194      * Returns true if the key was removed from the map, that is if it was present.
1195      */
1196     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1197         return _remove(map._inner, bytes32(key));
1198     }
1199 
1200     /**
1201      * @dev Returns true if the key is in the map. O(1).
1202      */
1203     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1204         return _contains(map._inner, bytes32(key));
1205     }
1206 
1207     /**
1208      * @dev Returns the number of elements in the map. O(1).
1209      */
1210     function length(UintToAddressMap storage map) internal view returns (uint256) {
1211         return _length(map._inner);
1212     }
1213 
1214    /**
1215     * @dev Returns the element stored at position `index` in the set. O(1).
1216     * Note that there are no guarantees on the ordering of values inside the
1217     * array, and it may change when more values are added or removed.
1218     *
1219     * Requirements:
1220     *
1221     * - `index` must be strictly less than {length}.
1222     */
1223     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1224         (bytes32 key, bytes32 value) = _at(map._inner, index);
1225         return (uint256(key), address(uint160(uint256(value))));
1226     }
1227 
1228     /**
1229      * @dev Tries to returns the value associated with `key`.  O(1).
1230      * Does not revert if `key` is not in the map.
1231      *
1232      * _Available since v3.4._
1233      */
1234     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1235         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1236         return (success, address(uint160(uint256(value))));
1237     }
1238 
1239     /**
1240      * @dev Returns the value associated with `key`.  O(1).
1241      *
1242      * Requirements:
1243      *
1244      * - `key` must be in the map.
1245      */
1246     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1247         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1248     }
1249 
1250     /**
1251      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1252      *
1253      * CAUTION: This function is deprecated because it requires allocating memory for the error
1254      * message unnecessarily. For custom revert reasons use {tryGet}.
1255      */
1256     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1257         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1258     }
1259 }
1260 
1261 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.0
1262 
1263 /**
1264  * @dev String operations.
1265  */
1266 library Strings {
1267     /**
1268      * @dev Converts a `uint256` to its ASCII `string` representation.
1269      */
1270     function toString(uint256 value) internal pure returns (string memory) {
1271         // Inspired by OraclizeAPI's implementation - MIT licence
1272         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1273 
1274         if (value == 0) {
1275             return "0";
1276         }
1277         uint256 temp = value;
1278         uint256 digits;
1279         while (temp != 0) {
1280             digits++;
1281             temp /= 10;
1282         }
1283         bytes memory buffer = new bytes(digits);
1284         uint256 index = digits - 1;
1285         temp = value;
1286         while (temp != 0) {
1287             buffer[index--] = bytes1(uint8(48 + temp % 10));
1288             temp /= 10;
1289         }
1290         return string(buffer);
1291     }
1292 }
1293 
1294 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.0
1295 
1296 /**
1297  * @title ERC721 Non-Fungible Token Standard basic implementation
1298  * @dev see https://eips.ethereum.org/EIPS/eip-721
1299  */
1300 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1301     using SafeMath for uint256;
1302     using Address for address;
1303     using EnumerableSet for EnumerableSet.UintSet;
1304     using EnumerableMap for EnumerableMap.UintToAddressMap;
1305     using Strings for uint256;
1306 
1307     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1308     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1309     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1310 
1311     // Mapping from holder address to their (enumerable) set of owned tokens
1312     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1313 
1314     // Enumerable mapping from token ids to their owners
1315     EnumerableMap.UintToAddressMap private _tokenOwners;
1316 
1317     // Mapping from token ID to approved address
1318     mapping (uint256 => address) private _tokenApprovals;
1319 
1320     // Mapping from owner to operator approvals
1321     mapping (address => mapping (address => bool)) private _operatorApprovals;
1322 
1323     // Token name
1324     string private _name;
1325 
1326     // Token symbol
1327     string private _symbol;
1328 
1329     // Optional mapping for token URIs
1330     mapping (uint256 => string) private _tokenURIs;
1331 
1332     // Base URI
1333     string private _baseURI;
1334 
1335     /*
1336      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1337      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1338      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1339      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1340      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1341      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1342      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1343      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1344      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1345      *
1346      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1347      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1348      */
1349     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1350 
1351     /*
1352      *     bytes4(keccak256('name()')) == 0x06fdde03
1353      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1354      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1355      *
1356      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1357      */
1358     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1359 
1360     /*
1361      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1362      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1363      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1364      *
1365      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1366      */
1367     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1368 
1369     /**
1370      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1371      */
1372     constructor (string memory name_, string memory symbol_) public {
1373         _name = name_;
1374         _symbol = symbol_;
1375 
1376         // register the supported interfaces to conform to ERC721 via ERC165
1377         _registerInterface(_INTERFACE_ID_ERC721);
1378         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1379         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-balanceOf}.
1384      */
1385     function balanceOf(address owner) public view virtual override returns (uint256) {
1386         require(owner != address(0), "ERC721: balance query for the zero address");
1387         return _holderTokens[owner].length();
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-ownerOf}.
1392      */
1393     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1394         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Metadata-name}.
1399      */
1400     function name() public view virtual override returns (string memory) {
1401         return _name;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Metadata-symbol}.
1406      */
1407     function symbol() public view virtual override returns (string memory) {
1408         return _symbol;
1409     }
1410 
1411     /**
1412     * @dev See {IERC721Metadata-tokenURI}.
1413     */
1414     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1415         string memory _tokenURI = _tokenURIs[tokenId];
1416         string memory base = baseURI();
1417 
1418         // If there is no base URI, return the token URI.
1419         if (bytes(base).length == 0) {
1420             return _tokenURI;
1421         }
1422         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1423         if (bytes(_tokenURI).length > 0) {
1424             return string(abi.encodePacked(base, _tokenURI));
1425         }
1426         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1427         return string(abi.encodePacked(base, tokenId.toString()));
1428     }
1429 
1430     /**
1431     * @dev Returns the base URI set via {_setBaseURI}. This will be
1432     * automatically added as a prefix in {tokenURI} to each token's URI, or
1433     * to the token ID if no specific URI is set for that token ID.
1434     */
1435     function baseURI() public view virtual returns (string memory) {
1436         return _baseURI;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1441      */
1442     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1443         return _holderTokens[owner].at(index);
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Enumerable-totalSupply}.
1448      */
1449     function totalSupply() public view virtual override returns (uint256) {
1450         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1451         return _tokenOwners.length();
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Enumerable-tokenByIndex}.
1456      */
1457     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1458         (uint256 tokenId, ) = _tokenOwners.at(index);
1459         return tokenId;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-approve}.
1464      */
1465     function approve(address to, uint256 tokenId) public virtual override {
1466         address owner = ERC721.ownerOf(tokenId);
1467         require(to != owner, "ERC721: approval to current owner");
1468 
1469         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1470             "ERC721: approve caller is not owner nor approved for all"
1471         );
1472 
1473         _approve(to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-getApproved}.
1478      */
1479     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1480         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1481 
1482         return _tokenApprovals[tokenId];
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-setApprovalForAll}.
1487      */
1488     function setApprovalForAll(address operator, bool approved) public virtual override {
1489         require(operator != _msgSender(), "ERC721: approve to caller");
1490 
1491         _operatorApprovals[_msgSender()][operator] = approved;
1492         emit ApprovalForAll(_msgSender(), operator, approved);
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-isApprovedForAll}.
1497      */
1498     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1499         return _operatorApprovals[owner][operator];
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-transferFrom}.
1504      */
1505     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1506         //solhint-disable-next-line max-line-length
1507         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1508 
1509         _transfer(from, to, tokenId);
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-safeTransferFrom}.
1514      */
1515     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1516         safeTransferFrom(from, to, tokenId, "");
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-safeTransferFrom}.
1521      */
1522     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1523         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1524         _safeTransfer(from, to, tokenId, _data);
1525     }
1526 
1527     /**
1528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1530      *
1531      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1532      *
1533      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1534      * implement alternative mechanisms to perform token transfer, such as signature-based.
1535      *
1536      * Requirements:
1537      *
1538      * - `from` cannot be the zero address.
1539      * - `to` cannot be the zero address.
1540      * - `tokenId` token must exist and be owned by `from`.
1541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1542      *
1543      * Emits a {Transfer} event.
1544      */
1545     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1546         _transfer(from, to, tokenId);
1547         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1548     }
1549 
1550     /**
1551      * @dev Returns whether `tokenId` exists.
1552      *
1553      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1554      *
1555      * Tokens start existing when they are minted (`_mint`),
1556      * and stop existing when they are burned (`_burn`).
1557      */
1558     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1559         return _tokenOwners.contains(tokenId);
1560     }
1561 
1562     /**
1563      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1564      *
1565      * Requirements:
1566      *
1567      * - `tokenId` must exist.
1568      */
1569     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1570         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1571         address owner = ERC721.ownerOf(tokenId);
1572         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1573     }
1574 
1575     /**
1576      * @dev Safely mints `tokenId` and transfers it to `to`.
1577      *
1578      * Requirements:
1579      d*
1580      * - `tokenId` must not exist.
1581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function _safeMint(address to, uint256 tokenId) internal virtual {
1586         _safeMint(to, tokenId, "");
1587     }
1588 
1589     /**
1590      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1591      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1592      */
1593     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1594         _mint(to, tokenId);
1595         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1596     }
1597 
1598     /**
1599      * @dev Mints `tokenId` and transfers it to `to`.
1600      *
1601      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must not exist.
1606      * - `to` cannot be the zero address.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _mint(address to, uint256 tokenId) internal virtual {
1611         require(to != address(0), "ERC721: mint to the zero address");
1612         require(!_exists(tokenId), "ERC721: token already minted");
1613 
1614         _beforeTokenTransfer(address(0), to, tokenId);
1615 
1616         _holderTokens[to].add(tokenId);
1617 
1618         _tokenOwners.set(tokenId, to);
1619 
1620         emit Transfer(address(0), to, tokenId);
1621     }
1622 
1623     /**
1624      * @dev Destroys `tokenId`.
1625      * The approval is cleared when the token is burned.
1626      *
1627      * Requirements:
1628      *
1629      * - `tokenId` must exist.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _burn(uint256 tokenId) internal virtual {
1634         address owner = ERC721.ownerOf(tokenId); // internal owner
1635 
1636         _beforeTokenTransfer(owner, address(0), tokenId);
1637 
1638         // Clear approvals
1639         _approve(address(0), tokenId);
1640 
1641         // Clear metadata (if any)
1642         if (bytes(_tokenURIs[tokenId]).length != 0) {
1643             delete _tokenURIs[tokenId];
1644         }
1645 
1646         _holderTokens[owner].remove(tokenId);
1647 
1648         _tokenOwners.remove(tokenId);
1649 
1650         emit Transfer(owner, address(0), tokenId);
1651     }
1652 
1653     /**
1654      * @dev Transfers `tokenId` from `from` to `to`.
1655      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1656      *
1657      * Requirements:
1658      *
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must be owned by `from`.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1665         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1666         require(to != address(0), "ERC721: transfer to the zero address");
1667 
1668         _beforeTokenTransfer(from, to, tokenId);
1669 
1670         // Clear approvals from the previous owner
1671         _approve(address(0), tokenId);
1672 
1673         _holderTokens[from].remove(tokenId);
1674         _holderTokens[to].add(tokenId);
1675 
1676         _tokenOwners.set(tokenId, to);
1677 
1678         emit Transfer(from, to, tokenId);
1679     }
1680 
1681     /**
1682      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1683      *
1684      * Requirements:
1685      *
1686      * - `tokenId` must exist.
1687      */
1688     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1689         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1690         _tokenURIs[tokenId] = _tokenURI;
1691     }
1692 
1693     /**
1694      * @dev Internal function to set the base URI for all token IDs. It is
1695      * automatically added as a prefix to the value returned in {tokenURI},
1696      * or to the token ID if {tokenURI} is empty.
1697      */
1698     function _setBaseURI(string memory baseURI_) internal virtual {
1699         _baseURI = baseURI_;
1700     }
1701 
1702     /**
1703      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1704      * The call is not executed if the target address is not a contract.
1705      *
1706      * @param from address representing the previous owner of the given token ID
1707      * @param to target address that will receive the tokens
1708      * @param tokenId uint256 ID of the token to be transferred
1709      * @param _data bytes optional data to send along with the call
1710      * @return bool whether the call correctly returned the expected magic value
1711      */
1712     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1713         private returns (bool)
1714     {
1715         if (!to.isContract()) {
1716             return true;
1717         }
1718         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1719             IERC721Receiver(to).onERC721Received.selector,
1720             _msgSender(),
1721             from,
1722             tokenId,
1723             _data
1724         ), "ERC721: transfer to non ERC721Receiver implementer");
1725         bytes4 retval = abi.decode(returndata, (bytes4));
1726         return (retval == _ERC721_RECEIVED);
1727     }
1728 
1729     function _approve(address to, uint256 tokenId) private {
1730         _tokenApprovals[tokenId] = to;
1731         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1732     }
1733 
1734     /**
1735      * @dev Hook that is called before any token transfer. This includes minting
1736      * and burning.
1737      *
1738      * Calling conditions:
1739      *
1740      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1741      * transferred to `to`.
1742      * - When `from` is zero, `tokenId` will be minted for `to`.
1743      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1744      * - `from` cannot be the zero address.
1745      * - `to` cannot be the zero address.
1746      *
1747      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1748      */
1749     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1750 }
1751 
1752 // File @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol@v3.4.0
1753 
1754 /**
1755  * @title ERC721 Burnable Token
1756  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1757  */
1758 abstract contract ERC721Burnable is Context, ERC721 {
1759     /**
1760      * @dev Burns `tokenId`. See {ERC721-_burn}.
1761      *
1762      * Requirements:
1763      *
1764      * - The caller must own `tokenId` or be an approved operator.
1765      */
1766     function burn(uint256 tokenId) public virtual {
1767         //solhint-disable-next-line max-line-length
1768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1769         _burn(tokenId);
1770     }
1771 }
1772 
1773 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
1774 
1775 /**
1776  * @dev Contract module which provides a basic access control mechanism, where
1777  * there is an account (an owner) that can be granted exclusive access to
1778  * specific functions.
1779  *
1780  * By default, the owner account will be the one that deploys the contract. This
1781  * can later be changed with {transferOwnership}.
1782  *
1783  * This module is used through inheritance. It will make available the modifier
1784  * `onlyOwner`, which can be applied to your functions to restrict their use to
1785  * the owner.
1786  */
1787 abstract contract Ownable is Context {
1788     address private _owner;
1789 
1790     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1791 
1792     /**
1793      * @dev Initializes the contract setting the deployer as the initial owner.
1794      */
1795     constructor () internal {
1796         address msgSender = _msgSender();
1797         _owner = msgSender;
1798         emit OwnershipTransferred(address(0), msgSender);
1799     }
1800 
1801     /**
1802      * @dev Returns the address of the current owner.
1803      */
1804     function owner() public view virtual returns (address) {
1805         return _owner;
1806     }
1807 
1808     /**
1809      * @dev Throws if called by any account other than the owner.
1810      */
1811     modifier onlyOwner() {
1812         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1813         _;
1814     }
1815 
1816      /**
1817     * @dev Throws if called by any account other than the owner.
1818     */
1819     modifier onlyTreasury(address _treasury) {
1820         require(_msgSender() == _treasury, "Ownable: caller is not the treasury");
1821         _;
1822     }
1823 
1824     /**
1825      * @dev Leaves the contract without owner. It will not be possible to call
1826      * `onlyOwner` functions anymore. Can only be called by the current owner.
1827      *
1828      * NOTE: Renouncing ownership will leave the contract without an owner,
1829      * thereby removing any functionality that is only available to the owner.
1830      */
1831     function renounceOwnership() public virtual onlyOwner {
1832         emit OwnershipTransferred(_owner, address(0));
1833         _owner = address(0);
1834     }
1835 
1836     /**
1837      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1838      * Can only be called by the current owner.
1839      */
1840     function transferOwnership(address newOwner) public virtual onlyOwner {
1841         require(newOwner != address(0), "Ownable: new owner is the zero address");
1842         emit OwnershipTransferred(_owner, newOwner);
1843         _owner = newOwner;
1844     }
1845 }
1846 
1847 // File contracts/FunkyMonkeyFratHouse.sol
1848 
1849 contract FunkyMonkeyFratHouse is ERC721Burnable, Ownable {
1850     uint256 constant public TOTAL_SUPPLY = 9999;
1851     uint256 public PRICE = 0.1 ether;
1852     uint256 public maxMintPerTransaction = 5;
1853     
1854     string public placeholderURI = '';
1855 
1856     // 0 = Toga Party
1857     // 1 = Greek Life
1858     // 2 = Pirate Parade
1859     struct Drops {
1860         uint256 fromIndex;
1861         uint256 toIndex;
1862         uint256 totalAmount;
1863         uint256 startingIndex;
1864         uint256 startingIndexBlock;
1865         bool dropIsActive;
1866     }
1867     mapping (uint256 => Drops) public drops;
1868     
1869     address payable treasury;
1870 
1871     bool public publicSaleIsActive = false;
1872 
1873     constructor(address payable _treasury) public ERC721("Funky Monkey Frat House", "FMFH") {
1874         treasury = _treasury;
1875         
1876         setBaseURI('ipfs://QmYB4N3aF7AvyycK7Dde4cjDEgMSYpRGRpmqebax46zbae/');
1877         placeholderURI = 'ipfs://QmeC2JKPDjrPq4SYx8ZsJdzVvRBQBb7yecPv2JzeE1U2y7/';
1878     }
1879 
1880     /**
1881     * Initialize drop config for the toga party
1882     */
1883     function initDropConfigTogaParty(
1884         uint256 _fromIndex,
1885         uint256 _toIndex,
1886         uint256 _totalAmount,
1887         bool _activateStartingIndex,
1888         bool _dropIsActive
1889     ) external onlyOwner {
1890         require(_toIndex > _fromIndex, "FunkyMonkeyFratHouseClub: The _toIndex can't be smaller than the _fromIndex");
1891         if(_activateStartingIndex) {
1892             require(drops[0].startingIndex == 0, "FunkyMonkeyFratHouseClub: Starting index is already set");
1893             require(drops[0].startingIndexBlock != 0, "FunkyMonkeyFratHouseClub: Starting index block must be set");
1894             drops[0].startingIndex = uint(blockhash(drops[0].startingIndexBlock)) % _totalAmount;
1895             // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1896             if (block.number.sub(drops[0].startingIndexBlock) > 255) {
1897                 drops[0].startingIndex = uint(blockhash(block.number - 1)) % _totalAmount;
1898             }
1899         }
1900 
1901         drops[1].dropIsActive = false;
1902         drops[2].dropIsActive = false;
1903         drops[0] = Drops({
1904             fromIndex: _fromIndex,
1905             toIndex: _toIndex,
1906             totalAmount: _totalAmount,
1907             startingIndex: drops[0].startingIndex,
1908             startingIndexBlock: drops[0].startingIndexBlock,
1909             dropIsActive: _dropIsActive
1910         });
1911     }
1912 
1913     /**
1914     * Initialize drop config for the toga party
1915     */
1916     function initDropConfigGreekLife(
1917         uint256 _fromIndex,
1918         uint256 _toIndex,
1919         uint256 _totalAmount,
1920         bool _activateStartingIndex,
1921         bool _dropIsActive
1922     ) external onlyOwner {
1923         require(_toIndex > _fromIndex, "FunkyMonkeyFratHouseClub: The _toIndex can't be smaller than the _fromIndex");
1924         if(_activateStartingIndex) {
1925             require(drops[1].startingIndex == 0, "FunkyMonkeyFratHouseClub: Starting index is already set");
1926             require(drops[1].startingIndexBlock != 0, "FunkyMonkeyFratHouseClub: Starting index block must be set");
1927             drops[1].startingIndex = uint(blockhash(drops[1].startingIndexBlock)) % _totalAmount;
1928             // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1929             if (block.number.sub(drops[1].startingIndexBlock) > 255) {
1930                 drops[1].startingIndex = uint(blockhash(block.number - 1)) % _totalAmount;
1931             }
1932         }
1933 
1934         drops[0].dropIsActive = false;
1935         drops[2].dropIsActive = false;
1936         drops[1] = Drops({
1937             fromIndex: _fromIndex,
1938             toIndex: _toIndex,
1939             totalAmount: _totalAmount,
1940             startingIndex: drops[1].startingIndex,
1941             startingIndexBlock: drops[1].startingIndexBlock,
1942             dropIsActive: _dropIsActive
1943         });
1944     }
1945 
1946     /**
1947     * Initialize drop config for the Pirate Parada
1948     */
1949     function initDropConfigPirateParade(
1950         uint256 _fromIndex,
1951         uint256 _toIndex,
1952         uint256 _totalAmount,
1953         bool _activateStartingIndex,
1954         bool _dropIsActive
1955     ) external onlyOwner {
1956         require(_toIndex > _fromIndex, "FunkyMonkeyFratHouseClub: The _toIndex can't be smaller than the _fromIndex");
1957         if(_activateStartingIndex) {
1958             require(drops[2].startingIndex == 0, "FunkyMonkeyFratHouseClub: Starting index is already set");
1959             require(drops[2].startingIndexBlock != 0, "FunkyMonkeyFratHouseClub: Starting index block must be set");
1960             drops[2].startingIndex = uint(blockhash(drops[2].startingIndexBlock)) % _totalAmount;
1961             // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1962             if (block.number.sub(drops[2].startingIndexBlock) > 255) {
1963                 drops[2].startingIndex = uint(blockhash(block.number - 1)) % _totalAmount;
1964             }
1965         }
1966 
1967         drops[0].dropIsActive = false;
1968         drops[1].dropIsActive = false;
1969         drops[2] = Drops({
1970             fromIndex: _fromIndex,
1971             toIndex: _toIndex,
1972             totalAmount: _totalAmount,
1973             startingIndex: drops[2].startingIndex,
1974             startingIndexBlock: drops[2].startingIndexBlock,
1975             dropIsActive: _dropIsActive
1976         });
1977     }
1978 
1979     /**
1980     * Flip the sale state
1981     */
1982     function flipSale(bool _isActive) public onlyOwner {
1983         publicSaleIsActive = _isActive;
1984     }
1985 
1986     /**
1987     * Mint public FunkyMonkeyFratHouse
1988     */
1989     function mintFunkyMonkeyFratHouse(uint numberOfTokens) public payable {
1990         require(publicSaleIsActive, "FunkyMonkeyFratHouseClub: Public sale must be active to mint");
1991         require(totalSupply().add(numberOfTokens) <= TOTAL_SUPPLY, "FunkyMonkeyFratHouseClub: Exceeds max supply");
1992         require(numberOfTokens <= maxMintPerTransaction, "FunkyMonkeyFratHouseClub: Above max tx count");
1993         require(PRICE.mul(numberOfTokens) <= msg.value, "FunkyMonkeyFratHouseClub: ETH sent is incorrect");
1994 
1995         uint256 totalTokensAfterMint = totalSupply().add(numberOfTokens);
1996         if (drops[0].dropIsActive) {
1997             require(totalTokensAfterMint <= drops[0].totalAmount, "Can't mint more than the totalAmount per drop");
1998             if (totalTokensAfterMint == drops[0].totalAmount) {
1999                 publicSaleIsActive = false;
2000             }
2001         } else if (drops[1].dropIsActive) {
2002             require(totalTokensAfterMint <= drops[1].totalAmount, "Can't mint more than the totalAmount per drop");
2003             if (totalTokensAfterMint == drops[1].totalAmount) {
2004                 publicSaleIsActive = false;
2005             }
2006         } else if (drops[2].dropIsActive) {
2007             require(totalTokensAfterMint <= drops[2].totalAmount, "Can't mint more than the totalAmount per drop");
2008             if (totalTokensAfterMint == drops[2].totalAmount) {
2009                 publicSaleIsActive = false;
2010             }
2011         }
2012 
2013         for(uint i = 0; i < numberOfTokens; i++) {
2014             uint mintIndex = totalSupply();
2015             _safeMint(msg.sender, mintIndex);
2016         }
2017         
2018         // 0 = Toga Party
2019         // 1 = Greek Life
2020         // 2 = Pirate Parade
2021         // Set the starting index if the drop is active
2022         if(drops[0].startingIndexBlock == 0 && drops[0].dropIsActive) {
2023             drops[0].startingIndexBlock = block.number;
2024         }
2025         // If we haven't set the starting index yet.
2026         if(drops[1].startingIndexBlock == 0 && drops[1].dropIsActive) {
2027             drops[1].startingIndexBlock = block.number;
2028         }
2029         // If we haven't set the starting index yet.
2030         if(drops[2].startingIndexBlock == 0 && drops[2].dropIsActive) {
2031             drops[2].startingIndexBlock = block.number;
2032         }
2033     }
2034 
2035     /**
2036     * Set the baseURI
2037     */
2038     function setBaseURI(string memory baseURI) public onlyOwner {
2039         _setBaseURI(baseURI);
2040     }
2041 
2042      /**
2043     * Set the price
2044     */
2045     function setPricePerNFT(uint256 _price) public onlyOwner {
2046         PRICE = _price;
2047     }
2048 
2049     /**
2050     * Set the MAX mints per TX
2051     */
2052     function setMaxMintsPerTransaction(uint256 _maxMintPerTransaction) public onlyOwner {
2053         maxMintPerTransaction = _maxMintPerTransaction;
2054     }
2055 
2056     /**
2057     * Set the placeholder URI
2058     */
2059     function setPlaceholderURI(string memory _placeholderURI) public onlyOwner {
2060         placeholderURI = _placeholderURI;
2061     }
2062 
2063     /**
2064     * Set the address of the treasury
2065     */
2066     function setTreasuryWallet(address payable _treasury) public onlyOwner {
2067         treasury = _treasury;
2068     }
2069 
2070     /**
2071     * Claim eth only available for the treasury address
2072     */
2073     function claimETH() public onlyTreasury(treasury) {
2074         payable(address(treasury)).transfer(address(this).balance);
2075     }
2076 
2077     /**
2078     * Get your api url based on your tokenId
2079     */
2080     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2081         Drops memory drop;
2082         if(tokenId >= drops[0].fromIndex && tokenId <= drops[0].toIndex) {
2083             drop = drops[0];
2084         } else if(tokenId >= drops[1].fromIndex && tokenId <= drops[1].toIndex) {
2085             drop = drops[1];
2086         } else if(tokenId >= drops[2].fromIndex && tokenId <= drops[2].toIndex) {
2087             drop = drops[2];
2088         }
2089 
2090         if(drop.startingIndex == 0) {
2091             return placeholderURI;
2092         }
2093 
2094         uint256 moddedId = drop.fromIndex + ((tokenId + drop.startingIndex) % (drop.fromIndex + drop.totalAmount));
2095         return super.tokenURI(moddedId);
2096     }
2097 }