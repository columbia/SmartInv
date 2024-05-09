1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-18
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.7.6;
8 
9 
10  //  author Name: Alex Yap
11  //  author-email: <echo@alexyap.dev>
12  //  author-website: https://alexyap.dev
13 
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/introspection/IERC165.sol
39 
40 
41 /**
42  * @dev Interface of the ERC165 standard, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-165[EIP].
44  *
45  * Implementers can declare support of contract interfaces, which can then be
46  * queried by others ({ERC165Checker}).
47  *
48  * For an implementation, see {ERC165}.
49  */
50 interface IERC165 {
51     /**
52      * @dev Returns true if this contract implements the interface defined by
53      * `interfaceId`. See the corresponding
54      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
55      * to learn more about how these ids are created.
56      *
57      * This function call must use less than 30 000 gas.
58      */
59     function supportsInterface(bytes4 interfaceId) external view returns (bool);
60 }
61 
62 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
63 
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174       * @dev Safely transfers `tokenId` token from `from` to `to`.
175       *
176       * Requirements:
177       *
178       * - `from` cannot be the zero address.
179       * - `to` cannot be the zero address.
180       * - `tokenId` token must exist and be owned by `from`.
181       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183       *
184       * Emits a {Transfer} event.
185       */
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
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
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
219  * @dev See https://eips.ethereum.org/EIPS/eip-721
220  */
221 interface IERC721Enumerable is IERC721 {
222 
223     /**
224      * @dev Returns the total amount of tokens stored by the contract.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     /**
229      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
230      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
231      */
232     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
233 
234     /**
235      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
236      * Use along with {totalSupply} to enumerate all tokens.
237      */
238     function tokenByIndex(uint256 index) external view returns (uint256);
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
242 
243 
244 /**
245  * @title ERC721 token receiver interface
246  * @dev Interface for any contract that wants to support safeTransfers
247  * from ERC721 asset contracts.
248  */
249 interface IERC721Receiver {
250     /**
251      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
252      * by `operator` from `from`, this function is called.
253      *
254      * It must return its Solidity selector to confirm the token transfer.
255      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
256      *
257      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
258      */
259     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
260 }
261 
262 // File: @openzeppelin/contracts/introspection/ERC165.sol
263 
264 
265 /**
266  * @dev Implementation of the {IERC165} interface.
267  *
268  * Contracts may inherit from this and call {_registerInterface} to declare
269  * their support of an interface.
270  */
271 abstract contract ERC165 is IERC165 {
272     /*
273      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
274      */
275     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
276 
277     /**
278      * @dev Mapping of interface ids to whether or not it's supported.
279      */
280     mapping(bytes4 => bool) private _supportedInterfaces;
281 
282     constructor () internal {
283         // Derived contracts need only register support for their own interfaces,
284         // we register support for ERC165 itself here
285         _registerInterface(_INTERFACE_ID_ERC165);
286     }
287 
288     /**
289      * @dev See {IERC165-supportsInterface}.
290      *
291      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
294         return _supportedInterfaces[interfaceId];
295     }
296 
297     /**
298      * @dev Registers the contract as an implementer of the interface defined by
299      * `interfaceId`. Support of the actual ERC165 interface is automatic and
300      * registering its interface id is not required.
301      *
302      * See {IERC165-supportsInterface}.
303      *
304      * Requirements:
305      *
306      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
307      */
308     function _registerInterface(bytes4 interfaceId) internal virtual {
309         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
310         _supportedInterfaces[interfaceId] = true;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/math/SafeMath.sol
315 
316 
317 /**
318  * @dev Wrappers over Solidity's arithmetic operations with added overflow
319  * checks.
320  *
321  * Arithmetic operations in Solidity wrap on overflow. This can easily result
322  * in bugs, because programmers usually assume that an overflow raises an
323  * error, which is the standard behavior in high level programming languages.
324  * `SafeMath` restores this intuition by reverting the transaction when an
325  * operation overflows.
326  *
327  * Using this library instead of the unchecked operations eliminates an entire
328  * class of bugs, so it's recommended to use it always.
329  */
330 library SafeMath {
331     /**
332      * @dev Returns the addition of two unsigned integers, with an overflow flag.
333      *
334      * _Available since v3.4._
335      */
336     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
337         uint256 c = a + b;
338         if (c < a) return (false, 0);
339         return (true, c);
340     }
341 
342     /**
343      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
344      *
345      * _Available since v3.4._
346      */
347     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
348         if (b > a) return (false, 0);
349         return (true, a - b);
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
354      *
355      * _Available since v3.4._
356      */
357     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
358         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
359         // benefit is lost if 'b' is also tested.
360         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
361         if (a == 0) return (true, 0);
362         uint256 c = a * b;
363         if (c / a != b) return (false, 0);
364         return (true, c);
365     }
366 
367     /**
368      * @dev Returns the division of two unsigned integers, with a division by zero flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         if (b == 0) return (false, 0);
374         return (true, a / b);
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         if (b == 0) return (false, 0);
384         return (true, a % b);
385     }
386 
387     /**
388      * @dev Returns the addition of two unsigned integers, reverting on
389      * overflow.
390      *
391      * Counterpart to Solidity's `+` operator.
392      *
393      * Requirements:
394      *
395      * - Addition cannot overflow.
396      */
397     function add(uint256 a, uint256 b) internal pure returns (uint256) {
398         uint256 c = a + b;
399         require(c >= a, "SafeMath: addition overflow");
400         return c;
401     }
402 
403     /**
404      * @dev Returns the subtraction of two unsigned integers, reverting on
405      * overflow (when the result is negative).
406      *
407      * Counterpart to Solidity's `-` operator.
408      *
409      * Requirements:
410      *
411      * - Subtraction cannot overflow.
412      */
413     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
414         require(b <= a, "SafeMath: subtraction overflow");
415         return a - b;
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, reverting on
420      * overflow.
421      *
422      * Counterpart to Solidity's `*` operator.
423      *
424      * Requirements:
425      *
426      * - Multiplication cannot overflow.
427      */
428     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429         if (a == 0) return 0;
430         uint256 c = a * b;
431         require(c / a == b, "SafeMath: multiplication overflow");
432         return c;
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers, reverting on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator. Note: this function uses a
440      * `revert` opcode (which leaves remaining gas untouched) while Solidity
441      * uses an invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function div(uint256 a, uint256 b) internal pure returns (uint256) {
448         require(b > 0, "SafeMath: division by zero");
449         return a / b;
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * reverting when dividing by zero.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
465         require(b > 0, "SafeMath: modulo by zero");
466         return a % b;
467     }
468 
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
471      * overflow (when the result is negative).
472      *
473      * CAUTION: This function is deprecated because it requires allocating memory for the error
474      * message unnecessarily. For custom revert reasons use {trySub}.
475      *
476      * Counterpart to Solidity's `-` operator.
477      *
478      * Requirements:
479      *
480      * - Subtraction cannot overflow.
481      */
482     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
483         require(b <= a, errorMessage);
484         return a - b;
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
489      * division by zero. The result is rounded towards zero.
490      *
491      * CAUTION: This function is deprecated because it requires allocating memory for the error
492      * message unnecessarily. For custom revert reasons use {tryDiv}.
493      *
494      * Counterpart to Solidity's `/` operator. Note: this function uses a
495      * `revert` opcode (which leaves remaining gas untouched) while Solidity
496      * uses an invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b > 0, errorMessage);
504         return a / b;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * reverting with custom message when dividing by zero.
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {tryMod}.
513      *
514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
515      * opcode (which leaves remaining gas untouched) while Solidity uses an
516      * invalid opcode to revert (consuming all remaining gas).
517      *
518      * Requirements:
519      *
520      * - The divisor cannot be zero.
521      */
522     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b > 0, errorMessage);
524         return a % b;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/utils/Address.sol
529 
530 
531 /**
532  * @dev Collection of functions related to the address type
533  */
534 library Address {
535     /**
536      * @dev Returns true if `account` is a contract.
537      *
538      * [IMPORTANT]
539      * ====
540      * It is unsafe to assume that an address for which this function returns
541      * false is an externally-owned account (EOA) and not a contract.
542      *
543      * Among others, `isContract` will return false for the following
544      * types of addresses:
545      *
546      *  - an externally-owned account
547      *  - a contract in construction
548      *  - an address where a contract will be created
549      *  - an address where a contract lived, but was destroyed
550      * ====
551      */
552     function isContract(address account) internal view returns (bool) {
553         // This method relies on extcodesize, which returns 0 for contracts in
554         // construction, since the code is only stored at the end of the
555         // constructor execution.
556 
557         uint256 size;
558         // solhint-disable-next-line no-inline-assembly
559         assembly { size := extcodesize(account) }
560         return size > 0;
561     }
562 
563     /**
564      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
565      * `recipient`, forwarding all available gas and reverting on errors.
566      *
567      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
568      * of certain opcodes, possibly making contracts go over the 2300 gas limit
569      * imposed by `transfer`, making them unable to receive funds via
570      * `transfer`. {sendValue} removes this limitation.
571      *
572      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
573      *
574      * IMPORTANT: because control is transferred to `recipient`, care must be
575      * taken to not create reentrancy vulnerabilities. Consider using
576      * {ReentrancyGuard} or the
577      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
578      */
579     function sendValue(address payable recipient, uint256 amount) internal {
580         require(address(this).balance >= amount, "Address: insufficient balance");
581 
582         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
583         (bool success, ) = recipient.call{ value: amount }("");
584         require(success, "Address: unable to send value, recipient may have reverted");
585     }
586 
587     /**
588      * @dev Performs a Solidity function call using a low level `call`. A
589      * plain`call` is an unsafe replacement for a function call: use this
590      * function instead.
591      *
592      * If `target` reverts with a revert reason, it is bubbled up by this
593      * function (like regular Solidity function calls).
594      *
595      * Returns the raw returned data. To convert to the expected return value,
596      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
597      *
598      * Requirements:
599      *
600      * - `target` must be a contract.
601      * - calling `target` with `data` must not revert.
602      *
603      * _Available since v3.1._
604      */
605     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
606       return functionCall(target, data, "Address: low-level call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
611      * `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
616         return functionCallWithValue(target, data, 0, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but also transferring `value` wei to `target`.
622      *
623      * Requirements:
624      *
625      * - the calling contract must have an ETH balance of at least `value`.
626      * - the called Solidity function must be `payable`.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
631         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
636      * with `errorMessage` as a fallback revert reason when `target` reverts.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
641         require(address(this).balance >= value, "Address: insufficient balance for call");
642         require(isContract(target), "Address: call to non-contract");
643 
644         // solhint-disable-next-line avoid-low-level-calls
645         (bool success, bytes memory returndata) = target.call{ value: value }(data);
646         return _verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a static call.
652      *
653      * _Available since v3.3._
654      */
655     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
656         return functionStaticCall(target, data, "Address: low-level static call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a static call.
662      *
663      * _Available since v3.3._
664      */
665     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
666         require(isContract(target), "Address: static call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.staticcall(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
680         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
690         require(isContract(target), "Address: delegate call to non-contract");
691 
692         // solhint-disable-next-line avoid-low-level-calls
693         (bool success, bytes memory returndata) = target.delegatecall(data);
694         return _verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
698         if (success) {
699             return returndata;
700         } else {
701             // Look for revert reason and bubble it up if present
702             if (returndata.length > 0) {
703                 // The easiest way to bubble the revert reason is using memory via assembly
704 
705                 // solhint-disable-next-line no-inline-assembly
706                 assembly {
707                     let returndata_size := mload(returndata)
708                     revert(add(32, returndata), returndata_size)
709                 }
710             } else {
711                 revert(errorMessage);
712             }
713         }
714     }
715 }
716 
717 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
718 
719 
720 /**
721  * @dev Library for managing
722  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
723  * types.
724  *
725  * Sets have the following properties:
726  *
727  * - Elements are added, removed, and checked for existence in constant time
728  * (O(1)).
729  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
730  *
731  * ```
732  * contract Example {
733  *     // Add the library methods
734  *     using EnumerableSet for EnumerableSet.AddressSet;
735  *
736  *     // Declare a set state variable
737  *     EnumerableSet.AddressSet private mySet;
738  * }
739  * ```
740  *
741  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
742  * and `uint256` (`UintSet`) are supported.
743  */
744 library EnumerableSet {
745     // To implement this library for multiple types with as little code
746     // repetition as possible, we write it in terms of a generic Set type with
747     // bytes32 values.
748     // The Set implementation uses private functions, and user-facing
749     // implementations (such as AddressSet) are just wrappers around the
750     // underlying Set.
751     // This means that we can only create new EnumerableSets for types that fit
752     // in bytes32.
753 
754     struct Set {
755         // Storage of set values
756         bytes32[] _values;
757 
758         // Position of the value in the `values` array, plus 1 because index 0
759         // means a value is not in the set.
760         mapping (bytes32 => uint256) _indexes;
761     }
762 
763     /**
764      * @dev Add a value to a set. O(1).
765      *
766      * Returns true if the value was added to the set, that is if it was not
767      * already present.
768      */
769     function _add(Set storage set, bytes32 value) private returns (bool) {
770         if (!_contains(set, value)) {
771             set._values.push(value);
772             // The value is stored at length-1, but we add 1 to all indexes
773             // and use 0 as a sentinel value
774             set._indexes[value] = set._values.length;
775             return true;
776         } else {
777             return false;
778         }
779     }
780 
781     /**
782      * @dev Removes a value from a set. O(1).
783      *
784      * Returns true if the value was removed from the set, that is if it was
785      * present.
786      */
787     function _remove(Set storage set, bytes32 value) private returns (bool) {
788         // We read and store the value's index to prevent multiple reads from the same storage slot
789         uint256 valueIndex = set._indexes[value];
790 
791         if (valueIndex != 0) { // Equivalent to contains(set, value)
792             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
793             // the array, and then remove the last element (sometimes called as 'swap and pop').
794             // This modifies the order of the array, as noted in {at}.
795 
796             uint256 toDeleteIndex = valueIndex - 1;
797             uint256 lastIndex = set._values.length - 1;
798 
799             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
800             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
801 
802             bytes32 lastvalue = set._values[lastIndex];
803 
804             // Move the last value to the index where the value to delete is
805             set._values[toDeleteIndex] = lastvalue;
806             // Update the index for the moved value
807             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
808 
809             // Delete the slot where the moved value was stored
810             set._values.pop();
811 
812             // Delete the index for the deleted slot
813             delete set._indexes[value];
814 
815             return true;
816         } else {
817             return false;
818         }
819     }
820 
821     /**
822      * @dev Returns true if the value is in the set. O(1).
823      */
824     function _contains(Set storage set, bytes32 value) private view returns (bool) {
825         return set._indexes[value] != 0;
826     }
827 
828     /**
829      * @dev Returns the number of values on the set. O(1).
830      */
831     function _length(Set storage set) private view returns (uint256) {
832         return set._values.length;
833     }
834 
835    /**
836     * @dev Returns the value stored at position `index` in the set. O(1).
837     *
838     * Note that there are no guarantees on the ordering of values inside the
839     * array, and it may change when more values are added or removed.
840     *
841     * Requirements:
842     *
843     * - `index` must be strictly less than {length}.
844     */
845     function _at(Set storage set, uint256 index) private view returns (bytes32) {
846         require(set._values.length > index, "EnumerableSet: index out of bounds");
847         return set._values[index];
848     }
849 
850     // Bytes32Set
851 
852     struct Bytes32Set {
853         Set _inner;
854     }
855 
856     /**
857      * @dev Add a value to a set. O(1).
858      *
859      * Returns true if the value was added to the set, that is if it was not
860      * already present.
861      */
862     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
863         return _add(set._inner, value);
864     }
865 
866     /**
867      * @dev Removes a value from a set. O(1).
868      *
869      * Returns true if the value was removed from the set, that is if it was
870      * present.
871      */
872     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
873         return _remove(set._inner, value);
874     }
875 
876     /**
877      * @dev Returns true if the value is in the set. O(1).
878      */
879     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
880         return _contains(set._inner, value);
881     }
882 
883     /**
884      * @dev Returns the number of values in the set. O(1).
885      */
886     function length(Bytes32Set storage set) internal view returns (uint256) {
887         return _length(set._inner);
888     }
889 
890    /**
891     * @dev Returns the value stored at position `index` in the set. O(1).
892     *
893     * Note that there are no guarantees on the ordering of values inside the
894     * array, and it may change when more values are added or removed.
895     *
896     * Requirements:
897     *
898     * - `index` must be strictly less than {length}.
899     */
900     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
901         return _at(set._inner, index);
902     }
903 
904     // AddressSet
905 
906     struct AddressSet {
907         Set _inner;
908     }
909 
910     /**
911      * @dev Add a value to a set. O(1).
912      *
913      * Returns true if the value was added to the set, that is if it was not
914      * already present.
915      */
916     function add(AddressSet storage set, address value) internal returns (bool) {
917         return _add(set._inner, bytes32(uint256(uint160(value))));
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function remove(AddressSet storage set, address value) internal returns (bool) {
927         return _remove(set._inner, bytes32(uint256(uint160(value))));
928     }
929 
930     /**
931      * @dev Returns true if the value is in the set. O(1).
932      */
933     function contains(AddressSet storage set, address value) internal view returns (bool) {
934         return _contains(set._inner, bytes32(uint256(uint160(value))));
935     }
936 
937     /**
938      * @dev Returns the number of values in the set. O(1).
939      */
940     function length(AddressSet storage set) internal view returns (uint256) {
941         return _length(set._inner);
942     }
943 
944    /**
945     * @dev Returns the value stored at position `index` in the set. O(1).
946     *
947     * Note that there are no guarantees on the ordering of values inside the
948     * array, and it may change when more values are added or removed.
949     *
950     * Requirements:
951     *
952     * - `index` must be strictly less than {length}.
953     */
954     function at(AddressSet storage set, uint256 index) internal view returns (address) {
955         return address(uint160(uint256(_at(set._inner, index))));
956     }
957 
958 
959     // UintSet
960 
961     struct UintSet {
962         Set _inner;
963     }
964 
965     /**
966      * @dev Add a value to a set. O(1).
967      *
968      * Returns true if the value was added to the set, that is if it was not
969      * already present.
970      */
971     function add(UintSet storage set, uint256 value) internal returns (bool) {
972         return _add(set._inner, bytes32(value));
973     }
974 
975     /**
976      * @dev Removes a value from a set. O(1).
977      *
978      * Returns true if the value was removed from the set, that is if it was
979      * present.
980      */
981     function remove(UintSet storage set, uint256 value) internal returns (bool) {
982         return _remove(set._inner, bytes32(value));
983     }
984 
985     /**
986      * @dev Returns true if the value is in the set. O(1).
987      */
988     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
989         return _contains(set._inner, bytes32(value));
990     }
991 
992     /**
993      * @dev Returns the number of values on the set. O(1).
994      */
995     function length(UintSet storage set) internal view returns (uint256) {
996         return _length(set._inner);
997     }
998 
999    /**
1000     * @dev Returns the value stored at position `index` in the set. O(1).
1001     *
1002     * Note that there are no guarantees on the ordering of values inside the
1003     * array, and it may change when more values are added or removed.
1004     *
1005     * Requirements:
1006     *
1007     * - `index` must be strictly less than {length}.
1008     */
1009     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1010         return uint256(_at(set._inner, index));
1011     }
1012 }
1013 
1014 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1015 
1016 /**
1017  * @dev Library for managing an enumerable variant of Solidity's
1018  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1019  * type.
1020  *
1021  * Maps have the following properties:
1022  *
1023  * - Entries are added, removed, and checked for existence in constant time
1024  * (O(1)).
1025  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1026  *
1027  * ```
1028  * contract Example {
1029  *     // Add the library methods
1030  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1031  *
1032  *     // Declare a set state variable
1033  *     EnumerableMap.UintToAddressMap private myMap;
1034  * }
1035  * ```
1036  *
1037  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1038  * supported.
1039  */
1040 library EnumerableMap {
1041     // To implement this library for multiple types with as little code
1042     // repetition as possible, we write it in terms of a generic Map type with
1043     // bytes32 keys and values.
1044     // The Map implementation uses private functions, and user-facing
1045     // implementations (such as Uint256ToAddressMap) are just wrappers around
1046     // the underlying Map.
1047     // This means that we can only create new EnumerableMaps for types that fit
1048     // in bytes32.
1049 
1050     struct MapEntry {
1051         bytes32 _key;
1052         bytes32 _value;
1053     }
1054 
1055     struct Map {
1056         // Storage of map keys and values
1057         MapEntry[] _entries;
1058 
1059         // Position of the entry defined by a key in the `entries` array, plus 1
1060         // because index 0 means a key is not in the map.
1061         mapping (bytes32 => uint256) _indexes;
1062     }
1063 
1064     /**
1065      * @dev Adds a key-value pair to a map, or updates the value for an existing
1066      * key. O(1).
1067      *
1068      * Returns true if the key was added to the map, that is if it was not
1069      * already present.
1070      */
1071     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1072         // We read and store the key's index to prevent multiple reads from the same storage slot
1073         uint256 keyIndex = map._indexes[key];
1074 
1075         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1076             map._entries.push(MapEntry({ _key: key, _value: value }));
1077             // The entry is stored at length-1, but we add 1 to all indexes
1078             // and use 0 as a sentinel value
1079             map._indexes[key] = map._entries.length;
1080             return true;
1081         } else {
1082             map._entries[keyIndex - 1]._value = value;
1083             return false;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Removes a key-value pair from a map. O(1).
1089      *
1090      * Returns true if the key was removed from the map, that is if it was present.
1091      */
1092     function _remove(Map storage map, bytes32 key) private returns (bool) {
1093         // We read and store the key's index to prevent multiple reads from the same storage slot
1094         uint256 keyIndex = map._indexes[key];
1095 
1096         if (keyIndex != 0) { // Equivalent to contains(map, key)
1097             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1098             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1099             // This modifies the order of the array, as noted in {at}.
1100 
1101             uint256 toDeleteIndex = keyIndex - 1;
1102             uint256 lastIndex = map._entries.length - 1;
1103 
1104             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1105             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1106 
1107             MapEntry storage lastEntry = map._entries[lastIndex];
1108 
1109             // Move the last entry to the index where the entry to delete is
1110             map._entries[toDeleteIndex] = lastEntry;
1111             // Update the index for the moved entry
1112             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1113 
1114             // Delete the slot where the moved entry was stored
1115             map._entries.pop();
1116 
1117             // Delete the index for the deleted slot
1118             delete map._indexes[key];
1119 
1120             return true;
1121         } else {
1122             return false;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns true if the key is in the map. O(1).
1128      */
1129     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1130         return map._indexes[key] != 0;
1131     }
1132 
1133     /**
1134      * @dev Returns the number of key-value pairs in the map. O(1).
1135      */
1136     function _length(Map storage map) private view returns (uint256) {
1137         return map._entries.length;
1138     }
1139 
1140    /**
1141     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1142     *
1143     * Note that there are no guarantees on the ordering of entries inside the
1144     * array, and it may change when more entries are added or removed.
1145     *
1146     * Requirements:
1147     *
1148     * - `index` must be strictly less than {length}.
1149     */
1150     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1151         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1152 
1153         MapEntry storage entry = map._entries[index];
1154         return (entry._key, entry._value);
1155     }
1156 
1157     /**
1158      * @dev Tries to returns the value associated with `key`.  O(1).
1159      * Does not revert if `key` is not in the map.
1160      */
1161     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1162         uint256 keyIndex = map._indexes[key];
1163         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1164         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1165     }
1166 
1167     /**
1168      * @dev Returns the value associated with `key`.  O(1).
1169      *
1170      * Requirements:
1171      *
1172      * - `key` must be in the map.
1173      */
1174     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1175         uint256 keyIndex = map._indexes[key];
1176         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1177         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1178     }
1179 
1180     /**
1181      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1182      *
1183      * CAUTION: This function is deprecated because it requires allocating memory for the error
1184      * message unnecessarily. For custom revert reasons use {_tryGet}.
1185      */
1186     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1187         uint256 keyIndex = map._indexes[key];
1188         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1189         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1190     }
1191 
1192     // UintToAddressMap
1193 
1194     struct UintToAddressMap {
1195         Map _inner;
1196     }
1197 
1198     /**
1199      * @dev Adds a key-value pair to a map, or updates the value for an existing
1200      * key. O(1).
1201      *
1202      * Returns true if the key was added to the map, that is if it was not
1203      * already present.
1204      */
1205     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1206         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1207     }
1208 
1209     /**
1210      * @dev Removes a value from a set. O(1).
1211      *
1212      * Returns true if the key was removed from the map, that is if it was present.
1213      */
1214     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1215         return _remove(map._inner, bytes32(key));
1216     }
1217 
1218     /**
1219      * @dev Returns true if the key is in the map. O(1).
1220      */
1221     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1222         return _contains(map._inner, bytes32(key));
1223     }
1224 
1225     /**
1226      * @dev Returns the number of elements in the map. O(1).
1227      */
1228     function length(UintToAddressMap storage map) internal view returns (uint256) {
1229         return _length(map._inner);
1230     }
1231 
1232    /**
1233     * @dev Returns the element stored at position `index` in the set. O(1).
1234     * Note that there are no guarantees on the ordering of values inside the
1235     * array, and it may change when more values are added or removed.
1236     *
1237     * Requirements:
1238     *
1239     * - `index` must be strictly less than {length}.
1240     */
1241     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1242         (bytes32 key, bytes32 value) = _at(map._inner, index);
1243         return (uint256(key), address(uint160(uint256(value))));
1244     }
1245 
1246     /**
1247      * @dev Tries to returns the value associated with `key`.  O(1).
1248      * Does not revert if `key` is not in the map.
1249      *
1250      * _Available since v3.4._
1251      */
1252     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1253         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1254         return (success, address(uint160(uint256(value))));
1255     }
1256 
1257     /**
1258      * @dev Returns the value associated with `key`.  O(1).
1259      *
1260      * Requirements:
1261      *
1262      * - `key` must be in the map.
1263      */
1264     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1265         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1266     }
1267 
1268     /**
1269      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1270      *
1271      * CAUTION: This function is deprecated because it requires allocating memory for the error
1272      * message unnecessarily. For custom revert reasons use {tryGet}.
1273      */
1274     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1275         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1276     }
1277 }
1278 
1279 // File: @openzeppelin/contracts/utils/Strings.sol
1280 
1281 
1282 /**
1283  * @dev String operations.
1284  */
1285 library Strings {
1286     /**
1287      * @dev Converts a `uint256` to its ASCII `string` representation.
1288      */
1289     function toString(uint256 value) internal pure returns (string memory) {
1290         // Inspired by OraclizeAPI's implementation - MIT licence
1291         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1292 
1293         if (value == 0) {
1294             return "0";
1295         }
1296         uint256 temp = value;
1297         uint256 digits;
1298         while (temp != 0) {
1299             digits++;
1300             temp /= 10;
1301         }
1302         bytes memory buffer = new bytes(digits);
1303         uint256 index = digits - 1;
1304         temp = value;
1305         while (temp != 0) {
1306             buffer[index--] = bytes1(uint8(48 + temp % 10));
1307             temp /= 10;
1308         }
1309         return string(buffer);
1310     }
1311 }
1312 
1313 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1314 
1315 
1316 /**
1317  * @title ERC721 Non-Fungible Token Standard basic implementation
1318  * @dev see https://eips.ethereum.org/EIPS/eip-721
1319  */
1320 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1321     using SafeMath for uint256;
1322     using Address for address;
1323     using EnumerableSet for EnumerableSet.UintSet;
1324     using EnumerableMap for EnumerableMap.UintToAddressMap;
1325     using Strings for uint256;
1326 
1327     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1328     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1329     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1330 
1331     // Mapping from holder address to their (enumerable) set of owned tokens
1332     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1333 
1334     // Enumerable mapping from token ids to their owners
1335     EnumerableMap.UintToAddressMap private _tokenOwners;
1336 
1337     // Mapping from token ID to approved address
1338     mapping (uint256 => address) private _tokenApprovals;
1339 
1340     // Mapping from owner to operator approvals
1341     mapping (address => mapping (address => bool)) private _operatorApprovals;
1342 
1343     // Token name
1344     string private _name;
1345 
1346     // Token symbol
1347     string private _symbol;
1348 
1349     // Optional mapping for token URIs
1350     mapping (uint256 => string) private _tokenURIs;
1351 
1352     // Base URI
1353     string private _baseURI;
1354 
1355     /*
1356      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1357      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1358      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1359      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1360      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1361      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1362      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1363      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1364      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1365      *
1366      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1367      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1368      */
1369     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1370 
1371     /*
1372      *     bytes4(keccak256('name()')) == 0x06fdde03
1373      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1374      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1375      *
1376      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1377      */
1378     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1379 
1380     /*
1381      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1382      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1383      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1384      *
1385      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1386      */
1387     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1388 
1389     /**
1390      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1391      */
1392     constructor (string memory name_, string memory symbol_) public {
1393         _name = name_;
1394         _symbol = symbol_;
1395 
1396         // register the supported interfaces to conform to ERC721 via ERC165
1397         _registerInterface(_INTERFACE_ID_ERC721);
1398         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1399         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-balanceOf}.
1404      */
1405     function balanceOf(address owner) public view virtual override returns (uint256) {
1406         require(owner != address(0), "ERC721: balance query for the zero address");
1407         return _holderTokens[owner].length();
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-ownerOf}.
1412      */
1413     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1414         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1415     }
1416 
1417     /**
1418      * @dev See {IERC721Metadata-name}.
1419      */
1420     function name() public view virtual override returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Metadata-symbol}.
1426      */
1427     function symbol() public view virtual override returns (string memory) {
1428         return _symbol;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Metadata-tokenURI}.
1433      */
1434     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1435         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1436 
1437         string memory _tokenURI = _tokenURIs[tokenId];
1438         string memory base = baseURI();
1439 
1440         // If there is no base URI, return the token URI.
1441         if (bytes(base).length == 0) {
1442             return _tokenURI;
1443         }
1444         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1445         if (bytes(_tokenURI).length > 0) {
1446             return string(abi.encodePacked(base, _tokenURI));
1447         }
1448         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1449         return string(abi.encodePacked(base, tokenId.toString()));
1450     }
1451 
1452     /**
1453     * @dev Returns the base URI set via {_setBaseURI}. This will be
1454     * automatically added as a prefix in {tokenURI} to each token's URI, or
1455     * to the token ID if no specific URI is set for that token ID.
1456     */
1457     function baseURI() public view virtual returns (string memory) {
1458         return _baseURI;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1463      */
1464     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1465         return _holderTokens[owner].at(index);
1466     }
1467 
1468     /**
1469      * @dev See {IERC721Enumerable-totalSupply}.
1470      */
1471     function totalSupply() public view virtual override returns (uint256) {
1472         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1473         return _tokenOwners.length();
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-tokenByIndex}.
1478      */
1479     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1480         (uint256 tokenId, ) = _tokenOwners.at(index);
1481         return tokenId;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-approve}.
1486      */
1487     function approve(address to, uint256 tokenId) public virtual override {
1488         address owner = ERC721.ownerOf(tokenId);
1489         require(to != owner, "ERC721: approval to current owner");
1490 
1491         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1492             "ERC721: approve caller is not owner nor approved for all"
1493         );
1494 
1495         _approve(to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-getApproved}.
1500      */
1501     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1502         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1503 
1504         return _tokenApprovals[tokenId];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-setApprovalForAll}.
1509      */
1510     function setApprovalForAll(address operator, bool approved) public virtual override {
1511         require(operator != _msgSender(), "ERC721: approve to caller");
1512 
1513         _operatorApprovals[_msgSender()][operator] = approved;
1514         emit ApprovalForAll(_msgSender(), operator, approved);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-isApprovedForAll}.
1519      */
1520     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1521         return _operatorApprovals[owner][operator];
1522     }
1523 
1524     /**
1525      * @dev See {IERC721-transferFrom}.
1526      */
1527     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1528         //solhint-disable-next-line max-line-length
1529         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1530 
1531         _transfer(from, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-safeTransferFrom}.
1536      */
1537     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1538         safeTransferFrom(from, to, tokenId, "");
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-safeTransferFrom}.
1543      */
1544     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1545         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1546         _safeTransfer(from, to, tokenId, _data);
1547     }
1548 
1549     /**
1550      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1551      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1552      *
1553      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1554      *
1555      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1556      * implement alternative mechanisms to perform token transfer, such as signature-based.
1557      *
1558      * Requirements:
1559      *
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      * - `tokenId` token must exist and be owned by `from`.
1563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1568         _transfer(from, to, tokenId);
1569         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1570     }
1571 
1572     /**
1573      * @dev Returns whether `tokenId` exists.
1574      *
1575      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1576      *
1577      * Tokens start existing when they are minted (`_mint`),
1578      * and stop existing when they are burned (`_burn`).
1579      */
1580     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1581         return _tokenOwners.contains(tokenId);
1582     }
1583 
1584     /**
1585      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1586      *
1587      * Requirements:
1588      *
1589      * - `tokenId` must exist.
1590      */
1591     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1592         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1593         address owner = ERC721.ownerOf(tokenId);
1594         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1595     }
1596 
1597     /**
1598      * @dev Safely mints `tokenId` and transfers it to `to`.
1599      *
1600      * Requirements:
1601      d*
1602      * - `tokenId` must not exist.
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function _safeMint(address to, uint256 tokenId) internal virtual {
1608         _safeMint(to, tokenId, "");
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1613      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1614      */
1615     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1616         _mint(to, tokenId);
1617         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1618     }
1619 
1620     /**
1621      * @dev Mints `tokenId` and transfers it to `to`.
1622      *
1623      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must not exist.
1628      * - `to` cannot be the zero address.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function _mint(address to, uint256 tokenId) internal virtual {
1633         require(to != address(0), "ERC721: mint to the zero address");
1634         require(!_exists(tokenId), "ERC721: token already minted");
1635 
1636         _beforeTokenTransfer(address(0), to, tokenId);
1637 
1638         _holderTokens[to].add(tokenId);
1639 
1640         _tokenOwners.set(tokenId, to);
1641 
1642         emit Transfer(address(0), to, tokenId);
1643     }
1644 
1645     /**
1646      * @dev Destroys `tokenId`.
1647      * The approval is cleared when the token is burned.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _burn(uint256 tokenId) internal virtual {
1656         address owner = ERC721.ownerOf(tokenId); // internal owner
1657 
1658         _beforeTokenTransfer(owner, address(0), tokenId);
1659 
1660         // Clear approvals
1661         _approve(address(0), tokenId);
1662 
1663         // Clear metadata (if any)
1664         if (bytes(_tokenURIs[tokenId]).length != 0) {
1665             delete _tokenURIs[tokenId];
1666         }
1667 
1668         _holderTokens[owner].remove(tokenId);
1669 
1670         _tokenOwners.remove(tokenId);
1671 
1672         emit Transfer(owner, address(0), tokenId);
1673     }
1674 
1675     /**
1676      * @dev Transfers `tokenId` from `from` to `to`.
1677      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1678      *
1679      * Requirements:
1680      *
1681      * - `to` cannot be the zero address.
1682      * - `tokenId` token must be owned by `from`.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1687         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1688         require(to != address(0), "ERC721: transfer to the zero address");
1689 
1690         _beforeTokenTransfer(from, to, tokenId);
1691 
1692         // Clear approvals from the previous owner
1693         _approve(address(0), tokenId);
1694 
1695         _holderTokens[from].remove(tokenId);
1696         _holderTokens[to].add(tokenId);
1697 
1698         _tokenOwners.set(tokenId, to);
1699 
1700         emit Transfer(from, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      */
1710     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1711         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1712         _tokenURIs[tokenId] = _tokenURI;
1713     }
1714 
1715     /**
1716      * @dev Internal function to set the base URI for all token IDs. It is
1717      * automatically added as a prefix to the value returned in {tokenURI},
1718      * or to the token ID if {tokenURI} is empty.
1719      */
1720     function _setBaseURI(string memory baseURI_) internal virtual {
1721         _baseURI = baseURI_;
1722     }
1723 
1724     /**
1725      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1726      * The call is not executed if the target address is not a contract.
1727      *
1728      * @param from address representing the previous owner of the given token ID
1729      * @param to target address that will receive the tokens
1730      * @param tokenId uint256 ID of the token to be transferred
1731      * @param _data bytes optional data to send along with the call
1732      * @return bool whether the call correctly returned the expected magic value
1733      */
1734     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1735         private returns (bool)
1736     {
1737         if (!to.isContract()) {
1738             return true;
1739         }
1740         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1741             IERC721Receiver(to).onERC721Received.selector,
1742             _msgSender(),
1743             from,
1744             tokenId,
1745             _data
1746         ), "ERC721: transfer to non ERC721Receiver implementer");
1747         bytes4 retval = abi.decode(returndata, (bytes4));
1748         return (retval == _ERC721_RECEIVED);
1749     }
1750 
1751     /**
1752      * @dev Approve `to` to operate on `tokenId`
1753      *
1754      * Emits an {Approval} event.
1755      */
1756     function _approve(address to, uint256 tokenId) internal virtual {
1757         _tokenApprovals[tokenId] = to;
1758         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1759     }
1760 
1761     /**
1762      * @dev Hook that is called before any token transfer. This includes minting
1763      * and burning.
1764      *
1765      * Calling conditions:
1766      *
1767      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1768      * transferred to `to`.
1769      * - When `from` is zero, `tokenId` will be minted for `to`.
1770      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1771      * - `from` cannot be the zero address.
1772      * - `to` cannot be the zero address.
1773      *
1774      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1775      */
1776     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1777 }
1778 
1779 // File: @openzeppelin/contracts/access/Ownable.sol
1780 
1781 /**
1782  * @dev Contract module which provides a basic access control mechanism, where
1783  * there is an account (an owner) that can be granted exclusive access to
1784  * specific functions.
1785  *
1786  * By default, the owner account will be the one that deploys the contract. This
1787  * can later be changed with {transferOwnership}.
1788  *
1789  * This module is used through inheritance. It will make available the modifier
1790  * `onlyOwner`, which can be applied to your functions to restrict their use to
1791  * the owner.
1792  */
1793 abstract contract Ownable is Context {
1794     address private _owner;
1795 
1796     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1797 
1798     /**
1799      * @dev Initializes the contract setting the deployer as the initial owner.
1800      */
1801     constructor () internal {
1802         address msgSender = _msgSender();
1803         _owner = msgSender;
1804         emit OwnershipTransferred(address(0), msgSender);
1805     }
1806 
1807     /**
1808      * @dev Returns the address of the current owner.
1809      */
1810     function owner() public view virtual returns (address) {
1811         return _owner;
1812     }
1813 
1814     /**
1815      * @dev Throws if called by any account other than the owner.
1816      */
1817     modifier onlyOwner() {
1818         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1819         _;
1820     }
1821 
1822     /**
1823      * @dev Leaves the contract without owner. It will not be possible to call
1824      * `onlyOwner` functions anymore. Can only be called by the current owner.
1825      *
1826      * NOTE: Renouncing ownership will leave the contract without an owner,
1827      * thereby removing any functionality that is only available to the owner.
1828      */
1829     function renounceOwnership() public virtual onlyOwner {
1830         emit OwnershipTransferred(_owner, address(0));
1831         _owner = address(0);
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Can only be called by the current owner.
1837      */
1838     function transferOwnership(address newOwner) public virtual onlyOwner {
1839         require(newOwner != address(0), "Ownable: new owner is the zero address");
1840         emit OwnershipTransferred(_owner, newOwner);
1841         _owner = newOwner;
1842     }
1843 }
1844 
1845 // File: contracts/genesis.sol
1846 
1847 /**
1848  * @title Pixlr Genesis contract
1849  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1850  */
1851 contract PixlrGenesis is ERC721, Ownable {
1852 
1853     event MemberAdded(address member);
1854     event MemberRemoved(address member);
1855 
1856     using SafeMath for uint256;
1857 
1858     string public GENESIS_PROVENANCE = "";
1859 
1860     uint256 public genesisPrice;
1861 
1862     uint public maxGenesisPerTxn;
1863 
1864     uint256 public constant MAX_GENESIS = 10000;
1865 
1866     bool public saleIsActivePreSale = false;
1867     bool public saleIsActiveTierA = false;
1868     bool public saleIsActiveTierB = false;
1869     bool public saleIsActiveTierC = false;
1870     bool public saleIsActiveTierD = false;
1871     bool public saleIsActiveTierE = false;
1872 
1873     uint256 MintCycleTierA = 2499;
1874     uint256 MintCycleTierB = 4499;
1875     uint256 MintCycleTierC = 6499;
1876     uint256 MintCycleTierD = 8499;
1877     uint256 MintCycleTierE = 9999;
1878 
1879     mapping (address => bool) members;
1880 
1881     constructor(string memory baseURI) ERC721("Pixlr Genesis", "PG") {
1882         _setBaseURI(baseURI);
1883     }
1884 
1885     function withdraw() public onlyOwner {
1886         uint balance = address(this).balance;
1887         require(balance > 0);
1888 
1889         msg.sender.transfer(balance);
1890     }
1891 
1892     /**
1893      * Set some genesis aside
1894      */
1895     function reserveGenesis(uint256 _maxMint) public onlyOwner {
1896         uint supply = totalSupply();
1897         uint i;
1898         for (i = 0; i < _maxMint; i++) {
1899             if (totalSupply() < MAX_GENESIS) {
1900                 _safeMint(msg.sender, supply + i);
1901             }
1902         }
1903     }
1904 
1905     /*
1906       * Set provenance once it's calculated
1907     */
1908     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1909         GENESIS_PROVENANCE = provenanceHash;
1910     }
1911 
1912     function setBaseURI(string memory baseURI) public onlyOwner {
1913         _setBaseURI(baseURI);
1914     }
1915 
1916     function setMaxperTransaction(uint256 _maxNFTPerTransaction) internal onlyOwner {
1917         maxGenesisPerTxn = _maxNFTPerTransaction;
1918     }
1919 
1920     /**
1921      * @dev A method to verify whether an address is a member of the whitelist
1922      * @param _member The address to verify.
1923      * @return Whether the address is a member of the whitelist.
1924      */
1925     function isMember(address _member) public view returns(bool)
1926     {
1927         return members[_member];
1928     }
1929 
1930     /**
1931      * @dev A method to add a member to the whitelist
1932      * @param addresses The member to add as a member.
1933      */
1934     function addMember(address[] calldata addresses) public onlyOwner
1935     {
1936         for (uint256 i = 0; i < addresses.length; i++) {
1937             require(addresses[i] != address(0), "Cannot add null address");
1938 
1939             members[addresses[i]] = true;
1940             
1941             emit MemberAdded(addresses[i]);
1942         }
1943     }
1944 
1945     /**
1946      * @dev A method to remove a member from the whitelist
1947      * @param _member The member to remove as a member.
1948      */
1949     function removeMember(address _member) public onlyOwner
1950     {
1951         require(
1952             isMember(_member),
1953             "Not member of whitelist."
1954         );
1955 
1956         delete members[_member];
1957         emit MemberRemoved(_member);
1958     }
1959 
1960     /*
1961     * Pause sale if active, make active if paused
1962     */
1963     function flipSaleStatePreSale(uint256 price, uint256 _maxMint) public onlyOwner {
1964         genesisPrice = price;
1965         setMaxperTransaction(_maxMint);
1966         saleIsActivePreSale = !saleIsActivePreSale;
1967     }
1968 
1969     function flipSaleStateTierA(uint256 price, uint256 _maxMint) public onlyOwner {
1970         genesisPrice = price;
1971         setMaxperTransaction(_maxMint);
1972         saleIsActiveTierA = !saleIsActiveTierA;
1973     }
1974 
1975     function flipSaleStateTierB(uint256 price, uint256 _maxMint) public onlyOwner {
1976         genesisPrice = price;
1977         setMaxperTransaction(_maxMint);
1978         saleIsActiveTierB = !saleIsActiveTierB;
1979     }
1980 
1981     function flipSaleStateTierC(uint256 price, uint256 _maxMint) public onlyOwner {
1982         genesisPrice = price;
1983         setMaxperTransaction(_maxMint);
1984         saleIsActiveTierC = !saleIsActiveTierC;
1985     }
1986 
1987     function flipSaleStateTierD(uint256 price, uint256 _maxMint) public onlyOwner {
1988         genesisPrice = price;
1989         setMaxperTransaction(_maxMint);
1990         saleIsActiveTierD = !saleIsActiveTierD;
1991     }
1992 
1993     function flipSaleStateTierE(uint256 price, uint256 _maxMint) public onlyOwner {
1994         genesisPrice = price;
1995         setMaxperTransaction(_maxMint);
1996         saleIsActiveTierE = !saleIsActiveTierE;
1997     }
1998 
1999     /**
2000     * Pre Sale Mints
2001     */
2002     function mintPreSale(uint numberOfTokens) public payable {
2003         require(saleIsActivePreSale, "Sale must be active to mint Pixlr Genesis");
2004         require(maxGenesisPerTxn > 0);
2005         require(totalSupply() <= MintCycleTierA);
2006         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2007         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Pixlr Genesis");
2008         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2009         require(members[msg.sender], "You are not in the whitelist to perform minting");
2010 
2011         for(uint i = 0; i < numberOfTokens; i++) {
2012             uint mintIndex = totalSupply();
2013             if (totalSupply() <= MintCycleTierA) {
2014                 _safeMint(msg.sender, mintIndex);
2015             }
2016         }
2017     }
2018 
2019     /**
2020     * Tier A Mints
2021     */
2022     function mintTierA(uint numberOfTokens) public payable {
2023         require(saleIsActiveTierA, "Sale must be active to mint Pixlr Genesis");
2024         require(maxGenesisPerTxn > 0);
2025         require(totalSupply() <= MintCycleTierA);
2026         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2027         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Pixlr Genesis");
2028         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2029 
2030         for(uint i = 0; i < numberOfTokens; i++) {
2031             uint mintIndex = totalSupply();
2032             if (totalSupply() <= MintCycleTierA) {
2033                 _safeMint(msg.sender, mintIndex);
2034             }
2035         }
2036     }
2037 
2038     /**
2039     * Tier B Mints
2040     */
2041     function mintTierB(uint numberOfTokens) public payable {
2042         require(saleIsActiveTierB, "Sale must be active to mint Pixlr Genesis");
2043         require(maxGenesisPerTxn > 0);
2044         require(totalSupply() <= MintCycleTierB);
2045         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2046         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Pixlr Genesis");
2047         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2048 
2049         for(uint i = 0; i < numberOfTokens; i++) {
2050             uint mintIndex = totalSupply();
2051             if (totalSupply() <= MintCycleTierB) {
2052                 _safeMint(msg.sender, mintIndex);
2053             }
2054         }
2055     }
2056 
2057     /**
2058     * Tier C Mints
2059     */
2060     function mintTierC(uint numberOfTokens) public payable {
2061         require(saleIsActiveTierC, "Sale must be active to mint Pixlr Genesis");
2062         require(maxGenesisPerTxn > 0);
2063         require(totalSupply() <= MintCycleTierC);
2064         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2065         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Pixlr Genesis");
2066         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2067 
2068         for(uint i = 0; i < numberOfTokens; i++) {
2069             uint mintIndex = totalSupply();
2070             if (totalSupply() <= MintCycleTierC) {
2071                 _safeMint(msg.sender, mintIndex);
2072             }
2073         }
2074     }
2075 
2076     /**
2077     * Tier D Mints
2078     */
2079     function mintTierD(uint numberOfTokens) public payable {
2080         require(saleIsActiveTierD, "Sale must be active to mint Pixlr Genesis");
2081         require(maxGenesisPerTxn > 0);
2082         require(totalSupply() <= MintCycleTierD);
2083         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2084         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Pixlr Genesis");
2085         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2086 
2087         for(uint i = 0; i < numberOfTokens; i++) {
2088             uint mintIndex = totalSupply();
2089             if (totalSupply() <= MintCycleTierD) {
2090                 _safeMint(msg.sender, mintIndex);
2091             }
2092         }
2093     }
2094 
2095     /**
2096     * Tier E Mints
2097     */
2098     function mintTierE(uint numberOfTokens) public payable {
2099         require(saleIsActiveTierE, "Sale must be active to mint Samurai Doges");
2100         require(maxGenesisPerTxn > 0);
2101         require(numberOfTokens <= maxGenesisPerTxn, "Cannot purchase this many tokens in a transaction");
2102         require(totalSupply().add(numberOfTokens) <= MAX_GENESIS, "Purchase would exceed max supply of Samurai Doges");
2103         require(genesisPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2104 
2105         for(uint i = 0; i < numberOfTokens; i++) {
2106             uint mintIndex = totalSupply();
2107             if (totalSupply() < MAX_GENESIS) {
2108                 _safeMint(msg.sender, mintIndex);
2109             }
2110         }
2111     }
2112 }