1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.7;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 /**
31  * @dev Implementation of the {IERC165} interface.
32  *
33  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
34  * for the additional interface id that will be supported. For example:
35  *
36  * ```solidity
37  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
38  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
39  * }
40  * ```
41  *
42  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
43  */
44 abstract contract ERC165 is IERC165 {
45     /**
46      * @dev See {IERC165-supportsInterface}.
47      */
48     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
49         return interfaceId == type(IERC165).interfaceId;
50     }
51 }
52 
53 /**
54  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
55  *
56  * These functions can be used to verify that a message was signed by the holder
57  * of the private keys of a given address.
58  */
59 library ECDSA {
60     enum RecoverError {
61         NoError,
62         InvalidSignature,
63         InvalidSignatureLength,
64         InvalidSignatureS,
65         InvalidSignatureV
66     }
67 
68     function _throwError(RecoverError error) private pure {
69         if (error == RecoverError.NoError) {
70             return; // no error: do nothing
71         } else if (error == RecoverError.InvalidSignature) {
72             revert("ECDSA: invalid signature");
73         } else if (error == RecoverError.InvalidSignatureLength) {
74             revert("ECDSA: invalid signature length");
75         } else if (error == RecoverError.InvalidSignatureS) {
76             revert("ECDSA: invalid signature 's' value");
77         } else if (error == RecoverError.InvalidSignatureV) {
78             revert("ECDSA: invalid signature 'v' value");
79         }
80     }
81 
82     /**
83      * @dev Returns the address that signed a hashed message (`hash`) with
84      * `signature` or error string. This address can then be used for verification purposes.
85      *
86      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
87      * this function rejects them by requiring the `s` value to be in the lower
88      * half order, and the `v` value to be either 27 or 28.
89      *
90      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
91      * verification to be secure: it is possible to craft signatures that
92      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
93      * this is by receiving a hash of the original message (which may otherwise
94      * be too long), and then calling {toEthSignedMessageHash} on it.
95      *
96      * Documentation for signature generation:
97      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
98      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
99      *
100      * _Available since v4.3._
101      */
102     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
103         // Check the signature length
104         // - case 65: r,s,v signature (standard)
105         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
106         if (signature.length == 65) {
107             bytes32 r;
108             bytes32 s;
109             uint8 v;
110             // ecrecover takes the signature parameters, and the only way to get them
111             // currently is to use assembly.
112             assembly {
113                 r := mload(add(signature, 0x20))
114                 s := mload(add(signature, 0x40))
115                 v := byte(0, mload(add(signature, 0x60)))
116             }
117             return tryRecover(hash, v, r, s);
118         } else if (signature.length == 64) {
119             bytes32 r;
120             bytes32 vs;
121             // ecrecover takes the signature parameters, and the only way to get them
122             // currently is to use assembly.
123             assembly {
124                 r := mload(add(signature, 0x20))
125                 vs := mload(add(signature, 0x40))
126             }
127             return tryRecover(hash, r, vs);
128         } else {
129             return (address(0), RecoverError.InvalidSignatureLength);
130         }
131     }
132 
133     /**
134      * @dev Returns the address that signed a hashed message (`hash`) with
135      * `signature`. This address can then be used for verification purposes.
136      *
137      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
138      * this function rejects them by requiring the `s` value to be in the lower
139      * half order, and the `v` value to be either 27 or 28.
140      *
141      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
142      * verification to be secure: it is possible to craft signatures that
143      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
144      * this is by receiving a hash of the original message (which may otherwise
145      * be too long), and then calling {toEthSignedMessageHash} on it.
146      */
147     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
148         (address recovered, RecoverError error) = tryRecover(hash, signature);
149         _throwError(error);
150         return recovered;
151     }
152 
153     /**
154      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
155      *
156      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
157      *
158      * _Available since v4.3._
159      */
160     function tryRecover(
161         bytes32 hash,
162         bytes32 r,
163         bytes32 vs
164     ) internal pure returns (address, RecoverError) {
165         bytes32 s;
166         uint8 v;
167         assembly {
168             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
169             v := add(shr(255, vs), 27)
170         }
171         return tryRecover(hash, v, r, s);
172     }
173 
174     /**
175      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
176      *
177      * _Available since v4.2._
178      */
179     function recover(
180         bytes32 hash,
181         bytes32 r,
182         bytes32 vs
183     ) internal pure returns (address) {
184         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
185         _throwError(error);
186         return recovered;
187     }
188 
189     /**
190      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
191      * `r` and `s` signature fields separately.
192      *
193      * _Available since v4.3._
194      */
195     function tryRecover(
196         bytes32 hash,
197         uint8 v,
198         bytes32 r,
199         bytes32 s
200     ) internal pure returns (address, RecoverError) {
201         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
202         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
203         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
204         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
205         //
206         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
207         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
208         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
209         // these malleable signatures as well.
210         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
211             return (address(0), RecoverError.InvalidSignatureS);
212         }
213         if (v != 27 && v != 28) {
214             return (address(0), RecoverError.InvalidSignatureV);
215         }
216 
217         // If the signature is valid (and not malleable), return the signer address
218         address signer = ecrecover(hash, v, r, s);
219         if (signer == address(0)) {
220             return (address(0), RecoverError.InvalidSignature);
221         }
222 
223         return (signer, RecoverError.NoError);
224     }
225 
226     /**
227      * @dev Overload of {ECDSA-recover} that receives the `v`,
228      * `r` and `s` signature fields separately.
229      */
230     function recover(
231         bytes32 hash,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) internal pure returns (address) {
236         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
237         _throwError(error);
238         return recovered;
239     }
240 
241     /**
242      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
243      * produces hash corresponding to the one signed with the
244      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
245      * JSON-RPC method as part of EIP-191.
246      *
247      * See {recover}.
248      */
249     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
250         // 32 is the length in bytes of hash,
251         // enforced by the type signature above
252         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
253     }
254 
255     /**
256      * @dev Returns an Ethereum Signed Typed Data, created from a
257      * `domainSeparator` and a `structHash`. This produces hash corresponding
258      * to the one signed with the
259      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
260      * JSON-RPC method as part of EIP-712.
261      *
262      * See {recover}.
263      */
264     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
265         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
266     }
267 }
268 
269 /**
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes calldata) {
285         return msg.data;
286     }
287 }
288 
289 /**
290  * @dev Collection of functions related to the address type
291  */
292 library Address {
293     /**
294      * @dev Returns true if `account` is a contract.
295      *
296      * [IMPORTANT]
297      * ====
298      * It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      *
301      * Among others, `isContract` will return false for the following
302      * types of addresses:
303      *
304      *  - an externally-owned account
305      *  - a contract in construction
306      *  - an address where a contract will be created
307      *  - an address where a contract lived, but was destroyed
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // This method relies on extcodesize, which returns 0 for contracts in
312         // construction, since the code is only stored at the end of the
313         // constructor execution.
314 
315         uint256 size;
316         assembly {
317             size := extcodesize(account)
318         }
319         return size > 0;
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         (bool success, ) = recipient.call{value: amount}("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain `call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value
396     ) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.call{value: value}(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
426         return functionStaticCall(target, data, "Address: low-level static call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.delegatecall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
475      * revert reason using the provided one.
476      *
477      * _Available since v4.3._
478      */
479     function verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) internal pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 /**
503  * @dev Interface of the ERC20 standard as defined in the EIP.
504  */
505 interface IERC20 {
506     /**
507      * @dev Returns the amount of tokens in existence.
508      */
509     function totalSupply() external view returns (uint256);
510 
511     /**
512      * @dev Returns the amount of tokens owned by `account`.
513      */
514     function balanceOf(address account) external view returns (uint256);
515 
516     /**
517      * @dev Moves `amount` tokens from the caller's account to `recipient`.
518      *
519      * Returns a boolean value indicating whether the operation succeeded.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transfer(address recipient, uint256 amount) external returns (bool);
524 
525     /**
526      * @dev Returns the remaining number of tokens that `spender` will be
527      * allowed to spend on behalf of `owner` through {transferFrom}. This is
528      * zero by default.
529      *
530      * This value changes when {approve} or {transferFrom} are called.
531      */
532     function allowance(address owner, address spender) external view returns (uint256);
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
536      *
537      * Returns a boolean value indicating whether the operation succeeded.
538      *
539      * IMPORTANT: Beware that changing an allowance with this method brings the risk
540      * that someone may use both the old and the new allowance by unfortunate
541      * transaction ordering. One possible solution to mitigate this race
542      * condition is to first reduce the spender's allowance to 0 and set the
543      * desired value afterwards:
544      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address spender, uint256 amount) external returns (bool);
549 
550     /**
551      * @dev Moves `amount` tokens from `sender` to `recipient` using the
552      * allowance mechanism. `amount` is then deducted from the caller's
553      * allowance.
554      *
555      * Returns a boolean value indicating whether the operation succeeded.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address sender,
561         address recipient,
562         uint256 amount
563     ) external returns (bool);
564 
565     /**
566      * @dev Emitted when `value` tokens are moved from one account (`from`) to
567      * another (`to`).
568      *
569      * Note that `value` may be zero.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 value);
572 
573     /**
574      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
575      * a call to {approve}. `value` is the new allowance.
576      */
577     event Approval(address indexed owner, address indexed spender, uint256 value);
578 }
579 
580 
581 /**
582  * @dev Interface for the optional metadata functions from the ERC20 standard.
583  *
584  * _Available since v4.1._
585  */
586 interface IERC20Metadata is IERC20 {
587     /**
588      * @dev Returns the name of the token.
589      */
590     function name() external view returns (string memory);
591 
592     /**
593      * @dev Returns the symbol of the token.
594      */
595     function symbol() external view returns (string memory);
596 
597     /**
598      * @dev Returns the decimals places of the token.
599      */
600     function decimals() external view returns (uint8);
601 }
602 
603 /**
604  * @dev Implementation of the {IERC20} interface.
605  *
606  * This implementation is agnostic to the way tokens are created. This means
607  * that a supply mechanism has to be added in a derived contract using {_mint}.
608  * For a generic mechanism see {ERC20PresetMinterPauser}.
609  *
610  * TIP: For a detailed writeup see our guide
611  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
612  * to implement supply mechanisms].
613  *
614  * We have followed general OpenZeppelin Contracts guidelines: functions revert
615  * instead returning `false` on failure. This behavior is nonetheless
616  * conventional and does not conflict with the expectations of ERC20
617  * applications.
618  *
619  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
620  * This allows applications to reconstruct the allowance for all accounts just
621  * by listening to said events. Other implementations of the EIP may not emit
622  * these events, as it isn't required by the specification.
623  *
624  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
625  * functions have been added to mitigate the well-known issues around setting
626  * allowances. See {IERC20-approve}.
627  */
628 contract ERC20 is Context, IERC20, IERC20Metadata {
629     mapping(address => uint256) private _balances;
630 
631     mapping(address => mapping(address => uint256)) private _allowances;
632 
633     uint256 private _totalSupply;
634 
635     string private _name;
636     string private _symbol;
637 
638     /**
639      * @dev Sets the values for {name} and {symbol}.
640      *
641      * The default value of {decimals} is 18. To select a different value for
642      * {decimals} you should overload it.
643      *
644      * All two of these values are immutable: they can only be set once during
645      * construction.
646      */
647     constructor(string memory name_, string memory symbol_) {
648         _name = name_;
649         _symbol = symbol_;
650     }
651 
652     /**
653      * @dev Returns the name of the token.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev Returns the symbol of the token, usually a shorter version of the
661      * name.
662      */
663     function symbol() public view virtual override returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev Returns the number of decimals used to get its user representation.
669      * For example, if `decimals` equals `2`, a balance of `505` tokens should
670      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
671      *
672      * Tokens usually opt for a value of 18, imitating the relationship between
673      * Ether and Wei. This is the value {ERC20} uses, unless this function is
674      * overridden;
675      *
676      * NOTE: This information is only used for _display_ purposes: it in
677      * no way affects any of the arithmetic of the contract, including
678      * {IERC20-balanceOf} and {IERC20-transfer}.
679      */
680     function decimals() public view virtual override returns (uint8) {
681         return 18;
682     }
683 
684     /**
685      * @dev See {IERC20-totalSupply}.
686      */
687     function totalSupply() public view virtual override returns (uint256) {
688         return _totalSupply;
689     }
690 
691     /**
692      * @dev See {IERC20-balanceOf}.
693      */
694     function balanceOf(address account) public view virtual override returns (uint256) {
695         return _balances[account];
696     }
697 
698     /**
699      * @dev See {IERC20-transfer}.
700      *
701      * Requirements:
702      *
703      * - `recipient` cannot be the zero address.
704      * - the caller must have a balance of at least `amount`.
705      */
706     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
707         _transfer(_msgSender(), recipient, amount);
708         return true;
709     }
710 
711     /**
712      * @dev See {IERC20-allowance}.
713      */
714     function allowance(address owner, address spender) public view virtual override returns (uint256) {
715         return _allowances[owner][spender];
716     }
717 
718     /**
719      * @dev See {IERC20-approve}.
720      *
721      * Requirements:
722      *
723      * - `spender` cannot be the zero address.
724      */
725     function approve(address spender, uint256 amount) public virtual override returns (bool) {
726         _approve(_msgSender(), spender, amount);
727         return true;
728     }
729 
730     /**
731      * @dev See {IERC20-transferFrom}.
732      *
733      * Emits an {Approval} event indicating the updated allowance. This is not
734      * required by the EIP. See the note at the beginning of {ERC20}.
735      *
736      * Requirements:
737      *
738      * - `sender` and `recipient` cannot be the zero address.
739      * - `sender` must have a balance of at least `amount`.
740      * - the caller must have allowance for ``sender``'s tokens of at least
741      * `amount`.
742      */
743     function transferFrom(
744         address sender,
745         address recipient,
746         uint256 amount
747     ) public virtual override returns (bool) {
748         _transfer(sender, recipient, amount);
749 
750         uint256 currentAllowance = _allowances[sender][_msgSender()];
751         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
752         unchecked {
753             _approve(sender, _msgSender(), currentAllowance - amount);
754         }
755 
756         return true;
757     }
758 
759     /**
760      * @dev Atomically increases the allowance granted to `spender` by the caller.
761      *
762      * This is an alternative to {approve} that can be used as a mitigation for
763      * problems described in {IERC20-approve}.
764      *
765      * Emits an {Approval} event indicating the updated allowance.
766      *
767      * Requirements:
768      *
769      * - `spender` cannot be the zero address.
770      */
771     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
772         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
773         return true;
774     }
775 
776     /**
777      * @dev Atomically decreases the allowance granted to `spender` by the caller.
778      *
779      * This is an alternative to {approve} that can be used as a mitigation for
780      * problems described in {IERC20-approve}.
781      *
782      * Emits an {Approval} event indicating the updated allowance.
783      *
784      * Requirements:
785      *
786      * - `spender` cannot be the zero address.
787      * - `spender` must have allowance for the caller of at least
788      * `subtractedValue`.
789      */
790     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
791         uint256 currentAllowance = _allowances[_msgSender()][spender];
792         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
793         unchecked {
794             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
795         }
796 
797         return true;
798     }
799 
800     /**
801      * @dev Moves `amount` of tokens from `sender` to `recipient`.
802      *
803      * This internal function is equivalent to {transfer}, and can be used to
804      * e.g. implement automatic token fees, slashing mechanisms, etc.
805      *
806      * Emits a {Transfer} event.
807      *
808      * Requirements:
809      *
810      * - `sender` cannot be the zero address.
811      * - `recipient` cannot be the zero address.
812      * - `sender` must have a balance of at least `amount`.
813      */
814     function _transfer(
815         address sender,
816         address recipient,
817         uint256 amount
818     ) internal virtual {
819         require(sender != address(0), "ERC20: transfer from the zero address");
820         require(recipient != address(0), "ERC20: transfer to the zero address");
821 
822         _beforeTokenTransfer(sender, recipient, amount);
823 
824         uint256 senderBalance = _balances[sender];
825         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
826         unchecked {
827             _balances[sender] = senderBalance - amount;
828         }
829         _balances[recipient] += amount;
830 
831         emit Transfer(sender, recipient, amount);
832 
833         _afterTokenTransfer(sender, recipient, amount);
834     }
835 
836     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
837      * the total supply.
838      *
839      * Emits a {Transfer} event with `from` set to the zero address.
840      *
841      * Requirements:
842      *
843      * - `account` cannot be the zero address.
844      */
845     function _mint(address account, uint256 amount) internal virtual {
846         require(account != address(0), "ERC20: mint to the zero address");
847 
848         _beforeTokenTransfer(address(0), account, amount);
849 
850         _totalSupply += amount;
851         _balances[account] += amount;
852         emit Transfer(address(0), account, amount);
853 
854         _afterTokenTransfer(address(0), account, amount);
855     }
856 
857     /**
858      * @dev Destroys `amount` tokens from `account`, reducing the
859      * total supply.
860      *
861      * Emits a {Transfer} event with `to` set to the zero address.
862      *
863      * Requirements:
864      *
865      * - `account` cannot be the zero address.
866      * - `account` must have at least `amount` tokens.
867      */
868     function _burn(address account, uint256 amount) internal virtual {
869         require(account != address(0), "ERC20: burn from the zero address");
870 
871         _beforeTokenTransfer(account, address(0), amount);
872 
873         uint256 accountBalance = _balances[account];
874         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
875         unchecked {
876             _balances[account] = accountBalance - amount;
877         }
878         _totalSupply -= amount;
879 
880         emit Transfer(account, address(0), amount);
881 
882         _afterTokenTransfer(account, address(0), amount);
883     }
884 
885     /**
886      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
887      *
888      * This internal function is equivalent to `approve`, and can be used to
889      * e.g. set automatic allowances for certain subsystems, etc.
890      *
891      * Emits an {Approval} event.
892      *
893      * Requirements:
894      *
895      * - `owner` cannot be the zero address.
896      * - `spender` cannot be the zero address.
897      */
898     function _approve(
899         address owner,
900         address spender,
901         uint256 amount
902     ) internal virtual {
903         require(owner != address(0), "ERC20: approve from the zero address");
904         require(spender != address(0), "ERC20: approve to the zero address");
905 
906         _allowances[owner][spender] = amount;
907         emit Approval(owner, spender, amount);
908     }
909 
910     /**
911      * @dev Hook that is called before any transfer of tokens. This includes
912      * minting and burning.
913      *
914      * Calling conditions:
915      *
916      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
917      * will be transferred to `to`.
918      * - when `from` is zero, `amount` tokens will be minted for `to`.
919      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
920      * - `from` and `to` are never both zero.
921      *
922      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
923      */
924     function _beforeTokenTransfer(
925         address from,
926         address to,
927         uint256 amount
928     ) internal virtual {}
929 
930     /**
931      * @dev Hook that is called after any transfer of tokens. This includes
932      * minting and burning.
933      *
934      * Calling conditions:
935      *
936      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
937      * has been transferred to `to`.
938      * - when `from` is zero, `amount` tokens have been minted for `to`.
939      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
940      * - `from` and `to` are never both zero.
941      *
942      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
943      */
944     function _afterTokenTransfer(
945         address from,
946         address to,
947         uint256 amount
948     ) internal virtual {}
949 }
950 
951 
952 /**
953  * @dev _Available since v3.1._
954  */
955 interface IERC1155Receiver is IERC165 {
956     /**
957         @dev Handles the receipt of a single ERC1155 token type. This function is
958         called at the end of a `safeTransferFrom` after the balance has been updated.
959         To accept the transfer, this must return
960         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
961         (i.e. 0xf23a6e61, or its own function selector).
962         @param operator The address which initiated the transfer (i.e. msg.sender)
963         @param from The address which previously owned the token
964         @param id The ID of the token being transferred
965         @param value The amount of tokens being transferred
966         @param data Additional data with no specified format
967         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
968     */
969     function onERC1155Received(
970         address operator,
971         address from,
972         uint256 id,
973         uint256 value,
974         bytes calldata data
975     ) external returns (bytes4);
976 
977     /**
978         @dev Handles the receipt of a multiple ERC1155 token types. This function
979         is called at the end of a `safeBatchTransferFrom` after the balances have
980         been updated. To accept the transfer(s), this must return
981         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
982         (i.e. 0xbc197c81, or its own function selector).
983         @param operator The address which initiated the batch transfer (i.e. msg.sender)
984         @param from The address which previously owned the token
985         @param ids An array containing ids of each token being transferred (order and length must match values array)
986         @param values An array containing amounts of each token being transferred (order and length must match ids array)
987         @param data Additional data with no specified format
988         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
989     */
990     function onERC1155BatchReceived(
991         address operator,
992         address from,
993         uint256[] calldata ids,
994         uint256[] calldata values,
995         bytes calldata data
996     ) external returns (bytes4);
997 }
998 
999 /**
1000  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1001  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1002  *
1003  * _Available since v3.1._
1004  */
1005 interface IERC1155 is IERC165 {
1006     /**
1007      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1008      */
1009     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1010 
1011     /**
1012      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1013      * transfers.
1014      */
1015     event TransferBatch(
1016         address indexed operator,
1017         address indexed from,
1018         address indexed to,
1019         uint256[] ids,
1020         uint256[] values
1021     );
1022 
1023     /**
1024      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1025      * `approved`.
1026      */
1027     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1028 
1029     /**
1030      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1031      *
1032      * If an {URI} event was emitted for `id`, the standard
1033      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1034      * returned by {IERC1155MetadataURI-uri}.
1035      */
1036     event URI(string value, uint256 indexed id);
1037 
1038     /**
1039      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1040      *
1041      * Requirements:
1042      *
1043      * - `account` cannot be the zero address.
1044      */
1045     function balanceOf(address account, uint256 id) external view returns (uint256);
1046 
1047     /**
1048      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1049      *
1050      * Requirements:
1051      *
1052      * - `accounts` and `ids` must have the same length.
1053      */
1054     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1055         external
1056         view
1057         returns (uint256[] memory);
1058 
1059     /**
1060      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1061      *
1062      * Emits an {ApprovalForAll} event.
1063      *
1064      * Requirements:
1065      *
1066      * - `operator` cannot be the caller.
1067      */
1068     function setApprovalForAll(address operator, bool approved) external;
1069 
1070     /**
1071      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1072      *
1073      * See {setApprovalForAll}.
1074      */
1075     function isApprovedForAll(address account, address operator) external view returns (bool);
1076 
1077     /**
1078      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1079      *
1080      * Emits a {TransferSingle} event.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1086      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1087      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1088      * acceptance magic value.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 id,
1094         uint256 amount,
1095         bytes calldata data
1096     ) external;
1097 
1098     /**
1099      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1100      *
1101      * Emits a {TransferBatch} event.
1102      *
1103      * Requirements:
1104      *
1105      * - `ids` and `amounts` must have the same length.
1106      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1107      * acceptance magic value.
1108      */
1109     function safeBatchTransferFrom(
1110         address from,
1111         address to,
1112         uint256[] calldata ids,
1113         uint256[] calldata amounts,
1114         bytes calldata data
1115     ) external;
1116 }
1117 
1118 
1119 /**
1120  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1121  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1122  *
1123  * _Available since v3.1._
1124  */
1125 interface IERC1155MetadataURI is IERC1155 {
1126     /**
1127      * @dev Returns the URI for token type `id`.
1128      *
1129      * If the `\{id\}` substring is present in the URI, it must be replaced by
1130      * clients with the actual token type ID.
1131      */
1132     function uri(uint256 id) external view returns (string memory);
1133 }
1134 
1135 
1136 /**
1137  * @dev Implementation of the basic standard multi-token.
1138  * See https://eips.ethereum.org/EIPS/eip-1155
1139  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1140  *
1141  * _Available since v3.1._
1142  */
1143 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1144     using Address for address;
1145 
1146     // Mapping from token ID to account balances
1147     mapping(uint256 => mapping(address => uint256)) private _balances;
1148 
1149     // Mapping from account to operator approvals
1150     mapping(address => mapping(address => bool)) private _operatorApprovals;
1151 
1152     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1153     string private _uri;
1154 
1155     /**
1156      * @dev See {_setURI}.
1157      */
1158     constructor(string memory uri_) {
1159         _setURI(uri_);
1160     }
1161 
1162     /**
1163      * @dev See {IERC165-supportsInterface}.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1166         return
1167             interfaceId == type(IERC1155).interfaceId ||
1168             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1169             super.supportsInterface(interfaceId);
1170     }
1171 
1172     /**
1173      * @dev See {IERC1155MetadataURI-uri}.
1174      *
1175      * This implementation returns the same URI for *all* token types. It relies
1176      * on the token type ID substitution mechanism
1177      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1178      *
1179      * Clients calling this function must replace the `\{id\}` substring with the
1180      * actual token type ID.
1181      */
1182     function uri(uint256) public view virtual override returns (string memory) {
1183         return _uri;
1184     }
1185 
1186     /**
1187      * @dev See {IERC1155-balanceOf}.
1188      *
1189      * Requirements:
1190      *
1191      * - `account` cannot be the zero address.
1192      */
1193     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1194         require(account != address(0), "ERC1155: balance query for the zero address");
1195         return _balances[id][account];
1196     }
1197 
1198     /**
1199      * @dev See {IERC1155-balanceOfBatch}.
1200      *
1201      * Requirements:
1202      *
1203      * - `accounts` and `ids` must have the same length.
1204      */
1205     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (uint256[] memory)
1211     {
1212         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1213 
1214         uint256[] memory batchBalances = new uint256[](accounts.length);
1215 
1216         for (uint256 i = 0; i < accounts.length; ++i) {
1217             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1218         }
1219 
1220         return batchBalances;
1221     }
1222 
1223     /**
1224      * @dev See {IERC1155-setApprovalForAll}.
1225      */
1226     function setApprovalForAll(address operator, bool approved) public virtual override {
1227         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1228 
1229         _operatorApprovals[_msgSender()][operator] = approved;
1230         emit ApprovalForAll(_msgSender(), operator, approved);
1231     }
1232 
1233     /**
1234      * @dev See {IERC1155-isApprovedForAll}.
1235      */
1236     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1237         return _operatorApprovals[account][operator];
1238     }
1239 
1240     /**
1241      * @dev See {IERC1155-safeTransferFrom}.
1242      */
1243     function safeTransferFrom(
1244         address from,
1245         address to,
1246         uint256 id,
1247         uint256 amount,
1248         bytes memory data
1249     ) public virtual override {
1250         require(
1251             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1252             "ERC1155: caller is not owner nor approved"
1253         );
1254         _safeTransferFrom(from, to, id, amount, data);
1255     }
1256 
1257     /**
1258      * @dev See {IERC1155-safeBatchTransferFrom}.
1259      */
1260     function safeBatchTransferFrom(
1261         address from,
1262         address to,
1263         uint256[] memory ids,
1264         uint256[] memory amounts,
1265         bytes memory data
1266     ) public virtual override {
1267         require(
1268             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1269             "ERC1155: transfer caller is not owner nor approved"
1270         );
1271         _safeBatchTransferFrom(from, to, ids, amounts, data);
1272     }
1273 
1274     /**
1275      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1276      *
1277      * Emits a {TransferSingle} event.
1278      *
1279      * Requirements:
1280      *
1281      * - `to` cannot be the zero address.
1282      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1283      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1284      * acceptance magic value.
1285      */
1286     function _safeTransferFrom(
1287         address from,
1288         address to,
1289         uint256 id,
1290         uint256 amount,
1291         bytes memory data
1292     ) internal virtual {
1293         require(to != address(0), "ERC1155: transfer to the zero address");
1294 
1295         address operator = _msgSender();
1296 
1297         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1298 
1299         uint256 fromBalance = _balances[id][from];
1300         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1301         unchecked {
1302             _balances[id][from] = fromBalance - amount;
1303         }
1304         _balances[id][to] += amount;
1305 
1306         emit TransferSingle(operator, from, to, id, amount);
1307 
1308         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1309     }
1310 
1311     /**
1312      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1313      *
1314      * Emits a {TransferBatch} event.
1315      *
1316      * Requirements:
1317      *
1318      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1319      * acceptance magic value.
1320      */
1321     function _safeBatchTransferFrom(
1322         address from,
1323         address to,
1324         uint256[] memory ids,
1325         uint256[] memory amounts,
1326         bytes memory data
1327     ) internal virtual {
1328         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1329         require(to != address(0), "ERC1155: transfer to the zero address");
1330 
1331         address operator = _msgSender();
1332 
1333         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1334 
1335         for (uint256 i = 0; i < ids.length; ++i) {
1336             uint256 id = ids[i];
1337             uint256 amount = amounts[i];
1338 
1339             uint256 fromBalance = _balances[id][from];
1340             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1341             unchecked {
1342                 _balances[id][from] = fromBalance - amount;
1343             }
1344             _balances[id][to] += amount;
1345         }
1346 
1347         emit TransferBatch(operator, from, to, ids, amounts);
1348 
1349         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1350     }
1351 
1352     /**
1353      * @dev Sets a new URI for all token types, by relying on the token type ID
1354      * substitution mechanism
1355      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1356      *
1357      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1358      * URI or any of the amounts in the JSON file at said URI will be replaced by
1359      * clients with the token type ID.
1360      *
1361      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1362      * interpreted by clients as
1363      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1364      * for token type ID 0x4cce0.
1365      *
1366      * See {uri}.
1367      *
1368      * Because these URIs cannot be meaningfully represented by the {URI} event,
1369      * this function emits no events.
1370      */
1371     function _setURI(string memory newuri) internal virtual {
1372         _uri = newuri;
1373     }
1374 
1375     /**
1376      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1377      *
1378      * Emits a {TransferSingle} event.
1379      *
1380      * Requirements:
1381      *
1382      * - `account` cannot be the zero address.
1383      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1384      * acceptance magic value.
1385      */
1386     function _mint(
1387         address account,
1388         uint256 id,
1389         uint256 amount,
1390         bytes memory data
1391     ) internal virtual {
1392         require(account != address(0), "ERC1155: mint to the zero address");
1393 
1394         address operator = _msgSender();
1395 
1396         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1397 
1398         _balances[id][account] += amount;
1399         emit TransferSingle(operator, address(0), account, id, amount);
1400 
1401         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1402     }
1403 
1404     /**
1405      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1406      *
1407      * Requirements:
1408      *
1409      * - `ids` and `amounts` must have the same length.
1410      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1411      * acceptance magic value.
1412      */
1413     function _mintBatch(
1414         address to,
1415         uint256[] memory ids,
1416         uint256[] memory amounts,
1417         bytes memory data
1418     ) internal virtual {
1419         require(to != address(0), "ERC1155: mint to the zero address");
1420         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1421 
1422         address operator = _msgSender();
1423 
1424         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1425 
1426         for (uint256 i = 0; i < ids.length; i++) {
1427             _balances[ids[i]][to] += amounts[i];
1428         }
1429 
1430         emit TransferBatch(operator, address(0), to, ids, amounts);
1431 
1432         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1433     }
1434 
1435     /**
1436      * @dev Destroys `amount` tokens of token type `id` from `account`
1437      *
1438      * Requirements:
1439      *
1440      * - `account` cannot be the zero address.
1441      * - `account` must have at least `amount` tokens of token type `id`.
1442      */
1443     function _burn(
1444         address account,
1445         uint256 id,
1446         uint256 amount
1447     ) internal virtual {
1448         require(account != address(0), "ERC1155: burn from the zero address");
1449 
1450         address operator = _msgSender();
1451 
1452         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1453 
1454         uint256 accountBalance = _balances[id][account];
1455         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1456         unchecked {
1457             _balances[id][account] = accountBalance - amount;
1458         }
1459 
1460         emit TransferSingle(operator, account, address(0), id, amount);
1461     }
1462 
1463     /**
1464      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1465      *
1466      * Requirements:
1467      *
1468      * - `ids` and `amounts` must have the same length.
1469      */
1470     function _burnBatch(
1471         address account,
1472         uint256[] memory ids,
1473         uint256[] memory amounts
1474     ) internal virtual {
1475         require(account != address(0), "ERC1155: burn from the zero address");
1476         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1477 
1478         address operator = _msgSender();
1479 
1480         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1481 
1482         for (uint256 i = 0; i < ids.length; i++) {
1483             uint256 id = ids[i];
1484             uint256 amount = amounts[i];
1485 
1486             uint256 accountBalance = _balances[id][account];
1487             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1488             unchecked {
1489                 _balances[id][account] = accountBalance - amount;
1490             }
1491         }
1492 
1493         emit TransferBatch(operator, account, address(0), ids, amounts);
1494     }
1495 
1496     /**
1497      * @dev Hook that is called before any token transfer. This includes minting
1498      * and burning, as well as batched variants.
1499      *
1500      * The same hook is called on both single and batched variants. For single
1501      * transfers, the length of the `id` and `amount` arrays will be 1.
1502      *
1503      * Calling conditions (for each `id` and `amount` pair):
1504      *
1505      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1506      * of token type `id` will be  transferred to `to`.
1507      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1508      * for `to`.
1509      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1510      * will be burned.
1511      * - `from` and `to` are never both zero.
1512      * - `ids` and `amounts` have the same, non-zero length.
1513      *
1514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1515      */
1516     function _beforeTokenTransfer(
1517         address operator,
1518         address from,
1519         address to,
1520         uint256[] memory ids,
1521         uint256[] memory amounts,
1522         bytes memory data
1523     ) internal virtual {}
1524 
1525     function _doSafeTransferAcceptanceCheck(
1526         address operator,
1527         address from,
1528         address to,
1529         uint256 id,
1530         uint256 amount,
1531         bytes memory data
1532     ) private {
1533         if (to.isContract()) {
1534             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1535                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1536                     revert("ERC1155: ERC1155Receiver rejected tokens");
1537                 }
1538             } catch Error(string memory reason) {
1539                 revert(reason);
1540             } catch {
1541                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1542             }
1543         }
1544     }
1545 
1546     function _doSafeBatchTransferAcceptanceCheck(
1547         address operator,
1548         address from,
1549         address to,
1550         uint256[] memory ids,
1551         uint256[] memory amounts,
1552         bytes memory data
1553     ) private {
1554         if (to.isContract()) {
1555             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1556                 bytes4 response
1557             ) {
1558                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1559                     revert("ERC1155: ERC1155Receiver rejected tokens");
1560                 }
1561             } catch Error(string memory reason) {
1562                 revert(reason);
1563             } catch {
1564                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1565             }
1566         }
1567     }
1568 
1569     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1570         uint256[] memory array = new uint256[](1);
1571         array[0] = element;
1572 
1573         return array;
1574     }
1575 }
1576 
1577 
1578 contract JRNYRewardsNFT is ERC1155 {
1579     address public admin;
1580     string public name;
1581     string public symbol;
1582     string public metadata;
1583     
1584     mapping(uint256 => bool) minted;
1585 	mapping(uint256 => bool) nonTransferrable;
1586     
1587     using ECDSA for bytes32;
1588     address signer;
1589 		address maintainer;
1590 
1591     modifier onlyAdmin {
1592         require(admin == msg.sender, "Not allowed");
1593         _;
1594     }
1595 
1596     constructor(
1597         string memory _name,
1598         string memory _symbol,
1599         string memory _metadata
1600     ) ERC1155("") {
1601         name = _name;
1602         symbol = _symbol;
1603         metadata = _metadata;
1604         admin = msg.sender;
1605     }
1606 
1607     function authorizedMint(uint _nftId, bool _unique, uint _nonce, bytes memory _signature) public {
1608         bytes32 hash = hashTransaction(msg.sender, _nftId, _unique, _nonce);
1609         require(!minted[uint(hash)], "Token already minted");
1610         require(matchSignerAdmin(signTransaction(hash), _signature), "Signature mismatch");
1611         minted[uint(hash)] = true;
1612         _mint(msg.sender, _nftId, 1, "");
1613     }
1614 
1615     function adminBatchMint(
1616         address[] memory _to,
1617         uint256[] memory _ids,
1618         uint256[] memory _values,
1619         bytes memory _data
1620     ) public onlyAdmin {
1621         for (uint256 i = 0; i < _to.length; i++) {
1622             _mint(_to[i], _ids[i], _values[i], _data);
1623         }
1624     }
1625 
1626     function updateMetadata(string memory _metadata) external {
1627 		require (msg.sender == admin || msg.sender == maintainer, "Not allowed");
1628         metadata = _metadata;
1629     }
1630 
1631     function uri(uint256 _id) public view override returns (string memory) {
1632         return string(abi.encodePacked(metadata, uint2str(_id), ".json"));
1633     }
1634 
1635     function supportsInterface(bytes4 interfaceId)
1636         public
1637         view
1638         virtual
1639         override(ERC1155)
1640         returns (bool)
1641     {
1642         return super.supportsInterface(interfaceId);
1643     }
1644     
1645     function hasBeenMinted(address _sender, uint _nftId, bool _unique, uint _nonce) public view returns (bool) {
1646         return minted[uint(keccak256(abi.encode(_sender, _nftId, _unique, _nonce)))];
1647     }
1648     
1649     function hashTransaction(address _sender, uint _nftId, bool _unique, uint _nonce) public pure returns (bytes32) {
1650         bytes32 _hash = keccak256(abi.encode(_sender, _nftId, _unique, _nonce));
1651     	return _hash;
1652 	}
1653 	
1654 	
1655 	function signTransaction(bytes32 _hash) public pure returns (bytes32) {
1656 	    return _hash.toEthSignedMessageHash();
1657 	}
1658 
1659 	function matchSignerAdmin(bytes32 _payload, bytes memory _signature) public view returns (bool) {
1660 		return signer == _payload.recover(_signature);
1661 	}
1662 
1663     function changeMaintainer(address newAddress) external onlyAdmin {
1664         maintainer = newAddress;
1665     }
1666 	
1667 	function changeAdmin(address newAdmin) external onlyAdmin {
1668 	    admin = newAdmin;
1669 	}
1670 	
1671 	function changeApprovedSigner(address newSigner) external onlyAdmin {
1672 	    signer = newSigner;
1673 	}
1674 
1675 	function setTransferrableState(uint256 id, bool transferrable) external onlyAdmin {
1676 		nonTransferrable[id] = !transferrable;
1677 	}
1678 
1679 	function isNonTransferrable(uint256 id) external view returns(bool) {
1680 		return nonTransferrable[id];
1681 	}
1682 
1683 	function safeTransferFrom(
1684         address from,
1685         address to,
1686         uint256 id,
1687         uint256 amount,
1688         bytes memory data
1689     ) public override {
1690 		require(!nonTransferrable[id], "Asset non transferrable");
1691 		super.safeTransferFrom(from, to, id, amount, data);
1692 	}
1693 
1694 	function safeBatchTransferFrom(
1695         address from,
1696         address to,
1697         uint256[] memory ids,
1698         uint256[] memory amounts,
1699         bytes memory data
1700     ) public override {
1701 		for (uint i; i < ids.length ; ) {
1702 			require(!nonTransferrable[ids[i]], "Asset non transferrable");
1703 			unchecked { ++i; }
1704 		}
1705 		super.safeBatchTransferFrom(from, to, ids, amounts, data);
1706 	}
1707 
1708     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1709         if (_i == 0) {
1710             return "0";
1711         }
1712         uint j = _i;
1713         uint len;
1714         while (j != 0) {
1715             len++;
1716             j /= 10;
1717         }
1718         bytes memory bstr = new bytes(len);
1719         uint k = len;
1720         while (_i != 0) {
1721             k = k-1;
1722             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1723             bytes1 b1 = bytes1(temp);
1724             bstr[k] = b1;
1725             _i /= 10;
1726         }
1727         return string(bstr);
1728     }
1729 }