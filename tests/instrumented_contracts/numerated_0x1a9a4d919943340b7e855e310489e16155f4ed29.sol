1 /**
2  * @dev Provides information about the current execution context, including the
3  * sender of the transaction and its data. While these are generally available
4  * via msg.sender and msg.data, they should not be accessed in such a direct
5  * manner, since when dealing with meta-transactions the account sending and
6  * paying for execution may not be the actual sender (as far as an application
7  * is concerned).
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 /**
22  * @dev Contract module which provides a basic access control mechanism, where
23  * there is an account (an owner) that can be granted exclusive access to
24  * specific functions.
25  *
26  * By default, the owner account will be the one that deploys the contract. This
27  * can later be changed with {transferOwnership}.
28  *
29  * This module is used through inheritance. It will make available the modifier
30  * `onlyOwner`, which can be applied to your functions to restrict their use to
31  * the owner.
32  */
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _transferOwnership(_msgSender());
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         _checkOwner();
50         _;
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if the sender is not the owner.
62      */
63     function _checkOwner() internal view virtual {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP.
101  */
102 interface IERC20 {
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `to`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address to, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `from` to `to` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address from,
172         address to,
173         uint256 amount
174     ) external returns (bool);
175 }
176 
177 
178 /**
179  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
180  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
181  *
182  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
183  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
184  * need to send a transaction, and thus is not required to hold Ether at all.
185  */
186 interface IERC20Permit {
187     /**
188      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
189      * given ``owner``'s signed approval.
190      *
191      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
192      * ordering also apply here.
193      *
194      * Emits an {Approval} event.
195      *
196      * Requirements:
197      *
198      * - `spender` cannot be the zero address.
199      * - `deadline` must be a timestamp in the future.
200      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
201      * over the EIP712-formatted function arguments.
202      * - the signature must use ``owner``'s current nonce (see {nonces}).
203      *
204      * For more information on the signature format, see the
205      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
206      * section].
207      */
208     function permit(
209         address owner,
210         address spender,
211         uint256 value,
212         uint256 deadline,
213         uint8 v,
214         bytes32 r,
215         bytes32 s
216     ) external;
217 
218     /**
219      * @dev Returns the current nonce for `owner`. This value must be
220      * included whenever a signature is generated for {permit}.
221      *
222      * Every successful call to {permit} increases ``owner``'s nonce by one. This
223      * prevents a signature from being used multiple times.
224      */
225     function nonces(address owner) external view returns (uint256);
226 
227     /**
228      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
229      */
230     // solhint-disable-next-line func-name-mixedcase
231     function DOMAIN_SEPARATOR() external view returns (bytes32);
232 }
233 
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269 
270         return account.code.length > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441                 /// @solidity memory-safe-assembly
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 
454 /**
455  * @title SafeERC20
456  * @dev Wrappers around ERC20 operations that throw on failure (when the token
457  * contract returns false). Tokens that return no value (and instead revert or
458  * throw on failure) are also supported, non-reverting calls are assumed to be
459  * successful.
460  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
461  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
462  */
463 library SafeERC20 {
464     using Address for address;
465 
466     function safeTransfer(
467         IERC20 token,
468         address to,
469         uint256 value
470     ) internal {
471         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
472     }
473 
474     function safeTransferFrom(
475         IERC20 token,
476         address from,
477         address to,
478         uint256 value
479     ) internal {
480         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
481     }
482 
483     /**
484      * @dev Deprecated. This function has issues similar to the ones found in
485      * {IERC20-approve}, and its usage is discouraged.
486      *
487      * Whenever possible, use {safeIncreaseAllowance} and
488      * {safeDecreaseAllowance} instead.
489      */
490     function safeApprove(
491         IERC20 token,
492         address spender,
493         uint256 value
494     ) internal {
495         // safeApprove should only be called when setting an initial allowance,
496         // or when resetting it to zero. To increase and decrease it, use
497         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
498         require(
499             (value == 0) || (token.allowance(address(this), spender) == 0),
500             "SafeERC20: approve from non-zero to non-zero allowance"
501         );
502         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
503     }
504 
505     function safeIncreaseAllowance(
506         IERC20 token,
507         address spender,
508         uint256 value
509     ) internal {
510         uint256 newAllowance = token.allowance(address(this), spender) + value;
511         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512     }
513 
514     function safeDecreaseAllowance(
515         IERC20 token,
516         address spender,
517         uint256 value
518     ) internal {
519         unchecked {
520             uint256 oldAllowance = token.allowance(address(this), spender);
521             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
522             uint256 newAllowance = oldAllowance - value;
523             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524         }
525     }
526 
527     function safePermit(
528         IERC20Permit token,
529         address owner,
530         address spender,
531         uint256 value,
532         uint256 deadline,
533         uint8 v,
534         bytes32 r,
535         bytes32 s
536     ) internal {
537         uint256 nonceBefore = token.nonces(owner);
538         token.permit(owner, spender, value, deadline, v, r, s);
539         uint256 nonceAfter = token.nonces(owner);
540         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
541     }
542 
543     /**
544      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
545      * on the return value: the return value is optional (but if data is returned, it must not be false).
546      * @param token The token targeted by the call.
547      * @param data The call data (encoded using abi.encode or one of its variants).
548      */
549     function _callOptionalReturn(IERC20 token, bytes memory data) private {
550         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
551         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
552         // the target address contains contract code and also asserts for success in the low-level call.
553 
554         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
555         if (returndata.length > 0) {
556             // Return data is optional
557             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
558         }
559     }
560 }
561 
562 
563 library Strings {
564     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
565     uint8 private constant _ADDRESS_LENGTH = 20;
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
569      */
570     function toString(uint256 value) internal pure returns (string memory) {
571         // Inspired by OraclizeAPI's implementation - MIT licence
572         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
573 
574         if (value == 0) {
575             return "0";
576         }
577         uint256 temp = value;
578         uint256 digits;
579         while (temp != 0) {
580             digits++;
581             temp /= 10;
582         }
583         bytes memory buffer = new bytes(digits);
584         while (value != 0) {
585             digits -= 1;
586             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
587             value /= 10;
588         }
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
594      */
595     function toHexString(uint256 value) internal pure returns (string memory) {
596         if (value == 0) {
597             return "0x00";
598         }
599         uint256 temp = value;
600         uint256 length = 0;
601         while (temp != 0) {
602             length++;
603             temp >>= 8;
604         }
605         return toHexString(value, length);
606     }
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
610      */
611     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
612         bytes memory buffer = new bytes(2 * length + 2);
613         buffer[0] = "0";
614         buffer[1] = "x";
615         for (uint256 i = 2 * length + 1; i > 1; --i) {
616             buffer[i] = _HEX_SYMBOLS[value & 0xf];
617             value >>= 4;
618         }
619         require(value == 0, "Strings: hex length insufficient");
620         return string(buffer);
621     }
622 
623     /**
624      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
625      */
626     function toHexString(address addr) internal pure returns (string memory) {
627         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
628     }
629 }
630 
631 
632 /**
633  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
634  *
635  * These functions can be used to verify that a message was signed by the holder
636  * of the private keys of a given address.
637  */
638 library ECDSA {
639     enum RecoverError {
640         NoError,
641         InvalidSignature,
642         InvalidSignatureLength,
643         InvalidSignatureS,
644         InvalidSignatureV
645     }
646 
647     function _throwError(RecoverError error) private pure {
648         if (error == RecoverError.NoError) {
649             return; // no error: do nothing
650         } else if (error == RecoverError.InvalidSignature) {
651             revert("ECDSA: invalid signature");
652         } else if (error == RecoverError.InvalidSignatureLength) {
653             revert("ECDSA: invalid signature length");
654         } else if (error == RecoverError.InvalidSignatureS) {
655             revert("ECDSA: invalid signature 's' value");
656         } else if (error == RecoverError.InvalidSignatureV) {
657             revert("ECDSA: invalid signature 'v' value");
658         }
659     }
660 
661     /**
662      * @dev Returns the address that signed a hashed message (`hash`) with
663      * `signature` or error string. This address can then be used for verification purposes.
664      *
665      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
666      * this function rejects them by requiring the `s` value to be in the lower
667      * half order, and the `v` value to be either 27 or 28.
668      *
669      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
670      * verification to be secure: it is possible to craft signatures that
671      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
672      * this is by receiving a hash of the original message (which may otherwise
673      * be too long), and then calling {toEthSignedMessageHash} on it.
674      *
675      * Documentation for signature generation:
676      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
677      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
678      *
679      * _Available since v4.3._
680      */
681     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
682         if (signature.length == 65) {
683             bytes32 r;
684             bytes32 s;
685             uint8 v;
686             // ecrecover takes the signature parameters, and the only way to get them
687             // currently is to use assembly.
688             /// @solidity memory-safe-assembly
689             assembly {
690                 r := mload(add(signature, 0x20))
691                 s := mload(add(signature, 0x40))
692                 v := byte(0, mload(add(signature, 0x60)))
693             }
694             return tryRecover(hash, v, r, s);
695         } else {
696             return (address(0), RecoverError.InvalidSignatureLength);
697         }
698     }
699 
700     /**
701      * @dev Returns the address that signed a hashed message (`hash`) with
702      * `signature`. This address can then be used for verification purposes.
703      *
704      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
705      * this function rejects them by requiring the `s` value to be in the lower
706      * half order, and the `v` value to be either 27 or 28.
707      *
708      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
709      * verification to be secure: it is possible to craft signatures that
710      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
711      * this is by receiving a hash of the original message (which may otherwise
712      * be too long), and then calling {toEthSignedMessageHash} on it.
713      */
714     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
715         (address recovered, RecoverError error) = tryRecover(hash, signature);
716         _throwError(error);
717         return recovered;
718     }
719 
720     /**
721      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
722      *
723      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
724      *
725      * _Available since v4.3._
726      */
727     function tryRecover(
728         bytes32 hash,
729         bytes32 r,
730         bytes32 vs
731     ) internal pure returns (address, RecoverError) {
732         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
733         uint8 v = uint8((uint256(vs) >> 255) + 27);
734         return tryRecover(hash, v, r, s);
735     }
736 
737     /**
738      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
739      *
740      * _Available since v4.2._
741      */
742     function recover(
743         bytes32 hash,
744         bytes32 r,
745         bytes32 vs
746     ) internal pure returns (address) {
747         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
748         _throwError(error);
749         return recovered;
750     }
751 
752     /**
753      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
754      * `r` and `s` signature fields separately.
755      *
756      * _Available since v4.3._
757      */
758     function tryRecover(
759         bytes32 hash,
760         uint8 v,
761         bytes32 r,
762         bytes32 s
763     ) internal pure returns (address, RecoverError) {
764         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
765         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
766         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
767         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
768         //
769         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
770         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
771         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
772         // these malleable signatures as well.
773         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
774             return (address(0), RecoverError.InvalidSignatureS);
775         }
776         if (v != 27 && v != 28) {
777             return (address(0), RecoverError.InvalidSignatureV);
778         }
779 
780         // If the signature is valid (and not malleable), return the signer address
781         address signer = ecrecover(hash, v, r, s);
782         if (signer == address(0)) {
783             return (address(0), RecoverError.InvalidSignature);
784         }
785 
786         return (signer, RecoverError.NoError);
787     }
788 
789     /**
790      * @dev Overload of {ECDSA-recover} that receives the `v`,
791      * `r` and `s` signature fields separately.
792      */
793     function recover(
794         bytes32 hash,
795         uint8 v,
796         bytes32 r,
797         bytes32 s
798     ) internal pure returns (address) {
799         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
800         _throwError(error);
801         return recovered;
802     }
803 
804     /**
805      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
806      * produces hash corresponding to the one signed with the
807      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
808      * JSON-RPC method as part of EIP-191.
809      *
810      * See {recover}.
811      */
812     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
813         // 32 is the length in bytes of hash,
814         // enforced by the type signature above
815         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
816     }
817 
818     /**
819      * @dev Returns an Ethereum Signed Message, created from `s`. This
820      * produces hash corresponding to the one signed with the
821      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
822      * JSON-RPC method as part of EIP-191.
823      *
824      * See {recover}.
825      */
826     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
827         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
828     }
829 
830     /**
831      * @dev Returns an Ethereum Signed Typed Data, created from a
832      * `domainSeparator` and a `structHash`. This produces hash corresponding
833      * to the one signed with the
834      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
835      * JSON-RPC method as part of EIP-712.
836      *
837      * See {recover}.
838      */
839     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
840         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
841     }
842 }
843 
844 
845 contract Claimer is Ownable {
846     using SafeERC20 for IERC20;
847 
848     address public hft;
849     address public signerAddress;
850 
851     /// @notice A record of states for signing / validating signatures
852     mapping(address => uint256) public nonces;
853     mapping(address => uint256) public lastClaimed;
854 
855     bool internal _killswitch;
856 
857     event ClaimHFT(
858         address indexed sender,
859         uint256 indexed amount,
860         uint256 indexed nonce
861     );
862 
863     event WithdrawHFT(address hft, address recipient, uint256 amount);
864 
865     event UpdateSigner(address newSigner, address oldSigner);
866 
867     event UpdateKillswitch(bool killswitch);
868 
869     /**
870      * @notice Construct a new HFT Claimer contract
871      * @param _hft Hashflow token address
872      * @param _signer authorized signer to sign all the claim payloads
873      */
874     constructor(address _hft, address _signer) {
875         require(
876             _hft != address(0),
877             'Claimer::constructor: hft cannot be 0 address'
878         );
879         require(
880             _signer != address(0),
881             'Claimer::constructor: signer cannot be 0 address'
882         );
883         hft = _hft;
884         signerAddress = _signer;
885 
886         _killswitch = true;
887     }
888 
889     function updateKillswitch(bool killswitch) external onlyOwner {
890         emit UpdateKillswitch(killswitch);
891 
892         _killswitch = killswitch;
893     }
894 
895     function withdrawHFT(uint256 amount) external onlyOwner {
896         emit WithdrawHFT(hft, msg.sender, amount);
897 
898         IERC20(hft).safeTransfer(msg.sender, amount);
899     }
900 
901     function withdrawAllHFT() external onlyOwner {
902         uint256 balance = IERC20(hft).balanceOf(address(this));
903 
904         emit WithdrawHFT(hft, msg.sender, balance);
905         IERC20(hft).safeTransfer(msg.sender, balance);
906     }
907 
908     /**
909      * @notice Claim HFTs by providing a valid digest
910      * @param amount Deposit amount
911      * @param deadline time after which the siguture is invalid
912      * @param v The recovery byte of the signature
913      * @param r Half of the ECDSA signature pair
914      * @param s Half of the ECDSA signature pair
915      */
916     function claimHFT(
917         uint256 amount,
918         uint256 deadline,
919         uint8 v,
920         bytes32 r,
921         bytes32 s
922     ) external {
923         require(
924             block.timestamp <= deadline,
925             'Claimer::claimHFT: signature expired'
926         );
927         require(
928             block.timestamp - lastClaimed[msg.sender] >= 1 days,
929             'Claimer::claimHFT: HFT can only be claimed once a day'
930         );
931         require(_killswitch, 'Claimer::claimHFT: Killswitch is off.');
932         lastClaimed[msg.sender] = block.timestamp;
933 
934         bytes32 digest = keccak256(
935             abi.encodePacked(
936                 '\x19Ethereum Signed Message:\n32',
937                 keccak256(
938                     abi.encodePacked(
939                         address(this),
940                         hft,
941                         msg.sender,
942                         amount,
943                         deadline,
944                         nonces[msg.sender]++
945                     )
946                 )
947             )
948         );
949 
950         bytes memory signature = abi.encodePacked(r, s, v);
951 
952         require(
953             ECDSA.recover(digest, signature) == signerAddress,
954             'Claimer::claimHFT: Invalid signer'
955         );
956 
957         IERC20(hft).safeTransfer(msg.sender, amount);
958 
959         emit ClaimHFT(msg.sender, amount, (nonces[msg.sender] - 1));
960     }
961 
962     function updateSigner(address _signer) external onlyOwner {
963         require(
964             _signer != address(0),
965             'Claimer::updateSigner: signer cannot be 0 address'
966         );
967         emit UpdateSigner(_signer, signerAddress);
968         signerAddress = _signer;
969     }
970 
971     function renounceOwnership() public view override onlyOwner {
972         revert('Claimer::renounceOwnership: Cannot renounce ownership');
973     }
974 }