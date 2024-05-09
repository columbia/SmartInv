1 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
2 // SPDX-License-Identifier: AGPL-3.0-or-later
3 pragma solidity ^0.6.8;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
27 
28 /**
29  * @dev Interface of the ERC165 standard, as defined in the
30  * https://eips.ethereum.org/EIPS/eip-165[EIP].
31  *
32  * Implementers can declare support of contract interfaces, which can then be
33  * queried by others ({ERC165Checker}).
34  *
35  * For an implementation, see {ERC165}.
36  */
37 interface IERC165 {
38     /**
39      * @dev Returns true if this contract implements the interface defined by
40      * `interfaceId`. See the corresponding
41      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
42      * to learn more about how these ids are created.
43      *
44      * This function call must use less than 30 000 gas.
45      */
46     function supportsInterface(bytes4 interfaceId) external view returns (bool);
47 }
48 
49 
50 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
51 
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
63      */
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(address from, address to, uint256 tokenId) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must be owned by `from`.
111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(address from, address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId) external view returns (address operator);
140 
141     /**
142      * @dev Approve or remove `operator` as an operator for the caller.
143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
144      *
145      * Requirements:
146      *
147      * - The `operator` cannot be the caller.
148      *
149      * Emits an {ApprovalForAll} event.
150      */
151     function setApprovalForAll(address operator, bool _approved) external;
152 
153     /**
154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
155      *
156      * See {setApprovalForAll}
157      */
158     function isApprovedForAll(address owner, address operator) external view returns (bool);
159 
160     /**
161       * @dev Safely transfers `tokenId` token from `from` to `to`.
162       *
163       * Requirements:
164       *
165       * - `from` cannot be the zero address.
166       * - `to` cannot be the zero address.
167       * - `tokenId` token must exist and be owned by `from`.
168       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170       *
171       * Emits a {Transfer} event.
172       */
173     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
174 }
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.0
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
180  * @dev See https://eips.ethereum.org/EIPS/eip-721
181  */
182 interface IERC721Metadata is IERC721 {
183 
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
196      */
197     function tokenURI(uint256 tokenId) external view returns (string memory);
198 }
199 
200 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.0
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Enumerable is IERC721 {
207 
208     /**
209      * @dev Returns the total amount of tokens stored by the contract.
210      */
211     function totalSupply() external view returns (uint256);
212 
213     /**
214      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
215      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
216      */
217     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
218 
219     /**
220      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
221      * Use along with {totalSupply} to enumerate all tokens.
222      */
223     function tokenByIndex(uint256 index) external view returns (uint256);
224 }
225 
226 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.0
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
244 }
245 
246 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.0
247 
248 /**
249  * @dev Implementation of the {IERC165} interface.
250  *
251  * Contracts may inherit from this and call {_registerInterface} to declare
252  * their support of an interface.
253  */
254 abstract contract ERC165 is IERC165 {
255     /*
256      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
257      */
258     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
259 
260     /**
261      * @dev Mapping of interface ids to whether or not it's supported.
262      */
263     mapping(bytes4 => bool) private _supportedInterfaces;
264 
265     constructor () internal {
266         // Derived contracts need only register support for their own interfaces,
267         // we register support for ERC165 itself here
268         _registerInterface(_INTERFACE_ID_ERC165);
269     }
270 
271     /**
272      * @dev See {IERC165-supportsInterface}.
273      *
274      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
277         return _supportedInterfaces[interfaceId];
278     }
279 
280     /**
281      * @dev Registers the contract as an implementer of the interface defined by
282      * `interfaceId`. Support of the actual ERC165 interface is automatic and
283      * registering its interface id is not required.
284      *
285      * See {IERC165-supportsInterface}.
286      *
287      * Requirements:
288      *
289      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
290      */
291     function _registerInterface(bytes4 interfaceId) internal virtual {
292         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
293         _supportedInterfaces[interfaceId] = true;
294     }
295 }
296 
297 
298 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, with an overflow flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         uint256 c = a + b;
321         if (c < a) return (false, 0);
322         return (true, c);
323     }
324 
325     /**
326      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
327      *
328      * _Available since v3.4._
329      */
330     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         if (b > a) return (false, 0);
332         return (true, a - b);
333     }
334 
335     /**
336      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
342         // benefit is lost if 'b' is also tested.
343         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
344         if (a == 0) return (true, 0);
345         uint256 c = a * b;
346         if (c / a != b) return (false, 0);
347         return (true, c);
348     }
349 
350     /**
351      * @dev Returns the division of two unsigned integers, with a division by zero flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b == 0) return (false, 0);
357         return (true, a / b);
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         if (b == 0) return (false, 0);
367         return (true, a % b);
368     }
369 
370     /**
371      * @dev Returns the addition of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `+` operator.
375      *
376      * Requirements:
377      *
378      * - Addition cannot overflow.
379      */
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         require(c >= a, "SafeMath: addition overflow");
383         return c;
384     }
385 
386     /**
387      * @dev Returns the subtraction of two unsigned integers, reverting on
388      * overflow (when the result is negative).
389      *
390      * Counterpart to Solidity's `-` operator.
391      *
392      * Requirements:
393      *
394      * - Subtraction cannot overflow.
395      */
396     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
397         require(b <= a, "SafeMath: subtraction overflow");
398         return a - b;
399     }
400 
401     /**
402      * @dev Returns the multiplication of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `*` operator.
406      *
407      * Requirements:
408      *
409      * - Multiplication cannot overflow.
410      */
411     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
412         if (a == 0) return 0;
413         uint256 c = a * b;
414         require(c / a == b, "SafeMath: multiplication overflow");
415         return c;
416     }
417 
418     /**
419      * @dev Returns the integer division of two unsigned integers, reverting on
420      * division by zero. The result is rounded towards zero.
421      *
422      * Counterpart to Solidity's `/` operator. Note: this function uses a
423      * `revert` opcode (which leaves remaining gas untouched) while Solidity
424      * uses an invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
431         require(b > 0, "SafeMath: division by zero");
432         return a / b;
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * reverting when dividing by zero.
438      *
439      * Counterpart to Solidity's `%` operator. This function uses a `revert`
440      * opcode (which leaves remaining gas untouched) while Solidity uses an
441      * invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
448         require(b > 0, "SafeMath: modulo by zero");
449         return a % b;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
454      * overflow (when the result is negative).
455      *
456      * CAUTION: This function is deprecated because it requires allocating memory for the error
457      * message unnecessarily. For custom revert reasons use {trySub}.
458      *
459      * Counterpart to Solidity's `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b <= a, errorMessage);
467         return a - b;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
472      * division by zero. The result is rounded towards zero.
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {tryDiv}.
476      *
477      * Counterpart to Solidity's `/` operator. Note: this function uses a
478      * `revert` opcode (which leaves remaining gas untouched) while Solidity
479      * uses an invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b > 0, errorMessage);
487         return a / b;
488     }
489 
490     /**
491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492      * reverting with custom message when dividing by zero.
493      *
494      * CAUTION: This function is deprecated because it requires allocating memory for the error
495      * message unnecessarily. For custom revert reasons use {tryMod}.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      *
503      * - The divisor cannot be zero.
504      */
505     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b > 0, errorMessage);
507         return a % b;
508     }
509 }
510 
511 
512 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
513 
514 /**
515  * @dev Collection of functions related to the address type
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * [IMPORTANT]
522      * ====
523      * It is unsafe to assume that an address for which this function returns
524      * false is an externally-owned account (EOA) and not a contract.
525      *
526      * Among others, `isContract` will return false for the following
527      * types of addresses:
528      *
529      *  - an externally-owned account
530      *  - a contract in construction
531      *  - an address where a contract will be created
532      *  - an address where a contract lived, but was destroyed
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize, which returns 0 for contracts in
537         // construction, since the code is only stored at the end of the
538         // constructor execution.
539 
540         uint256 size;
541         // solhint-disable-next-line no-inline-assembly
542         assembly { size := extcodesize(account) }
543         return size > 0;
544     }
545 
546     /**
547      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
548      * `recipient`, forwarding all available gas and reverting on errors.
549      *
550      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
551      * of certain opcodes, possibly making contracts go over the 2300 gas limit
552      * imposed by `transfer`, making them unable to receive funds via
553      * `transfer`. {sendValue} removes this limitation.
554      *
555      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
556      *
557      * IMPORTANT: because control is transferred to `recipient`, care must be
558      * taken to not create reentrancy vulnerabilities. Consider using
559      * {ReentrancyGuard} or the
560      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
561      */
562     function sendValue(address payable recipient, uint256 amount) internal {
563         require(address(this).balance >= amount, "Address: insufficient balance");
564 
565         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
566         (bool success, ) = recipient.call{ value: amount }("");
567         require(success, "Address: unable to send value, recipient may have reverted");
568     }
569 
570     /**
571      * @dev Performs a Solidity function call using a low level `call`. A
572      * plain`call` is an unsafe replacement for a function call: use this
573      * function instead.
574      *
575      * If `target` reverts with a revert reason, it is bubbled up by this
576      * function (like regular Solidity function calls).
577      *
578      * Returns the raw returned data. To convert to the expected return value,
579      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
580      *
581      * Requirements:
582      *
583      * - `target` must be a contract.
584      * - calling `target` with `data` must not revert.
585      *
586      * _Available since v3.1._
587      */
588     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
589       return functionCall(target, data, "Address: low-level call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
594      * `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, 0, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but also transferring `value` wei to `target`.
605      *
606      * Requirements:
607      *
608      * - the calling contract must have an ETH balance of at least `value`.
609      * - the called Solidity function must be `payable`.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
619      * with `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
624         require(address(this).balance >= value, "Address: insufficient balance for call");
625         require(isContract(target), "Address: call to non-contract");
626 
627         // solhint-disable-next-line avoid-low-level-calls
628         (bool success, bytes memory returndata) = target.call{ value: value }(data);
629         return _verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
634      * but performing a static call.
635      *
636      * _Available since v3.3._
637      */
638     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
639         return functionStaticCall(target, data, "Address: low-level static call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         // solhint-disable-next-line avoid-low-level-calls
652         (bool success, bytes memory returndata) = target.staticcall(data);
653         return _verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
663         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a delegate call.
669      *
670      * _Available since v3.4._
671      */
672     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
673         require(isContract(target), "Address: delegate call to non-contract");
674 
675         // solhint-disable-next-line avoid-low-level-calls
676         (bool success, bytes memory returndata) = target.delegatecall(data);
677         return _verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 // solhint-disable-next-line no-inline-assembly
689                 assembly {
690                     let returndata_size := mload(returndata)
691                     revert(add(32, returndata), returndata_size)
692                 }
693             } else {
694                 revert(errorMessage);
695             }
696         }
697     }
698 }
699 
700 
701 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.0
702 
703 /**
704  * @dev Library for managing
705  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
706  * types.
707  *
708  * Sets have the following properties:
709  *
710  * - Elements are added, removed, and checked for existence in constant time
711  * (O(1)).
712  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
713  *
714  * ```
715  * contract Example {
716  *     // Add the library methods
717  *     using EnumerableSet for EnumerableSet.AddressSet;
718  *
719  *     // Declare a set state variable
720  *     EnumerableSet.AddressSet private mySet;
721  * }
722  * ```
723  *
724  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
725  * and `uint256` (`UintSet`) are supported.
726  */
727 library EnumerableSet {
728     // To implement this library for multiple types with as little code
729     // repetition as possible, we write it in terms of a generic Set type with
730     // bytes32 values.
731     // The Set implementation uses private functions, and user-facing
732     // implementations (such as AddressSet) are just wrappers around the
733     // underlying Set.
734     // This means that we can only create new EnumerableSets for types that fit
735     // in bytes32.
736 
737     struct Set {
738         // Storage of set values
739         bytes32[] _values;
740 
741         // Position of the value in the `values` array, plus 1 because index 0
742         // means a value is not in the set.
743         mapping (bytes32 => uint256) _indexes;
744     }
745 
746     /**
747      * @dev Add a value to a set. O(1).
748      *
749      * Returns true if the value was added to the set, that is if it was not
750      * already present.
751      */
752     function _add(Set storage set, bytes32 value) private returns (bool) {
753         if (!_contains(set, value)) {
754             set._values.push(value);
755             // The value is stored at length-1, but we add 1 to all indexes
756             // and use 0 as a sentinel value
757             set._indexes[value] = set._values.length;
758             return true;
759         } else {
760             return false;
761         }
762     }
763 
764     /**
765      * @dev Removes a value from a set. O(1).
766      *
767      * Returns true if the value was removed from the set, that is if it was
768      * present.
769      */
770     function _remove(Set storage set, bytes32 value) private returns (bool) {
771         // We read and store the value's index to prevent multiple reads from the same storage slot
772         uint256 valueIndex = set._indexes[value];
773 
774         if (valueIndex != 0) { // Equivalent to contains(set, value)
775             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
776             // the array, and then remove the last element (sometimes called as 'swap and pop').
777             // This modifies the order of the array, as noted in {at}.
778 
779             uint256 toDeleteIndex = valueIndex - 1;
780             uint256 lastIndex = set._values.length - 1;
781 
782             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
783             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
784 
785             bytes32 lastvalue = set._values[lastIndex];
786 
787             // Move the last value to the index where the value to delete is
788             set._values[toDeleteIndex] = lastvalue;
789             // Update the index for the moved value
790             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
791 
792             // Delete the slot where the moved value was stored
793             set._values.pop();
794 
795             // Delete the index for the deleted slot
796             delete set._indexes[value];
797 
798             return true;
799         } else {
800             return false;
801         }
802     }
803 
804     /**
805      * @dev Returns true if the value is in the set. O(1).
806      */
807     function _contains(Set storage set, bytes32 value) private view returns (bool) {
808         return set._indexes[value] != 0;
809     }
810 
811     /**
812      * @dev Returns the number of values on the set. O(1).
813      */
814     function _length(Set storage set) private view returns (uint256) {
815         return set._values.length;
816     }
817 
818    /**
819     * @dev Returns the value stored at position `index` in the set. O(1).
820     *
821     * Note that there are no guarantees on the ordering of values inside the
822     * array, and it may change when more values are added or removed.
823     *
824     * Requirements:
825     *
826     * - `index` must be strictly less than {length}.
827     */
828     function _at(Set storage set, uint256 index) private view returns (bytes32) {
829         require(set._values.length > index, "EnumerableSet: index out of bounds");
830         return set._values[index];
831     }
832 
833     // Bytes32Set
834 
835     struct Bytes32Set {
836         Set _inner;
837     }
838 
839     /**
840      * @dev Add a value to a set. O(1).
841      *
842      * Returns true if the value was added to the set, that is if it was not
843      * already present.
844      */
845     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
846         return _add(set._inner, value);
847     }
848 
849     /**
850      * @dev Removes a value from a set. O(1).
851      *
852      * Returns true if the value was removed from the set, that is if it was
853      * present.
854      */
855     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
856         return _remove(set._inner, value);
857     }
858 
859     /**
860      * @dev Returns true if the value is in the set. O(1).
861      */
862     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
863         return _contains(set._inner, value);
864     }
865 
866     /**
867      * @dev Returns the number of values in the set. O(1).
868      */
869     function length(Bytes32Set storage set) internal view returns (uint256) {
870         return _length(set._inner);
871     }
872 
873    /**
874     * @dev Returns the value stored at position `index` in the set. O(1).
875     *
876     * Note that there are no guarantees on the ordering of values inside the
877     * array, and it may change when more values are added or removed.
878     *
879     * Requirements:
880     *
881     * - `index` must be strictly less than {length}.
882     */
883     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
884         return _at(set._inner, index);
885     }
886 
887     // AddressSet
888 
889     struct AddressSet {
890         Set _inner;
891     }
892 
893     /**
894      * @dev Add a value to a set. O(1).
895      *
896      * Returns true if the value was added to the set, that is if it was not
897      * already present.
898      */
899     function add(AddressSet storage set, address value) internal returns (bool) {
900         return _add(set._inner, bytes32(uint256(uint160(value))));
901     }
902 
903     /**
904      * @dev Removes a value from a set. O(1).
905      *
906      * Returns true if the value was removed from the set, that is if it was
907      * present.
908      */
909     function remove(AddressSet storage set, address value) internal returns (bool) {
910         return _remove(set._inner, bytes32(uint256(uint160(value))));
911     }
912 
913     /**
914      * @dev Returns true if the value is in the set. O(1).
915      */
916     function contains(AddressSet storage set, address value) internal view returns (bool) {
917         return _contains(set._inner, bytes32(uint256(uint160(value))));
918     }
919 
920     /**
921      * @dev Returns the number of values in the set. O(1).
922      */
923     function length(AddressSet storage set) internal view returns (uint256) {
924         return _length(set._inner);
925     }
926 
927    /**
928     * @dev Returns the value stored at position `index` in the set. O(1).
929     *
930     * Note that there are no guarantees on the ordering of values inside the
931     * array, and it may change when more values are added or removed.
932     *
933     * Requirements:
934     *
935     * - `index` must be strictly less than {length}.
936     */
937     function at(AddressSet storage set, uint256 index) internal view returns (address) {
938         return address(uint160(uint256(_at(set._inner, index))));
939     }
940 
941 
942     // UintSet
943 
944     struct UintSet {
945         Set _inner;
946     }
947 
948     /**
949      * @dev Add a value to a set. O(1).
950      *
951      * Returns true if the value was added to the set, that is if it was not
952      * already present.
953      */
954     function add(UintSet storage set, uint256 value) internal returns (bool) {
955         return _add(set._inner, bytes32(value));
956     }
957 
958     /**
959      * @dev Removes a value from a set. O(1).
960      *
961      * Returns true if the value was removed from the set, that is if it was
962      * present.
963      */
964     function remove(UintSet storage set, uint256 value) internal returns (bool) {
965         return _remove(set._inner, bytes32(value));
966     }
967 
968     /**
969      * @dev Returns true if the value is in the set. O(1).
970      */
971     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
972         return _contains(set._inner, bytes32(value));
973     }
974 
975     /**
976      * @dev Returns the number of values on the set. O(1).
977      */
978     function length(UintSet storage set) internal view returns (uint256) {
979         return _length(set._inner);
980     }
981 
982    /**
983     * @dev Returns the value stored at position `index` in the set. O(1).
984     *
985     * Note that there are no guarantees on the ordering of values inside the
986     * array, and it may change when more values are added or removed.
987     *
988     * Requirements:
989     *
990     * - `index` must be strictly less than {length}.
991     */
992     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
993         return uint256(_at(set._inner, index));
994     }
995 }
996 
997 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.0
998 
999 /**
1000  * @dev Library for managing an enumerable variant of Solidity's
1001  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1002  * type.
1003  *
1004  * Maps have the following properties:
1005  *
1006  * - Entries are added, removed, and checked for existence in constant time
1007  * (O(1)).
1008  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1009  *
1010  * ```
1011  * contract Example {
1012  *     // Add the library methods
1013  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1014  *
1015  *     // Declare a set state variable
1016  *     EnumerableMap.UintToAddressMap private myMap;
1017  * }
1018  * ```
1019  *
1020  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1021  * supported.
1022  */
1023 library EnumerableMap {
1024     // To implement this library for multiple types with as little code
1025     // repetition as possible, we write it in terms of a generic Map type with
1026     // bytes32 keys and values.
1027     // The Map implementation uses private functions, and user-facing
1028     // implementations (such as Uint256ToAddressMap) are just wrappers around
1029     // the underlying Map.
1030     // This means that we can only create new EnumerableMaps for types that fit
1031     // in bytes32.
1032 
1033     struct MapEntry {
1034         bytes32 _key;
1035         bytes32 _value;
1036     }
1037 
1038     struct Map {
1039         // Storage of map keys and values
1040         MapEntry[] _entries;
1041 
1042         // Position of the entry defined by a key in the `entries` array, plus 1
1043         // because index 0 means a key is not in the map.
1044         mapping (bytes32 => uint256) _indexes;
1045     }
1046 
1047     /**
1048      * @dev Adds a key-value pair to a map, or updates the value for an existing
1049      * key. O(1).
1050      *
1051      * Returns true if the key was added to the map, that is if it was not
1052      * already present.
1053      */
1054     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1055         // We read and store the key's index to prevent multiple reads from the same storage slot
1056         uint256 keyIndex = map._indexes[key];
1057 
1058         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1059             map._entries.push(MapEntry({ _key: key, _value: value }));
1060             // The entry is stored at length-1, but we add 1 to all indexes
1061             // and use 0 as a sentinel value
1062             map._indexes[key] = map._entries.length;
1063             return true;
1064         } else {
1065             map._entries[keyIndex - 1]._value = value;
1066             return false;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Removes a key-value pair from a map. O(1).
1072      *
1073      * Returns true if the key was removed from the map, that is if it was present.
1074      */
1075     function _remove(Map storage map, bytes32 key) private returns (bool) {
1076         // We read and store the key's index to prevent multiple reads from the same storage slot
1077         uint256 keyIndex = map._indexes[key];
1078 
1079         if (keyIndex != 0) { // Equivalent to contains(map, key)
1080             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1081             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1082             // This modifies the order of the array, as noted in {at}.
1083 
1084             uint256 toDeleteIndex = keyIndex - 1;
1085             uint256 lastIndex = map._entries.length - 1;
1086 
1087             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1088             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1089 
1090             MapEntry storage lastEntry = map._entries[lastIndex];
1091 
1092             // Move the last entry to the index where the entry to delete is
1093             map._entries[toDeleteIndex] = lastEntry;
1094             // Update the index for the moved entry
1095             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1096 
1097             // Delete the slot where the moved entry was stored
1098             map._entries.pop();
1099 
1100             // Delete the index for the deleted slot
1101             delete map._indexes[key];
1102 
1103             return true;
1104         } else {
1105             return false;
1106         }
1107     }
1108 
1109     /**
1110      * @dev Returns true if the key is in the map. O(1).
1111      */
1112     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1113         return map._indexes[key] != 0;
1114     }
1115 
1116     /**
1117      * @dev Returns the number of key-value pairs in the map. O(1).
1118      */
1119     function _length(Map storage map) private view returns (uint256) {
1120         return map._entries.length;
1121     }
1122 
1123    /**
1124     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1125     *
1126     * Note that there are no guarantees on the ordering of entries inside the
1127     * array, and it may change when more entries are added or removed.
1128     *
1129     * Requirements:
1130     *
1131     * - `index` must be strictly less than {length}.
1132     */
1133     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1134         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1135 
1136         MapEntry storage entry = map._entries[index];
1137         return (entry._key, entry._value);
1138     }
1139 
1140     /**
1141      * @dev Tries to returns the value associated with `key`.  O(1).
1142      * Does not revert if `key` is not in the map.
1143      */
1144     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1145         uint256 keyIndex = map._indexes[key];
1146         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1147         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1148     }
1149 
1150     /**
1151      * @dev Returns the value associated with `key`.  O(1).
1152      *
1153      * Requirements:
1154      *
1155      * - `key` must be in the map.
1156      */
1157     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1158         uint256 keyIndex = map._indexes[key];
1159         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1160         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1161     }
1162 
1163     /**
1164      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1165      *
1166      * CAUTION: This function is deprecated because it requires allocating memory for the error
1167      * message unnecessarily. For custom revert reasons use {_tryGet}.
1168      */
1169     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1170         uint256 keyIndex = map._indexes[key];
1171         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1172         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1173     }
1174 
1175     // UintToAddressMap
1176 
1177     struct UintToAddressMap {
1178         Map _inner;
1179     }
1180 
1181     /**
1182      * @dev Adds a key-value pair to a map, or updates the value for an existing
1183      * key. O(1).
1184      *
1185      * Returns true if the key was added to the map, that is if it was not
1186      * already present.
1187      */
1188     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1189         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1190     }
1191 
1192     /**
1193      * @dev Removes a value from a set. O(1).
1194      *
1195      * Returns true if the key was removed from the map, that is if it was present.
1196      */
1197     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1198         return _remove(map._inner, bytes32(key));
1199     }
1200 
1201     /**
1202      * @dev Returns true if the key is in the map. O(1).
1203      */
1204     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1205         return _contains(map._inner, bytes32(key));
1206     }
1207 
1208     /**
1209      * @dev Returns the number of elements in the map. O(1).
1210      */
1211     function length(UintToAddressMap storage map) internal view returns (uint256) {
1212         return _length(map._inner);
1213     }
1214 
1215    /**
1216     * @dev Returns the element stored at position `index` in the set. O(1).
1217     * Note that there are no guarantees on the ordering of values inside the
1218     * array, and it may change when more values are added or removed.
1219     *
1220     * Requirements:
1221     *
1222     * - `index` must be strictly less than {length}.
1223     */
1224     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1225         (bytes32 key, bytes32 value) = _at(map._inner, index);
1226         return (uint256(key), address(uint160(uint256(value))));
1227     }
1228 
1229     /**
1230      * @dev Tries to returns the value associated with `key`.  O(1).
1231      * Does not revert if `key` is not in the map.
1232      *
1233      * _Available since v3.4._
1234      */
1235     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1236         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1237         return (success, address(uint160(uint256(value))));
1238     }
1239 
1240     /**
1241      * @dev Returns the value associated with `key`.  O(1).
1242      *
1243      * Requirements:
1244      *
1245      * - `key` must be in the map.
1246      */
1247     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1248         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1249     }
1250 
1251     /**
1252      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1253      *
1254      * CAUTION: This function is deprecated because it requires allocating memory for the error
1255      * message unnecessarily. For custom revert reasons use {tryGet}.
1256      */
1257     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1258         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1259     }
1260 }
1261 
1262 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.0
1263 
1264 /**
1265  * @dev String operations.
1266  */
1267 library Strings {
1268     /**
1269      * @dev Converts a `uint256` to its ASCII `string` representation.
1270      */
1271     function toString(uint256 value) internal pure returns (string memory) {
1272         // Inspired by OraclizeAPI's implementation - MIT licence
1273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1274 
1275         if (value == 0) {
1276             return "0";
1277         }
1278         uint256 temp = value;
1279         uint256 digits;
1280         while (temp != 0) {
1281             digits++;
1282             temp /= 10;
1283         }
1284         bytes memory buffer = new bytes(digits);
1285         uint256 index = digits - 1;
1286         temp = value;
1287         while (temp != 0) {
1288             buffer[index--] = bytes1(uint8(48 + temp % 10));
1289             temp /= 10;
1290         }
1291         return string(buffer);
1292     }
1293 }
1294 
1295 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.0
1296 
1297 /**
1298  * @title ERC721 Non-Fungible Token Standard basic implementation
1299  * @dev see https://eips.ethereum.org/EIPS/eip-721
1300  */
1301 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1302     using SafeMath for uint256;
1303     using Address for address;
1304     using EnumerableSet for EnumerableSet.UintSet;
1305     using EnumerableMap for EnumerableMap.UintToAddressMap;
1306     using Strings for uint256;
1307 
1308     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1309     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1310     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1311 
1312     // Mapping from holder address to their (enumerable) set of owned tokens
1313     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1314 
1315     // Enumerable mapping from token ids to their owners
1316     EnumerableMap.UintToAddressMap private _tokenOwners;
1317 
1318     // Mapping from token ID to approved address
1319     mapping (uint256 => address) private _tokenApprovals;
1320 
1321     // Mapping from owner to operator approvals
1322     mapping (address => mapping (address => bool)) private _operatorApprovals;
1323 
1324     // Token name
1325     string private _name;
1326 
1327     // Token symbol
1328     string private _symbol;
1329 
1330     // Optional mapping for token URIs
1331     mapping (uint256 => string) private _tokenURIs;
1332 
1333     // Base URI
1334     string private _baseURI;
1335 
1336     /*
1337      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1338      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1339      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1340      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1341      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1342      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1343      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1344      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1345      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1346      *
1347      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1348      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1349      */
1350     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1351 
1352     /*
1353      *     bytes4(keccak256('name()')) == 0x06fdde03
1354      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1355      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1356      *
1357      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1358      */
1359     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1360 
1361     /*
1362      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1363      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1364      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1365      *
1366      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1367      */
1368     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1369 
1370     /**
1371      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1372      */
1373     constructor (string memory name_, string memory symbol_) public {
1374         _name = name_;
1375         _symbol = symbol_;
1376 
1377         // register the supported interfaces to conform to ERC721 via ERC165
1378         _registerInterface(_INTERFACE_ID_ERC721);
1379         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1380         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-balanceOf}.
1385      */
1386     function balanceOf(address owner) public view virtual override returns (uint256) {
1387         require(owner != address(0), "ERC721: balance query for the zero address");
1388         return _holderTokens[owner].length();
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-ownerOf}.
1393      */
1394     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1395         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1396     }
1397 
1398     /**
1399      * @dev See {IERC721Metadata-name}.
1400      */
1401     function name() public view virtual override returns (string memory) {
1402         return _name;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Metadata-symbol}.
1407      */
1408     function symbol() public view virtual override returns (string memory) {
1409         return _symbol;
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Metadata-tokenURI}.
1414      */
1415     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1416         string memory _tokenURI = _tokenURIs[tokenId];
1417         string memory base = baseURI();
1418 
1419         // If there is no base URI, return the token URI.
1420         if (bytes(base).length == 0) {
1421             return _tokenURI;
1422         }
1423         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1424         if (bytes(_tokenURI).length > 0) {
1425             return string(abi.encodePacked(base, _tokenURI));
1426         }
1427         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1428         return string(abi.encodePacked(base, tokenId.toString()));
1429     }
1430 
1431     /**
1432     * @dev Returns the base URI set via {_setBaseURI}. This will be
1433     * automatically added as a prefix in {tokenURI} to each token's URI, or
1434     * to the token ID if no specific URI is set for that token ID.
1435     */
1436     function baseURI() public view virtual returns (string memory) {
1437         return _baseURI;
1438     }
1439 
1440     /**
1441      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1442      */
1443     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1444         return _holderTokens[owner].at(index);
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Enumerable-totalSupply}.
1449      */
1450     function totalSupply() public view virtual override returns (uint256) {
1451         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1452         return _tokenOwners.length();
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Enumerable-tokenByIndex}.
1457      */
1458     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1459         (uint256 tokenId, ) = _tokenOwners.at(index);
1460         return tokenId;
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-approve}.
1465      */
1466     function approve(address to, uint256 tokenId) public virtual override {
1467         address owner = ERC721.ownerOf(tokenId);
1468         require(to != owner, "ERC721: approval to current owner");
1469 
1470         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1471             "ERC721: approve caller is not owner nor approved for all"
1472         );
1473 
1474         _approve(to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev See {IERC721-getApproved}.
1479      */
1480     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1481         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1482 
1483         return _tokenApprovals[tokenId];
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-setApprovalForAll}.
1488      */
1489     function setApprovalForAll(address operator, bool approved) public virtual override {
1490         require(operator != _msgSender(), "ERC721: approve to caller");
1491 
1492         _operatorApprovals[_msgSender()][operator] = approved;
1493         emit ApprovalForAll(_msgSender(), operator, approved);
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-isApprovedForAll}.
1498      */
1499     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1500         return _operatorApprovals[owner][operator];
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-transferFrom}.
1505      */
1506     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1507         //solhint-disable-next-line max-line-length
1508         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1509 
1510         _transfer(from, to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-safeTransferFrom}.
1515      */
1516     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1517         safeTransferFrom(from, to, tokenId, "");
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-safeTransferFrom}.
1522      */
1523     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1524         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1525         _safeTransfer(from, to, tokenId, _data);
1526     }
1527 
1528     /**
1529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1531      *
1532      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1533      *
1534      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1535      * implement alternative mechanisms to perform token transfer, such as signature-based.
1536      *
1537      * Requirements:
1538      *
1539      * - `from` cannot be the zero address.
1540      * - `to` cannot be the zero address.
1541      * - `tokenId` token must exist and be owned by `from`.
1542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1547         _transfer(from, to, tokenId);
1548         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1549     }
1550 
1551     /**
1552      * @dev Returns whether `tokenId` exists.
1553      *
1554      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1555      *
1556      * Tokens start existing when they are minted (`_mint`),
1557      * and stop existing when they are burned (`_burn`).
1558      */
1559     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1560         return _tokenOwners.contains(tokenId);
1561     }
1562 
1563     /**
1564      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1565      *
1566      * Requirements:
1567      *
1568      * - `tokenId` must exist.
1569      */
1570     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1571         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1572         address owner = ERC721.ownerOf(tokenId);
1573         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1574     }
1575 
1576     /**
1577      * @dev Safely mints `tokenId` and transfers it to `to`.
1578      *
1579      * Requirements:
1580      d*
1581      * - `tokenId` must not exist.
1582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1583      *
1584      * Emits a {Transfer} event.
1585      */
1586     function _safeMint(address to, uint256 tokenId) internal virtual {
1587         _safeMint(to, tokenId, "");
1588     }
1589 
1590     /**
1591      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1592      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1593      */
1594     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1595         _mint(to, tokenId);
1596         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1597     }
1598 
1599     /**
1600      * @dev Mints `tokenId` and transfers it to `to`.
1601      *
1602      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1603      *
1604      * Requirements:
1605      *
1606      * - `tokenId` must not exist.
1607      * - `to` cannot be the zero address.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _mint(address to, uint256 tokenId) internal virtual {
1612         require(to != address(0), "ERC721: mint to the zero address");
1613         require(!_exists(tokenId), "ERC721: token already minted");
1614 
1615         _beforeTokenTransfer(address(0), to, tokenId);
1616 
1617         _holderTokens[to].add(tokenId);
1618 
1619         _tokenOwners.set(tokenId, to);
1620 
1621         emit Transfer(address(0), to, tokenId);
1622     }
1623 
1624     /**
1625      * @dev Destroys `tokenId`.
1626      * The approval is cleared when the token is burned.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      *
1632      * Emits a {Transfer} event.
1633      */
1634     function _burn(uint256 tokenId) internal virtual {
1635         address owner = ERC721.ownerOf(tokenId); // internal owner
1636 
1637         _beforeTokenTransfer(owner, address(0), tokenId);
1638 
1639         // Clear approvals
1640         _approve(address(0), tokenId);
1641 
1642         // Clear metadata (if any)
1643         if (bytes(_tokenURIs[tokenId]).length != 0) {
1644             delete _tokenURIs[tokenId];
1645         }
1646 
1647         _holderTokens[owner].remove(tokenId);
1648 
1649         _tokenOwners.remove(tokenId);
1650 
1651         emit Transfer(owner, address(0), tokenId);
1652     }
1653 
1654     /**
1655      * @dev Transfers `tokenId` from `from` to `to`.
1656      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1657      *
1658      * Requirements:
1659      *
1660      * - `to` cannot be the zero address.
1661      * - `tokenId` token must be owned by `from`.
1662      *
1663      * Emits a {Transfer} event.
1664      */
1665     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1666         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1667         require(to != address(0), "ERC721: transfer to the zero address");
1668 
1669         _beforeTokenTransfer(from, to, tokenId);
1670 
1671         // Clear approvals from the previous owner
1672         _approve(address(0), tokenId);
1673 
1674         _holderTokens[from].remove(tokenId);
1675         _holderTokens[to].add(tokenId);
1676 
1677         _tokenOwners.set(tokenId, to);
1678 
1679         emit Transfer(from, to, tokenId);
1680     }
1681 
1682     /**
1683      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must exist.
1688      */
1689     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1690         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1691         _tokenURIs[tokenId] = _tokenURI;
1692     }
1693 
1694     /**
1695      * @dev Internal function to set the base URI for all token IDs. It is
1696      * automatically added as a prefix to the value returned in {tokenURI},
1697      * or to the token ID if {tokenURI} is empty.
1698      */
1699     function _setBaseURI(string memory baseURI_) internal virtual {
1700         _baseURI = baseURI_;
1701     }
1702 
1703     /**
1704      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1705      * The call is not executed if the target address is not a contract.
1706      *
1707      * @param from address representing the previous owner of the given token ID
1708      * @param to target address that will receive the tokens
1709      * @param tokenId uint256 ID of the token to be transferred
1710      * @param _data bytes optional data to send along with the call
1711      * @return bool whether the call correctly returned the expected magic value
1712      */
1713     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1714         private returns (bool)
1715     {
1716         if (!to.isContract()) {
1717             return true;
1718         }
1719         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1720             IERC721Receiver(to).onERC721Received.selector,
1721             _msgSender(),
1722             from,
1723             tokenId,
1724             _data
1725         ), "ERC721: transfer to non ERC721Receiver implementer");
1726         bytes4 retval = abi.decode(returndata, (bytes4));
1727         return (retval == _ERC721_RECEIVED);
1728     }
1729 
1730     function _approve(address to, uint256 tokenId) private {
1731         _tokenApprovals[tokenId] = to;
1732         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1733     }
1734 
1735     /**
1736      * @dev Hook that is called before any token transfer. This includes minting
1737      * and burning.
1738      *
1739      * Calling conditions:
1740      *
1741      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1742      * transferred to `to`.
1743      * - When `from` is zero, `tokenId` will be minted for `to`.
1744      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1745      * - `from` cannot be the zero address.
1746      * - `to` cannot be the zero address.
1747      *
1748      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1749      */
1750     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1751 }
1752 
1753 // File @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol@v3.4.0
1754 
1755 /**
1756  * @title ERC721 Burnable Token
1757  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1758  */
1759 abstract contract ERC721Burnable is Context, ERC721 {
1760     /**
1761      * @dev Burns `tokenId`. See {ERC721-_burn}.
1762      *
1763      * Requirements:
1764      *
1765      * - The caller must own `tokenId` or be an approved operator.
1766      */
1767     function burn(uint256 tokenId) public virtual {
1768         //solhint-disable-next-line max-line-length
1769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1770         _burn(tokenId);
1771     }
1772 }
1773 
1774 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
1775 
1776 /**
1777  * @dev Contract module which provides a basic access control mechanism, where
1778  * there is an account (an owner) that can be granted exclusive access to
1779  * specific functions.
1780  *
1781  * By default, the owner account will be the one that deploys the contract. This
1782  * can later be changed with {transferOwnership}.
1783  *
1784  * This module is used through inheritance. It will make available the modifier
1785  * `onlyOwner`, which can be applied to your functions to restrict their use to
1786  * the owner.
1787  */
1788 abstract contract Ownable is Context {
1789     address private _owner;
1790 
1791     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1792 
1793     /**
1794      * @dev Initializes the contract setting the deployer as the initial owner.
1795      */
1796     constructor () internal {
1797         address msgSender = _msgSender();
1798         _owner = msgSender;
1799         emit OwnershipTransferred(address(0), msgSender);
1800     }
1801 
1802     /**
1803      * @dev Returns the address of the current owner.
1804      */
1805     function owner() public view virtual returns (address) {
1806         return _owner;
1807     }
1808 
1809     /**
1810      * @dev Throws if called by any account other than the owner.
1811      */
1812     modifier onlyOwner() {
1813         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1814         _;
1815     }
1816 
1817     /**
1818      * @dev Leaves the contract without owner. It will not be possible to call
1819      * `onlyOwner` functions anymore. Can only be called by the current owner.
1820      *
1821      * NOTE: Renouncing ownership will leave the contract without an owner,
1822      * thereby removing any functionality that is only available to the owner.
1823      */
1824     function renounceOwnership() public virtual onlyOwner {
1825         emit OwnershipTransferred(_owner, address(0));
1826         _owner = address(0);
1827     }
1828 
1829     /**
1830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1831      * Can only be called by the current owner.
1832      */
1833     function transferOwnership(address newOwner) public virtual onlyOwner {
1834         require(newOwner != address(0), "Ownable: new owner is the zero address");
1835         emit OwnershipTransferred(_owner, newOwner);
1836         _owner = newOwner;
1837     }
1838 }
1839 
1840 // File contracts/Regenz.sol
1841 
1842 contract Regenz is ERC721Burnable, Ownable {
1843 
1844   uint256 constant public PRICE = 0.033 ether;
1845   uint256 constant public TOTAL_SUPPLY = 10000;
1846   uint256 constant public REVEAL_TIMESTAMP = 0;
1847   uint256 constant public MAX_PER_TX = 30;
1848   uint256 constant public NUM_TO_RESERVE = 250;
1849 
1850   uint256 public startingIndex;
1851   uint256 public startingIndexBlock;
1852 
1853   string constant public METADATA_HASH = "";
1854   
1855   address payable claimEthAddress;
1856 
1857   bool private saleIsActive;
1858 
1859   struct RegenzBought {
1860       address wallet;
1861       uint[] regenz;
1862   }
1863   mapping (address => RegenzBought) regenzBought;
1864 
1865   constructor(address payable _claimEthAddress) public ERC721("Regenz", "REGENZ") {
1866       claimEthAddress = _claimEthAddress;
1867   }
1868 
1869   function reserveRegenz() public onlyOwner {
1870       uint supply = totalSupply();
1871       uint i;
1872       for (i = 0; i < NUM_TO_RESERVE; i++) {
1873           _safeMint(msg.sender, supply + i);
1874       }
1875   }
1876 
1877   function setBaseURI(string memory baseURI) public onlyOwner {
1878     _setBaseURI(baseURI);
1879   }
1880 
1881   /*
1882   * Pause sale if active, make active if paused
1883   */
1884   function flipSaleState() public onlyOwner {
1885       saleIsActive = !saleIsActive;
1886   }
1887 
1888   /**
1889   * Mints Regenz
1890   */
1891   function mintRegenz(uint numberOfTokens) public payable {
1892       require(saleIsActive, "Sale must be active to mint");
1893       require(numberOfTokens <= MAX_PER_TX, "Above max tx count");
1894       require(totalSupply().add(numberOfTokens) <= TOTAL_SUPPLY, "Exceeds max supply");
1895       require(PRICE.mul(numberOfTokens) <= msg.value, "ETH sent is incorrect");
1896       for(uint i = 0; i < numberOfTokens; i++) {
1897           uint mintIndex = totalSupply();
1898           _safeMint(msg.sender, mintIndex);
1899 
1900           regenzBought[msg.sender].regenz.push(mintIndex);
1901           regenzBought[msg.sender].wallet = msg.sender;
1902       }
1903         
1904 
1905       // If we haven't set the starting index and this is either
1906       // 1) the last saleable token or
1907       // 2) the first token to be sold after the end of pre-sale, set the starting index block
1908       if (startingIndexBlock == 0 && (totalSupply() == TOTAL_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
1909           startingIndexBlock = block.number;
1910       }
1911   }
1912 
1913   function getMintedRegenz(address wallet) public view returns (uint [] memory) {
1914        return regenzBought[wallet].regenz;
1915   }
1916 
1917   
1918     /**
1919     * Set the starting index for the collection
1920     */
1921     function setStartingIndex() public {
1922         require(startingIndex == 0, "Starting index is already set");
1923         require(startingIndexBlock != 0, "Starting index block must be set");
1924         startingIndex = uint(blockhash(startingIndexBlock)) % TOTAL_SUPPLY;
1925         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1926         if (block.number.sub(startingIndexBlock) > 255) {
1927             startingIndex = uint(blockhash(block.number - 1)) % TOTAL_SUPPLY;
1928         }
1929     }
1930 
1931     function claimETH() public {
1932         require(claimEthAddress == _msgSender(), "Ownable: caller is not the claimEthAddress");
1933         payable(address(claimEthAddress)).transfer(address(this).balance);
1934     }
1935 
1936     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1937         if (startingIndex == 0) {
1938         return super.tokenURI(0);
1939         }
1940         uint256 moddedId = (tokenId + startingIndex) % TOTAL_SUPPLY;
1941         return super.tokenURI(moddedId);
1942     }
1943 }