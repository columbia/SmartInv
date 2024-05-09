1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-23
3  *By @Thrasher66099
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.0;
9 
10 
11 // File: @openzeppelin/contracts/utils/Context.sol
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 
35 // File: @openzeppelin/contracts/introspection/IERC165.sol
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 
59 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
185 
186 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 
210 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Enumerable is IERC721 {
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
235 
236 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
237 
238 /**
239  * @title ERC721 token receiver interface
240  * @dev Interface for any contract that wants to support safeTransfers
241  * from ERC721 asset contracts.
242  */
243 interface IERC721Receiver {
244     /**
245      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
246      * by `operator` from `from`, this function is called.
247      *
248      * It must return its Solidity selector to confirm the token transfer.
249      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
250      *
251      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
252      */
253     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
254 }
255 
256 
257 // File: @openzeppelin/contracts/introspection/ERC165.sol
258 
259 /**
260  * @dev Implementation of the {IERC165} interface.
261  *
262  * Contracts may inherit from this and call {_registerInterface} to declare
263  * their support of an interface.
264  */
265 abstract contract ERC165 is IERC165 {
266     /*
267      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
268      */
269     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
270 
271     /**
272      * @dev Mapping of interface ids to whether or not it's supported.
273      */
274     mapping(bytes4 => bool) private _supportedInterfaces;
275 
276     constructor () {
277         // Derived contracts need only register support for their own interfaces,
278         // we register support for ERC165 itself here
279         _registerInterface(_INTERFACE_ID_ERC165);
280     }
281 
282     /**
283      * @dev See {IERC165-supportsInterface}.
284      *
285      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
286      */
287     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
288         return _supportedInterfaces[interfaceId];
289     }
290 
291     /**
292      * @dev Registers the contract as an implementer of the interface defined by
293      * `interfaceId`. Support of the actual ERC165 interface is automatic and
294      * registering its interface id is not required.
295      *
296      * See {IERC165-supportsInterface}.
297      *
298      * Requirements:
299      *
300      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
301      */
302     function _registerInterface(bytes4 interfaceId) internal virtual {
303         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
304         _supportedInterfaces[interfaceId] = true;
305     }
306 }
307 
308 
309 // File: @openzeppelin/contracts/math/SafeMath.sol
310 
311 /**
312  * @dev Wrappers over Solidity's arithmetic operations with added overflow
313  * checks.
314  *
315  * Arithmetic operations in Solidity wrap on overflow. This can easily result
316  * in bugs, because programmers usually assume that an overflow raises an
317  * error, which is the standard behavior in high level programming languages.
318  * `SafeMath` restores this intuition by reverting the transaction when an
319  * operation overflows.
320  *
321  * Using this library instead of the unchecked operations eliminates an entire
322  * class of bugs, so it's recommended to use it always.
323  */
324 library SafeMath {
325     /**
326      * @dev Returns the addition of two unsigned integers, with an overflow flag.
327      *
328      * _Available since v3.4._
329      */
330     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         uint256 c = a + b;
332         if (c < a) return (false, 0);
333         return (true, c);
334     }
335 
336     /**
337      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
338      *
339      * _Available since v3.4._
340      */
341     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342         if (b > a) return (false, 0);
343         return (true, a - b);
344     }
345 
346     /**
347      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
352         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
353         // benefit is lost if 'b' is also tested.
354         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
355         if (a == 0) return (true, 0);
356         uint256 c = a * b;
357         if (c / a != b) return (false, 0);
358         return (true, c);
359     }
360 
361     /**
362      * @dev Returns the division of two unsigned integers, with a division by zero flag.
363      *
364      * _Available since v3.4._
365      */
366     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
367         if (b == 0) return (false, 0);
368         return (true, a / b);
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         if (b == 0) return (false, 0);
378         return (true, a % b);
379     }
380 
381     /**
382      * @dev Returns the addition of two unsigned integers, reverting on
383      * overflow.
384      *
385      * Counterpart to Solidity's `+` operator.
386      *
387      * Requirements:
388      *
389      * - Addition cannot overflow.
390      */
391     function add(uint256 a, uint256 b) internal pure returns (uint256) {
392         uint256 c = a + b;
393         require(c >= a, "SafeMath: addition overflow");
394         return c;
395     }
396 
397     /**
398      * @dev Returns the subtraction of two unsigned integers, reverting on
399      * overflow (when the result is negative).
400      *
401      * Counterpart to Solidity's `-` operator.
402      *
403      * Requirements:
404      *
405      * - Subtraction cannot overflow.
406      */
407     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
408         require(b <= a, "SafeMath: subtraction overflow");
409         return a - b;
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, reverting on
414      * overflow.
415      *
416      * Counterpart to Solidity's `*` operator.
417      *
418      * Requirements:
419      *
420      * - Multiplication cannot overflow.
421      */
422     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
423         if (a == 0) return 0;
424         uint256 c = a * b;
425         require(c / a == b, "SafeMath: multiplication overflow");
426         return c;
427     }
428 
429     /**
430      * @dev Returns the integer division of two unsigned integers, reverting on
431      * division by zero. The result is rounded towards zero.
432      *
433      * Counterpart to Solidity's `/` operator. Note: this function uses a
434      * `revert` opcode (which leaves remaining gas untouched) while Solidity
435      * uses an invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      *
439      * - The divisor cannot be zero.
440      */
441     function div(uint256 a, uint256 b) internal pure returns (uint256) {
442         require(b > 0, "SafeMath: division by zero");
443         return a / b;
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * reverting when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
459         require(b > 0, "SafeMath: modulo by zero");
460         return a % b;
461     }
462 
463     /**
464      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
465      * overflow (when the result is negative).
466      *
467      * CAUTION: This function is deprecated because it requires allocating memory for the error
468      * message unnecessarily. For custom revert reasons use {trySub}.
469      *
470      * Counterpart to Solidity's `-` operator.
471      *
472      * Requirements:
473      *
474      * - Subtraction cannot overflow.
475      */
476     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
477         require(b <= a, errorMessage);
478         return a - b;
479     }
480 
481     /**
482      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
483      * division by zero. The result is rounded towards zero.
484      *
485      * CAUTION: This function is deprecated because it requires allocating memory for the error
486      * message unnecessarily. For custom revert reasons use {tryDiv}.
487      *
488      * Counterpart to Solidity's `/` operator. Note: this function uses a
489      * `revert` opcode (which leaves remaining gas untouched) while Solidity
490      * uses an invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b > 0, errorMessage);
498         return a / b;
499     }
500 
501     /**
502      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
503      * reverting with custom message when dividing by zero.
504      *
505      * CAUTION: This function is deprecated because it requires allocating memory for the error
506      * message unnecessarily. For custom revert reasons use {tryMod}.
507      *
508      * Counterpart to Solidity's `%` operator. This function uses a `revert`
509      * opcode (which leaves remaining gas untouched) while Solidity uses an
510      * invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
517         require(b > 0, errorMessage);
518         return a % b;
519     }
520 }
521 
522 
523 // File: @openzeppelin/contracts/utils/Address.sol
524 
525 /**
526  * @dev Collection of functions related to the address type
527  */
528 library Address {
529     /**
530      * @dev Returns true if `account` is a contract.
531      *
532      * [IMPORTANT]
533      * ====
534      * It is unsafe to assume that an address for which this function returns
535      * false is an externally-owned account (EOA) and not a contract.
536      *
537      * Among others, `isContract` will return false for the following
538      * types of addresses:
539      *
540      *  - an externally-owned account
541      *  - a contract in construction
542      *  - an address where a contract will be created
543      *  - an address where a contract lived, but was destroyed
544      * ====
545      */
546     function isContract(address account) internal view returns (bool) {
547         // This method relies on extcodesize, which returns 0 for contracts in
548         // construction, since the code is only stored at the end of the
549         // constructor execution.
550 
551         uint256 size;
552         // solhint-disable-next-line no-inline-assembly
553         assembly { size := extcodesize(account) }
554         return size > 0;
555     }
556 
557     /**
558      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
559      * `recipient`, forwarding all available gas and reverting on errors.
560      *
561      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
562      * of certain opcodes, possibly making contracts go over the 2300 gas limit
563      * imposed by `transfer`, making them unable to receive funds via
564      * `transfer`. {sendValue} removes this limitation.
565      *
566      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
567      *
568      * IMPORTANT: because control is transferred to `recipient`, care must be
569      * taken to not create reentrancy vulnerabilities. Consider using
570      * {ReentrancyGuard} or the
571      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
572      */
573     function sendValue(address payable recipient, uint256 amount) internal {
574         require(address(this).balance >= amount, "Address: insufficient balance");
575 
576         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
577         (bool success, ) = recipient.call{ value: amount }("");
578         require(success, "Address: unable to send value, recipient may have reverted");
579     }
580 
581     /**
582      * @dev Performs a Solidity function call using a low level `call`. A
583      * plain`call` is an unsafe replacement for a function call: use this
584      * function instead.
585      *
586      * If `target` reverts with a revert reason, it is bubbled up by this
587      * function (like regular Solidity function calls).
588      *
589      * Returns the raw returned data. To convert to the expected return value,
590      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
591      *
592      * Requirements:
593      *
594      * - `target` must be a contract.
595      * - calling `target` with `data` must not revert.
596      *
597      * _Available since v3.1._
598      */
599     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
600       return functionCall(target, data, "Address: low-level call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
605      * `errorMessage` as a fallback revert reason when `target` reverts.
606      *
607      * _Available since v3.1._
608      */
609     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
610         return functionCallWithValue(target, data, 0, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but also transferring `value` wei to `target`.
616      *
617      * Requirements:
618      *
619      * - the calling contract must have an ETH balance of at least `value`.
620      * - the called Solidity function must be `payable`.
621      *
622      * _Available since v3.1._
623      */
624     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
625         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
630      * with `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
635         require(address(this).balance >= value, "Address: insufficient balance for call");
636         require(isContract(target), "Address: call to non-contract");
637 
638         // solhint-disable-next-line avoid-low-level-calls
639         (bool success, bytes memory returndata) = target.call{ value: value }(data);
640         return _verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a static call.
646      *
647      * _Available since v3.3._
648      */
649     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
650         return functionStaticCall(target, data, "Address: low-level static call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a static call.
656      *
657      * _Available since v3.3._
658      */
659     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
660         require(isContract(target), "Address: static call to non-contract");
661 
662         // solhint-disable-next-line avoid-low-level-calls
663         (bool success, bytes memory returndata) = target.staticcall(data);
664         return _verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but performing a delegate call.
670      *
671      * _Available since v3.4._
672      */
673     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
674         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a delegate call.
680      *
681      * _Available since v3.4._
682      */
683     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
684         require(isContract(target), "Address: delegate call to non-contract");
685 
686         // solhint-disable-next-line avoid-low-level-calls
687         (bool success, bytes memory returndata) = target.delegatecall(data);
688         return _verifyCallResult(success, returndata, errorMessage);
689     }
690 
691     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
692         if (success) {
693             return returndata;
694         } else {
695             // Look for revert reason and bubble it up if present
696             if (returndata.length > 0) {
697                 // The easiest way to bubble the revert reason is using memory via assembly
698 
699                 // solhint-disable-next-line no-inline-assembly
700                 assembly {
701                     let returndata_size := mload(returndata)
702                     revert(add(32, returndata), returndata_size)
703                 }
704             } else {
705                 revert(errorMessage);
706             }
707         }
708     }
709 }
710 
711 
712 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
713 
714 /**
715  * @dev Library for managing
716  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
717  * types.
718  *
719  * Sets have the following properties:
720  *
721  * - Elements are added, removed, and checked for existence in constant time
722  * (O(1)).
723  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
724  *
725  * ```
726  * contract Example {
727  *     // Add the library methods
728  *     using EnumerableSet for EnumerableSet.AddressSet;
729  *
730  *     // Declare a set state variable
731  *     EnumerableSet.AddressSet private mySet;
732  * }
733  * ```
734  *
735  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
736  * and `uint256` (`UintSet`) are supported.
737  */
738 library EnumerableSet {
739     // To implement this library for multiple types with as little code
740     // repetition as possible, we write it in terms of a generic Set type with
741     // bytes32 values.
742     // The Set implementation uses private functions, and user-facing
743     // implementations (such as AddressSet) are just wrappers around the
744     // underlying Set.
745     // This means that we can only create new EnumerableSets for types that fit
746     // in bytes32.
747 
748     struct Set {
749         // Storage of set values
750         bytes32[] _values;
751 
752         // Position of the value in the `values` array, plus 1 because index 0
753         // means a value is not in the set.
754         mapping (bytes32 => uint256) _indexes;
755     }
756 
757     /**
758      * @dev Add a value to a set. O(1).
759      *
760      * Returns true if the value was added to the set, that is if it was not
761      * already present.
762      */
763     function _add(Set storage set, bytes32 value) private returns (bool) {
764         if (!_contains(set, value)) {
765             set._values.push(value);
766             // The value is stored at length-1, but we add 1 to all indexes
767             // and use 0 as a sentinel value
768             set._indexes[value] = set._values.length;
769             return true;
770         } else {
771             return false;
772         }
773     }
774 
775     /**
776      * @dev Removes a value from a set. O(1).
777      *
778      * Returns true if the value was removed from the set, that is if it was
779      * present.
780      */
781     function _remove(Set storage set, bytes32 value) private returns (bool) {
782         // We read and store the value's index to prevent multiple reads from the same storage slot
783         uint256 valueIndex = set._indexes[value];
784 
785         if (valueIndex != 0) { // Equivalent to contains(set, value)
786             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
787             // the array, and then remove the last element (sometimes called as 'swap and pop').
788             // This modifies the order of the array, as noted in {at}.
789 
790             uint256 toDeleteIndex = valueIndex - 1;
791             uint256 lastIndex = set._values.length - 1;
792 
793             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
794             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
795 
796             bytes32 lastvalue = set._values[lastIndex];
797 
798             // Move the last value to the index where the value to delete is
799             set._values[toDeleteIndex] = lastvalue;
800             // Update the index for the moved value
801             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
802 
803             // Delete the slot where the moved value was stored
804             set._values.pop();
805 
806             // Delete the index for the deleted slot
807             delete set._indexes[value];
808 
809             return true;
810         } else {
811             return false;
812         }
813     }
814 
815     /**
816      * @dev Returns true if the value is in the set. O(1).
817      */
818     function _contains(Set storage set, bytes32 value) private view returns (bool) {
819         return set._indexes[value] != 0;
820     }
821 
822     /**
823      * @dev Returns the number of values on the set. O(1).
824      */
825     function _length(Set storage set) private view returns (uint256) {
826         return set._values.length;
827     }
828 
829    /**
830     * @dev Returns the value stored at position `index` in the set. O(1).
831     *
832     * Note that there are no guarantees on the ordering of values inside the
833     * array, and it may change when more values are added or removed.
834     *
835     * Requirements:
836     *
837     * - `index` must be strictly less than {length}.
838     */
839     function _at(Set storage set, uint256 index) private view returns (bytes32) {
840         require(set._values.length > index, "EnumerableSet: index out of bounds");
841         return set._values[index];
842     }
843 
844     // Bytes32Set
845 
846     struct Bytes32Set {
847         Set _inner;
848     }
849 
850     /**
851      * @dev Add a value to a set. O(1).
852      *
853      * Returns true if the value was added to the set, that is if it was not
854      * already present.
855      */
856     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
857         return _add(set._inner, value);
858     }
859 
860     /**
861      * @dev Removes a value from a set. O(1).
862      *
863      * Returns true if the value was removed from the set, that is if it was
864      * present.
865      */
866     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
867         return _remove(set._inner, value);
868     }
869 
870     /**
871      * @dev Returns true if the value is in the set. O(1).
872      */
873     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
874         return _contains(set._inner, value);
875     }
876 
877     /**
878      * @dev Returns the number of values in the set. O(1).
879      */
880     function length(Bytes32Set storage set) internal view returns (uint256) {
881         return _length(set._inner);
882     }
883 
884    /**
885     * @dev Returns the value stored at position `index` in the set. O(1).
886     *
887     * Note that there are no guarantees on the ordering of values inside the
888     * array, and it may change when more values are added or removed.
889     *
890     * Requirements:
891     *
892     * - `index` must be strictly less than {length}.
893     */
894     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
895         return _at(set._inner, index);
896     }
897 
898     // AddressSet
899 
900     struct AddressSet {
901         Set _inner;
902     }
903 
904     /**
905      * @dev Add a value to a set. O(1).
906      *
907      * Returns true if the value was added to the set, that is if it was not
908      * already present.
909      */
910     function add(AddressSet storage set, address value) internal returns (bool) {
911         return _add(set._inner, bytes32(uint256(uint160(value))));
912     }
913 
914     /**
915      * @dev Removes a value from a set. O(1).
916      *
917      * Returns true if the value was removed from the set, that is if it was
918      * present.
919      */
920     function remove(AddressSet storage set, address value) internal returns (bool) {
921         return _remove(set._inner, bytes32(uint256(uint160(value))));
922     }
923 
924     /**
925      * @dev Returns true if the value is in the set. O(1).
926      */
927     function contains(AddressSet storage set, address value) internal view returns (bool) {
928         return _contains(set._inner, bytes32(uint256(uint160(value))));
929     }
930 
931     /**
932      * @dev Returns the number of values in the set. O(1).
933      */
934     function length(AddressSet storage set) internal view returns (uint256) {
935         return _length(set._inner);
936     }
937 
938    /**
939     * @dev Returns the value stored at position `index` in the set. O(1).
940     *
941     * Note that there are no guarantees on the ordering of values inside the
942     * array, and it may change when more values are added or removed.
943     *
944     * Requirements:
945     *
946     * - `index` must be strictly less than {length}.
947     */
948     function at(AddressSet storage set, uint256 index) internal view returns (address) {
949         return address(uint160(uint256(_at(set._inner, index))));
950     }
951 
952     // UintSet
953 
954     struct UintSet {
955         Set _inner;
956     }
957 
958     /**
959      * @dev Add a value to a set. O(1).
960      *
961      * Returns true if the value was added to the set, that is if it was not
962      * already present.
963      */
964     function add(UintSet storage set, uint256 value) internal returns (bool) {
965         return _add(set._inner, bytes32(value));
966     }
967 
968     /**
969      * @dev Removes a value from a set. O(1).
970      *
971      * Returns true if the value was removed from the set, that is if it was
972      * present.
973      */
974     function remove(UintSet storage set, uint256 value) internal returns (bool) {
975         return _remove(set._inner, bytes32(value));
976     }
977 
978     /**
979      * @dev Returns true if the value is in the set. O(1).
980      */
981     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
982         return _contains(set._inner, bytes32(value));
983     }
984 
985     /**
986      * @dev Returns the number of values on the set. O(1).
987      */
988     function length(UintSet storage set) internal view returns (uint256) {
989         return _length(set._inner);
990     }
991 
992    /**
993     * @dev Returns the value stored at position `index` in the set. O(1).
994     *
995     * Note that there are no guarantees on the ordering of values inside the
996     * array, and it may change when more values are added or removed.
997     *
998     * Requirements:
999     *
1000     * - `index` must be strictly less than {length}.
1001     */
1002     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1003         return uint256(_at(set._inner, index));
1004     }
1005 }
1006 
1007 
1008 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1009 
1010 /**
1011  * @dev Library for managing an enumerable variant of Solidity's
1012  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1013  * type.
1014  *
1015  * Maps have the following properties:
1016  *
1017  * - Entries are added, removed, and checked for existence in constant time
1018  * (O(1)).
1019  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1020  *
1021  * ```
1022  * contract Example {
1023  *     // Add the library methods
1024  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1025  *
1026  *     // Declare a set state variable
1027  *     EnumerableMap.UintToAddressMap private myMap;
1028  * }
1029  * ```
1030  *
1031  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1032  * supported.
1033  */
1034 library EnumerableMap {
1035     // To implement this library for multiple types with as little code
1036     // repetition as possible, we write it in terms of a generic Map type with
1037     // bytes32 keys and values.
1038     // The Map implementation uses private functions, and user-facing
1039     // implementations (such as Uint256ToAddressMap) are just wrappers around
1040     // the underlying Map.
1041     // This means that we can only create new EnumerableMaps for types that fit
1042     // in bytes32.
1043 
1044     struct MapEntry {
1045         bytes32 _key;
1046         bytes32 _value;
1047     }
1048 
1049     struct Map {
1050         // Storage of map keys and values
1051         MapEntry[] _entries;
1052 
1053         // Position of the entry defined by a key in the `entries` array, plus 1
1054         // because index 0 means a key is not in the map.
1055         mapping (bytes32 => uint256) _indexes;
1056     }
1057 
1058     /**
1059      * @dev Adds a key-value pair to a map, or updates the value for an existing
1060      * key. O(1).
1061      *
1062      * Returns true if the key was added to the map, that is if it was not
1063      * already present.
1064      */
1065     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1066         // We read and store the key's index to prevent multiple reads from the same storage slot
1067         uint256 keyIndex = map._indexes[key];
1068 
1069         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1070             map._entries.push(MapEntry({ _key: key, _value: value }));
1071             // The entry is stored at length-1, but we add 1 to all indexes
1072             // and use 0 as a sentinel value
1073             map._indexes[key] = map._entries.length;
1074             return true;
1075         } else {
1076             map._entries[keyIndex - 1]._value = value;
1077             return false;
1078         }
1079     }
1080 
1081     /**
1082      * @dev Removes a key-value pair from a map. O(1).
1083      *
1084      * Returns true if the key was removed from the map, that is if it was present.
1085      */
1086     function _remove(Map storage map, bytes32 key) private returns (bool) {
1087         // We read and store the key's index to prevent multiple reads from the same storage slot
1088         uint256 keyIndex = map._indexes[key];
1089 
1090         if (keyIndex != 0) { // Equivalent to contains(map, key)
1091             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1092             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1093             // This modifies the order of the array, as noted in {at}.
1094 
1095             uint256 toDeleteIndex = keyIndex - 1;
1096             uint256 lastIndex = map._entries.length - 1;
1097 
1098             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1099             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1100 
1101             MapEntry storage lastEntry = map._entries[lastIndex];
1102 
1103             // Move the last entry to the index where the entry to delete is
1104             map._entries[toDeleteIndex] = lastEntry;
1105             // Update the index for the moved entry
1106             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1107 
1108             // Delete the slot where the moved entry was stored
1109             map._entries.pop();
1110 
1111             // Delete the index for the deleted slot
1112             delete map._indexes[key];
1113 
1114             return true;
1115         } else {
1116             return false;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns true if the key is in the map. O(1).
1122      */
1123     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1124         return map._indexes[key] != 0;
1125     }
1126 
1127     /**
1128      * @dev Returns the number of key-value pairs in the map. O(1).
1129      */
1130     function _length(Map storage map) private view returns (uint256) {
1131         return map._entries.length;
1132     }
1133 
1134    /**
1135     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1136     *
1137     * Note that there are no guarantees on the ordering of entries inside the
1138     * array, and it may change when more entries are added or removed.
1139     *
1140     * Requirements:
1141     *
1142     * - `index` must be strictly less than {length}.
1143     */
1144     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1145         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1146 
1147         MapEntry storage entry = map._entries[index];
1148         return (entry._key, entry._value);
1149     }
1150 
1151     /**
1152      * @dev Tries to returns the value associated with `key`.  O(1).
1153      * Does not revert if `key` is not in the map.
1154      */
1155     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1156         uint256 keyIndex = map._indexes[key];
1157         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1158         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1159     }
1160 
1161     /**
1162      * @dev Returns the value associated with `key`.  O(1).
1163      *
1164      * Requirements:
1165      *
1166      * - `key` must be in the map.
1167      */
1168     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1169         uint256 keyIndex = map._indexes[key];
1170         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1171         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1172     }
1173 
1174     /**
1175      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1176      *
1177      * CAUTION: This function is deprecated because it requires allocating memory for the error
1178      * message unnecessarily. For custom revert reasons use {_tryGet}.
1179      */
1180     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1181         uint256 keyIndex = map._indexes[key];
1182         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1183         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1184     }
1185 
1186     // UintToAddressMap
1187 
1188     struct UintToAddressMap {
1189         Map _inner;
1190     }
1191 
1192     /**
1193      * @dev Adds a key-value pair to a map, or updates the value for an existing
1194      * key. O(1).
1195      *
1196      * Returns true if the key was added to the map, that is if it was not
1197      * already present.
1198      */
1199     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1200         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1201     }
1202 
1203     /**
1204      * @dev Removes a value from a set. O(1).
1205      *
1206      * Returns true if the key was removed from the map, that is if it was present.
1207      */
1208     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1209         return _remove(map._inner, bytes32(key));
1210     }
1211 
1212     /**
1213      * @dev Returns true if the key is in the map. O(1).
1214      */
1215     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1216         return _contains(map._inner, bytes32(key));
1217     }
1218 
1219     /**
1220      * @dev Returns the number of elements in the map. O(1).
1221      */
1222     function length(UintToAddressMap storage map) internal view returns (uint256) {
1223         return _length(map._inner);
1224     }
1225 
1226    /**
1227     * @dev Returns the element stored at position `index` in the set. O(1).
1228     * Note that there are no guarantees on the ordering of values inside the
1229     * array, and it may change when more values are added or removed.
1230     *
1231     * Requirements:
1232     *
1233     * - `index` must be strictly less than {length}.
1234     */
1235     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1236         (bytes32 key, bytes32 value) = _at(map._inner, index);
1237         return (uint256(key), address(uint160(uint256(value))));
1238     }
1239 
1240     /**
1241      * @dev Tries to returns the value associated with `key`.  O(1).
1242      * Does not revert if `key` is not in the map.
1243      *
1244      * _Available since v3.4._
1245      */
1246     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1247         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1248         return (success, address(uint160(uint256(value))));
1249     }
1250 
1251     /**
1252      * @dev Returns the value associated with `key`.  O(1).
1253      *
1254      * Requirements:
1255      *
1256      * - `key` must be in the map.
1257      */
1258     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1259         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1260     }
1261 
1262     /**
1263      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1264      *
1265      * CAUTION: This function is deprecated because it requires allocating memory for the error
1266      * message unnecessarily. For custom revert reasons use {tryGet}.
1267      */
1268     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1269         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1270     }
1271 }
1272 
1273 
1274 // File: @openzeppelin/contracts/utils/Strings.sol
1275 
1276 /**
1277  * @dev String operations.
1278  */
1279 library Strings {
1280     /**
1281      * @dev Converts a `uint256` to its ASCII `string` representation.
1282      */
1283     function toString(uint256 value) internal pure returns (string memory) {
1284         // Inspired by OraclizeAPI's implementation - MIT licence
1285         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1286 
1287         if (value == 0) {
1288             return "0";
1289         }
1290         uint256 temp = value;
1291         uint256 digits;
1292         while (temp != 0) {
1293             digits++;
1294             temp /= 10;
1295         }
1296         bytes memory buffer = new bytes(digits);
1297         uint256 index = digits - 1;
1298         temp = value;
1299         while (temp != 0) {
1300             buffer[index--] = bytes1(uint8(48 + temp % 10));
1301             temp /= 10;
1302         }
1303         return string(buffer);
1304     }
1305 
1306     
1307 }
1308 
1309 
1310 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1311 
1312 /**
1313  * @title ERC721 Non-Fungible Token Standard basic implementation
1314  * @dev see https://eips.ethereum.org/EIPS/eip-721
1315  */
1316 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1317     using SafeMath for uint256;
1318     using Address for address;
1319     using EnumerableSet for EnumerableSet.UintSet;
1320     using EnumerableMap for EnumerableMap.UintToAddressMap;
1321     using Strings for uint256;
1322 
1323     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1324     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1325     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1326 
1327     // Mapping from holder address to their (enumerable) set of owned tokens
1328     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1329 
1330     // Enumerable mapping from token ids to their owners
1331     EnumerableMap.UintToAddressMap private _tokenOwners;
1332 
1333     // Mapping from token ID to approved address
1334     mapping (uint256 => address) private _tokenApprovals;
1335 
1336     // Mapping from owner to operator approvals
1337     mapping (address => mapping (address => bool)) private _operatorApprovals;
1338 
1339     // Token name
1340     string private _name;
1341 
1342     // Token symbol
1343     string private _symbol;
1344 
1345     // Optional mapping for token URIs
1346     mapping (uint256 => string) private _tokenURIs;
1347 
1348     // Base URI
1349     string private _baseURI;
1350 
1351     /*
1352      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1353      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1354      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1355      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1356      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1357      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1358      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1359      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1360      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1361      *
1362      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1363      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1364      */
1365     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1366 
1367     /*
1368      *     bytes4(keccak256('name()')) == 0x06fdde03
1369      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1370      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1371      *
1372      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1373      */
1374     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1375 
1376     /*
1377      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1378      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1379      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1380      *
1381      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1382      */
1383     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1384 
1385     /**
1386      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1387      */
1388     constructor (string memory name_, string memory symbol_) {
1389         _name = name_;
1390         _symbol = symbol_;
1391 
1392         // register the supported interfaces to conform to ERC721 via ERC165
1393         _registerInterface(_INTERFACE_ID_ERC721);
1394         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1395         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-balanceOf}.
1400      */
1401     function balanceOf(address owner) public view virtual override returns (uint256) {
1402         require(owner != address(0), "ERC721: balance query for the zero address");
1403         return _holderTokens[owner].length();
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-ownerOf}.
1408      */
1409     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1410         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1411     }
1412 
1413     /**
1414      * @dev See {IERC721Metadata-name}.
1415      */
1416     function name() public view virtual override returns (string memory) {
1417         return _name;
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Metadata-symbol}.
1422      */
1423     function symbol() public view virtual override returns (string memory) {
1424         return _symbol;
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Metadata-tokenURI}.
1429      */
1430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1431         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1432 
1433         string memory _tokenURI = _tokenURIs[tokenId];
1434         string memory base = baseURI();
1435 
1436         // If there is no base URI, return the token URI.
1437         if (bytes(base).length == 0) {
1438             return _tokenURI;
1439         }
1440         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1441         if (bytes(_tokenURI).length > 0) {
1442             return string(abi.encodePacked(base, _tokenURI));
1443         }
1444         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1445         return string(abi.encodePacked(base, tokenId.toString()));
1446     }
1447 
1448     /**
1449     * @dev Returns the base URI set via {_setBaseURI}. This will be
1450     * automatically added as a prefix in {tokenURI} to each token's URI, or
1451     * to the token ID if no specific URI is set for that token ID.
1452     */
1453     function baseURI() public view virtual returns (string memory) {
1454         return _baseURI;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1459      */
1460     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1461         return _holderTokens[owner].at(index);
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Enumerable-totalSupply}.
1466      */
1467     function totalSupply() public view virtual override returns (uint256) {
1468         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1469         return _tokenOwners.length();
1470     }
1471 
1472     /**
1473      * @dev See {IERC721Enumerable-tokenByIndex}.
1474      */
1475     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1476         (uint256 tokenId, ) = _tokenOwners.at(index);
1477         return tokenId;
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-approve}.
1482      */
1483     function approve(address to, uint256 tokenId) public virtual override {
1484         address owner = ERC721.ownerOf(tokenId);
1485         require(to != owner, "ERC721: approval to current owner");
1486 
1487         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1488             "ERC721: approve caller is not owner nor approved for all"
1489         );
1490 
1491         _approve(to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-getApproved}.
1496      */
1497     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1498         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1499 
1500         return _tokenApprovals[tokenId];
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-setApprovalForAll}.
1505      */
1506     function setApprovalForAll(address operator, bool approved) public virtual override {
1507         require(operator != _msgSender(), "ERC721: approve to caller");
1508 
1509         _operatorApprovals[_msgSender()][operator] = approved;
1510         emit ApprovalForAll(_msgSender(), operator, approved);
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-isApprovedForAll}.
1515      */
1516     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1517         return _operatorApprovals[owner][operator];
1518     }
1519 
1520     /**
1521      * @dev See {IERC721-transferFrom}.
1522      */
1523     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1524         //solhint-disable-next-line max-line-length
1525         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1526 
1527         _transfer(from, to, tokenId);
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-safeTransferFrom}.
1532      */
1533     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1534         safeTransferFrom(from, to, tokenId, "");
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-safeTransferFrom}.
1539      */
1540     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1541         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1542         _safeTransfer(from, to, tokenId, _data);
1543     }
1544 
1545     /**
1546      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1547      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1548      *
1549      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1550      *
1551      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1552      * implement alternative mechanisms to perform token transfer, such as signature-based.
1553      *
1554      * Requirements:
1555      *
1556      * - `from` cannot be the zero address.
1557      * - `to` cannot be the zero address.
1558      * - `tokenId` token must exist and be owned by `from`.
1559      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1560      *
1561      * Emits a {Transfer} event.
1562      */
1563     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1564         _transfer(from, to, tokenId);
1565         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1566     }
1567 
1568     /**
1569      * @dev Returns whether `tokenId` exists.
1570      *
1571      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1572      *
1573      * Tokens start existing when they are minted (`_mint`),
1574      * and stop existing when they are burned (`_burn`).
1575      */
1576     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1577         return _tokenOwners.contains(tokenId);
1578     }
1579 
1580     /**
1581      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1582      *
1583      * Requirements:
1584      *
1585      * - `tokenId` must exist.
1586      */
1587     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1588         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1589         address owner = ERC721.ownerOf(tokenId);
1590         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1591     }
1592 
1593     /**
1594      * @dev Safely mints `tokenId` and transfers it to `to`.
1595      *
1596      * Requirements:
1597      d*
1598      * - `tokenId` must not exist.
1599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function _safeMint(address to, uint256 tokenId) internal virtual {
1604         _safeMint(to, tokenId, "");
1605     }
1606 
1607     /**
1608      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1609      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1610      */
1611     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1612         _mint(to, tokenId);
1613         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1614     }
1615 
1616     /**
1617      * @dev Mints `tokenId` and transfers it to `to`.
1618      *
1619      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must not exist.
1624      * - `to` cannot be the zero address.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function _mint(address to, uint256 tokenId) internal virtual {
1629         require(to != address(0), "ERC721: mint to the zero address");
1630         require(!_exists(tokenId), "ERC721: token already minted");
1631 
1632         _beforeTokenTransfer(address(0), to, tokenId);
1633 
1634         _holderTokens[to].add(tokenId);
1635 
1636         _tokenOwners.set(tokenId, to);
1637 
1638         emit Transfer(address(0), to, tokenId);
1639     }
1640 
1641     /**
1642      * @dev Destroys `tokenId`.
1643      * The approval is cleared when the token is burned.
1644      *
1645      * Requirements:
1646      *
1647      * - `tokenId` must exist.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function _burn(uint256 tokenId) internal virtual {
1652         address owner = ERC721.ownerOf(tokenId); // internal owner
1653 
1654         _beforeTokenTransfer(owner, address(0), tokenId);
1655 
1656         // Clear approvals
1657         _approve(address(0), tokenId);
1658 
1659         // Clear metadata (if any)
1660         if (bytes(_tokenURIs[tokenId]).length != 0) {
1661             delete _tokenURIs[tokenId];
1662         }
1663 
1664         _holderTokens[owner].remove(tokenId);
1665 
1666         _tokenOwners.remove(tokenId);
1667 
1668         emit Transfer(owner, address(0), tokenId);
1669     }
1670 
1671     /**
1672      * @dev Transfers `tokenId` from `from` to `to`.
1673      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1674      *
1675      * Requirements:
1676      *
1677      * - `to` cannot be the zero address.
1678      * - `tokenId` token must be owned by `from`.
1679      *
1680      * Emits a {Transfer} event.
1681      */
1682     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1683         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1684         require(to != address(0), "ERC721: transfer to the zero address");
1685 
1686         _beforeTokenTransfer(from, to, tokenId);
1687 
1688         // Clear approvals from the previous owner
1689         _approve(address(0), tokenId);
1690 
1691         _holderTokens[from].remove(tokenId);
1692         _holderTokens[to].add(tokenId);
1693 
1694         _tokenOwners.set(tokenId, to);
1695 
1696         emit Transfer(from, to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1701      *
1702      * Requirements:
1703      *
1704      * - `tokenId` must exist.
1705      */
1706     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1707         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1708         _tokenURIs[tokenId] = _tokenURI;
1709     }
1710 
1711     /**
1712      * @dev Internal function to set the base URI for all token IDs. It is
1713      * automatically added as a prefix to the value returned in {tokenURI},
1714      * or to the token ID if {tokenURI} is empty.
1715      */
1716     function _setBaseURI(string memory baseURI_) internal virtual {
1717         _baseURI = baseURI_;
1718     }
1719 
1720     /**
1721      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1722      * The call is not executed if the target address is not a contract.
1723      *
1724      * @param from address representing the previous owner of the given token ID
1725      * @param to target address that will receive the tokens
1726      * @param tokenId uint256 ID of the token to be transferred
1727      * @param _data bytes optional data to send along with the call
1728      * @return bool whether the call correctly returned the expected magic value
1729      */
1730     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1731         private returns (bool)
1732     {
1733         if (!to.isContract()) {
1734             return true;
1735         }
1736         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1737             IERC721Receiver(to).onERC721Received.selector,
1738             _msgSender(),
1739             from,
1740             tokenId,
1741             _data
1742         ), "ERC721: transfer to non ERC721Receiver implementer");
1743         bytes4 retval = abi.decode(returndata, (bytes4));
1744         return (retval == _ERC721_RECEIVED);
1745     }
1746 
1747     /**
1748      * @dev Approve `to` to operate on `tokenId`
1749      *
1750      * Emits an {Approval} event.
1751      */
1752     function _approve(address to, uint256 tokenId) internal virtual {
1753         _tokenApprovals[tokenId] = to;
1754         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1755     }
1756 
1757     /**
1758      * @dev Hook that is called before any token transfer. This includes minting
1759      * and burning.
1760      *
1761      * Calling conditions:
1762      *
1763      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1764      * transferred to `to`.
1765      * - When `from` is zero, `tokenId` will be minted for `to`.
1766      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1767      * - `from` cannot be the zero address.
1768      * - `to` cannot be the zero address.
1769      *
1770      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1771      */
1772     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1773 }
1774 
1775 
1776 // File: @openzeppelin/contracts/access/Ownable.sol
1777 
1778 /**
1779  * @dev Contract module which provides a basic access control mechanism, where
1780  * there is an account (an owner) that can be granted exclusive access to
1781  * specific functions.
1782  *
1783  * By default, the owner account will be the one that deploys the contract. This
1784  * can later be changed with {transferOwnership}.
1785  *
1786  * This module is used through inheritance. It will make available the modifier
1787  * `onlyOwner`, which can be applied to your functions to restrict their use to
1788  * the owner.
1789  */
1790 abstract contract Ownable is Context {
1791     address private _owner;
1792 
1793     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1794 
1795     /**
1796      * @dev Initializes the contract setting the deployer as the initial owner.
1797      */
1798     constructor () {
1799         address msgSender = _msgSender();
1800         _owner = msgSender;
1801         emit OwnershipTransferred(address(0), msgSender);
1802     }
1803 
1804     /**
1805      * @dev Returns the address of the current owner.
1806      */
1807     function owner() public view virtual returns (address) {
1808         return _owner;
1809     }
1810 
1811     /**
1812      * @dev Throws if called by any account other than the owner.
1813      */
1814     modifier onlyOwner() {
1815         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1816         _;
1817     }
1818 
1819     /**
1820      * @dev Leaves the contract without owner. It will not be possible to call
1821      * `onlyOwner` functions anymore. Can only be called by the current owner.
1822      *
1823      * NOTE: Renouncing ownership will leave the contract without an owner,
1824      * thereby removing any functionality that is only available to the owner.
1825      */
1826     function renounceOwnership() public virtual onlyOwner {
1827         emit OwnershipTransferred(_owner, address(0));
1828         _owner = address(0);
1829     }
1830 
1831     /**
1832      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1833      * Can only be called by the current owner.
1834      */
1835     function transferOwnership(address newOwner) public virtual onlyOwner {
1836         require(newOwner != address(0), "Ownable: new owner is the zero address");
1837         emit OwnershipTransferred(_owner, newOwner);
1838         _owner = newOwner;
1839     }
1840 }
1841 
1842 
1843 // File: contracts/CryptoSquatches.sol
1844 
1845 /**
1846  * @title CryptoSquatches contract
1847  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1848  */
1849 contract CryptoSquatches is ERC721, Ownable {
1850     using SafeMath for uint256;
1851 
1852     uint256 public startingIndexBlock;
1853     uint256 public startingIndex;
1854     uint256 public mintPrice;
1855     uint256 public maxToMint;
1856     uint256 public MAX_CRYPTO_SQUATCH_SUPPLY;
1857     uint256 public REVEAL_TIMESTAMP;
1858     string public prerevealURI;
1859 
1860     string public PROVENANCE_HASH = "";
1861     bool public saleIsActive;
1862 
1863     address wallet1;
1864     address wallet2;
1865 
1866     constructor() ERC721("Crypto Squatches", "CSQUATCH") {
1867         MAX_CRYPTO_SQUATCH_SUPPLY = 10000;
1868         REVEAL_TIMESTAMP = block.timestamp + (86400 * 2);
1869         mintPrice = 50000000000000000; // 0.05 ETH
1870         maxToMint = 10;
1871         saleIsActive = false;
1872         wallet1 = 0x5179cc5B74b9a77d0a04aa50Dfc557E62f82e449;
1873         wallet2 = 0x3DFd8477b5fD8b3615B47740d74DB4C028A0Da58;
1874     }
1875 
1876     /**
1877      * Get the array of token for owner.
1878      */
1879     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1880         uint256 tokenCount = balanceOf(_owner);
1881         if (tokenCount == 0) {
1882             return new uint256[](0);
1883         } else {
1884             uint256[] memory result = new uint256[](tokenCount);
1885             for (uint256 index; index < tokenCount; index++) {
1886                 result[index] = tokenOfOwnerByIndex(_owner, index);
1887             }
1888             return result;
1889         }
1890     }
1891 
1892     /**
1893     * MUST TURN INTO LIBRARY BEFORE LIVE DEPLOYMENT!!!!!
1894      */
1895     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1896         if (_i == 0) {
1897             return "0";
1898         }
1899         uint j = _i;
1900         uint len;
1901         while (j != 0) {
1902             len++;
1903             j /= 10;
1904         }
1905         bytes memory bstr = new bytes(len);
1906         uint k = len;
1907         while (_i != 0) {
1908             k = k-1;
1909             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1910             bytes1 b1 = bytes1(temp);
1911             bstr[k] = b1;
1912             _i /= 10;
1913         }
1914         return string(bstr);
1915     }
1916 
1917     /**
1918      * Check if certain token id is exists.
1919      */
1920     function exists(uint256 _tokenId) public view returns (bool) {
1921         return _exists(_tokenId);
1922     }
1923 
1924     /**
1925      * Set price to mint a Crypto Squatch.
1926      */
1927     function setMintPrice(uint256 _price) external onlyOwner {
1928         mintPrice = _price;
1929     }
1930 
1931     /**
1932      * Set maximum count to mint per once.
1933      */
1934     function setMaxToMint(uint256 _maxValue) external onlyOwner {
1935         maxToMint = _maxValue;
1936     }
1937 
1938     /**
1939      * Mint Crypto Squatches by owner
1940      */
1941     function reserveCryptoSquatches(address _to, uint256 _numberOfTokens) external onlyOwner {
1942         require(_to != address(0), "Invalid address to reserve.");
1943 
1944         uint256 supply = totalSupply();
1945         uint256 i;
1946 
1947         
1948         //Mint address, 0 on first mint
1949         //Supply is 1 so mint tokenId = 1 (which is the 2nd token)
1950         for (i = 0; i < _numberOfTokens; i++) {
1951             _safeMint(_to, supply + i);
1952         }
1953 
1954     }
1955 
1956     /**
1957      * Set reveal timestamp when finished the sale.
1958      */
1959     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner {
1960         REVEAL_TIMESTAMP = _revealTimeStamp;
1961     } 
1962 
1963     /*     
1964     * Set provenance once it's calculated
1965     */
1966     function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
1967         PROVENANCE_HASH = _provenanceHash;
1968     }
1969 
1970     function setBaseURI(string memory baseURI) external onlyOwner {
1971         _setBaseURI(baseURI);
1972     }
1973 
1974      /**
1975      * External function to set the prereveal URI for all token IDs. 
1976      * This is the URI that is shown on each token until the REVEAL_TIMESTAMP
1977      * is surpassed.
1978      */
1979     function setPrerevealURI(string memory prerevealURI_) external onlyOwner {
1980         prerevealURI = prerevealURI_;
1981     }
1982 
1983     /**
1984     * Returns the proper tokenURI only after the startingIndex is finalized.
1985     */
1986     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1987         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1988 
1989         if(startingIndex != 0 && block.timestamp >= REVEAL_TIMESTAMP)
1990         {
1991             string memory base = baseURI();
1992             string memory tokenURIWithOffset = uint2str(((tokenId + startingIndex) % MAX_CRYPTO_SQUATCH_SUPPLY));
1993             return string(abi.encodePacked(base, tokenURIWithOffset));
1994         }
1995         else
1996         {
1997             return prerevealURI;
1998         }
1999     }
2000 
2001     /*
2002     * Pause sale if active, make active if paused
2003     */
2004     function setSaleState() external onlyOwner {
2005         saleIsActive = !saleIsActive;
2006     }
2007 
2008     /**
2009     * Mints tokens
2010     */
2011     function mintCryptoSquatches(uint256 numberOfTokens) external payable {
2012         require(saleIsActive, "Sale must be active to mint");
2013         require(numberOfTokens <= maxToMint, "Invalid amount to mint per once");
2014         require(totalSupply().add(numberOfTokens) <= MAX_CRYPTO_SQUATCH_SUPPLY, "Purchase would exceed max supply");
2015         require(mintPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2016         
2017         for(uint256 i = 0; i < numberOfTokens; i++) {
2018             uint256 mintIndex = totalSupply();
2019             if (totalSupply() < MAX_CRYPTO_SQUATCH_SUPPLY) {
2020                 _safeMint(msg.sender, mintIndex);
2021             }
2022         }
2023 
2024         // If we haven't set the starting index and this is either
2025         // 1) the last saleable token or 2) the first token to be sold after
2026         // the end of pre-sale, set the starting index block
2027         if (startingIndexBlock == 0 && (totalSupply() == MAX_CRYPTO_SQUATCH_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
2028             startingIndexBlock = block.number;
2029         } 
2030     }
2031 
2032     /**
2033      * Set the starting index for the collection
2034      */
2035     function setStartingIndex() external {
2036         require(startingIndex == 0, "Starting index is already set");
2037         require(startingIndexBlock != 0, "Starting index block must be set");
2038         
2039         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_CRYPTO_SQUATCH_SUPPLY;
2040         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2041         if (block.number.sub(startingIndexBlock) > 255) {
2042             startingIndex = uint256(blockhash(block.number - 1)) % MAX_CRYPTO_SQUATCH_SUPPLY;
2043         }
2044         // Prevent default sequence
2045         if (startingIndex == 0) {
2046             startingIndex = startingIndex.add(1);
2047         }
2048     }
2049 
2050     /**
2051      * Set the starting index block for the collection, essentially unblocking
2052      * setting starting index
2053      */
2054     function emergencySetStartingIndexBlock() external onlyOwner {
2055         require(startingIndex == 0, "Starting index is already set");
2056         
2057         startingIndexBlock = block.number;
2058     }
2059 
2060     function withdraw() external onlyOwner {
2061         uint256 balance = address(this).balance;
2062         uint256 walletBalance = balance.mul(50).div(100);
2063         payable(wallet1).transfer(walletBalance);
2064         payable(wallet2).transfer(balance.sub(walletBalance));
2065     }
2066 }