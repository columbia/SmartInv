1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.7.6;
4 
5 
6  //  author Name: Srihari Kapu 
7  //  author-email: <sri@sriharikapu.com>
8  //  author-website: http://www.sriharikapu.com
9 
10 // File: @openzeppelin/contracts/utils/Context.sol
11 
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/introspection/IERC165.sol
35 
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
58 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193 
194     /**
195      * @dev Returns the token collection name.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the token collection symbol.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
206      */
207     function tokenURI(uint256 tokenId) external view returns (string memory);
208 }
209 
210 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
211 
212 
213 /**
214  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
215  * @dev See https://eips.ethereum.org/EIPS/eip-721
216  */
217 interface IERC721Enumerable is IERC721 {
218 
219     /**
220      * @dev Returns the total amount of tokens stored by the contract.
221      */
222     function totalSupply() external view returns (uint256);
223 
224     /**
225      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
226      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
227      */
228     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
229 
230     /**
231      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
232      * Use along with {totalSupply} to enumerate all tokens.
233      */
234     function tokenByIndex(uint256 index) external view returns (uint256);
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
238 
239 
240 /**
241  * @title ERC721 token receiver interface
242  * @dev Interface for any contract that wants to support safeTransfers
243  * from ERC721 asset contracts.
244  */
245 interface IERC721Receiver {
246     /**
247      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
248      * by `operator` from `from`, this function is called.
249      *
250      * It must return its Solidity selector to confirm the token transfer.
251      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
252      *
253      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
254      */
255     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/introspection/ERC165.sol
259 
260 
261 /**
262  * @dev Implementation of the {IERC165} interface.
263  *
264  * Contracts may inherit from this and call {_registerInterface} to declare
265  * their support of an interface.
266  */
267 abstract contract ERC165 is IERC165 {
268     /*
269      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
270      */
271     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
272 
273     /**
274      * @dev Mapping of interface ids to whether or not it's supported.
275      */
276     mapping(bytes4 => bool) private _supportedInterfaces;
277 
278     constructor () internal {
279         // Derived contracts need only register support for their own interfaces,
280         // we register support for ERC165 itself here
281         _registerInterface(_INTERFACE_ID_ERC165);
282     }
283 
284     /**
285      * @dev See {IERC165-supportsInterface}.
286      *
287      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
290         return _supportedInterfaces[interfaceId];
291     }
292 
293     /**
294      * @dev Registers the contract as an implementer of the interface defined by
295      * `interfaceId`. Support of the actual ERC165 interface is automatic and
296      * registering its interface id is not required.
297      *
298      * See {IERC165-supportsInterface}.
299      *
300      * Requirements:
301      *
302      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
303      */
304     function _registerInterface(bytes4 interfaceId) internal virtual {
305         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
306         _supportedInterfaces[interfaceId] = true;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/math/SafeMath.sol
311 
312 
313 /**
314  * @dev Wrappers over Solidity's arithmetic operations with added overflow
315  * checks.
316  *
317  * Arithmetic operations in Solidity wrap on overflow. This can easily result
318  * in bugs, because programmers usually assume that an overflow raises an
319  * error, which is the standard behavior in high level programming languages.
320  * `SafeMath` restores this intuition by reverting the transaction when an
321  * operation overflows.
322  *
323  * Using this library instead of the unchecked operations eliminates an entire
324  * class of bugs, so it's recommended to use it always.
325  */
326 library SafeMath {
327     /**
328      * @dev Returns the addition of two unsigned integers, with an overflow flag.
329      *
330      * _Available since v3.4._
331      */
332     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
333         uint256 c = a + b;
334         if (c < a) return (false, 0);
335         return (true, c);
336     }
337 
338     /**
339      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         if (b > a) return (false, 0);
345         return (true, a - b);
346     }
347 
348     /**
349      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
350      *
351      * _Available since v3.4._
352      */
353     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355         // benefit is lost if 'b' is also tested.
356         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357         if (a == 0) return (true, 0);
358         uint256 c = a * b;
359         if (c / a != b) return (false, 0);
360         return (true, c);
361     }
362 
363     /**
364      * @dev Returns the division of two unsigned integers, with a division by zero flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         if (b == 0) return (false, 0);
370         return (true, a / b);
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
375      *
376      * _Available since v3.4._
377      */
378     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
379         if (b == 0) return (false, 0);
380         return (true, a % b);
381     }
382 
383     /**
384      * @dev Returns the addition of two unsigned integers, reverting on
385      * overflow.
386      *
387      * Counterpart to Solidity's `+` operator.
388      *
389      * Requirements:
390      *
391      * - Addition cannot overflow.
392      */
393     function add(uint256 a, uint256 b) internal pure returns (uint256) {
394         uint256 c = a + b;
395         require(c >= a, "SafeMath: addition overflow");
396         return c;
397     }
398 
399     /**
400      * @dev Returns the subtraction of two unsigned integers, reverting on
401      * overflow (when the result is negative).
402      *
403      * Counterpart to Solidity's `-` operator.
404      *
405      * Requirements:
406      *
407      * - Subtraction cannot overflow.
408      */
409     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
410         require(b <= a, "SafeMath: subtraction overflow");
411         return a - b;
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `*` operator.
419      *
420      * Requirements:
421      *
422      * - Multiplication cannot overflow.
423      */
424     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
425         if (a == 0) return 0;
426         uint256 c = a * b;
427         require(c / a == b, "SafeMath: multiplication overflow");
428         return c;
429     }
430 
431     /**
432      * @dev Returns the integer division of two unsigned integers, reverting on
433      * division by zero. The result is rounded towards zero.
434      *
435      * Counterpart to Solidity's `/` operator. Note: this function uses a
436      * `revert` opcode (which leaves remaining gas untouched) while Solidity
437      * uses an invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      *
441      * - The divisor cannot be zero.
442      */
443     function div(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b > 0, "SafeMath: division by zero");
445         return a / b;
446     }
447 
448     /**
449      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
450      * reverting when dividing by zero.
451      *
452      * Counterpart to Solidity's `%` operator. This function uses a `revert`
453      * opcode (which leaves remaining gas untouched) while Solidity uses an
454      * invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
461         require(b > 0, "SafeMath: modulo by zero");
462         return a % b;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
467      * overflow (when the result is negative).
468      *
469      * CAUTION: This function is deprecated because it requires allocating memory for the error
470      * message unnecessarily. For custom revert reasons use {trySub}.
471      *
472      * Counterpart to Solidity's `-` operator.
473      *
474      * Requirements:
475      *
476      * - Subtraction cannot overflow.
477      */
478     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         require(b <= a, errorMessage);
480         return a - b;
481     }
482 
483     /**
484      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
485      * division by zero. The result is rounded towards zero.
486      *
487      * CAUTION: This function is deprecated because it requires allocating memory for the error
488      * message unnecessarily. For custom revert reasons use {tryDiv}.
489      *
490      * Counterpart to Solidity's `/` operator. Note: this function uses a
491      * `revert` opcode (which leaves remaining gas untouched) while Solidity
492      * uses an invalid opcode to revert (consuming all remaining gas).
493      *
494      * Requirements:
495      *
496      * - The divisor cannot be zero.
497      */
498     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b > 0, errorMessage);
500         return a / b;
501     }
502 
503     /**
504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
505      * reverting with custom message when dividing by zero.
506      *
507      * CAUTION: This function is deprecated because it requires allocating memory for the error
508      * message unnecessarily. For custom revert reasons use {tryMod}.
509      *
510      * Counterpart to Solidity's `%` operator. This function uses a `revert`
511      * opcode (which leaves remaining gas untouched) while Solidity uses an
512      * invalid opcode to revert (consuming all remaining gas).
513      *
514      * Requirements:
515      *
516      * - The divisor cannot be zero.
517      */
518     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
519         require(b > 0, errorMessage);
520         return a % b;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/utils/Address.sol
525 
526 
527 /**
528  * @dev Collection of functions related to the address type
529  */
530 library Address {
531     /**
532      * @dev Returns true if `account` is a contract.
533      *
534      * [IMPORTANT]
535      * ====
536      * It is unsafe to assume that an address for which this function returns
537      * false is an externally-owned account (EOA) and not a contract.
538      *
539      * Among others, `isContract` will return false for the following
540      * types of addresses:
541      *
542      *  - an externally-owned account
543      *  - a contract in construction
544      *  - an address where a contract will be created
545      *  - an address where a contract lived, but was destroyed
546      * ====
547      */
548     function isContract(address account) internal view returns (bool) {
549         // This method relies on extcodesize, which returns 0 for contracts in
550         // construction, since the code is only stored at the end of the
551         // constructor execution.
552 
553         uint256 size;
554         // solhint-disable-next-line no-inline-assembly
555         assembly { size := extcodesize(account) }
556         return size > 0;
557     }
558 
559     /**
560      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
561      * `recipient`, forwarding all available gas and reverting on errors.
562      *
563      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
564      * of certain opcodes, possibly making contracts go over the 2300 gas limit
565      * imposed by `transfer`, making them unable to receive funds via
566      * `transfer`. {sendValue} removes this limitation.
567      *
568      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
569      *
570      * IMPORTANT: because control is transferred to `recipient`, care must be
571      * taken to not create reentrancy vulnerabilities. Consider using
572      * {ReentrancyGuard} or the
573      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
574      */
575     function sendValue(address payable recipient, uint256 amount) internal {
576         require(address(this).balance >= amount, "Address: insufficient balance");
577 
578         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
579         (bool success, ) = recipient.call{ value: amount }("");
580         require(success, "Address: unable to send value, recipient may have reverted");
581     }
582 
583     /**
584      * @dev Performs a Solidity function call using a low level `call`. A
585      * plain`call` is an unsafe replacement for a function call: use this
586      * function instead.
587      *
588      * If `target` reverts with a revert reason, it is bubbled up by this
589      * function (like regular Solidity function calls).
590      *
591      * Returns the raw returned data. To convert to the expected return value,
592      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
593      *
594      * Requirements:
595      *
596      * - `target` must be a contract.
597      * - calling `target` with `data` must not revert.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
602       return functionCall(target, data, "Address: low-level call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
607      * `errorMessage` as a fallback revert reason when `target` reverts.
608      *
609      * _Available since v3.1._
610      */
611     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
612         return functionCallWithValue(target, data, 0, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but also transferring `value` wei to `target`.
618      *
619      * Requirements:
620      *
621      * - the calling contract must have an ETH balance of at least `value`.
622      * - the called Solidity function must be `payable`.
623      *
624      * _Available since v3.1._
625      */
626     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
627         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
632      * with `errorMessage` as a fallback revert reason when `target` reverts.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
637         require(address(this).balance >= value, "Address: insufficient balance for call");
638         require(isContract(target), "Address: call to non-contract");
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = target.call{ value: value }(data);
642         return _verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a static call.
648      *
649      * _Available since v3.3._
650      */
651     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
652         return functionStaticCall(target, data, "Address: low-level static call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a static call.
658      *
659      * _Available since v3.3._
660      */
661     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
662         require(isContract(target), "Address: static call to non-contract");
663 
664         // solhint-disable-next-line avoid-low-level-calls
665         (bool success, bytes memory returndata) = target.staticcall(data);
666         return _verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
676         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
681      * but performing a delegate call.
682      *
683      * _Available since v3.4._
684      */
685     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
686         require(isContract(target), "Address: delegate call to non-contract");
687 
688         // solhint-disable-next-line avoid-low-level-calls
689         (bool success, bytes memory returndata) = target.delegatecall(data);
690         return _verifyCallResult(success, returndata, errorMessage);
691     }
692 
693     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
694         if (success) {
695             return returndata;
696         } else {
697             // Look for revert reason and bubble it up if present
698             if (returndata.length > 0) {
699                 // The easiest way to bubble the revert reason is using memory via assembly
700 
701                 // solhint-disable-next-line no-inline-assembly
702                 assembly {
703                     let returndata_size := mload(returndata)
704                     revert(add(32, returndata), returndata_size)
705                 }
706             } else {
707                 revert(errorMessage);
708             }
709         }
710     }
711 }
712 
713 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
714 
715 
716 /**
717  * @dev Library for managing
718  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
719  * types.
720  *
721  * Sets have the following properties:
722  *
723  * - Elements are added, removed, and checked for existence in constant time
724  * (O(1)).
725  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
726  *
727  * ```
728  * contract Example {
729  *     // Add the library methods
730  *     using EnumerableSet for EnumerableSet.AddressSet;
731  *
732  *     // Declare a set state variable
733  *     EnumerableSet.AddressSet private mySet;
734  * }
735  * ```
736  *
737  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
738  * and `uint256` (`UintSet`) are supported.
739  */
740 library EnumerableSet {
741     // To implement this library for multiple types with as little code
742     // repetition as possible, we write it in terms of a generic Set type with
743     // bytes32 values.
744     // The Set implementation uses private functions, and user-facing
745     // implementations (such as AddressSet) are just wrappers around the
746     // underlying Set.
747     // This means that we can only create new EnumerableSets for types that fit
748     // in bytes32.
749 
750     struct Set {
751         // Storage of set values
752         bytes32[] _values;
753 
754         // Position of the value in the `values` array, plus 1 because index 0
755         // means a value is not in the set.
756         mapping (bytes32 => uint256) _indexes;
757     }
758 
759     /**
760      * @dev Add a value to a set. O(1).
761      *
762      * Returns true if the value was added to the set, that is if it was not
763      * already present.
764      */
765     function _add(Set storage set, bytes32 value) private returns (bool) {
766         if (!_contains(set, value)) {
767             set._values.push(value);
768             // The value is stored at length-1, but we add 1 to all indexes
769             // and use 0 as a sentinel value
770             set._indexes[value] = set._values.length;
771             return true;
772         } else {
773             return false;
774         }
775     }
776 
777     /**
778      * @dev Removes a value from a set. O(1).
779      *
780      * Returns true if the value was removed from the set, that is if it was
781      * present.
782      */
783     function _remove(Set storage set, bytes32 value) private returns (bool) {
784         // We read and store the value's index to prevent multiple reads from the same storage slot
785         uint256 valueIndex = set._indexes[value];
786 
787         if (valueIndex != 0) { // Equivalent to contains(set, value)
788             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
789             // the array, and then remove the last element (sometimes called as 'swap and pop').
790             // This modifies the order of the array, as noted in {at}.
791 
792             uint256 toDeleteIndex = valueIndex - 1;
793             uint256 lastIndex = set._values.length - 1;
794 
795             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
796             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
797 
798             bytes32 lastvalue = set._values[lastIndex];
799 
800             // Move the last value to the index where the value to delete is
801             set._values[toDeleteIndex] = lastvalue;
802             // Update the index for the moved value
803             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
804 
805             // Delete the slot where the moved value was stored
806             set._values.pop();
807 
808             // Delete the index for the deleted slot
809             delete set._indexes[value];
810 
811             return true;
812         } else {
813             return false;
814         }
815     }
816 
817     /**
818      * @dev Returns true if the value is in the set. O(1).
819      */
820     function _contains(Set storage set, bytes32 value) private view returns (bool) {
821         return set._indexes[value] != 0;
822     }
823 
824     /**
825      * @dev Returns the number of values on the set. O(1).
826      */
827     function _length(Set storage set) private view returns (uint256) {
828         return set._values.length;
829     }
830 
831    /**
832     * @dev Returns the value stored at position `index` in the set. O(1).
833     *
834     * Note that there are no guarantees on the ordering of values inside the
835     * array, and it may change when more values are added or removed.
836     *
837     * Requirements:
838     *
839     * - `index` must be strictly less than {length}.
840     */
841     function _at(Set storage set, uint256 index) private view returns (bytes32) {
842         require(set._values.length > index, "EnumerableSet: index out of bounds");
843         return set._values[index];
844     }
845 
846     // Bytes32Set
847 
848     struct Bytes32Set {
849         Set _inner;
850     }
851 
852     /**
853      * @dev Add a value to a set. O(1).
854      *
855      * Returns true if the value was added to the set, that is if it was not
856      * already present.
857      */
858     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
859         return _add(set._inner, value);
860     }
861 
862     /**
863      * @dev Removes a value from a set. O(1).
864      *
865      * Returns true if the value was removed from the set, that is if it was
866      * present.
867      */
868     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
869         return _remove(set._inner, value);
870     }
871 
872     /**
873      * @dev Returns true if the value is in the set. O(1).
874      */
875     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
876         return _contains(set._inner, value);
877     }
878 
879     /**
880      * @dev Returns the number of values in the set. O(1).
881      */
882     function length(Bytes32Set storage set) internal view returns (uint256) {
883         return _length(set._inner);
884     }
885 
886    /**
887     * @dev Returns the value stored at position `index` in the set. O(1).
888     *
889     * Note that there are no guarantees on the ordering of values inside the
890     * array, and it may change when more values are added or removed.
891     *
892     * Requirements:
893     *
894     * - `index` must be strictly less than {length}.
895     */
896     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
897         return _at(set._inner, index);
898     }
899 
900     // AddressSet
901 
902     struct AddressSet {
903         Set _inner;
904     }
905 
906     /**
907      * @dev Add a value to a set. O(1).
908      *
909      * Returns true if the value was added to the set, that is if it was not
910      * already present.
911      */
912     function add(AddressSet storage set, address value) internal returns (bool) {
913         return _add(set._inner, bytes32(uint256(uint160(value))));
914     }
915 
916     /**
917      * @dev Removes a value from a set. O(1).
918      *
919      * Returns true if the value was removed from the set, that is if it was
920      * present.
921      */
922     function remove(AddressSet storage set, address value) internal returns (bool) {
923         return _remove(set._inner, bytes32(uint256(uint160(value))));
924     }
925 
926     /**
927      * @dev Returns true if the value is in the set. O(1).
928      */
929     function contains(AddressSet storage set, address value) internal view returns (bool) {
930         return _contains(set._inner, bytes32(uint256(uint160(value))));
931     }
932 
933     /**
934      * @dev Returns the number of values in the set. O(1).
935      */
936     function length(AddressSet storage set) internal view returns (uint256) {
937         return _length(set._inner);
938     }
939 
940    /**
941     * @dev Returns the value stored at position `index` in the set. O(1).
942     *
943     * Note that there are no guarantees on the ordering of values inside the
944     * array, and it may change when more values are added or removed.
945     *
946     * Requirements:
947     *
948     * - `index` must be strictly less than {length}.
949     */
950     function at(AddressSet storage set, uint256 index) internal view returns (address) {
951         return address(uint160(uint256(_at(set._inner, index))));
952     }
953 
954 
955     // UintSet
956 
957     struct UintSet {
958         Set _inner;
959     }
960 
961     /**
962      * @dev Add a value to a set. O(1).
963      *
964      * Returns true if the value was added to the set, that is if it was not
965      * already present.
966      */
967     function add(UintSet storage set, uint256 value) internal returns (bool) {
968         return _add(set._inner, bytes32(value));
969     }
970 
971     /**
972      * @dev Removes a value from a set. O(1).
973      *
974      * Returns true if the value was removed from the set, that is if it was
975      * present.
976      */
977     function remove(UintSet storage set, uint256 value) internal returns (bool) {
978         return _remove(set._inner, bytes32(value));
979     }
980 
981     /**
982      * @dev Returns true if the value is in the set. O(1).
983      */
984     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
985         return _contains(set._inner, bytes32(value));
986     }
987 
988     /**
989      * @dev Returns the number of values on the set. O(1).
990      */
991     function length(UintSet storage set) internal view returns (uint256) {
992         return _length(set._inner);
993     }
994 
995    /**
996     * @dev Returns the value stored at position `index` in the set. O(1).
997     *
998     * Note that there are no guarantees on the ordering of values inside the
999     * array, and it may change when more values are added or removed.
1000     *
1001     * Requirements:
1002     *
1003     * - `index` must be strictly less than {length}.
1004     */
1005     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1006         return uint256(_at(set._inner, index));
1007     }
1008 }
1009 
1010 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1011 
1012 /**
1013  * @dev Library for managing an enumerable variant of Solidity's
1014  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1015  * type.
1016  *
1017  * Maps have the following properties:
1018  *
1019  * - Entries are added, removed, and checked for existence in constant time
1020  * (O(1)).
1021  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1022  *
1023  * ```
1024  * contract Example {
1025  *     // Add the library methods
1026  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1027  *
1028  *     // Declare a set state variable
1029  *     EnumerableMap.UintToAddressMap private myMap;
1030  * }
1031  * ```
1032  *
1033  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1034  * supported.
1035  */
1036 library EnumerableMap {
1037     // To implement this library for multiple types with as little code
1038     // repetition as possible, we write it in terms of a generic Map type with
1039     // bytes32 keys and values.
1040     // The Map implementation uses private functions, and user-facing
1041     // implementations (such as Uint256ToAddressMap) are just wrappers around
1042     // the underlying Map.
1043     // This means that we can only create new EnumerableMaps for types that fit
1044     // in bytes32.
1045 
1046     struct MapEntry {
1047         bytes32 _key;
1048         bytes32 _value;
1049     }
1050 
1051     struct Map {
1052         // Storage of map keys and values
1053         MapEntry[] _entries;
1054 
1055         // Position of the entry defined by a key in the `entries` array, plus 1
1056         // because index 0 means a key is not in the map.
1057         mapping (bytes32 => uint256) _indexes;
1058     }
1059 
1060     /**
1061      * @dev Adds a key-value pair to a map, or updates the value for an existing
1062      * key. O(1).
1063      *
1064      * Returns true if the key was added to the map, that is if it was not
1065      * already present.
1066      */
1067     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1068         // We read and store the key's index to prevent multiple reads from the same storage slot
1069         uint256 keyIndex = map._indexes[key];
1070 
1071         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1072             map._entries.push(MapEntry({ _key: key, _value: value }));
1073             // The entry is stored at length-1, but we add 1 to all indexes
1074             // and use 0 as a sentinel value
1075             map._indexes[key] = map._entries.length;
1076             return true;
1077         } else {
1078             map._entries[keyIndex - 1]._value = value;
1079             return false;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Removes a key-value pair from a map. O(1).
1085      *
1086      * Returns true if the key was removed from the map, that is if it was present.
1087      */
1088     function _remove(Map storage map, bytes32 key) private returns (bool) {
1089         // We read and store the key's index to prevent multiple reads from the same storage slot
1090         uint256 keyIndex = map._indexes[key];
1091 
1092         if (keyIndex != 0) { // Equivalent to contains(map, key)
1093             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1094             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1095             // This modifies the order of the array, as noted in {at}.
1096 
1097             uint256 toDeleteIndex = keyIndex - 1;
1098             uint256 lastIndex = map._entries.length - 1;
1099 
1100             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1101             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1102 
1103             MapEntry storage lastEntry = map._entries[lastIndex];
1104 
1105             // Move the last entry to the index where the entry to delete is
1106             map._entries[toDeleteIndex] = lastEntry;
1107             // Update the index for the moved entry
1108             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1109 
1110             // Delete the slot where the moved entry was stored
1111             map._entries.pop();
1112 
1113             // Delete the index for the deleted slot
1114             delete map._indexes[key];
1115 
1116             return true;
1117         } else {
1118             return false;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Returns true if the key is in the map. O(1).
1124      */
1125     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1126         return map._indexes[key] != 0;
1127     }
1128 
1129     /**
1130      * @dev Returns the number of key-value pairs in the map. O(1).
1131      */
1132     function _length(Map storage map) private view returns (uint256) {
1133         return map._entries.length;
1134     }
1135 
1136    /**
1137     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1138     *
1139     * Note that there are no guarantees on the ordering of entries inside the
1140     * array, and it may change when more entries are added or removed.
1141     *
1142     * Requirements:
1143     *
1144     * - `index` must be strictly less than {length}.
1145     */
1146     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1147         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1148 
1149         MapEntry storage entry = map._entries[index];
1150         return (entry._key, entry._value);
1151     }
1152 
1153     /**
1154      * @dev Tries to returns the value associated with `key`.  O(1).
1155      * Does not revert if `key` is not in the map.
1156      */
1157     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1158         uint256 keyIndex = map._indexes[key];
1159         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1160         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1161     }
1162 
1163     /**
1164      * @dev Returns the value associated with `key`.  O(1).
1165      *
1166      * Requirements:
1167      *
1168      * - `key` must be in the map.
1169      */
1170     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1171         uint256 keyIndex = map._indexes[key];
1172         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1173         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1174     }
1175 
1176     /**
1177      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1178      *
1179      * CAUTION: This function is deprecated because it requires allocating memory for the error
1180      * message unnecessarily. For custom revert reasons use {_tryGet}.
1181      */
1182     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1183         uint256 keyIndex = map._indexes[key];
1184         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1185         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1186     }
1187 
1188     // UintToAddressMap
1189 
1190     struct UintToAddressMap {
1191         Map _inner;
1192     }
1193 
1194     /**
1195      * @dev Adds a key-value pair to a map, or updates the value for an existing
1196      * key. O(1).
1197      *
1198      * Returns true if the key was added to the map, that is if it was not
1199      * already present.
1200      */
1201     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1202         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1203     }
1204 
1205     /**
1206      * @dev Removes a value from a set. O(1).
1207      *
1208      * Returns true if the key was removed from the map, that is if it was present.
1209      */
1210     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1211         return _remove(map._inner, bytes32(key));
1212     }
1213 
1214     /**
1215      * @dev Returns true if the key is in the map. O(1).
1216      */
1217     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1218         return _contains(map._inner, bytes32(key));
1219     }
1220 
1221     /**
1222      * @dev Returns the number of elements in the map. O(1).
1223      */
1224     function length(UintToAddressMap storage map) internal view returns (uint256) {
1225         return _length(map._inner);
1226     }
1227 
1228    /**
1229     * @dev Returns the element stored at position `index` in the set. O(1).
1230     * Note that there are no guarantees on the ordering of values inside the
1231     * array, and it may change when more values are added or removed.
1232     *
1233     * Requirements:
1234     *
1235     * - `index` must be strictly less than {length}.
1236     */
1237     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1238         (bytes32 key, bytes32 value) = _at(map._inner, index);
1239         return (uint256(key), address(uint160(uint256(value))));
1240     }
1241 
1242     /**
1243      * @dev Tries to returns the value associated with `key`.  O(1).
1244      * Does not revert if `key` is not in the map.
1245      *
1246      * _Available since v3.4._
1247      */
1248     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1249         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1250         return (success, address(uint160(uint256(value))));
1251     }
1252 
1253     /**
1254      * @dev Returns the value associated with `key`.  O(1).
1255      *
1256      * Requirements:
1257      *
1258      * - `key` must be in the map.
1259      */
1260     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1261         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1262     }
1263 
1264     /**
1265      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1266      *
1267      * CAUTION: This function is deprecated because it requires allocating memory for the error
1268      * message unnecessarily. For custom revert reasons use {tryGet}.
1269      */
1270     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1271         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1272     }
1273 }
1274 
1275 // File: @openzeppelin/contracts/utils/Strings.sol
1276 
1277 
1278 /**
1279  * @dev String operations.
1280  */
1281 library Strings {
1282     /**
1283      * @dev Converts a `uint256` to its ASCII `string` representation.
1284      */
1285     function toString(uint256 value) internal pure returns (string memory) {
1286         // Inspired by OraclizeAPI's implementation - MIT licence
1287         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1288 
1289         if (value == 0) {
1290             return "0";
1291         }
1292         uint256 temp = value;
1293         uint256 digits;
1294         while (temp != 0) {
1295             digits++;
1296             temp /= 10;
1297         }
1298         bytes memory buffer = new bytes(digits);
1299         uint256 index = digits - 1;
1300         temp = value;
1301         while (temp != 0) {
1302             buffer[index--] = bytes1(uint8(48 + temp % 10));
1303             temp /= 10;
1304         }
1305         return string(buffer);
1306     }
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1310 
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
1388     constructor (string memory name_, string memory symbol_) public {
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
1775 // File: @openzeppelin/contracts/access/Ownable.sol
1776 
1777 /**
1778  * @dev Contract module which provides a basic access control mechanism, where
1779  * there is an account (an owner) that can be granted exclusive access to
1780  * specific functions.
1781  *
1782  * By default, the owner account will be the one that deploys the contract. This
1783  * can later be changed with {transferOwnership}.
1784  *
1785  * This module is used through inheritance. It will make available the modifier
1786  * `onlyOwner`, which can be applied to your functions to restrict their use to
1787  * the owner.
1788  */
1789 abstract contract Ownable is Context {
1790     address private _owner;
1791 
1792     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1793 
1794     /**
1795      * @dev Initializes the contract setting the deployer as the initial owner.
1796      */
1797     constructor () internal {
1798         address msgSender = _msgSender();
1799         _owner = msgSender;
1800         emit OwnershipTransferred(address(0), msgSender);
1801     }
1802 
1803     /**
1804      * @dev Returns the address of the current owner.
1805      */
1806     function owner() public view virtual returns (address) {
1807         return _owner;
1808     }
1809 
1810     /**
1811      * @dev Throws if called by any account other than the owner.
1812      */
1813     modifier onlyOwner() {
1814         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1815         _;
1816     }
1817 
1818     /**
1819      * @dev Leaves the contract without owner. It will not be possible to call
1820      * `onlyOwner` functions anymore. Can only be called by the current owner.
1821      *
1822      * NOTE: Renouncing ownership will leave the contract without an owner,
1823      * thereby removing any functionality that is only available to the owner.
1824      */
1825     function renounceOwnership() public virtual onlyOwner {
1826         emit OwnershipTransferred(_owner, address(0));
1827         _owner = address(0);
1828     }
1829 
1830     /**
1831      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1832      * Can only be called by the current owner.
1833      */
1834     function transferOwnership(address newOwner) public virtual onlyOwner {
1835         require(newOwner != address(0), "Ownable: new owner is the zero address");
1836         emit OwnershipTransferred(_owner, newOwner);
1837         _owner = newOwner;
1838     }
1839 }
1840 
1841 // File: contracts/SamuraiDoge.sol
1842 
1843 /**
1844  * @title SamuraiDoge contract
1845  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1846  */
1847 contract SamuraiDoge is ERC721, Ownable {
1848     using SafeMath for uint256;
1849 
1850     string public SAMURAI_PROVENANCE = "";
1851 
1852     uint256 public startingIndexBlock;
1853 
1854     uint256 public startingIndex;
1855 
1856     uint256 public samuraidogePrice;
1857 
1858     uint public maxSamuraiPurchase;
1859 
1860     uint256 public MAX_DOGES;
1861 
1862     bool public saleIsActive = false;
1863 
1864     bool public preSaleIsActive = false;
1865 
1866     bool public freeSaleIsActive = false;
1867 
1868     bool public primarySaleIsActive = false;
1869 
1870     uint256 public REVEAL_TIMESTAMP;
1871 
1872     mapping(uint => string) public avatarNames;
1873 
1874     uint256 freeMintCycle = 399;
1875     uint256 preMintCycle = 1399;
1876     uint256 primaryMintCycle = 5399;
1877 
1878 
1879     function addAvatar(uint256 _index , string memory _avatarName) public payable onlyOwner {
1880         avatarNames[_index] = _avatarName;
1881     }
1882 
1883     function setAvatarName(uint256 _index , string memory _avatarName) public payable {
1884         require(ownerOf(_index) == msg.sender);
1885         avatarNames[_index] = _avatarName;
1886     }
1887 
1888 
1889     constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart) ERC721(name, symbol) {
1890         MAX_DOGES = maxNftSupply;
1891         REVEAL_TIMESTAMP = saleStart + (86400 * 9);
1892     }
1893 
1894     function withdraw() public onlyOwner {
1895         uint balance = address(this).balance;
1896         msg.sender.transfer(balance);
1897     }
1898 
1899     /**
1900      * Set some SamuraiDoge aside
1901      */
1902     function reserveSamurai() public onlyOwner {
1903         uint supply = totalSupply();
1904         uint i;
1905         for (i = 0; i < 200; i++) {
1906             _safeMint(msg.sender, supply + i);
1907         }
1908     }
1909 
1910     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1911         REVEAL_TIMESTAMP = revealTimeStamp;
1912     }
1913 
1914     /*
1915       * Set provenance once it's calculated
1916     */
1917     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1918         SAMURAI_PROVENANCE = provenanceHash;
1919     }
1920 
1921     function setBaseURI(string memory baseURI) public onlyOwner {
1922         _setBaseURI(baseURI);
1923     }
1924 
1925 
1926     /*
1927     * Pause sale if active, make active if paused
1928     */
1929     function flipFreeSaleState() public onlyOwner {
1930         freeSaleIsActive = !freeSaleIsActive;
1931     }
1932 
1933     function setMaxperTransaction(uint256 _maxNFTPerTransaction) internal onlyOwner {
1934         maxSamuraiPurchase = _maxNFTPerTransaction;
1935     }
1936 
1937     /*
1938     * Pause sale if active, make active if paused
1939     */
1940     function flipPreSaleState(uint256 price, uint256 _maxMint) public onlyOwner {
1941         samuraidogePrice = price;
1942         setMaxperTransaction(_maxMint);
1943         preSaleIsActive = !preSaleIsActive;
1944     }
1945 
1946     /*
1947     * Pause sale if active, make active if paused
1948     */
1949     function flipPrimarySaleState(uint256 price, uint256 _maxMint) public onlyOwner {
1950         samuraidogePrice = price;
1951         setMaxperTransaction(_maxMint);
1952         primarySaleIsActive = !primarySaleIsActive;
1953     }
1954 
1955     /*
1956 * Pause sale if active, make active if paused
1957 */
1958     function flipFinalSaleState(uint256 price, uint256 _maxMint) public onlyOwner {
1959         samuraidogePrice = price;
1960         setMaxperTransaction(_maxMint);
1961         saleIsActive = !saleIsActive;
1962     }
1963 
1964 
1965     /**
1966     * Free Sale Mints Samurai Doge, allows you to mint 200 free tokens
1967     */
1968     function freeMintSamurai() public payable {
1969         require(freeSaleIsActive, "Sale must be active to mint Samurai Doge");
1970         require(totalSupply() <= freeMintCycle);
1971 
1972         uint mintIndex = totalSupply();
1973         if (totalSupply() <= freeMintCycle) {
1974             _safeMint(msg.sender, mintIndex);
1975         }
1976 
1977     }
1978 
1979 
1980 
1981     /**
1982     * Pre Sale Mints Samurai Doge
1983     */
1984     function preMintSamurai(uint numberOfTokens) public payable {
1985         require(preSaleIsActive, "Sale must be active to mint Samurai Doge");
1986         require(maxSamuraiPurchase > 0);
1987         require(totalSupply() <= preMintCycle);
1988         require(numberOfTokens <= maxSamuraiPurchase, "Can only mint 5 tokens at a time");
1989         require(totalSupply().add(numberOfTokens) <= MAX_DOGES, "Purchase would exceed max supply of Samurai Doges");
1990         require(samuraidogePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1991 
1992         for(uint i = 0; i < numberOfTokens; i++) {
1993             uint mintIndex = totalSupply();
1994             if (totalSupply() <= preMintCycle) {
1995                 _safeMint(msg.sender, mintIndex);
1996             }
1997         }
1998 
1999         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
2000         // the end of pre-sale, set the starting index block
2001         if (startingIndexBlock == 0 && (totalSupply() == MAX_DOGES)) {
2002             startingIndexBlock = block.number;
2003         }
2004     }
2005 
2006 
2007 
2008     /**
2009     * Mints Samurai Doge
2010     */
2011     function primaryMintSamurai(uint numberOfTokens) public payable {
2012         require(primarySaleIsActive, "Sale must be active to mint Samurai Doges");
2013         require(maxSamuraiPurchase > 0);
2014         require(numberOfTokens <= maxSamuraiPurchase, "Can only mint 5 tokens at a time");
2015         require(totalSupply() <= primaryMintCycle);
2016 
2017         require(totalSupply().add(numberOfTokens) <= MAX_DOGES, "Purchase would exceed max supply of Samurai Doges");
2018         require(samuraidogePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2019 
2020         for(uint i = 0; i < numberOfTokens; i++) {
2021             uint mintIndex = totalSupply();
2022             if (totalSupply() <= primaryMintCycle) {
2023                 _safeMint(msg.sender, mintIndex);
2024             }
2025         }
2026 
2027         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
2028         // the end of pre-sale, set the starting index block
2029         if (startingIndexBlock == 0 && (totalSupply() == MAX_DOGES)) {
2030             startingIndexBlock = block.number;
2031         }
2032     }
2033 
2034 
2035 
2036     /**
2037     * Mints Samurai Doge
2038     */
2039     function postMintSamurai(uint numberOfTokens) public payable {
2040         require(saleIsActive, "Sale must be active to mint Samurai Doges");
2041         require(maxSamuraiPurchase > 0);
2042         require(numberOfTokens <= maxSamuraiPurchase, "Can only mint 5 tokens at a time");
2043 
2044         require(totalSupply().add(numberOfTokens) <= MAX_DOGES, "Purchase would exceed max supply of Samurai Doges");
2045         require(samuraidogePrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2046 
2047         for(uint i = 0; i < numberOfTokens; i++) {
2048             uint mintIndex = totalSupply();
2049             if (totalSupply() < MAX_DOGES) {
2050                 _safeMint(msg.sender, mintIndex);
2051             }
2052         }
2053 
2054         // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
2055         // the end of pre-sale, set the starting index block
2056         if (startingIndexBlock == 0 && (totalSupply() == MAX_DOGES)) {
2057             startingIndexBlock = block.number;
2058         }
2059     }
2060 
2061 
2062     /**
2063      * Set the starting index for the collection
2064      */
2065     function setStartingIndex() public {
2066         require(startingIndex == 0, "Starting index is already set");
2067         require(startingIndexBlock != 0, "Starting index block must be set");
2068 
2069         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_DOGES;
2070         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2071         if (block.number.sub(startingIndexBlock) > 255) {
2072             startingIndex = uint(blockhash(block.number - 1)) % MAX_DOGES;
2073         }
2074         // Prevent default sequence
2075         if (startingIndex == 0) {
2076             startingIndex = startingIndex.add(1);
2077         }
2078     }
2079 
2080     /**
2081      * Set the starting index block for the collection, essentially unblocking
2082      * setting starting index
2083      */
2084     function emergencySetStartingIndexBlock() public onlyOwner {
2085         require(startingIndex == 0, "Starting index is already set");
2086 
2087         startingIndexBlock = block.number;
2088     }
2089 }