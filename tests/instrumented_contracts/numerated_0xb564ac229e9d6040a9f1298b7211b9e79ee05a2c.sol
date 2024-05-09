1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
88 
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 
306 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.1
307 
308 
309 pragma solidity ^0.8.0;
310 
311 
312 /**
313  * @title SafeERC20
314  * @dev Wrappers around ERC20 operations that throw on failure (when the token
315  * contract returns false). Tokens that return no value (and instead revert or
316  * throw on failure) are also supported, non-reverting calls are assumed to be
317  * successful.
318  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
319  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
320  */
321 library SafeERC20 {
322     using Address for address;
323 
324     function safeTransfer(
325         IERC20 token,
326         address to,
327         uint256 value
328     ) internal {
329         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
330     }
331 
332     function safeTransferFrom(
333         IERC20 token,
334         address from,
335         address to,
336         uint256 value
337     ) internal {
338         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
339     }
340 
341     /**
342      * @dev Deprecated. This function has issues similar to the ones found in
343      * {IERC20-approve}, and its usage is discouraged.
344      *
345      * Whenever possible, use {safeIncreaseAllowance} and
346      * {safeDecreaseAllowance} instead.
347      */
348     function safeApprove(
349         IERC20 token,
350         address spender,
351         uint256 value
352     ) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         require(
357             (value == 0) || (token.allowance(address(this), spender) == 0),
358             "SafeERC20: approve from non-zero to non-zero allowance"
359         );
360         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
361     }
362 
363     function safeIncreaseAllowance(
364         IERC20 token,
365         address spender,
366         uint256 value
367     ) internal {
368         uint256 newAllowance = token.allowance(address(this), spender) + value;
369         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
370     }
371 
372     function safeDecreaseAllowance(
373         IERC20 token,
374         address spender,
375         uint256 value
376     ) internal {
377         unchecked {
378             uint256 oldAllowance = token.allowance(address(this), spender);
379             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
380             uint256 newAllowance = oldAllowance - value;
381             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
382         }
383     }
384 
385     /**
386      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
387      * on the return value: the return value is optional (but if data is returned, it must not be false).
388      * @param token The token targeted by the call.
389      * @param data The call data (encoded using abi.encode or one of its variants).
390      */
391     function _callOptionalReturn(IERC20 token, bytes memory data) private {
392         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
393         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
394         // the target address contains contract code and also asserts for success in the low-level call.
395 
396         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
397         if (returndata.length > 0) {
398             // Return data is optional
399             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
400         }
401     }
402 }
403 
404 
405 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
406 
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @dev Contract module that helps prevent reentrant calls to a function.
412  *
413  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
414  * available, which can be applied to functions to make sure there are no nested
415  * (reentrant) calls to them.
416  *
417  * Note that because there is a single `nonReentrant` guard, functions marked as
418  * `nonReentrant` may not call one another. This can be worked around by making
419  * those functions `private`, and then adding `external` `nonReentrant` entry
420  * points to them.
421  *
422  * TIP: If you would like to learn more about reentrancy and alternative ways
423  * to protect against it, check out our blog post
424  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
425  */
426 abstract contract ReentrancyGuard {
427     // Booleans are more expensive than uint256 or any type that takes up a full
428     // word because each write operation emits an extra SLOAD to first read the
429     // slot's contents, replace the bits taken up by the boolean, and then write
430     // back. This is the compiler's defense against contract upgrades and
431     // pointer aliasing, and it cannot be disabled.
432 
433     // The values being non-zero value makes deployment a bit more expensive,
434     // but in exchange the refund on every call to nonReentrant will be lower in
435     // amount. Since refunds are capped to a percentage of the total
436     // transaction's gas, it is best to keep them low in cases like this one, to
437     // increase the likelihood of the full refund coming into effect.
438     uint256 private constant _NOT_ENTERED = 1;
439     uint256 private constant _ENTERED = 2;
440 
441     uint256 private _status;
442 
443     constructor() {
444         _status = _NOT_ENTERED;
445     }
446 
447     /**
448      * @dev Prevents a contract from calling itself, directly or indirectly.
449      * Calling a `nonReentrant` function from another `nonReentrant`
450      * function is not supported. It is possible to prevent this from happening
451      * by making the `nonReentrant` function external, and make it call a
452      * `private` function that does the actual work.
453      */
454     modifier nonReentrant() {
455         // On the first call to nonReentrant, _notEntered will be true
456         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
457 
458         // Any calls to nonReentrant after this point will fail
459         _status = _ENTERED;
460 
461         _;
462 
463         // By storing the original value once again, a refund is triggered (see
464         // https://eips.ethereum.org/EIPS/eip-2200)
465         _status = _NOT_ENTERED;
466     }
467 }
468 
469 
470 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.1
471 
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
477  *
478  * These functions can be used to verify that a message was signed by the holder
479  * of the private keys of a given address.
480  */
481 library ECDSA {
482     enum RecoverError {
483         NoError,
484         InvalidSignature,
485         InvalidSignatureLength,
486         InvalidSignatureS,
487         InvalidSignatureV
488     }
489 
490     function _throwError(RecoverError error) private pure {
491         if (error == RecoverError.NoError) {
492             return; // no error: do nothing
493         } else if (error == RecoverError.InvalidSignature) {
494             revert("ECDSA: invalid signature");
495         } else if (error == RecoverError.InvalidSignatureLength) {
496             revert("ECDSA: invalid signature length");
497         } else if (error == RecoverError.InvalidSignatureS) {
498             revert("ECDSA: invalid signature 's' value");
499         } else if (error == RecoverError.InvalidSignatureV) {
500             revert("ECDSA: invalid signature 'v' value");
501         }
502     }
503 
504     /**
505      * @dev Returns the address that signed a hashed message (`hash`) with
506      * `signature` or error string. This address can then be used for verification purposes.
507      *
508      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
509      * this function rejects them by requiring the `s` value to be in the lower
510      * half order, and the `v` value to be either 27 or 28.
511      *
512      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
513      * verification to be secure: it is possible to craft signatures that
514      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
515      * this is by receiving a hash of the original message (which may otherwise
516      * be too long), and then calling {toEthSignedMessageHash} on it.
517      *
518      * Documentation for signature generation:
519      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
520      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
521      *
522      * _Available since v4.3._
523      */
524     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
525         // Check the signature length
526         // - case 65: r,s,v signature (standard)
527         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
528         if (signature.length == 65) {
529             bytes32 r;
530             bytes32 s;
531             uint8 v;
532             // ecrecover takes the signature parameters, and the only way to get them
533             // currently is to use assembly.
534             assembly {
535                 r := mload(add(signature, 0x20))
536                 s := mload(add(signature, 0x40))
537                 v := byte(0, mload(add(signature, 0x60)))
538             }
539             return tryRecover(hash, v, r, s);
540         } else if (signature.length == 64) {
541             bytes32 r;
542             bytes32 vs;
543             // ecrecover takes the signature parameters, and the only way to get them
544             // currently is to use assembly.
545             assembly {
546                 r := mload(add(signature, 0x20))
547                 vs := mload(add(signature, 0x40))
548             }
549             return tryRecover(hash, r, vs);
550         } else {
551             return (address(0), RecoverError.InvalidSignatureLength);
552         }
553     }
554 
555     /**
556      * @dev Returns the address that signed a hashed message (`hash`) with
557      * `signature`. This address can then be used for verification purposes.
558      *
559      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
560      * this function rejects them by requiring the `s` value to be in the lower
561      * half order, and the `v` value to be either 27 or 28.
562      *
563      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
564      * verification to be secure: it is possible to craft signatures that
565      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
566      * this is by receiving a hash of the original message (which may otherwise
567      * be too long), and then calling {toEthSignedMessageHash} on it.
568      */
569     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
570         (address recovered, RecoverError error) = tryRecover(hash, signature);
571         _throwError(error);
572         return recovered;
573     }
574 
575     /**
576      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
577      *
578      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
579      *
580      * _Available since v4.3._
581      */
582     function tryRecover(
583         bytes32 hash,
584         bytes32 r,
585         bytes32 vs
586     ) internal pure returns (address, RecoverError) {
587         bytes32 s;
588         uint8 v;
589         assembly {
590             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
591             v := add(shr(255, vs), 27)
592         }
593         return tryRecover(hash, v, r, s);
594     }
595 
596     /**
597      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
598      *
599      * _Available since v4.2._
600      */
601     function recover(
602         bytes32 hash,
603         bytes32 r,
604         bytes32 vs
605     ) internal pure returns (address) {
606         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
607         _throwError(error);
608         return recovered;
609     }
610 
611     /**
612      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
613      * `r` and `s` signature fields separately.
614      *
615      * _Available since v4.3._
616      */
617     function tryRecover(
618         bytes32 hash,
619         uint8 v,
620         bytes32 r,
621         bytes32 s
622     ) internal pure returns (address, RecoverError) {
623         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
624         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
625         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
626         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
627         //
628         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
629         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
630         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
631         // these malleable signatures as well.
632         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
633             return (address(0), RecoverError.InvalidSignatureS);
634         }
635         if (v != 27 && v != 28) {
636             return (address(0), RecoverError.InvalidSignatureV);
637         }
638 
639         // If the signature is valid (and not malleable), return the signer address
640         address signer = ecrecover(hash, v, r, s);
641         if (signer == address(0)) {
642             return (address(0), RecoverError.InvalidSignature);
643         }
644 
645         return (signer, RecoverError.NoError);
646     }
647 
648     /**
649      * @dev Overload of {ECDSA-recover} that receives the `v`,
650      * `r` and `s` signature fields separately.
651      */
652     function recover(
653         bytes32 hash,
654         uint8 v,
655         bytes32 r,
656         bytes32 s
657     ) internal pure returns (address) {
658         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
659         _throwError(error);
660         return recovered;
661     }
662 
663     /**
664      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
665      * produces hash corresponding to the one signed with the
666      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
667      * JSON-RPC method as part of EIP-191.
668      *
669      * See {recover}.
670      */
671     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
672         // 32 is the length in bytes of hash,
673         // enforced by the type signature above
674         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
675     }
676 
677     /**
678      * @dev Returns an Ethereum Signed Typed Data, created from a
679      * `domainSeparator` and a `structHash`. This produces hash corresponding
680      * to the one signed with the
681      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
682      * JSON-RPC method as part of EIP-712.
683      *
684      * See {recover}.
685      */
686     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
687         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
688     }
689 }
690 
691 
692 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
693 
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev Interface for the optional metadata functions from the ERC20 standard.
699  *
700  * _Available since v4.1._
701  */
702 interface IERC20Metadata is IERC20 {
703     /**
704      * @dev Returns the name of the token.
705      */
706     function name() external view returns (string memory);
707 
708     /**
709      * @dev Returns the symbol of the token.
710      */
711     function symbol() external view returns (string memory);
712 
713     /**
714      * @dev Returns the decimals places of the token.
715      */
716     function decimals() external view returns (uint8);
717 }
718 
719 
720 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
721 
722 
723 pragma solidity ^0.8.0;
724 
725 /**
726  * @dev Provides information about the current execution context, including the
727  * sender of the transaction and its data. While these are generally available
728  * via msg.sender and msg.data, they should not be accessed in such a direct
729  * manner, since when dealing with meta-transactions the account sending and
730  * paying for execution may not be the actual sender (as far as an application
731  * is concerned).
732  *
733  * This contract is only required for intermediate, library-like contracts.
734  */
735 abstract contract Context {
736     function _msgSender() internal view virtual returns (address) {
737         return msg.sender;
738     }
739 
740     function _msgData() internal view virtual returns (bytes calldata) {
741         return msg.data;
742     }
743 }
744 
745 
746 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
747 
748 
749 pragma solidity ^0.8.0;
750 
751 
752 
753 /**
754  * @dev Implementation of the {IERC20} interface.
755  *
756  * This implementation is agnostic to the way tokens are created. This means
757  * that a supply mechanism has to be added in a derived contract using {_mint}.
758  * For a generic mechanism see {ERC20PresetMinterPauser}.
759  *
760  * TIP: For a detailed writeup see our guide
761  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
762  * to implement supply mechanisms].
763  *
764  * We have followed general OpenZeppelin Contracts guidelines: functions revert
765  * instead returning `false` on failure. This behavior is nonetheless
766  * conventional and does not conflict with the expectations of ERC20
767  * applications.
768  *
769  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
770  * This allows applications to reconstruct the allowance for all accounts just
771  * by listening to said events. Other implementations of the EIP may not emit
772  * these events, as it isn't required by the specification.
773  *
774  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
775  * functions have been added to mitigate the well-known issues around setting
776  * allowances. See {IERC20-approve}.
777  */
778 contract ERC20 is Context, IERC20, IERC20Metadata {
779     mapping(address => uint256) private _balances;
780 
781     mapping(address => mapping(address => uint256)) private _allowances;
782 
783     uint256 private _totalSupply;
784 
785     string private _name;
786     string private _symbol;
787 
788     /**
789      * @dev Sets the values for {name} and {symbol}.
790      *
791      * The default value of {decimals} is 18. To select a different value for
792      * {decimals} you should overload it.
793      *
794      * All two of these values are immutable: they can only be set once during
795      * construction.
796      */
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800     }
801 
802     /**
803      * @dev Returns the name of the token.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev Returns the symbol of the token, usually a shorter version of the
811      * name.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev Returns the number of decimals used to get its user representation.
819      * For example, if `decimals` equals `2`, a balance of `505` tokens should
820      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
821      *
822      * Tokens usually opt for a value of 18, imitating the relationship between
823      * Ether and Wei. This is the value {ERC20} uses, unless this function is
824      * overridden;
825      *
826      * NOTE: This information is only used for _display_ purposes: it in
827      * no way affects any of the arithmetic of the contract, including
828      * {IERC20-balanceOf} and {IERC20-transfer}.
829      */
830     function decimals() public view virtual override returns (uint8) {
831         return 18;
832     }
833 
834     /**
835      * @dev See {IERC20-totalSupply}.
836      */
837     function totalSupply() public view virtual override returns (uint256) {
838         return _totalSupply;
839     }
840 
841     /**
842      * @dev See {IERC20-balanceOf}.
843      */
844     function balanceOf(address account) public view virtual override returns (uint256) {
845         return _balances[account];
846     }
847 
848     /**
849      * @dev See {IERC20-transfer}.
850      *
851      * Requirements:
852      *
853      * - `recipient` cannot be the zero address.
854      * - the caller must have a balance of at least `amount`.
855      */
856     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
857         _transfer(_msgSender(), recipient, amount);
858         return true;
859     }
860 
861     /**
862      * @dev See {IERC20-allowance}.
863      */
864     function allowance(address owner, address spender) public view virtual override returns (uint256) {
865         return _allowances[owner][spender];
866     }
867 
868     /**
869      * @dev See {IERC20-approve}.
870      *
871      * Requirements:
872      *
873      * - `spender` cannot be the zero address.
874      */
875     function approve(address spender, uint256 amount) public virtual override returns (bool) {
876         _approve(_msgSender(), spender, amount);
877         return true;
878     }
879 
880     /**
881      * @dev See {IERC20-transferFrom}.
882      *
883      * Emits an {Approval} event indicating the updated allowance. This is not
884      * required by the EIP. See the note at the beginning of {ERC20}.
885      *
886      * Requirements:
887      *
888      * - `sender` and `recipient` cannot be the zero address.
889      * - `sender` must have a balance of at least `amount`.
890      * - the caller must have allowance for ``sender``'s tokens of at least
891      * `amount`.
892      */
893     function transferFrom(
894         address sender,
895         address recipient,
896         uint256 amount
897     ) public virtual override returns (bool) {
898         _transfer(sender, recipient, amount);
899 
900         uint256 currentAllowance = _allowances[sender][_msgSender()];
901         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
902         unchecked {
903             _approve(sender, _msgSender(), currentAllowance - amount);
904         }
905 
906         return true;
907     }
908 
909     /**
910      * @dev Atomically increases the allowance granted to `spender` by the caller.
911      *
912      * This is an alternative to {approve} that can be used as a mitigation for
913      * problems described in {IERC20-approve}.
914      *
915      * Emits an {Approval} event indicating the updated allowance.
916      *
917      * Requirements:
918      *
919      * - `spender` cannot be the zero address.
920      */
921     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
922         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
923         return true;
924     }
925 
926     /**
927      * @dev Atomically decreases the allowance granted to `spender` by the caller.
928      *
929      * This is an alternative to {approve} that can be used as a mitigation for
930      * problems described in {IERC20-approve}.
931      *
932      * Emits an {Approval} event indicating the updated allowance.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      * - `spender` must have allowance for the caller of at least
938      * `subtractedValue`.
939      */
940     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
941         uint256 currentAllowance = _allowances[_msgSender()][spender];
942         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
943         unchecked {
944             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
945         }
946 
947         return true;
948     }
949 
950     /**
951      * @dev Moves `amount` of tokens from `sender` to `recipient`.
952      *
953      * This internal function is equivalent to {transfer}, and can be used to
954      * e.g. implement automatic token fees, slashing mechanisms, etc.
955      *
956      * Emits a {Transfer} event.
957      *
958      * Requirements:
959      *
960      * - `sender` cannot be the zero address.
961      * - `recipient` cannot be the zero address.
962      * - `sender` must have a balance of at least `amount`.
963      */
964     function _transfer(
965         address sender,
966         address recipient,
967         uint256 amount
968     ) internal virtual {
969         require(sender != address(0), "ERC20: transfer from the zero address");
970         require(recipient != address(0), "ERC20: transfer to the zero address");
971 
972         _beforeTokenTransfer(sender, recipient, amount);
973 
974         uint256 senderBalance = _balances[sender];
975         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
976         unchecked {
977             _balances[sender] = senderBalance - amount;
978         }
979         _balances[recipient] += amount;
980 
981         emit Transfer(sender, recipient, amount);
982 
983         _afterTokenTransfer(sender, recipient, amount);
984     }
985 
986     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
987      * the total supply.
988      *
989      * Emits a {Transfer} event with `from` set to the zero address.
990      *
991      * Requirements:
992      *
993      * - `account` cannot be the zero address.
994      */
995     function _mint(address account, uint256 amount) internal virtual {
996         require(account != address(0), "ERC20: mint to the zero address");
997 
998         _beforeTokenTransfer(address(0), account, amount);
999 
1000         _totalSupply += amount;
1001         _balances[account] += amount;
1002         emit Transfer(address(0), account, amount);
1003 
1004         _afterTokenTransfer(address(0), account, amount);
1005     }
1006 
1007     /**
1008      * @dev Destroys `amount` tokens from `account`, reducing the
1009      * total supply.
1010      *
1011      * Emits a {Transfer} event with `to` set to the zero address.
1012      *
1013      * Requirements:
1014      *
1015      * - `account` cannot be the zero address.
1016      * - `account` must have at least `amount` tokens.
1017      */
1018     function _burn(address account, uint256 amount) internal virtual {
1019         require(account != address(0), "ERC20: burn from the zero address");
1020 
1021         _beforeTokenTransfer(account, address(0), amount);
1022 
1023         uint256 accountBalance = _balances[account];
1024         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1025         unchecked {
1026             _balances[account] = accountBalance - amount;
1027         }
1028         _totalSupply -= amount;
1029 
1030         emit Transfer(account, address(0), amount);
1031 
1032         _afterTokenTransfer(account, address(0), amount);
1033     }
1034 
1035     /**
1036      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1037      *
1038      * This internal function is equivalent to `approve`, and can be used to
1039      * e.g. set automatic allowances for certain subsystems, etc.
1040      *
1041      * Emits an {Approval} event.
1042      *
1043      * Requirements:
1044      *
1045      * - `owner` cannot be the zero address.
1046      * - `spender` cannot be the zero address.
1047      */
1048     function _approve(
1049         address owner,
1050         address spender,
1051         uint256 amount
1052     ) internal virtual {
1053         require(owner != address(0), "ERC20: approve from the zero address");
1054         require(spender != address(0), "ERC20: approve to the zero address");
1055 
1056         _allowances[owner][spender] = amount;
1057         emit Approval(owner, spender, amount);
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before any transfer of tokens. This includes
1062      * minting and burning.
1063      *
1064      * Calling conditions:
1065      *
1066      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1067      * will be transferred to `to`.
1068      * - when `from` is zero, `amount` tokens will be minted for `to`.
1069      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1070      * - `from` and `to` are never both zero.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) internal virtual {}
1079 
1080     /**
1081      * @dev Hook that is called after any transfer of tokens. This includes
1082      * minting and burning.
1083      *
1084      * Calling conditions:
1085      *
1086      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1087      * has been transferred to `to`.
1088      * - when `from` is zero, `amount` tokens have been minted for `to`.
1089      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1090      * - `from` and `to` are never both zero.
1091      *
1092      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1093      */
1094     function _afterTokenTransfer(
1095         address from,
1096         address to,
1097         uint256 amount
1098     ) internal virtual {}
1099 }
1100 
1101 
1102 // File contracts/CosmosToken.sol
1103 
1104 pragma solidity 0.8.10;
1105 
1106 contract CosmosERC20 is ERC20 {
1107 	uint256 MAX_UINT = 2**256 - 1;
1108 	uint8 private cosmosDecimals;
1109 	address private gravityAddress;
1110 
1111 	// This override ensures we return the proper number of decimals
1112 	// for the cosmos token
1113 	function decimals() public view virtual override returns (uint8) {
1114 		return cosmosDecimals;
1115 	}
1116 
1117 	// This is not an accurate total supply. Instead this is the total supply
1118 	// of the given cosmos asset on Ethereum at this moment in time. Keeping
1119 	// a totally accurate supply would require constant updates from the Cosmos
1120 	// side, while in theory this could be piggy-backed on some existing bridge
1121 	// operation it's a lot of complextiy to add so we chose to forgoe it.
1122 	function totalSupply() public view virtual override returns (uint256) {
1123 		return MAX_UINT - balanceOf(gravityAddress);
1124 	}
1125 
1126 	constructor(
1127 		address _gravityAddress,
1128 		string memory _name,
1129 		string memory _symbol,
1130 		uint8 _decimals
1131 	) ERC20(_name, _symbol) {
1132 		cosmosDecimals = _decimals;
1133 		gravityAddress = _gravityAddress;
1134 		_mint(_gravityAddress, MAX_UINT);
1135 	}
1136 }
1137 
1138 
1139 // File contracts/Gravity.sol
1140 
1141 //SPDX-License-Identifier: Apache-2.0
1142 pragma solidity 0.8.10;
1143 
1144 
1145 
1146 
1147 
1148 
1149 error InvalidSignature();
1150 error InvalidValsetNonce(uint256 newNonce, uint256 currentNonce);
1151 error InvalidBatchNonce(uint256 newNonce, uint256 currentNonce);
1152 error InvalidLogicCallNonce(uint256 newNonce, uint256 currentNonce);
1153 error InvalidLogicCallTransfers();
1154 error InvalidLogicCallFees();
1155 error InvalidSendToCosmos();
1156 error IncorrectCheckpoint();
1157 error MalformedNewValidatorSet();
1158 error MalformedCurrentValidatorSet();
1159 error MalformedBatch();
1160 error InsufficientPower(uint256 cumulativePower, uint256 powerThreshold);
1161 error BatchTimedOut();
1162 error LogicCallTimedOut();
1163 
1164 // This is being used purely to avoid stack too deep errors
1165 struct LogicCallArgs {
1166 	// Transfers out to the logic contract
1167 	uint256[] transferAmounts;
1168 	address[] transferTokenContracts;
1169 	// The fees (transferred to msg.sender)
1170 	uint256[] feeAmounts;
1171 	address[] feeTokenContracts;
1172 	// The arbitrary logic call
1173 	address logicContractAddress;
1174 	bytes payload;
1175 	// Invalidation metadata
1176 	uint256 timeOut;
1177 	bytes32 invalidationId;
1178 	uint256 invalidationNonce;
1179 }
1180 
1181 // This is used purely to avoid stack too deep errors
1182 // represents everything about a given validator set
1183 struct ValsetArgs {
1184 	// the validators in this set, represented by an Ethereum address
1185 	address[] validators;
1186 	// the powers of the given validators in the same order as above
1187 	uint256[] powers;
1188 	// the nonce of this validator set
1189 	uint256 valsetNonce;
1190 	// the reward amount denominated in the below reward token, can be
1191 	// set to zero
1192 	uint256 rewardAmount;
1193 	// the reward token, should be set to the zero address if not being used
1194 	address rewardToken;
1195 }
1196 
1197 // This represents a validator signature
1198 struct Signature {
1199 	uint8 v;
1200 	bytes32 r;
1201 	bytes32 s;
1202 }
1203 
1204 contract Gravity is ReentrancyGuard {
1205 	using SafeERC20 for IERC20;
1206 
1207 	// The number of 'votes' required to execute a valset
1208 	// update or batch execution, set to 2/3 of 2^32
1209 	uint256 constant constant_powerThreshold = 2863311530;
1210 
1211 	// These are updated often
1212 	bytes32 public state_lastValsetCheckpoint;
1213 	mapping(address => uint256) public state_lastBatchNonces;
1214 	mapping(bytes32 => uint256) public state_invalidationMapping;
1215 	uint256 public state_lastValsetNonce = 0;
1216 	// event nonce zero is reserved by the Cosmos module as a special
1217 	// value indicating that no events have yet been submitted
1218 	uint256 public state_lastEventNonce = 1;
1219 
1220 	// This is set once at initialization
1221 	bytes32 public immutable state_gravityId;
1222 
1223 	// TransactionBatchExecutedEvent and SendToCosmosEvent both include the field _eventNonce.
1224 	// This is incremented every time one of these events is emitted. It is checked by the
1225 	// Cosmos module to ensure that all events are received in order, and that none are lost.
1226 	//
1227 	// ValsetUpdatedEvent does not include the field _eventNonce because it is never submitted to the Cosmos
1228 	// module. It is purely for the use of relayers to allow them to successfully submit batches.
1229 	event TransactionBatchExecutedEvent(
1230 		uint256 indexed _batchNonce,
1231 		address indexed _token,
1232 		uint256 _eventNonce
1233 	);
1234 	event SendToCosmosEvent(
1235 		address indexed _tokenContract,
1236 		address indexed _sender,
1237 		string _destination,
1238 		uint256 _amount,
1239 		uint256 _eventNonce
1240 	);
1241 	event ERC20DeployedEvent(
1242 		// FYI: Can't index on a string without doing a bunch of weird stuff
1243 		string _cosmosDenom,
1244 		address indexed _tokenContract,
1245 		string _name,
1246 		string _symbol,
1247 		uint8 _decimals,
1248 		uint256 _eventNonce
1249 	);
1250 	event ValsetUpdatedEvent(
1251 		uint256 indexed _newValsetNonce,
1252 		uint256 _eventNonce,
1253 		uint256 _rewardAmount,
1254 		address _rewardToken,
1255 		address[] _validators,
1256 		uint256[] _powers
1257 	);
1258 	event LogicCallEvent(
1259 		bytes32 _invalidationId,
1260 		uint256 _invalidationNonce,
1261 		bytes _returnData,
1262 		uint256 _eventNonce
1263 	);
1264 
1265 	// TEST FIXTURES
1266 	// These are here to make it easier to measure gas usage. They should be removed before production
1267 	function testMakeCheckpoint(ValsetArgs calldata _valsetArgs, bytes32 _gravityId) external pure {
1268 		makeCheckpoint(_valsetArgs, _gravityId);
1269 	}
1270 
1271 	function testCheckValidatorSignatures(
1272 		ValsetArgs calldata _currentValset,
1273 		Signature[] calldata _sigs,
1274 		bytes32 _theHash,
1275 		uint256 _powerThreshold
1276 	) external pure {
1277 		checkValidatorSignatures(_currentValset, _sigs, _theHash, _powerThreshold);
1278 	}
1279 
1280 	// END TEST FIXTURES
1281 
1282 	function lastBatchNonce(address _erc20Address) external view returns (uint256) {
1283 		return state_lastBatchNonces[_erc20Address];
1284 	}
1285 
1286 	function lastLogicCallNonce(bytes32 _invalidation_id) external view returns (uint256) {
1287 		return state_invalidationMapping[_invalidation_id];
1288 	}
1289 
1290 	// Utility function to verify geth style signatures
1291 	function verifySig(
1292 		address _signer,
1293 		bytes32 _theHash,
1294 		Signature calldata _sig
1295 	) private pure returns (bool) {
1296 		bytes32 messageDigest = keccak256(
1297 			abi.encodePacked("\x19Ethereum Signed Message:\n32", _theHash)
1298 		);
1299 		return _signer == ECDSA.recover(messageDigest, _sig.v, _sig.r, _sig.s);
1300 	}
1301 
1302 	// Utility function to determine that a validator set and signatures are well formed
1303 	function validateValset(ValsetArgs calldata _valset, Signature[] calldata _sigs) private pure {
1304 		// Check that current validators, powers, and signatures (v,r,s) set is well-formed
1305 		if (
1306 			_valset.validators.length != _valset.powers.length ||
1307 			_valset.validators.length != _sigs.length
1308 		) {
1309 			revert MalformedCurrentValidatorSet();
1310 		}
1311 	}
1312 
1313 	// Make a new checkpoint from the supplied validator set
1314 	// A checkpoint is a hash of all relevant information about the valset. This is stored by the contract,
1315 	// instead of storing the information directly. This saves on storage and gas.
1316 	// The format of the checkpoint is:
1317 	// h(gravityId, "checkpoint", valsetNonce, validators[], powers[])
1318 	// Where h is the keccak256 hash function.
1319 	// The validator powers must be decreasing or equal. This is important for checking the signatures on the
1320 	// next valset, since it allows the caller to stop verifying signatures once a quorum of signatures have been verified.
1321 	function makeCheckpoint(ValsetArgs memory _valsetArgs, bytes32 _gravityId)
1322 		private
1323 		pure
1324 		returns (bytes32)
1325 	{
1326 		// bytes32 encoding of the string "checkpoint"
1327 		bytes32 methodName = 0x636865636b706f696e7400000000000000000000000000000000000000000000;
1328 
1329 		bytes32 checkpoint = keccak256(
1330 			abi.encode(
1331 				_gravityId,
1332 				methodName,
1333 				_valsetArgs.valsetNonce,
1334 				_valsetArgs.validators,
1335 				_valsetArgs.powers,
1336 				_valsetArgs.rewardAmount,
1337 				_valsetArgs.rewardToken
1338 			)
1339 		);
1340 
1341 		return checkpoint;
1342 	}
1343 
1344 	function checkValidatorSignatures(
1345 		// The current validator set and their powers
1346 		ValsetArgs calldata _currentValset,
1347 		// The current validator's signatures
1348 		Signature[] calldata _sigs,
1349 		// This is what we are checking they have signed
1350 		bytes32 _theHash,
1351 		uint256 _powerThreshold
1352 	) private pure {
1353 		uint256 cumulativePower = 0;
1354 
1355 		for (uint256 i = 0; i < _currentValset.validators.length; i++) {
1356 			// If v is set to 0, this signifies that it was not possible to get a signature from this validator and we skip evaluation
1357 			// (In a valid signature, it is either 27 or 28)
1358 			if (_sigs[i].v != 0) {
1359 				// Check that the current validator has signed off on the hash
1360 				if (!verifySig(_currentValset.validators[i], _theHash, _sigs[i])) {
1361 					revert InvalidSignature();
1362 				}
1363 
1364 				// Sum up cumulative power
1365 				cumulativePower = cumulativePower + _currentValset.powers[i];
1366 
1367 				// Break early to avoid wasting gas
1368 				if (cumulativePower > _powerThreshold) {
1369 					break;
1370 				}
1371 			}
1372 		}
1373 
1374 		// Check that there was enough power
1375 		if (cumulativePower <= _powerThreshold) {
1376 			revert InsufficientPower(cumulativePower, _powerThreshold);
1377 		}
1378 		// Success
1379 	}
1380 
1381 	// This updates the valset by checking that the validators in the current valset have signed off on the
1382 	// new valset. The signatures supplied are the signatures of the current valset over the checkpoint hash
1383 	// generated from the new valset.
1384 	// Anyone can call this function, but they must supply valid signatures of constant_powerThreshold of the current valset over
1385 	// the new valset.
1386 	function updateValset(
1387 		// The new version of the validator set
1388 		ValsetArgs calldata _newValset,
1389 		// The current validators that approve the change
1390 		ValsetArgs calldata _currentValset,
1391 		// These are arrays of the parts of the current validator's signatures
1392 		Signature[] calldata _sigs
1393 	) external {
1394 		// CHECKS
1395 
1396 		// Check that the valset nonce is greater than the old one
1397 		if (_newValset.valsetNonce <= _currentValset.valsetNonce) {
1398 			revert InvalidValsetNonce({
1399 				newNonce: _newValset.valsetNonce,
1400 				currentNonce: _currentValset.valsetNonce
1401 			});
1402 		}
1403 
1404 		// Check that the valset nonce is less than a million nonces forward from the old one
1405 		// this makes it difficult for an attacker to lock out the contract by getting a single
1406 		// bad validator set through with uint256 max nonce
1407 		if (_newValset.valsetNonce > _currentValset.valsetNonce + 1000000) {
1408 			revert InvalidValsetNonce({
1409 				newNonce: _newValset.valsetNonce,
1410 				currentNonce: _currentValset.valsetNonce
1411 			});
1412 		}
1413 
1414 		// Check that new validators and powers set is well-formed
1415 		if (
1416 			_newValset.validators.length != _newValset.powers.length ||
1417 			_newValset.validators.length == 0
1418 		) {
1419 			revert MalformedNewValidatorSet();
1420 		}
1421 
1422 		// Check that current validators, powers, and signatures (v,r,s) set is well-formed
1423 		validateValset(_currentValset, _sigs);
1424 
1425 		// Check cumulative power to ensure the contract has sufficient power to actually
1426 		// pass a vote
1427 		uint256 cumulativePower = 0;
1428 		for (uint256 i = 0; i < _newValset.powers.length; i++) {
1429 			cumulativePower = cumulativePower + _newValset.powers[i];
1430 			if (cumulativePower > constant_powerThreshold) {
1431 				break;
1432 			}
1433 		}
1434 		if (cumulativePower <= constant_powerThreshold) {
1435 			revert InsufficientPower({
1436 				cumulativePower: cumulativePower,
1437 				powerThreshold: constant_powerThreshold
1438 			});
1439 		}
1440 
1441 		// Check that the supplied current validator set matches the saved checkpoint
1442 		if (makeCheckpoint(_currentValset, state_gravityId) != state_lastValsetCheckpoint) {
1443 			revert IncorrectCheckpoint();
1444 		}
1445 
1446 		// Check that enough current validators have signed off on the new validator set
1447 		bytes32 newCheckpoint = makeCheckpoint(_newValset, state_gravityId);
1448 
1449 		checkValidatorSignatures(_currentValset, _sigs, newCheckpoint, constant_powerThreshold);
1450 
1451 		// ACTIONS
1452 
1453 		// Stored to be used next time to validate that the valset
1454 		// supplied by the caller is correct.
1455 		state_lastValsetCheckpoint = newCheckpoint;
1456 
1457 		// Store new nonce
1458 		state_lastValsetNonce = _newValset.valsetNonce;
1459 
1460 		// Send submission reward to msg.sender if reward token is a valid value
1461 		if (_newValset.rewardToken != address(0) && _newValset.rewardAmount != 0) {
1462 			IERC20(_newValset.rewardToken).safeTransfer(msg.sender, _newValset.rewardAmount);
1463 		}
1464 
1465 		// LOGS
1466 
1467 		state_lastEventNonce = state_lastEventNonce + 1;
1468 		emit ValsetUpdatedEvent(
1469 			_newValset.valsetNonce,
1470 			state_lastEventNonce,
1471 			_newValset.rewardAmount,
1472 			_newValset.rewardToken,
1473 			_newValset.validators,
1474 			_newValset.powers
1475 		);
1476 	}
1477 
1478 	// submitBatch processes a batch of Cosmos -> Ethereum transactions by sending the tokens in the transactions
1479 	// to the destination addresses. It is approved by the current Cosmos validator set.
1480 	// Anyone can call this function, but they must supply valid signatures of constant_powerThreshold of the current valset over
1481 	// the batch.
1482 	function submitBatch(
1483 		// The validators that approve the batch
1484 		ValsetArgs calldata _currentValset,
1485 		// These are arrays of the parts of the validators signatures
1486 		Signature[] calldata _sigs,
1487 		// The batch of transactions
1488 		uint256[] calldata _amounts,
1489 		address[] calldata _destinations,
1490 		uint256[] calldata _fees,
1491 		uint256 _batchNonce,
1492 		address _tokenContract,
1493 		// a block height beyond which this batch is not valid
1494 		// used to provide a fee-free timeout
1495 		uint256 _batchTimeout
1496 	) external nonReentrant {
1497 		// CHECKS scoped to reduce stack depth
1498 		{
1499 			// Check that the batch nonce is higher than the last nonce for this token
1500 			if (_batchNonce <= state_lastBatchNonces[_tokenContract]) {
1501 				revert InvalidBatchNonce({
1502 					newNonce: _batchNonce,
1503 					currentNonce: state_lastBatchNonces[_tokenContract]
1504 				});
1505 			}
1506 
1507 			// Check that the batch nonce is less than one million nonces forward from the old one
1508 			// this makes it difficult for an attacker to lock out the contract by getting a single
1509 			// bad batch through with uint256 max nonce
1510 			if (_batchNonce > state_lastBatchNonces[_tokenContract] + 1000000) {
1511 				revert InvalidBatchNonce({
1512 					newNonce: _batchNonce,
1513 					currentNonce: state_lastBatchNonces[_tokenContract]
1514 				});
1515 			}
1516 
1517 			// Check that the block height is less than the timeout height
1518 			if (block.number >= _batchTimeout) {
1519 				revert BatchTimedOut();
1520 			}
1521 
1522 			// Check that current validators, powers, and signatures (v,r,s) set is well-formed
1523 			validateValset(_currentValset, _sigs);
1524 
1525 			// Check that the supplied current validator set matches the saved checkpoint
1526 			if (makeCheckpoint(_currentValset, state_gravityId) != state_lastValsetCheckpoint) {
1527 				revert IncorrectCheckpoint();
1528 			}
1529 
1530 			// Check that the transaction batch is well-formed
1531 			if (_amounts.length != _destinations.length || _amounts.length != _fees.length) {
1532 				revert MalformedBatch();
1533 			}
1534 
1535 			// Check that enough current validators have signed off on the transaction batch and valset
1536 			checkValidatorSignatures(
1537 				_currentValset,
1538 				_sigs,
1539 				// Get hash of the transaction batch and checkpoint
1540 				keccak256(
1541 					abi.encode(
1542 						state_gravityId,
1543 						// bytes32 encoding of "transactionBatch"
1544 						0x7472616e73616374696f6e426174636800000000000000000000000000000000,
1545 						_amounts,
1546 						_destinations,
1547 						_fees,
1548 						_batchNonce,
1549 						_tokenContract,
1550 						_batchTimeout
1551 					)
1552 				),
1553 				constant_powerThreshold
1554 			);
1555 
1556 			// ACTIONS
1557 
1558 			// Store batch nonce
1559 			state_lastBatchNonces[_tokenContract] = _batchNonce;
1560 
1561 			{
1562 				// Send transaction amounts to destinations
1563 				uint256 totalFee;
1564 				for (uint256 i = 0; i < _amounts.length; i++) {
1565 					IERC20(_tokenContract).safeTransfer(_destinations[i], _amounts[i]);
1566 					totalFee = totalFee + _fees[i];
1567 				}
1568 
1569 				// Send transaction fees to msg.sender
1570 				IERC20(_tokenContract).safeTransfer(msg.sender, totalFee);
1571 			}
1572 		}
1573 
1574 		// LOGS scoped to reduce stack depth
1575 		{
1576 			state_lastEventNonce = state_lastEventNonce + 1;
1577 			emit TransactionBatchExecutedEvent(_batchNonce, _tokenContract, state_lastEventNonce);
1578 		}
1579 	}
1580 
1581 	// This makes calls to contracts that execute arbitrary logic
1582 	// First, it gives the logic contract some tokens
1583 	// Then, it gives msg.senders tokens for fees
1584 	// Then, it calls an arbitrary function on the logic contract
1585 	// invalidationId and invalidationNonce are used for replay prevention.
1586 	// They can be used to implement a per-token nonce by setting the token
1587 	// address as the invalidationId and incrementing the nonce each call.
1588 	// They can be used for nonce-free replay prevention by using a different invalidationId
1589 	// for each call.
1590 	function submitLogicCall(
1591 		// The validators that approve the call
1592 		ValsetArgs calldata _currentValset,
1593 		// These are arrays of the parts of the validators signatures
1594 		Signature[] calldata _sigs,
1595 		LogicCallArgs memory _args
1596 	) external nonReentrant {
1597 		// CHECKS scoped to reduce stack depth
1598 		{
1599 			// Check that the call has not timed out
1600 			if (block.number >= _args.timeOut) {
1601 				revert LogicCallTimedOut();
1602 			}
1603 
1604 			// Check that the invalidation nonce is higher than the last nonce for this invalidation Id
1605 			if (state_invalidationMapping[_args.invalidationId] >= _args.invalidationNonce) {
1606 				revert InvalidLogicCallNonce({
1607 					newNonce: _args.invalidationNonce,
1608 					currentNonce: state_invalidationMapping[_args.invalidationId]
1609 				});
1610 			}
1611 
1612 			// note the lack of nonce skipping check, it's not needed here since an attacker
1613 			// will never be able to fill the invalidationId space, therefore a nonce lockout
1614 			// is simply not possible
1615 
1616 			// Check that current validators, powers, and signatures (v,r,s) set is well-formed
1617 			validateValset(_currentValset, _sigs);
1618 
1619 			// Check that the supplied current validator set matches the saved checkpoint
1620 			if (makeCheckpoint(_currentValset, state_gravityId) != state_lastValsetCheckpoint) {
1621 				revert IncorrectCheckpoint();
1622 			}
1623 
1624 			if (_args.transferAmounts.length != _args.transferTokenContracts.length) {
1625 				revert InvalidLogicCallTransfers();
1626 			}
1627 
1628 			if (_args.feeAmounts.length != _args.feeTokenContracts.length) {
1629 				revert InvalidLogicCallFees();
1630 			}
1631 		}
1632 		{
1633 			bytes32 argsHash = keccak256(
1634 				abi.encode(
1635 					state_gravityId,
1636 					// bytes32 encoding of "logicCall"
1637 					0x6c6f67696343616c6c0000000000000000000000000000000000000000000000,
1638 					_args.transferAmounts,
1639 					_args.transferTokenContracts,
1640 					_args.feeAmounts,
1641 					_args.feeTokenContracts,
1642 					_args.logicContractAddress,
1643 					_args.payload,
1644 					_args.timeOut,
1645 					_args.invalidationId,
1646 					_args.invalidationNonce
1647 				)
1648 			);
1649 
1650 			// Check that enough current validators have signed off on the transaction batch and valset
1651 			checkValidatorSignatures(
1652 				_currentValset,
1653 				_sigs,
1654 				// Get hash of the transaction batch and checkpoint
1655 				argsHash,
1656 				constant_powerThreshold
1657 			);
1658 		}
1659 
1660 		// ACTIONS
1661 
1662 		// Update invaldiation nonce
1663 		state_invalidationMapping[_args.invalidationId] = _args.invalidationNonce;
1664 
1665 		// Send tokens to the logic contract
1666 		for (uint256 i = 0; i < _args.transferAmounts.length; i++) {
1667 			IERC20(_args.transferTokenContracts[i]).safeTransfer(
1668 				_args.logicContractAddress,
1669 				_args.transferAmounts[i]
1670 			);
1671 		}
1672 
1673 		// Make call to logic contract
1674 		bytes memory returnData = Address.functionCall(_args.logicContractAddress, _args.payload);
1675 
1676 		// Send fees to msg.sender
1677 		for (uint256 i = 0; i < _args.feeAmounts.length; i++) {
1678 			IERC20(_args.feeTokenContracts[i]).safeTransfer(msg.sender, _args.feeAmounts[i]);
1679 		}
1680 
1681 		// LOGS scoped to reduce stack depth
1682 		{
1683 			state_lastEventNonce = state_lastEventNonce + 1;
1684 			emit LogicCallEvent(
1685 				_args.invalidationId,
1686 				_args.invalidationNonce,
1687 				returnData,
1688 				state_lastEventNonce
1689 			);
1690 		}
1691 	}
1692 
1693 	function sendToCosmos(
1694 		address _tokenContract,
1695 		string calldata _destination,
1696 		uint256 _amount
1697 	) external nonReentrant {
1698 		// we snapshot our current balance of this token
1699 		uint256 ourStartingBalance = IERC20(_tokenContract).balanceOf(address(this));
1700 
1701 		// attempt to transfer the user specified amount
1702 		IERC20(_tokenContract).safeTransferFrom(msg.sender, address(this), _amount);
1703 
1704 		// check what this particular ERC20 implementation actually gave us, since it doesn't
1705 		// have to be at all related to the _amount
1706 		uint256 ourEndingBalance = IERC20(_tokenContract).balanceOf(address(this));
1707 
1708 		// a very strange ERC20 may trigger this condition, if we didn't have this we would
1709 		// underflow, so it's mostly just an error message printer
1710 		if (ourEndingBalance <= ourStartingBalance) {
1711 			revert InvalidSendToCosmos();
1712 		}
1713 
1714 		state_lastEventNonce = state_lastEventNonce + 1;
1715 
1716 		// emit to Cosmos the actual amount our balance has changed, rather than the user
1717 		// provided amount. This protects against a small set of wonky ERC20 behavior, like
1718 		// burning on send but not tokens that for example change every users balance every day.
1719 		emit SendToCosmosEvent(
1720 			_tokenContract,
1721 			msg.sender,
1722 			_destination,
1723 			ourEndingBalance - ourStartingBalance,
1724 			state_lastEventNonce
1725 		);
1726 	}
1727 
1728 	function deployERC20(
1729 		string calldata _cosmosDenom,
1730 		string calldata _name,
1731 		string calldata _symbol,
1732 		uint8 _decimals
1733 	) external {
1734 		// Deploy an ERC20 with entire supply granted to Gravity.sol
1735 		CosmosERC20 erc20 = new CosmosERC20(address(this), _name, _symbol, _decimals);
1736 
1737 		// Fire an event to let the Cosmos module know
1738 		state_lastEventNonce = state_lastEventNonce + 1;
1739 		emit ERC20DeployedEvent(
1740 			_cosmosDenom,
1741 			address(erc20),
1742 			_name,
1743 			_symbol,
1744 			_decimals,
1745 			state_lastEventNonce
1746 		);
1747 	}
1748 
1749 	constructor(
1750 		// A unique identifier for this gravity instance to use in signatures
1751 		bytes32 _gravityId,
1752 		// The validator set, not in valset args format since many of it's
1753 		// arguments would never be used in this case
1754 		address[] memory _validators,
1755 		uint256[] memory _powers
1756 	) {
1757 		// CHECKS
1758 
1759 		// Check that validators, powers, and signatures (v,r,s) set is well-formed
1760 		if (_validators.length != _powers.length || _validators.length == 0) {
1761 			revert MalformedCurrentValidatorSet();
1762 		}
1763 
1764 		// Check cumulative power to ensure the contract has sufficient power to actually
1765 		// pass a vote
1766 		uint256 cumulativePower = 0;
1767 		for (uint256 i = 0; i < _powers.length; i++) {
1768 			cumulativePower = cumulativePower + _powers[i];
1769 			if (cumulativePower > constant_powerThreshold) {
1770 				break;
1771 			}
1772 		}
1773 		if (cumulativePower <= constant_powerThreshold) {
1774 			revert InsufficientPower({
1775 				cumulativePower: cumulativePower,
1776 				powerThreshold: constant_powerThreshold
1777 			});
1778 		}
1779 
1780 		ValsetArgs memory _valset;
1781 		_valset = ValsetArgs(_validators, _powers, 0, 0, address(0));
1782 
1783 		bytes32 newCheckpoint = makeCheckpoint(_valset, _gravityId);
1784 
1785 		// ACTIONS
1786 
1787 		state_gravityId = _gravityId;
1788 		state_lastValsetCheckpoint = newCheckpoint;
1789 
1790 		// LOGS
1791 
1792 		emit ValsetUpdatedEvent(
1793 			state_lastValsetNonce,
1794 			state_lastEventNonce,
1795 			0,
1796 			address(0),
1797 			_validators,
1798 			_powers
1799 		);
1800 	}
1801 }