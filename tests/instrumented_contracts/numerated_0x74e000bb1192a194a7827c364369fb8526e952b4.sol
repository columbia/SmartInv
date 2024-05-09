1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.18;
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
866 /**
867  * @dev Interface of ERC721 token receiver.
868  */
869 interface ERC721A__IERC721Receiver {
870     function onERC721Received(
871         address operator,
872         address from,
873         uint256 tokenId,
874         bytes calldata data
875     ) external returns (bytes4);
876 }
877 
878 /**
879  * @title ERC721A
880  *
881  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
882  * Non-Fungible Token Standard, including the Metadata extension.
883  * Optimized for lower gas during batch mints.
884  *
885  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
886  * starting from `_startTokenId()`.
887  *
888  * Assumptions:
889  *
890  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
891  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
892  */
893 contract ERC721A is IERC721A {
894     // Reference type for token approval.
895     struct TokenApprovalRef {
896         address value;
897     }
898 
899     // =============================================================
900     //                           CONSTANTS
901     // =============================================================
902 
903     // Mask of an entry in packed address data.
904     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
905 
906     // The bit position of `numberMinted` in packed address data.
907     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
908 
909     // The bit position of `numberBurned` in packed address data.
910     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
911 
912     // The bit position of `aux` in packed address data.
913     uint256 private constant _BITPOS_AUX = 192;
914 
915     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
916     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
917 
918     // The bit position of `startTimestamp` in packed ownership.
919     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
920 
921     // The bit mask of the `burned` bit in packed ownership.
922     uint256 private constant _BITMASK_BURNED = 1 << 224;
923 
924     // The bit position of the `nextInitialized` bit in packed ownership.
925     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
926 
927     // The bit mask of the `nextInitialized` bit in packed ownership.
928     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
929 
930     // The bit position of `extraData` in packed ownership.
931     uint256 private constant _BITPOS_EXTRA_DATA = 232;
932 
933     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
934     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
935 
936     // The mask of the lower 160 bits for addresses.
937     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
938 
939     // The maximum `quantity` that can be minted with {_mintERC2309}.
940     // This limit is to prevent overflows on the address data entries.
941     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
942     // is required to cause an overflow, which is unrealistic.
943     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
944 
945     // The `Transfer` event signature is given by:
946     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
947     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
948         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
949 
950     // =============================================================
951     //                            STORAGE
952     // =============================================================
953 
954     // The next token ID to be minted.
955     uint256 private _currentIndex;
956 
957     // The number of tokens burned.
958     uint256 private _burnCounter;
959 
960     // Token name
961     string private _name;
962 
963     // Token symbol
964     string private _symbol;
965 
966     // Mapping from token ID to ownership details
967     // An empty struct value does not necessarily mean the token is unowned.
968     // See {_packedOwnershipOf} implementation for details.
969     //
970     // Bits Layout:
971     // - [0..159]   `addr`
972     // - [160..223] `startTimestamp`
973     // - [224]      `burned`
974     // - [225]      `nextInitialized`
975     // - [232..255] `extraData`
976     mapping(uint256 => uint256) private _packedOwnerships;
977 
978     // Mapping owner address to address data.
979     //
980     // Bits Layout:
981     // - [0..63]    `balance`
982     // - [64..127]  `numberMinted`
983     // - [128..191] `numberBurned`
984     // - [192..255] `aux`
985     mapping(address => uint256) private _packedAddressData;
986 
987     // Mapping from token ID to approved address.
988     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
989 
990     // Mapping from owner to operator approvals
991     mapping(address => mapping(address => bool)) private _operatorApprovals;
992 
993     // =============================================================
994     //                          CONSTRUCTOR
995     // =============================================================
996 
997     constructor(string memory name_, string memory symbol_) {
998         _name = name_;
999         _symbol = symbol_;
1000         _currentIndex = _startTokenId();
1001     }
1002 
1003     // =============================================================
1004     //                   TOKEN COUNTING OPERATIONS
1005     // =============================================================
1006 
1007     /**
1008      * @dev Returns the starting token ID.
1009      * To change the starting token ID, please override this function.
1010      */
1011     function _startTokenId() internal view virtual returns (uint256) {
1012         return 1;
1013     }
1014 
1015     /**
1016      * @dev Returns the next token ID to be minted.
1017      */
1018     function _nextTokenId() internal view virtual returns (uint256) {
1019         return _currentIndex;
1020     }
1021 
1022     /**
1023      * @dev Returns the total number of tokens in existence.
1024      * Burned tokens will reduce the count.
1025      * To get the total number of tokens minted, please see {_totalMinted}.
1026      */
1027     function totalSupply() public view virtual override returns (uint256) {
1028         // Counter underflow is impossible as _burnCounter cannot be incremented
1029         // more than `_currentIndex - _startTokenId()` times.
1030         unchecked {
1031             return _currentIndex - _burnCounter - _startTokenId();
1032         }
1033     }
1034 
1035     /**
1036      * @dev Returns the total amount of tokens minted in the contract.
1037      */
1038     function _totalMinted() internal view virtual returns (uint256) {
1039         // Counter underflow is impossible as `_currentIndex` does not decrement,
1040         // and it is initialized to `_startTokenId()`.
1041         unchecked {
1042             return _currentIndex - _startTokenId();
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns the total number of tokens burned.
1048      */
1049     function _totalBurned() internal view virtual returns (uint256) {
1050         return _burnCounter;
1051     }
1052 
1053     // =============================================================
1054     //                    ADDRESS DATA OPERATIONS
1055     // =============================================================
1056 
1057     /**
1058      * @dev Returns the number of tokens in `owner`'s account.
1059      */
1060     function balanceOf(address owner) public view virtual override returns (uint256) {
1061         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1062         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1063     }
1064 
1065     /**
1066      * Returns the number of tokens minted by `owner`.
1067      */
1068     function _numberMinted(address owner) internal view returns (uint256) {
1069         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1070     }
1071 
1072     /**
1073      * Returns the number of tokens burned by or on behalf of `owner`.
1074      */
1075     function _numberBurned(address owner) internal view returns (uint256) {
1076         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1077     }
1078 
1079     /**
1080      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1081      */
1082     function _getAux(address owner) internal view returns (uint64) {
1083         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1084     }
1085 
1086     /**
1087      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1088      * If there are multiple variables, please pack them into a uint64.
1089      */
1090     function _setAux(address owner, uint64 aux) internal virtual {
1091         uint256 packed = _packedAddressData[owner];
1092         uint256 auxCasted;
1093         // Cast `aux` with assembly to avoid redundant masking.
1094         assembly {
1095             auxCasted := aux
1096         }
1097         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1098         _packedAddressData[owner] = packed;
1099     }
1100 
1101     // =============================================================
1102     //                            IERC165
1103     // =============================================================
1104 
1105     /**
1106      * @dev Returns true if this contract implements the interface defined by
1107      * `interfaceId`. See the corresponding
1108      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1109      * to learn more about how these ids are created.
1110      *
1111      * This function call must use less than 30000 gas.
1112      */
1113     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1114         // The interface IDs are constants representing the first 4 bytes
1115         // of the XOR of all function selectors in the interface.
1116         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1117         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1118         return
1119             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1120             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1121             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1122     }
1123 
1124     // =============================================================
1125     //                        IERC721Metadata
1126     // =============================================================
1127 
1128     /**
1129      * @dev Returns the token collection name.
1130      */
1131     function name() public view virtual override returns (string memory) {
1132         return _name;
1133     }
1134 
1135     /**
1136      * @dev Returns the token collection symbol.
1137      */
1138     function symbol() public view virtual override returns (string memory) {
1139         return _symbol;
1140     }
1141 
1142     /**
1143      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1144      */
1145     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1146         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1147 
1148         string memory baseURI = _baseURI();
1149         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1150     }
1151 
1152     /**
1153      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1154      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1155      * by default, it can be overridden in child contracts.
1156      */
1157     function _baseURI() internal view virtual returns (string memory) {
1158         return '';
1159     }
1160 
1161     // =============================================================
1162     //                     OWNERSHIPS OPERATIONS
1163     // =============================================================
1164 
1165     /**
1166      * @dev Returns the owner of the `tokenId` token.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      */
1172     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1173         return address(uint160(_packedOwnershipOf(tokenId)));
1174     }
1175 
1176     /**
1177      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1178      * It gradually moves to O(1) as tokens get transferred around over time.
1179      */
1180     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1181         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1182     }
1183 
1184     /**
1185      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1186      */
1187     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1188         return _unpackedOwnership(_packedOwnerships[index]);
1189     }
1190 
1191     /**
1192      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1193      */
1194     function _initializeOwnershipAt(uint256 index) internal virtual {
1195         if (_packedOwnerships[index] == 0) {
1196             _packedOwnerships[index] = _packedOwnershipOf(index);
1197         }
1198     }
1199 
1200     /**
1201      * Returns the packed ownership data of `tokenId`.
1202      */
1203     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1204         uint256 curr = tokenId;
1205 
1206         unchecked {
1207             if (_startTokenId() <= curr)
1208                 if (curr < _currentIndex) {
1209                     uint256 packed = _packedOwnerships[curr];
1210                     // If not burned.
1211                     if (packed & _BITMASK_BURNED == 0) {
1212                         // Invariant:
1213                         // There will always be an initialized ownership slot
1214                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1215                         // before an unintialized ownership slot
1216                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1217                         // Hence, `curr` will not underflow.
1218                         //
1219                         // We can directly compare the packed value.
1220                         // If the address is zero, packed will be zero.
1221                         while (packed == 0) {
1222                             packed = _packedOwnerships[--curr];
1223                         }
1224                         return packed;
1225                     }
1226                 }
1227         }
1228         revert OwnerQueryForNonexistentToken();
1229     }
1230 
1231     /**
1232      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1233      */
1234     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1235         ownership.addr = address(uint160(packed));
1236         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1237         ownership.burned = packed & _BITMASK_BURNED != 0;
1238         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1239     }
1240 
1241     /**
1242      * @dev Packs ownership data into a single uint256.
1243      */
1244     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1245         assembly {
1246             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1247             owner := and(owner, _BITMASK_ADDRESS)
1248             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1249             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1250         }
1251     }
1252 
1253     /**
1254      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1255      */
1256     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1257         // For branchless setting of the `nextInitialized` flag.
1258         assembly {
1259             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1260             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1261         }
1262     }
1263 
1264     // =============================================================
1265     //                      APPROVAL OPERATIONS
1266     // =============================================================
1267 
1268     /**
1269      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1270      * The approval is cleared when the token is transferred.
1271      *
1272      * Only a single account can be approved at a time, so approving the
1273      * zero address clears previous approvals.
1274      *
1275      * Requirements:
1276      *
1277      * - The caller must own the token or be an approved operator.
1278      * - `tokenId` must exist.
1279      *
1280      * Emits an {Approval} event.
1281      */
1282     function approve(address to, uint256 tokenId) public virtual override {
1283         address owner = ownerOf(tokenId);
1284 
1285         if (_msgSenderERC721A() != owner)
1286             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1287                 revert ApprovalCallerNotOwnerNorApproved();
1288             }
1289 
1290         _tokenApprovals[tokenId].value = to;
1291         emit Approval(owner, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Returns the account approved for `tokenId` token.
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must exist.
1300      */
1301     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1302         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1303 
1304         return _tokenApprovals[tokenId].value;
1305     }
1306 
1307     /**
1308      * @dev Approve or remove `operator` as an operator for the caller.
1309      * Operators can call {transferFrom} or {safeTransferFrom}
1310      * for any token owned by the caller.
1311      *
1312      * Requirements:
1313      *
1314      * - The `operator` cannot be the caller.
1315      *
1316      * Emits an {ApprovalForAll} event.
1317      */
1318     function setApprovalForAll(address operator, bool approved) public virtual override {
1319         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1320 
1321         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1322         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1323     }
1324 
1325     /**
1326      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1327      *
1328      * See {setApprovalForAll}.
1329      */
1330     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1331         return _operatorApprovals[owner][operator];
1332     }
1333 
1334     /**
1335      * @dev Returns whether `tokenId` exists.
1336      *
1337      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1338      *
1339      * Tokens start existing when they are minted. See {_mint}.
1340      */
1341     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1342         return
1343             _startTokenId() <= tokenId &&
1344             tokenId < _currentIndex && // If within bounds,
1345             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1346     }
1347 
1348     /**
1349      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1350      */
1351     function _isSenderApprovedOrOwner(
1352         address approvedAddress,
1353         address owner,
1354         address msgSender
1355     ) private pure returns (bool result) {
1356         assembly {
1357             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1358             owner := and(owner, _BITMASK_ADDRESS)
1359             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1360             msgSender := and(msgSender, _BITMASK_ADDRESS)
1361             // `msgSender == owner || msgSender == approvedAddress`.
1362             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1363         }
1364     }
1365 
1366     /**
1367      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1368      */
1369     function _getApprovedSlotAndAddress(uint256 tokenId)
1370         private
1371         view
1372         returns (uint256 approvedAddressSlot, address approvedAddress)
1373     {
1374         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1375         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1376         assembly {
1377             approvedAddressSlot := tokenApproval.slot
1378             approvedAddress := sload(approvedAddressSlot)
1379         }
1380     }
1381 
1382     // =============================================================
1383     //                      TRANSFER OPERATIONS
1384     // =============================================================
1385 
1386     /**
1387      * @dev Transfers `tokenId` from `from` to `to`.
1388      *
1389      * Requirements:
1390      *
1391      * - `from` cannot be the zero address.
1392      * - `to` cannot be the zero address.
1393      * - `tokenId` token must be owned by `from`.
1394      * - If the caller is not `from`, it must be approved to move this token
1395      * by either {approve} or {setApprovalForAll}.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function transferFrom(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) public virtual override {
1404         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1405 
1406         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1407 
1408         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1409 
1410         // The nested ifs save around 20+ gas over a compound boolean condition.
1411         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1412             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1413 
1414         if (to == address(0)) revert TransferToZeroAddress();
1415 
1416         _beforeTokenTransfers(from, to, tokenId, 1);
1417 
1418         // Clear approvals from the previous owner.
1419         assembly {
1420             if approvedAddress {
1421                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1422                 sstore(approvedAddressSlot, 0)
1423             }
1424         }
1425 
1426         // Underflow of the sender's balance is impossible because we check for
1427         // ownership above and the recipient's balance can't realistically overflow.
1428         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1429         unchecked {
1430             // We can directly increment and decrement the balances.
1431             --_packedAddressData[from]; // Updates: `balance -= 1`.
1432             ++_packedAddressData[to]; // Updates: `balance += 1`.
1433 
1434             // Updates:
1435             // - `address` to the next owner.
1436             // - `startTimestamp` to the timestamp of transfering.
1437             // - `burned` to `false`.
1438             // - `nextInitialized` to `true`.
1439             _packedOwnerships[tokenId] = _packOwnershipData(
1440                 to,
1441                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1442             );
1443 
1444             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1445             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1446                 uint256 nextTokenId = tokenId + 1;
1447                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1448                 if (_packedOwnerships[nextTokenId] == 0) {
1449                     // If the next slot is within bounds.
1450                     if (nextTokenId != _currentIndex) {
1451                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1452                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1453                     }
1454                 }
1455             }
1456         }
1457 
1458         emit Transfer(from, to, tokenId);
1459         _afterTokenTransfers(from, to, tokenId, 1);
1460     }
1461 
1462     /**
1463      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1464      */
1465     function safeTransferFrom(
1466         address from,
1467         address to,
1468         uint256 tokenId
1469     ) public virtual override {
1470         safeTransferFrom(from, to, tokenId, '');
1471     }
1472 
1473     /**
1474      * @dev Safely transfers `tokenId` token from `from` to `to`.
1475      *
1476      * Requirements:
1477      *
1478      * - `from` cannot be the zero address.
1479      * - `to` cannot be the zero address.
1480      * - `tokenId` token must exist and be owned by `from`.
1481      * - If the caller is not `from`, it must be approved to move this token
1482      * by either {approve} or {setApprovalForAll}.
1483      * - If `to` refers to a smart contract, it must implement
1484      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function safeTransferFrom(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) public virtual override {
1494         transferFrom(from, to, tokenId);
1495         if (to.code.length != 0)
1496             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1497                 revert TransferToNonERC721ReceiverImplementer();
1498             }
1499     }
1500 
1501     /**
1502      * @dev Hook that is called before a set of serially-ordered token IDs
1503      * are about to be transferred. This includes minting.
1504      * And also called before burning one token.
1505      *
1506      * `startTokenId` - the first token ID to be transferred.
1507      * `quantity` - the amount to be transferred.
1508      *
1509      * Calling conditions:
1510      *
1511      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1512      * transferred to `to`.
1513      * - When `from` is zero, `tokenId` will be minted for `to`.
1514      * - When `to` is zero, `tokenId` will be burned by `from`.
1515      * - `from` and `to` are never both zero.
1516      */
1517     function _beforeTokenTransfers(
1518         address from,
1519         address to,
1520         uint256 startTokenId,
1521         uint256 quantity
1522     ) internal virtual {}
1523 
1524     /**
1525      * @dev Hook that is called after a set of serially-ordered token IDs
1526      * have been transferred. This includes minting.
1527      * And also called after one token has been burned.
1528      *
1529      * `startTokenId` - the first token ID to be transferred.
1530      * `quantity` - the amount to be transferred.
1531      *
1532      * Calling conditions:
1533      *
1534      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1535      * transferred to `to`.
1536      * - When `from` is zero, `tokenId` has been minted for `to`.
1537      * - When `to` is zero, `tokenId` has been burned by `from`.
1538      * - `from` and `to` are never both zero.
1539      */
1540     function _afterTokenTransfers(
1541         address from,
1542         address to,
1543         uint256 startTokenId,
1544         uint256 quantity
1545     ) internal virtual {}
1546 
1547     /**
1548      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1549      *
1550      * `from` - Previous owner of the given token ID.
1551      * `to` - Target address that will receive the token.
1552      * `tokenId` - Token ID to be transferred.
1553      * `_data` - Optional data to send along with the call.
1554      *
1555      * Returns whether the call correctly returned the expected magic value.
1556      */
1557     function _checkContractOnERC721Received(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory _data
1562     ) private returns (bool) {
1563         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1564             bytes4 retval
1565         ) {
1566             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1567         } catch (bytes memory reason) {
1568             if (reason.length == 0) {
1569                 revert TransferToNonERC721ReceiverImplementer();
1570             } else {
1571                 assembly {
1572                     revert(add(32, reason), mload(reason))
1573                 }
1574             }
1575         }
1576     }
1577 
1578     // =============================================================
1579     //                        MINT OPERATIONS
1580     // =============================================================
1581 
1582     /**
1583      * @dev Mints `quantity` tokens and transfers them to `to`.
1584      *
1585      * Requirements:
1586      *
1587      * - `to` cannot be the zero address.
1588      * - `quantity` must be greater than 0.
1589      *
1590      * Emits a {Transfer} event for each mint.
1591      */
1592     function _mint(address to, uint256 quantity) internal virtual {
1593         uint256 startTokenId = _currentIndex;
1594         if (quantity == 0) revert MintZeroQuantity();
1595 
1596         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1597 
1598         // Overflows are incredibly unrealistic.
1599         // `balance` and `numberMinted` have a maximum limit of 2**64.
1600         // `tokenId` has a maximum limit of 2**256.
1601         unchecked {
1602             // Updates:
1603             // - `balance += quantity`.
1604             // - `numberMinted += quantity`.
1605             //
1606             // We can directly add to the `balance` and `numberMinted`.
1607             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1608 
1609             // Updates:
1610             // - `address` to the owner.
1611             // - `startTimestamp` to the timestamp of minting.
1612             // - `burned` to `false`.
1613             // - `nextInitialized` to `quantity == 1`.
1614             _packedOwnerships[startTokenId] = _packOwnershipData(
1615                 to,
1616                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1617             );
1618 
1619             uint256 toMasked;
1620             uint256 end = startTokenId + quantity;
1621 
1622             // Use assembly to loop and emit the `Transfer` event for gas savings.
1623             assembly {
1624                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1625                 toMasked := and(to, _BITMASK_ADDRESS)
1626                 // Emit the `Transfer` event.
1627                 log4(
1628                     0, // Start of data (0, since no data).
1629                     0, // End of data (0, since no data).
1630                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1631                     0, // `address(0)`.
1632                     toMasked, // `to`.
1633                     startTokenId // `tokenId`.
1634                 )
1635 
1636                 for {
1637                     let tokenId := add(startTokenId, 1)
1638                 } iszero(eq(tokenId, end)) {
1639                     tokenId := add(tokenId, 1)
1640                 } {
1641                     // Emit the `Transfer` event. Similar to above.
1642                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1643                 }
1644             }
1645             if (toMasked == 0) revert MintToZeroAddress();
1646 
1647             _currentIndex = end;
1648         }
1649         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1650     }
1651 
1652     /**
1653      * @dev Mints `quantity` tokens and transfers them to `to`.
1654      *
1655      * This function is intended for efficient minting only during contract creation.
1656      *
1657      * It emits only one {ConsecutiveTransfer} as defined in
1658      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1659      * instead of a sequence of {Transfer} event(s).
1660      *
1661      * Calling this function outside of contract creation WILL make your contract
1662      * non-compliant with the ERC721 standard.
1663      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1664      * {ConsecutiveTransfer} event is only permissible during contract creation.
1665      *
1666      * Requirements:
1667      *
1668      * - `to` cannot be the zero address.
1669      * - `quantity` must be greater than 0.
1670      *
1671      * Emits a {ConsecutiveTransfer} event.
1672      */
1673     function _mintERC2309(address to, uint256 quantity) internal virtual {
1674         uint256 startTokenId = _currentIndex;
1675         if (to == address(0)) revert MintToZeroAddress();
1676         if (quantity == 0) revert MintZeroQuantity();
1677         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1678 
1679         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1680 
1681         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1682         unchecked {
1683             // Updates:
1684             // - `balance += quantity`.
1685             // - `numberMinted += quantity`.
1686             //
1687             // We can directly add to the `balance` and `numberMinted`.
1688             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1689 
1690             // Updates:
1691             // - `address` to the owner.
1692             // - `startTimestamp` to the timestamp of minting.
1693             // - `burned` to `false`.
1694             // - `nextInitialized` to `quantity == 1`.
1695             _packedOwnerships[startTokenId] = _packOwnershipData(
1696                 to,
1697                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1698             );
1699 
1700             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1701 
1702             _currentIndex = startTokenId + quantity;
1703         }
1704         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1705     }
1706 
1707     /**
1708      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1709      *
1710      * Requirements:
1711      *
1712      * - If `to` refers to a smart contract, it must implement
1713      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1714      * - `quantity` must be greater than 0.
1715      *
1716      * See {_mint}.
1717      *
1718      * Emits a {Transfer} event for each mint.
1719      */
1720     function _safeMint(
1721         address to,
1722         uint256 quantity,
1723         bytes memory _data
1724     ) internal virtual {
1725         _mint(to, quantity);
1726 
1727         unchecked {
1728             if (to.code.length != 0) {
1729                 uint256 end = _currentIndex;
1730                 uint256 index = end - quantity;
1731                 do {
1732                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1733                         revert TransferToNonERC721ReceiverImplementer();
1734                     }
1735                 } while (index < end);
1736                 // Reentrancy protection.
1737                 if (_currentIndex != end) revert();
1738             }
1739         }
1740     }
1741 
1742     /**
1743      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1744      */
1745     function _safeMint(address to, uint256 quantity) internal virtual {
1746         _safeMint(to, quantity, '');
1747     }
1748 
1749     // =============================================================
1750     //                        BURN OPERATIONS
1751     // =============================================================
1752 
1753     /**
1754      * @dev Equivalent to `_burn(tokenId, false)`.
1755      */
1756     function _burn(uint256 tokenId) internal virtual {
1757         _burn(tokenId, false);
1758     }
1759 
1760     /**
1761      * @dev Destroys `tokenId`.
1762      * The approval is cleared when the token is burned.
1763      *
1764      * Requirements:
1765      *
1766      * - `tokenId` must exist.
1767      *
1768      * Emits a {Transfer} event.
1769      */
1770     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1771         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1772 
1773         address from = address(uint160(prevOwnershipPacked));
1774 
1775         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1776 
1777         if (approvalCheck) {
1778             // The nested ifs save around 20+ gas over a compound boolean condition.
1779             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1780                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1781         }
1782 
1783         _beforeTokenTransfers(from, address(0), tokenId, 1);
1784 
1785         // Clear approvals from the previous owner.
1786         assembly {
1787             if approvedAddress {
1788                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1789                 sstore(approvedAddressSlot, 0)
1790             }
1791         }
1792 
1793         // Underflow of the sender's balance is impossible because we check for
1794         // ownership above and the recipient's balance can't realistically overflow.
1795         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1796         unchecked {
1797             // Updates:
1798             // - `balance -= 1`.
1799             // - `numberBurned += 1`.
1800             //
1801             // We can directly decrement the balance, and increment the number burned.
1802             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1803             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1804 
1805             // Updates:
1806             // - `address` to the last owner.
1807             // - `startTimestamp` to the timestamp of burning.
1808             // - `burned` to `true`.
1809             // - `nextInitialized` to `true`.
1810             _packedOwnerships[tokenId] = _packOwnershipData(
1811                 from,
1812                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1813             );
1814 
1815             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1816             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1817                 uint256 nextTokenId = tokenId + 1;
1818                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1819                 if (_packedOwnerships[nextTokenId] == 0) {
1820                     // If the next slot is within bounds.
1821                     if (nextTokenId != _currentIndex) {
1822                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1823                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1824                     }
1825                 }
1826             }
1827         }
1828 
1829         emit Transfer(from, address(0), tokenId);
1830         _afterTokenTransfers(from, address(0), tokenId, 1);
1831 
1832         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1833         unchecked {
1834             _burnCounter++;
1835         }
1836     }
1837 
1838     // =============================================================
1839     //                     EXTRA DATA OPERATIONS
1840     // =============================================================
1841 
1842     /**
1843      * @dev Directly sets the extra data for the ownership data `index`.
1844      */
1845     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1846         uint256 packed = _packedOwnerships[index];
1847         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1848         uint256 extraDataCasted;
1849         // Cast `extraData` with assembly to avoid redundant masking.
1850         assembly {
1851             extraDataCasted := extraData
1852         }
1853         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1854         _packedOwnerships[index] = packed;
1855     }
1856 
1857     /**
1858      * @dev Called during each token transfer to set the 24bit `extraData` field.
1859      * Intended to be overridden by the cosumer contract.
1860      *
1861      * `previousExtraData` - the value of `extraData` before transfer.
1862      *
1863      * Calling conditions:
1864      *
1865      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1866      * transferred to `to`.
1867      * - When `from` is zero, `tokenId` will be minted for `to`.
1868      * - When `to` is zero, `tokenId` will be burned by `from`.
1869      * - `from` and `to` are never both zero.
1870      */
1871     function _extraData(
1872         address from,
1873         address to,
1874         uint24 previousExtraData
1875     ) internal view virtual returns (uint24) {}
1876 
1877     /**
1878      * @dev Returns the next extra data for the packed ownership data.
1879      * The returned result is shifted into position.
1880      */
1881     function _nextExtraData(
1882         address from,
1883         address to,
1884         uint256 prevOwnershipPacked
1885     ) private view returns (uint256) {
1886         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1887         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1888     }
1889 
1890     // =============================================================
1891     //                       OTHER OPERATIONS
1892     // =============================================================
1893 
1894     /**
1895      * @dev Returns the message sender (defaults to `msg.sender`).
1896      *
1897      * If you are writing GSN compatible contracts, you need to override this function.
1898      */
1899     function _msgSenderERC721A() internal view virtual returns (address) {
1900         return msg.sender;
1901     }
1902 
1903     /**
1904      * @dev Converts a uint256 to its ASCII string decimal representation.
1905      */
1906     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1907         assembly {
1908             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1909             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1910             // We will need 1 32-byte word to store the length,
1911             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1912             ptr := add(mload(0x40), 128)
1913             // Update the free memory pointer to allocate.
1914             mstore(0x40, ptr)
1915 
1916             // Cache the end of the memory to calculate the length later.
1917             let end := ptr
1918 
1919             // We write the string from the rightmost digit to the leftmost digit.
1920             // The following is essentially a do-while loop that also handles the zero case.
1921             // Costs a bit more than early returning for the zero case,
1922             // but cheaper in terms of deployment and overall runtime costs.
1923             for {
1924                 // Initialize and perform the first pass without check.
1925                 let temp := value
1926                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1927                 ptr := sub(ptr, 1)
1928                 // Write the character to the pointer.
1929                 // The ASCII index of the '0' character is 48.
1930                 mstore8(ptr, add(48, mod(temp, 10)))
1931                 temp := div(temp, 10)
1932             } temp {
1933                 // Keep dividing `temp` until zero.
1934                 temp := div(temp, 10)
1935             } {
1936                 // Body of the for loop.
1937                 ptr := sub(ptr, 1)
1938                 mstore8(ptr, add(48, mod(temp, 10)))
1939             }
1940 
1941             let length := sub(end, ptr)
1942             // Move the pointer 32 bytes leftwards to make room for the length.
1943             ptr := sub(ptr, 32)
1944             // Store the length.
1945             mstore(ptr, length)
1946         }
1947     }
1948 }
1949 
1950 interface IERC721AQueryable is IERC721A {
1951     /**
1952      * Invalid query range (`start` >= `stop`).
1953      */
1954     error InvalidQueryRange();
1955 
1956     /**
1957      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1958      *
1959      * If the `tokenId` is out of bounds:
1960      *
1961      * - `addr = address(0)`
1962      * - `startTimestamp = 0`
1963      * - `burned = false`
1964      * - `extraData = 0`
1965      *
1966      * If the `tokenId` is burned:
1967      *
1968      * - `addr = <Address of owner before token was burned>`
1969      * - `startTimestamp = <Timestamp when token was burned>`
1970      * - `burned = true`
1971      * - `extraData = <Extra data when token was burned>`
1972      *
1973      * Otherwise:
1974      *
1975      * - `addr = <Address of owner>`
1976      * - `startTimestamp = <Timestamp of start of ownership>`
1977      * - `burned = false`
1978      * - `extraData = <Extra data at start of ownership>`
1979      */
1980     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1981 
1982     /**
1983      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1984      * See {ERC721AQueryable-explicitOwnershipOf}
1985      */
1986     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1987 
1988     /**
1989      * @dev Returns an array of token IDs owned by `owner`,
1990      * in the range [`start`, `stop`)
1991      * (i.e. `start <= tokenId < stop`).
1992      *
1993      * This function allows for tokens to be queried if the collection
1994      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1995      *
1996      * Requirements:
1997      *
1998      * - `start < stop`
1999      */
2000     function tokensOfOwnerIn(
2001         address owner,
2002         uint256 start,
2003         uint256 stop
2004     ) external view returns (uint256[] memory);
2005 
2006     /**
2007      * @dev Returns an array of token IDs owned by `owner`.
2008      *
2009      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2010      * It is meant to be called off-chain.
2011      *
2012      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2013      * multiple smaller scans if the collection is large enough to cause
2014      * an out-of-gas error (10K collections should be fine).
2015      */
2016     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2017 }
2018 
2019 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2020     /**
2021      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2022      *
2023      * If the `tokenId` is out of bounds:
2024      *
2025      * - `addr = address(0)`
2026      * - `startTimestamp = 0`
2027      * - `burned = false`
2028      * - `extraData = 0`
2029      *
2030      * If the `tokenId` is burned:
2031      *
2032      * - `addr = <Address of owner before token was burned>`
2033      * - `startTimestamp = <Timestamp when token was burned>`
2034      * - `burned = true`
2035      * - `extraData = <Extra data when token was burned>`
2036      *
2037      * Otherwise:
2038      *
2039      * - `addr = <Address of owner>`
2040      * - `startTimestamp = <Timestamp of start of ownership>`
2041      * - `burned = false`
2042      * - `extraData = <Extra data at start of ownership>`
2043      */
2044     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2045         TokenOwnership memory ownership;
2046         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2047             return ownership;
2048         }
2049         ownership = _ownershipAt(tokenId);
2050         if (ownership.burned) {
2051             return ownership;
2052         }
2053         return _ownershipOf(tokenId);
2054     }
2055 
2056     /**
2057      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2058      * See {ERC721AQueryable-explicitOwnershipOf}
2059      */
2060     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2061         external
2062         view
2063         virtual
2064         override
2065         returns (TokenOwnership[] memory)
2066     {
2067         unchecked {
2068             uint256 tokenIdsLength = tokenIds.length;
2069             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2070             for (uint256 i; i != tokenIdsLength; ++i) {
2071                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2072             }
2073             return ownerships;
2074         }
2075     }
2076 
2077     /**
2078      * @dev Returns an array of token IDs owned by `owner`,
2079      * in the range [`start`, `stop`)
2080      * (i.e. `start <= tokenId < stop`).
2081      *
2082      * This function allows for tokens to be queried if the collection
2083      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2084      *
2085      * Requirements:
2086      *
2087      * - `start < stop`
2088      */
2089     function tokensOfOwnerIn(
2090         address owner,
2091         uint256 start,
2092         uint256 stop
2093     ) external view virtual override returns (uint256[] memory) {
2094         unchecked {
2095             if (start >= stop) revert InvalidQueryRange();
2096             uint256 tokenIdsIdx;
2097             uint256 stopLimit = _nextTokenId();
2098             // Set `start = max(start, _startTokenId())`.
2099             if (start < _startTokenId()) {
2100                 start = _startTokenId();
2101             }
2102             // Set `stop = min(stop, stopLimit)`.
2103             if (stop > stopLimit) {
2104                 stop = stopLimit;
2105             }
2106             uint256 tokenIdsMaxLength = balanceOf(owner);
2107             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2108             // to cater for cases where `balanceOf(owner)` is too big.
2109             if (start < stop) {
2110                 uint256 rangeLength = stop - start;
2111                 if (rangeLength < tokenIdsMaxLength) {
2112                     tokenIdsMaxLength = rangeLength;
2113                 }
2114             } else {
2115                 tokenIdsMaxLength = 0;
2116             }
2117             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2118             if (tokenIdsMaxLength == 0) {
2119                 return tokenIds;
2120             }
2121             // We need to call `explicitOwnershipOf(start)`,
2122             // because the slot at `start` may not be initialized.
2123             TokenOwnership memory ownership = explicitOwnershipOf(start);
2124             address currOwnershipAddr;
2125             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2126             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2127             if (!ownership.burned) {
2128                 currOwnershipAddr = ownership.addr;
2129             }
2130             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2131                 ownership = _ownershipAt(i);
2132                 if (ownership.burned) {
2133                     continue;
2134                 }
2135                 if (ownership.addr != address(0)) {
2136                     currOwnershipAddr = ownership.addr;
2137                 }
2138                 if (currOwnershipAddr == owner) {
2139                     tokenIds[tokenIdsIdx++] = i;
2140                 }
2141             }
2142             // Downsize the array to fit.
2143             assembly {
2144                 mstore(tokenIds, tokenIdsIdx)
2145             }
2146             return tokenIds;
2147         }
2148     }
2149 
2150     /**
2151      * @dev Returns an array of token IDs owned by `owner`.
2152      *
2153      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2154      * It is meant to be called off-chain.
2155      *
2156      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2157      * multiple smaller scans if the collection is large enough to cause
2158      * an out-of-gas error (10K collections should be fine).
2159      */
2160     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2161         unchecked {
2162             uint256 tokenIdsIdx;
2163             address currOwnershipAddr;
2164             uint256 tokenIdsLength = balanceOf(owner);
2165             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2166             TokenOwnership memory ownership;
2167             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2168                 ownership = _ownershipAt(i);
2169                 if (ownership.burned) {
2170                     continue;
2171                 }
2172                 if (ownership.addr != address(0)) {
2173                     currOwnershipAddr = ownership.addr;
2174                 }
2175                 if (currOwnershipAddr == owner) {
2176                     tokenIds[tokenIdsIdx++] = i;
2177                 }
2178             }
2179             return tokenIds;
2180         }
2181     }
2182 }
2183 
2184 contract BlurFarmers is Ownable, ERC721A, ERC721AQueryable {
2185 
2186     using Strings for uint;
2187 
2188     enum Step {
2189         Before,
2190         PublicSale,
2191         SoldOut,
2192         Reveal
2193     }
2194 
2195     string public baseURI;
2196 
2197     Step public sellingStep;
2198 
2199     uint private constant MAX_PUBLIC = 1250;
2200 
2201     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
2202 
2203     uint public maxMintAmountPerPublic = 2;
2204 
2205     uint private teamLength;
2206 
2207     constructor(string memory _baseURI) ERC721A("Blur Farmers", "BF"){
2208         baseURI = _baseURI;
2209     }
2210 
2211     function mintForOpensea() external onlyOwner{
2212         if(totalSupply() != 0) revert("Only 1 mint for deployer");
2213         _mint(msg.sender, 1);
2214     }
2215 
2216     function publicSaleMint(uint _quantity) external  {
2217         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2218         if(totalSupply() + _quantity > (MAX_PUBLIC)) revert("Max supply exceeded for public exceeded");
2219         if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("Max exceeded");
2220         _mint(msg.sender, _quantity);
2221         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
2222     }
2223 
2224     function currentState() external view returns (Step, uint) {
2225         return (sellingStep, maxMintAmountPerPublic);
2226     }
2227 
2228     function setBaseUri(string memory _baseURI) external onlyOwner {
2229         baseURI = _baseURI;
2230     }
2231 
2232     function setStep(uint _step) external onlyOwner {
2233         sellingStep = Step(_step);
2234     }
2235 
2236     function setMaxMintPerPublic(uint amount) external onlyOwner{
2237         maxMintAmountPerPublic = amount;
2238     }
2239 
2240     function getNumberMinted(address account) external view returns (uint256) {
2241         return _numberMinted(account);
2242     }
2243 
2244     function getNumberPublicMinted(address account) external view returns (uint256) {
2245         return mintedAmountNFTsperWalletPublicSale[account];
2246     }
2247 
2248     function tokenURI(uint _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2249         require(_exists(_tokenId), "URI query for nonexistent token");
2250         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2251     }
2252 }