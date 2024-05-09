1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*                                       
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      *
25      * [IMPORTANT]
26      * ====
27      * You shouldn't rely on `isContract` to protect against flash loan attacks!
28      *
29      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
30      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
31      * constructor.
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize/address.code.length, which returns 0
36         // for contracts in construction, since the code is only stored at the end
37         // of the constructor execution.
38 
39         return account.code.length > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210                 /// @solidity memory-safe-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 interface IERC721A {
233     /**
234      * The caller must own the token or be an approved operator.
235      */
236     error ApprovalCallerNotOwnerNorApproved();
237 
238     /**
239      * The token does not exist.
240      */
241     error ApprovalQueryForNonexistentToken();
242 
243     /**
244      * The caller cannot approve to their own address.
245      */
246     error ApproveToCaller();
247 
248     /**
249      * Cannot query the balance for the zero address.
250      */
251     error BalanceQueryForZeroAddress();
252 
253     /**
254      * Cannot mint to the zero address.
255      */
256     error MintToZeroAddress();
257 
258     /**
259      * The quantity of tokens minted must be more than zero.
260      */
261     error MintZeroQuantity();
262 
263     /**
264      * The token does not exist.
265      */
266     error OwnerQueryForNonexistentToken();
267 
268     /**
269      * The caller must own the token or be an approved operator.
270      */
271     error TransferCallerNotOwnerNorApproved();
272 
273     /**
274      * The token must be owned by `from`.
275      */
276     error TransferFromIncorrectOwner();
277 
278     /**
279      * Cannot safely transfer to a contract that does not implement the
280      * ERC721Receiver interface.
281      */
282     error TransferToNonERC721ReceiverImplementer();
283 
284     /**
285      * Cannot transfer to the zero address.
286      */
287     error TransferToZeroAddress();
288 
289     /**
290      * The token does not exist.
291      */
292     error URIQueryForNonexistentToken();
293 
294     /**
295      * The `quantity` minted with ERC2309 exceeds the safety limit.
296      */
297     error MintERC2309QuantityExceedsLimit();
298 
299     /**
300      * The `extraData` cannot be set on an unintialized ownership slot.
301      */
302     error OwnershipNotInitializedForExtraData();
303 
304     // =============================================================
305     //                            STRUCTS
306     // =============================================================
307 
308     struct TokenOwnership {
309         // The address of the owner.
310         address addr;
311         // Stores the start time of ownership with minimal overhead for tokenomics.
312         uint64 startTimestamp;
313         // Whether the token has been burned.
314         bool burned;
315         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
316         uint24 extraData;
317     }
318 
319     // =============================================================
320     //                         TOKEN COUNTERS
321     // =============================================================
322 
323     /**
324      * @dev Returns the total number of tokens in existence.
325      * Burned tokens will reduce the count.
326      * To get the total number of tokens minted, please see {_totalMinted}.
327      */
328     function totalSupply() external view returns (uint256);
329 
330     // =============================================================
331     //                            IERC165
332     // =============================================================
333 
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 
344     // =============================================================
345     //                            IERC721
346     // =============================================================
347 
348     /**
349      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
350      */
351     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
355      */
356     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when `owner` enables or disables
360      * (`approved`) `operator` to manage all of its assets.
361      */
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     /**
365      * @dev Returns the number of tokens in `owner`'s account.
366      */
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     /**
370      * @dev Returns the owner of the `tokenId` token.
371      *
372      * Requirements:
373      *
374      * - `tokenId` must exist.
375      */
376     function ownerOf(uint256 tokenId) external view returns (address owner);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`,
380      * checking first that contract recipients are aware of the ERC721 protocol
381      * to prevent tokens from being forever locked.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must be have been allowed to move
389      * this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement
391      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
392      *
393      * Emits a {Transfer} event.
394      */
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId,
399         bytes calldata data
400     ) external;
401 
402     /**
403      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
404      */
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Transfers `tokenId` from `from` to `to`.
413      *
414      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
415      * whenever possible.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must be owned by `from`.
422      * - If the caller is not `from`, it must be approved to move this token
423      * by either {approve} or {setApprovalForAll}.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
435      * The approval is cleared when the token is transferred.
436      *
437      * Only a single account can be approved at a time, so approving the
438      * zero address clears previous approvals.
439      *
440      * Requirements:
441      *
442      * - The caller must own the token or be an approved operator.
443      * - `tokenId` must exist.
444      *
445      * Emits an {Approval} event.
446      */
447     function approve(address to, uint256 tokenId) external;
448 
449     /**
450      * @dev Approve or remove `operator` as an operator for the caller.
451      * Operators can call {transferFrom} or {safeTransferFrom}
452      * for any token owned by the caller.
453      *
454      * Requirements:
455      *
456      * - The `operator` cannot be the caller.
457      *
458      * Emits an {ApprovalForAll} event.
459      */
460     function setApprovalForAll(address operator, bool _approved) external;
461 
462     /**
463      * @dev Returns the account approved for `tokenId` token.
464      *
465      * Requirements:
466      *
467      * - `tokenId` must exist.
468      */
469     function getApproved(uint256 tokenId) external view returns (address operator);
470 
471     /**
472      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
473      *
474      * See {setApprovalForAll}.
475      */
476     function isApprovedForAll(address owner, address operator) external view returns (bool);
477 
478     // =============================================================
479     //                        IERC721Metadata
480     // =============================================================
481 
482     /**
483      * @dev Returns the token collection name.
484      */
485     function name() external view returns (string memory);
486 
487     /**
488      * @dev Returns the token collection symbol.
489      */
490     function symbol() external view returns (string memory);
491 
492     /**
493      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
494      */
495     function tokenURI(uint256 tokenId) external view returns (string memory);
496 
497     // =============================================================
498     //                           IERC2309
499     // =============================================================
500 
501     /**
502      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
503      * (inclusive) is transferred from `from` to `to`, as defined in the
504      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
505      *
506      * See {_mintERC2309} for more details.
507      */
508     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
509 }
510 
511 interface IERC20Permit {
512     /**
513      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
514      * given ``owner``'s signed approval.
515      *
516      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
517      * ordering also apply here.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      * - `deadline` must be a timestamp in the future.
525      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
526      * over the EIP712-formatted function arguments.
527      * - the signature must use ``owner``'s current nonce (see {nonces}).
528      *
529      * For more information on the signature format, see the
530      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
531      * section].
532      */
533     function permit(
534         address owner,
535         address spender,
536         uint256 value,
537         uint256 deadline,
538         uint8 v,
539         bytes32 r,
540         bytes32 s
541     ) external;
542 
543     /**
544      * @dev Returns the current nonce for `owner`. This value must be
545      * included whenever a signature is generated for {permit}.
546      *
547      * Every successful call to {permit} increases ``owner``'s nonce by one. This
548      * prevents a signature from being used multiple times.
549      */
550     function nonces(address owner) external view returns (uint256);
551 
552     /**
553      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
554      */
555     // solhint-disable-next-line func-name-mixedcase
556     function DOMAIN_SEPARATOR() external view returns (bytes32);
557 }
558 
559 interface IERC20 {
560     /**
561      * @dev Emitted when `value` tokens are moved from one account (`from`) to
562      * another (`to`).
563      *
564      * Note that `value` may be zero.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 value);
567 
568     /**
569      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
570      * a call to {approve}. `value` is the new allowance.
571      */
572     event Approval(address indexed owner, address indexed spender, uint256 value);
573 
574     /**
575      * @dev Returns the amount of tokens in existence.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns the amount of tokens owned by `account`.
581      */
582     function balanceOf(address account) external view returns (uint256);
583 
584     /**
585      * @dev Moves `amount` tokens from the caller's account to `to`.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transfer(address to, uint256 amount) external returns (bool);
592 
593     /**
594      * @dev Returns the remaining number of tokens that `spender` will be
595      * allowed to spend on behalf of `owner` through {transferFrom}. This is
596      * zero by default.
597      *
598      * This value changes when {approve} or {transferFrom} are called.
599      */
600     function allowance(address owner, address spender) external view returns (uint256);
601 
602     /**
603      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
604      *
605      * Returns a boolean value indicating whether the operation succeeded.
606      *
607      * IMPORTANT: Beware that changing an allowance with this method brings the risk
608      * that someone may use both the old and the new allowance by unfortunate
609      * transaction ordering. One possible solution to mitigate this race
610      * condition is to first reduce the spender's allowance to 0 and set the
611      * desired value afterwards:
612      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address spender, uint256 amount) external returns (bool);
617 
618     /**
619      * @dev Moves `amount` tokens from `from` to `to` using the
620      * allowance mechanism. `amount` is then deducted from the caller's
621      * allowance.
622      *
623      * Returns a boolean value indicating whether the operation succeeded.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 amount
631     ) external returns (bool);
632 }
633 
634 library SafeERC20 {
635     using Address for address;
636 
637     function safeTransfer(
638         IERC20 token,
639         address to,
640         uint256 value
641     ) internal {
642         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
643     }
644 
645     function safeTransferFrom(
646         IERC20 token,
647         address from,
648         address to,
649         uint256 value
650     ) internal {
651         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
652     }
653 
654     /**
655      * @dev Deprecated. This function has issues similar to the ones found in
656      * {IERC20-approve}, and its usage is discouraged.
657      *
658      * Whenever possible, use {safeIncreaseAllowance} and
659      * {safeDecreaseAllowance} instead.
660      */
661     function safeApprove(
662         IERC20 token,
663         address spender,
664         uint256 value
665     ) internal {
666         // safeApprove should only be called when setting an initial allowance,
667         // or when resetting it to zero. To increase and decrease it, use
668         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
669         require(
670             (value == 0) || (token.allowance(address(this), spender) == 0),
671             "SafeERC20: approve from non-zero to non-zero allowance"
672         );
673         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
674     }
675 
676     function safeIncreaseAllowance(
677         IERC20 token,
678         address spender,
679         uint256 value
680     ) internal {
681         uint256 newAllowance = token.allowance(address(this), spender) + value;
682         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
683     }
684 
685     function safeDecreaseAllowance(
686         IERC20 token,
687         address spender,
688         uint256 value
689     ) internal {
690         unchecked {
691             uint256 oldAllowance = token.allowance(address(this), spender);
692             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
693             uint256 newAllowance = oldAllowance - value;
694             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
695         }
696     }
697 
698     function safePermit(
699         IERC20Permit token,
700         address owner,
701         address spender,
702         uint256 value,
703         uint256 deadline,
704         uint8 v,
705         bytes32 r,
706         bytes32 s
707     ) internal {
708         uint256 nonceBefore = token.nonces(owner);
709         token.permit(owner, spender, value, deadline, v, r, s);
710         uint256 nonceAfter = token.nonces(owner);
711         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
712     }
713 
714     /**
715      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
716      * on the return value: the return value is optional (but if data is returned, it must not be false).
717      * @param token The token targeted by the call.
718      * @param data The call data (encoded using abi.encode or one of its variants).
719      */
720     function _callOptionalReturn(IERC20 token, bytes memory data) private {
721         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
722         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
723         // the target address contains contract code and also asserts for success in the low-level call.
724 
725         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
726         if (returndata.length > 0) {
727             // Return data is optional
728             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
729         }
730     }
731 }
732 
733 library Strings {
734     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
735     uint8 private constant _ADDRESS_LENGTH = 20;
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
739      */
740     function toString(uint256 value) internal pure returns (string memory) {
741         // Inspired by OraclizeAPI's implementation - MIT licence
742         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
743 
744         if (value == 0) {
745             return "0";
746         }
747         uint256 temp = value;
748         uint256 digits;
749         while (temp != 0) {
750             digits++;
751             temp /= 10;
752         }
753         bytes memory buffer = new bytes(digits);
754         while (value != 0) {
755             digits -= 1;
756             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
757             value /= 10;
758         }
759         return string(buffer);
760     }
761 
762     /**
763      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
764      */
765     function toHexString(uint256 value) internal pure returns (string memory) {
766         if (value == 0) {
767             return "0x00";
768         }
769         uint256 temp = value;
770         uint256 length = 0;
771         while (temp != 0) {
772             length++;
773             temp >>= 8;
774         }
775         return toHexString(value, length);
776     }
777 
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
780      */
781     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
782         bytes memory buffer = new bytes(2 * length + 2);
783         buffer[0] = "0";
784         buffer[1] = "x";
785         for (uint256 i = 2 * length + 1; i > 1; --i) {
786             buffer[i] = _HEX_SYMBOLS[value & 0xf];
787             value >>= 4;
788         }
789         require(value == 0, "Strings: hex length insufficient");
790         return string(buffer);
791     }
792 
793     /**
794      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
795      */
796     function toHexString(address addr) internal pure returns (string memory) {
797         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
798     }
799 }
800 
801 abstract contract Ownable is Context {
802     address private _owner;
803 
804     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
805 
806     /**
807      * @dev Initializes the contract setting the deployer as the initial owner.
808      */
809     constructor() {
810         _transferOwnership(_msgSender());
811     }
812 
813     /**
814      * @dev Throws if called by any account other than the owner.
815      */
816     modifier onlyOwner() {
817         _checkOwner();
818         _;
819     }
820 
821     /**
822      * @dev Returns the address of the current owner.
823      */
824     function owner() public view virtual returns (address) {
825         return _owner;
826     }
827 
828     /**
829      * @dev Throws if the sender is not the owner.
830      */
831     function _checkOwner() internal view virtual {
832         require(owner() == _msgSender(), "Ownable: caller is not the owner");
833     }
834 
835     /**
836      * @dev Leaves the contract without owner. It will not be possible to call
837      * `onlyOwner` functions anymore. Can only be called by the current owner.
838      *
839      * NOTE: Renouncing ownership will leave the contract without an owner,
840      * thereby removing any functionality that is only available to the owner.
841      */
842     function renounceOwnership() public virtual onlyOwner {
843         _transferOwnership(address(0));
844     }
845 
846     /**
847      * @dev Transfers ownership of the contract to a new account (`newOwner`).
848      * Can only be called by the current owner.
849      */
850     function transferOwnership(address newOwner) public virtual onlyOwner {
851         require(newOwner != address(0), "Ownable: new owner is the zero address");
852         _transferOwnership(newOwner);
853     }
854 
855     /**
856      * @dev Transfers ownership of the contract to a new account (`newOwner`).
857      * Internal function without access restriction.
858      */
859     function _transferOwnership(address newOwner) internal virtual {
860         address oldOwner = _owner;
861         _owner = newOwner;
862         emit OwnershipTransferred(oldOwner, newOwner);
863     }
864 }
865 
866 contract PaymentSplitter is Context {
867     event PayeeAdded(address account, uint256 shares);
868     event PaymentReleased(address to, uint256 amount);
869     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
870     event PaymentReceived(address from, uint256 amount);
871 
872     uint256 private _totalShares;
873     uint256 private _totalReleased;
874 
875     mapping(address => uint256) private _shares;
876     mapping(address => uint256) private _released;
877     address[] private _payees;
878 
879     mapping(IERC20 => uint256) private _erc20TotalReleased;
880     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
881 
882     /**
883      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
884      * the matching position in the `shares` array.
885      *
886      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
887      * duplicates in `payees`.
888      */
889     constructor(address[] memory payees, uint256[] memory shares_) payable {
890         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
891         require(payees.length > 0, "PaymentSplitter: no payees");
892 
893         for (uint256 i = 0; i < payees.length; i++) {
894             _addPayee(payees[i], shares_[i]);
895         }
896     }
897 
898     /**
899      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
900      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
901      * reliability of the events, and not the actual splitting of Ether.
902      *
903      * To learn more about this see the Solidity documentation for
904      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
905      * functions].
906      */
907     receive() external payable virtual {
908         emit PaymentReceived(_msgSender(), msg.value);
909     }
910 
911     /**
912      * @dev Getter for the total shares held by payees.
913      */
914     function totalShares() public view returns (uint256) {
915         return _totalShares;
916     }
917 
918     /**
919      * @dev Getter for the total amount of Ether already released.
920      */
921     function totalReleased() public view returns (uint256) {
922         return _totalReleased;
923     }
924 
925     /**
926      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
927      * contract.
928      */
929     function totalReleased(IERC20 token) public view returns (uint256) {
930         return _erc20TotalReleased[token];
931     }
932 
933     /**
934      * @dev Getter for the amount of shares held by an account.
935      */
936     function shares(address account) public view returns (uint256) {
937         return _shares[account];
938     }
939 
940     /**
941      * @dev Getter for the amount of Ether already released to a payee.
942      */
943     function released(address account) public view returns (uint256) {
944         return _released[account];
945     }
946 
947     /**
948      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
949      * IERC20 contract.
950      */
951     function released(IERC20 token, address account) public view returns (uint256) {
952         return _erc20Released[token][account];
953     }
954 
955     /**
956      * @dev Getter for the address of the payee number `index`.
957      */
958     function payee(uint256 index) public view returns (address) {
959         return _payees[index];
960     }
961 
962     /**
963      * @dev Getter for the amount of payee's releasable Ether.
964      */
965     function releasable(address account) public view returns (uint256) {
966         uint256 totalReceived = address(this).balance + totalReleased();
967         return _pendingPayment(account, totalReceived, released(account));
968     }
969 
970     /**
971      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
972      * IERC20 contract.
973      */
974     function releasable(IERC20 token, address account) public view returns (uint256) {
975         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
976         return _pendingPayment(account, totalReceived, released(token, account));
977     }
978 
979     /**
980      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
981      * total shares and their previous withdrawals.
982      */
983     function release(address payable account) public virtual {
984         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
985 
986         uint256 payment = releasable(account);
987 
988         require(payment != 0, "PaymentSplitter: account is not due payment");
989 
990         _released[account] += payment;
991         _totalReleased += payment;
992 
993         Address.sendValue(account, payment);
994         emit PaymentReleased(account, payment);
995     }
996 
997     /**
998      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
999      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1000      * contract.
1001      */
1002     function release(IERC20 token, address account) public virtual {
1003         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1004 
1005         uint256 payment = releasable(token, account);
1006 
1007         require(payment != 0, "PaymentSplitter: account is not due payment");
1008 
1009         _erc20Released[token][account] += payment;
1010         _erc20TotalReleased[token] += payment;
1011 
1012         SafeERC20.safeTransfer(token, account, payment);
1013         emit ERC20PaymentReleased(token, account, payment);
1014     }
1015 
1016     /**
1017      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1018      * already released amounts.
1019      */
1020     function _pendingPayment(
1021         address account,
1022         uint256 totalReceived,
1023         uint256 alreadyReleased
1024     ) private view returns (uint256) {
1025         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1026     }
1027 
1028     /**
1029      * @dev Add a new payee to the contract.
1030      * @param account The address of the payee to add.
1031      * @param shares_ The number of shares owned by the payee.
1032      */
1033     function _addPayee(address account, uint256 shares_) private {
1034         require(account != address(0), "PaymentSplitter: account is the zero address");
1035         require(shares_ > 0, "PaymentSplitter: shares are 0");
1036         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1037 
1038         _payees.push(account);
1039         _shares[account] = shares_;
1040         _totalShares = _totalShares + shares_;
1041         emit PayeeAdded(account, shares_);
1042     }
1043 }
1044 
1045 /**
1046  * @dev Interface of ERC721 token receiver.
1047  */
1048 interface ERC721A__IERC721Receiver {
1049     function onERC721Received(
1050         address operator,
1051         address from,
1052         uint256 tokenId,
1053         bytes calldata data
1054     ) external returns (bytes4);
1055 }
1056 
1057 /**
1058  * @title ERC721A
1059  *
1060  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1061  * Non-Fungible Token Standard, including the Metadata extension.
1062  * Optimized for lower gas during batch mints.
1063  *
1064  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1065  * starting from `_startTokenId()`.
1066  *
1067  * Assumptions:
1068  *
1069  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1070  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1071  */
1072 contract ERC721A is IERC721A {
1073     // Reference type for token approval.
1074     struct TokenApprovalRef {
1075         address value;
1076     }
1077 
1078     // =============================================================
1079     //                           CONSTANTS
1080     // =============================================================
1081 
1082     // Mask of an entry in packed address data.
1083     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1084 
1085     // The bit position of `numberMinted` in packed address data.
1086     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1087 
1088     // The bit position of `numberBurned` in packed address data.
1089     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1090 
1091     // The bit position of `aux` in packed address data.
1092     uint256 private constant _BITPOS_AUX = 192;
1093 
1094     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1095     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1096 
1097     // The bit position of `startTimestamp` in packed ownership.
1098     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1099 
1100     // The bit mask of the `burned` bit in packed ownership.
1101     uint256 private constant _BITMASK_BURNED = 1 << 224;
1102 
1103     // The bit position of the `nextInitialized` bit in packed ownership.
1104     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1105 
1106     // The bit mask of the `nextInitialized` bit in packed ownership.
1107     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1108 
1109     // The bit position of `extraData` in packed ownership.
1110     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1111 
1112     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1113     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1114 
1115     // The mask of the lower 160 bits for addresses.
1116     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1117 
1118     // The maximum `quantity` that can be minted with {_mintERC2309}.
1119     // This limit is to prevent overflows on the address data entries.
1120     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1121     // is required to cause an overflow, which is unrealistic.
1122     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1123 
1124     // The `Transfer` event signature is given by:
1125     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1126     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1127         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1128 
1129     // =============================================================
1130     //                            STORAGE
1131     // =============================================================
1132 
1133     // The next token ID to be minted.
1134     uint256 private _currentIndex;
1135 
1136     // The number of tokens burned.
1137     uint256 private _burnCounter;
1138 
1139     // Token name
1140     string private _name;
1141 
1142     // Token symbol
1143     string private _symbol;
1144 
1145     // Mapping from token ID to ownership details
1146     // An empty struct value does not necessarily mean the token is unowned.
1147     // See {_packedOwnershipOf} implementation for details.
1148     //
1149     // Bits Layout:
1150     // - [0..159]   `addr`
1151     // - [160..223] `startTimestamp`
1152     // - [224]      `burned`
1153     // - [225]      `nextInitialized`
1154     // - [232..255] `extraData`
1155     mapping(uint256 => uint256) private _packedOwnerships;
1156 
1157     // Mapping owner address to address data.
1158     //
1159     // Bits Layout:
1160     // - [0..63]    `balance`
1161     // - [64..127]  `numberMinted`
1162     // - [128..191] `numberBurned`
1163     // - [192..255] `aux`
1164     mapping(address => uint256) private _packedAddressData;
1165 
1166     // Mapping from token ID to approved address.
1167     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1168 
1169     // Mapping from owner to operator approvals
1170     mapping(address => mapping(address => bool)) private _operatorApprovals;
1171 
1172     // =============================================================
1173     //                          CONSTRUCTOR
1174     // =============================================================
1175 
1176     constructor(string memory name_, string memory symbol_) {
1177         _name = name_;
1178         _symbol = symbol_;
1179         _currentIndex = _startTokenId();
1180     }
1181 
1182     // =============================================================
1183     //                   TOKEN COUNTING OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Returns the starting token ID.
1188      * To change the starting token ID, please override this function.
1189      */
1190     function _startTokenId() internal view virtual returns (uint256) {
1191         return 1;
1192     }
1193 
1194     /**
1195      * @dev Returns the next token ID to be minted.
1196      */
1197     function _nextTokenId() internal view virtual returns (uint256) {
1198         return _currentIndex;
1199     }
1200 
1201     /**
1202      * @dev Returns the total number of tokens in existence.
1203      * Burned tokens will reduce the count.
1204      * To get the total number of tokens minted, please see {_totalMinted}.
1205      */
1206     function totalSupply() public view virtual override returns (uint256) {
1207         // Counter underflow is impossible as _burnCounter cannot be incremented
1208         // more than `_currentIndex - _startTokenId()` times.
1209         unchecked {
1210             return _currentIndex - _burnCounter - _startTokenId();
1211         }
1212     }
1213 
1214     /**
1215      * @dev Returns the total amount of tokens minted in the contract.
1216      */
1217     function _totalMinted() internal view virtual returns (uint256) {
1218         // Counter underflow is impossible as `_currentIndex` does not decrement,
1219         // and it is initialized to `_startTokenId()`.
1220         unchecked {
1221             return _currentIndex - _startTokenId();
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the total number of tokens burned.
1227      */
1228     function _totalBurned() internal view virtual returns (uint256) {
1229         return _burnCounter;
1230     }
1231 
1232     // =============================================================
1233     //                    ADDRESS DATA OPERATIONS
1234     // =============================================================
1235 
1236     /**
1237      * @dev Returns the number of tokens in `owner`'s account.
1238      */
1239     function balanceOf(address owner) public view virtual override returns (uint256) {
1240         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1241         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1242     }
1243 
1244     /**
1245      * Returns the number of tokens minted by `owner`.
1246      */
1247     function _numberMinted(address owner) internal view returns (uint256) {
1248         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1249     }
1250 
1251     /**
1252      * Returns the number of tokens burned by or on behalf of `owner`.
1253      */
1254     function _numberBurned(address owner) internal view returns (uint256) {
1255         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1256     }
1257 
1258     /**
1259      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1260      */
1261     function _getAux(address owner) internal view returns (uint64) {
1262         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1263     }
1264 
1265     /**
1266      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1267      * If there are multiple variables, please pack them into a uint64.
1268      */
1269     function _setAux(address owner, uint64 aux) internal virtual {
1270         uint256 packed = _packedAddressData[owner];
1271         uint256 auxCasted;
1272         // Cast `aux` with assembly to avoid redundant masking.
1273         assembly {
1274             auxCasted := aux
1275         }
1276         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1277         _packedAddressData[owner] = packed;
1278     }
1279 
1280     // =============================================================
1281     //                            IERC165
1282     // =============================================================
1283 
1284     /**
1285      * @dev Returns true if this contract implements the interface defined by
1286      * `interfaceId`. See the corresponding
1287      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1288      * to learn more about how these ids are created.
1289      *
1290      * This function call must use less than 30000 gas.
1291      */
1292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1293         // The interface IDs are constants representing the first 4 bytes
1294         // of the XOR of all function selectors in the interface.
1295         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1296         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1297         return
1298             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1299             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1300             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1301     }
1302 
1303     // =============================================================
1304     //                        IERC721Metadata
1305     // =============================================================
1306 
1307     /**
1308      * @dev Returns the token collection name.
1309      */
1310     function name() public view virtual override returns (string memory) {
1311         return _name;
1312     }
1313 
1314     /**
1315      * @dev Returns the token collection symbol.
1316      */
1317     function symbol() public view virtual override returns (string memory) {
1318         return _symbol;
1319     }
1320 
1321     /**
1322      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1323      */
1324     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1325         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1326 
1327         string memory baseURI = _baseURI();
1328         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1329     }
1330 
1331     /**
1332      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1333      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1334      * by default, it can be overridden in child contracts.
1335      */
1336     function _baseURI() internal view virtual returns (string memory) {
1337         return '';
1338     }
1339 
1340     // =============================================================
1341     //                     OWNERSHIPS OPERATIONS
1342     // =============================================================
1343 
1344     /**
1345      * @dev Returns the owner of the `tokenId` token.
1346      *
1347      * Requirements:
1348      *
1349      * - `tokenId` must exist.
1350      */
1351     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1352         return address(uint160(_packedOwnershipOf(tokenId)));
1353     }
1354 
1355     /**
1356      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1357      * It gradually moves to O(1) as tokens get transferred around over time.
1358      */
1359     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1360         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1361     }
1362 
1363     /**
1364      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1365      */
1366     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1367         return _unpackedOwnership(_packedOwnerships[index]);
1368     }
1369 
1370     /**
1371      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1372      */
1373     function _initializeOwnershipAt(uint256 index) internal virtual {
1374         if (_packedOwnerships[index] == 0) {
1375             _packedOwnerships[index] = _packedOwnershipOf(index);
1376         }
1377     }
1378 
1379     /**
1380      * Returns the packed ownership data of `tokenId`.
1381      */
1382     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1383         uint256 curr = tokenId;
1384 
1385         unchecked {
1386             if (_startTokenId() <= curr)
1387                 if (curr < _currentIndex) {
1388                     uint256 packed = _packedOwnerships[curr];
1389                     // If not burned.
1390                     if (packed & _BITMASK_BURNED == 0) {
1391                         // Invariant:
1392                         // There will always be an initialized ownership slot
1393                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1394                         // before an unintialized ownership slot
1395                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1396                         // Hence, `curr` will not underflow.
1397                         //
1398                         // We can directly compare the packed value.
1399                         // If the address is zero, packed will be zero.
1400                         while (packed == 0) {
1401                             packed = _packedOwnerships[--curr];
1402                         }
1403                         return packed;
1404                     }
1405                 }
1406         }
1407         revert OwnerQueryForNonexistentToken();
1408     }
1409 
1410     /**
1411      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1412      */
1413     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1414         ownership.addr = address(uint160(packed));
1415         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1416         ownership.burned = packed & _BITMASK_BURNED != 0;
1417         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1418     }
1419 
1420     /**
1421      * @dev Packs ownership data into a single uint256.
1422      */
1423     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1424         assembly {
1425             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1426             owner := and(owner, _BITMASK_ADDRESS)
1427             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1428             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1429         }
1430     }
1431 
1432     /**
1433      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1434      */
1435     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1436         // For branchless setting of the `nextInitialized` flag.
1437         assembly {
1438             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1439             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1440         }
1441     }
1442 
1443     // =============================================================
1444     //                      APPROVAL OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1449      * The approval is cleared when the token is transferred.
1450      *
1451      * Only a single account can be approved at a time, so approving the
1452      * zero address clears previous approvals.
1453      *
1454      * Requirements:
1455      *
1456      * - The caller must own the token or be an approved operator.
1457      * - `tokenId` must exist.
1458      *
1459      * Emits an {Approval} event.
1460      */
1461     function approve(address to, uint256 tokenId) public virtual override {
1462         address owner = ownerOf(tokenId);
1463 
1464         if (_msgSenderERC721A() != owner)
1465             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1466                 revert ApprovalCallerNotOwnerNorApproved();
1467             }
1468 
1469         _tokenApprovals[tokenId].value = to;
1470         emit Approval(owner, to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Returns the account approved for `tokenId` token.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      */
1480     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1481         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1482 
1483         return _tokenApprovals[tokenId].value;
1484     }
1485 
1486     /**
1487      * @dev Approve or remove `operator` as an operator for the caller.
1488      * Operators can call {transferFrom} or {safeTransferFrom}
1489      * for any token owned by the caller.
1490      *
1491      * Requirements:
1492      *
1493      * - The `operator` cannot be the caller.
1494      *
1495      * Emits an {ApprovalForAll} event.
1496      */
1497     function setApprovalForAll(address operator, bool approved) public virtual override {
1498         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1499 
1500         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1501         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1502     }
1503 
1504     /**
1505      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1506      *
1507      * See {setApprovalForAll}.
1508      */
1509     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1510         return _operatorApprovals[owner][operator];
1511     }
1512 
1513     /**
1514      * @dev Returns whether `tokenId` exists.
1515      *
1516      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1517      *
1518      * Tokens start existing when they are minted. See {_mint}.
1519      */
1520     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1521         return
1522             _startTokenId() <= tokenId &&
1523             tokenId < _currentIndex && // If within bounds,
1524             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1525     }
1526 
1527     /**
1528      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1529      */
1530     function _isSenderApprovedOrOwner(
1531         address approvedAddress,
1532         address owner,
1533         address msgSender
1534     ) private pure returns (bool result) {
1535         assembly {
1536             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1537             owner := and(owner, _BITMASK_ADDRESS)
1538             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1539             msgSender := and(msgSender, _BITMASK_ADDRESS)
1540             // `msgSender == owner || msgSender == approvedAddress`.
1541             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1542         }
1543     }
1544 
1545     /**
1546      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1547      */
1548     function _getApprovedSlotAndAddress(uint256 tokenId)
1549         private
1550         view
1551         returns (uint256 approvedAddressSlot, address approvedAddress)
1552     {
1553         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1554         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1555         assembly {
1556             approvedAddressSlot := tokenApproval.slot
1557             approvedAddress := sload(approvedAddressSlot)
1558         }
1559     }
1560 
1561     // =============================================================
1562     //                      TRANSFER OPERATIONS
1563     // =============================================================
1564 
1565     /**
1566      * @dev Transfers `tokenId` from `from` to `to`.
1567      *
1568      * Requirements:
1569      *
1570      * - `from` cannot be the zero address.
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must be owned by `from`.
1573      * - If the caller is not `from`, it must be approved to move this token
1574      * by either {approve} or {setApprovalForAll}.
1575      *
1576      * Emits a {Transfer} event.
1577      */
1578     function transferFrom(
1579         address from,
1580         address to,
1581         uint256 tokenId
1582     ) public virtual override {
1583         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1584 
1585         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1586 
1587         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1588 
1589         // The nested ifs save around 20+ gas over a compound boolean condition.
1590         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1591             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1592 
1593         if (to == address(0)) revert TransferToZeroAddress();
1594 
1595         _beforeTokenTransfers(from, to, tokenId, 1);
1596 
1597         // Clear approvals from the previous owner.
1598         assembly {
1599             if approvedAddress {
1600                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1601                 sstore(approvedAddressSlot, 0)
1602             }
1603         }
1604 
1605         // Underflow of the sender's balance is impossible because we check for
1606         // ownership above and the recipient's balance can't realistically overflow.
1607         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1608         unchecked {
1609             // We can directly increment and decrement the balances.
1610             --_packedAddressData[from]; // Updates: `balance -= 1`.
1611             ++_packedAddressData[to]; // Updates: `balance += 1`.
1612 
1613             // Updates:
1614             // - `address` to the next owner.
1615             // - `startTimestamp` to the timestamp of transfering.
1616             // - `burned` to `false`.
1617             // - `nextInitialized` to `true`.
1618             _packedOwnerships[tokenId] = _packOwnershipData(
1619                 to,
1620                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1621             );
1622 
1623             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1624             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1625                 uint256 nextTokenId = tokenId + 1;
1626                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1627                 if (_packedOwnerships[nextTokenId] == 0) {
1628                     // If the next slot is within bounds.
1629                     if (nextTokenId != _currentIndex) {
1630                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1631                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1632                     }
1633                 }
1634             }
1635         }
1636 
1637         emit Transfer(from, to, tokenId);
1638         _afterTokenTransfers(from, to, tokenId, 1);
1639     }
1640 
1641     /**
1642      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1643      */
1644     function safeTransferFrom(
1645         address from,
1646         address to,
1647         uint256 tokenId
1648     ) public virtual override {
1649         safeTransferFrom(from, to, tokenId, '');
1650     }
1651 
1652     /**
1653      * @dev Safely transfers `tokenId` token from `from` to `to`.
1654      *
1655      * Requirements:
1656      *
1657      * - `from` cannot be the zero address.
1658      * - `to` cannot be the zero address.
1659      * - `tokenId` token must exist and be owned by `from`.
1660      * - If the caller is not `from`, it must be approved to move this token
1661      * by either {approve} or {setApprovalForAll}.
1662      * - If `to` refers to a smart contract, it must implement
1663      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function safeTransferFrom(
1668         address from,
1669         address to,
1670         uint256 tokenId,
1671         bytes memory _data
1672     ) public virtual override {
1673         transferFrom(from, to, tokenId);
1674         if (to.code.length != 0)
1675             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1676                 revert TransferToNonERC721ReceiverImplementer();
1677             }
1678     }
1679 
1680     /**
1681      * @dev Hook that is called before a set of serially-ordered token IDs
1682      * are about to be transferred. This includes minting.
1683      * And also called before burning one token.
1684      *
1685      * `startTokenId` - the first token ID to be transferred.
1686      * `quantity` - the amount to be transferred.
1687      *
1688      * Calling conditions:
1689      *
1690      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1691      * transferred to `to`.
1692      * - When `from` is zero, `tokenId` will be minted for `to`.
1693      * - When `to` is zero, `tokenId` will be burned by `from`.
1694      * - `from` and `to` are never both zero.
1695      */
1696     function _beforeTokenTransfers(
1697         address from,
1698         address to,
1699         uint256 startTokenId,
1700         uint256 quantity
1701     ) internal virtual {}
1702 
1703     /**
1704      * @dev Hook that is called after a set of serially-ordered token IDs
1705      * have been transferred. This includes minting.
1706      * And also called after one token has been burned.
1707      *
1708      * `startTokenId` - the first token ID to be transferred.
1709      * `quantity` - the amount to be transferred.
1710      *
1711      * Calling conditions:
1712      *
1713      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1714      * transferred to `to`.
1715      * - When `from` is zero, `tokenId` has been minted for `to`.
1716      * - When `to` is zero, `tokenId` has been burned by `from`.
1717      * - `from` and `to` are never both zero.
1718      */
1719     function _afterTokenTransfers(
1720         address from,
1721         address to,
1722         uint256 startTokenId,
1723         uint256 quantity
1724     ) internal virtual {}
1725 
1726     /**
1727      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1728      *
1729      * `from` - Previous owner of the given token ID.
1730      * `to` - Target address that will receive the token.
1731      * `tokenId` - Token ID to be transferred.
1732      * `_data` - Optional data to send along with the call.
1733      *
1734      * Returns whether the call correctly returned the expected magic value.
1735      */
1736     function _checkContractOnERC721Received(
1737         address from,
1738         address to,
1739         uint256 tokenId,
1740         bytes memory _data
1741     ) private returns (bool) {
1742         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1743             bytes4 retval
1744         ) {
1745             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1746         } catch (bytes memory reason) {
1747             if (reason.length == 0) {
1748                 revert TransferToNonERC721ReceiverImplementer();
1749             } else {
1750                 assembly {
1751                     revert(add(32, reason), mload(reason))
1752                 }
1753             }
1754         }
1755     }
1756 
1757     // =============================================================
1758     //                        MINT OPERATIONS
1759     // =============================================================
1760 
1761     /**
1762      * @dev Mints `quantity` tokens and transfers them to `to`.
1763      *
1764      * Requirements:
1765      *
1766      * - `to` cannot be the zero address.
1767      * - `quantity` must be greater than 0.
1768      *
1769      * Emits a {Transfer} event for each mint.
1770      */
1771     function _mint(address to, uint256 quantity) internal virtual {
1772         uint256 startTokenId = _currentIndex;
1773         if (quantity == 0) revert MintZeroQuantity();
1774 
1775         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1776 
1777         // Overflows are incredibly unrealistic.
1778         // `balance` and `numberMinted` have a maximum limit of 2**64.
1779         // `tokenId` has a maximum limit of 2**256.
1780         unchecked {
1781             // Updates:
1782             // - `balance += quantity`.
1783             // - `numberMinted += quantity`.
1784             //
1785             // We can directly add to the `balance` and `numberMinted`.
1786             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1787 
1788             // Updates:
1789             // - `address` to the owner.
1790             // - `startTimestamp` to the timestamp of minting.
1791             // - `burned` to `false`.
1792             // - `nextInitialized` to `quantity == 1`.
1793             _packedOwnerships[startTokenId] = _packOwnershipData(
1794                 to,
1795                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1796             );
1797 
1798             uint256 toMasked;
1799             uint256 end = startTokenId + quantity;
1800 
1801             // Use assembly to loop and emit the `Transfer` event for gas savings.
1802             assembly {
1803                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1804                 toMasked := and(to, _BITMASK_ADDRESS)
1805                 // Emit the `Transfer` event.
1806                 log4(
1807                     0, // Start of data (0, since no data).
1808                     0, // End of data (0, since no data).
1809                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1810                     0, // `address(0)`.
1811                     toMasked, // `to`.
1812                     startTokenId // `tokenId`.
1813                 )
1814 
1815                 for {
1816                     let tokenId := add(startTokenId, 1)
1817                 } iszero(eq(tokenId, end)) {
1818                     tokenId := add(tokenId, 1)
1819                 } {
1820                     // Emit the `Transfer` event. Similar to above.
1821                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1822                 }
1823             }
1824             if (toMasked == 0) revert MintToZeroAddress();
1825 
1826             _currentIndex = end;
1827         }
1828         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1829     }
1830 
1831     /**
1832      * @dev Mints `quantity` tokens and transfers them to `to`.
1833      *
1834      * This function is intended for efficient minting only during contract creation.
1835      *
1836      * It emits only one {ConsecutiveTransfer} as defined in
1837      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1838      * instead of a sequence of {Transfer} event(s).
1839      *
1840      * Calling this function outside of contract creation WILL make your contract
1841      * non-compliant with the ERC721 standard.
1842      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1843      * {ConsecutiveTransfer} event is only permissible during contract creation.
1844      *
1845      * Requirements:
1846      *
1847      * - `to` cannot be the zero address.
1848      * - `quantity` must be greater than 0.
1849      *
1850      * Emits a {ConsecutiveTransfer} event.
1851      */
1852     function _mintERC2309(address to, uint256 quantity) internal virtual {
1853         uint256 startTokenId = _currentIndex;
1854         if (to == address(0)) revert MintToZeroAddress();
1855         if (quantity == 0) revert MintZeroQuantity();
1856         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1857 
1858         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1859 
1860         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1861         unchecked {
1862             // Updates:
1863             // - `balance += quantity`.
1864             // - `numberMinted += quantity`.
1865             //
1866             // We can directly add to the `balance` and `numberMinted`.
1867             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1868 
1869             // Updates:
1870             // - `address` to the owner.
1871             // - `startTimestamp` to the timestamp of minting.
1872             // - `burned` to `false`.
1873             // - `nextInitialized` to `quantity == 1`.
1874             _packedOwnerships[startTokenId] = _packOwnershipData(
1875                 to,
1876                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1877             );
1878 
1879             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1880 
1881             _currentIndex = startTokenId + quantity;
1882         }
1883         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1884     }
1885 
1886     /**
1887      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1888      *
1889      * Requirements:
1890      *
1891      * - If `to` refers to a smart contract, it must implement
1892      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1893      * - `quantity` must be greater than 0.
1894      *
1895      * See {_mint}.
1896      *
1897      * Emits a {Transfer} event for each mint.
1898      */
1899     function _safeMint(
1900         address to,
1901         uint256 quantity,
1902         bytes memory _data
1903     ) internal virtual {
1904         _mint(to, quantity);
1905 
1906         unchecked {
1907             if (to.code.length != 0) {
1908                 uint256 end = _currentIndex;
1909                 uint256 index = end - quantity;
1910                 do {
1911                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1912                         revert TransferToNonERC721ReceiverImplementer();
1913                     }
1914                 } while (index < end);
1915                 // Reentrancy protection.
1916                 if (_currentIndex != end) revert();
1917             }
1918         }
1919     }
1920 
1921     /**
1922      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1923      */
1924     function _safeMint(address to, uint256 quantity) internal virtual {
1925         _safeMint(to, quantity, '');
1926     }
1927 
1928     // =============================================================
1929     //                        BURN OPERATIONS
1930     // =============================================================
1931 
1932     /**
1933      * @dev Equivalent to `_burn(tokenId, false)`.
1934      */
1935     function _burn(uint256 tokenId) internal virtual {
1936         _burn(tokenId, false);
1937     }
1938 
1939     /**
1940      * @dev Destroys `tokenId`.
1941      * The approval is cleared when the token is burned.
1942      *
1943      * Requirements:
1944      *
1945      * - `tokenId` must exist.
1946      *
1947      * Emits a {Transfer} event.
1948      */
1949     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1950         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1951 
1952         address from = address(uint160(prevOwnershipPacked));
1953 
1954         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1955 
1956         if (approvalCheck) {
1957             // The nested ifs save around 20+ gas over a compound boolean condition.
1958             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1959                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1960         }
1961 
1962         _beforeTokenTransfers(from, address(0), tokenId, 1);
1963 
1964         // Clear approvals from the previous owner.
1965         assembly {
1966             if approvedAddress {
1967                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1968                 sstore(approvedAddressSlot, 0)
1969             }
1970         }
1971 
1972         // Underflow of the sender's balance is impossible because we check for
1973         // ownership above and the recipient's balance can't realistically overflow.
1974         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1975         unchecked {
1976             // Updates:
1977             // - `balance -= 1`.
1978             // - `numberBurned += 1`.
1979             //
1980             // We can directly decrement the balance, and increment the number burned.
1981             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1982             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1983 
1984             // Updates:
1985             // - `address` to the last owner.
1986             // - `startTimestamp` to the timestamp of burning.
1987             // - `burned` to `true`.
1988             // - `nextInitialized` to `true`.
1989             _packedOwnerships[tokenId] = _packOwnershipData(
1990                 from,
1991                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1992             );
1993 
1994             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1995             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1996                 uint256 nextTokenId = tokenId + 1;
1997                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1998                 if (_packedOwnerships[nextTokenId] == 0) {
1999                     // If the next slot is within bounds.
2000                     if (nextTokenId != _currentIndex) {
2001                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2002                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2003                     }
2004                 }
2005             }
2006         }
2007 
2008         emit Transfer(from, address(0), tokenId);
2009         _afterTokenTransfers(from, address(0), tokenId, 1);
2010 
2011         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2012         unchecked {
2013             _burnCounter++;
2014         }
2015     }
2016 
2017     // =============================================================
2018     //                     EXTRA DATA OPERATIONS
2019     // =============================================================
2020 
2021     /**
2022      * @dev Directly sets the extra data for the ownership data `index`.
2023      */
2024     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2025         uint256 packed = _packedOwnerships[index];
2026         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2027         uint256 extraDataCasted;
2028         // Cast `extraData` with assembly to avoid redundant masking.
2029         assembly {
2030             extraDataCasted := extraData
2031         }
2032         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2033         _packedOwnerships[index] = packed;
2034     }
2035 
2036     /**
2037      * @dev Called during each token transfer to set the 24bit `extraData` field.
2038      * Intended to be overridden by the cosumer contract.
2039      *
2040      * `previousExtraData` - the value of `extraData` before transfer.
2041      *
2042      * Calling conditions:
2043      *
2044      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2045      * transferred to `to`.
2046      * - When `from` is zero, `tokenId` will be minted for `to`.
2047      * - When `to` is zero, `tokenId` will be burned by `from`.
2048      * - `from` and `to` are never both zero.
2049      */
2050     function _extraData(
2051         address from,
2052         address to,
2053         uint24 previousExtraData
2054     ) internal view virtual returns (uint24) {}
2055 
2056     /**
2057      * @dev Returns the next extra data for the packed ownership data.
2058      * The returned result is shifted into position.
2059      */
2060     function _nextExtraData(
2061         address from,
2062         address to,
2063         uint256 prevOwnershipPacked
2064     ) private view returns (uint256) {
2065         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2066         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2067     }
2068 
2069     // =============================================================
2070     //                       OTHER OPERATIONS
2071     // =============================================================
2072 
2073     /**
2074      * @dev Returns the message sender (defaults to `msg.sender`).
2075      *
2076      * If you are writing GSN compatible contracts, you need to override this function.
2077      */
2078     function _msgSenderERC721A() internal view virtual returns (address) {
2079         return msg.sender;
2080     }
2081 
2082     /**
2083      * @dev Converts a uint256 to its ASCII string decimal representation.
2084      */
2085     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2086         assembly {
2087             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2088             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2089             // We will need 1 32-byte word to store the length,
2090             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2091             ptr := add(mload(0x40), 128)
2092             // Update the free memory pointer to allocate.
2093             mstore(0x40, ptr)
2094 
2095             // Cache the end of the memory to calculate the length later.
2096             let end := ptr
2097 
2098             // We write the string from the rightmost digit to the leftmost digit.
2099             // The following is essentially a do-while loop that also handles the zero case.
2100             // Costs a bit more than early returning for the zero case,
2101             // but cheaper in terms of deployment and overall runtime costs.
2102             for {
2103                 // Initialize and perform the first pass without check.
2104                 let temp := value
2105                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2106                 ptr := sub(ptr, 1)
2107                 // Write the character to the pointer.
2108                 // The ASCII index of the '0' character is 48.
2109                 mstore8(ptr, add(48, mod(temp, 10)))
2110                 temp := div(temp, 10)
2111             } temp {
2112                 // Keep dividing `temp` until zero.
2113                 temp := div(temp, 10)
2114             } {
2115                 // Body of the for loop.
2116                 ptr := sub(ptr, 1)
2117                 mstore8(ptr, add(48, mod(temp, 10)))
2118             }
2119 
2120             let length := sub(end, ptr)
2121             // Move the pointer 32 bytes leftwards to make room for the length.
2122             ptr := sub(ptr, 32)
2123             // Store the length.
2124             mstore(ptr, length)
2125         }
2126     }
2127 }
2128 
2129 contract RIPPele is Ownable, ERC721A, PaymentSplitter {
2130 
2131     using Strings for uint;
2132 
2133     enum Step {
2134         Before,
2135         PublicSale,
2136         SoldOut,
2137         Reveal
2138     }
2139 
2140     string public baseURI;
2141 
2142     Step public sellingStep;
2143 
2144     uint private constant MAX_SUPPLY = 5555;
2145 
2146     uint public publicPrice = 0.0025 ether;
2147 
2148     mapping(address => uint) public mintedAmountNFTsperWallet;
2149 
2150     uint public maxAmountPerTxnPublic = 10; 
2151 
2152     uint private teamLength;
2153 
2154     constructor(address[] memory _team, uint[] memory _teamShares, string memory _baseURI) ERC721A("RIP Pele", "RIPPELE")
2155     PaymentSplitter(_team, _teamShares) {
2156         baseURI = _baseURI;
2157         teamLength = _team.length;
2158     }
2159 
2160     function mintForOpensea() external onlyOwner{
2161         if(totalSupply() != 0) revert("Only one mint for deployer");
2162         _mint(msg.sender, 1);
2163     }
2164     
2165     function freeMint() external {
2166         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2167         if(_numberMinted(msg.sender) > 0) revert("Only 1 free");
2168         if(totalSupply() + 1 > MAX_SUPPLY) revert("Max supply exceeded");
2169         _mint(msg.sender, 1);
2170     }
2171 
2172     function publicSaleMint(uint _quantity) external payable {
2173         if(publicPrice <= 0) revert("Price is 0");
2174         if(msg.value < publicPrice * _quantity) revert("Not enough funds");
2175         if(_quantity > maxAmountPerTxnPublic) revert("Over max amount per txn");
2176         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2177         if(totalSupply() + _quantity > MAX_SUPPLY) revert("Max supply exceeded");
2178         _mint(msg.sender, _quantity);
2179     }
2180 
2181     function currentState() external view returns (Step, uint, uint) {
2182         return (sellingStep, publicPrice, maxAmountPerTxnPublic);
2183     }
2184 
2185     function changePublicSalePrice(uint256 new_price) external onlyOwner{
2186         publicPrice = new_price;
2187     }
2188 
2189     function setBaseUri(string memory _baseURI) external onlyOwner {
2190         baseURI = _baseURI;
2191     }
2192 
2193     function setStep(uint _step) external onlyOwner {
2194         sellingStep = Step(_step);
2195     }
2196 
2197     function setMaxTxnPublic(uint amount) external onlyOwner{
2198         maxAmountPerTxnPublic = amount;
2199     }
2200 
2201     function getNumberMinted(address account) external view returns (uint256) {
2202         return _numberMinted(account);
2203     }
2204 
2205     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2206         require(_exists(_tokenId), "URI query for nonexistent token");
2207         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2208     }
2209 
2210     function releaseAll() external {
2211         for(uint i = 0 ; i < teamLength ; i++) {
2212             release(payable(payee(i)));
2213         }
2214     }
2215 }