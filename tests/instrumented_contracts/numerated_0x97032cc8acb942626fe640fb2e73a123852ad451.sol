1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&##BBGGGGGGGGBB#&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGGGGGGGGGGGGGGGGGGG#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGGGGGGGGGGGGGGGGGGGGGG#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BGGGGGGGGGGGGGGGGGGGGGGGGGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 &&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BGGGGGGGGGGGGGGGGGGGGGGGGGGGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 #YJ5PGBB##&&@@@@@@@@@@@@@@@@@@@@@@BPGGGGGGGGGGGGGGGGGGGGGGGGGGGGPB@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&@&G5
11 @@#GP55YYJYJYYYY55PPGGBBB###&&&&&&BGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB&&&#BG&&&&@&&#&#&#&B&B&B&#@#@#&&#G
12 @@@@@@@@@@&&##BBGGPP55YYYYJJJJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJ??YJJ#@&#&#&#@&@&@&@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&BPPP555555555555YYYYYY55555555555B##&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&BGGGGGGGGGGGGGGGGGGGGGGGGGGGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BGGGGGGGGGGGGGGGGGGGGGGGGGGB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGGGGGGGGGGGGGGGGGGGGGG&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGGGGGGGGGGGGGGGGGGB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#BGGBGGGGGGBBB#&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                    
21                                            
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      *
42      * [IMPORTANT]
43      * ====
44      * You shouldn't rely on `isContract` to protect against flash loan attacks!
45      *
46      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
47      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
48      * constructor.
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize/address.code.length, which returns 0
53         // for contracts in construction, since the code is only stored at the end
54         // of the constructor execution.
55 
56         return account.code.length > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain `call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227                 /// @solidity memory-safe-assembly
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 interface IERC721A {
250     /**
251      * The caller must own the token or be an approved operator.
252      */
253     error ApprovalCallerNotOwnerNorApproved();
254 
255     /**
256      * The token does not exist.
257      */
258     error ApprovalQueryForNonexistentToken();
259 
260     /**
261      * The caller cannot approve to their own address.
262      */
263     error ApproveToCaller();
264 
265     /**
266      * Cannot query the balance for the zero address.
267      */
268     error BalanceQueryForZeroAddress();
269 
270     /**
271      * Cannot mint to the zero address.
272      */
273     error MintToZeroAddress();
274 
275     /**
276      * The quantity of tokens minted must be more than zero.
277      */
278     error MintZeroQuantity();
279 
280     /**
281      * The token does not exist.
282      */
283     error OwnerQueryForNonexistentToken();
284 
285     /**
286      * The caller must own the token or be an approved operator.
287      */
288     error TransferCallerNotOwnerNorApproved();
289 
290     /**
291      * The token must be owned by `from`.
292      */
293     error TransferFromIncorrectOwner();
294 
295     /**
296      * Cannot safely transfer to a contract that does not implement the
297      * ERC721Receiver interface.
298      */
299     error TransferToNonERC721ReceiverImplementer();
300 
301     /**
302      * Cannot transfer to the zero address.
303      */
304     error TransferToZeroAddress();
305 
306     /**
307      * The token does not exist.
308      */
309     error URIQueryForNonexistentToken();
310 
311     /**
312      * The `quantity` minted with ERC2309 exceeds the safety limit.
313      */
314     error MintERC2309QuantityExceedsLimit();
315 
316     /**
317      * The `extraData` cannot be set on an unintialized ownership slot.
318      */
319     error OwnershipNotInitializedForExtraData();
320 
321     // =============================================================
322     //                            STRUCTS
323     // =============================================================
324 
325     struct TokenOwnership {
326         // The address of the owner.
327         address addr;
328         // Stores the start time of ownership with minimal overhead for tokenomics.
329         uint64 startTimestamp;
330         // Whether the token has been burned.
331         bool burned;
332         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
333         uint24 extraData;
334     }
335 
336     // =============================================================
337     //                         TOKEN COUNTERS
338     // =============================================================
339 
340     /**
341      * @dev Returns the total number of tokens in existence.
342      * Burned tokens will reduce the count.
343      * To get the total number of tokens minted, please see {_totalMinted}.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     // =============================================================
348     //                            IERC165
349     // =============================================================
350 
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 
361     // =============================================================
362     //                            IERC721
363     // =============================================================
364 
365     /**
366      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
367      */
368     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
369 
370     /**
371      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
372      */
373     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
374 
375     /**
376      * @dev Emitted when `owner` enables or disables
377      * (`approved`) `operator` to manage all of its assets.
378      */
379     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
380 
381     /**
382      * @dev Returns the number of tokens in `owner`'s account.
383      */
384     function balanceOf(address owner) external view returns (uint256 balance);
385 
386     /**
387      * @dev Returns the owner of the `tokenId` token.
388      *
389      * Requirements:
390      *
391      * - `tokenId` must exist.
392      */
393     function ownerOf(uint256 tokenId) external view returns (address owner);
394 
395     /**
396      * @dev Safely transfers `tokenId` token from `from` to `to`,
397      * checking first that contract recipients are aware of the ERC721 protocol
398      * to prevent tokens from being forever locked.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `tokenId` token must exist and be owned by `from`.
405      * - If the caller is not `from`, it must be have been allowed to move
406      * this token by either {approve} or {setApprovalForAll}.
407      * - If `to` refers to a smart contract, it must implement
408      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
409      *
410      * Emits a {Transfer} event.
411      */
412     function safeTransferFrom(
413         address from,
414         address to,
415         uint256 tokenId,
416         bytes calldata data
417     ) external;
418 
419     /**
420      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
421      */
422     function safeTransferFrom(
423         address from,
424         address to,
425         uint256 tokenId
426     ) external;
427 
428     /**
429      * @dev Transfers `tokenId` from `from` to `to`.
430      *
431      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
432      * whenever possible.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must be owned by `from`.
439      * - If the caller is not `from`, it must be approved to move this token
440      * by either {approve} or {setApprovalForAll}.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
452      * The approval is cleared when the token is transferred.
453      *
454      * Only a single account can be approved at a time, so approving the
455      * zero address clears previous approvals.
456      *
457      * Requirements:
458      *
459      * - The caller must own the token or be an approved operator.
460      * - `tokenId` must exist.
461      *
462      * Emits an {Approval} event.
463      */
464     function approve(address to, uint256 tokenId) external;
465 
466     /**
467      * @dev Approve or remove `operator` as an operator for the caller.
468      * Operators can call {transferFrom} or {safeTransferFrom}
469      * for any token owned by the caller.
470      *
471      * Requirements:
472      *
473      * - The `operator` cannot be the caller.
474      *
475      * Emits an {ApprovalForAll} event.
476      */
477     function setApprovalForAll(address operator, bool _approved) external;
478 
479     /**
480      * @dev Returns the account approved for `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function getApproved(uint256 tokenId) external view returns (address operator);
487 
488     /**
489      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
490      *
491      * See {setApprovalForAll}.
492      */
493     function isApprovedForAll(address owner, address operator) external view returns (bool);
494 
495     // =============================================================
496     //                        IERC721Metadata
497     // =============================================================
498 
499     /**
500      * @dev Returns the token collection name.
501      */
502     function name() external view returns (string memory);
503 
504     /**
505      * @dev Returns the token collection symbol.
506      */
507     function symbol() external view returns (string memory);
508 
509     /**
510      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
511      */
512     function tokenURI(uint256 tokenId) external view returns (string memory);
513 
514     // =============================================================
515     //                           IERC2309
516     // =============================================================
517 
518     /**
519      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
520      * (inclusive) is transferred from `from` to `to`, as defined in the
521      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
522      *
523      * See {_mintERC2309} for more details.
524      */
525     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
526 }
527 
528 interface IERC20Permit {
529     /**
530      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
531      * given ``owner``'s signed approval.
532      *
533      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
534      * ordering also apply here.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      * - `deadline` must be a timestamp in the future.
542      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
543      * over the EIP712-formatted function arguments.
544      * - the signature must use ``owner``'s current nonce (see {nonces}).
545      *
546      * For more information on the signature format, see the
547      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
548      * section].
549      */
550     function permit(
551         address owner,
552         address spender,
553         uint256 value,
554         uint256 deadline,
555         uint8 v,
556         bytes32 r,
557         bytes32 s
558     ) external;
559 
560     /**
561      * @dev Returns the current nonce for `owner`. This value must be
562      * included whenever a signature is generated for {permit}.
563      *
564      * Every successful call to {permit} increases ``owner``'s nonce by one. This
565      * prevents a signature from being used multiple times.
566      */
567     function nonces(address owner) external view returns (uint256);
568 
569     /**
570      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
571      */
572     // solhint-disable-next-line func-name-mixedcase
573     function DOMAIN_SEPARATOR() external view returns (bytes32);
574 }
575 
576 interface IERC20 {
577     /**
578      * @dev Emitted when `value` tokens are moved from one account (`from`) to
579      * another (`to`).
580      *
581      * Note that `value` may be zero.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 value);
584 
585     /**
586      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
587      * a call to {approve}. `value` is the new allowance.
588      */
589     event Approval(address indexed owner, address indexed spender, uint256 value);
590 
591     /**
592      * @dev Returns the amount of tokens in existence.
593      */
594     function totalSupply() external view returns (uint256);
595 
596     /**
597      * @dev Returns the amount of tokens owned by `account`.
598      */
599     function balanceOf(address account) external view returns (uint256);
600 
601     /**
602      * @dev Moves `amount` tokens from the caller's account to `to`.
603      *
604      * Returns a boolean value indicating whether the operation succeeded.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transfer(address to, uint256 amount) external returns (bool);
609 
610     /**
611      * @dev Returns the remaining number of tokens that `spender` will be
612      * allowed to spend on behalf of `owner` through {transferFrom}. This is
613      * zero by default.
614      *
615      * This value changes when {approve} or {transferFrom} are called.
616      */
617     function allowance(address owner, address spender) external view returns (uint256);
618 
619     /**
620      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
621      *
622      * Returns a boolean value indicating whether the operation succeeded.
623      *
624      * IMPORTANT: Beware that changing an allowance with this method brings the risk
625      * that someone may use both the old and the new allowance by unfortunate
626      * transaction ordering. One possible solution to mitigate this race
627      * condition is to first reduce the spender's allowance to 0 and set the
628      * desired value afterwards:
629      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address spender, uint256 amount) external returns (bool);
634 
635     /**
636      * @dev Moves `amount` tokens from `from` to `to` using the
637      * allowance mechanism. `amount` is then deducted from the caller's
638      * allowance.
639      *
640      * Returns a boolean value indicating whether the operation succeeded.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 amount
648     ) external returns (bool);
649 }
650 
651 library SafeERC20 {
652     using Address for address;
653 
654     function safeTransfer(
655         IERC20 token,
656         address to,
657         uint256 value
658     ) internal {
659         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
660     }
661 
662     function safeTransferFrom(
663         IERC20 token,
664         address from,
665         address to,
666         uint256 value
667     ) internal {
668         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
669     }
670 
671     /**
672      * @dev Deprecated. This function has issues similar to the ones found in
673      * {IERC20-approve}, and its usage is discouraged.
674      *
675      * Whenever possible, use {safeIncreaseAllowance} and
676      * {safeDecreaseAllowance} instead.
677      */
678     function safeApprove(
679         IERC20 token,
680         address spender,
681         uint256 value
682     ) internal {
683         // safeApprove should only be called when setting an initial allowance,
684         // or when resetting it to zero. To increase and decrease it, use
685         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
686         require(
687             (value == 0) || (token.allowance(address(this), spender) == 0),
688             "SafeERC20: approve from non-zero to non-zero allowance"
689         );
690         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
691     }
692 
693     function safeIncreaseAllowance(
694         IERC20 token,
695         address spender,
696         uint256 value
697     ) internal {
698         uint256 newAllowance = token.allowance(address(this), spender) + value;
699         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
700     }
701 
702     function safeDecreaseAllowance(
703         IERC20 token,
704         address spender,
705         uint256 value
706     ) internal {
707         unchecked {
708             uint256 oldAllowance = token.allowance(address(this), spender);
709             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
710             uint256 newAllowance = oldAllowance - value;
711             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
712         }
713     }
714 
715     function safePermit(
716         IERC20Permit token,
717         address owner,
718         address spender,
719         uint256 value,
720         uint256 deadline,
721         uint8 v,
722         bytes32 r,
723         bytes32 s
724     ) internal {
725         uint256 nonceBefore = token.nonces(owner);
726         token.permit(owner, spender, value, deadline, v, r, s);
727         uint256 nonceAfter = token.nonces(owner);
728         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
729     }
730 
731     /**
732      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
733      * on the return value: the return value is optional (but if data is returned, it must not be false).
734      * @param token The token targeted by the call.
735      * @param data The call data (encoded using abi.encode or one of its variants).
736      */
737     function _callOptionalReturn(IERC20 token, bytes memory data) private {
738         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
739         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
740         // the target address contains contract code and also asserts for success in the low-level call.
741 
742         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
743         if (returndata.length > 0) {
744             // Return data is optional
745             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
746         }
747     }
748 }
749 
750 library Strings {
751     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
752     uint8 private constant _ADDRESS_LENGTH = 20;
753 
754     /**
755      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
756      */
757     function toString(uint256 value) internal pure returns (string memory) {
758         // Inspired by OraclizeAPI's implementation - MIT licence
759         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
760 
761         if (value == 0) {
762             return "0";
763         }
764         uint256 temp = value;
765         uint256 digits;
766         while (temp != 0) {
767             digits++;
768             temp /= 10;
769         }
770         bytes memory buffer = new bytes(digits);
771         while (value != 0) {
772             digits -= 1;
773             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
774             value /= 10;
775         }
776         return string(buffer);
777     }
778 
779     /**
780      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
781      */
782     function toHexString(uint256 value) internal pure returns (string memory) {
783         if (value == 0) {
784             return "0x00";
785         }
786         uint256 temp = value;
787         uint256 length = 0;
788         while (temp != 0) {
789             length++;
790             temp >>= 8;
791         }
792         return toHexString(value, length);
793     }
794 
795     /**
796      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
797      */
798     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
799         bytes memory buffer = new bytes(2 * length + 2);
800         buffer[0] = "0";
801         buffer[1] = "x";
802         for (uint256 i = 2 * length + 1; i > 1; --i) {
803             buffer[i] = _HEX_SYMBOLS[value & 0xf];
804             value >>= 4;
805         }
806         require(value == 0, "Strings: hex length insufficient");
807         return string(buffer);
808     }
809 
810     /**
811      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
812      */
813     function toHexString(address addr) internal pure returns (string memory) {
814         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
815     }
816 }
817 
818 abstract contract Ownable is Context {
819     address private _owner;
820 
821     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
822 
823     /**
824      * @dev Initializes the contract setting the deployer as the initial owner.
825      */
826     constructor() {
827         _transferOwnership(_msgSender());
828     }
829 
830     /**
831      * @dev Throws if called by any account other than the owner.
832      */
833     modifier onlyOwner() {
834         _checkOwner();
835         _;
836     }
837 
838     /**
839      * @dev Returns the address of the current owner.
840      */
841     function owner() public view virtual returns (address) {
842         return _owner;
843     }
844 
845     /**
846      * @dev Throws if the sender is not the owner.
847      */
848     function _checkOwner() internal view virtual {
849         require(owner() == _msgSender(), "Ownable: caller is not the owner");
850     }
851 
852     /**
853      * @dev Leaves the contract without owner. It will not be possible to call
854      * `onlyOwner` functions anymore. Can only be called by the current owner.
855      *
856      * NOTE: Renouncing ownership will leave the contract without an owner,
857      * thereby removing any functionality that is only available to the owner.
858      */
859     function renounceOwnership() public virtual onlyOwner {
860         _transferOwnership(address(0));
861     }
862 
863     /**
864      * @dev Transfers ownership of the contract to a new account (`newOwner`).
865      * Can only be called by the current owner.
866      */
867     function transferOwnership(address newOwner) public virtual onlyOwner {
868         require(newOwner != address(0), "Ownable: new owner is the zero address");
869         _transferOwnership(newOwner);
870     }
871 
872     /**
873      * @dev Transfers ownership of the contract to a new account (`newOwner`).
874      * Internal function without access restriction.
875      */
876     function _transferOwnership(address newOwner) internal virtual {
877         address oldOwner = _owner;
878         _owner = newOwner;
879         emit OwnershipTransferred(oldOwner, newOwner);
880     }
881 }
882 
883 library ECDSA {
884     enum RecoverError {
885         NoError,
886         InvalidSignature,
887         InvalidSignatureLength,
888         InvalidSignatureS,
889         InvalidSignatureV
890     }
891 
892     function _throwError(RecoverError error) private pure {
893         if (error == RecoverError.NoError) {
894             return; // no error: do nothing
895         } else if (error == RecoverError.InvalidSignature) {
896             revert("ECDSA: invalid signature");
897         } else if (error == RecoverError.InvalidSignatureLength) {
898             revert("ECDSA: invalid signature length");
899         } else if (error == RecoverError.InvalidSignatureS) {
900             revert("ECDSA: invalid signature 's' value");
901         } else if (error == RecoverError.InvalidSignatureV) {
902             revert("ECDSA: invalid signature 'v' value");
903         }
904     }
905 
906     /**
907      * @dev Returns the address that signed a hashed message (`hash`) with
908      * `signature` or error string. This address can then be used for verification purposes.
909      *
910      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
911      * this function rejects them by requiring the `s` value to be in the lower
912      * half order, and the `v` value to be either 27 or 28.
913      *
914      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
915      * verification to be secure: it is possible to craft signatures that
916      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
917      * this is by receiving a hash of the original message (which may otherwise
918      * be too long), and then calling {toEthSignedMessageHash} on it.
919      *
920      * Documentation for signature generation:
921      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
922      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
923      *
924      * _Available since v4.3._
925      */
926     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
927         // Check the signature length
928         // - case 65: r,s,v signature (standard)
929         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
930         if (signature.length == 65) {
931             bytes32 r;
932             bytes32 s;
933             uint8 v;
934             // ecrecover takes the signature parameters, and the only way to get them
935             // currently is to use assembly.
936             /// @solidity memory-safe-assembly
937             assembly {
938                 r := mload(add(signature, 0x20))
939                 s := mload(add(signature, 0x40))
940                 v := byte(0, mload(add(signature, 0x60)))
941             }
942             return tryRecover(hash, v, r, s);
943         } else if (signature.length == 64) {
944             bytes32 r;
945             bytes32 vs;
946             // ecrecover takes the signature parameters, and the only way to get them
947             // currently is to use assembly.
948             /// @solidity memory-safe-assembly
949             assembly {
950                 r := mload(add(signature, 0x20))
951                 vs := mload(add(signature, 0x40))
952             }
953             return tryRecover(hash, r, vs);
954         } else {
955             return (address(0), RecoverError.InvalidSignatureLength);
956         }
957     }
958 
959     /**
960      * @dev Returns the address that signed a hashed message (`hash`) with
961      * `signature`. This address can then be used for verification purposes.
962      *
963      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
964      * this function rejects them by requiring the `s` value to be in the lower
965      * half order, and the `v` value to be either 27 or 28.
966      *
967      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
968      * verification to be secure: it is possible to craft signatures that
969      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
970      * this is by receiving a hash of the original message (which may otherwise
971      * be too long), and then calling {toEthSignedMessageHash} on it.
972      */
973     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
974         (address recovered, RecoverError error) = tryRecover(hash, signature);
975         _throwError(error);
976         return recovered;
977     }
978 
979     /**
980      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
981      *
982      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
983      *
984      * _Available since v4.3._
985      */
986     function tryRecover(
987         bytes32 hash,
988         bytes32 r,
989         bytes32 vs
990     ) internal pure returns (address, RecoverError) {
991         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
992         uint8 v = uint8((uint256(vs) >> 255) + 27);
993         return tryRecover(hash, v, r, s);
994     }
995 
996     /**
997      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
998      *
999      * _Available since v4.2._
1000      */
1001     function recover(
1002         bytes32 hash,
1003         bytes32 r,
1004         bytes32 vs
1005     ) internal pure returns (address) {
1006         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1007         _throwError(error);
1008         return recovered;
1009     }
1010 
1011     /**
1012      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1013      * `r` and `s` signature fields separately.
1014      *
1015      * _Available since v4.3._
1016      */
1017     function tryRecover(
1018         bytes32 hash,
1019         uint8 v,
1020         bytes32 r,
1021         bytes32 s
1022     ) internal pure returns (address, RecoverError) {
1023         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1024         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1025         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1026         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1027         //
1028         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1029         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1030         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1031         // these malleable signatures as well.
1032         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1033             return (address(0), RecoverError.InvalidSignatureS);
1034         }
1035         if (v != 27 && v != 28) {
1036             return (address(0), RecoverError.InvalidSignatureV);
1037         }
1038 
1039         // If the signature is valid (and not malleable), return the signer address
1040         address signer = ecrecover(hash, v, r, s);
1041         if (signer == address(0)) {
1042             return (address(0), RecoverError.InvalidSignature);
1043         }
1044 
1045         return (signer, RecoverError.NoError);
1046     }
1047 
1048     /**
1049      * @dev Overload of {ECDSA-recover} that receives the `v`,
1050      * `r` and `s` signature fields separately.
1051      */
1052     function recover(
1053         bytes32 hash,
1054         uint8 v,
1055         bytes32 r,
1056         bytes32 s
1057     ) internal pure returns (address) {
1058         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1059         _throwError(error);
1060         return recovered;
1061     }
1062 
1063     /**
1064      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1065      * produces hash corresponding to the one signed with the
1066      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1067      * JSON-RPC method as part of EIP-191.
1068      *
1069      * See {recover}.
1070      */
1071     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1072         // 32 is the length in bytes of hash,
1073         // enforced by the type signature above
1074         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1075     }
1076 
1077     /**
1078      * @dev Returns an Ethereum Signed Message, created from `s`. This
1079      * produces hash corresponding to the one signed with the
1080      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1081      * JSON-RPC method as part of EIP-191.
1082      *
1083      * See {recover}.
1084      */
1085     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1086         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1087     }
1088 
1089     /**
1090      * @dev Returns an Ethereum Signed Typed Data, created from a
1091      * `domainSeparator` and a `structHash`. This produces hash corresponding
1092      * to the one signed with the
1093      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1094      * JSON-RPC method as part of EIP-712.
1095      *
1096      * See {recover}.
1097      */
1098     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1099         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1100     }
1101 }
1102 
1103 contract PaymentSplitter is Context {
1104     event PayeeAdded(address account, uint256 shares);
1105     event PaymentReleased(address to, uint256 amount);
1106     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1107     event PaymentReceived(address from, uint256 amount);
1108 
1109     uint256 private _totalShares;
1110     uint256 private _totalReleased;
1111 
1112     mapping(address => uint256) private _shares;
1113     mapping(address => uint256) private _released;
1114     address[] private _payees;
1115 
1116     mapping(IERC20 => uint256) private _erc20TotalReleased;
1117     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1118 
1119     /**
1120      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1121      * the matching position in the `shares` array.
1122      *
1123      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1124      * duplicates in `payees`.
1125      */
1126     constructor(address[] memory payees, uint256[] memory shares_) payable {
1127         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1128         require(payees.length > 0, "PaymentSplitter: no payees");
1129 
1130         for (uint256 i = 0; i < payees.length; i++) {
1131             _addPayee(payees[i], shares_[i]);
1132         }
1133     }
1134 
1135     /**
1136      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1137      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1138      * reliability of the events, and not the actual splitting of Ether.
1139      *
1140      * To learn more about this see the Solidity documentation for
1141      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1142      * functions].
1143      */
1144     receive() external payable virtual {
1145         emit PaymentReceived(_msgSender(), msg.value);
1146     }
1147 
1148     /**
1149      * @dev Getter for the total shares held by payees.
1150      */
1151     function totalShares() public view returns (uint256) {
1152         return _totalShares;
1153     }
1154 
1155     /**
1156      * @dev Getter for the total amount of Ether already released.
1157      */
1158     function totalReleased() public view returns (uint256) {
1159         return _totalReleased;
1160     }
1161 
1162     /**
1163      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1164      * contract.
1165      */
1166     function totalReleased(IERC20 token) public view returns (uint256) {
1167         return _erc20TotalReleased[token];
1168     }
1169 
1170     /**
1171      * @dev Getter for the amount of shares held by an account.
1172      */
1173     function shares(address account) public view returns (uint256) {
1174         return _shares[account];
1175     }
1176 
1177     /**
1178      * @dev Getter for the amount of Ether already released to a payee.
1179      */
1180     function released(address account) public view returns (uint256) {
1181         return _released[account];
1182     }
1183 
1184     /**
1185      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1186      * IERC20 contract.
1187      */
1188     function released(IERC20 token, address account) public view returns (uint256) {
1189         return _erc20Released[token][account];
1190     }
1191 
1192     /**
1193      * @dev Getter for the address of the payee number `index`.
1194      */
1195     function payee(uint256 index) public view returns (address) {
1196         return _payees[index];
1197     }
1198 
1199     /**
1200      * @dev Getter for the amount of payee's releasable Ether.
1201      */
1202     function releasable(address account) public view returns (uint256) {
1203         uint256 totalReceived = address(this).balance + totalReleased();
1204         return _pendingPayment(account, totalReceived, released(account));
1205     }
1206 
1207     /**
1208      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1209      * IERC20 contract.
1210      */
1211     function releasable(IERC20 token, address account) public view returns (uint256) {
1212         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1213         return _pendingPayment(account, totalReceived, released(token, account));
1214     }
1215 
1216     /**
1217      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1218      * total shares and their previous withdrawals.
1219      */
1220     function release(address payable account) public virtual {
1221         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1222 
1223         uint256 payment = releasable(account);
1224 
1225         require(payment != 0, "PaymentSplitter: account is not due payment");
1226 
1227         _released[account] += payment;
1228         _totalReleased += payment;
1229 
1230         Address.sendValue(account, payment);
1231         emit PaymentReleased(account, payment);
1232     }
1233 
1234     /**
1235      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1236      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1237      * contract.
1238      */
1239     function release(IERC20 token, address account) public virtual {
1240         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1241 
1242         uint256 payment = releasable(token, account);
1243 
1244         require(payment != 0, "PaymentSplitter: account is not due payment");
1245 
1246         _erc20Released[token][account] += payment;
1247         _erc20TotalReleased[token] += payment;
1248 
1249         SafeERC20.safeTransfer(token, account, payment);
1250         emit ERC20PaymentReleased(token, account, payment);
1251     }
1252 
1253     /**
1254      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1255      * already released amounts.
1256      */
1257     function _pendingPayment(
1258         address account,
1259         uint256 totalReceived,
1260         uint256 alreadyReleased
1261     ) private view returns (uint256) {
1262         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1263     }
1264 
1265     /**
1266      * @dev Add a new payee to the contract.
1267      * @param account The address of the payee to add.
1268      * @param shares_ The number of shares owned by the payee.
1269      */
1270     function _addPayee(address account, uint256 shares_) private {
1271         require(account != address(0), "PaymentSplitter: account is the zero address");
1272         require(shares_ > 0, "PaymentSplitter: shares are 0");
1273         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1274 
1275         _payees.push(account);
1276         _shares[account] = shares_;
1277         _totalShares = _totalShares + shares_;
1278         emit PayeeAdded(account, shares_);
1279     }
1280 }
1281 
1282 /**
1283  * @dev Interface of ERC721 token receiver.
1284  */
1285 interface ERC721A__IERC721Receiver {
1286     function onERC721Received(
1287         address operator,
1288         address from,
1289         uint256 tokenId,
1290         bytes calldata data
1291     ) external returns (bytes4);
1292 }
1293 
1294 /**
1295  * @title ERC721A
1296  *
1297  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1298  * Non-Fungible Token Standard, including the Metadata extension.
1299  * Optimized for lower gas during batch mints.
1300  *
1301  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1302  * starting from `_startTokenId()`.
1303  *
1304  * Assumptions:
1305  *
1306  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1307  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1308  */
1309 contract ERC721A is IERC721A {
1310     // Reference type for token approval.
1311     struct TokenApprovalRef {
1312         address value;
1313     }
1314 
1315     // =============================================================
1316     //                           CONSTANTS
1317     // =============================================================
1318 
1319     // Mask of an entry in packed address data.
1320     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1321 
1322     // The bit position of `numberMinted` in packed address data.
1323     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1324 
1325     // The bit position of `numberBurned` in packed address data.
1326     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1327 
1328     // The bit position of `aux` in packed address data.
1329     uint256 private constant _BITPOS_AUX = 192;
1330 
1331     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1332     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1333 
1334     // The bit position of `startTimestamp` in packed ownership.
1335     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1336 
1337     // The bit mask of the `burned` bit in packed ownership.
1338     uint256 private constant _BITMASK_BURNED = 1 << 224;
1339 
1340     // The bit position of the `nextInitialized` bit in packed ownership.
1341     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1342 
1343     // The bit mask of the `nextInitialized` bit in packed ownership.
1344     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1345 
1346     // The bit position of `extraData` in packed ownership.
1347     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1348 
1349     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1350     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1351 
1352     // The mask of the lower 160 bits for addresses.
1353     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1354 
1355     // The maximum `quantity` that can be minted with {_mintERC2309}.
1356     // This limit is to prevent overflows on the address data entries.
1357     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1358     // is required to cause an overflow, which is unrealistic.
1359     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1360 
1361     // The `Transfer` event signature is given by:
1362     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1363     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1364         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1365 
1366     // =============================================================
1367     //                            STORAGE
1368     // =============================================================
1369 
1370     // The next token ID to be minted.
1371     uint256 private _currentIndex;
1372 
1373     // The number of tokens burned.
1374     uint256 private _burnCounter;
1375 
1376     // Token name
1377     string private _name;
1378 
1379     // Token symbol
1380     string private _symbol;
1381 
1382     // Mapping from token ID to ownership details
1383     // An empty struct value does not necessarily mean the token is unowned.
1384     // See {_packedOwnershipOf} implementation for details.
1385     //
1386     // Bits Layout:
1387     // - [0..159]   `addr`
1388     // - [160..223] `startTimestamp`
1389     // - [224]      `burned`
1390     // - [225]      `nextInitialized`
1391     // - [232..255] `extraData`
1392     mapping(uint256 => uint256) private _packedOwnerships;
1393 
1394     // Mapping owner address to address data.
1395     //
1396     // Bits Layout:
1397     // - [0..63]    `balance`
1398     // - [64..127]  `numberMinted`
1399     // - [128..191] `numberBurned`
1400     // - [192..255] `aux`
1401     mapping(address => uint256) private _packedAddressData;
1402 
1403     // Mapping from token ID to approved address.
1404     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1405 
1406     // Mapping from owner to operator approvals
1407     mapping(address => mapping(address => bool)) private _operatorApprovals;
1408 
1409     // =============================================================
1410     //                          CONSTRUCTOR
1411     // =============================================================
1412 
1413     constructor(string memory name_, string memory symbol_) {
1414         _name = name_;
1415         _symbol = symbol_;
1416         _currentIndex = _startTokenId();
1417     }
1418 
1419     // =============================================================
1420     //                   TOKEN COUNTING OPERATIONS
1421     // =============================================================
1422 
1423     /**
1424      * @dev Returns the starting token ID.
1425      * To change the starting token ID, please override this function.
1426      */
1427     function _startTokenId() internal view virtual returns (uint256) {
1428         return 0;
1429     }
1430 
1431     /**
1432      * @dev Returns the next token ID to be minted.
1433      */
1434     function _nextTokenId() internal view virtual returns (uint256) {
1435         return _currentIndex;
1436     }
1437 
1438     /**
1439      * @dev Returns the total number of tokens in existence.
1440      * Burned tokens will reduce the count.
1441      * To get the total number of tokens minted, please see {_totalMinted}.
1442      */
1443     function totalSupply() public view virtual override returns (uint256) {
1444         // Counter underflow is impossible as _burnCounter cannot be incremented
1445         // more than `_currentIndex - _startTokenId()` times.
1446         unchecked {
1447             return _currentIndex - _burnCounter - _startTokenId();
1448         }
1449     }
1450 
1451     /**
1452      * @dev Returns the total amount of tokens minted in the contract.
1453      */
1454     function _totalMinted() internal view virtual returns (uint256) {
1455         // Counter underflow is impossible as `_currentIndex` does not decrement,
1456         // and it is initialized to `_startTokenId()`.
1457         unchecked {
1458             return _currentIndex - _startTokenId();
1459         }
1460     }
1461 
1462     /**
1463      * @dev Returns the total number of tokens burned.
1464      */
1465     function _totalBurned() internal view virtual returns (uint256) {
1466         return _burnCounter;
1467     }
1468 
1469     // =============================================================
1470     //                    ADDRESS DATA OPERATIONS
1471     // =============================================================
1472 
1473     /**
1474      * @dev Returns the number of tokens in `owner`'s account.
1475      */
1476     function balanceOf(address owner) public view virtual override returns (uint256) {
1477         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1478         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1479     }
1480 
1481     /**
1482      * Returns the number of tokens minted by `owner`.
1483      */
1484     function _numberMinted(address owner) internal view returns (uint256) {
1485         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1486     }
1487 
1488     /**
1489      * Returns the number of tokens burned by or on behalf of `owner`.
1490      */
1491     function _numberBurned(address owner) internal view returns (uint256) {
1492         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1493     }
1494 
1495     /**
1496      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1497      */
1498     function _getAux(address owner) internal view returns (uint64) {
1499         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1500     }
1501 
1502     /**
1503      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1504      * If there are multiple variables, please pack them into a uint64.
1505      */
1506     function _setAux(address owner, uint64 aux) internal virtual {
1507         uint256 packed = _packedAddressData[owner];
1508         uint256 auxCasted;
1509         // Cast `aux` with assembly to avoid redundant masking.
1510         assembly {
1511             auxCasted := aux
1512         }
1513         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1514         _packedAddressData[owner] = packed;
1515     }
1516 
1517     // =============================================================
1518     //                            IERC165
1519     // =============================================================
1520 
1521     /**
1522      * @dev Returns true if this contract implements the interface defined by
1523      * `interfaceId`. See the corresponding
1524      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1525      * to learn more about how these ids are created.
1526      *
1527      * This function call must use less than 30000 gas.
1528      */
1529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1530         // The interface IDs are constants representing the first 4 bytes
1531         // of the XOR of all function selectors in the interface.
1532         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1533         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1534         return
1535             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1536             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1537             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1538     }
1539 
1540     // =============================================================
1541     //                        IERC721Metadata
1542     // =============================================================
1543 
1544     /**
1545      * @dev Returns the token collection name.
1546      */
1547     function name() public view virtual override returns (string memory) {
1548         return _name;
1549     }
1550 
1551     /**
1552      * @dev Returns the token collection symbol.
1553      */
1554     function symbol() public view virtual override returns (string memory) {
1555         return _symbol;
1556     }
1557 
1558     /**
1559      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1560      */
1561     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1562         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1563 
1564         string memory baseURI = _baseURI();
1565         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1566     }
1567 
1568     /**
1569      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1570      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1571      * by default, it can be overridden in child contracts.
1572      */
1573     function _baseURI() internal view virtual returns (string memory) {
1574         return '';
1575     }
1576 
1577     // =============================================================
1578     //                     OWNERSHIPS OPERATIONS
1579     // =============================================================
1580 
1581     /**
1582      * @dev Returns the owner of the `tokenId` token.
1583      *
1584      * Requirements:
1585      *
1586      * - `tokenId` must exist.
1587      */
1588     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1589         return address(uint160(_packedOwnershipOf(tokenId)));
1590     }
1591 
1592     /**
1593      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1594      * It gradually moves to O(1) as tokens get transferred around over time.
1595      */
1596     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1597         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1598     }
1599 
1600     /**
1601      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1602      */
1603     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1604         return _unpackedOwnership(_packedOwnerships[index]);
1605     }
1606 
1607     /**
1608      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1609      */
1610     function _initializeOwnershipAt(uint256 index) internal virtual {
1611         if (_packedOwnerships[index] == 0) {
1612             _packedOwnerships[index] = _packedOwnershipOf(index);
1613         }
1614     }
1615 
1616     /**
1617      * Returns the packed ownership data of `tokenId`.
1618      */
1619     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1620         uint256 curr = tokenId;
1621 
1622         unchecked {
1623             if (_startTokenId() <= curr)
1624                 if (curr < _currentIndex) {
1625                     uint256 packed = _packedOwnerships[curr];
1626                     // If not burned.
1627                     if (packed & _BITMASK_BURNED == 0) {
1628                         // Invariant:
1629                         // There will always be an initialized ownership slot
1630                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1631                         // before an unintialized ownership slot
1632                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1633                         // Hence, `curr` will not underflow.
1634                         //
1635                         // We can directly compare the packed value.
1636                         // If the address is zero, packed will be zero.
1637                         while (packed == 0) {
1638                             packed = _packedOwnerships[--curr];
1639                         }
1640                         return packed;
1641                     }
1642                 }
1643         }
1644         revert OwnerQueryForNonexistentToken();
1645     }
1646 
1647     /**
1648      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1649      */
1650     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1651         ownership.addr = address(uint160(packed));
1652         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1653         ownership.burned = packed & _BITMASK_BURNED != 0;
1654         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1655     }
1656 
1657     /**
1658      * @dev Packs ownership data into a single uint256.
1659      */
1660     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1661         assembly {
1662             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1663             owner := and(owner, _BITMASK_ADDRESS)
1664             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1665             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1666         }
1667     }
1668 
1669     /**
1670      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1671      */
1672     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1673         // For branchless setting of the `nextInitialized` flag.
1674         assembly {
1675             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1676             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1677         }
1678     }
1679 
1680     // =============================================================
1681     //                      APPROVAL OPERATIONS
1682     // =============================================================
1683 
1684     /**
1685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1686      * The approval is cleared when the token is transferred.
1687      *
1688      * Only a single account can be approved at a time, so approving the
1689      * zero address clears previous approvals.
1690      *
1691      * Requirements:
1692      *
1693      * - The caller must own the token or be an approved operator.
1694      * - `tokenId` must exist.
1695      *
1696      * Emits an {Approval} event.
1697      */
1698     function approve(address to, uint256 tokenId) public virtual override {
1699         address owner = ownerOf(tokenId);
1700 
1701         if (_msgSenderERC721A() != owner)
1702             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1703                 revert ApprovalCallerNotOwnerNorApproved();
1704             }
1705 
1706         _tokenApprovals[tokenId].value = to;
1707         emit Approval(owner, to, tokenId);
1708     }
1709 
1710     /**
1711      * @dev Returns the account approved for `tokenId` token.
1712      *
1713      * Requirements:
1714      *
1715      * - `tokenId` must exist.
1716      */
1717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1718         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1719 
1720         return _tokenApprovals[tokenId].value;
1721     }
1722 
1723     /**
1724      * @dev Approve or remove `operator` as an operator for the caller.
1725      * Operators can call {transferFrom} or {safeTransferFrom}
1726      * for any token owned by the caller.
1727      *
1728      * Requirements:
1729      *
1730      * - The `operator` cannot be the caller.
1731      *
1732      * Emits an {ApprovalForAll} event.
1733      */
1734     function setApprovalForAll(address operator, bool approved) public virtual override {
1735         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1736 
1737         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1738         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1739     }
1740 
1741     /**
1742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1743      *
1744      * See {setApprovalForAll}.
1745      */
1746     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1747         return _operatorApprovals[owner][operator];
1748     }
1749 
1750     /**
1751      * @dev Returns whether `tokenId` exists.
1752      *
1753      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1754      *
1755      * Tokens start existing when they are minted. See {_mint}.
1756      */
1757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1758         return
1759             _startTokenId() <= tokenId &&
1760             tokenId < _currentIndex && // If within bounds,
1761             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1762     }
1763 
1764     /**
1765      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1766      */
1767     function _isSenderApprovedOrOwner(
1768         address approvedAddress,
1769         address owner,
1770         address msgSender
1771     ) private pure returns (bool result) {
1772         assembly {
1773             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1774             owner := and(owner, _BITMASK_ADDRESS)
1775             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1776             msgSender := and(msgSender, _BITMASK_ADDRESS)
1777             // `msgSender == owner || msgSender == approvedAddress`.
1778             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1779         }
1780     }
1781 
1782     /**
1783      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1784      */
1785     function _getApprovedSlotAndAddress(uint256 tokenId)
1786         private
1787         view
1788         returns (uint256 approvedAddressSlot, address approvedAddress)
1789     {
1790         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1791         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1792         assembly {
1793             approvedAddressSlot := tokenApproval.slot
1794             approvedAddress := sload(approvedAddressSlot)
1795         }
1796     }
1797 
1798     // =============================================================
1799     //                      TRANSFER OPERATIONS
1800     // =============================================================
1801 
1802     /**
1803      * @dev Transfers `tokenId` from `from` to `to`.
1804      *
1805      * Requirements:
1806      *
1807      * - `from` cannot be the zero address.
1808      * - `to` cannot be the zero address.
1809      * - `tokenId` token must be owned by `from`.
1810      * - If the caller is not `from`, it must be approved to move this token
1811      * by either {approve} or {setApprovalForAll}.
1812      *
1813      * Emits a {Transfer} event.
1814      */
1815     function transferFrom(
1816         address from,
1817         address to,
1818         uint256 tokenId
1819     ) public virtual override {
1820         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1821 
1822         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1823 
1824         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1825 
1826         // The nested ifs save around 20+ gas over a compound boolean condition.
1827         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1828             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1829 
1830         if (to == address(0)) revert TransferToZeroAddress();
1831 
1832         _beforeTokenTransfers(from, to, tokenId, 1);
1833 
1834         // Clear approvals from the previous owner.
1835         assembly {
1836             if approvedAddress {
1837                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1838                 sstore(approvedAddressSlot, 0)
1839             }
1840         }
1841 
1842         // Underflow of the sender's balance is impossible because we check for
1843         // ownership above and the recipient's balance can't realistically overflow.
1844         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1845         unchecked {
1846             // We can directly increment and decrement the balances.
1847             --_packedAddressData[from]; // Updates: `balance -= 1`.
1848             ++_packedAddressData[to]; // Updates: `balance += 1`.
1849 
1850             // Updates:
1851             // - `address` to the next owner.
1852             // - `startTimestamp` to the timestamp of transfering.
1853             // - `burned` to `false`.
1854             // - `nextInitialized` to `true`.
1855             _packedOwnerships[tokenId] = _packOwnershipData(
1856                 to,
1857                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1858             );
1859 
1860             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1861             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1862                 uint256 nextTokenId = tokenId + 1;
1863                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1864                 if (_packedOwnerships[nextTokenId] == 0) {
1865                     // If the next slot is within bounds.
1866                     if (nextTokenId != _currentIndex) {
1867                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1868                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1869                     }
1870                 }
1871             }
1872         }
1873 
1874         emit Transfer(from, to, tokenId);
1875         _afterTokenTransfers(from, to, tokenId, 1);
1876     }
1877 
1878     /**
1879      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1880      */
1881     function safeTransferFrom(
1882         address from,
1883         address to,
1884         uint256 tokenId
1885     ) public virtual override {
1886         safeTransferFrom(from, to, tokenId, '');
1887     }
1888 
1889     /**
1890      * @dev Safely transfers `tokenId` token from `from` to `to`.
1891      *
1892      * Requirements:
1893      *
1894      * - `from` cannot be the zero address.
1895      * - `to` cannot be the zero address.
1896      * - `tokenId` token must exist and be owned by `from`.
1897      * - If the caller is not `from`, it must be approved to move this token
1898      * by either {approve} or {setApprovalForAll}.
1899      * - If `to` refers to a smart contract, it must implement
1900      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1901      *
1902      * Emits a {Transfer} event.
1903      */
1904     function safeTransferFrom(
1905         address from,
1906         address to,
1907         uint256 tokenId,
1908         bytes memory _data
1909     ) public virtual override {
1910         transferFrom(from, to, tokenId);
1911         if (to.code.length != 0)
1912             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1913                 revert TransferToNonERC721ReceiverImplementer();
1914             }
1915     }
1916 
1917     /**
1918      * @dev Hook that is called before a set of serially-ordered token IDs
1919      * are about to be transferred. This includes minting.
1920      * And also called before burning one token.
1921      *
1922      * `startTokenId` - the first token ID to be transferred.
1923      * `quantity` - the amount to be transferred.
1924      *
1925      * Calling conditions:
1926      *
1927      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1928      * transferred to `to`.
1929      * - When `from` is zero, `tokenId` will be minted for `to`.
1930      * - When `to` is zero, `tokenId` will be burned by `from`.
1931      * - `from` and `to` are never both zero.
1932      */
1933     function _beforeTokenTransfers(
1934         address from,
1935         address to,
1936         uint256 startTokenId,
1937         uint256 quantity
1938     ) internal virtual {}
1939 
1940     /**
1941      * @dev Hook that is called after a set of serially-ordered token IDs
1942      * have been transferred. This includes minting.
1943      * And also called after one token has been burned.
1944      *
1945      * `startTokenId` - the first token ID to be transferred.
1946      * `quantity` - the amount to be transferred.
1947      *
1948      * Calling conditions:
1949      *
1950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1951      * transferred to `to`.
1952      * - When `from` is zero, `tokenId` has been minted for `to`.
1953      * - When `to` is zero, `tokenId` has been burned by `from`.
1954      * - `from` and `to` are never both zero.
1955      */
1956     function _afterTokenTransfers(
1957         address from,
1958         address to,
1959         uint256 startTokenId,
1960         uint256 quantity
1961     ) internal virtual {}
1962 
1963     /**
1964      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1965      *
1966      * `from` - Previous owner of the given token ID.
1967      * `to` - Target address that will receive the token.
1968      * `tokenId` - Token ID to be transferred.
1969      * `_data` - Optional data to send along with the call.
1970      *
1971      * Returns whether the call correctly returned the expected magic value.
1972      */
1973     function _checkContractOnERC721Received(
1974         address from,
1975         address to,
1976         uint256 tokenId,
1977         bytes memory _data
1978     ) private returns (bool) {
1979         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1980             bytes4 retval
1981         ) {
1982             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1983         } catch (bytes memory reason) {
1984             if (reason.length == 0) {
1985                 revert TransferToNonERC721ReceiverImplementer();
1986             } else {
1987                 assembly {
1988                     revert(add(32, reason), mload(reason))
1989                 }
1990             }
1991         }
1992     }
1993 
1994     // =============================================================
1995     //                        MINT OPERATIONS
1996     // =============================================================
1997 
1998     /**
1999      * @dev Mints `quantity` tokens and transfers them to `to`.
2000      *
2001      * Requirements:
2002      *
2003      * - `to` cannot be the zero address.
2004      * - `quantity` must be greater than 0.
2005      *
2006      * Emits a {Transfer} event for each mint.
2007      */
2008     function _mint(address to, uint256 quantity) internal virtual {
2009         uint256 startTokenId = _currentIndex;
2010         if (quantity == 0) revert MintZeroQuantity();
2011 
2012         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2013 
2014         // Overflows are incredibly unrealistic.
2015         // `balance` and `numberMinted` have a maximum limit of 2**64.
2016         // `tokenId` has a maximum limit of 2**256.
2017         unchecked {
2018             // Updates:
2019             // - `balance += quantity`.
2020             // - `numberMinted += quantity`.
2021             //
2022             // We can directly add to the `balance` and `numberMinted`.
2023             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2024 
2025             // Updates:
2026             // - `address` to the owner.
2027             // - `startTimestamp` to the timestamp of minting.
2028             // - `burned` to `false`.
2029             // - `nextInitialized` to `quantity == 1`.
2030             _packedOwnerships[startTokenId] = _packOwnershipData(
2031                 to,
2032                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2033             );
2034 
2035             uint256 toMasked;
2036             uint256 end = startTokenId + quantity;
2037 
2038             // Use assembly to loop and emit the `Transfer` event for gas savings.
2039             assembly {
2040                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2041                 toMasked := and(to, _BITMASK_ADDRESS)
2042                 // Emit the `Transfer` event.
2043                 log4(
2044                     0, // Start of data (0, since no data).
2045                     0, // End of data (0, since no data).
2046                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2047                     0, // `address(0)`.
2048                     toMasked, // `to`.
2049                     startTokenId // `tokenId`.
2050                 )
2051 
2052                 for {
2053                     let tokenId := add(startTokenId, 1)
2054                 } iszero(eq(tokenId, end)) {
2055                     tokenId := add(tokenId, 1)
2056                 } {
2057                     // Emit the `Transfer` event. Similar to above.
2058                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2059                 }
2060             }
2061             if (toMasked == 0) revert MintToZeroAddress();
2062 
2063             _currentIndex = end;
2064         }
2065         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2066     }
2067 
2068     /**
2069      * @dev Mints `quantity` tokens and transfers them to `to`.
2070      *
2071      * This function is intended for efficient minting only during contract creation.
2072      *
2073      * It emits only one {ConsecutiveTransfer} as defined in
2074      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2075      * instead of a sequence of {Transfer} event(s).
2076      *
2077      * Calling this function outside of contract creation WILL make your contract
2078      * non-compliant with the ERC721 standard.
2079      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2080      * {ConsecutiveTransfer} event is only permissible during contract creation.
2081      *
2082      * Requirements:
2083      *
2084      * - `to` cannot be the zero address.
2085      * - `quantity` must be greater than 0.
2086      *
2087      * Emits a {ConsecutiveTransfer} event.
2088      */
2089     function _mintERC2309(address to, uint256 quantity) internal virtual {
2090         uint256 startTokenId = _currentIndex;
2091         if (to == address(0)) revert MintToZeroAddress();
2092         if (quantity == 0) revert MintZeroQuantity();
2093         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2094 
2095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2096 
2097         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2098         unchecked {
2099             // Updates:
2100             // - `balance += quantity`.
2101             // - `numberMinted += quantity`.
2102             //
2103             // We can directly add to the `balance` and `numberMinted`.
2104             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2105 
2106             // Updates:
2107             // - `address` to the owner.
2108             // - `startTimestamp` to the timestamp of minting.
2109             // - `burned` to `false`.
2110             // - `nextInitialized` to `quantity == 1`.
2111             _packedOwnerships[startTokenId] = _packOwnershipData(
2112                 to,
2113                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2114             );
2115 
2116             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2117 
2118             _currentIndex = startTokenId + quantity;
2119         }
2120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2121     }
2122 
2123     /**
2124      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2125      *
2126      * Requirements:
2127      *
2128      * - If `to` refers to a smart contract, it must implement
2129      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2130      * - `quantity` must be greater than 0.
2131      *
2132      * See {_mint}.
2133      *
2134      * Emits a {Transfer} event for each mint.
2135      */
2136     function _safeMint(
2137         address to,
2138         uint256 quantity,
2139         bytes memory _data
2140     ) internal virtual {
2141         _mint(to, quantity);
2142 
2143         unchecked {
2144             if (to.code.length != 0) {
2145                 uint256 end = _currentIndex;
2146                 uint256 index = end - quantity;
2147                 do {
2148                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2149                         revert TransferToNonERC721ReceiverImplementer();
2150                     }
2151                 } while (index < end);
2152                 // Reentrancy protection.
2153                 if (_currentIndex != end) revert();
2154             }
2155         }
2156     }
2157 
2158     /**
2159      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2160      */
2161     function _safeMint(address to, uint256 quantity) internal virtual {
2162         _safeMint(to, quantity, '');
2163     }
2164 
2165     // =============================================================
2166     //                        BURN OPERATIONS
2167     // =============================================================
2168 
2169     /**
2170      * @dev Equivalent to `_burn(tokenId, false)`.
2171      */
2172     function _burn(uint256 tokenId) internal virtual {
2173         _burn(tokenId, false);
2174     }
2175 
2176     /**
2177      * @dev Destroys `tokenId`.
2178      * The approval is cleared when the token is burned.
2179      *
2180      * Requirements:
2181      *
2182      * - `tokenId` must exist.
2183      *
2184      * Emits a {Transfer} event.
2185      */
2186     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2187         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2188 
2189         address from = address(uint160(prevOwnershipPacked));
2190 
2191         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2192 
2193         if (approvalCheck) {
2194             // The nested ifs save around 20+ gas over a compound boolean condition.
2195             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2196                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2197         }
2198 
2199         _beforeTokenTransfers(from, address(0), tokenId, 1);
2200 
2201         // Clear approvals from the previous owner.
2202         assembly {
2203             if approvedAddress {
2204                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2205                 sstore(approvedAddressSlot, 0)
2206             }
2207         }
2208 
2209         // Underflow of the sender's balance is impossible because we check for
2210         // ownership above and the recipient's balance can't realistically overflow.
2211         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2212         unchecked {
2213             // Updates:
2214             // - `balance -= 1`.
2215             // - `numberBurned += 1`.
2216             //
2217             // We can directly decrement the balance, and increment the number burned.
2218             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2219             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2220 
2221             // Updates:
2222             // - `address` to the last owner.
2223             // - `startTimestamp` to the timestamp of burning.
2224             // - `burned` to `true`.
2225             // - `nextInitialized` to `true`.
2226             _packedOwnerships[tokenId] = _packOwnershipData(
2227                 from,
2228                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2229             );
2230 
2231             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2232             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2233                 uint256 nextTokenId = tokenId + 1;
2234                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2235                 if (_packedOwnerships[nextTokenId] == 0) {
2236                     // If the next slot is within bounds.
2237                     if (nextTokenId != _currentIndex) {
2238                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2239                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2240                     }
2241                 }
2242             }
2243         }
2244 
2245         emit Transfer(from, address(0), tokenId);
2246         _afterTokenTransfers(from, address(0), tokenId, 1);
2247 
2248         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2249         unchecked {
2250             _burnCounter++;
2251         }
2252     }
2253 
2254     // =============================================================
2255     //                     EXTRA DATA OPERATIONS
2256     // =============================================================
2257 
2258     /**
2259      * @dev Directly sets the extra data for the ownership data `index`.
2260      */
2261     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2262         uint256 packed = _packedOwnerships[index];
2263         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2264         uint256 extraDataCasted;
2265         // Cast `extraData` with assembly to avoid redundant masking.
2266         assembly {
2267             extraDataCasted := extraData
2268         }
2269         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2270         _packedOwnerships[index] = packed;
2271     }
2272 
2273     /**
2274      * @dev Called during each token transfer to set the 24bit `extraData` field.
2275      * Intended to be overridden by the cosumer contract.
2276      *
2277      * `previousExtraData` - the value of `extraData` before transfer.
2278      *
2279      * Calling conditions:
2280      *
2281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2282      * transferred to `to`.
2283      * - When `from` is zero, `tokenId` will be minted for `to`.
2284      * - When `to` is zero, `tokenId` will be burned by `from`.
2285      * - `from` and `to` are never both zero.
2286      */
2287     function _extraData(
2288         address from,
2289         address to,
2290         uint24 previousExtraData
2291     ) internal view virtual returns (uint24) {}
2292 
2293     /**
2294      * @dev Returns the next extra data for the packed ownership data.
2295      * The returned result is shifted into position.
2296      */
2297     function _nextExtraData(
2298         address from,
2299         address to,
2300         uint256 prevOwnershipPacked
2301     ) private view returns (uint256) {
2302         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2303         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2304     }
2305 
2306     // =============================================================
2307     //                       OTHER OPERATIONS
2308     // =============================================================
2309 
2310     /**
2311      * @dev Returns the message sender (defaults to `msg.sender`).
2312      *
2313      * If you are writing GSN compatible contracts, you need to override this function.
2314      */
2315     function _msgSenderERC721A() internal view virtual returns (address) {
2316         return msg.sender;
2317     }
2318 
2319     /**
2320      * @dev Converts a uint256 to its ASCII string decimal representation.
2321      */
2322     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2323         assembly {
2324             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2325             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2326             // We will need 1 32-byte word to store the length,
2327             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2328             ptr := add(mload(0x40), 128)
2329             // Update the free memory pointer to allocate.
2330             mstore(0x40, ptr)
2331 
2332             // Cache the end of the memory to calculate the length later.
2333             let end := ptr
2334 
2335             // We write the string from the rightmost digit to the leftmost digit.
2336             // The following is essentially a do-while loop that also handles the zero case.
2337             // Costs a bit more than early returning for the zero case,
2338             // but cheaper in terms of deployment and overall runtime costs.
2339             for {
2340                 // Initialize and perform the first pass without check.
2341                 let temp := value
2342                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2343                 ptr := sub(ptr, 1)
2344                 // Write the character to the pointer.
2345                 // The ASCII index of the '0' character is 48.
2346                 mstore8(ptr, add(48, mod(temp, 10)))
2347                 temp := div(temp, 10)
2348             } temp {
2349                 // Keep dividing `temp` until zero.
2350                 temp := div(temp, 10)
2351             } {
2352                 // Body of the for loop.
2353                 ptr := sub(ptr, 1)
2354                 mstore8(ptr, add(48, mod(temp, 10)))
2355             }
2356 
2357             let length := sub(end, ptr)
2358             // Move the pointer 32 bytes leftwards to make room for the length.
2359             ptr := sub(ptr, 32)
2360             // Store the length.
2361             mstore(ptr, length)
2362         }
2363     }
2364 }
2365 
2366 contract ShogunApes is Ownable, ERC721A, PaymentSplitter {
2367 
2368     using ECDSA for bytes32;
2369     using Strings for uint;
2370 
2371     address private signerAddressVIP;
2372     address private signerAddressWL;
2373 
2374     enum Step {
2375         Before,
2376         VIPSale,
2377         PublicSale,
2378         WhitelistSale,
2379         SoldOut,
2380         Reveal
2381     }
2382 
2383     string public baseURI;
2384 
2385     Step public sellingStep;
2386 
2387     uint private constant MAX_PUBLIC = 600;
2388     uint private constant MAX_VIP = 88;
2389     uint private constant MAX_WL = 200;
2390 
2391     uint public wlSalePrice = 0.01 ether;
2392     uint public publicSalePrice = 0.025 ether;
2393 
2394     mapping(address => uint) public mintedAmountNFTsperWalletWhitelistSale;
2395     mapping(address => uint) public mintedAmountNFTsperWalletVIPSale;
2396     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
2397 
2398     uint public maxMintAmountPerVIP = 1;
2399     uint public maxMintAmountPerWhitelist = 1; 
2400     uint public maxMintAmountPerPublic = 2; 
2401     uint public maxAmountPerTxnPublic = 2; 
2402 
2403     uint private teamLength;
2404 
2405     constructor(address[] memory _team, uint[] memory _teamShares, address _signerAddressVIP, address _signerAddressWL, string memory _baseURI) ERC721A("Shogun Apes", "SHOGUNAPES")
2406     PaymentSplitter(_team, _teamShares) {
2407         signerAddressVIP = _signerAddressVIP;
2408         signerAddressWL = _signerAddressWL;
2409         baseURI = _baseURI;
2410         teamLength = _team.length;
2411     }
2412 
2413     function mintForOpensea() external onlyOwner{
2414         if(totalSupply() != 0) revert("Only one mint for deployer");
2415         _mint(msg.sender, 1);
2416     }
2417 
2418     function VIPMint(uint _quantity, bytes calldata signature) external {
2419         if(sellingStep != Step.VIPSale) revert("VIP Mint is not open");
2420         if(totalSupply() + _quantity > MAX_VIP) revert("Max supply for VIP exceeded");
2421         if(signerAddressVIP != keccak256(
2422             abi.encodePacked(
2423                 "\x19Ethereum Signed Message:\n32",
2424                 bytes32(uint256(uint160(msg.sender)))
2425             )
2426         ).recover(signature)) revert("You are not in VIP whitelist");
2427         if(mintedAmountNFTsperWalletVIPSale[msg.sender] + _quantity > maxMintAmountPerVIP) revert("You can only get 1 NFT on the VIP Sale");
2428             
2429         mintedAmountNFTsperWalletVIPSale[msg.sender] += _quantity;
2430         
2431         // The _numberMinted is incremented internally
2432         _mint(msg.sender, _quantity);
2433     }
2434 
2435     function publicSaleMint(uint _quantity) external payable {
2436         uint price = publicSalePrice;
2437         if(price <= 0) revert("Price is 0");
2438 
2439         if(_quantity > maxAmountPerTxnPublic) revert("Max amount per txn is 2");
2440 
2441         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2442         if(totalSupply() + _quantity > (MAX_VIP + MAX_PUBLIC)) revert("Max supply exceeded for public exceeded");
2443         if(msg.value < price * _quantity) revert("Not enough funds");
2444 
2445         if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("You can only get 2 NFT on the Public Sale");
2446             
2447         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
2448 
2449         _mint(msg.sender, _quantity);
2450     }
2451 
2452     function WLMint(uint _quantity, bytes calldata signature) external payable {
2453         uint price = wlSalePrice;
2454         if(price <= 0) revert("Price is 0");
2455 
2456         if(sellingStep != Step.WhitelistSale) revert("WL Mint not live.");
2457         if(totalSupply() + _quantity > (MAX_VIP + MAX_PUBLIC + MAX_WL)) revert("Max supply exceeded for WL exceeded");
2458         if(msg.value < price * _quantity) revert("Not enough funds");          
2459         if(signerAddressWL != keccak256(
2460             abi.encodePacked(
2461                 "\x19Ethereum Signed Message:\n32",
2462                 bytes32(uint256(uint160(msg.sender)))
2463             )
2464         ).recover(signature)) revert("You are not in WL whitelist");
2465         if(mintedAmountNFTsperWalletWhitelistSale[msg.sender] + _quantity > maxMintAmountPerWhitelist) revert("You can only get 1 NFT on the Whitelist Sale");
2466             
2467         mintedAmountNFTsperWalletWhitelistSale[msg.sender] += _quantity;
2468         _mint(msg.sender, _quantity);
2469     }
2470 
2471     function currentState() external view returns (Step, uint, uint, uint, uint, uint, uint) {
2472         return (sellingStep, publicSalePrice, wlSalePrice, maxMintAmountPerVIP, maxMintAmountPerWhitelist, maxMintAmountPerPublic, maxAmountPerTxnPublic);
2473     }
2474 
2475     function changeWlSalePrice(uint256 new_price) external onlyOwner{
2476         wlSalePrice = new_price;
2477     }
2478 
2479     function changePublicSalePrice(uint256 new_price) external onlyOwner{
2480         publicSalePrice = new_price;
2481     }
2482 
2483     function setBaseUri(string memory _baseURI) external onlyOwner {
2484         baseURI = _baseURI;
2485     }
2486 
2487     function setStep(uint _step) external onlyOwner {
2488         sellingStep = Step(_step);
2489     }
2490 
2491     function setMaxMintPerVIP(uint amount) external onlyOwner {
2492         maxMintAmountPerVIP = amount;
2493     }
2494 
2495     function setMaxMintPerWhitelist(uint amount) external onlyOwner{
2496         maxMintAmountPerWhitelist = amount;
2497     }
2498 
2499     function setMaxMintPerPublic(uint amount) external onlyOwner{
2500         maxMintAmountPerPublic = amount;
2501     }
2502 
2503     function setMaxTxnPublic(uint amount) external onlyOwner{
2504         maxAmountPerTxnPublic = amount;
2505     }
2506 
2507     function getNumberMinted(address account) external view returns (uint256) {
2508         return _numberMinted(account);
2509     }
2510 
2511     function getNumberWLMinted(address account) external view returns (uint256) {
2512         return mintedAmountNFTsperWalletWhitelistSale[account];
2513     }
2514 
2515     function getNumberVIPMinted(address account) external view returns (uint256) {
2516         return mintedAmountNFTsperWalletVIPSale[account];
2517     }
2518 
2519     function getNumberPublicMinted(address account) external view returns (uint256) {
2520         return mintedAmountNFTsperWalletPublicSale[account];
2521     }
2522 
2523     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2524         require(_exists(_tokenId), "URI query for nonexistent token");
2525         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2526     }
2527 
2528     function releaseAll() external {
2529         for(uint i = 0 ; i < teamLength ; i++) {
2530             release(payable(payee(i)));
2531         }
2532     }
2533 }