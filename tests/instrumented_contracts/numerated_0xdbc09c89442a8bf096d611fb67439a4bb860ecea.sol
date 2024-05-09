1 /*____________*_____________ */
2 /*___________***____________ */
3 /*__________*****___________ */
4 /*_________*******__________ */
5 /*__________*****___________ */
6 /*___________***____________ */
7 /*__________* * *___________ */
8 /*_________*******__________ */
9 /*________*********_________ */
10 /*_______***********________ */
11 /*________*********_________ */
12 /*_________*******__________ */
13 /*__________*****___________ */
14 /*___________***____________ */
15 /*____________*_____________ */
16 /*__________________________ */
17 /*   https://Peopleeum.com   */
18  /*Submitted for verification at Etherscan.io on 2021-09-01
19 */
20 
21 // SPDX-License-Identifier: AGPL-3.0-or-later
22 pragma solidity ^0.7.6;
23 
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
46 
47 /**
48  * @dev Interface of the ERC165 standard, as defined in the
49  * https://eips.ethereum.org/EIPS/eip-165[EIP].
50  *
51  * Implementers can declare support of contract interfaces, which can then be
52  * queried by others ({ERC165Checker}).
53  *
54  * For an implementation, see {ERC165}.
55  */
56 interface IERC165 {
57     /**
58      * @dev Returns true if this contract implements the interface defined by
59      * `interfaceId`. See the corresponding
60      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
61      * to learn more about how these ids are created.
62      *
63      * This function call must use less than 30 000 gas.
64      */
65     function supportsInterface(bytes4 interfaceId) external view returns (bool);
66 }
67 
68 
69 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
70 
71 /**
72  * @dev Required interface of an ERC721 compliant contract.
73  */
74 interface IERC721 is IERC165 {
75     /**
76      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
82      */
83     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
89 
90     /**
91      * @dev Returns the number of tokens in ``owner``'s account.
92      */
93     function balanceOf(address owner) external view returns (uint256 balance);
94 
95     /**
96      * @dev Returns the owner of the `tokenId` token.
97      *
98      * Requirements:
99      *
100      * - `tokenId` must exist.
101      */
102     function ownerOf(uint256 tokenId) external view returns (address owner);
103 
104     /**
105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must exist and be owned by `from`.
113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
115      *
116      * Emits a {Transfer} event.
117      */
118     function safeTransferFrom(address from, address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(address from, address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
138      * The approval is cleared when the token is transferred.
139      *
140      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
141      *
142      * Requirements:
143      *
144      * - The caller must own the token or be an approved operator.
145      * - `tokenId` must exist.
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Returns the account approved for `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function getApproved(uint256 tokenId) external view returns (address operator);
159 
160     /**
161      * @dev Approve or remove `operator` as an operator for the caller.
162      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
163      *
164      * Requirements:
165      *
166      * - The `operator` cannot be the caller.
167      *
168      * Emits an {ApprovalForAll} event.
169      */
170     function setApprovalForAll(address operator, bool _approved) external;
171 
172     /**
173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
174      *
175      * See {setApprovalForAll}
176      */
177     function isApprovedForAll(address owner, address operator) external view returns (bool);
178 
179     /**
180       * @dev Safely transfers `tokenId` token from `from` to `to`.
181       *
182       * Requirements:
183       *
184       * - `from` cannot be the zero address.
185       * - `to` cannot be the zero address.
186       * - `tokenId` token must exist and be owned by `from`.
187       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189       *
190       * Emits a {Transfer} event.
191       */
192     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
193 }
194 
195 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.0
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202 
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.0
220 
221 /**
222  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
223  * @dev See https://eips.ethereum.org/EIPS/eip-721
224  */
225 interface IERC721Enumerable is IERC721 {
226 
227     /**
228      * @dev Returns the total amount of tokens stored by the contract.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
234      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
235      */
236     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
237 
238     /**
239      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
240      * Use along with {totalSupply} to enumerate all tokens.
241      */
242     function tokenByIndex(uint256 index) external view returns (uint256);
243 }
244 
245 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.0
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by `operator` from `from`, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
261      */
262     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
263 }
264 
265 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.0
266 
267 /**
268  * @dev Implementation of the {IERC165} interface.
269  *
270  * Contracts may inherit from this and call {_registerInterface} to declare
271  * their support of an interface.
272  */
273 abstract contract ERC165 is IERC165 {
274     /*
275      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
276      */
277     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
278 
279     /**
280      * @dev Mapping of interface ids to whether or not it's supported.
281      */
282     mapping(bytes4 => bool) private _supportedInterfaces;
283 
284     constructor () internal {
285         // Derived contracts need only register support for their own interfaces,
286         // we register support for ERC165 itself here
287         _registerInterface(_INTERFACE_ID_ERC165);
288     }
289 
290     /**
291      * @dev See {IERC165-supportsInterface}.
292      *
293      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
296         return _supportedInterfaces[interfaceId];
297     }
298 
299     /**
300      * @dev Registers the contract as an implementer of the interface defined by
301      * `interfaceId`. Support of the actual ERC165 interface is automatic and
302      * registering its interface id is not required.
303      *
304      * See {IERC165-supportsInterface}.
305      *
306      * Requirements:
307      *
308      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
309      */
310     function _registerInterface(bytes4 interfaceId) internal virtual {
311         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
312         _supportedInterfaces[interfaceId] = true;
313     }
314 }
315 
316 
317 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
318 
319 /**
320  * @dev Wrappers over Solidity's arithmetic operations with added overflow
321  * checks.
322  *
323  * Arithmetic operations in Solidity wrap on overflow. This can easily result
324  * in bugs, because programmers usually assume that an overflow raises an
325  * error, which is the standard behavior in high level programming languages.
326  * `SafeMath` restores this intuition by reverting the transaction when an
327  * operation overflows.
328  *
329  * Using this library instead of the unchecked operations eliminates an entire
330  * class of bugs, so it's recommended to use it always.
331  */
332 library SafeMath {
333     /**
334      * @dev Returns the addition of two unsigned integers, with an overflow flag.
335      *
336      * _Available since v3.4._
337      */
338     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
339         uint256 c = a + b;
340         if (c < a) return (false, 0);
341         return (true, c);
342     }
343 
344     /**
345      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
346      *
347      * _Available since v3.4._
348      */
349     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
350         if (b > a) return (false, 0);
351         return (true, a - b);
352     }
353 
354     /**
355      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
356      *
357      * _Available since v3.4._
358      */
359     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
361         // benefit is lost if 'b' is also tested.
362         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
363         if (a == 0) return (true, 0);
364         uint256 c = a * b;
365         if (c / a != b) return (false, 0);
366         return (true, c);
367     }
368 
369     /**
370      * @dev Returns the division of two unsigned integers, with a division by zero flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         if (b == 0) return (false, 0);
376         return (true, a / b);
377     }
378 
379     /**
380      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385         if (b == 0) return (false, 0);
386         return (true, a % b);
387     }
388 
389     /**
390      * @dev Returns the addition of two unsigned integers, reverting on
391      * overflow.
392      *
393      * Counterpart to Solidity's `+` operator.
394      *
395      * Requirements:
396      *
397      * - Addition cannot overflow.
398      */
399     function add(uint256 a, uint256 b) internal pure returns (uint256) {
400         uint256 c = a + b;
401         require(c >= a, "SafeMath: addition overflow");
402         return c;
403     }
404 
405     /**
406      * @dev Returns the subtraction of two unsigned integers, reverting on
407      * overflow (when the result is negative).
408      *
409      * Counterpart to Solidity's `-` operator.
410      *
411      * Requirements:
412      *
413      * - Subtraction cannot overflow.
414      */
415     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
416         require(b <= a, "SafeMath: subtraction overflow");
417         return a - b;
418     }
419 
420     /**
421      * @dev Returns the multiplication of two unsigned integers, reverting on
422      * overflow.
423      *
424      * Counterpart to Solidity's `*` operator.
425      *
426      * Requirements:
427      *
428      * - Multiplication cannot overflow.
429      */
430     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
431         if (a == 0) return 0;
432         uint256 c = a * b;
433         require(c / a == b, "SafeMath: multiplication overflow");
434         return c;
435     }
436 
437     /**
438      * @dev Returns the integer division of two unsigned integers, reverting on
439      * division by zero. The result is rounded towards zero.
440      *
441      * Counterpart to Solidity's `/` operator. Note: this function uses a
442      * `revert` opcode (which leaves remaining gas untouched) while Solidity
443      * uses an invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      *
447      * - The divisor cannot be zero.
448      */
449     function div(uint256 a, uint256 b) internal pure returns (uint256) {
450         require(b > 0, "SafeMath: division by zero");
451         return a / b;
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
456      * reverting when dividing by zero.
457      *
458      * Counterpart to Solidity's `%` operator. This function uses a `revert`
459      * opcode (which leaves remaining gas untouched) while Solidity uses an
460      * invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
467         require(b > 0, "SafeMath: modulo by zero");
468         return a % b;
469     }
470 
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
473      * overflow (when the result is negative).
474      *
475      * CAUTION: This function is deprecated because it requires allocating memory for the error
476      * message unnecessarily. For custom revert reasons use {trySub}.
477      *
478      * Counterpart to Solidity's `-` operator.
479      *
480      * Requirements:
481      *
482      * - Subtraction cannot overflow.
483      */
484     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         require(b <= a, errorMessage);
486         return a - b;
487     }
488 
489     /**
490      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
491      * division by zero. The result is rounded towards zero.
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {tryDiv}.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b > 0, errorMessage);
506         return a / b;
507     }
508 
509     /**
510      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
511      * reverting with custom message when dividing by zero.
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {tryMod}.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b > 0, errorMessage);
526         return a % b;
527     }
528 }
529 
530 
531 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
532 
533 /**
534  * @dev Collection of functions related to the address type
535  */
536 library Address {
537     /**
538      * @dev Returns true if `account` is a contract.
539      *
540      * [IMPORTANT]
541      * ====
542      * It is unsafe to assume that an address for which this function returns
543      * false is an externally-owned account (EOA) and not a contract.
544      *
545      * Among others, `isContract` will return false for the following
546      * types of addresses:
547      *
548      *  - an externally-owned account
549      *  - a contract in construction
550      *  - an address where a contract will be created
551      *  - an address where a contract lived, but was destroyed
552      * ====
553      */
554     function isContract(address account) internal view returns (bool) {
555         // This method relies on extcodesize, which returns 0 for contracts in
556         // construction, since the code is only stored at the end of the
557         // constructor execution.
558 
559         uint256 size;
560         // solhint-disable-next-line no-inline-assembly
561         assembly { size := extcodesize(account) }
562         return size > 0;
563     }
564 
565     /**
566      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
567      * `recipient`, forwarding all available gas and reverting on errors.
568      *
569      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
570      * of certain opcodes, possibly making contracts go over the 2300 gas limit
571      * imposed by `transfer`, making them unable to receive funds via
572      * `transfer`. {sendValue} removes this limitation.
573      *
574      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
575      *
576      * IMPORTANT: because control is transferred to `recipient`, care must be
577      * taken to not create reentrancy vulnerabilities. Consider using
578      * {ReentrancyGuard} or the
579      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
580      */
581     function sendValue(address payable recipient, uint256 amount) internal {
582         require(address(this).balance >= amount, "Address: insufficient balance");
583 
584         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
585         (bool success, ) = recipient.call{ value: amount }("");
586         require(success, "Address: unable to send value, recipient may have reverted");
587     }
588 
589     /**
590      * @dev Performs a Solidity function call using a low level `call`. A
591      * plain`call` is an unsafe replacement for a function call: use this
592      * function instead.
593      *
594      * If `target` reverts with a revert reason, it is bubbled up by this
595      * function (like regular Solidity function calls).
596      *
597      * Returns the raw returned data. To convert to the expected return value,
598      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
599      *
600      * Requirements:
601      *
602      * - `target` must be a contract.
603      * - calling `target` with `data` must not revert.
604      *
605      * _Available since v3.1._
606      */
607     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
608       return functionCall(target, data, "Address: low-level call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
613      * `errorMessage` as a fallback revert reason when `target` reverts.
614      *
615      * _Available since v3.1._
616      */
617     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
618         return functionCallWithValue(target, data, 0, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but also transferring `value` wei to `target`.
624      *
625      * Requirements:
626      *
627      * - the calling contract must have an ETH balance of at least `value`.
628      * - the called Solidity function must be `payable`.
629      *
630      * _Available since v3.1._
631      */
632     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
638      * with `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
643         require(address(this).balance >= value, "Address: insufficient balance for call");
644         require(isContract(target), "Address: call to non-contract");
645 
646         // solhint-disable-next-line avoid-low-level-calls
647         (bool success, bytes memory returndata) = target.call{ value: value }(data);
648         return _verifyCallResult(success, returndata, errorMessage);
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
653      * but performing a static call.
654      *
655      * _Available since v3.3._
656      */
657     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
658         return functionStaticCall(target, data, "Address: low-level static call failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
663      * but performing a static call.
664      *
665      * _Available since v3.3._
666      */
667     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
668         require(isContract(target), "Address: static call to non-contract");
669 
670         // solhint-disable-next-line avoid-low-level-calls
671         (bool success, bytes memory returndata) = target.staticcall(data);
672         return _verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
682         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
687      * but performing a delegate call.
688      *
689      * _Available since v3.4._
690      */
691     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
692         require(isContract(target), "Address: delegate call to non-contract");
693 
694         // solhint-disable-next-line avoid-low-level-calls
695         (bool success, bytes memory returndata) = target.delegatecall(data);
696         return _verifyCallResult(success, returndata, errorMessage);
697     }
698 
699     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
700         if (success) {
701             return returndata;
702         } else {
703             // Look for revert reason and bubble it up if present
704             if (returndata.length > 0) {
705                 // The easiest way to bubble the revert reason is using memory via assembly
706 
707                 // solhint-disable-next-line no-inline-assembly
708                 assembly {
709                     let returndata_size := mload(returndata)
710                     revert(add(32, returndata), returndata_size)
711                 }
712             } else {
713                 revert(errorMessage);
714             }
715         }
716     }
717 }
718 
719 
720 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.0
721 
722 /**
723  * @dev Library for managing
724  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
725  * types.
726  *
727  * Sets have the following properties:
728  *
729  * - Elements are added, removed, and checked for existence in constant time
730  * (O(1)).
731  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
732  *
733  * ```
734  * contract Example {
735  *     // Add the library methods
736  *     using EnumerableSet for EnumerableSet.AddressSet;
737  *
738  *     // Declare a set state variable
739  *     EnumerableSet.AddressSet private mySet;
740  * }
741  * ```
742  *
743  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
744  * and `uint256` (`UintSet`) are supported.
745  */
746 library EnumerableSet {
747     // To implement this library for multiple types with as little code
748     // repetition as possible, we write it in terms of a generic Set type with
749     // bytes32 values.
750     // The Set implementation uses private functions, and user-facing
751     // implementations (such as AddressSet) are just wrappers around the
752     // underlying Set.
753     // This means that we can only create new EnumerableSets for types that fit
754     // in bytes32.
755 
756     struct Set {
757         // Storage of set values
758         bytes32[] _values;
759 
760         // Position of the value in the `values` array, plus 1 because index 0
761         // means a value is not in the set.
762         mapping (bytes32 => uint256) _indexes;
763     }
764 
765     /**
766      * @dev Add a value to a set. O(1).
767      *
768      * Returns true if the value was added to the set, that is if it was not
769      * already present.
770      */
771     function _add(Set storage set, bytes32 value) private returns (bool) {
772         if (!_contains(set, value)) {
773             set._values.push(value);
774             // The value is stored at length-1, but we add 1 to all indexes
775             // and use 0 as a sentinel value
776             set._indexes[value] = set._values.length;
777             return true;
778         } else {
779             return false;
780         }
781     }
782 
783     /**
784      * @dev Removes a value from a set. O(1).
785      *
786      * Returns true if the value was removed from the set, that is if it was
787      * present.
788      */
789     function _remove(Set storage set, bytes32 value) private returns (bool) {
790         // We read and store the value's index to prevent multiple reads from the same storage slot
791         uint256 valueIndex = set._indexes[value];
792 
793         if (valueIndex != 0) { // Equivalent to contains(set, value)
794             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
795             // the array, and then remove the last element (sometimes called as 'swap and pop').
796             // This modifies the order of the array, as noted in {at}.
797 
798             uint256 toDeleteIndex = valueIndex - 1;
799             uint256 lastIndex = set._values.length - 1;
800 
801             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
802             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
803 
804             bytes32 lastvalue = set._values[lastIndex];
805 
806             // Move the last value to the index where the value to delete is
807             set._values[toDeleteIndex] = lastvalue;
808             // Update the index for the moved value
809             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
810 
811             // Delete the slot where the moved value was stored
812             set._values.pop();
813 
814             // Delete the index for the deleted slot
815             delete set._indexes[value];
816 
817             return true;
818         } else {
819             return false;
820         }
821     }
822 
823     /**
824      * @dev Returns true if the value is in the set. O(1).
825      */
826     function _contains(Set storage set, bytes32 value) private view returns (bool) {
827         return set._indexes[value] != 0;
828     }
829 
830     /**
831      * @dev Returns the number of values on the set. O(1).
832      */
833     function _length(Set storage set) private view returns (uint256) {
834         return set._values.length;
835     }
836 
837    /**
838     * @dev Returns the value stored at position `index` in the set. O(1).
839     *
840     * Note that there are no guarantees on the ordering of values inside the
841     * array, and it may change when more values are added or removed.
842     *
843     * Requirements:
844     *
845     * - `index` must be strictly less than {length}.
846     */
847     function _at(Set storage set, uint256 index) private view returns (bytes32) {
848         require(set._values.length > index, "EnumerableSet: index out of bounds");
849         return set._values[index];
850     }
851 
852     // Bytes32Set
853 
854     struct Bytes32Set {
855         Set _inner;
856     }
857 
858     /**
859      * @dev Add a value to a set. O(1).
860      *
861      * Returns true if the value was added to the set, that is if it was not
862      * already present.
863      */
864     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
865         return _add(set._inner, value);
866     }
867 
868     /**
869      * @dev Removes a value from a set. O(1).
870      *
871      * Returns true if the value was removed from the set, that is if it was
872      * present.
873      */
874     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
875         return _remove(set._inner, value);
876     }
877 
878     /**
879      * @dev Returns true if the value is in the set. O(1).
880      */
881     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
882         return _contains(set._inner, value);
883     }
884 
885     /**
886      * @dev Returns the number of values in the set. O(1).
887      */
888     function length(Bytes32Set storage set) internal view returns (uint256) {
889         return _length(set._inner);
890     }
891 
892    /**
893     * @dev Returns the value stored at position `index` in the set. O(1).
894     *
895     * Note that there are no guarantees on the ordering of values inside the
896     * array, and it may change when more values are added or removed.
897     *
898     * Requirements:
899     *
900     * - `index` must be strictly less than {length}.
901     */
902     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
903         return _at(set._inner, index);
904     }
905 
906     // AddressSet
907 
908     struct AddressSet {
909         Set _inner;
910     }
911 
912     /**
913      * @dev Add a value to a set. O(1).
914      *
915      * Returns true if the value was added to the set, that is if it was not
916      * already present.
917      */
918     function add(AddressSet storage set, address value) internal returns (bool) {
919         return _add(set._inner, bytes32(uint256(uint160(value))));
920     }
921 
922     /**
923      * @dev Removes a value from a set. O(1).
924      *
925      * Returns true if the value was removed from the set, that is if it was
926      * present.
927      */
928     function remove(AddressSet storage set, address value) internal returns (bool) {
929         return _remove(set._inner, bytes32(uint256(uint160(value))));
930     }
931 
932     /**
933      * @dev Returns true if the value is in the set. O(1).
934      */
935     function contains(AddressSet storage set, address value) internal view returns (bool) {
936         return _contains(set._inner, bytes32(uint256(uint160(value))));
937     }
938 
939     /**
940      * @dev Returns the number of values in the set. O(1).
941      */
942     function length(AddressSet storage set) internal view returns (uint256) {
943         return _length(set._inner);
944     }
945 
946    /**
947     * @dev Returns the value stored at position `index` in the set. O(1).
948     *
949     * Note that there are no guarantees on the ordering of values inside the
950     * array, and it may change when more values are added or removed.
951     *
952     * Requirements:
953     *
954     * - `index` must be strictly less than {length}.
955     */
956     function at(AddressSet storage set, uint256 index) internal view returns (address) {
957         return address(uint160(uint256(_at(set._inner, index))));
958     }
959 
960 
961     // UintSet
962 
963     struct UintSet {
964         Set _inner;
965     }
966 
967     /**
968      * @dev Add a value to a set. O(1).
969      *
970      * Returns true if the value was added to the set, that is if it was not
971      * already present.
972      */
973     function add(UintSet storage set, uint256 value) internal returns (bool) {
974         return _add(set._inner, bytes32(value));
975     }
976 
977     /**
978      * @dev Removes a value from a set. O(1).
979      *
980      * Returns true if the value was removed from the set, that is if it was
981      * present.
982      */
983     function remove(UintSet storage set, uint256 value) internal returns (bool) {
984         return _remove(set._inner, bytes32(value));
985     }
986 
987     /**
988      * @dev Returns true if the value is in the set. O(1).
989      */
990     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
991         return _contains(set._inner, bytes32(value));
992     }
993 
994     /**
995      * @dev Returns the number of values on the set. O(1).
996      */
997     function length(UintSet storage set) internal view returns (uint256) {
998         return _length(set._inner);
999     }
1000 
1001    /**
1002     * @dev Returns the value stored at position `index` in the set. O(1).
1003     *
1004     * Note that there are no guarantees on the ordering of values inside the
1005     * array, and it may change when more values are added or removed.
1006     *
1007     * Requirements:
1008     *
1009     * - `index` must be strictly less than {length}.
1010     */
1011     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1012         return uint256(_at(set._inner, index));
1013     }
1014 }
1015 
1016 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.0
1017 
1018 /**
1019  * @dev Library for managing an enumerable variant of Solidity's
1020  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1021  * type.
1022  *
1023  * Maps have the following properties:
1024  *
1025  * - Entries are added, removed, and checked for existence in constant time
1026  * (O(1)).
1027  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1028  *
1029  * ```
1030  * contract Example {
1031  *     // Add the library methods
1032  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1033  *
1034  *     // Declare a set state variable
1035  *     EnumerableMap.UintToAddressMap private myMap;
1036  * }
1037  * ```
1038  *
1039  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1040  * supported.
1041  */
1042 library EnumerableMap {
1043     // To implement this library for multiple types with as little code
1044     // repetition as possible, we write it in terms of a generic Map type with
1045     // bytes32 keys and values.
1046     // The Map implementation uses private functions, and user-facing
1047     // implementations (such as Uint256ToAddressMap) are just wrappers around
1048     // the underlying Map.
1049     // This means that we can only create new EnumerableMaps for types that fit
1050     // in bytes32.
1051 
1052     struct MapEntry {
1053         bytes32 _key;
1054         bytes32 _value;
1055     }
1056 
1057     struct Map {
1058         // Storage of map keys and values
1059         MapEntry[] _entries;
1060 
1061         // Position of the entry defined by a key in the `entries` array, plus 1
1062         // because index 0 means a key is not in the map.
1063         mapping (bytes32 => uint256) _indexes;
1064     }
1065 
1066     /**
1067      * @dev Adds a key-value pair to a map, or updates the value for an existing
1068      * key. O(1).
1069      *
1070      * Returns true if the key was added to the map, that is if it was not
1071      * already present.
1072      */
1073     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1074         // We read and store the key's index to prevent multiple reads from the same storage slot
1075         uint256 keyIndex = map._indexes[key];
1076 
1077         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1078             map._entries.push(MapEntry({ _key: key, _value: value }));
1079             // The entry is stored at length-1, but we add 1 to all indexes
1080             // and use 0 as a sentinel value
1081             map._indexes[key] = map._entries.length;
1082             return true;
1083         } else {
1084             map._entries[keyIndex - 1]._value = value;
1085             return false;
1086         }
1087     }
1088 
1089     /**
1090      * @dev Removes a key-value pair from a map. O(1).
1091      *
1092      * Returns true if the key was removed from the map, that is if it was present.
1093      */
1094     function _remove(Map storage map, bytes32 key) private returns (bool) {
1095         // We read and store the key's index to prevent multiple reads from the same storage slot
1096         uint256 keyIndex = map._indexes[key];
1097 
1098         if (keyIndex != 0) { // Equivalent to contains(map, key)
1099             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1100             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1101             // This modifies the order of the array, as noted in {at}.
1102 
1103             uint256 toDeleteIndex = keyIndex - 1;
1104             uint256 lastIndex = map._entries.length - 1;
1105 
1106             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1107             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1108 
1109             MapEntry storage lastEntry = map._entries[lastIndex];
1110 
1111             // Move the last entry to the index where the entry to delete is
1112             map._entries[toDeleteIndex] = lastEntry;
1113             // Update the index for the moved entry
1114             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1115 
1116             // Delete the slot where the moved entry was stored
1117             map._entries.pop();
1118 
1119             // Delete the index for the deleted slot
1120             delete map._indexes[key];
1121 
1122             return true;
1123         } else {
1124             return false;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Returns true if the key is in the map. O(1).
1130      */
1131     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1132         return map._indexes[key] != 0;
1133     }
1134 
1135     /**
1136      * @dev Returns the number of key-value pairs in the map. O(1).
1137      */
1138     function _length(Map storage map) private view returns (uint256) {
1139         return map._entries.length;
1140     }
1141 
1142    /**
1143     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1144     *
1145     * Note that there are no guarantees on the ordering of entries inside the
1146     * array, and it may change when more entries are added or removed.
1147     *
1148     * Requirements:
1149     *
1150     * - `index` must be strictly less than {length}.
1151     */
1152     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1153         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1154 
1155         MapEntry storage entry = map._entries[index];
1156         return (entry._key, entry._value);
1157     }
1158 
1159     /**
1160      * @dev Tries to returns the value associated with `key`.  O(1).
1161      * Does not revert if `key` is not in the map.
1162      */
1163     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1164         uint256 keyIndex = map._indexes[key];
1165         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1166         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1167     }
1168 
1169     /**
1170      * @dev Returns the value associated with `key`.  O(1).
1171      *
1172      * Requirements:
1173      *
1174      * - `key` must be in the map.
1175      */
1176     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1177         uint256 keyIndex = map._indexes[key];
1178         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1179         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1180     }
1181 
1182     /**
1183      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1184      *
1185      * CAUTION: This function is deprecated because it requires allocating memory for the error
1186      * message unnecessarily. For custom revert reasons use {_tryGet}.
1187      */
1188     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1189         uint256 keyIndex = map._indexes[key];
1190         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1191         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1192     }
1193 
1194     // UintToAddressMap
1195 
1196     struct UintToAddressMap {
1197         Map _inner;
1198     }
1199 
1200     /**
1201      * @dev Adds a key-value pair to a map, or updates the value for an existing
1202      * key. O(1).
1203      *
1204      * Returns true if the key was added to the map, that is if it was not
1205      * already present.
1206      */
1207     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1208         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1209     }
1210 
1211     /**
1212      * @dev Removes a value from a set. O(1).
1213      *
1214      * Returns true if the key was removed from the map, that is if it was present.
1215      */
1216     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1217         return _remove(map._inner, bytes32(key));
1218     }
1219 
1220     /**
1221      * @dev Returns true if the key is in the map. O(1).
1222      */
1223     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1224         return _contains(map._inner, bytes32(key));
1225     }
1226 
1227     /**
1228      * @dev Returns the number of elements in the map. O(1).
1229      */
1230     function length(UintToAddressMap storage map) internal view returns (uint256) {
1231         return _length(map._inner);
1232     }
1233 
1234    /**
1235     * @dev Returns the element stored at position `index` in the set. O(1).
1236     * Note that there are no guarantees on the ordering of values inside the
1237     * array, and it may change when more values are added or removed.
1238     *
1239     * Requirements:
1240     *
1241     * - `index` must be strictly less than {length}.
1242     */
1243     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1244         (bytes32 key, bytes32 value) = _at(map._inner, index);
1245         return (uint256(key), address(uint160(uint256(value))));
1246     }
1247 
1248     /**
1249      * @dev Tries to returns the value associated with `key`.  O(1).
1250      * Does not revert if `key` is not in the map.
1251      *
1252      * _Available since v3.4._
1253      */
1254     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1255         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1256         return (success, address(uint160(uint256(value))));
1257     }
1258 
1259     /**
1260      * @dev Returns the value associated with `key`.  O(1).
1261      *
1262      * Requirements:
1263      *
1264      * - `key` must be in the map.
1265      */
1266     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1267         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1268     }
1269 
1270     /**
1271      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1272      *
1273      * CAUTION: This function is deprecated because it requires allocating memory for the error
1274      * message unnecessarily. For custom revert reasons use {tryGet}.
1275      */
1276     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1277         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1278     }
1279 }
1280 
1281 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.0
1282 
1283 /**
1284  * @dev String operations.
1285  */
1286 library Strings {
1287     /**
1288      * @dev Converts a `uint256` to its ASCII `string` representation.
1289      */
1290     function toString(uint256 value) internal pure returns (string memory) {
1291         // Inspired by OraclizeAPI's implementation - MIT licence
1292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1293 
1294         if (value == 0) {
1295             return "0";
1296         }
1297         uint256 temp = value;
1298         uint256 digits;
1299         while (temp != 0) {
1300             digits++;
1301             temp /= 10;
1302         }
1303         bytes memory buffer = new bytes(digits);
1304         uint256 index = digits - 1;
1305         temp = value;
1306         while (temp != 0) {
1307             buffer[index--] = bytes1(uint8(48 + temp % 10));
1308             temp /= 10;
1309         }
1310         return string(buffer);
1311     }
1312 }
1313 
1314 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.0
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
1435         string memory _tokenURI = _tokenURIs[tokenId];
1436         string memory base = baseURI();
1437 
1438         // If there is no base URI, return the token URI.
1439         if (bytes(base).length == 0) {
1440             return _tokenURI;
1441         }
1442         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1443         if (bytes(_tokenURI).length > 0) {
1444             return string(abi.encodePacked(base, _tokenURI));
1445         }
1446         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1447         return string(abi.encodePacked(base, tokenId.toString()));
1448     }
1449 
1450     /**
1451     * @dev Returns the base URI set via {_setBaseURI}. This will be
1452     * automatically added as a prefix in {tokenURI} to each token's URI, or
1453     * to the token ID if no specific URI is set for that token ID.
1454     */
1455     function baseURI() public view virtual returns (string memory) {
1456         return _baseURI;
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1461      */
1462     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1463         return _holderTokens[owner].at(index);
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Enumerable-totalSupply}.
1468      */
1469     function totalSupply() public view virtual override returns (uint256) {
1470         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1471         return _tokenOwners.length();
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-tokenByIndex}.
1476      */
1477     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1478         (uint256 tokenId, ) = _tokenOwners.at(index);
1479         return tokenId;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-approve}.
1484      */
1485     function approve(address to, uint256 tokenId) public virtual override {
1486         address owner = ERC721.ownerOf(tokenId);
1487         require(to != owner, "ERC721: approval to current owner");
1488 
1489         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1490             "ERC721: approve caller is not owner nor approved for all"
1491         );
1492 
1493         _approve(to, tokenId);
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-getApproved}.
1498      */
1499     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1500         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1501 
1502         return _tokenApprovals[tokenId];
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-setApprovalForAll}.
1507      */
1508     function setApprovalForAll(address operator, bool approved) public virtual override {
1509         require(operator != _msgSender(), "ERC721: approve to caller");
1510 
1511         _operatorApprovals[_msgSender()][operator] = approved;
1512         emit ApprovalForAll(_msgSender(), operator, approved);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-isApprovedForAll}.
1517      */
1518     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1519         return _operatorApprovals[owner][operator];
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-transferFrom}.
1524      */
1525     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1526         //solhint-disable-next-line max-line-length
1527         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1528 
1529         _transfer(from, to, tokenId);
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-safeTransferFrom}.
1534      */
1535     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1536         safeTransferFrom(from, to, tokenId, "");
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-safeTransferFrom}.
1541      */
1542     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1543         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1544         _safeTransfer(from, to, tokenId, _data);
1545     }
1546 
1547     /**
1548      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1549      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1550      *
1551      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1552      *
1553      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1554      * implement alternative mechanisms to perform token transfer, such as signature-based.
1555      *
1556      * Requirements:
1557      *
1558      * - `from` cannot be the zero address.
1559      * - `to` cannot be the zero address.
1560      * - `tokenId` token must exist and be owned by `from`.
1561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1566         _transfer(from, to, tokenId);
1567         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1568     }
1569 
1570     /**
1571      * @dev Returns whether `tokenId` exists.
1572      *
1573      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1574      *
1575      * Tokens start existing when they are minted (`_mint`),
1576      * and stop existing when they are burned (`_burn`).
1577      */
1578     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1579         return _tokenOwners.contains(tokenId);
1580     }
1581 
1582     /**
1583      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must exist.
1588      */
1589     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1590         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1591         address owner = ERC721.ownerOf(tokenId);
1592         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1593     }
1594 
1595     /**
1596      * @dev Safely mints `tokenId` and transfers it to `to`.
1597      *
1598      * Requirements:
1599      d*
1600      * - `tokenId` must not exist.
1601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function _safeMint(address to, uint256 tokenId) internal virtual {
1606         _safeMint(to, tokenId, "");
1607     }
1608 
1609     /**
1610      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1611      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1612      */
1613     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1614         _mint(to, tokenId);
1615         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1616     }
1617 
1618     /**
1619      * @dev Mints `tokenId` and transfers it to `to`.
1620      *
1621      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1622      *
1623      * Requirements:
1624      *
1625      * - `tokenId` must not exist.
1626      * - `to` cannot be the zero address.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _mint(address to, uint256 tokenId) internal virtual {
1631         require(to != address(0), "ERC721: mint to the zero address");
1632         require(!_exists(tokenId), "ERC721: token already minted");
1633 
1634         _beforeTokenTransfer(address(0), to, tokenId);
1635 
1636         _holderTokens[to].add(tokenId);
1637 
1638         _tokenOwners.set(tokenId, to);
1639 
1640         emit Transfer(address(0), to, tokenId);
1641     }
1642 
1643     /**
1644      * @dev Destroys `tokenId`.
1645      * The approval is cleared when the token is burned.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function _burn(uint256 tokenId) internal virtual {
1654         address owner = ERC721.ownerOf(tokenId); // internal owner
1655 
1656         _beforeTokenTransfer(owner, address(0), tokenId);
1657 
1658         // Clear approvals
1659         _approve(address(0), tokenId);
1660 
1661         // Clear metadata (if any)
1662         if (bytes(_tokenURIs[tokenId]).length != 0) {
1663             delete _tokenURIs[tokenId];
1664         }
1665 
1666         _holderTokens[owner].remove(tokenId);
1667 
1668         _tokenOwners.remove(tokenId);
1669 
1670         emit Transfer(owner, address(0), tokenId);
1671     }
1672 
1673     /**
1674      * @dev Transfers `tokenId` from `from` to `to`.
1675      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1676      *
1677      * Requirements:
1678      *
1679      * - `to` cannot be the zero address.
1680      * - `tokenId` token must be owned by `from`.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1685         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1686         require(to != address(0), "ERC721: transfer to the zero address");
1687 
1688         _beforeTokenTransfer(from, to, tokenId);
1689 
1690         // Clear approvals from the previous owner
1691         _approve(address(0), tokenId);
1692 
1693         _holderTokens[from].remove(tokenId);
1694         _holderTokens[to].add(tokenId);
1695 
1696         _tokenOwners.set(tokenId, to);
1697 
1698         emit Transfer(from, to, tokenId);
1699     }
1700 
1701     /**
1702      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1703      *
1704      * Requirements:
1705      *
1706      * - `tokenId` must exist.
1707      */
1708     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1709         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1710         _tokenURIs[tokenId] = _tokenURI;
1711     }
1712 
1713     /**
1714      * @dev Internal function to set the base URI for all token IDs. It is
1715      * automatically added as a prefix to the value returned in {tokenURI},
1716      * or to the token ID if {tokenURI} is empty.
1717      */
1718     function _setBaseURI(string memory baseURI_) internal virtual {
1719         _baseURI = baseURI_;
1720     }
1721 
1722     /**
1723      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1724      * The call is not executed if the target address is not a contract.
1725      *
1726      * @param from address representing the previous owner of the given token ID
1727      * @param to target address that will receive the tokens
1728      * @param tokenId uint256 ID of the token to be transferred
1729      * @param _data bytes optional data to send along with the call
1730      * @return bool whether the call correctly returned the expected magic value
1731      */
1732     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1733         private returns (bool)
1734     {
1735         if (!to.isContract()) {
1736             return true;
1737         }
1738         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1739             IERC721Receiver(to).onERC721Received.selector,
1740             _msgSender(),
1741             from,
1742             tokenId,
1743             _data
1744         ), "ERC721: transfer to non ERC721Receiver implementer");
1745         bytes4 retval = abi.decode(returndata, (bytes4));
1746         return (retval == _ERC721_RECEIVED);
1747     }
1748 
1749     function _approve(address to, uint256 tokenId) private {
1750         _tokenApprovals[tokenId] = to;
1751         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1752     }
1753 
1754     /**
1755      * @dev Hook that is called before any token transfer. This includes minting
1756      * and burning.
1757      *
1758      * Calling conditions:
1759      *
1760      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1761      * transferred to `to`.
1762      * - When `from` is zero, `tokenId` will be minted for `to`.
1763      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1764      * - `from` cannot be the zero address.
1765      * - `to` cannot be the zero address.
1766      *
1767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1768      */
1769     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1770 }
1771 
1772 // File @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol@v3.4.0
1773 
1774 /**
1775  * @title ERC721 Burnable Token
1776  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1777  */
1778 abstract contract ERC721Burnable is Context, ERC721 {
1779     /**
1780      * @dev Burns `tokenId`. See {ERC721-_burn}.
1781      *
1782      * Requirements:
1783      *
1784      * - The caller must own `tokenId` or be an approved operator.
1785      */
1786     function burn(uint256 tokenId) public virtual {
1787         //solhint-disable-next-line max-line-length
1788         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1789         _burn(tokenId);
1790     }
1791 }
1792 
1793 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
1794 
1795 /**
1796  * @dev Contract module which provides a basic access control mechanism, where
1797  * there is an account (an owner) that can be granted exclusive access to
1798  * specific functions.
1799  *
1800  * By default, the owner account will be the one that deploys the contract. This
1801  * can later be changed with {transferOwnership}.
1802  *
1803  * This module is used through inheritance. It will make available the modifier
1804  * `onlyOwner`, which can be applied to your functions to restrict their use to
1805  * the owner.
1806  */
1807 abstract contract Ownable is Context {
1808     address private _owner;
1809 
1810     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1811 
1812     /**
1813      * @dev Initializes the contract setting the deployer as the initial owner.
1814      */
1815     constructor () internal {
1816         address msgSender = _msgSender();
1817         _owner = msgSender;
1818         emit OwnershipTransferred(address(0), msgSender);
1819     }
1820 
1821     /**
1822      * @dev Returns the address of the current owner.
1823      */
1824     function owner() public view virtual returns (address) {
1825         return _owner;
1826     }
1827 
1828     /**
1829      * @dev Throws if called by any account other than the owner.
1830      */
1831     modifier onlyOwner() {
1832         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1833         _;
1834     }
1835 
1836     /**
1837     /**
1838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1839      * Can only be called by the current owner.
1840      */
1841     function transferOwnership(address newOwner) public virtual onlyOwner {
1842         require(newOwner != address(0), "Ownable: new owner is the zero address");
1843         emit OwnershipTransferred(_owner, newOwner);
1844         _owner = newOwner;
1845     }
1846 }
1847 
1848 
1849 
1850 
1851 ////////////////////////////////////////////////////////////////
1852 //                  HTTPS://PEOPLEEUM.COM                     //
1853 ////////////////////////////////////////////////////////////////
1854 
1855 contract PeopleeumContract is ERC721Burnable, Ownable {
1856 
1857     using SafeMath for uint256;
1858     uint256 public constant PRICE = 100000000000000000; // 0.1 ETH
1859     uint256 public constant MAX_PEOPLEEUM = 11333;
1860     uint256 public constant MAX_PURCHASE = 20;
1861     uint256 public constant MAX_OWNABLE = 50; //
1862     uint256 public pplmReserve = 200;
1863     bool public saleIsActive = false;
1864     bool public vipSaleIsActive = true;
1865     address[]  private withdrawWallets;
1866     struct freeMints{
1867         uint128 freeCount;
1868         bool hasFree;
1869     }
1870     mapping(address => freeMints) private freeMintWallets;
1871 
1872 
1873     constructor() ERC721("Peopleeum", "PPLM") { }
1874 
1875 
1876     //event freeMintDone(address indexed _address, uint256 _fromToken,  uint indexed _tokenCount);
1877     //event mintDone(address indexed _address, uint256 _fromToken ,uint  _tokenCount);
1878 
1879     function addtoWhitelist(address[]  memory _address) public onlyOwner {  
1880         for (uint i=0; i<_address.length ; i++) {
1881             freeMintWallets[_address[i]].freeCount +=1;
1882             freeMintWallets[_address[i]].hasFree =true;
1883         }
1884 
1885     }
1886 
1887     function reservePeopleeum(address _to, uint256 _reserveAmount) public onlyOwner {        
1888         uint256 supply = totalSupply();
1889         require(_reserveAmount > 0 && _reserveAmount <= pplmReserve, "Not enough reserve left for team");
1890         for (uint256 i = 0; i < _reserveAmount; i++) {
1891             _safeMint(_to, supply + i);
1892         }
1893         pplmReserve = pplmReserve.sub(_reserveAmount);
1894     }
1895 
1896     function setBaseURI(string memory baseURI) public onlyOwner {
1897         _setBaseURI(baseURI);
1898     }
1899 
1900 
1901 
1902     function flipSaleState() public onlyOwner {
1903         saleIsActive = !saleIsActive;
1904     }
1905 
1906     function flipVipSaleState() public onlyOwner {
1907         vipSaleIsActive= !vipSaleIsActive;
1908     }
1909 
1910 
1911     function getFreeNum(address  address_) external view returns (uint128) {
1912         return freeMintWallets[address_].freeCount ;
1913     }
1914      function hasFree(address  address_) external view returns (bool) {
1915         return freeMintWallets[address_].hasFree ;
1916     }
1917 
1918 
1919     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1920         uint256 tokenCount = balanceOf(_owner);
1921         if (tokenCount == 0) {
1922             // Return an empty array
1923             return new uint256[](0);
1924         } else {
1925             uint256[] memory result = new uint256[](tokenCount);
1926             uint256 index;
1927             for (index = 0; index < tokenCount; index++) {
1928                 result[index] = tokenOfOwnerByIndex(_owner, index);
1929             }
1930             return result;
1931         }
1932     }
1933 
1934     function mintNewPeopleeum(uint256 numberOfTokens) public payable {
1935         uint256 supply = totalSupply();
1936         require(saleIsActive, "Sale must be active to mint");
1937         require(supply.add(numberOfTokens).add(pplmReserve) <= MAX_PEOPLEEUM, "Purchase would exceed max supply of peopleeum");
1938         require(PRICE.mul(numberOfTokens) <= msg.value, "ETH sent is incorrect");
1939         require(numberOfTokens <= MAX_PURCHASE && numberOfTokens > 0  , "Can only mint 20 tokens at a time");
1940         require((balanceOf(msg.sender) + numberOfTokens) <= MAX_OWNABLE, "Max Ownable is reached");
1941         for(uint i = 0; i < numberOfTokens; i++) {
1942             _safeMint(msg.sender, supply + i);
1943         }
1944     }
1945 
1946     function freeMint(uint128 numberOfTokens) public {
1947         uint256 supply = totalSupply();
1948         require(freeMintWallets[msg.sender].freeCount >0 && numberOfTokens <= freeMintWallets[msg.sender].freeCount, "You have not Free Tokens");
1949         require(saleIsActive, "Sale must be active to mint");
1950         require(vipSaleIsActive, "VIP Sale must be active to free mint");
1951         require(supply.add(numberOfTokens).add(pplmReserve) <= MAX_PEOPLEEUM, "Exceeds max supply");
1952         freeMintWallets[msg.sender].freeCount -= numberOfTokens;
1953         for(uint i = 0; i < numberOfTokens; i++) {
1954             _safeMint(msg.sender, supply+i);
1955         }
1956     }
1957 
1958 
1959     function withdrawAll() public payable onlyOwner {
1960         //Wallets here
1961         withdrawWallets.push (0xebC8231A2e52DAdAf55C9cDf9e397384D61F5EA7);
1962         withdrawWallets.push (0x8EE78C34E4ceFc08C3146de8F7D98B3330f8f67f);
1963         withdrawWallets.push (0xaE42DCbEF87D631e7CD1a0E5a6B4C517661da692);
1964         withdrawWallets.push (0x77D5671cdD54345e710F747a3a7Cd9Fdb943A719);
1965         withdrawWallets.push (0x99BeD5cFB3D8E3F8BB491e8105126231fAD5A713);
1966         uint256 balanc = address(this).balance/withdrawWallets.length;
1967         uint256 indx;
1968         for (indx=0; indx< withdrawWallets.length;indx++){
1969             require(payable(withdrawWallets[indx]).send(balanc));
1970         }
1971     }
1972 
1973 }