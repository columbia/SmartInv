1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 interface IERC165 {
5     /**
6      * @dev Returns true if this contract implements the interface defined by
7      * `interfaceId`. See the corresponding
8      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
9      * to learn more about how these ids are created.
10      *
11      * This function call must use less than 30 000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 interface IERC721 is IERC165 {
17     /**
18      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
21 
22     /**
23      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
24      */
25     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
26 
27     /**
28      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
29      */
30     event ApprovalWeed(address indexed owner, address indexed operator, bool approved);
31 
32     /**
33      * @dev Returns the number of tokens in ``owner``'s account.
34      */
35     function balanceOf(address owner) external view returns (uint256 balance);
36 
37     /**
38      * @dev Returns the owner of the `tokenId` token.
39      *
40      * Requirements:
41      *
42      * - `tokenId` must exist.
43      */
44     function ownerOf(uint256 tokenId) external view returns (address owner);
45 
46     /**
47      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
48      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
49      *
50      * Requirements:
51      *
52      * - `from` cannot be the zero address.
53      * - `to` cannot be the zero address.
54      * - `tokenId` token must exist and be owned by `from`.
55      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalWeed}.
56      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
57      *
58      * Emits a {Transfer} event.
59      */
60     function safeTransferFrom(
61         address from,
62         address to,
63         uint256 tokenId
64     ) external;
65 
66     /**
67      * @dev Transfers `tokenId` token from `from` to `to`.
68      *
69      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalWeed}.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
88      * The approval is cleared when the token is transferred.
89      *
90      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
91      *
92      * Requirements:
93      *
94      * - The caller must own the token or be an approved operator.
95      * - `tokenId` must exist.
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address to, uint256 tokenId) external;
100 
101     /**
102      * @dev Returns the account approved for `tokenId` token.
103      *
104      * Requirements:
105      *
106      * - `tokenId` must exist.
107      */
108     function getApproved(uint256 tokenId) external view returns (address operator);
109 
110     /**
111      * @dev Approve or remove `operator` as an operator for the caller.
112      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
113      *
114      * Requirements:
115      *
116      * - The `operator` cannot be the caller.
117      *
118      * Emits an {ApprovalWeed} event.
119      */
120     function setApprovalWeed(address operator, bool _approved) external;
121 
122     /**
123      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
124      *
125      * See {setApprovalWeed}
126      */
127     function isApprovedWeed(address owner, address operator) external view returns (bool);
128 
129     /**
130      * @dev Safely transfers `tokenId` token from `from` to `to`.
131      *
132      * Requirements:
133      *
134      * - `from` cannot be the zero address.
135      * - `to` cannot be the zero address.
136      * - `tokenId` token must exist and be owned by `from`.
137      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalWeed}.
138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
139      *
140      * Emits a {Transfer} event.
141      */
142     function safeTransferFrom(
143         address from,
144         address to,
145         uint256 tokenId,
146         bytes calldata data
147     ) external;
148 }
149 
150 interface IERC721Receiver {
151     /**
152      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
153      * by `operator` from `from`, this function is called.
154      *
155      * It must return its Solidity selector to confirm the token transfer.
156      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
157      *
158      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
159      */
160     function onERC721Received(
161         address operator,
162         address from,
163         uint256 tokenId,
164         bytes calldata data
165     ) external returns (bytes4);
166 }
167 
168 interface IERC721Metadata is IERC721 {
169     /**
170      * @dev Returns the token collection name.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the token collection symbol.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
181      */
182     function tokenURI(uint256 tokenId) external view returns (string memory);
183 }
184 
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      *
203      * [IMPORTANT]
204      * ====
205      * You shouldn't rely on `isContract` to protect against flash loan attacks!
206      *
207      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
208      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
209      * constructor.
210      * ====
211      */
212     function isContract(address account) internal view returns (bool) {
213         // This method relies on extcodesize/address.code.length, which returns 0
214         // for contracts in construction, since the code is only stored at the end
215         // of the constructor execution.
216 
217         return account.code.length > 0;
218     }
219 
220     /**
221      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
222      * `recipient`, forwarding all available gas and reverting on errors.
223      *
224      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
225      * of certain opcodes, possibly making contracts go over the 2300 gas limit
226      * imposed by `transfer`, making them unable to receive funds via
227      * `transfer`. {sendValue} removes this limitation.
228      *
229      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
230      *
231      * IMPORTANT: because control is transferred to `recipient`, care must be
232      * taken to not create reentrancy vulnerabilities. Consider using
233      * {ReentrancyGuard} or the
234      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
235      */
236     function sendValue(address payable recipient, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238 
239         (bool success, ) = recipient.call{value: amount}("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, 0, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but also transferring `value` wei to `target`.
282      *
283      * Requirements:
284      *
285      * - the calling contract must have an ETH balance of at least `value`.
286      * - the called Solidity function must be `payable`.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value: value}(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
324         return functionStaticCall(target, data, "Address: low-level static call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.staticcall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
373      * revert reason using the provided one.
374      *
375      * _Available since v4.3._
376      */
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 abstract contract Context {
401     function _msgSender() internal view virtual returns (address) {
402         return msg.sender;
403     }
404 
405     function _msgData() internal view virtual returns (bytes calldata) {
406         return msg.data;
407     }
408 }
409 
410 library Strings {
411     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
412 
413     /**
414      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
415      */
416     function toString(uint256 value) internal pure returns (string memory) {
417         // Inspired by OraclizeAPI's implementation - MIT licence
418         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
419 
420         if (value == 0) {
421             return "0";
422         }
423         uint256 temp = value;
424         uint256 digits;
425         while (temp != 0) {
426             digits++;
427             temp /= 10;
428         }
429         bytes memory buffer = new bytes(digits);
430         while (value != 0) {
431             digits -= 1;
432             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
433             value /= 10;
434         }
435         return string(buffer);
436     }
437 
438     /**
439      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
440      */
441     function toHexString(uint256 value) internal pure returns (string memory) {
442         if (value == 0) {
443             return "0x00";
444         }
445         uint256 temp = value;
446         uint256 length = 0;
447         while (temp != 0) {
448             length++;
449             temp >>= 8;
450         }
451         return toHexString(value, length);
452     }
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
456      */
457     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
458         bytes memory buffer = new bytes(2 * length + 2);
459         buffer[0] = "0";
460         buffer[1] = "x";
461         for (uint256 i = 2 * length + 1; i > 1; --i) {
462             buffer[i] = _HEX_SYMBOLS[value & 0xf];
463             value >>= 4;
464         }
465         require(value == 0, "Strings: hex length insufficient");
466         return string(buffer);
467     }
468 }
469 
470 abstract contract ERC165 is IERC165 {
471     /**
472      * @dev See {IERC165-supportsInterface}.
473      */
474     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475         return interfaceId == type(IERC165).interfaceId;
476     }
477 }
478 
479 abstract contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor() {
488         _transferOwnership(_msgSender());
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view virtual returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(owner() == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         _transferOwnership(address(0));
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public virtual onlyOwner {
522         require(newOwner != address(0), "Ownable: new owner is the zero address");
523         _transferOwnership(newOwner);
524     }
525 
526     /**
527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
528      * Internal function without access restriction.
529      */
530     function _transferOwnership(address newOwner) internal virtual {
531         address oldOwner = _owner;
532         _owner = newOwner;
533         emit OwnershipTransferred(oldOwner, newOwner);
534     }
535 }
536 
537 interface IERC20 {
538     /**
539      * @dev Returns the amount of tokens in existence.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns the amount of tokens owned by `account`.
545      */
546     function balanceOf(address account) external view returns (uint256);
547 
548     /**
549      * @dev Moves `amount` tokens from the caller's account to `recipient`.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transfer(address recipient, uint256 amount) external returns (bool);
556 
557     /**
558      * @dev Returns the remaining number of tokens that `spender` will be
559      * allowed to spend on behalf of `owner` through {transferFrom}. This is
560      * zero by default.
561      *
562      * This value changes when {approve} or {transferFrom} are called.
563      */
564     function allowance(address owner, address spender) external view returns (uint256);
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
568      *
569      * Returns a boolean value indicating whether the operation succeeded.
570      *
571      * IMPORTANT: Beware that changing an allowance with this method brings the risk
572      * that someone may use both the old and the new allowance by unfortunate
573      * transaction ordering. One possible solution to mitigate this race
574      * condition is to first reduce the spender's allowance to 0 and set the
575      * desired value afterwards:
576      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address spender, uint256 amount) external returns (bool);
581 
582     /**
583      * @dev Moves `amount` tokens from `sender` to `recipient` using the
584      * allowance mechanism. `amount` is then deducted from the caller's
585      * allowance.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(
592         address sender,
593         address recipient,
594         uint256 amount
595     ) external returns (bool);
596 
597     /**
598      * @dev Emitted when `value` tokens are moved from one account (`from`) to
599      * another (`to`).
600      *
601      * Note that `value` may be zero.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 value);
604 
605     /**
606      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
607      * a call to {approve}. `value` is the new allowance.
608      */
609     event Approval(address indexed owner, address indexed spender, uint256 value);
610 }
611 
612 library SafeERC20 {
613     using Address for address;
614 
615     function safeTransfer(
616         IERC20 token,
617         address to,
618         uint256 value
619     ) internal {
620         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
621     }
622 
623     function safeTransferFrom(
624         IERC20 token,
625         address from,
626         address to,
627         uint256 value
628     ) internal {
629         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
630     }
631 
632     /**
633      * @dev Deprecated. This function has issues similar to the ones found in
634      * {IERC20-approve}, and its usage is discouraged.
635      *
636      * Whenever possible, use {safeIncreaseAllowance} and
637      * {safeDecreaseAllowance} instead.
638      */
639     function safeApprove(
640         IERC20 token,
641         address spender,
642         uint256 value
643     ) internal {
644         // safeApprove should only be called when setting an initial allowance,
645         // or when resetting it to zero. To increase and decrease it, use
646         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
647         require(
648             (value == 0) || (token.allowance(address(this), spender) == 0),
649             "SafeERC20: approve from non-zero to non-zero allowance"
650         );
651         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
652     }
653 
654     function safeIncreaseAllowance(
655         IERC20 token,
656         address spender,
657         uint256 value
658     ) internal {
659         uint256 newAllowance = token.allowance(address(this), spender) + value;
660         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
661     }
662 
663     function safeDecreaseAllowance(
664         IERC20 token,
665         address spender,
666         uint256 value
667     ) internal {
668         unchecked {
669             uint256 oldAllowance = token.allowance(address(this), spender);
670             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
671             uint256 newAllowance = oldAllowance - value;
672             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
673         }
674     }
675 
676     /**
677      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
678      * on the return value: the return value is optional (but if data is returned, it must not be false).
679      * @param token The token targeted by the call.
680      * @param data The call data (encoded using abi.encode or one of its variants).
681      */
682     function _callOptionalReturn(IERC20 token, bytes memory data) private {
683         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
684         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
685         // the target address contains contract code and also asserts for success in the low-level call.
686 
687         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
688         if (returndata.length > 0) {
689             // Return data is optional
690             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
691         }
692     }
693 }
694 
695 interface IWeedsLab {
696     function getNFTMetadata(uint256 tokenID) external view returns (uint8, uint8);
697 }
698 
699 interface IStaking {
700     function startFarming(uint256 _startDate) external;
701 }
702 
703 contract WeedsLab is ERC165, IERC721, IERC721Metadata, Ownable {
704     using Address for address;
705     using Strings for uint256;
706     using SafeERC20 for IERC20;
707 
708     struct PriceChange {
709         uint256 startTime;
710         uint256 newPrice;
711     }
712 
713     address[] public claimWallets;
714     mapping(address => uint256) public claimAmounts;
715  
716     mapping (uint8 => PriceChange) private priceChange;
717 
718     struct NFTMetadata {
719         /**
720         _nftType:
721         0 - Sol
722          */
723         uint8 _nftType;
724         /**
725         gen:
726         Gen 0 - from 1 to 3333
727          */
728         uint8 gen;
729     }
730 
731     uint256[] private mintedSols;
732 
733     // Token name
734     string private _name = "Weeds Lab Official";
735 
736     // Token symbol
737     string private _symbol = "WeedsLab";
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     uint256 private _totalSupply = 3333;
752     uint256 private _circulatingSupply;
753 
754     mapping (uint256 => NFTMetadata) private _nftMetadata;
755 
756     mapping (address => bool) private whitelist;
757 
758     mapping (address => uint256) public getLists;
759     mapping (address => uint256) public usedGetLists;
760     bool public listsEnabled = false;
761 
762     bool public whitelistOnly = true;
763 
764     address stakingContract;
765 
766     bool public _revealed;
767 
768     string private baseURI;
769     string private notRevealedURI;
770 
771     uint256 private gen0Price = 3 * 10**16; // wl1 25 * 10**15 // wl2 28 * 10**15
772 
773     modifier onlyStaking() {
774         require(_msgSender() == stakingContract);
775         _;
776     }
777 
778     constructor(address[] memory _wallets, uint256[] memory _percentages) {
779         uint256 total;
780         require(_wallets.length == _percentages.length, "Invalid Input");
781         for (uint256 i = 0; i < _wallets.length; i++) {
782             claimWallets.push(_wallets[i]);
783             claimAmounts[_wallets[i]] = _percentages[i];
784             total += _percentages[i];
785         }
786         require(total == 100, "Total percentages must add up to 100");
787     }
788 
789     /// @dev Public Functions
790 
791     function skip(uint256 amount) public onlyOwner {
792         _circulatingSupply += amount;
793     }
794 
795     function test(uint256 _amount) public onlyOwner {
796         for (uint256 i = 0; i < _amount; i++) {
797             _circulatingSupply ++;
798             _safeMint(_msgSender(), _circulatingSupply);
799         }
800     }
801 
802     function getCurrentPrice() external view returns (uint256) {
803         uint8 gen;
804         if (_circulatingSupply <= 3333) {
805             gen = 0;
806         } else {
807             return 0;
808         }
809         return _getCurrentPrice(gen);
810     }
811 
812     function getUserNFTIds(address user) public view returns (uint256[] memory) {
813         uint256[] memory userIds = new uint256[](balanceOf(user));
814         for (uint256 i = 0; i < balanceOf(user); i++) {
815             userIds[i] = _ownedTokens[user][i];
816         }
817         return userIds;
818     }
819 
820     function getNumOfMintedSols() public view returns (uint256) {
821         return mintedSols.length;
822     }
823 
824     function getNFTMetadata(uint256 tokenID) external view virtual returns (uint8, uint8) {
825         require(_revealed, "Tokens were not yet revealed");
826         require(_exists(tokenID), "Token does not exist");
827         return (_nftMetadata[tokenID]._nftType, _nftMetadata[tokenID].gen);
828     }
829 
830     function isInWhitelist(address _address) external view returns (bool) {
831         return whitelist[_address];
832     }
833 
834     function getMintedSols() external view returns (uint256[] memory) {
835         return mintedSols;
836     }
837 
838     function getList(uint256 _amount) external {
839         require(usedGetLists[_msgSender()] + _amount <= getLists[_msgSender()], "Insufficient mints");
840         usedGetLists[_msgSender()] += _amount;
841         for (uint256 i = 0; i < _amount; i++) {
842             _circulatingSupply ++;
843             _safeMint(_msgSender(), _circulatingSupply);
844         }
845     }
846 
847     function mint(uint256 _amount) external payable {
848         require(_circulatingSupply + _amount <= 3333, "All tokens were minted");
849         uint256 price;
850         if (_circulatingSupply < 3333 && _circulatingSupply + _amount <= 3333) {
851             price = _getCurrentPrice(0);
852             require(msg.value >= _amount * price);
853             if (whitelistOnly) {
854                 require(whitelist[_msgSender()], "Address is not in whitelist");
855             }
856             if (msg.value > _amount * price) {
857                 payable(msg.sender).transfer(msg.value - _amount * price);
858             }
859         }  
860         for (uint256 i = 0; i < _amount; i++) {
861             _circulatingSupply ++;
862             _safeMint(_msgSender(), _circulatingSupply);
863             if (_circulatingSupply == 3333) {
864                 _startFarming();
865             }
866         }
867     } 
868 
869     function withdrawFunds() external {
870         require(claimAmounts[_msgSender()] > 0, "Contract: Unauthorised call");
871         uint256 nBal = address(this).balance;
872         for (uint256 i = 0; i < claimWallets.length; i++) {
873             address to = claimWallets[i];
874             if (nBal > 0) {
875                 payable(to).transfer(nBal * claimAmounts[to] / 100);
876             } 
877         }
878     }
879 
880     /// @dev onlyOwner Functions
881 
882     function setTempoPrice(uint8 gen, uint256 newPrice, uint256 startTime) external onlyOwner {
883         if (startTime == 0) {
884             startTime = block.timestamp;
885         }
886         priceChange[gen].startTime = startTime;
887         priceChange[gen].newPrice = newPrice * 10**15;
888     }
889 
890     function setList(bool value) external onlyOwner {
891         listsEnabled = value;
892     }
893 
894     function setLists(address[] memory addresses, uint256 amount) external onlyOwner {
895         for (uint256 i = 0; i < addresses.length; i++) {
896             getLists[addresses[i]] = amount;
897         }
898     }
899 
900     function changeMintPrice(uint256 _gen0Price) external onlyOwner {
901         gen0Price = _gen0Price * 10**15;
902     }
903 
904     function reveal() external onlyOwner {
905         _revealed = true;
906     }
907 
908     function setBaseURI(string memory _newBaseURI) external onlyOwner {
909         baseURI = _newBaseURI;
910     }
911 
912     function setNotRevealedURI(string memory _newNotRevealedURI) external onlyOwner {
913         notRevealedURI = _newNotRevealedURI;
914     }
915 
916     function setStakingContract(address _address) external onlyOwner {
917         stakingContract = _address;
918     }
919 
920     function withdrawAnyToken(IERC20 asset) external onlyOwner {
921         asset.safeTransfer(owner(), asset.balanceOf(address(this)));
922     }
923 
924     function setWhitelistStatus(bool value) external onlyOwner {
925         whitelistOnly = value;
926     }
927 
928     function addToWhitelist(address _address) external onlyOwner {
929         _addToWhitelist(_address);
930     }
931 
932     function addMultipleToWhitelist(address[] memory _addresses) external onlyOwner {
933         for (uint256 i = 0; i < _addresses.length; i++) {
934             _addToWhitelist(_addresses[i]);
935         }
936     }
937 
938     function _startFarming() internal {
939         require(_circulatingSupply == 3333);
940         IStaking(stakingContract).startFarming(block.timestamp);
941     }
942 
943     function _getCurrentPrice(uint8 gen) internal view returns (uint256) {
944         require(gen < 3, "Invalid Generation");
945         if (block.timestamp <= priceChange[gen].startTime + 3600) {
946             return priceChange[gen].newPrice;
947         } else {
948             if (gen == 0) {
949                 return gen0Price;
950             } else {
951                 revert();
952             }
953         }
954     }
955 
956     function _addToWhitelist(address _address) internal {
957         whitelist[_address] = true;
958     }
959 
960     /// @dev ERC721 Functions
961 
962     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
963         return
964             interfaceId == type(IERC721).interfaceId ||
965             interfaceId == type(IERC721Metadata).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     function totalSupply() public view virtual returns (uint256) {
970         return _totalSupply;
971     }
972 
973     function cirulatingSupply() public view returns (uint256) {
974         return _circulatingSupply;
975     }
976 
977     function balanceOf(address owner) public view virtual override returns (uint256) {
978         require(owner != address(0), "ERC721: balance query for the zero address");
979         return _balances[owner];
980     }
981 
982     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
983         address owner = _owners[tokenId];
984         require(owner != address(0), "ERC721: owner query for nonexistent token");
985         return owner;
986     }
987 
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     function symbol() public view virtual override returns (string memory) {
993         return _symbol;
994     }
995 
996     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
997         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
998 
999         if (_revealed) {
1000             string memory baseURI_ = _baseURI();
1001             return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString())) : "";
1002         } else {
1003             return string(abi.encodePacked(notRevealedURI, tokenId.toString()));
1004         }
1005     
1006     }
1007 
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return baseURI;
1010     }
1011 
1012     function approve(address to, uint256 tokenId) public virtual override {
1013         address owner = ownerOf(tokenId);
1014         require(to != owner, "ERC721: approval to current owner");
1015 
1016         require(
1017             _msgSender() == owner || isApprovedWeed(owner, _msgSender()),
1018             "ERC721: approve caller is not owner nor approved for all"
1019         );
1020 
1021         _approve(to, tokenId);
1022     }
1023 
1024     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1025         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1026 
1027         return _tokenApprovals[tokenId];
1028     }
1029 
1030     function setApprovalWeed(address operator, bool approved) public virtual override {
1031         _setApprovalWeed(_msgSender(), operator, approved);
1032     }
1033 
1034     function isApprovedWeed(address owner, address operator) public view virtual override returns (bool) {
1035         return _operatorApprovals[owner][operator];
1036     }
1037 
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         //solhint-disable-next-line max-line-length
1044         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1045 
1046         _transfer(from, to, tokenId);
1047     }
1048 
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, "");
1055     }
1056 
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) public virtual override {
1063         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1064         _safeTransfer(from, to, tokenId, _data);
1065     }
1066 
1067     function _safeTransfer(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) internal virtual {
1073         _transfer(from, to, tokenId);
1074         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1075     }
1076 
1077     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1078         return _owners[tokenId] != address(0);
1079     }
1080 
1081     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1082         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1083         address owner = ownerOf(tokenId);
1084         return (spender == owner || getApproved(tokenId) == spender || isApprovedWeed(owner, spender));
1085     }
1086 
1087     function _safeMint(address to, uint256 tokenId) internal virtual {
1088         _safeMint(to, tokenId, "");
1089     }
1090 
1091     function _safeMint(
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) internal virtual {
1096         _mint(to, tokenId);
1097         require(
1098             _checkOnERC721Received(address(0), to, tokenId, _data),
1099             "ERC721: transfer to non ERC721Receiver implementer"
1100         );
1101     }
1102 
1103     function _mint(address to, uint256 tokenId) internal virtual {
1104         require(to != address(0), "ERC721: mint to the zero address");
1105         require(!_exists(tokenId), "ERC721: token already minted");
1106 
1107         _beforeTokenTransfer(address(0), to, tokenId);
1108 
1109         if (tokenId <= 3333) {
1110             _nftMetadata[tokenId].gen = 0;
1111         }
1112 
1113         if (_nftMetadata[tokenId]._nftType == 0) {
1114             mintedSols.push(tokenId);
1115         } 
1116 
1117         _balances[to] += 1;
1118         _owners[tokenId] = to;
1119         emit Transfer(address(0), to, tokenId);
1120     }
1121 
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {
1127         require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1128         require(to != address(0), "ERC721: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, tokenId);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId);
1134 
1135         _balances[from] -= 1;
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(from, to, tokenId);
1140 
1141     }
1142 
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     function _setApprovalWeed(
1149         address owner,
1150         address operator,
1151         bool approved
1152     ) internal virtual {
1153         require(owner != operator, "ERC721: approve to caller");
1154         _operatorApprovals[owner][operator] = approved;
1155         emit ApprovalWeed(owner, operator, approved);
1156     }
1157 
1158     function _checkOnERC721Received(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory _data
1163     ) private returns (bool) {
1164         if (to.isContract()) {
1165             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1166                 return retval == IERC721Receiver.onERC721Received.selector;
1167             } catch (bytes memory reason) {
1168                 if (reason.length == 0) {
1169                     revert("ERC721: transfer to non ERC721Receiver implementer");
1170                 } else {
1171                     assembly {
1172                         revert(add(32, reason), mload(reason))
1173                     }
1174                 }
1175             }
1176         } else {
1177             return true;
1178         }
1179     }
1180 
1181      // Mapping from owner to list of owned token IDs
1182     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1183 
1184     // Mapping from token ID to index of the owner tokens list
1185     mapping(uint256 => uint256) private _ownedTokensIndex;
1186 
1187     // Array with all token ids, used for enumeration
1188     uint256[] private _allTokens;
1189 
1190     // Mapping from token id to position in the allTokens array
1191     mapping(uint256 => uint256) private _allTokensIndex;
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1195      */
1196     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
1197         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1198         return _ownedTokens[owner][index];
1199     }
1200     
1201     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
1202         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1203         return _allTokens[index];
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any token transfer. This includes minting
1208      * and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {
1226         
1227         if (from == address(0)) {
1228             _addTokenToAllTokensEnumeration(tokenId);
1229         } else if (from != to) {
1230             _removeTokenFromOwnerEnumeration(from, tokenId);
1231         }
1232         if (to == address(0)) {
1233             _removeTokenFromAllTokensEnumeration(tokenId);
1234         } else if (to != from) {
1235             _addTokenToOwnerEnumeration(to, tokenId);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1241      * @param to address representing the new owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1243      */
1244     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1245         uint256 length = balanceOf(to);
1246         _ownedTokens[to][length] = tokenId;
1247         _ownedTokensIndex[tokenId] = length;
1248     }
1249 
1250     /**
1251      * @dev Private function to add a token to this extension's token tracking data structures.
1252      * @param tokenId uint256 ID of the token to be added to the tokens list
1253      */
1254     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1255         _allTokensIndex[tokenId] = _allTokens.length;
1256         _allTokens.push(tokenId);
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1261      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1262      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1263      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1264      * @param from address representing the previous owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1266      */
1267     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1268         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1269         // then delete the last slot (swap and pop).
1270 
1271         uint256 lastTokenIndex = balanceOf(from) - 1;
1272         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1273 
1274         // When the token to delete is the last token, the swap operation is unnecessary
1275         if (tokenIndex != lastTokenIndex) {
1276             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1277 
1278             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1279             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1280         }
1281 
1282         // This also deletes the contents at the last position of the array
1283         delete _ownedTokensIndex[tokenId];
1284         delete _ownedTokens[from][lastTokenIndex];
1285     }
1286 
1287     /**
1288      * @dev Private function to remove a token from this extension's token tracking data structures.
1289      * This has O(1) time complexity, but alters the order of the _allTokens array.
1290      * @param tokenId uint256 ID of the token to be removed from the tokens list
1291      */
1292     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1293         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1294         // then delete the last slot (swap and pop).
1295 
1296         uint256 lastTokenIndex = _allTokens.length - 1;
1297         uint256 tokenIndex = _allTokensIndex[tokenId];
1298 
1299         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1300         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1301         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1302         uint256 lastTokenId = _allTokens[lastTokenIndex];
1303 
1304         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1305         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1306 
1307         // This also deletes the contents at the last position of the array
1308         delete _allTokensIndex[tokenId];
1309         _allTokens.pop();
1310     }
1311 }