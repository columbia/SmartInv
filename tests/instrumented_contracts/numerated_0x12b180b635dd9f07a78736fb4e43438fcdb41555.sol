1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.12;
3 
4 /*
5   __  __                    _____      _       
6  |  \/  |                  / ____|    | |      
7  | \  / | ___   ___  _ __ | |     __ _| |_ ____
8  | |\/| |/ _ \ / _ \| '_ \| |    / _` | __|_  /
9  | |  | | (_) | (_) | | | | |___| (_| | |_ / / 
10  |_|  |_|\___/ \___/|_| |_|\_____\__,_|\__/___|
11 
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on `isContract` to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217                 /// @solidity memory-safe-assembly
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 interface IERC721A {
240     /**
241      * The caller must own the token or be an approved operator.
242      */
243     error ApprovalCallerNotOwnerNorApproved();
244 
245     /**
246      * The token does not exist.
247      */
248     error ApprovalQueryForNonexistentToken();
249 
250     /**
251      * The caller cannot approve to their own address.
252      */
253     error ApproveToCaller();
254 
255     /**
256      * Cannot query the balance for the zero address.
257      */
258     error BalanceQueryForZeroAddress();
259 
260     /**
261      * Cannot mint to the zero address.
262      */
263     error MintToZeroAddress();
264 
265     /**
266      * The quantity of tokens minted must be more than zero.
267      */
268     error MintZeroQuantity();
269 
270     /**
271      * The token does not exist.
272      */
273     error OwnerQueryForNonexistentToken();
274 
275     /**
276      * The caller must own the token or be an approved operator.
277      */
278     error TransferCallerNotOwnerNorApproved();
279 
280     /**
281      * The token must be owned by `from`.
282      */
283     error TransferFromIncorrectOwner();
284 
285     /**
286      * Cannot safely transfer to a contract that does not implement the
287      * ERC721Receiver interface.
288      */
289     error TransferToNonERC721ReceiverImplementer();
290 
291     /**
292      * Cannot transfer to the zero address.
293      */
294     error TransferToZeroAddress();
295 
296     /**
297      * The token does not exist.
298      */
299     error URIQueryForNonexistentToken();
300 
301     /**
302      * The `quantity` minted with ERC2309 exceeds the safety limit.
303      */
304     error MintERC2309QuantityExceedsLimit();
305 
306     /**
307      * The `extraData` cannot be set on an unintialized ownership slot.
308      */
309     error OwnershipNotInitializedForExtraData();
310 
311     // =============================================================
312     //                            STRUCTS
313     // =============================================================
314 
315     struct TokenOwnership {
316         // The address of the owner.
317         address addr;
318         // Stores the start time of ownership with minimal overhead for tokenomics.
319         uint64 startTimestamp;
320         // Whether the token has been burned.
321         bool burned;
322         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
323         uint24 extraData;
324     }
325 
326     // =============================================================
327     //                         TOKEN COUNTERS
328     // =============================================================
329 
330     /**
331      * @dev Returns the total number of tokens in existence.
332      * Burned tokens will reduce the count.
333      * To get the total number of tokens minted, please see {_totalMinted}.
334      */
335     function totalSupply() external view returns (uint256);
336 
337     // =============================================================
338     //                            IERC165
339     // =============================================================
340 
341     /**
342      * @dev Returns true if this contract implements the interface defined by
343      * `interfaceId`. See the corresponding
344      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
345      * to learn more about how these ids are created.
346      *
347      * This function call must use less than 30000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 
351     // =============================================================
352     //                            IERC721
353     // =============================================================
354 
355     /**
356      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
359 
360     /**
361      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
362      */
363     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables or disables
367      * (`approved`) `operator` to manage all of its assets.
368      */
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of tokens in `owner`'s account.
373      */
374     function balanceOf(address owner) external view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function ownerOf(uint256 tokenId) external view returns (address owner);
384 
385     /**
386      * @dev Safely transfers `tokenId` token from `from` to `to`,
387      * checking first that contract recipients are aware of the ERC721 protocol
388      * to prevent tokens from being forever locked.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must exist and be owned by `from`.
395      * - If the caller is not `from`, it must be have been allowed to move
396      * this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement
398      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
399      *
400      * Emits a {Transfer} event.
401      */
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId,
406         bytes calldata data
407     ) external;
408 
409     /**
410      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
411      */
412     function safeTransferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Transfers `tokenId` from `from` to `to`.
420      *
421      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
422      * whenever possible.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must be owned by `from`.
429      * - If the caller is not `from`, it must be approved to move this token
430      * by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the
445      * zero address clears previous approvals.
446      *
447      * Requirements:
448      *
449      * - The caller must own the token or be an approved operator.
450      * - `tokenId` must exist.
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address to, uint256 tokenId) external;
455 
456     /**
457      * @dev Approve or remove `operator` as an operator for the caller.
458      * Operators can call {transferFrom} or {safeTransferFrom}
459      * for any token owned by the caller.
460      *
461      * Requirements:
462      *
463      * - The `operator` cannot be the caller.
464      *
465      * Emits an {ApprovalForAll} event.
466      */
467     function setApprovalForAll(address operator, bool _approved) external;
468 
469     /**
470      * @dev Returns the account approved for `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function getApproved(uint256 tokenId) external view returns (address operator);
477 
478     /**
479      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
480      *
481      * See {setApprovalForAll}.
482      */
483     function isApprovedForAll(address owner, address operator) external view returns (bool);
484 
485     // =============================================================
486     //                        IERC721Metadata
487     // =============================================================
488 
489     /**
490      * @dev Returns the token collection name.
491      */
492     function name() external view returns (string memory);
493 
494     /**
495      * @dev Returns the token collection symbol.
496      */
497     function symbol() external view returns (string memory);
498 
499     /**
500      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
501      */
502     function tokenURI(uint256 tokenId) external view returns (string memory);
503 
504     // =============================================================
505     //                           IERC2309
506     // =============================================================
507 
508     /**
509      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
510      * (inclusive) is transferred from `from` to `to`, as defined in the
511      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
512      *
513      * See {_mintERC2309} for more details.
514      */
515     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
516 }
517 
518 interface IERC20Permit {
519     /**
520      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
521      * given ``owner``'s signed approval.
522      *
523      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
524      * ordering also apply here.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      * - `deadline` must be a timestamp in the future.
532      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
533      * over the EIP712-formatted function arguments.
534      * - the signature must use ``owner``'s current nonce (see {nonces}).
535      *
536      * For more information on the signature format, see the
537      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
538      * section].
539      */
540     function permit(
541         address owner,
542         address spender,
543         uint256 value,
544         uint256 deadline,
545         uint8 v,
546         bytes32 r,
547         bytes32 s
548     ) external;
549 
550     /**
551      * @dev Returns the current nonce for `owner`. This value must be
552      * included whenever a signature is generated for {permit}.
553      *
554      * Every successful call to {permit} increases ``owner``'s nonce by one. This
555      * prevents a signature from being used multiple times.
556      */
557     function nonces(address owner) external view returns (uint256);
558 
559     /**
560      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
561      */
562     // solhint-disable-next-line func-name-mixedcase
563     function DOMAIN_SEPARATOR() external view returns (bytes32);
564 }
565 
566 interface IERC20 {
567     /**
568      * @dev Emitted when `value` tokens are moved from one account (`from`) to
569      * another (`to`).
570      *
571      * Note that `value` may be zero.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 value);
574 
575     /**
576      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
577      * a call to {approve}. `value` is the new allowance.
578      */
579     event Approval(address indexed owner, address indexed spender, uint256 value);
580 
581     /**
582      * @dev Returns the amount of tokens in existence.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /**
587      * @dev Returns the amount of tokens owned by `account`.
588      */
589     function balanceOf(address account) external view returns (uint256);
590 
591     /**
592      * @dev Moves `amount` tokens from the caller's account to `to`.
593      *
594      * Returns a boolean value indicating whether the operation succeeded.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transfer(address to, uint256 amount) external returns (bool);
599 
600     /**
601      * @dev Returns the remaining number of tokens that `spender` will be
602      * allowed to spend on behalf of `owner` through {transferFrom}. This is
603      * zero by default.
604      *
605      * This value changes when {approve} or {transferFrom} are called.
606      */
607     function allowance(address owner, address spender) external view returns (uint256);
608 
609     /**
610      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
611      *
612      * Returns a boolean value indicating whether the operation succeeded.
613      *
614      * IMPORTANT: Beware that changing an allowance with this method brings the risk
615      * that someone may use both the old and the new allowance by unfortunate
616      * transaction ordering. One possible solution to mitigate this race
617      * condition is to first reduce the spender's allowance to 0 and set the
618      * desired value afterwards:
619      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address spender, uint256 amount) external returns (bool);
624 
625     /**
626      * @dev Moves `amount` tokens from `from` to `to` using the
627      * allowance mechanism. `amount` is then deducted from the caller's
628      * allowance.
629      *
630      * Returns a boolean value indicating whether the operation succeeded.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 amount
638     ) external returns (bool);
639 }
640 
641 library SafeERC20 {
642     using Address for address;
643 
644     function safeTransfer(
645         IERC20 token,
646         address to,
647         uint256 value
648     ) internal {
649         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
650     }
651 
652     function safeTransferFrom(
653         IERC20 token,
654         address from,
655         address to,
656         uint256 value
657     ) internal {
658         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
659     }
660 
661     /**
662      * @dev Deprecated. This function has issues similar to the ones found in
663      * {IERC20-approve}, and its usage is discouraged.
664      *
665      * Whenever possible, use {safeIncreaseAllowance} and
666      * {safeDecreaseAllowance} instead.
667      */
668     function safeApprove(
669         IERC20 token,
670         address spender,
671         uint256 value
672     ) internal {
673         // safeApprove should only be called when setting an initial allowance,
674         // or when resetting it to zero. To increase and decrease it, use
675         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
676         require(
677             (value == 0) || (token.allowance(address(this), spender) == 0),
678             "SafeERC20: approve from non-zero to non-zero allowance"
679         );
680         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
681     }
682 
683     function safeIncreaseAllowance(
684         IERC20 token,
685         address spender,
686         uint256 value
687     ) internal {
688         uint256 newAllowance = token.allowance(address(this), spender) + value;
689         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
690     }
691 
692     function safeDecreaseAllowance(
693         IERC20 token,
694         address spender,
695         uint256 value
696     ) internal {
697         unchecked {
698             uint256 oldAllowance = token.allowance(address(this), spender);
699             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
700             uint256 newAllowance = oldAllowance - value;
701             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702         }
703     }
704 
705     function safePermit(
706         IERC20Permit token,
707         address owner,
708         address spender,
709         uint256 value,
710         uint256 deadline,
711         uint8 v,
712         bytes32 r,
713         bytes32 s
714     ) internal {
715         uint256 nonceBefore = token.nonces(owner);
716         token.permit(owner, spender, value, deadline, v, r, s);
717         uint256 nonceAfter = token.nonces(owner);
718         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
719     }
720 
721     /**
722      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
723      * on the return value: the return value is optional (but if data is returned, it must not be false).
724      * @param token The token targeted by the call.
725      * @param data The call data (encoded using abi.encode or one of its variants).
726      */
727     function _callOptionalReturn(IERC20 token, bytes memory data) private {
728         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
729         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
730         // the target address contains contract code and also asserts for success in the low-level call.
731 
732         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
733         if (returndata.length > 0) {
734             // Return data is optional
735             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
736         }
737     }
738 }
739 
740 library Strings {
741     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
742     uint8 private constant _ADDRESS_LENGTH = 20;
743 
744     /**
745      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
746      */
747     function toString(uint256 value) internal pure returns (string memory) {
748         // Inspired by OraclizeAPI's implementation - MIT licence
749         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
750 
751         if (value == 0) {
752             return "0";
753         }
754         uint256 temp = value;
755         uint256 digits;
756         while (temp != 0) {
757             digits++;
758             temp /= 10;
759         }
760         bytes memory buffer = new bytes(digits);
761         while (value != 0) {
762             digits -= 1;
763             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
764             value /= 10;
765         }
766         return string(buffer);
767     }
768 
769     /**
770      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
771      */
772     function toHexString(uint256 value) internal pure returns (string memory) {
773         if (value == 0) {
774             return "0x00";
775         }
776         uint256 temp = value;
777         uint256 length = 0;
778         while (temp != 0) {
779             length++;
780             temp >>= 8;
781         }
782         return toHexString(value, length);
783     }
784 
785     /**
786      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
787      */
788     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
789         bytes memory buffer = new bytes(2 * length + 2);
790         buffer[0] = "0";
791         buffer[1] = "x";
792         for (uint256 i = 2 * length + 1; i > 1; --i) {
793             buffer[i] = _HEX_SYMBOLS[value & 0xf];
794             value >>= 4;
795         }
796         require(value == 0, "Strings: hex length insufficient");
797         return string(buffer);
798     }
799 
800     /**
801      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
802      */
803     function toHexString(address addr) internal pure returns (string memory) {
804         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
805     }
806 }
807 
808 abstract contract Ownable is Context {
809     address private _owner;
810 
811     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
812 
813     /**
814      * @dev Initializes the contract setting the deployer as the initial owner.
815      */
816     constructor() {
817         _transferOwnership(_msgSender());
818     }
819 
820     /**
821      * @dev Throws if called by any account other than the owner.
822      */
823     modifier onlyOwner() {
824         _checkOwner();
825         _;
826     }
827 
828     /**
829      * @dev Returns the address of the current owner.
830      */
831     function owner() public view virtual returns (address) {
832         return _owner;
833     }
834 
835     /**
836      * @dev Throws if the sender is not the owner.
837      */
838     function _checkOwner() internal view virtual {
839         require(owner() == _msgSender(), "Ownable: caller is not the owner");
840     }
841 
842     /**
843      * @dev Leaves the contract without owner. It will not be possible to call
844      * `onlyOwner` functions anymore. Can only be called by the current owner.
845      *
846      * NOTE: Renouncing ownership will leave the contract without an owner,
847      * thereby removing any functionality that is only available to the owner.
848      */
849     function renounceOwnership() public virtual onlyOwner {
850         _transferOwnership(address(0));
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Can only be called by the current owner.
856      */
857     function transferOwnership(address newOwner) public virtual onlyOwner {
858         require(newOwner != address(0), "Ownable: new owner is the zero address");
859         _transferOwnership(newOwner);
860     }
861 
862     /**
863      * @dev Transfers ownership of the contract to a new account (`newOwner`).
864      * Internal function without access restriction.
865      */
866     function _transferOwnership(address newOwner) internal virtual {
867         address oldOwner = _owner;
868         _owner = newOwner;
869         emit OwnershipTransferred(oldOwner, newOwner);
870     }
871 }
872 
873 library ECDSA {
874     enum RecoverError {
875         NoError,
876         InvalidSignature,
877         InvalidSignatureLength,
878         InvalidSignatureS,
879         InvalidSignatureV
880     }
881 
882     function _throwError(RecoverError error) private pure {
883         if (error == RecoverError.NoError) {
884             return; // no error: do nothing
885         } else if (error == RecoverError.InvalidSignature) {
886             revert("ECDSA: invalid signature");
887         } else if (error == RecoverError.InvalidSignatureLength) {
888             revert("ECDSA: invalid signature length");
889         } else if (error == RecoverError.InvalidSignatureS) {
890             revert("ECDSA: invalid signature 's' value");
891         } else if (error == RecoverError.InvalidSignatureV) {
892             revert("ECDSA: invalid signature 'v' value");
893         }
894     }
895 
896     /**
897      * @dev Returns the address that signed a hashed message (`hash`) with
898      * `signature` or error string. This address can then be used for verification purposes.
899      *
900      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
901      * this function rejects them by requiring the `s` value to be in the lower
902      * half order, and the `v` value to be either 27 or 28.
903      *
904      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
905      * verification to be secure: it is possible to craft signatures that
906      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
907      * this is by receiving a hash of the original message (which may otherwise
908      * be too long), and then calling {toEthSignedMessageHash} on it.
909      *
910      * Documentation for signature generation:
911      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
912      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
913      *
914      * _Available since v4.3._
915      */
916     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
917         // Check the signature length
918         // - case 65: r,s,v signature (standard)
919         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
920         if (signature.length == 65) {
921             bytes32 r;
922             bytes32 s;
923             uint8 v;
924             // ecrecover takes the signature parameters, and the only way to get them
925             // currently is to use assembly.
926             /// @solidity memory-safe-assembly
927             assembly {
928                 r := mload(add(signature, 0x20))
929                 s := mload(add(signature, 0x40))
930                 v := byte(0, mload(add(signature, 0x60)))
931             }
932             return tryRecover(hash, v, r, s);
933         } else if (signature.length == 64) {
934             bytes32 r;
935             bytes32 vs;
936             // ecrecover takes the signature parameters, and the only way to get them
937             // currently is to use assembly.
938             /// @solidity memory-safe-assembly
939             assembly {
940                 r := mload(add(signature, 0x20))
941                 vs := mload(add(signature, 0x40))
942             }
943             return tryRecover(hash, r, vs);
944         } else {
945             return (address(0), RecoverError.InvalidSignatureLength);
946         }
947     }
948 
949     /**
950      * @dev Returns the address that signed a hashed message (`hash`) with
951      * `signature`. This address can then be used for verification purposes.
952      *
953      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
954      * this function rejects them by requiring the `s` value to be in the lower
955      * half order, and the `v` value to be either 27 or 28.
956      *
957      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
958      * verification to be secure: it is possible to craft signatures that
959      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
960      * this is by receiving a hash of the original message (which may otherwise
961      * be too long), and then calling {toEthSignedMessageHash} on it.
962      */
963     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
964         (address recovered, RecoverError error) = tryRecover(hash, signature);
965         _throwError(error);
966         return recovered;
967     }
968 
969     /**
970      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
971      *
972      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
973      *
974      * _Available since v4.3._
975      */
976     function tryRecover(
977         bytes32 hash,
978         bytes32 r,
979         bytes32 vs
980     ) internal pure returns (address, RecoverError) {
981         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
982         uint8 v = uint8((uint256(vs) >> 255) + 27);
983         return tryRecover(hash, v, r, s);
984     }
985 
986     /**
987      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
988      *
989      * _Available since v4.2._
990      */
991     function recover(
992         bytes32 hash,
993         bytes32 r,
994         bytes32 vs
995     ) internal pure returns (address) {
996         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
997         _throwError(error);
998         return recovered;
999     }
1000 
1001     /**
1002      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1003      * `r` and `s` signature fields separately.
1004      *
1005      * _Available since v4.3._
1006      */
1007     function tryRecover(
1008         bytes32 hash,
1009         uint8 v,
1010         bytes32 r,
1011         bytes32 s
1012     ) internal pure returns (address, RecoverError) {
1013         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1014         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1015         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1016         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1017         //
1018         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1019         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1020         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1021         // these malleable signatures as well.
1022         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1023             return (address(0), RecoverError.InvalidSignatureS);
1024         }
1025         if (v != 27 && v != 28) {
1026             return (address(0), RecoverError.InvalidSignatureV);
1027         }
1028 
1029         // If the signature is valid (and not malleable), return the signer address
1030         address signer = ecrecover(hash, v, r, s);
1031         if (signer == address(0)) {
1032             return (address(0), RecoverError.InvalidSignature);
1033         }
1034 
1035         return (signer, RecoverError.NoError);
1036     }
1037 
1038     /**
1039      * @dev Overload of {ECDSA-recover} that receives the `v`,
1040      * `r` and `s` signature fields separately.
1041      */
1042     function recover(
1043         bytes32 hash,
1044         uint8 v,
1045         bytes32 r,
1046         bytes32 s
1047     ) internal pure returns (address) {
1048         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1049         _throwError(error);
1050         return recovered;
1051     }
1052 
1053     /**
1054      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1055      * produces hash corresponding to the one signed with the
1056      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1057      * JSON-RPC method as part of EIP-191.
1058      *
1059      * See {recover}.
1060      */
1061     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1062         // 32 is the length in bytes of hash,
1063         // enforced by the type signature above
1064         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1065     }
1066 
1067     /**
1068      * @dev Returns an Ethereum Signed Message, created from `s`. This
1069      * produces hash corresponding to the one signed with the
1070      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1071      * JSON-RPC method as part of EIP-191.
1072      *
1073      * See {recover}.
1074      */
1075     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1076         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1077     }
1078 
1079     /**
1080      * @dev Returns an Ethereum Signed Typed Data, created from a
1081      * `domainSeparator` and a `structHash`. This produces hash corresponding
1082      * to the one signed with the
1083      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1084      * JSON-RPC method as part of EIP-712.
1085      *
1086      * See {recover}.
1087      */
1088     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1089         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1090     }
1091 }
1092 
1093 contract PaymentSplitter is Context {
1094     event PayeeAdded(address account, uint256 shares);
1095     event PaymentReleased(address to, uint256 amount);
1096     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1097     event PaymentReceived(address from, uint256 amount);
1098 
1099     uint256 private _totalShares;
1100     uint256 private _totalReleased;
1101 
1102     mapping(address => uint256) private _shares;
1103     mapping(address => uint256) private _released;
1104     address[] private _payees;
1105 
1106     mapping(IERC20 => uint256) private _erc20TotalReleased;
1107     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1108 
1109     /**
1110      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1111      * the matching position in the `shares` array.
1112      *
1113      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1114      * duplicates in `payees`.
1115      */
1116     constructor(address[] memory payees, uint256[] memory shares_) payable {
1117         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1118         require(payees.length > 0, "PaymentSplitter: no payees");
1119 
1120         for (uint256 i = 0; i < payees.length; i++) {
1121             _addPayee(payees[i], shares_[i]);
1122         }
1123     }
1124 
1125     /**
1126      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1127      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1128      * reliability of the events, and not the actual splitting of Ether.
1129      *
1130      * To learn more about this see the Solidity documentation for
1131      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1132      * functions].
1133      */
1134     receive() external payable virtual {
1135         emit PaymentReceived(_msgSender(), msg.value);
1136     }
1137 
1138     /**
1139      * @dev Getter for the total shares held by payees.
1140      */
1141     function totalShares() public view returns (uint256) {
1142         return _totalShares;
1143     }
1144 
1145     /**
1146      * @dev Getter for the total amount of Ether already released.
1147      */
1148     function totalReleased() public view returns (uint256) {
1149         return _totalReleased;
1150     }
1151 
1152     /**
1153      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1154      * contract.
1155      */
1156     function totalReleased(IERC20 token) public view returns (uint256) {
1157         return _erc20TotalReleased[token];
1158     }
1159 
1160     /**
1161      * @dev Getter for the amount of shares held by an account.
1162      */
1163     function shares(address account) public view returns (uint256) {
1164         return _shares[account];
1165     }
1166 
1167     /**
1168      * @dev Getter for the amount of Ether already released to a payee.
1169      */
1170     function released(address account) public view returns (uint256) {
1171         return _released[account];
1172     }
1173 
1174     /**
1175      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1176      * IERC20 contract.
1177      */
1178     function released(IERC20 token, address account) public view returns (uint256) {
1179         return _erc20Released[token][account];
1180     }
1181 
1182     /**
1183      * @dev Getter for the address of the payee number `index`.
1184      */
1185     function payee(uint256 index) public view returns (address) {
1186         return _payees[index];
1187     }
1188 
1189     /**
1190      * @dev Getter for the amount of payee's releasable Ether.
1191      */
1192     function releasable(address account) public view returns (uint256) {
1193         uint256 totalReceived = address(this).balance + totalReleased();
1194         return _pendingPayment(account, totalReceived, released(account));
1195     }
1196 
1197     /**
1198      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1199      * IERC20 contract.
1200      */
1201     function releasable(IERC20 token, address account) public view returns (uint256) {
1202         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1203         return _pendingPayment(account, totalReceived, released(token, account));
1204     }
1205 
1206     /**
1207      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1208      * total shares and their previous withdrawals.
1209      */
1210     function release(address payable account) public virtual {
1211         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1212 
1213         uint256 payment = releasable(account);
1214 
1215         require(payment != 0, "PaymentSplitter: account is not due payment");
1216 
1217         _released[account] += payment;
1218         _totalReleased += payment;
1219 
1220         Address.sendValue(account, payment);
1221         emit PaymentReleased(account, payment);
1222     }
1223 
1224     /**
1225      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1226      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1227      * contract.
1228      */
1229     function release(IERC20 token, address account) public virtual {
1230         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1231 
1232         uint256 payment = releasable(token, account);
1233 
1234         require(payment != 0, "PaymentSplitter: account is not due payment");
1235 
1236         _erc20Released[token][account] += payment;
1237         _erc20TotalReleased[token] += payment;
1238 
1239         SafeERC20.safeTransfer(token, account, payment);
1240         emit ERC20PaymentReleased(token, account, payment);
1241     }
1242 
1243     /**
1244      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1245      * already released amounts.
1246      */
1247     function _pendingPayment(
1248         address account,
1249         uint256 totalReceived,
1250         uint256 alreadyReleased
1251     ) private view returns (uint256) {
1252         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1253     }
1254 
1255     /**
1256      * @dev Add a new payee to the contract.
1257      * @param account The address of the payee to add.
1258      * @param shares_ The number of shares owned by the payee.
1259      */
1260     function _addPayee(address account, uint256 shares_) private {
1261         require(account != address(0), "PaymentSplitter: account is the zero address");
1262         require(shares_ > 0, "PaymentSplitter: shares are 0");
1263         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1264 
1265         _payees.push(account);
1266         _shares[account] = shares_;
1267         _totalShares = _totalShares + shares_;
1268         emit PayeeAdded(account, shares_);
1269     }
1270 }
1271 
1272 /**
1273  * @dev Interface of ERC721 token receiver.
1274  */
1275 interface ERC721A__IERC721Receiver {
1276     function onERC721Received(
1277         address operator,
1278         address from,
1279         uint256 tokenId,
1280         bytes calldata data
1281     ) external returns (bytes4);
1282 }
1283 
1284 /**
1285  * @title ERC721A
1286  *
1287  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1288  * Non-Fungible Token Standard, including the Metadata extension.
1289  * Optimized for lower gas during batch mints.
1290  *
1291  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1292  * starting from `_startTokenId()`.
1293  *
1294  * Assumptions:
1295  *
1296  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1297  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1298  */
1299 contract ERC721A is IERC721A {
1300     // Reference type for token approval.
1301     struct TokenApprovalRef {
1302         address value;
1303     }
1304 
1305     // =============================================================
1306     //                           CONSTANTS
1307     // =============================================================
1308 
1309     // Mask of an entry in packed address data.
1310     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1311 
1312     // The bit position of `numberMinted` in packed address data.
1313     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1314 
1315     // The bit position of `numberBurned` in packed address data.
1316     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1317 
1318     // The bit position of `aux` in packed address data.
1319     uint256 private constant _BITPOS_AUX = 192;
1320 
1321     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1322     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1323 
1324     // The bit position of `startTimestamp` in packed ownership.
1325     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1326 
1327     // The bit mask of the `burned` bit in packed ownership.
1328     uint256 private constant _BITMASK_BURNED = 1 << 224;
1329 
1330     // The bit position of the `nextInitialized` bit in packed ownership.
1331     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1332 
1333     // The bit mask of the `nextInitialized` bit in packed ownership.
1334     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1335 
1336     // The bit position of `extraData` in packed ownership.
1337     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1338 
1339     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1340     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1341 
1342     // The mask of the lower 160 bits for addresses.
1343     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1344 
1345     // The maximum `quantity` that can be minted with {_mintERC2309}.
1346     // This limit is to prevent overflows on the address data entries.
1347     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1348     // is required to cause an overflow, which is unrealistic.
1349     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1350 
1351     // The `Transfer` event signature is given by:
1352     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1353     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1354         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1355 
1356     // =============================================================
1357     //                            STORAGE
1358     // =============================================================
1359 
1360     // The next token ID to be minted.
1361     uint256 private _currentIndex;
1362 
1363     // The number of tokens burned.
1364     uint256 private _burnCounter;
1365 
1366     // Token name
1367     string private _name;
1368 
1369     // Token symbol
1370     string private _symbol;
1371 
1372     // Mapping from token ID to ownership details
1373     // An empty struct value does not necessarily mean the token is unowned.
1374     // See {_packedOwnershipOf} implementation for details.
1375     //
1376     // Bits Layout:
1377     // - [0..159]   `addr`
1378     // - [160..223] `startTimestamp`
1379     // - [224]      `burned`
1380     // - [225]      `nextInitialized`
1381     // - [232..255] `extraData`
1382     mapping(uint256 => uint256) private _packedOwnerships;
1383 
1384     // Mapping owner address to address data.
1385     //
1386     // Bits Layout:
1387     // - [0..63]    `balance`
1388     // - [64..127]  `numberMinted`
1389     // - [128..191] `numberBurned`
1390     // - [192..255] `aux`
1391     mapping(address => uint256) private _packedAddressData;
1392 
1393     // Mapping from token ID to approved address.
1394     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1395 
1396     // Mapping from owner to operator approvals
1397     mapping(address => mapping(address => bool)) private _operatorApprovals;
1398 
1399     // =============================================================
1400     //                          CONSTRUCTOR
1401     // =============================================================
1402 
1403     constructor(string memory name_, string memory symbol_) {
1404         _name = name_;
1405         _symbol = symbol_;
1406         _currentIndex = _startTokenId();
1407     }
1408 
1409     // =============================================================
1410     //                   TOKEN COUNTING OPERATIONS
1411     // =============================================================
1412 
1413     /**
1414      * @dev Returns the starting token ID.
1415      * To change the starting token ID, please override this function.
1416      */
1417     function _startTokenId() internal view virtual returns (uint256) {
1418         return 0;
1419     }
1420 
1421     /**
1422      * @dev Returns the next token ID to be minted.
1423      */
1424     function _nextTokenId() internal view virtual returns (uint256) {
1425         return _currentIndex;
1426     }
1427 
1428     /**
1429      * @dev Returns the total number of tokens in existence.
1430      * Burned tokens will reduce the count.
1431      * To get the total number of tokens minted, please see {_totalMinted}.
1432      */
1433     function totalSupply() public view virtual override returns (uint256) {
1434         // Counter underflow is impossible as _burnCounter cannot be incremented
1435         // more than `_currentIndex - _startTokenId()` times.
1436         unchecked {
1437             return _currentIndex - _burnCounter - _startTokenId();
1438         }
1439     }
1440 
1441     /**
1442      * @dev Returns the total amount of tokens minted in the contract.
1443      */
1444     function _totalMinted() internal view virtual returns (uint256) {
1445         // Counter underflow is impossible as `_currentIndex` does not decrement,
1446         // and it is initialized to `_startTokenId()`.
1447         unchecked {
1448             return _currentIndex - _startTokenId();
1449         }
1450     }
1451 
1452     /**
1453      * @dev Returns the total number of tokens burned.
1454      */
1455     function _totalBurned() internal view virtual returns (uint256) {
1456         return _burnCounter;
1457     }
1458 
1459     // =============================================================
1460     //                    ADDRESS DATA OPERATIONS
1461     // =============================================================
1462 
1463     /**
1464      * @dev Returns the number of tokens in `owner`'s account.
1465      */
1466     function balanceOf(address owner) public view virtual override returns (uint256) {
1467         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1468         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1469     }
1470 
1471     /**
1472      * Returns the number of tokens minted by `owner`.
1473      */
1474     function _numberMinted(address owner) internal view returns (uint256) {
1475         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1476     }
1477 
1478     /**
1479      * Returns the number of tokens burned by or on behalf of `owner`.
1480      */
1481     function _numberBurned(address owner) internal view returns (uint256) {
1482         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1483     }
1484 
1485     /**
1486      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1487      */
1488     function _getAux(address owner) internal view returns (uint64) {
1489         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1490     }
1491 
1492     /**
1493      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1494      * If there are multiple variables, please pack them into a uint64.
1495      */
1496     function _setAux(address owner, uint64 aux) internal virtual {
1497         uint256 packed = _packedAddressData[owner];
1498         uint256 auxCasted;
1499         // Cast `aux` with assembly to avoid redundant masking.
1500         assembly {
1501             auxCasted := aux
1502         }
1503         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1504         _packedAddressData[owner] = packed;
1505     }
1506 
1507     // =============================================================
1508     //                            IERC165
1509     // =============================================================
1510 
1511     /**
1512      * @dev Returns true if this contract implements the interface defined by
1513      * `interfaceId`. See the corresponding
1514      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1515      * to learn more about how these ids are created.
1516      *
1517      * This function call must use less than 30000 gas.
1518      */
1519     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1520         // The interface IDs are constants representing the first 4 bytes
1521         // of the XOR of all function selectors in the interface.
1522         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1523         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1524         return
1525             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1526             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1527             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1528     }
1529 
1530     // =============================================================
1531     //                        IERC721Metadata
1532     // =============================================================
1533 
1534     /**
1535      * @dev Returns the token collection name.
1536      */
1537     function name() public view virtual override returns (string memory) {
1538         return _name;
1539     }
1540 
1541     /**
1542      * @dev Returns the token collection symbol.
1543      */
1544     function symbol() public view virtual override returns (string memory) {
1545         return _symbol;
1546     }
1547 
1548     /**
1549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1550      */
1551     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1552         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1553 
1554         string memory baseURI = _baseURI();
1555         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1556     }
1557 
1558     /**
1559      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1560      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1561      * by default, it can be overridden in child contracts.
1562      */
1563     function _baseURI() internal view virtual returns (string memory) {
1564         return '';
1565     }
1566 
1567     // =============================================================
1568     //                     OWNERSHIPS OPERATIONS
1569     // =============================================================
1570 
1571     /**
1572      * @dev Returns the owner of the `tokenId` token.
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must exist.
1577      */
1578     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1579         return address(uint160(_packedOwnershipOf(tokenId)));
1580     }
1581 
1582     /**
1583      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1584      * It gradually moves to O(1) as tokens get transferred around over time.
1585      */
1586     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1587         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1588     }
1589 
1590     /**
1591      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1592      */
1593     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1594         return _unpackedOwnership(_packedOwnerships[index]);
1595     }
1596 
1597     /**
1598      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1599      */
1600     function _initializeOwnershipAt(uint256 index) internal virtual {
1601         if (_packedOwnerships[index] == 0) {
1602             _packedOwnerships[index] = _packedOwnershipOf(index);
1603         }
1604     }
1605 
1606     /**
1607      * Returns the packed ownership data of `tokenId`.
1608      */
1609     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1610         uint256 curr = tokenId;
1611 
1612         unchecked {
1613             if (_startTokenId() <= curr)
1614                 if (curr < _currentIndex) {
1615                     uint256 packed = _packedOwnerships[curr];
1616                     // If not burned.
1617                     if (packed & _BITMASK_BURNED == 0) {
1618                         // Invariant:
1619                         // There will always be an initialized ownership slot
1620                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1621                         // before an unintialized ownership slot
1622                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1623                         // Hence, `curr` will not underflow.
1624                         //
1625                         // We can directly compare the packed value.
1626                         // If the address is zero, packed will be zero.
1627                         while (packed == 0) {
1628                             packed = _packedOwnerships[--curr];
1629                         }
1630                         return packed;
1631                     }
1632                 }
1633         }
1634         revert OwnerQueryForNonexistentToken();
1635     }
1636 
1637     /**
1638      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1639      */
1640     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1641         ownership.addr = address(uint160(packed));
1642         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1643         ownership.burned = packed & _BITMASK_BURNED != 0;
1644         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1645     }
1646 
1647     /**
1648      * @dev Packs ownership data into a single uint256.
1649      */
1650     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1651         assembly {
1652             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1653             owner := and(owner, _BITMASK_ADDRESS)
1654             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1655             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1656         }
1657     }
1658 
1659     /**
1660      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1661      */
1662     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1663         // For branchless setting of the `nextInitialized` flag.
1664         assembly {
1665             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1666             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1667         }
1668     }
1669 
1670     // =============================================================
1671     //                      APPROVAL OPERATIONS
1672     // =============================================================
1673 
1674     /**
1675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1676      * The approval is cleared when the token is transferred.
1677      *
1678      * Only a single account can be approved at a time, so approving the
1679      * zero address clears previous approvals.
1680      *
1681      * Requirements:
1682      *
1683      * - The caller must own the token or be an approved operator.
1684      * - `tokenId` must exist.
1685      *
1686      * Emits an {Approval} event.
1687      */
1688     function approve(address to, uint256 tokenId) public virtual override {
1689         address owner = ownerOf(tokenId);
1690 
1691         if (_msgSenderERC721A() != owner)
1692             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1693                 revert ApprovalCallerNotOwnerNorApproved();
1694             }
1695 
1696         _tokenApprovals[tokenId].value = to;
1697         emit Approval(owner, to, tokenId);
1698     }
1699 
1700     /**
1701      * @dev Returns the account approved for `tokenId` token.
1702      *
1703      * Requirements:
1704      *
1705      * - `tokenId` must exist.
1706      */
1707     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1708         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1709 
1710         return _tokenApprovals[tokenId].value;
1711     }
1712 
1713     /**
1714      * @dev Approve or remove `operator` as an operator for the caller.
1715      * Operators can call {transferFrom} or {safeTransferFrom}
1716      * for any token owned by the caller.
1717      *
1718      * Requirements:
1719      *
1720      * - The `operator` cannot be the caller.
1721      *
1722      * Emits an {ApprovalForAll} event.
1723      */
1724     function setApprovalForAll(address operator, bool approved) public virtual override {
1725         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1726 
1727         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1728         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1729     }
1730 
1731     /**
1732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1733      *
1734      * See {setApprovalForAll}.
1735      */
1736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1737         return _operatorApprovals[owner][operator];
1738     }
1739 
1740     /**
1741      * @dev Returns whether `tokenId` exists.
1742      *
1743      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1744      *
1745      * Tokens start existing when they are minted. See {_mint}.
1746      */
1747     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1748         return
1749             _startTokenId() <= tokenId &&
1750             tokenId < _currentIndex && // If within bounds,
1751             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1752     }
1753 
1754     /**
1755      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1756      */
1757     function _isSenderApprovedOrOwner(
1758         address approvedAddress,
1759         address owner,
1760         address msgSender
1761     ) private pure returns (bool result) {
1762         assembly {
1763             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1764             owner := and(owner, _BITMASK_ADDRESS)
1765             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1766             msgSender := and(msgSender, _BITMASK_ADDRESS)
1767             // `msgSender == owner || msgSender == approvedAddress`.
1768             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1769         }
1770     }
1771 
1772     /**
1773      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1774      */
1775     function _getApprovedSlotAndAddress(uint256 tokenId)
1776         private
1777         view
1778         returns (uint256 approvedAddressSlot, address approvedAddress)
1779     {
1780         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1781         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1782         assembly {
1783             approvedAddressSlot := tokenApproval.slot
1784             approvedAddress := sload(approvedAddressSlot)
1785         }
1786     }
1787 
1788     // =============================================================
1789     //                      TRANSFER OPERATIONS
1790     // =============================================================
1791 
1792     /**
1793      * @dev Transfers `tokenId` from `from` to `to`.
1794      *
1795      * Requirements:
1796      *
1797      * - `from` cannot be the zero address.
1798      * - `to` cannot be the zero address.
1799      * - `tokenId` token must be owned by `from`.
1800      * - If the caller is not `from`, it must be approved to move this token
1801      * by either {approve} or {setApprovalForAll}.
1802      *
1803      * Emits a {Transfer} event.
1804      */
1805     function transferFrom(
1806         address from,
1807         address to,
1808         uint256 tokenId
1809     ) public virtual override {
1810         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1811 
1812         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1813 
1814         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1815 
1816         // The nested ifs save around 20+ gas over a compound boolean condition.
1817         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1818             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1819 
1820         if (to == address(0)) revert TransferToZeroAddress();
1821 
1822         _beforeTokenTransfers(from, to, tokenId, 1);
1823 
1824         // Clear approvals from the previous owner.
1825         assembly {
1826             if approvedAddress {
1827                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1828                 sstore(approvedAddressSlot, 0)
1829             }
1830         }
1831 
1832         // Underflow of the sender's balance is impossible because we check for
1833         // ownership above and the recipient's balance can't realistically overflow.
1834         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1835         unchecked {
1836             // We can directly increment and decrement the balances.
1837             --_packedAddressData[from]; // Updates: `balance -= 1`.
1838             ++_packedAddressData[to]; // Updates: `balance += 1`.
1839 
1840             // Updates:
1841             // - `address` to the next owner.
1842             // - `startTimestamp` to the timestamp of transfering.
1843             // - `burned` to `false`.
1844             // - `nextInitialized` to `true`.
1845             _packedOwnerships[tokenId] = _packOwnershipData(
1846                 to,
1847                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1848             );
1849 
1850             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1851             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1852                 uint256 nextTokenId = tokenId + 1;
1853                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1854                 if (_packedOwnerships[nextTokenId] == 0) {
1855                     // If the next slot is within bounds.
1856                     if (nextTokenId != _currentIndex) {
1857                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1858                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1859                     }
1860                 }
1861             }
1862         }
1863 
1864         emit Transfer(from, to, tokenId);
1865         _afterTokenTransfers(from, to, tokenId, 1);
1866     }
1867 
1868     /**
1869      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1870      */
1871     function safeTransferFrom(
1872         address from,
1873         address to,
1874         uint256 tokenId
1875     ) public virtual override {
1876         safeTransferFrom(from, to, tokenId, '');
1877     }
1878 
1879     /**
1880      * @dev Safely transfers `tokenId` token from `from` to `to`.
1881      *
1882      * Requirements:
1883      *
1884      * - `from` cannot be the zero address.
1885      * - `to` cannot be the zero address.
1886      * - `tokenId` token must exist and be owned by `from`.
1887      * - If the caller is not `from`, it must be approved to move this token
1888      * by either {approve} or {setApprovalForAll}.
1889      * - If `to` refers to a smart contract, it must implement
1890      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1891      *
1892      * Emits a {Transfer} event.
1893      */
1894     function safeTransferFrom(
1895         address from,
1896         address to,
1897         uint256 tokenId,
1898         bytes memory _data
1899     ) public virtual override {
1900         transferFrom(from, to, tokenId);
1901         if (to.code.length != 0)
1902             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1903                 revert TransferToNonERC721ReceiverImplementer();
1904             }
1905     }
1906 
1907     /**
1908      * @dev Hook that is called before a set of serially-ordered token IDs
1909      * are about to be transferred. This includes minting.
1910      * And also called before burning one token.
1911      *
1912      * `startTokenId` - the first token ID to be transferred.
1913      * `quantity` - the amount to be transferred.
1914      *
1915      * Calling conditions:
1916      *
1917      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1918      * transferred to `to`.
1919      * - When `from` is zero, `tokenId` will be minted for `to`.
1920      * - When `to` is zero, `tokenId` will be burned by `from`.
1921      * - `from` and `to` are never both zero.
1922      */
1923     function _beforeTokenTransfers(
1924         address from,
1925         address to,
1926         uint256 startTokenId,
1927         uint256 quantity
1928     ) internal virtual {}
1929 
1930     /**
1931      * @dev Hook that is called after a set of serially-ordered token IDs
1932      * have been transferred. This includes minting.
1933      * And also called after one token has been burned.
1934      *
1935      * `startTokenId` - the first token ID to be transferred.
1936      * `quantity` - the amount to be transferred.
1937      *
1938      * Calling conditions:
1939      *
1940      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1941      * transferred to `to`.
1942      * - When `from` is zero, `tokenId` has been minted for `to`.
1943      * - When `to` is zero, `tokenId` has been burned by `from`.
1944      * - `from` and `to` are never both zero.
1945      */
1946     function _afterTokenTransfers(
1947         address from,
1948         address to,
1949         uint256 startTokenId,
1950         uint256 quantity
1951     ) internal virtual {}
1952 
1953     /**
1954      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1955      *
1956      * `from` - Previous owner of the given token ID.
1957      * `to` - Target address that will receive the token.
1958      * `tokenId` - Token ID to be transferred.
1959      * `_data` - Optional data to send along with the call.
1960      *
1961      * Returns whether the call correctly returned the expected magic value.
1962      */
1963     function _checkContractOnERC721Received(
1964         address from,
1965         address to,
1966         uint256 tokenId,
1967         bytes memory _data
1968     ) private returns (bool) {
1969         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1970             bytes4 retval
1971         ) {
1972             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1973         } catch (bytes memory reason) {
1974             if (reason.length == 0) {
1975                 revert TransferToNonERC721ReceiverImplementer();
1976             } else {
1977                 assembly {
1978                     revert(add(32, reason), mload(reason))
1979                 }
1980             }
1981         }
1982     }
1983 
1984     // =============================================================
1985     //                        MINT OPERATIONS
1986     // =============================================================
1987 
1988     /**
1989      * @dev Mints `quantity` tokens and transfers them to `to`.
1990      *
1991      * Requirements:
1992      *
1993      * - `to` cannot be the zero address.
1994      * - `quantity` must be greater than 0.
1995      *
1996      * Emits a {Transfer} event for each mint.
1997      */
1998     function _mint(address to, uint256 quantity) internal virtual {
1999         uint256 startTokenId = _currentIndex;
2000         if (quantity == 0) revert MintZeroQuantity();
2001 
2002         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2003 
2004         // Overflows are incredibly unrealistic.
2005         // `balance` and `numberMinted` have a maximum limit of 2**64.
2006         // `tokenId` has a maximum limit of 2**256.
2007         unchecked {
2008             // Updates:
2009             // - `balance += quantity`.
2010             // - `numberMinted += quantity`.
2011             //
2012             // We can directly add to the `balance` and `numberMinted`.
2013             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2014 
2015             // Updates:
2016             // - `address` to the owner.
2017             // - `startTimestamp` to the timestamp of minting.
2018             // - `burned` to `false`.
2019             // - `nextInitialized` to `quantity == 1`.
2020             _packedOwnerships[startTokenId] = _packOwnershipData(
2021                 to,
2022                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2023             );
2024 
2025             uint256 toMasked;
2026             uint256 end = startTokenId + quantity;
2027 
2028             // Use assembly to loop and emit the `Transfer` event for gas savings.
2029             assembly {
2030                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2031                 toMasked := and(to, _BITMASK_ADDRESS)
2032                 // Emit the `Transfer` event.
2033                 log4(
2034                     0, // Start of data (0, since no data).
2035                     0, // End of data (0, since no data).
2036                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2037                     0, // `address(0)`.
2038                     toMasked, // `to`.
2039                     startTokenId // `tokenId`.
2040                 )
2041 
2042                 for {
2043                     let tokenId := add(startTokenId, 1)
2044                 } iszero(eq(tokenId, end)) {
2045                     tokenId := add(tokenId, 1)
2046                 } {
2047                     // Emit the `Transfer` event. Similar to above.
2048                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2049                 }
2050             }
2051             if (toMasked == 0) revert MintToZeroAddress();
2052 
2053             _currentIndex = end;
2054         }
2055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2056     }
2057 
2058     /**
2059      * @dev Mints `quantity` tokens and transfers them to `to`.
2060      *
2061      * This function is intended for efficient minting only during contract creation.
2062      *
2063      * It emits only one {ConsecutiveTransfer} as defined in
2064      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2065      * instead of a sequence of {Transfer} event(s).
2066      *
2067      * Calling this function outside of contract creation WILL make your contract
2068      * non-compliant with the ERC721 standard.
2069      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2070      * {ConsecutiveTransfer} event is only permissible during contract creation.
2071      *
2072      * Requirements:
2073      *
2074      * - `to` cannot be the zero address.
2075      * - `quantity` must be greater than 0.
2076      *
2077      * Emits a {ConsecutiveTransfer} event.
2078      */
2079     function _mintERC2309(address to, uint256 quantity) internal virtual {
2080         uint256 startTokenId = _currentIndex;
2081         if (to == address(0)) revert MintToZeroAddress();
2082         if (quantity == 0) revert MintZeroQuantity();
2083         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2084 
2085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2086 
2087         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2088         unchecked {
2089             // Updates:
2090             // - `balance += quantity`.
2091             // - `numberMinted += quantity`.
2092             //
2093             // We can directly add to the `balance` and `numberMinted`.
2094             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2095 
2096             // Updates:
2097             // - `address` to the owner.
2098             // - `startTimestamp` to the timestamp of minting.
2099             // - `burned` to `false`.
2100             // - `nextInitialized` to `quantity == 1`.
2101             _packedOwnerships[startTokenId] = _packOwnershipData(
2102                 to,
2103                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2104             );
2105 
2106             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2107 
2108             _currentIndex = startTokenId + quantity;
2109         }
2110         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2111     }
2112 
2113     /**
2114      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2115      *
2116      * Requirements:
2117      *
2118      * - If `to` refers to a smart contract, it must implement
2119      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2120      * - `quantity` must be greater than 0.
2121      *
2122      * See {_mint}.
2123      *
2124      * Emits a {Transfer} event for each mint.
2125      */
2126     function _safeMint(
2127         address to,
2128         uint256 quantity,
2129         bytes memory _data
2130     ) internal virtual {
2131         _mint(to, quantity);
2132 
2133         unchecked {
2134             if (to.code.length != 0) {
2135                 uint256 end = _currentIndex;
2136                 uint256 index = end - quantity;
2137                 do {
2138                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2139                         revert TransferToNonERC721ReceiverImplementer();
2140                     }
2141                 } while (index < end);
2142                 // Reentrancy protection.
2143                 if (_currentIndex != end) revert();
2144             }
2145         }
2146     }
2147 
2148     /**
2149      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2150      */
2151     function _safeMint(address to, uint256 quantity) internal virtual {
2152         _safeMint(to, quantity, '');
2153     }
2154 
2155     // =============================================================
2156     //                        BURN OPERATIONS
2157     // =============================================================
2158 
2159     /**
2160      * @dev Equivalent to `_burn(tokenId, false)`.
2161      */
2162     function _burn(uint256 tokenId) internal virtual {
2163         _burn(tokenId, false);
2164     }
2165 
2166     /**
2167      * @dev Destroys `tokenId`.
2168      * The approval is cleared when the token is burned.
2169      *
2170      * Requirements:
2171      *
2172      * - `tokenId` must exist.
2173      *
2174      * Emits a {Transfer} event.
2175      */
2176     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2177         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2178 
2179         address from = address(uint160(prevOwnershipPacked));
2180 
2181         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2182 
2183         if (approvalCheck) {
2184             // The nested ifs save around 20+ gas over a compound boolean condition.
2185             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2186                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2187         }
2188 
2189         _beforeTokenTransfers(from, address(0), tokenId, 1);
2190 
2191         // Clear approvals from the previous owner.
2192         assembly {
2193             if approvedAddress {
2194                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2195                 sstore(approvedAddressSlot, 0)
2196             }
2197         }
2198 
2199         // Underflow of the sender's balance is impossible because we check for
2200         // ownership above and the recipient's balance can't realistically overflow.
2201         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2202         unchecked {
2203             // Updates:
2204             // - `balance -= 1`.
2205             // - `numberBurned += 1`.
2206             //
2207             // We can directly decrement the balance, and increment the number burned.
2208             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2209             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2210 
2211             // Updates:
2212             // - `address` to the last owner.
2213             // - `startTimestamp` to the timestamp of burning.
2214             // - `burned` to `true`.
2215             // - `nextInitialized` to `true`.
2216             _packedOwnerships[tokenId] = _packOwnershipData(
2217                 from,
2218                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2219             );
2220 
2221             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2222             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2223                 uint256 nextTokenId = tokenId + 1;
2224                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2225                 if (_packedOwnerships[nextTokenId] == 0) {
2226                     // If the next slot is within bounds.
2227                     if (nextTokenId != _currentIndex) {
2228                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2229                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2230                     }
2231                 }
2232             }
2233         }
2234 
2235         emit Transfer(from, address(0), tokenId);
2236         _afterTokenTransfers(from, address(0), tokenId, 1);
2237 
2238         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2239         unchecked {
2240             _burnCounter++;
2241         }
2242     }
2243 
2244     // =============================================================
2245     //                     EXTRA DATA OPERATIONS
2246     // =============================================================
2247 
2248     /**
2249      * @dev Directly sets the extra data for the ownership data `index`.
2250      */
2251     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2252         uint256 packed = _packedOwnerships[index];
2253         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2254         uint256 extraDataCasted;
2255         // Cast `extraData` with assembly to avoid redundant masking.
2256         assembly {
2257             extraDataCasted := extraData
2258         }
2259         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2260         _packedOwnerships[index] = packed;
2261     }
2262 
2263     /**
2264      * @dev Called during each token transfer to set the 24bit `extraData` field.
2265      * Intended to be overridden by the cosumer contract.
2266      *
2267      * `previousExtraData` - the value of `extraData` before transfer.
2268      *
2269      * Calling conditions:
2270      *
2271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2272      * transferred to `to`.
2273      * - When `from` is zero, `tokenId` will be minted for `to`.
2274      * - When `to` is zero, `tokenId` will be burned by `from`.
2275      * - `from` and `to` are never both zero.
2276      */
2277     function _extraData(
2278         address from,
2279         address to,
2280         uint24 previousExtraData
2281     ) internal view virtual returns (uint24) {}
2282 
2283     /**
2284      * @dev Returns the next extra data for the packed ownership data.
2285      * The returned result is shifted into position.
2286      */
2287     function _nextExtraData(
2288         address from,
2289         address to,
2290         uint256 prevOwnershipPacked
2291     ) private view returns (uint256) {
2292         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2293         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2294     }
2295 
2296     // =============================================================
2297     //                       OTHER OPERATIONS
2298     // =============================================================
2299 
2300     /**
2301      * @dev Returns the message sender (defaults to `msg.sender`).
2302      *
2303      * If you are writing GSN compatible contracts, you need to override this function.
2304      */
2305     function _msgSenderERC721A() internal view virtual returns (address) {
2306         return msg.sender;
2307     }
2308 
2309     /**
2310      * @dev Converts a uint256 to its ASCII string decimal representation.
2311      */
2312     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2313         assembly {
2314             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2315             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2316             // We will need 1 32-byte word to store the length,
2317             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2318             ptr := add(mload(0x40), 128)
2319             // Update the free memory pointer to allocate.
2320             mstore(0x40, ptr)
2321 
2322             // Cache the end of the memory to calculate the length later.
2323             let end := ptr
2324 
2325             // We write the string from the rightmost digit to the leftmost digit.
2326             // The following is essentially a do-while loop that also handles the zero case.
2327             // Costs a bit more than early returning for the zero case,
2328             // but cheaper in terms of deployment and overall runtime costs.
2329             for {
2330                 // Initialize and perform the first pass without check.
2331                 let temp := value
2332                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2333                 ptr := sub(ptr, 1)
2334                 // Write the character to the pointer.
2335                 // The ASCII index of the '0' character is 48.
2336                 mstore8(ptr, add(48, mod(temp, 10)))
2337                 temp := div(temp, 10)
2338             } temp {
2339                 // Keep dividing `temp` until zero.
2340                 temp := div(temp, 10)
2341             } {
2342                 // Body of the for loop.
2343                 ptr := sub(ptr, 1)
2344                 mstore8(ptr, add(48, mod(temp, 10)))
2345             }
2346 
2347             let length := sub(end, ptr)
2348             // Move the pointer 32 bytes leftwards to make room for the length.
2349             ptr := sub(ptr, 32)
2350             // Store the length.
2351             mstore(ptr, length)
2352         }
2353     }
2354 }
2355 
2356 contract Mooncatz is Ownable, ERC721A, PaymentSplitter {
2357 
2358     using ECDSA for bytes32;
2359     using Strings for uint;
2360 
2361     address private signerAddressVIP;
2362     address private signerAddressWL;
2363 
2364     enum Step {
2365         Before,
2366         VIPSale,
2367         WhitelistSale,
2368         PublicSale,
2369         SoldOut,
2370         Reveal
2371     }
2372 
2373     string public baseURI;
2374 
2375     Step public sellingStep;
2376 
2377     uint private constant MAX_SUPPLY = 5555;
2378     uint private constant MAX_WHITELIST = 4437;
2379     uint private constant MAX_VIP = 1111;
2380 
2381     uint public wlSalePrice = 0.0069 ether;
2382 
2383     mapping(address => uint) public mintedAmountNFTsperWalletWhitelistSale;
2384     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
2385     // Use _numberMinted for VIPs
2386 
2387     uint public maxMintAmountPerVIP = 1;
2388     uint public maxMintAmountPerWhitelist = 1; 
2389     uint public maxMintAmountPerPublic = 1; 
2390 
2391     uint private teamLength;
2392 
2393     constructor(address[] memory _team, uint[] memory _teamShares, address _signerAddressVIP, address _signerAddressWL, string memory _baseURI) ERC721A("Mooncatz", "MOON")
2394     PaymentSplitter(_team, _teamShares) {
2395         signerAddressVIP = _signerAddressVIP;
2396         signerAddressWL = _signerAddressWL;
2397         baseURI = _baseURI;
2398         teamLength = _team.length;
2399     }
2400 
2401     function changeVIPSignerAddress(address newSigner) external onlyOwner{
2402         signerAddressVIP = newSigner;
2403     }
2404 
2405     function changeWLSignerAddress(address newSigner) external onlyOwner{
2406         signerAddressWL = newSigner;
2407     }
2408 
2409     function mintForOpensea() external onlyOwner{
2410         if(totalSupply() != 0) revert("Only one mint for deployer");
2411         _mint(msg.sender, 1);
2412     }
2413 
2414     function VIPMint(address _account, uint _quantity, bytes calldata signature) external {
2415         if(sellingStep != Step.VIPSale) revert("VIP Mint is not open");
2416         if(totalSupply() + _quantity > MAX_VIP) revert("Max supply for VIP exceeded");
2417         if(signerAddressVIP != keccak256(
2418             abi.encodePacked(
2419                 "\x19Ethereum Signed Message:\n32",
2420                 bytes32(uint256(uint160(msg.sender)))
2421             )
2422         ).recover(signature)) revert("You are not in VIP whitelist");
2423         if(_numberMinted(msg.sender) + _quantity > maxMintAmountPerVIP) revert("Over max amount of nft minted for VIP");
2424         
2425         // The _numberMinted is incremented internally
2426         _mint(_account, _quantity);
2427     }
2428 
2429     function publicSaleMint(address _account, uint _quantity) external payable {
2430         uint price = wlSalePrice;
2431         if(price <= 0) revert("Price is 0");
2432 
2433         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2434         if(totalSupply() + _quantity > MAX_SUPPLY) revert("Max supply exceeded");
2435         if(msg.value < price * _quantity) revert("Not enough funds");   
2436         if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("You can only get 1 NFT on the Public Sale");
2437         // Add check if already minted in wl or VIP
2438 
2439         if(_numberMinted(msg.sender) != 0) revert("User has minted in VIP or WL stage already");
2440 
2441         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
2442         _mint(_account, _quantity);
2443     }
2444 
2445     function WLMint(address _account, uint _quantity, bytes calldata signature) external payable {
2446         uint price = wlSalePrice;
2447         if(price <= 0) revert("Price is 0");
2448 
2449         if(sellingStep != Step.WhitelistSale) revert("WL Mint not live.");
2450         if(totalSupply() + _quantity > MAX_SUPPLY) revert("Max supply exceeded");
2451         if(signerAddressVIP == keccak256(
2452             abi.encodePacked(
2453                 "\x19Ethereum Signed Message:\n32",
2454                 bytes32(uint256(uint160(msg.sender)))
2455             )
2456         ).recover(signature)){
2457             if(_numberMinted(msg.sender) != 0) revert("User has mint in VIP stage already");
2458         }
2459         if(msg.value < price * _quantity) revert("Not enough funds");          
2460         if(signerAddressWL != keccak256(
2461             abi.encodePacked(
2462                 "\x19Ethereum Signed Message:\n32",
2463                 bytes32(uint256(uint160(msg.sender)))
2464             )
2465         ).recover(signature)) revert("You are not in WL whitelist");
2466         if(mintedAmountNFTsperWalletWhitelistSale[msg.sender] + _quantity > maxMintAmountPerWhitelist) revert("You can only get 1 NFT on the Whitelist Sale");
2467             
2468         mintedAmountNFTsperWalletWhitelistSale[msg.sender] += _quantity;
2469         _mint(_account, _quantity);
2470     }
2471 
2472     function setBaseUri(string memory _baseURI) external onlyOwner {
2473         baseURI = _baseURI;
2474     }
2475 
2476     function setStep(uint _step) external onlyOwner {
2477         sellingStep = Step(_step);
2478     }
2479 
2480     function setMaxMintPerVIP(uint amount) external onlyOwner {
2481         maxMintAmountPerVIP = amount;
2482     }
2483 
2484     function setMaxMintPerWhitelist(uint amount) external onlyOwner{
2485         maxMintAmountPerWhitelist = amount;
2486     }
2487 
2488     function setMaxMintPerPublic(uint amount) external onlyOwner{
2489         maxMintAmountPerPublic = amount;
2490     }
2491 
2492     function testSignerRecovery(bytes calldata signature) external view returns (address) {
2493         return keccak256(
2494             abi.encodePacked(
2495                 "\x19Ethereum Signed Message:\n32",
2496                 bytes32(uint256(uint160(msg.sender)))
2497             )
2498         ).recover(signature);
2499     }
2500 
2501     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2502         require(_exists(_tokenId), "URI query for nonexistent token");
2503         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2504     }
2505 
2506     function releaseAll() external {
2507         for(uint i = 0 ; i < teamLength ; i++) {
2508             release(payable(payee(i)));
2509         }
2510     }
2511 }