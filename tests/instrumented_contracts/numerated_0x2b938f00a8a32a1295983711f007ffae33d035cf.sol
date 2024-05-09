1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/access/Ownable.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Address.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
194 
195 pragma solidity ^0.8.1;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      *
218      * [IMPORTANT]
219      * ====
220      * You shouldn't rely on `isContract` to protect against flash loan attacks!
221      *
222      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
223      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
224      * constructor.
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize/address.code.length, which returns 0
229         // for contracts in construction, since the code is only stored at the end
230         // of the constructor execution.
231 
232         return account.code.length > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(isContract(target), "Address: delegate call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.delegatecall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
388      * revert reason using the provided one.
389      *
390      * _Available since v4.3._
391      */
392     function verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) internal pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @title SafeERC20
425  * @dev Wrappers around ERC20 operations that throw on failure (when the token
426  * contract returns false). Tokens that return no value (and instead revert or
427  * throw on failure) are also supported, non-reverting calls are assumed to be
428  * successful.
429  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
430  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
431  */
432 library SafeERC20 {
433     using Address for address;
434 
435     function safeTransfer(
436         IERC20 token,
437         address to,
438         uint256 value
439     ) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
441     }
442 
443     function safeTransferFrom(
444         IERC20 token,
445         address from,
446         address to,
447         uint256 value
448     ) internal {
449         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
450     }
451 
452     /**
453      * @dev Deprecated. This function has issues similar to the ones found in
454      * {IERC20-approve}, and its usage is discouraged.
455      *
456      * Whenever possible, use {safeIncreaseAllowance} and
457      * {safeDecreaseAllowance} instead.
458      */
459     function safeApprove(
460         IERC20 token,
461         address spender,
462         uint256 value
463     ) internal {
464         // safeApprove should only be called when setting an initial allowance,
465         // or when resetting it to zero. To increase and decrease it, use
466         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
467         require(
468             (value == 0) || (token.allowance(address(this), spender) == 0),
469             "SafeERC20: approve from non-zero to non-zero allowance"
470         );
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
472     }
473 
474     function safeIncreaseAllowance(
475         IERC20 token,
476         address spender,
477         uint256 value
478     ) internal {
479         uint256 newAllowance = token.allowance(address(this), spender) + value;
480         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
481     }
482 
483     function safeDecreaseAllowance(
484         IERC20 token,
485         address spender,
486         uint256 value
487     ) internal {
488         unchecked {
489             uint256 oldAllowance = token.allowance(address(this), spender);
490             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
491             uint256 newAllowance = oldAllowance - value;
492             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
493         }
494     }
495 
496     /**
497      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
498      * on the return value: the return value is optional (but if data is returned, it must not be false).
499      * @param token The token targeted by the call.
500      * @param data The call data (encoded using abi.encode or one of its variants).
501      */
502     function _callOptionalReturn(IERC20 token, bytes memory data) private {
503         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
504         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
505         // the target address contains contract code and also asserts for success in the low-level call.
506 
507         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
508         if (returndata.length > 0) {
509             // Return data is optional
510             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
524  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
525  *
526  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
527  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
528  * need to send a transaction, and thus is not required to hold Ether at all.
529  */
530 interface IERC20Permit {
531     /**
532      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
533      * given ``owner``'s signed approval.
534      *
535      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
536      * ordering also apply here.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      * - `deadline` must be a timestamp in the future.
544      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
545      * over the EIP712-formatted function arguments.
546      * - the signature must use ``owner``'s current nonce (see {nonces}).
547      *
548      * For more information on the signature format, see the
549      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
550      * section].
551      */
552     function permit(
553         address owner,
554         address spender,
555         uint256 value,
556         uint256 deadline,
557         uint8 v,
558         bytes32 r,
559         bytes32 s
560     ) external;
561 
562     /**
563      * @dev Returns the current nonce for `owner`. This value must be
564      * included whenever a signature is generated for {permit}.
565      *
566      * Every successful call to {permit} increases ``owner``'s nonce by one. This
567      * prevents a signature from being used multiple times.
568      */
569     function nonces(address owner) external view returns (uint256);
570 
571     /**
572      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
573      */
574     // solhint-disable-next-line func-name-mixedcase
575     function DOMAIN_SEPARATOR() external view returns (bytes32);
576 }
577 
578 // File: contracts/libraries/RevertReasonParser.sol
579 
580 
581 
582 pragma solidity >=0.7.6;
583 
584 /*
585 “Copyright (c) 2019-2021 1inch 
586 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
587 and associated documentation files (the "Software"), to deal in the Software without restriction,
588 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
589 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
590 subject to the following conditions: 
591 The above copyright notice and this permission notice shall be included
592 in all copies or substantial portions of the Software. 
593 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
594 THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
595 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
596 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
597 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE”.
598 */
599 
600 library RevertReasonParser {
601   function parse(bytes memory data, string memory prefix) internal pure returns (string memory) {
602     // https://solidity.readthedocs.io/en/latest/control-structures.html#revert
603     // We assume that revert reason is abi-encoded as Error(string)
604 
605     // 68 = 4-byte selector 0x08c379a0 + 32 bytes offset + 32 bytes length
606     if (data.length >= 68 && data[0] == '\x08' && data[1] == '\xc3' && data[2] == '\x79' && data[3] == '\xa0') {
607       string memory reason;
608       // solhint-disable no-inline-assembly
609       assembly {
610         // 68 = 32 bytes data length + 4-byte selector + 32 bytes offset
611         reason := add(data, 68)
612       }
613       /*
614                 revert reason is padded up to 32 bytes with ABI encoder: Error(string)
615                 also sometimes there is extra 32 bytes of zeros padded in the end:
616                 https://github.com/ethereum/solidity/issues/10170
617                 because of that we can't check for equality and instead check
618                 that string length + extra 68 bytes is less than overall data length
619             */
620       require(data.length >= 68 + bytes(reason).length, 'Invalid revert reason');
621       return string(abi.encodePacked(prefix, 'Error(', reason, ')'));
622     }
623     // 36 = 4-byte selector 0x4e487b71 + 32 bytes integer
624     else if (data.length == 36 && data[0] == '\x4e' && data[1] == '\x48' && data[2] == '\x7b' && data[3] == '\x71') {
625       uint256 code;
626       // solhint-disable no-inline-assembly
627       assembly {
628         // 36 = 32 bytes data length + 4-byte selector
629         code := mload(add(data, 36))
630       }
631       return string(abi.encodePacked(prefix, 'Panic(', _toHex(code), ')'));
632     }
633 
634     return string(abi.encodePacked(prefix, 'Unknown(', _toHex(data), ')'));
635   }
636 
637   function _toHex(uint256 value) private pure returns (string memory) {
638     return _toHex(abi.encodePacked(value));
639   }
640 
641   function _toHex(bytes memory data) private pure returns (string memory) {
642     bytes16 alphabet = 0x30313233343536373839616263646566;
643     bytes memory str = new bytes(2 + data.length * 2);
644     str[0] = '0';
645     str[1] = 'x';
646     for (uint256 i = 0; i < data.length; i++) {
647       str[2 * i + 2] = alphabet[uint8(data[i] >> 4)];
648       str[2 * i + 3] = alphabet[uint8(data[i] & 0x0f)];
649     }
650     return string(str);
651   }
652 }
653 
654 // File: contracts/dependency/Permitable.sol
655 
656 
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /*
662 “Copyright (c) 2019-2021 1inch 
663 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
664 and associated documentation files (the "Software"), to deal in the Software without restriction,
665 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
666 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
667 subject to the following conditions: 
668 The above copyright notice and this permission notice shall be included
669 in all copies or substantial portions of the Software. 
670 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
671 THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
672 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
673 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
674 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE”.
675 */
676 
677 contract Permitable {
678   event Error(string reason);
679 
680   function _permit(
681     IERC20 token,
682     uint256 amount,
683     bytes calldata permit
684   ) internal {
685     if (permit.length == 32 * 7) {
686       // solhint-disable-next-line avoid-low-level-calls
687       (bool success, bytes memory result) = address(token).call(
688         abi.encodePacked(IERC20Permit.permit.selector, permit)
689       );
690       if (!success) {
691         string memory reason = RevertReasonParser.parse(result, 'Permit call failed: ');
692         if (token.allowance(msg.sender, address(this)) < amount) {
693           revert(reason);
694         } else {
695           emit Error(reason);
696         }
697       }
698     }
699   }
700 }
701 
702 // File: contracts/interfaces/IAggregationExecutor.sol
703 
704 
705 
706 pragma solidity >=0.6.12;
707 
708 interface IAggregationExecutor {
709   function callBytes(bytes calldata data) external payable; // 0xd9c45357
710 
711   // callbytes per swap sequence
712   function swapSingleSequence(bytes calldata data) external;
713 
714   function finalTransactionProcessing(
715     address tokenIn,
716     address tokenOut,
717     address to,
718     bytes calldata destTokenFeeData
719   ) external;
720 }
721 
722 // File: @openzeppelin/contracts/interfaces/IERC20.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 // File: contracts/interfaces/IAggregationExecutor1Inch.sol
730 
731 
732 pragma solidity 0.8.9;
733 
734 interface IAggregationExecutor1Inch {
735   function callBytes(address msgSender, bytes calldata data) external payable; // 0x2636f7f8
736 }
737 
738 interface IAggregationRouter1InchV4 {
739   function swap(
740     IAggregationExecutor1Inch caller,
741     SwapDescription1Inch calldata desc,
742     bytes calldata data
743   ) external payable returns (uint256 returnAmount, uint256 gasLeft);
744 }
745 
746 struct SwapDescription1Inch {
747   IERC20 srcToken;
748   IERC20 dstToken;
749   address payable srcReceiver;
750   address payable dstReceiver;
751   uint256 amount;
752   uint256 minReturnAmount;
753   uint256 flags;
754   bytes permit;
755 }
756 
757 struct SwapDescriptionExecutor1Inch {
758   IERC20 srcToken;
759   IERC20 dstToken;
760   address payable srcReceiver1Inch;
761   address payable dstReceiver;
762   address[] srcReceivers;
763   uint256[] srcAmounts;
764   uint256 amount;
765   uint256 minReturnAmount;
766   uint256 flags;
767   bytes permit;
768 }
769 
770 // File: contracts/libraries/TransferHelper.sol
771 
772 
773 
774 pragma solidity >=0.5.16;
775 
776 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
777 library TransferHelper {
778   function safeApprove(
779     address token,
780     address to,
781     uint256 value
782   ) internal {
783     // bytes4(keccak256(bytes('approve(address,uint256)')));
784     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
785     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
786   }
787 
788   function safeTransfer(
789     address token,
790     address to,
791     uint256 value
792   ) internal {
793     // bytes4(keccak256(bytes('transfer(address,uint256)')));
794     if (value == 0) return;
795     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
796     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
797   }
798 
799   function safeTransferFrom(
800     address token,
801     address from,
802     address to,
803     uint256 value
804   ) internal {
805     // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
806     if (value == 0) return;
807     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
808     require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
809   }
810 
811   function safeTransferETH(address to, uint256 value) internal {
812     if (value == 0) return;
813     (bool success, ) = to.call{value: value}(new bytes(0));
814     require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
815   }
816 }
817 
818 // File: contracts/MetaAggregationRouter.sol
819 
820 
821 
822 /// Copyright (c) 2019-2021 1inch
823 /// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
824 /// and associated documentation files (the "Software"), to deal in the Software without restriction,
825 /// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
826 /// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
827 /// subject to the following conditions:
828 /// The above copyright notice and this permission notice shall be included in all copies or
829 /// substantial portions of the Software.
830 /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
831 /// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
832 /// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
833 /// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
834 /// OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
835 
836 pragma solidity 0.8.9;
837 
838 
839 
840 
841 
842 
843 
844 
845 contract MetaAggregationRouter is Permitable, Ownable {
846   using SafeERC20 for IERC20;
847 
848   address public immutable WETH;
849   address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
850 
851   uint256 private constant _PARTIAL_FILL = 0x01;
852   uint256 private constant _REQUIRES_EXTRA_ETH = 0x02;
853   uint256 private constant _SHOULD_CLAIM = 0x04;
854   uint256 private constant _BURN_FROM_MSG_SENDER = 0x08;
855   uint256 private constant _BURN_FROM_TX_ORIGIN = 0x10;
856   uint256 private constant _SIMPLE_SWAP = 0x20;
857 
858   mapping(address => bool) public isWhitelist;
859 
860   struct SwapDescription {
861     IERC20 srcToken;
862     IERC20 dstToken;
863     address[] srcReceivers;
864     uint256[] srcAmounts;
865     address dstReceiver;
866     uint256 amount;
867     uint256 minReturnAmount;
868     uint256 flags;
869     bytes permit;
870   }
871 
872   struct SimpleSwapData {
873     address[] firstPools;
874     uint256[] firstSwapAmounts;
875     bytes[] swapDatas;
876     uint256 deadline;
877     bytes destTokenFeeData;
878   }
879 
880   event Swapped(
881     address sender,
882     IERC20 srcToken,
883     IERC20 dstToken,
884     address dstReceiver,
885     uint256 spentAmount,
886     uint256 returnAmount
887   );
888 
889   event ClientData(bytes clientData);
890 
891   event Exchange(address pair, uint256 amountOut, address output);
892 
893   constructor(address _WETH) {
894     WETH = _WETH;
895   }
896 
897   receive() external payable {
898     assert(msg.sender == WETH);
899     // only accept ETH via fallback from the WETH contract
900   }
901 
902   function rescueFunds(address token, uint256 amount) external onlyOwner {
903     if (_isETH(IERC20(token))) {
904       TransferHelper.safeTransferETH(msg.sender, amount);
905     } else {
906       TransferHelper.safeTransfer(token, msg.sender, amount);
907     }
908   }
909 
910   function updateWhitelist(address addr, bool value) external onlyOwner {
911     isWhitelist[addr] = value;
912   }
913 
914   function swapRouter1Inch(
915     address router1Inch,
916     bytes calldata router1InchData,
917     SwapDescription calldata desc,
918     bytes calldata clientData
919   ) external payable returns (uint256 returnAmount, uint256 gasUsed) {
920     uint256 gasBefore = gasleft();
921     require(isWhitelist[router1Inch], 'not whitelist router');
922     require(desc.minReturnAmount > 0, 'Min return should not be 0');
923     require(
924       desc.srcReceivers.length == desc.srcAmounts.length && desc.srcAmounts.length <= 1,
925       'Invalid lengths for receiving src tokens'
926     );
927 
928     uint256 val = msg.value;
929     if (!_isETH(desc.srcToken)) {
930       // transfer token to kyber router
931       _permit(desc.srcToken, desc.amount, desc.permit);
932       TransferHelper.safeTransferFrom(address(desc.srcToken), msg.sender, address(this), desc.amount);
933 
934       // approve token to 1inch router
935       uint256 amount = _getBalance(desc.srcToken, address(this));
936       desc.srcToken.safeIncreaseAllowance(router1Inch, amount);
937 
938       // transfer fee to feeTaker
939       for (uint256 i = 0; i < desc.srcReceivers.length; i++) {
940         TransferHelper.safeTransferFrom(address(desc.srcToken), msg.sender, desc.srcReceivers[i], desc.srcAmounts[i]);
941       }
942     } else {
943       for (uint256 i = 0; i < desc.srcReceivers.length; i++) {
944         val -= desc.srcAmounts[i];
945         TransferHelper.safeTransferETH(desc.srcReceivers[i], desc.srcAmounts[i]);
946       }
947     }
948 
949     address dstReceiver = (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
950     uint256 initialSrcBalance = (desc.flags & _PARTIAL_FILL != 0) ? _getBalance(desc.srcToken, msg.sender) : 0;
951     uint256 initialDstBalance = _getBalance(desc.dstToken, dstReceiver);
952     {
953       // call to 1inch router contract
954       (bool success, ) = router1Inch.call{value: val}(router1InchData);
955       require(success, 'call to 1inch router fail');
956     }
957 
958     // 1inch router return to msg.sender (mean fund will return to this address)
959     uint256 stuckAmount = _getBalance(desc.dstToken, address(this));
960     _doTransferERC20(desc.dstToken, dstReceiver, stuckAmount);
961 
962     // safe check here
963     returnAmount = _getBalance(desc.dstToken, dstReceiver) - initialDstBalance;
964     uint256 spentAmount = desc.amount;
965     if (desc.flags & _PARTIAL_FILL != 0) {
966       spentAmount = initialSrcBalance + desc.amount - _getBalance(desc.srcToken, msg.sender);
967       require(returnAmount * desc.amount >= desc.minReturnAmount * spentAmount, 'Return amount is not enough');
968     } else {
969       require(returnAmount >= desc.minReturnAmount, 'Return amount is not enough');
970     }
971 
972     emit Swapped(msg.sender, desc.srcToken, desc.dstToken, dstReceiver, spentAmount, returnAmount);
973     emit Exchange(router1Inch, returnAmount, _isETH(desc.dstToken) ? WETH : address(desc.dstToken));
974     emit ClientData(clientData);
975     unchecked {
976       gasUsed = gasBefore - gasleft();
977     }
978   }
979 
980   function swapExecutor1Inch(
981     IAggregationExecutor1Inch caller,
982     SwapDescriptionExecutor1Inch calldata desc,
983     bytes calldata executor1InchData,
984     bytes calldata clientData
985   ) external payable returns (uint256 returnAmount, uint256 gasUsed) {
986     uint256 gasBefore = gasleft();
987     require(desc.minReturnAmount > 0, 'Min return should not be 0');
988     require(executor1InchData.length > 0, 'data should not be empty');
989     require(desc.srcReceivers.length == desc.srcAmounts.length, 'invalid src receivers length');
990 
991     bool srcETH = _isETH(desc.srcToken);
992     if (desc.flags & _REQUIRES_EXTRA_ETH != 0) {
993       require(msg.value > (srcETH ? desc.amount : 0), 'Invalid msg.value');
994     } else {
995       require(msg.value == (srcETH ? desc.amount : 0), 'Invalid msg.value');
996     }
997     uint256 val = msg.value;
998     if (!srcETH) {
999       _permit(desc.srcToken, desc.amount, desc.permit);
1000 
1001       // transfer to fee taker
1002       uint256 srcReceiversLength = desc.srcReceivers.length;
1003       for (uint256 i = 0; i < srcReceiversLength; ) {
1004         TransferHelper.safeTransferFrom(address(desc.srcToken), msg.sender, desc.srcReceivers[i], desc.srcAmounts[i]);
1005         unchecked {
1006           ++i;
1007         }
1008       }
1009 
1010       // transfer to 1inch srcReceiver
1011       TransferHelper.safeTransferFrom(address(desc.srcToken), msg.sender, desc.srcReceiver1Inch, desc.amount);
1012     } else {
1013       // transfer to 1inch srcReceiver
1014       uint256 srcReceiversLength = desc.srcReceivers.length;
1015       for (uint256 i = 0; i < srcReceiversLength; ) {
1016         val -= desc.srcAmounts[i];
1017         TransferHelper.safeTransferETH(desc.srcReceivers[i], desc.srcAmounts[i]);
1018         unchecked {
1019           ++i;
1020         }
1021       }
1022     }
1023 
1024     {
1025       bytes memory callData = abi.encodePacked(caller.callBytes.selector, bytes12(0), msg.sender, executor1InchData);
1026       // solhint-disable-next-line avoid-low-level-calls
1027       (bool success, bytes memory result) = address(caller).call{value: val}(callData);
1028       if (!success) {
1029         revert(RevertReasonParser.parse(result, 'callBytes failed: '));
1030       }
1031     }
1032 
1033     uint256 spentAmount = desc.amount;
1034     returnAmount = _getBalance(desc.dstToken, address(this));
1035 
1036     if (desc.flags & _PARTIAL_FILL != 0) {
1037       uint256 unspentAmount = _getBalance(desc.srcToken, address(this));
1038       if (unspentAmount > 0) {
1039         spentAmount = spentAmount - unspentAmount;
1040         _doTransferERC20(desc.srcToken, msg.sender, unspentAmount);
1041       }
1042 
1043       require(returnAmount * desc.amount >= desc.minReturnAmount * spentAmount, 'Return amount is not enough');
1044     } else {
1045       require(returnAmount >= desc.minReturnAmount, 'Return amount is not enough');
1046     }
1047 
1048     address dstReceiver = (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
1049     _doTransferERC20(desc.dstToken, dstReceiver, returnAmount);
1050 
1051     emit Swapped(msg.sender, desc.srcToken, desc.dstToken, dstReceiver, spentAmount, returnAmount);
1052     emit Exchange(address(caller), returnAmount, _isETH(desc.dstToken) ? WETH : address(desc.dstToken));
1053     emit ClientData(clientData);
1054     unchecked {
1055       gasUsed = gasBefore - gasleft();
1056     }
1057   }
1058 
1059   function swap(
1060     IAggregationExecutor caller,
1061     SwapDescription calldata desc,
1062     bytes calldata executorData,
1063     bytes calldata clientData
1064   ) external payable returns (uint256 returnAmount, uint256 gasUsed) {
1065     uint256 gasBefore = gasleft();
1066     require(desc.minReturnAmount > 0, 'Min return should not be 0');
1067     require(executorData.length > 0, 'executorData should be not zero');
1068 
1069     uint256 flags = desc.flags;
1070 
1071     // simple mode swap
1072     if (flags & _SIMPLE_SWAP != 0) return swapSimpleMode(caller, desc, executorData, clientData);
1073 
1074     {
1075       IERC20 srcToken = desc.srcToken;
1076       if (flags & _REQUIRES_EXTRA_ETH != 0) {
1077         require(msg.value > (_isETH(srcToken) ? desc.amount : 0), 'Invalid msg.value');
1078       } else {
1079         require(msg.value == (_isETH(srcToken) ? desc.amount : 0), 'Invalid msg.value');
1080       }
1081 
1082       require(desc.srcReceivers.length == desc.srcAmounts.length, 'Invalid lengths for receiving src tokens');
1083 
1084       if (flags & _SHOULD_CLAIM != 0) {
1085         require(!_isETH(srcToken), 'Claim token is ETH');
1086         _permit(srcToken, desc.amount, desc.permit);
1087         for (uint256 i = 0; i < desc.srcReceivers.length; i++) {
1088           TransferHelper.safeTransferFrom(address(srcToken), msg.sender, desc.srcReceivers[i], desc.srcAmounts[i]);
1089         }
1090       }
1091 
1092       if (_isETH(srcToken)) {
1093         // normally in case taking fee in srcToken and srcToken is the native token
1094         for (uint256 i = 0; i < desc.srcReceivers.length; i++) {
1095           TransferHelper.safeTransferETH(desc.srcReceivers[i], desc.srcAmounts[i]);
1096         }
1097       }
1098     }
1099 
1100     {
1101       address dstReceiver = (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
1102       uint256 initialSrcBalance = (flags & _PARTIAL_FILL != 0) ? _getBalance(desc.srcToken, msg.sender) : 0;
1103       IERC20 dstToken = desc.dstToken;
1104       uint256 initialDstBalance = _getBalance(dstToken, dstReceiver);
1105 
1106       _callWithEth(caller, executorData);
1107 
1108       uint256 spentAmount = desc.amount;
1109       returnAmount = _getBalance(dstToken, dstReceiver) - initialDstBalance;
1110 
1111       if (flags & _PARTIAL_FILL != 0) {
1112         spentAmount = initialSrcBalance + desc.amount - _getBalance(desc.srcToken, msg.sender);
1113         require(returnAmount * desc.amount >= desc.minReturnAmount * spentAmount, 'Return amount is not enough');
1114       } else {
1115         require(returnAmount >= desc.minReturnAmount, 'Return amount is not enough');
1116       }
1117 
1118       emit Swapped(msg.sender, desc.srcToken, dstToken, dstReceiver, spentAmount, returnAmount);
1119       emit Exchange(address(caller), returnAmount, _isETH(dstToken) ? WETH : address(dstToken));
1120       emit ClientData(clientData);
1121     }
1122 
1123     unchecked {
1124       gasUsed = gasBefore - gasleft();
1125     }
1126   }
1127 
1128   function swapSimpleMode(
1129     IAggregationExecutor caller,
1130     SwapDescription calldata desc,
1131     bytes calldata executorData,
1132     bytes calldata clientData
1133   ) public returns (uint256 returnAmount, uint256 gasUsed) {
1134     uint256 gasBefore = gasleft();
1135 
1136     require(!_isETH(desc.srcToken), 'src is eth, should use normal swap');
1137     _permit(desc.srcToken, desc.amount, desc.permit);
1138 
1139     uint256 totalSwapAmount = desc.amount;
1140     if (desc.srcReceivers.length > 0) {
1141       // take fee in tokenIn
1142       require(
1143         desc.srcReceivers.length == 1 && desc.srcReceivers.length == desc.srcAmounts.length,
1144         'Wrong number of src receivers'
1145       );
1146       TransferHelper.safeTransferFrom(address(desc.srcToken), msg.sender, desc.srcReceivers[0], desc.srcAmounts[0]);
1147       require(desc.srcAmounts[0] <= totalSwapAmount, 'invalid fee amount in src token');
1148       totalSwapAmount -= desc.srcAmounts[0];
1149     }
1150     address dstReceiver = (desc.dstReceiver == address(0)) ? msg.sender : desc.dstReceiver;
1151     uint256 initialDstBalance = _getBalance(desc.srcToken, dstReceiver);
1152 
1153     _swapMultiSequencesWithSimpleMode(
1154       caller,
1155       address(desc.srcToken),
1156       totalSwapAmount,
1157       address(desc.dstToken),
1158       dstReceiver,
1159       executorData
1160     );
1161 
1162     returnAmount = _getBalance(desc.dstToken, dstReceiver) - initialDstBalance;
1163 
1164     require(returnAmount >= desc.minReturnAmount, 'Return amount is not enough');
1165     emit Swapped(msg.sender, desc.srcToken, desc.dstToken, dstReceiver, desc.amount, returnAmount);
1166     emit Exchange(address(caller), returnAmount, _isETH(desc.dstToken) ? WETH : address(desc.dstToken));
1167     emit ClientData(clientData);
1168 
1169     unchecked {
1170       gasUsed = gasBefore - gasleft();
1171     }
1172   }
1173 
1174   function _doTransferERC20(
1175     IERC20 token,
1176     address to,
1177     uint256 amount
1178   ) internal {
1179     if (amount > 0) {
1180       if (_isETH(token)) {
1181         TransferHelper.safeTransferETH(to, amount);
1182       } else {
1183         TransferHelper.safeTransfer(address(token), to, amount);
1184       }
1185     }
1186   }
1187 
1188   // Only use this mode if the first pool of each sequence can receive tokenIn directly into the pool
1189   function _swapMultiSequencesWithSimpleMode(
1190     IAggregationExecutor caller,
1191     address tokenIn,
1192     uint256 totalSwapAmount,
1193     address tokenOut,
1194     address dstReceiver,
1195     bytes calldata data
1196   ) internal {
1197     SimpleSwapData memory swapData = abi.decode(data, (SimpleSwapData));
1198     require(swapData.deadline >= block.timestamp, 'ROUTER: Expired');
1199     require(
1200       swapData.firstPools.length == swapData.firstSwapAmounts.length &&
1201         swapData.firstPools.length == swapData.swapDatas.length,
1202       'invalid swap data length'
1203     );
1204     uint256 numberSeq = swapData.firstPools.length;
1205     for (uint256 i = 0; i < numberSeq; i++) {
1206       // collect amount to the first pool
1207       TransferHelper.safeTransferFrom(tokenIn, msg.sender, swapData.firstPools[i], swapData.firstSwapAmounts[i]);
1208       require(swapData.firstSwapAmounts[i] <= totalSwapAmount, 'invalid swap amount');
1209       totalSwapAmount -= swapData.firstSwapAmounts[i];
1210       {
1211         // solhint-disable-next-line avoid-low-level-calls
1212         // may take some native tokens for commission fee
1213         (bool success, bytes memory result) = address(caller).call(
1214           abi.encodeWithSelector(caller.swapSingleSequence.selector, swapData.swapDatas[i])
1215         );
1216         if (!success) {
1217           revert(RevertReasonParser.parse(result, 'swapSingleSequence failed: '));
1218         }
1219       }
1220     }
1221     {
1222       // solhint-disable-next-line avoid-low-level-calls
1223       // may take some native tokens for commission fee
1224       (bool success, bytes memory result) = address(caller).call(
1225         abi.encodeWithSelector(
1226           caller.finalTransactionProcessing.selector,
1227           tokenIn,
1228           tokenOut,
1229           dstReceiver,
1230           swapData.destTokenFeeData
1231         )
1232       );
1233       if (!success) {
1234         revert(RevertReasonParser.parse(result, 'finalTransactionProcessing failed: '));
1235       }
1236     }
1237   }
1238 
1239   function _getBalance(IERC20 token, address account) internal view returns (uint256) {
1240     if (_isETH(token)) {
1241       return account.balance;
1242     } else {
1243       return token.balanceOf(account);
1244     }
1245   }
1246 
1247   function _isETH(IERC20 token) internal pure returns (bool) {
1248     return (address(token) == ETH_ADDRESS);
1249   }
1250 
1251   function _callWithEth(IAggregationExecutor caller, bytes calldata executorData) internal {
1252     // solhint-disable-next-line avoid-low-level-calls
1253     // may take some native tokens for commission fee
1254     uint256 ethAmount = _getBalance(IERC20(ETH_ADDRESS), address(this));
1255     if (ethAmount > msg.value) ethAmount = msg.value;
1256     (bool success, bytes memory result) = address(caller).call{value: ethAmount}(
1257       abi.encodeWithSelector(caller.callBytes.selector, executorData)
1258     );
1259     if (!success) {
1260       revert(RevertReasonParser.parse(result, 'callBytes failed: '));
1261     }
1262   }
1263 }