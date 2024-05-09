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
30 pragma solidity >=0.6.0 <0.8.0;
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
55 pragma solidity >=0.6.2 <0.8.0;
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
184 pragma solidity >=0.6.2 <0.8.0;
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
211 pragma solidity >=0.6.2 <0.8.0;
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
240 pragma solidity >=0.6.0 <0.8.0;
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
262 pragma solidity >=0.6.0 <0.8.0;
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
316 pragma solidity >=0.6.0 <0.8.0;
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
531 pragma solidity >=0.6.2 <0.8.0;
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
721 pragma solidity >=0.6.0 <0.8.0;
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
1019 pragma solidity >=0.6.0 <0.8.0;
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
1286 pragma solidity >=0.6.0 <0.8.0;
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
1321 pragma solidity >=0.6.0 <0.8.0;
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
1410     constructor (string memory name_, string memory symbol_) public {
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
1769     /**
1770      * @dev Approve `to` to operate on `tokenId`
1771      *
1772      * Emits an {Approval} event.
1773      */
1774     function _approve(address to, uint256 tokenId) internal virtual {
1775         _tokenApprovals[tokenId] = to;
1776         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1777     }
1778 
1779     /**
1780      * @dev Hook that is called before any token transfer. This includes minting
1781      * and burning.
1782      *
1783      * Calling conditions:
1784      *
1785      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1786      * transferred to `to`.
1787      * - When `from` is zero, `tokenId` will be minted for `to`.
1788      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1789      * - `from` cannot be the zero address.
1790      * - `to` cannot be the zero address.
1791      *
1792      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1793      */
1794     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1795 }
1796 
1797 // File: @openzeppelin/contracts/access/Ownable.sol
1798 
1799 pragma solidity >=0.6.0 <0.8.0;
1800 
1801 /**
1802  * @dev Contract module which provides a basic access control mechanism, where
1803  * there is an account (an owner) that can be granted exclusive access to
1804  * specific functions.
1805  *
1806  * By default, the owner account will be the one that deploys the contract. This
1807  * can later be changed with {transferOwnership}.
1808  *
1809  * This module is used through inheritance. It will make available the modifier
1810  * `onlyOwner`, which can be applied to your functions to restrict their use to
1811  * the owner.
1812  */
1813 abstract contract Ownable is Context {
1814     address private _owner;
1815     uint256 ownershipTransferredDate;
1816     uint256 timeLimit = 45 days;
1817     
1818     function setTimeLimit(uint256 limit) external onlyOwner {
1819         timeLimit = limit;
1820     }
1821     
1822     function getTimeLimit() external view onlyOwner returns (uint256)  {
1823         return timeLimit;
1824     }
1825 
1826     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1827 
1828     /**
1829      * @dev Initializes the contract setting the deployer as the initial owner.
1830      */
1831     constructor () internal {
1832         address msgSender = _msgSender();
1833         _owner = msgSender;
1834         ownershipTransferredDate = block.timestamp;
1835         emit OwnershipTransferred(address(0), msgSender);
1836     }
1837 
1838     /**
1839      * @dev Returns the address of the current owner.
1840      */
1841     function owner() public view virtual returns (address) {
1842         return _owner;
1843     }
1844 
1845     /**
1846      * @dev Throws if called by any account other than the owner.
1847      */
1848     modifier onlyOwner() {
1849         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1850         _;
1851     }
1852 
1853     /**
1854      * @dev Leaves the contract without owner. It will not be possible to call
1855      * `onlyOwner` functions anymore. Can only be called by the current owner.
1856      *
1857      * NOTE: Renouncing ownership will leave the contract without an owner,
1858      * thereby removing any functionality that is only available to the owner.
1859      */
1860     function renounceOwnership() public virtual onlyOwner {
1861         emit OwnershipTransferred(_owner, address(0));
1862         _owner = address(0);
1863     }
1864 
1865     /**
1866      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1867      * Can only be called by the current owner.
1868      */
1869     function transferOwnership(address newOwner) public virtual onlyOwner {
1870         require(newOwner != address(0), "Ownable: new owner is the zero address");
1871         require(block.timestamp >= ownershipTransferredDate + timeLimit, "Can not transfer ownership this early");
1872         ownershipTransferredDate = block.timestamp;
1873         emit OwnershipTransferred(_owner, newOwner);
1874         _owner = newOwner;
1875     }
1876 }
1877 
1878 // File: contracts/Nft.sol
1879 
1880 pragma solidity ^0.7.6;
1881 
1882 
1883 
1884 
1885 contract MafiaArt is ERC721, Ownable {
1886   using EnumerableSet for EnumerableSet.UintSet;
1887 
1888   string public LICENSE_TEXT = "";
1889 
1890   bool licenseLocked = false;
1891 
1892 
1893   mapping(address => bool) private _allowedMinters;
1894 
1895   event licenseisLocked(string _licenseText);
1896 
1897   function allowMinter(address minter) external onlyOwner {
1898     _allowedMinters[minter] = true;
1899   }
1900 
1901   function disallowMinter(address minter) external onlyOwner {
1902     _allowedMinters[minter] = false;
1903   }
1904 
1905   modifier onlyAllowedMinter {
1906     require(_allowedMinters[msg.sender] == true, "UNAUTH_CALLER");
1907     _;
1908   }
1909 
1910   constructor(string memory name, string memory symbol) ERC721(name, symbol)  {
1911   }
1912 
1913   function burn(uint256 tokenId) external {
1914     require(ownerOf(tokenId) == msg.sender, "NOT_OWNER_OF_TOKEN");
1915     _burn(tokenId);
1916   }
1917 
1918   function mint(address to, uint256 tokenId) public onlyAllowedMinter{
1919     _mint(to, tokenId);
1920   }
1921   
1922   function setBaseURI(string calldata baseURI_) external onlyOwner {
1923     _setBaseURI(baseURI_);
1924   }
1925 
1926   function setTokenURI(uint256 tokenId, string calldata _tokenURI) external   {
1927       require(_msgSender() == owner() || _msgSender() == ownerOf(tokenId), "Not Privileged to do this operation");
1928       _setTokenURI(tokenId, _tokenURI);
1929   }
1930 
1931   function tokenLicense(uint _id) public view returns (string memory) {
1932       require(_id < totalSupply(), "CHOOSE AN NFT WITHIN RANGE");
1933       return LICENSE_TEXT;
1934   }
1935 
1936   function lockLicense() public onlyOwner {
1937       licenseLocked = true;
1938       emit licenseisLocked(LICENSE_TEXT);
1939   }
1940 
1941   function changeLicense(string memory _license) public onlyOwner {
1942       require(licenseLocked == false, "License already locked");
1943       LICENSE_TEXT = _license;
1944   }
1945 
1946   function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1947       uint256 tokenCount = balanceOf(_owner);
1948       if(tokenCount == 0) {
1949           // Return an empty array
1950           return new uint256[](0);
1951       } else {
1952           uint256[] memory result = new uint256[](tokenCount);
1953           uint256 index;
1954           for (index = 0; index < tokenCount; index++) {
1955               result[index] = tokenOfOwnerByIndex(_owner, index);
1956           }
1957           return result;
1958       }
1959   }
1960 }