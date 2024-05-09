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
127 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Address
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize, which returns 0 for contracts in
152         // construction, since the code is only stored at the end of the
153         // constructor execution.
154 
155         uint256 size;
156         assembly {
157             size := extcodesize(account)
158         }
159         return size > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return _verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return _verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return _verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     function _verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) private pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context
337 
338 /*
339  * @dev Provides information about the current execution context, including the
340  * sender of the transaction and its data. While these are generally available
341  * via msg.sender and msg.data, they should not be accessed in such a direct
342  * manner, since when dealing with meta-transactions the account sending and
343  * paying for execution may not be the actual sender (as far as an application
344  * is concerned).
345  *
346  * This contract is only required for intermediate, library-like contracts.
347  */
348 abstract contract Context {
349     function _msgSender() internal view virtual returns (address) {
350         return msg.sender;
351     }
352 
353     function _msgData() internal view virtual returns (bytes calldata) {
354         return msg.data;
355     }
356 }
357 
358 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Counters
359 
360 /**
361  * @title Counters
362  * @author Matt Condon (@shrugs)
363  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
364  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
365  *
366  * Include with `using Counters for Counters.Counter;`
367  */
368 library Counters {
369     struct Counter {
370         // This variable should never be directly accessed by users of the library: interactions must be restricted to
371         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
372         // this feature: see https://github.com/ethereum/solidity/issues/4637
373         uint256 _value; // default: 0
374     }
375 
376     function current(Counter storage counter) internal view returns (uint256) {
377         return counter._value;
378     }
379 
380     function increment(Counter storage counter) internal {
381         unchecked {
382             counter._value += 1;
383         }
384     }
385 
386     function decrement(Counter storage counter) internal {
387         uint256 value = counter._value;
388         require(value > 0, "Counter: decrement overflow");
389         unchecked {
390             counter._value = value - 1;
391         }
392     }
393 
394     function reset(Counter storage counter) internal {
395         counter._value = 0;
396     }
397 }
398 
399 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ECDSA
400 
401 /**
402  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
403  *
404  * These functions can be used to verify that a message was signed by the holder
405  * of the private keys of a given address.
406  */
407 library ECDSA {
408     /**
409      * @dev Returns the address that signed a hashed message (`hash`) with
410      * `signature`. This address can then be used for verification purposes.
411      *
412      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
413      * this function rejects them by requiring the `s` value to be in the lower
414      * half order, and the `v` value to be either 27 or 28.
415      *
416      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
417      * verification to be secure: it is possible to craft signatures that
418      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
419      * this is by receiving a hash of the original message (which may otherwise
420      * be too long), and then calling {toEthSignedMessageHash} on it.
421      *
422      * Documentation for signature generation:
423      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
424      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
425      */
426     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
427         // Check the signature length
428         // - case 65: r,s,v signature (standard)
429         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
430         if (signature.length == 65) {
431             bytes32 r;
432             bytes32 s;
433             uint8 v;
434             // ecrecover takes the signature parameters, and the only way to get them
435             // currently is to use assembly.
436             assembly {
437                 r := mload(add(signature, 0x20))
438                 s := mload(add(signature, 0x40))
439                 v := byte(0, mload(add(signature, 0x60)))
440             }
441             return recover(hash, v, r, s);
442         } else if (signature.length == 64) {
443             bytes32 r;
444             bytes32 vs;
445             // ecrecover takes the signature parameters, and the only way to get them
446             // currently is to use assembly.
447             assembly {
448                 r := mload(add(signature, 0x20))
449                 vs := mload(add(signature, 0x40))
450             }
451             return recover(hash, r, vs);
452         } else {
453             revert("ECDSA: invalid signature length");
454         }
455     }
456 
457     /**
458      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
459      *
460      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
461      *
462      * _Available since v4.2._
463      */
464     function recover(
465         bytes32 hash,
466         bytes32 r,
467         bytes32 vs
468     ) internal pure returns (address) {
469         bytes32 s;
470         uint8 v;
471         assembly {
472             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
473             v := add(shr(255, vs), 27)
474         }
475         return recover(hash, v, r, s);
476     }
477 
478     /**
479      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
480      */
481     function recover(
482         bytes32 hash,
483         uint8 v,
484         bytes32 r,
485         bytes32 s
486     ) internal pure returns (address) {
487         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
488         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
489         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
490         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
491         //
492         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
493         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
494         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
495         // these malleable signatures as well.
496         require(
497             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
498             "ECDSA: invalid signature 's' value"
499         );
500         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
501 
502         // If the signature is valid (and not malleable), return the signer address
503         address signer = ecrecover(hash, v, r, s);
504         require(signer != address(0), "ECDSA: invalid signature");
505 
506         return signer;
507     }
508 
509     /**
510      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
511      * produces hash corresponding to the one signed with the
512      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
513      * JSON-RPC method as part of EIP-191.
514      *
515      * See {recover}.
516      */
517     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
518         // 32 is the length in bytes of hash,
519         // enforced by the type signature above
520         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
521     }
522 
523     /**
524      * @dev Returns an Ethereum Signed Typed Data, created from a
525      * `domainSeparator` and a `structHash`. This produces hash corresponding
526      * to the one signed with the
527      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
528      * JSON-RPC method as part of EIP-712.
529      *
530      * See {recover}.
531      */
532     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
533         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
534     }
535 }
536 
537 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20
538 
539 /**
540  * @dev Interface of the ERC20 standard as defined in the EIP.
541  */
542 interface IERC20 {
543     /**
544      * @dev Returns the amount of tokens in existence.
545      */
546     function totalSupply() external view returns (uint256);
547 
548     /**
549      * @dev Returns the amount of tokens owned by `account`.
550      */
551     function balanceOf(address account) external view returns (uint256);
552 
553     /**
554      * @dev Moves `amount` tokens from the caller's account to `recipient`.
555      *
556      * Returns a boolean value indicating whether the operation succeeded.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transfer(address recipient, uint256 amount) external returns (bool);
561 
562     /**
563      * @dev Returns the remaining number of tokens that `spender` will be
564      * allowed to spend on behalf of `owner` through {transferFrom}. This is
565      * zero by default.
566      *
567      * This value changes when {approve} or {transferFrom} are called.
568      */
569     function allowance(address owner, address spender) external view returns (uint256);
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
573      *
574      * Returns a boolean value indicating whether the operation succeeded.
575      *
576      * IMPORTANT: Beware that changing an allowance with this method brings the risk
577      * that someone may use both the old and the new allowance by unfortunate
578      * transaction ordering. One possible solution to mitigate this race
579      * condition is to first reduce the spender's allowance to 0 and set the
580      * desired value afterwards:
581      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address spender, uint256 amount) external returns (bool);
586 
587     /**
588      * @dev Moves `amount` tokens from `sender` to `recipient` using the
589      * allowance mechanism. `amount` is then deducted from the caller's
590      * allowance.
591      *
592      * Returns a boolean value indicating whether the operation succeeded.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transferFrom(
597         address sender,
598         address recipient,
599         uint256 amount
600     ) external returns (bool);
601 
602     /**
603      * @dev Emitted when `value` tokens are moved from one account (`from`) to
604      * another (`to`).
605      *
606      * Note that `value` may be zero.
607      */
608     event Transfer(address indexed from, address indexed to, uint256 value);
609 
610     /**
611      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
612      * a call to {approve}. `value` is the new allowance.
613      */
614     event Approval(address indexed owner, address indexed spender, uint256 value);
615 }
616 
617 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Permit
618 
619 /**
620  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
621  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
622  *
623  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
624  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
625  * need to send a transaction, and thus is not required to hold Ether at all.
626  */
627 interface IERC20Permit {
628     /**
629      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
630      * given ``owner``'s signed approval.
631      *
632      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
633      * ordering also apply here.
634      *
635      * Emits an {Approval} event.
636      *
637      * Requirements:
638      *
639      * - `spender` cannot be the zero address.
640      * - `deadline` must be a timestamp in the future.
641      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
642      * over the EIP712-formatted function arguments.
643      * - the signature must use ``owner``'s current nonce (see {nonces}).
644      *
645      * For more information on the signature format, see the
646      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
647      * section].
648      */
649     function permit(
650         address owner,
651         address spender,
652         uint256 value,
653         uint256 deadline,
654         uint8 v,
655         bytes32 r,
656         bytes32 s
657     ) external;
658 
659     /**
660      * @dev Returns the current nonce for `owner`. This value must be
661      * included whenever a signature is generated for {permit}.
662      *
663      * Every successful call to {permit} increases ``owner``'s nonce by one. This
664      * prevents a signature from being used multiple times.
665      */
666     function nonces(address owner) external view returns (uint256);
667 
668     /**
669      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
670      */
671     // solhint-disable-next-line func-name-mixedcase
672     function DOMAIN_SEPARATOR() external view returns (bytes32);
673 }
674 
675 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Math
676 
677 /**
678  * @dev Standard math utilities missing in the Solidity language.
679  */
680 library Math {
681     /**
682      * @dev Returns the largest of two numbers.
683      */
684     function max(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a >= b ? a : b;
686     }
687 
688     /**
689      * @dev Returns the smallest of two numbers.
690      */
691     function min(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a < b ? a : b;
693     }
694 
695     /**
696      * @dev Returns the average of two numbers. The result is rounded towards
697      * zero.
698      */
699     function average(uint256 a, uint256 b) internal pure returns (uint256) {
700         // (a + b) / 2 can overflow, so we distribute.
701         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
702     }
703 
704     /**
705      * @dev Returns the ceiling of the division of two numbers.
706      *
707      * This differs from standard division with `/` in that it rounds up instead
708      * of rounding down.
709      */
710     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
711         // (a + b - 1) / b can overflow on addition, so we distribute.
712         return a / b + (a % b == 0 ? 0 : 1);
713     }
714 }
715 
716 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ReentrancyGuard
717 
718 /**
719  * @dev Contract module that helps prevent reentrant calls to a function.
720  *
721  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
722  * available, which can be applied to functions to make sure there are no nested
723  * (reentrant) calls to them.
724  *
725  * Note that because there is a single `nonReentrant` guard, functions marked as
726  * `nonReentrant` may not call one another. This can be worked around by making
727  * those functions `private`, and then adding `external` `nonReentrant` entry
728  * points to them.
729  *
730  * TIP: If you would like to learn more about reentrancy and alternative ways
731  * to protect against it, check out our blog post
732  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
733  */
734 abstract contract ReentrancyGuard {
735     // Booleans are more expensive than uint256 or any type that takes up a full
736     // word because each write operation emits an extra SLOAD to first read the
737     // slot's contents, replace the bits taken up by the boolean, and then write
738     // back. This is the compiler's defense against contract upgrades and
739     // pointer aliasing, and it cannot be disabled.
740 
741     // The values being non-zero value makes deployment a bit more expensive,
742     // but in exchange the refund on every call to nonReentrant will be lower in
743     // amount. Since refunds are capped to a percentage of the total
744     // transaction's gas, it is best to keep them low in cases like this one, to
745     // increase the likelihood of the full refund coming into effect.
746     uint256 private constant _NOT_ENTERED = 1;
747     uint256 private constant _ENTERED = 2;
748 
749     uint256 private _status;
750 
751     constructor() {
752         _status = _NOT_ENTERED;
753     }
754 
755     /**
756      * @dev Prevents a contract from calling itself, directly or indirectly.
757      * Calling a `nonReentrant` function from another `nonReentrant`
758      * function is not supported. It is possible to prevent this from happening
759      * by making the `nonReentrant` function external, and make it call a
760      * `private` function that does the actual work.
761      */
762     modifier nonReentrant() {
763         // On the first call to nonReentrant, _notEntered will be true
764         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
765 
766         // Any calls to nonReentrant after this point will fail
767         _status = _ENTERED;
768 
769         _;
770 
771         // By storing the original value once again, a refund is triggered (see
772         // https://eips.ethereum.org/EIPS/eip-2200)
773         _status = _NOT_ENTERED;
774     }
775 }
776 
777 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/EIP712
778 
779 /**
780  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
781  *
782  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
783  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
784  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
785  *
786  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
787  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
788  * ({_hashTypedDataV4}).
789  *
790  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
791  * the chain id to protect against replay attacks on an eventual fork of the chain.
792  *
793  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
794  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
795  *
796  * _Available since v3.4._
797  */
798 abstract contract EIP712 {
799     /* solhint-disable var-name-mixedcase */
800     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
801     // invalidate the cached domain separator if the chain id changes.
802     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
803     uint256 private immutable _CACHED_CHAIN_ID;
804 
805     bytes32 private immutable _HASHED_NAME;
806     bytes32 private immutable _HASHED_VERSION;
807     bytes32 private immutable _TYPE_HASH;
808 
809     /* solhint-enable var-name-mixedcase */
810 
811     /**
812      * @dev Initializes the domain separator and parameter caches.
813      *
814      * The meaning of `name` and `version` is specified in
815      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
816      *
817      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
818      * - `version`: the current major version of the signing domain.
819      *
820      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
821      * contract upgrade].
822      */
823     constructor(string memory name, string memory version) {
824         bytes32 hashedName = keccak256(bytes(name));
825         bytes32 hashedVersion = keccak256(bytes(version));
826         bytes32 typeHash = keccak256(
827             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
828         );
829         _HASHED_NAME = hashedName;
830         _HASHED_VERSION = hashedVersion;
831         _CACHED_CHAIN_ID = block.chainid;
832         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
833         _TYPE_HASH = typeHash;
834     }
835 
836     /**
837      * @dev Returns the domain separator for the current chain.
838      */
839     function _domainSeparatorV4() internal view returns (bytes32) {
840         if (block.chainid == _CACHED_CHAIN_ID) {
841             return _CACHED_DOMAIN_SEPARATOR;
842         } else {
843             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
844         }
845     }
846 
847     function _buildDomainSeparator(
848         bytes32 typeHash,
849         bytes32 nameHash,
850         bytes32 versionHash
851     ) private view returns (bytes32) {
852         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
853     }
854 
855     /**
856      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
857      * function returns the hash of the fully encoded EIP712 message for this domain.
858      *
859      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
860      *
861      * ```solidity
862      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
863      *     keccak256("Mail(address to,string contents)"),
864      *     mailTo,
865      *     keccak256(bytes(mailContents))
866      * )));
867      * address signer = ECDSA.recover(digest, signature);
868      * ```
869      */
870     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
871         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
872     }
873 }
874 
875 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Metadata
876 
877 /**
878  * @dev Interface for the optional metadata functions from the ERC20 standard.
879  *
880  * _Available since v4.1._
881  */
882 interface IERC20Metadata is IERC20 {
883     /**
884      * @dev Returns the name of the token.
885      */
886     function name() external view returns (string memory);
887 
888     /**
889      * @dev Returns the symbol of the token.
890      */
891     function symbol() external view returns (string memory);
892 
893     /**
894      * @dev Returns the decimals places of the token.
895      */
896     function decimals() external view returns (uint8);
897 }
898 
899 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Pausable
900 
901 /**
902  * @dev Contract module which allows children to implement an emergency stop
903  * mechanism that can be triggered by an authorized account.
904  *
905  * This module is used through inheritance. It will make available the
906  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
907  * the functions of your contract. Note that they will not be pausable by
908  * simply including this module, only once the modifiers are put in place.
909  */
910 abstract contract Pausable is Context {
911     /**
912      * @dev Emitted when the pause is triggered by `account`.
913      */
914     event Paused(address account);
915 
916     /**
917      * @dev Emitted when the pause is lifted by `account`.
918      */
919     event Unpaused(address account);
920 
921     bool private _paused;
922 
923     /**
924      * @dev Initializes the contract in unpaused state.
925      */
926     constructor() {
927         _paused = false;
928     }
929 
930     /**
931      * @dev Returns true if the contract is paused, and false otherwise.
932      */
933     function paused() public view virtual returns (bool) {
934         return _paused;
935     }
936 
937     /**
938      * @dev Modifier to make a function callable only when the contract is not paused.
939      *
940      * Requirements:
941      *
942      * - The contract must not be paused.
943      */
944     modifier whenNotPaused() {
945         require(!paused(), "Pausable: paused");
946         _;
947     }
948 
949     /**
950      * @dev Modifier to make a function callable only when the contract is paused.
951      *
952      * Requirements:
953      *
954      * - The contract must be paused.
955      */
956     modifier whenPaused() {
957         require(paused(), "Pausable: not paused");
958         _;
959     }
960 
961     /**
962      * @dev Triggers stopped state.
963      *
964      * Requirements:
965      *
966      * - The contract must not be paused.
967      */
968     function _pause() internal virtual whenNotPaused {
969         _paused = true;
970         emit Paused(_msgSender());
971     }
972 
973     /**
974      * @dev Returns to normal state.
975      *
976      * Requirements:
977      *
978      * - The contract must be paused.
979      */
980     function _unpause() internal virtual whenPaused {
981         _paused = false;
982         emit Unpaused(_msgSender());
983     }
984 }
985 
986 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/SafeERC20
987 
988 /**
989  * @title SafeERC20
990  * @dev Wrappers around ERC20 operations that throw on failure (when the token
991  * contract returns false). Tokens that return no value (and instead revert or
992  * throw on failure) are also supported, non-reverting calls are assumed to be
993  * successful.
994  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
995  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
996  */
997 library SafeERC20 {
998     using Address for address;
999 
1000     function safeTransfer(
1001         IERC20 token,
1002         address to,
1003         uint256 value
1004     ) internal {
1005         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1006     }
1007 
1008     function safeTransferFrom(
1009         IERC20 token,
1010         address from,
1011         address to,
1012         uint256 value
1013     ) internal {
1014         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1015     }
1016 
1017     /**
1018      * @dev Deprecated. This function has issues similar to the ones found in
1019      * {IERC20-approve}, and its usage is discouraged.
1020      *
1021      * Whenever possible, use {safeIncreaseAllowance} and
1022      * {safeDecreaseAllowance} instead.
1023      */
1024     function safeApprove(
1025         IERC20 token,
1026         address spender,
1027         uint256 value
1028     ) internal {
1029         // safeApprove should only be called when setting an initial allowance,
1030         // or when resetting it to zero. To increase and decrease it, use
1031         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1032         require(
1033             (value == 0) || (token.allowance(address(this), spender) == 0),
1034             "SafeERC20: approve from non-zero to non-zero allowance"
1035         );
1036         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1037     }
1038 
1039     function safeIncreaseAllowance(
1040         IERC20 token,
1041         address spender,
1042         uint256 value
1043     ) internal {
1044         uint256 newAllowance = token.allowance(address(this), spender) + value;
1045         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1046     }
1047 
1048     function safeDecreaseAllowance(
1049         IERC20 token,
1050         address spender,
1051         uint256 value
1052     ) internal {
1053         unchecked {
1054             uint256 oldAllowance = token.allowance(address(this), spender);
1055             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1056             uint256 newAllowance = oldAllowance - value;
1057             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1058         }
1059     }
1060 
1061     /**
1062      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1063      * on the return value: the return value is optional (but if data is returned, it must not be false).
1064      * @param token The token targeted by the call.
1065      * @param data The call data (encoded using abi.encode or one of its variants).
1066      */
1067     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1068         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1069         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1070         // the target address contains contract code and also asserts for success in the low-level call.
1071 
1072         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1073         if (returndata.length > 0) {
1074             // Return data is optional
1075             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1076         }
1077     }
1078 }
1079 
1080 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20
1081 
1082 /**
1083  * @dev Implementation of the {IERC20} interface.
1084  *
1085  * This implementation is agnostic to the way tokens are created. This means
1086  * that a supply mechanism has to be added in a derived contract using {_mint}.
1087  * For a generic mechanism see {ERC20PresetMinterPauser}.
1088  *
1089  * TIP: For a detailed writeup see our guide
1090  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1091  * to implement supply mechanisms].
1092  *
1093  * We have followed general OpenZeppelin guidelines: functions revert instead
1094  * of returning `false` on failure. This behavior is nonetheless conventional
1095  * and does not conflict with the expectations of ERC20 applications.
1096  *
1097  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1098  * This allows applications to reconstruct the allowance for all accounts just
1099  * by listening to said events. Other implementations of the EIP may not emit
1100  * these events, as it isn't required by the specification.
1101  *
1102  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1103  * functions have been added to mitigate the well-known issues around setting
1104  * allowances. See {IERC20-approve}.
1105  */
1106 contract ERC20 is Context, IERC20, IERC20Metadata {
1107     mapping(address => uint256) private _balances;
1108 
1109     mapping(address => mapping(address => uint256)) private _allowances;
1110 
1111     uint256 private _totalSupply;
1112 
1113     string private _name;
1114     string private _symbol;
1115 
1116     /**
1117      * @dev Sets the values for {name} and {symbol}.
1118      *
1119      * The default value of {decimals} is 18. To select a different value for
1120      * {decimals} you should overload it.
1121      *
1122      * All two of these values are immutable: they can only be set once during
1123      * construction.
1124      */
1125     constructor(string memory name_, string memory symbol_) {
1126         _name = name_;
1127         _symbol = symbol_;
1128     }
1129 
1130     /**
1131      * @dev Returns the name of the token.
1132      */
1133     function name() public view virtual override returns (string memory) {
1134         return _name;
1135     }
1136 
1137     /**
1138      * @dev Returns the symbol of the token, usually a shorter version of the
1139      * name.
1140      */
1141     function symbol() public view virtual override returns (string memory) {
1142         return _symbol;
1143     }
1144 
1145     /**
1146      * @dev Returns the number of decimals used to get its user representation.
1147      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1148      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1149      *
1150      * Tokens usually opt for a value of 18, imitating the relationship between
1151      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1152      * overridden;
1153      *
1154      * NOTE: This information is only used for _display_ purposes: it in
1155      * no way affects any of the arithmetic of the contract, including
1156      * {IERC20-balanceOf} and {IERC20-transfer}.
1157      */
1158     function decimals() public view virtual override returns (uint8) {
1159         return 18;
1160     }
1161 
1162     /**
1163      * @dev See {IERC20-totalSupply}.
1164      */
1165     function totalSupply() public view virtual override returns (uint256) {
1166         return _totalSupply;
1167     }
1168 
1169     /**
1170      * @dev See {IERC20-balanceOf}.
1171      */
1172     function balanceOf(address account) public view virtual override returns (uint256) {
1173         return _balances[account];
1174     }
1175 
1176     /**
1177      * @dev See {IERC20-transfer}.
1178      *
1179      * Requirements:
1180      *
1181      * - `recipient` cannot be the zero address.
1182      * - the caller must have a balance of at least `amount`.
1183      */
1184     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1185         _transfer(_msgSender(), recipient, amount);
1186         return true;
1187     }
1188 
1189     /**
1190      * @dev See {IERC20-allowance}.
1191      */
1192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1193         return _allowances[owner][spender];
1194     }
1195 
1196     /**
1197      * @dev See {IERC20-approve}.
1198      *
1199      * Requirements:
1200      *
1201      * - `spender` cannot be the zero address.
1202      */
1203     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1204         _approve(_msgSender(), spender, amount);
1205         return true;
1206     }
1207 
1208     /**
1209      * @dev See {IERC20-transferFrom}.
1210      *
1211      * Emits an {Approval} event indicating the updated allowance. This is not
1212      * required by the EIP. See the note at the beginning of {ERC20}.
1213      *
1214      * Requirements:
1215      *
1216      * - `sender` and `recipient` cannot be the zero address.
1217      * - `sender` must have a balance of at least `amount`.
1218      * - the caller must have allowance for ``sender``'s tokens of at least
1219      * `amount`.
1220      */
1221     function transferFrom(
1222         address sender,
1223         address recipient,
1224         uint256 amount
1225     ) public virtual override returns (bool) {
1226         _transfer(sender, recipient, amount);
1227 
1228         uint256 currentAllowance = _allowances[sender][_msgSender()];
1229         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1230         unchecked {
1231             _approve(sender, _msgSender(), currentAllowance - amount);
1232         }
1233 
1234         return true;
1235     }
1236 
1237     /**
1238      * @dev Atomically increases the allowance granted to `spender` by the caller.
1239      *
1240      * This is an alternative to {approve} that can be used as a mitigation for
1241      * problems described in {IERC20-approve}.
1242      *
1243      * Emits an {Approval} event indicating the updated allowance.
1244      *
1245      * Requirements:
1246      *
1247      * - `spender` cannot be the zero address.
1248      */
1249     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1250         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1251         return true;
1252     }
1253 
1254     /**
1255      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1256      *
1257      * This is an alternative to {approve} that can be used as a mitigation for
1258      * problems described in {IERC20-approve}.
1259      *
1260      * Emits an {Approval} event indicating the updated allowance.
1261      *
1262      * Requirements:
1263      *
1264      * - `spender` cannot be the zero address.
1265      * - `spender` must have allowance for the caller of at least
1266      * `subtractedValue`.
1267      */
1268     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1269         uint256 currentAllowance = _allowances[_msgSender()][spender];
1270         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1271         unchecked {
1272             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1273         }
1274 
1275         return true;
1276     }
1277 
1278     /**
1279      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1280      *
1281      * This internal function is equivalent to {transfer}, and can be used to
1282      * e.g. implement automatic token fees, slashing mechanisms, etc.
1283      *
1284      * Emits a {Transfer} event.
1285      *
1286      * Requirements:
1287      *
1288      * - `sender` cannot be the zero address.
1289      * - `recipient` cannot be the zero address.
1290      * - `sender` must have a balance of at least `amount`.
1291      */
1292     function _transfer(
1293         address sender,
1294         address recipient,
1295         uint256 amount
1296     ) internal virtual {
1297         require(sender != address(0), "ERC20: transfer from the zero address");
1298         require(recipient != address(0), "ERC20: transfer to the zero address");
1299 
1300         _beforeTokenTransfer(sender, recipient, amount);
1301 
1302         uint256 senderBalance = _balances[sender];
1303         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1304         unchecked {
1305             _balances[sender] = senderBalance - amount;
1306         }
1307         _balances[recipient] += amount;
1308 
1309         emit Transfer(sender, recipient, amount);
1310 
1311         _afterTokenTransfer(sender, recipient, amount);
1312     }
1313 
1314     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1315      * the total supply.
1316      *
1317      * Emits a {Transfer} event with `from` set to the zero address.
1318      *
1319      * Requirements:
1320      *
1321      * - `account` cannot be the zero address.
1322      */
1323     function _mint(address account, uint256 amount) internal virtual {
1324         require(account != address(0), "ERC20: mint to the zero address");
1325 
1326         _beforeTokenTransfer(address(0), account, amount);
1327 
1328         _totalSupply += amount;
1329         _balances[account] += amount;
1330         emit Transfer(address(0), account, amount);
1331 
1332         _afterTokenTransfer(address(0), account, amount);
1333     }
1334 
1335     /**
1336      * @dev Destroys `amount` tokens from `account`, reducing the
1337      * total supply.
1338      *
1339      * Emits a {Transfer} event with `to` set to the zero address.
1340      *
1341      * Requirements:
1342      *
1343      * - `account` cannot be the zero address.
1344      * - `account` must have at least `amount` tokens.
1345      */
1346     function _burn(address account, uint256 amount) internal virtual {
1347         require(account != address(0), "ERC20: burn from the zero address");
1348 
1349         _beforeTokenTransfer(account, address(0), amount);
1350 
1351         uint256 accountBalance = _balances[account];
1352         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1353         unchecked {
1354             _balances[account] = accountBalance - amount;
1355         }
1356         _totalSupply -= amount;
1357 
1358         emit Transfer(account, address(0), amount);
1359 
1360         _afterTokenTransfer(account, address(0), amount);
1361     }
1362 
1363     /**
1364      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1365      *
1366      * This internal function is equivalent to `approve`, and can be used to
1367      * e.g. set automatic allowances for certain subsystems, etc.
1368      *
1369      * Emits an {Approval} event.
1370      *
1371      * Requirements:
1372      *
1373      * - `owner` cannot be the zero address.
1374      * - `spender` cannot be the zero address.
1375      */
1376     function _approve(
1377         address owner,
1378         address spender,
1379         uint256 amount
1380     ) internal virtual {
1381         require(owner != address(0), "ERC20: approve from the zero address");
1382         require(spender != address(0), "ERC20: approve to the zero address");
1383 
1384         _allowances[owner][spender] = amount;
1385         emit Approval(owner, spender, amount);
1386     }
1387 
1388     /**
1389      * @dev Hook that is called before any transfer of tokens. This includes
1390      * minting and burning.
1391      *
1392      * Calling conditions:
1393      *
1394      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1395      * will be transferred to `to`.
1396      * - when `from` is zero, `amount` tokens will be minted for `to`.
1397      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1398      * - `from` and `to` are never both zero.
1399      *
1400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1401      */
1402     function _beforeTokenTransfer(
1403         address from,
1404         address to,
1405         uint256 amount
1406     ) internal virtual {}
1407 
1408     /**
1409      * @dev Hook that is called after any transfer of tokens. This includes
1410      * minting and burning.
1411      *
1412      * Calling conditions:
1413      *
1414      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1415      * has been transferred to `to`.
1416      * - when `from` is zero, `amount` tokens have been minted for `to`.
1417      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1418      * - `from` and `to` are never both zero.
1419      *
1420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1421      */
1422     function _afterTokenTransfer(
1423         address from,
1424         address to,
1425         uint256 amount
1426     ) internal virtual {}
1427 }
1428 
1429 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20Permit
1430 
1431 /**
1432  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1433  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1434  *
1435  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1436  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1437  * need to send a transaction, and thus is not required to hold Ether at all.
1438  *
1439  * _Available since v3.4._
1440  */
1441 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1442     using Counters for Counters.Counter;
1443 
1444     mapping(address => Counters.Counter) private _nonces;
1445 
1446     // solhint-disable-next-line var-name-mixedcase
1447     bytes32 private immutable _PERMIT_TYPEHASH =
1448         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1449 
1450     /**
1451      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1452      *
1453      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1454      */
1455     constructor(string memory name) EIP712(name, "1") {}
1456 
1457     /**
1458      * @dev See {IERC20Permit-permit}.
1459      */
1460     function permit(
1461         address owner,
1462         address spender,
1463         uint256 value,
1464         uint256 deadline,
1465         uint8 v,
1466         bytes32 r,
1467         bytes32 s
1468     ) public virtual override {
1469         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1470 
1471         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1472 
1473         bytes32 hash = _hashTypedDataV4(structHash);
1474 
1475         address signer = ECDSA.recover(hash, v, r, s);
1476         require(signer == owner, "ERC20Permit: invalid signature");
1477 
1478         _approve(owner, spender, value);
1479     }
1480 
1481     /**
1482      * @dev See {IERC20Permit-nonces}.
1483      */
1484     function nonces(address owner) public view virtual override returns (uint256) {
1485         return _nonces[owner].current();
1486     }
1487 
1488     /**
1489      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1490      */
1491     // solhint-disable-next-line func-name-mixedcase
1492     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1493         return _domainSeparatorV4();
1494     }
1495 
1496     /**
1497      * @dev "Consume a nonce": return the current value and increment.
1498      *
1499      * _Available since v4.1._
1500      */
1501     function _useNonce(address owner) internal virtual returns (uint256 current) {
1502         Counters.Counter storage nonce = _nonces[owner];
1503         current = nonce.current();
1504         nonce.increment();
1505     }
1506 }
1507 
1508 // File: BToken.sol
1509 
1510 contract BToken is ERC20Permit, ReentrancyGuard {
1511   using SafeERC20 for IERC20;
1512 
1513   event Accrue(uint interest);
1514   event Mint(address indexed caller, address indexed to, uint amount, uint credit);
1515   event Burn(address indexed caller, address indexed to, uint amount, uint credit);
1516 
1517   uint public constant MINIMUM_LIQUIDITY = 10**6; // minimum liquidity to be locked in the pool when first mint occurs
1518 
1519   address public immutable betaBank; // BetaBank address
1520   address public immutable underlying; // the underlying token
1521 
1522   uint public interestRate; // current interest rate
1523   uint public lastAccrueTime; // last interest accrual timestamp
1524   uint public totalLoanable; // total asset amount available to be borrowed
1525   uint public totalLoan; // total amount of loan
1526   uint public totalDebtShare; // total amount of debt share
1527 
1528   /// @dev Initializes the BToken contract.
1529   /// @param _betaBank BetaBank address.
1530   /// @param _underlying The underlying token address for the bToken.
1531   constructor(address _betaBank, address _underlying)
1532     ERC20Permit('B Token')
1533     ERC20('B Token', 'bTOKEN')
1534   {
1535     require(_betaBank != address(0), 'constructor/betabank-zero-address');
1536     require(_underlying != address(0), 'constructor/underlying-zero-address');
1537     betaBank = _betaBank;
1538     underlying = _underlying;
1539     interestRate = IBetaInterestModel(IBetaBank(_betaBank).interestModel()).initialRate();
1540     lastAccrueTime = block.timestamp;
1541   }
1542 
1543   /// @dev Returns the name of the token.
1544   function name() public view override returns (string memory) {
1545     try IERC20Metadata(underlying).name() returns (string memory data) {
1546       return string(abi.encodePacked('B ', data));
1547     } catch (bytes memory) {
1548       return ERC20.name();
1549     }
1550   }
1551 
1552   /// @dev Returns the symbol of the token.
1553   function symbol() public view override returns (string memory) {
1554     try IERC20Metadata(underlying).symbol() returns (string memory data) {
1555       return string(abi.encodePacked('b', data));
1556     } catch (bytes memory) {
1557       return ERC20.symbol();
1558     }
1559   }
1560 
1561   /// @dev Returns the decimal places of the token.
1562   function decimals() public view override returns (uint8) {
1563     try IERC20Metadata(underlying).decimals() returns (uint8 data) {
1564       return data;
1565     } catch (bytes memory) {
1566       return ERC20.decimals();
1567     }
1568   }
1569 
1570   /// @dev Accrues interest rate and adjusts the rate. Can be called by anyone at any time.
1571   function accrue() public {
1572     // 1. Check time past condition
1573     uint timePassed = block.timestamp - lastAccrueTime;
1574     if (timePassed == 0) return;
1575     lastAccrueTime = block.timestamp;
1576     // 2. Check bank pause condition
1577     require(!Pausable(betaBank).paused(), 'BetaBank/paused');
1578     // 3. Compute the accrued interest value over the past time
1579     (uint totalLoan_, uint totalLoanable_, uint interestRate_) = (
1580       totalLoan,
1581       totalLoanable,
1582       interestRate
1583     ); // gas saving by avoiding multiple SLOADs
1584     IBetaConfig config = IBetaConfig(IBetaBank(betaBank).config());
1585     IBetaInterestModel model = IBetaInterestModel(IBetaBank(betaBank).interestModel());
1586     uint interest = (interestRate_ * totalLoan_ * timePassed) / (365 days) / 1e18;
1587     // 4. Update total loan and next interest rate
1588     totalLoan_ += interest;
1589     totalLoan = totalLoan_;
1590     interestRate = model.getNextInterestRate(interestRate_, totalLoanable_, totalLoan_, timePassed);
1591     // 5. Send a portion of collected interest to the beneficiary
1592     if (interest > 0) {
1593       uint reserveRate = config.reserveRate();
1594       if (reserveRate > 0) {
1595         uint toReserve = (interest * reserveRate) / 1e18;
1596         _mint(
1597           config.reserveBeneficiary(),
1598           (toReserve * totalSupply()) / (totalLoan_ + totalLoanable_ - toReserve)
1599         );
1600       }
1601       emit Accrue(interest);
1602     }
1603   }
1604 
1605   /// @dev Returns the debt value for the given debt share. Automatically calls accrue.
1606   function fetchDebtShareValue(uint _debtShare) external returns (uint) {
1607     accrue();
1608     if (_debtShare == 0) {
1609       return 0;
1610     }
1611     return Math.ceilDiv(_debtShare * totalLoan, totalDebtShare); // round up
1612   }
1613 
1614   /// @dev Mints new bToken to the given address.
1615   /// @param _to The address to mint new bToken for.
1616   /// @param _amount The amount of underlying tokens to deposit via `transferFrom`.
1617   /// @return credit The amount of bToken minted.
1618   function mint(address _to, uint _amount) external nonReentrant returns (uint credit) {
1619     accrue();
1620     uint amount;
1621     {
1622       uint balBefore = IERC20(underlying).balanceOf(address(this));
1623       IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
1624       uint balAfter = IERC20(underlying).balanceOf(address(this));
1625       amount = balAfter - balBefore;
1626     }
1627     uint supply = totalSupply();
1628     if (supply == 0) {
1629       credit = amount - MINIMUM_LIQUIDITY;
1630       // Permanently lock the first MINIMUM_LIQUIDITY tokens
1631       totalLoanable += credit;
1632       totalLoan += MINIMUM_LIQUIDITY;
1633       totalDebtShare += MINIMUM_LIQUIDITY;
1634       _mint(address(1), MINIMUM_LIQUIDITY); // OpenZeppelin ERC20 does not allow minting to 0
1635     } else {
1636       credit = (amount * supply) / (totalLoanable + totalLoan);
1637       totalLoanable += amount;
1638     }
1639     require(credit > 0, 'mint/no-credit-minted');
1640     _mint(_to, credit);
1641     emit Mint(msg.sender, _to, _amount, credit);
1642   }
1643 
1644   /// @dev Burns the given bToken for the proportional amount of underlying tokens.
1645   /// @param _to The address to send the underlying tokens to.
1646   /// @param _credit The amount of bToken to burn.
1647   /// @return amount The amount of underlying tokens getting transferred out.
1648   function burn(address _to, uint _credit) external nonReentrant returns (uint amount) {
1649     accrue();
1650     uint supply = totalSupply();
1651     amount = (_credit * (totalLoanable + totalLoan)) / supply;
1652     require(amount > 0, 'burn/no-amount-returned');
1653     totalLoanable -= amount;
1654     _burn(msg.sender, _credit);
1655     IERC20(underlying).safeTransfer(_to, amount);
1656     emit Burn(msg.sender, _to, amount, _credit);
1657   }
1658 
1659   /// @dev Borrows the funds for the given address. Must only be called by BetaBank.
1660   /// @param _to The address to borrow the funds for.
1661   /// @param _amount The amount to borrow.
1662   /// @return debtShare The amount of new debt share minted.
1663   function borrow(address _to, uint _amount) external nonReentrant returns (uint debtShare) {
1664     require(msg.sender == betaBank, 'borrow/not-BetaBank');
1665     accrue();
1666     IERC20(underlying).safeTransfer(_to, _amount);
1667     debtShare = Math.ceilDiv(_amount * totalDebtShare, totalLoan); // round up
1668     totalLoanable -= _amount;
1669     totalLoan += _amount;
1670     totalDebtShare += debtShare;
1671   }
1672 
1673   /// @dev Repays the debt using funds from the given address. Must only be called by BetaBank.
1674   /// @param _from The address to drain the funds to repay.
1675   /// @param _amount The amount of funds to call via `transferFrom`.
1676   /// @return debtShare The amount of debt share repaid.
1677   function repay(address _from, uint _amount) external nonReentrant returns (uint debtShare) {
1678     require(msg.sender == betaBank, 'repay/not-BetaBank');
1679     accrue();
1680     uint amount;
1681     {
1682       uint balBefore = IERC20(underlying).balanceOf(address(this));
1683       IERC20(underlying).safeTransferFrom(_from, address(this), _amount);
1684       uint balAfter = IERC20(underlying).balanceOf(address(this));
1685       amount = balAfter - balBefore;
1686     }
1687     require(amount <= totalLoan, 'repay/amount-too-high');
1688     debtShare = (amount * totalDebtShare) / totalLoan; // round down
1689     totalLoanable += amount;
1690     totalLoan -= amount;
1691     totalDebtShare -= debtShare;
1692     require(totalDebtShare >= MINIMUM_LIQUIDITY, 'repay/too-low-sum-debt-share');
1693   }
1694 
1695   /// @dev Recovers tokens in this contract. EMERGENCY ONLY. Full trust in BetaBank.
1696   /// @param _token The token to recover, can even be underlying so please be careful.
1697   /// @param _to The address to recover tokens to.
1698   /// @param _amount The amount of tokens to recover, or MAX_UINT256 if whole balance.
1699   function recover(
1700     address _token,
1701     address _to,
1702     uint _amount
1703   ) external nonReentrant {
1704     require(msg.sender == betaBank, 'recover/not-BetaBank');
1705     if (_amount == type(uint).max) {
1706       _amount = IERC20(_token).balanceOf(address(this));
1707     }
1708     IERC20(_token).safeTransfer(_to, _amount);
1709   }
1710 }
