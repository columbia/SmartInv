1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity 0.8.6;
4 
5 
6 
7 // Part: IBetaBank
8 
9 interface IBetaBank {
10   /// @dev Returns the address of BToken of the given underlying token, or 0 if not exists.
11   function bTokens(address _underlying) external view returns (address);
12 
13   /// @dev Returns the address of the underlying of the given BToken, or 0 if not exists.
14   function underlyings(address _bToken) external view returns (address);
15 
16   /// @dev Returns the address of the oracle contract.
17   function oracle() external view returns (address);
18 
19   /// @dev Returns the address of the config contract.
20   function config() external view returns (address);
21 
22   /// @dev Returns the interest rate model smart contract.
23   function interestModel() external view returns (address);
24 
25   /// @dev Returns the position's collateral token and AmToken.
26   function getPositionTokens(address _owner, uint _pid)
27     external
28     view
29     returns (address _collateral, address _bToken);
30 
31   /// @dev Returns the debt of the given position. Can't be view as it needs to call accrue.
32   function fetchPositionDebt(address _owner, uint _pid) external returns (uint);
33 
34   /// @dev Returns the LTV of the given position. Can't be view as it needs to call accrue.
35   function fetchPositionLTV(address _owner, uint _pid) external returns (uint);
36 
37   /// @dev Opens a new position in the Beta smart contract.
38   function open(
39     address _owner,
40     address _underlying,
41     address _collateral
42   ) external returns (uint pid);
43 
44   /// @dev Borrows tokens on the given position.
45   function borrow(
46     address _owner,
47     uint _pid,
48     uint _amount
49   ) external;
50 
51   /// @dev Repays tokens on the given position.
52   function repay(
53     address _owner,
54     uint _pid,
55     uint _amount
56   ) external;
57 
58   /// @dev Puts more collateral to the given position.
59   function put(
60     address _owner,
61     uint _pid,
62     uint _amount
63   ) external;
64 
65   /// @dev Takes some collateral out of the position.
66   function take(
67     address _owner,
68     uint _pid,
69     uint _amount
70   ) external;
71 
72   /// @dev Liquidates the given position.
73   function liquidate(
74     address _owner,
75     uint _pid,
76     uint _amount
77   ) external;
78 }
79 
80 // Part: IBetaConfig
81 
82 interface IBetaConfig {
83   /// @dev Returns the risk level for the given asset.
84   function getRiskLevel(address token) external view returns (uint);
85 
86   /// @dev Returns the rate of interest collected to be distributed to the protocol reserve.
87   function reserveRate() external view returns (uint);
88 
89   /// @dev Returns the beneficiary to receive a portion interest rate for the protocol.
90   function reserveBeneficiary() external view returns (address);
91 
92   /// @dev Returns the ratio of which the given token consider for collateral value.
93   function getCollFactor(address token) external view returns (uint);
94 
95   /// @dev Returns the max amount of collateral to accept globally.
96   function getCollMaxAmount(address token) external view returns (uint);
97 
98   /// @dev Returns max ltv of collateral / debt to allow a new position.
99   function getSafetyLTV(address token) external view returns (uint);
100 
101   /// @dev Returns max ltv of collateral / debt to liquidate a position of the given token.
102   function getLiquidationLTV(address token) external view returns (uint);
103 
104   /// @dev Returns the bonus incentive reward factor for liquidators.
105   function getKillBountyRate(address token) external view returns (uint);
106 }
107 
108 // Part: IBetaInterestModel
109 
110 interface IBetaInterestModel {
111   /// @dev Returns the initial interest rate per year (times 1e18).
112   function initialRate() external view returns (uint);
113 
114   /// @dev Returns the next interest rate for the market.
115   /// @param prevRate The current interest rate.
116   /// @param totalAvailable The current available liquidity.
117   /// @param totalLoan The current outstanding loan.
118   /// @param timePast The time past since last interest rate rebase in seconds.
119   function getNextInterestRate(
120     uint prevRate,
121     uint totalAvailable,
122     uint totalLoan,
123     uint timePast
124   ) external view returns (uint);
125 }
126 
127 // Part: IWETH
128 
129 interface IWETH {
130   function deposit() external payable;
131 
132   function withdraw(uint wad) external;
133 
134   function approve(address guy, uint wad) external returns (bool);
135 }
136 
137 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Address
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      */
160     function isContract(address account) internal view returns (bool) {
161         // This method relies on extcodesize, which returns 0 for contracts in
162         // construction, since the code is only stored at the end of the
163         // constructor execution.
164 
165         uint256 size;
166         assembly {
167             size := extcodesize(account)
168         }
169         return size > 0;
170     }
171 
172     /**
173      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
174      * `recipient`, forwarding all available gas and reverting on errors.
175      *
176      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
177      * of certain opcodes, possibly making contracts go over the 2300 gas limit
178      * imposed by `transfer`, making them unable to receive funds via
179      * `transfer`. {sendValue} removes this limitation.
180      *
181      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
182      *
183      * IMPORTANT: because control is transferred to `recipient`, care must be
184      * taken to not create reentrancy vulnerabilities. Consider using
185      * {ReentrancyGuard} or the
186      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
187      */
188     function sendValue(address payable recipient, uint256 amount) internal {
189         require(address(this).balance >= amount, "Address: insufficient balance");
190 
191         (bool success, ) = recipient.call{value: amount}("");
192         require(success, "Address: unable to send value, recipient may have reverted");
193     }
194 
195     /**
196      * @dev Performs a Solidity function call using a low level `call`. A
197      * plain `call` is an unsafe replacement for a function call: use this
198      * function instead.
199      *
200      * If `target` reverts with a revert reason, it is bubbled up by this
201      * function (like regular Solidity function calls).
202      *
203      * Returns the raw returned data. To convert to the expected return value,
204      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
205      *
206      * Requirements:
207      *
208      * - `target` must be a contract.
209      * - calling `target` with `data` must not revert.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
214         return functionCall(target, data, "Address: low-level call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
219      * `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, 0, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but also transferring `value` wei to `target`.
234      *
235      * Requirements:
236      *
237      * - the calling contract must have an ETH balance of at least `value`.
238      * - the called Solidity function must be `payable`.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
252      * with `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(address(this).balance >= value, "Address: insufficient balance for call");
263         require(isContract(target), "Address: call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.call{value: value}(data);
266         return _verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
276         return functionStaticCall(target, data, "Address: low-level static call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal view returns (bytes memory) {
290         require(isContract(target), "Address: static call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.staticcall(data);
293         return _verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(isContract(target), "Address: delegate call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.delegatecall(data);
320         return _verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     function _verifyCallResult(
324         bool success,
325         bytes memory returndata,
326         string memory errorMessage
327     ) private pure returns (bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 assembly {
336                     let returndata_size := mload(returndata)
337                     revert(add(32, returndata), returndata_size)
338                 }
339             } else {
340                 revert(errorMessage);
341             }
342         }
343     }
344 }
345 
346 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context
347 
348 /*
349  * @dev Provides information about the current execution context, including the
350  * sender of the transaction and its data. While these are generally available
351  * via msg.sender and msg.data, they should not be accessed in such a direct
352  * manner, since when dealing with meta-transactions the account sending and
353  * paying for execution may not be the actual sender (as far as an application
354  * is concerned).
355  *
356  * This contract is only required for intermediate, library-like contracts.
357  */
358 abstract contract Context {
359     function _msgSender() internal view virtual returns (address) {
360         return msg.sender;
361     }
362 
363     function _msgData() internal view virtual returns (bytes calldata) {
364         return msg.data;
365     }
366 }
367 
368 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Counters
369 
370 /**
371  * @title Counters
372  * @author Matt Condon (@shrugs)
373  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
374  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
375  *
376  * Include with `using Counters for Counters.Counter;`
377  */
378 library Counters {
379     struct Counter {
380         // This variable should never be directly accessed by users of the library: interactions must be restricted to
381         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
382         // this feature: see https://github.com/ethereum/solidity/issues/4637
383         uint256 _value; // default: 0
384     }
385 
386     function current(Counter storage counter) internal view returns (uint256) {
387         return counter._value;
388     }
389 
390     function increment(Counter storage counter) internal {
391         unchecked {
392             counter._value += 1;
393         }
394     }
395 
396     function decrement(Counter storage counter) internal {
397         uint256 value = counter._value;
398         require(value > 0, "Counter: decrement overflow");
399         unchecked {
400             counter._value = value - 1;
401         }
402     }
403 
404     function reset(Counter storage counter) internal {
405         counter._value = 0;
406     }
407 }
408 
409 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ECDSA
410 
411 /**
412  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
413  *
414  * These functions can be used to verify that a message was signed by the holder
415  * of the private keys of a given address.
416  */
417 library ECDSA {
418     /**
419      * @dev Returns the address that signed a hashed message (`hash`) with
420      * `signature`. This address can then be used for verification purposes.
421      *
422      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
423      * this function rejects them by requiring the `s` value to be in the lower
424      * half order, and the `v` value to be either 27 or 28.
425      *
426      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
427      * verification to be secure: it is possible to craft signatures that
428      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
429      * this is by receiving a hash of the original message (which may otherwise
430      * be too long), and then calling {toEthSignedMessageHash} on it.
431      *
432      * Documentation for signature generation:
433      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
434      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
435      */
436     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
437         // Check the signature length
438         // - case 65: r,s,v signature (standard)
439         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
440         if (signature.length == 65) {
441             bytes32 r;
442             bytes32 s;
443             uint8 v;
444             // ecrecover takes the signature parameters, and the only way to get them
445             // currently is to use assembly.
446             assembly {
447                 r := mload(add(signature, 0x20))
448                 s := mload(add(signature, 0x40))
449                 v := byte(0, mload(add(signature, 0x60)))
450             }
451             return recover(hash, v, r, s);
452         } else if (signature.length == 64) {
453             bytes32 r;
454             bytes32 vs;
455             // ecrecover takes the signature parameters, and the only way to get them
456             // currently is to use assembly.
457             assembly {
458                 r := mload(add(signature, 0x20))
459                 vs := mload(add(signature, 0x40))
460             }
461             return recover(hash, r, vs);
462         } else {
463             revert("ECDSA: invalid signature length");
464         }
465     }
466 
467     /**
468      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
469      *
470      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
471      *
472      * _Available since v4.2._
473      */
474     function recover(
475         bytes32 hash,
476         bytes32 r,
477         bytes32 vs
478     ) internal pure returns (address) {
479         bytes32 s;
480         uint8 v;
481         assembly {
482             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
483             v := add(shr(255, vs), 27)
484         }
485         return recover(hash, v, r, s);
486     }
487 
488     /**
489      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
490      */
491     function recover(
492         bytes32 hash,
493         uint8 v,
494         bytes32 r,
495         bytes32 s
496     ) internal pure returns (address) {
497         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
498         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
499         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
500         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
501         //
502         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
503         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
504         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
505         // these malleable signatures as well.
506         require(
507             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
508             "ECDSA: invalid signature 's' value"
509         );
510         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
511 
512         // If the signature is valid (and not malleable), return the signer address
513         address signer = ecrecover(hash, v, r, s);
514         require(signer != address(0), "ECDSA: invalid signature");
515 
516         return signer;
517     }
518 
519     /**
520      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
521      * produces hash corresponding to the one signed with the
522      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
523      * JSON-RPC method as part of EIP-191.
524      *
525      * See {recover}.
526      */
527     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
528         // 32 is the length in bytes of hash,
529         // enforced by the type signature above
530         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
531     }
532 
533     /**
534      * @dev Returns an Ethereum Signed Typed Data, created from a
535      * `domainSeparator` and a `structHash`. This produces hash corresponding
536      * to the one signed with the
537      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
538      * JSON-RPC method as part of EIP-712.
539      *
540      * See {recover}.
541      */
542     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
543         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
544     }
545 }
546 
547 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20
548 
549 /**
550  * @dev Interface of the ERC20 standard as defined in the EIP.
551  */
552 interface IERC20 {
553     /**
554      * @dev Returns the amount of tokens in existence.
555      */
556     function totalSupply() external view returns (uint256);
557 
558     /**
559      * @dev Returns the amount of tokens owned by `account`.
560      */
561     function balanceOf(address account) external view returns (uint256);
562 
563     /**
564      * @dev Moves `amount` tokens from the caller's account to `recipient`.
565      *
566      * Returns a boolean value indicating whether the operation succeeded.
567      *
568      * Emits a {Transfer} event.
569      */
570     function transfer(address recipient, uint256 amount) external returns (bool);
571 
572     /**
573      * @dev Returns the remaining number of tokens that `spender` will be
574      * allowed to spend on behalf of `owner` through {transferFrom}. This is
575      * zero by default.
576      *
577      * This value changes when {approve} or {transferFrom} are called.
578      */
579     function allowance(address owner, address spender) external view returns (uint256);
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
583      *
584      * Returns a boolean value indicating whether the operation succeeded.
585      *
586      * IMPORTANT: Beware that changing an allowance with this method brings the risk
587      * that someone may use both the old and the new allowance by unfortunate
588      * transaction ordering. One possible solution to mitigate this race
589      * condition is to first reduce the spender's allowance to 0 and set the
590      * desired value afterwards:
591      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address spender, uint256 amount) external returns (bool);
596 
597     /**
598      * @dev Moves `amount` tokens from `sender` to `recipient` using the
599      * allowance mechanism. `amount` is then deducted from the caller's
600      * allowance.
601      *
602      * Returns a boolean value indicating whether the operation succeeded.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transferFrom(
607         address sender,
608         address recipient,
609         uint256 amount
610     ) external returns (bool);
611 
612     /**
613      * @dev Emitted when `value` tokens are moved from one account (`from`) to
614      * another (`to`).
615      *
616      * Note that `value` may be zero.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 value);
619 
620     /**
621      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
622      * a call to {approve}. `value` is the new allowance.
623      */
624     event Approval(address indexed owner, address indexed spender, uint256 value);
625 }
626 
627 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Permit
628 
629 /**
630  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
631  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
632  *
633  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
634  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
635  * need to send a transaction, and thus is not required to hold Ether at all.
636  */
637 interface IERC20Permit {
638     /**
639      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
640      * given ``owner``'s signed approval.
641      *
642      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
643      * ordering also apply here.
644      *
645      * Emits an {Approval} event.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `deadline` must be a timestamp in the future.
651      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
652      * over the EIP712-formatted function arguments.
653      * - the signature must use ``owner``'s current nonce (see {nonces}).
654      *
655      * For more information on the signature format, see the
656      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
657      * section].
658      */
659     function permit(
660         address owner,
661         address spender,
662         uint256 value,
663         uint256 deadline,
664         uint8 v,
665         bytes32 r,
666         bytes32 s
667     ) external;
668 
669     /**
670      * @dev Returns the current nonce for `owner`. This value must be
671      * included whenever a signature is generated for {permit}.
672      *
673      * Every successful call to {permit} increases ``owner``'s nonce by one. This
674      * prevents a signature from being used multiple times.
675      */
676     function nonces(address owner) external view returns (uint256);
677 
678     /**
679      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
680      */
681     // solhint-disable-next-line func-name-mixedcase
682     function DOMAIN_SEPARATOR() external view returns (bytes32);
683 }
684 
685 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Math
686 
687 /**
688  * @dev Standard math utilities missing in the Solidity language.
689  */
690 library Math {
691     /**
692      * @dev Returns the largest of two numbers.
693      */
694     function max(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a >= b ? a : b;
696     }
697 
698     /**
699      * @dev Returns the smallest of two numbers.
700      */
701     function min(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a < b ? a : b;
703     }
704 
705     /**
706      * @dev Returns the average of two numbers. The result is rounded towards
707      * zero.
708      */
709     function average(uint256 a, uint256 b) internal pure returns (uint256) {
710         // (a + b) / 2 can overflow, so we distribute.
711         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
712     }
713 
714     /**
715      * @dev Returns the ceiling of the division of two numbers.
716      *
717      * This differs from standard division with `/` in that it rounds up instead
718      * of rounding down.
719      */
720     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
721         // (a + b - 1) / b can overflow on addition, so we distribute.
722         return a / b + (a % b == 0 ? 0 : 1);
723     }
724 }
725 
726 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ReentrancyGuard
727 
728 /**
729  * @dev Contract module that helps prevent reentrant calls to a function.
730  *
731  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
732  * available, which can be applied to functions to make sure there are no nested
733  * (reentrant) calls to them.
734  *
735  * Note that because there is a single `nonReentrant` guard, functions marked as
736  * `nonReentrant` may not call one another. This can be worked around by making
737  * those functions `private`, and then adding `external` `nonReentrant` entry
738  * points to them.
739  *
740  * TIP: If you would like to learn more about reentrancy and alternative ways
741  * to protect against it, check out our blog post
742  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
743  */
744 abstract contract ReentrancyGuard {
745     // Booleans are more expensive than uint256 or any type that takes up a full
746     // word because each write operation emits an extra SLOAD to first read the
747     // slot's contents, replace the bits taken up by the boolean, and then write
748     // back. This is the compiler's defense against contract upgrades and
749     // pointer aliasing, and it cannot be disabled.
750 
751     // The values being non-zero value makes deployment a bit more expensive,
752     // but in exchange the refund on every call to nonReentrant will be lower in
753     // amount. Since refunds are capped to a percentage of the total
754     // transaction's gas, it is best to keep them low in cases like this one, to
755     // increase the likelihood of the full refund coming into effect.
756     uint256 private constant _NOT_ENTERED = 1;
757     uint256 private constant _ENTERED = 2;
758 
759     uint256 private _status;
760 
761     constructor() {
762         _status = _NOT_ENTERED;
763     }
764 
765     /**
766      * @dev Prevents a contract from calling itself, directly or indirectly.
767      * Calling a `nonReentrant` function from another `nonReentrant`
768      * function is not supported. It is possible to prevent this from happening
769      * by making the `nonReentrant` function external, and make it call a
770      * `private` function that does the actual work.
771      */
772     modifier nonReentrant() {
773         // On the first call to nonReentrant, _notEntered will be true
774         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
775 
776         // Any calls to nonReentrant after this point will fail
777         _status = _ENTERED;
778 
779         _;
780 
781         // By storing the original value once again, a refund is triggered (see
782         // https://eips.ethereum.org/EIPS/eip-2200)
783         _status = _NOT_ENTERED;
784     }
785 }
786 
787 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/EIP712
788 
789 /**
790  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
791  *
792  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
793  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
794  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
795  *
796  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
797  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
798  * ({_hashTypedDataV4}).
799  *
800  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
801  * the chain id to protect against replay attacks on an eventual fork of the chain.
802  *
803  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
804  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
805  *
806  * _Available since v3.4._
807  */
808 abstract contract EIP712 {
809     /* solhint-disable var-name-mixedcase */
810     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
811     // invalidate the cached domain separator if the chain id changes.
812     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
813     uint256 private immutable _CACHED_CHAIN_ID;
814 
815     bytes32 private immutable _HASHED_NAME;
816     bytes32 private immutable _HASHED_VERSION;
817     bytes32 private immutable _TYPE_HASH;
818 
819     /* solhint-enable var-name-mixedcase */
820 
821     /**
822      * @dev Initializes the domain separator and parameter caches.
823      *
824      * The meaning of `name` and `version` is specified in
825      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
826      *
827      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
828      * - `version`: the current major version of the signing domain.
829      *
830      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
831      * contract upgrade].
832      */
833     constructor(string memory name, string memory version) {
834         bytes32 hashedName = keccak256(bytes(name));
835         bytes32 hashedVersion = keccak256(bytes(version));
836         bytes32 typeHash = keccak256(
837             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
838         );
839         _HASHED_NAME = hashedName;
840         _HASHED_VERSION = hashedVersion;
841         _CACHED_CHAIN_ID = block.chainid;
842         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
843         _TYPE_HASH = typeHash;
844     }
845 
846     /**
847      * @dev Returns the domain separator for the current chain.
848      */
849     function _domainSeparatorV4() internal view returns (bytes32) {
850         if (block.chainid == _CACHED_CHAIN_ID) {
851             return _CACHED_DOMAIN_SEPARATOR;
852         } else {
853             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
854         }
855     }
856 
857     function _buildDomainSeparator(
858         bytes32 typeHash,
859         bytes32 nameHash,
860         bytes32 versionHash
861     ) private view returns (bytes32) {
862         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
863     }
864 
865     /**
866      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
867      * function returns the hash of the fully encoded EIP712 message for this domain.
868      *
869      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
870      *
871      * ```solidity
872      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
873      *     keccak256("Mail(address to,string contents)"),
874      *     mailTo,
875      *     keccak256(bytes(mailContents))
876      * )));
877      * address signer = ECDSA.recover(digest, signature);
878      * ```
879      */
880     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
881         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
882     }
883 }
884 
885 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Metadata
886 
887 /**
888  * @dev Interface for the optional metadata functions from the ERC20 standard.
889  *
890  * _Available since v4.1._
891  */
892 interface IERC20Metadata is IERC20 {
893     /**
894      * @dev Returns the name of the token.
895      */
896     function name() external view returns (string memory);
897 
898     /**
899      * @dev Returns the symbol of the token.
900      */
901     function symbol() external view returns (string memory);
902 
903     /**
904      * @dev Returns the decimals places of the token.
905      */
906     function decimals() external view returns (uint8);
907 }
908 
909 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Pausable
910 
911 /**
912  * @dev Contract module which allows children to implement an emergency stop
913  * mechanism that can be triggered by an authorized account.
914  *
915  * This module is used through inheritance. It will make available the
916  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
917  * the functions of your contract. Note that they will not be pausable by
918  * simply including this module, only once the modifiers are put in place.
919  */
920 abstract contract Pausable is Context {
921     /**
922      * @dev Emitted when the pause is triggered by `account`.
923      */
924     event Paused(address account);
925 
926     /**
927      * @dev Emitted when the pause is lifted by `account`.
928      */
929     event Unpaused(address account);
930 
931     bool private _paused;
932 
933     /**
934      * @dev Initializes the contract in unpaused state.
935      */
936     constructor() {
937         _paused = false;
938     }
939 
940     /**
941      * @dev Returns true if the contract is paused, and false otherwise.
942      */
943     function paused() public view virtual returns (bool) {
944         return _paused;
945     }
946 
947     /**
948      * @dev Modifier to make a function callable only when the contract is not paused.
949      *
950      * Requirements:
951      *
952      * - The contract must not be paused.
953      */
954     modifier whenNotPaused() {
955         require(!paused(), "Pausable: paused");
956         _;
957     }
958 
959     /**
960      * @dev Modifier to make a function callable only when the contract is paused.
961      *
962      * Requirements:
963      *
964      * - The contract must be paused.
965      */
966     modifier whenPaused() {
967         require(paused(), "Pausable: not paused");
968         _;
969     }
970 
971     /**
972      * @dev Triggers stopped state.
973      *
974      * Requirements:
975      *
976      * - The contract must not be paused.
977      */
978     function _pause() internal virtual whenNotPaused {
979         _paused = true;
980         emit Paused(_msgSender());
981     }
982 
983     /**
984      * @dev Returns to normal state.
985      *
986      * Requirements:
987      *
988      * - The contract must be paused.
989      */
990     function _unpause() internal virtual whenPaused {
991         _paused = false;
992         emit Unpaused(_msgSender());
993     }
994 }
995 
996 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/SafeERC20
997 
998 /**
999  * @title SafeERC20
1000  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1001  * contract returns false). Tokens that return no value (and instead revert or
1002  * throw on failure) are also supported, non-reverting calls are assumed to be
1003  * successful.
1004  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1005  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1006  */
1007 library SafeERC20 {
1008     using Address for address;
1009 
1010     function safeTransfer(
1011         IERC20 token,
1012         address to,
1013         uint256 value
1014     ) internal {
1015         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1016     }
1017 
1018     function safeTransferFrom(
1019         IERC20 token,
1020         address from,
1021         address to,
1022         uint256 value
1023     ) internal {
1024         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1025     }
1026 
1027     /**
1028      * @dev Deprecated. This function has issues similar to the ones found in
1029      * {IERC20-approve}, and its usage is discouraged.
1030      *
1031      * Whenever possible, use {safeIncreaseAllowance} and
1032      * {safeDecreaseAllowance} instead.
1033      */
1034     function safeApprove(
1035         IERC20 token,
1036         address spender,
1037         uint256 value
1038     ) internal {
1039         // safeApprove should only be called when setting an initial allowance,
1040         // or when resetting it to zero. To increase and decrease it, use
1041         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1042         require(
1043             (value == 0) || (token.allowance(address(this), spender) == 0),
1044             "SafeERC20: approve from non-zero to non-zero allowance"
1045         );
1046         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1047     }
1048 
1049     function safeIncreaseAllowance(
1050         IERC20 token,
1051         address spender,
1052         uint256 value
1053     ) internal {
1054         uint256 newAllowance = token.allowance(address(this), spender) + value;
1055         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1056     }
1057 
1058     function safeDecreaseAllowance(
1059         IERC20 token,
1060         address spender,
1061         uint256 value
1062     ) internal {
1063         unchecked {
1064             uint256 oldAllowance = token.allowance(address(this), spender);
1065             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1066             uint256 newAllowance = oldAllowance - value;
1067             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1068         }
1069     }
1070 
1071     /**
1072      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1073      * on the return value: the return value is optional (but if data is returned, it must not be false).
1074      * @param token The token targeted by the call.
1075      * @param data The call data (encoded using abi.encode or one of its variants).
1076      */
1077     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1078         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1079         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1080         // the target address contains contract code and also asserts for success in the low-level call.
1081 
1082         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1083         if (returndata.length > 0) {
1084             // Return data is optional
1085             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1086         }
1087     }
1088 }
1089 
1090 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20
1091 
1092 /**
1093  * @dev Implementation of the {IERC20} interface.
1094  *
1095  * This implementation is agnostic to the way tokens are created. This means
1096  * that a supply mechanism has to be added in a derived contract using {_mint}.
1097  * For a generic mechanism see {ERC20PresetMinterPauser}.
1098  *
1099  * TIP: For a detailed writeup see our guide
1100  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1101  * to implement supply mechanisms].
1102  *
1103  * We have followed general OpenZeppelin guidelines: functions revert instead
1104  * of returning `false` on failure. This behavior is nonetheless conventional
1105  * and does not conflict with the expectations of ERC20 applications.
1106  *
1107  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1108  * This allows applications to reconstruct the allowance for all accounts just
1109  * by listening to said events. Other implementations of the EIP may not emit
1110  * these events, as it isn't required by the specification.
1111  *
1112  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1113  * functions have been added to mitigate the well-known issues around setting
1114  * allowances. See {IERC20-approve}.
1115  */
1116 contract ERC20 is Context, IERC20, IERC20Metadata {
1117     mapping(address => uint256) private _balances;
1118 
1119     mapping(address => mapping(address => uint256)) private _allowances;
1120 
1121     uint256 private _totalSupply;
1122 
1123     string private _name;
1124     string private _symbol;
1125 
1126     /**
1127      * @dev Sets the values for {name} and {symbol}.
1128      *
1129      * The default value of {decimals} is 18. To select a different value for
1130      * {decimals} you should overload it.
1131      *
1132      * All two of these values are immutable: they can only be set once during
1133      * construction.
1134      */
1135     constructor(string memory name_, string memory symbol_) {
1136         _name = name_;
1137         _symbol = symbol_;
1138     }
1139 
1140     /**
1141      * @dev Returns the name of the token.
1142      */
1143     function name() public view virtual override returns (string memory) {
1144         return _name;
1145     }
1146 
1147     /**
1148      * @dev Returns the symbol of the token, usually a shorter version of the
1149      * name.
1150      */
1151     function symbol() public view virtual override returns (string memory) {
1152         return _symbol;
1153     }
1154 
1155     /**
1156      * @dev Returns the number of decimals used to get its user representation.
1157      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1158      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1159      *
1160      * Tokens usually opt for a value of 18, imitating the relationship between
1161      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1162      * overridden;
1163      *
1164      * NOTE: This information is only used for _display_ purposes: it in
1165      * no way affects any of the arithmetic of the contract, including
1166      * {IERC20-balanceOf} and {IERC20-transfer}.
1167      */
1168     function decimals() public view virtual override returns (uint8) {
1169         return 18;
1170     }
1171 
1172     /**
1173      * @dev See {IERC20-totalSupply}.
1174      */
1175     function totalSupply() public view virtual override returns (uint256) {
1176         return _totalSupply;
1177     }
1178 
1179     /**
1180      * @dev See {IERC20-balanceOf}.
1181      */
1182     function balanceOf(address account) public view virtual override returns (uint256) {
1183         return _balances[account];
1184     }
1185 
1186     /**
1187      * @dev See {IERC20-transfer}.
1188      *
1189      * Requirements:
1190      *
1191      * - `recipient` cannot be the zero address.
1192      * - the caller must have a balance of at least `amount`.
1193      */
1194     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1195         _transfer(_msgSender(), recipient, amount);
1196         return true;
1197     }
1198 
1199     /**
1200      * @dev See {IERC20-allowance}.
1201      */
1202     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1203         return _allowances[owner][spender];
1204     }
1205 
1206     /**
1207      * @dev See {IERC20-approve}.
1208      *
1209      * Requirements:
1210      *
1211      * - `spender` cannot be the zero address.
1212      */
1213     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1214         _approve(_msgSender(), spender, amount);
1215         return true;
1216     }
1217 
1218     /**
1219      * @dev See {IERC20-transferFrom}.
1220      *
1221      * Emits an {Approval} event indicating the updated allowance. This is not
1222      * required by the EIP. See the note at the beginning of {ERC20}.
1223      *
1224      * Requirements:
1225      *
1226      * - `sender` and `recipient` cannot be the zero address.
1227      * - `sender` must have a balance of at least `amount`.
1228      * - the caller must have allowance for ``sender``'s tokens of at least
1229      * `amount`.
1230      */
1231     function transferFrom(
1232         address sender,
1233         address recipient,
1234         uint256 amount
1235     ) public virtual override returns (bool) {
1236         _transfer(sender, recipient, amount);
1237 
1238         uint256 currentAllowance = _allowances[sender][_msgSender()];
1239         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1240         unchecked {
1241             _approve(sender, _msgSender(), currentAllowance - amount);
1242         }
1243 
1244         return true;
1245     }
1246 
1247     /**
1248      * @dev Atomically increases the allowance granted to `spender` by the caller.
1249      *
1250      * This is an alternative to {approve} that can be used as a mitigation for
1251      * problems described in {IERC20-approve}.
1252      *
1253      * Emits an {Approval} event indicating the updated allowance.
1254      *
1255      * Requirements:
1256      *
1257      * - `spender` cannot be the zero address.
1258      */
1259     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1260         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1261         return true;
1262     }
1263 
1264     /**
1265      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1266      *
1267      * This is an alternative to {approve} that can be used as a mitigation for
1268      * problems described in {IERC20-approve}.
1269      *
1270      * Emits an {Approval} event indicating the updated allowance.
1271      *
1272      * Requirements:
1273      *
1274      * - `spender` cannot be the zero address.
1275      * - `spender` must have allowance for the caller of at least
1276      * `subtractedValue`.
1277      */
1278     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1279         uint256 currentAllowance = _allowances[_msgSender()][spender];
1280         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1281         unchecked {
1282             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1283         }
1284 
1285         return true;
1286     }
1287 
1288     /**
1289      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1290      *
1291      * This internal function is equivalent to {transfer}, and can be used to
1292      * e.g. implement automatic token fees, slashing mechanisms, etc.
1293      *
1294      * Emits a {Transfer} event.
1295      *
1296      * Requirements:
1297      *
1298      * - `sender` cannot be the zero address.
1299      * - `recipient` cannot be the zero address.
1300      * - `sender` must have a balance of at least `amount`.
1301      */
1302     function _transfer(
1303         address sender,
1304         address recipient,
1305         uint256 amount
1306     ) internal virtual {
1307         require(sender != address(0), "ERC20: transfer from the zero address");
1308         require(recipient != address(0), "ERC20: transfer to the zero address");
1309 
1310         _beforeTokenTransfer(sender, recipient, amount);
1311 
1312         uint256 senderBalance = _balances[sender];
1313         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1314         unchecked {
1315             _balances[sender] = senderBalance - amount;
1316         }
1317         _balances[recipient] += amount;
1318 
1319         emit Transfer(sender, recipient, amount);
1320 
1321         _afterTokenTransfer(sender, recipient, amount);
1322     }
1323 
1324     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1325      * the total supply.
1326      *
1327      * Emits a {Transfer} event with `from` set to the zero address.
1328      *
1329      * Requirements:
1330      *
1331      * - `account` cannot be the zero address.
1332      */
1333     function _mint(address account, uint256 amount) internal virtual {
1334         require(account != address(0), "ERC20: mint to the zero address");
1335 
1336         _beforeTokenTransfer(address(0), account, amount);
1337 
1338         _totalSupply += amount;
1339         _balances[account] += amount;
1340         emit Transfer(address(0), account, amount);
1341 
1342         _afterTokenTransfer(address(0), account, amount);
1343     }
1344 
1345     /**
1346      * @dev Destroys `amount` tokens from `account`, reducing the
1347      * total supply.
1348      *
1349      * Emits a {Transfer} event with `to` set to the zero address.
1350      *
1351      * Requirements:
1352      *
1353      * - `account` cannot be the zero address.
1354      * - `account` must have at least `amount` tokens.
1355      */
1356     function _burn(address account, uint256 amount) internal virtual {
1357         require(account != address(0), "ERC20: burn from the zero address");
1358 
1359         _beforeTokenTransfer(account, address(0), amount);
1360 
1361         uint256 accountBalance = _balances[account];
1362         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1363         unchecked {
1364             _balances[account] = accountBalance - amount;
1365         }
1366         _totalSupply -= amount;
1367 
1368         emit Transfer(account, address(0), amount);
1369 
1370         _afterTokenTransfer(account, address(0), amount);
1371     }
1372 
1373     /**
1374      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1375      *
1376      * This internal function is equivalent to `approve`, and can be used to
1377      * e.g. set automatic allowances for certain subsystems, etc.
1378      *
1379      * Emits an {Approval} event.
1380      *
1381      * Requirements:
1382      *
1383      * - `owner` cannot be the zero address.
1384      * - `spender` cannot be the zero address.
1385      */
1386     function _approve(
1387         address owner,
1388         address spender,
1389         uint256 amount
1390     ) internal virtual {
1391         require(owner != address(0), "ERC20: approve from the zero address");
1392         require(spender != address(0), "ERC20: approve to the zero address");
1393 
1394         _allowances[owner][spender] = amount;
1395         emit Approval(owner, spender, amount);
1396     }
1397 
1398     /**
1399      * @dev Hook that is called before any transfer of tokens. This includes
1400      * minting and burning.
1401      *
1402      * Calling conditions:
1403      *
1404      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1405      * will be transferred to `to`.
1406      * - when `from` is zero, `amount` tokens will be minted for `to`.
1407      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1408      * - `from` and `to` are never both zero.
1409      *
1410      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1411      */
1412     function _beforeTokenTransfer(
1413         address from,
1414         address to,
1415         uint256 amount
1416     ) internal virtual {}
1417 
1418     /**
1419      * @dev Hook that is called after any transfer of tokens. This includes
1420      * minting and burning.
1421      *
1422      * Calling conditions:
1423      *
1424      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1425      * has been transferred to `to`.
1426      * - when `from` is zero, `amount` tokens have been minted for `to`.
1427      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1428      * - `from` and `to` are never both zero.
1429      *
1430      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1431      */
1432     function _afterTokenTransfer(
1433         address from,
1434         address to,
1435         uint256 amount
1436     ) internal virtual {}
1437 }
1438 
1439 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20Permit
1440 
1441 /**
1442  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1443  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1444  *
1445  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1446  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1447  * need to send a transaction, and thus is not required to hold Ether at all.
1448  *
1449  * _Available since v3.4._
1450  */
1451 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1452     using Counters for Counters.Counter;
1453 
1454     mapping(address => Counters.Counter) private _nonces;
1455 
1456     // solhint-disable-next-line var-name-mixedcase
1457     bytes32 private immutable _PERMIT_TYPEHASH =
1458         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1459 
1460     /**
1461      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1462      *
1463      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1464      */
1465     constructor(string memory name) EIP712(name, "1") {}
1466 
1467     /**
1468      * @dev See {IERC20Permit-permit}.
1469      */
1470     function permit(
1471         address owner,
1472         address spender,
1473         uint256 value,
1474         uint256 deadline,
1475         uint8 v,
1476         bytes32 r,
1477         bytes32 s
1478     ) public virtual override {
1479         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1480 
1481         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1482 
1483         bytes32 hash = _hashTypedDataV4(structHash);
1484 
1485         address signer = ECDSA.recover(hash, v, r, s);
1486         require(signer == owner, "ERC20Permit: invalid signature");
1487 
1488         _approve(owner, spender, value);
1489     }
1490 
1491     /**
1492      * @dev See {IERC20Permit-nonces}.
1493      */
1494     function nonces(address owner) public view virtual override returns (uint256) {
1495         return _nonces[owner].current();
1496     }
1497 
1498     /**
1499      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1500      */
1501     // solhint-disable-next-line func-name-mixedcase
1502     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1503         return _domainSeparatorV4();
1504     }
1505 
1506     /**
1507      * @dev "Consume a nonce": return the current value and increment.
1508      *
1509      * _Available since v4.1._
1510      */
1511     function _useNonce(address owner) internal virtual returns (uint256 current) {
1512         Counters.Counter storage nonce = _nonces[owner];
1513         current = nonce.current();
1514         nonce.increment();
1515     }
1516 }
1517 
1518 // Part: BToken
1519 
1520 contract BToken is ERC20Permit, ReentrancyGuard {
1521   using SafeERC20 for IERC20;
1522 
1523   event Accrue(uint interest);
1524   event Mint(address indexed caller, address indexed to, uint amount, uint credit);
1525   event Burn(address indexed caller, address indexed to, uint amount, uint credit);
1526 
1527   uint public constant MINIMUM_LIQUIDITY = 10**6; // minimum liquidity to be locked in the pool when first mint occurs
1528 
1529   address public immutable betaBank; // BetaBank address
1530   address public immutable underlying; // the underlying token
1531 
1532   uint public interestRate; // current interest rate
1533   uint public lastAccrueTime; // last interest accrual timestamp
1534   uint public totalLoanable; // total asset amount available to be borrowed
1535   uint public totalLoan; // total amount of loan
1536   uint public totalDebtShare; // total amount of debt share
1537 
1538   /// @dev Initializes the BToken contract.
1539   /// @param _betaBank BetaBank address.
1540   /// @param _underlying The underlying token address for the bToken.
1541   constructor(address _betaBank, address _underlying)
1542     ERC20Permit('B Token')
1543     ERC20('B Token', 'bTOKEN')
1544   {
1545     require(_betaBank != address(0), 'constructor/betabank-zero-address');
1546     require(_underlying != address(0), 'constructor/underlying-zero-address');
1547     betaBank = _betaBank;
1548     underlying = _underlying;
1549     interestRate = IBetaInterestModel(IBetaBank(_betaBank).interestModel()).initialRate();
1550     lastAccrueTime = block.timestamp;
1551   }
1552 
1553   /// @dev Returns the name of the token.
1554   function name() public view override returns (string memory) {
1555     try IERC20Metadata(underlying).name() returns (string memory data) {
1556       return string(abi.encodePacked('B ', data));
1557     } catch (bytes memory) {
1558       return ERC20.name();
1559     }
1560   }
1561 
1562   /// @dev Returns the symbol of the token.
1563   function symbol() public view override returns (string memory) {
1564     try IERC20Metadata(underlying).symbol() returns (string memory data) {
1565       return string(abi.encodePacked('b', data));
1566     } catch (bytes memory) {
1567       return ERC20.symbol();
1568     }
1569   }
1570 
1571   /// @dev Returns the decimal places of the token.
1572   function decimals() public view override returns (uint8) {
1573     try IERC20Metadata(underlying).decimals() returns (uint8 data) {
1574       return data;
1575     } catch (bytes memory) {
1576       return ERC20.decimals();
1577     }
1578   }
1579 
1580   /// @dev Accrues interest rate and adjusts the rate. Can be called by anyone at any time.
1581   function accrue() public {
1582     // 1. Check time past condition
1583     uint timePassed = block.timestamp - lastAccrueTime;
1584     if (timePassed == 0) return;
1585     lastAccrueTime = block.timestamp;
1586     // 2. Check bank pause condition
1587     require(!Pausable(betaBank).paused(), 'BetaBank/paused');
1588     // 3. Compute the accrued interest value over the past time
1589     (uint totalLoan_, uint totalLoanable_, uint interestRate_) = (
1590       totalLoan,
1591       totalLoanable,
1592       interestRate
1593     ); // gas saving by avoiding multiple SLOADs
1594     IBetaConfig config = IBetaConfig(IBetaBank(betaBank).config());
1595     IBetaInterestModel model = IBetaInterestModel(IBetaBank(betaBank).interestModel());
1596     uint interest = (interestRate_ * totalLoan_ * timePassed) / (365 days) / 1e18;
1597     // 4. Update total loan and next interest rate
1598     totalLoan_ += interest;
1599     totalLoan = totalLoan_;
1600     interestRate = model.getNextInterestRate(interestRate_, totalLoanable_, totalLoan_, timePassed);
1601     // 5. Send a portion of collected interest to the beneficiary
1602     if (interest > 0) {
1603       uint reserveRate = config.reserveRate();
1604       if (reserveRate > 0) {
1605         uint toReserve = (interest * reserveRate) / 1e18;
1606         _mint(
1607           config.reserveBeneficiary(),
1608           (toReserve * totalSupply()) / (totalLoan_ + totalLoanable_ - toReserve)
1609         );
1610       }
1611       emit Accrue(interest);
1612     }
1613   }
1614 
1615   /// @dev Returns the debt value for the given debt share. Automatically calls accrue.
1616   function fetchDebtShareValue(uint _debtShare) external returns (uint) {
1617     accrue();
1618     if (_debtShare == 0) {
1619       return 0;
1620     }
1621     return Math.ceilDiv(_debtShare * totalLoan, totalDebtShare); // round up
1622   }
1623 
1624   /// @dev Mints new bToken to the given address.
1625   /// @param _to The address to mint new bToken for.
1626   /// @param _amount The amount of underlying tokens to deposit via `transferFrom`.
1627   /// @return credit The amount of bToken minted.
1628   function mint(address _to, uint _amount) external nonReentrant returns (uint credit) {
1629     accrue();
1630     uint amount;
1631     {
1632       uint balBefore = IERC20(underlying).balanceOf(address(this));
1633       IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
1634       uint balAfter = IERC20(underlying).balanceOf(address(this));
1635       amount = balAfter - balBefore;
1636     }
1637     uint supply = totalSupply();
1638     if (supply == 0) {
1639       credit = amount - MINIMUM_LIQUIDITY;
1640       // Permanently lock the first MINIMUM_LIQUIDITY tokens
1641       totalLoanable += credit;
1642       totalLoan += MINIMUM_LIQUIDITY;
1643       totalDebtShare += MINIMUM_LIQUIDITY;
1644       _mint(address(1), MINIMUM_LIQUIDITY); // OpenZeppelin ERC20 does not allow minting to 0
1645     } else {
1646       credit = (amount * supply) / (totalLoanable + totalLoan);
1647       totalLoanable += amount;
1648     }
1649     require(credit > 0, 'mint/no-credit-minted');
1650     _mint(_to, credit);
1651     emit Mint(msg.sender, _to, _amount, credit);
1652   }
1653 
1654   /// @dev Burns the given bToken for the proportional amount of underlying tokens.
1655   /// @param _to The address to send the underlying tokens to.
1656   /// @param _credit The amount of bToken to burn.
1657   /// @return amount The amount of underlying tokens getting transferred out.
1658   function burn(address _to, uint _credit) external nonReentrant returns (uint amount) {
1659     accrue();
1660     uint supply = totalSupply();
1661     amount = (_credit * (totalLoanable + totalLoan)) / supply;
1662     require(amount > 0, 'burn/no-amount-returned');
1663     totalLoanable -= amount;
1664     _burn(msg.sender, _credit);
1665     IERC20(underlying).safeTransfer(_to, amount);
1666     emit Burn(msg.sender, _to, amount, _credit);
1667   }
1668 
1669   /// @dev Borrows the funds for the given address. Must only be called by BetaBank.
1670   /// @param _to The address to borrow the funds for.
1671   /// @param _amount The amount to borrow.
1672   /// @return debtShare The amount of new debt share minted.
1673   function borrow(address _to, uint _amount) external nonReentrant returns (uint debtShare) {
1674     require(msg.sender == betaBank, 'borrow/not-BetaBank');
1675     accrue();
1676     IERC20(underlying).safeTransfer(_to, _amount);
1677     debtShare = Math.ceilDiv(_amount * totalDebtShare, totalLoan); // round up
1678     totalLoanable -= _amount;
1679     totalLoan += _amount;
1680     totalDebtShare += debtShare;
1681   }
1682 
1683   /// @dev Repays the debt using funds from the given address. Must only be called by BetaBank.
1684   /// @param _from The address to drain the funds to repay.
1685   /// @param _amount The amount of funds to call via `transferFrom`.
1686   /// @return debtShare The amount of debt share repaid.
1687   function repay(address _from, uint _amount) external nonReentrant returns (uint debtShare) {
1688     require(msg.sender == betaBank, 'repay/not-BetaBank');
1689     accrue();
1690     uint amount;
1691     {
1692       uint balBefore = IERC20(underlying).balanceOf(address(this));
1693       IERC20(underlying).safeTransferFrom(_from, address(this), _amount);
1694       uint balAfter = IERC20(underlying).balanceOf(address(this));
1695       amount = balAfter - balBefore;
1696     }
1697     require(amount <= totalLoan, 'repay/amount-too-high');
1698     debtShare = (amount * totalDebtShare) / totalLoan; // round down
1699     totalLoanable += amount;
1700     totalLoan -= amount;
1701     totalDebtShare -= debtShare;
1702     require(totalDebtShare >= MINIMUM_LIQUIDITY, 'repay/too-low-sum-debt-share');
1703   }
1704 
1705   /// @dev Recovers tokens in this contract. EMERGENCY ONLY. Full trust in BetaBank.
1706   /// @param _token The token to recover, can even be underlying so please be careful.
1707   /// @param _to The address to recover tokens to.
1708   /// @param _amount The amount of tokens to recover, or MAX_UINT256 if whole balance.
1709   function recover(
1710     address _token,
1711     address _to,
1712     uint _amount
1713   ) external nonReentrant {
1714     require(msg.sender == betaBank, 'recover/not-BetaBank');
1715     if (_amount == type(uint).max) {
1716       _amount = IERC20(_token).balanceOf(address(this));
1717     }
1718     IERC20(_token).safeTransfer(_to, _amount);
1719   }
1720 }
1721 
1722 // File: WETHGateway.sol
1723 
1724 contract WETHGateway {
1725   using SafeERC20 for IERC20;
1726 
1727   address public immutable bweth;
1728   address public immutable weth;
1729 
1730   /// @dev Initializes the BWETH contract
1731   /// @param _bweth BWETH token address
1732   constructor(address _bweth) {
1733     address _weth = BToken(_bweth).underlying();
1734     IERC20(_weth).safeApprove(_bweth, type(uint).max);
1735     bweth = _bweth;
1736     weth = _weth;
1737   }
1738 
1739   /// @dev Wraps the given ETH to WETH and calls mint action on BWETH for the caller.
1740   /// @param _to The address to receive BToken.
1741   /// @return credit The BWETH amount minted to the caller.
1742   function mint(address _to) external payable returns (uint credit) {
1743     IWETH(weth).deposit{value: msg.value}();
1744     credit = BToken(bweth).mint(_to, msg.value);
1745   }
1746 
1747   /// @dev Performs burn action on BWETH and unwraps WETH back to ETH for the caller.
1748   /// @param _to The address to send ETH to.
1749   /// @param _credit The amount of BToken to burn.
1750   /// @return amount The amount of ETH to be received.
1751   function burn(address _to, uint _credit) public returns (uint amount) {
1752     IERC20(bweth).safeTransferFrom(msg.sender, address(this), _credit);
1753     amount = BToken(bweth).burn(address(this), _credit);
1754     IWETH(weth).withdraw(amount);
1755     (bool success, ) = _to.call{value: amount}(new bytes(0));
1756     require(success, 'burn/eth-transfer-failed');
1757   }
1758 
1759   /// @dev Similar to burn function, but with an additional call to BToken's EIP712 permit.
1760   function burnWithPermit(
1761     address _to,
1762     uint _credit,
1763     uint _approve,
1764     uint _deadline,
1765     uint8 _v,
1766     bytes32 _r,
1767     bytes32 _s
1768   ) external returns (uint amount) {
1769     BToken(bweth).permit(msg.sender, address(this), _approve, _deadline, _v, _r, _s);
1770     amount = burn(_to, _credit);
1771   }
1772 
1773   receive() external payable {
1774     require(msg.sender == weth, '!weth');
1775   }
1776 }
