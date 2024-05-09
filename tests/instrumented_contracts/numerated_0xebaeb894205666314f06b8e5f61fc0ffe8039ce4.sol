1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 pragma solidity ^0.7.0;
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
54 
55 pragma solidity ^0.7.0;
56 
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(address from, address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(address from, address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167       * @dev Safely transfers `tokenId` token from `from` to `to`.
168       *
169       * Requirements:
170       *
171       * - `from` cannot be the zero address.
172       * - `to` cannot be the zero address.
173       * - `tokenId` token must exist and be owned by `from`.
174       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176       *
177       * Emits a {Transfer} event.
178       */
179     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
183 
184 pragma solidity ^0.7.0;
185 
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192 
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
209 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
210 
211 pragma solidity ^0.7.0;
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Enumerable is IERC721 {
219 
220     /**
221      * @dev Returns the total amount of tokens stored by the contract.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
227      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
228      */
229     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
230 
231     /**
232      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
233      * Use along with {totalSupply} to enumerate all tokens.
234      */
235     function tokenByIndex(uint256 index) external view returns (uint256);
236 }
237 
238 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
239 
240 pragma solidity ^0.7.0;
241 
242 /**
243  * @title ERC721 token receiver interface
244  * @dev Interface for any contract that wants to support safeTransfers
245  * from ERC721 asset contracts.
246  */
247 interface IERC721Receiver {
248     /**
249      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
250      * by `operator` from `from`, this function is called.
251      *
252      * It must return its Solidity selector to confirm the token transfer.
253      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
254      *
255      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
256      */
257     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
258 }
259 
260 // File: @openzeppelin/contracts/introspection/ERC165.sol
261 
262 pragma solidity ^0.7.0;
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
282     constructor () {
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
316 pragma solidity ^0.7.0;
317 
318 /**
319  * @dev Wrappers over Solidity's arithmetic operations with added overflow
320  * checks.
321  *
322  * Arithmetic operations in Solidity wrap on overflow. This can easily result
323  * in bugs, because programmers usually assume that an overflow raises an
324  * error, which is the standard behavior in high level programming languages.
325  * `SafeMath` restores this intuition by reverting the transaction when an
326  * operation overflows.
327  *
328  * Using this library instead of the unchecked operations eliminates an entire
329  * class of bugs, so it's recommended to use it always.
330  */
331 library SafeMath {
332     /**
333      * @dev Returns the addition of two unsigned integers, with an overflow flag.
334      *
335      * _Available since v3.4._
336      */
337     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
338         uint256 c = a + b;
339         if (c < a) return (false, 0);
340         return (true, c);
341     }
342 
343     /**
344      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
345      *
346      * _Available since v3.4._
347      */
348     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
349         if (b > a) return (false, 0);
350         return (true, a - b);
351     }
352 
353     /**
354      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
355      *
356      * _Available since v3.4._
357      */
358     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
360         // benefit is lost if 'b' is also tested.
361         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
362         if (a == 0) return (true, 0);
363         uint256 c = a * b;
364         if (c / a != b) return (false, 0);
365         return (true, c);
366     }
367 
368     /**
369      * @dev Returns the division of two unsigned integers, with a division by zero flag.
370      *
371      * _Available since v3.4._
372      */
373     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
374         if (b == 0) return (false, 0);
375         return (true, a / b);
376     }
377 
378     /**
379      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
380      *
381      * _Available since v3.4._
382      */
383     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         if (b == 0) return (false, 0);
385         return (true, a % b);
386     }
387 
388     /**
389      * @dev Returns the addition of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `+` operator.
393      *
394      * Requirements:
395      *
396      * - Addition cannot overflow.
397      */
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         require(c >= a, "SafeMath: addition overflow");
401         return c;
402     }
403 
404     /**
405      * @dev Returns the subtraction of two unsigned integers, reverting on
406      * overflow (when the result is negative).
407      *
408      * Counterpart to Solidity's `-` operator.
409      *
410      * Requirements:
411      *
412      * - Subtraction cannot overflow.
413      */
414     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
415         require(b <= a, "SafeMath: subtraction overflow");
416         return a - b;
417     }
418 
419     /**
420      * @dev Returns the multiplication of two unsigned integers, reverting on
421      * overflow.
422      *
423      * Counterpart to Solidity's `*` operator.
424      *
425      * Requirements:
426      *
427      * - Multiplication cannot overflow.
428      */
429     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
430         if (a == 0) return 0;
431         uint256 c = a * b;
432         require(c / a == b, "SafeMath: multiplication overflow");
433         return c;
434     }
435 
436     /**
437      * @dev Returns the integer division of two unsigned integers, reverting on
438      * division by zero. The result is rounded towards zero.
439      *
440      * Counterpart to Solidity's `/` operator. Note: this function uses a
441      * `revert` opcode (which leaves remaining gas untouched) while Solidity
442      * uses an invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function div(uint256 a, uint256 b) internal pure returns (uint256) {
449         require(b > 0, "SafeMath: division by zero");
450         return a / b;
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
455      * reverting when dividing by zero.
456      *
457      * Counterpart to Solidity's `%` operator. This function uses a `revert`
458      * opcode (which leaves remaining gas untouched) while Solidity uses an
459      * invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
466         require(b > 0, "SafeMath: modulo by zero");
467         return a % b;
468     }
469 
470     /**
471      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
472      * overflow (when the result is negative).
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {trySub}.
476      *
477      * Counterpart to Solidity's `-` operator.
478      *
479      * Requirements:
480      *
481      * - Subtraction cannot overflow.
482      */
483     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
484         require(b <= a, errorMessage);
485         return a - b;
486     }
487 
488     /**
489      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
490      * division by zero. The result is rounded towards zero.
491      *
492      * CAUTION: This function is deprecated because it requires allocating memory for the error
493      * message unnecessarily. For custom revert reasons use {tryDiv}.
494      *
495      * Counterpart to Solidity's `/` operator. Note: this function uses a
496      * `revert` opcode (which leaves remaining gas untouched) while Solidity
497      * uses an invalid opcode to revert (consuming all remaining gas).
498      *
499      * Requirements:
500      *
501      * - The divisor cannot be zero.
502      */
503     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b > 0, errorMessage);
505         return a / b;
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * reverting with custom message when dividing by zero.
511      *
512      * CAUTION: This function is deprecated because it requires allocating memory for the error
513      * message unnecessarily. For custom revert reasons use {tryMod}.
514      *
515      * Counterpart to Solidity's `%` operator. This function uses a `revert`
516      * opcode (which leaves remaining gas untouched) while Solidity uses an
517      * invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b > 0, errorMessage);
525         return a % b;
526     }
527 }
528 
529 // File: @openzeppelin/contracts/utils/Address.sol
530 
531 pragma solidity ^0.7.0;
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
719 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
720 
721 pragma solidity ^0.7.0;
722 
723 /**
724  * @dev Library for managing
725  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
726  * types.
727  *
728  * Sets have the following properties:
729  *
730  * - Elements are added, removed, and checked for existence in constant time
731  * (O(1)).
732  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
733  *
734  * ```
735  * contract Example {
736  *     // Add the library methods
737  *     using EnumerableSet for EnumerableSet.AddressSet;
738  *
739  *     // Declare a set state variable
740  *     EnumerableSet.AddressSet private mySet;
741  * }
742  * ```
743  *
744  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
745  * and `uint256` (`UintSet`) are supported.
746  */
747 library EnumerableSet {
748     // To implement this library for multiple types with as little code
749     // repetition as possible, we write it in terms of a generic Set type with
750     // bytes32 values.
751     // The Set implementation uses private functions, and user-facing
752     // implementations (such as AddressSet) are just wrappers around the
753     // underlying Set.
754     // This means that we can only create new EnumerableSets for types that fit
755     // in bytes32.
756 
757     struct Set {
758         // Storage of set values
759         bytes32[] _values;
760 
761         // Position of the value in the `values` array, plus 1 because index 0
762         // means a value is not in the set.
763         mapping (bytes32 => uint256) _indexes;
764     }
765 
766     /**
767      * @dev Add a value to a set. O(1).
768      *
769      * Returns true if the value was added to the set, that is if it was not
770      * already present.
771      */
772     function _add(Set storage set, bytes32 value) private returns (bool) {
773         if (!_contains(set, value)) {
774             set._values.push(value);
775             // The value is stored at length-1, but we add 1 to all indexes
776             // and use 0 as a sentinel value
777             set._indexes[value] = set._values.length;
778             return true;
779         } else {
780             return false;
781         }
782     }
783 
784     /**
785      * @dev Removes a value from a set. O(1).
786      *
787      * Returns true if the value was removed from the set, that is if it was
788      * present.
789      */
790     function _remove(Set storage set, bytes32 value) private returns (bool) {
791         // We read and store the value's index to prevent multiple reads from the same storage slot
792         uint256 valueIndex = set._indexes[value];
793 
794         if (valueIndex != 0) { // Equivalent to contains(set, value)
795             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
796             // the array, and then remove the last element (sometimes called as 'swap and pop').
797             // This modifies the order of the array, as noted in {at}.
798 
799             uint256 toDeleteIndex = valueIndex - 1;
800             uint256 lastIndex = set._values.length - 1;
801 
802             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
803             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
804 
805             bytes32 lastvalue = set._values[lastIndex];
806 
807             // Move the last value to the index where the value to delete is
808             set._values[toDeleteIndex] = lastvalue;
809             // Update the index for the moved value
810             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
811 
812             // Delete the slot where the moved value was stored
813             set._values.pop();
814 
815             // Delete the index for the deleted slot
816             delete set._indexes[value];
817 
818             return true;
819         } else {
820             return false;
821         }
822     }
823 
824     /**
825      * @dev Returns true if the value is in the set. O(1).
826      */
827     function _contains(Set storage set, bytes32 value) private view returns (bool) {
828         return set._indexes[value] != 0;
829     }
830 
831     /**
832      * @dev Returns the number of values on the set. O(1).
833      */
834     function _length(Set storage set) private view returns (uint256) {
835         return set._values.length;
836     }
837 
838    /**
839     * @dev Returns the value stored at position `index` in the set. O(1).
840     *
841     * Note that there are no guarantees on the ordering of values inside the
842     * array, and it may change when more values are added or removed.
843     *
844     * Requirements:
845     *
846     * - `index` must be strictly less than {length}.
847     */
848     function _at(Set storage set, uint256 index) private view returns (bytes32) {
849         require(set._values.length > index, "EnumerableSet: index out of bounds");
850         return set._values[index];
851     }
852 
853     // Bytes32Set
854 
855     struct Bytes32Set {
856         Set _inner;
857     }
858 
859     /**
860      * @dev Add a value to a set. O(1).
861      *
862      * Returns true if the value was added to the set, that is if it was not
863      * already present.
864      */
865     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
866         return _add(set._inner, value);
867     }
868 
869     /**
870      * @dev Removes a value from a set. O(1).
871      *
872      * Returns true if the value was removed from the set, that is if it was
873      * present.
874      */
875     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
876         return _remove(set._inner, value);
877     }
878 
879     /**
880      * @dev Returns true if the value is in the set. O(1).
881      */
882     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
883         return _contains(set._inner, value);
884     }
885 
886     /**
887      * @dev Returns the number of values in the set. O(1).
888      */
889     function length(Bytes32Set storage set) internal view returns (uint256) {
890         return _length(set._inner);
891     }
892 
893    /**
894     * @dev Returns the value stored at position `index` in the set. O(1).
895     *
896     * Note that there are no guarantees on the ordering of values inside the
897     * array, and it may change when more values are added or removed.
898     *
899     * Requirements:
900     *
901     * - `index` must be strictly less than {length}.
902     */
903     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
904         return _at(set._inner, index);
905     }
906 
907     // AddressSet
908 
909     struct AddressSet {
910         Set _inner;
911     }
912 
913     /**
914      * @dev Add a value to a set. O(1).
915      *
916      * Returns true if the value was added to the set, that is if it was not
917      * already present.
918      */
919     function add(AddressSet storage set, address value) internal returns (bool) {
920         return _add(set._inner, bytes32(uint256(uint160(value))));
921     }
922 
923     /**
924      * @dev Removes a value from a set. O(1).
925      *
926      * Returns true if the value was removed from the set, that is if it was
927      * present.
928      */
929     function remove(AddressSet storage set, address value) internal returns (bool) {
930         return _remove(set._inner, bytes32(uint256(uint160(value))));
931     }
932 
933     /**
934      * @dev Returns true if the value is in the set. O(1).
935      */
936     function contains(AddressSet storage set, address value) internal view returns (bool) {
937         return _contains(set._inner, bytes32(uint256(uint160(value))));
938     }
939 
940     /**
941      * @dev Returns the number of values in the set. O(1).
942      */
943     function length(AddressSet storage set) internal view returns (uint256) {
944         return _length(set._inner);
945     }
946 
947    /**
948     * @dev Returns the value stored at position `index` in the set. O(1).
949     *
950     * Note that there are no guarantees on the ordering of values inside the
951     * array, and it may change when more values are added or removed.
952     *
953     * Requirements:
954     *
955     * - `index` must be strictly less than {length}.
956     */
957     function at(AddressSet storage set, uint256 index) internal view returns (address) {
958         return address(uint160(uint256(_at(set._inner, index))));
959     }
960 
961 
962     // UintSet
963 
964     struct UintSet {
965         Set _inner;
966     }
967 
968     /**
969      * @dev Add a value to a set. O(1).
970      *
971      * Returns true if the value was added to the set, that is if it was not
972      * already present.
973      */
974     function add(UintSet storage set, uint256 value) internal returns (bool) {
975         return _add(set._inner, bytes32(value));
976     }
977 
978     /**
979      * @dev Removes a value from a set. O(1).
980      *
981      * Returns true if the value was removed from the set, that is if it was
982      * present.
983      */
984     function remove(UintSet storage set, uint256 value) internal returns (bool) {
985         return _remove(set._inner, bytes32(value));
986     }
987 
988     /**
989      * @dev Returns true if the value is in the set. O(1).
990      */
991     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
992         return _contains(set._inner, bytes32(value));
993     }
994 
995     /**
996      * @dev Returns the number of values on the set. O(1).
997      */
998     function length(UintSet storage set) internal view returns (uint256) {
999         return _length(set._inner);
1000     }
1001 
1002    /**
1003     * @dev Returns the value stored at position `index` in the set. O(1).
1004     *
1005     * Note that there are no guarantees on the ordering of values inside the
1006     * array, and it may change when more values are added or removed.
1007     *
1008     * Requirements:
1009     *
1010     * - `index` must be strictly less than {length}.
1011     */
1012     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1013         return uint256(_at(set._inner, index));
1014     }
1015 }
1016 
1017 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1018 
1019 pragma solidity ^0.7.0;
1020 
1021 /**
1022  * @dev Library for managing an enumerable variant of Solidity's
1023  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1024  * type.
1025  *
1026  * Maps have the following properties:
1027  *
1028  * - Entries are added, removed, and checked for existence in constant time
1029  * (O(1)).
1030  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1031  *
1032  * ```
1033  * contract Example {
1034  *     // Add the library methods
1035  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1036  *
1037  *     // Declare a set state variable
1038  *     EnumerableMap.UintToAddressMap private myMap;
1039  * }
1040  * ```
1041  *
1042  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1043  * supported.
1044  */
1045 library EnumerableMap {
1046     // To implement this library for multiple types with as little code
1047     // repetition as possible, we write it in terms of a generic Map type with
1048     // bytes32 keys and values.
1049     // The Map implementation uses private functions, and user-facing
1050     // implementations (such as Uint256ToAddressMap) are just wrappers around
1051     // the underlying Map.
1052     // This means that we can only create new EnumerableMaps for types that fit
1053     // in bytes32.
1054 
1055     struct MapEntry {
1056         bytes32 _key;
1057         bytes32 _value;
1058     }
1059 
1060     struct Map {
1061         // Storage of map keys and values
1062         MapEntry[] _entries;
1063 
1064         // Position of the entry defined by a key in the `entries` array, plus 1
1065         // because index 0 means a key is not in the map.
1066         mapping (bytes32 => uint256) _indexes;
1067     }
1068 
1069     /**
1070      * @dev Adds a key-value pair to a map, or updates the value for an existing
1071      * key. O(1).
1072      *
1073      * Returns true if the key was added to the map, that is if it was not
1074      * already present.
1075      */
1076     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1077         // We read and store the key's index to prevent multiple reads from the same storage slot
1078         uint256 keyIndex = map._indexes[key];
1079 
1080         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1081             map._entries.push(MapEntry({ _key: key, _value: value }));
1082             // The entry is stored at length-1, but we add 1 to all indexes
1083             // and use 0 as a sentinel value
1084             map._indexes[key] = map._entries.length;
1085             return true;
1086         } else {
1087             map._entries[keyIndex - 1]._value = value;
1088             return false;
1089         }
1090     }
1091 
1092     /**
1093      * @dev Removes a key-value pair from a map. O(1).
1094      *
1095      * Returns true if the key was removed from the map, that is if it was present.
1096      */
1097     function _remove(Map storage map, bytes32 key) private returns (bool) {
1098         // We read and store the key's index to prevent multiple reads from the same storage slot
1099         uint256 keyIndex = map._indexes[key];
1100 
1101         if (keyIndex != 0) { // Equivalent to contains(map, key)
1102             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1103             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1104             // This modifies the order of the array, as noted in {at}.
1105 
1106             uint256 toDeleteIndex = keyIndex - 1;
1107             uint256 lastIndex = map._entries.length - 1;
1108 
1109             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1110             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1111 
1112             MapEntry storage lastEntry = map._entries[lastIndex];
1113 
1114             // Move the last entry to the index where the entry to delete is
1115             map._entries[toDeleteIndex] = lastEntry;
1116             // Update the index for the moved entry
1117             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1118 
1119             // Delete the slot where the moved entry was stored
1120             map._entries.pop();
1121 
1122             // Delete the index for the deleted slot
1123             delete map._indexes[key];
1124 
1125             return true;
1126         } else {
1127             return false;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Returns true if the key is in the map. O(1).
1133      */
1134     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1135         return map._indexes[key] != 0;
1136     }
1137 
1138     /**
1139      * @dev Returns the number of key-value pairs in the map. O(1).
1140      */
1141     function _length(Map storage map) private view returns (uint256) {
1142         return map._entries.length;
1143     }
1144 
1145    /**
1146     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1147     *
1148     * Note that there are no guarantees on the ordering of entries inside the
1149     * array, and it may change when more entries are added or removed.
1150     *
1151     * Requirements:
1152     *
1153     * - `index` must be strictly less than {length}.
1154     */
1155     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1156         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1157 
1158         MapEntry storage entry = map._entries[index];
1159         return (entry._key, entry._value);
1160     }
1161 
1162     /**
1163      * @dev Tries to returns the value associated with `key`.  O(1).
1164      * Does not revert if `key` is not in the map.
1165      */
1166     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1167         uint256 keyIndex = map._indexes[key];
1168         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1169         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1170     }
1171 
1172     /**
1173      * @dev Returns the value associated with `key`.  O(1).
1174      *
1175      * Requirements:
1176      *
1177      * - `key` must be in the map.
1178      */
1179     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1180         uint256 keyIndex = map._indexes[key];
1181         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1182         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1183     }
1184 
1185     /**
1186      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1187      *
1188      * CAUTION: This function is deprecated because it requires allocating memory for the error
1189      * message unnecessarily. For custom revert reasons use {_tryGet}.
1190      */
1191     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1192         uint256 keyIndex = map._indexes[key];
1193         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1194         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1195     }
1196 
1197     // UintToAddressMap
1198 
1199     struct UintToAddressMap {
1200         Map _inner;
1201     }
1202 
1203     /**
1204      * @dev Adds a key-value pair to a map, or updates the value for an existing
1205      * key. O(1).
1206      *
1207      * Returns true if the key was added to the map, that is if it was not
1208      * already present.
1209      */
1210     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1211         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1212     }
1213 
1214     /**
1215      * @dev Removes a value from a set. O(1).
1216      *
1217      * Returns true if the key was removed from the map, that is if it was present.
1218      */
1219     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1220         return _remove(map._inner, bytes32(key));
1221     }
1222 
1223     /**
1224      * @dev Returns true if the key is in the map. O(1).
1225      */
1226     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1227         return _contains(map._inner, bytes32(key));
1228     }
1229 
1230     /**
1231      * @dev Returns the number of elements in the map. O(1).
1232      */
1233     function length(UintToAddressMap storage map) internal view returns (uint256) {
1234         return _length(map._inner);
1235     }
1236 
1237    /**
1238     * @dev Returns the element stored at position `index` in the set. O(1).
1239     * Note that there are no guarantees on the ordering of values inside the
1240     * array, and it may change when more values are added or removed.
1241     *
1242     * Requirements:
1243     *
1244     * - `index` must be strictly less than {length}.
1245     */
1246     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1247         (bytes32 key, bytes32 value) = _at(map._inner, index);
1248         return (uint256(key), address(uint160(uint256(value))));
1249     }
1250 
1251     /**
1252      * @dev Tries to returns the value associated with `key`.  O(1).
1253      * Does not revert if `key` is not in the map.
1254      *
1255      * _Available since v3.4._
1256      */
1257     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1258         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1259         return (success, address(uint160(uint256(value))));
1260     }
1261 
1262     /**
1263      * @dev Returns the value associated with `key`.  O(1).
1264      *
1265      * Requirements:
1266      *
1267      * - `key` must be in the map.
1268      */
1269     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1270         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1271     }
1272 
1273     /**
1274      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1275      *
1276      * CAUTION: This function is deprecated because it requires allocating memory for the error
1277      * message unnecessarily. For custom revert reasons use {tryGet}.
1278      */
1279     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1280         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/utils/Strings.sol
1285 
1286 pragma solidity ^0.7.0;
1287 
1288 /**
1289  * @dev String operations.
1290  */
1291 library Strings {
1292     /**
1293      * @dev Converts a `uint256` to its ASCII `string` representation.
1294      */
1295     function toString(uint256 value) internal pure returns (string memory) {
1296         // Inspired by OraclizeAPI's implementation - MIT licence
1297         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1298 
1299         if (value == 0) {
1300             return "0";
1301         }
1302         uint256 temp = value;
1303         uint256 digits;
1304         while (temp != 0) {
1305             digits++;
1306             temp /= 10;
1307         }
1308         bytes memory buffer = new bytes(digits);
1309         uint256 index = digits - 1;
1310         temp = value;
1311         while (temp != 0) {
1312             buffer[index--] = bytes1(uint8(48 + temp % 10));
1313             temp /= 10;
1314         }
1315         return string(buffer);
1316     }
1317 }
1318 
1319 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1320 
1321 pragma solidity ^0.7.0;
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 
1330 
1331 
1332 
1333 
1334 /**
1335  * @title ERC721 Non-Fungible Token Standard basic implementation
1336  * @dev see https://eips.ethereum.org/EIPS/eip-721
1337  */
1338 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1339     using SafeMath for uint256;
1340     using Address for address;
1341     using EnumerableSet for EnumerableSet.UintSet;
1342     using EnumerableMap for EnumerableMap.UintToAddressMap;
1343     using Strings for uint256;
1344 
1345     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1346     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1347     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1348 
1349     // Mapping from holder address to their (enumerable) set of owned tokens
1350     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1351 
1352     // Enumerable mapping from token ids to their owners
1353     EnumerableMap.UintToAddressMap private _tokenOwners;
1354 
1355     // Mapping from token ID to approved address
1356     mapping (uint256 => address) private _tokenApprovals;
1357 
1358     // Mapping from owner to operator approvals
1359     mapping (address => mapping (address => bool)) private _operatorApprovals;
1360 
1361     // Token name
1362     string private _name;
1363 
1364     // Token symbol
1365     string private _symbol;
1366 
1367     // Optional mapping for token URIs
1368     mapping (uint256 => string) private _tokenURIs;
1369 
1370     // Base URI
1371     string private _baseURI;
1372 
1373     /*
1374      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1375      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1376      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1377      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1378      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1379      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1380      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1381      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1382      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1383      *
1384      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1385      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1386      */
1387     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1388 
1389     /*
1390      *     bytes4(keccak256('name()')) == 0x06fdde03
1391      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1392      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1393      *
1394      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1395      */
1396     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1397 
1398     /*
1399      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1400      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1401      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1402      *
1403      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1404      */
1405     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1406 
1407     /**
1408      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1409      */
1410     constructor (string memory name_, string memory symbol_) {
1411         _name = name_;
1412         _symbol = symbol_;
1413 
1414         // register the supported interfaces to conform to ERC721 via ERC165
1415         _registerInterface(_INTERFACE_ID_ERC721);
1416         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1417         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-balanceOf}.
1422      */
1423     function balanceOf(address owner) public view virtual override returns (uint256) {
1424         require(owner != address(0), "ERC721: balance query for the zero address");
1425         return _holderTokens[owner].length();
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-ownerOf}.
1430      */
1431     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1432         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Metadata-name}.
1437      */
1438     function name() public view virtual override returns (string memory) {
1439         return _name;
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Metadata-symbol}.
1444      */
1445     function symbol() public view virtual override returns (string memory) {
1446         return _symbol;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Metadata-tokenURI}.
1451      */
1452     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1453         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1454 
1455         string memory _tokenURI = _tokenURIs[tokenId];
1456         string memory base = baseURI();
1457 
1458         // If there is no base URI, return the token URI.
1459         if (bytes(base).length == 0) {
1460             return _tokenURI;
1461         }
1462         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1463         if (bytes(_tokenURI).length > 0) {
1464             return string(abi.encodePacked(base, _tokenURI));
1465         }
1466         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1467         return string(abi.encodePacked(base, tokenId.toString()));
1468     }
1469 
1470     /**
1471     * @dev Returns the base URI set via {_setBaseURI}. This will be
1472     * automatically added as a prefix in {tokenURI} to each token's URI, or
1473     * to the token ID if no specific URI is set for that token ID.
1474     */
1475     function baseURI() public view virtual returns (string memory) {
1476         return _baseURI;
1477     }
1478 
1479     /**
1480      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1481      */
1482     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1483         return _holderTokens[owner].at(index);
1484     }
1485 
1486     /**
1487      * @dev See {IERC721Enumerable-totalSupply}.
1488      */
1489     function totalSupply() public view virtual override returns (uint256) {
1490         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1491         return _tokenOwners.length();
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Enumerable-tokenByIndex}.
1496      */
1497     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1498         (uint256 tokenId, ) = _tokenOwners.at(index);
1499         return tokenId;
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-approve}.
1504      */
1505     function approve(address to, uint256 tokenId) public virtual override {
1506         address owner = ERC721.ownerOf(tokenId);
1507         require(to != owner, "ERC721: approval to current owner");
1508 
1509         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1510             "ERC721: approve caller is not owner nor approved for all"
1511         );
1512 
1513         _approve(to, tokenId);
1514     }
1515 
1516     /**
1517      * @dev See {IERC721-getApproved}.
1518      */
1519     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1520         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1521 
1522         return _tokenApprovals[tokenId];
1523     }
1524 
1525     /**
1526      * @dev See {IERC721-setApprovalForAll}.
1527      */
1528     function setApprovalForAll(address operator, bool approved) public virtual override {
1529         require(operator != _msgSender(), "ERC721: approve to caller");
1530 
1531         _operatorApprovals[_msgSender()][operator] = approved;
1532         emit ApprovalForAll(_msgSender(), operator, approved);
1533     }
1534 
1535     /**
1536      * @dev See {IERC721-isApprovedForAll}.
1537      */
1538     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1539         return _operatorApprovals[owner][operator];
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-transferFrom}.
1544      */
1545     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1546         //solhint-disable-next-line max-line-length
1547         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1548 
1549         _transfer(from, to, tokenId);
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-safeTransferFrom}.
1554      */
1555     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1556         safeTransferFrom(from, to, tokenId, "");
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-safeTransferFrom}.
1561      */
1562     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1563         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1564         _safeTransfer(from, to, tokenId, _data);
1565     }
1566 
1567     /**
1568      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1569      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1570      *
1571      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1572      *
1573      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1574      * implement alternative mechanisms to perform token transfer, such as signature-based.
1575      *
1576      * Requirements:
1577      *
1578      * - `from` cannot be the zero address.
1579      * - `to` cannot be the zero address.
1580      * - `tokenId` token must exist and be owned by `from`.
1581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1586         _transfer(from, to, tokenId);
1587         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1588     }
1589 
1590     /**
1591      * @dev Returns whether `tokenId` exists.
1592      *
1593      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1594      *
1595      * Tokens start existing when they are minted (`_mint`),
1596      * and stop existing when they are burned (`_burn`).
1597      */
1598     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1599         return _tokenOwners.contains(tokenId);
1600     }
1601 
1602     /**
1603      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1604      *
1605      * Requirements:
1606      *
1607      * - `tokenId` must exist.
1608      */
1609     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1610         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1611         address owner = ERC721.ownerOf(tokenId);
1612         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1613     }
1614 
1615     /**
1616      * @dev Safely mints `tokenId` and transfers it to `to`.
1617      *
1618      * Requirements:
1619      d*
1620      * - `tokenId` must not exist.
1621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1622      *
1623      * Emits a {Transfer} event.
1624      */
1625     function _safeMint(address to, uint256 tokenId) internal virtual {
1626         _safeMint(to, tokenId, "");
1627     }
1628 
1629     /**
1630      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1631      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1632      */
1633     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1634         _mint(to, tokenId);
1635         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1636     }
1637 
1638     /**
1639      * @dev Mints `tokenId` and transfers it to `to`.
1640      *
1641      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1642      *
1643      * Requirements:
1644      *
1645      * - `tokenId` must not exist.
1646      * - `to` cannot be the zero address.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _mint(address to, uint256 tokenId) internal virtual {
1651         require(to != address(0), "ERC721: mint to the zero address");
1652         require(!_exists(tokenId), "ERC721: token already minted");
1653 
1654         _beforeTokenTransfer(address(0), to, tokenId);
1655 
1656         _holderTokens[to].add(tokenId);
1657 
1658         _tokenOwners.set(tokenId, to);
1659 
1660         emit Transfer(address(0), to, tokenId);
1661     }
1662 
1663     /**
1664      * @dev Destroys `tokenId`.
1665      * The approval is cleared when the token is burned.
1666      *
1667      * Requirements:
1668      *
1669      * - `tokenId` must exist.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _burn(uint256 tokenId) internal virtual {
1674         address owner = ERC721.ownerOf(tokenId); // internal owner
1675 
1676         _beforeTokenTransfer(owner, address(0), tokenId);
1677 
1678         // Clear approvals
1679         _approve(address(0), tokenId);
1680 
1681         // Clear metadata (if any)
1682         if (bytes(_tokenURIs[tokenId]).length != 0) {
1683             delete _tokenURIs[tokenId];
1684         }
1685 
1686         _holderTokens[owner].remove(tokenId);
1687 
1688         _tokenOwners.remove(tokenId);
1689 
1690         emit Transfer(owner, address(0), tokenId);
1691     }
1692 
1693     /**
1694      * @dev Transfers `tokenId` from `from` to `to`.
1695      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1696      *
1697      * Requirements:
1698      *
1699      * - `to` cannot be the zero address.
1700      * - `tokenId` token must be owned by `from`.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1705         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1706         require(to != address(0), "ERC721: transfer to the zero address");
1707 
1708         _beforeTokenTransfer(from, to, tokenId);
1709 
1710         // Clear approvals from the previous owner
1711         _approve(address(0), tokenId);
1712 
1713         _holderTokens[from].remove(tokenId);
1714         _holderTokens[to].add(tokenId);
1715 
1716         _tokenOwners.set(tokenId, to);
1717 
1718         emit Transfer(from, to, tokenId);
1719     }
1720 
1721     /**
1722      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1723      *
1724      * Requirements:
1725      *
1726      * - `tokenId` must exist.
1727      */
1728     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1729         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1730         _tokenURIs[tokenId] = _tokenURI;
1731     }
1732 
1733     /**
1734      * @dev Internal function to set the base URI for all token IDs. It is
1735      * automatically added as a prefix to the value returned in {tokenURI},
1736      * or to the token ID if {tokenURI} is empty.
1737      */
1738     function _setBaseURI(string memory baseURI_) internal virtual {
1739         _baseURI = baseURI_;
1740     }
1741 
1742     /**
1743      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1744      * The call is not executed if the target address is not a contract.
1745      *
1746      * @param from address representing the previous owner of the given token ID
1747      * @param to target address that will receive the tokens
1748      * @param tokenId uint256 ID of the token to be transferred
1749      * @param _data bytes optional data to send along with the call
1750      * @return bool whether the call correctly returned the expected magic value
1751      */
1752     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1753         private returns (bool)
1754     {
1755         if (!to.isContract()) {
1756             return true;
1757         }
1758         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1759             IERC721Receiver(to).onERC721Received.selector,
1760             _msgSender(),
1761             from,
1762             tokenId,
1763             _data
1764         ), "ERC721: transfer to non ERC721Receiver implementer");
1765         bytes4 retval = abi.decode(returndata, (bytes4));
1766         return (retval == _ERC721_RECEIVED);
1767     }
1768 
1769     function _approve(address to, uint256 tokenId) private {
1770         _tokenApprovals[tokenId] = to;
1771         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1772     }
1773 
1774     /**
1775      * @dev Hook that is called before any token transfer. This includes minting
1776      * and burning.
1777      *
1778      * Calling conditions:
1779      *
1780      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1781      * transferred to `to`.
1782      * - When `from` is zero, `tokenId` will be minted for `to`.
1783      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1784      * - `from` cannot be the zero address.
1785      * - `to` cannot be the zero address.
1786      *
1787      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1788      */
1789     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1790 }
1791 
1792 // File: @openzeppelin/contracts/access/Ownable.sol
1793 
1794 pragma solidity ^0.7.0;
1795 
1796 /**
1797  * @dev Contract module which provides a basic access control mechanism, where
1798  * there is an account (an owner) that can be granted exclusive access to
1799  * specific functions.
1800  *
1801  * By default, the owner account will be the one that deploys the contract. This
1802  * can later be changed with {transferOwnership}.
1803  *
1804  * This module is used through inheritance. It will make available the modifier
1805  * `onlyOwner`, which can be applied to your functions to restrict their use to
1806  * the owner.
1807  */
1808 abstract contract Ownable is Context {
1809     address private _owner;
1810 
1811     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1812 
1813     /**
1814      * @dev Initializes the contract setting the deployer as the initial owner.
1815      */
1816     constructor () {
1817         address msgSender = _msgSender();
1818         _owner = msgSender;
1819         emit OwnershipTransferred(address(0), msgSender);
1820     }
1821 
1822     /**
1823      * @dev Returns the address of the current owner.
1824      */
1825     function owner() public view virtual returns (address) {
1826         return _owner;
1827     }
1828 
1829     /**
1830      * @dev Throws if called by any account other than the owner.
1831      */
1832     modifier onlyOwner() {
1833         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1834         _;
1835     }
1836 
1837     /**
1838      * @dev Leaves the contract without owner. It will not be possible to call
1839      * `onlyOwner` functions anymore. Can only be called by the current owner.
1840      *
1841      * NOTE: Renouncing ownership will leave the contract without an owner,
1842      * thereby removing any functionality that is only available to the owner.
1843      */
1844     function renounceOwnership() public virtual onlyOwner {
1845         emit OwnershipTransferred(_owner, address(0));
1846         _owner = address(0);
1847     }
1848 
1849     /**
1850      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1851      * Can only be called by the current owner.
1852      */
1853     function transferOwnership(address newOwner) public virtual onlyOwner {
1854         require(newOwner != address(0), "Ownable: new owner is the zero address");
1855         emit OwnershipTransferred(_owner, newOwner);
1856         _owner = newOwner;
1857     }
1858 }
1859 
1860 // File: contracts/digirocks.sol
1861 
1862 pragma solidity >=0.6.0 <0.8.0;
1863 
1864 
1865 
1866 // Inspired by Chubbies (chubbies.io)
1867 contract Digirocks is ERC721, Ownable {
1868     using SafeMath for uint256;
1869     uint public constant MAX_DIGIROCKS = 10000;
1870     uint public constant MAX_FREE_DIGIROCKS = 250;
1871     uint public redeemedDigirocks = 0;
1872     bool public hasSaleStarted = false;
1873     mapping(address => uint) public redemptions;
1874 
1875     string public METADATA_PROVENANCE_HASH = "";
1876     
1877     constructor(string memory baseURI) ERC721("Digirocks","DIGIROCKS")  {
1878         setBaseURI(baseURI);
1879         redemptions[0xBF3e23afd790E34A39d2E5B465f57e0ED74b3B9A] = 39;
1880         redemptions[0xb432cFCa03A7ddd34F9469092316a88D01bA80Fc] = 6;
1881         redemptions[0x139a0975eA36cEc4C59447002A875749Ac9c460f] = 6;
1882         redemptions[0xB8e9ba6Ef868352579f1ACc6945e96667000BF82] = 5;
1883         redemptions[0x9F5c28dA8F8622D36dC0F596142d66BB1512BAb5] = 5;
1884         redemptions[0xC57B739aA628F821C69A42279D278B41eFc6972E] = 5;
1885         redemptions[0x4B0292faCb3Bf7C26DEF0B6aeb24133C6B5bd68d] = 5;
1886         redemptions[0xbC1eB4359ab755Af079F6EF77E3FaAc465e53EDA] = 4;
1887         redemptions[0x8d809b30Ce1d511c674784c4bcFCd5D28F957F5C] = 4;
1888         redemptions[0x876A07C532c88f778790651503DfabE159F845a2] = 4;
1889         redemptions[0x5f1088110EdcBa27Fc206cdcc326B413b5867361] = 4;
1890         redemptions[0x525bFC44292b26d1c2f0303AA447Db46d7F23056] = 3;
1891         redemptions[0x75259686c1C967399eDA0b4B16f16FB0990f9615] = 3;
1892         redemptions[0x9baB7d4E2B2443667017A0FE4E18b662d10EdDa7] = 3;
1893         redemptions[0x89abF6673dE7e578e3c3CDeCC4CC18c0b9aDCc70] = 3;
1894         redemptions[0x8C8Ddf9A1390886525866F651aD0Ef1947d10897] = 3;
1895         redemptions[0x9B5546050984fe69aE9cFa57538C83282A3cBce2] = 2;
1896         redemptions[0x217d83bbe3693365b6BD40f4Dd2019b4aA7C681B] = 2;
1897         redemptions[0x593e76d2a379C72F3dC7698A0a87f6Adc92b7C5A] = 2;
1898         redemptions[0x0985224a811E65c235DBF4a2C2117712AABe4e39] = 2;
1899         redemptions[0x0614e07756390441CB246c886917487840e74f7d] = 2;
1900         redemptions[0x3546BD99767246C358ff1497f1580C8365b25AC8] = 2;
1901         redemptions[0xc9BD470a494E002aECBbBf73cA5BD8a2807F296b] = 2;
1902         redemptions[0x42F7c5275aC4372156027d939843C9C42523DF2E] = 2;
1903         redemptions[0x75e4d2CD3e6652226808D2750DEbeaF2023E5dE1] = 2;
1904         redemptions[0xd4cF19f76addb489d079D0f60F41D6E91E7c79E1] = 2;
1905         redemptions[0xbbA99dfb76452780d3a8da48D6aAd5f540131Da4] = 2;
1906         redemptions[0x229D6a31d0CF2225837DB8C82A6c78De5cDe114d] = 2;
1907         redemptions[0x5540B6425bdC1dF657a3d3934019eB89781F4897] = 2;
1908         redemptions[0x8a22E82B7f1916aC985593C481F3EfcdE00FDd78] = 2;
1909         redemptions[0x10A7aDb377e67B1e6080Cdd3dda59f42aebBeFf9] = 2;
1910         redemptions[0xeEcd39A1F6283bEF2771C004618bb3a982FC126C] = 2;
1911         redemptions[0xf476Cd75BE8Fdd197AE0b466A2ec2ae44Da41897] = 2;
1912         redemptions[0x5c5fc4680AAfa2CeD7b5826883c1a26DcE05eC4d] = 1;
1913         redemptions[0x0A2A3d3C6d4f2D57D307DA3E3e99FF8122077Da5] = 1;
1914         redemptions[0x1e33Fa287537F185f0cB89F8ef69bBf54fE64Ec2] = 1;
1915         redemptions[0x2160eD383B9f1C9cF1e01926209DAF5ecC8E1E49] = 1;
1916         redemptions[0xCdA1a0ECd7D25B49Ecbf0EeC1f45f0B7fb59961b] = 1;
1917         redemptions[0x33F04Cf7fa115165aF33CEA6846AA0dbC20c318B] = 1;
1918         redemptions[0xa9A1bB451Ef2bAcc8377BdF74cEA001278F48347] = 1;
1919         redemptions[0x4B4a367C6f5018529b3bbe0BeE27C7dae043331A] = 1;
1920         redemptions[0x9657B94D5d0a7C58CD2c59Ac17969e754C29eC29] = 1;
1921         redemptions[0x268087220BEF3a1aACC85ea32D140A87e56f494F] = 1;
1922         redemptions[0xd078df89564Bd99c74B3076a584Eb23068072909] = 1;
1923         redemptions[0x361084AF8D45E07885b31fCEDCb642b9Cc7B72D7] = 1;
1924         redemptions[0x43286B397932eb5C7C1Ea06632600A8E3a484c87] = 1;
1925         redemptions[0x5d54DBAc524Eed9FE4606F65fC0f069E704323a6] = 1;
1926         redemptions[0x827e692C4AB6e02099D0B4792D931075134876d4] = 1;
1927         redemptions[0x0A4E4f47b29B5891684c2202bc771aC3a8a35D7a] = 1;
1928         redemptions[0xB0B7aBccD78a560955eaD86a34eae2F0B6f0199E] = 1;
1929         redemptions[0xA5019C1D0ceefff54bC89F07dC53126861C76AbA] = 1;
1930         redemptions[0xf631B11ceC7a24a1300C301e3f079F5C76faaD1B] = 1;
1931         redemptions[0xe3ACe06FFa96f25FD652D068cD133cBb6B1869Eb] = 1;
1932         redemptions[0x784b0788F00b7085B2E66aBa316a271C3d10a347] = 1;
1933         redemptions[0x88bADBA19b9AeC1025125060Df9afFa6Fc0ECBe0] = 1;
1934         redemptions[0x8A0A570195Fb73a73b550902EEfb221A4E416739] = 1;
1935         redemptions[0xd7F4A99f72b19d609892694d638C18E2C93De9DC] = 1;
1936         redemptions[0x3Bd77B00f02C8BcfF586C565E2c5e6B6c5878EC3] = 1;
1937         redemptions[0xe336647d97414E5613c31b321306708bE29B6E0c] = 1;
1938         redemptions[0x992931cB309055B105327DEe9EB7afa702442D89] = 1;
1939         redemptions[0xE366f493c7192a268b8f12A8bEb6F604b29e6C11] = 1;
1940         redemptions[0xAa66a53e01698873D22d49C69c4829190975cc32] = 1;
1941         redemptions[0x561d171b3f3691b122B3767CAbd5e86bE76ffdb5] = 1;
1942         redemptions[0x0A46570dBA491858461E1164B436e9266b3f55b5] = 1;
1943         redemptions[0x7Dcb39fe010A205f16ee3249F04b24d74C4f44F1] = 1;
1944         redemptions[0xB4B1F87A6C2C95726ca3aaF9E3a06142D78E3Ac4] = 1;
1945         redemptions[0x98e9de3364f73824b06fc6531C42b85e67A4A98c] = 1;
1946         redemptions[0xc345b043023BDeB7b034064A06E36dA51d2FC3d8] = 1;
1947         redemptions[0xe5845761e7773976055F2559ca54be41F09d9E88] = 1;
1948         redemptions[0x209af07A4B6b2D15923ffa8C3d41cDAC49BC6c4F] = 1;
1949         redemptions[0x9A8b253C304b897AF8147143c5D0db4635E8c9C6] = 1;
1950         redemptions[0x6B254f8a91E255a4FB916501F896E15522799D82] = 1;
1951         redemptions[0x97f4319bfEFd1394fC33E0721cBe7388C57Aa810] = 1;
1952         redemptions[0x311747a35Da6c4d3259B8FBfFCe770Be105B7130] = 1;
1953         redemptions[0x8B73704918df1E5bcfD4d0ea2a04a7B534A06F80] = 1;
1954         redemptions[0xddEaEC88e4a183F5aCC7d7cFd6f69e300Bb6D455] = 1;
1955         redemptions[0x40d6D4b08BdEB4cf37f416d0EF2b4211671Ef484] = 1;
1956         redemptions[0xb432005e1010492fa315b9737881e5E18925204c] = 1;
1957         redemptions[0x95B46b33b8d7cc0A804D93f5FdDD7efBCB1fEDAC] = 1;
1958         redemptions[0x241Ef80D41C220B5616A4aB9bA9B9a9Fd7A79a5f] = 1;
1959         redemptions[0xafc69fD946f565183d9229d75e1953dF179aD959] = 1;
1960         redemptions[0x38319E74CeFe77B62FeC8E7a2aB81318727f46c7] = 1;
1961         redemptions[0x9BA74Ba6c4FD92646985AfA5d6A8EDB4F2A38Ba5] = 1;
1962         redemptions[0x934cBdF4c7163eFac4B8210713c5B7c134E207E6] = 1;
1963         redemptions[0x3a9F45ac308CcC0a1A48b0f9e2F8Ce859A0039ea] = 1;
1964         redemptions[0xa42A2271EcBaB3F638595F64c8d96623E334167E] = 1;
1965         redemptions[0x9Fe686D6fAcBC5AE4433308B26e7c810ac43F3D4] = 1;
1966         redemptions[0x15296589Df4156703d25475ea9b1039030acFaeb] = 1;
1967         redemptions[0x38F1DfdcaF2F0d70c29D4AF6a4AA9E920efe8B18] = 1;
1968         redemptions[0x3140fe113a49d78830E18b64F2398544EE39F8F9] = 1;
1969         redemptions[0x00AEa56c78ebB54dBf1C52520c20302aAD6B7355] = 1;
1970         redemptions[0xB810D1238dC5E5D664eBC5d19B0Fd2C28d42968D] = 1;
1971         redemptions[0x73dFEd4F1269d4Ae7fA951a65b923f887513E18d] = 1;
1972         redemptions[0x6b401B4B53219Fb4E5Ea71D4a98cd3c75095Ee77] = 1;
1973         redemptions[0x5B2D192182Cc6e39B047880995B67e179B89F63e] = 1;
1974         redemptions[0xce97592353ACE045DFD9882c50ceF606327FBE43] = 1;
1975     }
1976     
1977     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1978         uint256 tokenCount = balanceOf(_owner);
1979         if (tokenCount == 0) {
1980             // Return an empty array
1981             return new uint256[](0);
1982         } else {
1983             uint256[] memory result = new uint256[](tokenCount);
1984             uint256 index;
1985             for (index = 0; index < tokenCount; index++) {
1986                 result[index] = tokenOfOwnerByIndex(_owner, index);
1987             }
1988             return result;
1989         }
1990     }
1991     
1992     function calculatePrice() public view returns (uint256) {
1993         require(hasSaleStarted == true, "Sale hasn't started");
1994         require(totalSupply() < MAX_DIGIROCKS, "Sale has already ended");
1995 
1996         uint currentSupply = totalSupply();
1997         if (currentSupply >= 9900) {
1998             return 960000000000000000;        // 9900-10000: 0.96 ETH
1999         } else if (currentSupply >= 9500) {
2000             return 480000000000000000;         // 9500-9900:  0.48 ETH
2001         } else if (currentSupply >= 7500) {
2002             return 240000000000000000;         // 7500-9500:  0.24 ETH
2003         } else if (currentSupply >= 3500) {
2004             return 120000000000000000;         // 3500-7500:  0.12 ETH
2005         } else if (currentSupply >= 1500) {
2006             return 60000000000000000;          // 1500-3500:  0.06 ETH 
2007         } else if (currentSupply >= 500) {
2008             return 30000000000000000;          // 500-1500:   0.03 ETH 
2009         } else {
2010             return 15000000000000000;          // 0 - 500     0.015 ETH
2011         }
2012     }
2013 
2014     function calculatePriceForToken(uint _id) public view returns (uint256) {
2015         require(_id < MAX_DIGIROCKS, "Sale has already ended");
2016 
2017         if (_id >= 9900) {
2018             return 960000000000000000;        // 9900-10000: 0.96 ETH
2019         } else if (_id >= 9500) {
2020             return 480000000000000000;         // 9500-9900:  0.48 ETH
2021         } else if (_id >= 7500) {
2022             return 240000000000000000;         // 7500-9500:  0.24 ETH
2023         } else if (_id >= 3500) {
2024             return 120000000000000000;         // 3500-7500:  0.12 ETH
2025         } else if (_id >= 1500) {
2026             return 60000000000000000;          // 1500-3500:  0.06 ETH 
2027         } else if (_id >= 500) {
2028             return 30000000000000000;          // 500-1500:   0.03 ETH 
2029         } else {
2030             return 15000000000000000;          // 0 - 500     0.015 ETH
2031         }
2032     }
2033     
2034    function adoptDigirock(uint256 numDigirocks) public payable {
2035         require(numDigirocks > 0 && numDigirocks <= 20, "You can adopt minimum 1, maximum 20 Digirocks");
2036         require(totalSupply().add(numDigirocks) <= MAX_DIGIROCKS, "Exceeds MAX_DIGIROCKS");
2037         require(msg.value >= calculatePrice().mul(numDigirocks), "Ether value sent is below the price");
2038 
2039         for (uint i = 0; i < numDigirocks; i++) {
2040             uint mintIndex = totalSupply();
2041             _safeMint(msg.sender, mintIndex);
2042         }
2043     }
2044     
2045     // God Mode
2046     function setProvenanceHash(string memory _hash) public onlyOwner {
2047         METADATA_PROVENANCE_HASH = _hash;
2048     }
2049     
2050     function setBaseURI(string memory baseURI) public onlyOwner {
2051         _setBaseURI(baseURI);
2052     }
2053     
2054     function startSale() public onlyOwner {
2055         hasSaleStarted = true;
2056     }
2057 
2058     function pauseSale() public onlyOwner {
2059         hasSaleStarted = false;
2060     }
2061     
2062     function withdrawAll() public payable onlyOwner {
2063         require(payable(msg.sender).send(address(this).balance));
2064     }
2065 
2066     // Freak owners can claim a free rock
2067     function claimFreeDigirock(uint256 numDigirocks) public {
2068         require(redemptions[msg.sender] >= numDigirocks, "You can't claim that many");
2069         require(totalSupply().add(numDigirocks) <= MAX_DIGIROCKS, "Exceeds MAX_DIGIROCKS");
2070         require(redeemedDigirocks.add(numDigirocks) <= MAX_FREE_DIGIROCKS, "Exceeds MAX_FREE_DIGIROCKS");
2071 
2072         for (uint i = 0; i < numDigirocks; i++) {
2073             uint mintIndex = totalSupply();
2074             redemptions[msg.sender] = redemptions[msg.sender].sub(1);
2075             redeemedDigirocks = redeemedDigirocks.add(1);
2076             _safeMint(msg.sender, mintIndex);
2077         }
2078     }
2079 
2080     // Add the freakowner that can claim the rock
2081     function addClaimable(address freakowner, uint256 numDigirocks) public onlyOwner {
2082         require(totalSupply().add(numDigirocks) < MAX_DIGIROCKS, "Exceeds MAX_DIGIROCKS");
2083         require(redeemedDigirocks.add(numDigirocks) <= MAX_FREE_DIGIROCKS, "Exceeds MAX_FREE_DIGIROCKS");
2084         redemptions[freakowner] = numDigirocks;
2085     }
2086 }