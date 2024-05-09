1 // SPDX-License-Identifier: MIT
2 // Creator: XCart Dev Team
3 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
12  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
13  *
14  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
15  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
16  * need to send a transaction, and thus is not required to hold Ether at all.
17  */
18 interface IERC20Permit {
19     /**
20      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
21      * given ``owner``'s signed approval.
22      *
23      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
24      * ordering also apply here.
25      *
26      * Emits an {Approval} event.
27      *
28      * Requirements:
29      *
30      * - `spender` cannot be the zero address.
31      * - `deadline` must be a timestamp in the future.
32      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
33      * over the EIP712-formatted function arguments.
34      * - the signature must use ``owner``'s current nonce (see {nonces}).
35      *
36      * For more information on the signature format, see the
37      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
38      * section].
39      */
40     function permit(
41         address owner,
42         address spender,
43         uint256 value,
44         uint256 deadline,
45         uint8 v,
46         bytes32 r,
47         bytes32 s
48     ) external;
49 
50     /**
51      * @dev Returns the current nonce for `owner`. This value must be
52      * included whenever a signature is generated for {permit}.
53      *
54      * Every successful call to {permit} increases ``owner``'s nonce by one. This
55      * prevents a signature from being used multiple times.
56      */
57     function nonces(address owner) external view returns (uint256);
58 
59     /**
60      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
61      */
62     // solhint-disable-next-line func-name-mixedcase
63     function DOMAIN_SEPARATOR() external view returns (bytes32);
64 }
65 
66 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
67 
68 
69 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev Interface of the ERC20 standard as defined in the EIP.
75  */
76 interface IERC20 {
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100 
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `to`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address to, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Moves `amount` tokens from `from` to `to` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address from,
146         address to,
147         uint256 amount
148     ) external returns (bool);
149 }
150 
151 // File: @openzeppelin/contracts/utils/Strings.sol
152 
153 
154 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev String operations.
160  */
161 library Strings {
162     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
163     uint8 private constant _ADDRESS_LENGTH = 20;
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
167      */
168     function toString(uint256 value) internal pure returns (string memory) {
169         // Inspired by OraclizeAPI's implementation - MIT licence
170         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
171 
172         if (value == 0) {
173             return "0";
174         }
175         uint256 temp = value;
176         uint256 digits;
177         while (temp != 0) {
178             digits++;
179             temp /= 10;
180         }
181         bytes memory buffer = new bytes(digits);
182         while (value != 0) {
183             digits -= 1;
184             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
185             value /= 10;
186         }
187         return string(buffer);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
192      */
193     function toHexString(uint256 value) internal pure returns (string memory) {
194         if (value == 0) {
195             return "0x00";
196         }
197         uint256 temp = value;
198         uint256 length = 0;
199         while (temp != 0) {
200             length++;
201             temp >>= 8;
202         }
203         return toHexString(value, length);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
208      */
209     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
210         bytes memory buffer = new bytes(2 * length + 2);
211         buffer[0] = "0";
212         buffer[1] = "x";
213         for (uint256 i = 2 * length + 1; i > 1; --i) {
214             buffer[i] = _HEX_SYMBOLS[value & 0xf];
215             value >>= 4;
216         }
217         require(value == 0, "Strings: hex length insufficient");
218         return string(buffer);
219     }
220 
221     /**
222      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
223      */
224     function toHexString(address addr) internal pure returns (string memory) {
225         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Context.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/access/Ownable.sol
257 
258 
259 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * By default, the owner account will be the one that deploys the contract. This
270  * can later be changed with {transferOwnership}.
271  *
272  * This module is used through inheritance. It will make available the modifier
273  * `onlyOwner`, which can be applied to your functions to restrict their use to
274  * the owner.
275  */
276 abstract contract Ownable is Context {
277     address private _owner;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor() {
285         _transferOwnership(_msgSender());
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         _checkOwner();
293         _;
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view virtual returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if the sender is not the owner.
305      */
306     function _checkOwner() internal view virtual {
307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _transferOwnership(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Address.sol
342 
343 
344 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
345 
346 pragma solidity ^0.8.1;
347 
348 /**
349  * @dev Collection of functions related to the address type
350  */
351 library Address {
352     /**
353      * @dev Returns true if `account` is a contract.
354      *
355      * [IMPORTANT]
356      * ====
357      * It is unsafe to assume that an address for which this function returns
358      * false is an externally-owned account (EOA) and not a contract.
359      *
360      * Among others, `isContract` will return false for the following
361      * types of addresses:
362      *
363      *  - an externally-owned account
364      *  - a contract in construction
365      *  - an address where a contract will be created
366      *  - an address where a contract lived, but was destroyed
367      * ====
368      *
369      * [IMPORTANT]
370      * ====
371      * You shouldn't rely on `isContract` to protect against flash loan attacks!
372      *
373      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
374      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
375      * constructor.
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // This method relies on extcodesize/address.code.length, which returns 0
380         // for contracts in construction, since the code is only stored at the end
381         // of the constructor execution.
382 
383         return account.code.length > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain `call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but also transferring `value` wei to `target`.
448      *
449      * Requirements:
450      *
451      * - the calling contract must have an ETH balance of at least `value`.
452      * - the called Solidity function must be `payable`.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554                 /// @solidity memory-safe-assembly
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 
576 /**
577  * @title SafeERC20
578  * @dev Wrappers around ERC20 operations that throw on failure (when the token
579  * contract returns false). Tokens that return no value (and instead revert or
580  * throw on failure) are also supported, non-reverting calls are assumed to be
581  * successful.
582  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
583  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
584  */
585 library SafeERC20 {
586     using Address for address;
587 
588     function safeTransfer(
589         IERC20 token,
590         address to,
591         uint256 value
592     ) internal {
593         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
594     }
595 
596     function safeTransferFrom(
597         IERC20 token,
598         address from,
599         address to,
600         uint256 value
601     ) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
603     }
604 
605     /**
606      * @dev Deprecated. This function has issues similar to the ones found in
607      * {IERC20-approve}, and its usage is discouraged.
608      *
609      * Whenever possible, use {safeIncreaseAllowance} and
610      * {safeDecreaseAllowance} instead.
611      */
612     function safeApprove(
613         IERC20 token,
614         address spender,
615         uint256 value
616     ) internal {
617         // safeApprove should only be called when setting an initial allowance,
618         // or when resetting it to zero. To increase and decrease it, use
619         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
620         require(
621             (value == 0) || (token.allowance(address(this), spender) == 0),
622             "SafeERC20: approve from non-zero to non-zero allowance"
623         );
624         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
625     }
626 
627     function safeIncreaseAllowance(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         uint256 newAllowance = token.allowance(address(this), spender) + value;
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
634     }
635 
636     function safeDecreaseAllowance(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         unchecked {
642             uint256 oldAllowance = token.allowance(address(this), spender);
643             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
644             uint256 newAllowance = oldAllowance - value;
645             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
646         }
647     }
648 
649     function safePermit(
650         IERC20Permit token,
651         address owner,
652         address spender,
653         uint256 value,
654         uint256 deadline,
655         uint8 v,
656         bytes32 r,
657         bytes32 s
658     ) internal {
659         uint256 nonceBefore = token.nonces(owner);
660         token.permit(owner, spender, value, deadline, v, r, s);
661         uint256 nonceAfter = token.nonces(owner);
662         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
663     }
664 
665     /**
666      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
667      * on the return value: the return value is optional (but if data is returned, it must not be false).
668      * @param token The token targeted by the call.
669      * @param data The call data (encoded using abi.encode or one of its variants).
670      */
671     function _callOptionalReturn(IERC20 token, bytes memory data) private {
672         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
673         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
674         // the target address contains contract code and also asserts for success in the low-level call.
675 
676         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
677         if (returndata.length > 0) {
678             // Return data is optional
679             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
680         }
681     }
682 }
683 
684 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Interface of the ERC165 standard, as defined in the
693  * https://eips.ethereum.org/EIPS/eip-165[EIP].
694  *
695  * Implementers can declare support of contract interfaces, which can then be
696  * queried by others ({ERC165Checker}).
697  *
698  * For an implementation, see {ERC165}.
699  */
700 interface IERC165 {
701     /**
702      * @dev Returns true if this contract implements the interface defined by
703      * `interfaceId`. See the corresponding
704      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
705      * to learn more about how these ids are created.
706      *
707      * This function call must use less than 30 000 gas.
708      */
709     function supportsInterface(bytes4 interfaceId) external view returns (bool);
710 }
711 
712 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Implementation of the {IERC165} interface.
722  *
723  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
724  * for the additional interface id that will be supported. For example:
725  *
726  * ```solidity
727  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
729  * }
730  * ```
731  *
732  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
733  */
734 abstract contract ERC165 is IERC165 {
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739         return interfaceId == type(IERC165).interfaceId;
740     }
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
744 
745 
746 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev _Available since v3.1._
753  */
754 interface IERC1155Receiver is IERC165 {
755     /**
756      * @dev Handles the receipt of a single ERC1155 token type. This function is
757      * called at the end of a `safeTransferFrom` after the balance has been updated.
758      *
759      * NOTE: To accept the transfer, this must return
760      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
761      * (i.e. 0xf23a6e61, or its own function selector).
762      *
763      * @param operator The address which initiated the transfer (i.e. msg.sender)
764      * @param from The address which previously owned the token
765      * @param id The ID of the token being transferred
766      * @param value The amount of tokens being transferred
767      * @param data Additional data with no specified format
768      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
769      */
770     function onERC1155Received(
771         address operator,
772         address from,
773         uint256 id,
774         uint256 value,
775         bytes calldata data
776     ) external returns (bytes4);
777 
778     /**
779      * @dev Handles the receipt of a multiple ERC1155 token types. This function
780      * is called at the end of a `safeBatchTransferFrom` after the balances have
781      * been updated.
782      *
783      * NOTE: To accept the transfer(s), this must return
784      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
785      * (i.e. 0xbc197c81, or its own function selector).
786      *
787      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
788      * @param from The address which previously owned the token
789      * @param ids An array containing ids of each token being transferred (order and length must match values array)
790      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
791      * @param data Additional data with no specified format
792      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
793      */
794     function onERC1155BatchReceived(
795         address operator,
796         address from,
797         uint256[] calldata ids,
798         uint256[] calldata values,
799         bytes calldata data
800     ) external returns (bytes4);
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 
811 /**
812  * @dev Required interface of an ERC1155 compliant contract, as defined in the
813  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
814  *
815  * _Available since v3.1._
816  */
817 interface IERC1155 is IERC165 {
818     /**
819      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
820      */
821     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
822 
823     /**
824      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
825      * transfers.
826      */
827     event TransferBatch(
828         address indexed operator,
829         address indexed from,
830         address indexed to,
831         uint256[] ids,
832         uint256[] values
833     );
834 
835     /**
836      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
837      * `approved`.
838      */
839     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
840 
841     /**
842      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
843      *
844      * If an {URI} event was emitted for `id`, the standard
845      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
846      * returned by {IERC1155MetadataURI-uri}.
847      */
848     event URI(string value, uint256 indexed id);
849 
850     /**
851      * @dev Returns the amount of tokens of token type `id` owned by `account`.
852      *
853      * Requirements:
854      *
855      * - `account` cannot be the zero address.
856      */
857     function balanceOf(address account, uint256 id) external view returns (uint256);
858 
859     /**
860      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
861      *
862      * Requirements:
863      *
864      * - `accounts` and `ids` must have the same length.
865      */
866     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
867         external
868         view
869         returns (uint256[] memory);
870 
871     /**
872      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
873      *
874      * Emits an {ApprovalForAll} event.
875      *
876      * Requirements:
877      *
878      * - `operator` cannot be the caller.
879      */
880     function setApprovalForAll(address operator, bool approved) external;
881 
882     /**
883      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
884      *
885      * See {setApprovalForAll}.
886      */
887     function isApprovedForAll(address account, address operator) external view returns (bool);
888 
889     /**
890      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
891      *
892      * Emits a {TransferSingle} event.
893      *
894      * Requirements:
895      *
896      * - `to` cannot be the zero address.
897      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
898      * - `from` must have a balance of tokens of type `id` of at least `amount`.
899      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
900      * acceptance magic value.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 id,
906         uint256 amount,
907         bytes calldata data
908     ) external;
909 
910     /**
911      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
912      *
913      * Emits a {TransferBatch} event.
914      *
915      * Requirements:
916      *
917      * - `ids` and `amounts` must have the same length.
918      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
919      * acceptance magic value.
920      */
921     function safeBatchTransferFrom(
922         address from,
923         address to,
924         uint256[] calldata ids,
925         uint256[] calldata amounts,
926         bytes calldata data
927     ) external;
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
940  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
941  *
942  * _Available since v3.1._
943  */
944 interface IERC1155MetadataURI is IERC1155 {
945     /**
946      * @dev Returns the URI for token type `id`.
947      *
948      * If the `\{id\}` substring is present in the URI, it must be replaced by
949      * clients with the actual token type ID.
950      */
951     function uri(uint256 id) external view returns (string memory);
952 }
953 
954 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
955 
956 
957 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 
962 
963 
964 
965 
966 
967 /**
968  * @dev Implementation of the basic standard multi-token.
969  * See https://eips.ethereum.org/EIPS/eip-1155
970  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
971  *
972  * _Available since v3.1._
973  */
974 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
975     using Address for address;
976 
977     // Mapping from token ID to account balances
978     mapping(uint256 => mapping(address => uint256)) private _balances;
979 
980     // Mapping from account to operator approvals
981     mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
984     string private _uri;
985 
986     /**
987      * @dev See {_setURI}.
988      */
989     constructor(string memory uri_) {
990         _setURI(uri_);
991     }
992 
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
997         return
998             interfaceId == type(IERC1155).interfaceId ||
999             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1000             super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC1155MetadataURI-uri}.
1005      *
1006      * This implementation returns the same URI for *all* token types. It relies
1007      * on the token type ID substitution mechanism
1008      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1009      *
1010      * Clients calling this function must replace the `\{id\}` substring with the
1011      * actual token type ID.
1012      */
1013     function uri(uint256) public view virtual override returns (string memory) {
1014         return _uri;
1015     }
1016 
1017     /**
1018      * @dev See {IERC1155-balanceOf}.
1019      *
1020      * Requirements:
1021      *
1022      * - `account` cannot be the zero address.
1023      */
1024     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1025         require(account != address(0), "ERC1155: address zero is not a valid owner");
1026         return _balances[id][account];
1027     }
1028 
1029     /**
1030      * @dev See {IERC1155-balanceOfBatch}.
1031      *
1032      * Requirements:
1033      *
1034      * - `accounts` and `ids` must have the same length.
1035      */
1036     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1037         public
1038         view
1039         virtual
1040         override
1041         returns (uint256[] memory)
1042     {
1043         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1044 
1045         uint256[] memory batchBalances = new uint256[](accounts.length);
1046 
1047         for (uint256 i = 0; i < accounts.length; ++i) {
1048             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1049         }
1050 
1051         return batchBalances;
1052     }
1053 
1054     /**
1055      * @dev See {IERC1155-setApprovalForAll}.
1056      */
1057     function setApprovalForAll(address operator, bool approved) public virtual override {
1058         _setApprovalForAll(_msgSender(), operator, approved);
1059     }
1060 
1061     /**
1062      * @dev See {IERC1155-isApprovedForAll}.
1063      */
1064     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1065         return _operatorApprovals[account][operator];
1066     }
1067 
1068     /**
1069      * @dev See {IERC1155-safeTransferFrom}.
1070      */
1071     function safeTransferFrom(
1072         address from,
1073         address to,
1074         uint256 id,
1075         uint256 amount,
1076         bytes memory data
1077     ) public virtual override {
1078         require(
1079             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1080             "ERC1155: caller is not token owner nor approved"
1081         );
1082         _safeTransferFrom(from, to, id, amount, data);
1083     }
1084 
1085     /**
1086      * @dev See {IERC1155-safeBatchTransferFrom}.
1087      */
1088     function safeBatchTransferFrom(
1089         address from,
1090         address to,
1091         uint256[] memory ids,
1092         uint256[] memory amounts,
1093         bytes memory data
1094     ) public virtual override {
1095         require(
1096             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1097             "ERC1155: caller is not token owner nor approved"
1098         );
1099         _safeBatchTransferFrom(from, to, ids, amounts, data);
1100     }
1101 
1102     /**
1103      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1104      *
1105      * Emits a {TransferSingle} event.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1111      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1112      * acceptance magic value.
1113      */
1114     function _safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 id,
1118         uint256 amount,
1119         bytes memory data
1120     ) internal virtual {
1121         require(to != address(0), "ERC1155: transfer to the zero address");
1122 
1123         address operator = _msgSender();
1124         uint256[] memory ids = _asSingletonArray(id);
1125         uint256[] memory amounts = _asSingletonArray(amount);
1126 
1127         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1128 
1129         uint256 fromBalance = _balances[id][from];
1130         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1131         unchecked {
1132             _balances[id][from] = fromBalance - amount;
1133         }
1134         _balances[id][to] += amount;
1135 
1136         emit TransferSingle(operator, from, to, id, amount);
1137 
1138         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1139 
1140         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1141     }
1142 
1143     /**
1144      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1145      *
1146      * Emits a {TransferBatch} event.
1147      *
1148      * Requirements:
1149      *
1150      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1151      * acceptance magic value.
1152      */
1153     function _safeBatchTransferFrom(
1154         address from,
1155         address to,
1156         uint256[] memory ids,
1157         uint256[] memory amounts,
1158         bytes memory data
1159     ) internal virtual {
1160         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1161         require(to != address(0), "ERC1155: transfer to the zero address");
1162 
1163         address operator = _msgSender();
1164 
1165         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1166 
1167         for (uint256 i = 0; i < ids.length; ++i) {
1168             uint256 id = ids[i];
1169             uint256 amount = amounts[i];
1170 
1171             uint256 fromBalance = _balances[id][from];
1172             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1173             unchecked {
1174                 _balances[id][from] = fromBalance - amount;
1175             }
1176             _balances[id][to] += amount;
1177         }
1178 
1179         emit TransferBatch(operator, from, to, ids, amounts);
1180 
1181         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1182 
1183         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1184     }
1185 
1186     /**
1187      * @dev Sets a new URI for all token types, by relying on the token type ID
1188      * substitution mechanism
1189      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1190      *
1191      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1192      * URI or any of the amounts in the JSON file at said URI will be replaced by
1193      * clients with the token type ID.
1194      *
1195      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1196      * interpreted by clients as
1197      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1198      * for token type ID 0x4cce0.
1199      *
1200      * See {uri}.
1201      *
1202      * Because these URIs cannot be meaningfully represented by the {URI} event,
1203      * this function emits no events.
1204      */
1205     function _setURI(string memory newuri) internal virtual {
1206         _uri = newuri;
1207     }
1208 
1209     /**
1210      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1211      *
1212      * Emits a {TransferSingle} event.
1213      *
1214      * Requirements:
1215      *
1216      * - `to` cannot be the zero address.
1217      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1218      * acceptance magic value.
1219      */
1220     function _mint(
1221         address to,
1222         uint256 id,
1223         uint256 amount,
1224         bytes memory data
1225     ) internal virtual {
1226         require(to != address(0), "ERC1155: mint to the zero address");
1227 
1228         address operator = _msgSender();
1229         uint256[] memory ids = _asSingletonArray(id);
1230         uint256[] memory amounts = _asSingletonArray(amount);
1231 
1232         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1233 
1234         _balances[id][to] += amount;
1235         emit TransferSingle(operator, address(0), to, id, amount);
1236 
1237         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1238 
1239         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1240     }
1241 
1242     /**
1243      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1244      *
1245      * Emits a {TransferBatch} event.
1246      *
1247      * Requirements:
1248      *
1249      * - `ids` and `amounts` must have the same length.
1250      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1251      * acceptance magic value.
1252      */
1253     function _mintBatch(
1254         address to,
1255         uint256[] memory ids,
1256         uint256[] memory amounts,
1257         bytes memory data
1258     ) internal virtual {
1259         require(to != address(0), "ERC1155: mint to the zero address");
1260         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1261 
1262         address operator = _msgSender();
1263 
1264         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1265 
1266         for (uint256 i = 0; i < ids.length; i++) {
1267             _balances[ids[i]][to] += amounts[i];
1268         }
1269 
1270         emit TransferBatch(operator, address(0), to, ids, amounts);
1271 
1272         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1273 
1274         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1275     }
1276 
1277     /**
1278      * @dev Destroys `amount` tokens of token type `id` from `from`
1279      *
1280      * Emits a {TransferSingle} event.
1281      *
1282      * Requirements:
1283      *
1284      * - `from` cannot be the zero address.
1285      * - `from` must have at least `amount` tokens of token type `id`.
1286      */
1287     function _burn(
1288         address from,
1289         uint256 id,
1290         uint256 amount
1291     ) internal virtual {
1292         require(from != address(0), "ERC1155: burn from the zero address");
1293 
1294         address operator = _msgSender();
1295         uint256[] memory ids = _asSingletonArray(id);
1296         uint256[] memory amounts = _asSingletonArray(amount);
1297 
1298         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1299 
1300         uint256 fromBalance = _balances[id][from];
1301         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1302         unchecked {
1303             _balances[id][from] = fromBalance - amount;
1304         }
1305 
1306         emit TransferSingle(operator, from, address(0), id, amount);
1307 
1308         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1309     }
1310 
1311     /**
1312      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1313      *
1314      * Emits a {TransferBatch} event.
1315      *
1316      * Requirements:
1317      *
1318      * - `ids` and `amounts` must have the same length.
1319      */
1320     function _burnBatch(
1321         address from,
1322         uint256[] memory ids,
1323         uint256[] memory amounts
1324     ) internal virtual {
1325         require(from != address(0), "ERC1155: burn from the zero address");
1326         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1327 
1328         address operator = _msgSender();
1329 
1330         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1331 
1332         for (uint256 i = 0; i < ids.length; i++) {
1333             uint256 id = ids[i];
1334             uint256 amount = amounts[i];
1335 
1336             uint256 fromBalance = _balances[id][from];
1337             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1338             unchecked {
1339                 _balances[id][from] = fromBalance - amount;
1340             }
1341         }
1342 
1343         emit TransferBatch(operator, from, address(0), ids, amounts);
1344 
1345         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1346     }
1347 
1348     /**
1349      * @dev Approve `operator` to operate on all of `owner` tokens
1350      *
1351      * Emits an {ApprovalForAll} event.
1352      */
1353     function _setApprovalForAll(
1354         address owner,
1355         address operator,
1356         bool approved
1357     ) internal virtual {
1358         require(owner != operator, "ERC1155: setting approval status for self");
1359         _operatorApprovals[owner][operator] = approved;
1360         emit ApprovalForAll(owner, operator, approved);
1361     }
1362 
1363     /**
1364      * @dev Hook that is called before any token transfer. This includes minting
1365      * and burning, as well as batched variants.
1366      *
1367      * The same hook is called on both single and batched variants. For single
1368      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1369      *
1370      * Calling conditions (for each `id` and `amount` pair):
1371      *
1372      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1373      * of token type `id` will be  transferred to `to`.
1374      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1375      * for `to`.
1376      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1377      * will be burned.
1378      * - `from` and `to` are never both zero.
1379      * - `ids` and `amounts` have the same, non-zero length.
1380      *
1381      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1382      */
1383     function _beforeTokenTransfer(
1384         address operator,
1385         address from,
1386         address to,
1387         uint256[] memory ids,
1388         uint256[] memory amounts,
1389         bytes memory data
1390     ) internal virtual {}
1391 
1392     /**
1393      * @dev Hook that is called after any token transfer. This includes minting
1394      * and burning, as well as batched variants.
1395      *
1396      * The same hook is called on both single and batched variants. For single
1397      * transfers, the length of the `id` and `amount` arrays will be 1.
1398      *
1399      * Calling conditions (for each `id` and `amount` pair):
1400      *
1401      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1402      * of token type `id` will be  transferred to `to`.
1403      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1404      * for `to`.
1405      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1406      * will be burned.
1407      * - `from` and `to` are never both zero.
1408      * - `ids` and `amounts` have the same, non-zero length.
1409      *
1410      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1411      */
1412     function _afterTokenTransfer(
1413         address operator,
1414         address from,
1415         address to,
1416         uint256[] memory ids,
1417         uint256[] memory amounts,
1418         bytes memory data
1419     ) internal virtual {}
1420 
1421     function _doSafeTransferAcceptanceCheck(
1422         address operator,
1423         address from,
1424         address to,
1425         uint256 id,
1426         uint256 amount,
1427         bytes memory data
1428     ) private {
1429         if (to.isContract()) {
1430             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1431                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1432                     revert("ERC1155: ERC1155Receiver rejected tokens");
1433                 }
1434             } catch Error(string memory reason) {
1435                 revert(reason);
1436             } catch {
1437                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1438             }
1439         }
1440     }
1441 
1442     function _doSafeBatchTransferAcceptanceCheck(
1443         address operator,
1444         address from,
1445         address to,
1446         uint256[] memory ids,
1447         uint256[] memory amounts,
1448         bytes memory data
1449     ) private {
1450         if (to.isContract()) {
1451             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1452                 bytes4 response
1453             ) {
1454                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1455                     revert("ERC1155: ERC1155Receiver rejected tokens");
1456                 }
1457             } catch Error(string memory reason) {
1458                 revert(reason);
1459             } catch {
1460                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1461             }
1462         }
1463     }
1464 
1465     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1466         uint256[] memory array = new uint256[](1);
1467         array[0] = element;
1468 
1469         return array;
1470     }
1471 }
1472 
1473 // File: xcart.sol
1474 
1475 
1476 // Creator: XCart Dev Team
1477 
1478 pragma solidity ^0.8.7;
1479 
1480 
1481 
1482 
1483 
1484 
1485 error MintedQueryForZeroAddress();
1486 error PiecesNotEnoughToSynthesize();
1487 
1488 contract XCART is ERC1155, Ownable {
1489     using SafeERC20 for IERC20;
1490     enum Status {
1491         Waiting,
1492         Started,
1493         Opened,
1494         Finished
1495     }
1496 
1497     struct AddressData {
1498         // Sum of minted and synthesized.
1499         uint64 nft_balance;
1500         // Only for minted ones.
1501         uint64 nft_num_minted;
1502         // From id to number.
1503         mapping(uint8 => uint16) piecesData;
1504     }
1505 
1506     Status public status;
1507 
1508     // Instead of uri_
1509     string private _baseURI;
1510 
1511     // Price
1512     uint256 private NFT_PRICE = 0.168 * 10**18; // 0.168 ETH
1513     uint256 private PIECE_PRICE = 0.0188 * 10**18; // 0.0188 ETH
1514 
1515     // For NFT
1516     uint8 private MAX_MINT_PER_ADDR = 2;
1517 
1518     // This value cannot be greater than 2800.
1519     uint16 private SYN_SUPPLY = 0;
1520     // This value cannot be greater than 7200.
1521     uint16 private MINT_SUPPLY = 0;
1522     // Offset between mint & syn
1523     uint16 private _offset = 7205;
1524 
1525     // The tokenId of the next token to be minted.
1526     uint256 private _currentMintNFTIndex;
1527     uint256 private _currentSynNFTIndex;
1528 
1529     // For pieces
1530     uint8 public constant ID_P1 = 0;
1531     uint8 public constant ID_P2 = 1;
1532     uint8 public constant ID_P3 = 2;
1533     uint8 public constant ID_P4 = 3;
1534     uint8 public constant ID_P5 = 4;
1535 
1536     uint16 public constant MAX_PIECES = 2800;
1537 
1538     mapping(address => AddressData) private _addressData;
1539     mapping(uint8 => uint16) private _piecesMinted;
1540 
1541     event NFTMinted(address indexed minter, uint256 amount, uint256 firstTokenId, address inviter);
1542     event NFTSynthesized(address owner, uint256 tokenId);
1543     event NFTExchanged(address indexed owner, uint256 tokenId);
1544     event PiecesMinted(address indexed minter, uint256 amount, uint256 tokenId, address inviter);
1545     event PiecesAirdropped(address indexed receiver, uint256 amount);
1546     event StatusChanged(Status status);
1547     event BaseURIChanged(string newBaseURI);
1548 
1549     constructor(string memory uri_) ERC1155("XCART") {
1550         _baseURI = uri_;
1551         _currentMintNFTIndex = _genesisNFTId();
1552         _currentSynNFTIndex = _offset;
1553     }
1554 
1555     function _genesisNFTId() internal view virtual returns (uint256) {
1556         return 5;
1557     }
1558 
1559     function totalSupply() public view returns (uint256) {
1560         unchecked {
1561             return MINT_SUPPLY + SYN_SUPPLY;
1562         }
1563     }
1564 
1565     function totalMintSupply() public view returns (uint256) {
1566         unchecked {
1567             return MINT_SUPPLY;
1568         }
1569     }
1570 
1571     function totalSynSupply() public view returns (uint256) {
1572         unchecked {
1573             return SYN_SUPPLY;
1574         }
1575     }
1576 
1577     function perAccountSupply() public view returns (uint256) {
1578         unchecked {
1579             return MAX_MINT_PER_ADDR;
1580         }
1581     }
1582 
1583     // How many NFTs has been minted.
1584     function totalNFTMinted() public view returns (uint256) {
1585         unchecked {
1586             return _currentMintNFTIndex - _genesisNFTId();
1587         }
1588     }
1589 
1590     function totalNFTSynthesized() public view returns (uint256) {
1591         unchecked {
1592             return _currentSynNFTIndex - _offset;
1593         }
1594     }
1595 
1596     // Max mint number for each address
1597     function maxMintNumberPerAddress() public view returns (uint256) {
1598         unchecked {
1599             return uint256(MAX_MINT_PER_ADDR);
1600         }
1601     }
1602 
1603     // How many pieces has been minted.
1604     function piecesMinted(uint8 pid) public view returns (uint256) {
1605         unchecked {
1606             return uint256(_piecesMinted[pid]);
1607         }
1608     }
1609 
1610     function numberMinted(address owner_) public view returns (uint256) {
1611         if (owner_ == address(0)) revert MintedQueryForZeroAddress();
1612         return uint256(_addressData[owner_].nft_num_minted);
1613     }
1614 
1615     // Read-only price functions
1616     function nftPrice() public view returns (uint256) {
1617         unchecked {
1618             return NFT_PRICE;
1619         }
1620     }
1621 
1622     function piecePrice() public view returns (uint256) {
1623         unchecked {
1624             return PIECE_PRICE;
1625         }
1626     }
1627 
1628     function mintNFT(uint256 quantity_, address inviter_) public payable {
1629         require(status == Status.Started || status == Status.Opened, "Sale has not started");
1630         require(tx.origin == msg.sender, "Contract calls are not allowed");
1631         require(quantity_ > 0, "At least one NFT must be minted");
1632         require(
1633             totalNFTMinted() + quantity_ <= MINT_SUPPLY,
1634             "Short minted supply(NFT)"
1635         );
1636         require(
1637             numberMinted(msg.sender) + quantity_ <= MAX_MINT_PER_ADDR,
1638             "This address has reached the limit of minting."
1639         );
1640         require(msg.value >= NFT_PRICE * quantity_, "Not enough ETH sent: check price.");
1641 
1642         uint256[] memory ids = new uint256[] (quantity_);
1643         uint256[] memory amounts = new uint256[] (quantity_);
1644         uint256 index = _currentMintNFTIndex;
1645         for (uint256 i = 0; i < quantity_; i++) {
1646             ids[i] = index;
1647             amounts[i] = 1;
1648             index ++;
1649         }
1650         _mintBatch(msg.sender, ids, amounts, "");
1651         _currentMintNFTIndex += quantity_;
1652         _addressData[msg.sender].nft_balance += uint64(quantity_);
1653         _addressData[msg.sender].nft_num_minted += uint64(quantity_);
1654 
1655         _refundIfOver(NFT_PRICE * quantity_);
1656         emit NFTMinted(msg.sender, quantity_, ids[0], inviter_);
1657     }
1658 
1659     function mintPiece(address inviter_) public payable {
1660         require(status == Status.Started || status == Status.Opened, "Sale has not started");
1661         require(tx.origin == msg.sender, "Contract calls are not allowed");
1662         require( 
1663             piecesMinted(ID_P1) + 
1664             piecesMinted(ID_P2) + 
1665             piecesMinted(ID_P3) + 
1666             piecesMinted(ID_P4) + 
1667             piecesMinted(ID_P5) < MAX_PIECES * 5, "Short minted supply(Pieces)");
1668 
1669         require(msg.value >= PIECE_PRICE, "Not enough ETH sent: check price.");
1670 
1671         uint8 random = _randomInFive();
1672         if (piecesMinted(random) == MAX_PIECES) {
1673             for (uint8 i = 0; i < 5; i++) {
1674                 if (piecesMinted(i) < MAX_PIECES) {
1675                     random = i;
1676                     break;
1677                 }
1678             }
1679         }
1680         _mint(msg.sender, random, 1, "");
1681         _piecesMinted[random] += 1;
1682         _addressData[msg.sender].piecesData[random] += 1;
1683         uint256 tokenId = random;
1684 
1685         _refundIfOver(PIECE_PRICE);
1686         emit PiecesMinted(msg.sender, 1, tokenId, inviter_);
1687     }
1688 
1689     function synthesize() public payable {
1690         require(status >= Status.Started, "Sale has not started");
1691         require(tx.origin == msg.sender, "Contract calls are not allowed");
1692         require(
1693             totalNFTSynthesized() <= SYN_SUPPLY,
1694             "Short synthesized NFT supply"
1695         );
1696         for(uint8 i = 0 ; i < 5 ; i ++) {
1697             if(_addressData[msg.sender].piecesData[i] <= 0) {
1698                 revert PiecesNotEnoughToSynthesize();
1699             }
1700         }
1701         for (uint8 i = 0 ; i < 5 ; i ++) {
1702             _burn(msg.sender, i, 1);
1703             _addressData[msg.sender].piecesData[i] -= 1;
1704         }
1705         _synthesizeNFT();
1706     }
1707 
1708     function exchange(uint256 nft_id_) public payable {
1709         require(status >= Status.Started, "Sale has not started");
1710         require(tx.origin == msg.sender, "Contract calls are not allowed");
1711         require(balanceOf(msg.sender, nft_id_) > 0, "Address does not have any NFTs");
1712         require(nft_id_ >= _genesisNFTId(), "Cannot exchange a piece.");
1713         _burn(msg.sender, nft_id_, 1);
1714         _addressData[msg.sender].nft_balance -= 1;
1715         emit NFTExchanged(msg.sender, nft_id_);
1716     }
1717 
1718     function _synthesizeNFT() private {
1719         require(status >= Status.Started, "Sale has not started");
1720         require(tx.origin == msg.sender, "Contract calls are not allowed");
1721         require(
1722             totalNFTSynthesized() <= SYN_SUPPLY,
1723             "Short synthesized NFT supply"
1724         );
1725         uint256 tokenId = _currentSynNFTIndex;
1726         _mint(msg.sender, _currentSynNFTIndex, 1, "");
1727         _currentSynNFTIndex += 1;
1728         _addressData[msg.sender].nft_balance += 1;
1729         emit NFTSynthesized(msg.sender, tokenId);
1730     }
1731 
1732     function setStatus(Status status_) public onlyOwner {
1733         status = status_;
1734         emit StatusChanged(status);
1735     }
1736 
1737     function uri(uint256 tokenId_) public view virtual override returns (string memory) {
1738         if (tokenId_ < _genesisNFTId()) {
1739             return "https://bafybeie2mbntsrgcgiw3svgqutbz7ovtpfcxjuotu5mbhjy4s3xduiugry.ipfs.nftstorage.link/{id}.json";
1740         }
1741         return _baseURI;
1742     }
1743 
1744     function setURI(string calldata newURI_) public onlyOwner {
1745         _baseURI = newURI_;
1746         emit BaseURIChanged(newURI_);
1747     }
1748 
1749     function setMintSupply(uint16 mintSupply_) public onlyOwner {
1750         require(mintSupply_ > MINT_SUPPLY, "Mint supply value must be greater than original value");
1751         require(mintSupply_ <= 7200, "Mint supply value must be less than or equal 7200");
1752         MINT_SUPPLY = mintSupply_;
1753     }
1754 
1755     function setSynSupply(uint16 synSupply_) public onlyOwner {
1756         require(synSupply_ > SYN_SUPPLY, "Syn supply value must be greater than original value");
1757         require(synSupply_ <= 2800, "Syn supply value must be less than or equal 2800");
1758         SYN_SUPPLY = synSupply_;
1759     }
1760 
1761     function setMaxMintNumberPerAddress(uint8 maxMintNumber_) public onlyOwner {
1762         require(maxMintNumber_ > 0, "Value must greater than 0");
1763         require(maxMintNumber_ < 256, "Value must less than 256");
1764         MAX_MINT_PER_ADDR = maxMintNumber_;
1765     }
1766 
1767     function setMintPrice(uint256 mintPrice_) public onlyOwner {
1768         require(mintPrice_ > 0, "Mint price must be greater than 0");
1769         NFT_PRICE = mintPrice_;
1770     }
1771 
1772     function setPiecePrice(uint256 pPrice_) public onlyOwner {
1773         require(pPrice_ > 0, "Piece price must be greater than 0");
1774         PIECE_PRICE = pPrice_;
1775     }
1776 
1777     function _refundIfOver(uint256 price_) private {
1778         if (msg.value > price_) {
1779             payable(msg.sender).transfer(msg.value - price_);
1780         }
1781     }
1782 
1783     function safeTransferFrom(
1784         address from,
1785         address to,
1786         uint256 id,
1787         uint256 amount,
1788         bytes memory data
1789     ) public override {
1790         require(
1791             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1792             "ERC1155: caller is not token owner nor approved"
1793         );
1794         require(amount < 65536, "Amount cannot over 65536");
1795         _safeTransferFrom(from, to, id, amount, data);
1796 
1797         if (id < _genesisNFTId()) {
1798             _addressData[from].piecesData[uint8(id)] -= uint16(amount);
1799             _addressData[to].piecesData[uint8(id)] += uint16(amount);
1800         } else {
1801             _addressData[from].nft_balance -= uint16(amount);
1802             _addressData[to].nft_balance += uint16(amount);
1803         }
1804     }
1805 
1806     function safeBatchTransferFrom(
1807         address from,
1808         address to,
1809         uint256[] memory ids,
1810         uint256[] memory amounts,
1811         bytes memory data
1812     ) public override {
1813         require(
1814             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1815             "ERC1155: caller is not token owner nor approved"
1816         );
1817         _safeBatchTransferFrom(from, to, ids, amounts, data);
1818 
1819         for (uint256 i = 0; i < ids.length; ++i) {
1820             require(amounts[i] < 65536, "Amount cannot over 65536");
1821             if (ids[i] < _genesisNFTId()) {
1822                 _addressData[from].piecesData[uint8(ids[i])] -= uint16(amounts[i]);
1823                 _addressData[to].piecesData[uint8(ids[i])] += uint16(amounts[i]);
1824             } else {
1825                 _addressData[from].nft_balance -= uint16(amounts[i]);
1826                 _addressData[to].nft_balance += uint16(amounts[i]);
1827             }
1828         }
1829     }
1830 
1831     // Get a random number in 5
1832     function _randomInFive() private view returns (uint8) {
1833         uint256 x = uint256(keccak256(abi.encodePacked(
1834                     (block.timestamp) +
1835                     (block.difficulty) +
1836                     ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1837                     (block.gaslimit) +
1838                     ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
1839                     (block.number)
1840                 ))) % 5;
1841         return uint8(x);
1842     }
1843 
1844     function withdrawETH(address payable recipient_) external onlyOwner {
1845         uint256 balance = address(this).balance;
1846         (bool success, ) = recipient_.call{value: balance}("");
1847         require(success, "Withdraw successfully");
1848     }
1849 
1850     function withdrawSafeERC20Token(address tokenContract_, address payable recipient_, uint256 amount_) external onlyOwner {
1851         IERC20 tokenContract = IERC20(tokenContract_);
1852         tokenContract.safeTransfer(recipient_, amount_);
1853     }
1854 
1855     function airdropPieces(address receiver_, uint16 amount_) external onlyOwner {
1856         require(piecesMinted(ID_P1) < MAX_PIECES - amount_, "Short minted supply(Piece id: 0)");
1857         require(piecesMinted(ID_P2) < MAX_PIECES - amount_, "Short minted supply(Piece id: 1)");
1858         require(piecesMinted(ID_P3) < MAX_PIECES - amount_, "Short minted supply(Piece id: 2)");
1859         require(piecesMinted(ID_P4) < MAX_PIECES - amount_, "Short minted supply(Piece id: 3)");
1860         require(piecesMinted(ID_P5) < MAX_PIECES - amount_, "Short minted supply(Piece id: 4)");
1861 
1862         for (uint8 i = 0; i < 5; i ++) {
1863             _mint(receiver_, i, amount_, "");
1864             _piecesMinted[i] += amount_;
1865             _addressData[receiver_].piecesData[i] += amount_;
1866         }
1867         emit PiecesAirdropped(receiver_, amount_);
1868     }
1869 }