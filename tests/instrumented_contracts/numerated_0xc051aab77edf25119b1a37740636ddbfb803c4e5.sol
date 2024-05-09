1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-02
3 */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity ^0.6.8;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 
53 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(address from, address to, uint256 tokenId) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address from, address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122      * The approval is cleared when the token is transferred.
123      *
124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125      *
126      * Requirements:
127      *
128      * - The caller must own the token or be an approved operator.
129      * - `tokenId` must exist.
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Returns the account approved for `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function getApproved(uint256 tokenId) external view returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator) external view returns (bool);
162 
163     /**
164       * @dev Safely transfers `tokenId` token from `from` to `to`.
165       *
166       * Requirements:
167       *
168       * - `from` cannot be the zero address.
169       * - `to` cannot be the zero address.
170       * - `tokenId` token must exist and be owned by `from`.
171       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173       *
174       * Emits a {Transfer} event.
175       */
176     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
177 }
178 
179 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.0
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Metadata is IERC721 {
186 
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.0
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Enumerable is IERC721 {
210 
211     /**
212      * @dev Returns the total amount of tokens stored by the contract.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
218      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
219      */
220     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
221 
222     /**
223      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
224      * Use along with {totalSupply} to enumerate all tokens.
225      */
226     function tokenByIndex(uint256 index) external view returns (uint256);
227 }
228 
229 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.0
230 
231 /**
232  * @title ERC721 token receiver interface
233  * @dev Interface for any contract that wants to support safeTransfers
234  * from ERC721 asset contracts.
235  */
236 interface IERC721Receiver {
237     /**
238      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
239      * by `operator` from `from`, this function is called.
240      *
241      * It must return its Solidity selector to confirm the token transfer.
242      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
243      *
244      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
245      */
246     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
247 }
248 
249 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.0
250 
251 /**
252  * @dev Implementation of the {IERC165} interface.
253  *
254  * Contracts may inherit from this and call {_registerInterface} to declare
255  * their support of an interface.
256  */
257 abstract contract ERC165 is IERC165 {
258     /*
259      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
260      */
261     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
262 
263     /**
264      * @dev Mapping of interface ids to whether or not it's supported.
265      */
266     mapping(bytes4 => bool) private _supportedInterfaces;
267 
268     constructor () internal {
269         // Derived contracts need only register support for their own interfaces,
270         // we register support for ERC165 itself here
271         _registerInterface(_INTERFACE_ID_ERC165);
272     }
273 
274     /**
275      * @dev See {IERC165-supportsInterface}.
276      *
277      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
278      */
279     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
280         return _supportedInterfaces[interfaceId];
281     }
282 
283     /**
284      * @dev Registers the contract as an implementer of the interface defined by
285      * `interfaceId`. Support of the actual ERC165 interface is automatic and
286      * registering its interface id is not required.
287      *
288      * See {IERC165-supportsInterface}.
289      *
290      * Requirements:
291      *
292      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
293      */
294     function _registerInterface(bytes4 interfaceId) internal virtual {
295         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
296         _supportedInterfaces[interfaceId] = true;
297     }
298 }
299 
300 
301 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
302 
303 /**
304  * @dev Wrappers over Solidity's arithmetic operations with added overflow
305  * checks.
306  *
307  * Arithmetic operations in Solidity wrap on overflow. This can easily result
308  * in bugs, because programmers usually assume that an overflow raises an
309  * error, which is the standard behavior in high level programming languages.
310  * `SafeMath` restores this intuition by reverting the transaction when an
311  * operation overflows.
312  *
313  * Using this library instead of the unchecked operations eliminates an entire
314  * class of bugs, so it's recommended to use it always.
315  */
316 library SafeMath {
317     /**
318      * @dev Returns the addition of two unsigned integers, with an overflow flag.
319      *
320      * _Available since v3.4._
321      */
322     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
323         uint256 c = a + b;
324         if (c < a) return (false, 0);
325         return (true, c);
326     }
327 
328     /**
329      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
330      *
331      * _Available since v3.4._
332      */
333     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
334         if (b > a) return (false, 0);
335         return (true, a - b);
336     }
337 
338     /**
339      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
345         // benefit is lost if 'b' is also tested.
346         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
347         if (a == 0) return (true, 0);
348         uint256 c = a * b;
349         if (c / a != b) return (false, 0);
350         return (true, c);
351     }
352 
353     /**
354      * @dev Returns the division of two unsigned integers, with a division by zero flag.
355      *
356      * _Available since v3.4._
357      */
358     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         if (b == 0) return (false, 0);
360         return (true, a / b);
361     }
362 
363     /**
364      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         if (b == 0) return (false, 0);
370         return (true, a % b);
371     }
372 
373     /**
374      * @dev Returns the addition of two unsigned integers, reverting on
375      * overflow.
376      *
377      * Counterpart to Solidity's `+` operator.
378      *
379      * Requirements:
380      *
381      * - Addition cannot overflow.
382      */
383     function add(uint256 a, uint256 b) internal pure returns (uint256) {
384         uint256 c = a + b;
385         require(c >= a, "SafeMath: addition overflow");
386         return c;
387     }
388 
389     /**
390      * @dev Returns the subtraction of two unsigned integers, reverting on
391      * overflow (when the result is negative).
392      *
393      * Counterpart to Solidity's `-` operator.
394      *
395      * Requirements:
396      *
397      * - Subtraction cannot overflow.
398      */
399     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
400         require(b <= a, "SafeMath: subtraction overflow");
401         return a - b;
402     }
403 
404     /**
405      * @dev Returns the multiplication of two unsigned integers, reverting on
406      * overflow.
407      *
408      * Counterpart to Solidity's `*` operator.
409      *
410      * Requirements:
411      *
412      * - Multiplication cannot overflow.
413      */
414     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
415         if (a == 0) return 0;
416         uint256 c = a * b;
417         require(c / a == b, "SafeMath: multiplication overflow");
418         return c;
419     }
420 
421     /**
422      * @dev Returns the integer division of two unsigned integers, reverting on
423      * division by zero. The result is rounded towards zero.
424      *
425      * Counterpart to Solidity's `/` operator. Note: this function uses a
426      * `revert` opcode (which leaves remaining gas untouched) while Solidity
427      * uses an invalid opcode to revert (consuming all remaining gas).
428      *
429      * Requirements:
430      *
431      * - The divisor cannot be zero.
432      */
433     function div(uint256 a, uint256 b) internal pure returns (uint256) {
434         require(b > 0, "SafeMath: division by zero");
435         return a / b;
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * reverting when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
451         require(b > 0, "SafeMath: modulo by zero");
452         return a % b;
453     }
454 
455     /**
456      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
457      * overflow (when the result is negative).
458      *
459      * CAUTION: This function is deprecated because it requires allocating memory for the error
460      * message unnecessarily. For custom revert reasons use {trySub}.
461      *
462      * Counterpart to Solidity's `-` operator.
463      *
464      * Requirements:
465      *
466      * - Subtraction cannot overflow.
467      */
468     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
469         require(b <= a, errorMessage);
470         return a - b;
471     }
472 
473     /**
474      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
475      * division by zero. The result is rounded towards zero.
476      *
477      * CAUTION: This function is deprecated because it requires allocating memory for the error
478      * message unnecessarily. For custom revert reasons use {tryDiv}.
479      *
480      * Counterpart to Solidity's `/` operator. Note: this function uses a
481      * `revert` opcode (which leaves remaining gas untouched) while Solidity
482      * uses an invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
489         require(b > 0, errorMessage);
490         return a / b;
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
495      * reverting with custom message when dividing by zero.
496      *
497      * CAUTION: This function is deprecated because it requires allocating memory for the error
498      * message unnecessarily. For custom revert reasons use {tryMod}.
499      *
500      * Counterpart to Solidity's `%` operator. This function uses a `revert`
501      * opcode (which leaves remaining gas untouched) while Solidity uses an
502      * invalid opcode to revert (consuming all remaining gas).
503      *
504      * Requirements:
505      *
506      * - The divisor cannot be zero.
507      */
508     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b > 0, errorMessage);
510         return a % b;
511     }
512 }
513 
514 
515 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
516 
517 /**
518  * @dev Collection of functions related to the address type
519  */
520 library Address {
521     /**
522      * @dev Returns true if `account` is a contract.
523      *
524      * [IMPORTANT]
525      * ====
526      * It is unsafe to assume that an address for which this function returns
527      * false is an externally-owned account (EOA) and not a contract.
528      *
529      * Among others, `isContract` will return false for the following
530      * types of addresses:
531      *
532      *  - an externally-owned account
533      *  - a contract in construction
534      *  - an address where a contract will be created
535      *  - an address where a contract lived, but was destroyed
536      * ====
537      */
538     function isContract(address account) internal view returns (bool) {
539         // This method relies on extcodesize, which returns 0 for contracts in
540         // construction, since the code is only stored at the end of the
541         // constructor execution.
542 
543         uint256 size;
544         // solhint-disable-next-line no-inline-assembly
545         assembly { size := extcodesize(account) }
546         return size > 0;
547     }
548 
549     /**
550      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
551      * `recipient`, forwarding all available gas and reverting on errors.
552      *
553      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
554      * of certain opcodes, possibly making contracts go over the 2300 gas limit
555      * imposed by `transfer`, making them unable to receive funds via
556      * `transfer`. {sendValue} removes this limitation.
557      *
558      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
559      *
560      * IMPORTANT: because control is transferred to `recipient`, care must be
561      * taken to not create reentrancy vulnerabilities. Consider using
562      * {ReentrancyGuard} or the
563      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
564      */
565     function sendValue(address payable recipient, uint256 amount) internal {
566         require(address(this).balance >= amount, "Address: insufficient balance");
567 
568         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
569         (bool success, ) = recipient.call{ value: amount }("");
570         require(success, "Address: unable to send value, recipient may have reverted");
571     }
572 
573     /**
574      * @dev Performs a Solidity function call using a low level `call`. A
575      * plain`call` is an unsafe replacement for a function call: use this
576      * function instead.
577      *
578      * If `target` reverts with a revert reason, it is bubbled up by this
579      * function (like regular Solidity function calls).
580      *
581      * Returns the raw returned data. To convert to the expected return value,
582      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
583      *
584      * Requirements:
585      *
586      * - `target` must be a contract.
587      * - calling `target` with `data` must not revert.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
592       return functionCall(target, data, "Address: low-level call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
597      * `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, 0, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but also transferring `value` wei to `target`.
608      *
609      * Requirements:
610      *
611      * - the calling contract must have an ETH balance of at least `value`.
612      * - the called Solidity function must be `payable`.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
617         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
622      * with `errorMessage` as a fallback revert reason when `target` reverts.
623      *
624      * _Available since v3.1._
625      */
626     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
627         require(address(this).balance >= value, "Address: insufficient balance for call");
628         require(isContract(target), "Address: call to non-contract");
629 
630         // solhint-disable-next-line avoid-low-level-calls
631         (bool success, bytes memory returndata) = target.call{ value: value }(data);
632         return _verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a static call.
638      *
639      * _Available since v3.3._
640      */
641     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
642         return functionStaticCall(target, data, "Address: low-level static call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a static call.
648      *
649      * _Available since v3.3._
650      */
651     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
652         require(isContract(target), "Address: static call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.staticcall(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
666         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
676         require(isContract(target), "Address: delegate call to non-contract");
677 
678         // solhint-disable-next-line avoid-low-level-calls
679         (bool success, bytes memory returndata) = target.delegatecall(data);
680         return _verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
684         if (success) {
685             return returndata;
686         } else {
687             // Look for revert reason and bubble it up if present
688             if (returndata.length > 0) {
689                 // The easiest way to bubble the revert reason is using memory via assembly
690 
691                 // solhint-disable-next-line no-inline-assembly
692                 assembly {
693                     let returndata_size := mload(returndata)
694                     revert(add(32, returndata), returndata_size)
695                 }
696             } else {
697                 revert(errorMessage);
698             }
699         }
700     }
701 }
702 
703 
704 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.0
705 
706 /**
707  * @dev Library for managing
708  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
709  * types.
710  *
711  * Sets have the following properties:
712  *
713  * - Elements are added, removed, and checked for existence in constant time
714  * (O(1)).
715  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
716  *
717  * ```
718  * contract Example {
719  *     // Add the library methods
720  *     using EnumerableSet for EnumerableSet.AddressSet;
721  *
722  *     // Declare a set state variable
723  *     EnumerableSet.AddressSet private mySet;
724  * }
725  * ```
726  *
727  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
728  * and `uint256` (`UintSet`) are supported.
729  */
730 library EnumerableSet {
731     // To implement this library for multiple types with as little code
732     // repetition as possible, we write it in terms of a generic Set type with
733     // bytes32 values.
734     // The Set implementation uses private functions, and user-facing
735     // implementations (such as AddressSet) are just wrappers around the
736     // underlying Set.
737     // This means that we can only create new EnumerableSets for types that fit
738     // in bytes32.
739 
740     struct Set {
741         // Storage of set values
742         bytes32[] _values;
743 
744         // Position of the value in the `values` array, plus 1 because index 0
745         // means a value is not in the set.
746         mapping (bytes32 => uint256) _indexes;
747     }
748 
749     /**
750      * @dev Add a value to a set. O(1).
751      *
752      * Returns true if the value was added to the set, that is if it was not
753      * already present.
754      */
755     function _add(Set storage set, bytes32 value) private returns (bool) {
756         if (!_contains(set, value)) {
757             set._values.push(value);
758             // The value is stored at length-1, but we add 1 to all indexes
759             // and use 0 as a sentinel value
760             set._indexes[value] = set._values.length;
761             return true;
762         } else {
763             return false;
764         }
765     }
766 
767     /**
768      * @dev Removes a value from a set. O(1).
769      *
770      * Returns true if the value was removed from the set, that is if it was
771      * present.
772      */
773     function _remove(Set storage set, bytes32 value) private returns (bool) {
774         // We read and store the value's index to prevent multiple reads from the same storage slot
775         uint256 valueIndex = set._indexes[value];
776 
777         if (valueIndex != 0) { // Equivalent to contains(set, value)
778             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
779             // the array, and then remove the last element (sometimes called as 'swap and pop').
780             // This modifies the order of the array, as noted in {at}.
781 
782             uint256 toDeleteIndex = valueIndex - 1;
783             uint256 lastIndex = set._values.length - 1;
784 
785             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
786             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
787 
788             bytes32 lastvalue = set._values[lastIndex];
789 
790             // Move the last value to the index where the value to delete is
791             set._values[toDeleteIndex] = lastvalue;
792             // Update the index for the moved value
793             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
794 
795             // Delete the slot where the moved value was stored
796             set._values.pop();
797 
798             // Delete the index for the deleted slot
799             delete set._indexes[value];
800 
801             return true;
802         } else {
803             return false;
804         }
805     }
806 
807     /**
808      * @dev Returns true if the value is in the set. O(1).
809      */
810     function _contains(Set storage set, bytes32 value) private view returns (bool) {
811         return set._indexes[value] != 0;
812     }
813 
814     /**
815      * @dev Returns the number of values on the set. O(1).
816      */
817     function _length(Set storage set) private view returns (uint256) {
818         return set._values.length;
819     }
820 
821    /**
822     * @dev Returns the value stored at position `index` in the set. O(1).
823     *
824     * Note that there are no guarantees on the ordering of values inside the
825     * array, and it may change when more values are added or removed.
826     *
827     * Requirements:
828     *
829     * - `index` must be strictly less than {length}.
830     */
831     function _at(Set storage set, uint256 index) private view returns (bytes32) {
832         require(set._values.length > index, "EnumerableSet: index out of bounds");
833         return set._values[index];
834     }
835 
836     // Bytes32Set
837 
838     struct Bytes32Set {
839         Set _inner;
840     }
841 
842     /**
843      * @dev Add a value to a set. O(1).
844      *
845      * Returns true if the value was added to the set, that is if it was not
846      * already present.
847      */
848     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
849         return _add(set._inner, value);
850     }
851 
852     /**
853      * @dev Removes a value from a set. O(1).
854      *
855      * Returns true if the value was removed from the set, that is if it was
856      * present.
857      */
858     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
859         return _remove(set._inner, value);
860     }
861 
862     /**
863      * @dev Returns true if the value is in the set. O(1).
864      */
865     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
866         return _contains(set._inner, value);
867     }
868 
869     /**
870      * @dev Returns the number of values in the set. O(1).
871      */
872     function length(Bytes32Set storage set) internal view returns (uint256) {
873         return _length(set._inner);
874     }
875 
876    /**
877     * @dev Returns the value stored at position `index` in the set. O(1).
878     *
879     * Note that there are no guarantees on the ordering of values inside the
880     * array, and it may change when more values are added or removed.
881     *
882     * Requirements:
883     *
884     * - `index` must be strictly less than {length}.
885     */
886     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
887         return _at(set._inner, index);
888     }
889 
890     // AddressSet
891 
892     struct AddressSet {
893         Set _inner;
894     }
895 
896     /**
897      * @dev Add a value to a set. O(1).
898      *
899      * Returns true if the value was added to the set, that is if it was not
900      * already present.
901      */
902     function add(AddressSet storage set, address value) internal returns (bool) {
903         return _add(set._inner, bytes32(uint256(uint160(value))));
904     }
905 
906     /**
907      * @dev Removes a value from a set. O(1).
908      *
909      * Returns true if the value was removed from the set, that is if it was
910      * present.
911      */
912     function remove(AddressSet storage set, address value) internal returns (bool) {
913         return _remove(set._inner, bytes32(uint256(uint160(value))));
914     }
915 
916     /**
917      * @dev Returns true if the value is in the set. O(1).
918      */
919     function contains(AddressSet storage set, address value) internal view returns (bool) {
920         return _contains(set._inner, bytes32(uint256(uint160(value))));
921     }
922 
923     /**
924      * @dev Returns the number of values in the set. O(1).
925      */
926     function length(AddressSet storage set) internal view returns (uint256) {
927         return _length(set._inner);
928     }
929 
930    /**
931     * @dev Returns the value stored at position `index` in the set. O(1).
932     *
933     * Note that there are no guarantees on the ordering of values inside the
934     * array, and it may change when more values are added or removed.
935     *
936     * Requirements:
937     *
938     * - `index` must be strictly less than {length}.
939     */
940     function at(AddressSet storage set, uint256 index) internal view returns (address) {
941         return address(uint160(uint256(_at(set._inner, index))));
942     }
943 
944 
945     // UintSet
946 
947     struct UintSet {
948         Set _inner;
949     }
950 
951     /**
952      * @dev Add a value to a set. O(1).
953      *
954      * Returns true if the value was added to the set, that is if it was not
955      * already present.
956      */
957     function add(UintSet storage set, uint256 value) internal returns (bool) {
958         return _add(set._inner, bytes32(value));
959     }
960 
961     /**
962      * @dev Removes a value from a set. O(1).
963      *
964      * Returns true if the value was removed from the set, that is if it was
965      * present.
966      */
967     function remove(UintSet storage set, uint256 value) internal returns (bool) {
968         return _remove(set._inner, bytes32(value));
969     }
970 
971     /**
972      * @dev Returns true if the value is in the set. O(1).
973      */
974     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
975         return _contains(set._inner, bytes32(value));
976     }
977 
978     /**
979      * @dev Returns the number of values on the set. O(1).
980      */
981     function length(UintSet storage set) internal view returns (uint256) {
982         return _length(set._inner);
983     }
984 
985    /**
986     * @dev Returns the value stored at position `index` in the set. O(1).
987     *
988     * Note that there are no guarantees on the ordering of values inside the
989     * array, and it may change when more values are added or removed.
990     *
991     * Requirements:
992     *
993     * - `index` must be strictly less than {length}.
994     */
995     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
996         return uint256(_at(set._inner, index));
997     }
998 }
999 
1000 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.0
1001 
1002 /**
1003  * @dev Library for managing an enumerable variant of Solidity's
1004  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1005  * type.
1006  *
1007  * Maps have the following properties:
1008  *
1009  * - Entries are added, removed, and checked for existence in constant time
1010  * (O(1)).
1011  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1012  *
1013  * ```
1014  * contract Example {
1015  *     // Add the library methods
1016  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1017  *
1018  *     // Declare a set state variable
1019  *     EnumerableMap.UintToAddressMap private myMap;
1020  * }
1021  * ```
1022  *
1023  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1024  * supported.
1025  */
1026 library EnumerableMap {
1027     // To implement this library for multiple types with as little code
1028     // repetition as possible, we write it in terms of a generic Map type with
1029     // bytes32 keys and values.
1030     // The Map implementation uses private functions, and user-facing
1031     // implementations (such as Uint256ToAddressMap) are just wrappers around
1032     // the underlying Map.
1033     // This means that we can only create new EnumerableMaps for types that fit
1034     // in bytes32.
1035 
1036     struct MapEntry {
1037         bytes32 _key;
1038         bytes32 _value;
1039     }
1040 
1041     struct Map {
1042         // Storage of map keys and values
1043         MapEntry[] _entries;
1044 
1045         // Position of the entry defined by a key in the `entries` array, plus 1
1046         // because index 0 means a key is not in the map.
1047         mapping (bytes32 => uint256) _indexes;
1048     }
1049 
1050     /**
1051      * @dev Adds a key-value pair to a map, or updates the value for an existing
1052      * key. O(1).
1053      *
1054      * Returns true if the key was added to the map, that is if it was not
1055      * already present.
1056      */
1057     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1058         // We read and store the key's index to prevent multiple reads from the same storage slot
1059         uint256 keyIndex = map._indexes[key];
1060 
1061         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1062             map._entries.push(MapEntry({ _key: key, _value: value }));
1063             // The entry is stored at length-1, but we add 1 to all indexes
1064             // and use 0 as a sentinel value
1065             map._indexes[key] = map._entries.length;
1066             return true;
1067         } else {
1068             map._entries[keyIndex - 1]._value = value;
1069             return false;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Removes a key-value pair from a map. O(1).
1075      *
1076      * Returns true if the key was removed from the map, that is if it was present.
1077      */
1078     function _remove(Map storage map, bytes32 key) private returns (bool) {
1079         // We read and store the key's index to prevent multiple reads from the same storage slot
1080         uint256 keyIndex = map._indexes[key];
1081 
1082         if (keyIndex != 0) { // Equivalent to contains(map, key)
1083             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1084             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1085             // This modifies the order of the array, as noted in {at}.
1086 
1087             uint256 toDeleteIndex = keyIndex - 1;
1088             uint256 lastIndex = map._entries.length - 1;
1089 
1090             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1091             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1092 
1093             MapEntry storage lastEntry = map._entries[lastIndex];
1094 
1095             // Move the last entry to the index where the entry to delete is
1096             map._entries[toDeleteIndex] = lastEntry;
1097             // Update the index for the moved entry
1098             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1099 
1100             // Delete the slot where the moved entry was stored
1101             map._entries.pop();
1102 
1103             // Delete the index for the deleted slot
1104             delete map._indexes[key];
1105 
1106             return true;
1107         } else {
1108             return false;
1109         }
1110     }
1111 
1112     /**
1113      * @dev Returns true if the key is in the map. O(1).
1114      */
1115     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1116         return map._indexes[key] != 0;
1117     }
1118 
1119     /**
1120      * @dev Returns the number of key-value pairs in the map. O(1).
1121      */
1122     function _length(Map storage map) private view returns (uint256) {
1123         return map._entries.length;
1124     }
1125 
1126    /**
1127     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1128     *
1129     * Note that there are no guarantees on the ordering of entries inside the
1130     * array, and it may change when more entries are added or removed.
1131     *
1132     * Requirements:
1133     *
1134     * - `index` must be strictly less than {length}.
1135     */
1136     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1137         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1138 
1139         MapEntry storage entry = map._entries[index];
1140         return (entry._key, entry._value);
1141     }
1142 
1143     /**
1144      * @dev Tries to returns the value associated with `key`.  O(1).
1145      * Does not revert if `key` is not in the map.
1146      */
1147     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1148         uint256 keyIndex = map._indexes[key];
1149         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1150         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1151     }
1152 
1153     /**
1154      * @dev Returns the value associated with `key`.  O(1).
1155      *
1156      * Requirements:
1157      *
1158      * - `key` must be in the map.
1159      */
1160     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1161         uint256 keyIndex = map._indexes[key];
1162         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1163         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1164     }
1165 
1166     /**
1167      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1168      *
1169      * CAUTION: This function is deprecated because it requires allocating memory for the error
1170      * message unnecessarily. For custom revert reasons use {_tryGet}.
1171      */
1172     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1173         uint256 keyIndex = map._indexes[key];
1174         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1175         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1176     }
1177 
1178     // UintToAddressMap
1179 
1180     struct UintToAddressMap {
1181         Map _inner;
1182     }
1183 
1184     /**
1185      * @dev Adds a key-value pair to a map, or updates the value for an existing
1186      * key. O(1).
1187      *
1188      * Returns true if the key was added to the map, that is if it was not
1189      * already present.
1190      */
1191     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1192         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1193     }
1194 
1195     /**
1196      * @dev Removes a value from a set. O(1).
1197      *
1198      * Returns true if the key was removed from the map, that is if it was present.
1199      */
1200     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1201         return _remove(map._inner, bytes32(key));
1202     }
1203 
1204     /**
1205      * @dev Returns true if the key is in the map. O(1).
1206      */
1207     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1208         return _contains(map._inner, bytes32(key));
1209     }
1210 
1211     /**
1212      * @dev Returns the number of elements in the map. O(1).
1213      */
1214     function length(UintToAddressMap storage map) internal view returns (uint256) {
1215         return _length(map._inner);
1216     }
1217 
1218    /**
1219     * @dev Returns the element stored at position `index` in the set. O(1).
1220     * Note that there are no guarantees on the ordering of values inside the
1221     * array, and it may change when more values are added or removed.
1222     *
1223     * Requirements:
1224     *
1225     * - `index` must be strictly less than {length}.
1226     */
1227     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1228         (bytes32 key, bytes32 value) = _at(map._inner, index);
1229         return (uint256(key), address(uint160(uint256(value))));
1230     }
1231 
1232     /**
1233      * @dev Tries to returns the value associated with `key`.  O(1).
1234      * Does not revert if `key` is not in the map.
1235      *
1236      * _Available since v3.4._
1237      */
1238     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1239         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1240         return (success, address(uint160(uint256(value))));
1241     }
1242 
1243     /**
1244      * @dev Returns the value associated with `key`.  O(1).
1245      *
1246      * Requirements:
1247      *
1248      * - `key` must be in the map.
1249      */
1250     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1251         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1252     }
1253 
1254     /**
1255      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1256      *
1257      * CAUTION: This function is deprecated because it requires allocating memory for the error
1258      * message unnecessarily. For custom revert reasons use {tryGet}.
1259      */
1260     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1261         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1262     }
1263 }
1264 
1265 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.0
1266 
1267 /**
1268  * @dev String operations.
1269  */
1270 library Strings {
1271     /**
1272      * @dev Converts a `uint256` to its ASCII `string` representation.
1273      */
1274     function toString(uint256 value) internal pure returns (string memory) {
1275         // Inspired by OraclizeAPI's implementation - MIT licence
1276         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1277 
1278         if (value == 0) {
1279             return "0";
1280         }
1281         uint256 temp = value;
1282         uint256 digits;
1283         while (temp != 0) {
1284             digits++;
1285             temp /= 10;
1286         }
1287         bytes memory buffer = new bytes(digits);
1288         uint256 index = digits - 1;
1289         temp = value;
1290         while (temp != 0) {
1291             buffer[index--] = bytes1(uint8(48 + temp % 10));
1292             temp /= 10;
1293         }
1294         return string(buffer);
1295     }
1296 }
1297 
1298 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.0
1299 
1300 /**
1301  * @title ERC721 Non-Fungible Token Standard basic implementation
1302  * @dev see https://eips.ethereum.org/EIPS/eip-721
1303  */
1304 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1305     using SafeMath for uint256;
1306     using Address for address;
1307     using EnumerableSet for EnumerableSet.UintSet;
1308     using EnumerableMap for EnumerableMap.UintToAddressMap;
1309     using Strings for uint256;
1310 
1311     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1312     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1313     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1314 
1315     // Mapping from holder address to their (enumerable) set of owned tokens
1316     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1317 
1318     // Enumerable mapping from token ids to their owners
1319     EnumerableMap.UintToAddressMap private _tokenOwners;
1320 
1321     // Mapping from token ID to approved address
1322     mapping (uint256 => address) private _tokenApprovals;
1323 
1324     // Mapping from owner to operator approvals
1325     mapping (address => mapping (address => bool)) private _operatorApprovals;
1326 
1327     // Token name
1328     string private _name;
1329 
1330     // Token symbol
1331     string private _symbol;
1332 
1333     // Optional mapping for token URIs
1334     mapping (uint256 => string) private _tokenURIs;
1335 
1336     // Base URI
1337     string private _baseURI;
1338 
1339     /*
1340      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1341      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1342      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1343      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1344      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1345      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1346      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1347      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1348      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1349      *
1350      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1351      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1352      */
1353     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1354 
1355     /*
1356      *     bytes4(keccak256('name()')) == 0x06fdde03
1357      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1358      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1359      *
1360      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1361      */
1362     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1363 
1364     /*
1365      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1366      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1367      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1368      *
1369      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1370      */
1371     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1372 
1373     /**
1374      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1375      */
1376     constructor (string memory name_, string memory symbol_) public {
1377         _name = name_;
1378         _symbol = symbol_;
1379 
1380         // register the supported interfaces to conform to ERC721 via ERC165
1381         _registerInterface(_INTERFACE_ID_ERC721);
1382         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1383         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-balanceOf}.
1388      */
1389     function balanceOf(address owner) public view virtual override returns (uint256) {
1390         require(owner != address(0), "ERC721: balance query for the zero address");
1391         return _holderTokens[owner].length();
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-ownerOf}.
1396      */
1397     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1398         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Metadata-name}.
1403      */
1404     function name() public view virtual override returns (string memory) {
1405         return _name;
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Metadata-symbol}.
1410      */
1411     function symbol() public view virtual override returns (string memory) {
1412         return _symbol;
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Metadata-tokenURI}.
1417      */
1418     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1419         string memory _tokenURI = _tokenURIs[tokenId];
1420         string memory base = baseURI();
1421 
1422         // If there is no base URI, return the token URI.
1423         if (bytes(base).length == 0) {
1424             return _tokenURI;
1425         }
1426         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1427         if (bytes(_tokenURI).length > 0) {
1428             return string(abi.encodePacked(base, _tokenURI));
1429         }
1430         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1431         return string(abi.encodePacked(base, tokenId.toString()));
1432     }
1433 
1434     /**
1435     * @dev Returns the base URI set via {_setBaseURI}. This will be
1436     * automatically added as a prefix in {tokenURI} to each token's URI, or
1437     * to the token ID if no specific URI is set for that token ID.
1438     */
1439     function baseURI() public view virtual returns (string memory) {
1440         return _baseURI;
1441     }
1442 
1443     /**
1444      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1445      */
1446     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1447         return _holderTokens[owner].at(index);
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Enumerable-totalSupply}.
1452      */
1453     function totalSupply() public view virtual override returns (uint256) {
1454         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1455         return _tokenOwners.length();
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Enumerable-tokenByIndex}.
1460      */
1461     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1462         (uint256 tokenId, ) = _tokenOwners.at(index);
1463         return tokenId;
1464     }
1465 
1466     /**
1467      * @dev See {IERC721-approve}.
1468      */
1469     function approve(address to, uint256 tokenId) public virtual override {
1470         address owner = ERC721.ownerOf(tokenId);
1471         require(to != owner, "ERC721: approval to current owner");
1472 
1473         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1474             "ERC721: approve caller is not owner nor approved for all"
1475         );
1476 
1477         _approve(to, tokenId);
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-getApproved}.
1482      */
1483     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1484         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1485 
1486         return _tokenApprovals[tokenId];
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-setApprovalForAll}.
1491      */
1492     function setApprovalForAll(address operator, bool approved) public virtual override {
1493         require(operator != _msgSender(), "ERC721: approve to caller");
1494 
1495         _operatorApprovals[_msgSender()][operator] = approved;
1496         emit ApprovalForAll(_msgSender(), operator, approved);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721-isApprovedForAll}.
1501      */
1502     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1503         return _operatorApprovals[owner][operator];
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-transferFrom}.
1508      */
1509     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1510         //solhint-disable-next-line max-line-length
1511         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1512 
1513         _transfer(from, to, tokenId);
1514     }
1515 
1516     /**
1517      * @dev See {IERC721-safeTransferFrom}.
1518      */
1519     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1520         safeTransferFrom(from, to, tokenId, "");
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-safeTransferFrom}.
1525      */
1526     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1527         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1528         _safeTransfer(from, to, tokenId, _data);
1529     }
1530 
1531     /**
1532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1534      *
1535      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1536      *
1537      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1538      * implement alternative mechanisms to perform token transfer, such as signature-based.
1539      *
1540      * Requirements:
1541      *
1542      * - `from` cannot be the zero address.
1543      * - `to` cannot be the zero address.
1544      * - `tokenId` token must exist and be owned by `from`.
1545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1546      *
1547      * Emits a {Transfer} event.
1548      */
1549     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1550         _transfer(from, to, tokenId);
1551         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1552     }
1553 
1554     /**
1555      * @dev Returns whether `tokenId` exists.
1556      *
1557      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1558      *
1559      * Tokens start existing when they are minted (`_mint`),
1560      * and stop existing when they are burned (`_burn`).
1561      */
1562     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1563         return _tokenOwners.contains(tokenId);
1564     }
1565 
1566     /**
1567      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      */
1573     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1574         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1575         address owner = ERC721.ownerOf(tokenId);
1576         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1577     }
1578 
1579     /**
1580      * @dev Safely mints `tokenId` and transfers it to `to`.
1581      *
1582      * Requirements:
1583      d*
1584      * - `tokenId` must not exist.
1585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1586      *
1587      * Emits a {Transfer} event.
1588      */
1589     function _safeMint(address to, uint256 tokenId) internal virtual {
1590         _safeMint(to, tokenId, "");
1591     }
1592 
1593     /**
1594      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1595      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1596      */
1597     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1598         _mint(to, tokenId);
1599         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1600     }
1601 
1602     /**
1603      * @dev Mints `tokenId` and transfers it to `to`.
1604      *
1605      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1606      *
1607      * Requirements:
1608      *
1609      * - `tokenId` must not exist.
1610      * - `to` cannot be the zero address.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function _mint(address to, uint256 tokenId) internal virtual {
1615         require(to != address(0), "ERC721: mint to the zero address");
1616         require(!_exists(tokenId), "ERC721: token already minted");
1617 
1618         _beforeTokenTransfer(address(0), to, tokenId);
1619 
1620         _holderTokens[to].add(tokenId);
1621 
1622         _tokenOwners.set(tokenId, to);
1623 
1624         emit Transfer(address(0), to, tokenId);
1625     }
1626 
1627     /**
1628      * @dev Destroys `tokenId`.
1629      * The approval is cleared when the token is burned.
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must exist.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function _burn(uint256 tokenId) internal virtual {
1638         address owner = ERC721.ownerOf(tokenId); // internal owner
1639 
1640         _beforeTokenTransfer(owner, address(0), tokenId);
1641 
1642         // Clear approvals
1643         _approve(address(0), tokenId);
1644 
1645         // Clear metadata (if any)
1646         if (bytes(_tokenURIs[tokenId]).length != 0) {
1647             delete _tokenURIs[tokenId];
1648         }
1649 
1650         _holderTokens[owner].remove(tokenId);
1651 
1652         _tokenOwners.remove(tokenId);
1653 
1654         emit Transfer(owner, address(0), tokenId);
1655     }
1656 
1657     /**
1658      * @dev Transfers `tokenId` from `from` to `to`.
1659      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1660      *
1661      * Requirements:
1662      *
1663      * - `to` cannot be the zero address.
1664      * - `tokenId` token must be owned by `from`.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1669         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1670         require(to != address(0), "ERC721: transfer to the zero address");
1671 
1672         _beforeTokenTransfer(from, to, tokenId);
1673 
1674         // Clear approvals from the previous owner
1675         _approve(address(0), tokenId);
1676 
1677         _holderTokens[from].remove(tokenId);
1678         _holderTokens[to].add(tokenId);
1679 
1680         _tokenOwners.set(tokenId, to);
1681 
1682         emit Transfer(from, to, tokenId);
1683     }
1684 
1685     /**
1686      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      */
1692     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1693         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1694         _tokenURIs[tokenId] = _tokenURI;
1695     }
1696 
1697     /**
1698      * @dev Internal function to set the base URI for all token IDs. It is
1699      * automatically added as a prefix to the value returned in {tokenURI},
1700      * or to the token ID if {tokenURI} is empty.
1701      */
1702     function _setBaseURI(string memory baseURI_) internal virtual {
1703         _baseURI = baseURI_;
1704     }
1705 
1706     /**
1707      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1708      * The call is not executed if the target address is not a contract.
1709      *
1710      * @param from address representing the previous owner of the given token ID
1711      * @param to target address that will receive the tokens
1712      * @param tokenId uint256 ID of the token to be transferred
1713      * @param _data bytes optional data to send along with the call
1714      * @return bool whether the call correctly returned the expected magic value
1715      */
1716     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1717         private returns (bool)
1718     {
1719         if (!to.isContract()) {
1720             return true;
1721         }
1722         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1723             IERC721Receiver(to).onERC721Received.selector,
1724             _msgSender(),
1725             from,
1726             tokenId,
1727             _data
1728         ), "ERC721: transfer to non ERC721Receiver implementer");
1729         bytes4 retval = abi.decode(returndata, (bytes4));
1730         return (retval == _ERC721_RECEIVED);
1731     }
1732 
1733     function _approve(address to, uint256 tokenId) private {
1734         _tokenApprovals[tokenId] = to;
1735         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1736     }
1737 
1738     /**
1739      * @dev Hook that is called before any token transfer. This includes minting
1740      * and burning.
1741      *
1742      * Calling conditions:
1743      *
1744      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1745      * transferred to `to`.
1746      * - When `from` is zero, `tokenId` will be minted for `to`.
1747      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1748      * - `from` cannot be the zero address.
1749      * - `to` cannot be the zero address.
1750      *
1751      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1752      */
1753     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1754 }
1755 
1756 // File @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol@v3.4.0
1757 
1758 /**
1759  * @title ERC721 Burnable Token
1760  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1761  */
1762 abstract contract ERC721Burnable is Context, ERC721 {
1763     /**
1764      * @dev Burns `tokenId`. See {ERC721-_burn}.
1765      *
1766      * Requirements:
1767      *
1768      * - The caller must own `tokenId` or be an approved operator.
1769      */
1770     function burn(uint256 tokenId) public virtual {
1771         //solhint-disable-next-line max-line-length
1772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1773         _burn(tokenId);
1774     }
1775 }
1776 
1777 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
1778 
1779 /**
1780  * @dev Contract module which provides a basic access control mechanism, where
1781  * there is an account (an owner) that can be granted exclusive access to
1782  * specific functions.
1783  *
1784  * By default, the owner account will be the one that deploys the contract. This
1785  * can later be changed with {transferOwnership}.
1786  *
1787  * This module is used through inheritance. It will make available the modifier
1788  * `onlyOwner`, which can be applied to your functions to restrict their use to
1789  * the owner.
1790  */
1791 abstract contract Ownable is Context {
1792     address private _owner;
1793 
1794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1795 
1796     /**
1797      * @dev Initializes the contract setting the deployer as the initial owner.
1798      */
1799     constructor () internal {
1800         address msgSender = _msgSender();
1801         _owner = msgSender;
1802         emit OwnershipTransferred(address(0), msgSender);
1803     }
1804 
1805     /**
1806      * @dev Returns the address of the current owner.
1807      */
1808     function owner() public view virtual returns (address) {
1809         return _owner;
1810     }
1811 
1812     /**
1813      * @dev Throws if called by any account other than the owner.
1814      */
1815     modifier onlyOwner() {
1816         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1817         _;
1818     }
1819 
1820     /**
1821      * @dev Leaves the contract without owner. It will not be possible to call
1822      * `onlyOwner` functions anymore. Can only be called by the current owner.
1823      *
1824      * NOTE: Renouncing ownership will leave the contract without an owner,
1825      * thereby removing any functionality that is only available to the owner.
1826      */
1827     function renounceOwnership() public virtual onlyOwner {
1828         emit OwnershipTransferred(_owner, address(0));
1829         _owner = address(0);
1830     }
1831 
1832     /**
1833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1834      * Can only be called by the current owner.
1835      */
1836     function transferOwnership(address newOwner) public virtual onlyOwner {
1837         require(newOwner != address(0), "Ownable: new owner is the zero address");
1838         emit OwnershipTransferred(_owner, newOwner);
1839         _owner = newOwner;
1840     }
1841 }
1842 
1843 contract RebelSeals is ERC721Burnable, Ownable {
1844     uint256 constant public PRICE = 0.08 ether;
1845     uint256 constant public TOTAL_SUPPLY = 9999;
1846     uint256 constant public REVEAL_TIMESTAMP = 0;
1847     uint256 constant public MAX_PER_TX = 20;
1848     uint256 constant public MAX_MINT_WHITELIST = 20;
1849     uint256 public MAX_TEAM_TOKENS = 100;
1850     uint256 public startingIndex;
1851     uint256 public startingIndexBlock;
1852 
1853     struct Whitelist {
1854         address addr;
1855         uint hasMinted;
1856     }
1857     mapping(address => Whitelist) public whitelist;
1858     
1859     address[] whitelistAddr;
1860     address payable claimEthAddress = 0xF429bdA61698e56081b9E926BA447C895f211A51; // multisig
1861 
1862     bool public saleIsActive = false;
1863     bool public privateSaleIsActive = true;
1864 
1865     constructor(address[] memory addrs) public ERC721("Rebel Seals", "RebelSeals") {
1866         whitelistAddr = addrs;
1867         for(uint i = 0; i < whitelistAddr.length; i++) {
1868             addAddressToWhitelist(whitelistAddr[i]);
1869         }
1870     }
1871 
1872     function reserveSeal(address addr, uint256 amount) public {
1873         require(MAX_TEAM_TOKENS > 0, 'There is no team tokens left');
1874         require(msg.sender == address(0xF429bdA61698e56081b9E926BA447C895f211A51), 'You are not whitelisted to reserve');
1875         MAX_TEAM_TOKENS = MAX_TEAM_TOKENS.sub(amount);
1876 
1877         uint supply = totalSupply();
1878         uint i;
1879         for (i = 0; i < amount; i++) {
1880             _safeMint(addr, supply + i);
1881         }
1882     }
1883 
1884     function setBaseURI(string memory baseURI) public onlyOwner {
1885         _setBaseURI(baseURI);
1886     }
1887 
1888     function flipSaleState() public onlyOwner {
1889         saleIsActive = !saleIsActive;
1890     }
1891 
1892     function flipPrivateSaleState() public onlyOwner {
1893         privateSaleIsActive = !privateSaleIsActive;
1894     }
1895 
1896     function mintSeal(uint numberOfTokens) public payable {
1897         require(saleIsActive, "Sale must be active to mint");
1898         require(totalSupply().add(numberOfTokens) <= TOTAL_SUPPLY, "Exceeds max supply");
1899         require(PRICE.mul(numberOfTokens) <= msg.value, "ETH sent is incorrect");
1900 
1901         // Private sales
1902         if(privateSaleIsActive) {
1903             require(numberOfTokens <= MAX_MINT_WHITELIST, "Above max tx count");
1904             require(isWhitelisted(msg.sender), "Is not whitelisted");
1905             require(whitelist[msg.sender].hasMinted.add(numberOfTokens) <= MAX_MINT_WHITELIST, "Can only mint 20 while whitelisted");
1906             require(whitelist[msg.sender].hasMinted <= MAX_MINT_WHITELIST, "Can only mint 20 while whitelisted");
1907             whitelist[msg.sender].hasMinted = whitelist[msg.sender].hasMinted.add(numberOfTokens);
1908         } else {
1909             require(numberOfTokens <= MAX_PER_TX, "Above max tx count");
1910         }
1911 
1912         for(uint i = 0; i < numberOfTokens; i++) {
1913             uint mintIndex = totalSupply();
1914             _safeMint(msg.sender, mintIndex);
1915         }
1916         
1917         // If we haven't set the starting index and this is either
1918         // 1) the last saleable token or
1919         // 2) the first token to be sold after the end of pre-sale, set the starting index block
1920         if (startingIndexBlock == 0 && (totalSupply() == TOTAL_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
1921             startingIndexBlock = block.number;
1922         }
1923     }
1924 
1925     /**
1926     * Set the starting index for the collection
1927     */
1928     function setStartingIndex() public onlyOwner {
1929         require(startingIndex == 0, "Starting index is already set");
1930         require(startingIndexBlock != 0, "Starting index block must be set");
1931         startingIndex = uint(blockhash(startingIndexBlock)) % TOTAL_SUPPLY;
1932         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1933         if (block.number.sub(startingIndexBlock) > 255) {
1934             startingIndex = uint(blockhash(block.number - 1)) % TOTAL_SUPPLY;
1935         }
1936     }
1937 
1938     function claimETH() public {
1939         require(claimEthAddress == _msgSender(), "Ownable: caller is not the claimEthAddress");
1940         payable(address(claimEthAddress)).transfer(address(this).balance);
1941     }
1942 
1943     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1944         if (startingIndex == 0) {
1945             return super.tokenURI(0);
1946         }
1947         uint256 moddedId = (tokenId + startingIndex) % TOTAL_SUPPLY;
1948         return super.tokenURI(moddedId);
1949     }
1950 
1951     /**
1952     * @dev add an address to the whitelist
1953     * @param addr address
1954     */
1955     function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
1956         require(!isWhitelisted(addr), "Already whitelisted");
1957         whitelist[addr].addr = addr;
1958         whitelist[addr].hasMinted = 0;
1959         success = true;
1960     }
1961 
1962     function isWhitelisted(address addr) public view returns (bool isWhiteListed) {
1963         return whitelist[addr].addr == addr;
1964     }
1965 }