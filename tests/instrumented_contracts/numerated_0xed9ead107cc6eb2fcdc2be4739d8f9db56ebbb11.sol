1 // File: code-sample/MagicBabyMonsters/interfaces/IToken.sol
2 
3 
4 
5 /// @title IToken interface
6 
7 pragma solidity ^0.8.6;
8 
9 interface IToken {
10     function mintAdmin(uint256 quantity, address to) external;
11 }
12 // File: code-sample/MagicBabyMonsters/interfaces/IDescriptor.sol
13 
14 
15 
16 /// @title IDescriptor interface
17 
18 pragma solidity ^0.8.6;
19 
20 interface IDescriptor {
21     function tokenURI(uint256 tokenId) external view returns (string memory);
22 }
23 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
24 
25 
26 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
32  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
33  *
34  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
35  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
36  * need to send a transaction, and thus is not required to hold Ether at all.
37  */
38 interface IERC20Permit {
39     /**
40      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
41      * given ``owner``'s signed approval.
42      *
43      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
44      * ordering also apply here.
45      *
46      * Emits an {Approval} event.
47      *
48      * Requirements:
49      *
50      * - `spender` cannot be the zero address.
51      * - `deadline` must be a timestamp in the future.
52      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
53      * over the EIP712-formatted function arguments.
54      * - the signature must use ``owner``'s current nonce (see {nonces}).
55      *
56      * For more information on the signature format, see the
57      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
58      * section].
59      */
60     function permit(
61         address owner,
62         address spender,
63         uint256 value,
64         uint256 deadline,
65         uint8 v,
66         bytes32 r,
67         bytes32 s
68     ) external;
69 
70     /**
71      * @dev Returns the current nonce for `owner`. This value must be
72      * included whenever a signature is generated for {permit}.
73      *
74      * Every successful call to {permit} increases ``owner``'s nonce by one. This
75      * prevents a signature from being used multiple times.
76      */
77     function nonces(address owner) external view returns (uint256);
78 
79     /**
80      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
81      */
82     // solhint-disable-next-line func-name-mixedcase
83     function DOMAIN_SEPARATOR() external view returns (bytes32);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `to`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address to, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `from` to `to` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address from,
166         address to,
167         uint256 amount
168     ) external returns (bool);
169 }
170 
171 // File: @openzeppelin/contracts/utils/Strings.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev String operations.
180  */
181 library Strings {
182     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
183     uint8 private constant _ADDRESS_LENGTH = 20;
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
187      */
188     function toString(uint256 value) internal pure returns (string memory) {
189         // Inspired by OraclizeAPI's implementation - MIT licence
190         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
191 
192         if (value == 0) {
193             return "0";
194         }
195         uint256 temp = value;
196         uint256 digits;
197         while (temp != 0) {
198             digits++;
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         while (value != 0) {
203             digits -= 1;
204             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
205             value /= 10;
206         }
207         return string(buffer);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
212      */
213     function toHexString(uint256 value) internal pure returns (string memory) {
214         if (value == 0) {
215             return "0x00";
216         }
217         uint256 temp = value;
218         uint256 length = 0;
219         while (temp != 0) {
220             length++;
221             temp >>= 8;
222         }
223         return toHexString(value, length);
224     }
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
228      */
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 
241     /**
242      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
243      */
244     function toHexString(address addr) internal pure returns (string memory) {
245         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
246     }
247 }
248 
249 // File: @openzeppelin/contracts/utils/Address.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
253 
254 pragma solidity ^0.8.1;
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      *
277      * [IMPORTANT]
278      * ====
279      * You shouldn't rely on `isContract` to protect against flash loan attacks!
280      *
281      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
282      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
283      * constructor.
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // This method relies on extcodesize/address.code.length, which returns 0
288         // for contracts in construction, since the code is only stored at the end
289         // of the constructor execution.
290 
291         return account.code.length > 0;
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         (bool success, ) = recipient.call{value: amount}("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain `call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
398         return functionStaticCall(target, data, "Address: low-level static call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal view returns (bytes memory) {
412         require(isContract(target), "Address: static call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.staticcall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(isContract(target), "Address: delegate call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.delegatecall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
447      * revert reason using the provided one.
448      *
449      * _Available since v4.3._
450      */
451     function verifyCallResult(
452         bool success,
453         bytes memory returndata,
454         string memory errorMessage
455     ) internal pure returns (bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462                 /// @solidity memory-safe-assembly
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 
483 
484 /**
485  * @title SafeERC20
486  * @dev Wrappers around ERC20 operations that throw on failure (when the token
487  * contract returns false). Tokens that return no value (and instead revert or
488  * throw on failure) are also supported, non-reverting calls are assumed to be
489  * successful.
490  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
491  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
492  */
493 library SafeERC20 {
494     using Address for address;
495 
496     function safeTransfer(
497         IERC20 token,
498         address to,
499         uint256 value
500     ) internal {
501         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
502     }
503 
504     function safeTransferFrom(
505         IERC20 token,
506         address from,
507         address to,
508         uint256 value
509     ) internal {
510         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
511     }
512 
513     /**
514      * @dev Deprecated. This function has issues similar to the ones found in
515      * {IERC20-approve}, and its usage is discouraged.
516      *
517      * Whenever possible, use {safeIncreaseAllowance} and
518      * {safeDecreaseAllowance} instead.
519      */
520     function safeApprove(
521         IERC20 token,
522         address spender,
523         uint256 value
524     ) internal {
525         // safeApprove should only be called when setting an initial allowance,
526         // or when resetting it to zero. To increase and decrease it, use
527         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
528         require(
529             (value == 0) || (token.allowance(address(this), spender) == 0),
530             "SafeERC20: approve from non-zero to non-zero allowance"
531         );
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
533     }
534 
535     function safeIncreaseAllowance(
536         IERC20 token,
537         address spender,
538         uint256 value
539     ) internal {
540         uint256 newAllowance = token.allowance(address(this), spender) + value;
541         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
542     }
543 
544     function safeDecreaseAllowance(
545         IERC20 token,
546         address spender,
547         uint256 value
548     ) internal {
549         unchecked {
550             uint256 oldAllowance = token.allowance(address(this), spender);
551             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
552             uint256 newAllowance = oldAllowance - value;
553             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
554         }
555     }
556 
557     function safePermit(
558         IERC20Permit token,
559         address owner,
560         address spender,
561         uint256 value,
562         uint256 deadline,
563         uint8 v,
564         bytes32 r,
565         bytes32 s
566     ) internal {
567         uint256 nonceBefore = token.nonces(owner);
568         token.permit(owner, spender, value, deadline, v, r, s);
569         uint256 nonceAfter = token.nonces(owner);
570         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
571     }
572 
573     /**
574      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
575      * on the return value: the return value is optional (but if data is returned, it must not be false).
576      * @param token The token targeted by the call.
577      * @param data The call data (encoded using abi.encode or one of its variants).
578      */
579     function _callOptionalReturn(IERC20 token, bytes memory data) private {
580         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
581         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
582         // the target address contains contract code and also asserts for success in the low-level call.
583 
584         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
585         if (returndata.length > 0) {
586             // Return data is optional
587             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
588         }
589     }
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
593 
594 
595 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title ERC721 token receiver interface
601  * @dev Interface for any contract that wants to support safeTransfers
602  * from ERC721 asset contracts.
603  */
604 interface IERC721Receiver {
605     /**
606      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
607      * by `operator` from `from`, this function is called.
608      *
609      * It must return its Solidity selector to confirm the token transfer.
610      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
611      *
612      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
613      */
614     function onERC721Received(
615         address operator,
616         address from,
617         uint256 tokenId,
618         bytes calldata data
619     ) external returns (bytes4);
620 }
621 
622 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Interface of the ERC165 standard, as defined in the
631  * https://eips.ethereum.org/EIPS/eip-165[EIP].
632  *
633  * Implementers can declare support of contract interfaces, which can then be
634  * queried by others ({ERC165Checker}).
635  *
636  * For an implementation, see {ERC165}.
637  */
638 interface IERC165 {
639     /**
640      * @dev Returns true if this contract implements the interface defined by
641      * `interfaceId`. See the corresponding
642      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
643      * to learn more about how these ids are created.
644      *
645      * This function call must use less than 30 000 gas.
646      */
647     function supportsInterface(bytes4 interfaceId) external view returns (bool);
648 }
649 
650 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 
658 /**
659  * @dev Implementation of the {IERC165} interface.
660  *
661  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
662  * for the additional interface id that will be supported. For example:
663  *
664  * ```solidity
665  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
666  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
667  * }
668  * ```
669  *
670  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
671  */
672 abstract contract ERC165 is IERC165 {
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         return interfaceId == type(IERC165).interfaceId;
678     }
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @dev Required interface of an ERC721 compliant contract.
691  */
692 interface IERC721 is IERC165 {
693     /**
694      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
695      */
696     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
697 
698     /**
699      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
700      */
701     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
702 
703     /**
704      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
705      */
706     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
707 
708     /**
709      * @dev Returns the number of tokens in ``owner``'s account.
710      */
711     function balanceOf(address owner) external view returns (uint256 balance);
712 
713     /**
714      * @dev Returns the owner of the `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function ownerOf(uint256 tokenId) external view returns (address owner);
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
732      *
733      * Emits a {Transfer} event.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes calldata data
740     ) external;
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
744      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must exist and be owned by `from`.
751      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
752      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) external;
761 
762     /**
763      * @dev Transfers `tokenId` token from `from` to `to`.
764      *
765      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must be owned by `from`.
772      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
773      *
774      * Emits a {Transfer} event.
775      */
776     function transferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external;
781 
782     /**
783      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
784      * The approval is cleared when the token is transferred.
785      *
786      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
787      *
788      * Requirements:
789      *
790      * - The caller must own the token or be an approved operator.
791      * - `tokenId` must exist.
792      *
793      * Emits an {Approval} event.
794      */
795     function approve(address to, uint256 tokenId) external;
796 
797     /**
798      * @dev Approve or remove `operator` as an operator for the caller.
799      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
800      *
801      * Requirements:
802      *
803      * - The `operator` cannot be the caller.
804      *
805      * Emits an {ApprovalForAll} event.
806      */
807     function setApprovalForAll(address operator, bool _approved) external;
808 
809     /**
810      * @dev Returns the account approved for `tokenId` token.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function getApproved(uint256 tokenId) external view returns (address operator);
817 
818     /**
819      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
820      *
821      * See {setApprovalForAll}
822      */
823     function isApprovedForAll(address owner, address operator) external view returns (bool);
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
827 
828 
829 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
836  * @dev See https://eips.ethereum.org/EIPS/eip-721
837  */
838 interface IERC721Metadata is IERC721 {
839     /**
840      * @dev Returns the token collection name.
841      */
842     function name() external view returns (string memory);
843 
844     /**
845      * @dev Returns the token collection symbol.
846      */
847     function symbol() external view returns (string memory);
848 
849     /**
850      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
851      */
852     function tokenURI(uint256 tokenId) external view returns (string memory);
853 }
854 
855 // File: @openzeppelin/contracts/utils/Context.sol
856 
857 
858 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 /**
863  * @dev Provides information about the current execution context, including the
864  * sender of the transaction and its data. While these are generally available
865  * via msg.sender and msg.data, they should not be accessed in such a direct
866  * manner, since when dealing with meta-transactions the account sending and
867  * paying for execution may not be the actual sender (as far as an application
868  * is concerned).
869  *
870  * This contract is only required for intermediate, library-like contracts.
871  */
872 abstract contract Context {
873     function _msgSender() internal view virtual returns (address) {
874         return msg.sender;
875     }
876 
877     function _msgData() internal view virtual returns (bytes calldata) {
878         return msg.data;
879     }
880 }
881 
882 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
883 
884 
885 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 
891 
892 /**
893  * @title PaymentSplitter
894  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
895  * that the Ether will be split in this way, since it is handled transparently by the contract.
896  *
897  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
898  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
899  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
900  * time of contract deployment and can't be updated thereafter.
901  *
902  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
903  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
904  * function.
905  *
906  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
907  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
908  * to run tests before sending real value to this contract.
909  */
910 contract PaymentSplitter is Context {
911     event PayeeAdded(address account, uint256 shares);
912     event PaymentReleased(address to, uint256 amount);
913     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
914     event PaymentReceived(address from, uint256 amount);
915 
916     uint256 private _totalShares;
917     uint256 private _totalReleased;
918 
919     mapping(address => uint256) private _shares;
920     mapping(address => uint256) private _released;
921     address[] private _payees;
922 
923     mapping(IERC20 => uint256) private _erc20TotalReleased;
924     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
925 
926     /**
927      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
928      * the matching position in the `shares` array.
929      *
930      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
931      * duplicates in `payees`.
932      */
933     constructor(address[] memory payees, uint256[] memory shares_) payable {
934         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
935         require(payees.length > 0, "PaymentSplitter: no payees");
936 
937         for (uint256 i = 0; i < payees.length; i++) {
938             _addPayee(payees[i], shares_[i]);
939         }
940     }
941 
942     /**
943      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
944      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
945      * reliability of the events, and not the actual splitting of Ether.
946      *
947      * To learn more about this see the Solidity documentation for
948      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
949      * functions].
950      */
951     receive() external payable virtual {
952         emit PaymentReceived(_msgSender(), msg.value);
953     }
954 
955     /**
956      * @dev Getter for the total shares held by payees.
957      */
958     function totalShares() public view returns (uint256) {
959         return _totalShares;
960     }
961 
962     /**
963      * @dev Getter for the total amount of Ether already released.
964      */
965     function totalReleased() public view returns (uint256) {
966         return _totalReleased;
967     }
968 
969     /**
970      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
971      * contract.
972      */
973     function totalReleased(IERC20 token) public view returns (uint256) {
974         return _erc20TotalReleased[token];
975     }
976 
977     /**
978      * @dev Getter for the amount of shares held by an account.
979      */
980     function shares(address account) public view returns (uint256) {
981         return _shares[account];
982     }
983 
984     /**
985      * @dev Getter for the amount of Ether already released to a payee.
986      */
987     function released(address account) public view returns (uint256) {
988         return _released[account];
989     }
990 
991     /**
992      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
993      * IERC20 contract.
994      */
995     function released(IERC20 token, address account) public view returns (uint256) {
996         return _erc20Released[token][account];
997     }
998 
999     /**
1000      * @dev Getter for the address of the payee number `index`.
1001      */
1002     function payee(uint256 index) public view returns (address) {
1003         return _payees[index];
1004     }
1005 
1006     /**
1007      * @dev Getter for the amount of payee's releasable Ether.
1008      */
1009     function releasable(address account) public view returns (uint256) {
1010         uint256 totalReceived = address(this).balance + totalReleased();
1011         return _pendingPayment(account, totalReceived, released(account));
1012     }
1013 
1014     /**
1015      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1016      * IERC20 contract.
1017      */
1018     function releasable(IERC20 token, address account) public view returns (uint256) {
1019         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1020         return _pendingPayment(account, totalReceived, released(token, account));
1021     }
1022 
1023     /**
1024      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1025      * total shares and their previous withdrawals.
1026      */
1027     function release(address payable account) public virtual {
1028         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1029 
1030         uint256 payment = releasable(account);
1031 
1032         require(payment != 0, "PaymentSplitter: account is not due payment");
1033 
1034         _released[account] += payment;
1035         _totalReleased += payment;
1036 
1037         Address.sendValue(account, payment);
1038         emit PaymentReleased(account, payment);
1039     }
1040 
1041     /**
1042      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1043      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1044      * contract.
1045      */
1046     function release(IERC20 token, address account) public virtual {
1047         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1048 
1049         uint256 payment = releasable(token, account);
1050 
1051         require(payment != 0, "PaymentSplitter: account is not due payment");
1052 
1053         _erc20Released[token][account] += payment;
1054         _erc20TotalReleased[token] += payment;
1055 
1056         SafeERC20.safeTransfer(token, account, payment);
1057         emit ERC20PaymentReleased(token, account, payment);
1058     }
1059 
1060     /**
1061      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1062      * already released amounts.
1063      */
1064     function _pendingPayment(
1065         address account,
1066         uint256 totalReceived,
1067         uint256 alreadyReleased
1068     ) private view returns (uint256) {
1069         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1070     }
1071 
1072     /**
1073      * @dev Add a new payee to the contract.
1074      * @param account The address of the payee to add.
1075      * @param shares_ The number of shares owned by the payee.
1076      */
1077     function _addPayee(address account, uint256 shares_) private {
1078         require(account != address(0), "PaymentSplitter: account is the zero address");
1079         require(shares_ > 0, "PaymentSplitter: shares are 0");
1080         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1081 
1082         _payees.push(account);
1083         _shares[account] = shares_;
1084         _totalShares = _totalShares + shares_;
1085         emit PayeeAdded(account, shares_);
1086     }
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1090 
1091 
1092 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 /**
1104  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1105  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1106  * {ERC721Enumerable}.
1107  */
1108 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1109     using Address for address;
1110     using Strings for uint256;
1111 
1112     // Token name
1113     string private _name;
1114 
1115     // Token symbol
1116     string private _symbol;
1117 
1118     // Mapping from token ID to owner address
1119     mapping(uint256 => address) private _owners;
1120 
1121     // Mapping owner address to token count
1122     mapping(address => uint256) private _balances;
1123 
1124     // Mapping from token ID to approved address
1125     mapping(uint256 => address) private _tokenApprovals;
1126 
1127     // Mapping from owner to operator approvals
1128     mapping(address => mapping(address => bool)) private _operatorApprovals;
1129 
1130     /**
1131      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1132      */
1133     constructor(string memory name_, string memory symbol_) {
1134         _name = name_;
1135         _symbol = symbol_;
1136     }
1137 
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1142         return
1143             interfaceId == type(IERC721).interfaceId ||
1144             interfaceId == type(IERC721Metadata).interfaceId ||
1145             super.supportsInterface(interfaceId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-balanceOf}.
1150      */
1151     function balanceOf(address owner) public view virtual override returns (uint256) {
1152         require(owner != address(0), "ERC721: address zero is not a valid owner");
1153         return _balances[owner];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-ownerOf}.
1158      */
1159     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1160         address owner = _owners[tokenId];
1161         require(owner != address(0), "ERC721: invalid token ID");
1162         return owner;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-name}.
1167      */
1168     function name() public view virtual override returns (string memory) {
1169         return _name;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-symbol}.
1174      */
1175     function symbol() public view virtual override returns (string memory) {
1176         return _symbol;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Metadata-tokenURI}.
1181      */
1182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1183         _requireMinted(tokenId);
1184 
1185         string memory baseURI = _baseURI();
1186         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1187     }
1188 
1189     /**
1190      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1192      * by default, can be overridden in child contracts.
1193      */
1194     function _baseURI() internal view virtual returns (string memory) {
1195         return "";
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-approve}.
1200      */
1201     function approve(address to, uint256 tokenId) public virtual override {
1202         address owner = ERC721.ownerOf(tokenId);
1203         require(to != owner, "ERC721: approval to current owner");
1204 
1205         require(
1206             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1207             "ERC721: approve caller is not token owner nor approved for all"
1208         );
1209 
1210         _approve(to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-getApproved}.
1215      */
1216     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1217         _requireMinted(tokenId);
1218 
1219         return _tokenApprovals[tokenId];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-setApprovalForAll}.
1224      */
1225     function setApprovalForAll(address operator, bool approved) public virtual override {
1226         _setApprovalForAll(_msgSender(), operator, approved);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-isApprovedForAll}.
1231      */
1232     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1233         return _operatorApprovals[owner][operator];
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-transferFrom}.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) public virtual override {
1244         //solhint-disable-next-line max-line-length
1245         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1246 
1247         _transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public virtual override {
1258         safeTransferFrom(from, to, tokenId, "");
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory data
1269     ) public virtual override {
1270         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1271         _safeTransfer(from, to, tokenId, data);
1272     }
1273 
1274     /**
1275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1277      *
1278      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1279      *
1280      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1281      * implement alternative mechanisms to perform token transfer, such as signature-based.
1282      *
1283      * Requirements:
1284      *
1285      * - `from` cannot be the zero address.
1286      * - `to` cannot be the zero address.
1287      * - `tokenId` token must exist and be owned by `from`.
1288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _safeTransfer(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory data
1297     ) internal virtual {
1298         _transfer(from, to, tokenId);
1299         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1300     }
1301 
1302     /**
1303      * @dev Returns whether `tokenId` exists.
1304      *
1305      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1306      *
1307      * Tokens start existing when they are minted (`_mint`),
1308      * and stop existing when they are burned (`_burn`).
1309      */
1310     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1311         return _owners[tokenId] != address(0);
1312     }
1313 
1314     /**
1315      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      */
1321     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1322         address owner = ERC721.ownerOf(tokenId);
1323         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1324     }
1325 
1326     /**
1327      * @dev Safely mints `tokenId` and transfers it to `to`.
1328      *
1329      * Requirements:
1330      *
1331      * - `tokenId` must not exist.
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _safeMint(address to, uint256 tokenId) internal virtual {
1337         _safeMint(to, tokenId, "");
1338     }
1339 
1340     /**
1341      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1342      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1343      */
1344     function _safeMint(
1345         address to,
1346         uint256 tokenId,
1347         bytes memory data
1348     ) internal virtual {
1349         _mint(to, tokenId);
1350         require(
1351             _checkOnERC721Received(address(0), to, tokenId, data),
1352             "ERC721: transfer to non ERC721Receiver implementer"
1353         );
1354     }
1355 
1356     /**
1357      * @dev Mints `tokenId` and transfers it to `to`.
1358      *
1359      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must not exist.
1364      * - `to` cannot be the zero address.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _mint(address to, uint256 tokenId) internal virtual {
1369         require(to != address(0), "ERC721: mint to the zero address");
1370         require(!_exists(tokenId), "ERC721: token already minted");
1371 
1372         _beforeTokenTransfer(address(0), to, tokenId);
1373 
1374         _balances[to] += 1;
1375         _owners[tokenId] = to;
1376 
1377         emit Transfer(address(0), to, tokenId);
1378 
1379         _afterTokenTransfer(address(0), to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev Destroys `tokenId`.
1384      * The approval is cleared when the token is burned.
1385      *
1386      * Requirements:
1387      *
1388      * - `tokenId` must exist.
1389      *
1390      * Emits a {Transfer} event.
1391      */
1392     function _burn(uint256 tokenId) internal virtual {
1393         address owner = ERC721.ownerOf(tokenId);
1394 
1395         _beforeTokenTransfer(owner, address(0), tokenId);
1396 
1397         // Clear approvals
1398         _approve(address(0), tokenId);
1399 
1400         _balances[owner] -= 1;
1401         delete _owners[tokenId];
1402 
1403         emit Transfer(owner, address(0), tokenId);
1404 
1405         _afterTokenTransfer(owner, address(0), tokenId);
1406     }
1407 
1408     /**
1409      * @dev Transfers `tokenId` from `from` to `to`.
1410      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1411      *
1412      * Requirements:
1413      *
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must be owned by `from`.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function _transfer(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) internal virtual {
1424         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1425         require(to != address(0), "ERC721: transfer to the zero address");
1426 
1427         _beforeTokenTransfer(from, to, tokenId);
1428 
1429         // Clear approvals from the previous owner
1430         _approve(address(0), tokenId);
1431 
1432         _balances[from] -= 1;
1433         _balances[to] += 1;
1434         _owners[tokenId] = to;
1435 
1436         emit Transfer(from, to, tokenId);
1437 
1438         _afterTokenTransfer(from, to, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Approve `to` to operate on `tokenId`
1443      *
1444      * Emits an {Approval} event.
1445      */
1446     function _approve(address to, uint256 tokenId) internal virtual {
1447         _tokenApprovals[tokenId] = to;
1448         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev Approve `operator` to operate on all of `owner` tokens
1453      *
1454      * Emits an {ApprovalForAll} event.
1455      */
1456     function _setApprovalForAll(
1457         address owner,
1458         address operator,
1459         bool approved
1460     ) internal virtual {
1461         require(owner != operator, "ERC721: approve to caller");
1462         _operatorApprovals[owner][operator] = approved;
1463         emit ApprovalForAll(owner, operator, approved);
1464     }
1465 
1466     /**
1467      * @dev Reverts if the `tokenId` has not been minted yet.
1468      */
1469     function _requireMinted(uint256 tokenId) internal view virtual {
1470         require(_exists(tokenId), "ERC721: invalid token ID");
1471     }
1472 
1473     /**
1474      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1475      * The call is not executed if the target address is not a contract.
1476      *
1477      * @param from address representing the previous owner of the given token ID
1478      * @param to target address that will receive the tokens
1479      * @param tokenId uint256 ID of the token to be transferred
1480      * @param data bytes optional data to send along with the call
1481      * @return bool whether the call correctly returned the expected magic value
1482      */
1483     function _checkOnERC721Received(
1484         address from,
1485         address to,
1486         uint256 tokenId,
1487         bytes memory data
1488     ) private returns (bool) {
1489         if (to.isContract()) {
1490             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1491                 return retval == IERC721Receiver.onERC721Received.selector;
1492             } catch (bytes memory reason) {
1493                 if (reason.length == 0) {
1494                     revert("ERC721: transfer to non ERC721Receiver implementer");
1495                 } else {
1496                     /// @solidity memory-safe-assembly
1497                     assembly {
1498                         revert(add(32, reason), mload(reason))
1499                     }
1500                 }
1501             }
1502         } else {
1503             return true;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Hook that is called before any token transfer. This includes minting
1509      * and burning.
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1517      * - `from` and `to` are never both zero.
1518      *
1519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1520      */
1521     function _beforeTokenTransfer(
1522         address from,
1523         address to,
1524         uint256 tokenId
1525     ) internal virtual {}
1526 
1527     /**
1528      * @dev Hook that is called after any transfer of tokens. This includes
1529      * minting and burning.
1530      *
1531      * Calling conditions:
1532      *
1533      * - when `from` and `to` are both non-zero.
1534      * - `from` and `to` are never both zero.
1535      *
1536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1537      */
1538     function _afterTokenTransfer(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) internal virtual {}
1543 }
1544 
1545 // File: @openzeppelin/contracts/access/Ownable.sol
1546 
1547 
1548 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 
1553 /**
1554  * @dev Contract module which provides a basic access control mechanism, where
1555  * there is an account (an owner) that can be granted exclusive access to
1556  * specific functions.
1557  *
1558  * By default, the owner account will be the one that deploys the contract. This
1559  * can later be changed with {transferOwnership}.
1560  *
1561  * This module is used through inheritance. It will make available the modifier
1562  * `onlyOwner`, which can be applied to your functions to restrict their use to
1563  * the owner.
1564  */
1565 abstract contract Ownable is Context {
1566     address private _owner;
1567 
1568     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1569 
1570     /**
1571      * @dev Initializes the contract setting the deployer as the initial owner.
1572      */
1573     constructor() {
1574         _transferOwnership(_msgSender());
1575     }
1576 
1577     /**
1578      * @dev Throws if called by any account other than the owner.
1579      */
1580     modifier onlyOwner() {
1581         _checkOwner();
1582         _;
1583     }
1584 
1585     /**
1586      * @dev Returns the address of the current owner.
1587      */
1588     function owner() public view virtual returns (address) {
1589         return _owner;
1590     }
1591 
1592     /**
1593      * @dev Throws if the sender is not the owner.
1594      */
1595     function _checkOwner() internal view virtual {
1596         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1597     }
1598 
1599     /**
1600      * @dev Leaves the contract without owner. It will not be possible to call
1601      * `onlyOwner` functions anymore. Can only be called by the current owner.
1602      *
1603      * NOTE: Renouncing ownership will leave the contract without an owner,
1604      * thereby removing any functionality that is only available to the owner.
1605      */
1606     function renounceOwnership() public virtual onlyOwner {
1607         _transferOwnership(address(0));
1608     }
1609 
1610     /**
1611      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1612      * Can only be called by the current owner.
1613      */
1614     function transferOwnership(address newOwner) public virtual onlyOwner {
1615         require(newOwner != address(0), "Ownable: new owner is the zero address");
1616         _transferOwnership(newOwner);
1617     }
1618 
1619     /**
1620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1621      * Internal function without access restriction.
1622      */
1623     function _transferOwnership(address newOwner) internal virtual {
1624         address oldOwner = _owner;
1625         _owner = newOwner;
1626         emit OwnershipTransferred(oldOwner, newOwner);
1627     }
1628 }
1629 
1630 // File: code-sample/MagicBabyMonsters/MagicBabyMonsters.sol
1631 
1632 
1633 
1634 pragma solidity ^0.8.6;
1635 
1636 
1637 
1638 
1639 
1640 
1641 
1642 contract MagicBabyMonster is Ownable, ERC721, PaymentSplitter,IToken  {
1643     using Strings for uint256;
1644 
1645     // Sale details
1646     uint256 public maxTokens = 5000; 
1647     uint256 public maxMintsPerTx = 3;
1648     uint256 public price = .01 ether; 
1649     bool public saleActive;
1650 
1651     // When set, diverts tokenURI calls to external contract
1652     address public descriptor;
1653     // Only used when `descriptor` is 0x0
1654     string public baseURI;
1655 
1656     uint256 private nowTokenId = 0;
1657 
1658     // Admin access for privileged contracts
1659     mapping(address => bool) public admins;
1660 
1661     /**
1662      * @notice Caller must be owner or privileged admin contract.
1663      */
1664     modifier onlyAdmin() {
1665         require(owner() == _msgSender() || admins[msg.sender], "Not admin");
1666         _;
1667     }
1668 
1669     constructor(address[] memory payees, uint256[] memory shares)
1670       ERC721("Magic Baby Monster", "MBM")
1671       PaymentSplitter(payees, shares)
1672     {}
1673 
1674     /**
1675      * @dev Public mint.
1676      */
1677     function mint(uint256 quantity) external payable {
1678         require(saleActive, "Sale inactive");
1679         require(quantity <= maxMintsPerTx, "Too many mints per txn");
1680         require(nowTokenId + quantity <= maxTokens , "Exceeds max supply");
1681         require(msg.value >= price * quantity, "Not enough ether");
1682         require(msg.sender == tx.origin, "No contract mints");
1683 
1684         for (uint256 i = 0; i < quantity; i++) {
1685             _safeMint(msg.sender, ++nowTokenId);
1686         }
1687     }
1688 
1689     /**
1690      * @dev Return tokenURI directly or via alternative `descriptor` contract
1691      */
1692     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1693         require(_exists(tokenId), "URI query for nonexistent token");
1694 
1695         if (descriptor == address(0)) {
1696             return string(abi.encodePacked(baseURI, tokenId.toString()));
1697         } else {
1698             return IDescriptor(descriptor).tokenURI(tokenId);
1699         }
1700         
1701     }
1702 
1703     /**
1704      * @dev Simplified version of ERC721Enumberable's `totalSupply`
1705      */
1706     function totalSupply() external view returns (uint256) {
1707         return nowTokenId;
1708     }
1709 
1710     /**
1711      * @dev Set `descriptor` contract address to route `tokenURI`
1712      */
1713     function setDescriptor(address _descriptor) external onlyOwner {
1714         descriptor = _descriptor;
1715     }
1716 
1717     /**
1718      * @dev Set the `baseURI` used to construct `tokenURI`.
1719      */
1720     function setBaseURI(string memory _baseURI) external onlyOwner {
1721         baseURI = _baseURI;
1722     }
1723 
1724     /**
1725      * @dev Enable adjusting max mints per transaction.
1726      */
1727     function setMaxMintsPerTxn(uint256 newMax) external onlyOwner {
1728         maxMintsPerTx = newMax;
1729     }
1730 
1731     /**
1732      * @dev Enable adjusting price.
1733      */
1734     function setPrice(uint256 newPriceWei) external onlyOwner {
1735         price = newPriceWei;
1736     }
1737 
1738     /**
1739      * @dev Toggle sale status.
1740      */
1741     function toggleSale() external onlyOwner {
1742         saleActive = !saleActive;
1743     }
1744 
1745     /**
1746      * @dev Toggle admin status for an address.
1747      */
1748     function setAdmin(address _address) external onlyOwner {
1749         admins[_address] = !admins[_address];
1750     }
1751 
1752     /**
1753      * @dev Admin mint. 
1754      */
1755     function mintAdmin(uint256 quantity, address to) external override onlyAdmin {
1756         require(nowTokenId + quantity <= maxTokens , "Exceeds max supply");
1757 
1758         for (uint256 i = 0; i < quantity; i++) {
1759             _safeMint(to, ++nowTokenId);
1760         }
1761     }
1762 
1763 }