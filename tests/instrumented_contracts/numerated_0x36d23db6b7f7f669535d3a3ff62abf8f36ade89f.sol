1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 /**
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
84         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
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
133         (bool success, bytes memory returndata) = target.call{value: value}(data);
134         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a delegate call.
165      *
166      * _Available since v3.4._
167      */
168     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         (bool success, bytes memory returndata) = target.delegatecall(data);
184         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
189      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
190      *
191      * _Available since v4.8._
192      */
193     function verifyCallResultFromTarget(
194         address target,
195         bool success,
196         bytes memory returndata,
197         string memory errorMessage
198     ) internal view returns (bytes memory) {
199         if (success) {
200             if (returndata.length == 0) {
201                 // only check isContract if the call was successful and the return data is empty
202                 // otherwise we already know that it was a contract
203                 require(isContract(target), "Address: call to non-contract");
204             }
205             return returndata;
206         } else {
207             _revert(returndata, errorMessage);
208         }
209     }
210 
211     /**
212      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason or using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             _revert(returndata, errorMessage);
226         }
227     }
228 
229     function _revert(bytes memory returndata, string memory errorMessage) private pure {
230         // Look for revert reason and bubble it up if present
231         if (returndata.length > 0) {
232             // The easiest way to bubble the revert reason is using memory via assembly
233             /// @solidity memory-safe-assembly
234             assembly {
235                 let returndata_size := mload(returndata)
236                 revert(add(32, returndata), returndata_size)
237             }
238         } else {
239             revert(errorMessage);
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-IERC20PermitUpgradeable.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
253  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
254  *
255  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
256  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
257  * need to send a transaction, and thus is not required to hold Ether at all.
258  */
259 interface IERC20PermitUpgradeable {
260     /**
261      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
262      * given ``owner``'s signed approval.
263      *
264      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
265      * ordering also apply here.
266      *
267      * Emits an {Approval} event.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      * - `deadline` must be a timestamp in the future.
273      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
274      * over the EIP712-formatted function arguments.
275      * - the signature must use ``owner``'s current nonce (see {nonces}).
276      *
277      * For more information on the signature format, see the
278      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
279      * section].
280      */
281     function permit(
282         address owner,
283         address spender,
284         uint256 value,
285         uint256 deadline,
286         uint8 v,
287         bytes32 r,
288         bytes32 s
289     ) external;
290 
291     /**
292      * @dev Returns the current nonce for `owner`. This value must be
293      * included whenever a signature is generated for {permit}.
294      *
295      * Every successful call to {permit} increases ``owner``'s nonce by one. This
296      * prevents a signature from being used multiple times.
297      */
298     function nonces(address owner) external view returns (uint256);
299 
300     /**
301      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
302      */
303     // solhint-disable-next-line func-name-mixedcase
304     function DOMAIN_SEPARATOR() external view returns (bytes32);
305 }
306 
307 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Interface of the ERC20 standard as defined in the EIP.
316  */
317 interface IERC20Upgradeable {
318     /**
319      * @dev Emitted when `value` tokens are moved from one account (`from`) to
320      * another (`to`).
321      *
322      * Note that `value` may be zero.
323      */
324     event Transfer(address indexed from, address indexed to, uint256 value);
325 
326     /**
327      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
328      * a call to {approve}. `value` is the new allowance.
329      */
330     event Approval(address indexed owner, address indexed spender, uint256 value);
331 
332     /**
333      * @dev Returns the amount of tokens in existence.
334      */
335     function totalSupply() external view returns (uint256);
336 
337     /**
338      * @dev Returns the amount of tokens owned by `account`.
339      */
340     function balanceOf(address account) external view returns (uint256);
341 
342     /**
343      * @dev Moves `amount` tokens from the caller's account to `to`.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transfer(address to, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Returns the remaining number of tokens that `spender` will be
353      * allowed to spend on behalf of `owner` through {transferFrom}. This is
354      * zero by default.
355      *
356      * This value changes when {approve} or {transferFrom} are called.
357      */
358     function allowance(address owner, address spender) external view returns (uint256);
359 
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * IMPORTANT: Beware that changing an allowance with this method brings the risk
366      * that someone may use both the old and the new allowance by unfortunate
367      * transaction ordering. One possible solution to mitigate this race
368      * condition is to first reduce the spender's allowance to 0 and set the
369      * desired value afterwards:
370      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371      *
372      * Emits an {Approval} event.
373      */
374     function approve(address spender, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Moves `amount` tokens from `from` to `to` using the
378      * allowance mechanism. `amount` is then deducted from the caller's
379      * allowance.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 amount
389     ) external returns (bool);
390 }
391 
392 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
396 
397 pragma solidity ^0.8.1;
398 
399 /**
400  * @dev Collection of functions related to the address type
401  */
402 library AddressUpgradeable {
403     /**
404      * @dev Returns true if `account` is a contract.
405      *
406      * [IMPORTANT]
407      * ====
408      * It is unsafe to assume that an address for which this function returns
409      * false is an externally-owned account (EOA) and not a contract.
410      *
411      * Among others, `isContract` will return false for the following
412      * types of addresses:
413      *
414      *  - an externally-owned account
415      *  - a contract in construction
416      *  - an address where a contract will be created
417      *  - an address where a contract lived, but was destroyed
418      * ====
419      *
420      * [IMPORTANT]
421      * ====
422      * You shouldn't rely on `isContract` to protect against flash loan attacks!
423      *
424      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
425      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
426      * constructor.
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize/address.code.length, which returns 0
431         // for contracts in construction, since the code is only stored at the end
432         // of the constructor execution.
433 
434         return account.code.length > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         (bool success, bytes memory returndata) = target.call{value: value}(data);
529         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
539         return functionStaticCall(target, data, "Address: low-level static call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal view returns (bytes memory) {
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
559      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
560      *
561      * _Available since v4.8._
562      */
563     function verifyCallResultFromTarget(
564         address target,
565         bool success,
566         bytes memory returndata,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         if (success) {
570             if (returndata.length == 0) {
571                 // only check isContract if the call was successful and the return data is empty
572                 // otherwise we already know that it was a contract
573                 require(isContract(target), "Address: call to non-contract");
574             }
575             return returndata;
576         } else {
577             _revert(returndata, errorMessage);
578         }
579     }
580 
581     /**
582      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
583      * revert reason or using the provided one.
584      *
585      * _Available since v4.3._
586      */
587     function verifyCallResult(
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal pure returns (bytes memory) {
592         if (success) {
593             return returndata;
594         } else {
595             _revert(returndata, errorMessage);
596         }
597     }
598 
599     function _revert(bytes memory returndata, string memory errorMessage) private pure {
600         // Look for revert reason and bubble it up if present
601         if (returndata.length > 0) {
602             // The easiest way to bubble the revert reason is using memory via assembly
603             /// @solidity memory-safe-assembly
604             assembly {
605                 let returndata_size := mload(returndata)
606                 revert(add(32, returndata), returndata_size)
607             }
608         } else {
609             revert(errorMessage);
610         }
611     }
612 }
613 
614 // File: @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol
615 
616 
617 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 
623 
624 /**
625  * @title SafeERC20
626  * @dev Wrappers around ERC20 operations that throw on failure (when the token
627  * contract returns false). Tokens that return no value (and instead revert or
628  * throw on failure) are also supported, non-reverting calls are assumed to be
629  * successful.
630  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
631  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
632  */
633 library SafeERC20Upgradeable {
634     using AddressUpgradeable for address;
635 
636     function safeTransfer(
637         IERC20Upgradeable token,
638         address to,
639         uint256 value
640     ) internal {
641         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
642     }
643 
644     function safeTransferFrom(
645         IERC20Upgradeable token,
646         address from,
647         address to,
648         uint256 value
649     ) internal {
650         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
651     }
652 
653     /**
654      * @dev Deprecated. This function has issues similar to the ones found in
655      * {IERC20-approve}, and its usage is discouraged.
656      *
657      * Whenever possible, use {safeIncreaseAllowance} and
658      * {safeDecreaseAllowance} instead.
659      */
660     function safeApprove(
661         IERC20Upgradeable token,
662         address spender,
663         uint256 value
664     ) internal {
665         // safeApprove should only be called when setting an initial allowance,
666         // or when resetting it to zero. To increase and decrease it, use
667         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
668         require(
669             (value == 0) || (token.allowance(address(this), spender) == 0),
670             "SafeERC20: approve from non-zero to non-zero allowance"
671         );
672         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
673     }
674 
675     function safeIncreaseAllowance(
676         IERC20Upgradeable token,
677         address spender,
678         uint256 value
679     ) internal {
680         uint256 newAllowance = token.allowance(address(this), spender) + value;
681         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
682     }
683 
684     function safeDecreaseAllowance(
685         IERC20Upgradeable token,
686         address spender,
687         uint256 value
688     ) internal {
689         unchecked {
690             uint256 oldAllowance = token.allowance(address(this), spender);
691             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
692             uint256 newAllowance = oldAllowance - value;
693             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
694         }
695     }
696 
697     function safePermit(
698         IERC20PermitUpgradeable token,
699         address owner,
700         address spender,
701         uint256 value,
702         uint256 deadline,
703         uint8 v,
704         bytes32 r,
705         bytes32 s
706     ) internal {
707         uint256 nonceBefore = token.nonces(owner);
708         token.permit(owner, spender, value, deadline, v, r, s);
709         uint256 nonceAfter = token.nonces(owner);
710         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
711     }
712 
713     /**
714      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
715      * on the return value: the return value is optional (but if data is returned, it must not be false).
716      * @param token The token targeted by the call.
717      * @param data The call data (encoded using abi.encode or one of its variants).
718      */
719     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
720         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
721         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
722         // the target address contains contract code and also asserts for success in the low-level call.
723 
724         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
725         if (returndata.length > 0) {
726             // Return data is optional
727             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
728         }
729     }
730 }
731 
732 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
733 
734 
735 // OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)
736 
737 pragma solidity ^0.8.2;
738 
739 
740 /**
741  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
742  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
743  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
744  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
745  *
746  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
747  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
748  * case an upgrade adds a module that needs to be initialized.
749  *
750  * For example:
751  *
752  * [.hljs-theme-light.nopadding]
753  * ```
754  * contract MyToken is ERC20Upgradeable {
755  *     function initialize() initializer public {
756  *         __ERC20_init("MyToken", "MTK");
757  *     }
758  * }
759  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
760  *     function initializeV2() reinitializer(2) public {
761  *         __ERC20Permit_init("MyToken");
762  *     }
763  * }
764  * ```
765  *
766  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
767  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
768  *
769  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
770  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
771  *
772  * [CAUTION]
773  * ====
774  * Avoid leaving a contract uninitialized.
775  *
776  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
777  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
778  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
779  *
780  * [.hljs-theme-light.nopadding]
781  * ```
782  * /// @custom:oz-upgrades-unsafe-allow constructor
783  * constructor() {
784  *     _disableInitializers();
785  * }
786  * ```
787  * ====
788  */
789 abstract contract Initializable {
790     /**
791      * @dev Indicates that the contract has been initialized.
792      * @custom:oz-retyped-from bool
793      */
794     uint8 private _initialized;
795 
796     /**
797      * @dev Indicates that the contract is in the process of being initialized.
798      */
799     bool private _initializing;
800 
801     /**
802      * @dev Triggered when the contract has been initialized or reinitialized.
803      */
804     event Initialized(uint8 version);
805 
806     /**
807      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
808      * `onlyInitializing` functions can be used to initialize parent contracts.
809      *
810      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
811      * constructor.
812      *
813      * Emits an {Initialized} event.
814      */
815     modifier initializer() {
816         bool isTopLevelCall = !_initializing;
817         require(
818             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
819             "Initializable: contract is already initialized"
820         );
821         _initialized = 1;
822         if (isTopLevelCall) {
823             _initializing = true;
824         }
825         _;
826         if (isTopLevelCall) {
827             _initializing = false;
828             emit Initialized(1);
829         }
830     }
831 
832     /**
833      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
834      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
835      * used to initialize parent contracts.
836      *
837      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
838      * are added through upgrades and that require initialization.
839      *
840      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
841      * cannot be nested. If one is invoked in the context of another, execution will revert.
842      *
843      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
844      * a contract, executing them in the right order is up to the developer or operator.
845      *
846      * WARNING: setting the version to 255 will prevent any future reinitialization.
847      *
848      * Emits an {Initialized} event.
849      */
850     modifier reinitializer(uint8 version) {
851         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
852         _initialized = version;
853         _initializing = true;
854         _;
855         _initializing = false;
856         emit Initialized(version);
857     }
858 
859     /**
860      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
861      * {initializer} and {reinitializer} modifiers, directly or indirectly.
862      */
863     modifier onlyInitializing() {
864         require(_initializing, "Initializable: contract is not initializing");
865         _;
866     }
867 
868     /**
869      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
870      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
871      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
872      * through proxies.
873      *
874      * Emits an {Initialized} event the first time it is successfully executed.
875      */
876     function _disableInitializers() internal virtual {
877         require(!_initializing, "Initializable: contract is initializing");
878         if (_initialized < type(uint8).max) {
879             _initialized = type(uint8).max;
880             emit Initialized(type(uint8).max);
881         }
882     }
883 
884     /**
885      * @dev Returns the highest version that has been initialized. See {reinitializer}.
886      */
887     function _getInitializedVersion() internal view returns (uint8) {
888         return _initialized;
889     }
890 
891     /**
892      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
893      */
894     function _isInitializing() internal view returns (bool) {
895         return _initializing;
896     }
897 }
898 
899 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
900 
901 
902 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 
907 /**
908  * @dev Contract module that helps prevent reentrant calls to a function.
909  *
910  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
911  * available, which can be applied to functions to make sure there are no nested
912  * (reentrant) calls to them.
913  *
914  * Note that because there is a single `nonReentrant` guard, functions marked as
915  * `nonReentrant` may not call one another. This can be worked around by making
916  * those functions `private`, and then adding `external` `nonReentrant` entry
917  * points to them.
918  *
919  * TIP: If you would like to learn more about reentrancy and alternative ways
920  * to protect against it, check out our blog post
921  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
922  */
923 abstract contract ReentrancyGuardUpgradeable is Initializable {
924     // Booleans are more expensive than uint256 or any type that takes up a full
925     // word because each write operation emits an extra SLOAD to first read the
926     // slot's contents, replace the bits taken up by the boolean, and then write
927     // back. This is the compiler's defense against contract upgrades and
928     // pointer aliasing, and it cannot be disabled.
929 
930     // The values being non-zero value makes deployment a bit more expensive,
931     // but in exchange the refund on every call to nonReentrant will be lower in
932     // amount. Since refunds are capped to a percentage of the total
933     // transaction's gas, it is best to keep them low in cases like this one, to
934     // increase the likelihood of the full refund coming into effect.
935     uint256 private constant _NOT_ENTERED = 1;
936     uint256 private constant _ENTERED = 2;
937 
938     uint256 private _status;
939 
940     function __ReentrancyGuard_init() internal onlyInitializing {
941         __ReentrancyGuard_init_unchained();
942     }
943 
944     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
945         _status = _NOT_ENTERED;
946     }
947 
948     /**
949      * @dev Prevents a contract from calling itself, directly or indirectly.
950      * Calling a `nonReentrant` function from another `nonReentrant`
951      * function is not supported. It is possible to prevent this from happening
952      * by making the `nonReentrant` function external, and making it call a
953      * `private` function that does the actual work.
954      */
955     modifier nonReentrant() {
956         _nonReentrantBefore();
957         _;
958         _nonReentrantAfter();
959     }
960 
961     function _nonReentrantBefore() private {
962         // On the first call to nonReentrant, _status will be _NOT_ENTERED
963         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
964 
965         // Any calls to nonReentrant after this point will fail
966         _status = _ENTERED;
967     }
968 
969     function _nonReentrantAfter() private {
970         // By storing the original value once again, a refund is triggered (see
971         // https://eips.ethereum.org/EIPS/eip-2200)
972         _status = _NOT_ENTERED;
973     }
974 
975     /**
976      * @dev This empty reserved space is put in place to allow future versions to add new
977      * variables without shifting down storage in the inheritance chain.
978      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
979      */
980     uint256[49] private __gap;
981 }
982 
983 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
984 
985 
986 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @dev Provides information about the current execution context, including the
993  * sender of the transaction and its data. While these are generally available
994  * via msg.sender and msg.data, they should not be accessed in such a direct
995  * manner, since when dealing with meta-transactions the account sending and
996  * paying for execution may not be the actual sender (as far as an application
997  * is concerned).
998  *
999  * This contract is only required for intermediate, library-like contracts.
1000  */
1001 abstract contract ContextUpgradeable is Initializable {
1002     function __Context_init() internal onlyInitializing {
1003     }
1004 
1005     function __Context_init_unchained() internal onlyInitializing {
1006     }
1007     function _msgSender() internal view virtual returns (address) {
1008         return msg.sender;
1009     }
1010 
1011     function _msgData() internal view virtual returns (bytes calldata) {
1012         return msg.data;
1013     }
1014 
1015     /**
1016      * @dev This empty reserved space is put in place to allow future versions to add new
1017      * variables without shifting down storage in the inheritance chain.
1018      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1019      */
1020     uint256[50] private __gap;
1021 }
1022 
1023 // File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol
1024 
1025 
1026 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 
1032 /**
1033  * @dev Contract module which allows children to implement an emergency stop
1034  * mechanism that can be triggered by an authorized account.
1035  *
1036  * This module is used through inheritance. It will make available the
1037  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1038  * the functions of your contract. Note that they will not be pausable by
1039  * simply including this module, only once the modifiers are put in place.
1040  */
1041 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1042     /**
1043      * @dev Emitted when the pause is triggered by `account`.
1044      */
1045     event Paused(address account);
1046 
1047     /**
1048      * @dev Emitted when the pause is lifted by `account`.
1049      */
1050     event Unpaused(address account);
1051 
1052     bool private _paused;
1053 
1054     /**
1055      * @dev Initializes the contract in unpaused state.
1056      */
1057     function __Pausable_init() internal onlyInitializing {
1058         __Pausable_init_unchained();
1059     }
1060 
1061     function __Pausable_init_unchained() internal onlyInitializing {
1062         _paused = false;
1063     }
1064 
1065     /**
1066      * @dev Modifier to make a function callable only when the contract is not paused.
1067      *
1068      * Requirements:
1069      *
1070      * - The contract must not be paused.
1071      */
1072     modifier whenNotPaused() {
1073         _requireNotPaused();
1074         _;
1075     }
1076 
1077     /**
1078      * @dev Modifier to make a function callable only when the contract is paused.
1079      *
1080      * Requirements:
1081      *
1082      * - The contract must be paused.
1083      */
1084     modifier whenPaused() {
1085         _requirePaused();
1086         _;
1087     }
1088 
1089     /**
1090      * @dev Returns true if the contract is paused, and false otherwise.
1091      */
1092     function paused() public view virtual returns (bool) {
1093         return _paused;
1094     }
1095 
1096     /**
1097      * @dev Throws if the contract is paused.
1098      */
1099     function _requireNotPaused() internal view virtual {
1100         require(!paused(), "Pausable: paused");
1101     }
1102 
1103     /**
1104      * @dev Throws if the contract is not paused.
1105      */
1106     function _requirePaused() internal view virtual {
1107         require(paused(), "Pausable: not paused");
1108     }
1109 
1110     /**
1111      * @dev Triggers stopped state.
1112      *
1113      * Requirements:
1114      *
1115      * - The contract must not be paused.
1116      */
1117     function _pause() internal virtual whenNotPaused {
1118         _paused = true;
1119         emit Paused(_msgSender());
1120     }
1121 
1122     /**
1123      * @dev Returns to normal state.
1124      *
1125      * Requirements:
1126      *
1127      * - The contract must be paused.
1128      */
1129     function _unpause() internal virtual whenPaused {
1130         _paused = false;
1131         emit Unpaused(_msgSender());
1132     }
1133 
1134     /**
1135      * @dev This empty reserved space is put in place to allow future versions to add new
1136      * variables without shifting down storage in the inheritance chain.
1137      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1138      */
1139     uint256[49] private __gap;
1140 }
1141 
1142 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1143 
1144 
1145 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 
1151 /**
1152  * @dev Contract module which provides a basic access control mechanism, where
1153  * there is an account (an owner) that can be granted exclusive access to
1154  * specific functions.
1155  *
1156  * By default, the owner account will be the one that deploys the contract. This
1157  * can later be changed with {transferOwnership}.
1158  *
1159  * This module is used through inheritance. It will make available the modifier
1160  * `onlyOwner`, which can be applied to your functions to restrict their use to
1161  * the owner.
1162  */
1163 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1167 
1168     /**
1169      * @dev Initializes the contract setting the deployer as the initial owner.
1170      */
1171     function __Ownable_init() internal onlyInitializing {
1172         __Ownable_init_unchained();
1173     }
1174 
1175     function __Ownable_init_unchained() internal onlyInitializing {
1176         _transferOwnership(_msgSender());
1177     }
1178 
1179     /**
1180      * @dev Throws if called by any account other than the owner.
1181      */
1182     modifier onlyOwner() {
1183         _checkOwner();
1184         _;
1185     }
1186 
1187     /**
1188      * @dev Returns the address of the current owner.
1189      */
1190     function owner() public view virtual returns (address) {
1191         return _owner;
1192     }
1193 
1194     /**
1195      * @dev Throws if the sender is not the owner.
1196      */
1197     function _checkOwner() internal view virtual {
1198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1199     }
1200 
1201     /**
1202      * @dev Leaves the contract without owner. It will not be possible to call
1203      * `onlyOwner` functions anymore. Can only be called by the current owner.
1204      *
1205      * NOTE: Renouncing ownership will leave the contract without an owner,
1206      * thereby removing any functionality that is only available to the owner.
1207      */
1208     function renounceOwnership() public virtual onlyOwner {
1209         _transferOwnership(address(0));
1210     }
1211 
1212     /**
1213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1214      * Can only be called by the current owner.
1215      */
1216     function transferOwnership(address newOwner) public virtual onlyOwner {
1217         require(newOwner != address(0), "Ownable: new owner is the zero address");
1218         _transferOwnership(newOwner);
1219     }
1220 
1221     /**
1222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1223      * Internal function without access restriction.
1224      */
1225     function _transferOwnership(address newOwner) internal virtual {
1226         address oldOwner = _owner;
1227         _owner = newOwner;
1228         emit OwnershipTransferred(oldOwner, newOwner);
1229     }
1230 
1231     /**
1232      * @dev This empty reserved space is put in place to allow future versions to add new
1233      * variables without shifting down storage in the inheritance chain.
1234      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1235      */
1236     uint256[49] private __gap;
1237 }
1238 
1239 // File: contracts/MyToken.sol
1240 
1241 
1242 
1243 
1244 contract RoePresale is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable, PausableUpgradeable {
1245         address public recipientWalletAddress; // state variable for the recipient's address
1246 
1247     using SafeERC20Upgradeable for IERC20Upgradeable;
1248     mapping(address => bool) public wertWhitelistedWallets;
1249     mapping(address => bool) public whitelistRecipients;
1250     event WhitelistAdded(address indexed wallet);
1251     event WhitelistRemoved(address indexed wallet);
1252 
1253 
1254     constructor() initializer {
1255         __Ownable_init();
1256     }
1257   
1258   function whitelistRecipient(address recipient) external onlyOwner {
1259         recipientWalletAddress = recipient;
1260         whitelistRecipients[recipient] = true;
1261         emit WhitelistAdded(recipient);
1262     }
1263 
1264     function buyWithETHWert(
1265         uint256 _amount
1266     )
1267         external
1268         payable
1269         whenNotPaused
1270         nonReentrant
1271         returns (bool)
1272     {
1273        
1274         require(msg.value >= _amount, "Less payment");
1275         require(whitelistRecipients[recipientWalletAddress], "Recipient address not whitelisted");
1276         Address.sendValue(payable(recipientWalletAddress), _amount);    
1277         return true;
1278     }
1279     
1280 
1281     function whitelistUsersForWERT(
1282         address[] calldata _addressesToWhitelist
1283     ) external onlyOwner {
1284         for (uint256 i = 0; i < _addressesToWhitelist.length; i++) {
1285             wertWhitelistedWallets[_addressesToWhitelist[i]] = true;
1286         }
1287         
1288     }
1289 
1290     function removeFromWhitelistForWERT(
1291         address[] calldata _addressesToRemoveFromWhitelist
1292     ) external onlyOwner {
1293         for (uint256 i = 0; i < _addressesToRemoveFromWhitelist.length; i++) {
1294             wertWhitelistedWallets[_addressesToRemoveFromWhitelist[i]] = false;
1295         }
1296     }
1297 
1298     
1299     receive() external payable {
1300         // React to receiving ether
1301     }
1302 }